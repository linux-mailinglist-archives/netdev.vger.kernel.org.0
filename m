Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722566DA9E7
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240229AbjDGIOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240270AbjDGIOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:14:10 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABBCAF0D;
        Fri,  7 Apr 2023 01:13:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdbSZ3gYiDXspWNU+pdbBbYobe3S0oy4QMtU4Z5vR19CP7TnCutx1SyjWa0gDqMsp/MJVQfTVme8eNefmkSbEd2H+ciPg8DaiogMTZ/HCifBiSq5hA5XXtbcq697EbXP09gDSKLCUDVaYtIHZw1yIcuJgtMOH8sbKICmmjmHxssKdxFpTo9stYPiAKuiDbEpwMMWbAoD3YWK/YY2YJmFygbV5eADf+/lofz7pjpQlgnh9tJB4rAsw/oiTvTWIA4/QTmD4FyXlwDvk5gGd/JWqwxOjPZ7euzdCcd2npbj4pPjrLybvPRMeAw17nGLVVNFB4tQjHL+81xr+O3kaXqgzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Spb7iEm4V4e4VtyZuFiXTV2mDwxz1Cv53YrIBPT/exs=;
 b=lmsvlL4Uk+suoQxj1zvTg8CMVzSjrrO+oF8bMQoPsn/XBWxhZIAJ7T1rXuqJMg17ZLe94S4hLbY6NadcPL0oUNDbBQ4AzjZEi3Tjp4CXqtifjZg6YbxlnoxJe6mmVa6oTloWGduOJXQgvqtbaiDZWYntpU8HTOeSRo5rEQfjs5QhmhvtncnN3KT4csD/a7P2OoO9MrMuCSBtYKTnPPa/PkZtEInrme95A8PHuhMQBEuqCE/Q9hkhUywp9eMu5CAWB6g3gfF5UWVqxkDa9zadIzKzqd04TA6J2dY70dtLHWu7CuhVU2cmeWp2ifHvd134gJER3UfHb6y+Hznhcrd3jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Spb7iEm4V4e4VtyZuFiXTV2mDwxz1Cv53YrIBPT/exs=;
 b=irrw09MNb6EYNj506ebKaYfAxAusF29bRrb4VAvfC+pnGMuR6z0E+PWl+UHXLwnIaF5+dggrIDYt++nJlB/81T2RNrlNbcmf++YLf/ruN9hucaVhSsilV9/uV45N+15bc1j+gzqPiLeY/xRc09WygVZCdVVisoflv0JEFqQ9fOE=
