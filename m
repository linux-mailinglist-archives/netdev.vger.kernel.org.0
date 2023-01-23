Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D199678828
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjAWUg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjAWUgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:36:19 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2287116335;
        Mon, 23 Jan 2023 12:36:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AErqawBAwEqNfxqkBtXnrPBpAcyd7KwruTaxW0eL/9yT78bttLlTg/fsMv40IurksT0u5Xhndrc5eEDSgdd+BheunYomM92pA+h6eoDNrnKffB9U0B2yHMqozfbV1ND20/1/ca90OpizsvTniCFWcRyoyLjKGx9ZaynUV1531WfA9MDLk7viwb3w3QCTeFPMVM9MSEFK14XAsOtxeLD7NJE1WEuYRClJucB0DO5ZDcbw8GqcIFjsvH8qy/t5LSRrCF/hA7PFFFZdMhcBaPahEb0NRAP5TYy1mdwbwuUpjDP2Uvl0D9y1Iq3qn5lJP6hfHP+4kTjLfE92+H2bNB//nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Hqi9IkuwfnBrJkCJrDC5DL74fTccWNtsKEVZvqfdAs=;
 b=WZpJCvFTQYyNcG9JYZDuAFQRBT8NzkPdIvch0tyi8uY1LsZcTeSv2QftmLFHirxEts0RZcFIhfV4ylM0gXGwFh+yjrts/QVy8aWfu2vxYvVhtvthBmPsZY/tywgltExRMlmMeUdQF2yYBt+sLaT8JuKL7tBm6Gi03iZ9iEYVUCxAGN/aZ6Dg+/3mC1vUcXQs3XHdNKwoiKRTdKBBlWRX8Q78QvIv9d3GvPH08rXhD3UsoTBEEWcmr2q8bCPFxgtbd87KKp9M+VyLxUI2++SqPN38q1IcRqXwBs6FpbDxqKX7jF15RQIUM3Lamu+TM+a47zfgmNepwXa3FK4m9g6AoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Hqi9IkuwfnBrJkCJrDC5DL74fTccWNtsKEVZvqfdAs=;
 b=EPU5ofcLJJAQg8p48ajKcIWnwz8Y8eBsJyFhyIFoYFz81NExcNYM1MLRulcU6UpSfllM66BOPgw0BUmxM5akCY9bxnuIw26z9DqgKaufQFGkuqlWLGvKP+Nnb+92xidi1EQR9NB0x8/dMwwxzdebrpD+wsHC5BAmJ0TOdpx76hYQc5qmjINPZWjDi0QV3jYWirgER3tnGBvbvQNjWxnnTTgg9ePv4tkKebYqkIkpvlY3nO3F90G7dWl5x8N3kBRral7cj9ZnEAAjFtcjBSad3ESxoA1Zzf51V1dMIF0zfCBMPqB3VvdM8F3lkzcna5ySeAzjvNgIrYxmOkus+dTeAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6571.namprd12.prod.outlook.com (2603:10b6:208:38e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Mon, 23 Jan
 2023 20:36:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 20:36:05 +0000
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
Subject: [PATCH v3 02/10] iommu: Remove iommu_map_atomic()
Date:   Mon, 23 Jan 2023 16:35:55 -0400
Message-Id: <2-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
In-Reply-To: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0253.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a66bdee-2237-44b8-e925-08dafd81729c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hasSl52RIYD2H2cOuOBRvMhL7KosuGUEfEh3lVhHU1gH/ND8N7Pp3UGD0ZUK1MywIb4THhu4ezVyC7CyAbPudZaRSMDdNUFJQsxMq4c9RRtZHeZsrbHSqj/vGuwLTZpEZohLcbLlDyZJYV9LFpphjF7yzAQ2V1mYWaEgtTFxM4kFYsZ5yo5d9AyoZUkGtefaQ8hlWBtCs03mLxSw9CP2y36C5fNp+jkeERIKyocfZ31PnNuo5JyqEUlmzR64ittr/RBMc2p49cNaI20jP2AfgmzY98OkDAsiDT43izw9KkT1NnjDLrBBcHYB4258b33FPi7ydjBIEeW0yF7XA5zyudxiSZOEsLyVrfk1NQ2kEUK3GLult2CRGmxNUN8P9gF1NhVp61dyPg+8Zn8TV63LlX/awt3/MWqcDng6WxyxElsc0XLM3LfL3eX2rZ9riBRX7b/No6WA7SFYEGDBVIZyArqzFrR9UtlIVXr18ygAGc6xUD+htwNljd3eJG0w5dP4l4rDIAX9mmoDSOL3DRS3GhBwNnjkc6vjTgKFYSANrZrN4tupFG99jIxMipUoxj0ta8imotsI2dpeiq2co86Nmnzglt1YamIAiKDcxfg5eVtxO4ZLxADdKc896vjg5Dl+YJ2wQq3lQ+b056CF7T96eUsL0OuWUraw2JeOvIPUMpgFSsqVNNEzyGo7BEA8OHMb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(5660300002)(316002)(8936002)(7416002)(41300700001)(38100700002)(110136005)(36756003)(186003)(83380400001)(478600001)(6666004)(86362001)(6512007)(6506007)(6486002)(26005)(66476007)(8676002)(66946007)(4326008)(2616005)(54906003)(2906002)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZcFMO/If6CJVQJ3KYuCVYiUtaPqdRTZYpcZqkavkv9i92AiEGhVTI0MdFX7k?=
 =?us-ascii?Q?PulTgIubmFjn3Dqf8GEEM+f3PERjLfnd0x09nhfp05eTr4lwiPe2HnuZ1YSj?=
 =?us-ascii?Q?f5NvpjdwyVLll5T1TQIxohFt6edX8cC4F5SwL8zDcb/2UOHkwVqYu1LFT2h0?=
 =?us-ascii?Q?4TTTM1uWmr8qJw3sOeoCEbMMab729rnVq+h1D0m7RPsvPkn/i9m1rbFLLSqm?=
 =?us-ascii?Q?51YEqCaDD7wmfmQ1kGrurPoIHL7HbavDU/Gn/32y26+K28Ttc4cnpVjr5jud?=
 =?us-ascii?Q?A/OE76ykSsr2yXeglL5Q9WC76PsTpLqWGP0ihfjWI/Cbu48rdrvEVSYdN6/h?=
 =?us-ascii?Q?nZokml4ik8XzYqL3kVTXSMlYy95qfnVmyoWfOQVAsDuBQTr8AAbQqJDug19m?=
 =?us-ascii?Q?1IvBdHNktw0Emoqwe3wyuaQhJuYuBp9zPcmcPm+Jms17mXOLwMwd3IHdz6lR?=
 =?us-ascii?Q?FJZBgkW+vKfXwkWqFhHp2I04mbcj7hN+FlxVfZy8PxMzeYu8GOezvNEoQezD?=
 =?us-ascii?Q?ZlaTQ7L4LMS2tJgT/FkXi3O9YTja9xiEruEHq1DFLlxVxdX9oAM+L/Izt2Dd?=
 =?us-ascii?Q?eWBpdCLHF17shpkeb9d+iiDTrX4NLursUAUFS34ZM7XxVHHm6cEEZDc3DcjU?=
 =?us-ascii?Q?jEJMz1Mogx1iZJ8TSTOR7TBaAwUq48FKgR8+3KI7KF11zSdtbcCgT99dEuAh?=
 =?us-ascii?Q?89BGhxJUiRO8c6nAhbPhkctxGSPVaQjtBqc4mxw7mz6+9WwEMR7nWypOzAgv?=
 =?us-ascii?Q?9rQEjXBa1CAED7i8BC09rMxqqA7rPy/NLp88mXBaBgMFhwGQ0wOZQzB5GuyS?=
 =?us-ascii?Q?FbeuyxbB4ahwnd90KyCkvE2loBhonOfjDABKsI0UzemcJms5zEoPIRcM36gD?=
 =?us-ascii?Q?gGD/WGb4fOWDv4AI2AUazBku0fXOtubwIeEcNInL7wP9qLplHHo0XcUWTYlq?=
 =?us-ascii?Q?i4izlZVIHUTn731ifrrZuNN7+gugkUiSx5eI8iHwtGvjzlplck+Ka8VtcuOw?=
 =?us-ascii?Q?UwigR9uj0fc36QqXwfSI9eEZNktIkMxoWBrjrR+NE47BWnR8mwXPAp+E6HjG?=
 =?us-ascii?Q?ZNuDW3qajsThdZrsvdj7kigSH4Gs4afCgsRq+Xhcw4xBmzOW/FtN/Y3rnGSu?=
 =?us-ascii?Q?Z3hfxCY3gbPBS+ugIOLEaZtoaiOjm4XYLkEmsx2H5BkntoUkhgxZ2tp6b75S?=
 =?us-ascii?Q?55+J/nOXEosCCXqDx5W6cunaOtKl874PpJOMpT9pRmqpPDa3VQyLhP0fvSia?=
 =?us-ascii?Q?TUaGXi2y8hK4h/+IVvqFG6dlud3L2Or5cJUUMh/aKScIGFD6AzE6f/bxStTm?=
 =?us-ascii?Q?1phpI7mXN8Q+Isoteo8lhwT6uAPRXjeEE4P5toFv1GkA0cWvkJSB+QfZmZJJ?=
 =?us-ascii?Q?LY1h/tJmtbBf9OMtV5JsbuJ6xJmJmxAfH8pFZLUoogm1eTylDk2H1U8UJKrB?=
 =?us-ascii?Q?Xk5Shi46tesDaLdjn3ymKyEsqmOtvkZG7dbRJmd+KQHm1N308fcXnt5mUy1+?=
 =?us-ascii?Q?/Vyt0vRv6m9sCEuAyBrvv5ghtfOVtWVJTq6K5jeWNamSnsc3GOQdQDi5lqez?=
 =?us-ascii?Q?UjJXFCQa1/03f1KCSYBYoJsyC1JRIiuRXb8qawcg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a66bdee-2237-44b8-e925-08dafd81729c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:36:04.3246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1AgasB/w+6OITMEYLI7M0v2PE7s8QcDDv441Il5Vjini5ivI1GMCMpoZn/B4q5H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6571
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is only one call site and it can now just pass the GFP_ATOMIC to the
normal iommu_map().

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 2 +-
 drivers/iommu/iommu.c     | 7 -------
 include/linux/iommu.h     | 9 ---------
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 8bdb65e7686ff9..7016db569f81fc 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -713,7 +713,7 @@ static dma_addr_t __iommu_dma_map(struct device *dev, phys_addr_t phys,
 	if (!iova)
 		return DMA_MAPPING_ERROR;
 
-	if (iommu_map_atomic(domain, iova, phys - iova_off, size, prot)) {
+	if (iommu_map(domain, iova, phys - iova_off, size, prot, GFP_ATOMIC)) {
 		iommu_dma_free_iova(cookie, iova, size, NULL);
 		return DMA_MAPPING_ERROR;
 	}
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 7dac062b58f039..9412b420d07257 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2381,13 +2381,6 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 }
 EXPORT_SYMBOL_GPL(iommu_map);
 
-int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
-	      phys_addr_t paddr, size_t size, int prot)
-{
-	return iommu_map(domain, iova, paddr, size, prot, GFP_ATOMIC);
-}
-EXPORT_SYMBOL_GPL(iommu_map_atomic);
-
 static size_t __iommu_unmap_pages(struct iommu_domain *domain,
 				  unsigned long iova, size_t size,
 				  struct iommu_iotlb_gather *iotlb_gather)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d2020994f292db..521cd79700f4d8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -468,8 +468,6 @@ extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
-extern int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
-			    phys_addr_t paddr, size_t size, int prot);
 extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 			  size_t size);
 extern size_t iommu_unmap_fast(struct iommu_domain *domain,
@@ -778,13 +776,6 @@ static inline int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	return -ENODEV;
 }
 
-static inline int iommu_map_atomic(struct iommu_domain *domain,
-				   unsigned long iova, phys_addr_t paddr,
-				   size_t size, int prot)
-{
-	return -ENODEV;
-}
-
 static inline size_t iommu_unmap(struct iommu_domain *domain,
 				 unsigned long iova, size_t size)
 {
-- 
2.39.0

