Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E931F23AE37
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgHCUfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:35:01 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:34074 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726725AbgHCUfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:35:01 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8131720067;
        Mon,  3 Aug 2020 20:34:59 +0000 (UTC)
Received: from us4-mdac16-12.at1.mdlocal (unknown [10.110.49.194])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7E079800A3;
        Mon,  3 Aug 2020 20:34:59 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 165ED100052;
        Mon,  3 Aug 2020 20:34:59 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 943CB28006F;
        Mon,  3 Aug 2020 20:34:58 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 Aug 2020
 21:34:51 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 05/11] sfc_ef100: RX filter table management and
 related gubbins
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
Message-ID: <68af9181-d476-35d5-c41b-128be972d6e7@solarflare.com>
Date:   Mon, 3 Aug 2020 21:34:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25582.002
X-TM-AS-Result: No-6.484200-8.000000-10
X-TMASE-MatchedRID: TuwRzrPxPxZbbYRuf3nrh7sHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc7Wuzp0zYDj5NfQ7AU9Ytd4fzgVmnL/olWq4ULvdc8DZ1SOymiJfTYXsWY
        tS6p50rGaJfo0dDvh7gCbXA1B7PqotKK2P+LRq7tH+PTjR9EWksu99zcLpJbCBbJs+dLiqQYfQa
        rqCH5mUK1qVjkRjd7RIOXdMK2UtALs708UolyRv4JzLQve4x1UK/YFZTiDf+qfuM4lD6uC8bLJA
        ie8s+T8XK9FoQ/9VZ62ZXRrhevIbxBqxioFyNyPlchF+IvkllN9LQinZ4QefL6qvLNjDYTwmTDw
        p0zM3zoqtq5d3cxkNT+yncrZqGnuVmZfn1+zh9xY/oX8VIBwES1Vv/zSPeJRgmEJOqdkrWoaYZG
        4nppMmPzVMAMo4PR1g79F3fqglBo+3Ed3WSD4x77rweoAIK8o
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-6.484200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25582.002
X-MDID: 1596486899-bG6-wYZNg_Wn
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 10 ++++
 drivers/net/ethernet/sfc/ef100_nic.c    | 67 +++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index ec9ca81fed85..362a915c836a 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -89,6 +89,7 @@ static int ef100_net_stop(struct net_device *net_dev)
 	efx_disable_interrupts(efx);
 	efx_clear_interrupt_affinity(efx);
 	efx_nic_fini_interrupt(efx);
+	efx_remove_filters(efx);
 	efx_fini_napi(efx);
 	efx_remove_channels(efx);
 	efx_mcdi_free_vis(efx);
@@ -138,6 +139,10 @@ static int ef100_net_open(struct net_device *net_dev)
 
 	efx_init_napi(efx);
 
+	rc = efx_probe_filters(efx);
+	if (rc)
+		goto fail;
+
 	rc = efx_nic_init_interrupt(efx);
 	if (rc)
 		goto fail;
@@ -207,8 +212,13 @@ static const struct net_device_ops ef100_netdev_ops = {
 	.ndo_open               = ef100_net_open,
 	.ndo_stop               = ef100_net_stop,
 	.ndo_start_xmit         = ef100_hard_start_xmit,
+	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_set_rx_mode        = efx_set_rx_mode, /* Lookout */
 	.ndo_get_phys_port_id   = efx_get_phys_port_id,
 	.ndo_get_phys_port_name = efx_get_phys_port_name,
+#ifdef CONFIG_RFS_ACCEL
+	.ndo_rx_flow_steer      = efx_filter_rfs,
+#endif
 };
 
 /*	Netdev registration
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index fcc5b0de76d7..728e2ffd1d77 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -347,6 +347,37 @@ static int ef100_phy_probe(struct efx_nic *efx)
 	return 0;
 }
 
+static int ef100_filter_table_probe(struct efx_nic *efx)
+{
+	return efx_mcdi_filter_table_probe(efx, true);
+}
+
+static int ef100_filter_table_up(struct efx_nic *efx)
+{
+	int rc;
+
+	rc = efx_mcdi_filter_add_vlan(efx, EFX_FILTER_VID_UNSPEC);
+	if (rc) {
+		efx_mcdi_filter_table_down(efx);
+		return rc;
+	}
+
+	rc = efx_mcdi_filter_add_vlan(efx, 0);
+	if (rc) {
+		efx_mcdi_filter_del_vlan(efx, EFX_FILTER_VID_UNSPEC);
+		efx_mcdi_filter_table_down(efx);
+	}
+
+	return rc;
+}
+
+static void ef100_filter_table_down(struct efx_nic *efx)
+{
+	efx_mcdi_filter_del_vlan(efx, 0);
+	efx_mcdi_filter_del_vlan(efx, EFX_FILTER_VID_UNSPEC);
+	efx_mcdi_filter_table_down(efx);
+}
+
 /*	Other
  */
 static int ef100_reconfigure_mac(struct efx_nic *efx, bool mtu_only)
