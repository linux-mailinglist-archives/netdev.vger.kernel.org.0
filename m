Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2006B1981
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCICpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjCICob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:44:31 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021016.outbound.protection.outlook.com [52.101.57.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E321A965;
        Wed,  8 Mar 2023 18:43:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5991xDbNQtM+EWX/DUFsfP+/NCkSEGzZ0zPrAI0JpA3CXGxAN2xHJ4tO/Bx9P8HDFXt7woHgd6D/ZkNuk4q9PdL7rqluXYfvcVnp3G49SBeo/SMIk6+IDLF/Mjc0+ijiQR4N1bmrjpSPMCnToCfvJJQVK5q4WJ2neghewMO7z3y5MhTB/ywI5y9N6yQSr3S64r8vG4GFyyNwEFIFLASJq929GdomAnS7NG8gDhF45Y07I1bnjeKDlnl/0Exqo/oMvqr5jqDuCMmHyc6RUoj1/qcWXU2ZfAaJIUO1W25uZolXRZa462765taEErtJPt7EljhjFN2AlPHJiV4e4TK8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vEuH5Ee28VRY5Qrxd7yqx/QGPvZZfqnOwBt4Yd6S1g0=;
 b=nwKVCOevDj6yEhLvlGdq3GtO9GKR+aHZTBzmu7QZQjLHFF4RTG6G5sPDxCkZQ5jeQBKKC4E0bAQ62pz7z2IJ6Oew1e8DWP2b7FwbiIQtj1gvMHXWyVNfRHuqT01YzCFD3/QqW2bnqntmk9CD8UGvlffzvJt0ZMA/6t21l6qSzDd49d2supNxP9PnyZpnQrRvkiA3fviXkb4ZVfHwuZUSAe485+V8nUxH8/BkCRYivFTbmedH/9Mevwz62pU6GC0AJNCMZWNUjJkISosSacKC5oLJ3F5cDgOvhU4hI9VwLaYxWow9NazmOdBzNTJXeopJ9NguNlZEyh1Q4Fi+5JYMWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEuH5Ee28VRY5Qrxd7yqx/QGPvZZfqnOwBt4Yd6S1g0=;
 b=GAMY7Q4Wuve3YtenDG36mLiUNeLUf7kkuw4FL6HaqZaLk1ur3U0qfUISV51zCEUIiaBaKvtKjV3xpA8EB1MzBsF55CLz2c0DpU4adXUFnznZSzQFc9eJkqycUDlvlVtBoSbuZ+6KDj6cuLBr+FI7e3xLQQjkMHYN+3MdX7x+L+c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:51 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:51 +0000
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
Subject: [PATCH v6 08/13] Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
Date:   Wed,  8 Mar 2023 18:40:09 -0800
Message-Id: <1678329614-3482-9-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: cc2e8e44-8a39-4129-925a-08db2047d63d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X1wtHL5FFRo0lzKZR6M5yeLp/3vjYSyZbCmfCLL+Mwh6zI+UFvLeuDCG3DHT7M48lRqfsDXiwf0US+Na1bAj874GGZlsVPnmpBWrGhN00uHbs/nUe4hqCjOsi5BKfxHFRqlsjW51tOhK/+EWqrpO5o5nBU+n+FxmUhGW865dGQYVpfcXWrhdizxRAu7/DDy40m8hOvWKa9gtPD9vlCHpw++i+GH5CsVYjfUCR35mB0CpcTvqZloSKpJdl3zxr9ybmRhnWhV4bRiKS+BXDbUvvb9nQSIXCnicHKh8RV91j5qIvgiCkodM0B+8i3LQJMMpgWupnzS/KjI22dU4cHX3DPKnmhXYXSMiSPEGVUr+BI2nsjF9vowacqzCm82KrzJ+IT4Az0eyLvMeMvB6GLquls4CWm43ZSuHnGGu2Hyfzi/ntHVI34sjSH3sQETyJkX72DpSj+rCawuJZIN/OOkgQobe4Ce0GS0p9PFedry9Sb3gYDwD05sH7NiRuk0od/1kdNA40iSsQWQNQ82o/Izm1u40qnuF9vdNDuYcLPOc3Hs6AvfKn+lNVTnhJRz+ssf95USaaPrtEsvKJUp2Q8oqHH8Ukl0PXlTC8kVgpS6y/8gaeWexFfl3G1i2e+jMxi7PfW1HWQ7kOgqZvrEa97z1//zRr3q0BYtaZXX4f2Fhkq59j+NWO8r3vHxTbxjDwG9xS/8TZ2tQTAH1TuIKKRSY43CG45Uq1tKkMs5XQQbMKIJUKC+sjVejq8SUXmiL/Iaa6qzUcGbmiXXxiX/kgu7h4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?559SJ55jmfi5YkHcVc2E236qXtCIyy2YlqF6Taf8TpYKhVXIzlttc78XN+WP?=
 =?us-ascii?Q?xBI+/8dpmGhEEl/Fqld+XzILfkgESHJHVn254YSaGxKLr4ThSI/gU06Y49MZ?=
 =?us-ascii?Q?jvqy4DoOvZ53ps777YUWZ0hdGEaxiYjaOV8HUGu5dPdHC77sa+yUbU053q45?=
 =?us-ascii?Q?LMFxw++xy83madSk9eTuQa8DqoH3KE3aZR42UDRYvsGcCpubKbNdRzdU6tmE?=
 =?us-ascii?Q?pTuFY1cy4BSblaMi7hNsmtauPgQY1vPDc9gl+LbLOlVBDabWOVWjyrx3Kl0A?=
 =?us-ascii?Q?DZMVmv4Ci7fNUGINbGX9SQPf+isYsN0hnS05c3uyfGFU5zenJGoJtASkGSgh?=
 =?us-ascii?Q?4EOYqWWT35S1v1pIqP5YZYhD7GjIEWIdMtR6Hu5uipHcB5KrOZJTygjoUG9t?=
 =?us-ascii?Q?DzjMULulPI3N82Hvb99w3z7tmIZoQi8ny7FQiL3rFN+xkRyzhuAGvV21EQ9b?=
 =?us-ascii?Q?r3k+ayMeCEPmYtmBlykQzdrMjCojOxDPT9bOhJk9qZyjszNw3huwXnDUq47R?=
 =?us-ascii?Q?RB8gj3n3GKA0XKyxi+Ioz08j/30xwMpgVqapcr4EvnMAXs9G8GPyPJyv3Vve?=
 =?us-ascii?Q?PwKg4kc6rQFedKJxHaLvpy+MytMXdA8I8jN+UQWbcVfa6juv1JFInJdIZ+ZX?=
 =?us-ascii?Q?GEynuuVsr9ymAafhvt0yzcnT/g+tio1CY3EVi2JeOwkhZqjv0ZP3Yhi4Yrp0?=
 =?us-ascii?Q?v0/JMEzVZCKet/6cnqvttoCJuynOrEhiIiQ0ypLqh7FJSz3L3lG8nv1AiRQ+?=
 =?us-ascii?Q?eFsD1d/+LH/C8bBPgaYWxoqPKzpeVMw7Xb/soywMwWUaeosoPPiJAkBjnSTK?=
 =?us-ascii?Q?M3pYymTNc9hy5zSJj+Hm4RyxQsoTZKJu37g5qmHjFcKnnicb68kNx08jCCIJ?=
 =?us-ascii?Q?oleJx1x/cWrRTuHn9hm/A7zdLkjtOb20Of7Odyc18Iw8H+eHnZKwPP4/LvC8?=
 =?us-ascii?Q?ti5NterzHY8jmyEwaHOVxSXVk0W8rrk9sedVwgANz5icPP6PzovD6PFBO2+H?=
 =?us-ascii?Q?cd92qKEv2C3kcGm6J7EJvnhHYBhYO1TbALJogo0g5HQGzZHt+RezyHbZF/TD?=
 =?us-ascii?Q?LqjW/Cc77EliybWy6/r1I7Hc2PyAtwoT5Zu5qTs3kl0Yw8MiY0G4VPK6SUdf?=
 =?us-ascii?Q?DfBnTK4oBvmOMtY2VSHhlfcBEGRHRrJQGdrQzP0MOh1i7AMhp5UBb1qbaadY?=
 =?us-ascii?Q?DCiDt2cH42PYQTFTDg6OHiJ8LVKgtvfTID3TzJq63rAd5GiwVSKGGS6QKxEd?=
 =?us-ascii?Q?mlNDCsaG4MkHJj2A3fwtvNk0BRGJrM2Nk1f+NdqYMgPysecM8mgF4jooF+0a?=
 =?us-ascii?Q?Osh6t/YB3ayYZWLiT095LeK4+r9+9yMiVVnqV6gBn2106hLeUdXEZk6f2YKh?=
 =?us-ascii?Q?HUbrn4E6p4cyKFYOkjs8RuVpaeP0jC/zLeSqt+25Xy/x3l0qFy+DLdUtwGd0?=
 =?us-ascii?Q?TDTrSTw3I6fvC6TSOY311tFi4ZG4qaJUBm39YIpzyNSeaG0zsavx9G1QpekP?=
 =?us-ascii?Q?9DWeEMGxBNipz16Qv/+JKlaXNWYDHxgNo5jDCKHPlevvn70/GQm/KOrv1z4n?=
 =?us-ascii?Q?SCmF/aoI0+BCEt4QtraKdCb9FXCbQJTCMBYW9PgXFmf2vUXsF1ZyGPFHmdWA?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc2e8e44-8a39-4129-925a-08db2047d63d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:51.4069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bfpMAdilGI0VoPFDCL8S/rm660NZHcCoeacVyibX23PD6jPIxwGQ7C2XGY3U5Ept4m7GNtVX7rE6GpOHU9tYGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
mapping for VMBus monitor pages. Because set_memory_decrypted()
and set_memory_encrypted() are no-ops in normal VMs, it's
not even necessary to test for being in a Confidential VM
(a.k.a., "Isolation VM").

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/hv/connection.c   | 113 ++++++++++++----------------------------------
 drivers/hv/hyperv_vmbus.h |   2 -
 2 files changed, 28 insertions(+), 87 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index da51b50..5978e9d 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -104,8 +104,14 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 		vmbus_connection.msg_conn_id = VMBUS_MESSAGE_CONNECTION_ID;
 	}
 
