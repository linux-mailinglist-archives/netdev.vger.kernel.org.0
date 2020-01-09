Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A09F135D09
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbgAIPoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:44:23 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59408 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728098AbgAIPoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:44:23 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3D46EB80075;
        Thu,  9 Jan 2020 15:44:21 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 Jan 2020 15:44:16 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 3/9] sfc: move more MCDI port code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Message-ID: <fff67a29-f364-50ec-acd0-73a456893b27@solarflare.com>
Date:   Thu, 9 Jan 2020 15:44:12 +0000
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
X-TM-AS-Result: No-6.326700-8.000000-10
X-TMASE-MatchedRID: RtQeqDiqBJncGqXv24dgLcn9tWHiLD2Geouvej40T4gd0WOKRkwsh1ym
        Rv3NQjsEfGzuoVn0Vs6PQi9XuOWoOPI1YbpS1+avKSfEqVU/Tv8rtU4v33TxweM0/bFuUDghy5M
        gwQconH5Y5prlPxsxVyUPrqZPyrg/6mXf0PFT64y0pHkVd9vKzHPAOHhFO1wcKBVvFbsUM5UDK6
        XcoxVT+vcYGeBHGtnM5EJ+L1ocBmFovGFNoIkoj2WnA2xO92UpZwLLfALfnN1UjspoiX02F0hUg
        OnWl3qA17hbsK6wMAWcoe9rF4qH80s3SiaAjbkfg2tpowTD9VoX2zxRNhh61ZxfjZvll77ikH1X
        SJwPy4p9hQIuMWcvjGT7XCGDBzH9RZJ90/Q8SpmeAiCmPx4NwLTrdaH1ZWqC3TrdyO4a2u36C0e
        Ps7A07Q9dk+6tnSFLNeoDuPID3KkNL9MUSzZUEHe95P/kfiF3dZ3mZrxUuEU=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.326700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25156.003
X-MDID: 1578584662-ML9IYrM0h9jH
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various functions dealing with flow control, forward error correction,
polling, port number, and PHY testing.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_port.c        | 138 -------------------
 drivers/net/ethernet/sfc/mcdi_port_common.c | 139 ++++++++++++++++++++
 2 files changed, 139 insertions(+), 138 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index d811753782dc..0db6068a668d 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -188,58 +188,6 @@ int efx_mcdi_port_reconfigure(struct efx_nic *efx)
 				 efx->loopback_mode, 0);
 }
 
-/* Verify that the forced flow control settings (!EFX_FC_AUTO) are
- * supported by the link partner. Warn the user if this isn't the case
- */
-void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa)
-{
-	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
-	u32 rmtadv;
-
-	/* The link partner capabilities are only relevant if the
-	 * link supports flow control autonegotiation */
-	if (~phy_cfg->supported_cap & (1 << MC_CMD_PHY_CAP_AN_LBN))
-		return;
-
-	/* If flow control autoneg is supported and enabled, then fine */
-	if (efx->wanted_fc & EFX_FC_AUTO)
-		return;
-
-	rmtadv = 0;
-	if (lpa & (1 << MC_CMD_PHY_CAP_PAUSE_LBN))
-		rmtadv |= ADVERTISED_Pause;
-	if (lpa & (1 << MC_CMD_PHY_CAP_ASYM_LBN))
-		rmtadv |=  ADVERTISED_Asym_Pause;
-
-	if ((efx->wanted_fc & EFX_FC_TX) && rmtadv == ADVERTISED_Asym_Pause)
-		netif_err(efx, link, efx->net_dev,
-			  "warning: link partner doesn't support pause frames");
-}
-
-bool efx_mcdi_phy_poll(struct efx_nic *efx)
-{
-	struct efx_link_state old_state = efx->link_state;
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
-	int rc;
-
-	WARN_ON(!mutex_is_locked(&efx->mac_lock));
-
-	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
-			  outbuf, sizeof(outbuf), NULL);
-	if (rc)
-		efx->link_state.up = false;
-	else
-		efx_mcdi_phy_decode_link(
-			efx, &efx->link_state,
-			MCDI_DWORD(outbuf, GET_LINK_OUT_LINK_SPEED),
-			MCDI_DWORD(outbuf, GET_LINK_OUT_FLAGS),
-			MCDI_DWORD(outbuf, GET_LINK_OUT_FCNTL));
-
-	return !efx_link_state_equal(&efx->link_state, &old_state);
-}
-
 static void efx_mcdi_phy_remove(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_data = efx->phy_data;
@@ -327,57 +275,6 @@ efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx,
 	return 0;
 }
 
