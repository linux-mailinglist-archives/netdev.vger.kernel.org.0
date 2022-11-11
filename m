Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34056253A8
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbiKKGXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbiKKGWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:22:39 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022025.outbound.protection.outlook.com [52.101.53.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9616C71F3F;
        Thu, 10 Nov 2022 22:22:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORhch3e2Jr/zndq+e4nA9wD9ofWvBrWhGFAxy2JVi1XosCdV+Z9rLjjYZNSt/XKRjAk467nuOWcFHq1yUQPsPV7WGeFzb1SpKMZP010xE3iGGv/MulT6363D/z+uyAGjr9+MfcJCXRenZE2Fc2IEYNjO8jIOYIySQ1xemRZwaoBaPZXbYcMLB/WVMndjre+YEw2G1RSKaUy42+ixXn9hjNYOWvdWxtXhPNMG3Xgff3r9nahk+TsV5jK1X/h9apcj9617Lp03uc8fwhUjgqn7cPAIf45FwbRMnEC3idX2ow6EV1gQDG2/pJl+ptNfIUnMAGBM/SM08ueLkxcJ4AixDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ukiq3mpmblNcB6SjkymwPbJw8wM1j3J+T3/kZJCLbMk=;
 b=NMuDSdDHt50Po7q1nQ2CmluEwQ+i9uE6AEWLSnlhSLXwhxsNtfUbTXq37xMQpzOzjYTP5okWfm01+A0qLYkM/z5nnsU7z/19xtWbg2HWaGJkk2Z8b5MUbJJxytZc7vPFhneDCqi1DWqv0ruIh3Hu1w+Df4rits7WFtFkQ0DnWvcFZLn+yCvG0ChN8qzhZXD23Cp5jRysY1cwV1SfBv6LrufopBxEqBNWgbYeUWuh2+0k6hutynV4R8r234Lras+puJVMy6Pcse3GMNV78+2KbqBLql+cygVoVAyDC6WEYRty8/nhDxEwCpZaQSUKqMHhr44OuEL8ygTkXPc2kXIUYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ukiq3mpmblNcB6SjkymwPbJw8wM1j3J+T3/kZJCLbMk=;
 b=aXFyNhJiQ+VJnQ92m26HuIfreIlyEYbw3MdKQW3tb+BGQFKjZMPgesUOPwfJ2/aKg241j8G8f0yn6tNFS9XozIzlidRowrfUDWAMLUGEaX487IXFSkdU5FNEAXk1XujSWAo3P8RUaEA/0uFor6yMFA3LPnE6KY72/eUAuBappAM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:27 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:27 +0000
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
Subject: [PATCH v2 08/12] Drivers: hv: vmbus: Remove second way of mapping ring buffers
Date:   Thu, 10 Nov 2022 22:21:37 -0800
Message-Id: <1668147701-4583-9-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 787fc119-4485-4fee-4e75-08dac3ad1ab0
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9FnQEjAqbNYCEaY2IjSG6k+uVehxqgYL4BQPCKKVn4r1l1qFhU/1xoVk/tZkkvfcezK5UIg3NC8JyUWX62rvZcufjIUteXo4rrMiAs/OodD4g+y4wAgtqoFMAovvT7X8Uf7pTgP8rgFQywNSFzRthUj6BStEwWrVkXJz8plzqY9IGDfxjFFEz9cUYEgCv4WORsLBCHciEMaMeMPW2yCDmiizVbddn9kP61docaIwWKL1krKqcnsrcqrDR0ICba2njmM89kHqc/Ow0c0O2ECgvUi4GHVr0I/kEWevGaGXR/Y8fBQNrgIMOR9ftRTXqSHZ+eb2W/isLx5AW252EhPYc32JM0SDSZxGiPghbVoYkZlLVjJVnfitKgrhWFYagBieNFp9Qiy5vKbdB5hF2/8ej4A/9CLz6nLlXC1fiw2mYVjd82/PO7j8PeExXeW1KadYvnH2AmM8cnlHQZSVowK5qshMhXkZ/8tMs1G4FmXvIJR88+ih/8VAOxEKnCz3LyI7zPfnwvlx/TvrHtJ64tTnpXHLnWIM8OS2vTD0Zifcj5fSEmH652eS/egAbliufxZwdcAy+YguAcahSsXyu4oPo6aPvDQwvKGxo0+DxrDb8B4y7DindSRYBjrcpIXBuJQZtxAm+eTrzeFnvs9Z2VzSywWJgNK9p0XdH6ql9pSXJF2To44YmIionY8HxhAV/30UdvAfkplT1IJRPBTQrE9gaucW9uyRmKet0ibi+A5M3RoFIvxlx8nojr1bxR40cCCCYFkNJU7NMuFCv5+IRNkvHbXHP5gItDtIzTR6qeFIzSxtFaIlj9yWFkzjw5IaY2F/QryQ7tTUwLHPIOtFO4tshw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ft7kr+wauI3y8EAXQxCbznZYiOPWJnrTLS/BrpzjDs6OQdPWArlgv3OO7jYv?=
 =?us-ascii?Q?f8q/21nPGHAqvLDJ9ycJ/51e6YJaI2jMTubq9j3VqNa/idqwnvPqOSW6dotr?=
 =?us-ascii?Q?xBSZ7B4EFnikZA8s8tK0yZd62aF0bAM5sDd2NzzCNnsdMyVJ9MeYCxLA51bF?=
 =?us-ascii?Q?W+tTidCmOb16TBHW3+iK3mhxPpulxD8SAzQsvcfLZ4pGP5Vq084LJZyjekgv?=
 =?us-ascii?Q?fuWuDPBfNJZswgKAYg4tcZZZEHUDvHAztqh7aZVu/nI2TakkRKM0hh7j33GL?=
 =?us-ascii?Q?qv5VdlQnxa/H9jRDKxbyVw44BJa/gOBai/6EdZURePUeBi8KRjxQ01UppVjU?=
 =?us-ascii?Q?IWvIkdo4OUo6yhkco4A8JwO6ELwD68l9/WybqXwPSzlGkbMJm9NASaagjcan?=
 =?us-ascii?Q?UPAQ1e0POnq1kLvnSA6OWK0UlgKl/gyUHxpb+ragpVHaZvdyqlg1UNctimNl?=
 =?us-ascii?Q?fiBX6WoB2kpX7q2mPsFhy8neBTUCfTDIcw4sfeZBWBzefsIzg0D/P+rAFcQy?=
 =?us-ascii?Q?6AMRj73+9bpQq/B06tQ2y28GD48u0gqEqQPEKtU1Oo/ORAbt3uD7sMHqQ98a?=
 =?us-ascii?Q?4VD9MveqNFe5Z8QumV65rpfTfnIRmVdnblqQhbNeWztSQKjf5TOa7ltOcAVC?=
 =?us-ascii?Q?2pc6s2BR8cxfJi8gJ7zvF/qaMEqRILCDF1DVO/MkqfiptvZY0QTMVu4tDizd?=
 =?us-ascii?Q?+PL2DPJ/7jb1UYJw29fPNpAmMEi5b6NKyguYInsvG51ZNehWqytMtXaFmxAz?=
 =?us-ascii?Q?IGcvzBOFNkWyJ/HYl/ajgFc6iOVyevkAI+WiJXUqFi+5ruUN2aNVsDi3Mjm0?=
 =?us-ascii?Q?GZdJQxZyi7gxjUxjWWQ1Lr4UPXG9Y/jvjAi75G2nPoPBf0Os4Y4U4SwGMvJ9?=
 =?us-ascii?Q?b3Rf+1/QmP131fnsDCyvmdeUQcrdtMvJwua8ai3bYz0k5wUELwpPxF/YjDzF?=
 =?us-ascii?Q?LKeJmvuYVFJEk3OdpPxykSUhIxhTjISJ8r0xmVX8Z5pGlBXlLE1o7eZHNSa6?=
 =?us-ascii?Q?+o4lpQuuQCHLJ2+2AmxHlxYRQbn06b9KRrKlEryIIQR0ts2e9GZKGYkJ2G4X?=
 =?us-ascii?Q?/g6IPEScR3rxiGzHwIxfNyIYEl5Wm4/D/VZ5fz4Vaf70OBTMbyZf1s3iToDJ?=
 =?us-ascii?Q?imhSVVVsF2Z1Snrl/OlwvJfBIL66T/eOXHvTSzTWC3v5ZxjfTf39Ui6vwIXv?=
 =?us-ascii?Q?lYF49LH37JArfXDxKgo4Zyj+A5mHdyEOwFJCpvC/07J8eaJnevnp1+/Yeb3M?=
 =?us-ascii?Q?/sFrpDnDIfm+l+/qkJgLbyFhY22RrEBUqVcVAdMs78hYTUA1Sk6QE8Xwe4Ze?=
 =?us-ascii?Q?iS6EN4CJe+LXGrKJUNclqnqF/+9dPBsDMGFopgGo/j+2Xg1h8yCzAd0aUAH2?=
 =?us-ascii?Q?tEDcb1TjgvZDY2aEpmf51phKBS7naPgaKzwpKpkftYOhJjOhw32FaXSDK1+p?=
 =?us-ascii?Q?c5MXTi8KGpevc7mvF4A5KaR56Nkd8oju7AxyvXr0WlSMe2F+gkSCJkDtOG5b?=
 =?us-ascii?Q?08QNnFDKXWQMIOXEblUPdhZvVXy8UFtVvxRYMFe6SlD2+FR7JKnKjPACEEPg?=
 =?us-ascii?Q?FO8vcbAzGzjfAyEYzeNSi5yjfzd7ij7NshDCPao0hqFuZMxBBQDiw6SnVSSW?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 787fc119-4485-4fee-4e75-08dac3ad1ab0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:27.3210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrs+q0L/5tzk/3PmFuBtjFLPZUMHSve4ku+I6BtwZdBNfa2jwDzujyqCn5E6doKsVkDBYKHBQtT3M4x9SiRrKg==
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
(encrypted) and shared (decrypted), it's no longer necessary to
have separate code paths for mapping VMBus ring buffers for
for normal VMs and for Confidential VMs.

As such, remove the code path that uses vmap_pfn(), and set
the protection flags argument to vmap() to account for the
difference between normal and Confidential VMs.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/hv/ring_buffer.c | 62 ++++++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 42 deletions(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index b4a91b1..20a0631 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -186,8 +186,6 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
 {
 	struct page **pages_wraparound;
-	unsigned long *pfns_wraparound;
-	u64 pfn;
 	int i;
 
 	BUILD_BUG_ON((sizeof(struct hv_ring_buffer) != PAGE_SIZE));
@@ -196,50 +194,30 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 	 * First page holds struct hv_ring_buffer, do wraparound mapping for
 	 * the rest.
 	 */
-	if (hv_isolation_type_snp()) {
-		pfn = page_to_pfn(pages) +
-			PFN_DOWN(ms_hyperv.shared_gpa_boundary);
+	pages_wraparound = kcalloc(page_cnt * 2 - 1,
+				   sizeof(struct page *),
+				   GFP_KERNEL);
+	if (!pages_wraparound)
+		return -ENOMEM;
 
-		pfns_wraparound = kcalloc(page_cnt * 2 - 1,
-			sizeof(unsigned long), GFP_KERNEL);
-		if (!pfns_wraparound)
-			return -ENOMEM;
-
-		pfns_wraparound[0] = pfn;
-		for (i = 0; i < 2 * (page_cnt - 1); i++)
-			pfns_wraparound[i + 1] = pfn + i % (page_cnt - 1) + 1;
-
-		ring_info->ring_buffer = (struct hv_ring_buffer *)
-			vmap_pfn(pfns_wraparound, page_cnt * 2 - 1,
-				 pgprot_decrypted(PAGE_KERNEL_NOENC));
-		kfree(pfns_wraparound);
-
-		if (!ring_info->ring_buffer)
-			return -ENOMEM;
-
-		/* Zero ring buffer after setting memory host visibility. */
-		memset(ring_info->ring_buffer, 0x00, PAGE_SIZE * page_cnt);
-	} else {
-		pages_wraparound = kcalloc(page_cnt * 2 - 1,
-					   sizeof(struct page *),
-					   GFP_KERNEL);
-		if (!pages_wraparound)
-			return -ENOMEM;
-
-		pages_wraparound[0] = pages;
-		for (i = 0; i < 2 * (page_cnt - 1); i++)
-			pages_wraparound[i + 1] =
-				&pages[i % (page_cnt - 1) + 1];
+	pages_wraparound[0] = pages;
+	for (i = 0; i < 2 * (page_cnt - 1); i++)
+		pages_wraparound[i + 1] =
+			&pages[i % (page_cnt - 1) + 1];
 
-		ring_info->ring_buffer = (struct hv_ring_buffer *)
-			vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP,
-				PAGE_KERNEL);
+	ring_info->ring_buffer = (struct hv_ring_buffer *)
+		vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP,
+			pgprot_decrypted(PAGE_KERNEL_NOENC));
 
-		kfree(pages_wraparound);
-		if (!ring_info->ring_buffer)
-			return -ENOMEM;
-	}
+	kfree(pages_wraparound);
+	if (!ring_info->ring_buffer)
+		return -ENOMEM;
 
+	/*
+	 * Ensure the header page is zero'ed since
+	 * encryption status may have changed.
+	 */
+	memset(ring_info->ring_buffer, 0, HV_HYP_PAGE_SIZE);
 
 	ring_info->ring_buffer->read_index =
 		ring_info->ring_buffer->write_index = 0;
-- 
1.8.3.1

