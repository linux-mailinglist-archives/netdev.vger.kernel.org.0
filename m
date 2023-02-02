Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFD0688937
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 22:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjBBVsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 16:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbjBBVr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 16:47:59 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020027.outbound.protection.outlook.com [52.101.56.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2370487146;
        Thu,  2 Feb 2023 13:47:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/yRlYG+sXETndMFBYx7SgEePM+PmqbMPFH3oHgmyCZEy64XXMpBiEMagXxm0EhZ3my0HQGpqcFjpaE78+Tps6z7jSskqIS+9YDKvR4t67NJxDZkpf8TnK7PN6F466qRVvsAk4YEHSJzRfy4v9P2dMYqPMn/OUf6/tldyulhBG3G1H15KKlztHjNyq7GSvM34q2W3GptMOmUkhvZcDN3eDF8RqmpDPxmX5liUUlX1gu1GsKfu/dWZksS3JguWYTRNdfLEE/y5p4N0BOKalk+rcWYBBgFlVJ/EKo/mXSjfuwtsTfCrXNyZ3BytvXif84dYJNDdfZ0byfU9/vvYSXd7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+C7X/dha1iEPs2r4ThFcoPADFBU9Obtny5jywgqX9j4=;
 b=N3808jultzv8INz3Xx0H7xskXMCPHyCpxd53lrAGmUe5MjvXu6wKrQXltqzalQYJbKlVuBgJfmpGGyh7Vp6TlqIvnKax6dpg8ASxX02KgswLBYZxvMn+33qLO8tFakoKxQePDeW5mB3xuLJ7Tsu83p2CV2At2h0LootrWlyzwzl43RfwVKCrPbORe1lMfExqk+fDs6mPfLQfaCfDx88v670rEjd4iMr1mqjfTou8Rq/uJdBDAIRkkTjFpO3J2yS3rpDBa8CjWPI/Cs+q1oZer83umAfvSGWbk76Vn+crWUbWxWSt+aM19/nz1sCoBq6xloslNeiQ8q+sUtDy6s1D6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+C7X/dha1iEPs2r4ThFcoPADFBU9Obtny5jywgqX9j4=;
 b=fesYZd/i1l9U1aBePQunFObirND2f1j2ratFRTTZ+W5f0ZpCUVQkRjSRakIR6/6gHj9ZoFcgLbxmVYkBpAefOMtdRPEhkJj5eTAWs1ERdmVmikbAJWFwd3Cmu1+DCm22SnjzBjWDjJxxfSFIFtuFyseWuy0ZeSeeiIsOJ45FDxc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by MN0PR21MB3534.namprd21.prod.outlook.com (2603:10b6:208:3d1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.8; Thu, 2 Feb
 2023 21:47:44 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc%8]) with mapi id 15.20.6086.007; Thu, 2 Feb 2023
 21:47:44 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH net,v3] net: mana: Fix accessing freed irq affinity_hint
