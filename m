Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2D320F42E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbgF3MLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:11:46 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:52552 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387448AbgF3MLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:11:45 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 26969200B5;
        Tue, 30 Jun 2020 12:11:44 +0000 (UTC)
Received: from us4-mdac16-52.at1.mdlocal (unknown [10.110.48.101])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1C9D4800A3;
        Tue, 30 Jun 2020 12:11:44 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AB2EA10004F;
        Tue, 30 Jun 2020 12:11:43 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 70099140087;
        Tue, 30 Jun 2020 12:11:43 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:11:39 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 05/14] sfc: commonise some MAC configuration code
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <34c4ed3c-8e71-8eb6-fe9f-9f1ed6099e73@solarflare.com>
Date:   Tue, 30 Jun 2020 13:11:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-2.593100-8.000000-10
X-TMASE-MatchedRID: PCFkxA7eE67CpGfpWZNAso9BVqQOQlT5eouvej40T4gd0WOKRkwsh1ym
        Rv3NQjsEfGzuoVn0Vs6PQi9XuOWoOHI/MxNRI7UkCWlWR223da4w6FEHkL/wj66vUcPaplaYtLM
        efGorMlXHE4B47ECvKx5pG1lPrPh872C1bZnMeokHwuCWPSIIAKLwP+jjbL9Kx6C6dcifNxjgcJ
        c1hBF7dqfUF50ckaWqkZOl7WKIImrvXOvQVlExsDXJPZYaymc4xEHRux+uk8hxKpvEGAbTDlbPN
        gTs5YtKoxoIf9fi1inST5uaTCzfjT54V4TOatpPfXonvbik6q3hNctnRRPCkexHQTnv6/Tfmffk
        ZST0kK8gMKS8hKuNuBoQVhcDKUH1JRIzmbBpwaQgJCm6ypGLZ4kFmqDGAwWm
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.593100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593519104-7-VMV001CBYU
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor it a little as we go, and introduce efx_mcdi_set_mtu() which we
 will later use for ef100 to change MTU without touching other MAC settings.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_port.c        | 13 --------
 drivers/net/ethernet/sfc/mcdi_port_common.c | 36 +++++++++++++++++++--
 drivers/net/ethernet/sfc/mcdi_port_common.h |  1 +
 3 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index 133f8b8ec3b3..98eeb404f68d 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -176,19 +176,6 @@ static int efx_mcdi_phy_probe(struct efx_nic *efx)
 	return rc;
 }
 
-int efx_mcdi_port_reconfigure(struct efx_nic *efx)
-{
-	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
-	u32 caps = (efx->link_advertising[0] ?
-		    ethtool_linkset_to_mcdi_cap(efx->link_advertising) :
-		    phy_cfg->forced_cap);
-
-	caps |= ethtool_fec_caps_to_mcdi(efx->fec_config);
-
-	return efx_mcdi_set_link(efx, caps, efx_get_mcdi_phy_flags(efx),
-				 efx->loopback_mode, 0);
-}
-
 static void efx_mcdi_phy_remove(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_data = efx->phy_data;
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index e0608d0d961b..56af8b54a864 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -476,6 +476,24 @@ int efx_mcdi_phy_test_alive(struct efx_nic *efx)
 	return 0;
 }
 
+int efx_mcdi_port_reconfigure(struct efx_nic *efx)
+{
+	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
+	u32 caps = (efx->link_advertising[0] ?
+		    ethtool_linkset_to_mcdi_cap(efx->link_advertising) :
+		    phy_cfg->forced_cap);
+
+	caps |= ethtool_fec_caps_to_mcdi(efx->fec_config);
+
+	return efx_mcdi_set_link(efx, caps, efx_get_mcdi_phy_flags(efx),
+				 efx->loopback_mode, 0);
+}
+
+static unsigned int efx_calc_mac_mtu(struct efx_nic *efx)
+{
+	return EFX_MAX_FRAME_LEN(efx->net_dev->mtu);
+}
+
 int efx_mcdi_set_mac(struct efx_nic *efx)
 {
 	u32 fcntl;
@@ -487,8 +505,7 @@ int efx_mcdi_set_mac(struct efx_nic *efx)
 	ether_addr_copy(MCDI_PTR(cmdbytes, SET_MAC_IN_ADDR),
 			efx->net_dev->dev_addr);
 
-	MCDI_SET_DWORD(cmdbytes, SET_MAC_IN_MTU,
-		       EFX_MAX_FRAME_LEN(efx->net_dev->mtu));
+	MCDI_SET_DWORD(cmdbytes, SET_MAC_IN_MTU, efx_calc_mac_mtu(efx));
 	MCDI_SET_DWORD(cmdbytes, SET_MAC_IN_DRAIN, 0);
 
 	/* Set simple MAC filter for Siena */
@@ -521,6 +538,21 @@ int efx_mcdi_set_mac(struct efx_nic *efx)
 			    NULL, 0, NULL);
 }
 
+int efx_mcdi_set_mtu(struct efx_nic *efx)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_MAC_EXT_IN_LEN);
+
+	BUILD_BUG_ON(MC_CMD_SET_MAC_OUT_LEN != 0);
+
+	MCDI_SET_DWORD(inbuf, SET_MAC_EXT_IN_MTU, efx_calc_mac_mtu(efx));
+
+	MCDI_POPULATE_DWORD_1(inbuf, SET_MAC_EXT_IN_CONTROL,
+			      SET_MAC_EXT_IN_CFG_MTU, 1);
+
+	return efx_mcdi_rpc(efx, MC_CMD_SET_MAC, inbuf, sizeof(inbuf),
+			    NULL, 0, NULL);
+}
+
 enum efx_stats_action {
 	EFX_STATS_ENABLE,
 	EFX_STATS_DISABLE,
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.h b/drivers/net/ethernet/sfc/mcdi_port_common.h
index 54c0acf8e243..f6f81cbeb07e 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.h
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.h
@@ -51,6 +51,7 @@ int efx_mcdi_phy_get_fecparam(struct efx_nic *efx,
 			      struct ethtool_fecparam *fec);
 int efx_mcdi_phy_test_alive(struct efx_nic *efx);
 int efx_mcdi_set_mac(struct efx_nic *efx);
+int efx_mcdi_set_mtu(struct efx_nic *efx);
 int efx_mcdi_mac_init_stats(struct efx_nic *efx);
 void efx_mcdi_mac_fini_stats(struct efx_nic *efx);
 int efx_mcdi_port_get_number(struct efx_nic *efx);