-	msg->monitor_page1 = vmbus_connection.monitor_pages_pa[0];
-	msg->monitor_page2 = vmbus_connection.monitor_pages_pa[1];
+	/*
+	 * shared_gpa_boundary is zero in non-SNP VMs, so it's safe to always
+	 * bitwise OR it
+	 */
+	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]) |
+				ms_hyperv.shared_gpa_boundary;
+	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]) |
+				ms_hyperv.shared_gpa_boundary;
 
 	msg->target_vcpu = hv_cpu_number_to_vp_number(VMBUS_CONNECT_CPU);
 
@@ -219,72 +225,27 @@ int vmbus_connect(void)
 	 * Setup the monitor notification facility. The 1st page for
 	 * parent->child and the 2nd page for child->parent
 	 */
-	vmbus_connection.monitor_pages[0] = (void *)hv_alloc_hyperv_zeroed_page();
-	vmbus_connection.monitor_pages[1] = (void *)hv_alloc_hyperv_zeroed_page();
+	vmbus_connection.monitor_pages[0] = (void *)hv_alloc_hyperv_page();
+	vmbus_connection.monitor_pages[1] = (void *)hv_alloc_hyperv_page();
 	if ((vmbus_connection.monitor_pages[0] == NULL) ||
 	    (vmbus_connection.monitor_pages[1] == NULL)) {
 		ret = -ENOMEM;
 		goto cleanup;
 	}
 
