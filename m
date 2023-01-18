Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62E26725E8
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjARSBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjARSAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:00:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FF25999B;
        Wed, 18 Jan 2023 10:00:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFjWMK9udofnRi0AnAqRtywz5K8lZXQ0q6Nf1LxnJ16Zs0a84cBlgRledY5xDIKCnskFtJYkcv7k+xibKGSmOGplL+Qys2XmBqtjNqyL5NK+USv5QbnH1p/0cbOSjLWuBR0810qpXeb3ApGZWPASPf+w6IF/yzxeZUfUlC3udT+IRU+59Nq9HYrKry2KRNADjpndN3ircywBQ3GNulRIc9hX21+VGniXH7aBP0s7cVqcWE+woolvR3IQrbo20m5ZYwvg/znPycl4+w9cUR/KzhpajAju6hluVSre0p0ngyodVXkFYcgWlRoDGnEStGCbqgrpZc6m0rY4pEOyW+XPFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8hpilVa2qjlCphllcpBP3r1l8+EaRmX8eQgl6ry1GCQ=;
 b=BzL6mZAJ+PxWr8iqJ7nnQv/1CzKhk87qiUk4000mOLVvWVXguTNPSAcxdyiWXbwIPqYfjPV7TwRtiO8F+6ANalj81pzqH9b9R3xjDwT20qTj0HnxXsrWMsS8l8YNs+vRGaic5ISEN43AUJZWt83RQSEqxplwaVQoor/WFttP1zDsYrMVjxio2lc+VfkpKyaw8pxXCiWpf35sMCJeny+RsaGsQT+4pWoxzf95iYpPho13hEzBCt1fJGVe6rm7Vdrtp8tlW4zBkYp/7GAdsquY1I0oTz9cOi0mKcPUvD2bcxAJFg0hqhLU1eUA8B91dvXkxWeeUDvPqsb6lTnA/XQ7Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hpilVa2qjlCphllcpBP3r1l8+EaRmX8eQgl6ry1GCQ=;
 b=rr32UewlZDIykiBe9q/ePW25oJVrqxi2CzRVby4gT6uZ8v7Kxa1l5mEQQwAUx7UObhGy3y1N5/F/g2L+b9xGsJT/p4w5snRlbfpx5cO7U5C5BRGWS08iJz+nxetTHyZqM4uwxBEqTeYGUOrBoBysMMaVXVRXVMyTsbDro7negtyqPg3SuXsP1kVu0ISVyb7CeQSiD2LTXp0lqhj0iYfoM9lvLFrTm5xSGgnl/uZ4J3k72I+jW8xD1NY9yx1HNPwGFxvhSr/Wb71gxQGT68zge3MEWANukXOBb6xZFhx/OrV8EYZEgTdKKrI8K56mnA4RWsduh6du97oKtoNMluHJ+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB7614.namprd12.prod.outlook.com (2603:10b6:208:429::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 18:00:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 18:00:47 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-tegra@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nouveau@lists.freedesktop.org,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 01/10] iommu: Add a gfp parameter to iommu_map()
