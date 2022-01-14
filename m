Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0857C48EADF
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 14:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241363AbiANNhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 08:37:08 -0500
Received: from mail-vi1eur05on2042.outbound.protection.outlook.com ([40.107.21.42]:15708
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233135AbiANNgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 08:36:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nt3dYWM2ZoEQF7yhMk77gW4ihLvCNp1P0eQ/cCagaV0AJ7TCRxGjRlRbGj5K6Q0UEgrMgRyI3XQrGaJjEZ3wj+OFWGAZdCHh7dBwt2F59885BM0Au6golG7S7edzMrpeBJe676tDQ+Frc64C30qnGc0M2ITmftruXVwnlRBaLkR4LTPOvkiEI9MB9M6zABM1EP7j/8U3izefCgQ1ZlPWJOc2YtmQmkEcMTUh27x+qm1DCwpvGaaFVA3f03wZkSb8GeWUX7vDbk3bqApWawL1ExeIbrZNojaynUgkR7tOY8JmRZ0maxdD6CWzC1dHdSAy3nIapF/v9Dr6lOZ8Z2RpEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nDE614455SFnnkaghP6QBHFGRQHMYf3QMKWGGHeNlo=;
 b=Q7+bbCvejW4/XqR9m/EWDtihitUj9DGd9i/ayII4UAOvKp2EQSKPgc62px5tUlgq/6gYknQSCfVcRJTt1sMIZM5PPECml6hB7YqYvNlUkG9OkzRRZk0PoMSdw0aXu71WQ+OWsPFi1XtYbKC/Dv0KKyeSOpAW4kyi6y5PO2KSLWdafxOtywhFF6upsrdnfQPEU9uu2dtKMJ+Wv9Fg2goY6ccVyyrmdyWMzt+VNREyORDtZYRUlFHJXbZ82Z1NZCwAkDbmIfQVCVpeESz5FH5L9nvTAMR2ds56A4cOmTpex286lRVJMcKkSnDGX2K3kBTR2nc8lTAj+SLqdyJIUPDg+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nDE614455SFnnkaghP6QBHFGRQHMYf3QMKWGGHeNlo=;
 b=COz45bfNdqhG2ytV9LwRvIdALKi/N3q+0rFKpFa5Kdf8ug7v5DElvr5L7ybSgEOlhsNBeq6EfaNkPep3ajZmeV8BGCzoqlsxj+R1+EIQ9buaf681YF85MALChehcjaBcSLyGztBwA9v9lky90stY1kjgxKtRzmiqrOZIAS3C2Ns=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Fri, 14 Jan
 2022 13:36:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4867.012; Fri, 14 Jan 2022
 13:36:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net] net: mscc: ocelot: don't dereference NULL pointers with shared tc filters
