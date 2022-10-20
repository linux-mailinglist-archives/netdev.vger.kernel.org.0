Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6316E60676E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiJTR6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJTR6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:58:30 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022023.outbound.protection.outlook.com [40.93.200.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0405A199F4A;
        Thu, 20 Oct 2022 10:58:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmvhNkBCc/lnveXm898BUcfxzo+nODD77nqIR1IjeQofUMNxf3VaCsakcfoqyxf7DxTXZ+n5yQJAS6O6zHiZAI/8dW3478Q1nuNFiYbo4Bv1S8hNPIBKGN6NRSDl5/9B13TKq2aJ9yHs4Ssp+KH+ZoCCBsZtCuk6ohMQE7S74RLVstqPOPxDXFzcMzbQREAZfzFt5lm5GC1fE6i003ypH4tsD19wSnT3XRtaZBvuvxsDzCw4Pt057tQULP+os0WTU9x9gVufFSrjwKAibri1XinMO9/IsMq1XBATrPMG18+0mwyoks0AMqn4CsCQXC7hTmsGf5tL3ffcS3YW7aI8ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPFQFBJ2cy3ptAG94AF8myzZ+oHcLnbdNyGAmv7MIzY=;
 b=d7FcQtP9aXY5P9ZOOxHyeTUJVV+ZD+Dfu469/M9/HmnMfxRQH2sZ48+5aCfuHkXt8P7IsC7bkWhZKGcOkyYDjZy92fTdV+RF1VcYhk5n+DqJTCrrF5UAxhCF2GW/P40hb7OL12TqJka7gRI9FEk0Y0FBE+zPKZkzuBraGqcEPJ24tqfNQhm2/an1lNIVfZbeTEypquIfw6JgAij75LFcfguuYQL0R6V9bVa8YtlIzQO2kSNFH4FBIsRmMOKQYKyHD3oob/z1/rf4bPPIqrMsKFBIHrI+5XP9ssKqAJuOzbZVXqptp/yd/9Tsn1Cqyy+YkQ5ZXNgXr/rkrcn9T1MVcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPFQFBJ2cy3ptAG94AF8myzZ+oHcLnbdNyGAmv7MIzY=;
 b=IK1LYIczikzzumQ5UAp4NLuHNcIil/+RFAS/mN1XXqZVSHjrCf1MswMZUzjlS8eriEyuCkPQgcIzSds7XrwCttER7rgGIuKJiItP5EMjAGuzvqKOz6WEWpDcXECt9npN5kALyppnaTeA5tEpyAeofe1SH3Hqa7SDLWsFQUPcbV0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:25 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:25 +0000
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
Subject: [PATCH 02/12] x86/ioapic: Gate decrypted mapping on cc_platform_has() attribute
Date:   Thu, 20 Oct 2022 10:57:05 -0700
Message-Id: <1666288635-72591-3-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9db358de-a263-4117-ea11-08dab2c4af91
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zrSbdrQ7y7RyiqAaqk7qcG1PKbmWmmf2gZiH9JgPp7x9L/b+dHabbn7UhxIvsSGy+Kf3pqUalakPxrpRSwnFtYps5H2J1BK+gXzKZCJNODkLrN6H5SjLoZcd0fvMJq7o3V+3pcRdo8NKAf31d9bL14Dt4WwiuOX8ttRYAqXeAMkkYDrnxCxfdJnBFdhaVf2Q3/5v54nr4dBf0H65yM8l//QhFOE08AVijosBg8UbT0cxu7axDkxi7bvUUB8GaUUIUPc/jPfxhEZbD9Ny+3rmM94xAJTTCObfk6XuvhD3Uj2UTalI9VCK0tYMF0af7ZFVmFFaRGir0XLNpSnXVHojhnbykxvsgs0vU8ifExrDh59pHnV5qSOhNPwwMxjklY7VZENe9lMzx6wPKM3BTMDA0Ea6P8CELyHjH5quDsncIquy7j4LGKnXz3nXDvaxoVeKUlb5Dqxh+mZKJ0622z4Cj4eVSbAi/E/yRu+veVFnRvpUq47T1vQbuj1XPUiDTEvoVaPdvIMnfwLbQ1il4ZS3b/x2bH3V4KHqZNcVLtdsz7aNlKPBSB7X7dSZUdalKf2VDe9TOAlbtFoofXFHUqFWvojf7msiLNFx3b9Fby9XIsncAgawYrPf90SORi6k8EQGxPMtDeRjve94PY8LryFiYQdzZKt+949YwzF5NtszmsBJVFZ2ODyf9YszZfUBRQdeObHwb0oXYQ3Y1kDJjmXh8e6PYrdu2YHvalgrOheKUq0jvWfSrbXcPi54k62LsgZmHGf+iKdxMcbURDW7qoePEC88/i5n7Xb77nJ1+z/HPGy5z7aj1o0zBDq765pTQU/FIrU3J4zBldhak9vZrSqYJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wgQ0kXLr14ZHtrrea7b2Cq2FNSjWvg+I/OxrgKVpkgb16N+qyurJ2oAXXeN+?=
 =?us-ascii?Q?Y/wrjSN1f5sJmzBLYcQX8Qvx2azYJ58Xytqf2Yz7Ci+uw8LSHafFNgtZjifF?=
 =?us-ascii?Q?SVTzPDlaL1bX1yIv0Ibx5W9RlzY74JRo/1pyrwTwZQ67XpnlkiIJ15suPCzA?=
 =?us-ascii?Q?2kxU6Yv0n4ttumiQxstUo8pxzPnJJBXfntYwKYybspl+0IuVZaryVXHhWjV6?=
 =?us-ascii?Q?9wkX2eQMwk3anlDXDHNmzsh5f00x6GMXQhVzFs0qtT6sGJHJfuIdcnenZAfF?=
 =?us-ascii?Q?/qBXV6VJrvyeIe2cOvXBUcqWXZCTICoSzMMTKszQkTw32cpS8UIL7395LGRm?=
 =?us-ascii?Q?C3FkQ7YgDqgsH9rLokwYnLQ7+3bZPz0PIJt1IJCaswAeyDlHR7sJNMqL9bmG?=
 =?us-ascii?Q?88mTaEUpcEPRZy/E/0RPAc/CR/VwEdzNMOSPHFaxlCmi6X61gncc84LEbs8w?=
 =?us-ascii?Q?QxRzBlJXDHVGaLY/QILGKK29ORa+EnuQZ4f1RPRPU+pc91ro9Hw7HfQFXwM3?=
 =?us-ascii?Q?Wwd7+yPzLiXLQ7tcARrWrUBrfsI0aS3+4GhNm64GHmLdq1CxuITNAKG8q+oE?=
 =?us-ascii?Q?okVDVshlz2JmEdoy9yA5+Y1PlDUjXf+pjKW/SreGJx8IQg+LaEEFxRkaBqoq?=
 =?us-ascii?Q?gTNrFWqCGM3KIWfGbatlzMyPLaGJRLtWPdXUIsNj1jTyp0D8dJuOiUBZJk/6?=
 =?us-ascii?Q?XExAkOIe+rGMK5Bmh2loguFAya3HyrLFTXxMD6T1/NZ3sK2iqXMuu6eA+5Qk?=
 =?us-ascii?Q?0EVNTwMz2Fr4cnSEgXwRPzCnGixHCdQHR6zcHJOJt1AW1VgOyDN4zCcctaOS?=
 =?us-ascii?Q?zcEH46N5LwMu11F+xvr56HTuYfisHsL3NpRSA6qh6vGqiLaM6W+oYZ+AkQcz?=
 =?us-ascii?Q?s2nNvW3TuZviZLIBe+5vVTrl3R2cVuEEyb25Xc0Zc8XUUhLBmcN96KkZPTBu?=
 =?us-ascii?Q?y9Jchdw4iAAaVzEjMKwQxrywBNiqOEN3n9sOqps6PoTGL8ylRDbvRtdSbwZv?=
 =?us-ascii?Q?BGmJSHcHzFLV50Wl/akk10xxLe5lCkL4sNNq9gZq0X3HTOsf26SHKFrYVN0X?=
 =?us-ascii?Q?SPWKXoP2Fu+k3Yg0UnKVyUecwYtoe8XuyeIgrK6Nv2+drhwLpaAVkv3+20Uf?=
 =?us-ascii?Q?HJoiXIMkWnw6YvDOx2Yi6FdXxcFazX3NgHBWHDckRcejWpxwb/8XLjpsX0mR?=
 =?us-ascii?Q?1OSY2/ZH8lPsqxQmFGxh5GxvHQp6d54RT6P4Kzgy5wFMNZnz3UBENRa/K37S?=
 =?us-ascii?Q?VGdJzXx3LDtpP1+jYcoBBqSYMthVHpx80EjGjygYAzzyGM2kh7OkHAm+u6Zu?=
 =?us-ascii?Q?hnRw8fm3rHhPSoe8/F7yHmtG0WPD9ZM3Lqg3W+DF0MsnrfaNfifCENlnsBC6?=
 =?us-ascii?Q?q35lwXKODoS8Dt5xOI6yFZHAymG8IgB2nRoGhHImNopHug9V78gI/hQCujUd?=
 =?us-ascii?Q?Dljqnqaf+wrE4aYdmB0wX0wGFiujaPkIWsGuocfHr9mTJLzdljwxEeCRcsn6?=
 =?us-ascii?Q?0Sw7zGAtWViCc8j2eKCIgjjAZNqUpmq6NKSWX2WTvrpol1NDbe2CwgimOPgu?=
 =?us-ascii?Q?/ZuEvz2VDy2t/gtobOkUdU6Zug8zkR//JUMenBIi?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db358de-a263-4117-ea11-08dab2c4af91
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:25.7455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Y1g9Un+cEQ2h7ORI9rfj8GXvsXH6+d/F+/QNpbKmVZbuEbrqvIrhWjQENud+dfpZjAUosbWwKGLL7e180FzAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code always maps the IOAPIC as shared (decrypted) in a
confidential VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
enabled use a paravisor running in VMPL0 to emulate the IOAPIC.
In such a case, the IOAPIC must be accessed as private (encrypted).

Fix this by gating the IOAPIC decrypted mapping on a new
cc_platform_has() attribute that a subsequent patch in the series
will set only for Hyper-V guests. The new attribute is named
somewhat generically because similar paravisor emulation cases
may arise in the future.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/kernel/apic/io_apic.c |  3 ++-
 include/linux/cc_platform.h    | 13 +++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a868b76..d2c1bf7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2686,7 +2686,8 @@ static void io_apic_set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
 	 * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
 	 * bits, just like normal ioremap():
 	 */
-	flags = pgprot_decrypted(flags);
+	if (!cc_platform_has(CC_ATTR_HAS_PARAVISOR))
+		flags = pgprot_decrypted(flags);
 
 	__set_fixmap(idx, phys, flags);
 }
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index cb0d6cd..b6c4a79 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -90,6 +90,19 @@ enum cc_attr {
 	 * Examples include TDX Guest.
 	 */
 	CC_ATTR_HOTPLUG_DISABLED,
+
+	/**
+	 * @CC_ATTR_HAS_PARAVISOR: Guest VM is running with a paravisor
+	 *
+	 * The platform/OS is running as a guest/virtual machine with
+	 * a paravisor in VMPL0. Having a paravisor affects things
+	 * like whether the I/O APIC is emulated and operates in the
+	 * encrypted or decrypted portion of the guest physical address
+	 * space.
+	 *
+	 * Examples include Hyper-V SEV-SNP guests using vTOM.
+	 */
+	CC_ATTR_HAS_PARAVISOR,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
-- 
1.8.3.1

