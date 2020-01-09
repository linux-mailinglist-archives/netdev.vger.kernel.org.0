Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC03135D08
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732481AbgAIPoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:44:10 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:49128 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728098AbgAIPoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:44:10 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5B85B4C005C;
        Thu,  9 Jan 2020 15:44:08 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 Jan 2020 15:44:03 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 2/9] sfc: move some MCDI port utility functions
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Message-ID: <650c26b9-50aa-770d-807f-76624b5e3795@solarflare.com>
Date:   Thu, 9 Jan 2020 15:43:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25156.003
X-TM-AS-Result: No-8.474700-8.000000-10
X-TMASE-MatchedRID: ZYIaf++Xw0HWJ0QHHhBxzfRUId35VCIeoae+ev6zOlJjLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8Jdw5T4Iaj538mJZXQNDzktSGjzBgnFZvQ6nZS/aYgjrzlIxScKXZnK0fxu
        fjwI9BUvx0jLr9FmWFYVD+y1T8ETgvfQtoT+WkuRSW7+rBmR2Kswx7VbZgGmKCXjDiV/HPZyDuU
        30s68UOye5LrMlxEslGaDtM+KUWfUBEbXlE6vL9yqwx8x+s5lF9e5am3m57X1re4AoC7Yi5v9zU
        rAq0MIuE9MlYybyBQ0PPiy29YUtpcWWHrBmpJLreWgJLNowHdXYcHWTGnsBJLZ25/Upg4v8kaaU
        Pq8HDk/kHlsOklG/XN03wn5UzKR7dlbQL6bxKiF2GcWKGZufBYY+g3uPA6ifRjNrjV0arFJJcBX
        vKYkUg2yyVMXexFFqkZOl7WKIImpvmJzqtHKHjwtuKBGekqUpbGVEmIfjf3t5lftzKiovtlvBNu
        OsRxX5bK5mEiqokgVlFM4MI8j4yKA/178Pel+o
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.474700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25156.003
X-MDID: 1578584649-RQbHXS5Mmx1c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

They just convert between different sets of flags/registers.
Some block comments were adjusted.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_port.c        | 148 --------------------
 drivers/net/ethernet/sfc/mcdi_port_common.c | 148 ++++++++++++++++++++
 2 files changed, 148 insertions(+), 148 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index 109c86dd130d..d811753782dc 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -69,154 +69,6 @@ static int efx_mcdi_mdio_write(struct net_device *net_dev,
 	return 0;
 }
 