-int efx_mcdi_phy_get_fecparam(struct efx_nic *efx, struct ethtool_fecparam *fec)
-{
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_V2_LEN);
-	u32 caps, active, speed; /* MCDI format */
-	bool is_25g = false;
-	size_t outlen;
-	int rc;
-
-	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
-	if (rc)
-		return rc;
-	if (outlen < MC_CMD_GET_LINK_OUT_V2_LEN)
-		return -EOPNOTSUPP;
-
-	/* behaviour for 25G/50G links depends on 25G BASER bit */
-	speed = MCDI_DWORD(outbuf, GET_LINK_OUT_V2_LINK_SPEED);
-	is_25g = speed == 25000 || speed == 50000;
-
-	caps = MCDI_DWORD(outbuf, GET_LINK_OUT_V2_CAP);
-	fec->fec = mcdi_fec_caps_to_ethtool(caps, is_25g);
-	/* BASER is never supported on 100G */
-	if (speed == 100000)
-		fec->fec &= ~ETHTOOL_FEC_BASER;
-
-	active = MCDI_DWORD(outbuf, GET_LINK_OUT_V2_FEC_TYPE);
-	switch (active) {
-	case MC_CMD_FEC_NONE:
-		fec->active_fec = ETHTOOL_FEC_OFF;
-		break;
-	case MC_CMD_FEC_BASER:
-		fec->active_fec = ETHTOOL_FEC_BASER;
-		break;
-	case MC_CMD_FEC_RS:
-		fec->active_fec = ETHTOOL_FEC_RS;
-		break;
-	default:
-		netif_warn(efx, hw, efx->net_dev,
-			   "Firmware reports unrecognised FEC_TYPE %u\n",
-			   active);
-		/* We don't know what firmware has picked.  AUTO is as good a
-		 * "can't happen" value as any other.
-		 */
-		fec->active_fec = ETHTOOL_FEC_AUTO;
-		break;
-	}
-
-	return 0;
-}
-
 static int efx_mcdi_phy_set_fecparam(struct efx_nic *efx,
 				     const struct ethtool_fecparam *fec)
 {
@@ -405,27 +302,6 @@ static int efx_mcdi_phy_set_fecparam(struct efx_nic *efx,
 	return 0;
 }
 
-int efx_mcdi_phy_test_alive(struct efx_nic *efx)
-{
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_STATE_OUT_LEN);
-	size_t outlen;
-	int rc;
-
-	BUILD_BUG_ON(MC_CMD_GET_PHY_STATE_IN_LEN != 0);
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_PHY_STATE, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
-	if (rc)
-		return rc;
-
-	if (outlen < MC_CMD_GET_PHY_STATE_OUT_LEN)
-		return -EIO;
-	if (MCDI_DWORD(outbuf, GET_PHY_STATE_OUT_STATE) != MC_CMD_PHY_STATE_OK)
-		return -EINVAL;
-
-	return 0;
-}
-
 static const char *const mcdi_sft9001_cable_diag_names[] = {
 	"cable.pairA.length",
 	"cable.pairB.length",
@@ -1008,17 +884,3 @@ void efx_mcdi_port_remove(struct efx_nic *efx)
 	efx->phy_op->remove(efx);
 	efx_nic_free_buffer(efx, &efx->stats_buffer);
 }
-
-/* Get physical port number (EF10 only; on Siena it is same as PF number) */
-int efx_mcdi_port_get_number(struct efx_nic *efx)
-{
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PORT_ASSIGNMENT_OUT_LEN);
-	int rc;
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_PORT_ASSIGNMENT, NULL, 0,
-			  outbuf, sizeof(outbuf), NULL);
-	if (rc)
-		return rc;
-
-	return MCDI_DWORD(outbuf, GET_PORT_ASSIGNMENT_OUT_PORT);
-}
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 9763d59f7681..3b1c559246b4 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -348,3 +348,142 @@ u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g)
 	       (baser_req ? ETHTOOL_FEC_BASER : 0) |
 	       (baser == baser_req && rs == rs_req ? 0 : ETHTOOL_FEC_AUTO);
 }
