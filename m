Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523CC629071
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiKODEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbiKODDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:03:22 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F98C65DD
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:28 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id e12-20020a62aa0c000000b0056c12c0aadeso7100987pff.21
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LmbtQXfRONLBh7ffBd4bAoho6T1l6iyjip9uOPJH4mk=;
        b=kP0k0rKgZGTa23eCpMmPwgD6iD6Y7SS3SqPHN7QTRHGrrG6fGLjZOU2ILC66u7e6LX
         cuj12UmH2OL+y4eh9T8zWI8saqe4fJBWKAndXkYmEcA4tc+Xn4eBidmrscgjO8jqrfxT
         o/AkvLhuQF7+YgVHN/KQfpLzsW9RqT38Z4tGPDxoKNmu+kFuJEHBuikZqchc2cenu2bv
         bc7/gcu7mY4aYZIHta/NEWjsJHzzqw0Bfnkgk0OvgLa+j2VCl4DQFOCOUw5xFhTyUmNT
         gU5KL0dk3lyjWtDitYOfuYynw/H1al1YA0nX8t+1WzU4qG10gBcmgP9IQBvnvCFGyNYa
         G+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LmbtQXfRONLBh7ffBd4bAoho6T1l6iyjip9uOPJH4mk=;
        b=evgZx7veYq99xc9NqDy+UWFHva4U7/Isls3vgo/lGdLpOBinxuPies1cueAyxW1C7k
         s6g8pPmHS6qRqZ5J7x+QiS0B+fQQWGN2saqHeYf2+HipCkQpOpX27vTGvtopQ54oTfgP
         lih4M3N5KkUM5HFjp5THNygyW4ysDoFZZA9M1Q955jWkBufRS1kAgC6MjgBBJQLBk98b
         8OXIRRo4yQJ14IZhOqc2ny8JSoaNlg59ThzAeTf36ikhiRO7h9bHtBeNAiLL9YXrT0wd
         9blkgPeTlGjcBF67memb4Pqry/6TtkUfoAil+CzcEpsOKuaKP2AFWPMoHinhjCRxUAAc
         wAWA==
X-Gm-Message-State: ANoB5pk2npE6eFxRnLo3a4qzcHXM6b2zxdlPKh/PbvQEKEJP/J8/igss
        lNSCByJenU6C7h2T5kdDUWacHPs=
X-Google-Smtp-Source: AA0mqf70hAU4ASIwlaf/FEHEOOF7u4nv6TjYjGO8hH7My4K1/VEbWVdQ2/1qx5/bMXZq5W2F82/xbX0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a62:3683:0:b0:56d:dd2a:c494 with SMTP id
 d125-20020a623683000000b0056ddd2ac494mr16321177pfa.76.1668481347866; Mon, 14
 Nov 2022 19:02:27 -0800 (PST)
Date:   Mon, 14 Nov 2022 19:02:08 -0800
In-Reply-To: <20221115030210.3159213-1-sdf@google.com>
Mime-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115030210.3159213-10-sdf@google.com>
Subject: [PATCH bpf-next 09/11] mlx4: Introduce mlx4_xdp_buff wrapper for xdp_buff
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
        netdev@vger.kernel.org
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
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 26 +++++++++++++---------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 8f762fc170b3..467356633172 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -661,17 +661,21 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
 #define MLX4_CQE_STATUS_IP_ANY (MLX4_CQE_STATUS_IPV4)
 #endif
 
+struct mlx4_xdp_buff {
+	struct xdp_buff xdp;
+};
+
 int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	int factor = priv->cqe_factor;
 	struct mlx4_en_rx_ring *ring;
+	struct mlx4_xdp_buff mxbuf;
 	struct bpf_prog *xdp_prog;
 	int cq_ring = cq->ring;
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
2.38.1.431.g37b22c650d-goog

