Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E1967A7DC
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjAYAfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbjAYAe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:34:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92131521D9;
        Tue, 24 Jan 2023 16:34:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDA61B8171E;
        Wed, 25 Jan 2023 00:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD92C433D2;
        Wed, 25 Jan 2023 00:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674606876;
        bh=xxZVhx3StcgNnFongN1nNXK6YLKdcHChYY3E1jGyTAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=epYawzDE2xpezUbg9rjd2tkpWE3xGtgUzEdUTLHsSInZ/J6RAJbPf7/Kklfqt+GjR
         9IvCvgCT7cadqdBEtCtIfGBp3duJEtTYez52Wd1ioM+ltXYV36bijhCulv5uuKnqGV
         jONfdJZ/v3iawlN5dG7rKHSghndkWAY/frn+pXvSfLgYFUvgYpaif3pS/iL3NAu3kb
         PLl1DCGwZwWzezEYdv52KCdt0chHMYZD2OtiobFlzVV0LxMKtAyzrWshhqyjNp7odf
         BBAvwjJ7mtAW+mBovdKqGWbX/6jjEoXmdSvhzko2NyedcfuXLNo1znO+coVwGIdYka
         4/ti4w8BjGahg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, martin.lau@linux.dev
Subject: [PATCH v2 bpf-next 6/8] bpf: devmap: check XDP features in __xdp_enqueue routine
Date:   Wed, 25 Jan 2023 01:33:26 +0100
Message-Id: <46f49d11939557aee7315bc23589cf261c19b494.1674606198.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674606193.git.lorenzo@kernel.org>
References: <cover.1674606193.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check if the destination device implements ndo_xdp_xmit callback relying
on NETDEV_XDP_ACT_NDO_XMIT flags. Moreover, check if the destination device
supports XDP non-linear frame in __xdp_enqueue and is_valid_dst routines.
This patch allows to perform XDP_REDIRECT on non-linear XDP buffers.

Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/bpf/devmap.c | 16 +++++++++++++---
 net/core/filter.c   | 13 +++++--------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index d01e4c55b376..2675fefc6cb6 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -474,7 +474,11 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 {
 	int err;
 
-	if (!dev->netdev_ops->ndo_xdp_xmit)
+	if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))
+		return -EOPNOTSUPP;
+
+	if (unlikely(!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT_SG) &&
+		     xdp_frame_has_frags(xdpf)))
 		return -EOPNOTSUPP;
 
 	err = xdp_ok_fwd_dev(dev, xdp_get_frame_len(xdpf));
@@ -532,8 +536,14 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_frame *xdpf,
 
 static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf)
 {
-	if (!obj ||
-	    !obj->dev->netdev_ops->ndo_xdp_xmit)
+	if (!obj)
+		return false;
+
+	if (!(obj->dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))
+		return false;
+
+	if (unlikely(!(obj->dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT_SG) &&
+		     xdp_frame_has_frags(xdpf)))
 		return false;
 
 	if (xdp_ok_fwd_dev(obj->dev, xdp_get_frame_len(xdpf)))
diff --git a/net/core/filter.c b/net/core/filter.c
index ed08dbf10338..aeebe21a7eff 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4314,16 +4314,13 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	enum bpf_map_type map_type = ri->map_type;
 
-	/* XDP_REDIRECT is not fully supported yet for xdp frags since
-	 * not all XDP capable drivers can map non-linear xdp_frame in
-	 * ndo_xdp_xmit.
-	 */
-	if (unlikely(xdp_buff_has_frags(xdp) &&
-		     map_type != BPF_MAP_TYPE_CPUMAP))
-		return -EOPNOTSUPP;
+	if (map_type == BPF_MAP_TYPE_XSKMAP) {
+		/* XDP_REDIRECT is not supported AF_XDP yet. */
+		if (unlikely(xdp_buff_has_frags(xdp)))
+			return -EOPNOTSUPP;
 
-	if (map_type == BPF_MAP_TYPE_XSKMAP)
 		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
+	}
 
 	return __xdp_do_redirect_frame(ri, dev, xdp_convert_buff_to_frame(xdp),
 				       xdp_prog);
-- 
2.39.1

