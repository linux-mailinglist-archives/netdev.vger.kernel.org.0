Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B465183CF
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbiECMFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbiECMFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:05:42 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80040.outbound.protection.outlook.com [40.107.8.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AF03134B
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:02:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ck+N1gEUsF3gGxE8LdQRWvYyVeOein0sDidxmKVlnEhP8oM536ccMjxreLWAXGaTK4qtjkAkJKsbrz+IDWdt4W8SS/fWMNYNz/3SSvWOY5VSN1FGiPee0eNxxKjY/Txd4p9/RMLq5DlIGSBlFjpcMAom6pyf1vp2ZlXj9RKcOu5hgrnvqw03uref5TebV4xWUSlaXu2NUQVU+UGuLPjfvd/fj9CEnxeiwKS9Tg7CAy+uMpzlAO3j1axSsbk2WluleI7ZuOnJDxd38CMxntqcoaVwxxzM9RSQL21iUf3sIriWPnKLsrU2zfgX2LSFiQ9ZwPmfvMjOKTGwJQV7ohw7iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lc6K/qSvc4Tpgn7Mxi4FOhecqFh82cVcEzF0DlTCk7E=;
 b=T6uRaMiBRbYinlSc8v0mRAXoyywiCd4FtRLRHzvHdogboeXTFYlXEJVTVMZ0Iv6i/uYP9zCmO5pmEdg//s4Yxml+Bhf+RkMtAR1wjHEnk+/qmz5jPazy42+2wFMkOKss2zCwRQYK0lBXzFoDvVJU9zAEatxwsK4glIpIQvDGblZbemR64pjUasD+qfWDLYy/EIzTxc2gQTpDKxJDzE0QzIWThqZHCa2EMSCiF4UgjG0bKIJWS/XCZBIsh+axiN0j93sVRimBQNHZyGoh3UTPyJ9uOdUN3Vw9nTeQuClCX3QsrxwFKeafnhu06t+uOy50KVVwFHWg+mFEeILATn78DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lc6K/qSvc4Tpgn7Mxi4FOhecqFh82cVcEzF0DlTCk7E=;
 b=WgcPAtPrkavywU3tztxxtYcqn2Qaj3Gzk08Ccl6NDM8MP5c65LwSoUuyS4LQX55cH3ZGSS4bsRUM2ITuvp5o72AZshFl1h+wD4zLeQsQb/DOgkm41orGtWN7vtAHeHpAyHLvHf+bypMw+4qEc5rWSWrknrYIDf3KSujZOKeuyQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS1PR04MB9480.eurprd04.prod.outlook.com (2603:10a6:20b:4d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 12:02:08 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:02:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 4/5] net: mscc: ocelot: drop port argument from qos_policer_conf_set
Date:   Tue,  3 May 2022 15:01:49 +0300
Message-Id: <20220503120150.837233-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503120150.837233-1-vladimir.oltean@nxp.com>
References: <20220503120150.837233-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0067.eurprd04.prod.outlook.com
 (2603:10a6:802:2::38) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f044371-9f80-4157-978f-08da2cfcbfa1
X-MS-TrafficTypeDiagnostic: AS1PR04MB9480:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB9480A16A45020D27EAD1D77FE0C09@AS1PR04MB9480.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SF6W5OjPhr4cLzPIWjVjLmlyw9rNRZy+DzecukgJ0zEnGv2urGzHqNCsAwaybWxbPp8owINvnA0iXCZi+kRNKr1xg6f1Hrq4m4a+gUKFLod3gi7+X9wlYcyq96kZxSM+JNs07ZcyNF9qkvE6e9qCoKimbPGkx1XKm0GhlZ1FdEfSbKI8MVQv9MkkO3HqHhSAD02oBct9FdeFH6vXgqvPC4Crhx91tH+J5xWdJNNU72/w/YE6cL71w+ttCIHsiEVQT1Qrdgb3EPJSAy2E8iqcTHon2kUv0bdhpXH3ytlAtjTmkW9uU/uvPJtSF5zEhZLIICZ396gVD/EgLs1K4CGuE55AVCz/yxT8SnJ/zX8vHySOD3DkDZmCZ+gA/z5Fgnog6tfwqTEMLO+CtorBgmCNtH7v+PilDREIDyM+MrrQWDTOJ65D2rb/TIQblP2WD4A7vSxtEQHaNgHLtENfb/mMotuFqMRdDAHUmEDOFrBWm3kClfAwYyC4wQWslXWpt4xYtdF/FR7cBDmWs8lxRBpnu9dGFoCltqBfWy8u0Dgy68goy/pizRUqTPReoNfh2laTTLJOv/v0yrOtXys+dt6/hOamSCop73dgjmYd3B/FA8aAM2tUA7Lb18OhC5GgXBaZ1DwG0OQ6MezkVGJnh+n2OARo6k2dt+SNoVisv2JoX+rCfoFBU2BVuDHzMTR3AbHxhrN7WNN5YVAwNjsiahOiQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(83380400001)(8936002)(7416002)(8676002)(66476007)(44832011)(5660300002)(38350700002)(4326008)(508600001)(86362001)(6666004)(186003)(54906003)(2616005)(1076003)(38100700002)(6916009)(6506007)(26005)(316002)(2906002)(6512007)(52116002)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j+N6xrsImZNHTkS5vhxGCIew9v+r0Ta+DxoiDJYI7U48x1uEzMU6SKWmZVAg?=
 =?us-ascii?Q?hlbEAW1JywQbcNSQuNVrKZeh1o/6Q1XxfVx//MV3OZr7DfIzTdl6QGIQ5VFV?=
 =?us-ascii?Q?PZFdGmEuOULW+2qlp7+NBwH27L/mBez58SVno+SrVZyDsG3qcgtnJWYpwdQo?=
 =?us-ascii?Q?00LpEtM0mpJdapFUzaJTtk/qoX2+/GgCFVBHxdbi0uikZoZRSDb4Ys4WJVgn?=
 =?us-ascii?Q?ZRz/vBVcXZngIqWT387fY0LVi79SWodyRyz/oOH1qooStzrobQS61QzJ8766?=
 =?us-ascii?Q?QIBMCRoUWHjiDmqTGAFLZp/50/SizTlNF0mTKG3Gradt88L/uTxr3dm1K+s0?=
 =?us-ascii?Q?mRP+sA9lekzY3cXT+k/pLQIDWZVpFcz8wibuMV4XCDejAPMWSQfIld/dZUfN?=
 =?us-ascii?Q?cuoGn1bm2ogXCqeFVqytZ/lhCLbX9iP05c3BfaDJqFUrwI7oWXvH9iGoZz4M?=
 =?us-ascii?Q?mlCIlyNZVryy3rUij1JBL50hu4OQepwTieW4MOcqVMeDr0kxWLl8o3JUShaN?=
 =?us-ascii?Q?QSl/rpR4M9blTz6NySmBCHEcdogFHbVW1yWIty5lrIU0mx1ahE3iGs7l2c8v?=
 =?us-ascii?Q?3sjbDehs7y7fp+uNfOgdClIlxSbmi6u5G6mAvIwuHKEu9eqgzj/cr2PsviAB?=
 =?us-ascii?Q?3lxEtoz0KkxYY6qBess7Xl1NCe9uO3pLaBUyd0Tn2wA4Zj8Rs1CfQaZczYJq?=
 =?us-ascii?Q?0VBr9quIRHkru4fThOdEKlslwkJzPgjtcRzgS1NcMQ1JpzUfg5f13Mdg4T2g?=
 =?us-ascii?Q?v55LCqeHl2rn/ekSewe6die3/sp4oK1E9hC2kXQdmDJG+WILU2EAX6qbpZl0?=
 =?us-ascii?Q?dJfNAt0dKL4p53Yncb6epxAnp6jTgUrxJCwhfl3aYpdHGLoyOxCKGImISPMy?=
 =?us-ascii?Q?IT+lsHB5HyC52p+jHG8Cri2KSVDrY4FjduJz2x/2K2WatwrQSYBTvH+N+DfO?=
 =?us-ascii?Q?vDpY1aY0nSC2X80zMJVkZQis3WdidXTNo/SW/g82jMja95GszyJfKLEk6kZV?=
 =?us-ascii?Q?6bMl1+N4sYqzOB95sGTcKSAnOskEFvIR1ugv7pqg+OiSeVMc8VS7st3OBUUl?=
 =?us-ascii?Q?aKjv44pUcwd7mZJHCfR2FWp3LcCB+erYXLEeh6g3IznhtJ37pvSEGivjo+hv?=
 =?us-ascii?Q?FDOIXp8iKK2+pfVmhyEWQGgx6x+lHxmxCqGwfS0wFr4Lu1xxXsMCC8NBjUUv?=
 =?us-ascii?Q?k4+7MNWu1xhfc0t0YtownC/tvStqIWLk9bWn59y49PcsnGtRdP1Bx571Xbv1?=
 =?us-ascii?Q?p043adRV5c4hj6Q0DUXUDy8CwjLvDYAGbHXdkb7CRAHDE515PPuxAZV7MKFl?=
 =?us-ascii?Q?b9bsf6h2O1t2xOndoLMty0vDPW7Wc+hGsQxt+bf6+/lj9fiVJoKKwyLufn2P?=
 =?us-ascii?Q?mP6LANiGG31+VtSrWzdpsBVkd9mM4u5JmBdqUJGTPK8fEiJ3f9OLrVsmvRen?=
 =?us-ascii?Q?mlXnscJMgQGY5jKoac1T8rD4JA5qyR+9S4Qycc0dedq81H6XOp+52Id/nFkh?=
 =?us-ascii?Q?0I4diG+kYqP6pflJZXZbKVjI1H3rLZRcDHx7rWTGRwdm6/iWfC5SIiIJokCD?=
 =?us-ascii?Q?RJv7yODdBNXHO2AxMuKtXfR4NL7XXnrUg7r9KGTVweMqCCGo59OQOF4FCWFt?=
 =?us-ascii?Q?qnNHfiF6VSZWsCDSq/bG3Xbc1pdP7fjx4F2GlwYaYI3P6mycRDI1LXMKrOy+?=
 =?us-ascii?Q?6OOMkV4AneOdcs0YJwxWUSyO3GV5Ezl3jqLo3ED0/L20rPYJqT76Ah5BZ9Iv?=
 =?us-ascii?Q?pdgsf6r3xKbbVq+B5vkl3/DqVNd9BjA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f044371-9f80-4157-978f-08da2cfcbfa1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:02:08.6484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NTiVN7dnqzzF31QVkgDe4MO7PSAHx6IPOXhQZ1eFwtXEvMPN8KRWi2khKpSS2FKVELL9UKM4ZGEkUbvjMN3dgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "port" argument is used for nothing else except printing on the
error path. Print errors on behalf of the policer index, which is less
confusing anyway.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_police.c | 26 +++++++++++++----------
 drivers/net/ethernet/mscc/ocelot_police.h |  2 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  4 ++--
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_police.c b/drivers/net/ethernet/mscc/ocelot_police.c
index a65606bb84a0..7e1f67be38f5 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.c
+++ b/drivers/net/ethernet/mscc/ocelot_police.c
@@ -20,7 +20,7 @@
 /* Default policer order */
 #define POL_ORDER 0x1d3 /* Ocelot policer order: Serial (QoS -> Port -> VCAP) */
 
-int qos_policer_conf_set(struct ocelot *ocelot, int port, u32 pol_ix,
+int qos_policer_conf_set(struct ocelot *ocelot, u32 pol_ix,
 			 struct qos_policer_conf *conf)
 {
 	u32 cf = 0, cir_ena = 0, frm_mode = POL_MODE_LINERATE;
@@ -102,26 +102,30 @@ int qos_policer_conf_set(struct ocelot *ocelot, int port, u32 pol_ix,
 
 	/* Check limits */
 	if (pir > GENMASK(15, 0)) {
-		dev_err(ocelot->dev, "Invalid pir for port %d: %u (max %lu)\n",
-			port, pir, GENMASK(15, 0));
+		dev_err(ocelot->dev,
+			"Invalid pir for policer %u: %u (max %lu)\n",
+			pol_ix, pir, GENMASK(15, 0));
 		return -EINVAL;
 	}
 
 	if (cir > GENMASK(15, 0)) {
-		dev_err(ocelot->dev, "Invalid cir for port %d: %u (max %lu)\n",
-			port, cir, GENMASK(15, 0));
+		dev_err(ocelot->dev,
+			"Invalid cir for policer %u: %u (max %lu)\n",
+			pol_ix, cir, GENMASK(15, 0));
 		return -EINVAL;
 	}
 
 	if (pbs > pbs_max) {
-		dev_err(ocelot->dev, "Invalid pbs for port %d: %u (max %u)\n",
-			port, pbs, pbs_max);
+		dev_err(ocelot->dev,
+			"Invalid pbs for policer %u: %u (max %u)\n",
+			pol_ix, pbs, pbs_max);
 		return -EINVAL;
 	}
 
 	if (cbs > cbs_max) {
-		dev_err(ocelot->dev, "Invalid cbs for port %d: %u (max %u)\n",
-			port, cbs, cbs_max);
+		dev_err(ocelot->dev,
+			"Invalid cbs for policer %u: %u (max %u)\n",
+			pol_ix, cbs, cbs_max);
 		return -EINVAL;
 	}
 
@@ -211,7 +215,7 @@ int ocelot_port_policer_add(struct ocelot *ocelot, int port,
 	dev_dbg(ocelot->dev, "%s: port %u pir %u kbps, pbs %u bytes\n",
 		__func__, port, pp.pir, pp.pbs);
 
-	err = qos_policer_conf_set(ocelot, port, POL_IX_PORT + port, &pp);
+	err = qos_policer_conf_set(ocelot, POL_IX_PORT + port, &pp);
 	if (err)
 		return err;
 
@@ -235,7 +239,7 @@ int ocelot_port_policer_del(struct ocelot *ocelot, int port)
 
 	pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
 
-	err = qos_policer_conf_set(ocelot, port, POL_IX_PORT + port, &pp);
+	err = qos_policer_conf_set(ocelot, POL_IX_PORT + port, &pp);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_police.h b/drivers/net/ethernet/mscc/ocelot_police.h
index 7552995f8b17..0749f23684f2 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.h
+++ b/drivers/net/ethernet/mscc/ocelot_police.h
@@ -31,7 +31,7 @@ struct qos_policer_conf {
 	u8   ipg; /* Size of IPG when MSCC_QOS_RATE_MODE_LINE is chosen */
 };
 
-int qos_policer_conf_set(struct ocelot *ocelot, int port, u32 pol_ix,
+int qos_policer_conf_set(struct ocelot *ocelot, u32 pol_ix,
 			 struct qos_policer_conf *conf);
 
 int ocelot_policer_validate(const struct flow_action *action,
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index e8445d78a168..30e25d45f08d 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -913,7 +913,7 @@ int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
 	if (!tmp)
 		return -ENOMEM;
 
-	ret = qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+	ret = qos_policer_conf_set(ocelot, pol_ix, &pp);
 	if (ret) {
 		kfree(tmp);
 		return ret;
@@ -944,7 +944,7 @@ int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix)
 
 	if (z) {
 		pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
-		return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+		return qos_policer_conf_set(ocelot, pol_ix, &pp);
 	}
 
 	return 0;
-- 
2.25.1

