Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CD86E8811
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbjDTCl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDTClR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:41:17 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021022.outbound.protection.outlook.com [52.101.57.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319F319C;
        Wed, 19 Apr 2023 19:41:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2daLkX4jTduVqc1IwwYyh34QzFtZMCxLnSmHOMAzJCovYD79VU4kzcBjXiFusbxVnHpVO9EySNMQhEgP2/5Y4oTp7HWsvfOsdLP0YTLyJVD7halIVHv5JR86I6WUlL/sxKJLpm852aJ5V+0wlHyqi7mPEHkgCoRoc0K0Xf44qRokst/dSIG95kNkbbA5R5V0fUHWWO6oAyykHAFedp6tESD1Oulo8nabxROD4PioAiPQ7L0p2YgJbuUhyLr0eeAS/6Cr904WMmtPGOrf2/zz8QFi/x6kZZc0smN3O23tq5f0uPaej3pQmFYD7oVB6DsjLj6myfXcUdraLRh15EVgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S43hd72g4XCuT214Mh2BPkeNAGS1uZ+7A5vBPK/+6qM=;
 b=dfkk6u/PJPsT7LmDi/ApycGWdvWKlM+yNTy1lfjdDvliCmyWR2XBZy7P3jFQYmdBJ+n2euLmZ0tk4PgepncdF6wT+PKBO1zgumo+J7ac/kkBSa9RebdaESofnEb49JZYIO2+0NqdR1ZCNjfxTsS2wrU4aTn8GdOSkJWuHsi7KxVcnfer2lbPuNfHS8TN8QTyAZIubslVyEeGBKaEJKH/f4JA6RcsXUEuHHxUtxFD4wBkcmGZxxFyAd7bJGYiqEZRXo0ESgTX1vxVPVmH4/HKhIBpT3hStip/KMgizop1TWZ9fUNZgjD1LzQ5eUqiwaoHuG8eaf6fLJzz1HDCz05H/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S43hd72g4XCuT214Mh2BPkeNAGS1uZ+7A5vBPK/+6qM=;
 b=jScYm3+Ssf94O83Z71ASzmHn1vrcQk8ufvi9mPUs9G4iS4NV6N9hYYErij8OG+jJSFRoZeXhTcWqVqniOONU/PlgzfD040AVxXOUsKUr+YSRhVvcS3oMilBNSl7dJnwYdddV0MRzaMgjVlbv11Uw9Mtch9x/bQwy+xhzugT4DdA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by SJ1PR21MB3411.namprd21.prod.outlook.com
 (2603:10b6:a03:451::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.7; Thu, 20 Apr
 2023 02:41:13 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30%5]) with mapi id 15.20.6340.009; Thu, 20 Apr 2023
 02:41:13 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     bhelgaas@google.com, davem@davemloft.net, decui@microsoft.com,
        edumazet@google.com, haiyangz@microsoft.com, jakeo@microsoft.com,
        kuba@kernel.org, kw@linux.com, kys@microsoft.com, leon@kernel.org,
        linux-pci@vger.kernel.org, lpieralisi@kernel.org,
        mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
        saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
        boqun.feng@gmail.com, ssengar@microsoft.com, helgaas@kernel.org
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        josete@microsoft.com, stable@vger.kernel.org
Subject: [PATCH v3 1/6] PCI: hv: Fix a race condition bug in hv_pci_query_relations()
Date:   Wed, 19 Apr 2023 19:40:32 -0700
Message-Id: <20230420024037.5921-2-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230420024037.5921-1-decui@microsoft.com>
References: <20230420024037.5921-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::28) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|SJ1PR21MB3411:EE_
X-MS-Office365-Filtering-Correlation-Id: dafc2c46-7017-48eb-2c97-08db4148b4ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +0hcMB2HLsP11j2ZcWyQDF3Ry0p0B7LTajJ0D1afPGKl52/0TSncNRUMv8/0adCIhoYPQqPe5F+HiBCtEBD5bvW2TG2wwQej8GMH6CtmmXqzjKd2hKGMAg8MusbiXKtioRyr3flGVfCr9eWjWTCJPyDQum0VOhPgH28qyzPPUw7fRebA5AeKWKSzKPZMFLBHObTSmmSk+grxnfHW5cqaQTxH4QifPLGAsioivTslHeOgaJqPxSBBTUSQSRHQQIjkZUsXiBnhj2dC4nW+UZVtElD3U1PveHiAxk1l+oqLBz623d6zyUhml/x8mvNzSQqI7hYrEqWvj8jj0EH6tJ87SqA6gOkZEJOs5CPOMPAuzZCfm2yqK+JDMM3RVWsBcAlqc82SvhLvZaDx3+3Qfr8vkXoCVYth1G/6++cJ+6/P2U8FmResv3QC8h27PjVZv9eEEM3s5GEO0WXkzmJRUSidoeeDWWD5U4qGPofKNoGNQxtHZfJpQcicTdr4MLZlcBHuvAKzcowPbsFTT/Hl5jbbUcSEKMiE6ZaAlCGFz3kDLDNFna/k81/Y7RswGxPfqn8uxGOX5u6KKVlIkVEcLGrM7MFtk6BKDmMLGXf3/S1GdvAkQIIbA+WVwxc4WNEOq8n57gDrso5nK+Eb3Df8hV49LA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(2616005)(83380400001)(36756003)(186003)(6486002)(6512007)(1076003)(6506007)(6666004)(52116002)(66946007)(66556008)(10290500003)(66476007)(478600001)(4326008)(316002)(41300700001)(82950400001)(82960400001)(921005)(786003)(8676002)(8936002)(38100700002)(5660300002)(7416002)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6/mb8PVez0rcjvLfv5GGi0jvBc3+F2SDn34SSY4m/5VrdsLxLSPIao+G4ALb?=
 =?us-ascii?Q?c0yi5eJwhwJMxCRVIqCJZYpi89QYGYjfLvLWIOx469jCYI7VccvfKTE2Yg93?=
 =?us-ascii?Q?POlnoudkPUwwyh17r0n1h/96nrB3VWx1lO0z/hsBLOVBGedYFH/WpH7pv68D?=
 =?us-ascii?Q?cISbmh/6LNJaNFbbDcYVlx11IvmKCisixzg/uIkvcEk05yaAXbZ+FIRgdbvr?=
 =?us-ascii?Q?Qz/KmWGxE6kdaiJOr53qHunsgc88yLaoj/5uGfeN2Zg6EVuOmqiwV3qKICwQ?=
 =?us-ascii?Q?82Ea5H0nZwM31CUWVpitDpbf2MWQ2GOdmRuTJMzbF1AY0mdyOvF4qpZiQ6IV?=
 =?us-ascii?Q?Khxo6QYXcRdDiCUC8q50n9gc8UzexuqHPsgwMmJc6c0vM44Cojgv7jCILVAv?=
 =?us-ascii?Q?tJ1h/vr7iPGuJwW+MRNK2FV1ac+hE7xrfPBxGNfgbE+QWBiGHOQqaxkx5jOj?=
 =?us-ascii?Q?BN4zvomhnwP/xj+gM7t6IoTYoIY1EUAIwKNdRw5X71OUoUsHS4fbVp17RdOx?=
 =?us-ascii?Q?KSUvCAi9o5tFe4tIn8GAhpCGai2yWcyuE8to0eTnuZ+UsFJCRZexaSxfhb6Z?=
 =?us-ascii?Q?zz95R03bXghY+imod37FVldT/acD6BK+FSFQ5n6eRzOGgeIHdX7iWCSlWYcc?=
 =?us-ascii?Q?Tq2y/CBFugoBPWwtS878N+EVEZjvqQjg4VGX9UiKCREfPGhh7cbt22pjA64o?=
 =?us-ascii?Q?5TCwdhST7OcIf0tbL47MMNL+U1NkZAJODO4QTpnY6M6TW/JkdV7wYmOgyhsL?=
 =?us-ascii?Q?hkmsHSbI+0adZWDZY8MRwcsTaqdgP4SJRLMQtnnPNModcDhC0wztNIQBO2/p?=
 =?us-ascii?Q?9B6qPzX7FyG0j2I1flJ6QEhYPG1PbaJ0x88qlxrIU4qhfqGGDj0JxIlkLJV/?=
 =?us-ascii?Q?uPHcH0o3qwRkTzwsBVUJxMNqKOjeNyBcqw5GKkIWU0MUCInGJexPHc4lUrg/?=
 =?us-ascii?Q?m/YQUkaQU8pIw0mhhpUGNvhJ8op4MAvbBXsfMwPa3ERZj38ch7dMfEFTA1Lw?=
 =?us-ascii?Q?cVJTeptSKigCJJwUERDdb7ddwF7KTJJk5VMADVt/BtxSzP2zZ/8p/1NCxjvT?=
 =?us-ascii?Q?FsIOayh//IX31ycugdXhnQSLOB4IFQ1kOD2TubhEsBQtp6S81Wgh+VSDKtiH?=
 =?us-ascii?Q?p6JqTWuwB0yZTaOAOum0246I4oEkjJDNzOF9bYBv7SvXF8afCj+4ef6oZz27?=
 =?us-ascii?Q?TLM1Jx33lYhMc9e6IGYw3HFWiQXvBRlT5oYbsEGdh/zi8o42h7Crm0qkk0Jp?=
 =?us-ascii?Q?r29pcKycct7HhZSnaaSQz+9Z2SfEnIJv/cN2oGVerXS3DH9zx/dn1GlvhNee?=
 =?us-ascii?Q?svciU7amX5apodvksCX0GElxtvlTNvpc/Za8sGIT0I7+hGRjLAFx6Aqecx7F?=
 =?us-ascii?Q?3FGdbgSdDn39bgTRD8Tyha31GMCs+b7hSuvd/+ddjNKzC+2ti1QyxwR7w2XY?=
 =?us-ascii?Q?LKzEL33N9e68dn1+4DPy5UCEdWQnKGV8LwCcXNGyRkZyn/ffr1G4yS52qZ7P?=
 =?us-ascii?Q?FqKnweb2hm32HRkMyPBUtmSiH4Brf0j04ILrgUhwt9oopt1lbeaYm9JYuRtM?=
 =?us-ascii?Q?xDcEaeYIBUCWwrMs0w8m1xh8ixEH4xNCMIAsZFj/R8nFwiZDrtRwox/KWr4j?=
 =?us-ascii?Q?2Y1SnR5nradL6/O4ZUp/GR++W/Z65J+e5MoWk8ZBC0YB?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dafc2c46-7017-48eb-2c97-08db4148b4ee
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 02:41:13.3714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEOO7tZbhVX6C6y5rbq0qRjFUAJ6KMBEyI9LNMGeZwz0A0QFeA6MnXScX5FEugzuF+l6460CxqIVs/+gVJfZxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3411
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the longstanding race between hv_pci_query_relations() and
survey_child_resources() by flushing the workqueue before we exit from
hv_pci_query_relations().

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org
---

v2:
  Removed the "debug code".
  No change to the patch body.
  Added Cc:stable

v3:
  Added Michael's Reviewed-by.

 drivers/pci/controller/pci-hyperv.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index f33370b756283..b82c7cde19e66 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3308,6 +3308,19 @@ static int hv_pci_query_relations(struct hv_device *hdev)
 	if (!ret)
 		ret = wait_for_response(hdev, &comp);
 
+	/*
+	 * In the case of fast device addition/removal, it's possible that
+	 * vmbus_sendpacket() or wait_for_response() returns -ENODEV but we
+	 * already got a PCI_BUS_RELATIONS* message from the host and the
+	 * channel callback already scheduled a work to hbus->wq, which can be
+	 * running survey_child_resources() -> complete(&hbus->survey_event),
+	 * even after hv_pci_query_relations() exits and the stack variable
+	 * 'comp' is no longer valid. This can cause a strange hang issue
+	 * or sometimes a page fault. Flush hbus->wq before we exit from
+	 * hv_pci_query_relations() to avoid the issues.
+	 */
+	flush_workqueue(hbus->wq);
+
 	return ret;
 }
 
-- 
2.25.1

