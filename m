Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B667F6B1956
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCIClq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCICln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:41:43 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021026.outbound.protection.outlook.com [52.101.57.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C73AA242;
        Wed,  8 Mar 2023 18:41:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XX3IswRAnDEM5pvPZjoAm+mviXWexH99Zhw3+wZYTWky2d9uFhA7jyGjWHiQD2oEWURnJhtgaCdoOchCR8vmkpbk+jRcBwy/MG5Oqhfnw5yNfZRoCVblppijqJR5NAkQUSN7n0cPnOW/ZyDAJJnTCCUY0wHmw85S0TAn7r1CH4x4LveIv2ubNsqADu3k+Q7mCpEo901Vn8dMj090ddsKzKRf0OdbnsK8e5l/xn+AK2YN596bF2V02sIZPLyQFkiDoo21BhWvifo9s4Sa8tePzmIGY/CuKgtRmL+gLnhfavaB6urLjyp3gviP/yromMunpH9xZdif9tY/udpQWZQfvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WMpXjLd+UjKJmPXYudC0MTw+Yv2SaNNAfvRbowIeYws=;
 b=BXGG+cScghzVfSI/OdjxMgr0UU8u/+J/LcwnIgQQOv0pPw8XcVPLUHKGuIKI0mlfpwGqMx5dmmcJ9BhQg0J+ccjPhg8ep+O9WM+GkqQCtPmnrUnLTYn6xp6A323y26o5+GXGlKCxqNGtQcy4GX+l8J3C+Bnt2H5L2cjG5h8HHIGk9RyrbWdx9SOZwdVWc5qukprqM65PrYHwjghksgqkeD0RRyR2r+FZZcDUL3iktJDDgF41w6J+g4/rgnlddCyVm4+BMEPWDnNY1rm8LQdkpwd2HP6iRxiYIZvGAUA1O62pDkLtCYxaEKQ4H0PZhfprE7GMNuKjqfarqcMYDwezZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMpXjLd+UjKJmPXYudC0MTw+Yv2SaNNAfvRbowIeYws=;
 b=Y4JZCE6u01xeEcsFTQvpASEbpqo4hC/qjNQcngpO7BfAx0a9uVZQW3MVzh4UiFPGKEJ7kILA56bXiPYc7ewVvxBy3rqLY4QcE/fJZtdDfqtIglBf0Y5bmWQrSPp1F0mAiNr3+ZbAMvG5YWc6KtSX9iHw1yXwn0TNmbZ8h4/Sw8Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:40 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:40 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Cc:     mikelley@microsoft.com
Subject: [PATCH v6 03/13] Drivers: hv: Explicitly request decrypted in vmap_pfn() calls
Date:   Wed,  8 Mar 2023 18:40:04 -0800
Message-Id: <1678329614-3482-4-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::13) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BL0PR2101MB1313:EE_
X-MS-Office365-Filtering-Correlation-Id: a49cc182-4b56-40fd-6e80-08db2047cfba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OZABL/s18pfGYE0i16VfQkZZKj6LqpeFBcYZx6kwZLI3vpthFQ5N8+Pq5eNJE0ZoJKrjPftE3ICFslD8rHb170ziI4ep5eLWf7GbSIQk93Fdkxbqc7Hx/kOY4XssGSCi9NtTBga/0/Z6Eg30rJFIk7ZVK2OAUUYd3lNTcCJjhZMXkRJrRsYoYiC6f4ShFzZz5foRV0n3VOOG3une7zqDxCtxOwW5pf+qVvsgRe8hMNp3AHhyQzU6/LtdLTOP8JUZfqVXt5Xt+q4wWo+lyJN8TwbWnN+PfBlH6SLQnTbyldA4dXOZ0bVZ1MMhGkFzpRrb0HSxUnNmnO4/g1QXmFRJBpGFXQRBy2aMv9jDhAPYsToPuWlRMqQFQV3TSkYto8s6I6qklQguVfL6aHZXa0dRLWlhZwYJbh6Cy4fwPQlGSlH7SkVmFLzIVco1UwyvJ36LJArzlcwyPl+aQUIE/ej+rJI9K9woRgwjao5grKd9u+WXSglYBmPHl7S18ULVCwS7oPGWtM9btEQhyOgP66EhU8gn5TZCBE0XF1XARPvc/RjEay6uByD8d/2y2HOBoFLUtw94+E0bSpoDBkLvLHk9kIoAdw0//0nexKRBZ753kbht5fxgpZrSlqXXitBWkZkfKkBV2AGtw5VHgniK/9z76kQCxO1URSQoFZD/KIVAt4fR+4J2zMpgn7WXu/aKJFi1z7Ut8jCNpS1twZCMalH9UIJbmDBDJT3QNlY0ZXvkPJwPSMOL4VLWAGqj/KpDkK723UtWLNxLSyB6+OP5TEC7YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HErpfInEtW/PFb9bgO/DszZaIaCmT4ave17VR/z+Ph8ly/3qux/XKKgECKhK?=
 =?us-ascii?Q?swbQ46lDFoGk8epk1FMVezxEeDZPAdLrptQbNFC26dC7gqZIaDQYT5izeRF5?=
 =?us-ascii?Q?g0hLEfMknKG3rnpPVRzbrsVcIkg30vHzZcNINveXXAWosLIXSFsGqffr0iIM?=
 =?us-ascii?Q?WrjjieX+xh9HyddvON8fM34cQzTPgVVPGocwaW6DcND875iZeXWD8zbanCPK?=
 =?us-ascii?Q?paMU4DruMV/p/OwLUIX8k3R4Ob9ZfNJAFvMGrdzOcr1g70WL28H4dFv1RlAK?=
 =?us-ascii?Q?gmUk5dJMsPYf55jlY6WAZlSCffvz+qox8MjLQ8FCOHeqjNBrqovsVKzvqssg?=
 =?us-ascii?Q?N5vMJZAsymAau6JMwIcb6x+S87oRi70lmLKKNff7w1ifnzpNC4zSYfqvwXG6?=
 =?us-ascii?Q?EAlJ4oyBFF71ckj5kCIGIYE5hX2rVy8Aklf1tV8Y/u7JxBsujKWXL5kQPe/p?=
 =?us-ascii?Q?kfOlo0F5kZDNm3+uZM6EJifu5bD54BOrpIw90V9m+I852vTm5QfRPfIUWTI9?=
 =?us-ascii?Q?XCYBXYKqVojmaFrmcKS0Oxx7BFaJobNCQeWR2w6idw+hCAX16HG2t2p1W0ZM?=
 =?us-ascii?Q?MmkznXITd98Zu6ZPhqaloBQTe8zbNHZ6YFDiuY+o+1rbYZMQuYYZ+4p1J+CX?=
 =?us-ascii?Q?oKHG89n0SPNu+zc/S5adiJvl5VzDlW0eczxikjVqMJoE7Zbjh/bA5RiWBi7E?=
 =?us-ascii?Q?ikp/jS9+BYcD6ePh84RR5YvqhxGZkgbh8DqKe1zHYpxB6uZXtSrZXnVa65Qs?=
 =?us-ascii?Q?jv8Ht5w3//NOOT2HRizpIuT+JqYH4iKdLnw5yadaFOZ0x0xhVFtEhe1e2+rl?=
 =?us-ascii?Q?tQXHtEbJBz/zd2SugPKvF4k+iiSiXP53aZxQEGEFovpiD+GkDKXTJO6/QFc4?=
 =?us-ascii?Q?r9XRpYryVVl8DC73+sHZdqlymZbeCpSVMYNtws+r/Qw0yGaWAscFJYz/hgld?=
 =?us-ascii?Q?1i33l1zdW9HjYLmnlF8Uxox8KpbnDfNHUTk309E1CCghhJqUyV0jIZL6A0hU?=
 =?us-ascii?Q?JIWxpSgBPjDLdmfNxMvcDb+mEk5cnGcXq7UwwYYmuHMd8WtImcy78Cz2V2MN?=
 =?us-ascii?Q?YwH2mbD2Gjwlw8De9c5a2jI/w7vFCPLN6aaDkQe6Jw9mCVdRN1UC0t2ALeXF?=
 =?us-ascii?Q?HPDdR9njQ9+vu8J0ZT82m710Ra8jfapX7gsNfITFCIT71KTygTFWVZTWbfKS?=
 =?us-ascii?Q?f2UmNofL9kcgRmnkgc/GyrEuhYvKe7g+dMNObr8pdoR5YfvNm+hfQ0m78NVc?=
 =?us-ascii?Q?RBQoqxM7z0817roaxqddNz44K+W3AfYdxBoqZBopUZq0XA3dN7pd/vilS1bf?=
 =?us-ascii?Q?DwOX+1dTMduiHxzinbZT489P4PDMs0Voxir/+ONTSfXIjvJvGmJwBqsnqWIO?=
 =?us-ascii?Q?0xPvtcLldFvUwFi/tsakdQwh6UY7Rp7w6o6awGLJWeSKNSlvQZq/qjLqPued?=
 =?us-ascii?Q?YKQTaZQmm7eogFdvaL6kWr1Ui6qZIO1cAPxjJtBSzd1ZALPVZBsPAq59ou16?=
 =?us-ascii?Q?oVXrP3PEpEMwAD+BHeqIYtWQ2jOydyR4xgTDVYcQhwxzohYAiPL1MoBGU1Ob?=
 =?us-ascii?Q?Q059xP372Up9DvivhslTP2x1lOHVb+wqwFX5m4P0rRGtkfg10f/CSsU+Uwvf?=
 =?us-ascii?Q?zw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a49cc182-4b56-40fd-6e80-08db2047cfba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:40.4800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lX10i8QRYpeAyKNmzAxxJbqS05e2rf053Ccw70/wyz0aHd0XWRvDLjHRJMkFFcabK/X/hzrwy2qqop7EvHOSaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update vmap_pfn() calls to explicitly request that the mapping
be for decrypted access to the memory.  There's no change in
functionality since the PFNs passed to vmap_pfn() are above the
shared_gpa_boundary, implicitly producing a decrypted mapping.
But explicitly requesting "decrypted" allows the code to work
before and after changes that cause vmap_pfn() to mask the
PFNs to being below the shared_gpa_boundary.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/ivm.c    | 2 +-
 drivers/hv/ring_buffer.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index f33c67e..5648efb 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -343,7 +343,7 @@ void *hv_map_memory(void *addr, unsigned long size)
 		pfns[i] = vmalloc_to_pfn(addr + i * PAGE_SIZE) +
 			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
 
-	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, PAGE_KERNEL_IO);
+	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, pgprot_decrypted(PAGE_KERNEL));
 	kfree(pfns);
 
 	return vaddr;
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index c6692fd..2111e97 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -211,7 +211,7 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 
 		ring_info->ring_buffer = (struct hv_ring_buffer *)
 			vmap_pfn(pfns_wraparound, page_cnt * 2 - 1,
-				 PAGE_KERNEL);
+				 pgprot_decrypted(PAGE_KERNEL));
 		kfree(pfns_wraparound);
 
 		if (!ring_info->ring_buffer)
-- 
1.8.3.1

