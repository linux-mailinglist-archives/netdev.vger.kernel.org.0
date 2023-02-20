Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C251969CAD1
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbjBTMZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjBTMYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:24:35 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2054.outbound.protection.outlook.com [40.107.15.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5081C592;
        Mon, 20 Feb 2023 04:24:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNeco7JYAeIcZoLhddkZ2iPmHaPzlwpkNHYd71Wk5Lp2jLLwHAls1JlDbpYt3G1HK2Kwmfulylm+pF8pOTBAY7E8rnm5wA3U2yqwhCnl0JhS+twPEpWBCVaKc9WYNpnlXetShHjI+8RxaYE1izrimuNFTnEhDX6bC137bbpfowuGGmEI6/f/pOeH39bwmQHvDXBFHBs8K+RDudRSHerxwJuptbY7QKlBmOYqUL6E3Z8pr6fi7X2+UM9yNa9AnARFv2wb9PvTpzqrjuW5Qgls2UZrosKqDdXGnC3kjD0AyEwgpxK1RX5mSDHxzGehnLzpzN2VkkLvF4fFF4dU9mLSJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=InaTY6K8I6vtUgqHdvNLhqv7r2tvZqsSyR+0THPOCL8=;
 b=TIcO8EbPTFNzXM5RtgXMtnfGfci91gVPZnXnme5bjBblN/F2Pt6DZAiwC6M0ViL3IQGxe32XTgivKRDoIxMRsQj6Nx/gcJGtfo+gs0lTh1hVzpyMmLFUu7adsI3iKQ0QYpofhYXDZ7PDlEyghQhC/JOQv8UID+swg39+7QQzxS1tiRyW6PFmFnZSb2u5dAPMPzvX5lLb9nSRd73H4+TjjVWuclTbRdQo+fcGgnirt8dSU26SkXOfT7eb9Fh28+m9Lt3pb4qkRO1OVGh52Z5DG+t6r2Nn8ZMPXvqCHVYRFCHWm+tZpR484tJTXekcs91NdH8Uhp3c0DjnUOrPmm8KKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InaTY6K8I6vtUgqHdvNLhqv7r2tvZqsSyR+0THPOCL8=;
 b=knOIAGHwkpE94+haHPuGwb4LBPC6CqnmHmYOYR3iLWxqYy24nXH+chP7Hiay1xSf1SWcYdlGeEio6RU83X9u6nNIZuxnu/Hg3fmHkMhaU6dPoQ+qa045Y0cmuDEShF4zgjbkUkmOLl9JwMxG288VrHtCbYwKiDicoxOvpNYHBIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:24:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:24:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 06/13] net/sched: pass netlink extack to mqprio and taprio offload
