Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2398A6560AD
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 08:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiLZHNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 02:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiLZHNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 02:13:35 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF6362BF5;
        Sun, 25 Dec 2022 23:13:34 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,274,1665414000"; 
   d="scan'208";a="147425157"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 26 Dec 2022 16:13:32 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id DC84C41BAEC7;
        Mon, 26 Dec 2022 16:13:32 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net 1/2] net: ethernet: renesas: rswitch: Fix error path in renesas_eth_sw_probe()
Date:   Mon, 26 Dec 2022 16:13:27 +0900
Message-Id: <20221226071328.3895854-2-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221226071328.3895854-1-yoshihiro.shimoda.uh@renesas.com>
References: <20221226071328.3895854-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If rswitch_init() returns non-zero and this driver is re-probed,
the following error happens:

    renesas_eth_sw e6880000.ethernet: Unbalanced pm_runtime_enable!

So, fix error path in renesas_eth_sw_probe().

Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index e42ceaa0099f..473d86bdf97d 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1786,6 +1786,11 @@ static int renesas_eth_sw_probe(struct platform_device *pdev)
 	pm_runtime_get_sync(&pdev->dev);
 
 	ret = rswitch_init(priv);
+	if (ret < 0) {
+		pm_runtime_put(&pdev->dev);
+		pm_runtime_disable(&pdev->dev);
+		return ret;
+	}
 
 	device_set_wakeup_capable(&pdev->dev, 1);
 
-- 
2.25.1

