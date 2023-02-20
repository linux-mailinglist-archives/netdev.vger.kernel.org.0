Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824BA69CADE
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbjBTM0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbjBTM0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:26:21 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2071.outbound.protection.outlook.com [40.107.15.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61371C7F5;
        Mon, 20 Feb 2023 04:25:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGyvwRQSshBftf26arAZ5LCEKhAnflHthqKv80MSCsdZc6IJAwKycDZaHFhpPC6zWfMbMhgJRHGVhzOSVKCj5ITzwzV1/yE7fbvDdGhIcM4KDG+GuDDH5n7vhdTj5SLM2x+7gL5LrZ1L8ihS+UT6oTzQXJ/qtRvEjpJLJm/zq6aLu6ttMyEosUaRRRcPCNDRNY/ie6Frjc12eOy2XLiM1pxj1aozJVjPFMfE+1qLtrByndUUa9idR6kxaSxKeoMWknLDMN8iuuacM3rZKTcfsHcavJWjrxinjI+Bc3ZUFSRQposGTfMccs+0F3QOB2uFarIE7eDj56IY7k7dEXkFWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKvejzi45NCPS+k3v7NmJ2nLVbtdy2DS1s3Bg0kzn9k=;
 b=nOr4xjohzoxhEaM3wXqYU5weMYiYEYtt2VbnmQUMVQjUoTJP8NwXJsLSAwRobBn9i1vxKtLM8szJnZNfkfoLJ+wMmbnPhxmy5ym++siGRAFxGh8kn/Sh3NgO4FAtAXuwo0+InoWLhPSUKGOBTMNGemnJe2mh5e2p64x3diS+w2RxuHicFFfrzyQ5m/dvPZZPWZflHKvrFYrD/VS99svxkfkOgGwqGQY8vXPKfFKaxS+an1TA2wKGeO2pCaHuVvo4v7lssKCAthMlSo03/boGGvbY3oF8Loy+w3QAcC8yFnkTOcAcsj1nh4a90sJ+ig7uTZKz+GnO0oMdbEb+b1sY0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKvejzi45NCPS+k3v7NmJ2nLVbtdy2DS1s3Bg0kzn9k=;
 b=rDTxC67bByUBHpixS1RdvqBpQKCa4SHRa0X/kj4fqqKHv6nE1b76fm61mKmZOI14wh2M1wUYxP1fQOpN87M55kUzfNG8cLwYbNakvZijrmmBBgvW6jWNCBhnV6SDWF68sdTVVcatt1luyzxqS5NA0OyIdoIl8uAyTpU8rvYdD1g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:24:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:24:22 +0000
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
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v3 net-next 11/13] net: dsa: felix: act upon the mqprio qopt in taprio offload
Date:   Mon, 20 Feb 2023 14:23:41 +0200
Message-Id: <20230220122343.1156614-12-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: aaae7c8e-bd60-4915-5aeb-08db133d659d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LDW6SBO4R/Kygz9kpEAG3KaXM15YwtSdP6iJtDjXCAwsCG4++Ge0/MPk4kTDVQbpWpxC5VOnR/oJZ7J7UzyFwEy2Qy6Nhoj5JVnqSRjf1cxN5ppHpfBjtsfqxPqKxWmpQ9fsSuMe+482ECeXcHNV2LzBfbcrot/mGKRvr6QOa/mv9W/qvWWTDRlV/FrbLeNPs9yJS9RWqf9mHeiwv4CGZKP7UAbf66lv0O3WyvUiA3VKrpBMymRK8teKfCzt/2IX6n5a/DJUXWsZPoBqXUfnIvP6Kgf+yZpm6RyKWdGBirUJb70L8faDwGJHnevYLaRRyj6myqJybqrKB3eY/RscnKpyneGaTyED1T3YbZzfAH+d6F/OraYDYOAYff2611nuDTjyxWsgVQPpUnWWpN1xXk1dc7qmu+cGmPTD+76zFNMBKmmYJGk5nJaYwKsJnloi4hVUv275w0ymTfwcCZCnFiBr7a+X6uUgPKRxql52Fl8YaXs/2hNtj0m7OUytDWFWujCyN+G5Cfe20S+gQvymkHk1/Fd1AHlOMZK5nc4ovhPAsvB90CjyPGPPXKFzdHC141Nz+X6Kf40mDcSeRA4T2gkcrsdsGHBPqc+x9XR0oWQoEsA7B9yGTif5f/K2afHMrLWwrKfqrr06DlELGxyoM5yUipmPPsHraqgtB/QSU8SvuUezFAh5LTA5CqooLmcvNRQz7wgJxOL7cDopdwsX+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IYMpHMq+ZePdPm286/QghewWW2csSqBipGQrUXYXYaBcDVSA215HYLay0gxW?=
 =?us-ascii?Q?59hN5ZXUCNxXOFV42yoWuDoX6viwyO/S1ueH7k2jOgbEPa3wtxbAJwjwY5LF?=
 =?us-ascii?Q?FmpHg23e8A9furnPEiddWbVouUWA5rdDoLUUnCTr0eYwjepFtwBSbHypYlTn?=
 =?us-ascii?Q?V+eGmmafW0p5HKoZ1ZnwgKbV5EcOw9w2j/5cY9fZWtiBW4imVOtsRttbx+DT?=
 =?us-ascii?Q?IWe0sKWz4jAbLqoeNwWPSOnosnNw0vuJ79US6x1wG2o5wJ0F71bYDM2MqHK0?=
 =?us-ascii?Q?i0e5uSX05l9ddeee90IqEaF04s6FFlz/fRLJUb0IFy7Y/WA48j3uBbflXJsf?=
 =?us-ascii?Q?qlq4bMzQ5gb08ZlePNP1LCBI++5y8dbUXmZPU3OMtZunTqke21ctXmNgmcsj?=
 =?us-ascii?Q?BdcBtToP0ShuqRMYcM1zVkOJGagwjfXg6sXOCAjC+JYuhHnJDBwECycRIrLC?=
 =?us-ascii?Q?36VfmIBYGiQR/SKcb7aphD8qAuT4taWTSqxLpwJCEWmoyJ8rzkdAtSiJiIZ2?=
 =?us-ascii?Q?Te0I2lVwKw8k6sFFOCtg4v2GMGmgwt5MCO5yxGaRpmycTAI0+2iPsD1kQwWS?=
 =?us-ascii?Q?9GuY/oWSKROfOkuK0/3S9ap2zwa/TlYvYf9cALicyQT8oxVZvHWywGmZCO7w?=
 =?us-ascii?Q?tJEZYfiWfQJrEjWQlR8oCXCeuQh6R/7396/HLCXrr4JEKE0z1ELWqIHz+McP?=
 =?us-ascii?Q?boyJNazS5BcBqh4zMpSS/0bHPd2LjEbIE6SkNHf1d7uKinditWtX+UyNvr1K?=
 =?us-ascii?Q?vRv1I1QLCB7NBfTVQnpIKuL69dJuEp6r+OlesgP2BjDdpO8eF0ozcbNHIs6Q?=
 =?us-ascii?Q?S8/oHfU4CzKPU/9uwnlarHX1zZsV+XT8ILhmpPqZ25uSdXydoW1kPJx+sxOA?=
 =?us-ascii?Q?ePSiaplklj0C/EFIy3Uq17webFIoDIlITqo3oKhcj8FLx806gke9EQuDUNde?=
 =?us-ascii?Q?lb9mBEzmWvJtUU3EAevsa/NDezLn1h0kcZOt6UqIDG9CoHmGoRa1zcVdLdu7?=
 =?us-ascii?Q?hw5SuT4w/Vj7ZKG0RWHWfa5OzwOp29AFpYl+wQmNRDw9JPzxwlmj5Tb/qTI5?=
 =?us-ascii?Q?NK14P2AMWLS+WX/Q/IRiOHhaEKU+z4W7nfQhL18hdzQ2nP575ZzZ8H/uKqSY?=
 =?us-ascii?Q?i20llA52UqcqkDk8rYWpKCu9r41YT1OoOfmf9fObdAis3Lrrc6NV4bnZj1fD?=
 =?us-ascii?Q?RVJm5gzGXkhSOdXUWJedMtEWuljHGUVrRIIpcj/9jQYAJhf1ZvQilNQuGcJP?=
 =?us-ascii?Q?3XaGzkign1tRXEC7krdwmjT2Y0fMIwphJOL9LKSBpuYOr3ESjirtueh3Tv9I?=
 =?us-ascii?Q?qRcVv4VaVLzfaICEx2WVhbMWjcZ7wFAzBNeFciItY76sDXd74dygxCdPVMqf?=
 =?us-ascii?Q?4ef3zJ+BT0GvCJyMQnJGInY6iN1uuT3xR3d3Nzd95b0uXtlb7HJ4V0rbGkdN?=
 =?us-ascii?Q?FogxnPZIpL5rN+SmynrRzwKGFDXgmW49O+BKBV1FV8lRBLaSKc62WJnl+JFh?=
 =?us-ascii?Q?8dyNrjVDMMqdhuEBOez7bj8BHmnDkP0nZjUQPNwfw6k3I1ujj2cVUYLZyU5l?=
 =?us-ascii?Q?MyP2zPq0M5dQG6ans7uY6ZzJXmfpBOriirKtRZQkPNcRnocbLNHpC2/sJUnL?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaae7c8e-bd60-4915-5aeb-08db133d659d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:24:22.4301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IBQIkzPYnVCjfFHDr+Bk9++OzqDxn5pazPWt4zn3YHVN6McZXbm7MMVBRlngx0vcHbjcUUYYkOG7cmRsWSAkeQ==
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