Date:   Mon, 20 Feb 2023 14:23:36 +0200
Message-Id: <20230220122343.1156614-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ef9a81c-434f-4558-1ff7-08db133d5e68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0a1mYMNQbrbpH4XK/Bmt0Bb4HzZJYZ4C4Y4v5LoxRCNlCoJRPGCS74ulKq0qtfZQPKoF5sJiBIWTgZxQTwTY2m0tsAbxCfVhi2lcS4TbdKVJqp39ABVlyYxVGMalSW4hFPEAp5i71lmuWnsibmCUUNUYeD3eB2bceYfeA7xjyK4nbiw9ylFSQpqm5Cp040LguDVoQIutj4dHNP+PuSYftdubehNH+EzStzsAGFfOc2TRagPzRI4874T8Ehztj6CM5GOd6PXdAxOoDzoC11IgoihFnoEIDnb/0JiCDLTkxxfT7lR4EgHy2JUnq+IEJhKshAlq2gdu37sVoEUZGVpBi5W0S1ayL417/F7geDXuMWtJeHuaoPsmLmU6O2FgcXJRF9VY7ff6/sminaqGpjytRDqp1X59F8AwKB4UWH36uSEFEVTgKPUIu99NB8bKsNx9Lb19ixzwBuLQ06LrSiyIhoWs3m7Ikix8u5wvUjslQ/f/hF0uzN9g0e4v9AvKdbTsO56hgucERRgarouoDZ6Nk173fWVp7f/hbN5+nibPmLNTD/y1Livl8d1lQrF1r3LlUyVfoW2LE7jcDnaDn5kOhwHthAs5gVGd5KYaexPa/LXu9BwRpVQ0OfZO5zT319LbQCfjUD+bVbEcxA7ieqaFxdumtyWZr/gnFPaewtwBNlZsXlRxU5hoDxFJXYDmaUk5NJOz1zw3MkVl7d4s/dvmFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YSc1LQ9yp86OtQe5VJ1FPnDcqArEGQ9SlnIxoTRyBIEL9CavfmT9Ez4GfU91?=
 =?us-ascii?Q?+kHDDPxEL50odJSsOjJKTgJVHwNKQTUn7LolVz7FOWPh9rk2QfV4XCJiw8fh?=
 =?us-ascii?Q?xxmtcDzapjpKvQbHDb3GXmkELf5SG6TlWnwHrLyavuadqKTULk+4EilQDcZ4?=
 =?us-ascii?Q?ZrT7gkhmBWBGwgZ8y7wjtOlqwlmYd/m24YgD5ekn3eG70R9+SXBLnJweLgdi?=
 =?us-ascii?Q?iMhJgkYcUzP9JIkPAN45PRqbNdNQ5373yMt8JEoamaqJvmQ6YjoPts8hlTl9?=
 =?us-ascii?Q?Jm7i/spU8kK3SASzvHwrLc4FK/Zeg0L6XHZ/HfQApFjDxtbKot4xo9+WLwl8?=
 =?us-ascii?Q?Ww9TEfK1Em8YFjERpiZe0ZBKUNdBesNZXT09PYjMjUf5GL93ctc2cdEg5trx?=
 =?us-ascii?Q?wFpPyD2gYy0LsGSN6efqFk2BwfzFa2H3OwxAlkV0+V45rY9kAh7+sdjqSn2d?=
 =?us-ascii?Q?v8/10iExNzoXHSGdG8RSxkLgzSJyG5h8t8dry6G0WkR0wgw9EPOOFsYd1C8y?=
 =?us-ascii?Q?za5sEcoXeVKJa02V9aZP844vFsQrPWRPI166PF3IGS1qMl0hywpAP2BZlPoR?=
 =?us-ascii?Q?iHalgURlPb2FmgSvcahtZKajZUsD/zwFbXlHxn0s6b4nW2qrsOq48lkQWx7p?=
 =?us-ascii?Q?COj8/P/4iyoStCM+jaN1yrTQlWXK5rFangkpWDWXTP+Bhj3DtltMZvWb2yR+?=
 =?us-ascii?Q?/VLN70681kkR+rfyULOXXCzhltnpVAnrnWRhKFdHlKrBNU0HS+rxRGLzc8NM?=
 =?us-ascii?Q?C/Q5XJXBWRO7B4YAasW0LUe/iRHqZ1kZMMmv9Y4/i1fuSxgT06x9OjVdHxuf?=
 =?us-ascii?Q?VfH9yNzJmFjQBOgRihqOC3ouWtAvRiuve1hSbIKRPKeUglEi04/odXBeQDUU?=
 =?us-ascii?Q?DritCPr/c6TidwUa9yJ+Fw8xT/druj2ehKu6jOJajFnOwMTLmaC9EYIxcy3M?=
 =?us-ascii?Q?6ilIjyXU3Bd+3uM05zXhlByBqVJT2cHSwT2PhWrPV2PkmvM+PHx5Qe/5oCxL?=
 =?us-ascii?Q?9AHtyvED8lqmVonqH43E3iIpRb7Ksr4jK7zXaLJ3jxmx7lmTHrD9KZno16T3?=
 =?us-ascii?Q?KIVSaNX2Ie6LfjzfO/bj1DrEx42yveD7OsjTttB6ETY0p7Z0ZFX1nJxmnCdI?=
 =?us-ascii?Q?FrpnBsX4Ux+QIn27kp6SLhRHPA7NxV/NPoKxBwChvNcKZxzWyNSi5JQRlCRe?=
 =?us-ascii?Q?4kIGiDGJJtkUBU2ZlIJ0CSx6HSKNyqnG/m4d1MTABFvih8AWOXb9zqLdWkpw?=
 =?us-ascii?Q?nmo8h03CR7XWhlQMLlfCiYjQD00i8V9ER81MUWPQkyckZoCCXhdx0RmMQzy+?=
 =?us-ascii?Q?5GzWYjgDTkbhTSvQspg2DUXbrvd9oznaJ+/gxhePvmUmWsC35jiuypiYcIkH?=
 =?us-ascii?Q?AbJ80EVCCJU328zhX5VuiW0F4R7ii2da/mN97+kzIOxnixY52vP92h7SjuGy?=
 =?us-ascii?Q?dLnn+trJp9WdrjtCamiiHJ198C1BWJYpnbMS8aVzLbWKJ08rDqsztvymGJ6n?=
 =?us-ascii?Q?vedRNKp5bVzp+a+QWAHp7z+54MLDQ6dl46h4d01N22f6Os439Ef0au3faU+H?=
 =?us-ascii?Q?jQwNjuW//yWc9m+dC3geQxWkDH2OQhMMFjsQyx0TuhfRlubwTh5TKJDWOblx?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef9a81c-434f-4558-1ff7-08db133d5e68
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:24:10.3215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNtBOrvoILK4CSMgCUBGo2HK+FSlq8vuUqxdNMOCVQa3rwmRrKbcm+4B33A357ZHTG0GG+byoSO0/FxpDNn/Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the multiplexed ndo_setup_tc() model which lacks a first-class
struct netlink_ext_ack * argument, the only way to pass the netlink
extended ACK message down to the device driver is to embed it within the
offload structure.