Date:   Thu,  2 Feb 2023 13:47:17 -0800
Message-Id: <1675374437-4917-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::31) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|MN0PR21MB3534:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c268981-8c65-4242-098f-08db05671d5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /4PgxgL05SXc26hYeszyRM1ZfZ/YXgp43ZBjHmAI1asnsdVz8LcrfwFbcsNq7B0+tsV877SWuIK5++5d/aiTTPNGloMOnrsGmfL+TB57wMw1uDM9AM4J7y+0y51lTHjO2X+5SACvOg3B5h96plcCNGsbTJrJitIc9sZenFflFd93zekssE39HFGLsBG/2PE/Wvy/I708B3COUMN54IfpTcwJzpHY9d+egTrCHDb4ZyxZNEio4AXl79lW87eh7+X01POeVFfnF93yR2MQpbVBVD4wh8enGiw2CUM7xH5MHzClLIwOJ1TYgcTAFj50kxYpePlpJCj2q20F+bbmPeyrB9z6DzoSOkGnx03PpwtlaR0v8fHtP5zZ8BD9MolhYOJei+2OEmIYZuLDGKPyEhNaF+EPM2qVkt6RmJ9AdUSeV5po5lEdT6KjAnaA9TQHT0bYDHbM8ljBBuXPOfPwvxNz8Lo2a+x+TpHAOVdpK/5sM5X/lfTl4ia3nuSiRgkAtM8XDzxWSzpCpT4W5m1rd/5kf0AeHQNWoHHN4F8R/0PWKgROwBDcJ4f0rlgLl6TtqJJDwrMGKmyYNqWktHNNUOCbPmDZe9t5K2/twDkXYYKs+K5tqfYeQS9BX5zXGnGyw6G0G1S1ndwv0UkmhM7PPhGKl3/hQ5UouwxQ0ZN6T3MjPVIQrcK2VkLpMn1aROvEVpMRosL/CRxkshP+My8hspmSB21ksPL89O6mBC0DIEmRV2jGQMHqjZzg0Qs/cjYRVFSB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199018)(2906002)(36756003)(2616005)(316002)(83380400001)(52116002)(6666004)(7846003)(186003)(6512007)(6486002)(26005)(41300700001)(10290500003)(6506007)(478600001)(66556008)(66476007)(66946007)(8676002)(4326008)(5660300002)(8936002)(82950400001)(82960400001)(38350700002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7dytsCQqZGmkzvZy8h77+TW9WZFZgbZxlaEI7JTY6eL5Eho243bGey7MXaAV?=
 =?us-ascii?Q?4M5hq/RFcrb0D3vJaVtpMi8O8qHsl597aJq5tdA/BdN4JhLoPt0qxPUFy3Nc?=
 =?us-ascii?Q?W82jQWaPeZb7f3FKKXYhFgzQHkr+/Ie4iiRccXf+XaHpfThCOZC0b6g0bdQS?=
 =?us-ascii?Q?Sk//iq2XUnC/BU08AmPsxZVYH1G87WJ1wpuYV75voemeMtMw7azL/t9x2/CZ?=
 =?us-ascii?Q?a43VoRFwrUAN1/jVuY1gQ27Qq6Aurmr85UvZXgguH5GriZW9eqb6e4mrJa3C?=
 =?us-ascii?Q?luwnhdiv25jOCF1AMMy9Cw59t/fjyeFcTd+a7XOJCUFIpfrSWwY+hiesrjm7?=
 =?us-ascii?Q?fSFGvDrC1BaDW8SStOiGLqqn42w6CuAgGkLs54xge69GCv2SQLI2YnJKoxb8?=
 =?us-ascii?Q?C1I1Vf6OG6LAeDrAYDvyvRSMWVAcaCOcZX2//08t3MIdudxRxKZNK3FfUvuz?=
 =?us-ascii?Q?w96CoJ5Ew9IToJJZlo6tbMjJ3o5KVVwnVvXVqmEx2S4suU33N8BBQaofGWpK?=
 =?us-ascii?Q?Ci9SOwzM7EmGv49gVJh6M4K1iTf0P5wvYqJMr+I8ItMtNqVECWY145REpHuG?=
 =?us-ascii?Q?1jtgo2CE9XZyZ5+4LdXkk4iYD/O6k3sX63CA9cxAsiNBo/De1OcAqe5KbXZV?=
 =?us-ascii?Q?VuU89YSd7ObIktWTa2Q2oEIj1oKaAOfDLwLuO3nqiIjkArkCeJAg+jQ7ert5?=
 =?us-ascii?Q?fEgtUsJEi3H+d+Nvjw5JPt2m4HllIJKYlucbCriJEV6VDapQNIJ7UQ/nrbYK?=
 =?us-ascii?Q?4GK8MHoQdenqTMnXgqfMS9h3pTvQov/LRvaCwtbpaihH8TYouMFVNWTQylVl?=
 =?us-ascii?Q?sKf2gPIlnfVEGVLKuhKq/7JC+Hd2mryfxofFN3+/LF/JYWRWPaAqieRnURKJ?=
 =?us-ascii?Q?Ff/6JHqZoxXVToM0rUUJ5pieFPOaQa0F2j7Hj+mYZLEcjClc/0dnEzAjznxB?=
 =?us-ascii?Q?X9bqrQGZw/iGP8eZK2JVDeeRUzWc2OlZOcQL5UxMy/u7HF3N8GrucYwc0PVO?=
 =?us-ascii?Q?L3LlbP0QnlSc011+lYY1rQ12qP/QEhBDcrhq8TmqqGv8AlxyQspoyg+G5jYI?=
 =?us-ascii?Q?Jo6DLV0Dm4N0jdhCJKyE/+i6lvGiX6+fnDYDxPjwgRtd/P2xVk9JvIxrEMF5?=
 =?us-ascii?Q?QNizsbtKb/QFUsAd6rZLrsQ0wqL66KhcNqBEoKU9+9Xyf4V9e81LnptMmN4M?=
 =?us-ascii?Q?0m8kgvU8ZMvifGgY2O3hxDEWQHPLSc8cbtwkww1vVIqCb6xeAAlgT3xYrvNg?=
 =?us-ascii?Q?Cz2MIJPDYZH8mDa3RzwSWD8ayvJoSf70ZISSgl3PR6fdEg051oOqbCf31llu?=
 =?us-ascii?Q?Bxf7gn1DtEflApcq53LCmqTKp1iLNdTO9ghzAENZBdmtY8FoxjqIGy63JFZt?=
 =?us-ascii?Q?nC7Qt691SKvCPkj5MVSL22SrOdj8ropaORGBkJl3oE8VwxNPmARb+k5mXHXu?=
 =?us-ascii?Q?SAgGbNJSPOdRtnX9CWYu/okm6IqJ+D8TpMC3N5gUE7vtZGfxFuFfIchcu0QI?=
 =?us-ascii?Q?5wX/XoYAfaOc1mOPqwBhkZNj9xaKoTEhX3kVh+0hjB+Ls49wFnUxMmJ0AZUG?=
 =?us-ascii?Q?V1/SfqG+mdYOMHucMJ8Ngl5K9d6nig6SEpjh1rpKAcPI65GvTU7PczoKPHEu?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c268981-8c65-4242-098f-08db05671d5c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 21:47:43.9617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2H23dkE0QzTckRegY8c00SQ754eHKYsDYelgffFakkY/CzIF4AxKodDceqvXUfRllyRu9do8rpFaI1YxxmrzBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3534
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