The mqprio queue configuration can appear either through
TC_SETUP_QDISC_MQPRIO or through TC_SETUP_QDISC_TAPRIO. Make sure both
are treated in the same way.

Code does nothing new for now (except for rejecting multiple TXQs per
TC, which is a useless concept with DSA switches).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
---
v2->v3: slightly reword commit message
v1->v2: none

 drivers/net/dsa/ocelot/felix_vsc9959.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 3df71444dde1..81fcdccacd8b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1424,6 +1424,7 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	mutex_lock(&ocelot->tas_lock);
 
 	if (!taprio->enable) {
+		ocelot_port_mqprio(ocelot, port, &taprio->mqprio);
 		ocelot_rmw_rix(ocelot, 0, QSYS_TAG_CONFIG_ENABLE,
 			       QSYS_TAG_CONFIG, port);
 
@@ -1436,15 +1437,19 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		return 0;
 	}
 
+	ret = ocelot_port_mqprio(ocelot, port, &taprio->mqprio);
+	if (ret)
+		goto err_unlock;
+
 	if (taprio->cycle_time > NSEC_PER_SEC ||
 	    taprio->cycle_time_extension >= NSEC_PER_SEC) {
 		ret = -EINVAL;
-		goto err;
+		goto err_reset_tc;
 	}
 
 	if (taprio->num_entries > VSC9959_TAS_GCL_ENTRY_MAX) {
 		ret = -ERANGE;
-		goto err;
+		goto err_reset_tc;
 	}
 
 	/* Enable guard band. The switch will schedule frames without taking
@@ -1468,7 +1473,7 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	val = ocelot_read(ocelot, QSYS_PARAM_STATUS_REG_8);
 	if (val & QSYS_PARAM_STATUS_REG_8_CONFIG_PENDING) {
 		ret = -EBUSY;
-		goto err;
+		goto err_reset_tc;
 	}
 
 	ocelot_rmw_rix(ocelot,
@@ -1503,12 +1508,19 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 				 !(val & QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE),
 				 10, 100000);
 	if (ret)
-		goto err;
+		goto err_reset_tc;
 
 	ocelot_port->taprio = taprio_offload_get(taprio);
 	vsc9959_tas_guard_bands_update(ocelot, port);
 
-err:
+	mutex_unlock(&ocelot->tas_lock);
+
+	return 0;
+
+err_reset_tc:
+	taprio->mqprio.qopt.num_tc = 0;
+	ocelot_port_mqprio(ocelot, port, &taprio->mqprio);
+err_unlock:
 	mutex_unlock(&ocelot->tas_lock);
 
 	return ret;
-- 
2.34.1

