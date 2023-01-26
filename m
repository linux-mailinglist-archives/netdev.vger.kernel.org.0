Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A89867D73B
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjAZVFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjAZVFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:05:52 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020021.outbound.protection.outlook.com [52.101.56.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77DF1CAEE;
        Thu, 26 Jan 2023 13:05:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghM0Rlpk3jzl+4egLpAWvcLZjFAPynT8tP9Vq6RPhE9HTlha+ol7ODITVQ5XfmaJBy+/F2cQL1cMMZuSqNtfQui640txQt2siJx9xDadz1PULJKvouEHDompN9eK5hbGWVQ+F16LC4Ofx5KhVY/f9zoqehrGbExBDbKfURBpBF5inyv3XtAhh6L8Z/55bmV82qe4yd6MK9u/IAkZHlFKBVLggbNqgPXbruwtaYMFnaBuH2ftvaud/eF1Ak5rYWLG5eLbcAa49YGYsr91OgR+d87FxW9glIz7Dr3X96m3jAtnWbygjNBMKoRdvGfqh7QzuBo90HxbxsD8vDZXN7ekaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6iFhctQqe25h0yfeRecq3JLeK5MOXZBygz2NT+1z+Ks=;
 b=IUmcZa+N3AYYb+/gnbS9xpzSiptkJ8OR4afpq6CW1YZCWZ+a40ZJPU3tBswKonWcR3bIW0eFaLmKL/TP8A3heDSdPviiS3S0Qu92SqjcYynuUAZn78OlKn6qNreFcSHvTrzZvCPvQ/xIqXCBAjJfgRqETeQaWgISNnK/EbBQ6rDGbBdWFdTC0VM/jP3JhrE3+kVYnAXN2QRI++F8PslRq60ZQFcPG4qeuCg4gmYEkGmK8b+oUYTksxWencqPQ4uW1aHd/+9IByjHq3E/Q9yQwBvJ05dc5ZCi4RwdRGQ8YSPWCQAuXOpITKsnyyBuYb1T8Z+I4OLz5RnZLYaiwee+vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iFhctQqe25h0yfeRecq3JLeK5MOXZBygz2NT+1z+Ks=;
 b=D4D13OTnkKfR6KWb8NwjOyAhmHaIrkwo+V4U6miLi/D4RRWP/KDdDOY1n8Xk8Hcaf4FyGvfq7i8sXIw/W6S2nayFcNzjmhHFiX9homSUvl5yVQpOQfLpv0MYgg0C/mBBszxloY7MKsp4fzfjDxvXxzJldsMYep5DTYjLEYq3Sp4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by DS7PR21MB3527.namprd21.prod.outlook.com (2603:10b6:8:90::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.2; Thu, 26 Jan
 2023 21:05:45 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc%6]) with mapi id 15.20.6064.007; Thu, 26 Jan 2023
 21:05:45 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH net, 1/2] net: mana: Fix hint value before free irq
