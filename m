Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C386692C47
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjBKAuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjBKAut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:50:49 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1FF7E8C0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 16:50:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kL5adUx1Sn/FnrhCdXhSDSF7dVq9RtuXkeT8EofWx6/t+YaAA4mq0WERYx/FQf7e0EVTEElBnDTrKT2/zMGxS1XSJhgLHhJXoAANrUuUgzI9esweN5fdGt/5MeOaecsIw01q7sk4Dkzh+RfuASRrOA01bxTGZUi2SMFLWOKsgaSnMXHtoAsJJSBPLB+5bsMosMgzirFon5maiSuNP1YVSXL+U5B/FZQmrJPJpdigB52SsaJjLE2iYmuAs0CycZDQ1fGH3xDFtFcowK56gwO3uxqbauZ4W56xgF6sDtodT+As9P28vi5/yR4z6DGkkY/Yc9xdC2kAU840jljq4DxGUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VszhBOi6qlGfFpv+l6DpZnGycVfWM3msmbW4pyvnatU=;
 b=N4Jgt3tooVNdb5NPlzqHOzmGneHcrjdZLl0x+LeCRVW+bYwvE0x0HWLvVwtFqMk4+OVqWxQ3dn2RXKzhGubgWvkfbf2rSwF1cmdcyGpd7wPtVaCVAC8qARcpdd+1Xu1+vHK5XpkHgYmsAzITJMjtmBOdFlx3w6dJpi94uPeW2UUUPHozKBgk9DmEK94JmJIgDodvF0/CXOLdorQCQ5J74qrnbocGzTompKBJmK7SivL8UHtqjMKl5pJrr8EwZ3F4YkgiV1Li6K2ZOr8/thA4Y+km4EfbuXzneqZanjr4DaHczBilsTgnNei3Hk2OD8IRM8sIuMrPv7OGxAXRL6QGEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VszhBOi6qlGfFpv+l6DpZnGycVfWM3msmbW4pyvnatU=;
 b=UYzS0VULAAaPcdkWOrt52dfJrWgNnyaPzjtFSMr+zea4jpK8+V/eEGntBWoqd2y1QBCQCqm+8uUH0/id6x+eoP6e+ocDz0zUn5D4cq0tk7tG61oA0XwHq9vhPHrvIf4iUVxQDPBHLrCxYKKtlANX4iptvmY6dI3DhntdR8Z+1UI=