Received: from DM6PR01CA0013.prod.exchangelabs.com (2603:10b6:5:296::18) by
 CH2PR12MB4955.namprd12.prod.outlook.com (2603:10b6:610:68::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.31; Fri, 7 Apr 2023 08:12:50 +0000
Received: from CY4PEPF0000B8EF.namprd05.prod.outlook.com
 (2603:10b6:5:296:cafe::53) by DM6PR01CA0013.outlook.office365.com
 (2603:10b6:5:296::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Fri, 7 Apr 2023 08:12:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000B8EF.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.8 via Frontend Transport; Fri, 7 Apr 2023 08:12:49 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:12:48 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:12:44 -0500
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
Subject: [PATCH net-next v4 12/14] sfc: unmap VF's MCDI buffer when switching to vDPA mode
Date:   Fri, 7 Apr 2023 13:40:13 +0530
Message-ID: <20230407081021.30952-13-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EF:EE_|CH2PR12MB4955:EE_
X-MS-Office365-Filtering-Correlation-Id: 9311cb96-ca03-4881-1473-08db373fe0bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JNMnl9TyDiFyWs7P0YunSWPWTlpKuvMXUJwB37FgzJyTdYM5pR/k+1m1B9R/CkESx4pa7yp3vM7H5d0f4JYDM1M0m646AqX22set1xxWAglzPwMCe4T90WRTRqXA1o3MBae/MXuxA+rt+PGOjY1DnbY3dce4oKvWDQw8wBLTho4V6sWSJ9mvRv/SItkekRmquK6+K5wMD5OdBs4KwwH1W2S85cEKVXL0IRe/8deIK91rgATK0nVh6N33S8RwAaOQkndoPSqFWHDF5P4NSdGAw4embnJs0Ohc4TTdL5V4XTtgRKCjkQRXaAWzR0SdY4lTIsZHESuNAXTa7nyiztISa2dmizf0hAtdy2s1WgXYWQoGa+gY53aTQqrukgIzno033Dw+44Z1kClQTW8ft9/r8i0Ji2b9BFzfIxSbrKhR2KCodeAyyM9ovdpNbBK1JSPKUHCPoS/tKJAkH0NIqlUfM30Tj0UNO5SAGJJnCjHlxK9+vFH4XZTcl2HvZd791bk5M1n3dQuI4zXYu0Y3+g4poM0XrpVuFR8KIGICMKw/+r2fbXMUGBvxOD5ZKjaTQZOg/zIQfgPmWKOUBQu3jk9mpYyG2Dl3WhvAZeRmAzowd85JtkLg2PC/BHxMN77KAgZiATowgMNOn0/ARRkyxrPMgS/QJYyEGZlwIvC9aZUZTiNpNHrJd43lyGYow3M03Dd2NcAXeQNLeOP4Q2Eq2PLhgrq2Qr60oVzxzqJshIVMjhIiPt7S/kwXgqsVYH8uQtQp
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199021)(36840700001)(46966006)(40470700004)(426003)(83380400001)(336012)(36860700001)(47076005)(2616005)(82740400003)(316002)(6666004)(478600001)(54906003)(26005)(186003)(1076003)(110136005)(2906002)(44832011)(5660300002)(7416002)(8676002)(40460700003)(36756003)(921005)(81166007)(70586007)(41300700001)(4326008)(356005)(70206006)(40480700001)(82310400005)(86362001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:12:49.4696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9311cb96-ca03-4881-1473-08db373fe0bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4955
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid clash of IOVA range of VF's MCDI DMA buffer with the guest
buffer IOVAs, unmap the MCDI buffer when switching to vDPA mode
and use PF's IOMMU domain for running VF's MCDI commands.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c      |  1 -
 drivers/net/ethernet/sfc/ef100_vdpa.c     | 25 ++++++++++++++++
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  3 ++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 35 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h           |  3 ++
 drivers/net/ethernet/sfc/net_driver.h     | 12 ++++++++
 6 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 6dadfa391327..1b22b5bb01d9 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -34,7 +34,6 @@
 
 #define EF100_MAX_VIS 4096
 #define EF100_NUM_MCDI_BUFFERS	1
-#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
 
 #define EF100_RESET_PORT ((ETH_RESET_MAC | ETH_RESET_PHY) << ETH_RESET_SHARED_SHIFT)
 
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 340a714aa7c6..f8a273a4d221 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -228,10 +228,19 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
 static void ef100_vdpa_delete(struct efx_nic *efx)
 {
 	struct vdpa_device *vdpa_dev;
+	int rc;
 
 	if (efx->vdpa_nic) {
 		vdpa_dev = &efx->vdpa_nic->vdpa_dev;
 		ef100_vdpa_reset(vdpa_dev);
+		if (efx->mcdi_buf_mode == EFX_BUF_MODE_VDPA) {
+			rc = ef100_vdpa_map_mcdi_buffer(efx);
+			if (rc) {
+				pci_err(efx->pci_dev,
+					"map_mcdi_buffer failed, err: %d\n",
+					rc);
+			}
+		}
 
 		/* replace with _vdpa_unregister_device later */
 		put_device(&vdpa_dev->dev);
@@ -281,6 +290,21 @@ static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
 	return 0;
 }
 
+static void unmap_mcdi_buffer(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_mcdi_iface *mcdi;
+
+	mcdi = efx_mcdi(efx);
+	spin_lock_bh(&mcdi->iface_lock);
+	/* Save current MCDI mode to be restored later */
+	efx->vdpa_nic->mcdi_mode = mcdi->mode;
+	efx->mcdi_buf_mode = EFX_BUF_MODE_VDPA;
+	mcdi->mode = MCDI_MODE_FAIL;
+	spin_unlock_bh(&mcdi->iface_lock);
+	efx_nic_free_buffer(efx, &nic_data->mcdi_buf);
+}
+
 static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 						const char *dev_name,
 						enum ef100_vdpa_class dev_type,
@@ -347,6 +371,7 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 	for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
 		vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
 
+	unmap_mcdi_buffer(efx);
 	rc = get_net_config(vdpa_nic);
 	if (rc)
 		goto err_put_device;
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index cf86e1dde2a2..087fcd1c6e69 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -148,6 +148,7 @@ struct ef100_vdpa_filter {
  * @status: device status as per VIRTIO spec
  * @features: negotiated feature bits
  * @max_queue_pairs: maximum number of queue pairs supported
+ * @mcdi_mode: MCDI mode at the time of unmapping VF mcdi buffer
  * @net_config: virtio_net_config data
  * @vring: vring information of the vDPA device.
  * @mac_address: mac address of interface associated with this vdpa device
@@ -167,6 +168,7 @@ struct ef100_vdpa_nic {
 	u8 status;
 	u64 features;
 	u32 max_queue_pairs;
+	enum efx_mcdi_mode mcdi_mode;
 	struct virtio_net_config net_config;
 	struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
 	u8 *mac_address;
@@ -186,6 +188,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
 int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
 void ef100_vdpa_irq_vectors_free(void *data);
 int ef100_vdpa_reset(struct vdpa_device *vdev);
+int ef100_vdpa_map_mcdi_buffer(struct efx_nic *efx);
 
 static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
 {
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index b3b3ae42541c..59d433ec42d3 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -711,12 +711,47 @@ static int ef100_vdpa_suspend(struct vdpa_device *vdev)
 	mutex_unlock(&vdpa_nic->lock);
 	return rc;
 }
+
+int ef100_vdpa_map_mcdi_buffer(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_mcdi_iface *mcdi;
+	int rc;
+
+	/* Update VF's MCDI buffer when switching out of vdpa mode */
+	rc = efx_nic_alloc_buffer(efx, &nic_data->mcdi_buf,
+				  MCDI_BUF_LEN, GFP_KERNEL);
+	if (rc)
+		return rc;
+
+	mcdi = efx_mcdi(efx);
+	spin_lock_bh(&mcdi->iface_lock);
+	mcdi->mode = efx->vdpa_nic->mcdi_mode;
+	efx->mcdi_buf_mode = EFX_BUF_MODE_EF100;
+	spin_unlock_bh(&mcdi->iface_lock);
+
+	return 0;
+}
+
 static void ef100_vdpa_free(struct vdpa_device *vdev)
 {
 	struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
+	int rc;
 	int i;
 
 	if (vdpa_nic) {
+		if (vdpa_nic->efx->mcdi_buf_mode == EFX_BUF_MODE_VDPA) {
+			/* This will only be called via call to put_device()
+			 * on vdpa device creation failure
+			 */
+			rc = ef100_vdpa_map_mcdi_buffer(vdpa_nic->efx);
+			if (rc) {
+				dev_err(&vdev->dev,
+					"map_mcdi_buffer failed, err: %d\n",
+					rc);
+			}
+		}
+
 		for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
 			reset_vring(vdpa_nic, i);
 			if (vdpa_nic->vring[i].vring_ctx)
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 2badf08aa247..cfa78fc04354 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -8,6 +8,9 @@
 
 #ifndef EFX_MCDI_H
 #define EFX_MCDI_H
+#include "mcdi_pcol.h"
+
+#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
 
 /**
  * enum efx_mcdi_state - MCDI request handling state
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 948c7a06403a..9cdfeb6ad05a 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -848,6 +848,16 @@ enum efx_xdp_tx_queues_mode {
 
 struct efx_mae;
 
+/**
+ * enum efx_buf_alloc_mode - buffer allocation mode
+ * @EFX_BUF_MODE_EF100: buffer setup in ef100 mode
+ * @EFX_BUF_MODE_VDPA: buffer setup in vdpa mode
+ */
+enum efx_buf_alloc_mode {
+	EFX_BUF_MODE_EF100,
+	EFX_BUF_MODE_VDPA
+};
+
 /**
  * struct efx_nic - an Efx NIC
  * @name: Device name (net device name or bus id before net device registered)
@@ -877,6 +887,7 @@ struct efx_mae;
  * @irq_rx_mod_step_us: Step size for IRQ moderation for RX event queues
  * @irq_rx_moderation_us: IRQ moderation time for RX event queues
  * @msg_enable: Log message enable flags
+ * @mcdi_buf_mode: mcdi buffer allocation mode
  * @state: Device state number (%STATE_*). Serialised by the rtnl_lock.
  * @reset_pending: Bitmask for pending resets
  * @tx_queue: TX DMA queues
@@ -1045,6 +1056,7 @@ struct efx_nic {
 	u32 msg_enable;
 
 	enum nic_state state;
+	enum efx_buf_alloc_mode mcdi_buf_mode;
 	unsigned long reset_pending;
 
 	struct efx_channel *channel[EFX_MAX_CHANNELS];
-- 
2.30.1

