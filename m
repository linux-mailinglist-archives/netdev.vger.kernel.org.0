Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E732D5B8BF1
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiINPeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiINPdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:38 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2089.outbound.protection.outlook.com [40.107.22.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B145A880;
        Wed, 14 Sep 2022 08:33:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxMVxVyLKywRAKKLfHpJyXARyCm6P8UpFOq4vViQB92kmCvkJav0M3NC6p0YzwdeqhMxxFmiLxzvwyJzZWPThtgA+JjGKDX1R7gqWibt0XNyefNMF3sCk4KjPfEBVYzR2w2ULfxICCwW262rMiP0OzKs/jMJWRpcX/Rep8d2c7JGDqiFDP+ihF0AATgBCOH6H5tLow501epqwlK12w2DEkN4fH0kAVqtCNXh5RwQrg720uexYx4jvvQhOdiNBO9r2e4lN+nXsYioV/Y1n1vLFda3PFiNvzyg0UXWct0Uw4XUpwxyLa3uB03wPLkDIE4bk2lcAAfWkDkKeua4+Ky3AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxsWHfVwNlQzMBDUw49GB6WrQxH+DgSHSFu9QWGB5BU=;
 b=JL6W8z7VCA/EG+dIAOLCKGD+PCJ6r0n/bLYkQa7kcQjm0S3Y/ED6uVu4SEL//kT9g1sC6qF9bjf8hsqe/p3rUFkRRjmTF35CEPEgbWPHvWzDILJMpd6tQ2n9RayREUEim489guxUwHQESz3I1YT/5HZ+Wkn8zMAc3eA7GfWwbC35eSgWkKUCgINxGJgHsK2rWw5uAGtuBc3P+640FBLvrtlrhe0VJK/iJOljkbfviL3xQJZZ1fNN3H5dAO1lLGpxFwuedwzwO/ZKiPlpCEj6Qg4czzJxfij6i6jVm+s7zBOlyEHyRZW9gHPz3tk3oyu+KOX/UO3i75E96J0Zr2zd0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxsWHfVwNlQzMBDUw49GB6WrQxH+DgSHSFu9QWGB5BU=;
 b=ZHHKiIaL5hnaPYyqOkeaOB5/dx/GbDeXIiz+tK2kVNbgeGulCYpt4Mk2KYV8kbAayRWvNp61ilCyf+gwb2Orbub7KvjF0+jQkEcvSUgRflLkgHiNX6395y3zhIEOyg8Dbgb5K4N9zazTH/oyAXP7Ampc5kCWviNhuPXAd+6+60Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8949.eurprd04.prod.outlook.com (2603:10a6:10:2e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/13] net/sched: taprio: allow user input of per-tc max SDU
Date:   Wed, 14 Sep 2022 18:32:54 +0300
Message-Id: <20220914153303.1792444-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: f230365d-733b-4500-e743-08da96667c2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TriDEO/BkbwO2N88Qluv5C6QRUWjKp0ZVTBaVgmiPycZtoA/Avmp7eE6o3D+igkwNYOXYcUrpCevvlYaEsj+sTXDzYEJjjzUyPjYM/U2UAYTtEZinv3mOlMtAlut5Vg7GQeZOzS/WGueWSvq72o+gnKjY8wnTxpgVgkjsSJdZsWI2iXpxUYiZsYhw7pYOUbcKvk2rEzfHq/zAUVLqJrRavRd13RcXsHvayAplyvmNRmJRbx44ztslFE0Fd+OgxU5XuQCfYR/5FpqJpJAr5TyZeyRt5MoxvizunXkKn394Pmw3a8TwH0FCvpMt3udjMzHZoSEHDB4dHm2X7tL3qNfQT0J/9ccBw/qs+qVrfxIHo37ml35a91LzdBkWhmVVxQZjD4cbX+h51Gyn9c4tH+b/idC5qeRKBFIyppcxZCxjx0AGkiYTZpkFFXJn6EBvc5ZUtwXt7BwUn/0ayjmhHJ/+CmhgIDXsbm0si/0E4yDIqU1MCzO9TSZn4bgkwbkbQVExCMOFMWRCwsjuE75AKm6wnmf5z7WdYUQUJfdVGCKVVfHrBratAwPrcNgXICt4VWBxnvcSK8hDSTEQvDqYnlCV9qt1Lup+IaQDIlxhJUDVQrZH+HibHs/tk6Y9lZiVbxgyr30WdYMmm0jTPP3MyyIQUmrYjh/Nqt4seKEhcrOaKJek+iO+9bCUCZTqSobiXw9lpIbv9CQpw1ioZExLrxAF5qgFzCzzBI0oTHvbtFqfG+7Tpz/At3gchMwEEK186q3p3DEQRjPtOVTe9R8R7Uj3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6512007)(2616005)(52116002)(66476007)(44832011)(4326008)(41300700001)(66946007)(316002)(26005)(8936002)(2906002)(36756003)(6916009)(54906003)(6666004)(86362001)(38350700002)(1076003)(38100700002)(5660300002)(6486002)(186003)(66556008)(7416002)(478600001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5lURayTaIebdc7OElAU7/CmhDCI4XemBe8tlAMTaSH9vj3jk46TIdHKOc0/T?=
 =?us-ascii?Q?5sb4dbzGEzMzFwiz8ud+ijC2R//Jv13TvNleJkz2vBX7Nla/8M3QVLYRAEGH?=
 =?us-ascii?Q?2C1O9YbirHOasJspvzb6VwGmdBZU6nMSViIk/fow6y89tCcoDr8ilp6x/L+D?=
 =?us-ascii?Q?DfxjcrvyDk3JqrGvNBifW7nOizblZtk6qjZ4SjUCSbgDMTAnYdsiBddWJtoz?=
 =?us-ascii?Q?pWVDMSeNE8ZRLRnotfYhqodS4VdRiy9KTmm/wGPOCJ6UiiZ5uLjiiPkSj4La?=
 =?us-ascii?Q?/eBYUpVDGmHX427khyJwy62HOwRm/UXACf3UH12+fvsafnWVW1wRj4KwVgK2?=
 =?us-ascii?Q?g1c1KgvheP1vp2Gl/1s8PpJlJ11Pa71gXVih+oxmTKnwkEJ/fdIkuTKbyXI7?=
 =?us-ascii?Q?nnDcoUuYbwsT6r8q22qYNQ+C/AemmGEWp51v2ejQCc5LW1jt3y+qmveJ+KaX?=
 =?us-ascii?Q?cEjvKUfnhBSCBqr9Nn7FIQuWsKnoJTqXtxMkaudx4u/WRbAUTN5yQ6G59AT5?=
 =?us-ascii?Q?Cekmq/nqtgguvC81ssextJRCPSbo9gOHj6r9saOUBNpLl+in5oQ8OpMy+gLo?=
 =?us-ascii?Q?iRIW58MhSJfJ18ypMC5+yTUl05FVRPDnanXwpAYtwom8hfD4a6BynxUPEiXr?=
 =?us-ascii?Q?Ecs7Om3Emuj3rWmP7Sgr21OZ5ErZr2rVa79xrQ6zbfL1CGqRd5TqaBlWj7GS?=
 =?us-ascii?Q?NoEwKY0xYAYAyCxDhGTevwaIl4mJksaBLctdHJq6mERecCcd8zPd9Sey7Y8r?=
 =?us-ascii?Q?dO1qTCqcvxOeZNga6AiJoyYZIGJtxPMYSrlvVa1H2MXNfXWYPTUN+HcfAzO8?=
 =?us-ascii?Q?yNWu49s203UcKlqXWKrCFjeKkE7QLAQ0sFwLtr/3t5ug6DoqCAk5LuuZPNkZ?=
 =?us-ascii?Q?S3qSLwblDfzAP5v/g9tUlIfVvCCJLtz+VkVNTzaojexuZoLTi7ui6app2hIr?=
 =?us-ascii?Q?RTUIAOCJct1G/x+ebru+u93spmNiNlM3cCisHPjY8AeT66O9QA5jQTC7aOam?=
 =?us-ascii?Q?vuRQamPINHRdcF2gwLw0Xayez+URglNPhY+pHng4HDNUukLnrOgcyU1zUGrh?=
 =?us-ascii?Q?MxhRXldmsOQRWu7Q8YxrfA8+21DWEPmCC+SAlgnar3WYfaHkRy4uyiGekK3B?=
 =?us-ascii?Q?JMEHvk+9il5TDdUnWvTSqcZsIvNhtVZAKzmr4mcjX3Y2da5t3x9v1SvAZ4h1?=
 =?us-ascii?Q?FFXz+MEGQzGwMEbn4jEc98yJuMb4pTLH67cC4XVK3UYWHUuWjtt212Gm8zTp?=
 =?us-ascii?Q?AuWy1CVp1hNVgYPqE9orqReRfu4EJJGo1Oo1y3LYG2QtuPOuyknsTeOD0n2V?=
 =?us-ascii?Q?eR0glXNVyJu52UHaqngjKE/Y1r0+ySBDLong7/M7f7+GSOKr5V9zBnI+gtpd?=
 =?us-ascii?Q?7fiP6/npfaohqVNX3XvkYXaarbV0gFtp6okFBj+fczocSDc6MW15JU8Wez4c?=
 =?us-ascii?Q?PrKT8waWaAabWVimuUkKtg2y3B9HHGa8KpvqCGBRPFgr6/NY43V0ZH20x8Nm?=
 =?us-ascii?Q?5VD8wkSgauZFhL6E/nxw6fpDZ2SDW9X/dBK8aDuTqInjBzQ+a3ft8ZCk2EH1?=
 =?us-ascii?Q?n8wPw9aGjDVES8ilZCO7OF8A8FePxglGttjj+WZGVCqWSM12V8Z4D0BIt5h4?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f230365d-733b-4500-e743-08da96667c2b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:34.2928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tOSDkWl3YmnVsFOKNB00780SMMr1fS86gCsIWnMZhopMnTaxON7kXu2gBQNzDlB48P2kWsKlqsssJjgVLf7ipw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8949
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.1Q clause 12.29.1.1 "The queueMaxSDUTable structure and data
types" and 8.6.8.4 "Enhancements for scheduled traffic" talk about the
existence of a per traffic class limitation of maximum frame sizes, with
a fallback on the port-based MTU.

As far as I am able to understand, the 802.1Q Service Data Unit (SDU)
represents the MAC Service Data Unit (MSDU, i.e. L2 payload), excluding
any number of prepended VLAN headers which may be otherwise present in
the MSDU. Therefore, the queueMaxSDU is directly comparable to the
device MTU (1500 means L2 payload sizes are accepted, or frame sizes of
1518 octets, or 1522 plus one VLAN header). Drivers which offload this
are directly responsible of translating into other units of measurement.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/pkt_sched.h        |   1 +
 include/uapi/linux/pkt_sched.h |  11 +++
 net/sched/sch_taprio.c         | 122 ++++++++++++++++++++++++++++++++-
 3 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 29f65632ebc5..88080998557b 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -168,6 +168,7 @@ struct tc_taprio_qopt_offload {
 	ktime_t base_time;
 	u64 cycle_time;
 	u64 cycle_time_extension;
+	u32 max_sdu[TC_MAX_QUEUE];
 
 	size_t num_entries;
 	struct tc_taprio_sched_entry entries[];
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index f292b467b27f..000eec106856 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1232,6 +1232,16 @@ enum {
 #define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST	_BITUL(0)
 #define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD	_BITUL(1)
 
+enum {
+	TCA_TAPRIO_TC_ENTRY_UNSPEC,
+	TCA_TAPRIO_TC_ENTRY_INDEX,		/* u32 */
+	TCA_TAPRIO_TC_ENTRY_MAX_SDU,		/* u32 */
+
+	/* add new constants above here */
+	__TCA_TAPRIO_TC_ENTRY_CNT,
+	TCA_TAPRIO_TC_ENTRY_MAX = (__TCA_TAPRIO_TC_ENTRY_CNT - 1)
+};
+
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
@@ -1245,6 +1255,7 @@ enum {
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
 	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
 	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
+	TCA_TAPRIO_ATTR_TC_ENTRY, /* nest */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 2a4b8f59f444..834cbed88e4f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -79,6 +79,7 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
+	u32 max_sdu[TC_MAX_QUEUE];
 	u32 txtime_delay;
 };
 
@@ -416,6 +417,9 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 			      struct Qdisc *child, struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int prio = skb->priority;
+	u8 tc;
 
 	/* sk_flags are only safe to use on full sockets. */
 	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
@@ -427,6 +431,12 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 			return qdisc_drop(skb, sch, to_free);
 	}
 
+	/* Devices with full offload are expected to honor this in hardware */
+	tc = netdev_get_prio_tc_map(dev, prio);
+	if (q->max_sdu[tc] &&
+	    q->max_sdu[tc] < max_t(int, 0, skb->len - skb_mac_header_len(skb)))
+		return qdisc_drop(skb, sch, to_free);
+
 	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 
@@ -761,6 +771,11 @@ static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
 	[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]  = { .type = NLA_U32 },
 };
 
+static const struct nla_policy taprio_tc_policy[TCA_TAPRIO_TC_ENTRY_MAX + 1] = {
+	[TCA_TAPRIO_TC_ENTRY_INDEX]	   = { .type = NLA_U32 },
+	[TCA_TAPRIO_TC_ENTRY_MAX_SDU]	   = { .type = NLA_U32 },
+};
+
 static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_PRIOMAP]	       = {
 		.len = sizeof(struct tc_mqprio_qopt)
@@ -773,6 +788,7 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_FLAGS]                      = { .type = NLA_U32 },
 	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
