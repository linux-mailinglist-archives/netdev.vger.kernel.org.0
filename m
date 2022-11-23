Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2157B635EFC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238538AbiKWNF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238535AbiKWNFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:05:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20554CEBA8;
        Wed, 23 Nov 2022 04:49:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71500B81FA3;
        Wed, 23 Nov 2022 12:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8612C43470;
        Wed, 23 Nov 2022 12:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207736;
        bh=dvTLeoyNu7eFICLRoSnxH3F03RJcNb7dgmyKN7nwRnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D922lsjrolWkfRD+shTbR3JQGkpK6IwTTITljd7ow9jCKtsfavrU79wOlv8nA/Um7
         wmubF2nSKyvickJFawnoQAIjw4AYPbE7vsV5BpFfOj8GykmfYFuzeU5SVN1f4mN7RN
         FhX8ce8rIUfRU7cVTGVjpXtqkmI9WNeCyWC8HZWE0kq9iX/1Wa6CfmDmvJrpksAf7E
         M544kEmYJVgjaxqFOvCVkF8NuHbQHJhi2FRmItUmnZ1wnDcUo9/XX392JOeRyv+4hx
         I2vrjmBSLXVOgyt79hzeJDUR59EihTqMVRiYaxhq+NUl1IIbTqlLFn3BQtQomQp255
         /q8yZCOnCbi3Q==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v3 net-next 5/6] net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after suspend/resume
Date:   Wed, 23 Nov 2022 14:48:34 +0200
Message-Id: <20221123124835.18937-6-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221123124835.18937-1-rogerq@kernel.org>
References: <20221123124835.18937-1-rogerq@kernel.org>
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
index 0b59088e3728..f5357afde527 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2875,7 +2875,9 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
 	struct am65_cpsw_port *port;
 	struct net_device *ndev;
 	int i, ret;
+	struct am65_cpsw_host *host_p = am65_common_get_host(common);
 
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

