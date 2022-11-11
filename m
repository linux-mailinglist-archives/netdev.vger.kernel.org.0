Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC2B6253A0
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbiKKGWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiKKGWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:22:37 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022025.outbound.protection.outlook.com [52.101.53.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97673725F8;
        Thu, 10 Nov 2022 22:22:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SL+Op8c668UmcNoEXmNzBaCOv9BacVAZDfaFZe0SKpfngVVUvL6Yt4JW+SU1t6z9oGgax/aVzldtKVs9QtRWcHa0KRn8QsZQifUZn2wLrocQkFfKtCS98J4ouO8hQxSwA4sgzIJ+L4OduDx6xdhvkSqnYZmdRGoZ8PMbEXrIwKuYNlhllxbuJvO+On1eaxoIEDIgYaekKEFSv6nkB5M2rfT3atIR5c3LDBpViuzLt0Id5FLzDcUqaTp+nzEf0CraOMYojauSWgWtUuBhmJHeY12+pDI6ZSwV6WiavJeXOdGbIHM8Cm0vYQl9j8WhHJ+V25EjHTaxBV7xTMM+YvygXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgm+jUaF9HijpG4qFbxbmrNC62Z56ETkSKfonyRpknY=;
 b=jKA3k3rP2iVfNIEyy3oCpHUC8HazGSu0aqnwN8jM3W7n/BsXw+uTt1YAMuwI7E8+H2/8kKOXzUlJBaNK3lCAiplgWSrPTTqeBJsPJTB9uKrS4Z6HTmc6kRqM5JKJbMAapdqboPZOwaNJSteZOleiYsvVczKlGRmSw4jXzwRTQ8uDLizBMgX+RGXepeNX5/7xazrGYqQ2YlQnvdnDULxGj4tiy83d1z0uxvm+f5Bcj1aeirdqFED+Q8lYasGYGVAJX9yB6QwAdETa6gG6z4BTrsSc9dWbPlQuBiT5VJvVycqM4sHwlbuLWGdqM/irTr651Eoz6nCwZLqoa8NUYJgXGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgm+jUaF9HijpG4qFbxbmrNC62Z56ETkSKfonyRpknY=;
 b=ToILCqheV+R4T8gHNVRCPL9Zy2M3rQ9fC9X/ZivK5oxqPsUUkP9w+p6vvJljaZt6cS2Bj9Koid7ZwBIuPZW8uOf4EsahE+KXY9rfJmEIMTqJ6LePFAW7D1yAeXEE1LL8b2br6iM0VmokI/QG7IqHyAI8mgQqTozRRUsWFLH3A34=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:25 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:25 +0000
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
Subject: [PATCH v2 07/12] Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
Date:   Thu, 10 Nov 2022 22:21:36 -0800
Message-Id: <1668147701-4583-8-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1eb04da1-f7bb-4932-14d0-08dac3ad196c
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M+2Joy1XceC4wilOgAilQQJ/ir4WSMAOAaRqo7SX31Zh6Nwa1ozLQWVgwHmuFQ65wrrD/ybUKzK+9Xz3k57gLFoUWJlwMSzynRCYpvJhRX5nrX9zjhvlptqaZ4Oivpc3/oFjYqWR8FjItJuOirGjvGqn0pE6++AkwXE9MTxhtvDLdbm4MJy50lEAiZt10lHgCKAtK2BSpOTjhZXJ5Xxq0V3OCVIiUhrBDQhqz4+2gTY1uPVYX0ECrI1tUO4CwP9PLSZNZZ2JRdQG8KpSdu4OPdG78j76KZ0BblBEyjCLUahzQHVcKV/+vJlcWLERi8k2EuZ8oNhMrxP7MtTCHHPMGv8sMqvF5ams6ZsK2LT2DhvhjpyOrSFoHtUY53gMU3+beF+lq8lKyxu8nQLTX/aMaZRljHozTRKGrojsC1BzjioXDew+I5n6cdpNXx/O5ld7y7nS4bJMs2jRGckhQ6hAOp+fyrsrSd9La+54p0Klgiw3D6kOHCixk+tqBQd3JHXq4itzlW8IzKbaWoRh93oBjgfV2sdq/GCY46H/Bq31Ss6sA6T64Svic+9WvBCny2xbhGeDk3ZPvxkkUn7kpkjelpVH5KQ7XOK0K0N3Q+9hvGwb4iiki+E8ARTByc6JWVbBgcBT0SPzXhkpzkswhOTgugXGrNBfc/R/0wJqjSMO7PFKYyZvlQG6ibk3TR9eGwYNicwNZOuHHeWe8FLYXypDdFcDgCoeLGR6FrX620rm1OVo8qIMWZ8dbn0auMpmm8AVbJfEfWufErkK6vApdH6OZVhrUl1vG0B6DhDVt+kE9hMftPpqYh5CyYYaFb+4weO8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VZHo8GhM/3ERLUqVaD8hPUbkmwdCPWbQS/6ZWJWiN6KiVJb8YWznHEwiiPBa?=
 =?us-ascii?Q?F9pbkOibP9FJZLRK2/IXgWza7cBtnRJ+R5DW3X6o+AqpnDBAi5AomzLdwPKv?=
 =?us-ascii?Q?dK7bc8Rap3PrY29Jue2ZIeanpO2TXPAsEb3NZCP0sC+lg/no9vbMevjcG+se?=
 =?us-ascii?Q?oYFCK1KIiI0uTaEUnisYSFPsdtAepPSRVJv7RjEvoOzgIPebeJz9Xi3tujEH?=
 =?us-ascii?Q?OQvjmiiMUtHmsvoViN5n0HeGtccu+bq8loAH96NEQCTZegYQPNQnQV5OoEXE?=
 =?us-ascii?Q?3GzTamshnl7BcI30igP88mFkduap/rQwJau6pz4dWrb5seylUU78J95M8B1W?=
 =?us-ascii?Q?RLlD5vEilfmAbl64aIYPxNAf7KHevNcbbJGMchl9GIR7dbYvbtMLE6faFgjK?=
 =?us-ascii?Q?5cnxMBeJhtitjp9BOHqMY4NnTFOpa9jrlJlAzr/4X9/szDixZVUvpplUhzHm?=
 =?us-ascii?Q?DGG8YWu/g+BW6FfuWrFZw04CYIRWqI+WELoY7RaN0ElrigOgHZsmQcu3pEV/?=
 =?us-ascii?Q?1rqGgNhZZwsYGmk8YJ3fmc32qoUK3ewmGeozfE2vk5/91YQ4U2ZuuOjkmjjW?=
 =?us-ascii?Q?tuVMjVjXzHR/Twb+oTOmFVRFcC1B07W9nioGd7TU07kZtC0Pj8piDuyxY2pk?=
 =?us-ascii?Q?czZu6FQRbMLq4WfFqI6IDOKCoHdCsgpTiCs1HoPP2jG5onpP1TX9AGLKuVmv?=
 =?us-ascii?Q?NDxrJab0J6wRMF7fcgav0sLuJmqDbhtjEPCu6xTUNzxVjoVHDw2qGCUmAC3y?=
 =?us-ascii?Q?bw7MFYoHx7Y/FcXOsS86WKH40WkPOY7Et2acakG52u+EEibyhfEPtuiSpJ/m?=
 =?us-ascii?Q?G2qI1fuKAdRSI7KUoRm03rmaCHw9dqwPUP78/29FBEzXqyF/NHeLc+sxwpuE?=
 =?us-ascii?Q?yEt6GdKTrQAc+t3V/XBGNHnP/zuUGtv18DOSo9WRNZwlgatRhpUWLfxEGpmy?=
 =?us-ascii?Q?UrPrd2lzu8oc3m41TtodKyd4Xxr1FexeET+6RinCd7xoUUc3urluAvR+6flL?=
 =?us-ascii?Q?w4qdv9t4ub3QQjqs6Oxm6XsR81lv2oil00mHrStFwHSlfQ+BN+v1do6GuFii?=
 =?us-ascii?Q?Kjke+2ecAi9s57H7CEa/jSPjVpx/tmf9IykF3KjE0cLICzENS0brhGdKtam9?=
 =?us-ascii?Q?lvJgVqwGY1F+eGpv+taEkDTR5TFec3v9b9tAoEy/6i9UpN0eG7pmoJh7Zje9?=
 =?us-ascii?Q?QouD78V01EPjiG1gMqPPay3QEqEgEDUuv5dKdvrJGytzFjb1VELWO9P/MRCB?=
 =?us-ascii?Q?6fX/Gt40ynSrS7i17ysvdIMYgujOZthXv0IRxJAYaK0DCxtyR7Wpn54O7Zkc?=
 =?us-ascii?Q?TdLxQyS6/YnHKk9FFxEMVjBd02Yoo1IDsBuBwh7lq0Oho23Xg6zP9toW/nFZ?=
 =?us-ascii?Q?q+AgqTuQf441WWk3tk7NVDfzBa20l1V/pE4/9nu63Gs2hYw4JswkP//G2olj?=
 =?us-ascii?Q?nHmS8f8UfeI3iWObVHvU032eycxn8QWBPlQi4RlMPKahneADq5Ydrquurndo?=
 =?us-ascii?Q?TGb9XvQ/gdqU7C+WCJ5GIYybZM3vZ3uoY+6cNCetgsZuJcIsjKtHm2f+PR/W?=
 =?us-ascii?Q?C1XwA2m371usuB5iqDSrEXFKacRdwl6uPfOw212tTbM788RCyoR0Lj0BK4NL?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb04da1-f7bb-4932-14d0-08dac3ad196c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:25.1649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5syjhMfnGMGWJ5udiITNHWz4QRE381JbygKyQ+97i+RVRxbYzkVKQa1L3ZHZcm4MvOjFo4BNaQG5KMniMuQIA==
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