Received: from CY5PR19CA0111.namprd19.prod.outlook.com (2603:10b6:930:64::16)
 by SJ0PR12MB5611.namprd12.prod.outlook.com (2603:10b6:a03:426::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Sat, 11 Feb
 2023 00:50:39 +0000
Received: from CY4PEPF0000C969.namprd02.prod.outlook.com
 (2603:10b6:930:64:cafe::e5) by CY5PR19CA0111.outlook.office365.com
 (2603:10b6:930:64::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22 via Frontend
 Transport; Sat, 11 Feb 2023 00:50:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C969.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.16 via Frontend Transport; Sat, 11 Feb 2023 00:50:39 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 18:50:36 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v4 net-next 4/4] ionic: add tx/rx-push support with device Component Memory Buffers
Date:   Fri, 10 Feb 2023 16:50:17 -0800
Message-ID: <20230211005017.48134-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230211005017.48134-1-shannon.nelson@amd.com>
References: <20230211005017.48134-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C969:EE_|SJ0PR12MB5611:EE_
X-MS-Office365-Filtering-Correlation-Id: 79fefb97-ea19-4097-796c-08db0bc9fea3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V4hf0Ni2/3eZiVWg4iDA8WiYooYIy/VGEsApMrFqKyqlad58i0lDHLkTA3h+tacK/32ncA/8a+ZtYBEx1DBHz4QzIoH0Xdb8nU3/gx61tiFO2tIWlfPUjT1dzTXU2HOmJC2/f+YmCvZS7ERhBrFCvuNr3zRY+kEtiIEGq+FB8y4MibjsasFgT0sVDcbKXzquvSTHIiKhvlxlARlzTqIrA1eFBRZXy2A5FTonNceiCho7Nl7YrqE+WVa8DIwm+ZGuvDHtKk2FPKX6SjK43VINYgyY3klbXqblpY9VkZkU4l0p+liLbc6GeasXYcG3DDn+MN/9KBYiWn8zMRV5YNrR/UDrYnnepOnlL7S1lfGK5jwEqmL3AMRTHAK/nx4bLXJy18Pr9+iGeUWdDDS4buDXjcKz3XeXH3uB9r1XaXbObNk8y66HcyMv99k4QVAuBnOE0A6Msym3d2nFGWPCWXrW4vx2wQtTJKUPBuU+otxETTT5oGONZnmmgq16S+0OBgx2dAFFyZOj3A6IhAvt+y3Aczo0ZHLh2JCz43xG3O3Obp0RKlGeLUlxWsRmLpOaWUwUTApCbcqW2zpNkOCnKfyXS4cZN9C6fN/AWB2V3MNdmYI3r7YkhgLEfgbtCnbCR9ywcvOx7F8OzWtgYUrGnjx6F8zNOC6OAVx5yRHCIW7pSjDFKVGn2m5Ow1IcnteVgfPlBHdt/pky05nX4qpYPmghxf4hqUnhj3L4MWbEvdscYmc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(346002)(396003)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(70206006)(316002)(83380400001)(54906003)(110136005)(8676002)(8936002)(5660300002)(6666004)(4326008)(41300700001)(70586007)(478600001)(1076003)(16526019)(186003)(26005)(336012)(426003)(2616005)(356005)(47076005)(40480700001)(36756003)(82310400005)(86362001)(2906002)(44832011)(30864003)(36860700001)(82740400003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 00:50:39.0578
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79fefb97-ea19-4097-796c-08db0bc9fea3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C969.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5611
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ionic device has on-board memory (CMB) that can be used
for descriptors as a way to speed descriptor access for faster
packet processing.  It is rumored to improve latency and/or
packets-per-second for some profiles of small packet traffic,
although your mileage may vary.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |   2 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  67 ++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  13 ++
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 117 ++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_if.h    |   3 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 161 ++++++++++++++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  40 ++++-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  22 ++-
 8 files changed, 404 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 0eff78fa0565..e508f8eb43bf 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -352,6 +352,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_reset:
 	ionic_reset(ionic);
 err_out_teardown:
+	ionic_dev_teardown(ionic);
 	pci_clear_master(pdev);
 	/* Don't fail the probe for these errors, keep
 	 * the hw interface around for inspection
@@ -390,6 +391,7 @@ static void ionic_remove(struct pci_dev *pdev)
 
 	ionic_port_reset(ionic);
 	ionic_reset(ionic);
+	ionic_dev_teardown(ionic);
 	pci_clear_master(pdev);
 	ionic_unmap_bars(ionic);
 	pci_release_regions(pdev);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 626b9113e7c4..9c2be75ffbab 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -92,6 +92,7 @@ int ionic_dev_setup(struct ionic *ionic)
 	unsigned int num_bars = ionic->num_bars;
 	struct ionic_dev *idev = &ionic->idev;
 	struct device *dev = ionic->dev;
+	int size;
 	u32 sig;
 
 	/* BAR0: dev_cmd and interrupts */
@@ -133,9 +134,36 @@ int ionic_dev_setup(struct ionic *ionic)
 	idev->db_pages = bar->vaddr;
 	idev->phy_db_pages = bar->bus_addr;
 
+	/* BAR2: optional controller memory mapping */
+	bar++;
+	mutex_init(&idev->cmb_inuse_lock);
+	if (num_bars < 3 || !ionic->bars[IONIC_PCI_BAR_CMB].len) {
+		idev->cmb_inuse = NULL;
+		return 0;
+	}
+
+	idev->phy_cmb_pages = bar->bus_addr;
+	idev->cmb_npages = bar->len / PAGE_SIZE;
+	size = BITS_TO_LONGS(idev->cmb_npages) * sizeof(long);
+	idev->cmb_inuse = kzalloc(size, GFP_KERNEL);
+	if (!idev->cmb_inuse)
+		dev_warn(dev, "No memory for CMB, disabling\n");
+
 	return 0;
 }
 
+void ionic_dev_teardown(struct ionic *ionic)
+{
+	struct ionic_dev *idev = &ionic->idev;
+
+	kfree(idev->cmb_inuse);
+	idev->cmb_inuse = NULL;
+	idev->phy_cmb_pages = 0;
+	idev->cmb_npages = 0;
+
+	mutex_destroy(&idev->cmb_inuse_lock);
+}
+
 /* Devcmd Interface */
 bool ionic_is_fw_running(struct ionic_dev *idev)
 {
@@ -571,6 +599,33 @@ int ionic_db_page_num(struct ionic_lif *lif, int pid)
 	return (lif->hw_index * lif->dbid_count) + pid;
 }
 
+int ionic_get_cmb(struct ionic_lif *lif, u32 *pgid, phys_addr_t *pgaddr, int order)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+	int ret;
+
+	mutex_lock(&idev->cmb_inuse_lock);
+	ret = bitmap_find_free_region(idev->cmb_inuse, idev->cmb_npages, order);
+	mutex_unlock(&idev->cmb_inuse_lock);
+
+	if (ret < 0)
+		return ret;
+
+	*pgid = ret;
+	*pgaddr = idev->phy_cmb_pages + ret * PAGE_SIZE;
+
+	return 0;
+}
+
+void ionic_put_cmb(struct ionic_lif *lif, u32 pgid, int order)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+
+	mutex_lock(&idev->cmb_inuse_lock);
+	bitmap_release_region(idev->cmb_inuse, pgid, order);
+	mutex_unlock(&idev->cmb_inuse_lock);
+}
+
 int ionic_cq_init(struct ionic_lif *lif, struct ionic_cq *cq,
 		  struct ionic_intr_info *intr,
 		  unsigned int num_descs, size_t desc_size)
@@ -679,6 +734,18 @@ void ionic_q_map(struct ionic_queue *q, void *base, dma_addr_t base_pa)
 		cur->desc = base + (i * q->desc_size);
 }
 
