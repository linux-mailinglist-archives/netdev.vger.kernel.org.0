Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA4B67D73E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbjAZVFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbjAZVFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:05:53 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020021.outbound.protection.outlook.com [52.101.56.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7767C3403F;
        Thu, 26 Jan 2023 13:05:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnxWWzjl6av20MSQ3h5zcUp4w7z1Ti1GhekTZtuecAukHVxIlDX8J7XaDXw7Cp6UfTokY/TpkzZesubkxJhkUm3W8O4ihhJfwRzNWF/QA0XSwMcqev7RkjIgJUjpQ2SHl+y6QtI+ho8/1vAxGaYpHRRUs4RR4LKkOidcb9WiK/0LfxiAqymT2C+bGmMWfu+1xzhajpzhMfT1h2Y0Z0g+nQZsSSO1JXWBX85G9058lOHlqnRzSBx31nA3Ug5qT19CqN2VwU+sqpTg04cXdzWL8/A8zam7RtPDiljwQiYjuatR6UWL6f1RJ398uLjcnVHvJ/1qjTc8R2lIFfYIODNRYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DN3/c3OACdli/EEhGneaqP+H+2SWUn85yKA5drGKEkM=;
 b=X5P7b0aJxEsXJ4CTp6jSaVx7DVvy3O3ivxZxc33URrn9t+ZZ4LDqzYma0l18Fp7oZE+qN1lnyLb5ocJJSlcXam9RooBBRzKjc28P/5uuQTPZksQ4iMKCjZP/xq2/tiMTVlZBo1K2MYtdKHOHzbrcMrswtFTxGZkv/JvAzaYSbMjdz5Bk5ho72oSUrXGp8zczbKqbGIEeXAPAQ084BbOwOng13yHmn39Jfp6cBLP3ki7Fk440f8fPuCcpmQQxiEVPoaA4BDlbY7HmQEwoNRnW9GmAOEhrDBa+E+5BmwIB+7+OdZILt9et4dsYUAIa2sLJyItKN5S2dxuQhGDVRtThAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DN3/c3OACdli/EEhGneaqP+H+2SWUn85yKA5drGKEkM=;
 b=KbXsJOV3b5b+KEdSpUxZbaVktuDkmu3WNVUCWeXpNsF6OA0Op/HnpBbz9fyHn/DisusJ+J1E9akP/G7YknMLfBZe5aLHLg+qA4smbwGG1+vzaTy1aGyMa+FQkdvqUTMk7J7xsPyauEoORGYkM5lBapSsdYtEYRjmzmhkqsW9Bzo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by DS7PR21MB3527.namprd21.prod.outlook.com (2603:10b6:8:90::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.2; Thu, 26 Jan
 2023 21:05:48 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc%6]) with mapi id 15.20.6064.007; Thu, 26 Jan 2023
 21:05:48 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH net, 2/2] net: mana: Fix accessing freed irq affinity_hint