Date:   Fri, 14 Jan 2022 15:36:37 +0200
Message-Id: <20220114133637.3781271-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P195CA0022.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7b5d2c2-1c64-4f97-73b8-08d9d762ebb5
X-MS-TrafficTypeDiagnostic: VI1PR04MB4816:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB481638BDAC46B49E45DB1072E0549@VI1PR04MB4816.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGGulIwVDrO3bcNy/9AiaJcFreUO0+d80WUM7+o846+8XJ4sVjTnFj7j/5etHzCdXGHGK5eS7lwI0orOkie2/wmz0IvCuIVSi9M2q7vtxYvI4UdAbbI2/50IakPIPCG8pXTSXcoPcKUw9iRHlNJNtvQu7az0sR/KD25sQ/p5b3dgKENy8+CVLC2xx2HQbUfwE2uIwGpcUeStFAV9Jt4JVjCP5KB1URSSFFx06Yry/MamPftvZj0puLmZL90liUBexrhK/SrYF0P7IjlwFJN10FNy2s39fYXAYHSEfbrkmOaZqvuMUHolJzofDg4jBvoMOKm5FUVkNB+APp99rT342fByrkvQWOJG4F1SxXh5o+9wrfQoWS2Mo6EpdVcIJvaa/8kQ1xVrMo51IF3dhAl2jkEArK8oKE0Aptl+5A2TwSBcTVndeInfsMylM6l2WXvjuGivVQhH+7B5dOnNxu4xo2w/oB8iTHud6qpYyUZT8LDvifn7WnDSXBV2HXDAiHcUVHvCyO8N7tMBuBYDOUHY7XqBNallvM6XYs8NUQQ2u6pYwzTct56U2oox6TQg5EYtKNYwupL13T0k0oCFWZLMEABN66lXzTx6Tc8UT2GnNxTdDdZf9s9OIgeYvaDJMhYyEBgyi88iW8U3y/9VlTIw04BRoF2InU12IWEkrPdaO2yDhJyCczZXiyukLQiDdoCJ0wANocQjpD4RMNsvcFIOiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(66476007)(2906002)(54906003)(5660300002)(38100700002)(508600001)(52116002)(66556008)(6512007)(6666004)(83380400001)(8936002)(2616005)(4326008)(44832011)(1076003)(316002)(36756003)(6506007)(38350700002)(86362001)(186003)(6486002)(26005)(6916009)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4mvnZqtEWT1LBapU170vrvl0ByI7gj6z1gkNyHdsK87BfxhanxSPIMez6EcB?=
 =?us-ascii?Q?TxxarmZMn0WM+or3our71bu4ZrHdXtMlzMBaJTIC2UCDjrPSQH/E/mD/AnqB?=
 =?us-ascii?Q?uOmiU5I+Cyt+klrglZdejV+/eG/kXyj6NHOsItUgjUqEczIz5HSusvbjRaxK?=
 =?us-ascii?Q?Mlv4Mt3sHWPQ70lboFxsanBq3P4BJzcgF9BEbEGTyuoQArBoTgJgvHTq55wp?=
 =?us-ascii?Q?1aOUbbdkID6cklRp6FijJqlinDilN7tN5Zz6Fn0UX91PqGLxJpQyDbYQUucv?=
 =?us-ascii?Q?87dUY65KzX6+4pwDfAUbGQkDyh7RIAD1C4xqP2+I5i7ZYGmzjCyt9H1wFZAC?=
 =?us-ascii?Q?Gffyq5Nu8A1AmxtBHcXdokOtFwLmbomF3OADLn4963Irdx5HH1/P02U6NqLD?=
 =?us-ascii?Q?tSU7CQw0d/hcAFKq4Je/8kug4tq0AeMvXBUQxVD6omXlGp3QzcwB9/0bGaxj?=
 =?us-ascii?Q?sYZktaXnfjkAxzGAeoGIWlG/KFSp0S/MPokR0NfN3OBoKHr4s6GrazF5vCj+?=
 =?us-ascii?Q?TW4LXnLqvFtoEm/xsFctPbjJICAQFpy+qGVnYT/yQZdu4yJWaxcybdSnmqqF?=
 =?us-ascii?Q?pKUJ6WCzZDypCjDqmuTgB955/g+MBbUAdcvIfv44u4HRngYk6W+WtLivf2Yp?=
 =?us-ascii?Q?lqN9LN4075S3YJJRsTcNWS/7xJZBVGxFZssBFdf0VxiuLP5eZbUbtL+FbT7a?=
 =?us-ascii?Q?NHC9IneglYwcQFfD4ruQDvr1hiJAl7f1POqj2fzFNx922kqPJaWHSQgU6c2/?=
 =?us-ascii?Q?OPYoojUVMyC3ep2ZeauZgTROktfNE92pug5qdiZyYNB/orJcblvWrqVpzfBa?=
 =?us-ascii?Q?1LEOd7xX6JO9sCm5WCQPy0Q5Rp+n9pOOHdZ2DCqP++AnK/nX4hdCj9G0+HyM?=
 =?us-ascii?Q?pN1JVqrwGlVeyxb1DBjL32UCkWHfDvusKt2+mtxb9QFkSXK/Z5D1yzEWMgIp?=
 =?us-ascii?Q?POqLbKaXodj9YJG2Ka54AWexPihGlkyOgyyTE9Ipgr5x5lFre7QVTHgReI9k?=
 =?us-ascii?Q?MS9pXUwUR3ViRDiJJyMJqPCFdYVHZU8IVzz8MNRQ/u7P1fo0N8Dq+MPzpvky?=
 =?us-ascii?Q?BU57XrxiZD5PGTKY8HLSa4pyLkA6V5qCliErVUVfLdE0c422G49zeeseyo2X?=
 =?us-ascii?Q?V1Lv1vu5bOKlBXgz1Cd1n1FfWQWWZFAuJJVFT8AWfDJbaTbAYjQpwJP1OzQZ?=
 =?us-ascii?Q?RdBoLvdiX39sNoswJTLMeaaBTypX7q7worj1ZI7af1ThJs7vkKg7XoluUypA?=
 =?us-ascii?Q?afm7bb0xzzrunca3sNiOUn/YhXOjXzDLY0g4TmdBzEDaumJA1wf7ClVAM3cq?=
 =?us-ascii?Q?v1mO0zzh1L9CdA26DHd+sKP9yQM0THWf9VBPn2h4soXABVOdv+udYp3xvHM5?=
 =?us-ascii?Q?9mkAcGwPYOmmrOd5q4GW7JI1xkVmK0m+PwSnJRLdC71i5toZEOSIAzT95xnq?=
 =?us-ascii?Q?z0Z3PspDa0wZBsYoL51jQDvMkC0FmYAcf+FppFxVGn3GcnyGstXy+u6aJo9W?=
 =?us-ascii?Q?/Eb2H9ouPdX80Cj0DOxLZy/Vbjdt6/N2ieAwYf/B8OyQTNN+ONpZK/4yfzsO?=
 =?us-ascii?Q?u1bB0h1thXk8VSiP5bAIha+nQVf9bYol5lJkQ0k3gdJWeKQZhS2zkFTitX2z?=
 =?us-ascii?Q?XO+wL4Q/F+lPS1c5CxQblhc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b5d2c2-1c64-4f97-73b8-08d9d762ebb5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2022 13:36:51.4221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsmSQNblqD3fxlu8jrqrqS6zLEYnBpPraa0DELRgPWDLboCrV68VsbTQjUAUNemYSf7Av0eImD2CkV/TAd2jTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following command sequence:

tc qdisc del dev swp0 clsact
tc qdisc add dev swp0 ingress_block 1 clsact
tc qdisc add dev swp1 ingress_block 1 clsact
tc filter add block 1 flower action drop
tc qdisc del dev swp0 clsact

produces the following NPD:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000014
pc : vcap_entry_set+0x14/0x70
lr : ocelot_vcap_filter_del+0x198/0x234
Call trace:
 vcap_entry_set+0x14/0x70
 ocelot_vcap_filter_del+0x198/0x234
 ocelot_cls_flower_destroy+0x94/0xe4
 felix_cls_flower_del+0x70/0x84
 dsa_slave_setup_tc_block_cb+0x13c/0x60c
 dsa_slave_setup_tc_block_cb_ig+0x20/0x30
 tc_setup_cb_reoffload+0x44/0x120
 fl_reoffload+0x280/0x320
 tcf_block_playback_offloads+0x6c/0x184
 tcf_block_unbind+0x80/0xe0
 tcf_block_setup+0x174/0x214
 tcf_block_offload_cmd.isra.0+0x100/0x13c
 tcf_block_offload_unbind+0x5c/0xa0
 __tcf_block_put+0x54/0x174
 tcf_block_put_ext+0x5c/0x74
 clsact_destroy+0x40/0x60
 qdisc_destroy+0x4c/0x150
 qdisc_put+0x70/0x90
 qdisc_graft+0x3f0/0x4c0
 tc_get_qdisc+0x1cc/0x364
 rtnetlink_rcv_msg+0x124/0x340

The reason is that the driver isn't prepared to receive two tc filters
with the same cookie. It unconditionally creates a new struct
ocelot_vcap_filter for each tc filter, and it adds all filters with the
same identifier (cookie) to the ocelot_vcap_block.

