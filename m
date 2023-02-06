Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00E368C8C6
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjBFVaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjBFV37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:29:59 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2119.outbound.protection.outlook.com [40.107.244.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2C02B2BC;
        Mon,  6 Feb 2023 13:29:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J17ic1zCP4+L6qUn7V2VlXE8TEVWqW5neSeuAAsBZrpOQXeJgtlDrTZePy9kOX3h8nTFsh0K+un8e6mkr8pvz3SpoWwKe03BY3aoqN2ozUys1adjXhRYZCKX1Og/nVBZxNlHQQyzTx6fhfeL20m1NlXyJBgcFS1NvFGToGQsDdRyMXCS/noKqYDqsxatwtzgVESAtuOhE/Sh9xfBWPlb1XU/SJ+EoPGPqQwy7bsNnCTMVIkBXRmNNNAbhkkQvsl2EiWMIXIGAXtxbQbKszvx1HOvu5Av61aTBl7JZjwp+0bwsQ2ANRbgpgHYtXgzmYq1gHP37PTQHp1fzuhuivG/MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+C7X/dha1iEPs2r4ThFcoPADFBU9Obtny5jywgqX9j4=;
 b=X9DoCs1wlT29vED5QYz8lxxhConqzEa5kf8xMBQ1CdGFSPmBR9hHPdW9uNRxAUAJffeKWAd55SmMdgLVNVkH6ylfFhPW1RS2CAk3ic8chv/O3sB4IoV8GdMDqBfvAS89QsUTtRTDQyPBbx4wKkC4TVmq3aUsfwk3/bVDyHB7HAVE9xkHXXk7FvzMpARgnn/I4oW/ijViuA5KXOZx+xIV0gLBp3vf6k8nBQ+Y/3sZBxqN1hGvqqmqi6hpIV+TWzB0KjzpyvNON0DD6jQYIVt7MJbJS1rq0amWBAc2HGja7cVLL3i0X9GpwR3bkPypO2RoAzDB3dq9b+fy0s99ERC3cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+C7X/dha1iEPs2r4ThFcoPADFBU9Obtny5jywgqX9j4=;
 b=ThiSDG5vB3Sw/BEjoXYg/grI31XZJYxOAuCUq7gsWc+I/Gjm4+JCW/vKRUUhHPYBZ478i6x+p8IV0s/mkZSUJQVOvKhegRt3J1Y++d4ow+SFuWs1CCJcbvPJCkzJcSaNW6iIXZ+oiWlvHclMmUZByNuXWzS6Ewdnn9K0GA4J78U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by MN0PR21MB3168.namprd21.prod.outlook.com (2603:10b6:208:378::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.0; Mon, 6 Feb
 2023 21:29:08 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::38a0:760c:a81:b9b5]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::38a0:760c:a81:b9b5%5]) with mapi id 15.20.6111.001; Mon, 6 Feb 2023
 21:29:07 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, wei.liu@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH net,v3] net: mana: Fix accessing freed irq affinity_hint
