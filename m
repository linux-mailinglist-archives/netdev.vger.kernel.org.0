Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C3457D6A4
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 00:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbiGUWM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 18:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbiGUWMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 18:12:18 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60115.outbound.protection.outlook.com [40.107.6.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57ED951F3;
        Thu, 21 Jul 2022 15:12:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uq0uP2zn+NfXI+lu9UzRbk5WFKd3JiQLlhDtN3LqFWpvQL7bnUiMDURBUniS25FEC5tunY6DrLPxoVo0W0emI2YwVItvEm+/DOIXAzavbo0F1L+1A/pOsjZnGZjGfikvtG44NA3i3GcN7cYA8/dENqsCyr0XBMY1NeG+al8+sAWFc7hmTQmPWIl+5TD58aq89MJb8BvaUsfMBygDk7g0NPc/T4bmKyEQnGjKk09LKuD7ig3k8AVKV+Xb8rF9x2J5haVg1VzhUDnfwjrDb/WBfhwPc/8oXxWZzPH3IlZXN9YgVDy9Qm9RRS3iR79nEDJd7DAW0B32mED7ECVaoJ1P6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2d5Je96j8ZM8qDeI6GKKuMoaTi0HoRSzPkUWBd+i/D8=;
 b=I8L9hxM+wbAn8YRm8EF1hbfP+y8VnP1DKP3WowojaFKg4Sukcg4ER8wvIAEDllNJI1lK8/q/yHynH7J9ISI2WETKaax897HvcjPlAqbZRXcf6Zz7v/Titcv2QdHicX4UEQRLrWbMPq+AS9MAQUxKzDhP9+5vv7AXqYwoOIPWe2EvhAW/0RNxnWC7ZkOKCgDgZG7XTQxMhFr3WmauItlNFYbHaltXWLpI/LLCu77Vez/6TjWVGFVM1BCAItWbBXcapN/Hd9dtTXJnSjC1SwDVKzMHSOdg/CwOXHvTB2fktm1sMdi139ry9ccwQa/ANvyK7Ci5LMMxgZXOFRQUSh3VgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2d5Je96j8ZM8qDeI6GKKuMoaTi0HoRSzPkUWBd+i/D8=;
 b=X7GtsekZSsQFfZ5rNRM+Zzik12byfuvVJ2PXYKMDHwcSxNjn0AXT8OI6CWfZcQUUrJJaJNR5W5ujxMFuwCZ1flfO8jswTOVm+5Yf5skUU5AgmPj+fZIR/gBtsw4CDRYx4rZ52d9O1QsyS/tDNTc0mAMPJdlq4Eu0ruauG9Yi6Ys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0302.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Thu, 21 Jul
 2022 22:12:10 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%4]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 22:12:10 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v2 4/9] net: marvell: prestera: add delayed wq and flush wq on deinit
