Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89AB263C133
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiK2Nfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiK2Nf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:35:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E6931DC6;
        Tue, 29 Nov 2022 05:35:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7C416172F;
        Tue, 29 Nov 2022 13:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8363BC433D7;
        Tue, 29 Nov 2022 13:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669728924;
        bh=VRP1vnYIcXaScFgVI3vxzPn1UkCZHA4CW5xgKdTodRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xun1aE70YOFjbOsUl8B3zWhgVOzLJrtV49CZiipMOdZXsPP8Yqbyuk7o1s3VgyW3q
         01XTIuEyXXw9FXeoFSPQD54c0AeNTRxw11YBWisKKqEkzscX/YhZYh7M3q6RDnEvyJ
         ZQ1rM6ZNnuKFnUFqoMCA8q7DQqnGTtDZvZox72PzU3fK4I7j+MKrAadAf+rYsHeUnO
         JZV3uezSb4sgq3LRGg+WIXEACAgjbpbjB5MSgfOSDzpbMsciaaHELmRwDvs4jXkGM6
         ZxhXffFsSg20KAb7PtZZEuDUV3IDhjWY1SlS/Iov0dGzgMu57AMrp/SZ+V/YF0akjM
         q12sBFJzefjyg==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v4 net-next 5/6] net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after suspend/resume
Date:   Tue, 29 Nov 2022 15:35:00 +0200
Message-Id: <20221129133501.30659-6-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221129133501.30659-1-rogerq@kernel.org>
References: <20221129133501.30659-1-rogerq@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During suspend resume the context of PORT_VLAN_REG is lost so
save it during suspend and restore it during resume for
host port and slave ports.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 +++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 1c5a51439427..3f430f8d8a26 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2872,10 +2872,12 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 static int am65_cpsw_nuss_suspend(struct device *dev)
 {
 	struct am65_cpsw_common *common = dev_get_drvdata(dev);
+	struct am65_cpsw_host *host_p = am65_common_get_host(common);
 	struct am65_cpsw_port *port;
 	struct net_device *ndev;
 	int i, ret;
 
+	host_p->vid_context = readl(host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
 		ndev = port->ndev;
@@ -2883,6 +2885,7 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
 		if (!ndev)
 			continue;
 
+		port->vid_context = readl(port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
 		netif_device_detach(ndev);
 		if (netif_running(ndev)) {
 			rtnl_lock();
@@ -2909,6 +2912,7 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 	struct am65_cpsw_port *port;
 	struct net_device *ndev;
 	int i, ret;
+	struct am65_cpsw_host *host_p = am65_common_get_host(common);
 
 	ret = am65_cpsw_nuss_init_tx_chns(common);
 	if (ret)
@@ -2941,8 +2945,11 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 		}
 
 		netif_device_attach(ndev);
+		writel(port->vid_context, port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
 	}
 
+	writel(host_p->vid_context, host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
+
 	return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 2c9850fdfcb6..e95cc37a7286 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -55,12 +55,16 @@ struct am65_cpsw_port {
 	bool				rx_ts_enabled;
 	struct am65_cpsw_qos		qos;
 	struct devlink_port		devlink_port;
+	/* Only for suspend resume context */
+	u32				vid_context;
 };
 
 struct am65_cpsw_host {
 	struct am65_cpsw_common		*common;
 	void __iomem			*port_base;
 	void __iomem			*stat_base;
+	/* Only for suspend resume context */
+	u32				vid_context;
 };
 
 struct am65_cpsw_tx_chn {
-- 
2.17.1

