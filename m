Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FD725FE68
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgIGQPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:15:47 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:44176 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730488AbgIGQPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:15:18 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9342B60085;
        Mon,  7 Sep 2020 16:15:17 +0000 (UTC)
Received: from us4-mdac16-21.ut7.mdlocal (unknown [10.7.65.245])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 91F57800A4;
        Mon,  7 Sep 2020 16:15:17 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.41])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E81098005B;
        Mon,  7 Sep 2020 16:15:16 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 83B174C0073;
        Mon,  7 Sep 2020 16:15:16 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep 2020
 17:15:11 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 4/6] sfc: handle limited FEC support
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Message-ID: <67198e21-a679-b059-3eed-e579ada05a78@solarflare.com>
Date:   Mon, 7 Sep 2020 17:15:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25650.007
X-TM-AS-Result: No-3.083900-8.000000-10
X-TMASE-MatchedRID: Kw18Xv5S6HfqZd/Q8VPrjE+zv2ByYSDQffXpER5TkJEAjiw/nJICh3WQ
        EG9fkFjn8XVI39JCRnSjfNAVYAJRAq0iin8P0KjVPwKTD1v8YV5MkOX0Uoduud1bPD+cmI6DTca
        4Swg2I6PaXrpD+znxDfr698DDTYToZ/mERv8EXlVQ+S0N05fR+xfbPFE2GHrV3kqU4/bhfXCNp9
        wlZtMgueLzNWBegCW2RYvisGWbbS+No+PRbWqfRMZW5ai5WKlyoiEmB1SnJujWihxlHESXdmpaH
        NLcWSGpeYL5zWXWlILXluR+Pc5deWZ6i/1Q1iTCvxVmi6VaWZaPb9ieSc6fOkcED6gT62htkERy
        uRHFgnhSMqc7UpUorBKRsPC6bTvOqrQxXydIwG8AF83WedHbhQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.083900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25650.007
X-MDID: 1599495317-zLHUzhCmWcCF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the reported PHY capabilities do not include a given FEC mode, don't
 attempt to select that FEC mode anyway.  If the user tries to set a mode
 through ethtool that is not supported, return an error.
The _REQUESTED bits don't appear in the supported caps, but are implied
 by the corresponding FEC bits.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_port_common.c | 48 +++++++++++++++------
 drivers/net/ethernet/sfc/mcdi_port_common.h |  2 +-
 2 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 71c76a6a6b0e..c0e1c88a652c 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -308,7 +308,7 @@ void efx_mcdi_phy_decode_link(struct efx_nic *efx,
  * Both RS and BASER (whether AUTO or not) means use FEC if cable and link
  * partner support it, preferring RS to BASER.
  */
-u32 ethtool_fec_caps_to_mcdi(u32 ethtool_cap)
+u32 ethtool_fec_caps_to_mcdi(u32 supported_cap, u32 ethtool_cap)
 {
 	u32 ret = 0;
 
@@ -316,17 +316,21 @@ u32 ethtool_fec_caps_to_mcdi(u32 ethtool_cap)
 		return 0;
 
 	if (ethtool_cap & ETHTOOL_FEC_AUTO)
-		ret |= (1 << MC_CMD_PHY_CAP_BASER_FEC_LBN) |
-		       (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_LBN) |
-		       (1 << MC_CMD_PHY_CAP_RS_FEC_LBN);
-	if (ethtool_cap & ETHTOOL_FEC_RS)
+		ret |= ((1 << MC_CMD_PHY_CAP_BASER_FEC_LBN) |
+			(1 << MC_CMD_PHY_CAP_25G_BASER_FEC_LBN) |
+			(1 << MC_CMD_PHY_CAP_RS_FEC_LBN)) & supported_cap;
+	if (ethtool_cap & ETHTOOL_FEC_RS &&
+	    supported_cap & (1 << MC_CMD_PHY_CAP_RS_FEC_LBN))
 		ret |= (1 << MC_CMD_PHY_CAP_RS_FEC_LBN) |
 		       (1 << MC_CMD_PHY_CAP_RS_FEC_REQUESTED_LBN);
-	if (ethtool_cap & ETHTOOL_FEC_BASER)
-		ret |= (1 << MC_CMD_PHY_CAP_BASER_FEC_LBN) |
-		       (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_LBN) |
-		       (1 << MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_LBN) |
-		       (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_LBN);
+	if (ethtool_cap & ETHTOOL_FEC_BASER) {
+		if (supported_cap & (1 << MC_CMD_PHY_CAP_BASER_FEC_LBN))
+			ret |= (1 << MC_CMD_PHY_CAP_BASER_FEC_LBN) |
+			       (1 << MC_CMD_PHY_CAP_BASER_FEC_REQUESTED_LBN);
+		if (supported_cap & (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_LBN))
+			ret |= (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_LBN) |
+			       (1 << MC_CMD_PHY_CAP_25G_BASER_FEC_REQUESTED_LBN);
+	}
 	return ret;
 }
 
@@ -577,7 +581,7 @@ int efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx, const struct ethtool_li
 		}
 	}
 
