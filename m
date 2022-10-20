Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F49B60679C
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiJTSAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiJTSAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:00:01 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022019.outbound.protection.outlook.com [40.93.200.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254D11E8B9F;
        Thu, 20 Oct 2022 10:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BoETlBi5fl8IcCFM4IBgGbYoqJT8OvjdpKCoXa+bU0QlMkUzZNPJ5ISSkk7QZtwooZ6Z1ViRyc/dd+k1IulP3BUtjoWuTUmU+6+nxS2lIdIdJh9X3iiFlw8JKPKOmrHZ/zPJspSRJdt8yFK+iD5IjSX/g9OwA8RlZMrlTnzPO2PAA2ztlGVfac6sLNFwGKhfxy2hYSUJzFBMtdI4p9DjVD5gQdBSecdpoQNZmweSfkesbdkPazKehm073WseRMsnkvU9ZpcTRW8WASC4W2GRXUxssJn+qhT3p6AyFzpzZ3WnLOJq/QSsqKDhH9mnVz/wjQ7Wqb+bPVPY1JlaIl01uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDmLvoG9/pzHasbTbozbfs5gxQVzVwO1XjrgSlWkuMo=;
 b=Ht3RkviirN6as9T+ylDfOzFMIOzkJOHaSB3jBFzFspojMZpM5EJ3og1EGdfomJSEjc606vfqi+Yh51TxpiYPGImyAZ2vKAngvMfYqnXNLuooyfP4Tm/3Lj2I2GrIiCMr18BbT2+WDWqd+H7A7N/Fut5VVm3DR81MqeH14d7V1KPUniaefefvfGpDtBeUzvTUEpF1GBJGB53evsVc9ZHgJSRCJF1HGTotMXNMHpKmO4zq8hMMuWjjbAE+z8v/uq76Q3xzcIDRlVDbqRuslfrSSCftebFnhV/WqGqPiwvn3bLd2sHiKzgZ80l4444n1Y5t47TKtlFRwCBSP/jYZIGZDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDmLvoG9/pzHasbTbozbfs5gxQVzVwO1XjrgSlWkuMo=;
 b=hdYJaYIiC0NLiV1bkYI7yBsM4zO2AKrxyOZe4lHKczGE6g5q2lba+qcYrQo+xmbzcIRcdincmMvgAW8K8JZ2d45BCRrmZYIIimxukpCPJI9Rg8jy+p7t4pkgCXQwCwjKokRA9qmIfE8nQI9WGHxpOtKmTB5gY4s+u5TbwqQ4IxM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:41 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:41 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lpieralisi@kernel.org, robh@kernel.org, kw@linux.com,
        bhelgaas@google.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: [PATCH 09/12] hv_netvsc: Remove second mapping of send and recv buffers
Date:   Thu, 20 Oct 2022 10:57:12 -0700
Message-Id: <1666288635-72591-10-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:303:16d::31) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: 87f79f14-e92e-4ba9-c11e-08dab2c4b910
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ia+yDtN9GpHQdMKo+1zhe6riBfKQfXKvoZj30tWrVe4go2Skz/umj5HHa0E/ULHbp1FeTLsa+dKNau8WZQdd2WUmPbcMjDllH8auDjGB0logMPSr9BBaz5QVyF/A2L601hBQeuMAem0skmhaS7ljRDNB+pHINPbePQOOjYOoZB0V0OWGZnwSqHUbUPy5uZuma/ZprRVDwwdepKaecXuhxSPtGW+ZHzbxGHSXGZEvRPi2aDIViEnPW1iGblOG1UHtmU8UMt63gWm/7CYL0OekHmF10PAi8tamM27x7BpIwEDFgBxpT8TVuBf60e+UvxIK/RQGTJWokX7O4FWfW5l5rEkGgHBbqdywbQ6OE7lVeBHNok1CTYG6p8nJqdc6Eauzb4vmZlD2h82cXMorO7BA+iX9xIySjdUCNyOLQXt5lGV2oPqX7Vzz5+Jz17ictM772DpGB5nCl6zx7jrKf/2geT6CmRJcMtucKG62H3QkY3oaVL6lJ+Nr9dVtJ3axMuDXeeADybMtOk5SD9yKcv7crtuct+/a2L8o+W6PKzf7EqBsDoG+lTxBW3DEW3r8jKIr0/gTOYLYT06fhc6bT4LIfvHwNWLFZpjZVQqNR1ju82fWULp6k3NvDRQ82LT9+p4FhU8EhsgF8uMRlSNw/ecfwPugJM6rVhZOGlSg2EFGDcHyq1AzVa7y3WPYwnZs0iE+OV6NoJ6ajPqWvYEyk2iXzCxTkLq2Qv/RzfY3xrx2rfF2vW2z5hmt1FJFkdoT5S5Sv1OeWPa6aS0JKQTbHQqGM3EllOyoePAESYliTwCrbQ7ztfm2L4cVyad9BHfi8ygJ9EfAGjexknpnYhbejpCGkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6YJT2LfGjvq2BKnJg1sMzUFzJ1UG1DDZfX4pJ+oSwqRSIriZaw9PNJGIxQdD?=
 =?us-ascii?Q?H8dv8NpvW3+qdkPvaAMnELLny8zezzwSCdQWTa+loH8FU/J7vSlVqvPbDHhH?=
 =?us-ascii?Q?c9s7lMQGTqYRfPISg+DWPIG3pssAyP+4Hay7hfc/x/B8QNTfdTCYUORfa23z?=
 =?us-ascii?Q?QF1cgkrDCBT14aalR2UusQ0jeRjpVuIPU46KEUrYgwrhY4yVWYuUqFLvx45e?=
 =?us-ascii?Q?fLy1iyq2dqXSuSk0DCQJTppgUFKv5CfaMwtPqZ30heL4GFt6LsY+9eD+6Cqa?=
 =?us-ascii?Q?yCp7SB/GPZM3uvyuTGnADL6kChiRd+k4TAt4143vfMVIP1FcNdMcgLfMypli?=
 =?us-ascii?Q?5kd0dEk3QafTWCsEkffwy6CO0tssJ9Pf++1/+O3O7v+Wal6zXQzVy/yYXbAr?=
 =?us-ascii?Q?VMNwXz5X2vJYWt2PXxnmfiEAQ0v2Smt2ckoPOllznP7EUqITDdqiSl74Slhn?=
 =?us-ascii?Q?wqFCWp8hPqPnOZ04ENwtOQRi4PFFd/65w4TC1NhVeL5//cR1R2Ri0dDi87aM?=
 =?us-ascii?Q?wS35484nFGglykBBN4f0oEqoJ/+G2QU4XWM+wlsHbqtAyhjcpRs/YwCP9NYR?=
 =?us-ascii?Q?tTJ37lHumFwpWPSZ9CAsEGRKHt6QDlKwcqdF4XrzGR4dphiDNEzrsZwaB3Fg?=
 =?us-ascii?Q?GVsmYp6sn8rhb1HDGCkXO3jag8vbXjm907h9H2/UbJckelPTcrp03gJGuCA0?=
 =?us-ascii?Q?NUyfdMdXbMNYCTnEtpJm0W1MsW+VRaiPsaZJkwzZDSJRdDp7VGZH4YLMgHSa?=
 =?us-ascii?Q?9L0413XvmDGirSLQQDNH8HtVBOWusagBifYLYKcDodTn+j8xVsj+nNv8xaqe?=
 =?us-ascii?Q?b3TZa6+Ot6Fnsnlrp/6xNz+tNezEEARyRhNjzeLhIjU5NiSK70dKsKzr3V8d?=
 =?us-ascii?Q?W8k2YJpGPgavRSMnUAYR02Mk1SgB7V3BrJNttLnQz+Cx0CNdz7IccSRjpZrO?=
 =?us-ascii?Q?gunZKGTzySDR2B0qlIIL7XC77wnyW0WgGcnbJ9vO9GIz7IsSdxkPmIJ2iEOn?=
 =?us-ascii?Q?qaoSCOtkxlC8GduH4Z/hPddCO0KS6SO/ZgxI2XAp+oWpSFyDAXUrWoGSeTjL?=
 =?us-ascii?Q?pOG9zUBeVFhi+uIPtm+NjJSvDnpK+Aap8ayYSMGXYfVWMPRPl790RPvvVfmx?=
 =?us-ascii?Q?15Tlrxmz9ddIFf6qZBoT8bzVj19ctES0KEitqwg0j6ciI+hbyhsES24ZT9+X?=
 =?us-ascii?Q?KLDcO4JgTuLgM2TPZn20AZIlwSXdT/FLBSU/Hwd58fql4XVhluoKjjWYS3ss?=
 =?us-ascii?Q?OGm7zXBuy3LGZl3XXt9X55TdNoKHcCtqZj8DxNIq5Kul6AuuOdDcEvTEfVDs?=
 =?us-ascii?Q?qouUjeKTJI7YdFgwJFU/IiEWdNXOjtgAP5R7ao7Fe7vLgqst64bVE5DMPviD?=
 =?us-ascii?Q?zs5ThGL81tZjwPwJSfUHLxQHkWBE3sV7aoppN+Scwq5xhnFKNtRmoXT9LBFg?=
 =?us-ascii?Q?ABRYVYXOohL81Fnplyc5v6nX65wHzjlRzZIoPoxGxq/OM4hJDd+olMRLtXPh?=
 =?us-ascii?Q?Rw2SWCdjKGYznhChx6dtAftKxa+Td0Bqzs+au3TWObzCoOENePKAPLHUF8fc?=
 =?us-ascii?Q?4IJllJfRhBOiAXhJ34zvSejOGjRmCGkN7kYY4bw3?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f79f14-e92e-4ba9-c11e-08dab2c4b910
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:41.6750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G1aiVKKsJZhQvikX6CQaw6GDZHA9mTp1pwqkdftAiV0aUkcNYy6S6cHinxiSec8M37cJ/V/tyfDkrU2ChNDXtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