Date:   Mon,  6 Feb 2023 13:28:49 -0800
Message-Id: <1675718929-19565-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:303:16d::19) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|MN0PR21MB3168:EE_
X-MS-Office365-Filtering-Correlation-Id: 7caddd29-32aa-41d2-bc1e-08db08892db3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gQglNq96SwhCUA0LPDSoZrL6t+TrkkXK3ACQMxrdfoyr/F5xy6cRZn32KudBCUfGEOHxTeUsb45Z4NNrP3NqPGbgOgnQFwzwvqAXSPm4jHSzK8YWqDs1jFxtFYc3oOpFj9uYs4XDA4dzSK0rHMVL2PJJ1d9nAdHZayQpSeGRqhLBNqXpYxM4Pwrrp0dS1CAMpAlqmXCwa1csMQaQGvlVhDdHocwYz34MoN5OUUFwyOtiEoko00tQ0605SIgLh5/rMTNXctswC7RdHztEhuwemsRKnLKgdlfwQuWRMBdPMRG+beIUBK1BieSc65OLh/Th8+W2mOx0IfulZw9p2NjgGsn+uXF5VE9mAqQyFTfQtPY1Sw5GOdZT+kaArrd/ZdSDCIzdrsj3RAlScAlTaOL7Q4a1OZmkX1DzPTy74rL0Im+h/aZdswy+nEekKhLtRFawbmP6yHaDupD8C0T4YL4UDOLrm6TEl/V9+8Rnb+tc7wffJG0AQF3pRnSyeTwhu1okg62ZCz+cPNwNmb5/poRYKIDDP8Skkxs7CaAhvTOPz/VQTsrM6yRtNcpRbeo4tISKq7z8T2krBFhblPB1LD/Piwu1Ll6vYX5Dx/E1iHuGjO+RJEXSrloH+YJDBflxxCQZ0AzX4bYy5XVbm+dZiejok/hC3yj2j1MWUsXg/k/9k084f+XUwHGM3pZWCs7BA0IX/H9B83uanHH0Yw4GBZGuOsUJAzJNB659Z3FIiG5id2xe6Y0TxtQxb6dPTFtIeXhB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199018)(2906002)(7416002)(41300700001)(8936002)(5660300002)(83380400001)(6666004)(7846003)(478600001)(6486002)(6506007)(2616005)(186003)(36756003)(6512007)(26005)(82960400001)(4326008)(82950400001)(66946007)(316002)(66476007)(8676002)(66556008)(10290500003)(38350700002)(38100700002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i2MkXnytgaDYvsrpmcxtGjJDkooQGZ28Of5yAj2Ai6z83ZoaRvIm1Sl4DEF3?=
 =?us-ascii?Q?hOsyK97RdrDgTgFRRFTURVHpmlaDrliaY3MXam/L4dpvuE6pKrxaLQQ0L5hJ?=
 =?us-ascii?Q?hHbuSN3/H+RO0/Gg8Mb4MZBEj6rDSbVXwIH0WKJbbf09e+tEoN4zzlu1z8D1?=
 =?us-ascii?Q?ghnCjryiZItHMMhhXL2M3AznwEWOH1iz4w6atwIvJKdozb4lqS0o+hwW+uKg?=
 =?us-ascii?Q?unfMRNRJ1zCXRdmVz0UJBFlK3JPkp6wLmI9+hFtTaDqYxW6+baD4GfLFNEEJ?=
 =?us-ascii?Q?LgZ4n7nZHW1T8TGfGJwNCWZhaC8NnrHJ1xlInBVy5+j8nzM51cveJLFH8kMG?=
 =?us-ascii?Q?OufBQ/mBRSJnzoyOezFmKRcijggeNLDH7UgFBa9pUg0Ac5B+E/+sgOMtOrby?=
 =?us-ascii?Q?zKmRH+EpLX+nQjq+PRGhcndH9WMTcAFfJZQudBRjKGeePaP7KNYso3fHJRx6?=
 =?us-ascii?Q?AODmNLsblV03+mX5kOjr/VaRKzddf0FqiYEp/n0JFLi51ClD66sibJKfFkZD?=
 =?us-ascii?Q?dSRNh66WEOagRo1/EQf08e94rHqxMhc5TPv09zcE++dDRv6McjUOXwI4AM2b?=
 =?us-ascii?Q?JlspfVGUdL8LeBfbZSLtKnB3nAoxruIdi4hfEYtgvsGJHFQDqJhdbgI+CmsR?=
 =?us-ascii?Q?ayb2c0EV9q0zHdCQwulpVapP19sOyxIWy67CqCjvaLrTPUQbIBDBQzxoq9gh?=
 =?us-ascii?Q?yHP+ta9DsT3DdpzFaD+4eM+5D/JO0oZ2TKKSMGI/wakrZGR8qF5OelOih6c5?=
 =?us-ascii?Q?etZAFsCZQEJn6WYAoPZJrQZO7IsX53/Ey2OAr5N+npcESMAh9uBt+VBZ3mP3?=
 =?us-ascii?Q?xK9qwiCgz+8TRP1lFTHbYAtdBmWAg7bw4US6J+6DLrgh2dXAYaBhlw4BvMEu?=
 =?us-ascii?Q?hE6K8qu5/OSg/gl5Ldx5Np032EeuFMAG7fe4xr8It/Sy2FPce/YuZmIC7Ma6?=
 =?us-ascii?Q?dvpHKxSKkki97tc/teT4z7seWbrjKmP5n7leJLboviJCqSPSOQ30gc+xirMe?=
 =?us-ascii?Q?FC2FC4B3lJMNhZbcYUwRKdfMxed4PEFdK9XF7gy0iVxZ7k4WygxIZGYI3Nhj?=
 =?us-ascii?Q?j54f+ettG8QHdwGNCGN28fznTR5/02GSu6ggYoSulBA9ShiHqca7dlw3ZGFr?=
 =?us-ascii?Q?KyYepXodN30x9J+eKV5zpcqg8W9Ie7k4Mn9rBvnuB21NHoBIIDp7VrwEQQPu?=
 =?us-ascii?Q?PCIAcVEAXxB93bJSS0CEhPNd5ARBEalYo0qATqBGolQVp+gGbdqT/DCXrxns?=
 =?us-ascii?Q?ahP88fS4pmnsFrceSgcsT9oDH1bwlEwufrAssNSGI+zYU8tLxuZ1dBeigj7r?=
 =?us-ascii?Q?z+wVYP+hcRX0x1gMmH6jXMDDEihLKZMLdOffC1fD2NzoTFM+dVPp3bSi4n8c?=
 =?us-ascii?Q?QY1gK/fs8EmNqBhBtMpuGu1QD994JF/tRQxPwC1ZAh8u1jRWaOFDLfvxasv5?=
 =?us-ascii?Q?3Ldr5M2L+HxouwpXqZZV8FRLWPesT/4VqzO3deV6JFvGZlv5uOBLZKPYePye?=
 =?us-ascii?Q?2F1laGB6M8aquIg0dPQR4J41DAbg+WSG1pYRo8j/WxlxjuX94vA3roTIAgb8?=
 =?us-ascii?Q?xwN/kQSs9h4Pq+8lsedZmdKNdJHO2mSOIXy+ejScVRVWkVIAbDOVM6BtupoW?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7caddd29-32aa-41d2-bc1e-08db08892db3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 21:29:07.6164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okX67SBdDsCqCxrPzfKFhSINmdkbexjWEOWufx3tiNrmzXP4mGNJTHwdVKp4cP7Z2TpxfyiNB3oEEVV0lk6A4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3168
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After calling irq_set_affinity_and_hint(), the cpumask pointer is
saved in desc->affinity_hint, and will be used later when reading
/proc/irq/<num>/affinity_hint. So the cpumask variable needs to be
persistent. Otherwise, we are accessing freed memory when reading
the affinity_hint file.

Also, need to clear affinity_hint before free_irq(), otherwise there
is a one-time warning and stack trace during module unloading:

 [  243.948687] WARNING: CPU: 10 PID: 1589 at kernel/irq/manage.c:1913 free_irq+0x318/0x360
 ...
 [  243.948753] Call Trace:
 [  243.948754]  <TASK>
 [  243.948760]  mana_gd_remove_irqs+0x78/0xc0 [mana]
 [  243.948767]  mana_gd_remove+0x3e/0x80 [mana]
 [  243.948773]  pci_device_remove+0x3d/0xb0
 [  243.948778]  device_remove+0x46/0x70
 [  243.948782]  device_release_driver_internal+0x1fe/0x280
 [  243.948785]  driver_detach+0x4e/0xa0
 [  243.948787]  bus_remove_driver+0x70/0xf0
 [  243.948789]  driver_unregister+0x35/0x60
 [  243.948792]  pci_unregister_driver+0x44/0x90
 [  243.948794]  mana_driver_exit+0x14/0x3fe [mana]
 [  243.948800]  __do_sys_delete_module.constprop.0+0x185/0x2f0

To fix the bug, use the persistent mask, cpumask_of(cpu#), and set
affinity_hint to NULL before freeing the IRQ, as required by free_irq().

Cc: stable@vger.kernel.org
Fixes: 71fa6887eeca ("net: mana: Assign interrupts to CPUs based on NUMA nodes")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 37 ++++++-------------
 1 file changed, 11 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index b144f2237748..f9b8f372ec8a 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1217,9 +1217,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	unsigned int max_queues_per_port = num_online_cpus();
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 	struct gdma_irq_context *gic;
-	unsigned int max_irqs;
-	u16 *cpus;
-	cpumask_var_t req_mask;
+	unsigned int max_irqs, cpu;
 	int nvec, irq;
 	int err, i = 0, j;
 
@@ -1240,21 +1238,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 		goto free_irq_vector;
 	}
 
-	if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL)) {
-		err = -ENOMEM;
-		goto free_irq;
-	}
-
-	cpus = kcalloc(nvec, sizeof(*cpus), GFP_KERNEL);
-	if (!cpus) {
-		err = -ENOMEM;
-		goto free_mask;
-	}
-	for (i = 0; i < nvec; i++)
-		cpus[i] = cpumask_local_spread(i, gc->numa_node);
-
 	for (i = 0; i < nvec; i++) {
-		cpumask_set_cpu(cpus[i], req_mask);
 		gic = &gc->irq_contexts[i];
 		gic->handler = NULL;
 		gic->arg = NULL;
@@ -1269,17 +1253,16 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 		irq = pci_irq_vector(pdev, i);
 		if (irq < 0) {
 			err = irq;
-			goto free_mask;
+			goto free_irq;
 		}
 
 		err = request_irq(irq, mana_gd_intr, 0, gic->name, gic);
 		if (err)
-			goto free_mask;
-		irq_set_affinity_and_hint(irq, req_mask);
-		cpumask_clear(req_mask);
+			goto free_irq;
+
+		cpu = cpumask_local_spread(i, gc->numa_node);
+		irq_set_affinity_and_hint(irq, cpumask_of(cpu));
 	}
-	free_cpumask_var(req_mask);
-	kfree(cpus);
 
 	err = mana_gd_alloc_res_map(nvec, &gc->msix_resource);
 	if (err)
@@ -1290,13 +1273,12 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 
 	return 0;
 
-free_mask:
-	free_cpumask_var(req_mask);
-	kfree(cpus);
 free_irq:
 	for (j = i - 1; j >= 0; j--) {
 		irq = pci_irq_vector(pdev, j);
 		gic = &gc->irq_contexts[j];
+
+		irq_update_affinity_hint(irq, NULL);
 		free_irq(irq, gic);
 	}
 
@@ -1324,6 +1306,9 @@ static void mana_gd_remove_irqs(struct pci_dev *pdev)
 			continue;
 
 		gic = &gc->irq_contexts[i];
+
+		/* Need to clear the hint before free_irq */
+		irq_update_affinity_hint(irq, NULL);
 		free_irq(irq, gic);
 	}
 
-- 
2.25.1

