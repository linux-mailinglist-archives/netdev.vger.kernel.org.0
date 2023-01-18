Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5CA67260C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjARSBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjARSAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:00:48 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964C555290;
        Wed, 18 Jan 2023 10:00:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXoTCCFLZnOD9YXHQINsoNJysimNrVNAz3rNG+c2a8vlhmhYnZKx8Vvj5dsCJcNVEc5iBRKd7nmr76JNdkGzgliNRUSsmBWtS8zsDl4TDrNi6waQ0wAo5a/MwbvXVDcpAFHxjyXlFM53uQkNMqeQ1vfDypvRrHrPJ+knizM1bDSm+IhlkCA9apZ8VLrREpIggCSG/B+Et6xkako5nyUpbDGDYwgSSqczuSim6qSftxp0mqZzFt29HmXaOC6jOYZxL7VcR0KoIbjDkEyw2VN3VvAhpFTd8NFwi9ykBW4qF+pDw4UTW85zHEXPaYJxjmi95pt6+M0hHX+Hy/RW0fgoiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rgow5diNk+hVt+Qqw0FXU33IcXQf0aq5YG3bZTDQaI=;
 b=YJHXP40dKqKDwVDEviHWtEf2+d4oYsiHyB21j7UWWRbiUo1Nkuvs2qZxeA4mscr/7D+HNp8dZjq05MnEiKxKWEilFwAceCsGtrfKiH8KnVPP7aIriRrPxsfvsNo4y5lzVxJbXgSKsb/gW5iIJ/sbLlaT3oaPDyPbIab9zByrLu3aallUoA6lx7MHTCoH2AFQ3Afvzfb1p5cvj0j5we87oVaq3Yzi49KORD5bRbr9rwUcV5eOc488WlKRHjBXZwzbfCBKA97Q27qvt65RNFJLvdgFLPUMhp6IgDzWQXU61MP6Rp9z1TGozcfxbNCdtvAoeMIRncmU6njoqWQkKWvaJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rgow5diNk+hVt+Qqw0FXU33IcXQf0aq5YG3bZTDQaI=;
 b=tB8X5gTZH+CJRpWO9vB+DaX/UJdLa4S44i9WjPyrM+xIhyf75jrjn/O+2SFjtIpe9FHmJ9SKnJjBU2tmnseVEAhJUnJorjbYTudRDGkDhJE/VZEWU19NvDNXfePEa/bt+F1+VmhYXhYHXyYLCGe05jzXFURA8MqzIAbfu44YL1LokoKuHit7lJ3LwGQQlxmaN68vF+3wB0OTI2yfK4SyixAAryHmVM8TPs+KlcVUf0lfKtQ3h0ZV/aEfl8kpybw17TYv2BvUB0VApGiiO8I/sOnMC8qT4pakH5mykmv4xNRt+JTMh3kYPNGbIzVOfBq0rQzHREE9R0yjWNKbzqw9YQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB7614.namprd12.prod.outlook.com (2603:10b6:208:429::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 18:00:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 18:00:45 +0000
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
Subject: [PATCH v2 03/10] iommu: Add a gfp parameter to iommu_map_sg()
Date:   Wed, 18 Jan 2023 14:00:37 -0400
Message-Id: <3-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:208:329::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB7614:EE_
X-MS-Office365-Filtering-Correlation-Id: 3289005d-6cf5-4741-cb9e-08daf97debe6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EAquh9wTbVTZvNn7pq2JL2hrLPhCXhIIKiU5KfbQCyQk4TWnAjyEY40G8WU8zObnfa+Vl3YB9E8rXOLTjVp0m1Drz4Kic1KbvCmDgfjjRsR2DJvlxOfJ+SkbtwPur6XFoWQfYD9AURxA0yjdOn7I5IOjKDdfueh3sz6AtUQQWbFRvaBAS4EDKvzUp3rTEa9MRfvGKwB06Ny4MCW5Pu4L+WvqcZxmmd809GDu/XGIakZsqFpDLcKl1HbQtGsmBqEnpmh4s8UI9jMTcRNDowLURHPCPSKLL0V2ltLTHPM0bvfgzZi+ObdeXhiQcuE/YZlzZcgjcLUoWayuOUOTRQWufPe+a0ZTd4mOjwwso9ESUQasoILWH858lzexVI6eIx/H5mQUuMUiVLcUtwJqbyfwGP9vwa/a5cGArI46mS9mflNOzIV7Ei1DjGB2PqQLCFiUZhksRGIEwqW4t30zPtZH7NRrcaJghGcVvsGSFPS7IgQYpVhAJRTV79aPi2HJBK42KbuVrAPKJd7XQpVqqi5eKAjri12Hyd/oUFumCqKr7+ymL4rY+KbY8JCoVlHSAd92Z5gyzMwEVvCQMOtSyi2lj2m5KruireIJRJ8vO+VoBLqYCJDfpxBfxnheo3AkW/XI+dT6xb4S3F4acVohgQrq0qffjgS0x7fZjM3sce39dUfGPKE5BeceJ/72mtC3fQcF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(186003)(26005)(478600001)(6512007)(6486002)(6666004)(54906003)(316002)(110136005)(4326008)(66946007)(66556008)(8676002)(66476007)(36756003)(2616005)(41300700001)(8936002)(83380400001)(2906002)(7416002)(5660300002)(38100700002)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7f+aQxlhcqWHrfjoUc+2E6lpzU9E5X6C5dQ/JnnFutQxJSisp2jl5QB+Klo9?=
 =?us-ascii?Q?JxohTCoUv5u4LiMOTNsIb20mWefqV3alHEu0oje2vWgGxZHHeDt4rczkIGYC?=
 =?us-ascii?Q?/+a5tRdbxQlJp4B/2Bj79XdTLw6jyGkpOEIv5lPbzZn7jVUi1hyR56r3KnTq?=
 =?us-ascii?Q?hV5lrPdFKcIAdx37myMNUYO/h8rhMaa7V9HRigmYNHAsX9msFduCX4vQmumr?=
 =?us-ascii?Q?PC3QtX+rUxCsWAOOg+eoZoDsKhBUdUB2C4vm9RQZUq194e8c39+mltOJI7ql?=
 =?us-ascii?Q?FaGShFVVQM99j1t1yd5d93XZpraZdUz+r7xcQwIxQ3/iSPbPGWxzbX/dFEkY?=
 =?us-ascii?Q?+Nmn+Oa3lIpg+GBgRyoalwdeoDWDnD6CkM0IaGQYMBjQQonjxz+XvaB9+k+C?=
 =?us-ascii?Q?/RBeJjBx8FxA7yFlSuXm0SD6G09CaO0xLHUwrywAJHpQJAXJH9VhEFeerOCZ?=
 =?us-ascii?Q?QQX1q0ITQWxD8BqDLofugTuRh21bnjgvqUZAxfMSzZo9tTMBR5vSbD2wpB8X?=
 =?us-ascii?Q?g7fIXAUl8k9uWuS89+FopjZXOCiabvKyoIvY36h0DPgRjI/kwtjNpD5rKJwK?=
 =?us-ascii?Q?SrfVI0V5RyBxx+lx+gXFzpDeA0VwbeBOEU5sI5CYV3zfeGM3NJQGOpH3Vo36?=
 =?us-ascii?Q?e6e1eXn1ZcYHhBU0Tn7xZFb8+nNEwcxm3Y1rNe/jOKEXyQ0D86J98F3YZHiY?=
 =?us-ascii?Q?aitTN6I39iB99qkG0T6UcxqlD3k/qv0Ob55C0aC/qvMUrN1vB8La9e4clQRL?=
 =?us-ascii?Q?Hi0VutivUxPvAtbURdFEqMsk0eh1+wm6fLJlD+ks7+lV0DXXC2KrYAr8teDF?=
 =?us-ascii?Q?4+RIOwZmlwJ3OpHL/xsfehiPHrjythoRXADm0vkBEe8K3ci9sbS87yAFYv6l?=
 =?us-ascii?Q?dmKChfpD3v3MSLHFEO320DIIN+qgWbfsCt/HIHZtgHKhj3Og6U2DYRDrrLpy?=
 =?us-ascii?Q?mBtnY7nTMfupE5AoFRq/EqhPR4gYS7qpD9972GvVRFh/QKVh/Rtk9e3b/mBo?=
 =?us-ascii?Q?hMbrpJATKX4WXBrGIQtRkgm4bDaqtuh4Qc4ArAnWAnDsYrNQNT8rpEJP52M8?=
 =?us-ascii?Q?ok5C1A5J4iGMVWUQNkbqZlmTkz+AbtgWehIQ8vKWUuFuFEUJMTygf8kCZzQ+?=
 =?us-ascii?Q?l1kIRL8YnGQaiHa7nff7v09Ah+0nZiTkKoYhxL52+NAz74o6tbC47Jv70BQo?=
 =?us-ascii?Q?or3Cx0bGEHaEXY1iG2iLfRBPqdy6B0jOmG106Pyby8xO/qlFU3Ue5ZdRClRc?=
 =?us-ascii?Q?xxqybE9MJE/nJjQ6iaGvcj7JClHbZg880quf8K7KHMtW1yUL2jnKrkkSWWy9?=
 =?us-ascii?Q?ce7uubi8ithEXhJZrvMlbgteuZ/vaOH48/gHmr4MheP6j6P5sapk8HNAOkHU?=
 =?us-ascii?Q?bHxgC/aVuvDEcMUTQcSKdZV461mBt53e/9dxWnnSGfE6Li/nW95jW8Y7F1Qr?=
 =?us-ascii?Q?cGPrzVmPxMTh1o/snnk1Fjgk8sTxenPnYdes8DquN/7c8tT337lRCTGeq9eV?=
 =?us-ascii?Q?MWmVJeHN3uT+HWGZ5Fn+GBIWBLKB6d00p3r+KQja/fpXYRFWejxZKuQhdGIL?=
 =?us-ascii?Q?asj6glqzU7D8jkj8sVGqWXaF4wEqHdehu9UHWSSL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3289005d-6cf5-4741-cb9e-08daf97debe6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:00:45.3015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQ1WX3Ma18fOY83qY8rk8IB+ZaB0YFwzIbDxfHZcEPBDEisJQmbDs0D2J/7qFl9k
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

Follow the pattern for iommu_map() and remove iommu_map_sg_atomic().

This allows __iommu_dma_alloc_noncontiguous() to use a GFP_KERNEL
allocation here, based on the provided gfp flags.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/dma-iommu.c |  5 +++--
 drivers/iommu/iommu.c     | 26 ++++++++++----------------
 include/linux/iommu.h     | 18 +++++-------------
 3 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 7016db569f81fc..8c2788633c1766 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -833,7 +833,8 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
 			arch_dma_prep_coherent(sg_page(sg), sg->length);
 	}
 
