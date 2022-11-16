Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D6162C567
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239208AbiKPQvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239087AbiKPQus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:50:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B306127B;
        Wed, 16 Nov 2022 08:49:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 423ED61EEF;
        Wed, 16 Nov 2022 16:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E5DC433D7;
        Wed, 16 Nov 2022 16:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668617369;
        bh=+Yl4jjx33Nm+4lEyKhK/gA6nkezg3rtXvgUlWPsJ0wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRc42h0h2SVfBHFiiWOdAzQgZ9ojwrl0PCcB8tMt4/0OM5qTBCUOQd7vuSsMQg7rF
         /fttjPYOBp1zsMHTohX2Rq3TtgkTP4PVRdWhbQVOd+fXrXRywxaWBXdzigRfzs/Ekq
         EQiNvTK3lpQupWmbc1uOK3c9lNftGce3/KPwsNC+gQuCpwZMXisQF2SCRsSpZuOb4C
         Vtg6Sf8OjrrOijqf1UGBKa7L/vu26bFaUSk8QLN33fflTPUCpFas1seSpO15/Sis40
         IWsHpyCCdJ1zPR5X3fw8lpTnKMP1ZFXoEXFaAaPOQp11tOAqk5P+BkRGUpKRsJf7aw
         rQJHZDTPX6StQ==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 3/4] net: ethernet: ti: am65-cpsw: Restore ALE only if any interface was up
Date:   Wed, 16 Nov 2022 18:49:14 +0200
Message-Id: <20221116164915.13236-4-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221116164915.13236-1-rogerq@kernel.org>
References: <20221116164915.13236-1-rogerq@kernel.org>
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
index 4107e9df65cd..9f3871373ebd 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2932,6 +2932,7 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 	struct net_device *ndev;
 	int i, ret;
 	struct am65_cpsw_host *host_p = am65_common_get_host(common);
+	bool need_ale_restore = false;
 
 	ret = am65_cpsw_nuss_init_tx_chns(common);
 	if (ret)
@@ -2954,6 +2955,7 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 			continue;
 
 		if (netif_running(ndev)) {
+			need_ale_restore = true;
 			rtnl_lock();
 			ret = am65_cpsw_nuss_ndo_slave_open(ndev);
 			rtnl_unlock();
@@ -2968,7 +2970,8 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 	}
 
 	writel(host_p->vid_context, host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
-	cpsw_ale_restore(common->ale, common->ale_context);
+	if (need_ale_restore)
+		cpsw_ale_restore(common->ale, common->ale_context);
 
 	return 0;
 }
-- 
2.17.1

