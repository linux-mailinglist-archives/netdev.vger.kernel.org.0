Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682606DA9E3
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbjDGIOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239888AbjDGINb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:13:31 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3C1B446;
        Fri,  7 Apr 2023 01:12:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fw0GJxCNPaGPxMVVBtiKAeq7tk44DdAAU0mACE10Xf1PJrf1wQLbeZ6jm89VDuHHfkRmIccvW147ewn+EYhYt9UfWJdCJSsDRAdo34fucziHGxG4abEnDCUxDIUaN6LbbM5DgJHd73GtdzKKdKqTupWicUsgDz5LM0On3pwZRe52KeKFrehN3ntCS1N7A+OSaG8tmrlPvCvmN7TnOdL75lOL/jMZbcsmtIbJgiQ4IORzRe7dTMDkesnPM7sLQXYXGIRSflGMK0wOtGgi3+UECxFGlqDupuJ/jGf9gfcHxddh50WTYQxC0N5vOYIN6GfuWhpLsqpepVDgR0ygRXDEBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NkYt2yB3kJCCapaBDKabsgpjOqoSuz56GiMCvc70mR8=;
 b=EDM4O/z0b+DDV3AimKFQkTOfY40I/TGnRbojpS5Z7e4xELX+YUIGvgvEqQq9pwzEF/uUMJqxABxLZh+sq++1hcVYgy2KUTilC6F9CfzCUygXQqawb4JqvdLCG8bBjbgyeOvdH1nritMT7NcvpnKrOHO5ivAVIbbDPF2eERY8GaMsEgLFO+1oNdlmptsthx4/J2fPhc30KVsxatit2H7pYOzi+1A+SwPtJK4rldEf7tmIqhjC6D/Z4oneNDYrBwZRfZZcyv9kPFhpNh3kPjPG7q+V4zcs0DKjpdsL/IdyaEHGfUddJZi01XLkwD+cci0B37XpP0fKL2J7o3bbBDwgIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkYt2yB3kJCCapaBDKabsgpjOqoSuz56GiMCvc70mR8=;
 b=FJqINszNW4yQvxjb8td+Uu//VPdelgFuzFxRlCWqt05LeugFBCWeNYeB6IeWb9wL8hkStS2L+NmpW8B/3Qa6uBRuuiG4l7siEy9SXJuNp4Sixk/90kM9xOP5Rmw4NmReyNpDix61sw0TUJzfupNjuP1p+gmb+Wki01xCkm7o4ds=
