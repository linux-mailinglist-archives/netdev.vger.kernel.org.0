Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBE7668604
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240396AbjALVt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240917AbjALVsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:38 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021027.outbound.protection.outlook.com [52.101.62.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63A7138;
        Thu, 12 Jan 2023 13:43:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBMy1djo+Hct4j9CPHErVovksv0TZUyJPZa1FpQy3t0nuAuecHM4r+zvTHgvuJO++aZpvkVQlxTdd5bGx3RDfJrC0PAPSIj8YfpuVsVg02x9e5crE8IPIZLJSbCCxmfEhVNSCXpW8YHekZBtc7akZjGLuMsXBGKV/gxwZeHG8QClM6tsT/8muYqp7tlRSIpTZi9lGjBKV04fwwLj8HWZXbuFh4XdkL3ZirJ28vSogxbYrzyvkUdTBG/EBZirr7774yFXZlvy/K/ISQO4YwpqBMdkaAszc5oPW0lhkFIrMkaZEE0r2+kp7nu/w6YBo3kPN6dP3SCIgqupBAfwQX0qIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WMpXjLd+UjKJmPXYudC0MTw+Yv2SaNNAfvRbowIeYws=;
 b=et1NSPg6/TmRKt3RpdbQTrc/j/9MGN0M68mU3WEU0qjf9s97vAFuE8nPeUSBDSgkkQEZ7/8fRj27yD64FXRZoACNj6i1VFYAPIi3ByjJbxuk3UqBCPayY9FOyPSzeEN2opwxU6KG5XzlyguS687NHb/jv1Qin+xruXPls0le9BsA7K0CElFiuomqfkfQrKJMA4MU3PhNNNi/BKwVmOID27i/W4m0XxD+Ivc4G4GapuPbRIlIjKkF+pcbPITKlbPBK9qdpxyx8ASckQyc9Co2oaE9kVfflGiKtP6I3n/glA4H4XcTHBK0+Vx4PrmTCk7P7whfZJEyeRv+xdLaX7LDsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMpXjLd+UjKJmPXYudC0MTw+Yv2SaNNAfvRbowIeYws=;
 b=LUQXRwjatbHT5murwyU6bij+uBmV3BE1eW84NGIWOwdklPN+bYKGzNOlzRR0b5Bnu0K0ZW8/eK6afVSzSDEx3ZW2NNxQTaXcmk6YNnPgk99vo/OcB98/3Ze4Mtj90krBjjzO8h8xTF8SB7dbG4lsMI3+SyRxY/9KyTIUDIk4f/I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:02 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:02 +0000
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
Subject: [PATCH v5 03/14] Drivers: hv: Explicitly request decrypted in vmap_pfn() calls
Date:   Thu, 12 Jan 2023 13:42:22 -0800
Message-Id: <1673559753-94403-4-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 36ca748f-9355-4c1b-f74b-08daf4e5fb1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TMm8m8T1LzkFPnS/GK6umfT28POi/+i20GzRzUDn3WpD9/HuFfZkHtX20P0gDn0oThsVRLfLS2Kya+V/axbtv6Sx+AQv+mVrprGdDvDNiTy+BX8Yy+EVyOUz3UXplYiDXvieLqubjQJrxRjsJXIX0Heg00X9RRJb15kRUc6KCTDv0dingtgEOAfZDc+N4hj0huEolRRrDUz5hd2aMBKT2kioyApTs1pRBkyN8BWlBE7iWHzgKJtAHP+pPPe/n/zz3GiXFHavKd2E1yy3zuwqSBSspQ3d4S7SjGkKU1BsIgc+zjeAT3ylD/m/lBwDl3vrRG9y2dp4MrxGrd4EjcDcygczHArFfn2heloqtsviOeyfSxdiFXhQyACq2sakcyUe+XbFKkIZmNYPSCbsMCyGAJpnLEw1Q/5DmRSq9ms+V/av46gqgiSgM2E7BDcLIeEqSkVQnvQqGDQhFNkflFZvZ4GOM+cmQw3jpYDgKpuedqgmIvH8fGjciwlS9XUuUboM5VhFDbRlRb4eqdL1x5ZJgSojjwbZAVUK0+XCyP9xvpXuVxTAEmyWiTY4l+DpcPt6x2k5PxIX7QGuEcOXc1dCja7YbJ+cZeDEnoshwNIZ1/TbXvg7UI/0fH5/CLDBPWBRI2xMDUiYV+drQvn8VehKK575VnCVcyIAzks4XkbLhl6ksHjbef036KaZgIUGo57/otG38DGpWsy4NIKIPvUBFXqT6GGjxzSnyHfk+JCkP+VPQCS01R0+iETsWIOnSk2/cgCMd9QlmOGyP7S3MdnODg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P7l5wDcNXRhBXdKKx4pE1/Lc2RVJ2J10vyvBMddKkYHoxtMErZXHw/d+98/U?=
 =?us-ascii?Q?xv1nFK2B82sjPmFzZpxexr9+NffPNa5an2KRbLdiaNkJHpn9VzsKwywW180i?=
 =?us-ascii?Q?Eu7+IVlH4yjACLW5DiwX0TecK7Lavx/5xiPWb62HmGdSc0W/urFEMbbJA+u4?=
 =?us-ascii?Q?Rwv/YKD4hY2q1aKnGCOjVe4mBspcr/5o7vNan5SodY/ZMenGOsCbVC2Vbzca?=
 =?us-ascii?Q?v7p9JBmz3H/QIZXoY7qjb+caK2xQd9Tam1Kk0YL34hg6BmIjYd/SAaW5ImgJ?=
 =?us-ascii?Q?ek9iJILeMv7N6j7G3X/Kb2DhofSleoE4T0RsliPiPT4Q3VWuuliNXm1toeS6?=
 =?us-ascii?Q?jJLq0an51xqkFfhaAaGQK7NIbYYgk/wuu19Oajzkn8g+tNTSgrB+DO6Xc40C?=
 =?us-ascii?Q?avz8c6JDX84MZ/JdTatEcBkhGCxUtuS8uiTcPpsHhuhpcQAjbcSmatYwYHvf?=
 =?us-ascii?Q?YPruc9f5rjgXXtLCF2HyZ3LR7XjFXnjEEPq8Tm05yv+NaszVJHLx1rPJm/I/?=
 =?us-ascii?Q?yb1TcynB/GvpG7HfuLpqvGE/1hT1OojMblInMYxaEc/BDbdqh1MHLxKtm68l?=
 =?us-ascii?Q?b2TvhAL9TDGjXWrOZyhhT/YlAfDlR3+kqxXRgPROGZ5XARUwOGQPn49JLOgc?=
 =?us-ascii?Q?GF7SftWByXBuzj7At7msQ3QkD8gRjUgZntegU8gn/Sc6J3xcwvB1HkTchV1X?=
 =?us-ascii?Q?JCVw5jYQZGwYmqP50r8M6kYayK+0bymAUqbIq0+QtvDOYMRUEe7JNOGv8pGW?=
 =?us-ascii?Q?oMJivwt1w4vWRH2oSLtGe+NZRXZFzY7G4h7jw7C5SJnVHN/Hk463OBXlgOtj?=
 =?us-ascii?Q?QNikQPBWAERnGOkB5WH7Oap0wzrRKsBiBKG50xKo01BQKaSd00xhTg1IE36H?=
 =?us-ascii?Q?cN+omDenmwOVjUGzfOsIdPrvyjRjsdC1eJfwuwAKkh5ogtgbwYdkRFYePja6?=
 =?us-ascii?Q?mjG8eSm7e2aBOLEnwq+W9pvmo5GxUCrYlvKUeOwKP1lsUjeHyzduKBadvdPE?=
 =?us-ascii?Q?Q5XvLnZXni9ZAY91wwU6505CsEMHa2/DMNrfaPOhc/85aaXpxgk/CiMg7ZGm?=
 =?us-ascii?Q?/AUlUhIFlGsAQqxLcrdHrwIqZg/uQOwkdPINmISZWn1ZRtQ4XXnZCMv9PxDJ?=
 =?us-ascii?Q?w5G2vJZp8s0BS6z1FEWjNLw+rqzD/MnZe636Yf7KGrzgL6fztoMA4T3G7rhO?=
 =?us-ascii?Q?dIf54X756mbe45g0oKihpb1KTmlASm0Mlqglm/151SuTDyiE7UWLwA9MSHKr?=
 =?us-ascii?Q?zRRSdYUm5rHCl3i4sT8KEScGaw+qkJ10IdMrgKXpmG2LnQpQZhUOZmBq7YAf?=
 =?us-ascii?Q?rKN8sypfBQFPAZG7hZLwz/h190r1v+geV/ODkbjAtLFMkpI0GyvoTxdAB6vY?=
 =?us-ascii?Q?H4pH7W+QUa+DtghMgqUWmydqXvEdyNFM2+27cFlLBGTj25R+/Folb7CNH5N7?=
 =?us-ascii?Q?qK54aJCcj1jsB2IesMLeW+AtrsdLMYNuK5DTvdVXM3xXB/DBhTH+Ru9HMphN?=
 =?us-ascii?Q?prINsJ3bZcixupHvqB+P+DsTMPEBC7d5gXJpj1D4L32pJcRdMQxmlQKbUJK3?=
 =?us-ascii?Q?2agSwy4CRiAQpVLIkxtOepG/FmHfEDpCPzaeTQOZ?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36ca748f-9355-4c1b-f74b-08daf4e5fb1f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:02.5473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n3CPEB9ICxjpk7jpfn2zQRQcSgFfJeoUp6SiwrPbzmWwKvfvD1gjQWiUKBomBZ7ThfU3kVxas0XGh/BqS0YLcQ==
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

Update vmap_pfn() calls to explicitly request that the mapping
be for decrypted access to the memory.  There's no change in
functionality since the PFNs passed to vmap_pfn() are above the
shared_gpa_boundary, implicitly producing a decrypted mapping.
But explicitly requesting "decrypted" allows the code to work
before and after changes that cause vmap_pfn() to mask the
PFNs to being below the shared_gpa_boundary.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/ivm.c    | 2 +-
 drivers/hv/ring_buffer.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index f33c67e..5648efb 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -343,7 +343,7 @@ void *hv_map_memory(void *addr, unsigned long size)
 		pfns[i] = vmalloc_to_pfn(addr + i * PAGE_SIZE) +
 			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
 
-	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, PAGE_KERNEL_IO);
+	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, pgprot_decrypted(PAGE_KERNEL));
 	kfree(pfns);
 
 	return vaddr;
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index c6692fd..2111e97 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -211,7 +211,7 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 
 		ring_info->ring_buffer = (struct hv_ring_buffer *)
 			vmap_pfn(pfns_wraparound, page_cnt * 2 - 1,
-				 PAGE_KERNEL);
+				 pgprot_decrypted(PAGE_KERNEL));
 		kfree(pfns_wraparound);
 
 		if (!ring_info->ring_buffer)
-- 
1.8.3.1

