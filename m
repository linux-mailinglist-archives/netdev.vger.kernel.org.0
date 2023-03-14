Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BC76B9E3D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCNSYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjCNSY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:24:26 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2043.outbound.protection.outlook.com [40.107.105.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723DC233C6;
        Tue, 14 Mar 2023 11:24:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfKvcCfm/fUJhVU4LMZGz/tTXmwUztHahE1e13YpJGz2OdXQ5+ItZgx4kC1q4ymsCC1FLG+drBQcA3/oVSyBN4d9EGtjR1Nt7enPYfPehxRYkzN9FfvDTTI35LSTL3IQ1/i6tkr4/vqEM2ORtrImaAQlvq0d/dAwm89sjWewy4t6SLk7jUdb/wbgSRMOFZzZsytuGFENd/PIbYQd91YR4q8kuLDupWfL8CT8CpKtuLa2dgrMSaZd9XT46Zq0hbeXhwq7D1bjZ6GZ5Mv9k44Cp1Q+W26Ny4CaQ3H6t+MZa1bOHRbNe5pAlySvjMgh9Gi4ATd8Zu5LuQavIVMJ0D3aeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eR7QpYWXBw/qReJPhtbzYNdvR3ntTr0TG5tipWAGQSo=;
 b=Q4vitrl1pbVf2L28R2zDV7EDW/4Fj3k3hhIlgdIZ+KJeTpEMv/ylUUfhJTf3XIucQefjcGZcq2uj+F6uDl14IU2pTCXHew3A/Ob3Dy2h6lRYKgv1kG3FQQNaBlJP5dL8U6GKeZUX0+K0b0qFi5rSJoitk/O+dIuQBmU9jAYQfhdOKdJqkK1ZLX3rXFqgs+0mTaEdIj57ubZmH5o4eQEY0bH4FuKrz20FOtrEHUCCB8vsOkx+eMrrROBE77XHeVRZjY8nqPe1izrOAmJGAgJjRvQm9DbMZ11hNQlqKriZKGamIVPVHgGjwy0HY+AhwQZzGCeo5/7Mk+WtfSThXF9ksA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eR7QpYWXBw/qReJPhtbzYNdvR3ntTr0TG5tipWAGQSo=;
 b=g3xHNudTDe5820bYynP3ncygBwSyDQRm8+C2r/WB+JtwoJoTOsUY5PdwypkTM5Q2MRhmtSQrXCP6wvkIctCwEGhC0CVUlp2uYiu+A1oUq9NCbdXIi5YXdShBWTBQSCPpmymd2kc6GAvs9HM98E62wxC5Ez64LgjBhETEsnhRFwo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8253.eurprd04.prod.outlook.com (2603:10a6:102:1bf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 18:24:20 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 18:24:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Lukasz Majewski <lukma@denx.de>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net: dsa: don't error out when drivers return ETH_DATA_LEN in .port_max_mtu()
Date:   Tue, 14 Mar 2023 20:24:04 +0200
Message-Id: <20230314182405.2449898-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314182405.2449898-1-vladimir.oltean@nxp.com>
References: <20230314182405.2449898-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0032.eurprd05.prod.outlook.com (2603:10a6:205::45)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8253:EE_
X-MS-Office365-Filtering-Correlation-Id: b737293a-4791-4465-ac9f-08db24b95403
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Wb3l3GovjT3EYb+13QrfX3QiRpRugvlIQ91yvTq9vvKoRY5QPa7pLuVxZquFCnN5wPMNUUdIsSmj3et9kQ0k9hWkl8Yeqt9LyQvMStll7Ht+vMlun/80A2O7whFcf3n3X6dMxTkRjQSIyPBDWcvQ9j/25Ic7sN5mhnG6npgxF4tdbL+FwN3MdWwLMVfQ4Z8jQTgEx7UiAZSWE4ZyESmbNwF0kTV9KWUoOjJv4ZRUSIE+ZaHjsGIpZ7Maz8eWK51YsfbvORwqKWm1KVO8XGH5E8OaWpx3JOWKtxnFUIgleZeVmNNU4hgcVJ1AcA9iRSmIfNJd60vatN1fuugtd3YbjHSD+hJhsaemlQkZ3ZzypIB5YnJyPYF1A5Ei7SPIeAqIkT2zLbQgTvJubLO3ZAg34t0UX5tOq+LOKS0yeoD4VqK3jma9HyDE8C5ZAqZKVTZeIfz45x5CNLW7QM2Xg9h34Osi+tZpLivQkqNfVF01ElXLeYlYFjzNrw99mfENP2sUK2kMVR4YKsCOpa8mYZVG8rhXW7gI+I/4ZR0kREpTINIKAa/6JEQmm0Af0+4qE6kuPFrek4BF9BK573s5Bfc9uuEwN/qQnulacgKAiqofkig+xoyM4pVTVTYdr8wwfwVO/V89BB32ub8jKTbm0ZXkRJexKLKdvEnKkZ8GJZJszFCZAVODgswkYtw6p8TNumhvvuHvnVpmGrcaWgCO5+g6GxQgb6BaVVF3VwFjKPDgRs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38350700002)(66476007)(66556008)(66946007)(4326008)(6916009)(38100700002)(41300700001)(8936002)(316002)(54906003)(83380400001)(8676002)(478600001)(5660300002)(86362001)(7416002)(44832011)(6666004)(6486002)(36756003)(2616005)(6506007)(6512007)(186003)(2906002)(52116002)(26005)(1076003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LjD+HUzTuT8tCi2b/8XSpLEiS729O82dRu4bVbAQnGeb2y7GtyGI28ZW7YjL?=
 =?us-ascii?Q?eYXZZGopC8c8Z7R+5seKEpzywtCenPKKwBWD7eROUzPeDmVpeWXcdSLnVD3s?=
 =?us-ascii?Q?kQYm00rXZFuD+tJgvftKQkm/v3pgeglAb7mgZyrEgsonNmjSAdG2Z4N9p2KQ?=
 =?us-ascii?Q?rZ2uInAcqXBB8FOovAufnzRSGuR8xx/4GSRxjZ8HLODDwoqXi0zVCvJQigLc?=
 =?us-ascii?Q?a1AA8Z4xwjEUum+hcbIf8YA8J8/darf+a6QctuawzMe9fnCBmRTMmJOwfSMQ?=
 =?us-ascii?Q?1dsQ1pdZBcNtA8PeyySvNB3Fw3d7rFEE6PGrNpyVWUpbrlCdmoB/cGomUkcp?=
 =?us-ascii?Q?MwtxLWNHHimIedRRheJJ8i5yrAH4Mpa5Cl14jS25xOyoGUq/oi2fI6KQBkqp?=
 =?us-ascii?Q?+VltJqHnyGXrrjngkF5iaqZgNbW9U6PPPRNpUiOSYo8NM+JRC72REE2gXsgK?=
 =?us-ascii?Q?VpIbFqQfmbIPGK9Xea8QuRXd0rQAQuKIJPKoaaNyz4BQhWytP8jqkcmm7JK0?=
 =?us-ascii?Q?AkJY5y9zSM9JrT0lBItjKE+hFj9rwXxokn+t9AbG4at/04nWBf9d4Rn3m/ql?=
 =?us-ascii?Q?iai4K3jkwwU+LXmWII41jLa90hV8NmI1EZKTeU6pSFgvEeDgDlp9rK+mAjQQ?=
 =?us-ascii?Q?Zz9y+VRxNZxAYg1+BlnAb5pdyawmC9Qm1w9r+ON6DZk6emOW83k13xt3eoRu?=
 =?us-ascii?Q?kTplCYdgVZ1EGp1XfXcnxR99xYe/Z3MVTZH5l66PcP/hFoLe1Cr7n/EustgG?=
 =?us-ascii?Q?Eu0n4d5C8QiFyzjQwrScsInNWk0ffi8EMWzf1g0lfIsvxXMWzCCT8HQW0HqR?=
 =?us-ascii?Q?e1lGeVsvNGK3/oAKIVX9d4x2UP1dkrB8xK3thC41HL2br0L4yeH6DooEZ6zv?=
 =?us-ascii?Q?t3BC3blS31oQ5Vjr10SVNOg/MxutoJ78Aso/cxRB89ADbrynD3iH4yYikO5w?=
 =?us-ascii?Q?3MaClT9nWbT2VFdGmBji8ZODR0dHrvc8PhjEA/vtgOK9bzgZeHhF7ihxfkcb?=
 =?us-ascii?Q?wMooqRJcX/rKcesXHnWFqK3h5KqopeVkvg1qBS4m1CSa9h8Os+/mTHKSet7+?=
 =?us-ascii?Q?MO9dBYvXSQWwqebPbhYEjVvDEWjPqe5l9OvZRhzOZ7l/3+UwaTLaffxTQZHI?=
 =?us-ascii?Q?i3kNwf6Pzbm/oMd8Arpz6XIy2UxTMJOdzJZKNNPFWIh/2CJ9YnZRGzAAbUWD?=
 =?us-ascii?Q?C89SMUR5pEJlmTdHVST6R6ZnzMNkZ+4bXOyu60J45BOgbB1/27Lr4Ks3VJgM?=
 =?us-ascii?Q?Yb2TTXJZiRmWqzhV1+UAbGPy3MIuFOZehTdy6Jl0maYAqzkF4r4+gJcchLDB?=
 =?us-ascii?Q?jwl62lwBNnaUm/MglLiwpU6dQ8nLTPAG7N+n8jnu0ro3rX+OaVb/nny6JXgf?=
 =?us-ascii?Q?DwM9ceirExfrKy9GmmP8Tf1k/EqLFYIecYahXrCYBwiIJUNdesPXhmFDSOd8?=
 =?us-ascii?Q?NwA0iYMqWLrWrz6e+Kog5c/nY79asCO+ZMOf0U3E/W/D9z0ST37S21fq6ZSa?=
 =?us-ascii?Q?4DOO+H0p7pqJBd2/djdI5waccD2eumgHLO2uIN72SvCL7cNvREljf5CxsTSu?=
 =?us-ascii?Q?x/hR4AtZAZtTVEh4xHr0pi/2K3FH5bVNP7Fg65Xu67U60Mnn2maGX4XJymZ0?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b737293a-4791-4465-ac9f-08db24b95403
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 18:24:20.1852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2obLCxAF6xUzA3GJinQeGY6sZgY8anl4+OV17u2LqouSXBlvkvgmkygnQ8TkIeRvJkezr4J0R/ADoyZResHYHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when dsa_slave_change_mtu() is called on a user port where
dev->max_mtu is 1500 (as returned by ds->ops->port_max_mtu()), the code
will stumble upon this check:

	if (new_master_mtu > mtu_limit)
		return -ERANGE;

because new_master_mtu is adjusted for the tagger overhead but mtu_limit
is not.

But it would be good if the logic went through, for example if the DSA
master really depends on an MTU adjustment to accept DSA-tagged frames.

To make the code pass through the check, we need to adjust mtu_limit for
the overhead as well, if the minimum restriction was caused by the DSA
user port's MTU (dev->max_mtu). A DSA user port MTU and a DSA master MTU
are always offset by the protocol overhead.

Currently no drivers return 1500 .port_max_mtu(), but this is only
temporary and a bug in itself - mv88e6xxx should have done that, but
since commit b9c587fed61c ("dsa: mv88e6xxx: Include tagger overhead when
setting MTU for DSA and CPU ports") it no longer does. This is a
preparation for fixing that.

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 6957971c2db2..cac17183589f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1933,6 +1933,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	int new_master_mtu;
 	int old_master_mtu;
 	int mtu_limit;
+	int overhead;
 	int cpu_mtu;
 	int err;
 
@@ -1961,9 +1962,10 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 			largest_mtu = slave_mtu;
 	}
 
-	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
+	overhead = dsa_tag_protocol_overhead(cpu_dp->tag_ops);
+	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu + overhead);
 	old_master_mtu = master->mtu;
-	new_master_mtu = largest_mtu + dsa_tag_protocol_overhead(cpu_dp->tag_ops);
+	new_master_mtu = largest_mtu + overhead;
 	if (new_master_mtu > mtu_limit)
 		return -ERANGE;
 
@@ -1998,8 +2000,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 
 out_port_failed:
 	if (new_master_mtu != old_master_mtu)
-		dsa_port_mtu_change(cpu_dp, old_master_mtu -
-				    dsa_tag_protocol_overhead(cpu_dp->tag_ops));
+		dsa_port_mtu_change(cpu_dp, old_master_mtu - overhead);
 out_cpu_failed:
 	if (new_master_mtu != old_master_mtu)
 		dev_set_mtu(master, old_master_mtu);
-- 
2.34.1

