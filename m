Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF8863FF11
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbiLBDeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiLBDdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:33:19 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021023.outbound.protection.outlook.com [40.93.199.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E03DF3A;
        Thu,  1 Dec 2022 19:32:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6EcD6NFJY5R1cOH7dW6UG8Uf1+gtYRI30/7JlNzyzRQ+K878vf2JOKCdNeUpZ9u5dO5zXNkT/EJw6bj+es5grUln/1lF9uS/SWbPVVP2MsTBpYwtTQJaOiNMvvb0djv73WlfajxrorImdy7MnAQbQaEoNq2Ay6Oo9FY9F4+GoDwFFms6T3VfaDKGBkIyIWY9ybaqQFHsNi2b4/Xs+1rC6gRxOSuy2oQzUx7/Nkdv1A8F7kfHuGdx1D5vi22ztP7C90WDs+TQsbh/SYOpk+TZro5kYDEYIG7dh8p81GXab+z/btAxcMNlb5Bi9RLM/+IXaePvLRT+EJhajjzxn3nbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLvLpvSwNbIGXks/vU31yhV4PgqEudo572uGrbfS4zk=;
 b=oXFpdQmkf1Btm7jWnMKr6lLFpQxiZFbf8TmcBp6Y16pyUxKi9A71wCfpwKkWgrs3zirBw6p7ILjlHLw2HP0ylIqLrgiTN0rEDYj6CLjWAkjBtzqJBtR2p0kLp4JfC7wA9z1gugD0NY3I0nE6Pa2cDLS8s+Qe6t1rEVK0hVp6aHPuzSf6fDorpSH0eI2XHiE4RpUXBDsXzHqDdgWFhqwplSRnL2lNm7rDiiK3/J1QEBn4+zvFMkJRZ6UI5M1MXH6P85hqob3Q3G/dOdA4eBng1lg3RC+Ui+6HqjgvJOLQfzP1B/gb5v0agMMlMjzfwV0DngCpSBqtNB6bm4xy6q0ajQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLvLpvSwNbIGXks/vU31yhV4PgqEudo572uGrbfS4zk=;
 b=IuuZXYpcWwqR/NpebKSpVDXYIMkHgKOZJRKD4U/D3J2Je+cBV82ikeTQgQ3F8nFhYejDCd7b+B/TjPe0N+FhSDE+E6QCEPkm5b0twEJKphLQKIZ1YAUVO8MrtVh3P1707HiU9be468I43CIpEBuTA1YrPFSLIQL39RWlceTbpto=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 03:32:24 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:24 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: [Patch v4 10/13] hv_netvsc: Remove second mapping of send and recv buffers
Date:   Thu,  1 Dec 2022 19:30:28 -0800
Message-Id: <1669951831-4180-11-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0234.namprd04.prod.outlook.com
 (2603:10b6:303:87::29) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BL0PR2101MB1316:EE_
X-MS-Office365-Filtering-Correlation-Id: a6664ff8-452e-4284-9c84-08dad415d41a
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AjdUBeSzzuytcdRkD/V5e0q5PfYXVopWMa/2piT0GZYIkc4I0QLPHI/zLgABQLaoBFH0oLEuLQRf28USRTZfdUcDOYrj6j9pgyTqXvjjRM8oz1p8LVEtrChs5gZ7t5Mv2cecZZbVw12GYlu1LTt6t7T+A6+6Xngiabd+ylNnRP3DIyS1jBwpNgRe+WXX1Pi6RpQ1hp2j2jNJxIWRC/GpO3THpPdHEO3D4CE06ZeLXCd0650o7gcHVMuJnTR8HnQ6bYOu0WASdH4IQn3ZszuHrvXqxf0eeBl81fBQnZbFeIC5NzEEKRXhzqoQZSPdimqDbMeIZf2pHgWxkwPwnCui2AIs+WHelAQ7/fNC6l2nDYSc86PMHczlfFr94NNwat2Myw0CT+P0DG4vZ51GXRPXe9bnw941QobydKeqfqrEmNRzbMHqe51rkVhWckz9/sdBigKQ5LmbDUBShZn3QgFyR6c1ZaMHF6jed3ys6N45E6RnlPWulDGji79Rc85IBW3CUnaCQX3FKn6ENxSfJ1QSoglEZ6rYkCtaL8v924vm320cPR8CfamaIOM9VTHGllW4IUVhu+qOBBdOcdBH5135mpqOTI0uBf16VaUTEb+CiVCcB1Epk5L2igjdgbyXEDw4K+NnFlGHO8JgaABNHHwQx5oup2WTH/JudyJLCoIiph97xz+eoRehiLiHeQ8XxaklR0afYyog7Ga3OinTGQA8C71q98iT5BQH07FnqYFeGYTtURgzvk/C7t/fy65qYwem
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(86362001)(921005)(41300700001)(36756003)(2616005)(186003)(8936002)(5660300002)(66476007)(66556008)(52116002)(66946007)(82960400001)(7406005)(8676002)(7416002)(6506007)(107886003)(6486002)(316002)(478600001)(10290500003)(4326008)(6512007)(26005)(82950400001)(38100700002)(38350700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zuG15Q7e3ElnC7eEyOuHyHjB9JYN+ErNBCCruAXPbgSBThz/Y5YemdnSPjY2?=
 =?us-ascii?Q?4285oKRkWTTNfYd9kMOS1p8sCn4tnX1Y62PRp2e6aIOnfaoCqVsFRDk6lzyN?=
 =?us-ascii?Q?uyEvqd2xxh8v7rYF3C1PrDyYIR8abSBT92kxXEJL23ciDp59wrTG9fIQsyuJ?=
 =?us-ascii?Q?TEM9Hz0lycQI/0VwiXmxAWZ7Ex9vx1buRRuaswE9+3kjGNTebaS/qmeksFjP?=
 =?us-ascii?Q?Nrx74ketG0zIR+8iZCUGfG8OTW7n1K5tlQUxDwryiUyvbOYOlImJPQx8tKoz?=
 =?us-ascii?Q?St9gZLXHJRPMDAim5+7UMFDCsoexkOdc+m1zVLsN2LKKwK3DB6CAj7u9sabg?=
 =?us-ascii?Q?lMyYblSAtAgeMB+0wS8Kobj1DvoQmkI6o9aAV65hZrxEVIMVRmHi75YvySGA?=
 =?us-ascii?Q?G9iZXYkNjoqSvy0oKt5fXy68qrmyi/uHYItx1HS2ANbfxJtdSg/vsD+sPd5h?=
 =?us-ascii?Q?dd9z+H7RyEMWa1OI71TnMSwT9kNnBMLp+Vyl1fJHbQj/amXXd68W4iIO6lyn?=
 =?us-ascii?Q?5ggp5+TGXZYNrR/KfK4K4fXsFR5CZM2J9a3iI4mtFKZF5TeI3ti+b7USoB47?=
 =?us-ascii?Q?OyvIL6MsOU/0S9DtZpipqOQeTtUzbTOGa/ZPZzEFEtVzTN8Zgoiv8OTEkf9w?=
 =?us-ascii?Q?9ucxLOLDWzkjP/65FjMBdqTMGsAP12YkjqaJgGKxdE8rFfYwl/mPtX+HoAvI?=
 =?us-ascii?Q?jX4HRXtg87TFClQmE4LcoHqf6qMkrkur/nG7uJnnXTAW9CjJhtoN/PpQun0z?=
 =?us-ascii?Q?50UPWC4qWp+noRBNyxiKQ6lrhuuyW87QskdUtMuZPxSu8x8j5IR4S+JkDZdB?=
 =?us-ascii?Q?cS8HSLOlzZox52Tez2CSw2GcCF/LlX4PRF+aANtPSVNiNvqTXNzJBhWm1paN?=
 =?us-ascii?Q?+ftXSmTabauBdzaF7oN72m1YGFo2sfRC1+brI+k+1WQL4Mz6LxZImz02V/UJ?=
 =?us-ascii?Q?KEBLfw/7uWVEEd03c9fxsAeFYRDPTM2yqsStefYOqZsWo/edsEJ76w0eB4v2?=
 =?us-ascii?Q?azBAuQmosmCwq3Rmn7PIrj42YhTGjEEmqqoMz83AXv8c9KFzSn01R1OpljzQ?=
 =?us-ascii?Q?HmRbeNXmM33A/1s1D8A6cOVSxrV+FlAPtlX+w+zhlKhbPJ2raSX4PzwrEjKV?=
 =?us-ascii?Q?YWlnbvs56stlXFr+8F6lEC2cbNNUVv04k5UrZExL1ISOizo7836Rl8p9Bx/T?=
 =?us-ascii?Q?4s8ZXNjIIvvlrUlTM0+Uq7Om58PN8PZVoYrZLER4RLZJB4KVBqusEBxje6M7?=
 =?us-ascii?Q?I4mnGNktI/7YuT35pStXLZL/2goaWLNQBoUKQYKdKZE+PfDFFmuL4X3TL540?=
 =?us-ascii?Q?mAdyKfeOO+haexbRl2doOw8+4GcfxhweaBHUcKeoyN8HanES7m4WoQEUVU9d?=
 =?us-ascii?Q?yfk8NmpYQJLAR8C2xHKMjjvSFhHik65NwTFGM8ORwQbA7uxIEnIDzz5/xd7w?=
 =?us-ascii?Q?ppPJAPA+fzjaX60JaYbc1GOPmg2vJ9DJJiwHcXEtJLdbGfWdDziDg3ra/z44?=
 =?us-ascii?Q?8eGlvTVLLHNJfRhXjOJUQEkZwWCQYAvt/7VNW2xMT4sjr7qkJc2Xodh1cn9J?=
 =?us-ascii?Q?R27AgMEwEAmYKDKMTGmPJQurJgP8b01ORBhJVfvvSrpz7DBL7xKO6MUxDn6f?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6664ff8-452e-4284-9c84-08dad415d41a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:24.6761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6dlaqNRUaFGQB5dx03gnBWUL5XTu4Uzt/57baOAEU3/ntRbtnVG7b00AmKYaqkJITgUNhv1ELSkZSLo0f4gTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With changes to how Hyper-V guest VMs flip memory between private
(encrypted) and shared (decrypted), creating a second kernel virtual
mapping for shared memory is no longer necessary.  Everything needed
for the transition to shared is handled by set_memory_decrypted().

As such, remove the code to create and manage the second
mapping for the pre-allocated send and recv buffers.  This mapping
is the last user of hv_map_memory()/hv_unmap_memory(), so delete
these functions as well.  Finally, hv_map_memory() is the last
user of vmap_pfn() in Hyper-V guest code, so remove the Kconfig
selection of VMAP_PFN.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/ivm.c           | 28 ------------------------
 drivers/hv/Kconfig              |  1 -
 drivers/hv/hv_common.c          | 11 ----------
 drivers/net/hyperv/hyperv_net.h |  2 --
 drivers/net/hyperv/netvsc.c     | 48 ++---------------------------------------
 include/asm-generic/mshyperv.h  |  2 --
 6 files changed, 2 insertions(+), 90 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 8e2717d..83b71bd 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -356,34 +356,6 @@ void __init hv_vtom_init(void)
 
 #endif /* CONFIG_AMD_MEM_ENCRYPT */
 
-/*
- * hv_map_memory - map memory to extra space in the AMD SEV-SNP Isolation VM.
- */
-void *hv_map_memory(void *addr, unsigned long size)
-{
-	unsigned long *pfns = kcalloc(size / PAGE_SIZE,
-				      sizeof(unsigned long), GFP_KERNEL);
-	void *vaddr;
-	int i;
-
-	if (!pfns)
-		return NULL;
-
-	for (i = 0; i < size / PAGE_SIZE; i++)
-		pfns[i] = vmalloc_to_pfn(addr + i * PAGE_SIZE) +
-			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
-
-	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, pgprot_decrypted(PAGE_KERNEL_NOENC));
-	kfree(pfns);
-
-	return vaddr;
-}
-
-void hv_unmap_memory(void *addr)
-{
-	vunmap(addr);
-}
-
 enum hv_isolation_type hv_get_isolation_type(void)
 {
 	if (!(ms_hyperv.priv_high & HV_ISOLATION))
diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index 0747a8f..9a074cb 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -8,7 +8,6 @@ config HYPERV
 		|| (ARM64 && !CPU_BIG_ENDIAN))
 	select PARAVIRT
 	select X86_HV_CALLBACK_VECTOR if X86
-	select VMAP_PFN
 	help
 	  Select this option to run Linux as a Hyper-V client operating
 	  system.
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index ae68298..566735f 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -308,14 +308,3 @@ u64 __weak hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_s
 	return HV_STATUS_INVALID_PARAMETER;
 }
 EXPORT_SYMBOL_GPL(hv_ghcb_hypercall);
