Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7EA96160D3
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 11:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiKBKbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 06:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiKBKbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 06:31:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033E027CED;
        Wed,  2 Nov 2022 03:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F5246185D;
        Wed,  2 Nov 2022 10:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCBBC433D6;
        Wed,  2 Nov 2022 10:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667385109;
        bh=aTufAObW2je+qnvAz/jiexklJjGnI6PIiZmUAseYC9g=;
        h=From:To:Cc:Subject:Date:From;
        b=BX/HxPDCs0FeiLmNeiLz7zhMfDo6dSaHBErgH2A5ZUQIK2Kd5zY2Oon7lRd8IaGfE
         AmM1i928J2u9XtnWTI4LiESVRVvabfsta3tan91JEvyyvAWWPyDbX0TazAQ+F7NAuC
         eaBjjs/hprAWSZI3rsbgeo/mS7AB6qcisK3KjmkKDzTGf4ow0zIhkdT+b1pDFDbpgC
         dmRN59rGMLNFm/VEcCHhq3f2GQnFSfLpquZPMRPc8fML+dB0zXF6brvKFZIa94mmi8
         v/riZLJgb8QP+U9t3Xa9U/Q7AfZSpx7IHR97oFdsN0TvnVSFRewvgQ3C8yWPSZFiiM
         HZCMfqg1IEIxQ==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, s-vadapalli@ti.com, vigneshr@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>, Stable@vger.kernel.org
Subject: [PATCH] net: ethernet: ti: am65-cpsw: Fix segmentation fault at module unload
Date:   Wed,  2 Nov 2022 12:31:44 +0200
Message-Id: <20221102103144.12022-1-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move am65_cpsw_nuss_phylink_cleanup() call to after
am65_cpsw_nuss_cleanup_ndev() so phylink is still valid
to prevent the below Segmentation fault on module remove when
first slave link is up.

[   31.652944] Unable to handle kernel paging request at virtual address 00040008000005f4
[   31.684627] Mem abort info:
[   31.687446]   ESR = 0x0000000096000004
[   31.704614]   EC = 0x25: DABT (current EL), IL = 32 bits
[   31.720663]   SET = 0, FnV = 0
[   31.723729]   EA = 0, S1PTW = 0
[   31.740617]   FSC = 0x04: level 0 translation fault
[   31.756624] Data abort info:
[   31.759508]   ISV = 0, ISS = 0x00000004
[   31.776705]   CM = 0, WnR = 0
[   31.779695] [00040008000005f4] address between user and kernel address ranges
[   31.808644] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[   31.814928] Modules linked in: wlcore_sdio wl18xx wlcore mac80211 libarc4 cfg80211 rfkill crct10dif_ce phy_gmii_sel ti_am65_cpsw_nuss(-) sch_fq_codel ipv6
[   31.828776] CPU: 0 PID: 1026 Comm: modprobe Not tainted 6.1.0-rc2-00012-gfabfcf7dafdb-dirty #160
[   31.837547] Hardware name: Texas Instruments AM625 (DT)
[   31.842760] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   31.849709] pc : phy_stop+0x18/0xf8
[   31.853202] lr : phylink_stop+0x38/0xf8
[   31.857031] sp : ffff80000a0839f0
[   31.860335] x29: ffff80000a0839f0 x28: ffff000000de1c80 x27: 0000000000000000
[   31.867462] x26: 0000000000000000 x25: 0000000000000000 x24: ffff80000a083b98
[   31.874589] x23: 0000000000000800 x22: 0000000000000001 x21: ffff000001bfba90
[   31.881715] x20: ffff0000015ee000 x19: 0004000800000200 x18: 0000000000000000
[   31.888842] x17: ffff800076c45000 x16: ffff800008004000 x15: 000058e39660b106
[   31.895969] x14: 0000000000000144 x13: 0000000000000144 x12: 0000000000000000
[   31.903095] x11: 000000000000275f x10: 00000000000009e0 x9 : ffff80000a0837d0
[   31.910222] x8 : ffff000000de26c0 x7 : ffff00007fbd6540 x6 : ffff00007fbd64c0
[   31.917349] x5 : ffff00007fbd0b10 x4 : ffff00007fbd0b10 x3 : ffff00007fbd3920
[   31.924476] x2 : d0a07fcff8b8d500 x1 : 0000000000000000 x0 : 0004000800000200
[   31.931603] Call trace:
[   31.934042]  phy_stop+0x18/0xf8
[   31.937177]  phylink_stop+0x38/0xf8
[   31.940657]  am65_cpsw_nuss_ndo_slave_stop+0x28/0x1e0 [ti_am65_cpsw_nuss]
[   31.947452]  __dev_close_many+0xa4/0x140
[   31.951371]  dev_close_many+0x84/0x128
[   31.955115]  unregister_netdevice_many+0x130/0x6d0
[   31.959897]  unregister_netdevice_queue+0x94/0xd8
[   31.964591]  unregister_netdev+0x24/0x38
[   31.968504]  am65_cpsw_nuss_cleanup_ndev.isra.0+0x48/0x70 [ti_am65_cpsw_nuss]
[   31.975637]  am65_cpsw_nuss_remove+0x58/0xf8 [ti_am65_cpsw_nuss]

Cc: <Stable@vger.kernel.org> # v5.18+
Fixes: e8609e69470f ("net: ethernet: ti: am65-cpsw: Convert to PHYLINK")
Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 7f86068f3ff6..c50b137f92d7 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2823,7 +2823,6 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpsw_unregister_devlink(common);
 	am65_cpsw_unregister_notifiers(common);
 
@@ -2831,6 +2830,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	 * dma_deconfigure(dev) before devres_release_all(dev)
 	 */
 	am65_cpsw_nuss_cleanup_ndev(common);
+	am65_cpsw_nuss_phylink_cleanup(common);
 
 	of_platform_device_destroy(common->mdio_dev, NULL);
 
-- 
2.17.1