+void ionic_q_cmb_map(struct ionic_queue *q, void __iomem *base, dma_addr_t base_pa)
+{
+	struct ionic_desc_info *cur;
+	unsigned int i;
+
+	q->cmb_base = base;
+	q->cmb_base_pa = base_pa;
+
+	for (i = 0, cur = q->info; i < q->num_descs; i++, cur++)
+		cur->cmb_desc = base + (i * q->desc_size);
+}
+
 void ionic_q_sg_map(struct ionic_queue *q, void *base, dma_addr_t base_pa)
 {
 	struct ionic_desc_info *cur;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 2a1d7b9c07e7..a4a8802f3771 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -153,6 +153,11 @@ struct ionic_dev {
 	struct ionic_intr __iomem *intr_ctrl;
 	u64 __iomem *intr_status;
 
+	struct mutex cmb_inuse_lock; /* for cmb_inuse */
+	unsigned long *cmb_inuse;
+	dma_addr_t phy_cmb_pages;
+	u32 cmb_npages;
+
 	u32 port_info_sz;
 	struct ionic_port_info *port_info;
 	dma_addr_t port_info_pa;
@@ -197,6 +202,7 @@ struct ionic_desc_info {
 		struct ionic_rxq_desc *rxq_desc;
 		struct ionic_admin_cmd *adminq_desc;
 	};
+	void __iomem *cmb_desc;
 	union {
 		void *sg_desc;
 		struct ionic_txq_sg_desc *txq_sg_desc;
@@ -233,12 +239,14 @@ struct ionic_queue {
 		struct ionic_rxq_desc *rxq;
 		struct ionic_admin_cmd *adminq;
 	};
+	void __iomem *cmb_base;
 	union {
 		void *sg_base;
 		struct ionic_txq_sg_desc *txq_sgl;
 		struct ionic_rxq_sg_desc *rxq_sgl;
 	};
 	dma_addr_t base_pa;
+	dma_addr_t cmb_base_pa;
 	dma_addr_t sg_base_pa;
 	unsigned int desc_size;
 	unsigned int sg_desc_size;
@@ -301,6 +309,7 @@ static inline bool ionic_q_has_space(struct ionic_queue *q, unsigned int want)
 
 void ionic_init_devinfo(struct ionic *ionic);
 int ionic_dev_setup(struct ionic *ionic);
+void ionic_dev_teardown(struct ionic *ionic);
 
 void ionic_dev_cmd_go(struct ionic_dev *idev, union ionic_dev_cmd *cmd);
 u8 ionic_dev_cmd_status(struct ionic_dev *idev);
@@ -336,6 +345,9 @@ void ionic_dev_cmd_adminq_init(struct ionic_dev *idev, struct ionic_qcq *qcq,
 
 int ionic_db_page_num(struct ionic_lif *lif, int pid);
 
+int ionic_get_cmb(struct ionic_lif *lif, u32 *pgid, phys_addr_t *pgaddr, int order);
+void ionic_put_cmb(struct ionic_lif *lif, u32 pgid, int order);
+
 int ionic_cq_init(struct ionic_lif *lif, struct ionic_cq *cq,
 		  struct ionic_intr_info *intr,
 		  unsigned int num_descs, size_t desc_size);
@@ -352,6 +364,7 @@ int ionic_q_init(struct ionic_lif *lif, struct ionic_dev *idev,
 		 unsigned int num_descs, size_t desc_size,
 		 size_t sg_desc_size, unsigned int pid);
 void ionic_q_map(struct ionic_queue *q, void *base, dma_addr_t base_pa);
+void ionic_q_cmb_map(struct ionic_queue *q, void __iomem *base, dma_addr_t base_pa);
 void ionic_q_sg_map(struct ionic_queue *q, void *base, dma_addr_t base_pa);
 void ionic_q_post(struct ionic_queue *q, bool ring_doorbell, ionic_desc_cb cb,
 		  void *cb_arg);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 01c22701482d..cf33503468a3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -511,6 +511,87 @@ static int ionic_set_coalesce(struct net_device *netdev,
 	return 0;
 }
 
+static int ionic_validate_cmb_config(struct ionic_lif *lif,
+				     struct ionic_queue_params *qparam)
+{
+	int pages_have, pages_required = 0;
+	unsigned long sz;
+
+	if (!lif->ionic->idev.cmb_inuse &&
+	    (qparam->cmb_tx || qparam->cmb_rx)) {
+		netdev_info(lif->netdev, "CMB rings are not supported on this device\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (qparam->cmb_tx) {
+		if (!(lif->qtype_info[IONIC_QTYPE_TXQ].features & IONIC_QIDENT_F_CMB)) {
+			netdev_info(lif->netdev,
+				    "CMB rings for tx-push are not supported on this device\n");
+			return -EOPNOTSUPP;
+		}
+
+		sz = sizeof(struct ionic_txq_desc) * qparam->ntxq_descs * qparam->nxqs;
+		pages_required += ALIGN(sz, PAGE_SIZE) / PAGE_SIZE;
+	}
+
+	if (qparam->cmb_rx) {
+		if (!(lif->qtype_info[IONIC_QTYPE_RXQ].features & IONIC_QIDENT_F_CMB)) {
+			netdev_info(lif->netdev,
+				    "CMB rings for rx-push are not supported on this device\n");
+			return -EOPNOTSUPP;
+		}
+
+		sz = sizeof(struct ionic_rxq_desc) * qparam->nrxq_descs * qparam->nxqs;
+		pages_required += ALIGN(sz, PAGE_SIZE) / PAGE_SIZE;
+	}
+
+	pages_have = lif->ionic->bars[IONIC_PCI_BAR_CMB].len / PAGE_SIZE;
+	if (pages_required > pages_have) {
+		netdev_info(lif->netdev,
+			    "Not enough CMB pages for number of queues and size of descriptor rings, need %d have %d",
+			    pages_required, pages_have);
+		return -ENOMEM;
+	}
+
+	return pages_required;
+}
+
+static int ionic_cmb_rings_toggle(struct ionic_lif *lif, bool cmb_tx, bool cmb_rx)
+{
+	struct ionic_queue_params qparam;
+	int pages_used;
+
+	if (netif_running(lif->netdev)) {
+		netdev_info(lif->netdev, "Please stop device to toggle CMB for tx/rx-push\n");
+		return -EBUSY;
+	}
+
+	ionic_init_queue_params(lif, &qparam);
+	qparam.cmb_tx = cmb_tx;
+	qparam.cmb_rx = cmb_rx;
+	pages_used = ionic_validate_cmb_config(lif, &qparam);
+	if (pages_used < 0)
+		return pages_used;
+
+	if (cmb_tx)
+		set_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state);
+	else
+		clear_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state);
+
+	if (cmb_rx)
+		set_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state);
+	else
+		clear_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state);
+
+	if (cmb_tx || cmb_rx)
+		netdev_info(lif->netdev, "Enabling CMB %s %s rings - %d pages\n",
+			    cmb_tx ? "TX" : "", cmb_rx ? "RX" : "", pages_used);
+	else
+		netdev_info(lif->netdev, "Disabling CMB rings\n");
+
+	return 0;
+}
+
 static void ionic_get_ringparam(struct net_device *netdev,
 				struct ethtool_ringparam *ring,
 				struct kernel_ethtool_ringparam *kernel_ring,
@@ -522,6 +603,8 @@ static void ionic_get_ringparam(struct net_device *netdev,
 	ring->tx_pending = lif->ntxq_descs;
 	ring->rx_max_pending = IONIC_MAX_RX_DESC;
 	ring->rx_pending = lif->nrxq_descs;
+	kernel_ring->tx_push = test_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state);
+	kernel_ring->rx_push = test_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state);
 }
 
 static int ionic_set_ringparam(struct net_device *netdev,
@@ -551,9 +634,28 @@ static int ionic_set_ringparam(struct net_device *netdev,
 
 	/* if nothing to do return success */
 	if (ring->tx_pending == lif->ntxq_descs &&
-	    ring->rx_pending == lif->nrxq_descs)
+	    ring->rx_pending == lif->nrxq_descs &&
+	    kernel_ring->tx_push == test_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state) &&
+	    kernel_ring->rx_push == test_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state))
 		return 0;
 
