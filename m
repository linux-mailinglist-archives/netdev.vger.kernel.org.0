Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C746B1991
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjCICql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCICqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:46:00 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021018.outbound.protection.outlook.com [52.101.62.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED6F93E02;
        Wed,  8 Mar 2023 18:44:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EflOW5kG+rL6qOrXunG5R0VIRxcJuZUNE6yu2dx1GwxtTkmyvoaR43OUKwnmdfhG6VOV2+YaoiYeSBaukJTpt+xFF3I0IONO7cKrsMkuLOniqCBstmy49Cdw3i5nUn9ZBxqlux4dagtF9BQfzX69vtebzxy7hAP5voo5L5sgW08VKPaFfOnKJp+AtIBobOo19LOwBkiN+qqtj/piN6Neu7wJlZU85I5wuYLhTsWA3qDGy0LzKA1gcOW+q9us/qAwHoxfeRL4gXh4mkS5kkdQSz1ab58cE2NfVynK3U6CaWUkaMrFiDpLgwtrk3DK148CB3xt1deT2RZP5ApbpZSe2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=btHCRwLeI1shgTOdpYSDuK5X6Vba/jr4GkHOzvHVEYc=;
 b=DRgS1fRnwXbtdh9FYEYD0hV+2uR6ps1W5O2OBX/JM9J+ULAwY+HOFTejJZcWk1qzj7gipRgShgyj8E/sZTKjSGRXQqcd2Pd6QXMLyexqTRPw+fD///6DnXn/uhXwlHkG2HBHBigq0rFuxe/s6jKjoPJV/g7yqf1gmRfkP3ArsPCstYhcSxlkPCWmkS/2Q0E/vbheexysHR9AAm6Mkh+ghDuF/Z+HmhcXLglgMNsjBnarS05HMu25e5FL2vFMEGJdRtlcX9RDQ2mUlBryPJHe/HmfbMDQYSVYAURMbQboSmbUaBFvccHSqW4xp0d6Y4Op7XQ3noT2DTX8/8LQwhKv8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btHCRwLeI1shgTOdpYSDuK5X6Vba/jr4GkHOzvHVEYc=;
 b=Fb7BSBQ20rI2JDnBVE2lYRVDgK3pMmjTG624vsjDDob5sipSCV8t9sK5cgTWEtU+zxtsBucfCo/HpCGbYSxoSx3wFF4A+4nXGCZwCQTo5nEHvQWv/N7LeuJkhld5VoBB6pLHIxmzXv/4Rn/Rwyh3zcmSs5Axpd6CdIlTcEtjm9w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:56 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:56 +0000
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
Subject: [PATCH v6 10/13] hv_netvsc: Remove second mapping of send and recv buffers
Date:   Wed,  8 Mar 2023 18:40:11 -0800
Message-Id: <1678329614-3482-11-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: f79e6ef2-9ed1-46ec-e369-08db2047d8ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52Wp7LZwRD8JlN+8P0mt9JHHxPbx/tDJJIg8iF9xTUVzmeQHRedVe/iJ8pPl6L6gk0CrtzL9SzNtNO8Vka0yJgxxkQ4feYC8qMpvjXiE4w0d94XAFkzdwG9OlYYG214PlwxSIUy/a5XimapeRXNOHbA8IM5Wbnensx+HmOOUiraZpS2z4a/Vphl0y4JkMkizdPQXF3o47Vu0ac4yikLs0nRwj/OTH1d1DQxx58lqZfrbJj2fi3Xcj8kA5gIEeaHZLRunvZQnRuy8BBLR1+M8TUsC5UI0siFG9WLjodjDOpyoOBPO80kRmoBIDs0blzBwl0pwiOYH9yKGqnhVXiAIo8IOC14UyjEZS7H0ABMEgnSaBC9fq6lIRpHwRA8gmvGtUhqmWgwingpt8EU4VGWeUW+TD8F/HrCoFjZlJhdax2qetmFrzHTHEz2gKkwl4A88QnDTHDwUeqZPpUaXZ9zPsVGouwaGmwLNC0d8fLecIxxcNpDo9Zlc/HEyBB3GrUx7G/1I/qeUU+4SeE+EmzRO8ks6IJhet0Sm4DSVJCTVRaiTGco1FTEM6RoW+j5UDQIeYbrjvh0cLSMTlGPw2lrz6T9SCOXxUigBPjEGV0kp69dYk5ME/OLAFgl9D0chiGEQ1rR1G9rUhmZ9JEfzf4InaDoIIE2iNausPDnPeWQhZ4+V64CCqF6tyw9qDxm1DuveYZ5iZr6vlAX2SE1LoVlb08Vwy8L5fgWMHBo8SSeritDTRePhvqiHt0wIsW8JDa95ZHZhsb3ObgtIKlB6JeXIOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5A952LvTtFh2W25IPQZ0dHscPbMZKDDwvpS1ZkoHb70hYlK5KKOjgHJDLrl7?=
 =?us-ascii?Q?LHY+9Kky/gE5acVMWYpsIVRcI2URg8Fe1DuDXjOgH2IKAQZ3UAzMhTLAgE0b?=
 =?us-ascii?Q?mO3T0g/dVzXry3maTnZICX4z08bNGBmmIfsrt+ptsCTSukoT7pf9iws3WhE+?=
 =?us-ascii?Q?R8KTa98J4qPezfrCqvHFoEJB9x7EhFkQHvdetRlOjWvyScFBIaxYp4s3T3Ha?=
 =?us-ascii?Q?ExxTCz77mpi40kWecypKJBmHEC0t/S4d4Tjbrqpuhne3GK54En5OnlMJVZpb?=
 =?us-ascii?Q?2qp1xkvvkV75ikBpSGVBwhpXODdEKqu4Y0LyQ95AVoBXZhf74H8NrCcFAe+Y?=
 =?us-ascii?Q?jkw0lXhhAnuaCJuBdipkItbHgYnGBzAIQyS1aec20xbwsuX8/SPLJQiG3WeP?=
 =?us-ascii?Q?UZzAggUPfadJArQUbpVZf6/gaUnk/pBck6NlxyDk5zmedAvHPTrIDcHxdTYA?=
 =?us-ascii?Q?MgWxWrgSxdIl21Ia9C/AlzWwWzNEvEy22TOjyKM3iJz1pD5vux/bCySLyAIy?=
 =?us-ascii?Q?o9abe3gQ0uKTTusH5hqK9p700f/nRWSI49aAbATXV9qnVb3hIV+7xiJotNe4?=
 =?us-ascii?Q?deXf7U8bvuntOltLzpXWFFU6Sqo0G1U8M6ysj/aqCULxy4XpNVvVujlV69jl?=
 =?us-ascii?Q?zD7+1V9woZ4hmXvkYQMdm9Wvc0ewBbxoWtdzq8Ieou5Qykjh0L8ZzNlTxeUl?=
 =?us-ascii?Q?hudCkB83Xq2+KIANCyY+XkJii6SyxOPYFl6yvWqfLvzn1N2N8gHaUoBnHmoQ?=
 =?us-ascii?Q?ReuZr3F0HDMQa+B6BWFs5P6gQ9/vtbWxoetp6Ldh4TjC8YvukqkwlqPofrM2?=
 =?us-ascii?Q?AOekilhgA7Td4svduSZKyUBxPctrSZem8kbdsLaIbIopGfNcbAk3pRn5J15Z?=
 =?us-ascii?Q?51YHG4+b/azbMXiorW9BFv9499AMYSgd4RG6M75uOy/nYFU80JodN/i0Q9WM?=
 =?us-ascii?Q?H2/BGB1SsM9yAnAqUJVdij1t8R9LjID6tRYKUw9fhbkA6DZC6zPjTt2x/XHl?=
 =?us-ascii?Q?XdE1f/GSkUy1YNl7TpSikAb0KUojwmyLsjetz0SWfBEEVYO+6FyRTDwZK4Wp?=
 =?us-ascii?Q?ApDQQKYWHXuA46v7WTShwdmVWl/+OrCa3J7kPIuda1FTv4qadJWoZDyLOIhj?=
 =?us-ascii?Q?YduNSrbPveK7Na/KwmW/IFGfYu5q4on2rnZN4OVvgjFqBbzOEYxY4GXwBJy+?=
 =?us-ascii?Q?Ce8JT1cyIsX3ff4sbmB/G2CUFRduteedKlGaAElRyHQ5vdEvffiC4K6aceus?=
 =?us-ascii?Q?XURXuG39xe3utxrY+RUrWJykB/T2VaTuUDm1CbKBCxBFeIcfEO0kktkMHEdQ?=
 =?us-ascii?Q?waCKVwlINmyrzoaQ2l9MWrH1oU/GRLICidRh4hznbV65e14odPaOS/nHSlNx?=
 =?us-ascii?Q?dhm6Yk9uLZds//9/EbLz6zweNtUUCIyfDSkx3cM1/HWCLmSzGzo0X6NuUAB1?=
 =?us-ascii?Q?5H22pOK9YtKTz4K89HxbcmpDxcw3WA3BcjOXyl2FpAPy2bPoVH7lT0b8Lm9R?=
 =?us-ascii?Q?K8lxcyCnjn/NExNLnLDajpxIyKqY2QKeXLb6vRaNrNuzcXHJRrJRKoizauTI?=
 =?us-ascii?Q?SySZJQEyKNfiytpiKWWMl7Idet7oS9HDQqKGXBjvOyTMFnp710OYz2lUxyS0?=
 =?us-ascii?Q?ww=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79e6ef2-9ed1-46ec-e369-08db2047d8ea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:55.8827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Be4z1qQqGQtLXO59Yk4O1OTFq7LhELnErZJsXWCDr6Y3Yn21hh2OK5dXGYN9CXQ4tCVI9GMSfePMd4GxmkIfUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
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
index f6a020c..127d5b7 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -376,34 +376,6 @@ void __init hv_vtom_init(void)
 
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
-	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, pgprot_decrypted(PAGE_KERNEL));
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
index 52a6f89..6d40b6c 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -311,14 +311,3 @@ u64 __weak hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_s
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
index da737d9..82e9796 100644
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
@@ -1844,12 +1806,6 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
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
index 90d7f68..afcd9ae 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -271,8 +271,6 @@ static inline int cpumask_to_vpset_noself(struct hv_vpset *vpset,
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

