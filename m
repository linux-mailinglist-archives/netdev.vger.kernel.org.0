Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26BA33AAD2
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 06:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCOFYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 01:24:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:59451 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhCOFXm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 01:23:42 -0400
IronPort-SDR: ESNBWn/S7rvMVVmS3To3h3iEPV6F1F9OzP25VqADlEhdG5vh7AHFW194cKTBVKyz1ISaPmG3Dy
 iinlTauyA6Dg==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="253054427"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="253054427"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 22:23:42 -0700
IronPort-SDR: ZQekACZLCCbayptBTtxJY464w9G+pFikbNcAw6O5O/v7WBuvbeKoaKqvSJoV3Uv+KiIpKxg/nG
 AgjvyHCkZBWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="373313769"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga006.jf.intel.com with ESMTP; 14 Mar 2021 22:23:38 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King i <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: [PATCH net-next 3/6] net: phylink: make phylink_parse_mode() support non-DT platform
Date:   Mon, 15 Mar 2021 13:27:08 +0800
Message-Id: <20210315052711.16728-4-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315052711.16728-1-boon.leong.ong@intel.com>
References: <20210315052711.16728-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain platform does not support DT, so we make phylink_parse_mode() to
allow non-DT platform to use it to setup in-band AN advertising.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/phy/phylink.c | 5 +++--
 include/linux/phylink.h   | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index dc2800beacc3..96d8e88b4e46 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -271,8 +271,9 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 		pl->cfg_link_an_mode = MLO_AN_FIXED;
 	fwnode_handle_put(dn);
 
-	if (fwnode_property_read_string(fwnode, "managed", &managed) == 0 &&
-	    strcmp(managed, "in-band-status") == 0) {
+	if ((fwnode_property_read_string(fwnode, "managed", &managed) == 0 &&
+	     strcmp(managed, "in-band-status") == 0) ||
+	    pl->config->ovr_an_inband) {
 		if (pl->cfg_link_an_mode == MLO_AN_FIXED) {
 			phylink_err(pl,
 				    "can't use both fixed-link and in-band-status\n");
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index d81a714cfbbd..fd2acfd9b597 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -64,6 +64,7 @@ enum phylink_op_type {
  * @pcs_poll: MAC PCS cannot provide link change interrupt
  * @poll_fixed_state: if true, starts link_poll,
  *		      if MAC link is at %MLO_AN_FIXED mode.
+ * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
  * @get_fixed_state: callback to execute to determine the fixed link state,
  *		     if MAC link is at %MLO_AN_FIXED mode.
  */
@@ -72,6 +73,7 @@ struct phylink_config {
 	enum phylink_op_type type;
 	bool pcs_poll;
 	bool poll_fixed_state;
+	bool ovr_an_inband;
 	void (*get_fixed_state)(struct phylink_config *config,
 				struct phylink_link_state *state);
 };
-- 
2.25.1

