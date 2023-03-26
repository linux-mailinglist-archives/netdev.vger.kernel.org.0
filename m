Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B276C94D8
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjCZN4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjCZN41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:56:27 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021024.outbound.protection.outlook.com [52.101.62.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0857ABA;
        Sun, 26 Mar 2023 06:55:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRDb/w8LR+OYfn293u3vQijGuEf3uhOT+XCCEOdw2NNNORVgeuzJsahEPIl8HGN/Ij7/2uqAfdN7LpAFtI4l24Nd8qJgilQCfP+wVgoKs46hhfehsTFeE8zw/uhF0A9UYxTy0Be8dBU8u+MlZxxj5xfreERIj1zWKAJ2FxNKht+TlOGrclfwBKKgtZHGaCr0vqkvTxY+kXm044BHL8YDCk2ajr3geRdUuheS2tUigobK6Z64fW4cYMlKpA/rWtrvj+zB8IYxmTo+QpLa8GFpemTJ/hTQmDCSzIJ2pSPFLjXURu0188HI1iMJvBd/CqEDzrQ8tlo7aDPTc4SKpUaqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=btHCRwLeI1shgTOdpYSDuK5X6Vba/jr4GkHOzvHVEYc=;
 b=f36dVR+s92DEPTBGGZmKLHUcb4F+BXqjxpeAeVk14EHQnTee5UdHIPtBkTE5Qa0qwpr2dKShGFCi7fn2FkGOqdBwM29I/7GWW1pFX3jOaE/DRlWBwgPZboGmmvmu3OcbF/RI8foKkY6p6lMBDQWngTEX+AKwv8QqBxgU2RgtWDjb+5aN4DXVnJ4P9FY1VgaXfKhf5X28R0FBrQMIdTec8eIHUYkQsgRlXASjUlzMxA+kja+5+gALxxf0W8P4JG1jYPKWCyXgzLG4EdIaoWnBy4Vb4RMVUbCVTKm9AWBn5TBTwQtdvOLC3IKwonNvAz1jrtmXxI7gNbE82NrrjnSqHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btHCRwLeI1shgTOdpYSDuK5X6Vba/jr4GkHOzvHVEYc=;
 b=j17KpctZQPVPDcMJlFjHiPCV6Do0UsQQpxEYqrU6Rrxry++sLWbiPmzte7tNpVheRe8UrTqKz0NYjQauBrscEpK770aRZvC3zHanPwbqWuKnLOq8lmgF4YbwD+g/2qGrqfzPw+LBP6dJGtvvB5fDN5p6/zfZULgRJn97c2PUShI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB2001.namprd21.prod.outlook.com (2603:10b6:303:68::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.15; Sun, 26 Mar
 2023 13:53:28 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:28 +0000
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
Subject: [PATCH v7 10/12] hv_netvsc: Remove second mapping of send and recv buffers
Date:   Sun, 26 Mar 2023 06:52:05 -0700
Message-Id: <1679838727-87310-11-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1679838727-87310-1-git-send-email-mikelley@microsoft.com>
References: <1679838727-87310-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:303:8d::23) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB2001:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e7855a9-96a2-44b1-3858-08db2e0179fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c3rx3+MWVBEye6W7eIkZ25/2KiTegrgV7+DBkCVL9sBLRbgj+UQCyl1WHgU1u0bu4GsxwRCqS6+wFGqV8m+6DGIneDmHuc56bfuh4GXDE5nEYZBpPbv9NYsCr36OnEcuB82M5PqYVK3vXz6eikV8nlbhjaE+JqJspZRMK0m/PZ/F6XFl5iCKBMmTTB1LWUuqwN9v2a63haSOeGfu+DTFdqz3BPJBhaIcDaYZVbXwjQB0t03qqVPXfQAoGS5eNHR9mkDZb7PTmca9CZNxg3yPWzPYaEzyLI8Gb2Nq9hEI50LbT8Yh+GNWbWrG2T9y/Gp5V+Ps1cN8doxu+JgpXH/Eyv9KiLjZ291z26/O3VHdc7i18b/VwPzwwMlfiMS2Y0VSb5h/eWBHSL4JaksMPgXEnZyRfhnGnBOs2MopUcdeuwwSRmPIcCl5ZSL6eLqsdW5fTeD2YhEmLusZ4/6l7vlGoyfW4if7Oi3oLOTzTCF2iXRXxCZJeVQsYFJwOa36FQhNh0yI3aWIR4OXtVoGdA9vc1QUQGsN7BoXizIiTjIzfpvFFOVc43566FDWlYAZ9WQ9EgBd2u/py4Wk+0oyjD2rGFSULmctCGeLQEJZ6Y97UeM3PFU7clVozFf8sT+VfbPJAu/3RswodpeyOR1qIQcr2QM3/Rj8GJign1WvUpxOpxSnkpRCv9lpslDV80JTC4tR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(6486002)(41300700001)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fvyp/F2OQ2W3mwfQzG5Qeqwe8nH8m2xSDdWUP2pgP6a94yqtbhLMuCbXtYlr?=
 =?us-ascii?Q?R99HOeuKJy3hiFSy1twLKtN764pDy7a6JhAM/MynOppfplJOcmRB5HK+X910?=
 =?us-ascii?Q?PBFDvxsCjiuyz4Ih4Bz2V1fHFsArRzr8ZyY2HCGJNk9BQMKgm2YuxFomjlRL?=
 =?us-ascii?Q?IoO7yjcDximtNCq+dSVbVe7uuLZOqPeRo6jLI/d3XAtn0YgL2tdQ1Dqh4J7R?=
 =?us-ascii?Q?T+wOY9w9qozyW6AlPNp1E3uEuhiknSEY2242anUk8DeG1hY6T8GjkWseJssC?=
 =?us-ascii?Q?Yy/LUxyo3HqaS89bm0+WeNZzRuw/vVm5rIWE2u/7J8BTLyiFAg2GateHuXKs?=
 =?us-ascii?Q?/rltT5oSTWWoU98nmCPCPBgJNvxJ/nrwW74LvAUo+fJAP7hxq5dknw7Evrep?=
 =?us-ascii?Q?T8ZyzxvmAK80HIR/f0Im/zv5qI2glo8l/vMUw7VDWxRgwBLnShmWp1iv67Ei?=
 =?us-ascii?Q?UWJy7+tZUcEbdXT6bFh6euYY3C1rf0Iw8n0PCF1c2QoVZzg8WrjWhZ+JkzUL?=
 =?us-ascii?Q?coTfrMFcNgCF6rIqhX3xR2aR9hfBxO1FPNUCVFktPA49vlQ1AajdGOGLSOvo?=
 =?us-ascii?Q?18sqML8U6+v9germLrkr/PvGL1cZgF1kCRfEBAobb/nxlO+d6eASM0KQKxJz?=
 =?us-ascii?Q?QXT+Zmt3K+YXXCddOUZIwGVsdALxbwczl4UMi+6FKd3M4j2YAPbyBoFPkhtE?=
 =?us-ascii?Q?l+VACkdyqZ//h5p07FSVIdpfOqUxvbQh9YpnAyliMQahkFLytOLBy6AdW34F?=
 =?us-ascii?Q?Vybkd/MBLfzRrrcqB+sqpz7fUm0lYK/1ax6XKDoqbUgZsR+MB6Tlgdr78xDY?=
 =?us-ascii?Q?vIpoJyVOtPGSY69tnW85L6g4kaQ8dN1jGJlL5u73QsPpDW8ERJLO9+DnejoJ?=
 =?us-ascii?Q?Tv1zBEh0tac/ara/xQ8Y/+4uSmhrtagwM/ePxwm/ovOaQOoVxTgV3AYLg9AD?=
 =?us-ascii?Q?D/iMMI4wmvTUEIrZK0UG7jN4GJfY1/f5LxRGwJprdPw6jAtGpVd30l3RCich?=
 =?us-ascii?Q?lpkyYe4lN8ir33zSxH7ynC1uwx7NifmDod1azcZlWqNg2gMXKW2DT2x65MRs?=
 =?us-ascii?Q?TYVoL7BAFE6EKAaWV771M+ykWsnGAv+1lRi9a+Pk5LE+DU2LeUTJ/snWi8R4?=
 =?us-ascii?Q?bC1LW47bHzTOexDNS+4yKkk82tOBdbBF307nUq9wtJTT3XFmpgsEP9hQCfl2?=
 =?us-ascii?Q?+sRqpII1lmZULn6VYXQ6ATCkLhShf76YMjc0SvAIfQHoXb4jlVWPF5OWLn/j?=
 =?us-ascii?Q?oc1hEl/mK772QT/1YExWDypLDgvP2slD3SlxHqisNEp5QIvauLqa9Otqr8ni?=
 =?us-ascii?Q?Wmi5uLXIAg16HYClcacsrGnPtbKhY/uXxPQt+RCtCJ+85S5I6RC7PRPgEya5?=
 =?us-ascii?Q?ImWqP/UEqanxUofXlIKJcywoYdfVfaGkyHWU4c2MqfIJYxkS3bGWnDq7ucig?=
 =?us-ascii?Q?DGZN9HTi9BSS0oZZazpp+UaD9OrgmLvlazoMHAufvh5y5XrcSX4Ey5ArlpaF?=
 =?us-ascii?Q?zqopYRzU9QASWcyhnc3Uj6CWKOcn+Qk2Xp2JMdRZ7HZNn30jnXXNBSUfnTzk?=
 =?us-ascii?Q?QFdtoOzJjcYxoc4vta1npo+Omgzz5w9ox9A32lEsJu1ZFQ/oTH3I8lomnoCG?=
 =?us-ascii?Q?MA=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e7855a9-96a2-44b1-3858-08db2e0179fd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:28.0967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xe1ZAw8LYN8Vod71Up4sfdOZTN5CCLvdfIV5OcFcdeF3p1GHkE/LxKA+5j4Mh0vkpLnBGjpn6IkUHi9iQv3otA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2001
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