-u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
-{
-	u32 result = 0;
-
-	#define TEST_BIT(name)	test_bit(ETHTOOL_LINK_MODE_ ## name ## _BIT, \
-					 linkset)
-
-	if (TEST_BIT(10baseT_Half))
-		result |= (1 << MC_CMD_PHY_CAP_10HDX_LBN);
-	if (TEST_BIT(10baseT_Full))
-		result |= (1 << MC_CMD_PHY_CAP_10FDX_LBN);
-	if (TEST_BIT(100baseT_Half))
-		result |= (1 << MC_CMD_PHY_CAP_100HDX_LBN);
-	if (TEST_BIT(100baseT_Full))
-		result |= (1 << MC_CMD_PHY_CAP_100FDX_LBN);
-	if (TEST_BIT(1000baseT_Half))
-		result |= (1 << MC_CMD_PHY_CAP_1000HDX_LBN);
-	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full))
-		result |= (1 << MC_CMD_PHY_CAP_1000FDX_LBN);
-	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full))
-		result |= (1 << MC_CMD_PHY_CAP_10000FDX_LBN);
-	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full))
-		result |= (1 << MC_CMD_PHY_CAP_40000FDX_LBN);
-	if (TEST_BIT(100000baseCR4_Full))
-		result |= (1 << MC_CMD_PHY_CAP_100000FDX_LBN);
-	if (TEST_BIT(25000baseCR_Full))
-		result |= (1 << MC_CMD_PHY_CAP_25000FDX_LBN);
-	if (TEST_BIT(50000baseCR2_Full))
-		result |= (1 << MC_CMD_PHY_CAP_50000FDX_LBN);
-	if (TEST_BIT(Pause))
-		result |= (1 << MC_CMD_PHY_CAP_PAUSE_LBN);
-	if (TEST_BIT(Asym_Pause))
-		result |= (1 << MC_CMD_PHY_CAP_ASYM_LBN);
-	if (TEST_BIT(Autoneg))
-		result |= (1 << MC_CMD_PHY_CAP_AN_LBN);
-
-	#undef TEST_BIT
-
-	return result;
-}
-
-u32 efx_get_mcdi_phy_flags(struct efx_nic *efx)
-{
-	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
-	enum efx_phy_mode mode, supported;
-	u32 flags;
-
-	/* TODO: Advertise the capabilities supported by this PHY */
-	supported = 0;
-	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_TXDIS_LBN))
-		supported |= PHY_MODE_TX_DISABLED;
-	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_LOWPOWER_LBN))
-		supported |= PHY_MODE_LOW_POWER;
-	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_POWEROFF_LBN))
-		supported |= PHY_MODE_OFF;
-
-	mode = efx->phy_mode & supported;
-
-	flags = 0;
-	if (mode & PHY_MODE_TX_DISABLED)
-		flags |= (1 << MC_CMD_SET_LINK_IN_TXDIS_LBN);
-	if (mode & PHY_MODE_LOW_POWER)
-		flags |= (1 << MC_CMD_SET_LINK_IN_LOWPOWER_LBN);
-	if (mode & PHY_MODE_OFF)
-		flags |= (1 << MC_CMD_SET_LINK_IN_POWEROFF_LBN);
-
-	return flags;
-}
-
-u8 mcdi_to_ethtool_media(u32 media)
-{
-	switch (media) {
-	case MC_CMD_MEDIA_XAUI:
-	case MC_CMD_MEDIA_CX4:
-	case MC_CMD_MEDIA_KX4:
-		return PORT_OTHER;
-
-	case MC_CMD_MEDIA_XFP:
-	case MC_CMD_MEDIA_SFP_PLUS:
-	case MC_CMD_MEDIA_QSFP_PLUS:
-		return PORT_FIBRE;
-
-	case MC_CMD_MEDIA_BASE_T:
-		return PORT_TP;
-
-	default:
-		return PORT_OTHER;
-	}
-}
-
-/* The semantics of the ethtool FEC mode bitmask are not well defined,
- * particularly the meaning of combinations of bits.  Which means we get to
- * define our own semantics, as follows:
- * OFF overrides any other bits, and means "disable all FEC" (with the
- * exception of 25G KR4/CR4, where it is not possible to reject it if AN
- * partner requests it).
- * AUTO on its own means use cable requirements and link partner autoneg with
- * fw-default preferences for the cable type.
- * AUTO and either RS or BASER means use the specified FEC type if cable and
- * link partner support it, otherwise autoneg/fw-default.
- * RS or BASER alone means use the specified FEC type if cable and link partner
- * support it and either requests it, otherwise no FEC.
- * Both RS and BASER (whether AUTO or not) means use FEC if cable and link
- * partner support it, preferring RS to BASER.
- */
-u32 ethtool_fec_caps_to_mcdi(u32 ethtool_cap)
-{
-	u32 ret = 0;
-
-	if (ethtool_cap & ETHTOOL_FEC_OFF)
-		return 0;
-
-	if (ethtool_cap & ETHTOOL_FEC_AUTO)
-		ret |= (1 << MC_CMD_PHY_CAP_BASER_FEC_LBN) |
-		       (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_LBN) |
-		       (1 << MC_CMD_PHY_CAP_RS_FEC_LBN);
-	if (ethtool_cap & ETHTOOL_FEC_RS)
-		ret |= (1 << MC_CMD_PHY_CAP_RS_FEC_LBN) |
-		       (1 << MC_CMD_PHY_CAP_RS_FEC_REQUESTED_LBN);
-	if (ethtool_cap & ETHTOOL_FEC_BASER)
-		ret |= (1 << MC_CMD_PHY_CAP_BASER_FEC_LBN) |
-		       (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_LBN) |
-		       (1 << MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_LBN) |
-		       (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_LBN);
-	return ret;
-}
-
-/* Invert ethtool_fec_caps_to_mcdi.  There are two combinations that function
- * can never produce, (baser xor rs) and neither req; the implementation below
- * maps both of those to AUTO.  This should never matter, and it's not clear
- * what a better mapping would be anyway.
- */
-u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g)
-{
-	bool rs = caps & (1 << MC_CMD_PHY_CAP_RS_FEC_LBN),
-	     rs_req = caps & (1 << MC_CMD_PHY_CAP_RS_FEC_REQUESTED_LBN),
-	     baser = is_25g ? caps & (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_LBN)
-			    : caps & (1 << MC_CMD_PHY_CAP_BASER_FEC_LBN),
-	     baser_req = is_25g ? caps & (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_LBN)
-				: caps & (1 << MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_LBN);
-
-	if (!baser && !rs)
-		return ETHTOOL_FEC_OFF;
-	return (rs_req ? ETHTOOL_FEC_RS : 0) |
-	       (baser_req ? ETHTOOL_FEC_BASER : 0) |
-	       (baser == baser_req && rs == rs_req ? 0 : ETHTOOL_FEC_AUTO);
-}
-
 static int efx_mcdi_phy_probe(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_data;
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 0ba7b5a47d99..9763d59f7681 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -173,6 +173,96 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
 	#undef SET_BIT
 }
 
