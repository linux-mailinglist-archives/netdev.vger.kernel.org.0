Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD866067A3
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiJTSB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiJTSAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:00:20 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022018.outbound.protection.outlook.com [40.93.200.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4182192A0;
        Thu, 20 Oct 2022 10:59:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Am5l7j7dYKVMtiVtR8LS5uteN2+Fg9bhithuuhBVkSkRKuuoEbWoltYfVaNCCD4RuNtp5b+5N1FIgkq2t4E53WRRQVlSjql3XfhwP/PG9bHcteWbfpsVRNZ2D/eVr3hNVjwz8nu5SjB7gRoIz/wJ70iIl9hWqV/5BZndf0s+ULnRTiow5cJxSblJP3+vVREdZTFGPtN5FA43pRyCvZyAyvahpee/OIxlm8JUYf2+mBW3PGc57w5PNpi1a1lcAuzGYJNYx5QyGEERhRhoGfFnG4dhaYpDNgERgGAyXt+zaxmv4PUZED5cTApQApA955Br5KWdD+fmEk0vNAmBo7ESGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9iLJ4haHZkKLkeS3l8DGMNJQ9gab+4nH2WDd7cRqTE0=;
 b=LVK1i/zkft2/qXnLUbloxMeyHaSQBhYQSbqcgjpSF28uG0Da9fdfdfKOgT2O8XeHfAoWcH9o7hgxdEq9XtKu3M3W2atcBiBaj2pqf9Gj1nYZGl7xOvlQdnJ8IXuj/hlxIspAZ3tXJPw6QTQjOm8OUrgXKPOzNxjKZv+TKou80QnDdf6/7um18FgtuhgGY8O/60/RXXN4nZrr3+6QmxEppS/NKS1zXGGISqTOZ2UWMhYR/H8XGDGJrf4Mh+nf1d30wx2zNon+bAqzzXpfX/6us1J2sSwV8bQdtXKo8WxwjaammVNSOuwnLRVSm3JSEwtMi5fDJqrNopYJ1BHRxo0t9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9iLJ4haHZkKLkeS3l8DGMNJQ9gab+4nH2WDd7cRqTE0=;
 b=PfjIQIFlHqfKRXBLAX//uBUMfzxuEGLjh4IbiVCGGswyMw1V9TFiH1EZ96Q3lVi/RUEjX+naOuouZaO7TdLhWA01uT1fDKE+K9fk/P73UUBDvpVcFUHCXauiZec1k6QEFPrzovrYuzINvjqUs5syrJjGVJHAl3LUFgx5a9zSMCo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:44 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:44 +0000
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
Subject: [PATCH 10/12] Drivers: hv: Don't remap addresses that are above shared_gpa_boundary
Date:   Thu, 20 Oct 2022 10:57:13 -0700
Message-Id: <1666288635-72591-11-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: e116c558-11ff-40ee-74f2-08dab2c4ba6a
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dUwPyQNBaWc3JHmqGXG1z/gIolj6H1xe020Ufiju3vgYtrF8TLO0VRm9IIFzMVGBnqK2dO8CP+HaNhBjsxfUlFB0ezuhSD7TUGAJMVwYrKVD2pPQAsduN74kyoTUFtF8AC+6Y6kOaVCdiryMckAzCB0dyoSFkFjX+pXJrnwlFqKASYlGNZYLrX3tTKheFA0e972/5o4lQ+jUSxUHb0G5rz0Fow/akoszJUe61k7fyziC6GEz0EQV/uk1fNesmZsyqsI5YL9IqpsBdD6d/Ua6HVYEnMsXVzmjyvgG+YXbmDsps/mo0NJrqyFlUQ2geSqy4yz1UmFp9It+Fq8V/jgWZ6QG0vPQuneA52nWu/3N3j/pWEJhT0jrBrkTt+hJhY9yuUfzhggbjiMFgBPtxbULYkaH+4/uLwCU9uzoVKZJx9dInlTNzUIgLLvN1LiWbpOLXS48dsFzhzck/u1BWZKBDv3I/qSFqU6q4V2srgMCnZFaIU4mgrHlA+hiBbC/j21k7Tset6NigCCgIO0xI0HeVRH6KGnD73s+FK0PFpH0jylg8vOyrzihDcw6DtJy1hUy+1vOl8EHFy6hfdCbgsv9EIihM3wwQz5Eu73xm+wlyCNTi9D8/36AmJCOrWMBTretXkFwLHJBJNz/v26W0sUQq7SqH3EL3XnPF8GIg7bSGmDiVO9KgIuTq4KpDdWCh1RbdgQ+zCZM2nfAnHQm07a01/WUj9f7fDVbnnAIEUrqcK6Mbm3l3nLaz/Xtn7BYa2cgrt+DR2gmd0KC42bkfXwOvSzLgZJVHJycTqj86Xda6MY0fppqTKh0bDhAgprKVvzzsSTF0zVyBz9ofXCZm5ChbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2OL7jpywzKRe/ZAbFinLiZJWAFde+cW4qRipQLgTqZ2UJ3EOg+0UrjsZY0Bh?=
 =?us-ascii?Q?isnN+xdpKYiXJoe7VN0fqnOSU7hR3gFaxgSH7sbMFZrt98Sda/YOhvphkZim?=
 =?us-ascii?Q?7hK1xx3zBrwzhr6H/AjT6rReFjXDtDipQ4zEVKSqg5Jp/egO19I2OmPTpxcg?=
 =?us-ascii?Q?CODe/swbD+2lqZnw4grFEd+SWgxlRt2CIEnAbLZIK4I7Af7HRCrXzNfNNkjM?=
 =?us-ascii?Q?siu8BIM/J/r7y2Aktvtip9e3J8Svvlat/i/bEu+dTcNvW3GrZcj8tTf5KP7a?=
 =?us-ascii?Q?QurhPexU4X8oSL96jbTy2AEzQqVBRocY+Y2xo4ZBLVmtCP1K/aNdZmxeytwH?=
 =?us-ascii?Q?Y0I12ncQSy2WSmAL4CNjQH65ruPM6xn86yETZzFBGnQ2K18cxe2hBBc56Kcc?=
 =?us-ascii?Q?mQe/4j9s8NxdhyguG0Ab/RQmSJ7Xa4HZWxW5Two7sjUF1aH5cqB2l4aWs0JA?=
 =?us-ascii?Q?ig853Ksx3yqH3+AqbLVIw8afotWXH22zuQl83qPf0NuC76QZlSyloW8IMJri?=
 =?us-ascii?Q?2Oy5olzMVh8Pm/e+smNRJD9JvFsUY1569s6FdVIwEoWHudoC36jx5M/h5a+x?=
 =?us-ascii?Q?P/mdLufRfSHSKBjhF18c7NoxeqPRi8uobWWzXMbWcizmRuwAXN6sl1rMzuYd?=
 =?us-ascii?Q?3I6in4nyqeyGRkpW/1r1WITg8VIqT+7p6aYkbtzELhA/3hPUz1uZUTRkS6Ed?=
 =?us-ascii?Q?K8xy6lE5LyvPRg6sSc+PnniMl7DSEujT1yzGTZ+lDT56gZc2VqemKAgQpHZm?=
 =?us-ascii?Q?5MK3W01SqRlCqRpkdS4Nx1gP20KMfaAwqnWOLxcSdjDRt+/6Th8W8uA7KcbM?=
 =?us-ascii?Q?0hyf021PmBGBzGOW2XhFNmgwkw4s0UU7hUcT9fni/f5qrD8FwpG+HYLYeO6P?=
 =?us-ascii?Q?ye/0HmqxJCnR1BcpDsWXV027mwRSjBx7frYtZpT4eoOzxR/BmA9kMCcV/UZn?=
 =?us-ascii?Q?lXLSGfjz2hMMrzNyM/olUmL6fgD5rx3VFXl8JAZ3ve7No3knPk1dprROHsFt?=
 =?us-ascii?Q?xHZV/iagWQcgTKyRy6Z9MvC/nZKn165VSPyrlaTuxUwTTOZVm4pGV+BBRqAQ?=
 =?us-ascii?Q?XuzkK+HT5DkKwGdJUdNvmxwb1oGcTdQ+pd56wdqzXQwyznT5Ra2VIm+Yej9R?=
 =?us-ascii?Q?0JtCTV/ay6uaV+gRmUqjsVcsmF5UMkQkWZre+yBG2zIlH0xU6ms0Ad6644XW?=
 =?us-ascii?Q?sIn3pcQp4KRVHjfm4KaEpmVU6fF5TmEJNSDh6dyeUwjdjEhvpMI3VSrQxlUn?=
 =?us-ascii?Q?FWBElMmjjo41teQJPOWghVGpyKs4AMvkHyh3tqt1CfBIhvHGcybQjoz6b4kW?=
 =?us-ascii?Q?ZZwJnmBlPd7ZOHeUYgsu7iyJezNo0r6i0KRy9X9SfhM9OiRnyArT0JtJMBUB?=
 =?us-ascii?Q?ANKnJq9G5rz8+uubpkrdFAzzgCJQ3fWoOW+s2kbZbWg/axZmRwCukBb8jJXX?=
 =?us-ascii?Q?mORB07X5MnCjIY9RxuHRGLc68k057PXf11iuwffGAr8FCA3aV9vfU3nDMjHD?=
 =?us-ascii?Q?2bIhHOimYznTAl2dd7OwC7Yy0oopmjtioJ9q9LKT+EIE3VGjvYO1rSZs5jST?=
 =?us-ascii?Q?aQb9ODPMJsvNOg4V6HJ31DUW8FbsebYRkFzPL8RC?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e116c558-11ff-40ee-74f2-08dab2c4ba6a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:43.9731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TchAVr5jS45cg6UMnQ+S7l9SevACQOMEmx7AQdqBJarFCZZs4Aa06HeH03OevWiKvDXXkLIbzrtEHz3AO7NRZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the vTOM bit now treated as a protection flag and not part of
the physical address, avoid remapping physical addresses with vTOM set
since technically such addresses aren't valid.  Use ioremap_cache()
instead of memremap() to ensure that the mapping provides decrypted
access, which will correctly set the vTOM bit as a protection flag.

While this change is not required for correctness with the current
implementation of memremap(), for general code hygiene it's better to
not depend on the mapping functions doing something reasonable with
a physical address that is out-of-range.

While here, fix typos in two error messages.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/hyperv/hv_init.c |  7 +++++--
 drivers/hv/hv.c           | 23 +++++++++++++----------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 2977412..c881b5a 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -64,7 +64,10 @@ static int hyperv_init_ghcb(void)
 	 * memory boundary and map it here.
 	 */
 	rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
-	ghcb_va = memremap(ghcb_gpa, HV_HYP_PAGE_SIZE, MEMREMAP_WB);
+
+	/* Mask out vTOM bit. ioremap_cache() maps decrypted */
+	ghcb_gpa &= ~ms_hyperv.shared_gpa_boundary;
+	ghcb_va = (void *)ioremap_cache(ghcb_gpa, HV_HYP_PAGE_SIZE);
 	if (!ghcb_va)
 		return -ENOMEM;
 
@@ -220,7 +223,7 @@ static int hv_cpu_die(unsigned int cpu)
 	if (hv_ghcb_pg) {
 		ghcb_va = (void **)this_cpu_ptr(hv_ghcb_pg);
 		if (*ghcb_va)
-			memunmap(*ghcb_va);
+			iounmap(*ghcb_va);
 		*ghcb_va = NULL;
 	}
 
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 4d6480d..410e6c4 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -217,11 +217,13 @@ void hv_synic_enable_regs(unsigned int cpu)
 	simp.simp_enabled = 1;
 
 	if (hv_isolation_type_snp()) {
+		/* Mask out vTOM bit. ioremap_cache() maps decrypted */
+		u64 base = (simp.base_simp_gpa << HV_HYP_PAGE_SHIFT) &
+				~ms_hyperv.shared_gpa_boundary;
 		hv_cpu->synic_message_page
-			= memremap(simp.base_simp_gpa << HV_HYP_PAGE_SHIFT,
-				   HV_HYP_PAGE_SIZE, MEMREMAP_WB);
+			= (void *)ioremap_cache(base, HV_HYP_PAGE_SIZE);
 		if (!hv_cpu->synic_message_page)
-			pr_err("Fail to map syinc message page.\n");
+			pr_err("Fail to map synic message page.\n");
 	} else {
 		simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
 			>> HV_HYP_PAGE_SHIFT;
@@ -234,12 +236,13 @@ void hv_synic_enable_regs(unsigned int cpu)
 	siefp.siefp_enabled = 1;
 
 	if (hv_isolation_type_snp()) {
-		hv_cpu->synic_event_page =
-			memremap(siefp.base_siefp_gpa << HV_HYP_PAGE_SHIFT,
-				 HV_HYP_PAGE_SIZE, MEMREMAP_WB);
-
+		/* Mask out vTOM bit. ioremap_cache() maps decrypted */
+		u64 base = (siefp.base_siefp_gpa << HV_HYP_PAGE_SHIFT) &
+				~ms_hyperv.shared_gpa_boundary;
+		hv_cpu->synic_event_page
+			= (void *)ioremap_cache(base, HV_HYP_PAGE_SIZE);
 		if (!hv_cpu->synic_event_page)
-			pr_err("Fail to map syinc event page.\n");
+			pr_err("Fail to map synic event page.\n");
 	} else {
 		siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
 			>> HV_HYP_PAGE_SHIFT;
@@ -316,7 +319,7 @@ void hv_synic_disable_regs(unsigned int cpu)
 	 */
 	simp.simp_enabled = 0;
 	if (hv_isolation_type_snp())
-		memunmap(hv_cpu->synic_message_page);
+		iounmap(hv_cpu->synic_message_page);
 	else
 		simp.base_simp_gpa = 0;
 
@@ -326,7 +329,7 @@ void hv_synic_disable_regs(unsigned int cpu)
 	siefp.siefp_enabled = 0;
 
 	if (hv_isolation_type_snp())
-		memunmap(hv_cpu->synic_event_page);
+		iounmap(hv_cpu->synic_event_page);
 	else
 		siefp.base_siefp_gpa = 0;
 
-- 
1.8.3.1

