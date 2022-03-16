Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395FB4DB9A3
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358036AbiCPUn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358052AbiCPUnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:43:22 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2068.outbound.protection.outlook.com [40.107.21.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B990B6E572
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:42:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpEwy8Ku6MAJlSL5Hfi9wXSnfPTQbmtnNqJ3jmuUnIw5xEGiqfRkic9s78t3G4Y40LYCbBQgdGe3vRv8W+PGUm0vA5hTG7MmBVu58YIBgcLRw6/trDwiMw8gI4tXGbLYLxUiKc/Ci+Fo9oXVf4SdFmoAPV/OszrKIdIYb90RmRB16GqhRFabKOEUU810E8aD8j78J5wrmnrrz/sYRksQkLQUDQvxee9QssFyZd8PU8lrn07quMUkpLDFC1oQH/UF1569OTq9RjxdA/BpTPiolFQI/nojz3eHD2RJ7rgUjT22GKZRhi3gdzWPuwN+iCnbsO2AzlsjKG5V4Ok/K9IlVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjFXhUMgr7VmvSTmSI5BaU6AGVlKmBhtZ0ryBvyM4oU=;
 b=hXA1gVWEikr+pw6YOeczhvY/xypTDiuxGUwP0fpbWBMBr8DdYHAzCUgp3t07YjjHLrJAitsBOEzqcbuf5mxMLLqmVL04632X9EjVoYsiL7CW8M29Ro/UWzfNCh3PvR8DuyJlByfjnFYEvQV35kdUgfcKKWudj0RzTT1OVtvteXFiugvdOrnYjM0z2NjpZIiBZ7b/xcS3eesBj6WjCGv0Utau/QQEHnNkTx8fj8bWOZQBAIlzu9Wb0HZ7nb4nIzMZJRFxuMTBDroEKhyexXN3V5qbUWWoZdX/3iCHLcNChhRyi0fHCjiK2tQoUArN1/pD7O61Dnx8bzJ11vw1Swkyng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjFXhUMgr7VmvSTmSI5BaU6AGVlKmBhtZ0ryBvyM4oU=;
 b=deFbo+rfFs0Li2zz2GA/M8BKtTKtCHRwrRJf9C4Cw6ePvdw7xz2MY79GEJ0Xf74PKkVrg+UqbQC22OLhlcGhbfjuv8UVN90ut5I57sAynQ8VfPIb0duhYtjJUaeXfVs7hI3og6Ka8PNn5ZkWyuVTvOKwYrUPL9dlbrNHRch3Iyc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB3293.eurprd04.prod.outlook.com (2603:10a6:802:11::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.29; Wed, 16 Mar
 2022 20:41:57 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f%6]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 20:41:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 4/6] net: mscc: ocelot: offload per-flow mirroring using tc-mirred and VCAP IS2
