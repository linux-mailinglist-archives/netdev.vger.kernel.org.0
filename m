Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780695E7FDA
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiIWQdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiIWQd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:28 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60040.outbound.protection.outlook.com [40.107.6.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0459013F281;
        Fri, 23 Sep 2022 09:33:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDro3kwfOGoR79n42Jif69bSh+e82ek1p79uYJCCPSYdM9BhCp32nablZpvvumCSoCBayy2YNFKm/g5Gg351hfVGooea8Tlx4ZPMAHIzxjirKdqbUh22B0bHcMQGC10UyODxvfY/nBBMNlHdVjh4xdFm6tmsxI566KZ+6TlIrf7CTTQbuI+eARcdZnGaJxz18j+YkHNKdN1I1EljUVSZVEK1J5EWct/SjQoFkFFSxrPJqCI8PDgHTrzuir/jmpfAdz2HwuvIIrqJNtS+pRfI08DMp5vfeQUPdFXsNyHbR68jhk7IxKldaahO+odR7hU/mdG3rR4fzLDBKpIaCVO1AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c4prPwTUPpFXhVR2H0K6Zwb3DcuwqtlOXy5MI42LeaI=;
 b=PMZlkSfVDaK60/rl3MUbMfmBGyJeHMKYAuOeqNjXW2gFLuqjsmSpJMJMPcVCPb1wXlz6KUo9yyb4DBFckRD+k+KJVcDVZKCaHHA1wKU1+I37I5xETfnCyZNE8bC0qQXJfVtMNzyg5zU02hhp1YhSNxFcK/voAmiGV7X2/yYt7V9tl87JezMvITmD+aH4DwWvNvrwjer+Pq8SYn+41A+zMS+ZfTWlL9LSVVFfOA1/muK+7WGSb/F40OV7LOMyjuJRmV0lfuzOXQmcFw7N90BD7YOO92UQJahJ8HbVoo0NCMmhTcne7TTxp5M7NP3RaqbluA9MrQXH8ESFLu/Oz3+aUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4prPwTUPpFXhVR2H0K6Zwb3DcuwqtlOXy5MI42LeaI=;
 b=d1CclM2X478XG/4MWdgaNGnntB5tSd7GzjmjURnAoNbU/iaJ4tfc0teqYpnt6t+3n7o4Sbowr7jQudL9VCJML26TtAWRIGsxhm/R6TVewAbcbhWo1IxlKACDb6Fv7lsO5ystIPqjlKDwdIi1/Km4D0KFLbUEo4WDMctDe6WWlvQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:25 +0000
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
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 01/12] net/sched: taprio: allow user input of per-tc max SDU
Date:   Fri, 23 Sep 2022 19:32:59 +0300
Message-Id: <20220923163310.3192733-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 83edd099-ae5c-46f2-da93-08da9d815695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8nkA5fNKj6uBDVRUzjnIe0jPh2X2yVFp9OFxsngN2kqiKS1CfXR2Skc9ju72RbanTpDCQBkUrzXA9AtdazT1YvWiaNjird12obGGmktQLpb1bi8hcsgOQ5TTe684oNVBMGZTXq2qr/1yhKCKfPWBOJH/dWH4gu10LXDAm5n/B8Rz+AlQN7+6PfQ5Y4HfGSsd2exnC+3sdQ4/4VMjvHUpFddbXcgp90Clcwi7X2V28talanYjNSEg7uaMQkJyZY7KUbiiY/H7l4mLdjLo8rTARTkeWd9yWKdCfGPAqPTumT8OtuNNqPWQNNNSakNL84EKtiC5J9+2D+BwZo1RkMfgmm5uMUBdbNTkdn+839F6khKPL/buy7UC8C50e3HIkQVaP9TwE4/zOPoh08OqSPBLyIlmGtdyetI9p4JGVyKYF5rnJrYIdmUnE6yDHaPcwlvfJlbgLqL3c9bevyM1OdK4aO04l96VTqnIRi12gynWfeBcKhDL2eDZJS83Zu39nJlfLAJAw609c/hVdt4+vGpHPbxMOi54aPX3PkVSQwadmFeNBJaedaYDESiYOeZTkGkYteKIJjkzEzo5ZsRAooAwpiWKqQRphucK/ZrggZSThlr2NAjhLk01bp6kh5tpdmZ/UR14O8178v6F/DZhiTDAaoU795zlEOmQQF/KKq8PSdr7r+BV3bzLisV+sndb0A2u13Utu+EjI5xoQ47KedldCtWDu9EOwJaCqIOH/PFAFelk1NZDENSY9Jf6sABTlg9lvwFL7jwYtH3bgLUumaguXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jwFBB4YqtlnOpVO0BErP1d/JhcyBPlkxXgYUB1Ind9dWfnUHgPfpIFQFflE7?=
 =?us-ascii?Q?rQOlHRck+9A1Tq52W3OjTaRy7lR2GaOZLOaF1OlGbTvPBXt5BL+OOUTgKQjc?=
 =?us-ascii?Q?LLmsPz19ga12KCqsQfc5o4XfXU1/9F1vWqFECXvypi6GPygE1IX7h8xpDZiu?=
 =?us-ascii?Q?p1fU04E98Kl6yA7Q9+1sXDqI+q10qYmYfgocBBXLE+Sq5wk0yNPs0W3SPjK3?=
 =?us-ascii?Q?pQOYaiFQadBjDMSLuCA8/iNWX74nkr+dL1v5NCkBgx4pGqzTMP800Nab3qIM?=
 =?us-ascii?Q?QTBHM6jByfdms63RfTiHOMsc2UwIbNeC0W1NXzrBO9+ZwK/DEukioQP7UWSS?=
 =?us-ascii?Q?6l7UMtqpQ1lnu92hXXKhASm9nuwsD4BGmw+DU/rZjoQi3R7qGPbK48RZOeaN?=
 =?us-ascii?Q?EPqZXqy8GnMEQ9+ll0P9sJE3O3yUYi3yMcg/udkdKAhykG6G3SqtGnB/skTn?=
 =?us-ascii?Q?x10ti04u/SF42OsM5UO3dsKnxZ2LivhypC7GikCmCtlKy+aKixUv6hjOzOdZ?=
 =?us-ascii?Q?Aj+ocf/U6Rs+Xif9jQLhRAu/4okjUsZgsy/vAYJ1F3gs8kB1lID0Oyz9kH/0?=
 =?us-ascii?Q?WE7NBSoS/k9wr1WTqXPFBFqkiaz+gtrJjx1qomT1+uinMOGnlhqmFuO6JhWy?=
 =?us-ascii?Q?emOFeLQGATHSBG1IqDJmGqz/aLbXWEb4d9I74dIgudnKScLfJeyHR14fNnnj?=
 =?us-ascii?Q?eEwj7yQSu6eCZA8Ioar3q3RbxzEEt9sgIsV/BP6Ga5WCyJpuV9jxw/UCyiaL?=
 =?us-ascii?Q?6YVpvj4PuHjEEeAkezmokm4xw8WvcMX6aJ9wYDETUg8/H70RDPyUZAPHNO8x?=
 =?us-ascii?Q?Tt9CjRs0Wpet+EUaNWi0bVsBhmTCU8dDMX6SFJ2+AVoBhIOMqSMsszvhNTxT?=
 =?us-ascii?Q?on9IrE/Ha4/PCuUoUcSeq4f38u78qPuafRc5o7+7BXFREALUHsCn1Sg1tMf/?=
 =?us-ascii?Q?mbCI0bFkp3x8ELo+7fvYf0XywxWSsjuVhW1SxkEykaUkfiBDj758ffroI5CC?=
 =?us-ascii?Q?ARhikeWECICdgLitaZuDs60NfP+mC/V4qzVnuBumOng8khvJj4VGtGN2W9ZA?=
 =?us-ascii?Q?u9HznlkUEGxIKjiAUsJQzzBoTsHpswSF+ao5fqiJtY0BglggUE6brPvtGg0B?=
 =?us-ascii?Q?1wOfLXiDRnGCtExOk4q1TGp9tVPcpjkxacJlsFfHN/dEYDd4NGp04MUrgR/u?=
 =?us-ascii?Q?M25rnm9IWw/0rav3wmLOznsDa4AKOQxW41HiBaPwPf+JRYPshRbaBLsP3QPu?=
 =?us-ascii?Q?t7xyzqsOsLVO66k0/WO60sBtpzBGTbM1B5iXUAWM/W/CnzuA0EqZs4wrBq+7?=
 =?us-ascii?Q?AqU+GQpXZXTqhcvI9ZspxDTwzYSfcPyiCPx++9f7dLdQ0fPLORMvkIu1RmM6?=
 =?us-ascii?Q?SJlTL67mB/esu0m9sKKlyVg++czxoMM+fArTUaT+/RJnE2S5kJ6k8a1798wV?=
 =?us-ascii?Q?feJk94ntwGFHaHud9nPLNfPcazS08l1KrRin7cFw7jKqgBm/2MgISRAjjZ7+?=
 =?us-ascii?Q?5HwTE3mEwiozz1fVJhJjM9TzNEul3RgXaOvis+3GeNnEW2KdBRK7CXQkGtZt?=
 =?us-ascii?Q?JI5EBKQwirUM4Bwf8/m1hijH/6+zJIW1WL03G9M921xiPRnznpDoa9SfAt9O?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83edd099-ae5c-46f2-da93-08da9d815695
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:25.7537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLbHAUdFy46otvMN5FtuQn13WbFu5HxRHtApL58IgnifRmbfwWAxxsOkCsT3pZscyJHapUSQF7AAZDXmFu3eGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

