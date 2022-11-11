Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDBB625394
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbiKKGW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiKKGW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:22:26 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022018.outbound.protection.outlook.com [52.101.53.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F8E663FB;
        Thu, 10 Nov 2022 22:22:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMcBWMbKBOl0gTR43MuD/6CkRQDi9YQYWASKE8jQWJJ9TR1l6rQ0rLuoaD9BgnnLqWlK0im22P8OHa7Ua8xjD85Np0WoZexi/s16YVjL+jOi2M8K2LvFH1IsZqKUmkrkpXWXSEwS3GYBuKIFVpiYZA+CbRScibHGihfE4wMYJe6OyBro5qIPAN5r5E7JpQYI1FLt8jWMOwTkHbbRVUNxBbhj3o+gEcAjS0KvinzoOIyP91cn1IxNf1saXhLo6cdo+u5OugL7riRxr8bCOrdyqkPxRB7KJZ6rhu5XwalKAyib0kpg0Ub3frAIjTEC5YU1X4e2gKZwcnHQJ7K90IVDHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OcaeMt/u9wYn2yxcRzom+6u54BPUvchqecBRIxcVm4=;
 b=PjJVYA5y+dEffQ9Zz8cXxCQmIRWZJbFmp+N2llI1a1KKic22eKZYI6+R5wbYQQe+ixPP0QzUN8258KAgWgBms+DggZUzOaK9a2+D81aJk5myM+t3e53VTtex3QcvxSAwBC1G9rm1YXspDwQUc2WeVzxJi7DQZyO9bxeKBL7xgIg/aYlChlnKnQcH2r1fkutZIxYa8vtDUpnOm6y2iZNIl+cybwGsiaR6lUvOixEPl0vYS72J6FRA3zfH7we590Q2iscm7WQbqYV0UMRrvm8repd/CZuZALrOK9rcMFlrmCYBMD4nZKxT0p0EWWI7wuEfT2VAw8RPmJkf/iEQDknxXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OcaeMt/u9wYn2yxcRzom+6u54BPUvchqecBRIxcVm4=;
 b=H7WU6C6Oh2TMZF+Qzk8SWcmzU2SvWb04XoKdjWxGRLdWESdao1Wvn8KlcRREFr7klyPHACatj0UiCb7m7N1RP6IH3OIM9q6Uk+ZJcKyeMwSPPRXUZ8ewop0z9BkOoLWIlcIABXm01BmxnDzxLw5lYjUv2V3iTrmt38GZd5E9K1c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:14 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:14 +0000
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
Subject: [PATCH v2 02/12] x86/ioapic: Gate decrypted mapping on cc_platform_has() attribute
Date:   Thu, 10 Nov 2022 22:21:31 -0800
Message-Id: <1668147701-4583-3-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: e5f819b8-a68f-4569-c9ed-08dac3ad12c2
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJtq86ry/vEbYzqSqkbP2e7HDBlzZa7in6TGb6fzURJDIUdq6Fm5nA88Sw6GYiPgq8gyGzSixyHjk+pOCOLcoYH0nkvlHa+++SK2wplIVdoQ01BKl7ghphXoMEjh6RToVBTZ6a74X0lRsc4pcwvFZR2qFuMl2qQOjQ+iZ7cCp66KQ4tKAoeeCWfDWbTk89Glwk98jHSJxnx2t1X1hvNH2DHCdSYk0XpP5hiO5YEbNlfbIliDDiApEOWXtf1EK1862C3JMytMZTUuJmhQ6zDlQHwdl9YNDY+xoC+6OHKefSR2nJZYdrfc2OccFk+dCrrShYVAgNEX2f3iKKzG+bXIQDHROaDxQrMqEHMh+7Hnw77FSUFJ2SN4W+7vf9OrcKQ3MB+ijqpahrTSWMNKJwqOzNZNMpfRct1niEiZ4V0s99FmVM0EmDGlTRmLznPSdk2wtwsjgveXucKrAbiSAFxCijt7hMwvMoJi8tC0OqQte0vGzjB12IEZAzLfUNY6oRVhqQsMiFYNh3LdYiGmc5RXmbCUaist69XG/nrWC2kAMQ8gXuSMRxv+FbMz5ys0CXq4IFRs8y2HFvC9eS7g9pCwoAcGXHjukZanchKuGtjupIMLU5hTDM6bnE/wWPyDXwltWUlRkXpno8KIq4k9+sdFpiljOk5vTo5iO1LjNpzyOS9lwlqko1HkmwZR7Um8SGIpvBcgUF7vZ/jueAsHRRhCEPE2jiT8y2yw0KnY264JeGhoFWAqkcK95wFD5Sa3QVkfg343BYNIFeGZROCStcbhPN4ECTfD9BVjbzRZ9yq0BuLmIVDpPDzKnQty9Py33suw5Na7QqD24YwbaTOuFvcBxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nh+v0WkPJj4vMR/VScDAW9JXeXPIMtWP1pYrcNyZFp7CV7u36TDTIG5tnPIy?=
 =?us-ascii?Q?iVKUXE4pdqi/9ILRA9+VKhFZGEoH4BKCamiQALiquY0p2l/tVUqrOau+m8jy?=
 =?us-ascii?Q?Da8eQ+nvI5tmgkWyEuHNsEUsGmVF7MLNqy6Sv7yO4MNA0TGKYmw8li4MnJ/f?=
 =?us-ascii?Q?jobF9pJOvFviVYvHDy8/p7iBf0yGmzZJ3usTESFROfljubW0WoZtpYB0tYqA?=
 =?us-ascii?Q?3bMeb4kUvmwSQU/gRv+kpI0hJx3yQ86FCzjReeem+ATcfjk0ydfAVRWacPGS?=
 =?us-ascii?Q?MiktzGmKfWY9roSy6LDN560xKzvgZvC78uG0itvIsKYhQoSkquflpozWy5jg?=
 =?us-ascii?Q?WleUb+je9uwUaN6pB4+Z42HtOO/U3d5XzI6/Qq/e3MGGiHz2IhNTw44cqSUl?=
 =?us-ascii?Q?UHDXjU0SRTfJ0Cm4YEx3CsL0sF9gjfUfi4lc7ZhgTR6DlI7cF23WyIq220HF?=
 =?us-ascii?Q?wvc9mQWaJU3OOz+Y6W8HUfDeGcW/dZaj01fjQstxo/xdDzlv1VbqYjgwKTla?=
 =?us-ascii?Q?6HVbOTAH/zsBnV0D9qDkNoQ3oCRUgIKu5sMkKN0eruVBgAso6lNNEXbQd000?=
 =?us-ascii?Q?UFz1K2U1yRySJDt3ybaZUvqDlugGY/tORrf2X3U8wALrGS5zY0PF5nRQwToJ?=
 =?us-ascii?Q?5awv+dj7uAz2bE4KBmJB+la96ANtByaisu8DW+Esj0fIgbl6EERWp6MK4tf6?=
 =?us-ascii?Q?MI/dafsdWji5X+BT6ZHrIT3DC7ZNyUpGVHw3528utEzElSp1kxW9ExDyfr1E?=
 =?us-ascii?Q?jBamFMWVZyDkCzjN5ny0qNUha19qbum3d9jYOf8lyoQzVn1vyWRsAaXDdhvV?=
 =?us-ascii?Q?BEbVPkDGAFYDoD45Fin29sF/mXMtbukVKng49YQjN80sfGgwGn4uXYGox+F7?=
 =?us-ascii?Q?q6cDL3PLcez2jQ2KarSXBZxV5Nf9al6ayA9QN/YyFt/r9sQTX1ENaFpyPPL7?=
 =?us-ascii?Q?k6Nvesi5eUM0ljqV4678trWygIuO7H2jdetKpr/cbUGqQeHZseZQPLcRUl3E?=
 =?us-ascii?Q?g9eMNNoDNoNcJ8xjaTPeYVfocEjDvno3rEIrIaBJjRJWjxzP+7jytHAZh2WK?=
 =?us-ascii?Q?wKQDGvubsk01qLY3I6+8zikLrMCa771A9YkljjFXEFJ08b8el9RL60cIiCAU?=
 =?us-ascii?Q?eTJZ4mRRvnbo1L8hCt1SaiIyhb3Xj+YR0Sa6B9vW0/Ngqad6mjjS1Rz4zlOr?=
 =?us-ascii?Q?+efI5YshrbPhXrE0UGHP+l83KZhAZhJQsgA1XMZ4Jv+EYkbgpZBp1BKO9I24?=
 =?us-ascii?Q?2LQXF6mNzIZdO6meN9CkYvv4JLrF1+alMqDI3PUEn9C9WEqIz9atELNbWIfr?=
 =?us-ascii?Q?Tap2kuZ0FOkZ/SawmFXymPDyzvT7MCRuKfnYN8KA2vwc4Ogj+XBSa4op4xzD?=
 =?us-ascii?Q?HFObhr8umwqlVsYlES+b7xk8IQO4Qzxf1lI4Vs1CZ51S2uk3feGVXss7XXpg?=
 =?us-ascii?Q?Q5olYfsmiGs78ccsuxgS83tX1XCOjwA7yAgbwMWjpVc6wwaOqABk//JWV7sj?=
 =?us-ascii?Q?Pn863w/lhjGTg1194OpF/xDHHstuMTt9yaZLxKYixwXS5gwoLQoxfhmNdHk9?=
 =?us-ascii?Q?+6XWwTk/rL/S/WI1dKQ4V4CILoDel4RF7Fehi/EgHMiY8OjrzeU/dFbHg/4M?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f819b8-a68f-4569-c9ed-08dac3ad12c2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:13.9891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5ZGfvO9AJ0eB4++BJ9L+a7Sy6FwfIh8OXjs2EuR5V19H9l/us+D+xzPH7+fIHTlnWw7ZvneK41cW+8SJriudg==
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
Reviewed-by: Wei Liu <wei.liu@kernel.org>
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

