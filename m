Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029CE66AC56
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 16:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjANPzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 10:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjANPzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 10:55:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF93902F;
        Sat, 14 Jan 2023 07:55:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17607B8097A;
        Sat, 14 Jan 2023 15:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FE2C433D2;
        Sat, 14 Jan 2023 15:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673711712;
        bh=tTMkYCwIfSkQmHJDvNOYI3WNmgsYzlUepL/Re3S7G2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTBoe6qBbIbu35WVTynkrySj7iOYZw9b2rCgG7qWhb5QJCdqv+8fNU8bm1hM7Chvc
         Exv4kh0ToWYR7SqALagQNXszgmtiqUxpyr/maIUvuv+V13q9Euordf/1mBXYm6xE/G
         sv6zSAhn8ZA7QEN/vfx3brW4xgcQa0HPC7o5vzKimK9ikjSEPm33Aw3uRPoIMRfcQb
         1zlkSDeiNugbc71BPFJYUqf02bpJsnptNibDOOfRq4q8QZ/Ml/mVUnrd5rrDMXVLz1
         i1exmDeqRHtnHrKqAQWC5zy/17WqofG7M16/6HJYsttceLz9vDOD1QT8qXoZgnUPmN
         NtRJWfCkBLb3w==
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
        lorenzo.bianconi@redhat.com
Subject: [RFC v2 bpf-next 6/7] bpf: devmap: check XDP features in bpf_map_update_elem and __xdp_enqueue
Date:   Sat, 14 Jan 2023 16:54:36 +0100
Message-Id: <18571a03174b333413114ff9aeccfe9c102c504f.1673710867.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673710866.git.lorenzo@kernel.org>
References: <cover.1673710866.git.lorenzo@kernel.org>
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

When we update devmap element, the net_device whose ifindex is specified
in map value must support ndo_xdp_xmit callback, which is indicated by
the presence of XDP_F_REDIRECT_TARGET feature. Let's check for
this feature and return an error if device cannot be used as a redirect
target.

Moreover check the device support xdp non-linear frame in __xdp_enqueue
and is_valid_dst routines. This patch allows to perfrom XDP_REDIRECT on
non-linear xdp buffers.

Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/bpf/devmap.c | 25 +++++++++++++++++++++----
 net/core/filter.c   | 13 +++++--------
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index d01e4c55b376..69ceecc792df 100644
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
@@ -843,6 +853,7 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 {
 	struct bpf_prog *prog = NULL;
 	struct bpf_dtab_netdev *dev;
+	int ret = -EINVAL;
 
 	dev = bpf_map_kmalloc_node(&dtab->map, sizeof(*dev),
 				   GFP_NOWAIT | __GFP_NOWARN,
@@ -854,6 +865,12 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 	if (!dev->dev)
 		goto err_out;
 
+	/* Check if net_device can be used as a redirect target */
+	if (!(READ_ONCE(dev->dev->xdp_features) & NETDEV_XDP_ACT_NDO_XMIT)) {
+		ret = -EOPNOTSUPP;
+		goto err_put_dev;
+	}
+
 	if (val->bpf_prog.fd > 0) {
 		prog = bpf_prog_get_type_dev(val->bpf_prog.fd,
 					     BPF_PROG_TYPE_XDP, false);
@@ -882,7 +899,7 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
 	dev_put(dev->dev);
 err_out:
 	kfree(dev);
-	return ERR_PTR(-EINVAL);
+	return ERR_PTR(ret);
 }
 
 static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
diff --git a/net/core/filter.c b/net/core/filter.c
index d9befa6ba04e..b9a03f1b2012 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4285,16 +4285,13 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
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
2.39.0

