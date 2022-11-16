Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2F362C803
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbiKPSpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239341AbiKPSoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:44:20 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022016.outbound.protection.outlook.com [40.93.200.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAA661761;
        Wed, 16 Nov 2022 10:43:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksp55Zd/lyk5iaj4B2+gcnJE+IVfC2zu740VKGoIRvHvxUkfqFo1wqC4jGt1lV1eVOzE1nqJ/m9Hfqjt7dDoqShzbhye7w0YGUPAbL7T/SoG2aXS07xCG4geeqJUxROOno2lV15jcsTC7XS07jR5iTgoDJivEU/a+SMykEAzzEfqcxOCuzPsmXfiNwCjPu7OXZNncy+rEukt1wCwKgUI2EIP8wcOVoqufEvtCKr6Uf+cJwiE8XMvy6HrEJpxkG7aIOF9C4hImof++u73iTe7XoKiU9zGYp9SZ9ggfkUDtkGndyO7Ggq+ZKoSEUPxwlURxfqGZqZS0DH8uSRzyymZ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMQFfu0nvpSqyQBcQ+B8fVzRzFcxDk9HPFep8luloWg=;
 b=P9hpARPVciqlFK3pxkWnMNg76acFidG1FjVZZBiZpwWQTOulK2QR9HMQORxqx1I3qLsYM4SiLqL1p7FqMnK7O0+3E7ZZqVjGC3y8Tg/pUgHWfDTph+/0JA4sk+jmLsK2+UUUTm6y9u3BU6MNrF2yQR7DTi3UzR/YwtuOxKqbnN1og4d5P3QNMOcD+4ikNom0JAPJpcpMF2t+FkUgoRduxoeCphXCU6QBNjGTExWq4sw9Nf3XosFCHV3q1DyrpdPfzBAvk24lWraggoqliBMeloRcxHebUNKtsna88Yo6OC2gHUyr5TksIx+gMx2ZxI6JGP3OSbpS9V+A8wEa/pOXqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMQFfu0nvpSqyQBcQ+B8fVzRzFcxDk9HPFep8luloWg=;
 b=L7s5NjQ0IiGkxbXkgEGfNG6tc2Ste1dIznwKWQXXoCqYKYHQzjkbl83dpoRup//cyMxSO4qy04ntUrkRNT+/DwG+aeIvDBRYN55vCeOD3Jlm1PE88qSQkWEnnaJVu5lmopLE/cFeuPZEhYPL9OCrJLMM6FXqfY7+tvgHG4EJeUI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:46 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:46 +0000
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
Subject: [Patch v3 11/14] hv_netvsc: Remove second mapping of send and recv buffers
Date:   Wed, 16 Nov 2022 10:41:34 -0800
Message-Id: <1668624097-14884-12-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0178.namprd03.prod.outlook.com
 (2603:10b6:303:8d::33) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|DM4PR21MB3130:EE_
X-MS-Office365-Filtering-Correlation-Id: d358eca2-6833-400d-6f50-08dac8025ac7
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pa6hYN7rNMJnRjCNa3J2lBo3EkfKSjLOCPiYmKvn/visDITeqQjLNcsrYTWq1aiQchx1XR5WdJPBugXzcSkImuT/VLJlobm4x9yRmQYzLjNviNB0pT3/RAR4gBQAfvTxeWy992tFcrnKx4xOO/P0lq5xYTKeOR2UYpo6EsTut3xMqPkb2yE79iZxatqTrVS0B1kP153qm8LUsHTq0ngK7fzGOJBXmuysxKIiA3mIVzq/bweChVcLY7V0bJ3j2jvwP5JwmfFlxNXRAMWyVa3GtVuIkLAcqPCv0gvBjCOlziuexbgg2lY0Y/cj4FKWNr1roIG36SIkZNlgZByTEknCBEmH2qc+E5Akhs5ogWA9jZ99BqMyE+6OQ+hKORZxvXWVXGobZBe3+kbDgeXVabhAP2j25pP8vqUlOrZvm1rq4MfFLzOyrhMhDsWDg7CNHOw6EqcJfHrEC+Yi2HG6gCi+6Fxr4P+uQLso6hfGssIT1f/xDKvC2ozzhOCohd6wHmTko7jVZlfE941C4X+7Ts29/Tiy7YbHC0ltpDffv3BOm849F+TNoaY9hidUgAxfINochcwWbd7GHGrqN/gdrY0rXy4LnWcgAGsDyu+ajvoyirCwxE9icJHUG4uymIy9QGHPqUGsj0N+um/L4i18wXY0X7FXraiUErVoh8ys+1g3qsRgX1fA+whFrBVbFyaBJiFqNpPaed5Xgwau6x2hPDkZHR0qHFjFligPqJir3z0IMiy7nVM9djw8FXnujZk0NzZo6WvhAK6BaEc7RDF8lpwF5aNbmgOeoZicbbuRSl6NRh08Gv1D5vBkeKIlx1cMi4BgCyB6R+XJeCWZ6efR6LbQMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(6666004)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yc4CwSYcgP60Vgk904adBOXJfSTQh7VMPge5almqZI233vy+VAb8Qf7MyQV9?=
 =?us-ascii?Q?285rpSCnWCUzv5tzfksZ7ffv+8HhsJrejujNe52eejxuqExd79xwBHimFnyr?=
 =?us-ascii?Q?Hu3lOvupazM1HKC0moE2XRkx0aqr5/VJASBZ2fGmwUVakBzIZJEPSji+d9DL?=
 =?us-ascii?Q?QyKsEfZtWBIO7I5mJmJAOSv/kBiskKELzdv7x7TyHvFhveTwQ+2PCl/orN7J?=
 =?us-ascii?Q?Q9sP54UH4jdY+oOIvkA9nx/mEV2/dVrGCV4b/+HUVuoTnnJT1Qgrc6nq2s6i?=
 =?us-ascii?Q?QOv4yWx93YllHLv2PVriQWVqvhoRX6Cj/yp1dzihAjzS/qhdWAmABTXDwyAO?=
 =?us-ascii?Q?FxRtl/YYbW497kyzRdk9TUA+yRXZNqQrN0K+6KX0wdpgo3DsDUS/qDh8XY8m?=
 =?us-ascii?Q?CoZY52D9YN+HQIWJVQKI8fZgTD1Lsr5tsGjwHMOqV4HdlMVCWAYu8fvvYxH/?=
 =?us-ascii?Q?u0SDOHTsQSzQRhB9yrMcT5DJt/zpAm57A5pScv3iwl43vid6AHUfEk0IuYx4?=
 =?us-ascii?Q?3oXaekhqWiUQmq47WlZpiyIQ6Q6+0ohSX2TW1+Yxers7ivLJxSfLWucg7c3N?=
 =?us-ascii?Q?/9fSMB2aBKqUhcWYtO8iYtKQ11WnmKvjjs4WqBUX64iKHJlcwukf85V0Rs6H?=
 =?us-ascii?Q?ukjkHf799Em9HK7D9+3LX+Wi+32N4O/ydHFJr0NXxCJFIx9KW7KKXPRgj+dz?=
 =?us-ascii?Q?NawKnhXA1JxB0yBLWug9rLvIGOPCpzHQfQZc3d9uT9CUeFR0Cy+7t+JnMkOo?=
 =?us-ascii?Q?lkeT7rcvJ58eF6jYlj9/hmE20rfHvvEzMBiTSiK3MbEKjOOHnrel+1EP86lx?=
 =?us-ascii?Q?26pa/x8vE6oDGp5Oq0bFUgHlej2Mh5gRJhdFejvV3whuRgwzGUYceT9u1Dg7?=
 =?us-ascii?Q?NLB3IVPvmRPlZMkP/yxaxvdf3xqCPg+FXZHA3O2ftx3WoLw2F879VFCOCO3X?=
 =?us-ascii?Q?pNLGbxi6XxvteXXwXJ4MgTYgkGYqEzVg9dIl0u2dsk/7f1rQ9WCBTNDUVmuG?=
 =?us-ascii?Q?TjSoeaNu878d/c30w4NHOEA264HuDfnrKM3P5jKydEjgCSYpGNNUFjLGJNqd?=
 =?us-ascii?Q?FREQy/Q0Mvvl4uAuyZRXgDIvz6x9UWs7q+myDl7XNVH6E3I01GxrlCvOzFxK?=
 =?us-ascii?Q?kyqge6EGH8aLUlySs7+W+WdVuZSHuFSlsLv1CagaDlmqrdIPj4K2/HsDDO5R?=
 =?us-ascii?Q?m+KoTOhT9QjJhW+z+yU/FaOg2WRB+CRtCi0XcyqBzAp/oUEnx9I6JEC71KIZ?=
 =?us-ascii?Q?v8AjpcS+8oMDvVSNc0iePw/yNaFWt/2UeFj5e6K3mBOQdMdQKHaM8IcLzjgF?=
 =?us-ascii?Q?STIz+VLywB/VwNDuAdAdv5QiQjZGjKNeSRw+eN9l76nGKl0VKgWGI2DBChgx?=
 =?us-ascii?Q?Q/0v0ygyrPI/ATbgJu3tFSIXWSKWxQTebhpexyEQpdRYRrCJOR7MTy1REApK?=
 =?us-ascii?Q?KQ8cUxLcRUaZHLWpy7TuSthKkP56FPkKWlAzfmhhlmSk3IMi5Gq/2fwvWUqH?=
 =?us-ascii?Q?7Fi4J+FzwQQ3m0f3XYuojNyCECRWNYybqA26o38xPAg5FeMqHfJxcINsL/6A?=
 =?us-ascii?Q?szdorAFTXxJmhlG+L6ExjMCiqpQvLLA9Py5GzPXd?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d358eca2-6833-400d-6f50-08dac8025ac7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:46.6742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Du+VJp1q6TC+mZc2luLhBGBwsLXgZ2lvUVaExRId1EWlAeFwjzxfvYMFiw/SmqjRRJCdC0erdBk+h9I5INwYLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3130
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
index 29ccbe8..5e4b8b0 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -349,34 +349,6 @@ void __init hv_vtom_init(void)
 
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