To keep the fast path checks optimized, we keep 2 arrays in the qdisc,
one for max_sdu translated into frame length (so that it's comparable to
skb->len), and another for offloading and for dumping back to the user.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: precompute the max_frm_len using dev->hard_header_len, so that
the fast path can directly check against skb->len

 include/net/pkt_sched.h        |   1 +
 include/uapi/linux/pkt_sched.h |  11 +++
 net/sched/sch_taprio.c         | 138 ++++++++++++++++++++++++++++++++-
 3 files changed, 149 insertions(+), 1 deletion(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 2ff80cd04c5c..3c65417bea94 100644
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
index 0bc6d90e1e51..c38ed1861ee7 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -78,6 +78,8 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
+	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
+	u32 max_sdu[TC_MAX_QUEUE]; /* for dump and offloading */
 	u32 txtime_delay;
 };
 
@@ -415,6 +417,9 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 			      struct Qdisc *child, struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int prio = skb->priority;
+	u8 tc;
 
 	/* sk_flags are only safe to use on full sockets. */
 	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
@@ -426,6 +431,11 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 			return qdisc_drop(skb, sch, to_free);
 	}
 
+	/* Devices with full offload are expected to honor this in hardware */
+	tc = netdev_get_prio_tc_map(dev, prio);
+	if (skb->len > q->max_frm_len[tc])
+		return qdisc_drop(skb, sch, to_free);
+
 	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 
