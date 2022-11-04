Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080F66197BF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiKDNXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiKDNXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:23:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E302C671;
        Fri,  4 Nov 2022 06:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25BF8B82DF1;
        Fri,  4 Nov 2022 13:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7303BC43142;
        Fri,  4 Nov 2022 13:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667568211;
        bh=XSJdTlu/kETfFLIwIbP3T52ljFSepDcwbaGJg9YPCfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZEvsl/vuqjXxSnwP786tzoX6l4gRK6YK2XzI3rV25XvT0mngoChMK4oiQ0JRh0AL
         MyUFwmv3ErUy8ta72p1LL9oCVW/qt3YzcT+byhaeVxvg+DfkCipZ8+ATqpf+0xki2x
         GLbyrvL3CqaSm7ZSvA2sJjs/d7rD/+GOqmqwf3xiK3QjQH/XRNgS/1MC6ktTW3PAia
         YDCidkgXiOT8WgCsty7+MBPH8REHc2/E+OlyadPCMeHfysDqCrczgjjt00IQjuT3Uw
         /r4NWWH/4pdZ/snKQQ9WBq/qBDP6JzR4GP5/zyuUPtcBozSVo26tG7dik/B3S9K9RO
         cSwpdSY7CWl6Q==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vigneshr@ti.com, vibhore@ti.com, srk@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 5/5] net: ethernet: ti: am65-cpsw: Fix hardware switch mode on suspend/resume
Date:   Fri,  4 Nov 2022 15:23:10 +0200
Message-Id: <20221104132310.31577-6-rogerq@kernel.org>
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

On low power during system suspend the ALE table context is lost.
Save the ALE contect before suspend and restore it after resume.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 +++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 26bda0f8853a..f2e377524088 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2725,6 +2725,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	struct clk *clk;
 	u64 id_temp;
 	int ret, i;
+	int ale_entries;
 
 	common = devm_kzalloc(dev, sizeof(struct am65_cpsw_common), GFP_KERNEL);
 	if (!common)
@@ -2819,6 +2820,10 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 		goto err_of_clear;
 	}
 
+	ale_entries = common->ale->params.ale_entries;
+	common->ale_context = devm_kzalloc(dev,
+					   ale_entries * ALE_ENTRY_WORDS * sizeof(u32),
+					   GFP_KERNEL);
 	ret = am65_cpsw_init_cpts(common);
 	if (ret)
 		goto err_of_clear;
@@ -2889,6 +2894,7 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
 	int i, ret;
 	struct am65_cpsw_host *host_p = am65_common_get_host(common);
 
+	cpsw_ale_dump(common->ale, common->ale_context);
 	host_p->vid_context = readl(host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
@@ -2947,6 +2953,7 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 	}
 
 	writel(host_p->vid_context, host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
+	cpsw_ale_restore(common->ale, common->ale_context);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index e95cc37a7286..4b75620f8d28 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -149,6 +149,8 @@ struct am65_cpsw_common {
 	struct net_device *hw_bridge_dev;
 	struct notifier_block am65_cpsw_netdevice_nb;
 	unsigned char switch_id[MAX_PHYS_ITEM_ID_LEN];
+	/* only for suspend/resume context restore */
+	u32			*ale_context;
 };
 
 struct am65_cpsw_ndev_stats {
-- 
2.17.1

