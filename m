Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0FD63C12B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiK2NfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbiK2NfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:35:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD90C1FF8F;
        Tue, 29 Nov 2022 05:35:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64EF761734;
        Tue, 29 Nov 2022 13:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381F8C433D6;
        Tue, 29 Nov 2022 13:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669728914;
        bh=qfseqzA5QeFGbDcdL8jAeZcM/YWcdxti75h4w7j1dOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMCK03I4+nK/r1o4v/OB6a6fornBI7jfIZY0bkDR8eoD0vZtnsLe5ULGlVbd3Xelb
         di/k080iP3YbqPUlU9uoFKWjGSyMedGRLDYtMz8doxRRKrKkBHoCkU9WzDT9e3QgqW
         F/9sWOCr9gt8IytrsAsvFMFXI3Hs0DbU761Uyj7IG0eQCWCXU9RafQYELP+ZHkcDCV
         CwcLHbWEcprw1vDI/KPz/sJwUDvktivx+Vx6xgqXqMmBnqL3VCoCP41jWQkisSu5f3
         PqwHx7cp75HWygz4zlfWEwj8x76bHPBa01k9EgzI/N8B/VB7Erc1K02aE2quybItIk
         1FMgfU/fVJfhQ==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v4 net-next 2/6] Revert "net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after suspend/resume"
Date:   Tue, 29 Nov 2022 15:34:57 +0200
Message-Id: <20221129133501.30659-3-rogerq@kernel.org>
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

This reverts commit 643cf0e3ab5ccee37b3c53c018bd476c45c4b70e.

This is to make it easier to revert the offending commit
fd23df72f2be ("net: ethernet: ti: am65-cpsw: Add suspend/resume support")

Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 -------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 4 ----
 2 files changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index b43dc75c2202..04e673902d53 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2876,9 +2876,7 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
 	struct am65_cpsw_port *port;
 	struct net_device *ndev;
 	int i, ret;
-	struct am65_cpsw_host *host_p = am65_common_get_host(common);
 
-	host_p->vid_context = readl(host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
 		ndev = port->ndev;
@@ -2886,7 +2884,6 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
 		if (!ndev)
 			continue;
 
-		port->vid_context = readl(port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
 		netif_device_detach(ndev);
 		if (netif_running(ndev)) {
 			rtnl_lock();
@@ -2910,7 +2907,6 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 	struct am65_cpsw_port *port;
 	struct net_device *ndev;
 	int i, ret;
-	struct am65_cpsw_host *host_p = am65_common_get_host(common);
 
 	am65_cpts_resume(common->cpts);
 
@@ -2932,11 +2928,8 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 		}
 
 		netif_device_attach(ndev);
-		writel(port->vid_context, port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
 	}
 
-	writel(host_p->vid_context, host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
-
 	return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index e95cc37a7286..2c9850fdfcb6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -55,16 +55,12 @@ struct am65_cpsw_port {
 	bool				rx_ts_enabled;
 	struct am65_cpsw_qos		qos;
 	struct devlink_port		devlink_port;
-	/* Only for suspend resume context */
-	u32				vid_context;
 };
 
 struct am65_cpsw_host {
 	struct am65_cpsw_common		*common;
 	void __iomem			*port_base;
 	void __iomem			*stat_base;
-	/* Only for suspend resume context */
-	u32				vid_context;
 };
 
 struct am65_cpsw_tx_chn {
-- 
2.17.1