Date:   Wed, 18 Jan 2023 14:00:35 -0400
Message-Id: <1-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:208:32f::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB7614:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c51f368-152e-497e-f27f-08daf97dec29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+S6k5toC6HbuVGa0DKRRUgoCUFRoQlIojDEB9xfd7znLg53KBcjlXq3vDw4xCdczzHKGOuufYEcCqzQjHromUJJdnpsNPEst/nvxaWz6Wc2ytKmBIfx/+T9qVHz69pnwTYAXYPiuHqQ8L6c6mUfgZWxDLMoeU/tEvBjC0F+It8yqwQELn03wFgdlwZZpzBl67Xom8YiLD5a331RaSKZcZDsq6mNzxdWLA+/RYb8rX32RntIytOtKvPrasR9aBfJLJlaFpBNRl3i/YS8HlH7oVFA3R3iYqz6P/p0BNhaiGSTkXVdNxxSd3a6uV/Y9B4Qe5/Afhmli7j6W3M07QM234XienRQ29feJIzSQ1TCG3GpfVlhgHy/QF4ulZD/gkaJ4y8qZx5yHXcd2U20Kg7xwXaDhiEVmddaiauJ11zZTQm1WKFDs31t5cYKxLINXTyFFag0b1o8tGO6DnDEHlwnjIlYNyZ5B87srhRdUIZUtbyH3MNo+fl1zH8on3P1pH+LQO34O0fse4FkbHCtcX3NSkLpnERM3f2xsfYVXKkH0mTADkACmgc2N7XIqLFH7KSTQXKxlgwSBzrXm1IEOpJTsVkgxk6zxp+xvRUsUbjHymSIcKuK4Ksi5TGH0ntibvf89zBxPhjffANesZGcA3piQVPZiWss4TGbQgPD5Ty4W3Cvh0ebILw9f0hoCkAbvye/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(186003)(26005)(478600001)(6512007)(6486002)(6666004)(54906003)(316002)(110136005)(4326008)(66946007)(66556008)(8676002)(66476007)(36756003)(2616005)(41300700001)(8936002)(83380400001)(30864003)(2906002)(7416002)(5660300002)(38100700002)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+t9VJelzZ5bDxkojvRyRdj+eBlHibjHStMJhI+0mSZqQHSzhkBfa+olitL7D?=
 =?us-ascii?Q?zdtaq6hY8HL1sVfCEo4sF/juSu3Bq4o6+BYqIEefUsToBCrNNW0jwrWH/Def?=
 =?us-ascii?Q?fI7LqODDrAsOUcBGcjmhloJMxifhDtTcVk0ayKRiPvuj/0RgTzMETe8+LtG9?=
 =?us-ascii?Q?WeyO9TgRXIfuya2uCDzMojZbrX8DjRHUgxW2XYC7pjbblcoxY/EG4TV2iGIt?=
 =?us-ascii?Q?7w4K0fEYLdm+N+ImN/N/9PfVssPMaQ1eqHK1fJ4qdYgfMJW2nG0XcSM4JYKc?=
 =?us-ascii?Q?y4yjKbjgUnlRdJOfBorK2BMgOOYT8S5NFcKZ5wo0bygkJdsK7q3VJj1ND4rJ?=
 =?us-ascii?Q?BpQt1JIVh3NnXW455Vqy1PK3KPoz/9IledbWNOv+Ej1pQu8Wo2aTUmVmyfyX?=
 =?us-ascii?Q?EjhA4IqSeVqbZ33vF/J3+IYv9OmqIr33O1mZEA9ZnpfjiuOBHxFgBnorZZLS?=
 =?us-ascii?Q?hri/X+pPMbv0/UMifKyWBW15HtnTQChr8T59mxJ9ZL2E6xaMvPEoNW3f8GT+?=
 =?us-ascii?Q?Fomh1AvdwSr37DbgArrujARDVbSfPgtzOg1jdTtYOMjBpvCfFUp5xu7u7DU7?=
 =?us-ascii?Q?ICsn9wTo66phZDUs1E8HLa0mKnvp6ZyYikeI8m6nEKE9lk/QkTfVkRR2UXyp?=
 =?us-ascii?Q?Ov3ylYGSPps2MObGo6gitTa1aNWp/usO1A/pD7Hb50vde/w6TqaA2FpIOBrb?=
 =?us-ascii?Q?R0uAz2IocHiKy+uiKIHyigICL9nzTIbTLcGwQaMzq8qIQMyvTzDEfe/pq81z?=
 =?us-ascii?Q?TtwbHdYgjtKLb5V5p/mBcHpiMMvV+x6Wh69H+YuMBleA4gVUGhhyJ1aSGCV5?=
 =?us-ascii?Q?/E5nnwZ2Oz5cOSG8kD0B1G9YfnXvZOJDmFcGtzhBiNo5kNGzltEwK+I2RdvJ?=
 =?us-ascii?Q?phlkHxOM3U48bJ+GJfnFhO2fVZyo0CzQEQRqXX6B6CWiQr9tVYITp0p3X2sB?=
 =?us-ascii?Q?FAUzhXyXxxLK39MvCAnou8TYhG8ZQqt3eGOoa6n3cgu78no3gDygSNGJAIBa?=
 =?us-ascii?Q?tj5Ho3oO+BvhAjy7mN6Ifbn8tYfL/7daBI1zliBCDYV4fy6NHK0oj+n+O7aa?=
 =?us-ascii?Q?fxkst56mmXHD/IRKQNWgx20O5eI5w3N2Cwva6lEvzv7P2gGIYtlbWqOX406t?=
 =?us-ascii?Q?yq6DTefgOEnv8lStg969C7IbM6lqiOetI+XfVXSXiqcNZfJn/UmcssZ3DNi3?=
 =?us-ascii?Q?jvgfwzMe/uBXE4cmjPVxFBqqA1+0NFpL77/5IWGW/sJmjKD6YVWajOTZ6Uc+?=
 =?us-ascii?Q?477KhmwcHuZka2sN2f+kiDDR7nAbwjRws9HXfLuQPaezh98gTJxFe2v2xIwO?=
 =?us-ascii?Q?3XL14c/OMkbutBkXRu4K1O+slXsD2ps35pHHoeQtbiocMtacot+TDie2W25y?=
 =?us-ascii?Q?sLiB6cgg+lmd5fXDjeGJwfVFWxXBp91J/2792QQwdvRiszVRwgDI1xZPqKXj?=
 =?us-ascii?Q?AU0hCMmn+D+JuCYg2aqYyx9j5DOntGMap9iVixH333REf5iNW9+DAiaMalVu?=
 =?us-ascii?Q?gTuqJfHQO/Kp9OnR/CTARrudJ1cWQVrJTvOjwLPqpXuVALIFxq4Ru8KHHLcv?=
 =?us-ascii?Q?iLbx+hdulNgy1cdY/RCJoRk/uhubJtM9ed9rRbRv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c51f368-152e-497e-f27f-08daf97dec29
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:00:45.7402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLJq1DAAm1BXkeBsE8kP6/QtYiyd4roNA4mlnx0OJaJr39QdtJXdeNwEnFTS0vyq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7614
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal mechanisms support this, but instead of exposting the gfp to
the caller it wrappers it into iommu_map() and iommu_map_atomic()

