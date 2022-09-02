Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DAB5ABA67
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiIBV5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiIBV5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:57:23 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2054.outbound.protection.outlook.com [40.107.249.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310F0F54B6;
        Fri,  2 Sep 2022 14:57:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcXxsti46/d2pz+eAOpVTnVpsDTt1HzGvagnm5+tESpMb1N/vhWDCvwnoouUPpzVYpRm+ittPO3JgL32hTodG7gJ0YAbVan2aKo/3YvCjliY75zBYsEFz5Iiv3tYNf5Kjwj9CazJMLDI7qwHeQl4Il2CrJJv0+p1pCTlWj71hdorYWlkFPmwWU97wg4XTGLHzp6wHAUZy3DqsTRHiFf0+uRLCRu3cIqOBFc0rf6AMqdloBbFZNRn9qeuJBbTlkDeh4Il5jCrGBFz3KM3BISNaMyCAWzEG+lr8NjNwxUZXK9TDU0FUxpbo7ffDBttAInSIibiNEeKIdGL1VQHErojPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2IiMMu0q3PevM76SqvW3WwLO0bAufGDClB2DAycvgc=;
 b=Yp4+k5NO5bjJ+98gNynUJQaoJ0DBlfXXWLlV5IUkoCTdWKr+E0mCnz8BbcOvLPcaFtnyP4xjXL6TtG7lqpVffNTkpzbsGWdk+LEE4soBkrYvrW/eLCzj9TDLGuEBS0TQ6ChLLLNl9u815XC7v/m8OGwicB3Pysr+Ch7MkmuXqZCH4niFXagtNXVid1mP15sDkZ9ljsaQ4rDo/p7xjp9Y7uMHq18UXrn2tb72MNQnanpUNJA3Gom7826FubbUE972iCMtyH5lZkIEXp0y14ukG1uJfTduLDxbRCNVXhmx/gEi45JX8ePH89imPaHi4QTNuFnAVFuK0li6IjX1zQP4Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2IiMMu0q3PevM76SqvW3WwLO0bAufGDClB2DAycvgc=;
 b=rxrA6YPO70MFp1U7okfurh89959ODEzKKkVmiu0IOv6Fs/NDI8V/yePQfLRRTtu3XoLbn/YYc0nb7lExsGiJXZ+VYbhU691QeotvQPYzejUgx/ZQHJzDBpjeA5OOd+HiO7P599N4K6ZEm8W09EeKayxP+XhFmFibrNFMj0zPYGM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4576.eurprd04.prod.outlook.com (2603:10a6:803:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Fri, 2 Sep
 2022 21:57:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 21:57:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
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
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/3] net: dsa: felix: disable cut-through forwarding for frames oversized for tc-taprio
Date:   Sat,  3 Sep 2022 00:57:01 +0300
Message-Id: <20220902215702.3895073-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220902215702.3895073-1-vladimir.oltean@nxp.com>
References: <20220902215702.3895073-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ac5cd55-c403-4fbf-d78c-08da8d2e19b8
X-MS-TrafficTypeDiagnostic: VI1PR04MB4576:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U8DHrmcKsiqCCw+M3VgdyTZVNv9n2CkRepiBVej47iQdjoEvpPeqk5Q1S+4uXH0e3HP8FCYU7p9bKMPeCWqh4XyAJlKCfdR6ZH1lrAgi83SohXitJu4NV/sabhfxjo0f0KIQVh3c6TGZr5RInlltGE5rucpn3DAnVBTwg45EKNXZOmoguAeLLk/GyVe5z89zirpkaFgw8qnEXEAD9TbDxbkARidLnYJF75LcqfKN0XGWJr0Le23mBS+7JPAOGFro8n+8PMasUDIVLrZewe1BJufY+9kFPMUqDq+L1ZzU8MLHL3gWP0njVYjwEJ6/ARgt/SNaI3JhqL7YZkPOkfPKNyo49RMO7u9vfd8CxQqMUH3x2LbI+XfCR1qk51ZI46QY+c/BGhPJeEGMjcZDlt77XHCs9v3CU/YyV80ra1RZu4RJz9SHe8kuJ3ggeIbGO/z3AHRlEVXIHle3ipEH0tAyQV4Cf1o/MvQ/+NQUjBwUMwwj747oy7bOhoxQi/8Skz8xMmnUpfgYR7e56uH52fd93tbLHw/rmb+pTnUz6cZdRorZ9gYqlPKWAviHrYHrC26s0/xRzKKAYliUWOoDT3qOSAqnzxsKswvYPmnyiUUeOj/QGSOhoua79npGinKc6UAadO6p4TbHxSR0GW0U6wBjOGfC3/Yz4g7AtxyW+wc54FzMWmF3AOOY1yXKJrzjPpvAzUO3IJ51oKZBYOpvX3rqp4ksMGz1NGbgv35l/ZGUpDfsFvNNW88pIMZUZSg6BhseczRKXLHoaIpFa238eMuJJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(6916009)(36756003)(316002)(54906003)(38350700002)(186003)(38100700002)(1076003)(2616005)(86362001)(52116002)(2906002)(83380400001)(41300700001)(66556008)(66946007)(478600001)(4326008)(66476007)(6666004)(8676002)(6486002)(8936002)(7416002)(44832011)(6512007)(6506007)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C+EzAR8M2uNlkytDJKQEAaZMWaqmPDcgStno1tuGUyD9cAUBAtPD0LJqbdiP?=
 =?us-ascii?Q?O4ErGhCYg9o50nbh1uxKxG1aoMYaBAVgaXyBby8v3KzIwPW3w7i2km28eEZU?=
 =?us-ascii?Q?LtXxxnUNVvO+dMgc8Ej9kiNl/XRwQP5Ubrq4A+fuORJympEyCDs/EpFot2PY?=
 =?us-ascii?Q?NXiOVk2fkG5jBvH35zTgi87JpEDV6cM4spCAO6dZrb8VDtPqxJ6xWACZtuVI?=
 =?us-ascii?Q?wLlq6m3DKcTJ0I+ZGXEXsXoXYq3xJK2bMb/kbqkuCKtx/vcVjiQiGS/hTZNn?=
 =?us-ascii?Q?Ky1kosr4OS8gZyOXiZE6QQ21rxjFg5eqSOvs0bzYXPsWwB/m3z7yADDuKsSj?=
 =?us-ascii?Q?urqOmLmf1NgweW+IdMOLbCQb49Q95BEdmwR0pn9mjEGmHLUd8+LfXb33qBcu?=
 =?us-ascii?Q?H+YSyFKISvKoc7j4s31UbpNKgMaNujd2Pt07gyoFQKad0X0IRAaPa2V/irKy?=
 =?us-ascii?Q?ozZAZz41FTUbJuRDYokKZf2RxJnppyQPcZVaF39iB+1/1Gv0nE3E0BmcW72U?=
 =?us-ascii?Q?FPE3YNztqcYLBCL15+75sU2XjEbYEEUfs+swn3kJIIEg4bJYIcOyyO3Yyc8A?=
 =?us-ascii?Q?bYMsIGLZVGqH90ovwukRB4dmb6oR0Et7r9erpvrciM8i9QdyElgTtm5c68Zj?=
 =?us-ascii?Q?E9p8Ewp2cCSxRZ7Ebj6gcMI2OY1rdaKKcy2oMRF9FE7bI+GvfHbwKMPEG926?=
 =?us-ascii?Q?kcUffHCZov9ADY8rtv+C57TWVNxKU8D4Rp03ElrfpDSUmCgtlsSoNBu7m0Li?=
 =?us-ascii?Q?FCpEPqsorrJnBZTK6rTm+K1zwWSOmQQu80+sDFCrFJjPTq3w4tnBHzuy4OgX?=
 =?us-ascii?Q?I8Qd2UUFIxExTRFZbfwqHQonIrkcBKFLSDDgCp04dSZjIW+ofH3hfgowWvcg?=
 =?us-ascii?Q?z1a+7xi9JbNUc3vjLps86SgL36KUIbbaqc30nc9ail8tL6uCjXlxoYLio/kZ?=
 =?us-ascii?Q?++OA8RV2nf+AxaiR8l36Sk6EgQchQAcjDyvNTxUX8aZmCCQtq1xbL7vTiVvF?=
 =?us-ascii?Q?DjuMh1wEDZ520MtwKTasG3SMr9S1a+kOuZI11zhgqFkJq0UO+iuRIbvIlBwt?=
 =?us-ascii?Q?J4dfyFxbP3KJ+M4UuUgqiJOYIV3Qiyavv63EOH/gMU9NR/WMgfJ/TODs/NB1?=
 =?us-ascii?Q?cC0h3Rcf/h3O7+AfdNFhLfhH9Po/LfObjq/wWC2ACCnSYGAgmbCiLMLVmE42?=
 =?us-ascii?Q?+H0080oV8+/t3h3eQYXNVtmqqTKoWaKUVm36T/CE9qGhuNLn7ABAFAp01nwS?=
 =?us-ascii?Q?tlJDF7fDJge2ggJL4t3axE8aHQdaaWxhYVdZxeCrS2MJbkIP/JydP34Na0cL?=
 =?us-ascii?Q?Tkvy0JYP5hT1xzmCElTFSch25qh2Lg0+MGv6H1owGUCPjR66DwHDaXcxMFdy?=
 =?us-ascii?Q?4j08ZKAPrB2GMBllNilGH1qnexoh7yy5XI5XKBygeIK/skyi8wl82cXBgiuP?=
 =?us-ascii?Q?XGb/5lGY1vmqZIgwnaSBhNigZsinw+W3Ro6X1nlsKV5behLUq5E6kqBL3ut0?=
 =?us-ascii?Q?zx1IBHDF7WqwYjuaAbYyVUSjVn4E4N672greecmm7/eEmyhtwkyK4CX/auXk?=
 =?us-ascii?Q?Ktd525NyQLtulmX6EOt3iPT9DdhanwX4LzIJf+JrmGeoF4Nb6ocvFY6JBmdX?=
 =?us-ascii?Q?ww=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac5cd55-c403-4fbf-d78c-08da8d2e19b8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:57:16.7933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mKl7Y+MffZ5LdP59avEZpmI17x54Cpbx/nyBj3sbWrVM+LCzq0WZSyfkdmb6txtd18RXLM0bxtuvDEoWozqxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4576
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Experimentally, it looks like when QSYS_QMAXSDU_CFG_7 is set to 605,
frames even way larger than 601 octets are transmitted even though these
should be considered as oversized, according to the documentation, and
dropped.

Since oversized frame dropping depends on frame size, which is only
known at the EOF stage, and therefore not at SOF when cut-through
forwarding begins, it means that the switch cannot take QSYS_QMAXSDU_CFG_*
into consideration for traffic classes that are cut-through.

Since cut-through forwarding has no UAPI to control it, and the driver
enables it based on the mantra "if we can, then why not", the strategy
is to alter vsc9959_cut_through_fwd() to take into consideration which
tc's have oversize frame dropping enabled, and disable cut-through for
them. Then, from vsc9959_tas_guard_bands_update(), we re-trigger the
cut-through determination process.

There are 2 strategies for vsc9959_cut_through_fwd() to determine
whether a tc has oversized dropping enabled or not. One is to keep a bit
mask of traffic classes per port, and the other is to read back from the
hardware registers (a non-zero value of QSYS_QMAXSDU_CFG_* means the
feature is enabled). We choose reading back from registers, because
struct ocelot_port is shared with drivers (ocelot, seville) that don't
support either cut-through nor tc-taprio, and we don't have a felix
specific extension of struct ocelot_port. Furthermore, reading registers
from the Felix hardware is quite cheap, since they are memory-mapped.

Fixes: 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 122 ++++++++++++++++---------
 1 file changed, 79 insertions(+), 43 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 6fa4e0161b34..35ce08b485f3 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1539,6 +1539,65 @@ static void vsc9959_tas_min_gate_lengths(struct tc_taprio_qopt_offload *taprio,
 			min_gate_len[tc] = 0;
 }
 
+/* ocelot_write_rix is a macro that concatenates QSYS_MAXSDU_CFG_* with _RSZ,
+ * so we need to spell out the register access to each traffic class in helper
+ * functions, to simplify callers
+ */
+static void vsc9959_port_qmaxsdu_set(struct ocelot *ocelot, int port, int tc,
+				     u32 max_sdu)
+{
+	switch (tc) {
+	case 0:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_0,
+				 port);
+		break;
+	case 1:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_1,
+				 port);
+		break;
+	case 2:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_2,
+				 port);
+		break;
+	case 3:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_3,
+				 port);
+		break;
+	case 4:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_4,
+				 port);
+		break;
+	case 5:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_5,
+				 port);
+		break;
+	case 6:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_6,
+				 port);
+		break;
+	case 7:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_7,
+				 port);
+		break;
+	}
+}
+
+static u32 vsc9959_port_qmaxsdu_get(struct ocelot *ocelot, int port, int tc)
+{
+	switch (tc) {
+	case 0: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_0, port);
+	case 1: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_1, port);
+	case 2: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_2, port);
+	case 3: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_3, port);
+	case 4: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_4, port);
+	case 5: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_5, port);
+	case 6: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_6, port);
+	case 7: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_7, port);
+	default:
+		return 0;
+	}
+}
+
 /* Update QSYS_PORT_MAX_SDU to make sure the static guard bands added by the
  * switch (see the ALWAYS_GUARD_BAND_SCH_Q comment) are correct at all MTU
  * values (the default value is 1518). Also, for traffic class windows smaller
@@ -1595,6 +1654,8 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 
 	vsc9959_tas_min_gate_lengths(ocelot_port->taprio, min_gate_len);
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
 		u32 max_sdu;
 
@@ -1646,47 +1707,14 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 				 max_sdu);
 		}
 
-		/* ocelot_write_rix is a macro that concatenates
-		 * QSYS_MAXSDU_CFG_* with _RSZ, so we need to spell out
-		 * the writes to each traffic class
-		 */
-		switch (tc) {
-		case 0:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_0,
-					 port);
-			break;
-		case 1:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_1,
-					 port);
-			break;
-		case 2:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_2,
-					 port);
-			break;
-		case 3:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_3,
-					 port);
-			break;
-		case 4:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_4,
-					 port);
-			break;
-		case 5:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_5,
-					 port);
-			break;
-		case 6:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_6,
-					 port);
-			break;
-		case 7:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_7,
-					 port);
-			break;
-		}
+		vsc9959_port_qmaxsdu_set(ocelot, port, tc, max_sdu);
 	}
 
 	ocelot_write_rix(ocelot, maxlen, QSYS_PORT_MAX_SDU, port);
