Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8042362C808
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239344AbiKPSpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239305AbiKPSoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:44:13 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022016.outbound.protection.outlook.com [40.93.200.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A2764A27;
        Wed, 16 Nov 2022 10:42:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ha7CP/+32QVIWTPUNrHpjkWBixASNIg2TzmXsaDFLqDlWvV+agdk9ki7QMC3eIzZ+zGI6x7I2HCNMyBhaBuLQU/k/tK5jN0eaCZxE6DfykXbbHKNzD4TnEftE43t/x8gqcPdNFAEHvhZANKVtV37p8gSO7nN53h+qWbnEyOzYlX9E2EPFO72dKNZWwdjwLrrBq+PH2B+Cu/MdSd4Pm8RxIgCojZB92bV3L+FSu0vcIxHlQpTwFQ/UxkhVlnlrF9OGlwU9RFCy4ss9Bmn5WCQesnnNhW2O0eY7kA05Jh9XGs9alhJoM3fsnF8/UBmR5LqP8TM9Yz3YzuYTmscRCUNdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgm+jUaF9HijpG4qFbxbmrNC62Z56ETkSKfonyRpknY=;
 b=lcx+g2fJHv5xGaRp7mTfbpiuo6V07LgdHPPC5nhu/wrSiti1Q6fooqzqG5Jpo/PGRJLmw52NAWJ1kQltusogxCtiPsNNCotf/WerS0wJiGjVPha2pf8r+rtgSQUt9RSnUg3DGOC5XghCqnsGmxVq6d9pGGW3g2ISPGQwqIcJWEKyt8IY3HyZaqbmz7SVXxkZboZ7yvFmBEIMbjlkPgrpkjikMwA3vowJmpAm6PTFmLd6Eurcs3OqA6uIeoq6EL+R3lWXMh4oDsIG9ZNveuBzrYKT2qqA7i9XV0uQYtvAkNXSmgItyeejRhb6mlIz3izTVIfocln97+0r5M4gpsgX1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgm+jUaF9HijpG4qFbxbmrNC62Z56ETkSKfonyRpknY=;
 b=daNn7U6jAO+wZ1FYHHdFW1GXiLagv3j1xnVdCLhdYKqA0mmAtv0/3+/2d9FP145GC4ut370MQS6j8qaq2sDInCfrH2+qhBM7Rn0U7B09evChez4XDopsv38DUwt2F+XVkzAe1UTKlls9EGOV4l8pdVzN5V5wc5QmnRZvgHoFowg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:42 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:42 +0000
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
Subject: [Patch v3 09/14] Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
Date:   Wed, 16 Nov 2022 10:41:32 -0800
Message-Id: <1668624097-14884-10-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 96e9a4f1-2e33-4059-1314-08dac802580e
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eyMYsDy9qJ8JwyG8aV7zxh5UbbBMwjPzLCxeN5blk3A4Kv1k5sAdeuZAX77YRaJG7TxJZY14dOASnU51fO/C7ge5B3nraXy8hu8vTed9GnuB9r+vvPN5kYNG1OX0y6MWRi2oJjyM0RoE4jULchc2AQOq0vYV+buc3Y8NNf/X+jQzBP8g4QytCQgnYlQNkX3A72FByrtj3udNH3lGBTVGJKvK0MSjbiZjI1B7har1kFSUzSYn7Si3b1oL0x2gNNv5M5lUzZ2aOw/MXeDeAkhx0YOq7PrmPb14yLfpNyH0s6c5jxtcNzZ4+JZ/bNhwUYzgpMR1ytiFf7DAqgo4kZLlHPxODgQbPMyP6X8Da9K/UJ02OyS4Bl8t619036bZMo+MZcrcoxClZguKlfVmPluLOjZwI+piDJsUbLah4ndIQ7d5YN7qp7txNErA5owIMzTMkGMZHEDnxsZDt17dwL/gduN3gqPAlCZK5Z/UZ9dpu+ekM21n1yQmEoq1XrqOoEOxrIO9BeSsO4sV0iRO6lGlvRsmxlX7BYLHaWx9y84vLjThX/KMHTudY1TxNq8LuPc2LyAEPhoCP45+vMFPKYKdMCMrFTgF87BWEkZEFYe0Z4QKfpj6HTKYjIxX+YAbTSeAf2GpVx1otlnQJwP/waXqCS6ziebbZOwmqgxzxpjUNPVL6oT0cNyqSpkDjFbhQTwqsNIagjTLgbw7kW1urpLWlBygjGXnIlnqxIoviRuN+SpVb4V+VWwydGMMvByomQygqtVeLJ+IsbVx+oSmXI5AW5dz/+lHCMW44cSwIpsd/s6fo3OGD76CjnydezinTUQy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(6666004)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DIIPwsl+zZpbAwiRIXWJh67yG8HB/6sqCgWPXF9Ejit3elotEDhFAICGOG3M?=
 =?us-ascii?Q?L8/ISLs1xJWlGRK9qtfjmqL2gWHJmAw+06tGzCXzd9Bo1MbZHRCfL4uCS8wX?=
 =?us-ascii?Q?HDejEXPxjSBpLDa6eERLyimQ5GIl90g9cPa01etSEo1rGprYAT3+Po17KksO?=
 =?us-ascii?Q?7wfv9wPD5wDktJjzWO4Mt21ILpl2pu0nWS2yR21hYevVddPoExOQ69atKp0s?=
 =?us-ascii?Q?icTSeKSuWgU7zqLZT8IzMurneyu549ZtDBUseM6YtQfzC5cGy0zHiJADsIR2?=
 =?us-ascii?Q?0GqggFc1atIAhmb3VmmEM/5LE7qqve3ukaSVV4lRod5gzDYWBO+uop+JTcRc?=
 =?us-ascii?Q?OcuQ8St0SjM3Dmoi3lbtZQ61eb552x3y+uOy67YYiziuJJdEqk6MVjqtbd3R?=
 =?us-ascii?Q?vBP4kXNHil3U+4O+utB1STmLKZ3jio0AtI4dRo3S2ITm46sDVboEt8Y03a6T?=
 =?us-ascii?Q?QjOwXIaCRY5P8r4myiBhx/gqgK0hyL836HyVNOkoFXkmQqrVXS9M2ax9aCwY?=
 =?us-ascii?Q?rDrgKtnA07kuEN5gwNEZ6/DyeGUpGC8b1zl++paw+gNFq86/otD1HAlxCMUN?=
 =?us-ascii?Q?u8IZp4RiwLr7NacZ5axS4nXBke2LZwBGCtQyH330uB4y8+XoDGbkk3ei23Iw?=
 =?us-ascii?Q?7ZS5xwDht9nxNcaUDLoeSaUhhamAZYB1MyMX0c/gbQHwaNvpKs4I/wVhxULP?=
 =?us-ascii?Q?osD9HeND6c9i8xqNoanRvIDkOjGVldTn3OH31SX9LT0+eCrETsv+qWmIHRWz?=
 =?us-ascii?Q?ZVWpNRjRBsQraRnFP3t1VsP47Px3ruhzVw+3l+DCUeM1RSNr6dInr3N1c0Y2?=
 =?us-ascii?Q?jOxH7d3+OSW8xQjP7d0PfeDPWygCau7gjyIkGjp+cm+XaLRIFOxIKbJqK+m5?=
 =?us-ascii?Q?j9SdvrthDEzE0oW4RYTBVG8b7Xdo17ken8L/XBfFeP5w9yOu3OLCW7T0xLbW?=
 =?us-ascii?Q?d4G4zuPs3eLX54SllsBephdcuqqXUFxn0M1BsYCIUEIQRbPvNlxndcyN0ncN?=
 =?us-ascii?Q?etDRRe3xE2/P5Xr7DHv6LR0U1WP6+aJBx82W4cIHgoKB37HFoPBRmQSvx9LX?=
 =?us-ascii?Q?vZIi3jTa6sn2qHM4s+ly4kSCARtodeWHcf97wiQGEd1C51Z+CiRX8PDVgF5E?=
 =?us-ascii?Q?f41+wDs21J/4vfUMuFretaR2XJzsJXol7buuBmGYPqDdEioTmSBwP608rkfO?=
 =?us-ascii?Q?F3Ge8540Znr5fI7ymY5o8I1AUghcFM3eGDX7Wc0wWu+EkQ91f30V4SJB5uXY?=
 =?us-ascii?Q?90YDSUU60QBdoGvf9fp/lV8CauCr5qMiOzzZvb97oA5y1xTQ8bzFHL76QU+s?=
 =?us-ascii?Q?/V4zR4LMKa9ElYjlq4z7DqTEN9UGHRvog3iy+CjemYk5m5/VEnFLTnCuZXXT?=
 =?us-ascii?Q?+IyS4HPIDx9zU6jw4ApWjccEY/179bey0B7edScioz0UlBPNof+lIN8wjt46?=
 =?us-ascii?Q?7R3+bVs5IU7rqRZfayDoH15FDI4it3vxAXrQwhtNr56GdnI3gQrWModxGxVb?=
 =?us-ascii?Q?JK1SXNne8djTd8fhJcqf0ndEFvTtPLlBbEX+8ZwPNIo1CxqL7I+EDPP7MF6/?=
 =?us-ascii?Q?Jc+fRlqhzlSNcUf5ONLUn695H+6XvU9kAE74GUGi?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e9a4f1-2e33-4059-1314-08dac802580e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:42.1181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZc917t4Imz5aXdWompF/7OYDCnUbWZQd8VM4I03dX+gdebTnWlBQRL8ie+ngGgZsVELacdkH+98Hy7jD0Sdjw==
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

