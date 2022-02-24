Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832954C37C9
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiBXV3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbiBXV3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:29:05 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6A5194141;
        Thu, 24 Feb 2022 13:28:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWoU7YgngngYKEFAdDiEcnszNxZuzJ8jki1o5XDW+hjuaHcO8i14O2kPmKfIw2Vpscxq7tV81cbVDoUI0wyfxdpkJZaAqWrIgAdR/OdvJGEIDSBjqDcKklm658gVqQ66Non/1KAGehJWSsPN6GEmVrk5/TsxN+VQUeK2/fiersXTcgFty2B5GCSkLLysbgpjCzYixxU9e+FnE7ev+DeUEGRkfjfBS5KvQ3SzwlMLljaGBvHCyfkV/Pq902tYaGux/PrigNwb0ugSlV7ooVwaiXhGG1ixIUeHKHwxwyeTnBv1nPIogb1cEu3nU+JK3WIWOoZViVHrXwXTTM6wBcVMYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RDOtvSYes+zTVSAOjNScVRZ3HXTsTpcTNqEChmm9M88=;
 b=WyCrzS1TD1K1i4zauiMsrkQOy9eMD72B3vClNdeH+thg2iaUObeQGFF+BGzz57XOx36DZE6feIFXBxQR3jrmakPu3ZsKQ2h7Cnn791JoXsc/eYFA3qXLQ41RLXFiKxSLZHfmzS4Obb6vKTy/E+KRduM/1H4SfKkoW229nCKvMGWTnSjBap6fkK83WnkP1LrwxXnSlfiM1qX+oAQx93qTo/RfoQXMN4LGisWSDQD967QfhwfG/5BN+t0pcmFUmlNJzaTmVYGnqQSCvGSrXSI1mRRPvVVhU0Hx6hIXJubYneyo7si+kz7dN8pSHxFaX7v1g/w7V+dp+w759FuZA8srwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDOtvSYes+zTVSAOjNScVRZ3HXTsTpcTNqEChmm9M88=;
 b=st5SqH9jlxUYxZPqJSuZTNYNOvO4ZInZlmogcZEGTljUBoMYhplR4/xcQU0vst4j4//jZ7lMYY5AlF9NQbiToxfVizO/C1XlD+ivqOcaxfwlC5irgcYLd1y8OwkIoNp4dpQGvXeWgQVOkjkeADfvDSIxWiCJzaaffBg8/Qedrl8=