+	qparam.ntxq_descs = ring->tx_pending;
+	qparam.nrxq_descs = ring->rx_pending;
+	qparam.cmb_tx = kernel_ring->tx_push;
+	qparam.cmb_rx = kernel_ring->rx_push;
+
+	err = ionic_validate_cmb_config(lif, &qparam);
+	if (err < 0)
+		return err;
+
+	if (kernel_ring->tx_push != test_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state) ||
+	    kernel_ring->rx_push != test_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state)) {
+		err = ionic_cmb_rings_toggle(lif, kernel_ring->tx_push,
+					     kernel_ring->rx_push);
+		if (err < 0)
+			return err;
+	}
+
 	if (ring->tx_pending != lif->ntxq_descs)
 		netdev_info(netdev, "Changing Tx ring size from %d to %d\n",
 			    lif->ntxq_descs, ring->tx_pending);
@@ -569,9 +671,6 @@ static int ionic_set_ringparam(struct net_device *netdev,
 		return 0;
 	}
 
-	qparam.ntxq_descs = ring->tx_pending;
-	qparam.nrxq_descs = ring->rx_pending;
-
 	mutex_lock(&lif->queue_lock);
 	err = ionic_reconfigure_queues(lif, &qparam);
 	mutex_unlock(&lif->queue_lock);
@@ -638,7 +737,7 @@ static int ionic_set_channels(struct net_device *netdev,
 				    lif->nxqs, ch->combined_count);
 
 		qparam.nxqs = ch->combined_count;
-		qparam.intr_split = 0;
+		qparam.intr_split = false;
 	} else {
 		max_cnt /= 2;
 		if (ch->rx_count > max_cnt)
@@ -654,9 +753,13 @@ static int ionic_set_channels(struct net_device *netdev,
 				    lif->nxqs, ch->rx_count);
 
 		qparam.nxqs = ch->rx_count;
-		qparam.intr_split = 1;
+		qparam.intr_split = true;
 	}
 