The problem is here, in ocelot_vcap_filter_del():

	/* Gets index of the filter */
	index = ocelot_vcap_block_get_filter_index(block, filter);
	if (index < 0)
		return index;

	/* Delete filter */
	ocelot_vcap_block_remove_filter(ocelot, block, filter);

	/* Move up all the blocks over the deleted filter */
	for (i = index; i < block->count; i++) {
		struct ocelot_vcap_filter *tmp;

		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
		vcap_entry_set(ocelot, i, tmp);
	}

what will happen is ocelot_vcap_block_get_filter_index() will return the
index (@index) of the first filter found with that cookie. This is _not_
the index of _this_ filter, but the other one with the same cookie,
because ocelot_vcap_filter_equal() gets fooled.

Then later, ocelot_vcap_block_remove_filter() is coded to remove all
filters that are ocelot_vcap_filter_equal() with the passed @filter.
So unexpectedly, both filters get deleted from the list.

Then ocelot_vcap_filter_del() will attempt to move all the other filters
up, again finding them by index (@i). The block count is 2, @index was 0,
so it will attempt to move up filter @i=0 and @i=1. It assigns tmp =
ocelot_vcap_block_find_filter_by_index(block, i), which is now a NULL
pointer because ocelot_vcap_block_remove_filter() has removed more than
one filter.

As far as I can see, this problem has been there since the introduction
of tc offload support, however I cannot test beyond the blamed commit
due to hardware availability. In any case, any fix cannot be backported
that far, due to lots of changes to the code base.

Therefore, let's go for the correct solution, which is to not call
ocelot_vcap_filter_add() and ocelot_vcap_filter_del(), unless the filter
is actually unique and not shared. For the shared filters, we should
just modify the ingress port mask and call ocelot_vcap_filter_replace(),
a function introduced by commit 95706be13b9f ("net: mscc: ocelot: create
a function that replaces an existing VCAP filter"). This way,
block->rules will only contain filters with unique cookies, by design.

Fixes: 07d985eef073 ("net: dsa: felix: Wire up the ocelot cls_flower methods")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 29 ++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index beb9379424c0..4a0fda22d343 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -805,13 +805,34 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct ocelot_vcap_filter *filter;
 	int chain = f->common.chain_index;
-	int ret;
+	int block_id, ret;
 
 	if (chain && !ocelot_find_vcap_filter_that_points_at(ocelot, chain)) {
 		NL_SET_ERR_MSG_MOD(extack, "No default GOTO action points to this chain");
 		return -EOPNOTSUPP;
 	}
 
+	block_id = ocelot_chain_to_block(chain, ingress);
+	if (block_id < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload to this chain");
+		return -EOPNOTSUPP;
+	}
+
+	filter = ocelot_vcap_block_find_filter_by_id(&ocelot->block[block_id],
+						     f->cookie, true);
+	if (filter) {
+		/* Filter already exists on other ports */
+		if (!ingress) {
+			NL_SET_ERR_MSG_MOD(extack, "VCAP ES0 does not support shared filters");
+			return -EOPNOTSUPP;
+		}
+
+		filter->ingress_port_mask |= BIT(port);
+
+		return ocelot_vcap_filter_replace(ocelot, filter);
+	}
+
+	/* Filter didn't exist, create it now */
 	filter = ocelot_vcap_filter_create(ocelot, port, ingress, f);
 	if (!filter)
 		return -ENOMEM;
@@ -874,6 +895,12 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 	if (filter->type == OCELOT_VCAP_FILTER_DUMMY)
 		return ocelot_vcap_dummy_filter_del(ocelot, filter);
 
+	if (ingress) {
+		filter->ingress_port_mask &= ~BIT(port);
+		if (filter->ingress_port_mask)
+			return ocelot_vcap_filter_replace(ocelot, filter);
+	}
+
 	return ocelot_vcap_filter_del(ocelot, filter);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
-- 
2.25.1