-	caps |= ethtool_fec_caps_to_mcdi(efx->fec_config);
+	caps |= ethtool_fec_caps_to_mcdi(phy_cfg->supported_cap, efx->fec_config);
 
 	rc = efx_mcdi_set_link(efx, caps, efx_get_mcdi_phy_flags(efx),
 			       efx->loopback_mode, 0);
@@ -645,12 +649,30 @@ int efx_mcdi_phy_get_fecparam(struct efx_nic *efx, struct ethtool_fecparam *fec)
 	return 0;
 }
 
+/* Basic validation to ensure that the caps we are going to attempt to set are
+ * in fact supported by the adapter.  Note that 'no FEC' is always supported.
+ */
+static int ethtool_fec_supported(u32 supported_cap, u32 ethtool_cap)
+{
+	if (ethtool_cap & ETHTOOL_FEC_OFF)
+		return 0;
+
+	if (ethtool_cap &&
+	    !ethtool_fec_caps_to_mcdi(supported_cap, ethtool_cap))
+		return -EINVAL;
+	return 0;
+}
+
 int efx_mcdi_phy_set_fecparam(struct efx_nic *efx, const struct ethtool_fecparam *fec)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	u32 caps;
 	int rc;
 
+	rc = ethtool_fec_supported(phy_cfg->supported_cap, fec->fec);
+	if (rc)
+		return rc;
+
 	/* Work out what efx_mcdi_phy_set_link_ksettings() would produce from
 	 * saved advertising bits
 	 */
@@ -660,7 +682,7 @@ int efx_mcdi_phy_set_fecparam(struct efx_nic *efx, const struct ethtool_fecparam
 	else
 		caps = phy_cfg->forced_cap;
 
-	caps |= ethtool_fec_caps_to_mcdi(fec->fec);
+	caps |= ethtool_fec_caps_to_mcdi(phy_cfg->supported_cap, fec->fec);
 	rc = efx_mcdi_set_link(efx, caps, efx_get_mcdi_phy_flags(efx),
 			       efx->loopback_mode, 0);
 	if (rc)
@@ -699,7 +721,7 @@ int efx_mcdi_port_reconfigure(struct efx_nic *efx)
 		    ethtool_linkset_to_mcdi_cap(efx->link_advertising) :
 		    phy_cfg->forced_cap);
 
-	caps |= ethtool_fec_caps_to_mcdi(efx->fec_config);
+	caps |= ethtool_fec_caps_to_mcdi(phy_cfg->supported_cap, efx->fec_config);
 
 	return efx_mcdi_set_link(efx, caps, efx_get_mcdi_phy_flags(efx),
 				 efx->loopback_mode, 0);
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.h b/drivers/net/ethernet/sfc/mcdi_port_common.h
index 9d214079f699..f37e18adbc37 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.h
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.h
@@ -41,7 +41,7 @@ u8 mcdi_to_ethtool_media(u32 media);
 void efx_mcdi_phy_decode_link(struct efx_nic *efx,
 			      struct efx_link_state *link_state,
 			      u32 speed, u32 flags, u32 fcntl);
-u32 ethtool_fec_caps_to_mcdi(u32 ethtool_cap);
+u32 ethtool_fec_caps_to_mcdi(u32 supported_cap, u32 ethtool_cap);
 u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g);
 void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa);
 bool efx_mcdi_phy_poll(struct efx_nic *efx);