+	err = ionic_validate_cmb_config(lif, &qparam);
+	if (err < 0)
+		return err;
+
 	/* if we're not running, just set the values and return */
 	if (!netif_running(lif->netdev)) {
 		lif->nxqs = qparam.nxqs;
@@ -965,6 +1068,8 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_TX,
+	.supported_ring_params = ETHTOOL_RING_USE_TX_PUSH |
+				 ETHTOOL_RING_USE_RX_PUSH,
 	.get_drvinfo		= ionic_get_drvinfo,
 	.get_regs_len		= ionic_get_regs_len,
 	.get_regs		= ionic_get_regs,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index eac09b2375b8..9a1825edf0d0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -3073,9 +3073,10 @@ union ionic_adminq_comp {
 
 #define IONIC_BARS_MAX			6
 #define IONIC_PCI_BAR_DBELL		1
+#define IONIC_PCI_BAR_CMB		2
 
-/* BAR0 */
 #define IONIC_BAR0_SIZE				0x8000
+#define IONIC_BAR2_SIZE				0x800000
 
 #define IONIC_BAR0_DEV_INFO_REGS_OFFSET		0x0000
 #define IONIC_BAR0_DEV_CMD_REGS_OFFSET		0x0800
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 8499165b1563..5593bcd4dc57 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -25,9 +25,12 @@
 static const u8 ionic_qtype_versions[IONIC_QTYPE_MAX] = {
 	[IONIC_QTYPE_ADMINQ]  = 0,   /* 0 = Base version with CQ support */
 	[IONIC_QTYPE_NOTIFYQ] = 0,   /* 0 = Base version */
-	[IONIC_QTYPE_RXQ]     = 0,   /* 0 = Base version with CQ+SG support */
-	[IONIC_QTYPE_TXQ]     = 1,   /* 0 = Base version with CQ+SG support
-				      * 1 =   ... with Tx SG version 1
+	[IONIC_QTYPE_RXQ]     = 2,   /* 0 = Base version with CQ+SG support
+				      * 2 =       ... with CMB rings
+				      */
+	[IONIC_QTYPE_TXQ]     = 3,   /* 0 = Base version with CQ+SG support
+				      * 1 =       ... with Tx SG version 1
+				      * 3 =       ... with CMB rings
 				      */
 };
 
@@ -379,6 +382,15 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		qcq->q_base_pa = 0;
 	}
 
+	if (qcq->cmb_q_base) {
+		iounmap(qcq->cmb_q_base);
+		ionic_put_cmb(lif, qcq->cmb_pgid, qcq->cmb_order);
+		qcq->cmb_pgid = 0;
+		qcq->cmb_order = 0;
+		qcq->cmb_q_base = NULL;
+		qcq->cmb_q_base_pa = 0;
+	}
+
 	if (qcq->cq_base) {
 		dma_free_coherent(dev, qcq->cq_size, qcq->cq_base, qcq->cq_base_pa);
 		qcq->cq_base = NULL;
@@ -587,6 +599,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		ionic_cq_map(&new->cq, cq_base, cq_base_pa);
 		ionic_cq_bind(&new->cq, &new->q);
 	} else {
+		/* regular DMA q descriptors */
 		new->q_size = PAGE_SIZE + (num_descs * desc_size);
 		new->q_base = dma_alloc_coherent(dev, new->q_size, &new->q_base_pa,
 						 GFP_KERNEL);
@@ -599,6 +612,33 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		q_base_pa = ALIGN(new->q_base_pa, PAGE_SIZE);
 		ionic_q_map(&new->q, q_base, q_base_pa);
 
+		if (flags & IONIC_QCQ_F_CMB_RINGS) {
+			/* on-chip CMB q descriptors */
+			new->cmb_q_size = num_descs * desc_size;
+			new->cmb_order = order_base_2(new->cmb_q_size / PAGE_SIZE);
+
+			err = ionic_get_cmb(lif, &new->cmb_pgid, &new->cmb_q_base_pa,
+					    new->cmb_order);
+			if (err) {
+				netdev_err(lif->netdev,
+					   "Cannot allocate queue order %d from cmb: err %d\n",
+					   new->cmb_order, err);
+				goto err_out_free_q;
+			}
+
+			new->cmb_q_base = ioremap_wc(new->cmb_q_base_pa, new->cmb_q_size);
+			if (!new->cmb_q_base) {
+				netdev_err(lif->netdev, "Cannot map queue from cmb\n");
+				ionic_put_cmb(lif, new->cmb_pgid, new->cmb_order);
+				err = -ENOMEM;
+				goto err_out_free_q;
+			}
+
+			new->cmb_q_base_pa -= idev->phy_cmb_pages;
+			ionic_q_cmb_map(&new->q, new->cmb_q_base, new->cmb_q_base_pa);
+		}
+
+		/* cq DMA descriptors */
 		new->cq_size = PAGE_SIZE + (num_descs * cq_desc_size);
 		new->cq_base = dma_alloc_coherent(dev, new->cq_size, &new->cq_base_pa,
 						  GFP_KERNEL);
@@ -637,6 +677,10 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 err_out_free_cq:
 	dma_free_coherent(dev, new->cq_size, new->cq_base, new->cq_base_pa);
 err_out_free_q:
+	if (new->cmb_q_base) {
+		iounmap(new->cmb_q_base);
+		ionic_put_cmb(lif, new->cmb_pgid, new->cmb_order);
+	}
 	dma_free_coherent(dev, new->q_size, new->q_base, new->q_base_pa);
 err_out_free_cq_info:
 	vfree(new->cq.info);
@@ -718,6 +762,8 @@ static void ionic_qcq_sanitize(struct ionic_qcq *qcq)
 	qcq->cq.tail_idx = 0;
 	qcq->cq.done_color = 1;
 	memset(qcq->q_base, 0, qcq->q_size);
+	if (qcq->cmb_q_base)
+		memset_io(qcq->cmb_q_base, 0, qcq->cmb_q_size);
 	memset(qcq->cq_base, 0, qcq->cq_size);
 	memset(qcq->sg_base, 0, qcq->sg_size);
 }
@@ -737,6 +783,7 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.index = cpu_to_le32(q->index),
 			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
 					     IONIC_QINIT_F_SG),
