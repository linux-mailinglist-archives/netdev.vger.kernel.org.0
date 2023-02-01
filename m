Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366166870AB
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 22:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjBAVr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 16:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjBAVrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 16:47:25 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020017.outbound.protection.outlook.com [52.101.56.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6DF65346;
        Wed,  1 Feb 2023 13:47:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3AETXV0XHBTkHJuNhjNIlbPVVvKxN+V4BuTrde8endess+dY4wh/xIt7i3544+EJs7BXxeD1f5s/0/d3txVJ5HrH5Fq8Ivuvus2BD/95HTn6ajSUPeA46UuXxqkIfb0UT1YJBWvCjoqIWlUB4DaCl8TaHjMgW6nvTC/aHZVoGOUtK93Kpn6XQzJ7pH7tS7M+h0Kr8U+5lmaUgI84nQTRFCpEVDBAoK7lCu9MSMFeTpQf3RqbtKJopCdk5kDp6Da9bynFcn3Ya1+Jt7fgbRKJGFcVLbAKcoO1+2lQSSykF4oRJ6F6yB9eQtum18YgTIW69cPgiT3gYUkRW1wTx3YHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EXdyusGC/vr2kfACBWJ4CpK4YbAx/Su1K/Sv0smOTzE=;
 b=T6S1mEf+spNFuI+UmXdrMk1wBl95ikeWwA0NqkH1OCDQAt9A8hByxkvS9C6fM+y2uomew50G1ickTEcysXUAqLUlKQbD5g5hmEZRJ/zMw1G/wkxS+wT4cRn3F3FcI3+dSwjHUTQiNfcut/55P9mPJf8DPWwlEXp8Vza4coRbbbTC6aMC5CAWxzUxq0Zrv5MsD2+ggnQpnyl0Q1eXysa1wuV05QPsvQflb3D3ippR41z8VYY9cah7q1kyjZvGu0Vr2a26wA/tI2cEp00caN7/n6Ny/FgfHupiMquOM1jP2hZgngb25p7cNq0U/di9jYr8e2KqBpmfZID6CHsATkD20A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXdyusGC/vr2kfACBWJ4CpK4YbAx/Su1K/Sv0smOTzE=;
 b=TS7766Uk+oVADnBlx/XqkSLWJEA+G62aeqG51zxjP5C7JIB+pkIo2c3zy/ZKNx5+30tQ3DMbuhP1TpQETTFUsYNZj85wXDKiiPpJgNZI5InGQP79Msa98l3wX5Oiw3d21Y+2tI/ONLHXlGG1C3m+Edc0lSMbx/WOM1UWkaiCQAg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by PH7PR21MB3287.namprd21.prod.outlook.com (2603:10b6:510:1db::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.4; Wed, 1 Feb
 2023 21:47:22 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc%7]) with mapi id 15.20.6086.006; Wed, 1 Feb 2023
 21:47:22 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH net,v2] net: mana: Fix accessing freed irq affinity_hint