Received: from DM5PR07CA0043.namprd07.prod.outlook.com (2603:10b6:3:16::29) by
 MWHPR02MB2464.namprd02.prod.outlook.com (2603:10b6:300:42::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Thu, 24 Feb 2022 21:28:15 +0000
Received: from DM3NAM02FT049.eop-nam02.prod.protection.outlook.com
 (2603:10b6:3:16:cafe::d7) by DM5PR07CA0043.outlook.office365.com
 (2603:10b6:3:16::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 21:28:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT049.mail.protection.outlook.com (10.13.5.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:28:15 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:28:07 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:28:07 -0800
Envelope-to: eperezma@redhat.com,
 jasowang@redhat.com,
 mst@redhat.com,
 lingshan.zhu@intel.com,
 sgarzare@redhat.com,
 xieyongji@bytedance.com,
 elic@nvidia.com,
 si-wei.liu@oracle.com,
 parav@nvidia.com,
 longpeng2@huawei.com,
 virtualization@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [10.170.66.102] (port=59620 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nNLeg-00095B-HB; Thu, 24 Feb 2022 13:28:07 -0800
From:   Gautam Dawar <gautam.dawar@xilinx.com>
CC:     <gdawar@xilinx.com>, <martinh@xilinx.com>, <hanand@xilinx.com>,
        <tanujk@xilinx.com>, <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH v2 15/19] vhost-vdpa: support ASID based IOTLB API
Date:   Fri, 25 Feb 2022 02:52:55 +0530
Message-ID: <20220224212314.1326-16-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22ea36e4-cf4c-4e2e-dbb7-08d9f7dc913f
X-MS-TrafficTypeDiagnostic: MWHPR02MB2464:EE_
X-Microsoft-Antispam-PRVS: <MWHPR02MB24642CC59F403AAB15991D30B13D9@MWHPR02MB2464.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YWEU/PrlzDRx/eeMV5X8QxDpb5uqMikmY3wRTeiZAjVZZBJ2W8X0WTWMDfTHGpjKbFGQz3ds6jBSPLJgRHiz1t5FSB7VelNRchCW7aDRFu4ElFVl1wcKGW1wChH3XtbRy6E8MRh3O9naq81/Y5qnXgYnMgyU6SR8Nqdjh1EVPkqakd8uCUwhf09HV/CW4MvxJmzfVOBx48V96Xu6g8m3kbtPrwASlEnj32qjOlonhDFMdFXSvIVVjZBDAggNLvRdhWoifYWerNm4XyCL/qQnNA1qU8UKjKoQRKSgxG5+GuPu3ZY51jDPg6gZvKTSXOgPKphYo5W+0io1fQhwqkmJ2ATaVovHqX2EqWOXsXVo5iyZlHbhhzl5e/pFvHfEbybiTuCIp2jCqE0z+LSMFqA5y23KcEr7daHXD9s2KRj2jre0jPVA5cxsYrUc4KjQZD2u1AXMNWaMfFbSe5QJOpsfOVR5vW6HuGDxSOWXUtXBoJ6myNTNSfM2Rshj2/DpCGh7+mmFxSB3pQgTe0DT0DmKdbHJbHMcHleC8F2pqRnFQVmI2lgT/X4X6NRcU+NbeYvhrzwjDmTiNnqRelBMsRQjW+52d0Xwqh/WTsfKU8/ZVdm6rNXylokG8HMPxFcGmFL8LideocEo0EIoXZTkL5qBOOjqIWv9uptGqMXNyvHpE55s6p1AtEEbA/h6Q04CjGouS7jrEJjC8jQb3XTja7bq2EEGD8Mfcg/eO7whdpV49gE=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(44832011)(8936002)(9786002)(70586007)(70206006)(316002)(7416002)(54906003)(5660300002)(4326008)(356005)(7636003)(8676002)(82310400004)(7696005)(6666004)(40460700003)(83380400001)(109986005)(2616005)(1076003)(426003)(508600001)(336012)(26005)(47076005)(2906002)(36860700001)(186003)(36756003)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:28:15.0445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ea36e4-cf4c-4e2e-dbb7-08d9f7dc913f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT049.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2464
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the vhost-vdpa to support ASID based IOTLB API. The
vhost-vdpa device will allocated multiple IOTLBs for vDPA device that
supports multiple address spaces. The IOTLBs and vDPA device memory
mappings is determined and maintained through ASID.

Note that we still don't support vDPA device with more than one
address spaces that depends on platform IOMMU. This work will be done
by moving the IOMMU logic from vhost-vDPA to vDPA device driver.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c  | 129 ++++++++++++++++++++++++++++++++----------
 drivers/vhost/vhost.c |   2 +-
 2 files changed, 100 insertions(+), 31 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 47e6cf9d0881..4bcf824e3b12 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -28,7 +28,8 @@
 enum {
 	VHOST_VDPA_BACKEND_FEATURES =
 	(1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2) |
-	(1ULL << VHOST_BACKEND_F_IOTLB_BATCH),
+	(1ULL << VHOST_BACKEND_F_IOTLB_BATCH) |
+	(1ULL << VHOST_BACKEND_F_IOTLB_ASID),
 };
 
 #define VHOST_VDPA_DEV_MAX (1U << MINORBITS)
@@ -57,13 +58,20 @@ struct vhost_vdpa {
 	struct eventfd_ctx *config_ctx;
 	int in_batch;
 	struct vdpa_iova_range range;
-	int used_as;
+	u32 batch_asid;
 };
 
 static DEFINE_IDA(vhost_vdpa_ida);
 
 static dev_t vhost_vdpa_major;
 
+static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
+{
+	struct vhost_vdpa_as *as = container_of(iotlb, struct
+						vhost_vdpa_as, iotlb);
+	return as->id;
+}
+
 static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
 {
 	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
@@ -76,6 +84,16 @@ static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
 	return NULL;
 }
 
+static struct vhost_iotlb *asid_to_iotlb(struct vhost_vdpa *v, u32 asid)
+{
+	struct vhost_vdpa_as *as = asid_to_as(v, asid);
+
+	if (!as)
+		return NULL;
+
+	return &as->iotlb;
+}
+
 static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
 {
 	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
@@ -84,6 +102,9 @@ static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
 	if (asid_to_as(v, asid))
 		return NULL;
 
+	if (asid >= v->vdpa->nas)
+		return NULL;
+
 	as = kmalloc(sizeof(*as), GFP_KERNEL);
 	if (!as)
 		return NULL;
@@ -91,18 +112,24 @@ static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
 	vhost_iotlb_init(&as->iotlb, 0, 0);
 	as->id = asid;
 	hlist_add_head(&as->hash_link, head);
-	++v->used_as;
 
 	return as;
 }
 
-static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
+static struct vhost_vdpa_as *vhost_vdpa_find_alloc_as(struct vhost_vdpa *v,
+						      u32 asid)
 {
 	struct vhost_vdpa_as *as = asid_to_as(v, asid);
 
-	/* Remove default address space is not allowed */
-	if (asid == 0)
-		return -EINVAL;
+	if (as)
+		return as;
+
+	return vhost_vdpa_alloc_as(v, asid);
+}
+
+static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
+{
+	struct vhost_vdpa_as *as = asid_to_as(v, asid);
 
 	if (!as)
 		return -EINVAL;
@@ -110,7 +137,6 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
 	hlist_del(&as->hash_link);
 	vhost_iotlb_reset(&as->iotlb);
 	kfree(as);
-	--v->used_as;
 
 	return 0;
 }
@@ -665,6 +691,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	u32 asid = iotlb_to_asid(iotlb);
 	int r = 0;
 
 	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
@@ -673,10 +700,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		return r;
 
 	if (ops->dma_map) {
-		r = ops->dma_map(vdpa, 0, iova, size, pa, perm, opaque);
+		r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			r = ops->set_map(vdpa, 0, iotlb);
+			r = ops->set_map(vdpa, asid, iotlb);
 	} else {
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
@@ -692,23 +719,35 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	return 0;
 }
 
-static void vhost_vdpa_unmap(struct vhost_vdpa *v,
-			     struct vhost_iotlb *iotlb,
-			     u64 iova, u64 size)
+static int vhost_vdpa_unmap(struct vhost_vdpa *v,
+			    struct vhost_iotlb *iotlb,
+			    u64 iova, u64 size)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	u32 asid = iotlb_to_asid(iotlb);
+
+	if (!iotlb)
+		return -EINVAL;
 
 	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
 
 	if (ops->dma_map) {
-		ops->dma_unmap(vdpa, 0, iova, size);
+		ops->dma_unmap(vdpa, asid, iova, size);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			ops->set_map(vdpa, 0, iotlb);
+			ops->set_map(vdpa, asid, iotlb);
 	} else {
 		iommu_unmap(v->domain, iova, size);
 	}
+
+	/* If we are in the middle of batch processing, delay the free
+	 * of AS until BATCH_END.
+	 */
+	if (!v->in_batch && !iotlb->nmaps)
+		vhost_vdpa_remove_as(v, asid);
+
+	return 0;
 }
 
 static int vhost_vdpa_va_map(struct vhost_vdpa *v,
@@ -916,33 +955,55 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	struct vhost_vdpa_as *as = asid_to_as(v, 0);
-	struct vhost_iotlb *iotlb = &as->iotlb;
+	struct vhost_iotlb *iotlb = NULL;
+	struct vhost_vdpa_as *as = NULL;
 	int r = 0;
 
 	mutex_lock(&dev->mutex);
 
-	if (asid != 0)
-		return -EINVAL;
-
 	r = vhost_dev_check_owner(dev);
 	if (r)
 		goto unlock;
 
+	if (msg->type == VHOST_IOTLB_UPDATE ||
+	    msg->type == VHOST_IOTLB_BATCH_BEGIN) {
+		as = vhost_vdpa_find_alloc_as(v, asid);
+		if (!as) {
+			dev_err(&v->dev, "can't find and alloc asid %d\n",
+				asid);
+			return -EINVAL;
+		}
+		iotlb = &as->iotlb;
+	} else
+		iotlb = asid_to_iotlb(v, asid);
+
+	if ((v->in_batch && v->batch_asid != asid) || !iotlb) {
+		if (v->in_batch && v->batch_asid != asid) {
+			dev_info(&v->dev, "batch id %d asid %d\n",
+				 v->batch_asid, asid);
+		}
+		if (!iotlb)
+			dev_err(&v->dev, "no iotlb for asid %d\n", asid);
+		return -EINVAL;
+	}
+
 	switch (msg->type) {
 	case VHOST_IOTLB_UPDATE:
 		r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
 		break;
 	case VHOST_IOTLB_INVALIDATE:
-		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
+		r = vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
 		break;
 	case VHOST_IOTLB_BATCH_BEGIN:
+		v->batch_asid = asid;
 		v->in_batch = true;
 		break;
 	case VHOST_IOTLB_BATCH_END:
 		if (v->in_batch && ops->set_map)
-			ops->set_map(vdpa, 0, iotlb);
+			ops->set_map(vdpa, asid, iotlb);
 		v->in_batch = false;
+		if (!iotlb->nmaps)
+			vhost_vdpa_remove_as(v, asid);
 		break;
 	default:
 		r = -EINVAL;
@@ -1030,9 +1091,17 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
 
 static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
 {
+	struct vhost_vdpa_as *as;
+	u32 asid;
+
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
-	vhost_vdpa_remove_as(v, 0);
+
+	for (asid = 0; asid < v->vdpa->nas; asid++) {
+		as = asid_to_as(v, asid);
+		if (as)
+			vhost_vdpa_remove_as(v, asid);
+	}
 }
 
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
@@ -1067,12 +1136,9 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
 
-	if (!vhost_vdpa_alloc_as(v, 0))
-		goto err_alloc_as;
-
 	r = vhost_vdpa_alloc_domain(v);
 	if (r)
-		goto err_alloc_as;
+		goto err_alloc_domain;
 
 	vhost_vdpa_set_iova_range(v);
 
@@ -1080,7 +1146,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 	return 0;
 
-err_alloc_as:
+err_alloc_domain:
 	vhost_vdpa_cleanup(v);
 err:
 	atomic_dec(&v->opened);
@@ -1205,8 +1271,11 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	int minor;
 	int i, r;
 
-	/* Only support 1 address space and 1 groups */
-	if (vdpa->ngroups != 1 || vdpa->nas != 1)
+	/* We can't support platform IOMMU device with more than 1
+	 * group or as
+	 */
+	if (!ops->set_map && !ops->dma_map &&
+	    (vdpa->ngroups > 1 || vdpa->nas > 1))
 		return -EOPNOTSUPP;
 
 	v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 1f514d98f0de..92eeb684c84d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1167,7 +1167,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 				ret = -EINVAL;
 				goto done;
 			}
-			offset = sizeof(__u16);
+			offset = 0;
 		} else
 			offset = sizeof(__u32);
 		break;
-- 
2.25.0

