Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF2603C277
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391167AbfFKElK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:41:10 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33386 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391159AbfFKElJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:41:09 -0400
Received: by mail-qt1-f196.google.com with SMTP id x2so12124409qtr.0
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5mJrVl5LEivf48aN+6BHzooJFvRIjVE4iPwXmOBy/Ek=;
        b=Nj3cmHfvRhTSOgc6iFQX37ygFI6A4uhoK9KH3ezJiC2BISN0AuFUROQX472biBeYyH
         /nc5bF1zlwpyDeeTvAA+NlCCU5qs6uSQX0PLgQxfwtG7quw8alooAns+28ZVCCbpNNyh
         i02pkGCScqOjp3ycbn497bjW6PUrVvMtm7+xYDzQhrfz1qbD2dSvjgpUisAaR1CbSUrl
         rBidK767/uQ3NpZHcioUiTbnIT49Lq9fzL5EesncBmW3toOtQij+zHazWsWoC9aeMCrV
         rO+uyEwW9jrwPwjiMp49b62nw24GlbNhhFbD510U2Lgo6paCtaGT5L5Egpvzj1ug8a4q
         MCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5mJrVl5LEivf48aN+6BHzooJFvRIjVE4iPwXmOBy/Ek=;
        b=L3Hcj1NrxxPRSB16nCKoSpxz1pr081/7Zldf1r6k5X2vuG81Z1j0zpyw81T/3UnRfn
         1ZVhQoKobTlUFppIUG1x60aMGqS8dnCJBKZp7uU+IX92mOeNFUzAJmDkKL+qKDIVWfLk
         BnlxYIt5/DQOLJd2WlwdFpXiuOZQ/rlpF+UCZSo8Lh7Dvrwy4yP2sWJj7yyk+l8x1vTg
         xWPAGkssreu36cGPfYGipN5vlPyeaz3xsTVLG7e5g7Q6NPn8lmEiajre+1Rli1Ou3rSO
         kz8RixT5UbmXjQQTCwDLwMjtyn8he/zWxFlIejr9X1FyvDGtI/vn774EISdpb/sueqr0
         T7MA==
X-Gm-Message-State: APjAAAVtyq1OZ9qThS/guaygJ+WaWfRt2ABgvkAlnxedLSybRpdqRk+9
        KmjdAC5kBQp/sp+Fg8A/1f3sEQ==
X-Google-Smtp-Source: APXvYqxV1E8J1e4LVxVUQhmsX0ZoyvnJKrKT0IaR6qdcRAwyxca5/fXmdCUIT0WV2FSZmkMM5Uzzmw==
X-Received: by 2002:ac8:6898:: with SMTP id m24mr61494462qtq.362.1560228068150;
        Mon, 10 Jun 2019 21:41:08 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.41.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:41:07 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 12/12] nfp: tls: make use of kernel-driven TX resync
Date:   Mon, 10 Jun 2019 21:40:10 -0700
Message-Id: <20190611044010.29161-13-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When TCP stream gets out of sync (driver stops receiving skbs
with expected TCP sequence numbers) request a TX resync from
the kernel.

We try to distinguish retransmissions from missed transmissions
by comparing the sequence number to expected - if it's further
than the expected one - we probably missed packets.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 .../ethernet/netronome/nfp/crypto/crypto.h    |  1 -
 .../net/ethernet/netronome/nfp/crypto/tls.c   | 21 ++++++++++++-------
 .../ethernet/netronome/nfp/nfp_net_common.c   |  8 ++++---
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
index 591924ad920c..60372ddf69f0 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
+++ b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
@@ -13,7 +13,6 @@ struct nfp_net_tls_offload_ctx {
 	 */
 
 	u32 next_seq;
-	bool out_of_sync;
 };
 
 #ifdef CONFIG_TLS_DEVICE
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 93f87b7633b1..3ee829d69c04 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -390,25 +390,30 @@ nfp_net_tls_resync(struct net_device *netdev, struct sock *sk, u32 seq,
 	struct nfp_net_tls_offload_ctx *ntls;
 	struct nfp_crypto_req_update *req;
 	struct sk_buff *skb;
+	gfp_t flags;
 
-	if (WARN_ON_ONCE(direction != TLS_OFFLOAD_CTX_DIR_RX))
-		return;
-
-	skb = nfp_net_tls_alloc_simple(nn, sizeof(*req), GFP_ATOMIC);
+	flags = direction == TLS_OFFLOAD_CTX_DIR_TX ? GFP_KERNEL : GFP_ATOMIC;
+	skb = nfp_net_tls_alloc_simple(nn, sizeof(*req), flags);
 	if (!skb)
 		return;
 
-	ntls = tls_driver_ctx(sk, TLS_OFFLOAD_CTX_DIR_RX);
+	ntls = tls_driver_ctx(sk, direction);
 	req = (void *)skb->data;
 	req->ep_id = 0;
-	req->opcode = NFP_NET_CRYPTO_OP_TLS_1_2_AES_GCM_128_DEC;
+	req->opcode = nfp_tls_1_2_dir_to_opcode(direction);
 	memset(req->resv, 0, sizeof(req->resv));
 	memcpy(req->handle, ntls->fw_handle, sizeof(ntls->fw_handle));
 	req->tcp_seq = cpu_to_be32(seq);
 	memcpy(req->rec_no, rcd_sn, sizeof(req->rec_no));
 
-	nfp_ccm_mbox_post(nn, skb, NFP_CCM_TYPE_CRYPTO_UPDATE,
-			  sizeof(struct nfp_crypto_reply_simple));
+	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
+		nfp_net_tls_communicate_simple(nn, skb, "sync",
+					       NFP_CCM_TYPE_CRYPTO_UPDATE);
+		ntls->next_seq = seq;
+	} else {
+		nfp_ccm_mbox_post(nn, skb, NFP_CCM_TYPE_CRYPTO_UPDATE,
+				  sizeof(struct nfp_crypto_reply_simple));
+	}
 }
 
 static const struct tlsdev_ops nfp_net_tls_ops = {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index c9c43abb2427..8e9568b15062 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -829,6 +829,7 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 {
 	struct nfp_net_tls_offload_ctx *ntls;
 	struct sk_buff *nskb;
+	bool resync_pending;
 	u32 datalen, seq;
 
 	if (likely(!dp->ktls_tx))
@@ -839,7 +840,8 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
 	seq = ntohl(tcp_hdr(skb)->seq);
 	ntls = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
-	if (unlikely(ntls->next_seq != seq || ntls->out_of_sync)) {
+	resync_pending = tls_offload_tx_resync_pending(skb->sk);
+	if (unlikely(resync_pending || ntls->next_seq != seq)) {
 		/* Pure ACK out of order already */
 		if (!datalen)
 			return skb;
@@ -869,8 +871,8 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 		}
 
 		/* jump forward, a TX may have gotten lost, need to sync TX */
-		if (!ntls->out_of_sync && seq - ntls->next_seq < U32_MAX / 4)
-			ntls->out_of_sync = true;
+		if (!resync_pending && seq - ntls->next_seq < U32_MAX / 4)
+			tls_offload_tx_resync_request(nskb->sk);
 
 		*nr_frags = 0;
 		return nskb;
-- 
2.21.0