Received: from BN0PR04CA0090.namprd04.prod.outlook.com (2603:10b6:408:ea::35)
 by SN7PR12MB7201.namprd12.prod.outlook.com (2603:10b6:806:2a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Fri, 7 Apr
 2023 08:12:31 +0000
Received: from BN8NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::32) by BN0PR04CA0090.outlook.office365.com
 (2603:10b6:408:ea::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Fri, 7 Apr 2023 08:12:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT076.mail.protection.outlook.com (10.13.176.174) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.20 via Frontend Transport; Fri, 7 Apr 2023 08:12:31 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:12:30 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:12:08 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:12:04 -0500
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <jasowang@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <eperezma@redhat.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, <koushik.dutta@amd.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Subject: [PATCH net-next v4 10/14] sfc: implement filters for receiving traffic
Date:   Fri, 7 Apr 2023 13:40:11 +0530
Message-ID: <20230407081021.30952-11-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT076:EE_|SN7PR12MB7201:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a88c5e1-9eeb-45ab-708a-08db373fd609
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FqUOIm0zVOiTTdRQUyrDDyg3mV2P+su7CbdEJgXUhZM6AU7tV0aKw7Budb1po+8T4gO4P0y9rQ8M+/8xrt/VcWsdYtWb4fbmKyqA0V5dYBl+gkeUBuhpvp5S+UbazWz1wTHZmCnMnZA55OtlVH97iAtKN8u1YR7NBA1LSA/JaamkFBwtCaj2qkjzO1Iw4l7sYFBNZSz+Bbd2vCS+aeb+SIHS9++tsC9C7UWrdQH+Rkk4aBJTMLogPXviCo8fxW0LNiiLxMHL6FXDD7xF6+JbfMB1BhGbfWv5up9YuoaaJ+OBZH2xIEOcCiZPZS6Ujs8SppdF9OxThcudPII1pY2MFOnbpWJO3aqIRMX9C7mfgLJun0xD3yYL89CUyMFHXa4PduRi0LGIqScYnf5WpObiXfBcC3R5XKhlWg4cfMv540NNiv0Zb478NrcmZhiRhE1WMWavsmtOMDUHZ5qG1AmSFRb1N3hmFqgP1SQbG3OnocT/s/8TdbKCgSzbvtqHCGRhCSMl2JoJiofcUKXkN8DPkC9CFPkrtEcQIeLKaTi/eW0oCT6qHWPMP6lzCifgsRcdX9tCZ0f8MaB1Zwz3wGSMUNwykxAmy7nBfTSl77lcu/hirDl3x5Y8RI4Lewiof5y4UPIIOPqi2QUH/Bu9VnaNcC9r63zJd7e9Kg+JI7GqNb0TFH1iXfPkZSSUNJ6hIWqSRdZB4lyQBb/6Mb5bc5gDOo89KwCMeRZ8Q0UufrFT9mjCWEx8OWXKKYhYZPVY/1mm
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(186003)(36860700001)(40480700001)(47076005)(426003)(336012)(54906003)(110136005)(6666004)(316002)(2616005)(2906002)(1076003)(478600001)(26005)(83380400001)(7416002)(82310400005)(356005)(4326008)(81166007)(36756003)(44832011)(921005)(40460700003)(8676002)(8936002)(70206006)(41300700001)(82740400003)(5660300002)(86362001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:12:31.5998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a88c5e1-9eeb-45ab-708a-08db373fd609
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7201
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement unicast, broadcast and unknown multicast
filters for receiving different types of traffic.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_vdpa.c     | 162 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  36 ++++-
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  15 +-
 3 files changed, 211 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index f4a940961f9d..340a714aa7c6 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -16,12 +16,171 @@
 #include "mcdi_filters.h"
 #include "mcdi_functions.h"
 #include "ef100_netdev.h"
+#include "filter.h"
+#include "efx.h"
 
+#define EFX_INVALID_FILTER_ID -1
+
+/* vDPA queues starts from 2nd VI or qid 1 */
+#define EF100_VDPA_BASE_RX_QID 1
+
+static const char * const filter_names[] = { "bcast", "ucast", "mcast" };
 static struct virtio_device_id ef100_vdpa_id_table[] = {
 	{ .device = VIRTIO_ID_NET, .vendor = PCI_VENDOR_ID_REDHAT_QUMRANET },
 	{ 0 },
 };
 
+static int ef100_vdpa_set_mac_filter(struct efx_nic *efx,
+				     struct efx_filter_spec *spec,
+				     u32 qid, u8 *mac_addr)
+{
+	struct vdpa_device *vdev = &efx->vdpa_nic->vdpa_dev;
+	int rc;
+
+	efx_filter_init_rx(spec, EFX_FILTER_PRI_AUTO, 0, qid);
+
+	if (mac_addr) {
+		rc = efx_filter_set_eth_local(spec, EFX_FILTER_VID_UNSPEC,
+					      mac_addr);
+		if (rc) {
+			dev_err(&vdev->dev,
+				"Filter set eth local failed, err: %d\n", rc);
+			return rc;
+		}
+	} else {
+		efx_filter_set_mc_def(spec);
+	}
+
+	rc = efx_filter_insert_filter(efx, spec, true);
+	if (rc < 0)
+		dev_err(&vdev->dev,
+			"Filter insert failed, err: %d\n", rc);
+
+	return rc;
+}
+
+static int ef100_vdpa_delete_filter(struct ef100_vdpa_nic *vdpa_nic,
+				    enum ef100_vdpa_mac_filter_type type)
+{
+	struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
+	int rc = 0;
+
+	if (vdpa_nic->filters[type].filter_id == EFX_INVALID_FILTER_ID)
+		return rc;
+
+	rc = efx_filter_remove_id_safe(vdpa_nic->efx,
+				       EFX_FILTER_PRI_AUTO,
+				       vdpa_nic->filters[type].filter_id);
+	if (rc) {
+		dev_err(&vdev->dev, "%s filter id: %d remove failed, err: %d\n",
+			filter_names[type], vdpa_nic->filters[type].filter_id,
+			rc);
+		return rc;
+	}
+
+	vdpa_nic->filters[type].filter_id = EFX_INVALID_FILTER_ID;
+	vdpa_nic->filter_cnt--;
+
+	return 0;
+}
+
+int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
+			  enum ef100_vdpa_mac_filter_type type)
+{
+	struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
+	struct efx_nic *efx = vdpa_nic->efx;
+	/* Configure filter on base Rx queue only */
+	u32 qid = EF100_VDPA_BASE_RX_QID;
+	struct efx_filter_spec *spec;
+	u8 baddr[ETH_ALEN];
+	int rc;
+
+	/* remove existing filter */
+	rc = ef100_vdpa_delete_filter(vdpa_nic, type);
+	if (rc < 0) {
+		dev_err(&vdev->dev, "%s MAC filter deletion failed, err: %d",
+			filter_names[type], rc);
+		return rc;
+	}
+
+	/* Configure MAC Filter */
+	spec = &vdpa_nic->filters[type].spec;
+	if (type == EF100_VDPA_BCAST_MAC_FILTER) {
+		eth_broadcast_addr(baddr);
+		rc = ef100_vdpa_set_mac_filter(efx, spec, qid, baddr);
+	} else if (type == EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
+		rc = ef100_vdpa_set_mac_filter(efx, spec, qid, NULL);
+	} else {
+		/* Ensure we have a valid mac address */
+		if (!vdpa_nic->mac_configured ||
+		    !is_valid_ether_addr(vdpa_nic->mac_address)) {
+			dev_dbg(&vdev->dev,
+				"%s: unicast MAC not configured\n", __func__);
+			return -EINVAL;
+		}
+
+		rc = ef100_vdpa_set_mac_filter(efx, spec, qid,
+					       vdpa_nic->mac_address);
+	}
+
+	if (rc >= 0) {
+		vdpa_nic->filters[type].filter_id = rc;
+		vdpa_nic->filter_cnt++;
+
+		return 0;
+	}
+
+	dev_err(&vdev->dev, "%s MAC filter insert failed, err: %d\n",
+		filter_names[type], rc);
+
+	if (type != EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
+		ef100_vdpa_filter_remove(vdpa_nic);
+		return rc;
+	}
+
+	return 0;
+}
+
+int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic)
+{
+	enum ef100_vdpa_mac_filter_type filter;
+	int err = 0;
+	int rc;
+
+	for (filter = EF100_VDPA_BCAST_MAC_FILTER;
+	     filter <= EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
+		rc = ef100_vdpa_delete_filter(vdpa_nic, filter);
+		if (rc < 0)
+			/* store status of last failed filter remove */
+			err = rc;
+	}
+	return err;
+}
+
+int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic)
+{
+	struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
+	enum ef100_vdpa_mac_filter_type filter;
+	int rc;
+
+	/* remove existing filters, if any */
+	rc = ef100_vdpa_filter_remove(vdpa_nic);
+	if (rc < 0) {
+		dev_err(&vdev->dev,
+			"MAC filter deletion failed, err: %d", rc);
+		return rc;
+	}
+
+	for (filter = EF100_VDPA_BCAST_MAC_FILTER;
+	     filter <= EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
+		rc = ef100_vdpa_add_filter(vdpa_nic, filter);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
 int ef100_vdpa_init(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
@@ -185,6 +344,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 		goto err_put_device;
 	}
 
+	for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
+		vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
+
 	rc = get_net_config(vdpa_nic);
 	if (rc)
 		goto err_put_device;
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index d2d457692008..cf86e1dde2a2 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -73,6 +73,22 @@ enum ef100_vdpa_vq_type {
 	EF100_VDPA_VQ_NTYPES
 };
 
+/**
+ * enum ef100_vdpa_mac_filter_type - vdpa filter types
+ *
+ * @EF100_VDPA_BCAST_MAC_FILTER: Broadcast MAC filter
+ * @EF100_VDPA_UCAST_MAC_FILTER: Unicast MAC filter
+ * @EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER: Unknown multicast MAC filter to allow
+ *	IPv6 Neighbor Solicitation Message
+ * @EF100_VDPA_MAC_FILTER_NTYPES: Number of vDPA filter types
+ */
+enum ef100_vdpa_mac_filter_type {
+	EF100_VDPA_BCAST_MAC_FILTER,
+	EF100_VDPA_UCAST_MAC_FILTER,
+	EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER,
+	EF100_VDPA_MAC_FILTER_NTYPES,
+};
+
 /**
  * struct ef100_vdpa_vring_info - vDPA vring data structure
  *
@@ -108,6 +124,17 @@ struct ef100_vdpa_vring_info {
 	struct vdpa_callback cb;
 };
 
+/**
+ * struct ef100_vdpa_filter - vDPA filter data structure
+ *
+ * @filter_id: filter id of this filter
+ * @efx_filter_spec: hardware filter specs for this vdpa device
+ */
+struct ef100_vdpa_filter {
+	s32 filter_id;
+	struct efx_filter_spec spec;
+};
+
 /**
  *  struct ef100_vdpa_nic - vDPA NIC data structure
  *
@@ -117,6 +144,7 @@ struct ef100_vdpa_vring_info {
  * @lock: Managing access to vdpa config operations
  * @pf_index: PF index of the vDPA VF
  * @vf_index: VF index of the vDPA VF
+ * @filter_cnt: total number of filters created on this vdpa device
  * @status: device status as per VIRTIO spec
  * @features: negotiated feature bits
  * @max_queue_pairs: maximum number of queue pairs supported
@@ -124,6 +152,7 @@ struct ef100_vdpa_vring_info {
  * @vring: vring information of the vDPA device.
  * @mac_address: mac address of interface associated with this vdpa device
  * @mac_configured: true after MAC address is configured
+ * @filters: details of all filters created on this vdpa device
  * @cfg_cb: callback for config change
  */
 struct ef100_vdpa_nic {
@@ -134,6 +163,7 @@ struct ef100_vdpa_nic {
 	struct mutex lock;
 	u32 pf_index;
 	u32 vf_index;
+	u32 filter_cnt;
 	u8 status;
 	u64 features;
 	u32 max_queue_pairs;
@@ -141,6 +171,7 @@ struct ef100_vdpa_nic {
 	struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
 	u8 *mac_address;
 	bool mac_configured;
+	struct ef100_vdpa_filter filters[EF100_VDPA_MAC_FILTER_NTYPES];
 	struct vdpa_callback cfg_cb;
 };
 
@@ -148,7 +179,10 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data);
 void ef100_vdpa_fini(struct efx_probe_data *probe_data);
 int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
 void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
-void ef100_vdpa_irq_vectors_free(void *data);
+int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic);
+int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic);
+int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
+			  enum ef100_vdpa_mac_filter_type type);
 int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
 void ef100_vdpa_irq_vectors_free(void *data);
 int ef100_vdpa_reset(struct vdpa_device *vdev);
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index 13f657d56578..b3b3ae42541c 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -261,6 +261,7 @@ static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
 	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
 	vdpa_nic->status = 0;
 	vdpa_nic->features = 0;
