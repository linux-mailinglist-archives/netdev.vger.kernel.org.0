Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220852C9D41
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390293AbgLAJU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:20:59 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:31028 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389324AbgLAJIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 04:08:48 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0B197rOW012517;
        Tue, 1 Dec 2020 01:07:54 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net] net/tls: tls offload is broken
Date:   Tue,  1 Dec 2020 14:37:52 +0530
Message-Id: <20201201090752.27355-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent changes made to remove AES constants started using protocol
aware salt_size. ctx->prot_info's salt_size is filled in tls sw case,
but not in tls offload mode, and was working so far because of the
hard coded value was used.

Fixes: 6942a284fb3e ("net/tls: make inline helpers protocol-aware")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 net/tls/tls_device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6cc9fe778356..f7fb7d2c1de1 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -998,7 +998,7 @@ static void tls_device_attach(struct tls_context *ctx, struct sock *sk,
 
 int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 {
-	u16 nonce_size, tag_size, iv_size, rec_seq_size;
+	u16 nonce_size, tag_size, iv_size, rec_seq_size, salt_size;
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct tls_record_info *start_marker_record;
@@ -1039,6 +1039,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 		iv_size = TLS_CIPHER_AES_GCM_128_IV_SIZE;
 		iv = ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->iv;
 		rec_seq_size = TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE;
+		salt_size = TLS_CIPHER_AES_GCM_128_SALT_SIZE;
 		rec_seq =
 		 ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->rec_seq;
 		break;
@@ -1059,6 +1060,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	prot->tag_size = tag_size;
 	prot->overhead_size = prot->prepend_size + prot->tag_size;
 	prot->iv_size = iv_size;
+	prot->salt_size = salt_size;
 	ctx->tx.iv = kmalloc(iv_size + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 			     GFP_KERNEL);
 	if (!ctx->tx.iv) {
-- 
2.18.1

