Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF716AE3C6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCGPDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCGPDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:03:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F1A81CDF;
        Tue,  7 Mar 2023 06:54:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63C6761265;
        Tue,  7 Mar 2023 14:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DECC433EF;
        Tue,  7 Mar 2023 14:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678200876;
        bh=H4sA8nnBZcXuU7xmYpYEdn+Hznwwav+YgudjUw2OK5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkSEh6unBU4y84kIXZd4E2tCYOq5behXj5dJtB1C6TqyKspoqs9dI0I0IHzrL80I2
         UhQWCVkZ3C5yLFyRIh17B5lDzs5TUHs+fiv3VA9ErP7TjNkEKxb6E8foGvuLyM6otv
         LghX/iwJWsLrMBbZDEmvtPl4yd2D/E4PPqFQtpLnW0clCHNJFOeAdaoXd8xEanpDE/
         DL0wIBnd+Gm+ThWazXa88hbNs+aU78syMhtQslU+1WGN09icR0WH9EvSSS4BC2QlMC
         /WJE2X8ePt5RvICDYAE8gZPUlHjMV7gUSQjPAXId2rBIuLS8lTxbZJw79gzkB5NZxr
         zjv1jqCCARnwg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com
Subject: [PATCH net-next 3/8] xdp: add xdp_set_features_flag utility routine
Date:   Tue,  7 Mar 2023 15:54:00 +0100
Message-Id: <e8cb0b6167cf5b97125f57876c43e8cf248c5f0a.1678200041.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678200041.git.lorenzo@kernel.org>
References: <cover.1678200041.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_set_features_flag utility routine in order to update
dynamically xdp_features according to the dynamic hw configuration via
ethtool (e.g. changing number of hw rx/tx queues).
Add xdp_clear_features_flag() in order to clear all xdp_feature flag.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 Documentation/netlink/specs/netdev.yaml |  1 +
 include/net/xdp.h                       | 11 +++++++++++
 include/uapi/linux/netdev.h             |  2 ++
 net/core/xdp.c                          | 26 ++++++++++++++++++-------
 tools/include/uapi/linux/netdev.h       |  2 ++
 tools/net/ynl/ynl-gen-c.py              |  2 +-
 6 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index cffef09729f1..7e4a5b4e7162 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -7,6 +7,7 @@ definitions:
   -
     type: flags
     name: xdp-act
+    render-max: true
     entries:
       -
         name: basic
diff --git a/include/net/xdp.h b/include/net/xdp.h
index d517bfac937b..41c57b8b1671 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -428,12 +428,18 @@ MAX_XDP_METADATA_KFUNC,
 #ifdef CONFIG_NET
 u32 bpf_xdp_metadata_kfunc_id(int id);
 bool bpf_dev_bound_kfunc_id(u32 btf_id);
+void xdp_set_features_flag(struct net_device *dev, xdp_features_t val);
 void xdp_features_set_redirect_target(struct net_device *dev, bool support_sg);
 void xdp_features_clear_redirect_target(struct net_device *dev);
 #else
 static inline u32 bpf_xdp_metadata_kfunc_id(int id) { return 0; }
 static inline bool bpf_dev_bound_kfunc_id(u32 btf_id) { return false; }
 
+static inline void
+xdp_set_features_flag(struct net_device *dev, xdp_features_t val)
+{
+}
+
 static inline void
 xdp_features_set_redirect_target(struct net_device *dev, bool support_sg)
 {
@@ -445,4 +451,9 @@ xdp_features_clear_redirect_target(struct net_device *dev)
 }
 #endif
 
+static inline void xdp_clear_features_flag(struct net_device *dev)
+{
+	xdp_set_features_flag(dev, 0);
+}
+
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 588391447bfb..497cfc93f2e3 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -33,6 +33,8 @@ enum netdev_xdp_act {
 	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
 	NETDEV_XDP_ACT_RX_SG = 32,
 	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
+
+	NETDEV_XDP_ACT_MASK = 127,
 };
 
 enum {
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 8c92fc553317..87e654b7d06c 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -774,20 +774,32 @@ static int __init xdp_metadata_init(void)
 }
 late_initcall(xdp_metadata_init);
 
-void xdp_features_set_redirect_target(struct net_device *dev, bool support_sg)
+void xdp_set_features_flag(struct net_device *dev, xdp_features_t val)
 {
-	dev->xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
-	if (support_sg)
-		dev->xdp_features |= NETDEV_XDP_ACT_NDO_XMIT_SG;
+	val &= NETDEV_XDP_ACT_MASK;
+	if (dev->xdp_features == val)
+		return;
 
+	dev->xdp_features = val;
 	call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
 }
+EXPORT_SYMBOL_GPL(xdp_set_features_flag);
+
+void xdp_features_set_redirect_target(struct net_device *dev, bool support_sg)
+{
+	xdp_features_t val = (dev->xdp_features | NETDEV_XDP_ACT_NDO_XMIT);
+
+	if (support_sg)
+		val |= NETDEV_XDP_ACT_NDO_XMIT_SG;
+	xdp_set_features_flag(dev, val);
+}
 EXPORT_SYMBOL_GPL(xdp_features_set_redirect_target);
 
 void xdp_features_clear_redirect_target(struct net_device *dev)
 {
-	dev->xdp_features &= ~(NETDEV_XDP_ACT_NDO_XMIT |
-			       NETDEV_XDP_ACT_NDO_XMIT_SG);
-	call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
+	xdp_features_t val = dev->xdp_features;
+
+	val &= ~(NETDEV_XDP_ACT_NDO_XMIT | NETDEV_XDP_ACT_NDO_XMIT_SG);
+	xdp_set_features_flag(dev, val);
 }
 EXPORT_SYMBOL_GPL(xdp_features_clear_redirect_target);
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index 588391447bfb..497cfc93f2e3 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -33,6 +33,8 @@ enum netdev_xdp_act {
 	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
 	NETDEV_XDP_ACT_RX_SG = 32,
 	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
+
+	NETDEV_XDP_ACT_MASK = 127,
 };
 
 enum {
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 0d6df9414aa9..feb86f043e3b 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1995,7 +1995,7 @@ def render_uapi(family, cw):
                 cw.nl()
                 if const['type'] == 'flags':
                     max_name = c_upper(name_pfx + 'mask')
-                    max_val = f' = {(entry.user_value() << 1) - 1},'
+                    max_val = f' = {enum.get_mask()},'
                     cw.p(max_name + max_val)
                 else:
                     max_name = c_upper(name_pfx + 'max')
-- 
2.39.2