@@ -754,6 +764,11 @@ static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
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
@@ -766,6 +781,7 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_FLAGS]                      = { .type = NLA_U32 },
 	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
+	[TCA_TAPRIO_ATTR_TC_ENTRY]		     = { .type = NLA_NESTED },
 };
 
 static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
@@ -1216,7 +1232,7 @@ static int taprio_enable_offload(struct net_device *dev,
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	struct tc_taprio_qopt_offload *offload;
-	int err = 0;
+	int tc, err = 0;
 
 	if (!ops->ndo_setup_tc) {
 		NL_SET_ERR_MSG(extack,
@@ -1233,6 +1249,9 @@ static int taprio_enable_offload(struct net_device *dev,
 	offload->enable = 1;
 	taprio_sched_to_offload(dev, sched, offload);
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		offload->max_sdu[tc] = q->max_sdu[tc];
+
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack,
@@ -1367,6 +1386,89 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
 	return err;
 }
 
+static int taprio_parse_tc_entry(struct Qdisc *sch,
+				 struct nlattr *opt,
+				 u32 max_sdu[TC_QOPT_MAX_QUEUE],
+				 unsigned long *seen_tcs,
+				 struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1] = { };
+	struct net_device *dev = qdisc_dev(sch);
+	u32 val = 0;
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
+		val = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
+
+	if (val > dev->max_mtu) {
+		NL_SET_ERR_MSG_MOD(extack, "TC max SDU exceeds device max MTU");
+		return -ERANGE;
+	}
+
+	max_sdu[tc] = val;
+
+	return 0;
+}
+
+static int taprio_parse_tc_entries(struct Qdisc *sch,
+				   struct nlattr *opt,
+				   struct netlink_ext_ack *extack)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	u32 max_sdu[TC_QOPT_MAX_QUEUE];
+	unsigned long seen_tcs = 0;
+	struct nlattr *n;
+	int tc, rem;
+	int err = 0;
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		max_sdu[tc] = q->max_sdu[tc];
+
+	nla_for_each_nested(n, opt, rem) {
+		if (nla_type(n) != TCA_TAPRIO_ATTR_TC_ENTRY)
+			continue;
+
+		err = taprio_parse_tc_entry(sch, n, max_sdu, &seen_tcs, extack);
+		if (err)
+			goto out;
+	}
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
+		q->max_sdu[tc] = max_sdu[tc];
+		if (max_sdu[tc])
+			q->max_frm_len[tc] = max_sdu[tc] + dev->hard_header_len;
+		else
+			q->max_frm_len[tc] = U32_MAX; /* never oversized */
+	}
+
+out:
+	return err;
+}
+
 static int taprio_mqprio_cmp(const struct net_device *dev,
 			     const struct tc_mqprio_qopt *mqprio)
 {
@@ -1445,6 +1547,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
+	err = taprio_parse_tc_entries(sch, opt, extack);
+	if (err)
+		return err;
+
 	new_admin = kzalloc(sizeof(*new_admin), GFP_KERNEL);
 	if (!new_admin) {
 		NL_SET_ERR_MSG(extack, "Not enough memory for a new schedule");
@@ -1825,6 +1931,33 @@ static int dump_schedule(struct sk_buff *msg,
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
@@ -1863,6 +1996,9 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
 
+	if (taprio_dump_tc_entries(q, skb))
+		goto options_error;
+
 	if (oper && dump_schedule(skb, oper))
 		goto options_error;
 
-- 
2.34.1