Fix this instead of adding more variants for GFP_KERNEL_ACCOUNT.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm/mm/dma-mapping.c                     | 11 ++++++----
 .../drm/nouveau/nvkm/subdev/instmem/gk20a.c   |  3 ++-
 drivers/gpu/drm/tegra/drm.c                   |  2 +-
 drivers/gpu/host1x/cdma.c                     |  2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c      |  4 ++--
 drivers/iommu/dma-iommu.c                     |  2 +-
 drivers/iommu/iommu.c                         | 22 +++++++++----------
 drivers/iommu/iommufd/pages.c                 |  6 +++--
 drivers/media/platform/qcom/venus/firmware.c  |  2 +-
 drivers/net/ipa/ipa_mem.c                     |  6 +++--
 drivers/net/wireless/ath/ath10k/snoc.c        |  2 +-
 drivers/net/wireless/ath/ath11k/ahb.c         |  4 ++--
 drivers/remoteproc/remoteproc_core.c          |  5 +++--
 drivers/vfio/vfio_iommu_type1.c               |  9 ++++----
 drivers/vhost/vdpa.c                          |  2 +-
 include/linux/iommu.h                         |  4 ++--
 16 files changed, 48 insertions(+), 38 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index c135f6e37a00ca..8bc01071474ab7 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -984,7 +984,8 @@ __iommu_create_mapping(struct device *dev, struct page **pages, size_t size,
 
 		len = (j - i) << PAGE_SHIFT;
 		ret = iommu_map(mapping->domain, iova, phys, len,
-				__dma_info_to_prot(DMA_BIDIRECTIONAL, attrs));
+				__dma_info_to_prot(DMA_BIDIRECTIONAL, attrs),
+				GFP_KERNEL);
 		if (ret < 0)
 			goto fail;
 		iova += len;
