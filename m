Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571F654C3D1
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343883AbiFOIob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347073AbiFOIn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:43:59 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4B642492;
        Wed, 15 Jun 2022 01:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655282638; x=1686818638;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AO7NWdmA1E8wyzZ3AoQe7BdaShBWyUdh37nufgPzdq0=;
  b=MNazHUZvUvPo08ZTAr7y2eDwAvPLN91CPlbuBZ0xMPW3N00ia5ITwQD/
   Cobf3TRd0m2Lz/J9+b1Lk/iRqtTwEXNPQyC39nQC521uvSeIhzpKjnnLG
   ropSqXHfmREuFXuJNF3iDADPF9xqHl3DNjoJTX3sl/heuaEdIPXvtpu6q
   LqoM8W4Dex35XQErlr42PSrICoB07j+YQAgBDHVU/JUJRoAPUeaDN1F5m
   PakVKKLuU0yvcd37N6o5xqwwP456z9dDqzv6Af7CN2XPNNVa87BcR/j+c
   /LZcHfDUtwzxd7uX653Jqt2N+JSnmNm+PRIAVu6/BNajPTm91MRw4MOgN
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="277676311"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="277676311"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 01:43:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="712849357"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by orsmga004.jf.intel.com with ESMTP; 15 Jun 2022 01:43:54 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v5 1/5] net: make xpcs_do_config to accept advertising for pcs-xpcs and sja1105
Date:   Wed, 15 Jun 2022 16:39:04 +0800
Message-Id: <20220615083908.1651975-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220615083908.1651975-1-boon.leong.ong@intel.com>
References: <20220615083908.1651975-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xpcs_config() has 'advertising' input that is required for C37 1000BASE-X
AN in later patch series. So, we prepare xpcs_do_config() for it.

For sja1105, xpcs_do_config() is used for xpcs configuration without
depending on advertising input, so set to NULL.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 drivers/net/pcs/pcs-xpcs.c             | 6 +++---
 include/linux/pcs/pcs-xpcs.h           | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 72b6fc1932b..b253e27bcfb 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2330,7 +2330,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		else
 			mode = MLO_AN_PHY;
 
-		rc = xpcs_do_config(xpcs, priv->phy_mode[i], mode);
+		rc = xpcs_do_config(xpcs, priv->phy_mode[i], mode, NULL);
 		if (rc < 0)
 			goto out;
 
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 4cfd05c15ae..48d81c40aab 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -795,7 +795,7 @@ static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
 }
 
 int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
-		   unsigned int mode)
+		   unsigned int mode, const unsigned long *advertising)
 {
 	const struct xpcs_compat *compat;
 	int ret;
@@ -843,7 +843,7 @@ static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
 {
 	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
 
-	return xpcs_do_config(xpcs, interface, mode);
+	return xpcs_do_config(xpcs, interface, mode, advertising);
 }
 
 static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
@@ -864,7 +864,7 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 
 		state->link = 0;
 
-		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND);
+		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND, NULL);
 	}
 
 	if (state->an_enabled && xpcs_aneg_done_c73(xpcs, state, compat)) {
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 266eb26fb02..37eb97cc228 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -30,7 +30,7 @@ int xpcs_get_an_mode(struct dw_xpcs *xpcs, phy_interface_t interface);
 void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		  phy_interface_t interface, int speed, int duplex);
 int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
-		   unsigned int mode);
+		   unsigned int mode, const unsigned long *advertising);
 void xpcs_get_interfaces(struct dw_xpcs *xpcs, unsigned long *interfaces);
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
 		    int enable);
-- 
2.25.1