-	ret = iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt->orig_nents, ioprot);
+	ret = iommu_map_sg(domain, iova, sgt->sgl, sgt->orig_nents, ioprot,
+			   gfp);
 	if (ret < 0 || ret < size)
 		goto out_free_sg;
 
@@ -1281,7 +1282,7 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 	 * We'll leave any physical concatenation to the IOMMU driver's
 	 * implementation - it knows better than we do.
 	 */
-	ret = iommu_map_sg_atomic(domain, iova, sg, nents, prot);
+	ret = iommu_map_sg(domain, iova, sg, nents, prot, GFP_ATOMIC);
 	if (ret < 0 || ret < iova_len)
 		goto out_free_iova;
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 9412b420d07257..cc6e7c6bf72758 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2470,9 +2470,9 @@ size_t iommu_unmap_fast(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_unmap_fast);
 
-static ssize_t __iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
-		struct scatterlist *sg, unsigned int nents, int prot,
-		gfp_t gfp)
+ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
+		     struct scatterlist *sg, unsigned int nents, int prot,
+		     gfp_t gfp)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	size_t len = 0, mapped = 0;
@@ -2480,6 +2480,13 @@ static ssize_t __iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 	unsigned int i = 0;
 	int ret;
 
+	might_sleep_if(gfpflags_allow_blocking(gfp));
+
+	/* Discourage passing strange GFP flags */
+	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
+				__GFP_HIGHMEM)))
+		return -EINVAL;
+
 	while (i <= nents) {
 		phys_addr_t s_phys = sg_phys(sg);
 
@@ -2519,21 +2526,8 @@ static ssize_t __iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 
 	return ret;
 }