+u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
+{
+	u32 result = 0;
+
+	#define TEST_BIT(name)	test_bit(ETHTOOL_LINK_MODE_ ## name ## _BIT, \
+					 linkset)
+
+	if (TEST_BIT(10baseT_Half))
+		result |= (1 << MC_CMD_PHY_CAP_10HDX_LBN);
+	if (TEST_BIT(10baseT_Full))
+		result |= (1 << MC_CMD_PHY_CAP_10FDX_LBN);
+	if (TEST_BIT(100baseT_Half))
+		result |= (1 << MC_CMD_PHY_CAP_100HDX_LBN);
+	if (TEST_BIT(100baseT_Full))
+		result |= (1 << MC_CMD_PHY_CAP_100FDX_LBN);
+	if (TEST_BIT(1000baseT_Half))
+		result |= (1 << MC_CMD_PHY_CAP_1000HDX_LBN);
+	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full))
+		result |= (1 << MC_CMD_PHY_CAP_1000FDX_LBN);
+	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full))
+		result |= (1 << MC_CMD_PHY_CAP_10000FDX_LBN);
+	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full))
+		result |= (1 << MC_CMD_PHY_CAP_40000FDX_LBN);
+	if (TEST_BIT(100000baseCR4_Full))
+		result |= (1 << MC_CMD_PHY_CAP_100000FDX_LBN);
+	if (TEST_BIT(25000baseCR_Full))
+		result |= (1 << MC_CMD_PHY_CAP_25000FDX_LBN);
+	if (TEST_BIT(50000baseCR2_Full))
+		result |= (1 << MC_CMD_PHY_CAP_50000FDX_LBN);
+	if (TEST_BIT(Pause))
+		result |= (1 << MC_CMD_PHY_CAP_PAUSE_LBN);
+	if (TEST_BIT(Asym_Pause))
+		result |= (1 << MC_CMD_PHY_CAP_ASYM_LBN);
+	if (TEST_BIT(Autoneg))
+		result |= (1 << MC_CMD_PHY_CAP_AN_LBN);
+
+	#undef TEST_BIT
+
+	return result;
+}
+
+u32 efx_get_mcdi_phy_flags(struct efx_nic *efx)
+{
+	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
+	enum efx_phy_mode mode, supported;
+	u32 flags;
+
+	/* TODO: Advertise the capabilities supported by this PHY */
+	supported = 0;
+	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_TXDIS_LBN))
+		supported |= PHY_MODE_TX_DISABLED;
+	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_LOWPOWER_LBN))
+		supported |= PHY_MODE_LOW_POWER;
+	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_POWEROFF_LBN))
+		supported |= PHY_MODE_OFF;
+
+	mode = efx->phy_mode & supported;
+
+	flags = 0;
+	if (mode & PHY_MODE_TX_DISABLED)
+		flags |= (1 << MC_CMD_SET_LINK_IN_TXDIS_LBN);
+	if (mode & PHY_MODE_LOW_POWER)
+		flags |= (1 << MC_CMD_SET_LINK_IN_LOWPOWER_LBN);
+	if (mode & PHY_MODE_OFF)
+		flags |= (1 << MC_CMD_SET_LINK_IN_POWEROFF_LBN);
+
+	return flags;
+}
+
+u8 mcdi_to_ethtool_media(u32 media)
+{
+	switch (media) {
+	case MC_CMD_MEDIA_XAUI:
+	case MC_CMD_MEDIA_CX4:
+	case MC_CMD_MEDIA_KX4:
+		return PORT_OTHER;
+
+	case MC_CMD_MEDIA_XFP:
+	case MC_CMD_MEDIA_SFP_PLUS:
+	case MC_CMD_MEDIA_QSFP_PLUS:
+		return PORT_FIBRE;
+
+	case MC_CMD_MEDIA_BASE_T:
+		return PORT_TP;
+
+	default:
+		return PORT_OTHER;
+	}
+}
+
 void efx_mcdi_phy_decode_link(struct efx_nic *efx,
 			      struct efx_link_state *link_state,
 			      u32 speed, u32 flags, u32 fcntl)
