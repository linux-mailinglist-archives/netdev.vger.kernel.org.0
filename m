Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA09B644018
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbiLFJpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiLFJon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:44:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21C91F9DC;
        Tue,  6 Dec 2022 01:44:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 885B0611E0;
        Tue,  6 Dec 2022 09:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FABFC433D6;
        Tue,  6 Dec 2022 09:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670319881;
        bh=BYlR0o5X0xGA4XLptS1Any7Q7Cj6YM9GdILoyAJmUyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQfV1F1jpWVzZbov5WFamXrdWEP66p2Wx4HS2k9xI4oyl7Dgy6v57SMWxDG2VW32g
         p62G5vXLr0AWVtZ6Ew/nO4AduLoXHiGvpcadaf+BpYjbV4lz1iuIz3BsLleJqLluWe
         I7q/Lt+i8Ia4zEp+FwWGrOVhvkcSswOxjc2OTIGHR5eZckEtnQGswbGgv2gbJhsQix
         t91EGMLd5LEtvTgkdwszdecNDeIBf19k0KjxyjrUof+ypVyhClUt8z8JjjvNNwmz3o
         SmAKFpfZ0L7mMntpupLHz9DdZkrpTzuH2TFbzDj879iEbSMtT6b1qu6Op/tFToNGOg
         umIZb03xKsVCQ==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v5 net-next 5/6] net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after suspend/resume
Date:   Tue,  6 Dec 2022 11:44:18 +0200
Message-Id: <20221206094419.19478-6-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221206094419.19478-1-rogerq@kernel.org>
References: <20221206094419.19478-1-rogerq@kernel.org>
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
index d4618edd2f9c..ecf33c17ca96 100644
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

