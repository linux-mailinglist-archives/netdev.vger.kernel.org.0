Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33502545AB2
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345973AbiFJDlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346004AbiFJDlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:41:10 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9C921C63F;
        Thu,  9 Jun 2022 20:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654832468; x=1686368468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VsECB4rGQ9AOMk/R4KLPANHo0BZNISsxKzENHkPxCnY=;
  b=FsB4SCXeH3L9nus1qvnoDC+pSskv9SlII+/NawZz5FUbXIRwC2orYWjf
   1IwQ8S0A5om9zjhpeFctZvwyiYdB3dKNd9kr2ZePTBl2uX5vAxtYYZxm/
   J4ly+8hSFcVeHnmD0sTmijBEItZx3l7tK1bQyT0LABxNgphujlDV+Q9Mc
   Z8PFNo6SD8SqQ8No6LLE9lFnLkBQmzCdVy/+wteULtGDIrRqJKS2xtnur
   M+n1l5IKZYqZr/2GbfNS1OrCZWvL6+pkzOzmnQvrOccDMVNK/GkvTBsVV
   aIjgrbX/L9qgliTWTNk0y3yuuh4njc48RpX/VHe4J1WtuRlr/g0GAK0Zj
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="278305257"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="278305257"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 20:41:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="827993991"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jun 2022 20:40:59 -0700
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
Subject: [PATCH net-next v3 5/7] net: phylink: unset ovr_an_inband if fixed-link is selected
Date:   Fri, 10 Jun 2022 11:36:08 +0800
Message-Id: <20220610033610.114084-6-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610033610.114084-1-boon.leong.ong@intel.com>
References: <20220610033610.114084-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If "fixed-link" DT or ACPI _DSD subnode is selected, it should take
precedence over the value of ovr_an_inband passed by MAC driver.

Fixes: ab39385021d1 ("net: phylink: make phylink_parse_mode() support non-DT platform")
Tested-by: Emilio Riva <emilio.riva@ericsson.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/phy/phylink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 066684b8091..566852815e0 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -609,8 +609,10 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 	const char *managed;
 
 	dn = fwnode_get_named_child_node(fwnode, "fixed-link");
-	if (dn || fwnode_property_present(fwnode, "fixed-link"))
+	if (dn || fwnode_property_present(fwnode, "fixed-link")) {
 		pl->cfg_link_an_mode = MLO_AN_FIXED;
+		pl->config->ovr_an_inband = false;
+	}
 	fwnode_handle_put(dn);
 
 	if ((fwnode_property_read_string(fwnode, "managed", &managed) == 0 &&
-- 
2.25.1