Do this for struct tc_mqprio_qopt_offload and struct tc_taprio_qopt_offload.

Since struct tc_taprio_qopt_offload also contains a tc_mqprio_qopt_offload
structure, and since device drivers might effectively reuse their mqprio
implementation for the mqprio portion of taprio, we make taprio set the
extack in both offload structures to point at the same netlink extack
message.

In fact, the taprio handling is a bit more tricky, for 2 reasons.

First is because the offload structure has a longer lifetime than the
extack structure. The driver is supposed to populate the extack
synchronously from ndo_setup_tc() and leave it alone afterwards.
To not have any use-after-free surprises, we zero out the extack pointer
when we leave taprio_enable_offload().

The second reason is because taprio does overwrite the extack message on
ndo_setup_tc() error. We need to switch to the weak form of setting an
extack message, which preserves a potential message set by the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

 include/net/pkt_sched.h |  2 ++
 net/sched/sch_mqprio.c  |  5 ++++-
 net/sched/sch_taprio.c  | 12 ++++++++++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 2016839991a4..fc688c7e9595 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -167,6 +167,7 @@ struct tc_mqprio_caps {
 struct tc_mqprio_qopt_offload {
 	/* struct tc_mqprio_qopt must always be the first element */
 	struct tc_mqprio_qopt qopt;
+	struct netlink_ext_ack *extack;
 	u16 mode;
 	u16 shaper;
 	u32 flags;
@@ -194,6 +195,7 @@ struct tc_taprio_sched_entry {
 
 struct tc_taprio_qopt_offload {
 	struct tc_mqprio_qopt_offload mqprio;
+	struct netlink_ext_ack *extack;
 	u8 enable;
 	ktime_t base_time;
 	u64 cycle_time;
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 9ee5a9a9b9e9..5287ff60b3f9 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -33,9 +33,12 @@ static int mqprio_enable_offload(struct Qdisc *sch,
 				 const struct tc_mqprio_qopt *qopt,
 				 struct netlink_ext_ack *extack)
 {
-	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
 	struct mqprio_sched *priv = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct tc_mqprio_qopt_offload mqprio = {
+		.qopt = *qopt,
+		.extack = extack,
+	};
 	int err, i;
 
 	switch (priv->mode) {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 1f469861eae3..cbad43019172 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1520,7 +1520,9 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -ENOMEM;
 	}
 	offload->enable = 1;
+	offload->extack = extack;
 	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
+	offload->mqprio.extack = extack;
 	taprio_sched_to_offload(dev, sched, offload, &caps);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
@@ -1528,14 +1530,20 @@ static int taprio_enable_offload(struct net_device *dev,
 
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
 	if (err < 0) {
-		NL_SET_ERR_MSG(extack,
-			       "Device failed to setup taprio offload");
+		NL_SET_ERR_MSG_WEAK(extack,
+				    "Device failed to setup taprio offload");
 		goto done;
 	}
 
 	q->offloaded = true;
 
 done:
+	/* The offload structure may linger around via a reference taken by the
+	 * device driver, so clear up the netlink extack pointer so that the
+	 * driver isn't tempted to dereference data which stopped being valid
+	 */
+	offload->extack = NULL;
+	offload->mqprio.extack = NULL;
 	taprio_offload_free(offload);
 
 	return err;
-- 
2.34.1