+
+/* Verify that the forced flow control settings (!EFX_FC_AUTO) are
+ * supported by the link partner. Warn the user if this isn't the case
+ */
+void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa)
+{
+	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
+	u32 rmtadv;
+
+	/* The link partner capabilities are only relevant if the
+	 * link supports flow control autonegotiation
+	 */
+	if (~phy_cfg->supported_cap & (1 << MC_CMD_PHY_CAP_AN_LBN))
+		return;
+
+	/* If flow control autoneg is supported and enabled, then fine */
+	if (efx->wanted_fc & EFX_FC_AUTO)
+		return;
+
+	rmtadv = 0;
+	if (lpa & (1 << MC_CMD_PHY_CAP_PAUSE_LBN))
+		rmtadv |= ADVERTISED_Pause;
+	if (lpa & (1 << MC_CMD_PHY_CAP_ASYM_LBN))
+		rmtadv |=  ADVERTISED_Asym_Pause;
+
+	if ((efx->wanted_fc & EFX_FC_TX) && rmtadv == ADVERTISED_Asym_Pause)
+		netif_err(efx, link, efx->net_dev,
+			  "warning: link partner doesn't support pause frames");
+}
+
+bool efx_mcdi_phy_poll(struct efx_nic *efx)
+{
+	struct efx_link_state old_state = efx->link_state;
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
+	int rc;
+
+	WARN_ON(!mutex_is_locked(&efx->mac_lock));
+
+	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
+			  outbuf, sizeof(outbuf), NULL);
+	if (rc)
+		efx->link_state.up = false;
+	else
+		efx_mcdi_phy_decode_link(
+			efx, &efx->link_state,
+			MCDI_DWORD(outbuf, GET_LINK_OUT_LINK_SPEED),
+			MCDI_DWORD(outbuf, GET_LINK_OUT_FLAGS),
+			MCDI_DWORD(outbuf, GET_LINK_OUT_FCNTL));
+
+	return !efx_link_state_equal(&efx->link_state, &old_state);
+}
+
+int efx_mcdi_phy_get_fecparam(struct efx_nic *efx, struct ethtool_fecparam *fec)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_V2_LEN);
+	u32 caps, active, speed; /* MCDI format */
+	bool is_25g = false;
+	size_t outlen;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < MC_CMD_GET_LINK_OUT_V2_LEN)
+		return -EOPNOTSUPP;
+
+	/* behaviour for 25G/50G links depends on 25G BASER bit */
+	speed = MCDI_DWORD(outbuf, GET_LINK_OUT_V2_LINK_SPEED);
+	is_25g = speed == 25000 || speed == 50000;
+
+	caps = MCDI_DWORD(outbuf, GET_LINK_OUT_V2_CAP);
+	fec->fec = mcdi_fec_caps_to_ethtool(caps, is_25g);
+	/* BASER is never supported on 100G */
+	if (speed == 100000)
+		fec->fec &= ~ETHTOOL_FEC_BASER;
+
+	active = MCDI_DWORD(outbuf, GET_LINK_OUT_V2_FEC_TYPE);
+	switch (active) {
+	case MC_CMD_FEC_NONE:
+		fec->active_fec = ETHTOOL_FEC_OFF;
+		break;
+	case MC_CMD_FEC_BASER:
+		fec->active_fec = ETHTOOL_FEC_BASER;
+		break;
+	case MC_CMD_FEC_RS:
+		fec->active_fec = ETHTOOL_FEC_RS;
+		break;
+	default:
+		netif_warn(efx, hw, efx->net_dev,
+			   "Firmware reports unrecognised FEC_TYPE %u\n",
+			   active);
+		/* We don't know what firmware has picked.  AUTO is as good a
+		 * "can't happen" value as any other.
+		 */
+		fec->active_fec = ETHTOOL_FEC_AUTO;
+		break;
+	}
+
+	return 0;
+}
+
+int efx_mcdi_phy_test_alive(struct efx_nic *efx)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_STATE_OUT_LEN);
+	size_t outlen;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_GET_PHY_STATE_IN_LEN != 0);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_PHY_STATE, NULL, 0,
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+
+	if (outlen < MC_CMD_GET_PHY_STATE_OUT_LEN)
+		return -EIO;
+	if (MCDI_DWORD(outbuf, GET_PHY_STATE_OUT_STATE) != MC_CMD_PHY_STATE_OK)
+		return -EINVAL;
+
+	return 0;
+}
+
+/* Get physical port number (EF10 only; on Siena it is same as PF number) */
+int efx_mcdi_port_get_number(struct efx_nic *efx)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PORT_ASSIGNMENT_OUT_LEN);
+	int rc;
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_PORT_ASSIGNMENT, NULL, 0,
+			  outbuf, sizeof(outbuf), NULL);
+	if (rc)
+		return rc;
+
+	return MCDI_DWORD(outbuf, GET_PORT_ASSIGNMENT_OUT_PORT);
+}
-- 
2.20.1


