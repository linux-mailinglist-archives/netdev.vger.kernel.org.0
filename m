Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D10E54A752
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 05:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352513AbiFNDFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 23:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348867AbiFNDFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 23:05:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0A229CAC;
        Mon, 13 Jun 2022 20:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655175912; x=1686711912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AO7NWdmA1E8wyzZ3AoQe7BdaShBWyUdh37nufgPzdq0=;
  b=e7nFAtiq7r4z3Y9fHFNQTex4wiZ5vduXCC6zDta24Ajld651F/ucMxD8
   RUydbHoOMAKwnnTqc3XvRDWf+lNFlXDshTscJlY6MgWS3pYmxZZtYhMUV
   b7M+d7kB8WqXCtqDJwNTuS3zf0JqP5r/wrk1u8BUT7TRuTsFBPc1hPgTc
   CYt0D1bAAfZHWKBBwIMK49JtR+1RiT/kJPgKnuDlV7FysKH6U3AEkkCRC
   ZY5qXZsk+C0ByOSzBBls3YIE7OuJMlX412EP4zXA4Q6Dpk6OiQhrqWnpp
   PxjjFQIvNjOHKNT7Mym+86wwym6JjDZNQJ6EZPiLWL6MgjxLfDVK2m0he
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="278518749"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="278518749"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 20:05:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="761787685"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by orsmga005.jf.intel.com with ESMTP; 13 Jun 2022 20:05:07 -0700
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
Subject: [PATCH net-next v4 1/5] net: make xpcs_do_config to accept advertising for pcs-xpcs and sja1105
Date:   Tue, 14 Jun 2022 11:00:26 +0800
Message-Id: <20220614030030.1249850-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220614030030.1249850-1-boon.leong.ong@intel.com>
References: <20220614030030.1249850-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

