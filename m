Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1321F5E721A
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiIWCvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiIWCvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:51:42 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763711181EF;
        Thu, 22 Sep 2022 19:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663901501; x=1695437501;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZQz/Xqiy0IV+Q0g/GR2r1coFdoHv5TGeooo/qYyxhds=;
  b=jA3m2/bY5GmGw6JqUBwPJEbmuiMXDcbQdRel/gLz3uAhKy5fgn/gm0Rg
   jJ5gvRVEdNWSxKNQKkb+U6wrfwRhtDS7f0L1WEQPot30lwqYcU9GM8orb
   VAoOc8mB11/EYnSRUmvfuSpSgP57I5z4knTBtwUQE1qop5btEWaJUgdR6
   WFVDmFh7p6AXuuDWgmm0QXywzO4Br0VqN1DXikuzHv68EeU45i8UZkcZM
   UuSaM9a+68wJW/N3+mtcLi4v/zxEaelntGrHZ82mtjY0nV8pbvAF620wl
   MkQmVDhAigRETHQ03RUfXzRn1MruW8LemgBWt1GlL+QP1qjlLOFG0IRBq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="301373011"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="301373011"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 19:51:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="571221994"
Received: from junxiaochang.bj.intel.com ([10.238.135.52])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 19:51:36 -0700
From:   Junxiao Chang <junxiao.chang@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     junxiao.chang@intel.com, jimmyjs.chen@adlinktech.com,
        hong.aun.looi@intel.com
Subject: [net,v2] net: stmmac: power up/down serdes in stmmac_open/release
Date:   Fri, 23 Sep 2022 10:41:59 +0800
Message-Id: <20220923024200.1219634-1-junxiao.chang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes DMA engine reset timeout issue in suspend/resume
with ADLink I-Pi SMARC Plus board which dmesg shows:
...
[   54.678271] PM: suspend exit
[   54.754066] intel-eth-pci 0000:00:1d.2 enp0s29f2: PHY [stmmac-3:01] driver [Maxlinear Ethernet GPY215B] (irq=POLL)
[   54.755808] intel-eth-pci 0000:00:1d.2 enp0s29f2: Register MEM_TYPE_PAGE_POOL RxQ-0
...
[   54.780482] intel-eth-pci 0000:00:1d.2 enp0s29f2: Register MEM_TYPE_PAGE_POOL RxQ-7
[   55.784098] intel-eth-pci 0000:00:1d.2: Failed to reset the dma
[   55.784111] intel-eth-pci 0000:00:1d.2 enp0s29f2: stmmac_hw_setup: DMA engine initialization failed
[   55.784115] intel-eth-pci 0000:00:1d.2 enp0s29f2: stmmac_open: Hw setup failed
...

The issue is related with serdes which impacts clock.  There is
serdes in ADLink I-Pi SMARC board ethernet controller. Please refer to
commit b9663b7ca6ff78 ("net: stmmac: Enable SERDES power up/down sequence")
for detial. When issue is reproduced, DMA engine clock is not ready
because serdes is not powered up.

To reproduce DMA engine reset timeout issue with hardware which has
serdes in GBE controller, install Ubuntu. In Ubuntu GUI, click
"Power Off/Log Out" -> "Suspend" menu, it disables network interface,
then goes to sleep mode. When it wakes up, it enables network
interface again. Stmmac driver is called in this way:

1. stmmac_release: Stop network interface. In this function, it
   disables DMA engine and network interface;
2. stmmac_suspend: It is called in kernel suspend flow. But because
   network interface has been disabled(netif_running(ndev) is
   false), it does nothing and returns directly;
3. System goes into S3 or S0ix state. Some time later, system is
   waken up by keyboard or mouse;
4. stmmac_resume: It does nothing because network interface has
   been disabled;
5. stmmac_open: It is called to enable network interace again. DMA
   engine is initialized in this API, but serdes is not power on so
   there will be DMA engine reset timeout issue.

Similarly, serdes powerdown should be added in stmmac_release.
Network interface might be disabled by cmd "ifconfig eth0 down",
DMA engine, phy and mac have been disabled in ndo_stop callback,
serdes should be powered down as well. It doesn't make sense that
serdes is on while other components have been turned off.

If ethernet interface is in enabled state(netif_running(ndev) is true)
before suspend/resume, the issue couldn't be reproduced  because serdes
could be powered up in stmmac_resume.

Because serdes_powerup is added in stmmac_open, it doesn't need to be
called in probe function.

Fixes: b9663b7ca6ff78 ("net: stmmac: Enable SERDES power up/down sequence")
Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
Tested-by: Jimmy JS Chen <jimmyjs.chen@adlinktech.com>
Tested-by: Looi, Hong Aun <hong.aun.looi@intel.com>
---
v2: fixed 32 bits build issue and warning

 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 592d29abcb1c2..60adc33808191 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3801,6 +3801,15 @@ static int __stmmac_open(struct net_device *dev,
 
 	stmmac_reset_queues_param(priv);
 
+	if (priv->plat->serdes_powerup) {
+		ret = priv->plat->serdes_powerup(dev, priv->plat->bsp_priv);
+		if (ret < 0) {
+			netdev_err(priv->dev, "%s: Serdes powerup failed\n",
+					__func__);
+			goto init_error;
+		}
+	}
+
 	ret = stmmac_hw_setup(dev, true);
 	if (ret < 0) {
 		netdev_err(priv->dev, "%s: Hw setup failed\n", __func__);
@@ -3904,6 +3913,10 @@ static int stmmac_release(struct net_device *dev)
 	/* Disable the MAC Rx/Tx */
 	stmmac_mac_set(priv, priv->ioaddr, false);
 
+	/* Powerdown Serdes if there is */
+	if (priv->plat->serdes_powerdown)
+		priv->plat->serdes_powerdown(dev, priv->plat->bsp_priv);
+
 	netif_carrier_off(dev);
 
 	stmmac_release_ptp(priv);
@@ -7293,14 +7306,6 @@ int stmmac_dvr_probe(struct device *device,
 		goto error_netdev_register;
 	}
 
-	if (priv->plat->serdes_powerup) {
-		ret = priv->plat->serdes_powerup(ndev,
-						 priv->plat->bsp_priv);
-
-		if (ret < 0)
-			goto error_serdes_powerup;
-	}
-
 #ifdef CONFIG_DEBUG_FS
 	stmmac_init_fs(ndev);
 #endif
@@ -7315,8 +7320,6 @@ int stmmac_dvr_probe(struct device *device,
 
 	return ret;
 
-error_serdes_powerup:
-	unregister_netdev(ndev);
 error_netdev_register:
 	phylink_destroy(priv->phylink);
 error_xpcs_setup:
-- 
2.25.1