@@ -393,12 +424,24 @@ static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
 		__clear_bit(reset_type, &efx->reset_pending);
 		rc = dev_open(efx->net_dev, NULL);
 	} else if (reset_type == RESET_TYPE_ALL) {
+		/* A RESET_TYPE_ALL will cause filters to be removed, so we remove filters
+		 * and reprobe after reset to avoid removing filters twice
+		 */
+		down_read(&efx->filter_sem);
+		ef100_filter_table_down(efx);
+		up_read(&efx->filter_sem);
 		rc = efx_mcdi_reset(efx, reset_type);
 		if (rc)
 			return rc;
 
 		netif_device_attach(efx->net_dev);
 
+		down_read(&efx->filter_sem);
+		rc = ef100_filter_table_up(efx);
+		up_read(&efx->filter_sem);
+		if (rc)
+			return rc;
+
 		rc = dev_open(efx->net_dev, NULL);
 	} else {
 		rc = 1;	/* Leave the device closed */
@@ -480,6 +523,20 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.rx_remove = efx_mcdi_rx_remove,
 	.rx_write = ef100_rx_write,
 	.rx_packet = __ef100_rx_packet,
+	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
+	.filter_table_probe = ef100_filter_table_up,
+	.filter_table_restore = efx_mcdi_filter_table_restore,
+	.filter_table_remove = ef100_filter_table_down,
+	.filter_insert = efx_mcdi_filter_insert,
+	.filter_remove_safe = efx_mcdi_filter_remove_safe,
+	.filter_get_safe = efx_mcdi_filter_get_safe,
+	.filter_clear_rx = efx_mcdi_filter_clear_rx,
+	.filter_count_rx_used = efx_mcdi_filter_count_rx_used,
+	.filter_get_rx_id_limit = efx_mcdi_filter_get_rx_id_limit,
+	.filter_get_rx_ids = efx_mcdi_filter_get_rx_ids,
+#ifdef CONFIG_RFS_ACCEL
+	.filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
+#endif
 
 	.get_phys_port_id = efx_ef100_get_phys_port_id,
 
@@ -840,6 +897,12 @@ static int ef100_probe_main(struct efx_nic *efx)
 	if (rc)
 		goto fail;
 
+	down_write(&efx->filter_sem);
+	rc = ef100_filter_table_probe(efx);
+	up_write(&efx->filter_sem);
+	if (rc)
+		goto fail;
+
 	rc = ef100_register_netdev(efx);
 	if (rc)
 		goto fail;
@@ -877,6 +940,10 @@ void ef100_remove(struct efx_nic *efx)
 	struct ef100_nic_data *nic_data = efx->nic_data;
 
 	ef100_unregister_netdev(efx);
+
+	down_write(&efx->filter_sem);
+	efx_mcdi_filter_table_remove(efx);
+	up_write(&efx->filter_sem);
 	efx_fini_channels(efx);
 	kfree(efx->phy_data);
 	efx->phy_data = NULL;

