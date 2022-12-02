Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9F063FF08
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiLBDeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbiLBDdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:33:17 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021023.outbound.protection.outlook.com [40.93.199.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341A0DC4DA;
        Thu,  1 Dec 2022 19:32:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goelepv1eVhh5zF5Xa+6Gui2hpqRbjFcCBhiFD2N1YSwn/f6kqT3sdNELJy4j9RLoehDeTw9iQa5u9rloO9Tew2Q10oewu0Bz4twYqA0bx7rRVGkgaR2HR232Bp4FJIMmmZRwaaS1e/4QMuNOI2TPzRi3oo0wTtnSbl9o0uSr11h9Dn2ExM8kqA1EqrQeJYYgy8W3QzCXiBV0UNvyvohEqlUk6IdFQ2qgg6Fs9jVNhkTBc/HYA5SZwNpVG+l43OEzsk6OLkv7lC45rrCEWYI9DwBOBS0be4CTvzQczWXdi+5aVDWxhYyNLmP2u4b58Y2mXes803uY0GVlXqF4X69KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvE6SyTZq6LB5flL+POxNJmNnPxQpwBAtj9alMcKL+8=;
 b=kXpIPmm4Otp8/VqdZD0iV1yACA6kCKZHniNn2fVMMvAM43GIflO7YYLPLF+F4TjyNvZeNNKqVeyceexZbgzcnxFlzLNThXGs7orTi8N7hbHMH5nJa2b7W+4KBx23SMb0XVfSkVNAwSL1zhvqyv+e9EGcY1f/hlO6PGlxkMo26Y2mLZT4s+s/oWiDx2vniZ5Dv+o6iWs2n+vmEAwk6y7VMi36eVjw+J3bjkc0+fX4aU5B/nf0tpUXxWr4CwLFgGK1yMAuchLxEevsS/l5w8496Yx7SJpHrdp+iPIVbm9NLEyTh7I1uD0WN47zJBcgsiE5CLJtPz728PiRz0c42+KTMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvE6SyTZq6LB5flL+POxNJmNnPxQpwBAtj9alMcKL+8=;
 b=WNPcwoW8aLf8vUVk9u31FYzTMV+31xF9dj199sTl3QsEY+JKlmqTzYo+RIrrddlySfAv2uzh8CBjqtVoLR7ncTyoc9nuBjHn/jplbPMbbkcXtmSpN2pZIDsOHz9ZI83dk/SzXSnMO50JURtvzbmcEb0cwORtUIXZMm6jKwVbyKc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 03:32:20 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:20 +0000
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
Subject: [Patch v4 08/13] Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
Date:   Thu,  1 Dec 2022 19:30:26 -0800
Message-Id: <1669951831-4180-9-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: f3582eea-0c6f-4e94-a511-08dad415d17c
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xKUE+nD/cWn9j1MCsk4i9J8t/+QA4VFlj0itk8Wy7K7sXhIBeVr9tZEpQx0virljBeXeXmBqL5gM4r0/RGAJuwqimsDIM9OPwGlea1/fz0hGWeEEMfaUicezAwMjBmx2MKIZQafdcUKzFLN9jO+W93lTI5PYDvcAmR2c8bI03njIOVdBexZDf6Pz+9LDrD4mhoLWLG2qsRKcyHz22A7yxIn75+gQ5PdSPUO23AaPckvtTlNqHPeCSbM1sl+S45Mjp6IBCCOPGA5MPj1effLGSnyxFECjXghwD2J+FRkAl7uJJOl8HzpDwwFAtuySBhS48sXNhkGMOXLR6QEQdBHGUqSUhcapzVvYZQjs74V7LRcP0OVCXf5OwvWdrO/Kaj/gXWU5wyBotAG9JRvoZHo0hUxEKAheny4kIDV6AFSo8uXoHdc221HFahGl7MTt4byJMNYyiK2W3fFkXLfAffb4dZBX+zN4i96MPt+LX0RZQhOejBWJ+v2v4nbiyDzN/o/sviNPwhQjhgxCQ4N0DQsPah1VZkQbMhdCQuhMduONM/zIcXUph3qs+1rc8whNLvtKsYF3Yj8ZSoVWorAJ6S1om6ftNKGQJp87tSlWFlGRfN9phnM9K+qYfhaB0ry8DGIv+boscItVApdUy5awqi3DACs9ys/vMgZooiN/P/Hk0hVkCgmJhHnmx0tE9IDR2nZy/wBbJR4/HxCB8EjWsHs5OX070jog6ZlHIV29GT4oOm0U/0k9dKQl6Ec+AUPV58IP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(86362001)(921005)(41300700001)(36756003)(2616005)(186003)(8936002)(5660300002)(66476007)(66556008)(52116002)(66946007)(82960400001)(7406005)(8676002)(7416002)(6506007)(107886003)(6486002)(316002)(478600001)(10290500003)(4326008)(6512007)(26005)(82950400001)(38100700002)(38350700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GD2K80y3YdKlKAfNsulHz6bHC902YayHqikDOwGN34qEoxSYZDD5XkRCBj9C?=
 =?us-ascii?Q?cNow8vNLYRKYmE/hfRU9A7tqzNGnRIDBOn2bxHF5P1RMf4unAzG40ZI0YnOW?=
 =?us-ascii?Q?s9qt0U/dFuGp0I0bF0t8xq1xmjEbKh6bc4OuII6o951nX5WhxiPqmMYuCRE1?=
 =?us-ascii?Q?vLFvyG0Ii1LWgBVpx7r99Ia9I15+OCskKqkHWSlgDZ9od5xcomgfm3ISqVp6?=
 =?us-ascii?Q?ZDLIm3ODaIOYRJVzcoN0S5LzUqnsWCfFoL643nJ2X0LSuc59gi6UNZz5Y0me?=
 =?us-ascii?Q?tSmDA/3NV1oG2alwseHn8cHGf5w+OZc5MVy76W2yi/cuRMrmKzpk+s2EadyB?=
 =?us-ascii?Q?/xvCXCz9ZEG7J8lwmnYCaygXJ5/ul9qERJgRmDD4nVi4ZiFTiQs5NuThqaKt?=
 =?us-ascii?Q?YntKIN385VcK3cqxROe5PL9+8AqS53Y8aJZ0T7qwMtGPf28LnRtPM5rSeSY0?=
 =?us-ascii?Q?Ic8GnijHd0CGmOHaWCB+uTfYnQFYWb4qnnuMN+UksafxlEHKUWV8ZByrzmEj?=
 =?us-ascii?Q?tSKClqqe0q7U0NQTvNPEqERSf5O2GMIUS8IzaCJseCVBHIf8FowBr/pKW4Vw?=
 =?us-ascii?Q?k4kFMtuE9AFLlur1lhS98AZj4nQGFGZWbhiAMij8oPs/5dwN+kok0ETT3qC4?=
 =?us-ascii?Q?kNciuCd3yH/0lvlTxog7oQz2EN/GCPZEGccRiL9JFPU5QQEQi3mH/quQMjcn?=
 =?us-ascii?Q?K6w9Fqm3WytBDZwp68SdzTrtJWk3yWbqAGIFHeOjqwJUz5mk9hPwr9Vp1Suf?=
 =?us-ascii?Q?c1+CkHro1pQ48uHMv4wu+giolJZA9stPL8L34bPbnn3l091p2U7FEuM0Y7Pa?=
 =?us-ascii?Q?Z1q5QHYcm0yQH+T87KNsTDRFqhjsxv40MhS1DdMxME0VWprLzz1UPkEmnkAr?=
 =?us-ascii?Q?96NMzeGBF5/7LcuZNRST1UA2VOttr20fcWMt6QuqSAwuDmLwYmmF2BUvJqtk?=
 =?us-ascii?Q?PfKvAeWhNqV1ovJrvBKkC4/IUaOyaxIRM+7qog5au9dralPsZkEhKf1rdCMY?=
 =?us-ascii?Q?8PGG3BrL0kMBSo429nKm7K5kTAHaMVcPhDNo67GM2oMGoryHDSbWXohPk+KH?=
 =?us-ascii?Q?mWS8DJiMaEg5TO/t/dvYDbahk+UkXdqFmMlOaxQyP9Rw6i4Q4voNOpZ2r9zI?=
 =?us-ascii?Q?W19c1noF4RtPNBWjpc6sG+vBMzw7oUQhRkJPVNYPC2YydQUfBAkJcDB29oh3?=
 =?us-ascii?Q?n2CSnAsJNeFjFm9x4ImNSENUmIk2OsO5f/+9rFryf5V8tXUEZj3mxsC1k/ji?=
 =?us-ascii?Q?Hj0scfKSCtyVu2MzYV9YHHhqtJj21P+acMN40wjMY8fSEWLCsUIgn+IZzPmz?=
 =?us-ascii?Q?XUIx/d7hekz1pERHST9sVLhuuQSaCoJYw+J4UmUgoM/2XACQFzlmyqOYvBiD?=
 =?us-ascii?Q?1v29WJL3iQ3NdIultp7kcaoLUZfePyjolFfHoxdq15Kvg/Q7GL1PXB0A7aBu?=
 =?us-ascii?Q?DUo1jDh4NZ9IICvLdyFiIhhlOS8XOvwgrOB44c+aNjbD+HxvaPkwcaSFCkLV?=
 =?us-ascii?Q?rkGW36fphwjVGUezW4MGr+cybqLJWHeO1UCFEypLOdaQKzkNJhbY5iqO3Tct?=
 =?us-ascii?Q?2JTXHNEBGBPUStk8OSKLZMueNka1WK58ErtkvBOHHO15G43fnQQkPdp9rIQx?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3582eea-0c6f-4e94-a511-08dad415d17c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:20.2854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGU3GhbDkMjDil2V+78KJgCB0ZPLUE+wVpvoTiyfonrcFG2+Myc0BAXjmkdQMLafqv9eScbfbxAijGPHe14wYg==
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
index 9dc27e5..f670cfd 100644
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

