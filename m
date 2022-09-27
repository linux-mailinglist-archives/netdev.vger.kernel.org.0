Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBFE5ED13B
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 01:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiI0Xsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 19:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiI0XsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 19:48:12 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D591BF0D8;
        Tue, 27 Sep 2022 16:48:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORHTHFMK0Bjaq2JQeOIJdl0qTDts0/m7QhDGNVwFu35fbr3No1lROlxSw1Nv3vld94ZDxBOXAufzYwX0RkO/syFFvcUKUp13KlbndFfylfTDnqIdvAIwTKtqJoS01eWsw/dZSgSeijCD1I67NvByN2PHWN8no1cBHjCYqcAgNXt1utPClB3zKbCgNFuqMbGN5XWM0uspdGItbut6B4LZ5kcj2qQ8LjoeG0dzOkl75eTHRwQ5mgRdZsqfFA9ehQNMfd2lrofwkW7DQD62kEEYBB2St4ZUVayjp/2ak1vB5Pe7aYMsdHC9NWhsEcsyrfzO/RA8StMTQi+bF7eCKiPGLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODzc0lOKjPqguIXqdN9ULcmc5qbmmPPIdBuOdqYOwwQ=;
 b=hKR1C3sR4gz/W9D3UJxc0HXSRgbDkQk1vEqz6/s3xbz34TK5oXEiQKhPU1tLHxj/gFJ02gfLqlZTMhfk1DLz7kG7TvnuALK/o4vDX/SuQvrO6sbuZ41fY7aIcuTybd7XFJCYOBHt48h8tOAZgnmgYgxisUSIK9Dl201Wj95qFRCYB2nGygHVvy6uKmzJyX+okd+UvOnrTQ/fliKFaRI/GJuWrHbSVhewXPvyoaotsbqlRBtcIT2NuaqKcsW8lLCQ+mDFiMXsLYVS6RMwCInE6l3ry3J1sSOItfeu3XtIZ4/cHnWzc4uMN913traSeGW+uIKyRr7QrK8RNkJgefKbvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODzc0lOKjPqguIXqdN9ULcmc5qbmmPPIdBuOdqYOwwQ=;
 b=qUTchwjf1myqY9zjy5BPZAhQangz+QgOf8huuC9nAlJbI2z4N7ii0GrEJF9JhDZ8lmyD5vFmVkdBOWyVVNkvtawWWYfkboy0iENBlJZ3k6Y60vksvTn4fwUpfDmXJD7r0OlAr/fHdw7k1z+Ud49gfW5rR5R95cx8jgqPpxKuXUU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9444.eurprd04.prod.outlook.com (2603:10a6:10:35c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Tue, 27 Sep
 2022 23:48:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 23:48:04 +0000
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
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 4/8] net: dsa: hellcreek: refactor hellcreek_port_setup_tc() to use switch/case
Date:   Wed, 28 Sep 2022 02:47:42 +0300
Message-Id: <20220927234746.1823648-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
References: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0025.eurprd05.prod.outlook.com
 (2603:10a6:800:60::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9444:EE_
X-MS-Office365-Filtering-Correlation-Id: c78a1993-5396-4fd5-2ee1-08daa0e2b8af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NYQTijVv6/uhzSgt+r4APvx31W9xFelwIxbqNAR7gM6KSwA55ac1W6liIVk48PPbmmU2qyVQ+eycLzwBkPyHYrPYmjOVnemAbwL804l8nkMsQ5HkFMxUWdRA+E2PlDbwcVpjPlOA4cALv3Pg0nQ+CF+mBmUDF1S7p1IMYMEgpMchTLCfG0VJViA2goitGudoKMBRCXSRowWYlUkwUfrp2LoG9U8YY51TpaxV7zkIFXSvtASItJSunU8Wo+LcHfMykvAe6Ojv8PwYnD0yex8Hl2jHo5m9G9dgxvNS7P+cCdLSVVBD/FdspqugsbVaLh2s98Ny1F3mdMwzC1I0Q++OlUuLmQdSlbQ8bdyJmnGcWV+NfpY8ZzbC4TwRiRcSW9exW+g5htAHiSTTceqTG0aTSjDEACDhp3ASNmydF+d6q2gIia8uK/KpjJScVJpv7tr/6ky4EIczqpN/1RaFiHQTsb4pWmIcRXusQA2d+TCQRCc0FF6Eu8leHaUmZpCmRkLDiNI5BRVqpU81S2N2dYGo4LozR8YJn+JF2aD8EhT0yncIPx4jGb7EmweRHTYbXJWsGUm9mXzf0cDPk1YOv1ZEjPy9LY8BFwI+qrUo+v2J/gICeHToQZFzaA4OCGvamP7B3lEHR1AHym2xE74QIqmSbp9cddps+85jHEb+mBh3UeUl9n1aiEqggiT4t5FRpe6Olrtssy1APwvRnhSjsC3uY5Kf99FUJFArpYXXplDNw0jB2tBJ4OfTVD/sThTtsViYBb2htKlNMT/cN/URbuTKyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(7416002)(6512007)(41300700001)(6666004)(36756003)(6486002)(38350700002)(6506007)(6916009)(8676002)(86362001)(66476007)(4326008)(26005)(52116002)(8936002)(66946007)(83380400001)(38100700002)(316002)(54906003)(186003)(1076003)(2906002)(5660300002)(66556008)(478600001)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1PcYQF5J7JEpumRhxl74rRWIiR1LlH/4HE5WdOpV8zYk3jD74rrMtMYdE+Ym?=
 =?us-ascii?Q?tgK2c2tBlGLUXML+Mdf2ql8j0exXiI0jk7VVU4wdzhvvR74ecBJ6+jzUcRt3?=
 =?us-ascii?Q?x1hjkAZuhP8gZIMAhcZ+1w+MXewc3OQ00RGWPlKScbClzVaSFdL6I5LuM0+5?=
 =?us-ascii?Q?45EUKgCKJ+WjGIXDzXRWtUaxTwg1AZDlSFTrmkoeDoYffWsa88BrQSi10HTJ?=
 =?us-ascii?Q?iW1wg5KSsVARvIipxuVpk1rDJkujTfHBUamwaAZ9f49iTLxnxuIpoMuErkOB?=
 =?us-ascii?Q?gfS5vweZfaLnQwl4Y4hqn6LesRNyJJqlZq79JRhHiQV8mwVY2jgAbPZiPC1Q?=
 =?us-ascii?Q?onHpxfHEjd1n8Vu5Qs+h3pTPUpUOI8xUNQN8a6l6jUbLkKcH0krWphUPS3VM?=
 =?us-ascii?Q?ieCoOAkw3RBoNwgyOVhejsnvjYNrzsfmhu22KKXSpY73LI3DJsHBvqkfFKiJ?=
 =?us-ascii?Q?RJ4JWdPfGFaygxN6yozHiWuy3g4T5X06fk8VqfmSj2mq0YMP49+bi2mu5/Uj?=
 =?us-ascii?Q?IT3k/Qas839fjLheWezmbFsYTBKwnHHSa9JOR2vEqka7idtKgZsdJioRPe4J?=
 =?us-ascii?Q?a4Ens6yNK5pap+h5mHEY+iqkIb0lRbkGN51Lg1M06+B/MFdNa7YYd05yPxjl?=
 =?us-ascii?Q?PpGq4GZ3tXabPfXizQbutlnIYrCpN4tZwxX5aH4eGVJjaSK/JXBvitg5NKIK?=
 =?us-ascii?Q?+ArjfmN1fyYX5fcOiYz8Mnp+2183vOnuc+1wtt+KE7zfMKP1Z6//DdhQa6qZ?=
 =?us-ascii?Q?frJUxJdtsxmHwlNJx9AAxgdlZZfuXCZiZ8roM5CG1V+ipXR0Q/2wwKcSKUI/?=
 =?us-ascii?Q?ZNN6FKGDg6C5AjQY3q0A1fopCOdVjFP71ityPcrSIOLCmRhA6zU+xLau/08p?=
 =?us-ascii?Q?mhSY7A48+aBy2uorSU7CAmVJaAuOHj7QYs9u6P7Jf4uIAhXsjqiQt3dH4SnD?=
 =?us-ascii?Q?rUryBHABnf+fe3XBn5z/FTPXkEWNrujOj1LDUS2in8Gz1uKDGkTK0LAcdV3V?=
 =?us-ascii?Q?WdJHvyxE8lcsBmrEX4IwCVLD1Ol57wkNPmXk3p0e07n4me4PGrb49bt9Qb0n?=
 =?us-ascii?Q?1sxz788+x+11QBu3npQg9JIWzof5DIayE4+uosqI6AK7Vs9UssJSVfIS3S60?=
 =?us-ascii?Q?KW6pw6fOmxI5AmxatjzbLQLyMHYk6XeJE/de2Tw87kNwG7mQUNVoiYg4OpfQ?=
 =?us-ascii?Q?313GMXpJcrnzxx+t7M0dY4gqBmooFSLTM5qO9/TiNsP6wI/d6KAMlyk2oRYl?=
 =?us-ascii?Q?vbVvhBAJfchyy6i65BC8OjwTu3s92KAqgYNvxbBYeyd0Uwjaxrmv9I2XPNNv?=
 =?us-ascii?Q?0TxUrPWYQe7YvcuuVhdCz+CKZbc7sfn/U53mqOc246YUbKShjJwgsvnBiE6P?=
 =?us-ascii?Q?ThifFbU7wrtM0womRR3tSlpFWuGBhNiaWpu09JLUH1+ui39lD27C2PZPaQxM?=
 =?us-ascii?Q?uQdxQSgxIJTX4fakyWqlNVbtQIauNLwA3z9tyWN24ATmgGRBi6WodMyjRu1X?=
 =?us-ascii?Q?jkqyLFQuDxUb/5DEc7gkEoFrpWTy8UsvQFEGCNUHfJFCDeFKVuyuK2v/fwHR?=
 =?us-ascii?Q?MFlbomWHdhUB6FPn/hYO4YHG6xAIBas0jWHK5Glv4vdvpINbH880hgjQluDF?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c78a1993-5396-4fd5-2ee1-08daa0e2b8af
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 23:48:04.9450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ywIIgIG6JKQ4xwO2JnqmpovU57Kj+E66b+zqO1lVGD0/Y3jl27vj+T/PT03Y3zMWxsM0U5HYHr12dkEfIxeOtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9444
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch will need to make this function also respond to
TC_QUERY_BASE, so make the processing more structured around the
tc_setup_type.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

 drivers/net/dsa/hirschmann/hellcreek.c | 33 +++++++++++++++++++-------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index eac6ace7c5f9..ab830c8ac1b0 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1809,22 +1809,39 @@ static bool hellcreek_validate_schedule(struct hellcreek *hellcreek,
 	return true;
 }
 
+static int hellcreek_tc_query_caps(struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		caps->supports_queue_max_sdu = true;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
 				   enum tc_setup_type type, void *type_data)
 {
-	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct hellcreek *hellcreek = ds->priv;
 
-	if (type != TC_SETUP_QDISC_TAPRIO)
-		return -EOPNOTSUPP;
+	switch (type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_qopt_offload *taprio = type_data;
 
-	if (!hellcreek_validate_schedule(hellcreek, taprio))
-		return -EOPNOTSUPP;
+		if (!hellcreek_validate_schedule(hellcreek, taprio))
+			return -EOPNOTSUPP;
 
-	if (taprio->enable)
-		return hellcreek_port_set_schedule(ds, port, taprio);
+		if (taprio->enable)
+			return hellcreek_port_set_schedule(ds, port, taprio);
 
-	return hellcreek_port_del_schedule(ds, port);
+		return hellcreek_port_del_schedule(ds, port);
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
 }
 
 static const struct dsa_switch_ops hellcreek_ds_ops = {
-- 
2.34.1