Date:   Fri, 22 Jul 2022 01:11:43 +0300
Message-Id: <20220721221148.18787-5-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
References: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0005.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::15) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec588c6f-6941-42cf-2b36-08da6b660e9a
X-MS-TrafficTypeDiagnostic: VI1P190MB0302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2odThs39hBNe7GZmLEuGDxDdlGxCnZhL7zP8SXK8M2auEYe8eZvcKPEoF2y0DEqTL3x2CHqRs99QQtlOutDY0bWqWRyjZ90bH8U6X/IhvdctJPUnuBu2qN37JMM7+ljxKIKa+N821MH6eejwZRY3GvJarGnUsKUsuUqN7DU9aBC79M3AQiEPPQ+2mV/JiAlOZz/oCBI/qjnjXIS9BZoZr85eNeCwzrBUW1ON3XpY6Vle7O5h7dRbESldnPyGqGZju6KV1dbXqkIWzem7UGLA2q93dIP07btGvYXQXhCYw99ksF+ntbIW6lG0y/WZmKT+mgVgkqqnMKSsHrVM/qeqmLU2WQNy1rAm9Sh3KujqtaXihAXLyzbZ1XKEGjxnyxBSR0UKrE6hA/saIqPPxQU61Vdwaz3PkWnSh9STTZtiXjxMznvcFZ4oY1FCR+82eIMdMsHcXCNIolDLhAZH672rBJeGa8m2K19c8oLpNq16UmBBIZT0UOAsUEIke6D4KEMSd8X1dApv37P3Iwt6Z98fJ+KZxMOY/RoA/JVCfQc4RgOd+dph/tnnFVUuHOWbcCSeRqsoOjanYipGG/Kr6QrlBvmSTiFS7r/SdPurPDjMMcM0L0OgvbeMphN6keTNaPyCj5stW0KkKUbat4O3GvLKE/cUT+is71O2tu8hbLyz7GwEWbmXWfAHuKG/WoWnRrITr58M35Rh/RXYlpP+XfrsQA8PVjFkY/zGHQ4yGWe5nY7rj6fxb0aAPP2VuDridynDlOm/+UpTFlwK4t5wYbhxO4F5V/ZrM8NreJI6msy8Zs0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(39830400003)(346002)(8936002)(86362001)(4326008)(54906003)(66556008)(66476007)(8676002)(38350700002)(38100700002)(66946007)(6916009)(36756003)(52116002)(478600001)(44832011)(7416002)(6506007)(41300700001)(26005)(107886003)(186003)(316002)(6486002)(6666004)(2616005)(1076003)(6512007)(66574015)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J/FUepGc3KpT4w9xWDWKXZCYZ1h6vLANoQwEUFO7O4oHaRzQa5ew9wh/7FK7?=
 =?us-ascii?Q?WkvhT/LawgHgeVW6bS7fh+rWVo5Iki6lzqZw96d9psvKk4b/w/GjcpvcEPb9?=
 =?us-ascii?Q?G5qluCuvoQqhybU94oljezEHDIAOEeYjF9Hd5H2axfsRmooyJbb/3DUvbDG0?=
 =?us-ascii?Q?gT11ooBkdflL8idZgac/ICcN50AhA2ayIH5Qc68pTGNbLv+XcMTGxdO65/LQ?=
 =?us-ascii?Q?9qdafabZXTD0WVkVYVhY8SBCet+nbHHLrVp0wRS+3yknjgViecr9jG7A1Oln?=
 =?us-ascii?Q?+Cbc3M3t8cPCD2DH+C86TfDBzwBoxHGzG3ATtFyPQdhm2r31BKruVgT8NbAE?=
 =?us-ascii?Q?zsTHP3um9SJ6oOiy86f6y6QP6ekOa3iH5e4UeBKE0JUP2jNlJJJRtFwTaVbi?=
 =?us-ascii?Q?mz73kOJ5P9XvYjgpmQsL8neHx+51e6Yxur+2DWXjCHePia5MYJZEkPhfercJ?=
 =?us-ascii?Q?wet1nbiW4p3ieONwFzwzo/BmHmpiwseFcVauO9/uToankpnD+OmSdeFe3Dm4?=
 =?us-ascii?Q?NCIuGVoy/a4pSAh3dFWySwim9iqIeddv+ZNCeHNAjvIClmik4vJcYKuBBLuF?=
 =?us-ascii?Q?75slNFvXcs1sZVu9tCiX2jcH0uSoe+Mvk11PGaGHsV2OwWYzuUHcRqQgaMLb?=
 =?us-ascii?Q?reu4VKZZ26AvplN/OQ+LmizDQsHHsodCS5yyYTJMhho+wegpKbj5AreViKQv?=
 =?us-ascii?Q?T75bRnc7uKwo4/lMX0zFWddyretxYhAyxckcQ0MTbeqQN7W7jqQ1qs+BV+pu?=
 =?us-ascii?Q?IVJNCNmEUetHNrhC/LxeLnfj+Sphi4X5mwMhjFQ2C3FsNDOcymLamRXhtadZ?=
 =?us-ascii?Q?Gd1l5VSCWOvOW2CueffgxbHigskC+TZ/AvZYusFoPQGLnJqx2lMlHjNBMNrB?=
 =?us-ascii?Q?CG2mWjdCBzH8JR48wSWIgoGS32Ixccc7tDrHhR1M5Kl/3PpFyWDPN1fO+cEN?=
 =?us-ascii?Q?9v9rU6qWLu7Oa/v6PRroC4CRo24KlaItVIyV+E1O3YggS+eCbG9N7e0EoYf9?=
 =?us-ascii?Q?NK6h2ZkPf83e34utXJgPC0pwnCN2DGH0l2+KOsQxV5UkWwchqTLM7qOkNObF?=
 =?us-ascii?Q?ih+4GDq1qvB8KYHAly8la0R84OwsbWhCJULkB/B42W17UszCt15OnMqdZRba?=
 =?us-ascii?Q?AuVYwCle1b2ToIc3HUvPxNAKcFtdkFKefSbIQP95qULFggm3IOZcrfswwE8F?=
 =?us-ascii?Q?rnzKwebxD6efwI+pQV3VNEGF4qRZfggY9QI+447Z9We1cIZmVo203K/WKlqy?=
 =?us-ascii?Q?ERQbEHDacAq38r1wxOlhxzPWjwJfwaK6hymVMWm/TCIwpupLQwS2UZXsqolf?=
 =?us-ascii?Q?rwaYIrTjpo5/o6jZlKYk7XBJfLCwDGOsMuCoprluZgtuCBf5PS5X9RmoRT5y?=
 =?us-ascii?Q?tQEedkXIJthxA8C2lJT1O8blEs2Hl4DpDQNnCx9JjNAa0m2vQKXsOwwiYAK4?=
 =?us-ascii?Q?fKwk+oyvWPqPInycBotb6CqZNzPdv5r+P98hkoG9guMQUpFkP+okNGiqe2fl?=
 =?us-ascii?Q?V19weGrxzJ4RDAhOfTElalJ1VAY3Vq3Tewo6HLNLGMYWa98feLxsgcEfQ8fI?=
 =?us-ascii?Q?TtKTMWbBn2AxRgi82PGVPc4zBFT27swHKmSr86VbfpBegYPxVJXx+yvYfmwN?=
 =?us-ascii?Q?4w=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ec588c6f-6941-42cf-2b36-08da6b660e9a
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 22:12:10.3417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cojxw0ZUGIrcNZmNxMPO+vABEtWw5TT5EiHubWQ18eAu4cGLItPVi0LAfgTy3ir97bG0LrQqBwMRkL2qpWV4714kRnl3LcubRHqJS6stm0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flushing workqueues ensures, that no more pending works, related to just
unregistered or deinitialized notifiers. After that we can free memory.

