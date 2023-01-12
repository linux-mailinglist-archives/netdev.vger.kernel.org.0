Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED6E668619
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbjALVu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241031AbjALVsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:45 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021022.outbound.protection.outlook.com [52.101.62.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46C0102F;
        Thu, 12 Jan 2023 13:43:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3gk+5yjkCjMJYc6PMiiFrscMEsLPI2cJwTgasS1nY5AcDwqE5bZsk/zPHp5O6b0C/+SJtUpe8WwFzue+r5Iwap3619ahbaUQpmGAV89EOlNq+fdbjOKp3KB+iu5guNpbO6rmEPGFw3lGBESOEDUGpnkM7vWNpErCtkAQnxYr4HKa3kmeyCrpUhlmV3eUcwk0U47qNJTZtsA+gZCTwPuEsNOni8oBB/OrB12ryIimQt7kgBNeojrlHZPn5vQ+LLhSBcj3FFJ25GIV8nSKLDw5LkWfvAVXZHMSKV3o3yiAWfmupN/uga3x2e5Xixrjw+OsDDEbIOBuugxyOwnMWioug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8AC5ueMAiKSznjSDey6+7dYYNI7rIlOVJ4+gAvAByy0=;
 b=IkqduCCfB35Zt02PXW8hHrYbCbwkXxDMzueE81SQHuJtlfk/+NdeMYxkHYzGKP4OPGP4FMK/267lxzEFwQUnX94h7lXaptE95UFMMFeCXoEtYBXEtmHGkotUCB+1+9Swoyvhl2Q0z0k3gRrzf4lCatTzQhj20JNl0sTRlIAjA2G9hlKps9c34eY7ep96JqxYkKLDnmopKWlSswKnmnqh+vmb7Y6EWZtybHqOTZ6T7NSQUq2JzUsK5f+tNbpPxeihKbJmaRVYDQN4WOuCDnnNt4iWqdp+lFpNPcKbEFjcM3aiLmTSxQYqdqq8lZ0l/9yMvp156zsI3//bLD0kXSWWuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AC5ueMAiKSznjSDey6+7dYYNI7rIlOVJ4+gAvAByy0=;
 b=YgiOetx4hr7fQS3P3R9A0Y3xVoq+aKEap5oizbKrZ2qmjSl7Th7SHQpP1h24uxJPhuG4Vv1UghuovGoLEu2JWb6ckdF9kTd1iuGsOxNYJfO+bLwpdvU4KEQ6cdkHlGxtO18/C59h0DnL+n4o6PT3vId6Xw/fJhifI9Qg9XHhRwg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:20 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:20 +0000
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
Subject: [PATCH v5 11/14] hv_netvsc: Remove second mapping of send and recv buffers
Date:   Thu, 12 Jan 2023 13:42:30 -0800
Message-Id: <1673559753-94403-12-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0057.namprd04.prod.outlook.com
 (2603:10b6:303:6a::32) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1953:EE_
X-MS-Office365-Filtering-Correlation-Id: f6ddc3c8-8c3c-4941-48f9-08daf4e60567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QmrV5w0ZaL4kzXVLmUAgD4YsC+XoF7oNFnj+v0x6dEacUORhjtCkMW6Ld/2BCNCcA0vvLwdEWkltsR//0u5g/YIn4Ol2tvHsrLiUq+jEr6veAHmTYippfxS6t2G3OsN1XsnWCvMDM3eS1zz9Md4NpWgFu8UvKnpsDDibCBUeVmz60Dnlu6QA3gAVEO++04xkf7vbHA1cEQ22odIWJVY7jCDGlbSOu1D20alynFGtqRetjeo/bB77L/AOoGMs0aj9W1El9VTz0dDyD5lXyAIPbT+2mubGTjKhNf4/dcyHnL/MIzGLxZtx5dazathoLo5+BdPNQ2oyIrp+1HWpmUngOc0wda1EswRBAuIHWDYL3MyUNZUxqGbkg5RHqxHLxKgjIPy9kiP9P6Dtet5SUxqw/h2TdXGGB/UOs2+7h2OYRYkhehdwqs/Y/UPOfr76wJX1cvwKTdT6UqdoZZf61BC/cWfTQIYPTUU8ve+06Uh8EItyvRhfzLG3Ipzwp0mdLZxjUy+mUniWQbhVfSmBiOOpD14GkuCiGk1jc8GGaiiaVusxz0b2KEHXdBijRnZ2yWm/YO/eMHSmecu96DlAspmgU5c9JvFQ5BXB57DfE7OMMj+/YcOBRkDslZ/ww4b48tQXRg/uAsP9KnmvfTPJZeEhBrQdT4VtTRyv/UdrZL+0GUOQ/pFclsmkAvODOfEs6IPgNvhgPyEugUACRMKKPB4fWfUm7MVOVbfmuOR2Jwd0axyTxhpFpfqAT3iL68otAXJLj17gasjTQ6vI0pbUzXvC/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q01jNtQbluQOUNVGyLerBTUt2Fu99cs/zDCWjuQe2LiWKuhnP4qVxmSNI9fM?=
 =?us-ascii?Q?QFEyUGN2J4MzIH+xtXizkHzaDLCA0RBVZPCppBLU8g90EUUSAUXkgWI88U3A?=
 =?us-ascii?Q?ay/v1yPkvb2yESblry7eeNsXRA+Pcln+0o/uj64SXeviiWj50SHuyZVWLIPE?=
 =?us-ascii?Q?y7EcBDp+ldsRVG9JSR6wBXkFRjzK2pa5sd2ev9iXdDWzpgzIbzODVE05+kjd?=
 =?us-ascii?Q?90glUo5cFxGSoMw2cL8l1LdDNO0PupACFQptW+i8DhkNtuDx1sEQr3VGcmxt?=
 =?us-ascii?Q?TznGVm9q541mgnBEJx6n/K1mb8dHzf1NKBPqu/eVG4k8tpo6hKI4O6JWvjpO?=
 =?us-ascii?Q?ylHaGE0SOUIUdS3NKcBrGtqOSuw0+lstm17doWgORrg54AtkRuW8N5NvjJUk?=
 =?us-ascii?Q?SEBAwXUhEGLEuV18dhsoq/+ox/sJoBRwmEX2DxUfG7oPng65/jCIAWdJiyM4?=
 =?us-ascii?Q?4qNVAfY+YtKXisbq/C7j4Q0kudq20Loj/8MPRJvT3GOO+2H7snDlY7B6rDIC?=
 =?us-ascii?Q?rdgC1Jkb2RPUiQIg56sAL6QrawZzIp4Sk4uazthHabTE9WzfzDXxfSoFlp5p?=
 =?us-ascii?Q?6Dva8B+2OtF+kkw6kSkQITaLoUIRujrrpdl1NOncxLEWi29ONX1T3qazBPq2?=
 =?us-ascii?Q?Ge/+oWXEdP4dzsAIo6TlMEazrjIX7zFP6FUJChYXEi/c1D0RsaKxD/kSxSbN?=
 =?us-ascii?Q?6xDk5WsiJfkKAuW1ogtXYkE+J4rpp+2U8HBQciy9rMdl+oLrIru3Fp/mLOfQ?=
 =?us-ascii?Q?WgxxbRj4pj9qb/t0ODHMwEJoq7P6xk5J0bk2RdVQ16sK8M7LELRBjiNuUZDV?=
 =?us-ascii?Q?yhSzwutcO0Rts7OIi5LCqcXe8+Uau1fsgUJFny27VP0+2LQ2AmzkCZgBf9BO?=
 =?us-ascii?Q?bP6jBw0uVI8AetFilS4OKOStVRtoHVdtZHxSeZTCa/rrESTWFGTCC02fvhOu?=
 =?us-ascii?Q?tJW3u3NLA4QZenrTzALwloXR3ltgzJ0cvJs7552NQy7/77gj+cNlowkcl86S?=
 =?us-ascii?Q?YShNxqUuMM3cf7StoT79HaGkF+EhWsgB0vsPFd98NLAgBXU/2NRUF7eacAdX?=
 =?us-ascii?Q?XRAf3znVYznc2FNRbY+rTT0ljTJSgZj6aVpXEk/GUUYn04HVigSbout9oyzq?=
 =?us-ascii?Q?z3k/AJHlbko7c8ESxMdWUAV5k92hr8d1lIpJ3MYw4DNlnmx6JhIOyafjXF4q?=
 =?us-ascii?Q?98hNRbIZ41zkGo+mrNo2eKU4QdjaCbAL7nzKD6b2cUVGIPYWik1JuP83+de5?=
 =?us-ascii?Q?bNN80NNVNoiPU74p/lNVvdvc4lXJmHguaADFo15l365bqOH6sfimVOY3h7no?=
 =?us-ascii?Q?8DoM47S6aVeF8cq00/wRIlfyhDPyJi3SY+pnyE+6G+lZ2BANUkUq6davl4OQ?=
 =?us-ascii?Q?CoaALXzEvyT3yYw+Wgnikj9CHpU9eM6duqoFiwNHu1L11Ad10qPo1rQ4wvma?=
 =?us-ascii?Q?QU0rzMhbGlR95qhZfMjunjOvLZeehcppDtE4QLwDm2PHuNT/+s5TL+b83jti?=
 =?us-ascii?Q?wSIPVXnYP73AH9IY+6oYC/MfUn/4925+g0gPEHsnwccN8QZWoIjJE283KGwC?=
 =?us-ascii?Q?Y12I/O4wBBgs098Vd/rdEu9J68Pw46k/EuEBtc/G?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ddc3c8-8c3c-4941-48f9-08daf4e60567
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:19.8375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pr795Klct8Y+DSsrXu65bgozxLXiDJgUulZsQOoonrDhAYEfTbadpL9OdJb9Fvx+aNNWp2aCFrsLeFbCYp9Sow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1953
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
index 43bc193..abca943 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -362,34 +362,6 @@ void __init hv_vtom_init(void)
 
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
index 2bb2234..f2c0856 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -270,8 +270,6 @@ static inline int cpumask_to_vpset_noself(struct hv_vpset *vpset,
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

