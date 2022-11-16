Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5901962C7DD
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbiKPSmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbiKPSm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:42:29 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022017.outbound.protection.outlook.com [40.93.200.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C047A2981A;
        Wed, 16 Nov 2022 10:42:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSpEwcyIQfbals4jFYBERaZfhMrlmZm/CjAY9bKZFSIYQnRSCQCR12HJ21HX0jw9gHLsY2RbLnpfDXTi2Lqx6hinbtLCDZM8Rz5AthJ54Gy0LZtugy40/jtnGmNjULiDNE2N+TKd7bdH9ifCJGyfLkBArheDgUClVs2p94XwNpIhKuN9MxsR7zMA8i12I5lj5J/VkgJN34p1pbljDxHLXFO7BHUmmPK6rYrlKjNi00/qCur3g8UBqrxWGQbyZq4J4cWjfcRA5WmqCjSHpozLvP8fViVN414G10cIhopH2X1ittNa5LF0ZhpigAFhL874IFipXXcXHykyR/NzeXsM9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Py9ZpK0xmdyoKCjyej6AxiGrgOc0U5ZWOxrEejj/RE=;
 b=dSPhDh8FP+AJTnS9fW0AY+nMkveYbkhISDmMlWLKAUzaUkKsDZUyPN37RdZVUTuyAgol/LSNVYAdJP2a0HP7Bl9FlyIZe4sM73Az4i3l+rVHhGsSRs+isr4dMh1foHSFlOXhZ6p1Y99uwV/8txeScRcrZtoniz5yGcoXtjkQwNe+Ajbh+uso3zBJEleuTCkI5mwWRFHnqh1rnlSg6PM2S8lN1PntqphLLJLQChi1KZsEzwsVIirR3A4WrVz5b+oI97ymvinemZxOhV4O9pxsJTEFqboI4masxdwgxKw0ivvF3Ht2k2/y3TWSZ2r+BGykidkbPyiw0lgGc6CE9YYosQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Py9ZpK0xmdyoKCjyej6AxiGrgOc0U5ZWOxrEejj/RE=;
 b=eF84izhtYNIIvRcvxODc2pAVWwGHJTYMfLjo6iYOWcSA64BfdzIcvo1l/5tXZ3dbmvGV+l+hq+BZT6WngOJOtE8F3N1DECdmU3+ODmTsaQx1wDvR6C5K8tzXWUspVu7ZmS/kD6Yyjk0MTy8DVGZYE9bJRoapGkrydrpizfNjcQY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:26 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:26 +0000
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
Subject: [Patch v3 02/14] x86/ioapic: Gate decrypted mapping on cc_platform_has() attribute
Date:   Wed, 16 Nov 2022 10:41:25 -0800
Message-Id: <1668624097-14884-3-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: d7187970-03ef-42c5-fcc4-08dac8024e79
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8mi9lESvgUTICpTA/FqyCp2RVhtk2PJAH5l81mO44ti5fuGxdoSzJQsRwvhTNI2JCibM751g0og71+FFr1tPRgNhjq7+J8JoXXILCqXyPRUv4QDgpY1jCu2IY58sZyChTPD7XIMQqFG5jACGkj8GP2189acNxbDGooNjLBXqtDuMu9ED17w0ORxeG/dJTulkSjttHjiu3Dwpwz6c2A8Ltjf6225OQCKx9FyZbWmG24wYstxIPebUQnLLfF9mz3oGhrtXezBHNUnvWNtQ2lO4pALxpPAgCM6X0MOVPpPVUwV1jpDfqCAHHvfBLmkEtKFLOjUjiF2OV6Nch04j22zn62BCWoNgQT/kahYl7WaMwIZ4rztxg/sCqZREqLp8vlUEbR5dMLGlhpNA+zBh2iDF0RhAT+JB6ORmnvgeMxixC0NCnk4qHNa3o/ueF82oVVvwA2MLvjF1g4A4BU0zmRqi62077+HII39yy2oxkdf5lFKG/hCAZjd+yF/LlXco1yD9P5te8t/j4sFIqBkBxNzr/PlUjpFsB3U/ZriLQhsR+MvpTJTa9lB8DbANtyu4Zc1Z230uZot+U5NvbKIl0MUQsa0UIMf2XV/g7o5Xhkqjk9jNTKt2hWrb7A1NV5jxkS0SRsK9TYlDiQdEjKFaTjXnR6o2SXV9vcfJXTm3vAU0oRWz9EmJCTnFIMI5HCjP6VjtQwiwkLbvZL1xtFXXC1l1Ru0S1sTtPXnVJl98I7sELyos3BCgOaJ8BrEGhKDWz3VENuPrjTqKFuw3ifU1mnHlk53JKSRjh/Om0Pf78Oq2gecyLDDWzSP5hDcc3MZnVXWwqFc8xlrFRjGzfmac6OHwTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g/esYkbHIzoD8DFXl5GNKKW+XYGSrZ9KL9p+XH5BIHmx1mpVmv1qtOEeOONW?=
 =?us-ascii?Q?oBlQ9kb35U56mXQzNLTaOaCzRwrU0aBaqeiIbvVIT/UQVTRv0r2JMHaBKQKf?=
 =?us-ascii?Q?RS1Q9YFlQKz/jU91JKR5qwslyNaD3YlXbxshNFNMWmiwQOK0VrHs8fyByQz3?=
 =?us-ascii?Q?g77KE/6xPMA7NgF/bqO88oihLUFZAWx1CRdCU5EIw3T1jnpobBv7bieI2s0T?=
 =?us-ascii?Q?ldBzOfo+9i1HuPqWzyWCGAmC5vq+Y7N5tpchPyWW2Sx0Iolp0Rg8Zb0G/2qc?=
 =?us-ascii?Q?KY+D60ba6tBhstOeayQlQSuTVv6A2R7hv8WDyuAGMZ9W7gFyDK5Mkg+rYC2a?=
 =?us-ascii?Q?RuQM7es+poFSDIe1gmKNeoWwgW/Eg1S17zywc3kc5RwYyZhY7aT5VcADtoR3?=
 =?us-ascii?Q?SCQzd25XGtuVGVcFj2stsnUwig4AZDd1YWxtO540aq7BBFWr45cXRjxDp4Lq?=
 =?us-ascii?Q?rLZnB77goX08d+dY0kQfySWe0hLIoX7719TurBuGXMbYt1n+cF6HIxtV+Avn?=
 =?us-ascii?Q?4G9SvJhAIaWiG7or5gF4DB8YEANApju6mCDQD9QfiYbX2YXrEPZTH9XTNe8c?=
 =?us-ascii?Q?tMG16L6oUYw+T0lBeOBtPNPvyNxtZFyrm+1vXmmok6s+s1syjpptG7OK1S8d?=
 =?us-ascii?Q?TXE5tIyl6kxxIuiEQ1zT9Dq0kw4KrMzMrq7k3W1SzXTQ11yBbJ4Zq7N9XF9a?=
 =?us-ascii?Q?ztaKrMZHkxcB2EqqoDIa9tjv4sNXLxOpDRIa6csJCv6aRyiTmOlHuia+zyc5?=
 =?us-ascii?Q?v4AOK6Tu9pdXm7cfUxtymkZY81/Q3xU14mXFgurSjPDfSxkrOUrqL5xiUW8y?=
 =?us-ascii?Q?3aAdkTTHFrojZIOHCEGbZ2h+PWFlPgzT0GSZzJT/XYlVmprwFrz9jcRz68VV?=
 =?us-ascii?Q?DcomVKswnz1iMMSadLldwLMvJR35ZxVKyT+DvumMRuqRe8us1CsjCEYU9Vg7?=
 =?us-ascii?Q?boGTNU6LRtqlSqCRO/ZcU57Gjsh8bnkPALTqNvlSAydjGmdwHejxLY/6Rupa?=
 =?us-ascii?Q?Cx8Fvm9RReKLLbUBCzcSembUR4Lc5yD41iBWaT97dy7dv1JLLw1h3Krtag6v?=
 =?us-ascii?Q?YYJIx/MUxSXq0naO+zyS3CdTjlskSwUzKvXx5KgOsF+NSyfcLqyJkKRZcTBl?=
 =?us-ascii?Q?z4ihtFsFCuJXmRiAYJ1HRCnXywRWyoRWzf7HXxiR2KC7SdeX+DvMkzW6yfZz?=
 =?us-ascii?Q?Pmicjv8eaM/gzJrLg9Z51J+kP2/VuCg/rptJPbT3ULkIqGLbgPVboUMpND4J?=
 =?us-ascii?Q?n1AeHhnwlQ3cCoGrwrUHss+CzzQI91jJtcP3HyCj3xpVnxYNdB/e5YcwlAwh?=
 =?us-ascii?Q?bnZu3sR19VU2+REbzC7OMv+sjN9Ztb92gWkQfUU4CalfWu83tD5X4oqG+tPV?=
 =?us-ascii?Q?newsDXzqhVBJpavCpLa7YU2/RRtHOzsrlSrbQp/aSscs96qRdDn145KGPXhu?=
 =?us-ascii?Q?uHrllfAhcjuC92GvYLpkvQa4MhzId1WWtgDmmk4+4a+fj4z2QIgORV4PjjxJ?=
 =?us-ascii?Q?1c98RN0qy+KtCf7116QbVOp8wQuU+LW0vJw4u4Gt9YLu0b55SOi0v+zbgBDP?=
 =?us-ascii?Q?Gqr49WX4I/F2SIg/45PtaXv2xCF38ecbBhjo2Dfq?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7187970-03ef-42c5-fcc4-08dac8024e79
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:26.0184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CL15KPB99fnDCdD1qOXZrrzJPFvClz7ETctnN+VhIZW89Ui/q8fP5+1hwFbwFJij5XNajS9EHEJDPnoAvY6zPQ==
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

Current code always maps the IOAPIC as shared (decrypted) in a
confidential VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
enabled use a paravisor running in VMPL0 to emulate the IOAPIC.
In such a case, the IOAPIC must be accessed as private (encrypted).

Fix this by gating the IOAPIC decrypted mapping on a new
cc_platform_has() attribute that a subsequent patch in the series
will set only for Hyper-V guests.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |  3 ++-
 include/linux/cc_platform.h    | 12 ++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a868b76..c65e0cc 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2686,7 +2686,8 @@ static void io_apic_set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
 	 * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
 	 * bits, just like normal ioremap():
 	 */
-	flags = pgprot_decrypted(flags);
+	if (!cc_platform_has(CC_ATTR_EMULATED_IOAPIC))
+		flags = pgprot_decrypted(flags);
 
 	__set_fixmap(idx, phys, flags);
 }
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index cb0d6cd..7a0da75 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -90,6 +90,18 @@ enum cc_attr {
 	 * Examples include TDX Guest.
 	 */
 	CC_ATTR_HOTPLUG_DISABLED,
+
+	/**
+	 * @CC_ATTR_EMULATED_IOAPIC: Guest VM has an emulated I/O APIC
+	 *
+	 * The platform/OS is running as a guest/virtual machine with
+	 * an I/O APIC that is emulated by a paravisor running in the
+	 * guest VM context. As such, the I/O APIC is accessed in the
+	 * encrypted portion of the guest physical address space.
+	 *
+	 * Examples include Hyper-V SEV-SNP guests using vTOM.
+	 */
+	CC_ATTR_EMULATED_IOAPIC,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
-- 
1.8.3.1

