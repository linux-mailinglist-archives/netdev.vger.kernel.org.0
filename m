Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3CE5BBF90
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 21:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiIRTro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 15:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiIRTrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 15:47:25 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80102.outbound.protection.outlook.com [40.107.8.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD41A17A8D;
        Sun, 18 Sep 2022 12:47:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jir3/J6UTMwZjsx9ps9rBnGbOTL6Zg5EF3a+1CKWxuYw2CzNjFlh1P0XR2jxEIjYyQK03kuzsbw92SYvl7ODXIEWlYR96oPnGJHQYeUsFG+sO03ZFGWTl+fXZjPOgigkFkyCEqbLmtK+oTXNVqCdAhI1HXzspDHHX0oxU+DbohhTbOJmivQAW29DycOlUKQlPvKoFW5Fj/krDZRKFVQoObxd/yX2h8VSrjq1+C6trLM7opShjXdTJlSG7A7tEYrFMWF6QtIQ6o1UOiYheqYGK7hkH2U8gD23B4dCMn+yiHPnG96BQMRD0tUwJn3XEkQViL7xuqd0U2lvnEMWQlth3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hn+vllKNqCDrzvCy3JLN63DRNdTmAlku1u/GsZVezaU=;
 b=D4G8K2bNf/dPckmfCRyVUfIwFI+0AGJh8fR0MuDPqTtaaI9z0sJTSwJZhg4GShZy2CgChL7MXVvVPKRYLIc0oRs3ZawIPeKhzARdp2GhizMZWGpB6oylBbQ2qwqPSQMzn0f72GSVUWAjpIIqPuHwBdKkUIXdmFOWlI2gUC4I/PW8gK85UOF3ZejvKT3ELPHJVShdF3maLQllWD1sKz16b9S/d72ozSD251WVtrxEQtCeHRPrtCGM++1JREygF2CCkgXhfBVPWhrkFQrM6SnpO9M1dY9ZBQ2b+7ljdPNWORhjEFOEohuP+BTGMxTybEt5HXB+aG/hUIqnwuVRo5Apow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hn+vllKNqCDrzvCy3JLN63DRNdTmAlku1u/GsZVezaU=;
 b=E/PWlyCKp4ZHnwkMKal9mO4ddUTIaWoYyUX81HVh3u2Fdnl10R4ZJ7xdwgRdbvI65n6SqDokSWtPHQmAuwOdpxWs7+dG1Wau1xItkWEYrcHQKYRUYFfG/LX/dYHX5iMXDsAWnCPR3/eZYC4dcDq49II7B9O9wuECNUKS74n8XJU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS4P190MB1927.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:513::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Sun, 18 Sep
 2022 19:47:20 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f%5]) with mapi id 15.20.5632.018; Sun, 18 Sep 2022
 19:47:19 +0000
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
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH net-next v6 3/9] net: marvell: prestera: Add strict cleanup of fib arbiter
Date:   Sun, 18 Sep 2022 22:46:54 +0300
Message-Id: <20220918194700.19905-4-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
References: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0006.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::18) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|AS4P190MB1927:EE_
X-MS-Office365-Filtering-Correlation-Id: 08159167-61ea-4208-2889-08da99ae990b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8iBoHYSpDt8woIk78655dGEnz6C60BVyFNUBFwFSix9AjhcDyc4n8IUHLF7dj0f05sfK8pG+0ODKt3HYjrOyr0BiuGinIMbnujkNNqA8kIviIzA22G6Al/uX5RQd5gYI/t2AaeRzPoCoBPsnKb68z2wPHd0NgoJ+QU6ItZBsfW6rZ4Zr2VIMSd2R5PFN22thA6O6sRs1b3zQSpyl4wNz7f9RnzopXqEx5ehRN3jCxkGJUpeLFOLHgQcYqeiCpmp4JF3yysrpzKfw9wP79DjN8oj//bJ6LT4ikOP6tJSgWXgY3wBTnHESf2JQ4Cb/Kbkpm0sF1Ry5rv5OEGAUuTXPhFZ8iWWoBql5mDHSMNS8YAQmfKjHqAD6BQJLM/Ogy9plmvTf7ip+yiuZVmCDmbVcxltxm/Bl/PhntrMlbm7f9WII1VJ6f8gzu2/E5aGBiLZGFGJlYmyoKxSYDsPXUjqu13XczvjFF7u48JuNwwlG8ttURlG8/PP94pfoBJ7r4+UMFbcXa6gm0iZqaTvUYgC/2bEx2rCALIkrxAiNRa9K08tM3Hwly1O8tAmZnlyKiEpxrZ61P/VAPZ1tE8CEX0Nle0zGEI4XbreWgpXmtruDoUqLSqC04AOOsJDsxKwllrgUWfVA498utFFm2LgApC5ZLQnJ5yIBwYRew+3OlbSkztVryVneoJ4p2A+Cc/wygRhdD9qpM4mP+Pf/UNwZW5lp5wtUn0Dm3wIPqrGt1FqyXK9EF/x2N49Qesu9xbuJE3N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(39830400003)(396003)(136003)(451199015)(478600001)(6486002)(316002)(36756003)(83380400001)(66574015)(186003)(1076003)(2616005)(86362001)(38100700002)(38350700002)(26005)(6916009)(54906003)(52116002)(6512007)(6506007)(6666004)(107886003)(66946007)(66556008)(41300700001)(44832011)(5660300002)(8936002)(66476007)(2906002)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vlA1JDRlvojTisd0ZlunHPGL/cLyURYZ3ocuPrKUkBCbiWSlQNC6tvX/rFF0?=
 =?us-ascii?Q?xptv9i9AqhRFcRE8TpAtro3W9g1YpvgRAONbCcf41x8zS80kEgWN/CgdUj3u?=
 =?us-ascii?Q?MidbS/PODt7DsPuLpY8m8jU4IBf8pfUauFM07UqxOqNoOqdMdf9spcJzKuh0?=
 =?us-ascii?Q?pwzFNDO+xN862YJJXRey1jgWSVYcVp/hI7MaU72zP9Ctl+zioCUoDVUcaIyU?=
 =?us-ascii?Q?ewz9FNuL2ugc51SAhQQcZw2rK72pdjF6ox1xZc2OxdvRywjSxJMk0AShBHnv?=
 =?us-ascii?Q?+Rv2+rA7h28xP7cqt/qwHEszxC/UpmKE5/5roRc5keHJaVCLfZETHbK/yc23?=
 =?us-ascii?Q?0/+K6o+wxcvZJ17+vqeBbUAgOzEzdtO1mWm5H0kc2JD5GDca3/4q6fEjhOWP?=
 =?us-ascii?Q?3I5vrx7oiAkR6kd83qEFsghXCiX9MA4PIRDLNq7X0kzz36uC/K0qnXFRIcjo?=
 =?us-ascii?Q?FoWD0cspnLd7x2/WkuOtTTX1Jzh5wfTfBQYHAvPcwLtb6UYZ6dn3sU0bqYid?=
 =?us-ascii?Q?G4Kw0wqcyzbaEJOiEeGL/LT8Mxfrd5zd7Ni6s8ctdEKawYGMlGWAe59dGS5Z?=
 =?us-ascii?Q?VbYptor5YB8530EEukZHkgwpYcI1290U1E7i+mVPKvI/GYLsEn/OcMoa6+oV?=
 =?us-ascii?Q?PG0izMmj5Dso2xdl3V/0fJ4i9IcMRsypsHZfqaKI3+ac0IjmvhaVqEU38Me9?=
 =?us-ascii?Q?nuVb7bWrUDBTMShSFE8j+SqMT6v9RQYa/HI8VvoG830futPCjc1fTCOMdh5W?=
 =?us-ascii?Q?CCNS7p4G7GCLym0CO1bjqjQyD8z2bF8vILTwCcs3D0ARAlQw87zuCKBqw+dn?=
 =?us-ascii?Q?XP+pZo/JQsjtUeYnIDYyxQ2jk/ACU53xio58Y9pDgL5Y5TfqdfNbQSke6BII?=
 =?us-ascii?Q?plbU9Nksj9PBpgadttzY2LoB71oS7jDCcPVsTbOM31EE4yRgyGJ1CuhQ8rWF?=
 =?us-ascii?Q?G+QHi60SyXr4utvZa3hK+11CCSR0P6K49EtOujdBVhMVGwcUrjYS8jpfjL/Y?=
 =?us-ascii?Q?JWbv7f3aG4ivLArnbP2hMhbhX9+UA3WCczUDdZW4nVT9HxHgh8BdRH75+RN8?=
 =?us-ascii?Q?D2nKtXb21HV7gTPOHRMZ3ZHIH2KNBiEvC5Rf4qxyKqTtsaNKq5linsGMPV29?=
 =?us-ascii?Q?HoXJH0LC/jxx5wGUG6FeXakdjxUUGy9KFK8CuGwQacu9BygZBdVo/RzLlPkX?=
 =?us-ascii?Q?PyUGjqyU5J3p/jzDggQDcrDjTq6bFyVjuJtzEHv72W6jnHpz8S3I46g3NKzA?=
 =?us-ascii?Q?JrFcArBvwE0CtyYi/dwLDW9LR0cjRCInR+keNyiPyd6Ia7xNaoCVUSH+fbJ0?=
 =?us-ascii?Q?VxxE8YADo2Y8BROJrzuM3KUyvwT9isPVFX2/KGZhJ3MyTtz949kfGtZMxquS?=
 =?us-ascii?Q?rHiEhJzSD5/6ITJ+s+yuuxg/A5oWOk787avgTg3styRc4ATHAQ5aDq6kurqs?=
 =?us-ascii?Q?OtonS+raxubw2TH7DAyxIdpQ2zhRdgwMkg874FMQVDDFMuu5IQjfeGHeDUbw?=
 =?us-ascii?Q?myVTDB+xJbxVHcJ/kbkuG2JLZyaLNhcPO+cV6qQPYvEEiHSt/4BIDl7zVbnd?=
 =?us-ascii?Q?HkR/Szms0ZHAWjD7tRsazm95loAu082uNS6C8p9FWHfNRWagnqVdiM6Yv/Fy?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 08159167-61ea-4208-2889-08da99ae990b
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2022 19:47:19.8756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QuNbyXwWmuoIhB9w4NYoH+slvpMhhYK/2p92UASmoPFobloJ+5h5V7L1Xl/WHLlNa7zH/e3QFdWMDrumih2NbHha2CVDQdN+xugUBRzSSdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P190MB1927
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will, ensure, that there is no more, preciously allocated fib_cache
entries left after deinit.
Will be used to free allocated resources of nexthop routes, that points
to "not our" port (e.g. eth0).

Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router.c        | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index a8548b9f9cf1..bd0b21597676 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -336,6 +336,49 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
 	return 0;
 }
 
