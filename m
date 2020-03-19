Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD4618ABE4
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 05:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgCSElr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 00:41:47 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:63965 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgCSElr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 00:41:47 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02J4fNiM012950;
        Wed, 18 Mar 2020 21:41:24 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Cc:     borisp@mellanox.com, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next v2] Crypto/chtls: add/delete TLS header in driver
Date:   Thu, 19 Mar 2020 10:11:21 +0530
Message-Id: <20200319044121.6688-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel TLS forms TLS header in kernel during encryption and removes
while decryption before giving packet back to user application. The
similar logic is introduced in chtls code as well.

v1->v2:
- tls_proccess_cmsg() uses tls_handle_open_record() which is not required
  in TOE-TLS. Don't mix TOE with other TLS types.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_io.c | 73 ++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 5cf9b021220b..e1651adb9d06 100644
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
@@ -981,6 +973,37 @@ static int csk_wait_memory(struct chtls_dev *cdev,
 	goto do_rm_wq;
 }
 
+static int chtls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
+			       unsigned char *record_type)
+{
+	struct cmsghdr *cmsg;
+	int rc = -EINVAL;
+
+	for_each_cmsghdr(cmsg, msg) {
+		if (!CMSG_OK(msg, cmsg))
+			return -EINVAL;
+		if (cmsg->cmsg_level != SOL_TLS)
+			continue;
+
+		switch (cmsg->cmsg_type) {
+		case TLS_SET_RECORD_TYPE:
+			if (cmsg->cmsg_len < CMSG_LEN(sizeof(*record_type)))
+				return -EINVAL;
+
+			if (msg->msg_flags & MSG_MORE)
+				return -EINVAL;
+
+			*record_type = *(unsigned char *)CMSG_DATA(cmsg);
+			rc = 0;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	return rc;
+}
+
 int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
 	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
@@ -1022,15 +1045,21 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			goto wait_for_sndbuf;
 
 		if (is_tls_tx(csk) && !csk->tlshws.txleft) {
-			struct tls_hdr hdr;
+			unsigned char record_type = TLS_RECORD_TYPE_DATA;
 
-			recordsz = tls_header_read(&hdr, &msg->msg_iter);
-			size -= TLS_HEADER_LENGTH;
-			copied += TLS_HEADER_LENGTH;
+			if (unlikely(msg->msg_controllen)) {
+				err = chtls_proccess_cmsg(sk, msg,
+							  &record_type);
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
@@ -1521,6 +1550,22 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
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
-- 
2.18.1