+
+	ocelot->ops->cut_through_fwd(ocelot);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 
 static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
@@ -2779,7 +2807,7 @@ static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_switch *ds = felix->ds;
-	int port, other_port;
+	int tc, port, other_port;
 
 	lockdep_assert_held(&ocelot->fwd_domain_lock);
 
@@ -2823,19 +2851,27 @@ static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
 				min_speed = other_ocelot_port->speed;
 		}
 
-		/* Enable cut-through forwarding for all traffic classes. */
-		if (ocelot_port->speed == min_speed)
+		/* Enable cut-through forwarding for all traffic classes that
+		 * don't have oversized dropping enabled, since this check is
+		 * bypassed in cut-through mode.
+		 */
+		if (ocelot_port->speed == min_speed) {
 			val = GENMASK(7, 0);
 
+			for (tc = 0; tc < OCELOT_NUM_TC; tc++)
+				if (vsc9959_port_qmaxsdu_get(ocelot, port, tc))
+					val &= ~BIT(tc);
+		}
+
 set:
 		tmp = ocelot_read_rix(ocelot, ANA_CUT_THRU_CFG, port);
 		if (tmp == val)
 			continue;
 
 		dev_dbg(ocelot->dev,
-			"port %d fwd mask 0x%lx speed %d min_speed %d, %s cut-through forwarding\n",
+			"port %d fwd mask 0x%lx speed %d min_speed %d, %s cut-through forwarding on TC mask 0x%x\n",
 			port, mask, ocelot_port->speed, min_speed,
-			val ? "enabling" : "disabling");
+			val ? "enabling" : "disabling", val);
 
 		ocelot_write_rix(ocelot, val, ANA_CUT_THRU_CFG, port);
 	}
-- 
2.34.1