+			.intr_index = cpu_to_le16(qcq->intr.index),
 			.pid = cpu_to_le16(q->pid),
 			.ring_size = ilog2(q->num_descs),
 			.ring_base = cpu_to_le64(q->base_pa),
@@ -745,17 +792,19 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.features = cpu_to_le64(q->features),
 		},
 	};
-	unsigned int intr_index;
 	int err;
 
-	intr_index = qcq->intr.index;
-
-	ctx.cmd.q_init.intr_index = cpu_to_le16(intr_index);
+	if (qcq->flags & IONIC_QCQ_F_CMB_RINGS) {
+		ctx.cmd.q_init.flags |= cpu_to_le16(IONIC_QINIT_F_CMB);
+		ctx.cmd.q_init.ring_base = cpu_to_le64(qcq->cmb_q_base_pa);
+	}
 
 	dev_dbg(dev, "txq_init.pid %d\n", ctx.cmd.q_init.pid);
 	dev_dbg(dev, "txq_init.index %d\n", ctx.cmd.q_init.index);
 	dev_dbg(dev, "txq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
 	dev_dbg(dev, "txq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
+	dev_dbg(dev, "txq_init.cq_ring_base 0x%llx\n", ctx.cmd.q_init.cq_ring_base);
+	dev_dbg(dev, "txq_init.sg_ring_base 0x%llx\n", ctx.cmd.q_init.sg_ring_base);
 	dev_dbg(dev, "txq_init.flags 0x%x\n", ctx.cmd.q_init.flags);
 	dev_dbg(dev, "txq_init.ver %d\n", ctx.cmd.q_init.ver);
 	dev_dbg(dev, "txq_init.intr_index %d\n", ctx.cmd.q_init.intr_index);
@@ -807,6 +856,11 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	};
 	int err;
 
+	if (qcq->flags & IONIC_QCQ_F_CMB_RINGS) {
+		ctx.cmd.q_init.flags |= cpu_to_le16(IONIC_QINIT_F_CMB);
+		ctx.cmd.q_init.ring_base = cpu_to_le64(qcq->cmb_q_base_pa);
+	}
+
 	dev_dbg(dev, "rxq_init.pid %d\n", ctx.cmd.q_init.pid);
 	dev_dbg(dev, "rxq_init.index %d\n", ctx.cmd.q_init.index);
 	dev_dbg(dev, "rxq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
@@ -1966,8 +2020,13 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
 
 	flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
+
+	if (test_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state))
+		flags |= IONIC_QCQ_F_CMB_RINGS;
+
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
 		flags |= IONIC_QCQ_F_INTR;
+
 	for (i = 0; i < lif->nxqs; i++) {
 		err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
 				      num_desc, desc_sz, comp_sz, sg_desc_sz,
@@ -1988,6 +2047,9 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 
 	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG | IONIC_QCQ_F_INTR;
 
+	if (test_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state))
+		flags |= IONIC_QCQ_F_CMB_RINGS;
+
 	num_desc = lif->nrxq_descs;
 	desc_sz = sizeof(struct ionic_rxq_desc);
 	comp_sz = sizeof(struct ionic_rxq_comp);
@@ -2663,6 +2725,55 @@ static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_get_vf_stats       = ionic_get_vf_stats,
 };
 
