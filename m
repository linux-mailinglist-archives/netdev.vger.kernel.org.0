Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1B266860E
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240567AbjALVuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241015AbjALVsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:43 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021022.outbound.protection.outlook.com [52.101.62.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB263CDF;
        Thu, 12 Jan 2023 13:43:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S96xGx2Lh3/8EWNF3ChX4xeTNBYQDmCl3/NZcY7u9JqGiJXRw8ZdqBTwyaRFLO6poQ0N2DNa1Vyff0qyVOvniq+PVXyH4+CEVnCkED6YEJU2GSQuV63G55PgKOtB5KAAaxahIZYJHgA3ic7rs8jF/eXRrQyv6o2GvzTGjFbxv3SDGRd5ZMXjupdIRN6XUlANYnrAFu65gzd/lXgknDXSrhVfKwc8TAbVjFnX4HLwIof4FF2inS5Oc9HBMQ4QhtCfHTZolMQ7g4GHwhcCrjmsyZtkA4JnZZaMns2YybqdoqMlYxu6tZhRpzO0ZOtu4wJNvY8n7yAPUzHZD0UkQ5lJDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvE6SyTZq6LB5flL+POxNJmNnPxQpwBAtj9alMcKL+8=;
 b=gUkrTxRhAo4oBmAVP9Sb2mxodXqpNgkiy9yzZVsmSs/gSwgEFIfDIon2spZjgf5QOAtyMGABKm9HIC2fGbx4d7nHrtYtiRVJDjHOfGAdQwcv5ULttis7/+tNJh5YqhA1fkz4JyHgOxGvYbBJSB1xmeqo8LmHLs8JKInFS0OlNg+YCmV1fhssVJkV25qMQxF6HsQmR9MmNhU2AlkO0xuzEXJdbtMmr5UZ8YVyBKUXWxXI1UCLCjLrOS8gub6OuUfPxYImSU0Rba0GR5DzuyfSV8/N/q3+9tUuuWm+5tyOlDVMa4/pg87ZouO12W5cRi82QCGE1dOuS0lBqtzHD6dZvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvE6SyTZq6LB5flL+POxNJmNnPxQpwBAtj9alMcKL+8=;
 b=JlDtbCjdzEmo98KHV9x5L2M1SVa6LialBelp3If3GYpkZLjWXzSMr/uUprcf7lEH1HCyhcKYZ5mK24SqpwqLb5Vclhy5JD0GLyHxS0THPR7zWzREYUOEmo9znZrV/X3pTsS50rgi20lPR0OoMMlLYwqvVM0cDR32CdKBTuNxlH8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:15 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:15 +0000
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
Subject: [PATCH v5 09/14] Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
Date:   Thu, 12 Jan 2023 13:42:28 -0800
Message-Id: <1673559753-94403-10-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 39bf0fee-ab1d-47aa-4abb-08daf4e602ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UakiAdHDrWfFgC4MzzvP5FOwWsMXRIsgUKzavMwQQR9oEnl9lDP3yBLrFuurUjdOpVLIXkzPPeISD4Bjp3Skqd47a+ffaxdlrzNE1UZocxzW3e1Dv22b8kLke9wBgkhEvyl8uf3N9QIqqAgbReAK2FswJirNVT0HWVacH6ZcADavT6z9cotWv+egztl0EGxzlFM0lDsGdt6nwnbN/I40w/DZThUTyDYs8npvRBzGVwItXMj8IqAIBWYIcReaTINEhcOSF0bN/2GYHfQSPCQrI9GaN3LFQB5XBOACtLgxcC5aHBWbTygoYvcTy0qkPteVqVUSsdyZjKvnBKwrGvYBnpuQGRJ2URuInq/mARw1nA6vfOzUDj+cIUrbNIIwoPKPl5PdJ76SUjMZ6e6m5C/Vhy3XnELF2QQhYJugjsm2wjSuJOJTQWwbH9gIvykGfzuNc2lQsSFb0XmKS0I+vRQvFBNeFVrcYfeyKIHYzvicPiTl7Da4AlRRjt4yGxP9e8m2N48RWD6B9bIrRALSSYAi5h28Hy0Woeenra3KNA0jtnVr/e4GZWJvRZsuyq5KM8tKnfmzsQ85xzKIW75N+VCK25R459I+OjRoY5L/gpUHt+5gRwd823miVsd/zIN6YoiVOBc2fk7YlVI92exZRno3NVoFgESIiD2RJVfVvmc5PQR83gcwcaZVxsOTdRayQ7AUpoJ1Zjyiac/Y1KK5FjBYN5qBYWWwMzie0uaAOvKPeoJYYUGTAHCP6aKrg0Ad69Li
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9FI/bhWzY7970jUFdVPWCFkLeuSLTf+jOIgRoAjRsXdaOxIkX5paGkanZtNg?=
 =?us-ascii?Q?P9rdWlseOGwSdSwBsyMfz80dmyrDvrbQHpkJSc2xC9WHGgbnJv7qbI/UUmpD?=
 =?us-ascii?Q?wReL0lwQpFz8CzpOQZKI7hw+YEb0bDZWoxZJHOeZ1aNl3nd/Rm0AKncJZveR?=
 =?us-ascii?Q?UOqTKGpZfM6d7oi0eNSmDU5QMQtSrbZKjyeFSaNnusCsCNpX7cx6MQc5X1V0?=
 =?us-ascii?Q?I5wBaO+sjx0dsxTK8bJD0DBK3wcLqixG8Inxo9cvDgra7fAvb87uf/TwnaUM?=
 =?us-ascii?Q?caOONVP/UwWHggv95VUamWWyLX067tUigOOY5QrG5xwf5zH/YIwWvKPL2JyP?=
 =?us-ascii?Q?NLDP9NqDCYTUwJwWHNdB8yaUuDBM0uc64A5+l0Qwi4bXH5jbWha5SG+bL0/i?=
 =?us-ascii?Q?OrJwLiIAMNHBTEf31VX+Ra9y044Q7Z1cJB8TEwhXkav6uIj9T49e+ogywdIP?=
 =?us-ascii?Q?U2D2xojA2mBv8Iu6CiIhrbVqZ3RODYcJyZnDU1mXCzwHFDanRTjfTUPgGLEu?=
 =?us-ascii?Q?gB9NoYB8uCvXQ/TnqFDUed/0GR4jZCkaI08MpjMqdVS1dzcpDKBPThBcEXhJ?=
 =?us-ascii?Q?1vvQEEk/9Ai9gs5D4XGnirT7r+k1HzwRb2KIgBwQfMtBLl6gJyKVbmlNXVXJ?=
 =?us-ascii?Q?u6EOg2Sjuq/M7r+tKApDEiucgR4B+XxWb0EeFWp33EarsS27BswuHiQl4n44?=
 =?us-ascii?Q?JOdq6Z2F6uHQmNtfuVFKB+2RIdbm3ig4EY4AFtC21ndgAcQv2SvIuJwYH1E2?=
 =?us-ascii?Q?qkvwCEi2cuqKGNjh51xTvi9gB/SsCA43hj7SOhHSaXxXZ0+XQ/W8tMOZNcRW?=
 =?us-ascii?Q?XQYmeFvPX+RloaWGtu5vjiwX8DUnE/eAvQibhU4X1OkN8f1HNI4VDCR6G9we?=
 =?us-ascii?Q?Qw/v3/Ge/IvL7ru/L0gMRrfwbkcxjUSOMjruNPu4zc8e7UPGCv/vQFlpix8P?=
 =?us-ascii?Q?PNR10ppaeTAno3pCldjY5MiQMyl60+6OCgJ7EDvPTQjhvOClWJf4Kml6BZwx?=
 =?us-ascii?Q?IfpphFzprj3CvbcilCvrDw+7mdX7KcOBJB7SkcxvoPFy7G0jFwjk+r0+cSUw?=
 =?us-ascii?Q?8wONBohpQm//9JsYdH4rH2XuXAMVL5HxA27eSki/sxzNT7O7D0UaTCKXsArz?=
 =?us-ascii?Q?ArGhQjZHe1P2ssrPAZBFojR1At9CWCCsyJRCSP6SwGOAmeQ4H1ighDQybjyD?=
 =?us-ascii?Q?wQXRacqI7CNgeBWDSQkPoMO+Ut5m/O/uzLO2/N8Pt7vvzN5fpt1SzCfjfk3n?=
 =?us-ascii?Q?BWPk3Wdzg1/vWiTsh1yAQF+HI//6mcyzjfprXRnXA09XIsB3YLvFfAe8CAyc?=
 =?us-ascii?Q?aoWn8D9EHfDoCCq7PUfbAgCGagWde0LlAvT3JFg7j3md1RM8Bf2gQELL4pEk?=
 =?us-ascii?Q?TOgprFSQEphgVRbLZej4xZdmJXHGCmht5EV98XBEWiMPJJPlcE7hr5FUX10z?=
 =?us-ascii?Q?QF54+W1R3g6NF5yUWDcZyfQIwvlMVKEw7/D3gQJlv/D7tBEnkE1bc3XCGiiR?=
 =?us-ascii?Q?S9npMoWAIk95LagcvixosKff5W4Wcmsa1a9TTFhf4j6BO7jOBOPENEeOANBs?=
 =?us-ascii?Q?ioLOyGTGJGGSFw8gfAS4G2wRlk/0ZpjA7695Ylzs?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39bf0fee-ab1d-47aa-4abb-08daf4e602ca
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:15.4063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nelT8yHKulkoi9OQjgk/MKoB+P0gDDuuQ8Z5kBBMW5TBM8Y7ofvPf+aa0lxaLmgkFEShaJ8Pr7g6D27OgeQZvw==
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

