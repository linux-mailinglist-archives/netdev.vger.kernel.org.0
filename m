Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94726DE35D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjDKSDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjDKSCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:02:43 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AD361B5;
        Tue, 11 Apr 2023 11:02:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frBUxP1RaKbwP1DmJHW3W0n7b4yxtHHXr/D+hUXYNZCtpmKpWzIHvMSmV44+XBbdrvDrvfEV1J+uXVGf7SmcfYxSVsBeojSPt8flj6GlxcoGHXpRVDgeke7payZVdJX1pOxXqS7gli3nYMQI2fTQR6ZjPGipEvQvy5AELFkppSWMAJtafiQi4zAabd6rtPBLs4gjsgpB1w5Bm2xn8IzGpfXxE6DFLzyC+MPHIKEvmUBHlSGvDs/p8KVRzQu7sytzHYXzQwaTqUPipypzXQ+c5xGzBeLlG2whWHetGOqqzeXP96asVa1jsbEw0VIYhiTyqG2XXXKgeWjdjkGSTlRr7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VP9EEfl5mIhmjubsT9Ff9sFexFj057nS6x8TfZsyEj8=;
 b=TI4G+iQfnvNtYhAZKBXslop0d38QEgzuN25ud+TXG0OwWxnMPNUxWWMUVlBd5reb6bUvvMDGWSn1vWBI6J+1F0MRYi4aO8wNFq2ZA1IDcjkBVg4qplO8SrCBQGO2woQztjtcQGvC8YTYXj1Z5KGL5VHClc51cj/QFN0ovETTipJdRMmwiayevUub4kFa5MdRYM29uFk9tWNJl1fQoEjOMbhWg+/zGnabeSDkNpCUlVgLG2NoKzfI/TFGccMFuSkOfeYpR1zgv/UP4Tj/cF8T4oUoTmoCxjib1Xa2Rf/XwjvXBrIDEY2KsSKsY3TtzPZjDkUHHUJa+OX9OoSvnC7goA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VP9EEfl5mIhmjubsT9Ff9sFexFj057nS6x8TfZsyEj8=;
 b=Q8hWAEyyqzSlD1vqtsnD8nZCtvKdSxfUGOpSvSwnB/IGgkgrWPQNopdjri1f8VA6mHqQOgwlttiJCjeL3uypx6UQoqBnQtrCq3bYq79/eB6mEfXnh1YELaPAqkzr6t9u4NSgKKicfR2eDNSM1/+s1WImY4Upa4XeFinMYmHF+iw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7829.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:02:28 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 11 Apr 2023
 18:02:28 +0000
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
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 5/9] net/sched: pass netlink extack to mqprio and taprio offload
Date:   Tue, 11 Apr 2023 21:01:53 +0300
Message-Id: <20230411180157.1850527-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
References: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: 073a089d-5caf-41c9-8658-08db3ab6e9dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GCZ7OpPBEuvtIHFX6hvvMt8oX382EW8zsGPFk8gNo3oXx3cHDEDgssIwd260haUnErqXrlV8yGtca8hYmvPTi9SppwKuyi9QEG5J5JMsKzbKteMpf89yRbUaFBk47BkrkCZT9f3zUp0/rdV9b8DECV7DXgndy2lDmIKqRAw3Hp2z0+ZaAKE4ikLSPx4nFGp1KSQVHXq/fyd9rT3+h0Rt0fxgnB7Vn9LnivirroVFXXPScEotHpITG8xPiyxHW1LAEMqegD1nXahNqnQqLoKv0m0aJlyan6bE7BArekboNKEnX5KakX3a33eujIjevt/u5Fxu/pIUrGOi7smO1cNGR5kuf9Wk7BvzUKKazctCFFKAo9lmnr2ZHtxQXXWd1PkY9vNblKM6q6KzQb+pSUmioNPPcSPVaGLg3raow9Y2YGNNz7AOuyc4H2YncWfIVOPeVDFboyGElB1Pz1b2+mD/rjkn7X5Kw5AU8HJQSv+lZIS5UMks2IZJ135OdxRuoivh20nfbVXl4Ot+SP9idHSg3ZXy54r/at1lDKJlpnnb/0b2fJdQ7YBlbRZRqlGeF+ZXso/oiBWtjwoA4KjLya7B1blBowDmp/ciavof/Lm06zgQxQ4Nh3J5GaJiHCW0NFAL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(41300700001)(478600001)(86362001)(316002)(54906003)(8676002)(52116002)(6916009)(66946007)(66556008)(4326008)(66476007)(8936002)(6486002)(5660300002)(7416002)(44832011)(2616005)(186003)(36756003)(38100700002)(38350700002)(26005)(6506007)(6512007)(1076003)(83380400001)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qSsmE8y/XbnDXgJMZSt14+5MPCGIjKOZpAGxQPB4TZbdHFW08e+vtER1JDFJ?=
 =?us-ascii?Q?3l8YNA/DRBbOWly2NB4WploISG4G+cIL4PWwx6iwdNcIJKF1iTUjimreGVAI?=
 =?us-ascii?Q?kfCpGh69iH5znrDjn3mUeOiQHz9zrokK2SzfUmjPVakGSXTd47EiKMhRiSJX?=
 =?us-ascii?Q?jfwdpGfr7+uDDkdk2JZ9XxWwQB7WAqk+zkaIbXHInzhdW8zWEXzJY+Q46eTJ?=
 =?us-ascii?Q?TUTOIZLUFjD+MNPSkdeG2jkIwbY8FUn3XlJpNR/ILYted7g53I2u5D1gQA/U?=
 =?us-ascii?Q?CSIFPG24EKTk+FbddUcxQepuzD9w09bG7NGMzEMDpSCSQyCpERtVkOaOJxoF?=
 =?us-ascii?Q?maeQ9pwMTfQt7vt/xZYRwY5fWdoKTfXhqDgT6dLZZeer2nTyZZJLSY17OexU?=
 =?us-ascii?Q?TdWiqKfOYyl1C1QGUCXli4Mm5Rp3v/DENJpBFR1HkD8/0xdp02u6YAXmbefZ?=
 =?us-ascii?Q?oMFtKbFSbXOvB6Slge8ssmTLlnHwKHAG2/sFiYUlPkIjrvOapa0407ncJLV0?=
 =?us-ascii?Q?BknWfxS9xodgjuNT+I7v/0hU6ArY2GfvtfkAGUo9dGHmafu6hTuTLGVsnNIY?=
 =?us-ascii?Q?/NPxIlVY7YCXMUnoIFzPRKKNM0O3cdVKYzWLHAbhNJnNxyurQxe9dhsKLuRT?=
 =?us-ascii?Q?u8mdMPk+vSB8QR1sBK6nkNIbQW2lS3wXcfxzNlMOiChGSGHsx+MBW+Ur2eXM?=
 =?us-ascii?Q?JR+rGM+etgLGJOAh4mjSkYT7TR0CJRsQ8HxMSTdG5UPpWVMoSGIdnfdtJq2S?=
 =?us-ascii?Q?Jiee/YwVwYjopUDeb/1ojLBBo6rUxTXubvR1WS55J+aYEjNp2PZCvTi5MkOV?=
 =?us-ascii?Q?yp0yg5cunm6YZWkBRCX6D/5jmbX+jetI5D3L2UDgE+l8dQweGpdqjxCoMlyV?=
 =?us-ascii?Q?t89nGsmC9jSeRYMSLRZ6GLXFvIkBbc0okQ5rpjjFud+cQaC/63R3z2aFV51m?=
 =?us-ascii?Q?NBs9M6/dLigX0cnyX2rImoBmnqDIVgNivYqBpRFhFxF9LJSt8pCY0KAv6QYj?=
 =?us-ascii?Q?nNVoxrBVXR/I5tE4XgprUBhpkm5iYmbFnymw/DR5pJQSCOzn26AuOWMQUpOg?=
 =?us-ascii?Q?1RDnAoHpI4AQg/uDlg0Mmc9fVtgji0HvhM461Twt5I98NiKkHl//Shd6Zu4V?=
 =?us-ascii?Q?ZktdhqKYx8mqLo4LsvWokpfqs0mqSuV8eP0O4CllfcnywQxIoXwCtSuGeAuZ?=
 =?us-ascii?Q?84WyyYNbudblakTV1RH6dZ7CwYEqisfNeLz7x5gZFDPMaUZ4/Fp89KjK8dKw?=
 =?us-ascii?Q?cPGydoY6qINLHuLwEmAkpQaPB/MQcmsU2PT11bdsg1uK0SD91cDVg8TOyIPb?=
 =?us-ascii?Q?rvYZ3QqrimmbjNGnb0qm9g35qrAaY+O8gn+LTWYC1CK2v96BTPbB9DKgXB3O?=
 =?us-ascii?Q?RWrGyZbkRFMnH390GuTaiK/7Lxs73MHYV6FKOMAe3zfRkCy3nHf8GmH1CuHZ?=
 =?us-ascii?Q?UbCya8QNYNxUtJ8u/RPOlJSos00NIgLjAi/76JPiDlg7ohYdzFg3Z9BwsMtw?=
 =?us-ascii?Q?7eaQJJmbeycSypTVAZonZ++60wrP+wnrAAYv4PLojNWG0DI20S1f+a/4raF6?=
 =?us-ascii?Q?mu44lj2kRfye4WhyxIFmen3ezVYApB37jfNYv9w370bAReLaRzgBg5DqsBCe?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 073a089d-5caf-41c9-8658-08db3ab6e9dc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:02:28.7140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2J2MdSccaAMq9yYyXLvdIY3g2u47oKtmBdxxSUYdxuho/+WLsIggcW5BHhbpmy6VzNARf1aVSU9u0D7wpfv1Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7829
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
v3->v5: none
v2->v3: patch is new

 include/net/pkt_sched.h |  2 ++
 net/sched/sch_mqprio.c  |  5 ++++-
 net/sched/sch_taprio.c  | 12 ++++++++++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index bb0bd69fb655..b43ed4733455 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -166,6 +166,7 @@ struct tc_mqprio_caps {
 struct tc_mqprio_qopt_offload {
 	/* struct tc_mqprio_qopt must always be the first element */
 	struct tc_mqprio_qopt qopt;
+	struct netlink_ext_ack *extack;
 	u16 mode;
 	u16 shaper;
 	u32 flags;
@@ -193,6 +194,7 @@ struct tc_taprio_sched_entry {
 
 struct tc_taprio_qopt_offload {
 	struct tc_mqprio_qopt_offload mqprio;
+	struct netlink_ext_ack *extack;
 	u8 enable;
 	ktime_t base_time;
 	u64 cycle_time;
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index aae4d64dbf3f..67d77495c8fd 100644
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

