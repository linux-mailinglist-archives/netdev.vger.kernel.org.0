Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7B6189D11
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgCRNdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:33:36 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:46840 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgCRNdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:33:35 -0400
Received: from redhouse-blr-asicdesigners-com.blr.asicdesigners.com (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02IDXJoa011201;
        Wed, 18 Mar 2020 06:33:20 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Cc:     borisp@mellanox.com, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next] Crypto/chtls: add/delete TLS header in driver
Date:   Wed, 18 Mar 2020 19:03:04 +0530
Message-Id: <20200318133304.16196-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel TLS forms TLS header in kernel during encryption and removes
while decryption before giving packet back to user application. The
similar logic is introduced in chtls code as well.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_io.c | 41 ++++++++++++++++---------
 net/tls/tls_main.c                      |  1 +
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 5cf9b021220b..7fdb17cde506 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -902,14 +902,6 @@ static int chtls_skb_copy_to_page_nocache(struct sock *sk,
 	return 0;
 }
 
-/* Read TLS header to find content type and data length */
-static int tls_header_read(struct tls_hdr *thdr, struct iov_iter *from)
-{
-	if (copy_from_iter(thdr, sizeof(*thdr), from) != sizeof(*thdr))
-		return -EFAULT;
-	return (__force int)cpu_to_be16(thdr->length);
-}
-
 static int csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
 {
 	return (cdev->max_host_sndbuf - sk->sk_wmem_queued);
@@ -1022,15 +1014,20 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			goto wait_for_sndbuf;
 
 		if (is_tls_tx(csk) && !csk->tlshws.txleft) {
-			struct tls_hdr hdr;
+			unsigned char record_type = TLS_RECORD_TYPE_DATA;
 
-			recordsz = tls_header_read(&hdr, &msg->msg_iter);
-			size -= TLS_HEADER_LENGTH;
-			copied += TLS_HEADER_LENGTH;
+			if (unlikely(msg->msg_controllen)) {
+				err = tls_proccess_cmsg(sk, msg, &record_type);
+				if (err)
+					goto out_err;
+			}
+
+			recordsz = size;
 			csk->tlshws.txleft = recordsz;
-			csk->tlshws.type = hdr.type;
+			csk->tlshws.type = record_type;
+
 			if (skb)
-				ULP_SKB_CB(skb)->ulp.tls.type = hdr.type;
+				ULP_SKB_CB(skb)->ulp.tls.type = record_type;
 		}
 
 		if (!skb || (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND) ||
@@ -1521,6 +1518,22 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 				}
 			}
 		}
+		/* Set record type if not already done. For a non-data record,
+		 * do not proceed if record type could not be copied.
+		 */
+		if (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_TLS_HDR) {
+			struct tls_hdr *thdr = (struct tls_hdr *)skb->data;
+			int cerr = 0;
+
+			cerr = put_cmsg(msg, SOL_TLS, TLS_GET_RECORD_TYPE,
+					sizeof(thdr->type), &thdr->type);
+
+			if (cerr && thdr->type != TLS_RECORD_TYPE_DATA)
+				return -EIO;
+			/*  don't send tls header, skip copy */
+			goto skip_copy;
+		}
+
 		if (skb_copy_datagram_msg(skb, offset, msg, avail)) {
 			if (!copied) {
 				copied = -EFAULT;
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 82225bcc1117..c338b203ce8f 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -195,6 +195,7 @@ int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 
 	return rc;
 }
+EXPORT_SYMBOL(tls_proccess_cmsg);
 
 int tls_push_partial_record(struct sock *sk, struct tls_context *ctx,
 			    int flags)
-- 
2.18.1