Date:   Wed, 16 Mar 2022 22:41:42 +0200
Message-Id: <20220316204144.2679277-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
References: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0037.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::25) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bfa8889-8eab-461e-7b1c-08da078d69b7
X-MS-TrafficTypeDiagnostic: VI1PR04MB3293:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB3293A14B7D2DCD2B339AF1BBE0119@VI1PR04MB3293.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j2Gj2j7z6wqchMEzwjV+Q2vI1qa+77YcZYHOh9I81uaZYaYWipGIBVuay0YGoNL1n71tlM2FKnMkawo1TipD9Ny3Zd8eOLghtAHGj6lwpIu8JokJQ3amqOojSI/vxgG3YgaVebTUzDKX1cwCnIfiWwl62nFsf5hKeLGqS5vhVKmHWv6cakjZl9XcRQC47J1CFwza094zL9Em29r1wUrXAuo9FRQaJmh0if/kDC6P8zBeWBhX9LqReO6/RD+2FIjCkKTiHZrn5pAgnFczVlM0ZfxNRDZpP5GOzRNja8GuBBjFjeP1EqqTEvmvhqlyOGTd+frtEf0Jne431E5I5Mxx3NSsCStl29+Zi77AnPKPxM3NvxoZELz9O7C5v9xpmsd13AhH968bpBVV+lDaMTuZXegbB6NXS0EPXHF499NG4/XepGlRsdSy0/wmmsNf/viG97fclmk5rD64oTIUf3qMP5td9rIjJyGYyYjLbT7D/KJGna7b7nNVtsKGjCRnqp3VlR5Meoo8s1G9fNL1g78ovCuYVx5PobkknS21H3kjOSszHU85nloHTz2VtQDZtW6crI8dtV8ieN6qjWjNB8E3m6x+g9YAl7n9arrZ6iZJCNDhBBlHlJG4OuChBAFuxRAyHx8FJTUFpSt4dcKACG5SyIZjCTi2oQtE7UU4mLWKjSaTFr6venIvoUkY/iRVABcshhPdEyzsFLFsd8lbJKKK6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(38350700002)(86362001)(6916009)(316002)(6486002)(54906003)(5660300002)(36756003)(8936002)(44832011)(8676002)(66946007)(4326008)(66556008)(66476007)(2906002)(83380400001)(2616005)(1076003)(6506007)(508600001)(6512007)(6666004)(52116002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+SXUWKCEyvEZ0FCBWY57zHlXWRs1133PibvDf+2m8CON/BAAVckel4TlpTy7?=
 =?us-ascii?Q?2ldECSCg0rrkbaqv+k+cFWZUsly2IHMuYh8/cfqXqQcxUO5HetJEbdh+iNtC?=
 =?us-ascii?Q?4CLewG6DqxZV/mixdF1wdlbEk+huW7bikHB+FhGByU65JzWT4xiWrIMjIPv8?=
 =?us-ascii?Q?E+Hoy989pKO4V1L7vICQuq27iSZLHF5zFocRYNDUWblJ9n1fJnvbnLsQhCk8?=
 =?us-ascii?Q?h4keXumvTvrkVcW/5EYrII12RNllZKowX0Lkf8oQJqe0NY7rNvlpIEld0q6+?=
 =?us-ascii?Q?OsCnHuT8biOhZTIhf7isBKW9BVLO7ugNIdhMi+d5BTF78zB0dunZNCQLnHYH?=
 =?us-ascii?Q?A31T3ytaEG4OR/SJUlKT8+n2h5RQmGjOz9AJXcHOdIE1AWm7+LX3jYnc7ZKt?=
 =?us-ascii?Q?DdYgXznZ7QY1qqKm4mFlaW8n2Q3vqKIIG0dJHVAKWopZiUSXRN8FtWYMNNgl?=
 =?us-ascii?Q?EBt5nGIa/N1uB02fUXhAWDbM3dnXc3TpTupmE53QwAK+4IXSfA3yl5WKclRv?=
 =?us-ascii?Q?SI/z9q7gnJoJ/9842lMmRDNg/v4YuOl4+S5AMqTW63qDIjpJKXVXydMek7In?=
 =?us-ascii?Q?BkEofVBQaBKzO5n+QJ3l6or7X2KOZiyv09y3dAud+S6Tq2j621FwSbtAUcAo?=
 =?us-ascii?Q?A25ZEOLit5QalBo9hr57BTU/xw2HZklhf/oYrB7cntlZJyR6sS/Ok7O2NhIb?=
 =?us-ascii?Q?IFhdD+4107b9YgDE+GSK9owliYe8wPFqXP/nBTPp6Y2XdGIyTJmyS9bi809W?=
 =?us-ascii?Q?13kPaQEJJnALP2ti/kQyjg+/HfzyHeb2Tx5LhF3OoaTgDyG7Ip4Ofx6ASlXT?=
 =?us-ascii?Q?AsraROvDgrBoHwAXAunPdEuWy8WtRwlfyepSDTl3CaiHOYiVua5vFAja5bFM?=
 =?us-ascii?Q?aU8CB/Kz/KD2aHm8tkPm6Cs9oSg420DSLSfDlRMH78gelzrn7SzNh3q+coTO?=
 =?us-ascii?Q?YHF+v2jefzMvyY2GXxBCrPWdnFBJdbU9WgLH2J0npb2kJtFCLOplkPbj0VT6?=
 =?us-ascii?Q?MQreD9e/sA6SmDxYIvfLyOGohEaZwGSJGAeQ0BREI3sVa2zCu7Q1ZyV1ydKg?=
 =?us-ascii?Q?nKVCjVLjm94oSGTvbgvIssCMYwAQxPvnRv27wTX8wHyOK8YsHXvvPNUEKdPw?=
 =?us-ascii?Q?/jrcPPt7W430mdoq4xo6FLzim549cAZ30U0u6QmjcK0cd6tiSbnbTXP3bGkY?=
 =?us-ascii?Q?P+OFtDc/2EgHkMkYMB+RaWymizJbJdfJNID/JDiVnId4/c5KYhg1rViaBKuz?=
 =?us-ascii?Q?oUIuHe/h3JKwkFvMJ4DrtM5sBraFbIzKisv/3umMGUJ+KpziHsZ8TsKuNopJ?=
 =?us-ascii?Q?5lhQCBU/Ir56noSkUB3qh/1m4U3Mt2yXb8meo6CgZgTxKXE+vnWK4f/Acjlk?=
 =?us-ascii?Q?yHLpZ98EG4fydi0yt04Pk3227cojfTaXA9Td91Vuj6PJhIPFAAnmX5RnKhzx?=
 =?us-ascii?Q?T7bKFIO/L4pKFZRwHOej5D0olupm+aPd1tfvedhQuwEDCFQt1MRVrw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bfa8889-8eab-461e-7b1c-08da078d69b7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 20:41:57.3636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlcSDO+UvTNcY999klPGwHZAL9TweZkHrGQzQNHMePEuHdcCjDXJhffF6oP+ngeg2kCbw9DXBVnVCg6nM3UunA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3293
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per-flow mirroring with the VCAP IS2 TCAM (in itself handled as an
offload for tc-flower) is done by setting the MIRROR_ENA bit from the
action vector of the filter. The packet is mirrored to the port mask
configured in the ANA:ANA:MIRRORPORTS register (the same port mask as
the destinations for port-based mirroring).

Functionality was tested with:

tc qdisc add dev swp3 clsact
tc filter add dev swp3 ingress protocol ip \
	flower skip_sw ip_proto icmp \
	action mirred egress mirror dev swp1

and pinging through swp3, while seeing that the ICMP replies are
mirrored towards swp1.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c        |  6 +++---
 drivers/net/ethernet/mscc/ocelot.h        |  4 ++++
 drivers/net/ethernet/mscc/ocelot_flower.c | 21 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 12 ++++++++++++
 include/soc/mscc/ocelot_vcap.h            |  2 ++
 5 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d38a9b498490..e443bd8b2d09 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -3023,8 +3023,8 @@ int ocelot_port_del_dscp_prio(struct ocelot *ocelot, int port, u8 dscp, u8 prio)
 }
 EXPORT_SYMBOL_GPL(ocelot_port_del_dscp_prio);
 