+	ef100_vdpa_filter_remove(vdpa_nic);
 	for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
 		reset_vring(vdpa_nic, i);
 	ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
@@ -309,9 +310,19 @@ static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
 		}
 	}
 
+	rc = ef100_vdpa_filter_configure(vdpa_nic);
+	if (rc < 0) {
+		dev_err(&vdpa_nic->vdpa_dev.dev,
+			"%s: vdpa configure filter failed, err: %d\n",
+			__func__, rc);
+		goto err_filter_configure;
+	}
+
 	vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
 	return 0;
 
+err_filter_configure:
+	ef100_vdpa_filter_remove(vdpa_nic);
 clear_vring:
 	for (j = 0; j < i; j++)
 		delete_vring(vdpa_nic, j);
@@ -679,8 +690,10 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
 	}
 
 	memcpy((u8 *)&vdpa_nic->net_config + offset, buf, len);
-	if (is_valid_ether_addr(vdpa_nic->mac_address))
+	if (is_valid_ether_addr(vdpa_nic->mac_address)) {
 		vdpa_nic->mac_configured = true;
+		ef100_vdpa_add_filter(vdpa_nic, EF100_VDPA_UCAST_MAC_FILTER);
+	}
 }
 
 static int ef100_vdpa_suspend(struct vdpa_device *vdev)
-- 
2.30.1

