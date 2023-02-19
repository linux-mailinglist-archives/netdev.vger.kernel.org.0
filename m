Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC8A69C072
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjBSNxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjBSNxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:53:45 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2052.outbound.protection.outlook.com [40.107.104.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28A14C14;
        Sun, 19 Feb 2023 05:53:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CabmCGu5yaiRDsGl2gLbdvgHnoaJ0aiBm3ZpZ29HHfzInjbgGz40/OhoNfYyMnUMtdiydjM/OHDjQELR6GYHaZC2pB77oPNi08UFCv+OXpwbVKLWMZVLfS841HkLsNFWAAjnOjkR3dyq2PRrImaT+nlt5X/PWyNpRdEmSeIuUL41J7rjCdAcOSl02QavsIY20hcnc6N+MuHzSLi2QiZcHnZwc9mrRVqTSlRhZeEJD41/PxnGBOCqHuNXS3KEglfv8kIgAPnURy32J0a0DkfZA29FIsx2bKwbtJqJRpIp+mtrinqq9zTOziCYj8wOO6/FEgYPGSdf9cDbnoL9yhzFBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QShS6cOparXs1wiRaUsAwSj4ujBrAQYnKHPoAdZu+Dk=;
 b=U05hpMD7XO6WuLtFQJ53AdUvUK9ByjOVvXv/y7wtuAlDgHlsnwfG4zyEhva7oOgR+9KsOnBtHWtnTD92A/1ff+rhej8aG8AA/V/YalFslVoueWxiN33Ogf3LXTAItKwmF6CJB+33IhvHQOCvXWnmBZG0mnmdVUMZVWC8si6KoyILpXnsL1CPfXesjcvkgBiGy+GHuf2KeYak4x4OjiTNXa+O6UC2YUku32FYkJWvmvuYfSIJgymeiSdEDxxFvcTRjM00I3/QewcSzCYYhAiz3CZFTrMaYn18x6BH/2Gwnx0L6Fl2kGa1zF0gREeW0ewP97HG8eBDr9Xq0O+v5B0gEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QShS6cOparXs1wiRaUsAwSj4ujBrAQYnKHPoAdZu+Dk=;
 b=aKqNoBbq5z7Z9ZzZgn2YXPDUzg9rfT2EsQm8tQWq0URuPPUZJGJEtr+TqOaTcOkJ9lmnl+/MrfNZw5E62rJtPuxNDkpnQ7rO8Tt3hiuVV3ItfNATZimGm4MsadG/EDDfdZwItDXCHfK/UxkMSdDb2voR+It0DvPGLMYLtLws77g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:43 +0000
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
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 03/12] net: dsa: felix: act upon the mqprio qopt in taprio offload
Date:   Sun, 19 Feb 2023 15:52:59 +0200
Message-Id: <20230219135309.594188-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219135309.594188-1-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: 85939bc3-a162-4f9e-8243-08db1280b647
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q29rSgzVDF5AwG19c3sMiOdqPwJ33h7qIJKQGzkyJrjeQEmP/LfC/LPGSoM48H10n43esePBHvATtpRM8j4oPTnpaYOVJVVVPg51ZGM7GxAMptGbS0ljksIgE0zaXBrF8tVqg/Q7rh0VeSE0geymDLkkSPYQ/nHbLihZVS5GCP7D1e8M1ukRBaOA05bT71E6qplahemlj0+DMnSDpfqNAdIF3XFCdq4hAbdBPsnN0wXHgFzHUHvt3NeXCRQYr+qBMWQV4PfQDMyByNqAcJ6632H4RdkDwlog8MKqrZ+rOu3kP2JzLcXennQ7EkpKxrTekF/dPKFJd7oriBwp1Nt0V+DL0iH6qm9h1WqHKfWTZ0yjdMrTo+ywKSEQaym8EJl4plEFOfixIlV5MOegYR3A92fUESPqoOtawSIEtf/kDWb+bt+xe63SdsXMJt6LfuvJ1wgkd+xIkE2e2OxcogVSDBLo2IHdelm7hIBOC1R76UIPLgEXA0uliFcus2B7z3/MzHMqxliSmfqzYlMZBMG4hbLEdovqIu6Ep+FCeBjtEbGB8PO7cn0uJZmjkjZfBKwpW6v+2Or6jwTbku3LZa3qsmowTyiaic+HPEiTnwi+NHr/WMjbNNt93O5j1hDNQPlF593f3zqtOXxE0V/L+bcw/8LKVUk/rOAbDYOqHFXr77BVtRYolyk5TiPwVj6CpNQ8YsdPfEL5bhR3HxWzxivKJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(1076003)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GjAvfgIR1nMBg4ffMkHXGxbdgHBRS3IUixjgturLkmjPoKvNVEw1WIdq57kc?=
 =?us-ascii?Q?kCiaoMneDjjLIO9VXVuPNlGVw5370fYmNIFafznbtlVr9btLdKjGjWDg4v91?=
 =?us-ascii?Q?77H/lAiprQqgVc+ihaZee9NdMiFmuScxnVGXJI+ke9X5Lc0oCVUDzbmL/vDs?=
 =?us-ascii?Q?UV7afx8NlIMYvaofGeBLIMO4qVq4lrJymsYAEi9m0SHwPLqjUy4soYw6sI/2?=
 =?us-ascii?Q?GstCWErmPZkhqkEzEBD/mvDIkpYGJOzHAP5lDDu/oFOZGMN2VWUYcFHR8Nrl?=
 =?us-ascii?Q?56lzcu6RzGK0DHHDlAtdm+iSWjX0JNyiMOxOrOPbn/22IeRsgojDMrF43mVJ?=
 =?us-ascii?Q?OuNDT7pTZ9IoHELum5J50aHfG0/PlSciQR4hBNZHYQVUCA3KmGB9WBn6vFpQ?=
 =?us-ascii?Q?x5UR/92/6V4dxLKkGmxJ1XQz0lXrb1wrB7WAicppzIz60BH5VahQLQMtrJ9K?=
 =?us-ascii?Q?EZz7QIgONl+7cGfUpMssN9fE8t9Zhye5Bv1HTMwmcaNXZLs2Lehn9VGCMkiL?=
 =?us-ascii?Q?D1TZxcaYSF8x5WbhJMgd6hjwx95Nq/thMP5s5yoGUQFrEX+4u2kP3OLp3DGs?=
 =?us-ascii?Q?VFTyLXwK5NJLYh8F1GYNQ5vRyrWXPRmvTDd+a8cNpqhilboLva3giAXGKoWT?=
 =?us-ascii?Q?topJvaAnqFJ8L/ofytI7gGV4GElx9vPdrzN7rbZ9N7A89LHDN035NLKxX4+c?=
 =?us-ascii?Q?Qde7CbYiLVAUiYScCgICFGYKjzvVU30kVaDcLAnwO9mRNj/1RTvNOYEnPTaO?=
 =?us-ascii?Q?iDZsWG1zvJ2iEItN+29WgcVrbS8hR6CdTRNX4lModWC+ewwge+MHz6E05LUM?=
 =?us-ascii?Q?guqTtyfFE+QVj8PxNYQYIk36WuTs00wWnPxkdd6PbZJBUumK1ZCsG3x1xo2H?=
 =?us-ascii?Q?fuXWfwZoMdL30bBdbYwdetZdgBlu+o6vK1X+5tso8Tea6TIjnLl1lzzprXts?=
 =?us-ascii?Q?jZFm77TFQtjKzcEjbaxkwZXJ7I8BG2UnJJAMX9ovYBgU65XOarBidDO6u4+O?=
 =?us-ascii?Q?UiIYKHG/3VJyQigkcw5JsiNfQGKd8UzhPQlV/Fc2HThikxU5O+5V/K7wbnje?=
 =?us-ascii?Q?CwqDztrsiYyBWsXBogKYMf/cQlupuSIzn2sgIg7ab5VRNQEfEAb0GsfShaGb?=
 =?us-ascii?Q?a95WvNrX/Wh2lNO/c9Kd/dtrReKl7uwGyG+YYNHpH1mTNOef/7FkX/AdLnSj?=
 =?us-ascii?Q?T5M73mAUHvFNCT7C3B1IKxcdPoRDNQvyyJCe8m6ohQi+Mea2RX6ydVHNFZ9c?=
 =?us-ascii?Q?IePoJvOVZzcRlb/bZjh0bgfhqEuYc1DJ0giu72rVbwoCGJC/jHAcaoSx+uAT?=
 =?us-ascii?Q?wuxBDWTshNjdczvQ5Bs7eHroqsMtMeSiuX85u/pLhbB35KmK4M0W2hSxkRZK?=
 =?us-ascii?Q?GfCFAXvXzx5gtllY0xT3GsrzeMFehnBReamdcFnWc4hJo5mw5b+cHyWTm8nU?=
 =?us-ascii?Q?7Fj7A5JW3ydxXlDdEkLbUF5jkPtVDsKpVKCH2JoajvrtslnzcEUHg8j1aV5a?=
 =?us-ascii?Q?PjaSJ49jF1CgS3VKGpQnSs4VVOUc6YstKnYql9AElCOnHrVvxpfquVTqehQP?=
 =?us-ascii?Q?PPuMeI8/oklIZmI1FlvYeNXx8bYGUx8z20aelOOb9ZKWO+6hGKgXXeUOJku6?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85939bc3-a162-4f9e-8243-08db1280b647
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:42.9904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DkQ/zt4M6dF0dQYgSVh0pV0dTv7jDxBns3qdKm48RlB1Yu/5sDPP4tRMo6oswf9IzKyLffj50QlfbgV6RREPbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mqprio queue configuration can appear either through
TC_SETUP_QDISC_MQPRIO or through TC_SETUP_QDISC_TAPRIO. Make sure both
are treated in the same way.

Code does nothing new for now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

