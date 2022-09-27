Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C5B5EC282
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 14:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiI0MV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 08:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbiI0MV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 08:21:26 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2047.outbound.protection.outlook.com [40.107.20.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7629261DB5
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 05:20:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y18xyot8FUtBRO80IVumwpdpO3k9exF48apc0LdHfCVR3v/AZlURW3YftkXaD2C4uZnnE5+zb3d9NNn7BgE9FiuW674Ijw99VnilCMwiJuBLyERSWIU/gsvQSs7NoSSxxaUjsurH40zeTjAQQkj5GtCcWY8QIO0eb2KWKfBmuM+u8TRS4EKvDCo7TxnnI2hQm4C6TTKou79LLtwwZvzl0Iwgst6oqt5bBHaeM2eKUGs3FDi43rjEH6lZ7a0pz1VpDKk9PcxVqw8BlljE3KmkhkiDcHyhh5SBVeGk+YSdkFykShOdziPKEuyQFavpRzFDiDsgyUg6geIWjxgrOQB++Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCo7bEKcFpt64vv9o5XI7FV8eqEQqSFIO1mdR8j179E=;
 b=k443Qv4S3fWMGr3fOBfVAVks+HjDV1PI6Ft6wfJ2WcV7bbbOdVXXbutdWzM+urYrdOtZ9g/2DW4muZkcQUNXCiZuUY4XjjGZgTzs06LyMysFmwEEjURnmHStqw1Ua9c1Wt2AsjovWIksrXzt0Xy3HxzyPAmA+ubUNjUhiDURKZCWnVuAvvirhGUkD9WCeHa1oz4pWuzFD/GP9aLj8ZsrU2ZXIFlfdgCA1OKHqKHOToA0wLNirzBKO8K1fAywLNSqLA+7NjnnKayIh+uPAH/k2YBdLU1mh58ZcQ7R2UvMTOAgtNOXSeeQAJXakMeishfBAMlDZIJlFNZh7zwfgdV5GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCo7bEKcFpt64vv9o5XI7FV8eqEQqSFIO1mdR8j179E=;
 b=IY/rVIr8RX1UNt1pyab8poeGOW6ogonSJqkFw1hBThKXzhrt0QM2Kw/qzfYbQsQV2DAKUIiN0jPvyXSD6aKE8w9+iNeEdVMaMsmw5mZxHD8YSlW2OyavXUDS6MyWx/cDYtUQkkQn8CReGxPhzto8cIBdXAXOVMAJzliFy4EtG50=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9642.eurprd04.prod.outlook.com (2603:10a6:102:240::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 12:20:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 12:20:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net] net: mscc: ocelot: fix tagged VLAN refusal while under a VLAN-unaware bridge
Date:   Tue, 27 Sep 2022 15:20:42 +0300
Message-Id: <20220927122042.1100231-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0108.eurprd02.prod.outlook.com
 (2603:10a6:208:154::49) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9642:EE_
X-MS-Office365-Filtering-Correlation-Id: 24328245-ff0e-4cfa-2131-08daa082b9e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3G1ZSviooqgvF1q/uHhXkh73lbnB4hGbS67bStwysWYIyPZ7qic41dDvo10jL6P4WZphBo2daRrN4H1wbYC1A9LjMuZ6FpFd2aNuFubKRws3FPZhppUqHwZi2YX0GtMycZnwhF72XodoopFgGnZkUTXUAJYimG+TMsdKFIvYZ6TeIWfla1LuqGEesuR//JRgxjubc6vpU5szprIRRGBasyJKHR2blK5zu9QBj10QJ47/aRBRs2nlZ42sEWOrEHj6dyQAX8uUWE0Lq5rYFk+9Cdd0D/oed0jXEpH5w0u9kczbHjUWTambtnjTIU+GnheQCINJgqHdAYcdDBiVTf2AQuQOo6pglAoVFzyMeKNOD3Zuy3GWPEkGJmmwqCL2FEcAzJmgCKoS5QhAC0ZAEv7ozbKqJAyBnah+av4xVJgZOu/wuOPhjTfNGTEQuosHOh68MetgdG1phuupLB99ypoHGhoUU+X95BwYmzN3ATfwTeV4GD+uwIaBTMLXq8/14CdzQOuZJ+VCh5AvFnmtanZQdTmIpy8nG+xQLZc4WoFn2rqeb5klyKVouqD9Za23axWdbh4W2igge1xEL7mjg1YUI7kk9hM0Pom1Va9kRZB/w0GhBouhHppk4OhaREJ3r2+maNN+6flnxIw2WbPM/ny2bTSo1IlQw/QNvWngsFxh9voICHP/ZWagE75S50PNdt+B2nWS4BPJqqWj7xRkybH/yCH5cvsOduv55o0DL1uG/F1WmpultmyfC7LQxX2KobzS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(38350700002)(86362001)(38100700002)(66476007)(36756003)(6512007)(66556008)(2906002)(44832011)(8936002)(66946007)(5660300002)(7416002)(4326008)(8676002)(6506007)(316002)(26005)(2616005)(52116002)(1076003)(54906003)(186003)(6916009)(41300700001)(6486002)(478600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CBixK2KMp0RXBMCu+tFp24q9culTBiauaOk8J4HrMu/Kjwz0Cvdds4ztB7eq?=
 =?us-ascii?Q?rv7G1npMBaddG8AU9Jv8P06DjPXG3t2dtl6lWnyDT8xwoJ6oyw0bryRGJcsg?=
 =?us-ascii?Q?wvTxR4z4UcIB44rWByywqqEjmumOCg5vR4CYPNKN1leggXGVB5aVtBV2whjA?=
 =?us-ascii?Q?Oj4iUiU0whFSoYQiNQn9kiL1VXFhcSr1BP/57qA07sim8iQj4rM/Ji1RQLzE?=
 =?us-ascii?Q?OsKFRU18508Xht1oOWLP5ykONCiv2DVxSrv//D4m+/Rn5JU7oOwJ0kio+k4Y?=
 =?us-ascii?Q?ZvxR3GQV36uWMGyfmqT30U5zSE4sgs6v063qCjm6L7WFVYtjYymoQoyoOQRF?=
 =?us-ascii?Q?JIB0hJADYpuOXz5w/BBGrOZD9lYoE0JCQlo+u70vAgoHKG5lA/kaSVKOvduc?=
 =?us-ascii?Q?2HK0cpVMkjc7assKZR/YtyjXsPGbAMqmXrqsYY+ahEgEpdH3hkh4ge106bcl?=
 =?us-ascii?Q?FsVMzLjb6fwmlx0Q2v80T+zgTfBn6DWu6HHtXf7qpmWq2IncuJhUigMg3F7J?=
 =?us-ascii?Q?wOdMlG4ybzmPEVJkEek4jve9u5EFu1MJ/ZdebpKiCibJvy6bKXefBBwC3hIW?=
 =?us-ascii?Q?ScyLqL5x9f3S/JJ6h6/5fx7i/Rw0Tru0SndPgLQGThoYLYsWaMZzwLOLxAgz?=
 =?us-ascii?Q?Urmbw0iqD6l45kCiMX/cCxq9DkOzX4pTftTKOHd/UCgKApEVnaZ6FmbMFZtN?=
 =?us-ascii?Q?rngPKWrNytDzUvTKFG8iX+yOdHentn4kAXX7zSdTntXmjFAqw3Cf6GIoOtIJ?=
 =?us-ascii?Q?14d+TrhvO65lq1o7AaZgZQr8+5iET49crddIF+Qzk/ONOu5Q8AshQ9RXe+Ug?=
 =?us-ascii?Q?Zz8DL6YSBjbxn3Q7ItljJySnVd+vy7dcCzu1e66Av2R0JxVA2N1g8CLONAuq?=
 =?us-ascii?Q?VJPTheF++rdhJ3M+/yeZY2U+s6iMAbRHJ5ruGkW5v7ncoUO2x7/cFqtSMxJH?=
 =?us-ascii?Q?9+rKB8WUPlSS/27dE7IChfSt6W8+Tl1YfWwIuFuVjE20dFlzZH1jPo2U8fnZ?=
 =?us-ascii?Q?1EMdO5++r34bv4aJ1R6A6yk4v2Pz2QtCv/x9lyi5jWvDcPdh/OOJCQWhITnF?=
 =?us-ascii?Q?3z/CBiuuIrkDEZb5GDEkx2Uj+0eM1BU1rX0HCys6ANoByxn/EIABNOIVVzPg?=
 =?us-ascii?Q?fz4mLWJVNI99EkkgxnN1+fKV/UyBwXuXQwv7ZiWlXpgiSTA2Us4lfkSAFiCM?=
 =?us-ascii?Q?rZpZoM+kmmWi4xd107U8VKhy+GEVCGm+EKlNduGBdPFZibxVn5DnISCzMqNc?=
 =?us-ascii?Q?094nGTxHKekER6O/tSneZ8ZCM/SYUtskZOG3/S8zF0FDUJXljwA03TogpHHn?=
 =?us-ascii?Q?Eg61jQEaBJFh1tVetiVDkeHBYPqaOT/8xrNGTWaaALHILetSaWhHyPJ4OCE+?=
 =?us-ascii?Q?BBZe2lWtUYR8c7Ks1lGrnwvUBFKeEjTv7/67spB7Y9wilEkIvFqofE3kQz6M?=
 =?us-ascii?Q?ZcrcwAVPF042GCiWiLothz7swXTCIOEv759fNdaDtEVopsPKvC9VCPYIX7xQ?=
 =?us-ascii?Q?C3mls9nyrPzQiGL6ZuFmxR0M/Hs0YL7DXypZPcxS5YVW3fvLCE7rwoJ4jaeD?=
 =?us-ascii?Q?cbV9CrJByGsTHh0SirV7QkkIVTto+16gjjICkTiHBZiGB4xAR5mxBdrn8MFP?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24328245-ff0e-4cfa-2131-08daa082b9e1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 12:20:55.3109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pzPTPa/XEOfy18fNQJ2tf7nMSIHvYovp4z6yBfWY8IGEEAu/2GKYc9VGRpaRoElxioNsnbKSXKqk42Ef8sFoeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9642
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the following set of commands fails:

$ ip link add br0 type bridge # vlan_filtering 0
$ ip link set swp0 master br0
$ bridge vlan
port              vlan-id
swp0              1 PVID Egress Untagged
$ bridge vlan add dev swp0 vid 10
Error: mscc_ocelot_switch_lib: Port with more than one egress-untagged VLAN cannot have egress-tagged VLANs.

Dumping ocelot->vlans, one can see that the 2 egress-untagged VLANs on swp0 are
vid 1 (the bridge PVID) and vid 4094, a PVID used privately by the driver for
VLAN-unaware bridging. So this is why bridge vid 10 is refused, despite
'bridge vlan' showing a single egress untagged VLAN.

As mentioned in the comment added, having this private VLAN does not impose
restrictions to the hardware configuration, yet it is a bookkeeping problem.

There are 2 possible solutions.

One is to make the functions that operate on VLAN-unaware pvids:
- ocelot_add_vlan_unaware_pvid()
- ocelot_del_vlan_unaware_pvid()
- ocelot_port_setup_dsa_8021q_cpu()
- ocelot_port_teardown_dsa_8021q_cpu()
call something different than ocelot_vlan_member_(add|del)(), the latter being
the real problem, because it allocates a struct ocelot_bridge_vlan *vlan which
it adds to ocelot->vlans. We don't really *need* the private VLANs in
ocelot->vlans, it's just that we have the extra convenience of having the
vlan->portmask cached in software (whereas without these structures, we'd have
to create a raw ocelot_vlant_rmw_mask() procedure which reads back the current
port mask from hardware).

The other solution is to filter out the private VLANs from
ocelot_port_num_untagged_vlans(), since they aren't what callers care about.
We only need to do this to the mentioned function and not to
ocelot_port_num_tagged_vlans(), because private VLANs are never egress-tagged.

Nothing else seems to be broken in either solution, but the first one requires
more rework which will conflict with the net-next change  36a0bf443585 ("net:
mscc: ocelot: set up tag_8021q CPU ports independent of user port affinity"),
and I'd like to avoid that. So go with the other one.

Fixes: 54c319846086 ("net: mscc: ocelot: enforce FDB isolation when VLAN-unaware")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7a613b52787d..13b14110a060 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -289,6 +289,13 @@ static int ocelot_port_num_untagged_vlans(struct ocelot *ocelot, int port)
 		if (!(vlan->portmask & BIT(port)))
 			continue;
 
+		/* Ignore the VLAN added by ocelot_add_vlan_unaware_pvid(),
+		 * because this is never active in hardware at the same time as
+		 * the bridge VLANs, which only matter in VLAN-aware mode.
+		 */
+		if (vlan->vid >= OCELOT_RSV_VLAN_RANGE_START)
+			continue;
+
 		if (vlan->untagged & BIT(port))
 			num_untagged++;
 	}
-- 
2.34.1