+static void __prestera_k_arb_abort_fib(struct prestera_switch *sw)
+{
+	struct prestera_kern_fib_cache *fib_cache;
+	struct rhashtable_iter iter;
+
+	while (1) {
+		rhashtable_walk_enter(&sw->router->kern_fib_cache_ht, &iter);
+		rhashtable_walk_start(&iter);
+
+		fib_cache = rhashtable_walk_next(&iter);
+
+		rhashtable_walk_stop(&iter);
+		rhashtable_walk_exit(&iter);
+
+		if (!fib_cache) {
+			break;
+		} else if (IS_ERR(fib_cache)) {
+			continue;
+		} else if (fib_cache) {
+			__prestera_k_arb_fib_lpm_offload_set(sw, fib_cache,
+							     false, false,
+							     false);
+			/* No need to destroy lpm.
+			 * It will be aborted by destroy_ht
+			 */
+			prestera_kern_fib_cache_destroy(sw, fib_cache);
+		}
+	}
+}
+
+static void prestera_k_arb_abort(struct prestera_switch *sw)
+{
+	/* Function to remove all arbiter entries and related hw objects. */
+	/* Sequence:
+	 *   1) Clear arbiter tables, but don't touch hw
+	 *   2) Clear hw
+	 * We use such approach, because arbiter object is not directly mapped
+	 * to hw. So deletion of one arbiter object may even lead to creation of
+	 * hw object (e.g. in case of overlapped routes).
+	 */
+	__prestera_k_arb_abort_fib(sw);
+}
+
 static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 					  unsigned long event,
 					  struct netlink_ext_ack *extack)
@@ -602,6 +645,9 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+
+	prestera_k_arb_abort(sw);
+
 	kfree(sw->router->nhgrp_hw_state_cache);
 	rhashtable_destroy(&sw->router->kern_fib_cache_ht);
 	prestera_router_hw_fini(sw);
-- 
2.17.1