Delayed wq will be used for neighbours in next patches.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera.h      |  2 ++
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 11 +++++++++++
 .../net/ethernet/marvell/prestera/prestera_router.c   |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 2994e0a6e5ec..a3a112f5c09e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -357,6 +357,8 @@ int prestera_port_cfg_mac_write(struct prestera_port *port,
 struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 void prestera_queue_work(struct work_struct *work);
+void prestera_queue_delayed_work(struct delayed_work *work, unsigned long delay);
+void prestera_queue_drain(void);
 
 int prestera_port_learning_set(struct prestera_port *port, bool learn_enable);
 int prestera_port_uc_flood_set(struct prestera_port *port, bool flood);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index ea5bd5069826..ad50b9618535 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -35,6 +35,17 @@ void prestera_queue_work(struct work_struct *work)
 	queue_work(prestera_owq, work);
 }
 
+void prestera_queue_delayed_work(struct delayed_work *work, unsigned long delay)
+{
+	queue_delayed_work(prestera_wq, work, delay);
+}
+
+void prestera_queue_drain(void)
+{
+	drain_workqueue(prestera_wq);
+	drain_workqueue(prestera_owq);
+}
+
 int prestera_port_learning_set(struct prestera_port *port, bool learn)
 {
 	return prestera_hw_port_learning_set(port, learn);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 41955c7f8323..db327ab4a072 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -643,6 +643,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	prestera_queue_drain();
 
 	prestera_k_arb_abort(sw);
 
-- 
2.17.1

