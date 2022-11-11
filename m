Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA416253B4
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiKKGYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbiKKGXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:23:02 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022025.outbound.protection.outlook.com [52.101.53.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E0F72994;
        Thu, 10 Nov 2022 22:22:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUnmqIFpsX5KAi2rMoVlR5Xx/AguMoBLwU6gL6y24pUcuOhDkkmH4l/vn9ZAOjpzu2+RNbQfiGEAdi/1XTSjVZ6euXcE8o0JtyaTYc3NLsN1OXiOP80ruW34CM7hdmv2Q3/5Uu9PaU6fPKzNfNDne3kaP17l+YbgRMj43r4azqoXazV0om8psvSMoapA1RXewxqYxvb++u6LOfbetW725WSOGlHTBcUE6+aJ/Bwq3iAiPJwi47olGrmY7mWyEzCxGXwxAFff/+mxFpBI+L7+z7Yd+3X+PBIuQcWJQQcmofyBjR4zCq9c0/DUWBwyG9dRBerqy6UWKxMB9SelCXj5sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMQFfu0nvpSqyQBcQ+B8fVzRzFcxDk9HPFep8luloWg=;
 b=A/0rVR64E1B94/e048pKR5UQBQi490tvUPjyxKUUukpF7fHNMcFraTzAXU9FE/pa/MC7NwVzNl7Amc0GYGHgX6xP0eUaSPlzvBKW9XMTKaPznnn081LIZAweufzvvKsmIFvnA1TANF51Sr4kFkUXUby3b8rK/l+FJ5figJ27zd5oWpoDQ7RViBh9qWfMDlDz87TsYyAfE2EzYOrfuYMciuemNB8r8nWEh/fIsL18muosyzCfH14SfYhJVS4Z13ecW9V0KAzH+xMltsoMTXYY96Ix2+NNegKfGAQ8A+kq5wybtw34fY8lO+1tfL3wTGZGIafbey0db65PUuA4kCXgGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMQFfu0nvpSqyQBcQ+B8fVzRzFcxDk9HPFep8luloWg=;
 b=Y9bLG2rO+iTW/NzWpab7xp30zCvAexdry+HXcHXcKAYHoEAeuuxgFcpzme8mlzwJMtsAifTX7Sq/9Hmj01WkvPZArZxZfs/+l4YeKkwBi0PLtl3tJl4ewsJnn/WRyCybWBootrG3SyaTU76sh158RPfnI6XGxjCAtycwmhJjpbI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:29 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:29 +0000
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
Subject: [PATCH v2 09/12] hv_netvsc: Remove second mapping of send and recv buffers
Date:   Thu, 10 Nov 2022 22:21:38 -0800
Message-Id: <1668147701-4583-10-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0329.namprd04.prod.outlook.com
 (2603:10b6:303:82::34) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: 88677587-5b72-4c7c-dc46-08dac3ad1bfb
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52CwX+g8Ha/tRtICwUybCcszZWh07zfMU0FIuf7eu8mg6M2IIHy0U4A4NDkv9nvZ3zn/42lyIsTmplmeqARieiK0I2YcFceJXVVtoh9qRQE84Z/QuMsrMTrTNDS7vL3A+Whxa59WgIX0BjRhHa+lbaqsgzfQ277C/ob6cBQRgkHN6rBYAb7xpw4N+pA67AjGEtWOE782vfTt8WzQ2KlaPaG43KWfToqmz3em+TzHcdTzuizM2hqU/AOKEdDesGrXryLJ0WJdY9S5shWxyHEVpqIg8cTKrgSuSPYIHKSs82ACGQV7m5Ssu8dHXYWP6LX7yrhf0EM0CUuPCQcZeqh8z61Z2yAzISqkeUlHs5S5qq1SNCPf/eWYzAD6Wu49OKoQyktvuJ8uSTWiYGgncrCcMFya3rVwIqx5roFNg0t0/0zB6D+FVTroDs/vWBBfiU6E33zXW60efnStibbWCr2Ox60EO8wudMmVb+g0aFwfp5qTXVSDGmf9lqMil65agXY0NRM38s8bDQs+hj9mMLRaGRGw0OaNhUiIb5089cRyowDQ5NerSGIpKRIirxY6gxQo3k7LIslyUJq/FGvAdTaisUkzb14GkxIbOM+glqRMZDjYfRtaTJCL4lFZOW28ckRcaQG2iloYYh+aA0xps7g6FBuDpFozZQsqYE5uyoGgqb+i+TKNcZ9JkhA3r0ACDGgATxgT8MM3FxrhcOa4S8W17ofI8aA82miYqvJSkuzGzJoOHhXiBRXhamGa0vJ+h6WBLhSAfb5MLw/QW4A2waNxwLzr47ixvlIKV75LpjW7cKSVbT3Wi4XXLohbQdBuF0uPUd2/im8vJ9ThzzzsdMyMww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HFG58Wq3IHaHq47uK+C2Dbnz447vUsZVPpjBWqyRkT6Jzqh862PV5/HJaI6k?=
 =?us-ascii?Q?FJq2l9HGxhmZdAnvfCzaqRI5e0Rgl0dbCNzUQ4Ja8cUddSnsXaksxYvidwKc?=
 =?us-ascii?Q?6imqzylQ25vr/ElNIEHvH7htldCaRNmjCC1Cr1KdkzORgOQiwt6nnK4ExOwZ?=
 =?us-ascii?Q?FZXwkLAOL65R9Eq3a3qxfJLGXnHV4R6CbRvI3xtLZCt4kilmcOSTCy05Cw1D?=
 =?us-ascii?Q?PLat/WRNm1/RubIcWXcBxwnMu7p0jR+v3HMEQzw0z7hTy8kvsXdYkKG9xLgA?=
 =?us-ascii?Q?PRQOAYzkrmLFFNsLoF3/Qs9cFH7fDgL86so/jtknWC2hRQUtsTS3igX/sMRI?=
 =?us-ascii?Q?2+9uTblNWzny6BiB05qlRRTr716XiV1pxQRON9WYx44vJ8uibn4EbXzequCP?=
 =?us-ascii?Q?T2mkHEetTOCo1dkiqt1dbXXYSRohIW53IN2qDLM6QL4YLJsAwvoQw50zUKZd?=
 =?us-ascii?Q?g87DVQMZDI5ZlbnA15AvT9DaniA6M1fessopg0AyF8CBe+CIYQ7kxnF2QwvN?=
 =?us-ascii?Q?JZpzF1j/0W94S3WxjiHkDhfjnnpyoVu+ViljwITGpDOzyACa/wi0iDUPc+2d?=
 =?us-ascii?Q?FBjxKHZ06u4Hs3dOGqdH+mihJ4xxWXD+LYczMPzhIHiBoqpWYXLuPZNTKD9w?=
 =?us-ascii?Q?LCw3JrYv3CxZcAcAmA/WCkZ+WvcyR+PdbHFClL4sJqgMNx2aau9P1we9uGe4?=
 =?us-ascii?Q?Y11h8tf7K+49NIOHLFYBxW2P7zflAvaUjP4idldVLv9VeeBX1zlzZ4SEegpZ?=
 =?us-ascii?Q?jUh7wWQQln/OzFXCQYfme5aFiTVDUqMydzPH0YLj7hhRfXvAkq8wQevvF0Hm?=
 =?us-ascii?Q?F6RrtWnYBgmnHcJ8ETVN4gEXv9aWcfj4tTaVnQGba8Gu50zFAIHp/1Pc0A1D?=
 =?us-ascii?Q?ZihjJThjWyW0gi0TJxdASNdavSee2VNnScOEnFnUosvLLe2hO1QITHORDWBm?=
 =?us-ascii?Q?fU1Bz86z1BtHmliz5ZnhRsaz3ryGqdK2qSKwqhQM+BDsi2U9C2I5ygb7X3o5?=
 =?us-ascii?Q?g5m3PMnPUO4rQixi5yCC5LGsFF8Mb45ZLYYGKp6Flk4IBSmjfLVuUZPxBCis?=
 =?us-ascii?Q?v/RE4cOW1KF2OlyL7Zj717Khc/XL6pmmyGC0rh2ERVD0TBpRV5vJDSjjNNG5?=
 =?us-ascii?Q?yNPr4injySwUI6/wZzKfS8y153oBxNOIz4sWitGVGn92KUtpMDh3Mnc5ic8k?=
 =?us-ascii?Q?HpicXNh7eGKnwvnsb7/nE/sXCq25F82Z+MxjHqwSm0bWxbXONBpyBCyBIoYL?=
 =?us-ascii?Q?dUWZ55hkn4/ipAyoXKuOaPhBK4XXCKwgFvP6PyOHfE37xkYeD0A79jz+gxUZ?=
 =?us-ascii?Q?4dbPUDlxS7Brdxaab4xLrNmiGx1oTm3SapvvDdB8AWKPAKsegaBjZLoZBPdq?=
 =?us-ascii?Q?zifDA/gChJfYQpM3etH96k5uHOUOBPhsG5d+a3AS1E5ISDi4PsuBisNj4aLq?=
 =?us-ascii?Q?OV1P8rTKukcs5bjyVFJRyeVn/TkY8q3/C/CODnT+rmcAxEuBdPBlozVN6eOY?=
 =?us-ascii?Q?kSiSNYy7/M6ItvT1hKV4jQQz9iohLf8oQ2R2vlbpa6cwClaM6xJKDHWHsO8t?=
 =?us-ascii?Q?sPncqWhA8bUbkeZGQkT+gV2s9kdduP+NNYM56NrpW/XLMLBF4q2HiG3HN1F4?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88677587-5b72-4c7c-dc46-08dac3ad1bfb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:29.4626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WINj/yIlO3K1Ev/sdCDJoTt2QDP5U4rmFywgoWemoOgGMrgrARMIZy+hFsIaeMcsJmfvVdI5ahhCMfi6mYGG6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
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