Date:   Wed,  1 Feb 2023 13:46:53 -0800
Message-Id: <1675288013-2481-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:303:8f::26) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|PH7PR21MB3287:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bfbb31c-4c44-438b-688d-08db049de621
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IrzhOB0l3P0tQ+rEXjI19wpOO96ALLdrvjX0lqwc9L9GvogdfuQU5szjOqeB1iI44jk3B/PMZFb5in9/Z2VzGAE/FSvONWXmhXDc+D11u52T86gsqFra4CEu/veOoUHWBBzotSzkbR0/GHsANStpo6B+qDDEO0Hd1IRe71oju/9Bcmm7x6Po7kMKmMiCO3RC9iI9ld2ydwVY1g9t6QogS4SJ/SoSe5o6c+8cBjBQ2i/eJ2WMONYxVCsZlQten5f+68XQkFYxiVojWVxBAl0ABL+V/WIEVveHIxM1msdfcVvGLMEbzxA6igoq7cLJ8rPbb642disO2tizSfzEKSmFTB67ynAiWAKShzlvVOlsrDxI1gOnGBFXjMoaSMTXHAH56zluiD7aj41qoNyhiJ8jF5+Hqo7uU8ikWvYh0tBiUIr8abgIYso3n4hIO4Z2nlcFChefeTqJKfpvqR66sj45PhZc4F4uaH4kim7ruXgJMWL5yM+M5VH6RgqSeri3bv0icYNMIZ+8RVaz5Rz1XySQftciEv+wGZdYjQ4uKtVrAd66QXJB8uouI0jcAdSXISRW86rMQx80hLOp70P3iWeVwn6XkgjczrlisilniQx9PyaUlbStrBT0lOoO5o9vczYJJ8gQ1ZikqZQBg3tFIeauig24n/aHFyytTieqp6hWg5yVQagNG17ZXAWfBxgoU4+CV71FnPRXU2gVN8piqsCg/HYlSwSqjcsmhYXkFeL+B2SecLAFm0l9ZodyShVz9VT7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199018)(36756003)(2616005)(6486002)(6666004)(7846003)(52116002)(82960400001)(478600001)(2906002)(10290500003)(82950400001)(38350700002)(38100700002)(8936002)(6506007)(66556008)(8676002)(5660300002)(316002)(41300700001)(66476007)(66946007)(4326008)(26005)(6512007)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7qTskCVXL+L2L1488wOwRYv66QvWolckWMzrAeGAJr3Vhf4ii6kp3b0jHnd9?=
 =?us-ascii?Q?LtKHdp/YY5eQMxjUCnym07rNmcb2eGNbuGc4xRi1i2EuPkpSapKSm01Wh0vs?=
 =?us-ascii?Q?M/NG1q0aAUBjIxpNYh2ZKLjCLXRSJgKI0x1m8PBEGT0J70G1zs2Zl0Nj86tu?=
 =?us-ascii?Q?qJ6y54lXEbtgr/VQXXe0Vi4ZECKS8lCla42V4TOKvULqyNDtPgDQzMGwdOU3?=
 =?us-ascii?Q?n80j03VRLy4UJJXSinr27Ra6CN0iIiVm4FR+8JUGGrRpJfx4JOAX3lufrjpu?=
 =?us-ascii?Q?psQpOe6i2rXVCmnxMPVvOABmXBW+kCk1zrfen4/1896lO+kfzgCbhbRVvwi4?=
 =?us-ascii?Q?JZJIc22SunoacVXDJDnAiFRaOtuq7GCY3KbP0jj6T+ozBTFjapspuO9VuzW9?=
 =?us-ascii?Q?EaVQrNZ5nwD3m4DvB6xb2uuodT+ruJtO7HPhYpwVh/YKqajsPL9tTSTkXM8C?=
 =?us-ascii?Q?1Hi2ZOn1F8F7VR/nqT10wMd+MzhfZvJDmxOi0BzvFYjgpd46Qc7UD8FpyLUs?=
 =?us-ascii?Q?47/cWFtrf4E2EJiYldFNL64IUcl5tNTmGNLopGnaUi4Hhy4ZdcVVqT70bjHL?=
 =?us-ascii?Q?FHOO3c01xpT3+4f5InacakuRlHkUrEVU2zVgPm6aGRLQrATTcfewYBHM5qca?=
 =?us-ascii?Q?Bg6Lb64zI96HRgXYUirXqUpNr9vedDMunxzW7zjwtXU+k8orY/3H3T8vUdlx?=
 =?us-ascii?Q?ZNAkrPPbMaO9w83Q09Wd+56MahcQGZIhYGWixaWH9ySSlO9J9Jw7pwlMA0y5?=
 =?us-ascii?Q?MPD9xkrueU86M1V+eVTYocwzibKeN+PZjtkGCW/CHhTmXDrrZqetWNl19BUl?=
 =?us-ascii?Q?9f52bjEh1fLj0QNR2/hpACD40x1gDbuNTK/PGtugifre7EWgv+UOw8jTHZSx?=
 =?us-ascii?Q?2HoTVbZji0cSMs8A/AZFzuaclJkrLsr8gYqXMF3a9+omCn2imEIf3tRhyY4N?=
 =?us-ascii?Q?86XondqHmbbbF++BqEwr6CWtV3jZurslc94Wg9j/cbpGg9VNNU0lRRBapZhJ?=
 =?us-ascii?Q?0ipsdn0wYkCAMmqv0BtoV7tJLanDc1LjTAZdZMqq3AEDaucEs7ty0LqzPdyx?=
 =?us-ascii?Q?GYqNjQKUxMOH+EdjBDUrDJLwhVGlYfuOc+QXf4JwnbNWsvEtx0nd1Bw1Mmio?=
 =?us-ascii?Q?c/s820zdKykXjSbWa/E0eUr2p8s2EPtVo5pAFIRKnhCVyyiDQvHalQ1Wj1M/?=
 =?us-ascii?Q?4Q9D46fyaStd8kHk5noF4ok7asiNnP1RuTkLgpjjUAFbSw484y/Mes+SYbT8?=
 =?us-ascii?Q?kAofC5XdYXZ/D/Jqi1xVCcL3AOs/akBRUrkQsIzpFc0yN9cdYfjEdn15Awzi?=
 =?us-ascii?Q?rWaNKUuLQ/9YARq80sStmDdCC9O9T1Kd/JVzHQSFOgwChIhR9OA69Gvjeb0Z?=
 =?us-ascii?Q?8qCRkrZgnSTTfIHqyI8CRnpMcu7mJ0TYYaCFvyNdnbOgRJ6H6g6kU6iu1TVG?=
 =?us-ascii?Q?tIOkyvhyi5asXGECW8X9V4OHnxB75maXWeSQcOcU6q/d4bMyxeQNwM+Ew9uQ?=
 =?us-ascii?Q?78JswiXm0dvASwsOJ5LgvMcHKorC4h1RYrD5LEl+sx59+dt5oUoPk1wocNsk?=
 =?us-ascii?Q?1AmMJKiSmQDqxY5V65HhJhkh8NHfSqN7irisz7XVNspjHH0wJVytEiIXxtYI?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bfbb31c-4c44-438b-688d-08db049de621
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 21:47:22.2883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YW5ILIrFISYKdS72DzQRLHB/2akJUhUCXRkTIR5XTacmmdWqvMMAwKgea2LfroVumrw6723HzNkZQdmLypSOlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3287
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
---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 35 ++++++-------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index b144f2237748..a55d42332e20 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1218,8 +1218,6 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 	struct gdma_irq_context *gic;
 	unsigned int max_irqs;
-	u16 *cpus;
-	cpumask_var_t req_mask;
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
+		irq_set_affinity_and_hint(irq, cpumask_of(cpumask_local_spread
+					  (i, gc->numa_node)));
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