@@ -1207,7 +1208,8 @@ static int __map_sg_chunk(struct device *dev, struct scatterlist *sg,
 
 		prot = __dma_info_to_prot(dir, attrs);
 
-		ret = iommu_map(mapping->domain, iova, phys, len, prot);
+		ret = iommu_map(mapping->domain, iova, phys, len, prot,
+				GFP_KERNEL);
 		if (ret < 0)
 			goto fail;
 		count += len >> PAGE_SHIFT;
@@ -1379,7 +1381,8 @@ static dma_addr_t arm_iommu_map_page(struct device *dev, struct page *page,
 
 	prot = __dma_info_to_prot(dir, attrs);
 
-	ret = iommu_map(mapping->domain, dma_addr, page_to_phys(page), len, prot);
+	ret = iommu_map(mapping->domain, dma_addr, page_to_phys(page), len,
+			prot, GFP_KERNEL);
 	if (ret < 0)
 		goto fail;
 
@@ -1443,7 +1446,7 @@ static dma_addr_t arm_iommu_map_resource(struct device *dev,
 
 	prot = __dma_info_to_prot(dir, attrs) | IOMMU_MMIO;
 
-	ret = iommu_map(mapping->domain, dma_addr, addr, len, prot);
+	ret = iommu_map(mapping->domain, dma_addr, addr, len, prot, GFP_KERNEL);
 	if (ret < 0)
 		goto fail;
 
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c b/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
index 648ecf5a8fbc2a..a4ac94a2ab57fc 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
@@ -475,7 +475,8 @@ gk20a_instobj_ctor_iommu(struct gk20a_instmem *imem, u32 npages, u32 align,
 		u32 offset = (r->offset + i) << imem->iommu_pgshift;
 
 		ret = iommu_map(imem->domain, offset, node->dma_addrs[i],
-				PAGE_SIZE, IOMMU_READ | IOMMU_WRITE);
+				PAGE_SIZE, IOMMU_READ | IOMMU_WRITE,
+				GFP_KERNEL);
 		if (ret < 0) {
 			nvkm_error(subdev, "IOMMU mapping failure: %d\n", ret);
 
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 7bd2e65c2a16c5..6ca9f396e55be4 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1057,7 +1057,7 @@ void *tegra_drm_alloc(struct tegra_drm *tegra, size_t size, dma_addr_t *dma)
 
 	*dma = iova_dma_addr(&tegra->carveout.domain, alloc);
 	err = iommu_map(tegra->domain, *dma, virt_to_phys(virt),
-			size, IOMMU_READ | IOMMU_WRITE);
+			size, IOMMU_READ | IOMMU_WRITE, GFP_KERNEL);
 	if (err < 0)
 		goto free_iova;
 
diff --git a/drivers/gpu/host1x/cdma.c b/drivers/gpu/host1x/cdma.c
index 103fda055394ab..4ddfcd2138c95b 100644
--- a/drivers/gpu/host1x/cdma.c
+++ b/drivers/gpu/host1x/cdma.c
@@ -105,7 +105,7 @@ static int host1x_pushbuffer_init(struct push_buffer *pb)
 
 		pb->dma = iova_dma_addr(&host1x->iova, alloc);
 		err = iommu_map(host1x->domain, pb->dma, pb->phys, size,
-				IOMMU_READ);
+				IOMMU_READ, GFP_KERNEL);
 		if (err)
 			goto iommu_free_iova;
 	} else {
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index c301b3be9f303d..aeeaca65ace96a 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -277,7 +277,7 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x",
 					va_start, &pa_start, size, flags);
 				err = iommu_map(pd->domain, va_start, pa_start,
-							size, flags);
+						size, flags, GFP_KERNEL);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
@@ -294,7 +294,7 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x\n",
 					va_start, &pa_start, size, flags);
 				err = iommu_map(pd->domain, va_start, pa_start,
-						size, flags);
+						size, flags, GFP_KERNEL);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index f798c44e090337..8bdb65e7686ff9 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1615,7 +1615,7 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 	if (!iova)
 		goto out_free_page;
 
-	if (iommu_map(domain, iova, msi_addr, size, prot))
+	if (iommu_map(domain, iova, msi_addr, size, prot, GFP_KERNEL))
 		goto out_free_iova;
 
 	INIT_LIST_HEAD(&msi_page->list);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 5f6a85aea501ec..7dac062b58f039 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -930,7 +930,7 @@ static int iommu_create_device_direct_mappings(struct iommu_group *group,
 			if (map_size) {
 				ret = iommu_map(domain, addr - map_size,
 						addr - map_size, map_size,
-						entry->prot);
+						entry->prot, GFP_KERNEL);
 				if (ret)
 					goto out;
 				map_size = 0;
@@ -2360,31 +2360,31 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
 	return ret;
 }
 
-static int _iommu_map(struct iommu_domain *domain, unsigned long iova,
-		      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+int iommu_map(struct iommu_domain *domain, unsigned long iova,
+	      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	int ret;
 
+	might_sleep_if(gfpflags_allow_blocking(gfp));
+
+	/* Discourage passing strange GFP flags */
+	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
+				__GFP_HIGHMEM)))
+		return -EINVAL;
+
 	ret = __iommu_map(domain, iova, paddr, size, prot, gfp);
 	if (ret == 0 && ops->iotlb_sync_map)
 		ops->iotlb_sync_map(domain, iova, size);
 
 	return ret;
 }
