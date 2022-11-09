Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B920F622247
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiKICyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKICyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:54:14 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746A521274;
        Tue,  8 Nov 2022 18:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667962453; x=1699498453;
  h=from:to:cc:subject:date:message-id;
  bh=LcPwnMOvNXd8EfDVDs6NwQk1HFjCWGuocIdZbaknvaM=;
  b=KqJgOgMrUVAPvie08Usgwoa+Upx1E7SFpalm2CdOj9Q52ftjgnEFHd6O
   Md7HGhNn0/i8ZYGfQvsaSdzW3dlE95KUJuHMzwjPw4y6ZAfC7B6IM4wx9
   r0IONYFrBAbH+XQu5YcymB80GAJEcId0uklrQWKX097WqElTAzsmmZu7h
   JUT7/mQzUnvcXBal6hOCkHg++RamvxNMVjVPNwsOii1ncYBLB2Tt073lv
   y9p4cwI/hq6ICj6bEBm/nUgsBkbhxRlJP/7dU4+uNAO3RBpVHs5L8Yfaz
   IbbKVnksjflZpRQKpQCirND1NhWUaXL9YluQproQRWPwcCW0uXCrS9ujg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="290589531"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="290589531"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 18:54:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="669789208"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="669789208"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 08 Nov 2022 18:54:12 -0800
Received: from noorazur1-iLBPG12.png.intel.com (noorazur1-iLBPG12.png.intel.com [10.88.229.87])
        by linux.intel.com (Postfix) with ESMTP id 25A0F580AE3;
        Tue,  8 Nov 2022 18:54:08 -0800 (PST)
From:   Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Subject: [PATCH net 1/1] net: stmmac: add check for supported link mode before mode change
Date:   Wed,  9 Nov 2022 10:43:29 +0800
Message-Id: <20221109024329.15805-1-noor.azura.ahmad.tarmizi@linux.intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.0 required=5.0 tests=AC_FROM_MANY_DOTS,AD_PREFS,
        BAYES_00,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>

Currently, change for unsupported speed and duplex are sent to the phy,
rendering the link to unknown speed (link state down). Plus, advertising
settings are also passed down directly to the phy. Additional test is
now added to compare new speed and duplex settings and advertising
against current supported settings by attached phy.
Non-supported new settings(speed/duplex and advertising) will be rejected.

Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c  | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index f453b0d09366..d40cf7908eaa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -390,6 +390,21 @@ stmmac_ethtool_set_link_ksettings(struct net_device *dev,
 				  const struct ethtool_link_ksettings *cmd)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	struct ethtool_link_ksettings link_ks = {};
+
+	/* Get the current link settings */
+	stmmac_ethtool_get_link_ksettings(dev, &link_ks);
+
+	/* Check if the speed and duplex are supported by phy */
+	if (!phy_lookup_setting(cmd->base.speed, cmd->base.duplex,
+				link_ks.link_modes.supported, true))
+		return -EINVAL;
+
+	/* Check if the advertising request is supported */
+	if (!bitmap_subset(cmd->link_modes.advertising,
+			   link_ks.link_modes.supported,
+			   __ETHTOOL_LINK_MODE_MASK_NBITS))
+		return -EINVAL;
 
 	if (priv->hw->pcs & STMMAC_PCS_RGMII ||
 	    priv->hw->pcs & STMMAC_PCS_SGMII) {
-- 
2.17.1

