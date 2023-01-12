Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9776667B7
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 01:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbjALAd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 19:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235248AbjALAcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 19:32:53 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836493BEB0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:32:52 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id e1-20020a17090301c100b001945de452a1so144706plh.5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Oy7FllImPrmrWnDEe5Btq4uEoMcI9LQQjpbM58Drwg=;
        b=a16bIomN/UR6BbuiDAidezLl1VC014SQyYMKlGMqg4LfVHmqWtN/XEruUH/VpxPSd+
         0f29LjFAWO8wdwnmhmuGgYakJQWdhzBSMECqDZIPUqwbV2Zp3A/CrcRPY6lqo5sBtxnW
         dTfh+vZDdo470JGB0MdQQLDtGC4v0hoaLk2SzpslMqERB4B4ZmcozEh0eYIqLuyBYo+b
         XE7IRdcxTkq2W7Gb7zYMlvVDamqQzZHS1djWGK36KgjcCjsURgBzqccSZmeHOK6M6WUw
         y3fwxfNHkCBgZj+9dQgZWjXMOwKVR8giQCNdrpmOKp09H1AqbpIQJktPRwxe03X00W/Z
         kjPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Oy7FllImPrmrWnDEe5Btq4uEoMcI9LQQjpbM58Drwg=;
        b=rQosdv4p7oL2cZFELr73NuflwNFk1ehYku3pxafrtbahDSggxN1ONtES+b23z3QjHA
         yS9R4nOVDHjQsDascDuiFPnMEZHAXb4NBQSrfwIxhvEdMVh7vqOr2rD8HnfYUJ9Ovasd
         E5LhWBMTNR9n3kWDtXWfcmfQt9kljWPMQooSXd94JPfVxVDKnopl6KqbJyJsf5J7Cgst
         CDrnSumWXv1t0Zw7SvM4wfmdWN4I2RJgRGcPVMXnuBC1HuH2ZyZwk8V/7zQ1ADjxXvku
         9zGKIFdd6P+MbTW5rEtxPesnA8zaUxUQ/bNYUBFn70mWUDRpA8xQYSDDJ6ksjsGZU5YO
         j+EA==
X-Gm-Message-State: AFqh2kqR0gDWo9RXLvbFOVv+NJduhhsUqhq6kQKQvM9M6BJmeQ1Hz8HW
        dqRwAha2q2wzMUm4TIH/JhdM0gA=
X-Google-Smtp-Source: AMrXdXuzud2VRSsK1GthxVDOnlrwQCK3kNWR8ngBvaOyavmVwEHskSHI9bv63C2lssm6i7YE+4IS1Rg=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:ef94:b0:193:1d01:4909 with SMTP id
 iz20-20020a170902ef9400b001931d014909mr1632871plb.108.1673483572029; Wed, 11
 Jan 2023 16:32:52 -0800 (PST)
Date:   Wed, 11 Jan 2023 16:32:25 -0800
In-Reply-To: <20230112003230.3779451-1-sdf@google.com>
Mime-Version: 1.0
References: <20230112003230.3779451-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230112003230.3779451-13-sdf@google.com>
Subject: [PATCH bpf-next v7 12/17] net/mlx4_en: Introduce wrapper for xdp_buff
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional changes. Boilerplate to allow stuffing more data after xdp_buff.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 26 +++++++++++++---------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 8f762fc170b3..014a80af2813 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -661,9 +661,14 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
 #define MLX4_CQE_STATUS_IP_ANY (MLX4_CQE_STATUS_IPV4)
 #endif
 
+struct mlx4_en_xdp_buff {
+	struct xdp_buff xdp;
+};
+
 int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
+	struct mlx4_en_xdp_buff mxbuf = {};
 	int factor = priv->cqe_factor;
 	struct mlx4_en_rx_ring *ring;
 	struct bpf_prog *xdp_prog;
@@ -671,7 +676,6 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	bool doorbell_pending;
 	bool xdp_redir_flush;
 	struct mlx4_cqe *cqe;
-	struct xdp_buff xdp;
 	int polled = 0;
 	int index;
 
@@ -681,7 +685,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	ring = priv->rx_ring[cq_ring];
 
 	xdp_prog = rcu_dereference_bh(ring->xdp_prog);
-	xdp_init_buff(&xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
+	xdp_init_buff(&mxbuf.xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
 	doorbell_pending = false;
 	xdp_redir_flush = false;
 
@@ -776,24 +780,24 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 						priv->frag_info[0].frag_size,
 						DMA_FROM_DEVICE);
 
-			xdp_prepare_buff(&xdp, va - frags[0].page_offset,
+			xdp_prepare_buff(&mxbuf.xdp, va - frags[0].page_offset,
 					 frags[0].page_offset, length, false);
-			orig_data = xdp.data;
+			orig_data = mxbuf.xdp.data;
 
-			act = bpf_prog_run_xdp(xdp_prog, &xdp);
+			act = bpf_prog_run_xdp(xdp_prog, &mxbuf.xdp);
 
-			length = xdp.data_end - xdp.data;
-			if (xdp.data != orig_data) {
-				frags[0].page_offset = xdp.data -
-					xdp.data_hard_start;
-				va = xdp.data;
+			length = mxbuf.xdp.data_end - mxbuf.xdp.data;
+			if (mxbuf.xdp.data != orig_data) {
+				frags[0].page_offset = mxbuf.xdp.data -
+					mxbuf.xdp.data_hard_start;
+				va = mxbuf.xdp.data;
 			}
 
 			switch (act) {
 			case XDP_PASS:
 				break;
 			case XDP_REDIRECT:
-				if (likely(!xdp_do_redirect(dev, &xdp, xdp_prog))) {
+				if (likely(!xdp_do_redirect(dev, &mxbuf.xdp, xdp_prog))) {
 					ring->xdp_redirect++;
 					xdp_redir_flush = true;
 					frags[0].page = NULL;
-- 
2.39.0.314.g84b9a713c41-goog

