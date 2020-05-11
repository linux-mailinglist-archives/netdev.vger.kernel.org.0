Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B861CD9D5
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbgEKM2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:28:49 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:37912 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728084AbgEKM2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:28:49 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7AE9720057;
        Mon, 11 May 2020 12:28:48 +0000 (UTC)
Received: from us4-mdac16-14.at1.mdlocal (unknown [10.110.49.196])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7AB75800AD;
        Mon, 11 May 2020 12:28:48 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.108])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1CC084006F;
        Mon, 11 May 2020 12:28:48 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C1CF514006E;
        Mon, 11 May 2020 12:28:47 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 May
 2020 13:28:43 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/8] sfc: make capability checking a nic_type
 function
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Message-ID: <ad6213aa-b163-8708-47a4-553cb5aa0a8f@solarflare.com>
Date:   Mon, 11 May 2020 13:28:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25412.003
X-TM-AS-Result: No-4.598100-8.000000-10
X-TMASE-MatchedRID: 8xV9Hp+2OHJj3cEXcFAPHgfC4JY9IggAAhvJX5q+bOPI9EDAP/dptuw1
        gmAhG2GA1ZJ1UkQkpjrGJTjSUOcmhhJ49ZBgqflr8Kg68su2wyFJaD67iKvY0waYevV4zG3ZQBz
        oPKhLasiPqQJ9fQR1zhdOiqtio9PR24yrpGJOf8xbUzvsaHW6BgKflB9+9kWVX1Ahz57P/j6FKd
        8XesWMYMb6b2ifHmVRrf7C4HJrYGnUu3synNQKJM/XkDDEkV4eS23xtUVELfC5ZjHyzYrpGoKJl
        wiZfb2RGQ0YzgwPSLjYFEi+edweG6DjfsaD19Mhqg0gbtLVIa9caNB/u5yQq28w9EHWiptto8WM
        kQWv6iUD0yuKrQIMCD3Al4zalJpFWBd6ltyXuvseb09yDIgMBirHwZ4FiLNv3hgTQ5PqcAQuw/R
        GvgXVQnttQ2eAjB+3gU6PsXwcLKWOfVdNc9sx1c9QSEm+N9f2BCqCscoluYYxwqle67/WNUAzBb
        itj/RY7aFmrxFux0RN2fIyiQnUdOJqixYeb35sftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.598100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25412.003
X-MDID: 1589200128-Z9-dlytyenLO
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Zhao <tzhao@solarflare.com>

Various MCDI functions (especially in filter handling) need to check the
 datapath caps, but those live in nic_data (since they don't exist on
 Siena).  Decouple from ef10-specific data structures by adding check_caps
 to the nic_type, to allow using these functions from non-ef10 drivers.

Also add a convenience macro efx_has_cap() to reduce the amount of
 boilerplate involved in calling it.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c       | 18 ++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h       | 12 ++++++++++++
 drivers/net/ethernet/sfc/net_driver.h |  3 +++
 drivers/net/ethernet/sfc/siena.c      |  7 +++++++
 4 files changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 0ad311ff6796..7b3c6214dee6 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3961,6 +3961,22 @@ static int efx_ef10_udp_tnl_del_port(struct efx_nic *efx,
 	return rc;
 }
 
+static unsigned int ef10_check_caps(const struct efx_nic *efx,
+				    u8 flag,
+				    u32 offset)
+{
+	const struct efx_ef10_nic_data *nic_data = efx->nic_data;
+
+	switch (offset) {
+	case(MC_CMD_GET_CAPABILITIES_V4_OUT_FLAGS1_OFST):
+		return nic_data->datapath_caps & BIT_ULL(flag);
+	case(MC_CMD_GET_CAPABILITIES_V4_OUT_FLAGS2_OFST):
+		return nic_data->datapath_caps2 & BIT_ULL(flag);
+	default:
+		return 0;
+	}
+}
+
 #define EF10_OFFLOAD_FEATURES		\
 	(NETIF_F_IP_CSUM |		\
 	 NETIF_F_HW_VLAN_CTAG_FILTER |	\
@@ -4073,6 +4089,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.hwtstamp_filters = 1 << HWTSTAMP_FILTER_NONE |
 			    1 << HWTSTAMP_FILTER_ALL,
 	.rx_hash_key_size = 40,
+	.check_caps = ef10_check_caps,
 };
 
 const struct efx_nic_type efx_hunt_a0_nic_type = {
@@ -4208,4 +4225,5 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.hwtstamp_filters = 1 << HWTSTAMP_FILTER_NONE |
 			    1 << HWTSTAMP_FILTER_ALL,
 	.rx_hash_key_size = 40,
+	.check_caps = ef10_check_caps,
 };
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 54a45010b576..b107e4c00285 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -326,6 +326,18 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 #define MCDI_EVENT_FIELD(_ev, _field)			\
 	EFX_QWORD_FIELD(_ev, MCDI_EVENT_ ## _field)
 
+#define MCDI_CAPABILITY(field)						\
+	MC_CMD_GET_CAPABILITIES_V4_OUT_ ## field ## _LBN
+
+#define MCDI_CAPABILITY_OFST(field) \
+	MC_CMD_GET_CAPABILITIES_V4_OUT_ ## field ## _OFST
+
+/* field is FLAGS1 or FLAGS2 */
+#define efx_has_cap(efx, flag, field) \
+	efx->type->check_caps(efx, \
+			      MCDI_CAPABILITY(flag), \
+			      MCDI_CAPABILITY_OFST(field))
+
 void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len);
 int efx_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
 			   u16 *fw_subtype_list, u32 *capabilities);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index d43f22c8f31c..bdeea48ff938 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1354,6 +1354,9 @@ struct efx_nic_type {
 	void (*get_wol)(struct efx_nic *efx, struct ethtool_wolinfo *wol);
 	int (*set_wol)(struct efx_nic *efx, u32 type);
 	void (*resume_wol)(struct efx_nic *efx);
+	unsigned int (*check_caps)(const struct efx_nic *efx,
+				   u8 flag,
+				   u32 offset);
 	int (*test_chip)(struct efx_nic *efx, struct efx_self_tests *tests);
 	int (*test_nvram)(struct efx_nic *efx);
 	void (*mcdi_request)(struct efx_nic *efx,
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index baa464161626..ed1cb6caa69d 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -948,6 +948,13 @@ static int siena_mtd_probe(struct efx_nic *efx)
 
 #endif /* CONFIG_SFC_MTD */
 
+unsigned int siena_check_caps(const struct efx_nic *efx,
+			      u8 flag, u32 offset)
+{
+	/* Siena did not support MC_CMD_GET_CAPABILITIES */
+	return 0;
+}
+
 /**************************************************************************
  *
  * Revision-dependent attributes used by efx.c and nic.c

