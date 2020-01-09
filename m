Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1EF135D06
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbgAIPnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:43:55 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:46920 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728098AbgAIPnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:43:55 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0A1AA6C0082;
        Thu,  9 Jan 2020 15:43:53 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 Jan 2020 15:43:47 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 1/9] sfc: move some port link state/caps code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Message-ID: <63f85bb7-8478-7cf3-47d0-4d9ca021cc61@solarflare.com>
Date:   Thu, 9 Jan 2020 15:43:44 +0000
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
X-TM-AS-Result: No-6.343700-8.000000-10
X-TMASE-MatchedRID: wYWDuyoGXLv2up/bgDqTK7sHVDDM5xAP1JP9NndNOkUGmHr1eMxt2YB5
        w6KBECW1rdoLblq9S5p1WMYsMQ0A8fETe0ikDYzDR/j040fRFpJ/64NkLyMdNz+FxPbxImzyeKa
        jvO6uWnCTIGXbawTUhOosEgojljL9iIhN85unxJiiAZ3zAhQYgvngX/aL8PCNkY8eITaSJPjAIU
        VZS3IBHRKAD2eO+eGCYGbK/yKDPZrx1sgenrSpRL6EJGSqPePTa01mhnn7t6QELMPQNzyJSyHDH
        4fzgwJ+gzRQj/CwzH53Q6f+WWfNdEs3SiaAjbkffjUCBXbhed8v+qWvWMTZMenCWuVnysVgFPua
        hfa4tRWZscqkHvlEqLbV21zZqHPZScc3TMVaAva3D7EeeyZCM0loPruIq9jTv5ndmnZN3UQ/yCf
        99zBqMb/YkCk00rZtRT0ctbI6uxy9b+2IefOhtLu9iqQJLR0vqV3VmuIFNEsIPuuOlevAyoXdqP
        s1B/zd4vM1YF6AJbZcLc3sLtjOt42j49Ftap9EOwBXM346/+wKAemqhzdA2MxVpq44CoNXYIHAN
        IPdszrPnIVM3CxvZlI5WR4xCx0f
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.343700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25156.003
X-MDID: 1578584633-sJDb1bmKJFOy
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The moved code handles MCDI port link state and capabilities.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/Makefile           |   2 +-
 drivers/net/ethernet/sfc/efx.c              |  15 --
 drivers/net/ethernet/sfc/mcdi_port.c        | 180 +----------------
 drivers/net/ethernet/sfc/mcdi_port_common.c | 202 ++++++++++++++++++++
 4 files changed, 204 insertions(+), 195 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mcdi_port_common.c

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 40a54df34647..f6d4b2b2dd83 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -3,7 +3,7 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   farch.o siena.o ef10.o \
 			   tx.o tx_common.o rx.o rx_common.o \
 			   selftest.o ethtool.o ptp.o tx_tso.o \
-			   mcdi.o mcdi_port.o \
+			   mcdi.o mcdi_port.o mcdi_port_common.o \
 			   mcdi_mon.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o siena_sriov.o ef10_sriov.o
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 655424e83d97..33b6ed03b3ea 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -134,21 +134,6 @@ static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
  *
  **************************************************************************/
 
-void efx_link_set_advertising(struct efx_nic *efx,
-			      const unsigned long *advertising)
-{
-	memcpy(efx->link_advertising, advertising,
-	       sizeof(__ETHTOOL_DECLARE_LINK_MODE_MASK()));
-
-	efx->link_advertising[0] |= ADVERTISED_Autoneg;
-	if (advertising[0] & ADVERTISED_Pause)
-		efx->wanted_fc |= (EFX_FC_TX | EFX_FC_RX);
-	else
-		efx->wanted_fc &= ~(EFX_FC_TX | EFX_FC_RX);
-	if (advertising[0] & ADVERTISED_Asym_Pause)
-		efx->wanted_fc ^= EFX_FC_TX;
-}
-
 /* Equivalent to efx_link_set_advertising with all-zeroes, except does not
  * force the Autoneg bit on.
  */
diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index f19d7b8a2935..109c86dd130d 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -16,91 +16,6 @@
 #include "selftest.h"
 #include "mcdi_port_common.h"
 
-int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg)
-{
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_CFG_OUT_LEN);
-	size_t outlen;
-	int rc;
-
-	BUILD_BUG_ON(MC_CMD_GET_PHY_CFG_IN_LEN != 0);
-	BUILD_BUG_ON(MC_CMD_GET_PHY_CFG_OUT_NAME_LEN != sizeof(cfg->name));
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_PHY_CFG, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
-	if (rc)
-		goto fail;
-
-	if (outlen < MC_CMD_GET_PHY_CFG_OUT_LEN) {
-		rc = -EIO;
-		goto fail;
-	}
-
-	cfg->flags = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_FLAGS);
-	cfg->type = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_TYPE);
-	cfg->supported_cap =
-		MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_SUPPORTED_CAP);
-	cfg->channel = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_CHANNEL);
-	cfg->port = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_PRT);
-	cfg->stats_mask = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_STATS_MASK);
-	memcpy(cfg->name, MCDI_PTR(outbuf, GET_PHY_CFG_OUT_NAME),
-	       sizeof(cfg->name));
-	cfg->media = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_MEDIA_TYPE);
-	cfg->mmd_mask = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_MMD_MASK);
-	memcpy(cfg->revision, MCDI_PTR(outbuf, GET_PHY_CFG_OUT_REVISION),
-	       sizeof(cfg->revision));
-
-	return 0;
-
-fail:
-	netif_err(efx, hw, efx->net_dev, "%s: failed rc=%d\n", __func__, rc);
-	return rc;
-}
-
-int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
-		      u32 flags, u32 loopback_mode,
-		      u32 loopback_speed)
-{
-	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_LINK_IN_LEN);
-	int rc;
-
-	BUILD_BUG_ON(MC_CMD_SET_LINK_OUT_LEN != 0);
-
-	MCDI_SET_DWORD(inbuf, SET_LINK_IN_CAP, capabilities);
-	MCDI_SET_DWORD(inbuf, SET_LINK_IN_FLAGS, flags);
-	MCDI_SET_DWORD(inbuf, SET_LINK_IN_LOOPBACK_MODE, loopback_mode);
-	MCDI_SET_DWORD(inbuf, SET_LINK_IN_LOOPBACK_SPEED, loopback_speed);
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_SET_LINK, inbuf, sizeof(inbuf),
-			  NULL, 0, NULL);
-	return rc;
-}
-
-int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes)
-{
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LOOPBACK_MODES_OUT_LEN);
-	size_t outlen;
-	int rc;
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LOOPBACK_MODES, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
-	if (rc)
-		goto fail;
-
-	if (outlen < (MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_OFST +
-		      MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_LEN)) {
-		rc = -EIO;
-		goto fail;
-	}
-
-	*loopback_modes = MCDI_QWORD(outbuf, GET_LOOPBACK_MODES_OUT_SUGGESTED);
-
-	return 0;
-
-fail:
-	netif_err(efx, hw, efx->net_dev, "%s: failed rc=%d\n", __func__, rc);
-	return rc;
-}
-
 static int efx_mcdi_mdio_read(struct net_device *net_dev,
 			      int prtad, int devad, u16 addr)
 {
@@ -154,70 +69,6 @@ static int efx_mcdi_mdio_write(struct net_device *net_dev,
 	return 0;
 }
 
-void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
-{
-	#define SET_BIT(name)	__set_bit(ETHTOOL_LINK_MODE_ ## name ## _BIT, \
-					  linkset)
-
-	bitmap_zero(linkset, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	switch (media) {
-	case MC_CMD_MEDIA_KX4:
-		SET_BIT(Backplane);
-		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
-			SET_BIT(1000baseKX_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
-			SET_BIT(10000baseKX4_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN))
-			SET_BIT(40000baseKR4_Full);
-		break;
-
-	case MC_CMD_MEDIA_XFP:
-	case MC_CMD_MEDIA_SFP_PLUS:
-	case MC_CMD_MEDIA_QSFP_PLUS:
-		SET_BIT(FIBRE);
-		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
-			SET_BIT(1000baseT_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
-			SET_BIT(10000baseT_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN))
-			SET_BIT(40000baseCR4_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN))
-			SET_BIT(100000baseCR4_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN))
-			SET_BIT(25000baseCR_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_50000FDX_LBN))
-			SET_BIT(50000baseCR2_Full);
-		break;
-
-	case MC_CMD_MEDIA_BASE_T:
-		SET_BIT(TP);
-		if (cap & (1 << MC_CMD_PHY_CAP_10HDX_LBN))
-			SET_BIT(10baseT_Half);
-		if (cap & (1 << MC_CMD_PHY_CAP_10FDX_LBN))
-			SET_BIT(10baseT_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_100HDX_LBN))
-			SET_BIT(100baseT_Half);
-		if (cap & (1 << MC_CMD_PHY_CAP_100FDX_LBN))
-			SET_BIT(100baseT_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_1000HDX_LBN))
-			SET_BIT(1000baseT_Half);
-		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
-			SET_BIT(1000baseT_Full);
-		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
-			SET_BIT(10000baseT_Full);
-		break;
-	}
-
-	if (cap & (1 << MC_CMD_PHY_CAP_PAUSE_LBN))
-		SET_BIT(Pause);
-	if (cap & (1 << MC_CMD_PHY_CAP_ASYM_LBN))
-		SET_BIT(Asym_Pause);
-	if (cap & (1 << MC_CMD_PHY_CAP_AN_LBN))
-		SET_BIT(Autoneg);
-
-	#undef SET_BIT
-}
-
 u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
 {
 	u32 result = 0;
@@ -308,34 +159,6 @@ u8 mcdi_to_ethtool_media(u32 media)
 	}
 }
 
