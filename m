Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EE25F1B62
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 11:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiJAJeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 05:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiJAJer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 05:34:47 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60127.outbound.protection.outlook.com [40.107.6.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D6BE21;
        Sat,  1 Oct 2022 02:34:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhVd9tYcjv+UVUshXZj84roLd0yuEEnG5A1tePVuX2l+pX5UfsyNIHGba11Xz6M975M1v8MQ5CrfNrDc3yHZoCLscFe65+enCUa3Y9ZXPv/5x8kaEWcivFYcP/Npr15kHAOCtVPvGEj2hRbi7OKt5y0/HJvkuwMqg2fnlB7EZi4jzjYCBtQ9wwEeXKTQNoofRusmGVpPkSe+lIBsAkRLzUGdKJ9WsntHhPEIhE+QryUOhXfW7FX517lLCoyRYNIySw3l1KdjL7SJ4sdXxMmJL9/aTK2hEDZDMvVRnC94i4rpOkzwG03p85bFEiafpFm8xl7skmE7ZJ+chGgLBr4ASg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmTOzSD/0xJtBSQpqdUGaCrztLrPlE2yH8VK2NZYeZo=;
 b=bPo9lDatbBheUioKQVI5NXrwk6xBzo8bHz/63R0EEBSOTVwC+mmuHCzBfA0g1ggeXbAokuEfjByQtxGISs1kmA2lS8/jKnUGDIHaBjW8cb54+52rpByJvx0Akl946vySTeSk68hGUEUH/KqgapP4fKhlJRekta0UTcy1SnA//ElKz9T5ZSBzvPnM7JOuk7TuJTsbn9G6nftUw1T1p/lTA4ERsBfNnn65vBuTkX7VkhxFWVoxK6Ox7Gk3MxGyiqvoirMPcKNyJ9zOtFN/wTvKiJqaISlToqEZ3YdJXjg0nRQpinCFIb2jQktQJMLd8SNRwB6oQQ6H9Js5vuBKYURTNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmTOzSD/0xJtBSQpqdUGaCrztLrPlE2yH8VK2NZYeZo=;
 b=eUnqiVD5gaU7TqKbYsRlTMoMozD5TjpWRlpdGiJgHqYPSxAlBf+b5LaVV7gB2xKUWGYsPKk7TI7MFOTdNDmVj8S4nSaFPffCUp4DyQlP+vlNcLEC4Yu4QlDQGOs/cTR2WfifKXBK3VYBsoAgJ3Vyeb4SserGkOMwE9TcqK9ZCt4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0733.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:121::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:34:30 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0%2]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 09:34:30 +0000
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
Subject: [PATCH net-next v7 2/9] net: marvell: prestera: Add cleanup of allocated fib_nodes
Date:   Sat,  1 Oct 2022 12:34:10 +0300
Message-Id: <20221001093417.22388-3-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
References: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0696.eurprd06.prod.outlook.com
 (2603:10a6:20b:49f::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|VI1P190MB0733:EE_
X-MS-Office365-Filtering-Correlation-Id: 44b3778d-72b8-491c-2270-08daa39023e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pik6QXvSjIRCTq+WIT8ZUN87nAlML906sF7/qtaTv4DeKVmLm+YW6v7IltvuHCaY87+puh6ppoZqE32DzilTils4Fzx62M5wrlaetmrOyxjxl2r8bsSdRKfBHu2DcA8257Elsl8sHn94rIZwkd+4J4z5pDh4BZ6Ak7sAmY/QJS52kxL72GfiGbRLnQnXyB/8T1A7KVa6eX2BbDOIgvfi59a2sE10LsX7qrb9fzlWliFNRHqV5wp9puSLUG2VAl8YzIYUQgc1VayVZKWuPx1fZwRe2s9B0k/Bsix1xjtG51hlXoJ/YbHVFN/x6GkO1kF8rxzSzSin+0zwyvGgArdOD0qx/KtIC2ZQ84I033XOeqrSt8DiFL471kQi1PqtKxdvaVQXMX+nsw0pliSXdCgQI33QirCTTZQ/3w+DWrcCJDHvJC1RUilWJH97O/PdIExOIZKs3m2An+hvTwwLsZFQs5qaq8SfpCk0LX+G6VjuVLT+JkOstOqFprKSudigsG8BlghBwbAWJnZaEvsx8qNrEPyuMWyXGqY6Xg7IqJKmDurju37iDvcbEMrsyPwFhERrc7amsjgZpxheIRIQvMQU2rJhZEwFdWVZA7wqrlK+1C/D4zIrUq529EJbOdQzfWLGfZdgSMOVP9vPIWczDP5+4522432mob3iGSTOoG8YegOqw6GSjW4lPjFWw8nhPwdw4FftNMNJm7HgjgRlUYgBpGQxNpwMugw5NzncYpcIQkEkpOBTG5u5l7IuTbkFSRdJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39830400003)(366004)(346002)(136003)(451199015)(66574015)(38350700002)(38100700002)(5660300002)(86362001)(26005)(7416002)(8936002)(6506007)(6512007)(36756003)(8676002)(52116002)(4326008)(66946007)(66476007)(66556008)(6666004)(107886003)(41300700001)(44832011)(1076003)(186003)(6916009)(2616005)(2906002)(478600001)(316002)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5kNlyS2rj8QbLSP7fLXy33/Q8ReFIaE1Ow+HYJU3BDbMrcw1x4ZbM0RGQZxI?=
 =?us-ascii?Q?ELR7OuUhZ8ao6L4wk2b2TEdw4iWiedgUYcepIdZnCdW76hlMM3Jj3erTintR?=
 =?us-ascii?Q?L8RIcyt+I0COoz1mMMP0hvv/1hLluAWC3CahD6eLC6dnonMWmVShJ1qOcCSl?=
 =?us-ascii?Q?uMLLOCjjjdTzJXVkai2bsCeeOFgx9Zx6q3HrqV3Iy84glTTQDkG82znn3BVU?=
 =?us-ascii?Q?DV/2sQ4T/q0Gb6hnb+06AabHA9owWnHwGYaGQVXq5viRRiBzrq181gkIpkPA?=
 =?us-ascii?Q?qQKdBqqFeJG5Cyx6gtFG7ENlWa2HU+qHacexvgwm74C2T8qM2wGGy956+Eyl?=
 =?us-ascii?Q?IO6XQjNLqZ8yqdEWcVIFTgDz7iMDDJ8wnQmn04oU5u2M+HHR2P02H74hjGtj?=
 =?us-ascii?Q?zMtuRiOUWPfgQU7o/4Q+O+f8Qc8jEgqqRnd+Km1HLVlTA56ks6IiM4YID+kM?=
 =?us-ascii?Q?1uSzjUjHZ9XqdXMhUkAySQzg3dztdyke42y1XiCWOkPK9Z7yC13C4P8k/9hg?=
 =?us-ascii?Q?ANet6Wscf01UfEs4xc1G6xd6LnUBiI/VmepKtsEdwlgF7TJTfHiYFopQuh4J?=
 =?us-ascii?Q?Dc55Sejas7LN+3qL0ExYHs1klLW894OE4XPvPBmomQVb5MEeyYCbLuF/sVcc?=
 =?us-ascii?Q?VY0uBN2PqjrC53OPfkO83lpwfxQQys+Mv61MWucVPrAj2aGTBxdVrl3C30h0?=
 =?us-ascii?Q?CQ1XgT02o6geqvtRI5PlCIQoUUdc2CWLewmfgMHWQ4wa075u0W8nqh1kHlY9?=
 =?us-ascii?Q?LV0pxUJhrrOSYLnGVgAL5aQIXS0UH1RJqHCZOfd6+KQNaIvcqqI5WGW5Rxdi?=
 =?us-ascii?Q?PRsmdV3bbA8dXae8AZT2vzwCjUZXBqMz1f+G/6C0AQeTFMo5QVjEXBPVe/Vf?=
 =?us-ascii?Q?0GP+cNiH7y9O5+VGAYedJbh+btYp+GrEJC7+BBmzT8MuTQ+pMLqfJ9tnziIG?=
 =?us-ascii?Q?wETPsfOUHW7gSohdaeel15GSemH8zOYbA528VOUyglOjelTBOrdOflYPrfY0?=
 =?us-ascii?Q?8Gplw2/yGI8Ke8hv6Ss/5p4IqhGW1DXmx2WMZ0UHIy4r0HXK6eiv9rAqJidk?=
 =?us-ascii?Q?fIHRRXtFMRTwx04/rMRblaav07+kHnwgNsSnop39raxeT8TpAJIQ9gqlEqeo?=
 =?us-ascii?Q?IlXUhmf+YbHTmZx8sIUvnKbr30zDPOLQxCpP197aRsv7k4OYcxOy/GZDoD3F?=
 =?us-ascii?Q?QysR3fXXt9tmi+10wo8EMcGeSOFqrToU8YMiFCtyCFMuS4a2FSc24sl3iIUj?=
 =?us-ascii?Q?AEqIRqDQUCUrXXZbQF5c78npvLcij9Yh3eElAooYHvpFNwSzlAVt6bdurqJG?=
 =?us-ascii?Q?2y69FLWhDD/hV8UdiC9npnyd/tskzrseTyQ/jG05+cp1gJ3+TjDaGs3iQqAP?=
 =?us-ascii?Q?oq+Pxxdk39NRlx5whpXyiE1+DLTDdEK9Wcw3Izc9epxWr3EHFxulLIrCGqp6?=
 =?us-ascii?Q?Tnhw/fmnTf0Go/F7yXnM6R41fSzv6pxfRK2UouXgWLb4C3xUxDqDujEkoCKY?=
 =?us-ascii?Q?Chql061W0CX1D2dvorFS/dL/6d0lN8nNQgNqNjvKIBPxtWbovG2vKCoKEk/3?=
 =?us-ascii?Q?oiCmcepXxQO7dW7qaWZ0vw1ebPtk7nqU1M9NF8Gm4DRX4MToimLU4vg2zZh6?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b3778d-72b8-491c-2270-08daa39023e7
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:34:30.0564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXJoE9l4wjbxRakwDOp1IN8PgH+uUcT031HY5qsvxaFhX4dB8cg3zQpTf4uHFnqj0hYLqisX4x4pMDeUmAXcRn2TOZjU5rUjF90GMzZ97K0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0733
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do explicity cleanup on router_hw_fini, to ensure, that all allocated
objects cleaned. This will be used in cases,
when upper layer (cache) is not mapped to router_hw layer.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_router_hw.c   | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index db9d2e9d9904..4f65df0ae5e8 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -56,6 +56,7 @@ static int prestera_nexthop_group_set(struct prestera_switch *sw,
 static bool
 prestera_nexthop_group_util_hw_state(struct prestera_switch *sw,
 				     struct prestera_nexthop_group *nh_grp);
+static void prestera_fib_node_destroy_ht_cb(void *ptr, void *arg);
 
 /* TODO: move to router.h as macros */
 static bool prestera_nh_neigh_key_is_valid(struct prestera_nh_neigh_key *key)
@@ -97,6 +98,8 @@ int prestera_router_hw_init(struct prestera_switch *sw)
 
 void prestera_router_hw_fini(struct prestera_switch *sw)
 {
+	rhashtable_free_and_destroy(&sw->router->fib_ht,
+				    prestera_fib_node_destroy_ht_cb, sw);
 	WARN_ON(!list_empty(&sw->router->vr_list));
 	WARN_ON(!list_empty(&sw->router->rif_entry_list));
 	rhashtable_destroy(&sw->router->fib_ht);
@@ -605,6 +608,15 @@ void prestera_fib_node_destroy(struct prestera_switch *sw,
 	kfree(fib_node);
 }
 
+static void prestera_fib_node_destroy_ht_cb(void *ptr, void *arg)
+{
+	struct prestera_fib_node *node = ptr;
+	struct prestera_switch *sw = arg;
+
+	__prestera_fib_node_destruct(sw, node);
+	kfree(node);
+}
+
 struct prestera_fib_node *
 prestera_fib_node_create(struct prestera_switch *sw,
 			 struct prestera_fib_key *key,
-- 
2.17.1