-	vmbus_connection.monitor_pages_original[0]
-		= vmbus_connection.monitor_pages[0];
-	vmbus_connection.monitor_pages_original[1]
-		= vmbus_connection.monitor_pages[1];
-	vmbus_connection.monitor_pages_pa[0]
-		= virt_to_phys(vmbus_connection.monitor_pages[0]);
-	vmbus_connection.monitor_pages_pa[1]
-		= virt_to_phys(vmbus_connection.monitor_pages[1]);
-
-	if (hv_is_isolation_supported()) {
-		ret = set_memory_decrypted((unsigned long)
-					   vmbus_connection.monitor_pages[0],
-					   1);
-		ret |= set_memory_decrypted((unsigned long)
-					    vmbus_connection.monitor_pages[1],
-					    1);
-		if (ret)
-			goto cleanup;
-
-		/*
-		 * Isolation VM with AMD SNP needs to access monitor page via
-		 * address space above shared gpa boundary.
-		 */
-		if (hv_isolation_type_snp()) {
-			vmbus_connection.monitor_pages_pa[0] +=
-				ms_hyperv.shared_gpa_boundary;
-			vmbus_connection.monitor_pages_pa[1] +=
-				ms_hyperv.shared_gpa_boundary;
-
-			vmbus_connection.monitor_pages[0]
-				= memremap(vmbus_connection.monitor_pages_pa[0],
-					   HV_HYP_PAGE_SIZE,
-					   MEMREMAP_WB);
-			if (!vmbus_connection.monitor_pages[0]) {
-				ret = -ENOMEM;
-				goto cleanup;
-			}
-
-			vmbus_connection.monitor_pages[1]
-				= memremap(vmbus_connection.monitor_pages_pa[1],
-					   HV_HYP_PAGE_SIZE,
-					   MEMREMAP_WB);
-			if (!vmbus_connection.monitor_pages[1]) {
-				ret = -ENOMEM;
-				goto cleanup;
-			}
-		}
-
-		/*
-		 * Set memory host visibility hvcall smears memory
-		 * and so zero monitor pages here.
-		 */
-		memset(vmbus_connection.monitor_pages[0], 0x00,
-		       HV_HYP_PAGE_SIZE);
-		memset(vmbus_connection.monitor_pages[1], 0x00,
-		       HV_HYP_PAGE_SIZE);
+	ret = set_memory_decrypted((unsigned long)
+				vmbus_connection.monitor_pages[0], 1);
+	ret |= set_memory_decrypted((unsigned long)
+				vmbus_connection.monitor_pages[1], 1);
+	if (ret)
+		goto cleanup;
 
-	}
+	/*
+	 * Set_memory_decrypted() will change the memory contents if
+	 * decryption occurs, so zero monitor pages here.
+	 */
+	memset(vmbus_connection.monitor_pages[0], 0x00, HV_HYP_PAGE_SIZE);
+	memset(vmbus_connection.monitor_pages[1], 0x00, HV_HYP_PAGE_SIZE);
 
 	msginfo = kzalloc(sizeof(*msginfo) +
 			  sizeof(struct vmbus_channel_initiate_contact),
@@ -376,31 +337,13 @@ void vmbus_disconnect(void)
 		vmbus_connection.int_page = NULL;
 	}
 