+	[TCA_TAPRIO_ATTR_TC_ENTRY]		     = { .type = NLA_NESTED },
 };
 
 static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
@@ -1236,7 +1252,7 @@ static int taprio_enable_offload(struct net_device *dev,
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	struct tc_taprio_qopt_offload *offload;
-	int err = 0;
+	int tc, err = 0;
 
 	if (!ops->ndo_setup_tc) {
 		NL_SET_ERR_MSG(extack,
@@ -1253,6 +1269,9 @@ static int taprio_enable_offload(struct net_device *dev,
 	offload->enable = 1;
 	taprio_sched_to_offload(dev, sched, offload);
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		offload->max_sdu[tc] = q->max_sdu[tc];
+
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack,
@@ -1387,6 +1406,73 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
 	return err;
 }
 
+static int taprio_parse_tc_entry(struct Qdisc *sch,
+				 struct nlattr *opt,
+				 unsigned long *seen_tcs,
+				 struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1] = { };
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	u32 max_sdu = 0;
+	int err, tc;
+
+	err = nla_parse_nested(tb, TCA_TAPRIO_TC_ENTRY_MAX, opt,
+			       taprio_tc_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_TAPRIO_TC_ENTRY_INDEX]) {
+		NL_SET_ERR_MSG_MOD(extack, "TC entry index missing");
+		return -EINVAL;
+	}
+
+	tc = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_INDEX]);
+	if (tc >= TC_QOPT_MAX_QUEUE) {
+		NL_SET_ERR_MSG_MOD(extack, "TC entry index out of range");
+		return -ERANGE;
+	}
+
+	if (*seen_tcs & BIT(tc)) {
+		NL_SET_ERR_MSG_MOD(extack, "Duplicate TC entry");
+		return -EINVAL;
+	}
+
+	*seen_tcs |= BIT(tc);
+
+	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
+		max_sdu = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
+
+	if (max_sdu > dev->max_mtu) {
+		NL_SET_ERR_MSG_MOD(extack, "TC max SDU exceeds device max MTU");
+		return -ERANGE;
+	}
+
+	q->max_sdu[tc] = max_sdu;
+
+	return 0;
+}
+
+static int taprio_parse_tc_entries(struct Qdisc *sch,
+				   struct nlattr *opt,
+				   struct netlink_ext_ack *extack)
+{
+	unsigned long seen_tcs = 0;
+	struct nlattr *n;
+	int err = 0, rem;
+
+	nla_for_each_nested(n, opt, rem) {
+		if (nla_type(n) != TCA_TAPRIO_ATTR_TC_ENTRY)
+			continue;
+
+		err = taprio_parse_tc_entry(sch, n, &seen_tcs, extack);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
 static int taprio_mqprio_cmp(const struct net_device *dev,
 			     const struct tc_mqprio_qopt *mqprio)
 {
@@ -1465,6 +1551,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
+	err = taprio_parse_tc_entries(sch, opt, extack);
+	if (err)
+		return err;
+
 	new_admin = kzalloc(sizeof(*new_admin), GFP_KERNEL);
 	if (!new_admin) {
 		NL_SET_ERR_MSG(extack, "Not enough memory for a new schedule");
@@ -1855,6 +1945,33 @@ static int dump_schedule(struct sk_buff *msg,
 	return -1;
 }
 
+static int taprio_dump_tc_entries(struct taprio_sched *q, struct sk_buff *skb)
+{
+	struct nlattr *n;
+	int tc;
+
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
+		n = nla_nest_start(skb, TCA_TAPRIO_ATTR_TC_ENTRY);
+		if (!n)
+			return -EMSGSIZE;
+
+		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_INDEX, tc))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
+				q->max_sdu[tc]))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, n);
+	}
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, n);
+	return -EMSGSIZE;
+}
+
 static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -1894,6 +2011,9 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
 
+	if (taprio_dump_tc_entries(q, skb))
+		goto options_error;
+
 	if (oper && dump_schedule(skb, oper))
 		goto options_error;
 
-- 
2.34.1

