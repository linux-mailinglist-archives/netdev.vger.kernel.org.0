Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205386325A1
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 15:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiKUOXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 09:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiKUOXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 09:23:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82BA13EA6;
        Mon, 21 Nov 2022 06:23:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14534B81057;
        Mon, 21 Nov 2022 14:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C670C433D7;
        Mon, 21 Nov 2022 14:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669040594;
        bh=/jH9GYwDzo2HsuJAbISAsztvTBt8ms8nOOwZqv/Mke8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8j/afhgrCow+OkHmWwi/LOPFVdR6d5GZ0YUosld+p174tdNR2q494HyQLCZF2AX2
         ifTVbaC8Ev8c4mWlSiHQ7DLcACuL0cnAMSLlMwLZqMUZ3PBaeTKYsVuD36PnXwe9Pt
         elOinOX6CTyNMi03LeCL9Iz+JkN+xRBJIx4aR+Lh2dBNx5q7QcZwgHGzn32OP+5pH2
         X/o5gMirLaLai0AHRzi6F58UYWRYF2K2BrQ8MFN+24QIBwlx8qYZGFIH5yTOTpazZz
         ZGZ549pI3kGrKfD/xpxZM7jNg1q1DzGzUGggK2taltDifjUl3TEQCIhIRIWRioLGvl
         h/1UgX2+Sk6Ng==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v2 3/4] net: ethernet: ti: am65-cpsw: Restore ALE only if any interface was up
Date:   Mon, 21 Nov 2022 16:22:59 +0200
Message-Id: <20221121142300.9320-4-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221121142300.9320-1-rogerq@kernel.org>
References: <20221121142300.9320-1-rogerq@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no point in restoring ALE if all interfaces were down
prior to suspend as ALE will be cleared when any interface is
brought up.

So restore ALE only if any interface was up before system suspended.

Fixes: 1af3cb3702d0 ("net: ethernet: ti: am65-cpsw: Fix hardware switch mode on suspend/resume")
Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 2acde5b14516..dda9afe5410c 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2935,6 +2935,7 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 	struct net_device *ndev;
 	int i, ret;
 	struct am65_cpsw_host *host_p = am65_common_get_host(common);
+	bool need_ale_restore = false;
 
 	ret = am65_cpsw_nuss_init_tx_chns(common);
 	if (ret)
@@ -2957,6 +2958,7 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 			continue;
 
 		if (netif_running(ndev)) {
+			need_ale_restore = true;
 			rtnl_lock();
 			ret = am65_cpsw_nuss_ndo_slave_open(ndev);
 			rtnl_unlock();
@@ -2971,7 +2973,8 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 	}
 
 	writel(host_p->vid_context, host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
-	cpsw_ale_restore(common->ale, common->ale_context);
+	if (need_ale_restore)
+		cpsw_ale_restore(common->ale, common->ale_context);
 
 	return 0;
 }
-- 
2.17.1

