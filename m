Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5454921D50C
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbgGMLfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:35:12 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:50740 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgGMLfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:35:11 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5C42D60073;
        Mon, 13 Jul 2020 11:35:11 +0000 (UTC)
Received: from us4-mdac16-49.ut7.mdlocal (unknown [10.7.66.16])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5AE2A8009E;
        Mon, 13 Jul 2020 11:35:11 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E4E4D280053;
        Mon, 13 Jul 2020 11:35:10 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9CCD5B4006D;
        Mon, 13 Jul 2020 11:35:10 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 12:35:05 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 11/16] sfc_ef100: read datapath caps, implement
 check_caps
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
Message-ID: <96b7fc93-0724-55ae-b1f5-fdee38472d8f@solarflare.com>
Date:   Mon, 13 Jul 2020 12:35:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25538.003
X-TM-AS-Result: No-7.211600-8.000000-10
X-TMASE-MatchedRID: ZRt6D9EtTrj0gpEqM7fvYbsHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc5xXpQkwQ35BsAWE2Yt75J5ogGd8wIUGIK+6m15psHd9VeIuu+Gkot8Ul0
        3SIY6fe2nzH6iLqE0/0jN/KMDFU0FhiGHGwOUItAHtOpEBhWiFlxo0H+7nJCrv27awoUD83Tiyr
        ZwH5WBj4gOqUZwR4FLECEJDw7fG2+SsyjfsjrH/ltTO+xodboGAp+UH372RZW8YDH/UBNnm93UU
        MDGwMwTwr2TwTY3Zu5g0jv7ItNWqvViraMOl/0vEhGH3CRdKUWz5lM7Y7PGwP9LEanWbLZ2iWfF
        SmTuO0bi8zVgXoAltkWL4rBlm20vjaPj0W1qn0SyO81X3yak8wWQl5MEyvdtB351W9pVx5oSrLw
        68xGJeg/3TP35L8xt94z5gUGLF8l+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.211600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25538.003
X-MDID: 1594640111-TyGbgpAjJc1b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 58 +++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/ef100_nic.h |  2 +
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index d415d25e532a..06e9ae58f1c6 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -124,6 +124,49 @@ static void ef100_mcdi_reboot_detected(struct efx_nic *efx)
 {
 }
 
+/*	MCDI calls
+ */
+static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V4_OUT_LEN);
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	u8 vi_window_mode;
+	size_t outlen;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_GET_CAPABILITIES_IN_LEN != 0);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_CAPABILITIES, NULL, 0,
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < MC_CMD_GET_CAPABILITIES_V4_OUT_LEN) {
+		netif_err(efx, drv, efx->net_dev,
+			  "unable to read datapath firmware capabilities\n");
+		return -EIO;
+	}
+
+	nic_data->datapath_caps = MCDI_DWORD(outbuf,
+					     GET_CAPABILITIES_OUT_FLAGS1);
+	nic_data->datapath_caps2 = MCDI_DWORD(outbuf,
+					      GET_CAPABILITIES_V2_OUT_FLAGS2);
+
+	vi_window_mode = MCDI_BYTE(outbuf,
+				   GET_CAPABILITIES_V3_OUT_VI_WINDOW_MODE);
+	rc = efx_mcdi_window_mode_to_stride(efx, vi_window_mode);
+	if (rc)
+		return rc;
+
+	if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3))
+		efx->net_dev->features |= NETIF_F_TSO | NETIF_F_TSO6;
+	efx->num_mac_stats = MCDI_WORD(outbuf,
+				       GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
+	netif_dbg(efx, probe, efx->net_dev,
+		  "firmware reports num_mac_stats = %u\n",
+		  efx->num_mac_stats);
+	return 0;
+}
+
 /*	Event handling
  */
 static int ef100_ev_probe(struct efx_channel *channel)
@@ -299,8 +342,16 @@ static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
 static unsigned int ef100_check_caps(const struct efx_nic *efx,
 				     u8 flag, u32 offset)
 {
-	/* stub */
-	return 0;
+	const struct ef100_nic_data *nic_data = efx->nic_data;
+
+	switch (offset) {
+	case MC_CMD_GET_CAPABILITIES_V8_OUT_FLAGS1_OFST:
+		return nic_data->datapath_caps & BIT_ULL(flag);
+	case MC_CMD_GET_CAPABILITIES_V8_OUT_FLAGS2_OFST:
+		return nic_data->datapath_caps2 & BIT_ULL(flag);
+	default:
+		return 0;
+	}
 }
 
 /*	NIC level access functions
@@ -409,6 +460,9 @@ static int ef100_probe_main(struct efx_nic *efx)
 	}
 	if (rc)
 		goto fail;
+	rc = efx_ef100_init_datapath_caps(efx);
+	if (rc < 0)
+		goto fail;
 
 	efx->max_vis = EF100_MAX_VIS;
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 5d376e2d98a7..392611cc33b5 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -20,6 +20,8 @@ void ef100_remove(struct efx_nic *efx);
 struct ef100_nic_data {
 	struct efx_nic *efx;
 	struct efx_buffer mcdi_buf;
+	u32 datapath_caps;
+	u32 datapath_caps2;
 	u16 warm_boot_count;
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
 };

