Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0899A4EE0CE
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 20:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbiCaSnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 14:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbiCaSnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 14:43:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8501CCAE5;
        Thu, 31 Mar 2022 11:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFD4F6190F;
        Thu, 31 Mar 2022 18:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A55DC340EE;
        Thu, 31 Mar 2022 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648752121;
        bh=apXegdtOzccGlUHocXSkEnlmdQTp25CBf032C85g5YA=;
        h=From:To:Cc:Subject:Date:From;
        b=fXwOtDjGkScO7n004lp1NkBTHYI13itiw8bYiqKyHah5j4jB/PocxWaKBZoGOzpgi
         nQpNS4y5aaBOB+e3jEIFMF+7F07qa9JZQ9kimDaamTNpyFHUtBy4gIXjGAYOigfDuZ
         eYdvNCREQ3tqyJwrJ2KRmX2Sygtkf+/ExXPrdD2dwPTXo+TBbxuqeDJ4rFH1RXSJmp
         +mOk2WXx2h5OsmrNsRHszTztYLUUBbJ2wzjrU4ZQ010e6ecTR/zCO5BlLuCluud3Yz
         0SILu2LkAC85uRVVuvG2T2Rv3AQwaUYJVNVs3lrg7StW5HxRgALt/eW/UvcroBjFjA
         SLMqHHW/kIkCw==
Received: by wens.tw (Postfix, from userid 1000)
        id 378E25FC12; Fri,  1 Apr 2022 02:41:58 +0800 (CST)
From:   Chen-Yu Tsai <wens@kernel.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, Russell King <linux@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] net: stmmac: Fix unset max_speed difference between DT and non-DT platforms
Date:   Fri,  1 Apr 2022 02:41:45 +0800
Message-Id: <20220331184145.14242-1-wens@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

In commit 9cbadf094d9d ("net: stmmac: support max-speed device tree
property"), when DT platforms don't set "max-speed", max_speed is set to
-1; for non-DT platforms, it stays the default 0.

Prior to commit eeef2f6b9f6e ("net: stmmac: Start adding phylink support"),
the check for a valid max_speed setting was to check if it was greater
than zero. This commit got it right, but subsequent patches just checked
for non-zero, which is incorrect for DT platforms.

In commit 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
the conversion switched completely to checking for non-zero value as a
valid value, which caused 1000base-T to stop getting advertised by
default.

Instead of trying to fix all the checks, simply leave max_speed alone if
DT property parsing fails.

Fixes: 9cbadf094d9d ("net: stmmac: support max-speed device tree property")
Fixes: 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---

Resend: added Srinivas (author of first fixed commit) to CC list.

This was first noticed on ROC-RK3399-PC, and also observed on ROC-RK3328-CC.
The fix was tested on ROC-RK3328-CC and Libre Computer ALL-H5-ALL-CC.

 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 5d29f336315b..11e1055e8260 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -431,8 +431,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	plat->phylink_node = np;
 
 	/* Get max speed of operation from device tree */
-	if (of_property_read_u32(np, "max-speed", &plat->max_speed))
-		plat->max_speed = -1;
+	of_property_read_u32(np, "max-speed", &plat->max_speed);
 
 	plat->bus_id = of_alias_get_id(np, "ethernet");
 	if (plat->bus_id < 0)
-- 
2.34.1

