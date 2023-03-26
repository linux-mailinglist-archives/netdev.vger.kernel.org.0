Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422F76C94DF
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbjCZN7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjCZN7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:59:43 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-cusazlp170110003.outbound.protection.outlook.com [IPv6:2a01:111:f403:c111::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF6B83FC;
        Sun, 26 Mar 2023 06:59:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ievpBQnTekX7hWjCJFx8cd9ZHDTIomtdoYy1O+Ia9KEt5PDbYlQ7b8SQHVI8uI4UURwpRiMXb+TS4ao5Y48AhLrSOmx3yfHcPqtt8KiSgAkjgtVeUvMeWQAffrQryVPTzNg99ZtYBxL7qo9IlQhpiu5drE71MqculvsoXfpdYH1AilgDxktDd2QImXXkRRVScGd+sW23dD25oODaMz3Ciz7y5isDPuWSZCTTqyvb2L2lfD8UM920rPLLQxit6BhOl0I8/gszQDxK/js0RGoY3dqi4Gryf1mFzLRuJN6LjuMFs2wT9KFaRBz5VYb2YRgGhDr/M5tZnXu4xuZmXYlVVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vEuH5Ee28VRY5Qrxd7yqx/QGPvZZfqnOwBt4Yd6S1g0=;
 b=dWdRcujJ21Az7ioDbXrEadTgfmw66mXEmll5LszFJ21xFkBB4tIVO1vbEmFXE3F/FNAnGxvc686A1Oq+ysuqW67+36bpQMh4uuJIM71OrvU9h91Fb62/q0YXbmqDrKz/cwnOEns8vFsmIW+83OADpIX1XssbGeGyDWiAm7jwRIyXdRtmPPPuNg8Sf+s7zPDLjNyYk/5ec8VZYgk4AaZ5IUexSkmwQhN6Rod6h8vFs8QSUJ2jHyZkSl9cNjco6zSWWyGgs3Vr+nBmJ+7kprX3PzoxhNXShUjgeTAeGN5cch9IJRGwqBVis0VggjBhZL53IY9c77rRhU9U241SEwqnCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEuH5Ee28VRY5Qrxd7yqx/QGPvZZfqnOwBt4Yd6S1g0=;
 b=ZexElqRB4DpKRM7cul/vFSyfd5nbOsEDe2RDqmJ/FZYmZBwjpeeqm2TxTX4ww2IQiOJEr/V75YV70N29F7Jax9R85GJFzFceE7GF7hGZwGSaMU7++hb1HeBdhKMOK+3SqV6q//8PcpV5Dv724r75JXiEnN+kfZlOiUznPhh/ctg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB2001.namprd21.prod.outlook.com (2603:10b6:303:68::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.15; Sun, 26 Mar
 2023 13:53:24 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:24 +0000
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
Subject: [PATCH v7 08/12] Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
Date:   Sun, 26 Mar 2023 06:52:03 -0700
Message-Id: <1679838727-87310-9-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: fd8408d2-7b47-4a7b-0a6f-08db2e017783
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XCqfV2uMP4FOtfwNua2mmFaBSI4nrS4YyysXmn01wVxeQRaC0NcCqdcDUgkNeLqCXFdFAjlE/RAYPq8hlqFUhaG2Ma9FlEozU40ztJNuY1eTMcsPYm76d4GSayGbhGHrycRhkn0BLt/5PYXnpB9QwuuUYxwNm75vjJBrsB7ytbU67n5gP007/beCTaHTzevCJ63ZOgV3JTDmfZcHFB/Yljio43scp4YQsbrTA4rOis5+ooFcXfG1mI9Lcr/o6V05p4pd/VanZrhOKdO3K1lBV0Y0T6okc14ggWoXdS89dfjrExhHbici6JO3gFBwCiEH+5lbb9coKwLmop75xKVuiscfYv0phutbVQS3BsjFJN0ohAfXByzNBnjqMuCclR5Q3iBbU28gLTpO7pqYfhu68Sxjkc12FxGLCjCallLJa/BqvUoc0Pp0dRBFFgV6fic1QF+PqC2Wi908GudXvJvosiwesgaE4eZqtklTxUZouwxUXcB6SSge88arrvyVb4bdVPB1bDnfhWwRTLRthDhO1fP/pu3vlEM9JwxrLoGxSQlBcLtocW+/lqw/Rj8qe+8HPyDgwfZ2Wm3Ca9u39LFnyuCYLc2jAafSEOR9grTMDL2hp1BTo8PntaMo65Q+zyi3Dfu5ILzdhEm/kgbYW7kSwkD1STDp7tMzhiA20dbofXyaWO3NBAa5LIE61xJ/uFk2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(6486002)(41300700001)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?alNfdmPcT0NBrNilNPxY+dJ4TQ8tBPZuWks2MaCiAqiscCeaz2xRfgSfV39r?=
 =?us-ascii?Q?W82dH9I73QGyPlCcMSC7SY7w1duu3lE/JaJS4oy79dLuBiOOE4c3XRtXk+74?=
 =?us-ascii?Q?Z6BH9M7d7v6GDZ6XjqYbNnAySFRHi8/bL+YPchDVbPEzJwf3OGEy4ntCcxmO?=
 =?us-ascii?Q?2wcCa88ZeM5X1JLbQtzrRBDnp72SYt+2CalVryjW3LmGhRLcggR+atOSdl0y?=
 =?us-ascii?Q?Bh9SVUcVkEUm+aFhYzrrqHQTlchLkO/CYU13q8l0OoqzcIPmYghajUaz83vC?=
 =?us-ascii?Q?wVWUaiiHrrfQT2N5XiOQNKEYMBnHYe60CRGcpK7uCU/qeyrLEiOqtMYZm7Ae?=
 =?us-ascii?Q?DxM3Sc2Oe8F97bR53Qsr9rnRMMnCYXtelxrM49fRPjM/LpC/HYV1/uM7wz5g?=
 =?us-ascii?Q?crQjXPSswKudfDIwYtU0GBWP/+VSKL2QNp86Z3F+9aA5Bkdjx7jsXpiCE23K?=
 =?us-ascii?Q?+osDZCnK84/Jtf4YCiWrMow6JVxgVOwv+PCXBhQt4hSWgi3LjICHXU3X7LDZ?=
 =?us-ascii?Q?PcgPTD5p+6p3UjBe5hRJRyQBAmFW3BC1dAusX8aDZUmg/mwnYwLyn3hcMTmn?=
 =?us-ascii?Q?PPQuBkROkZIylPkY7MOPiMgVdPxikh+cPJnhYMauX8RHHVJoQRmx7bzJQhnK?=
 =?us-ascii?Q?AJ3Jtdz28Od5dgRvz+Hmnie73cznlnxj07+fkOGlFaS8L7O6+7jQjMGKcCMh?=
 =?us-ascii?Q?Nk2G95wYONWuFx8QrMByZnLhuidTj84kELT0rCsUEhA5BOgxMNn2ZgKsOMx5?=
 =?us-ascii?Q?6Z6DvhU/thYcbXR5PWj2/YjpK+5qHEzxVogBUaCOiBrQYI8whCqmEAhEecgG?=
 =?us-ascii?Q?AxC5cx7V69UPwzPc3OPAxnMFe4sEEMvYDHRFkowkTbPJFp8P3cEZgCuxKlEj?=
 =?us-ascii?Q?9aMFnx62TcLsv+Emtt6xWtyrdgV+l0zrAKMaun2bhAFC9/zTq2juyHpDOic2?=
 =?us-ascii?Q?lsKOwFS/IXcOOJwZuAimm4qkSawybSbhn8NItDelo93t3OF9XJDMrKoXRIaM?=
 =?us-ascii?Q?iV+ll22R/jMLA9NwQdlF6ByRGfyhcqUUgMmC3FvtvaZmhBNQhdqfJIZmk7C6?=
 =?us-ascii?Q?2GLXHPpr6zB/VxXDNBMYAkJ0ZpFyoIKn0Y2PEbnyvtQWC0sUrLfYV/hVTG+8?=
 =?us-ascii?Q?nrcvfsXc/ReJqs1c5S/0fWnn1hjvdYgGztJwspgbgyWlAyDHUd071Bz6YGxq?=
 =?us-ascii?Q?XmEzIO/iWuEVVrxcBa2kJbn9xTphYQn00DQj3evpphk9xwmnYREU1Gw04nTq?=
 =?us-ascii?Q?b1yh6z/jJzoJSSqu5IfCv2Zd4EuJSqxsnCFnqThbnRtkXoEYML5odwam1a9h?=
 =?us-ascii?Q?GEPT7vEe8z7JHazd/R/cwxYoVdgCVOhI9w+CPls41X3Stlyez9YboLcpMwCB?=
 =?us-ascii?Q?HxeFRjDuw/qfz7/oo7YWDVAFAMCtjiemJxSUJrNza8S9rSSY0bWZISC4cTMS?=
 =?us-ascii?Q?tYJ7pe+YZ82I2t0p6+whuvM2W74zpbg69r8WpbGJx7i33bveRv6JhghtuDPk?=
 =?us-ascii?Q?vsxz3iVY7VSRGy4qvUYuayBg0DL2Sf0LQDdbztvDKO0zQyTV/TsN5P1tzF8x?=
 =?us-ascii?Q?CKfDRYAQqt7A7p9Ir2BawqxDkxLb07+UijIPIBIi8BdmJeuGYgcPVO20RbSd?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8408d2-7b47-4a7b-0a6f-08db2e017783
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:23.9359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B0kcXYX63JxCgZUC7moEWbRWIXK1Zt6o0x7xs4d+tPWunjjDSIpLPSSqO2BT62NpDwgNLtN9Kd/93GO9HDXRng==
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