-
-ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
-		     struct scatterlist *sg, unsigned int nents, int prot)
-{
-	might_sleep();
-	return __iommu_map_sg(domain, iova, sg, nents, prot, GFP_KERNEL);
-}
 EXPORT_SYMBOL_GPL(iommu_map_sg);
 
-ssize_t iommu_map_sg_atomic(struct iommu_domain *domain, unsigned long iova,
-		    struct scatterlist *sg, unsigned int nents, int prot)
-{
-	return __iommu_map_sg(domain, iova, sg, nents, prot, GFP_ATOMIC);
-}
-
 /**
  * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
  * @domain: the iommu domain where the fault has happened
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 521cd79700f4d8..d5c16dc33c87de 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -474,10 +474,8 @@ extern size_t iommu_unmap_fast(struct iommu_domain *domain,
 			       unsigned long iova, size_t size,
 			       struct iommu_iotlb_gather *iotlb_gather);
 extern ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
-		struct scatterlist *sg, unsigned int nents, int prot);
-extern ssize_t iommu_map_sg_atomic(struct iommu_domain *domain,
-				   unsigned long iova, struct scatterlist *sg,
-				   unsigned int nents, int prot);
+			    struct scatterlist *sg, unsigned int nents,
+			    int prot, gfp_t gfp);
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova);
 extern void iommu_set_fault_handler(struct iommu_domain *domain,
 			iommu_fault_handler_t handler, void *token);
@@ -791,14 +789,7 @@ static inline size_t iommu_unmap_fast(struct iommu_domain *domain,
 
 static inline ssize_t iommu_map_sg(struct iommu_domain *domain,
 				   unsigned long iova, struct scatterlist *sg,
-				   unsigned int nents, int prot)
-{
-	return -ENODEV;
-}
-
-static inline ssize_t iommu_map_sg_atomic(struct iommu_domain *domain,
-				  unsigned long iova, struct scatterlist *sg,
-				  unsigned int nents, int prot)
+				   unsigned int nents, int prot, gfp_t gfp)
 {
 	return -ENODEV;
 }
@@ -1109,7 +1100,8 @@ iommu_get_domain_for_dev_pasid(struct device *dev, ioasid_t pasid,
 static inline size_t iommu_map_sgtable(struct iommu_domain *domain,
 			unsigned long iova, struct sg_table *sgt, int prot)
 {
-	return iommu_map_sg(domain, iova, sgt->sgl, sgt->orig_nents, prot);
+	return iommu_map_sg(domain, iova, sgt->sgl, sgt->orig_nents, prot,
+			    GFP_KERNEL);
 }
 
 #ifdef CONFIG_IOMMU_DEBUGFS
-- 
2.39.0

