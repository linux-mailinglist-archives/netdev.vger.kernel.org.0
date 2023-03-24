Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5CE6C797B
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 09:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjCXIRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 04:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjCXIRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 04:17:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6CE24705;
        Fri, 24 Mar 2023 01:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679645861; x=1711181861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7zEf318EIZQVC7Yb173ekmxTq+Dw6hKeKqmHqTYHp78=;
  b=XWlX2aiI0mu0vuIvgxk4TtNpg2rHKvr4Q+kzU4EN3TLENUqAFATZjKbV
   3fbSq8vGcH9X8xyfqdUcxBvyuzPK7SCk2zi/gKjET++dxAGok4zXoKWVu
   +WV3vv7lej0JvAw79oktNnTHLw85XPd4oDI6a492wp10YgJAf+miSdIKm
   L0zeu/jwFvpbjORv2bV6gSwIQ0K5IyjHsCKrctgSP43eJiuZRUPS9Geaj
   ubV5yh1o4KHwu/ifawz+nGCXu1dFrSUEyBnw3vqCV8/PMWBYxVmhULFuE
   qbDeHStI+1hRmJ0wXH7PCMrFDemOBW6otyN9DaPQS5rgGUUD8mRrVsbFK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="320116081"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="320116081"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 01:17:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="928574701"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="928574701"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by fmsmga006.fm.intel.com with ESMTP; 24 Mar 2023 01:17:37 -0700
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
        linux@armlinux.org.uk
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: [PATCH net v3 1/3] net: phylink: add phylink_expects_phy() method
Date:   Fri, 24 Mar 2023 16:16:54 +0800
Message-Id: <20230324081656.2969663-2-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324081656.2969663-1-michael.wei.hong.sit@intel.com>
References: <20230324081656.2969663-1-michael.wei.hong.sit@intel.com>
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
 drivers/net/phy/phylink.c | 13 +++++++++++++
 include/linux/phylink.h   |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1a2f074685fa..5c2bd1370993 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1586,6 +1586,19 @@ void phylink_destroy(struct phylink *pl)
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
+	return pl->cfg_link_an_mode != MLO_AN_FIXED;
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

