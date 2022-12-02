Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA1063FED8
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiLBDce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiLBDcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:32:15 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021020.outbound.protection.outlook.com [40.93.199.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0916D9B39;
        Thu,  1 Dec 2022 19:32:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcvcUcxGHqP+bRG4DXN3e8wE7xKIzxxtx6+94IoZJCpVWPQ/Be4USKZLx/7Uta+xTCq0OPbzFEee9GSjfUa0Yh0d9e29PwJZyGr4AgOaT52C4BiS9UdVwc4QK9rFQHg2rHC7EcCsG0qSt4iAkMo1Pj7VysY7ivfD5KLRTFiTiE9r7+MfDcu/dybi4HfJRdjTxdwhwZ6ngrOafXaAjjQyXXtaMM50pwUOqO6NHoLUZ36Iv+RuYkoP7c5Xc+SdushaLcq2n/QMZ/ArJT4KNafMOwHk2V9ABY0Kxs8rVWejcI8pWEPoTE0Oe1+Ko9vAGm+1J2glQLxKqgBXdGqarBHXYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lk2VDA8PK6HH9QYkfJfq+OgtogjLpKdOY0dq2ImQLko=;
 b=DzQZFd/ILOo1L+GVi5me9Neihx0ZoGk4v9pkZXVbrQ2Zwp1Wr0UjvKFLTAaYjKxYuioNBTCYOLgqejwt3KyF65/vW1PVnYqARDsGYCIk/T20bn1SLofJMGhAKdp0+RIrK1AtkU3hYHCcNvo/7fnK6W6F6i+HOUz2eOubTg+KriMTk8Gx3AHnN/r/9IfvDWXdLv2VemIsoBOyXcVe7CIEZfYHK4JNeBMwncBb5Ze6h1F5t5MInpvKsRAvJaRY/5uDRhcdZTJWe4OiTGOStKidgWY5egHz2OB8aQE6yPuhoNQ0fO0q5pTrogyhoqbjknoWV84BR0YbMG+ebywRa30nlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lk2VDA8PK6HH9QYkfJfq+OgtogjLpKdOY0dq2ImQLko=;
 b=LW7edWm+INDzPE5bcFFbciEhMLU0gOOI1ycwQv1LFHa7yNcSHS/aiTj3NQbwdgL2MUK8+X3zyV9Ro4T7zsK2gry3MOwb0R9cJ858b9tf7x4iHXaNdL2bJVGlWIVNdUL2kw7zRnUGTH5Tu+wz5ey12+5ntXnQhgBdaq6C4AubcOI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 03:32:05 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:05 +0000
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
Subject: [Patch v4 01/13] x86/ioapic: Gate decrypted mapping on cc_platform_has() attribute
Date:   Thu,  1 Dec 2022 19:30:19 -0800
Message-Id: <1669951831-4180-2-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: b62a164f-714a-4679-711b-08dad415c85b
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L95MwJiDD8Ho40Ixp3kZUdI1547fVrQjP/+WpHo6LSOeLDz6pcRK563/JONVINVGqUYIV2bD3fhu9hn6oI4ngF1PBUu2NcGS5CNPSmTYdb5Lz02bBv8m2UNvKzVUWre5jmDYky2SAJOVrFuPwdtgPW9Leg5X8PjFflf8y5jbk4gvv7CxUB53uCQQ59qGJ6C6IgvBuZFdLPBQnruV7zFmpYdXVZTy6SWU5BrtqusOS654T9v0viwEOsDfEFMUzpcYLvFZKTjk53Z+kuOdPZQRw/m7CamydFsDGZWj8eSyIBfEp3Su+ZnjOOASecRC2xgqPoqJfKFeAuf1n2QIrH5gRVPDf46TkGTWcfsHVYSin8gTU1byc4c1QJenZt4ar1jM8XrF2ZhLuelIKzLQWYP6JFCZcRjC8W7APNw+yPUbXqVfgGFjVwwR+aqFWbgBPMdnUtiMS4Oxz/6kFlaFUNWLzr2y5mX7IdcD4kGeS7brv2M1DQd/TAhIwPWQlmjPUa/M3Fnn6o/WLK4d2Teui3d0CL3YnFzHZ/bortOpkazCv/VQmudo8vzQpBkndRzAIurxksO+ryLWnT0ETl2kb7OOHbx3MzdoyADuotcjKNMQT3gUNPgeXGGeeK/CsZ8xaiEthUlN65K+nXQHniEA10zYTz0FezL+m9mU1uaD6VUOh2Gz6mA8pap7cdC3SsM0AHvC2vo4HERVSEByDQb1vyTL2v0ROE8hTFz9/icE4c07zDYAotN0stOTsY9oOWa8V10h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(86362001)(921005)(41300700001)(36756003)(2616005)(186003)(8936002)(5660300002)(66476007)(66556008)(52116002)(66946007)(82960400001)(7406005)(8676002)(7416002)(6506007)(6666004)(107886003)(6486002)(316002)(478600001)(10290500003)(4326008)(6512007)(26005)(82950400001)(38100700002)(38350700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TOouGj/nnkA9oIKK9EX/XO0EeNNwHZBIe7Tu1FgkUZP/OPslwWR/XbEViWdt?=
 =?us-ascii?Q?Px0VGNa2nKHXEz0ev7Nlabik/T7nnP2VAvFN7MGG7zoK1LFZClvorMp6WSxz?=
 =?us-ascii?Q?jqEcul7twUKTVomuz67UudhU6ZUM1/75KWJXiSETw80NzTgMdfRKixhWv9IG?=
 =?us-ascii?Q?8lrDeEv/ZejzCZFHrT+lpO3w9dpsT7O/KDA9WXBDDkypmyXTuZR6QHxOT4jR?=
 =?us-ascii?Q?RJWvNb7kw2N2eVccC3Yc3HHKtmV40cY2LFesfWfCrn47Mu1FIIo8/rP9YhdV?=
 =?us-ascii?Q?RCHRPMe6m39iogTmDLNj9wCzYYICUTQtDchdog3Ly6EZYwaPoWu1sNovOWXy?=
 =?us-ascii?Q?zj58rPTsYvM/gqBylPsXEnYPOzcQmcrtSz/sXWYJMA22PakAro7CjhkZ6n19?=
 =?us-ascii?Q?YvDrGWAmOhTdQov5gWSuQ2vCNf+1JhfyU5Q/Czt54/d4dBHf21SnfZffXAP7?=
 =?us-ascii?Q?q3zqHAGoY8P57FpmyU23YT+VK7nlDBDe40htzsvA8lY5NoV24/Hss+gbOrsu?=
 =?us-ascii?Q?QDhmZSjqNR4BcbZXazpECTqI0mZVF0MO5fhF+tULRzFS+TxuKbivdi9s2R0U?=
 =?us-ascii?Q?x6034q2wV9Ukf9/ukGdK4FDMUEwhss/Uo0hUax73LiAQKIhRr5XD2GMp8fs0?=
 =?us-ascii?Q?SYddiRFXIoshL4iFnkm0OyHrBOusl9Jzu8qdo1sahqZcxFj3gzYFCK/dLVjf?=
 =?us-ascii?Q?U0pxHqAZO/7UALQcY8Qq6ihevhpUDMAyCGIuwQ7UEkM+l5sA0jUA3/8e9MxZ?=
 =?us-ascii?Q?+B95XJkRf7XOidnCpQx0YsBcn3Ji6mDTuiRV0Xrh+FpIz1fkPJN7TX8Ng+4q?=
 =?us-ascii?Q?gUGAvlgMzNywb7kLnrEk2g7mYztdBF2GHTAQRm2Q/wEQelQ29bCYdmdyFM3w?=
 =?us-ascii?Q?9MwiBjywc5rHgw2Q9vZBKCV+9Sc0z8VuJOPjAMNNYqjKUCqnAfveatT5VcTE?=
 =?us-ascii?Q?MwSM0OeOyKoA+9opKAfOA0IcxLkiByOA0TmqaGB6teRcPxtkYg4FwJUQ1CAC?=
 =?us-ascii?Q?BxWrRjOSCAWThldcfG+j0W3wusERArzkk1Qx6ZXPALSXEP6/yfcn4+DRimf8?=
 =?us-ascii?Q?mJxox505dKLJHrDxG7dMnOzsOfAHZwUEDPYrzhzSWQ6aPT0qazqDRGoQrevP?=
 =?us-ascii?Q?DYUw3Qq1195KZqg5cFLSZ6H8Kr84vvvy3q2NXijRygO0pLIVJqOPrQP19dAC?=
 =?us-ascii?Q?+pwmV8IkKVcUOraJqbXLUsGKgH2nA0+k5WfvnZf1OpppMxZfEpCdyQ1cEPEH?=
 =?us-ascii?Q?k+XdQIFxQFJR+10nf0mDDpphivHGFMR2uj7I2XGLeYT5vMjf7I3Lfbb6UTD7?=
 =?us-ascii?Q?cdHHnEnHKgvLrE6bYloN7v6GJFiyQ7/3irJDO0JtDRY9iD6HVOGDap8z1i4y?=
 =?us-ascii?Q?3TknWsWC9Iu4SUAn+Cj16FbiliLbDSWZ3xnOZLC1E5d3N5WptSC1aM6bZZ8y?=
 =?us-ascii?Q?UimqBi/XqeBtP2EtSuXGVEpMbUGeKeri+liFQH/hdOOybyXuehdkDtS6XYwk?=
 =?us-ascii?Q?mDdHN7inMkpmLvfA0DcTG9tLObtoRhpKjI+YbBBTYWvpJfSmdRioYv7YYshY?=
 =?us-ascii?Q?F24kXmAcxin84aTV9oD1A140tCaLqjPYTo/RKm9qIfJccq3ICSZsd/Eu9KXq?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b62a164f-714a-4679-711b-08dad415c85b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:04.9541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kS5Wpc5s6X4RKXDwKEZ3DcO3lMjG7pQ4amWqULAqvMIbaG+TF91DhqD9uPNsz1FuuMNbDHdwOEfBxPChOwL0xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code always maps the IO-APIC as shared (decrypted) in a
confidential VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
enabled use a paravisor running in VMPL0 to emulate the IO-APIC.
In such a case, the IO-APIC must be accessed as private (encrypted).

Fix this by gating the IO-APIC decrypted mapping on a new
cc_platform_has() attribute that a subsequent patch in the series
will set only for guests using vTOM.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |  3 ++-
 include/linux/cc_platform.h    | 12 ++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a868b76..2b70e2e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2686,7 +2686,8 @@ static void io_apic_set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
 	 * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
 	 * bits, just like normal ioremap():
 	 */
-	flags = pgprot_decrypted(flags);
+	if (!cc_platform_has(CC_ATTR_ACCESS_IOAPIC_ENCRYPTED))
+		flags = pgprot_decrypted(flags);
 
 	__set_fixmap(idx, phys, flags);
 }
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index cb0d6cd..7b63a7d 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -90,6 +90,18 @@ enum cc_attr {
 	 * Examples include TDX Guest.
 	 */
 	CC_ATTR_HOTPLUG_DISABLED,
+
+	/**
+	 * @CC_ATTR_ACCESS_IOAPIC_ENCRYPTED: Guest VM IO-APIC is encrypted
+	 *
+	 * The platform/OS is running as a guest/virtual machine with
+	 * an IO-APIC that is emulated by a paravisor running in the
+	 * guest VM context. As such, the IO-APIC is accessed in the
+	 * encrypted portion of the guest physical address space.
+	 *
+	 * Examples include Hyper-V SEV-SNP guests using vTOM.
+	 */
+	CC_ATTR_ACCESS_IOAPIC_ENCRYPTED,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
-- 
1.8.3.1