-static struct ocelot_mirror *ocelot_mirror_get(struct ocelot *ocelot, int to,
-					       struct netlink_ext_ack *extack)
+struct ocelot_mirror *ocelot_mirror_get(struct ocelot *ocelot, int to,
+					struct netlink_ext_ack *extack)
 {
 	struct ocelot_mirror *m = ocelot->mirror;
 
@@ -3053,7 +3053,7 @@ static struct ocelot_mirror *ocelot_mirror_get(struct ocelot *ocelot, int to,
 	return m;
 }
 
-static void ocelot_mirror_put(struct ocelot *ocelot)
+void ocelot_mirror_put(struct ocelot *ocelot)
 {
 	struct ocelot_mirror *m = ocelot->mirror;
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index d5bd525e7ec2..d0fa8ab6cc81 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -112,6 +112,10 @@ int ocelot_trap_add(struct ocelot *ocelot, int port,
 		    void (*populate)(struct ocelot_vcap_filter *f));
 int ocelot_trap_del(struct ocelot *ocelot, int port, unsigned long cookie);
 
+struct ocelot_mirror *ocelot_mirror_get(struct ocelot *ocelot, int to,
+					struct netlink_ext_ack *extack);
+void ocelot_mirror_put(struct ocelot *ocelot);
+
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index bd9525867caa..03b5e59d033e 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -359,6 +359,27 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->action.port_mask = BIT(egress_port);
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
+		case FLOW_ACTION_MIRRED:
+			if (filter->block_id != VCAP_IS2) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Mirror action can only be offloaded to VCAP IS2");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			egress_port = ocelot->ops->netdev_to_port(a->dev);
+			if (egress_port < 0) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Destination not an ocelot port");
+				return -EOPNOTSUPP;
+			}
+			filter->egress_port.value = egress_port;
+			filter->action.mirror_ena = true;
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
 		case FLOW_ACTION_VLAN_POP:
 			if (filter->block_id != VCAP_IS1) {
 				NL_SET_ERR_MSG_MOD(extack,
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 829fb55ea9dc..c8701ac955a8 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -335,6 +335,7 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 
 	vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, a->mask_mode);
 	vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, a->port_mask);
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_MIRROR_ENA, a->mirror_ena);
 	vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, a->police_ena);
 	vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX, a->pol_ix);
 	vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, a->cpu_qu_num);
@@ -960,8 +961,16 @@ ocelot_vcap_filter_add_aux_resources(struct ocelot *ocelot,
 				     struct ocelot_vcap_filter *filter,
 				     struct netlink_ext_ack *extack)
 {
+	struct ocelot_mirror *m;
 	int ret;
 
+	if (filter->block_id == VCAP_IS2 && filter->action.mirror_ena) {
+		m = ocelot_mirror_get(ocelot, filter->egress_port.value,
+				      extack);
+		if (IS_ERR(m))
+			return PTR_ERR(m);
+	}
+
 	if (filter->block_id == VCAP_IS2 && filter->action.police_ena) {
 		ret = ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
 					      &filter->action.pol);
@@ -978,6 +987,9 @@ ocelot_vcap_filter_del_aux_resources(struct ocelot *ocelot,
 {
 	if (filter->block_id == VCAP_IS2 && filter->action.police_ena)
 		ocelot_vcap_policer_del(ocelot, filter->action.pol_ix);
+
+	if (filter->block_id == VCAP_IS2 && filter->action.mirror_ena)
+		ocelot_mirror_put(ocelot);
 }
 
 static int ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index deb2ad9eb0a5..7b2bf9b1fe69 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -654,6 +654,7 @@ struct ocelot_vcap_action {
 			enum ocelot_mask_mode mask_mode;
 			unsigned long port_mask;
 			bool police_ena;
+			bool mirror_ena;
 			struct ocelot_policer pol;
 			u32 pol_ix;
 		};
@@ -697,6 +698,7 @@ struct ocelot_vcap_filter {
 	unsigned long ingress_port_mask;
 	/* For VCAP ES0 */
 	struct ocelot_vcap_port ingress_port;
+	/* For VCAP IS2 mirrors and ES0 */
 	struct ocelot_vcap_port egress_port;
 
 	enum ocelot_vcap_bit dmac_mc;
-- 
2.25.1

