Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7239F6B241A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjCIM0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjCIM0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:26:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8664AEBAC8;
        Thu,  9 Mar 2023 04:26:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1382161AF9;
        Thu,  9 Mar 2023 12:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EACC4339B;
        Thu,  9 Mar 2023 12:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678364769;
        bh=+hMJKeIw91xCf4gCpoyS0rksbBEIqk6Mi9zC5eJzwEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzZmRrYrI61AmgJDwnM3v+DQt2rhC4SLCyojUc6qXD4bk0o1m6UVz2IXDS5Nz/Lst
         NZzOfhfIi/aCC4TxyWXkjRZvLmqHIXmmARPvzND65wlP9PfgCKBqPqxG98EOfD6Zk5
         MqH12GGNk3tmHJWakfOZQM+9RGW59YElWBAR2RaJUFq3eb0/Bfg/kQOzvG0ABBD4K3
         cZaZyfzFr3O7gVhRKRZ+zdQmzZZbyslp/elvQLCbgtJkX3E8u44oYYZbv4/O5YB5Pw
         tXbwIsnr6h+r5l+bCy7QPIobWXNf+VN1V1n5Ev5q1o9YaYH1+ieforc+ZVEM3q5Qlh
         4m4SfIBcU8s/A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: [PATCH net v2 3/8] xdp: add xdp_set_features_flag utility routine
Date:   Thu,  9 Mar 2023 13:25:27 +0100
Message-Id: <a20c35249681a801cf7f69b0305b7090848daa11.1678364613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678364612.git.lorenzo@kernel.org>
References: <cover.1678364612.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_set_features_flag utility routine in order to update
dynamically xdp_features according to the dynamic hw configuration via
ethtool (e.g. changing number of hw rx/tx queues).
Add xdp_clear_features_flag() in order to clear all xdp_feature flag.

Reviewed-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 Documentation/netlink/specs/netdev.yaml |  1 +
 include/net/xdp.h                       | 11 +++++++++++
 include/uapi/linux/netdev.h             |  2 ++
 net/core/xdp.c                          | 26 ++++++++++++++++++-------
 tools/include/uapi/linux/netdev.h       |  2 ++
 5 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index 24de747b5344..753e5914a8b7 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -9,6 +9,7 @@ definitions:
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
index 8c4e3e536c04..ed134fbdfd32 100644
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
index 8c4e3e536c04..ed134fbdfd32 100644
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
-- 
2.39.2