+static int ionic_cmb_reconfig(struct ionic_lif *lif,
+			      struct ionic_queue_params *qparam)
+{
+	struct ionic_queue_params start_qparams;
+	int err = 0;
+
+	/* When changing CMB queue parameters, we're using limited
+	 * on-device memory and don't have extra memory to use for
+	 * duplicate allocations, so we free it all first then
+	 * re-allocate with the new parameters.
+	 */
+
+	/* Checkpoint for possible unwind */
+	ionic_init_queue_params(lif, &start_qparams);
+
+	/* Stop and free the queues */
+	ionic_stop_queues_reconfig(lif);
+	ionic_txrx_free(lif);
+
+	/* Set up new qparams */
+	ionic_set_queue_params(lif, qparam);
+
+	if (netif_running(lif->netdev)) {
+		/* Alloc and start the new configuration */
+		err = ionic_txrx_alloc(lif);
+		if (err) {
+			dev_warn(lif->ionic->dev,
+				 "CMB reconfig failed, restoring values: %d\n", err);
+
+			/* Back out the changes */
+			ionic_set_queue_params(lif, &start_qparams);
+			err = ionic_txrx_alloc(lif);
+			if (err) {
+				dev_err(lif->ionic->dev,
+					"CMB restore failed: %d\n", err);
+				goto errout;
+			}
+		}
+
+		ionic_start_queues_reconfig(lif);
+	} else {
+		/* This was detached in ionic_stop_queues_reconfig() */
+		netif_device_attach(lif->netdev);
+	}
+
+errout:
+	return err;
+}
+
 static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
 {
 	/* only swapping the queues, not the napi, flags, or other stuff */
@@ -2705,6 +2816,11 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	unsigned int flags, i;
 	int err = 0;
 
+	/* Are we changing q params while CMB is on */
+	if ((test_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state) && qparam->cmb_tx) ||
+	    (test_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state) && qparam->cmb_rx))
+		return ionic_cmb_reconfig(lif, qparam);
+
 	/* allocate temporary qcq arrays to hold new queue structs */
 	if (qparam->nxqs != lif->nxqs || qparam->ntxq_descs != lif->ntxq_descs) {
 		tx_qcqs = devm_kcalloc(lif->ionic->dev, lif->ionic->ntxqs_per_lif,
@@ -2741,6 +2857,16 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 			sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
 
 		for (i = 0; i < qparam->nxqs; i++) {
+			/* If missing, short placeholder qcq needed for swap */
+			if (!lif->txqcqs[i]) {
+				flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
+				err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
+						      4, desc_sz, comp_sz, sg_desc_sz,
+						      lif->kern_pid, &lif->txqcqs[i]);
+				if (err)
+					goto err_out;
+			}
+
 			flags = lif->txqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
 			err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
 					      num_desc, desc_sz, comp_sz, sg_desc_sz,
@@ -2760,6 +2886,16 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 			comp_sz *= 2;
 
 		for (i = 0; i < qparam->nxqs; i++) {
+			/* If missing, short placeholder qcq needed for swap */
+			if (!lif->rxqcqs[i]) {
+				flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG;
+				err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
+						      4, desc_sz, comp_sz, sg_desc_sz,
+						      lif->kern_pid, &lif->rxqcqs[i]);
+				if (err)
+					goto err_out;
+			}
+
 			flags = lif->rxqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
 			err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
 					      num_desc, desc_sz, comp_sz, sg_desc_sz,
@@ -2809,10 +2945,15 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 			lif->tx_coalesce_hw = lif->rx_coalesce_hw;
 		}
 
-		/* clear existing interrupt assignments */
+		/* Clear existing interrupt assignments.  We check for NULL here
+		 * because we're checking the whole array for potential qcqs, not
+		 * just those qcqs that have just been set up.
+		 */
 		for (i = 0; i < lif->ionic->ntxqs_per_lif; i++) {
-			ionic_qcq_intr_free(lif, lif->txqcqs[i]);
-			ionic_qcq_intr_free(lif, lif->rxqcqs[i]);
+			if (lif->txqcqs[i])
+				ionic_qcq_intr_free(lif, lif->txqcqs[i]);
+			if (lif->rxqcqs[i])
+				ionic_qcq_intr_free(lif, lif->rxqcqs[i]);
 		}
 
 		/* re-assign the interrupts */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index a53984bf3544..741d41445559 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -59,6 +59,7 @@ struct ionic_rx_stats {
 #define IONIC_QCQ_F_TX_STATS		BIT(3)
 #define IONIC_QCQ_F_RX_STATS		BIT(4)
 #define IONIC_QCQ_F_NOTIFYQ		BIT(5)
+#define IONIC_QCQ_F_CMB_RINGS		BIT(6)
 
 struct ionic_qcq {
 	void *q_base;
@@ -70,6 +71,11 @@ struct ionic_qcq {
 	void *sg_base;
 	dma_addr_t sg_base_pa;
 	u32 sg_size;
+	void __iomem *cmb_q_base;
+	phys_addr_t cmb_q_base_pa;
+	u32 cmb_q_size;
+	u32 cmb_pgid;
+	u32 cmb_order;
 	struct dim dim;
 	struct ionic_queue q;
 	struct ionic_cq cq;
@@ -140,6 +146,8 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_BROKEN,
 	IONIC_LIF_F_TX_DIM_INTR,
 	IONIC_LIF_F_RX_DIM_INTR,
+	IONIC_LIF_F_CMB_TX_RINGS,
+	IONIC_LIF_F_CMB_RX_RINGS,
 
 	/* leave this as last */
 	IONIC_LIF_F_STATE_SIZE
@@ -243,8 +251,10 @@ struct ionic_queue_params {
 	unsigned int nxqs;
 	unsigned int ntxq_descs;
 	unsigned int nrxq_descs;
-	unsigned int intr_split;
 	u64 rxq_features;
+	bool intr_split;
+	bool cmb_tx;
+	bool cmb_rx;
 };
 
 static inline void ionic_init_queue_params(struct ionic_lif *lif,
@@ -253,8 +263,34 @@ static inline void ionic_init_queue_params(struct ionic_lif *lif,
 	qparam->nxqs = lif->nxqs;
 	qparam->ntxq_descs = lif->ntxq_descs;
 	qparam->nrxq_descs = lif->nrxq_descs;
-	qparam->intr_split = test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
 	qparam->rxq_features = lif->rxq_features;
+	qparam->intr_split = test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+	qparam->cmb_tx = test_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state);
+	qparam->cmb_rx = test_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state);
+}
+
+static inline void ionic_set_queue_params(struct ionic_lif *lif,
+					  struct ionic_queue_params *qparam)
+{
+	lif->nxqs = qparam->nxqs;
+	lif->ntxq_descs = qparam->ntxq_descs;
+	lif->nrxq_descs = qparam->nrxq_descs;
+	lif->rxq_features = qparam->rxq_features;
+
+	if (qparam->intr_split)
+		set_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+	else
+		clear_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+
+	if (qparam->cmb_tx)
+		set_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state);
+	else
+		clear_bit(IONIC_LIF_F_CMB_TX_RINGS, lif->state);
+
+	if (qparam->cmb_rx)
+		set_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state);
+	else
+		clear_bit(IONIC_LIF_F_CMB_RX_RINGS, lif->state);
 }
 
 static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 0c3977416cd1..413ff735225b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -341,6 +341,14 @@ bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	return true;
 }
 
