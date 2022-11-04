Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0266197BC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiKDNXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiKDNXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:23:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EA563DC;
        Fri,  4 Nov 2022 06:23:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ABEEB82CFE;
        Fri,  4 Nov 2022 13:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F243C433D7;
        Fri,  4 Nov 2022 13:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667568209;
        bh=AcbhjgBIMLzAyPW9JVkGaeIHxFzET2ExbSSFQyPqDzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2Dt9jBr04YLYmSvEhZPUYzVhojU3sKnBEBTRN4zZSPEyc99Kj8bv9UmyXP74EVpp
         1aJ19FwCpb+qFfsULtBRPbODqNpF8rgQ81Cn53IxrRBjKPFejmUocrHBqd/chH7U+E
         vdFz6UmzA6egUa9zo8hty0MisRGOXhwLbrhq72hQEFcbItlsBjccuZbd0ZG25572/J
         MEK390pjvdHoLStCzq3A16dNRQdgonMNlXnSirvLybEak+6+VWlVp+bhFjcNSogm3j
         tS2gxXIfN/LvC04r4uY9diDZKftS137YFJ/cyVAK9O2KshtfcdCcapyBiaGEnHwqou
         NSLtam41S35aw==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vigneshr@ti.com, vibhore@ti.com, srk@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 4/5] net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after suspend/resume
Date:   Fri,  4 Nov 2022 15:23:09 +0200
Message-Id: <20221104132310.31577-5-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221104132310.31577-1-rogerq@kernel.org>
References: <20221104132310.31577-1-rogerq@kernel.org>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 +++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 057ca7a23306..26bda0f8853a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2887,7 +2887,9 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
 	struct am65_cpsw_port *port;
 	struct net_device *ndev;
 	int i, ret;
+	struct am65_cpsw_host *host_p = am65_common_get_host(common);
 
+	host_p->vid_context = readl(host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
 		ndev = port->ndev;
@@ -2895,6 +2897,7 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
 		if (!ndev)
 			continue;
 
+		port->vid_context = readl(port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
 		netif_device_detach(ndev);
 		if (netif_running(ndev)) {
 			rtnl_lock();
@@ -2918,6 +2921,7 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 	struct am65_cpsw_port *port;
 	struct net_device *ndev;
 	int i, ret;
+	struct am65_cpsw_host *host_p = am65_common_get_host(common);
 
 	am65_cpts_resume(common->cpts);
 
@@ -2939,8 +2943,11 @@ static int am65_cpsw_nuss_resume(struct device *dev)
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