-	if (hv_is_isolation_supported()) {
-		/*
-		 * memunmap() checks input address is ioremap address or not
-		 * inside. It doesn't unmap any thing in the non-SNP CVM and
-		 * so not check CVM type here.
-		 */
-		memunmap(vmbus_connection.monitor_pages[0]);
-		memunmap(vmbus_connection.monitor_pages[1]);
-
-		set_memory_encrypted((unsigned long)
-			vmbus_connection.monitor_pages_original[0],
-			1);
-		set_memory_encrypted((unsigned long)
-			vmbus_connection.monitor_pages_original[1],
-			1);
-	}
+	set_memory_encrypted((unsigned long)vmbus_connection.monitor_pages[0], 1);
+	set_memory_encrypted((unsigned long)vmbus_connection.monitor_pages[1], 1);
 
-	hv_free_hyperv_page((unsigned long)
-		vmbus_connection.monitor_pages_original[0]);
-	hv_free_hyperv_page((unsigned long)
-		vmbus_connection.monitor_pages_original[1]);
-	vmbus_connection.monitor_pages_original[0] =
-		vmbus_connection.monitor_pages[0] = NULL;
-	vmbus_connection.monitor_pages_original[1] =
-		vmbus_connection.monitor_pages[1] = NULL;
+	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[0]);
+	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[1]);
+	vmbus_connection.monitor_pages[0] = NULL;
+	vmbus_connection.monitor_pages[1] = NULL;
 }
 
 /*
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index dc673ed..167ac51 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -241,8 +241,6 @@ struct vmbus_connection {
 	 * is child->parent notification
 	 */
 	struct hv_monitor_page *monitor_pages[2];
-	void *monitor_pages_original[2];
-	phys_addr_t monitor_pages_pa[2];
 	struct list_head chn_msg_list;
 	spinlock_t channelmsg_lock;
 
-- 
1.8.3.1