+static inline void ionic_write_cmb_desc(struct ionic_queue *q,
+					void __iomem *cmb_desc,
+					void *desc)
+{
+	if (q_to_qcq(q)->flags & IONIC_QCQ_F_CMB_RINGS)
+		memcpy_toio(cmb_desc, desc, q->desc_size);
+}
+
 void ionic_rx_fill(struct ionic_queue *q)
 {
 	struct net_device *netdev = q->lif->netdev;
@@ -419,6 +427,8 @@ void ionic_rx_fill(struct ionic_queue *q)
 					      IONIC_RXQ_DESC_OPCODE_SIMPLE;
 		desc_info->nbufs = nfrags;
 
+		ionic_write_cmb_desc(q, desc_info->cmb_desc, desc);
+
 		ionic_rxq_post(q, false, ionic_rx_clean, NULL);
 	}
 
@@ -860,7 +870,8 @@ static int ionic_tx_tcp_pseudo_csum(struct sk_buff *skb)
 	return 0;
 }
 
-static void ionic_tx_tso_post(struct ionic_queue *q, struct ionic_txq_desc *desc,
+static void ionic_tx_tso_post(struct ionic_queue *q,
+			      struct ionic_desc_info *desc_info,
 			      struct sk_buff *skb,
 			      dma_addr_t addr, u8 nsge, u16 len,
 			      unsigned int hdrlen, unsigned int mss,
@@ -868,6 +879,7 @@ static void ionic_tx_tso_post(struct ionic_queue *q, struct ionic_txq_desc *desc
 			      u16 vlan_tci, bool has_vlan,
 			      bool start, bool done)
 {
+	struct ionic_txq_desc *desc = desc_info->desc;
 	u8 flags = 0;
 	u64 cmd;
 
@@ -883,6 +895,8 @@ static void ionic_tx_tso_post(struct ionic_queue *q, struct ionic_txq_desc *desc
 	desc->hdr_len = cpu_to_le16(hdrlen);
 	desc->mss = cpu_to_le16(mss);
 
+	ionic_write_cmb_desc(q, desc_info->cmb_desc, desc);
+
 	if (start) {
 		skb_tx_timestamp(skb);
 		if (!unlikely(q->features & IONIC_TXQ_F_HWSTAMP))
@@ -1001,7 +1015,7 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 		seg_rem = min(tso_rem, mss);
 		done = (tso_rem == 0);
 		/* post descriptor */
-		ionic_tx_tso_post(q, desc, skb,
+		ionic_tx_tso_post(q, desc_info, skb,
 				  desc_addr, desc_nsge, desc_len,
 				  hdrlen, mss, outer_csum, vlan_tci, has_vlan,
 				  start, done);
@@ -1050,6 +1064,8 @@ static void ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb,
 	desc->csum_start = cpu_to_le16(skb_checksum_start_offset(skb));
 	desc->csum_offset = cpu_to_le16(skb->csum_offset);
 
+	ionic_write_cmb_desc(q, desc_info->cmb_desc, desc);
+
 	if (skb_csum_is_sctp(skb))
 		stats->crc32_csum++;
 	else
@@ -1087,6 +1103,8 @@ static void ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb,
 	desc->csum_start = 0;
 	desc->csum_offset = 0;
 
+	ionic_write_cmb_desc(q, desc_info->cmb_desc, desc);
+
 	stats->csum_none++;
 }
 
-- 
2.17.1