Date:   Thu, 26 Jan 2023 13:04:45 -0800
Message-Id: <1674767085-18583-3-git-send-email-haiyangz@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8a3c8aba-b35d-40f5-9f28-08daffe11973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MqXbGK41glRMJngQkz+qNEG0gYoIubhSs/HzUcwqPNvd/Zo+Civwh+yHsnNIP0pDsaD5/R5S3p7REGkWjqoslhJQQrKj8goIlyeR6yIpkXHlOeTbewMm19TE4qeQ33mDFp31VYm9ryCYjVocaMno3FGUP0rCQPxoK6rEVJ/A2wg3Au5qt2013ayVJ7UWs7LSqnaplPAzSAzWnlOtWO1oBPBdnEYvlw3xdvyCdK1gPJBbm/kH7zg9nHNuGdrWsQa5PFIJR8rKadeJnPAp/Apehi/UatxlB4FZFW4dpAxGWhqB+BfccNkOg4HkYWpS+jcvrDyBqhsubQmI5XOef3l+4kBwwQIjDK1+i2i/AMmmgX3INvlozzukVwK5J2SdWcdhdo0XZyKDHFBRbWlWwARc29H3MHB1IURUcrw5RKUuQS9O5/U5jsengUWvq6Dt3blGHTvnfvszsyQtqNUvmFHXC0IwjalLTUw8d+YEQkLlk3zJdnlml7zS1LkJAbGpap1NuCHab3AHAOaxJ87jCEml8DJ7HQEJMEy0vv1vpBh3hjXECTaJyy9w5ifBFUHKUfgZRhXMLJsASh+qytkEuulUHWR5KoSdF4G+18gymJiW4+O07TvFE92EQ1iZkjHuhgRI+8JZAXRf4uxMdwj12vAJjPuyFmHiUN1eD3z5ls+odjl6nWtkTdhEF6Pakqahswe2HfJegaEjIWBmTOqEbvNwNG5Gy/x/fMAJ5aztGjGYf/+MCQJLqIpH8NArt0ZTElhl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(451199018)(41300700001)(36756003)(66476007)(8676002)(66556008)(83380400001)(186003)(7846003)(10290500003)(478600001)(6486002)(316002)(2906002)(6506007)(6512007)(6666004)(52116002)(66946007)(26005)(2616005)(82960400001)(82950400001)(8936002)(5660300002)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VageIu+H91fjudm+IS839lhZQ7Ns1Ae52foYFwPnLzgCE3kLKQXQ/zu9EX7g?=
 =?us-ascii?Q?t+T+A6jbdm/dLHA/rwmygFsfA8pF6DYdAdoG2zKmPlFcmc1u9/oH0aQJ+0B/?=
 =?us-ascii?Q?o/B92XOo3RRao+GY+Jv5HkpAqBsFkoXlVz3P4+UVKUsOwv+45tGz+45+AaJR?=
 =?us-ascii?Q?bvmF8TJtT0zrMhVSL+Pw9HRu+tDq4A7I9boZDi7f2MqC8AZfecbYOdq2ZoB1?=
 =?us-ascii?Q?bwb7MDnt6+I67qTuluXxP8s567HY6bDT05rJdHs9HdEgIiWXMxSO9JnPgeA8?=
 =?us-ascii?Q?pxd4LiehLwcvV730n+RVpNhZao4gOK2vbpXVjiW3viFdQJ9q7DpIGPiatCua?=
 =?us-ascii?Q?CWafLnClM5cwtWPv9+8Kft7aPtfNvk/f3q/6x70Sv/t2Sa+gtwES9vh3oLtz?=
 =?us-ascii?Q?b8Hpn+M1l32RfDpqC/XyVyr4h3N4u7tDSG8pRadfZxF5uEDCVx2wWAt685ch?=
 =?us-ascii?Q?SWhnDGyNojX6YhTQPXJFxjLKQJ575RFRvF66bo8ltDvgIex7N6A2d49rdSsM?=
 =?us-ascii?Q?0GPDFu6cXObQuceEXTkXw6Y6omgDDYHV3B+0ckfRRu0QyulWBvteZI9dK28a?=
 =?us-ascii?Q?+xburcXcLQVwHEei6W0gp+Pdr8sMPhlJRdLEQNtYOZpGWMSq7Gza/eJ3QM1E?=
 =?us-ascii?Q?z5yxD9qRiywbaE6ciFsLFbYwSXjb/gca6WloWBT8nftAb+tJTP+bkWPu6Xyk?=
 =?us-ascii?Q?p3d8Xnt+VcyEzvOoI4GtAucbnUPCLHLJumYE3vorl/5rxH1AGdzUgvs/cbf7?=
 =?us-ascii?Q?0/tKvsoUdpQXF9F3L8b8uA4z6X5UOQ2nQn8UwlOOn694hsOE3ypW3d/yLo8+?=
 =?us-ascii?Q?TiEEdRU892z0ZbXZv1LHcNlekwI9dCm+1gYeoPNBKWqfR3raa7zFvI4k/viW?=
 =?us-ascii?Q?3Wiwz1Byus2OMyn+2ns/Q79mVu2kDpQjCNEzI9cESLky4IuRjw0QENOFHO+o?=
 =?us-ascii?Q?DGNiR9VJLs7kYg/WJ56s+qJiR+Kbxc8HOGMiCdhYj9Y3h5jiIa4AnV/od/Wl?=
 =?us-ascii?Q?Y8rRzQfQ4SPpS4NvmH4+ALXl096aRW0tIDKfgozmZ6mUKLlAbqbzgySX5hZU?=
 =?us-ascii?Q?0SELZtulDx8Hqc1zh7WowW0cR+30ca7wTP61fB+HXELjbmE19kNPLH/nG3Dq?=
 =?us-ascii?Q?zukcecW7sxpja2eYNJxgSz2DYA3+jfbcZzRMoW2+7cpnhL/6vZsAG4Y1VvtT?=
 =?us-ascii?Q?yYG0EBX1YLobGZwJxcx7dYT/h4mnRRxi0Qfc5k6JdxJlxGDKYiJCqrkXLYSS?=
 =?us-ascii?Q?9apiwG1/JVZYp6Hqa562x/5Xu7lfzO2n/pY66S8h22tXcgWS7Jh72NOVsCMu?=
 =?us-ascii?Q?aD/cPO1q1SQQF3//kQsWh3ILN2ld5ZDoWL6I0qRN88M0pn0RFDKo4sSi7AP+?=
 =?us-ascii?Q?yoW1GNOj/0PnyqUIP3qhavbIn1QIib2EMwN1Kbwr7IZDjiWqd1HTv3nHJb9g?=
 =?us-ascii?Q?Peb5S2PCuFsZo2Hmk1oHJPMFPQF+eWE5kdRGFiD01BG6XCCa4PG4HPEVdtAS?=
 =?us-ascii?Q?NNnk9hlLIRYFL9DU8/0FOpXqW6n4DQgipqbgs1JPqG43d8t9Nj9XWPxYrUQN?=
 =?us-ascii?Q?kdNEuknYCz2eYWHTImzq89B1YwKJoB1CyTceC6PVy60XWI0KnZF2uiGqNF87?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3c8aba-b35d-40f5-9f28-08daffe11973
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 21:05:48.7328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QHzwQ08UnOSVuFZWK/tMQrc/V75c+ZtlXq/ZY/5yHGpNGl86V3e5cOW5ZLEZh0qC4cEh9Q/1AHAuvkxCioL4OA==
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