-
-void __weak *hv_map_memory(void *addr, unsigned long size)
-{
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(hv_map_memory);
-
-void __weak hv_unmap_memory(void *addr)
-{
-}
-EXPORT_SYMBOL_GPL(hv_unmap_memory);
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index dd5919e..33d51e3 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -1139,7 +1139,6 @@ struct netvsc_device {
 
 	/* Receive buffer allocated by us but manages by NetVSP */
 	void *recv_buf;
-	void *recv_original_buf;
 	u32 recv_buf_size; /* allocated bytes */
 	struct vmbus_gpadl recv_buf_gpadl_handle;
 	u32 recv_section_cnt;
@@ -1148,7 +1147,6 @@ struct netvsc_device {
 
 	/* Send buffer allocated by us */
 	void *send_buf;
-	void *send_original_buf;
 	u32 send_buf_size;
 	struct vmbus_gpadl send_buf_gpadl_handle;
 	u32 send_section_cnt;
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 9352dad..661bbe6 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -154,17 +154,8 @@ static void free_netvsc_device(struct rcu_head *head)
 	int i;
 
 	kfree(nvdev->extension);
-
-	if (nvdev->recv_original_buf)
-		vfree(nvdev->recv_original_buf);
-	else
-		vfree(nvdev->recv_buf);
-
-	if (nvdev->send_original_buf)
-		vfree(nvdev->send_original_buf);
-	else
-		vfree(nvdev->send_buf);
-
+	vfree(nvdev->recv_buf);
+	vfree(nvdev->send_buf);
 	bitmap_free(nvdev->send_section_map);
 
 	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
@@ -347,7 +338,6 @@ static int netvsc_init_buf(struct hv_device *device,
 	struct nvsp_message *init_packet;
 	unsigned int buf_size;
 	int i, ret = 0;
-	void *vaddr;
 
 	/* Get receive buffer area. */
 	buf_size = device_info->recv_sections * device_info->recv_section_size;
@@ -383,17 +373,6 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
-	if (hv_isolation_type_snp()) {
-		vaddr = hv_map_memory(net_device->recv_buf, buf_size);
-		if (!vaddr) {
-			ret = -ENOMEM;
-			goto cleanup;
-		}
-
-		net_device->recv_original_buf = net_device->recv_buf;
-		net_device->recv_buf = vaddr;
-	}
-
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -497,17 +476,6 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
-	if (hv_isolation_type_snp()) {
-		vaddr = hv_map_memory(net_device->send_buf, buf_size);
-		if (!vaddr) {
-			ret = -ENOMEM;
-			goto cleanup;
-		}
-
-		net_device->send_original_buf = net_device->send_buf;
-		net_device->send_buf = vaddr;
-	}
-
 	/* Notify the NetVsp of the gpadl handle */
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -762,12 +730,6 @@ void netvsc_device_remove(struct hv_device *device)
 		netvsc_teardown_send_gpadl(device, net_device, ndev);
 	}
 
-	if (net_device->recv_original_buf)
-		hv_unmap_memory(net_device->recv_buf);
-
-	if (net_device->send_original_buf)
-		hv_unmap_memory(net_device->send_buf);
-
 	/* Release all resources */
 	free_netvsc_device_rcu(net_device);
 }
@@ -1831,12 +1793,6 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 	netif_napi_del(&net_device->chan_table[0].napi);
 
 cleanup2:
-	if (net_device->recv_original_buf)
-		hv_unmap_memory(net_device->recv_buf);
-
-	if (net_device->send_original_buf)
-		hv_unmap_memory(net_device->send_buf);
-
 	free_netvsc_device(&net_device->rcu);
 
 	return ERR_PTR(ret);
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index bfb9eb9..6fabc4a 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -267,8 +267,6 @@ static inline int cpumask_to_vpset_noself(struct hv_vpset *vpset,
 void hyperv_cleanup(void);
 bool hv_query_ext_cap(u64 cap_query);
 void hv_setup_dma_ops(struct device *dev, bool coherent);
-void *hv_map_memory(void *addr, unsigned long size);
-void hv_unmap_memory(void *addr);
 #else /* CONFIG_HYPERV */
 static inline bool hv_is_hyperv_initialized(void) { return false; }
 static inline bool hv_is_hibernation_supported(void) { return false; }
-- 
1.8.3.1