Date:   Thu, 26 Jan 2023 13:04:44 -0800
Message-Id: <1674767085-18583-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1674767085-18583-1-git-send-email-haiyangz@microsoft.com>
References: <1674767085-18583-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::16) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|DS7PR21MB3527:EE_
X-MS-Office365-Filtering-Correlation-Id: 007aba4c-7016-4e3f-74c3-08daffe11766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZuHiXXQuhURIbW2Bkzg9kwen+Cz2X/2dUyrZWLcOJ3bd19o/QVd8Sw3N5hMsqYb8f+CK1Alj7LP4mz90tJgCuISvuhgc3JNych08PTonp81K5pq6afcCv1kWwxDMviuOOrYIvIDLx6GV3oqzx1BlAWg5c1odTD5+JAflff85RBD5ZVh3L3qTzon/WZRCEpVcRIak6i47Wes0MU2N5j0wWVUiRyU6myO9W4zDKBxNFF/aRdhy4t3JvMRVIVizJstrfN8/UMOyBTkekDezvfcyYVMeKqBuqCY3/Y9WqLAwHjevNlXbZ9XyLBFCaR/0EnFgzvOHgQhZkJuCt+zDQEIso0VFVfajCNzG3E1LEhakd5mB/vsR6c3mGi8KeanM8gQnCvaDouMCxwYsMOtX5Z4WhKGAcfwhyo3kcsr8eabY9n0tB3HxiSHp2kdmWyaY33hxwdvhxQ+mwEVcVyzEMfmSY+HgsMlXGS6+fRAW14NjqpOCdQiPphfXAqssGknXYTWBelqDVCivWLy4T/KgcdFH1fsYtrG4KT+r/tNm4SdJHkFpnEzR+ocMnVbuQDQpRyDATShjcMGsuDUKo0+mAmwxgbeLeQ0adUYp6Whv5+2UAfQJdwVOKSHA6uFfWEuDu2vDt24spnZo/W/QuIj5UTxsgOr9Yt9FxfI5QwI17NX8fS7vDRapmpjTK+LeBBBkGeoRzSlXIHCCKCvMbjFSgmTxQp8aKDAPKqML/6x7fYuASH6fRWeOlhv3uCIyge5CNPnB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(451199018)(41300700001)(36756003)(66476007)(8676002)(66556008)(83380400001)(186003)(7846003)(10290500003)(478600001)(6486002)(316002)(2906002)(6506007)(6512007)(52116002)(66946007)(26005)(2616005)(82960400001)(82950400001)(8936002)(5660300002)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZZqHLnGMcyNZrLL69lgyl0ppz8iniZY84ZsiNwL31QwX9X//tepi3N+sAf+3?=
 =?us-ascii?Q?9WegM5/gxiJmT/CS/1JH/ZQW/2nbcq9n1ztf8RPzDlY7xTw2HOM32OlrTP0b?=
 =?us-ascii?Q?V+A74P2JTWLVEVr+rsG90yMU7Eg0DYul1efVtB3oq+6HIDgQ6a9oH6QF6cEP?=
 =?us-ascii?Q?YjKuXwEQLQruoNOACqLxZiuIGREjluy/i03fbs4fRuRENAdRqCL6lvest7IQ?=
 =?us-ascii?Q?Dyq72ZNAet1fyisLws285HmvwAxTRFzsrEtFKOeCzCHXhnlpC0pqcrvQ+I+y?=
 =?us-ascii?Q?SBZtgkmIhEolQjhJpokAupTQsMZM+F2F+GoJFr68HchoJWraGLqxnzlAcRld?=
 =?us-ascii?Q?illBNsF5H+yWPcjdssa4pzWxy1kaThujxyN8nUQlr4ZMYyH8ewt4D+VADsp+?=
 =?us-ascii?Q?UfE6pF8wHuAuzSZSdNkpwpnT+fw94ZdHOvX7dCiC2+Na8JFdXlUHXmWr+JeE?=
 =?us-ascii?Q?0vDLZ8EnbCQ+KnjNIDz0vIqZ02F+NrwQdsF6Zos0881QOjoYRJ98H4r9jDSG?=
 =?us-ascii?Q?Axhd7yYu4cbtxG3ykMJuXP2+1h5Cb8RhpVBe6s3fJWiLxcEiAx+3eCf37q/v?=
 =?us-ascii?Q?Z7vuLwP+Bb81xOSLsnbl3dZJsUgqc/BY3XFIVGrw2Gy5oGw/Cc5llrZE/W3z?=
 =?us-ascii?Q?AulWjblY1BDbbywJod6cB/o3l1D+ZYxArO+h3eYpwBWXlO8RCrh+svTC4b6/?=
 =?us-ascii?Q?s9z05j+KZafSo4BmQW82Jzr66VM0kbgdDtms6V88YLTNUnxS3fVfRwbosNA/?=
 =?us-ascii?Q?DyknvTc2b6vwuyfyjejpXKGXH7or8bg3v+S3w2ckU6KaadFrJ9m82a6kU6+u?=
 =?us-ascii?Q?3x15YBLEA23SvC+jBBV6dUc+2hB7GdT5nvuReS5MHLk6NP7NWvTYS8pxluLf?=
 =?us-ascii?Q?iADCgdmnM3uj8/ejeaHVq7dd0r9uVjBKgaL2HbEgKwewpyOQTu4peVRBT30a?=
 =?us-ascii?Q?CNNYlL38cEtNiIoXcTbm8NcDR9PZMLC1PDPT7KR1gOw+F32vSP+Xbg33Neg2?=
 =?us-ascii?Q?0ebvu3tpbdUpjsEOExhM1nUSj/ZDin737hb2qv+9E7au+XHQWf68sC95lotj?=
 =?us-ascii?Q?9nrzE9M8U/VKDjYO/5WuQE50uOwSnLXrTPrrEZyh5L1CaBXvhWMebZCyJATB?=
 =?us-ascii?Q?gEkSV9/yKPOLtQfFOG4+bSoWRV4yCF1w7ipQTZ8LzUwlFKyAgI+NBv5OFESj?=
 =?us-ascii?Q?dsA85PNzsNqz6O1IMO24MiraWg9oVuQukivytr7BnSMlYNZjsWJ88Ogj7I0W?=
 =?us-ascii?Q?gzFx5bqtKapfaaG0YYke4rmUHOy7JAlXSGiEv4Rkl/NcUobxsyoyS8F77vKt?=
 =?us-ascii?Q?UUhMHzONM286/xhMfgZMajn6Tny9/qXgvj/GgZR3jMwq8+avUi8i+WFlaSry?=
 =?us-ascii?Q?QYxZWKTk1kKN2OzjHfjSLVH8x1LATI7TM7kK7m7ELQXCImSZxTGma1HzyzbT?=
 =?us-ascii?Q?C7Ovvr3uCfi7WoGH7R41BT8zcDQsnXtAinAvrIf2NQ+U6hYOL15rd909fPVS?=
 =?us-ascii?Q?eiUdkOrsRNzGkVPPIfI+odMOIukrFCCytlvSlppHsBTeTEbGFw9CfdeT3qQA?=
 =?us-ascii?Q?C7r6KGk+Eox99SZ0CahHFIf1X6nhB69hT02ueafR6uDJMhweJMaLm0ot4i15?=
 =?us-ascii?Q?nw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 007aba4c-7016-4e3f-74c3-08daffe11766
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 21:05:45.4329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUN9fT+3qHclzoom8nYM/YSv4+EtcX6M2PVlxi9J8q06NS7mcDLBBKF9S6eCMc8SZ0t7wBHP2BYU9CO+7Jmtzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3527
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Need to clear affinity_hint before free_irq(), otherwise there is a
one-time warning and stack trace during module unloading.

To fix this bug, set affinity_hint to NULL before free as required.

Cc: stable@vger.kernel.org
Fixes: 71fa6887eeca ("net: mana: Assign interrupts to CPUs based on NUMA nodes")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index b144f2237748..3bae9d4c1f08 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1297,6 +1297,8 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	for (j = i - 1; j >= 0; j--) {
 		irq = pci_irq_vector(pdev, j);
 		gic = &gc->irq_contexts[j];
+
+		irq_update_affinity_hint(irq, NULL);
 		free_irq(irq, gic);
 	}
 
@@ -1324,6 +1326,9 @@ static void mana_gd_remove_irqs(struct pci_dev *pdev)
 			continue;
 
 		gic = &gc->irq_contexts[i];
+
+		/* Need to clear the hint before free_irq */
+		irq_update_affinity_hint(irq, NULL);
 		free_irq(irq, gic);
 	}
 
-- 
2.25.1