After calling irq_set_affinity_and_hint(), the cpumask pointer is
saved in desc->affinity_hint, and will be used later when reading
/proc/irq/<num>/affinity_hint. So the cpumask variable needs to be
allocated per irq, and available until freeing the irq. Otherwise,
we are accessing freed memory when reading the affinity_hint file.

To fix the bug, allocate the cpumask per irq, and free it just
before freeing the irq.

Cc: stable@vger.kernel.org
Fixes: 71fa6887eeca ("net: mana: Assign interrupts to CPUs based on NUMA nodes")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 40 ++++++++++---------
 include/net/mana/gdma.h                       |  1 +
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 3bae9d4c1f08..37473ae3859c 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1219,7 +1219,6 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	struct gdma_irq_context *gic;
 	unsigned int max_irqs;
 	u16 *cpus;
-	cpumask_var_t req_mask;
 	int nvec, irq;
 	int err, i = 0, j;
 
@@ -1240,25 +1239,26 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 		goto free_irq_vector;
 	}
 
-	if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL)) {
-		err = -ENOMEM;
-		goto free_irq;
-	}
-
 	cpus = kcalloc(nvec, sizeof(*cpus), GFP_KERNEL);
 	if (!cpus) {
 		err = -ENOMEM;
-		goto free_mask;
+		goto free_gic;
 	}
 	for (i = 0; i < nvec; i++)
 		cpus[i] = cpumask_local_spread(i, gc->numa_node);
 
 	for (i = 0; i < nvec; i++) {
-		cpumask_set_cpu(cpus[i], req_mask);
 		gic = &gc->irq_contexts[i];
 		gic->handler = NULL;
 		gic->arg = NULL;
 
+		if (!zalloc_cpumask_var(&gic->cpu_hint, GFP_KERNEL)) {
+			err = -ENOMEM;
+			goto free_irq;
+		}
+
+		cpumask_set_cpu(cpus[i], gic->cpu_hint);
+
 		if (!i)
 			snprintf(gic->name, MANA_IRQ_NAME_SZ, "mana_hwc@pci:%s",
 				 pci_name(pdev));
@@ -1269,17 +1269,18 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 		irq = pci_irq_vector(pdev, i);
 		if (irq < 0) {
 			err = irq;
-			goto free_mask;
+			free_cpumask_var(gic->cpu_hint);
+			goto free_irq;
 		}
 
 		err = request_irq(irq, mana_gd_intr, 0, gic->name, gic);
-		if (err)
-			goto free_mask;
-		irq_set_affinity_and_hint(irq, req_mask);
-		cpumask_clear(req_mask);
+		if (err) {
+			free_cpumask_var(gic->cpu_hint);
+			goto free_irq;
+		}
+
+		irq_set_affinity_and_hint(irq, gic->cpu_hint);
 	}
-	free_cpumask_var(req_mask);
-	kfree(cpus);
 
 	err = mana_gd_alloc_res_map(nvec, &gc->msix_resource);
 	if (err)
@@ -1288,20 +1289,22 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	gc->max_num_msix = nvec;
 	gc->num_msix_usable = nvec;
 
+	kfree(cpus);
 	return 0;
 
-free_mask:
-	free_cpumask_var(req_mask);
-	kfree(cpus);
 free_irq:
 	for (j = i - 1; j >= 0; j--) {
 		irq = pci_irq_vector(pdev, j);
 		gic = &gc->irq_contexts[j];
 
 		irq_update_affinity_hint(irq, NULL);
+		free_cpumask_var(gic->cpu_hint);
 		free_irq(irq, gic);
 	}
 
+	kfree(cpus);
+
+free_gic:
 	kfree(gc->irq_contexts);
 	gc->irq_contexts = NULL;
 free_irq_vector:
@@ -1329,6 +1332,7 @@ static void mana_gd_remove_irqs(struct pci_dev *pdev)
 
 		/* Need to clear the hint before free_irq */
 		irq_update_affinity_hint(irq, NULL);
+		free_cpumask_var(gic->cpu_hint);
 		free_irq(irq, gic);
 	}
 
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 56189e4252da..4dcafecbd89e 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -342,6 +342,7 @@ struct gdma_irq_context {
 	void (*handler)(void *arg);
 	void *arg;
 	char name[MANA_IRQ_NAME_SZ];
+	cpumask_var_t cpu_hint;
 };
 
 struct gdma_context {
-- 
2.25.1

