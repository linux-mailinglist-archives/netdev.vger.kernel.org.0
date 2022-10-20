Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744AD60677F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJTR6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiJTR6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:58:45 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022019.outbound.protection.outlook.com [40.93.200.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E623199F4B;
        Thu, 20 Oct 2022 10:58:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6EgIWD3Rn05x4f2BkAb2XGeEnh+1B/KzZ4h4w/FsscXioXk95Ojj74vVzLYqXH+Acon3J2WmA0ADALUzjHARB9UW/Vrr0LgGELF6naAQZFhzMDS3ZlyCZVbrNnkBifWZ0NnVbmUSKQb+mZh7voo+rTUGZAbfcH6MdUvuz6TyrercPKgyrLtJgQ6YN3NqkL/x61+tlhxdZw9Ie4bD4sKa7GxOuWSfs8dFbdRyk6Q3fw2exIOtSVUeniIIAbC26ilQXoKEUXRquG406Vzd4NWPh3kXWbi9gSgDlDVX9HRHkNZjkvSd0CaTbSFQ2bPpO7aQtkiGGlvAZtFlRKfLT2Pjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JVJae8bvqhWV+/W8WgU4LbCX1LQ5f5C6r5eDY1i+Crk=;
 b=Cf8G8VQZZIfMnIQiKKg/TnzGymAJu0r5mi8w6R+PQUFO7VYM5rhMCjfx2VScFdVyQ0KFuJKvaFMRFTZil8ap/tW2g6iob+qJoao1XhZJnLN2pwZlTwC8GMKEq3yqWvF215zQJA6zEs/Q6xqKP5Ydg2bIb2s83BHTbnXCofVOt2ssrlmXAOmJZ9wI/72zzTfjU54xfkc/IXZsgDY3msIBRNYbwapbjIm7bsCVsyApDjLiom8+Ng7F1WsxfGptqXl3/G2kd/cOEY+NV+hQ6bCuW5WdRGNZCXRbrXhXqII8GKtuanhDFUSTk0nola63cfQZcfGM0PVZA75av4gLPu+eUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVJae8bvqhWV+/W8WgU4LbCX1LQ5f5C6r5eDY1i+Crk=;
 b=TUUCcXdPhiDrCFUojK7wykYYj0DZUBX0D9c3I1zP3mlusYAO+nLxfI2QHx6SZnhccjWrUwzoa37+AtzKPFtZMQH8Y2Pz35T6BUq6uOG8u60wVD99P8yEDd78lS7Tlr2RGWTqXoZQlHqaho8Zm8AnEN7BfVDP9YI4gzFGQEHWoYU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:30 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:30 +0000
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
Subject: [PATCH 04/12] Drivers: hv: Explicitly request decrypted in vmap_pfn() calls
Date:   Thu, 20 Oct 2022 10:57:07 -0700
Message-Id: <1666288635-72591-5-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1185809a-8c70-4279-6883-08dab2c4b24a
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: myDy796499J7r+/agowhmvTmz3KzMj93nudCxJHRPy2wgxj2aClHWfaAcz+y3+q2apMPvNNSm3+thNlZzxhh7L5JQPLUmwoxtuOX+EcI2AEfizmMhbpSyJmIuPbsVPcouEQfxIREz7tDHFG2i99OFjWwx2g9u7at6eN4ggeEXhyhqgBabw1h2Y2IdFA3/QqRh/BcvExghaHCRjYDNg1ebZ/FOUkQHvjQhUWHqLvscuJ9ZiKOhSIlDKK5IV1E/vcTsCfsHma1rMNbAkL98lrBjEOWjOiHwCDc9djMhFBiNQcjd7fqTFEltODx6ghdD0nhos4prmCxQMqKr2mr9SzAtSr1Jm/AhPgZ30mBB5rAXAEQLYAvmyiRGWv01zRBYW0xlKwMtLK4Ovims5RL+xUxCwgYn5qqjJkqVBJNxssdpDN4o66w/FZRvPLii7OTAXWt+9CClDPN8R8dmeYz/y6bKKMQqFUVOlnCVyFkXv6w8EmDcymWPeO6QlUeNnCSg7AO9rBYuVG3JGBHh/lXniJNEcjOEAMVYaPG8B+uTBVVvjHvJH09OM9vUZO8+ijeM46dNX9Keu7KDFfYRmdRMw4qVHvChDuE/Jpe/0aMLtGks0JqFV92jW9G81SuoS1BasqiSkO1JYcJqFo0yUEZ7IfHHcgZWrybCDV2M6E/W7uAZjvKhOuiViZL+1bBoolkr5MQqD6TZIVsY4J4sQmL1ZLEz3F3Isz5P4I7AY0WALkuUNdsp7rqRTo0yJ16v/hLsc7o8pYG1woEJILUDgWsaYd4ljnr0DgcstvSwv5omKm9iNtIqsqCWM8C7Z9YzxUlebSkpgUVVO6Odw6du4egWI6uMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zeLMo2KlJuEqzTS/HhsajZ/hjaspn1yTeBkxBtr/mGlrN228PnKKFOLpZKRt?=
 =?us-ascii?Q?bfiofpSyvpTFInJkHh98pwCdRkL+r17va0ZISPv40dVmrVKU18+esY2l3plX?=
 =?us-ascii?Q?P1VmXt2yswXetB8tAMBLgQVQ5LvpB2KL5tB+nsS/GdMgdVTwxq3Fpzc9vnDc?=
 =?us-ascii?Q?kIc43v6SgPTNxJVh8qORufJ8sT8gnzApDU84GQ7+mpAMDexPZXwk2TvWmAPO?=
 =?us-ascii?Q?6T/wrSGcjZq24mkjhlRp/5lcnxHpPYTKEkbp3lyESCU/NwjaN2YQA+H6yj0L?=
 =?us-ascii?Q?JikXWGdEozNyVzT7bqtx2ki1pspmKlGtxXmsG9F3eVczDQ/s+mV4llDRK048?=
 =?us-ascii?Q?5UkHWdhO6Ln9LGKQ9ujVz/fXloaWr7M/kCvbMYz1l924HdLhs2cZTZiA37qb?=
 =?us-ascii?Q?La9llI2YVLNhiisa84mNE6WuRK43yofwlbqKS9BXSqfJTNl2LdRdRCDHmeZI?=
 =?us-ascii?Q?MVVeKLiub4cX3g1dtlwI7WF9NfXyxT8n2gRWmIUfXxVPAeaaiOu3IxNB6zTO?=
 =?us-ascii?Q?EjBd5JY7QJOre/29xuT6Q8q3uLBuPAJHcpgTbvdye62srsYRQ3Lmd7mWgN+A?=
 =?us-ascii?Q?8SE9p9aVa9UEdsbdDt9KFToBlB+keuLzPD/4lKjNDagGo+cw63vLijYj0Bju?=
 =?us-ascii?Q?jGxfwhar63JdWv4vPCWMpOKBNTAqIEpKv7MQHOB3bl2jtnSsTUNmjavsBHVl?=
 =?us-ascii?Q?f0nQ1kkwukWkNZWWhfEcfEHkK/Ojqx0xBzJU33mdTguy8CGhfFoO37W8QSWa?=
 =?us-ascii?Q?au1xS77ohvpnl65542pqU7nUhQN1U7XERfF+aLxhxrMb0atX1OZ7nfYQ+mUA?=
 =?us-ascii?Q?Ts/zIUhdTQue6kfUqJzjlUjbqc72JVr5gn0YJE2rQi56E3FrjeEgEX8lR+Sl?=
 =?us-ascii?Q?nVPLCQrhIS+pl/WFZtEXzRQSI4OlupQxPY0udS4iXvyTk7uto989R0LJvjyz?=
 =?us-ascii?Q?a7WLj2dt9/60QNkc+Xi6mLiHa53BhbXcB3CPrPRVdl9cak2XhnziAbTXAhfu?=
 =?us-ascii?Q?n7sYZVI0ff5EaVO5Tpnf1+EHE/UIzcWHPupMiAuMm7L/MDPwIamd2DLRgKUj?=
 =?us-ascii?Q?QjGc5RBJzbUaKQl6wYL6FNpY70euGZHTJ17BCzkQKt4vplh/iqUYatvK4Fda?=
 =?us-ascii?Q?2HN15uR/rIDtE+b8djQhz0XDlpe/hXzwSTJm+0uYCSsGlif13KTUA5hF7CdX?=
 =?us-ascii?Q?m2PyS9TSEMJ+JfRt3HGkBur1ui5vCJokxgneGLLQH8pRFi7zvCPOWlvwKPO3?=
 =?us-ascii?Q?1DyZihGfLvWaePyfYOa1iDJxaEFGKcUnuug8tzdPBuDxc24TOZRIDkPujTES?=
 =?us-ascii?Q?R8YtWjvjSEhrfuiOTwBdGHjadaHCZ+p1qjp7rVudfjPzTxYxY1fNM2VL4CTJ?=
 =?us-ascii?Q?0xe38YBN9V52118qiboF62GJ4F2Fw8tm9Axhp7B9YKl57jyERv+HomDGxf4K?=
 =?us-ascii?Q?bTa/PCZbbj59Xi3Su/Ij27wzSEkbCuMyvem0X7l1sClyzknVbWHgV75fO0dy?=
 =?us-ascii?Q?nshae7uqmrv3jTTzFy2yhOUnnJVU0D7Lt/M0dbTBDLh6nfnlRLELrRfZ3Tmv?=
 =?us-ascii?Q?UgFm5jy+opoaGSX48Gpzk4zgzt0+7nJMSi/hRv/o?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1185809a-8c70-4279-6883-08dab2c4b24a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:30.2932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17hxQelzEnGcmg9LkhR8QSb7K4YhFZvbktDA+ZG/+1zlFRLvPjtJhBqhYfwN9QnBwQTUyH5J4BxK5d6GaWWi0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for a subsequent patch, update vmap_pfn() calls to
explicitly request that the mapping be for decrypted access to
the memory.  There's no change in functionality since the PFNs
passed to vmap_pfn() are above the shared_gpa_boundary, implicitly
producing a decrypted mapping. But explicitly requesting decrypted
allows the code to work before and after a subsequent patch
that will cause vmap_pfn() to mask the PFNs to being below the
shared_gpa_boundary. While another subsesquent patch removes the
vmap_pfn() calls entirely, this temporary tweak avoids the need
for a large patch that makes all the changes at once.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/hyperv/ivm.c    | 2 +-
 drivers/hv/ring_buffer.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index f33c67e..e8be4c2 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -343,7 +343,7 @@ void *hv_map_memory(void *addr, unsigned long size)
 		pfns[i] = vmalloc_to_pfn(addr + i * PAGE_SIZE) +
 			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
 
-	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, PAGE_KERNEL_IO);
+	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, pgprot_decrypted(PAGE_KERNEL_NOENC));
 	kfree(pfns);
 
 	return vaddr;
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 59a4aa8..b4a91b1 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -211,7 +211,7 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 
 		ring_info->ring_buffer = (struct hv_ring_buffer *)
 			vmap_pfn(pfns_wraparound, page_cnt * 2 - 1,
-				 PAGE_KERNEL);
+				 pgprot_decrypted(PAGE_KERNEL_NOENC));
 		kfree(pfns_wraparound);
 
 		if (!ring_info->ring_buffer)
-- 
1.8.3.1

