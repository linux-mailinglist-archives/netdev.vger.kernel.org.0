Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BD4606797
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiJTSAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiJTSAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:00:00 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022018.outbound.protection.outlook.com [40.93.200.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A131EA573;
        Thu, 20 Oct 2022 10:59:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWweT4EQ8KUkmk1s3e5Trah6hb5DDak1OcwNWx6mP023yYWNa1Q7P5WPSJMgVs8nvc2NsVTtX6s97PE6wE6LBY/1qh86F/wN1FJoZKo8syn6BDVKG5DK/vHea9Se2qt46kF/rmwCa5JUsgJ7PJYGsCtIH2kILNpiqE4QHc+tN77RM7vBJCBi/1PmWLRbloWGvjZR1PQ8W9P00HSbTSGFQRTFwYlZBCXQlyCD4cJp1D9B9dJDy0s3rpUnFov4L8aA7SDkiMoqqq/YQalIlclosfM5MvFy3iflgI6HETVpa0iOiKA3PK806sVnTLesrmG3TENDASFDrVxRVQMBNhHHVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qeAXZg3STGQ4uhs+C+hLKwvmdp9vlTnfXiY2BSEKWok=;
 b=EL6Rtlq81mMshQYJvFrxAq93QkYkFY92ggd/cNoARNBO/8M250AWK3T86DMRYhS0YizJsXTOh7EcevUFkiaVyaDJ91xO74yayDLHefd+PeGbnqSbFMpKz3abJl4tfeMSPKsOXIsKCTR64yb/hxNXkh8MXjeMpoN/4zsXDdAz8hL7wmZ1aSKYCnEhPAT/uAk/BMYprmIH50ZvzQoJExdtPznlQ3W30YUO0KUisHh14j3BjqwKwKyH/bBwBbohxrvnHZ3kLVOFck88eao8d6X8t+FxPoCu93p4j4j8SBiEAeSb0pqHn7TO/gZ84XnXr1+RLVQL/EceZuASgQsKc/GoGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qeAXZg3STGQ4uhs+C+hLKwvmdp9vlTnfXiY2BSEKWok=;
 b=SHPTmDVV19xK2EPBTagY9CRg+R2uGiE2a0E3yTA5P03CKgAuKmL+asiK6JY2DF4cb0fQ+KalK2+DKZPb7bhzUMkWWhSpO/VEuWnZW7h7yZpgH9D1273U0XuDB0ki+SC5c9Yrrb/2vUDFiwOOLdwGRv6X5kZds6bBFcNF0UQx6Yw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:37 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:37 +0000
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
Subject: [PATCH 07/12] Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
Date:   Thu, 20 Oct 2022 10:57:10 -0700
Message-Id: <1666288635-72591-8-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 667e529d-2595-4149-d742-08dab2c4b655
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pbQrPcZ1dg5+ljl9eSXN0BogOtE3RCdIpI1qYRZPASGIlW9w4VbKTkzBzmkvZg1i4b2rFawdzISsxrb1GjLWxRVOnWjZYOXZcqWbqLDFgycxjDDCp0wb6UQxG2GBTWMrlIH0iVkAfne8ra1nRELHK3YFbVv45MWuJNFC5oJMSwteOwKvKl90r43EdKuSaPfFV3V5QGLp7vXQNUh3+jKQRFIl7KgvCNLw3YQkPxf/9Dkm2XkYYr90265PwCrXLe39nXRpqX+gTAiMcVI6zXzHcpoaZMArGKMY0+ihotvf5UsdGLrpJkBQEZTx11aE0MZwgF0fv4B1W6jSCBXjMPrsDFwssZSvOYeJqqmkSFMgNCHbn8LyVZ+PM1B6rRkmS6H2mQHIOxjdCRM8R01DEI3qAh1PlwG8qwtWn3CTU/pUJzxiivgFOLV4o8AMehGULzaDAeRJjyRuH0XiqfBnWeWNGIuLOA+KT6ozUDggmBPSJl/j3eFHQZYcEkqzNBur264fbC65hWcdNh+Z+jS1ApaD/2uzyO8ZlPgtsXE2HRUn8kJayeeiyDXm5FK8NfdGD8GR6YcNo0u8UzNX3Ja5p3+hS+v8cGp1/ye/I0QVDRi1g1/S7l8YDUGpKWRT4MkR1GU2OzQ49yoqnn1b1vzMFT+j9N0B0qTKme+x9efL17ezCnnSJ9jBm7tddAV7byDvvrf9+nhz4BxXAnlsDEjJGwKFNZLU3bn/qcSIl7r9QVE9d+AEzJMgwhW2pNMvMbF4T9XDMx6OfW85D3ObbsopRUQMCdhhygJRrM/7Dj5b6x0HPk+umQxMFrHkMjkLGwWWcpOz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9AbbhGm3Bdfvwa5WCmefqYD8T/1pV9v19C6EIhDFfABvVcY7HH/PqXmq3UBV?=
 =?us-ascii?Q?7BjSlzxCSerBJ6bEYNDUkDm1GwLHfoo51RMyj8Hsq/N3N5pRmtbQzhVLOfVJ?=
 =?us-ascii?Q?cBHioRHEgzmzGm1p0J9zTDV5Fok3ZN9/unvdMR0xJaNkXww2YlsGMyPBQpcn?=
 =?us-ascii?Q?F84CM2P3XyyGo0iv4stomQl/5oOlauDHzRqEiHlfcr+flpxWBHB53KGlDMAP?=
 =?us-ascii?Q?JkV7gOzf1E6LDSyFtKWLLLm3YUGeWhsY1z9w1eL8URcaIcCB1PXtTtmPkH1C?=
 =?us-ascii?Q?+ZqTCDuopyXsag/+jUkFxpyFOeNm2By+g4uiLZ64ogtAmNeH6Hm1JaCJj/R+?=
 =?us-ascii?Q?7cY2ZSPUKClDGuOGu0gpGKOFLLv2O5C7Zl0z4EsWfUN5WwhByovf9I1WGWVA?=
 =?us-ascii?Q?44F+12jeD+iN1/aao8fh3deLEnvCFibffBPSz6MHpjLDpzHkGDrk6xk3TplL?=
 =?us-ascii?Q?jWyk84gvJJ5ne5P5EeOCGphBTHRMtRLifsSuaadMCTDikz0iaQhiKeLab8zx?=
 =?us-ascii?Q?2CGH2ZKa3lfMChohUACYaR1E0Y5FH1ngToVgV80K6YgijcC5v9JGMfXwz/5v?=
 =?us-ascii?Q?L7m4AB2QXvRYqS0cpK8FmvvqmWii9bKyp5ot/AIGx0VbnRCKd8EwmaNWcASO?=
 =?us-ascii?Q?Pp+Y0VCumCoD+RY3ksVA5x4gIZ5zmZQI7eXUICYrRrqrPz3HVaWZSYPMRWIu?=
 =?us-ascii?Q?ZcQqnq7/Zq4oX/9Oh/lx0PZ8l38atOr3LpxMXfV9T61ZG76/JTlHtaVpDKZT?=
 =?us-ascii?Q?WUQV/edMZG6cARB4KOQNSqbJr4TCB4Nhd2pdfSlTcvQGq4yAG2rGYX5L5Nky?=
 =?us-ascii?Q?zF4SjJjVpMGZiNAthrbi7M7ZQRPZxycwdmA737yLXzkXSWC3WKKAOMjQdqse?=
 =?us-ascii?Q?HrQQid5GTNw+5eCtBHRqoQ0KIrAnRkRCQWym8wo06BHB1KGLcDm/LinAqNl3?=
 =?us-ascii?Q?neHUi5o2LkNL+s2KRvJGhUQiSjCsrJbSjnBDuDKUpN9SoX1WhywCf58vqN1M?=
 =?us-ascii?Q?Gun6yun6wvlUhdVenqc6wXdGTiU5RqmFJjaGJQbbNmAm6JAtRmq8BC/JHNgO?=
 =?us-ascii?Q?YkzwV3Q8y3Iz9f54KL102cUGx8D1ZOOxRsz+ESenghPQ2Ttk1a7oyHKmP+sw?=
 =?us-ascii?Q?22JjSDNuMYmEPN3t41W3arxcGxGSKT9yPMm5wdcVLvnmjymQQKIrqh3DxHGm?=
 =?us-ascii?Q?OX1yKmSkJri87ZNQw9TQTVKO2y19c12mFiu/DM5Olyc7HmKJ1dv3o8BeeoVL?=
 =?us-ascii?Q?Zq9RZzDYr22G/lUpGrRZ8pAeCBF0zolNn9tT9jaZx+E7EvpmFhoJUK1kUSed?=
 =?us-ascii?Q?11vmpFtqg6rfxlDMZ7NgdvuZeTQh2sqSM5TjBJv9y8hUqFc5wdYPVlw+lVN0?=
 =?us-ascii?Q?wjhnjESJwA8SUMGewzirPRql+7x0na9/xuQlFHmq7BVOVYBy79VY+Ks7dRLq?=
 =?us-ascii?Q?H2D0HYzobiw1Fx+r+Ce0iJu5KeE0rg1bXDjWlgeHEdIlxDsK9KYUIKf/ARia?=
 =?us-ascii?Q?4RP8JL2CRvAaVSua3PhwNUhjdhCRZFLrtgHmj2Boc/msGVDCC6kCwQHRuge2?=
 =?us-ascii?Q?ptrQrpYtf4oWdI3DajOcQafFAY4VTJF4q/ke25RM?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 667e529d-2595-4149-d742-08dab2c4b655
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:37.0790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mc14Ni/G97dftdclL4XaQqbJldWOg1pGtCxzzW0jjsWOsFUxuxxaIQkL3BfcePP4I/0eJBiP3Q9T9BN5Z0H5NA==
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
mapping for VMBus monitor pages. Because set_memory_decrypted()
and set_memory_encrypted() are no-ops in normal VMs, it's
not even necessary to test for being in a Confidential VM
(a.k.a., "Isolation VM").

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/hv/connection.c   | 113 ++++++++++++----------------------------------
 drivers/hv/hyperv_vmbus.h |   2 -
 2 files changed, 28 insertions(+), 87 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 9dc27e5..e473b69 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -104,8 +104,14 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 		vmbus_connection.msg_conn_id = VMBUS_MESSAGE_CONNECTION_ID;
 	}
 
-	msg->monitor_page1 = vmbus_connection.monitor_pages_pa[0];
-	msg->monitor_page2 = vmbus_connection.monitor_pages_pa[1];
+	/*
+	 * shared_gpa_boundary is zero in non-SNP VMs, so it's safe to always
+	 * do the add
+	 */
+	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]) +
+				ms_hyperv.shared_gpa_boundary;
+	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]) +
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

