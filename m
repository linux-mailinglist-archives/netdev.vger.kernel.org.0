Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C2B6CFEA1
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjC3IlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjC3IlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:41:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A6E7683;
        Thu, 30 Mar 2023 01:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680165657; x=1711701657;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0DOTY4ZPGFZaHY/uWfGDuMYUQdXHlRV5Muct6oWwU3o=;
  b=H18LoIdyq7eMgWshI/xN15aFm3jl8yB4ZcbFMS/F67EkGkFfY7sAkA/1
   ZqnTp2arjgaZDUgaGv5s0LR2sDZZZKgJS5cb/poLiPXhchS7FZPVtfYOm
   kpjX2L3ZyQTbMAuVmtvKSX/NtFv9UYS73vd1NxrD0YivkEVNvkQK/zno0
   rAfwWxtxS1XLblux/SYk53HR0gLr9lyCKmILLi+m+iJOTB8oWcOfY1X/Y
   KMm4sR6uNF/FFUMobVFgOW9LOjLoyDOB/0V/S9+tCWkXYxrD7+6wVoHpF
   O4h30ixxF/zqUzLLShvdhhKk5Y+9VIGBNTSK8S4yEskePJbbuLdlCfqSu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="343559394"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="343559394"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 01:40:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="684618816"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="684618816"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga002.jf.intel.com with ESMTP; 30 Mar 2023 01:40:52 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: [PATCH net v4 1/3] net: phylink: add phylink_expects_phy() method
Date:   Thu, 30 Mar 2023 16:39:58 +0800
Message-Id: <20230330084000.3292487-2-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330084000.3292487-1-michael.wei.hong.sit@intel.com>
References: <20230330084000.3292487-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide phylink_expects_phy() to allow MAC drivers to check if it
is expecting a PHY to attach to. Since fixed-linked setups do not
need to attach to a PHY.

Provides a boolean value as to if the MAC should expect a PHY.
returns true if a PHY is expected.

Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 drivers/net/phy/phylink.c | 17 +++++++++++++++++
 include/linux/phylink.h   |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1a2f074685fa..4c080656e280 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1586,6 +1586,23 @@ void phylink_destroy(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_destroy);
 
+/**
+ * phylink_expects_phy() - Determine if phylink expects a phy to be attached
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * Fixed-link mode does not need a PHY, returns a boolean value to check if
+ * phylink will be expecting a PHY to attach.
+ */
+bool phylink_expects_phy(struct phylink *pl)
+{
+	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
+	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
+	     phy_interface_mode_is_8023z(pl->link_config.interface)))
+		return false;
+	return true;
+}
+EXPORT_SYMBOL_GPL(phylink_expects_phy);
+
 static void phylink_phy_change(struct phy_device *phydev, bool up)
 {
 	struct phylink *pl = phydev->phylink;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index c492c26202b5..637698ed5cb6 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -574,6 +574,7 @@ struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
 			       phy_interface_t iface,
 			       const struct phylink_mac_ops *mac_ops);
 void phylink_destroy(struct phylink *);
+bool phylink_expects_phy(struct phylink *pl);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
-- 
2.34.1