@@ -200,3 +290,61 @@ void efx_mcdi_phy_decode_link(struct efx_nic *efx,
 	link_state->fd = !!(flags & (1 << MC_CMD_GET_LINK_OUT_FULL_DUPLEX_LBN));
 	link_state->speed = speed;
 }
+
+/* The semantics of the ethtool FEC mode bitmask are not well defined,
+ * particularly the meaning of combinations of bits.  Which means we get to
+ * define our own semantics, as follows:
+ * OFF overrides any other bits, and means "disable all FEC" (with the
+ * exception of 25G KR4/CR4, where it is not possible to reject it if AN
+ * partner requests it).
+ * AUTO on its own means use cable requirements and link partner autoneg with
+ * fw-default preferences for the cable type.
+ * AUTO and either RS or BASER means use the specified FEC type if cable and
+ * link partner support it, otherwise autoneg/fw-default.
+ * RS or BASER alone means use the specified FEC type if cable and link partner
+ * support it and either requests it, otherwise no FEC.
+ * Both RS and BASER (whether AUTO or not) means use FEC if cable and link
+ * partner support it, preferring RS to BASER.
+ */
+u32 ethtool_fec_caps_to_mcdi(u32 ethtool_cap)
+{
+	u32 ret = 0;
+
+	if (ethtool_cap & ETHTOOL_FEC_OFF)
+		return 0;
+
+	if (ethtool_cap & ETHTOOL_FEC_AUTO)
+		ret |= (1 << MC_CMD_PHY_CAP_BASER_FEC_LBN) |
+		       (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_LBN) |
+		       (1 << MC_CMD_PHY_CAP_RS_FEC_LBN);
+	if (ethtool_cap & ETHTOOL_FEC_RS)
+		ret |= (1 << MC_CMD_PHY_CAP_RS_FEC_LBN) |
+		       (1 << MC_CMD_PHY_CAP_RS_FEC_REQUESTED_LBN);
+	if (ethtool_cap & ETHTOOL_FEC_BASER)
+		ret |= (1 << MC_CMD_PHY_CAP_BASER_FEC_LBN) |
+		       (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_LBN) |
+		       (1 << MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_LBN) |
+		       (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_LBN);
+	return ret;
+}
+
+/* Invert ethtool_fec_caps_to_mcdi.  There are two combinations that function
+ * can never produce, (baser xor rs) and neither req; the implementation below
+ * maps both of those to AUTO.  This should never matter, and it's not clear
+ * what a better mapping would be anyway.
+ */
+u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g)
+{
+	bool rs = caps & (1 << MC_CMD_PHY_CAP_RS_FEC_LBN),
+	     rs_req = caps & (1 << MC_CMD_PHY_CAP_RS_FEC_REQUESTED_LBN),
+	     baser = is_25g ? caps & (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_LBN)
+			    : caps & (1 << MC_CMD_PHY_CAP_BASER_FEC_LBN),
+	     baser_req = is_25g ? caps & (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_LBN)
+				: caps & (1 << MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_LBN);
+
+	if (!baser && !rs)
+		return ETHTOOL_FEC_OFF;
+	return (rs_req ? ETHTOOL_FEC_RS : 0) |
+	       (baser_req ? ETHTOOL_FEC_BASER : 0) |
+	       (baser == baser_req && rs == rs_req ? 0 : ETHTOOL_FEC_AUTO);
+}
-- 
2.20.1