-
-int iommu_map(struct iommu_domain *domain, unsigned long iova,
-	      phys_addr_t paddr, size_t size, int prot)
-{
-	might_sleep();
-	return _iommu_map(domain, iova, paddr, size, prot, GFP_KERNEL);
-}
 EXPORT_SYMBOL_GPL(iommu_map);
 
 int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
 	      phys_addr_t paddr, size_t size, int prot)
 {
-	return _iommu_map(domain, iova, paddr, size, prot, GFP_ATOMIC);
+	return iommu_map(domain, iova, paddr, size, prot, GFP_ATOMIC);
 }
 EXPORT_SYMBOL_GPL(iommu_map_atomic);
 
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 1e1d3509efae5e..22cc3bb0c6c55a 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -456,7 +456,8 @@ static int batch_iommu_map_small(struct iommu_domain *domain,
 			size % PAGE_SIZE);
 
 	while (size) {
-		rc = iommu_map(domain, iova, paddr, PAGE_SIZE, prot);
+		rc = iommu_map(domain, iova, paddr, PAGE_SIZE, prot,
+			       GFP_KERNEL);
 		if (rc)
 			goto err_unmap;
 		iova += PAGE_SIZE;
@@ -500,7 +501,8 @@ static int batch_to_domain(struct pfn_batch *batch, struct iommu_domain *domain,
 		else
 			rc = iommu_map(domain, iova,
 				       PFN_PHYS(batch->pfns[cur]) + page_offset,
-				       next_iova - iova, area->iommu_prot);
+				       next_iova - iova, area->iommu_prot,
+				       GFP_KERNEL);
 		if (rc)
 			goto err_unmap;
 		iova = next_iova;
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 142d4c74017c04..07d4dceb5e72c7 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -158,7 +158,7 @@ static int venus_boot_no_tz(struct venus_core *core, phys_addr_t mem_phys,
 	core->fw.mapped_mem_size = mem_size;
 
 	ret = iommu_map(iommu, VENUS_FW_START_ADDR, mem_phys, mem_size,
-			IOMMU_READ | IOMMU_WRITE | IOMMU_PRIV);
+			IOMMU_READ | IOMMU_WRITE | IOMMU_PRIV, GFP_KERNEL);
 	if (ret) {
 		dev_err(dev, "could not map video firmware region\n");
 		return ret;
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 9ec5af323f731d..991a7d39f06661 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -466,7 +466,8 @@ static int ipa_imem_init(struct ipa *ipa, unsigned long addr, size_t size)
 	size = PAGE_ALIGN(size + addr - phys);
 	iova = phys;	/* We just want a direct mapping */
 
-	ret = iommu_map(domain, iova, phys, size, IOMMU_READ | IOMMU_WRITE);
+	ret = iommu_map(domain, iova, phys, size, IOMMU_READ | IOMMU_WRITE,
+			GFP_KERNEL);
 	if (ret)
 		return ret;
 
@@ -574,7 +575,8 @@ static int ipa_smem_init(struct ipa *ipa, u32 item, size_t size)
 	size = PAGE_ALIGN(size + addr - phys);
 	iova = phys;	/* We just want a direct mapping */
 
-	ret = iommu_map(domain, iova, phys, size, IOMMU_READ | IOMMU_WRITE);
+	ret = iommu_map(domain, iova, phys, size, IOMMU_READ | IOMMU_WRITE,
+			GFP_KERNEL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index cfcb759a87deac..9a82f0336d9537 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1639,7 +1639,7 @@ static int ath10k_fw_init(struct ath10k *ar)
 
 	ret = iommu_map(iommu_dom, ar_snoc->fw.fw_start_addr,
 			ar->msa.paddr, ar->msa.mem_size,
-			IOMMU_READ | IOMMU_WRITE);
+			IOMMU_READ | IOMMU_WRITE, GFP_KERNEL);
 	if (ret) {
 		ath10k_err(ar, "failed to map firmware region: %d\n", ret);
 		goto err_iommu_detach;
diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index d34a4d6325b2b4..df8fdc7067f99c 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1021,7 +1021,7 @@ static int ath11k_ahb_fw_resources_init(struct ath11k_base *ab)
 
 	ret = iommu_map(iommu_dom, ab_ahb->fw.msa_paddr,
 			ab_ahb->fw.msa_paddr, ab_ahb->fw.msa_size,
-			IOMMU_READ | IOMMU_WRITE);
+			IOMMU_READ | IOMMU_WRITE, GFP_KERNEL);
 	if (ret) {
 		ath11k_err(ab, "failed to map firmware region: %d\n", ret);
 		goto err_iommu_detach;
@@ -1029,7 +1029,7 @@ static int ath11k_ahb_fw_resources_init(struct ath11k_base *ab)
 
 	ret = iommu_map(iommu_dom, ab_ahb->fw.ce_paddr,
 			ab_ahb->fw.ce_paddr, ab_ahb->fw.ce_size,
-			IOMMU_READ | IOMMU_WRITE);
+			IOMMU_READ | IOMMU_WRITE, GFP_KERNEL);
 	if (ret) {
 		ath11k_err(ab, "failed to map firmware CE region: %d\n", ret);
 		goto err_iommu_unmap;
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 1cd4815a6dd197..80072b6b628358 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -643,7 +643,8 @@ static int rproc_handle_devmem(struct rproc *rproc, void *ptr,
 	if (!mapping)
 		return -ENOMEM;
 
-	ret = iommu_map(rproc->domain, rsc->da, rsc->pa, rsc->len, rsc->flags);
+	ret = iommu_map(rproc->domain, rsc->da, rsc->pa, rsc->len, rsc->flags,
+			GFP_KERNEL);
 	if (ret) {
 		dev_err(dev, "failed to map devmem: %d\n", ret);
 		goto out;
@@ -737,7 +738,7 @@ static int rproc_alloc_carveout(struct rproc *rproc,
 		}
 
 		ret = iommu_map(rproc->domain, mem->da, dma, mem->len,
-				mem->flags);
+				mem->flags, GFP_KERNEL);
 		if (ret) {
 			dev_err(dev, "iommu_map failed: %d\n", ret);
 			goto free_mapping;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00d4..e14f86a8ef5258 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1480,7 +1480,8 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 
 	list_for_each_entry(d, &iommu->domain_list, next) {
 		ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
-				npage << PAGE_SHIFT, prot | IOMMU_CACHE);
+				npage << PAGE_SHIFT, prot | IOMMU_CACHE,
+				GFP_KERNEL);
 		if (ret)
 			goto unwind;
 
@@ -1777,8 +1778,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				size = npage << PAGE_SHIFT;
 			}
 
-			ret = iommu_map(domain->domain, iova, phys,
-					size, dma->prot | IOMMU_CACHE);
+			ret = iommu_map(domain->domain, iova, phys, size,
+					dma->prot | IOMMU_CACHE, GFP_KERNEL);
 			if (ret) {
 				if (!dma->iommu_mapped) {
 					vfio_unpin_pages_remote(dma, iova,
@@ -1866,7 +1867,7 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain)
 		return;
 
 	ret = iommu_map(domain->domain, 0, page_to_phys(pages), PAGE_SIZE * 2,
-			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
+			IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE, GFP_KERNEL);
 	if (!ret) {
 		size_t unmapped = iommu_unmap(domain->domain, 0, PAGE_SIZE);
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ec32f785dfdec1..fd1536de5b1df0 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -792,7 +792,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 			r = ops->set_map(vdpa, asid, iotlb);
 	} else {
 		r = iommu_map(v->domain, iova, pa, size,
-			      perm_to_iommu_flags(perm));
+			      perm_to_iommu_flags(perm), GFP_KERNEL);
 	}
 	if (r) {
 		vhost_iotlb_del_range(iotlb, iova, iova + size - 1);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 46e1347bfa2286..d2020994f292db 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -467,7 +467,7 @@ extern int iommu_sva_unbind_gpasid(struct iommu_domain *domain,
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
-		     phys_addr_t paddr, size_t size, int prot);
+		     phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
 extern int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
 			    phys_addr_t paddr, size_t size, int prot);
 extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
@@ -773,7 +773,7 @@ static inline struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
 }
 
 static inline int iommu_map(struct iommu_domain *domain, unsigned long iova,
-			    phys_addr_t paddr, size_t size, int prot)
+			    phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	return -ENODEV;
 }
-- 
2.39.0