-void efx_mcdi_phy_decode_link(struct efx_nic *efx,
-			      struct efx_link_state *link_state,
-			      u32 speed, u32 flags, u32 fcntl)
-{
-	switch (fcntl) {
-	case MC_CMD_FCNTL_AUTO:
-		WARN_ON(1);	/* This is not a link mode */
-		link_state->fc = EFX_FC_AUTO | EFX_FC_TX | EFX_FC_RX;
-		break;
-	case MC_CMD_FCNTL_BIDIR:
-		link_state->fc = EFX_FC_TX | EFX_FC_RX;
-		break;
-	case MC_CMD_FCNTL_RESPOND:
-		link_state->fc = EFX_FC_RX;
-		break;
-	default:
-		WARN_ON(1);
-		/* Fall through */
-	case MC_CMD_FCNTL_OFF:
-		link_state->fc = 0;
-		break;
-	}
-
-	link_state->up = !!(flags & (1 << MC_CMD_GET_LINK_OUT_LINK_UP_LBN));
-	link_state->fd = !!(flags & (1 << MC_CMD_GET_LINK_OUT_FULL_DUPLEX_LBN));
-	link_state->speed = speed;
-}
-
 /* The semantics of the ethtool FEC mode bitmask are not well defined,
  * particularly the meaning of combinations of bits.  Which means we get to
  * define our own semantics, as follows:
@@ -652,8 +475,7 @@ efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx,
 	return 0;
 }
 
-int efx_mcdi_phy_get_fecparam(struct efx_nic *efx,
-			      struct ethtool_fecparam *fec)
+int efx_mcdi_phy_get_fecparam(struct efx_nic *efx, struct ethtool_fecparam *fec)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_V2_LEN);
 	u32 caps, active, speed; /* MCDI format */
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
new file mode 100644
index 000000000000..0ba7b5a47d99
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "mcdi_port_common.h"
+
+int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_CFG_OUT_LEN);
+	size_t outlen;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_GET_PHY_CFG_IN_LEN != 0);
+	BUILD_BUG_ON(MC_CMD_GET_PHY_CFG_OUT_NAME_LEN != sizeof(cfg->name));
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_PHY_CFG, NULL, 0,
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		goto fail;
+
+	if (outlen < MC_CMD_GET_PHY_CFG_OUT_LEN) {
+		rc = -EIO;
+		goto fail;
+	}
+
+	cfg->flags = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_FLAGS);
+	cfg->type = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_TYPE);
+	cfg->supported_cap =
+		MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_SUPPORTED_CAP);
+	cfg->channel = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_CHANNEL);
+	cfg->port = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_PRT);
+	cfg->stats_mask = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_STATS_MASK);
+	memcpy(cfg->name, MCDI_PTR(outbuf, GET_PHY_CFG_OUT_NAME),
+	       sizeof(cfg->name));
+	cfg->media = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_MEDIA_TYPE);
+	cfg->mmd_mask = MCDI_DWORD(outbuf, GET_PHY_CFG_OUT_MMD_MASK);
+	memcpy(cfg->revision, MCDI_PTR(outbuf, GET_PHY_CFG_OUT_REVISION),
+	       sizeof(cfg->revision));
+
+	return 0;
+
+fail:
+	netif_err(efx, hw, efx->net_dev, "%s: failed rc=%d\n", __func__, rc);
+	return rc;
+}
+
+void efx_link_set_advertising(struct efx_nic *efx,
+			      const unsigned long *advertising)
+{
+	memcpy(efx->link_advertising, advertising,
+	       sizeof(__ETHTOOL_DECLARE_LINK_MODE_MASK()));
+
+	efx->link_advertising[0] |= ADVERTISED_Autoneg;
+	if (advertising[0] & ADVERTISED_Pause)
+		efx->wanted_fc |= (EFX_FC_TX | EFX_FC_RX);
+	else
+		efx->wanted_fc &= ~(EFX_FC_TX | EFX_FC_RX);
+	if (advertising[0] & ADVERTISED_Asym_Pause)
+		efx->wanted_fc ^= EFX_FC_TX;
+}
+
+int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
+		      u32 flags, u32 loopback_mode, u32 loopback_speed)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_LINK_IN_LEN);
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_SET_LINK_OUT_LEN != 0);
+
+	MCDI_SET_DWORD(inbuf, SET_LINK_IN_CAP, capabilities);
+	MCDI_SET_DWORD(inbuf, SET_LINK_IN_FLAGS, flags);
+	MCDI_SET_DWORD(inbuf, SET_LINK_IN_LOOPBACK_MODE, loopback_mode);
+	MCDI_SET_DWORD(inbuf, SET_LINK_IN_LOOPBACK_SPEED, loopback_speed);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_SET_LINK, inbuf, sizeof(inbuf),
+			  NULL, 0, NULL);
+	return rc;
+}
+
+int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LOOPBACK_MODES_OUT_LEN);
+	size_t outlen;
+	int rc;
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LOOPBACK_MODES, NULL, 0,
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		goto fail;
+
+	if (outlen < (MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_OFST +
+		      MC_CMD_GET_LOOPBACK_MODES_OUT_SUGGESTED_LEN)) {
+		rc = -EIO;
+		goto fail;
+	}
+
+	*loopback_modes = MCDI_QWORD(outbuf, GET_LOOPBACK_MODES_OUT_SUGGESTED);
+
+	return 0;
+
+fail:
+	netif_err(efx, hw, efx->net_dev, "%s: failed rc=%d\n", __func__, rc);
+	return rc;
+}
+
+void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
+{
+	#define SET_BIT(name)	__set_bit(ETHTOOL_LINK_MODE_ ## name ## _BIT, \
+					  linkset)
+
+	bitmap_zero(linkset, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	switch (media) {
+	case MC_CMD_MEDIA_KX4:
+		SET_BIT(Backplane);
+		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
+			SET_BIT(1000baseKX_Full);
+		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
+			SET_BIT(10000baseKX4_Full);
+		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN))
+			SET_BIT(40000baseKR4_Full);
+		break;
+
+	case MC_CMD_MEDIA_XFP:
+	case MC_CMD_MEDIA_SFP_PLUS:
+	case MC_CMD_MEDIA_QSFP_PLUS:
+		SET_BIT(FIBRE);
+		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
+			SET_BIT(1000baseT_Full);
+		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
+			SET_BIT(10000baseT_Full);
+		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN))
+			SET_BIT(40000baseCR4_Full);
+		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN))
+			SET_BIT(100000baseCR4_Full);
+		if (cap & (1 << MC_CMD_PHY_CAP_25000FDX_LBN))
+			SET_BIT(25000baseCR_Full);
+		if (cap & (1 << MC_CMD_PHY_CAP_50000FDX_LBN))
+			SET_BIT(50000baseCR2_Full);
+		break;
+
+	case MC_CMD_MEDIA_BASE_T:
+		SET_BIT(TP);
+		if (cap & (1 << MC_CMD_PHY_CAP_10HDX_LBN))
+			SET_BIT(10baseT_Half);
+		if (cap & (1 << MC_CMD_PHY_CAP_10FDX_LBN))
+			SET_BIT(10baseT_Full);
+		if (cap & (1 << MC_CMD_PHY_CAP_100HDX_LBN))
+			SET_BIT(100baseT_Half);
+		if (cap & (1 << MC_CMD_PHY_CAP_100FDX_LBN))
+			SET_BIT(100baseT_Full);
+		if (cap & (1 << MC_CMD_PHY_CAP_1000HDX_LBN))
+			SET_BIT(1000baseT_Half);
+		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
+			SET_BIT(1000baseT_Full);
+		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
+			SET_BIT(10000baseT_Full);
+		break;
+	}
+
+	if (cap & (1 << MC_CMD_PHY_CAP_PAUSE_LBN))
+		SET_BIT(Pause);
+	if (cap & (1 << MC_CMD_PHY_CAP_ASYM_LBN))
+		SET_BIT(Asym_Pause);
+	if (cap & (1 << MC_CMD_PHY_CAP_AN_LBN))
+		SET_BIT(Autoneg);
+
+	#undef SET_BIT
+}
+
+void efx_mcdi_phy_decode_link(struct efx_nic *efx,
+			      struct efx_link_state *link_state,
+			      u32 speed, u32 flags, u32 fcntl)
+{
+	switch (fcntl) {
+	case MC_CMD_FCNTL_AUTO:
+		WARN_ON(1);	/* This is not a link mode */
+		link_state->fc = EFX_FC_AUTO | EFX_FC_TX | EFX_FC_RX;
+		break;
+	case MC_CMD_FCNTL_BIDIR:
+		link_state->fc = EFX_FC_TX | EFX_FC_RX;
+		break;
+	case MC_CMD_FCNTL_RESPOND:
+		link_state->fc = EFX_FC_RX;
+		break;
+	default:
+		WARN_ON(1);
+		/* Fall through */
+	case MC_CMD_FCNTL_OFF:
+		link_state->fc = 0;
+		break;
+	}
+
+	link_state->up = !!(flags & (1 << MC_CMD_GET_LINK_OUT_LINK_UP_LBN));
+	link_state->fd = !!(flags & (1 << MC_CMD_GET_LINK_OUT_FULL_DUPLEX_LBN));
+	link_state->speed = speed;
+}
-- 
2.20.1


