Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0701946112D
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 10:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244459AbhK2Jhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 04:37:37 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:58636 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244552AbhK2Jfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 04:35:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Uyf2n9o_1638178333;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Uyf2n9o_1638178333)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 29 Nov 2021 17:32:14 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vakul Garg <vakul.garg@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] net/tls: Fix authentication failure in CCM mode
Date:   Mon, 29 Nov 2021 17:32:12 +0800
Message-Id: <20211129093212.4053-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the TLS cipher suite uses CCM mode, including AES CCM and
SM4 CCM, the first byte of the B0 block is flags, and the real
IV starts from the second byte. The XOR operation of the IV and
rec_seq should be skip this byte, that is, add the iv_offset.

Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc: Vakul Garg <vakul.garg@nxp.com>
Cc: stable@vger.kernel.org # v5.2+
---
 net/tls/tls_sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d3e7ff90889e..dfe623a4e72f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -521,7 +521,7 @@ static int tls_do_encryption(struct sock *sk,
 	memcpy(&rec->iv_data[iv_offset], tls_ctx->tx.iv,
 	       prot->iv_size + prot->salt_size);
 
-	xor_iv_with_seq(prot, rec->iv_data, tls_ctx->tx.rec_seq);
+	xor_iv_with_seq(prot, rec->iv_data + iv_offset, tls_ctx->tx.rec_seq);
 
 	sge->offset += prot->prepend_size;
 	sge->length -= prot->prepend_size;
@@ -1499,7 +1499,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	else
 		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
 
-	xor_iv_with_seq(prot, iv, tls_ctx->rx.rec_seq);
+	xor_iv_with_seq(prot, iv + iv_offset, tls_ctx->rx.rec_seq);
 
 	/* Prepare AAD */
 	tls_make_aad(aad, rxm->full_len - prot->overhead_size +
-- 
2.32.0

