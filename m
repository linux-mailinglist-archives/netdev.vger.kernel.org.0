Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8961B41A8F6
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 08:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239013AbhI1Gag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 02:30:36 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:27436 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238931AbhI1Gaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 02:30:35 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UpuTxzi_1632810523;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UpuTxzi_1632810523)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Sep 2021 14:28:43 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] net/tls: support SM4 CCM algorithm
Date:   Tue, 28 Sep 2021 14:28:43 +0800
Message-Id: <20210928062843.75283-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IV of CCM mode has special requirements, this patch supports CCM
mode of SM4 algorithm.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 include/net/tls.h |  3 ++-
 net/tls/tls_sw.c  | 20 ++++++++++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index be4b3e1cac46..b6d40642afdd 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -66,7 +66,7 @@
 #define MAX_IV_SIZE			16
 #define TLS_MAX_REC_SEQ_SIZE		8
 
-/* For AES-CCM, the full 16-bytes of IV is made of '4' fields of given sizes.
+/* For CCM mode, the full 16-bytes of IV is made of '4' fields of given sizes.
  *
  * IV[16] = b0[1] || implicit nonce[4] || explicit nonce[8] || length[3]
  *
@@ -74,6 +74,7 @@
  * Hence b0 contains (3 - 1) = 2.
  */
 #define TLS_AES_CCM_IV_B0_BYTE		2
+#define TLS_SM4_CCM_IV_B0_BYTE		2
 
 #define __TLS_INC_STATS(net, field)				\
 	__SNMP_INC_STATS((net)->mib.tls_statistics, field)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 120a73abb95c..81bb78c812c4 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -498,9 +498,15 @@ static int tls_do_encryption(struct sock *sk,
 	int rc, iv_offset = 0;
 
 	/* For CCM based ciphers, first byte of IV is a constant */
-	if (prot->cipher_type == TLS_CIPHER_AES_CCM_128) {
+	switch (prot->cipher_type) {
+	case TLS_CIPHER_AES_CCM_128:
 		rec->iv_data[0] = TLS_AES_CCM_IV_B0_BYTE;
 		iv_offset = 1;
+		break;
+	case TLS_CIPHER_SM4_CCM:
+		rec->iv_data[0] = TLS_SM4_CCM_IV_B0_BYTE;
+		iv_offset = 1;
+		break;
 	}
 
 	memcpy(&rec->iv_data[iv_offset], tls_ctx->tx.iv,
@@ -1482,10 +1488,16 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	aad = (u8 *)(sgout + n_sgout);
 	iv = aad + prot->aad_size;
 
-	/* For CCM based ciphers, first byte of nonce+iv is always '2' */
-	if (prot->cipher_type == TLS_CIPHER_AES_CCM_128) {
-		iv[0] = 2;
+	/* For CCM based ciphers, first byte of nonce+iv is a constant */
+	switch (prot->cipher_type) {
+	case TLS_CIPHER_AES_CCM_128:
+		iv[0] = TLS_AES_CCM_IV_B0_BYTE;
 		iv_offset = 1;
+		break;
+	case TLS_CIPHER_SM4_CCM:
+		iv[0] = TLS_SM4_CCM_IV_B0_BYTE;
+		iv_offset = 1;
+		break;
 	}
 
 	/* Prepare IV */
-- 
2.19.1.3.ge56e4f7

