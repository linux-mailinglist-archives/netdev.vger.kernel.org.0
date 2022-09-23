Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EB25E7FE0
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiIWQeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiIWQdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:45 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60063.outbound.protection.outlook.com [40.107.6.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F4E13EEA1;
        Fri, 23 Sep 2022 09:33:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMdaLGaDiaMSfSb65sTDz7TQFCNDCoECtihfGmQ4GXMwfimlJQLU7Nnp5l431We2WR9p+F5nvIFG4qt/lrIM15kckgSxhLMb1if5OPfuQU88Pz56p4Tw4XbR3eyhCH35X3Yz6O2C8eD5ODWf5NunvlgpteN5s6sZyjmN3pEjdM1/umD4wbw0JIcak2OWKX55MxXnEdmhZeS9RXVqlsXXhB6M+oxTdZWRUb9jBVAteJypbTk7sw2J62yHVzVxwcvNk7KX4FOkYIJutk8Wp8+KZ+u7e0kJ95msgdWWb5HIk15KYaWYtCQti3TCNjS6iv/yuWcNLiWqHpXe+yqgIKjeFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/qImceEIMGRiCdK0XIGBs64uLrjRqXhcGrYsZfii1U=;
 b=d5EINESXeSKWSJ/31VnkNOBpOPq7+fG/udKES6LDPilT/PbloX3nzvS/OwButUuAdTkA2muCUsXgPDVR4MXv43wzXQsNTXWsWMRoIDgkJwfHrJEf/Owdn6bVv3qAeF1qVP59Q2LVu0Qni+rBmbPuqdKJEAHSFblUK0zm7nzk4PpU7qj+vHSFFHbkc/OTFti7MXqmIbeChCKL08ldAVRXnHnoQZ/d4FEFTti10oXMG0mu/zIsWpZIARiysH9AvMjZI5zTqHK1UwXYywEkJEdCX4KPngQGyDGZt+ivpT3HX/L2+u5cheBsqLCp/XnwIV56OVRYnAMu2G3Cj4ZyVxpWww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/qImceEIMGRiCdK0XIGBs64uLrjRqXhcGrYsZfii1U=;
 b=sTDeD7Cl/M9oc65PMcl+/i8DCK8Bs1+bF4MSDmnE99m0DZxetOTVxMWUnD4Yj49+jME9gqOKgMlALGDRJzE5JMNxih/aN4is+yqTEojvTUyuHfMft7boFZDF83EYTgbtCLG5Q+Er2a84tU9ceR4p5QWXmWH1PMlNCIf9B1zB3y4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:39 +0000
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
Subject: [PATCH v2 net-next 06/12] net: lan966x: deny tc-taprio changes to per-tc max SDU
Date:   Fri, 23 Sep 2022 19:33:04 +0300
Message-Id: <20220923163310.3192733-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: f3543c90-68b6-4cd0-7816-08da9d815ef7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZ9VgFzqqptC8sP0vgaMj7k0bl9PtVqAW2ROWzEK5OrbobqHtZ/cgij+abCQ7xcr2hp1igS+o6e/6qsvbTl17aL1uaKc45uJCoNhmhTi2LBUMBh2M0K7U/bc6il2R6i5INcNCloLH7z0j85cQJenkH8l+RH59B6FCwXQG5fujaru0uNYggNZBoIr8FxUyUdudSvckj6+NntdslNwV3Uv2jpTRrp1mwjncL6BYhvHx3/yrR4q3dABW9Xnimy0UPjp+T0/fZ+dm7UxVLEP7Bhl9jQ7TWneSRpZvEci0xqEvO44iudL8i0GShzN3eRytugj/9D8ciXHYCmYy6umY6nxrpECRyvOG4BwcWxvYi6XN+eVYKR2CUBD5OUtgfsY7MRoOHMRaOiHDNkNP1l1ZwVYv+iOa5S4er5I+xmzXFEx26pYgTZ4AVxj/NU8rcQp1hHZbFJ5Vkvntq5BC8qkVnJxCyroHY8HVQ4oWkA5MwNiR8ama+2D/cI8RYffLD8ZwuYAb4HR6LR7IKqfE+XvFZxUmPrrhXhiSpwJTnnPG+yg4m0BtT4XmLqfkWaW8K9eh1pvxvg1x+5D65KP6U4TLWtba0e5YqizKDRoqzOeAn7zZMyXI4y0RRYjrQ5yIItRK0l4e+XUXoEHP3kdxuS4yBy8coEcWDf6epXtC8E17Fd8/fLVaFle7KeoRTu+jsife04y49lDmcbbhtwK90Z5se21OIjD3XsAxT4j8tEryEYcjWiG+myRYiLQDM/vJbXqsm63t5vuSnFzJAkMKY+5UkTiSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(86362001)(52116002)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v6HeFBEM2bwoSoj0j3Ljkyi83g1DTORueW4QSyE4LSxno7bCCFFapvAEXcUq?=
 =?us-ascii?Q?YdzWrJSRJ6lxTWLL46ONeuuC/3dZjLAzaS3UehWAJnqePDcpLY9ygwamPBBO?=
 =?us-ascii?Q?54HvcB3ospB0B8aUBD8fLbbl/tN0QSXnyjJI5gbUROKEC+Y7YxjJds5DNhay?=
 =?us-ascii?Q?7c0u3Z/E+AVQDEPAo0odwndWZP2Er5fpry4IYN1WgKUT+SMxo1BR0QGSnkh9?=
 =?us-ascii?Q?wNxaBQ3nPvapSF71VuunScauFd2JkQo+Dfh+j0laoTwlhNFUJZYXP+ejXSAv?=
 =?us-ascii?Q?L5lE+G5NtqqKklT931gM3ZJ/5UGDrRZpi2IR4hNauA99YaggsY/+dMUhx9/i?=
 =?us-ascii?Q?PrR8gnZgByCfzyhjpPQGeFR6TbbJ0p3Z//NTD8GIMnCLjOagqsdR4Zua4cKU?=
 =?us-ascii?Q?xMQMZhz/CuRnlR3CgGDpSCuIcOTTnnHQsQB6bpCRoucyYRK8Blcrec7Szrtt?=
 =?us-ascii?Q?kFYurpVWRzhlMNsZjFlGRc7sSPWXuptUtaTTlps4T484TkVDFD6uRf7CLlXt?=
 =?us-ascii?Q?BuvyZ+j/E+BLfr0QpI8UhMhi781DR2RAsPpyCEw+IpsmGiny61Q54eRklM5s?=
 =?us-ascii?Q?/4//k0PGX9Jr3adwmhbHIitclQe1KKfMdH9k1ajbMWK0S7PMka0idtQ50YIv?=
 =?us-ascii?Q?QzEwpPMj9nG0r1Zi7jxPTmDrYnQskwITvu4TuKUM4H4aLKP3IXPzbRSKBxBO?=
 =?us-ascii?Q?oZ3iIU8Z8MbyxKdfzZW5g8c4G6ltIKhKTNdTiKL6sU2/Ud2JwlNbHK2gYrsL?=
 =?us-ascii?Q?Js3JV4LIKrV3qnbLC7zKPRgYKqtdfBPrHawVWQH0L+6o1C5lpK6HXvWsC5ut?=
 =?us-ascii?Q?wrPdnax/CH0BzikAEwP4wlMuVAuzHBo9dsNoAFbMLNjQVU5xHl5ubAGQ7xq6?=
 =?us-ascii?Q?PnGJfIERO0mZrsqeeNFrFuZ2YROthYHDIi7V8gZ0L9t/I9PFpoQ1CYUH1pQd?=
 =?us-ascii?Q?0yv/b5/1RHblMz3fXPDJRR6ECRftli3u8iauJAjysQLgjZFq1sASjRyGcIUH?=
 =?us-ascii?Q?yT0iNPFp/j+4hfXo+VTziD1R6cs9H4XMMrPJFjrsithypdHdwk1n5ZGXiCFB?=
 =?us-ascii?Q?QlzK9xUyTY0VHiNL14X9YdVjMn6BP9HiPA/876hSvLePARYXAax4Tt0hwRIO?=
 =?us-ascii?Q?1vS2c4HK8QZYKsWCIOsMFUI95Baie4kVHgCNAwnlYlKhxDYk9ZRsC0rj3XUB?=
 =?us-ascii?Q?7byWMseSLKlkLTXbQ1ishmxprUxhhVy3ecbw/i9xF0+JdUuvsepYunlMJjTr?=
 =?us-ascii?Q?fSEDaJQ77ZO7NjSbHoZT63UCQkYANwD15sLRVtgnbdKIMA7nzn5+yxtCMwM5?=
 =?us-ascii?Q?F7h/CcPcZRabqX6LYv+dLgKq17Qw051w2MzzAbqr6/jW6wLWWkh3Ho4ijC9/?=
 =?us-ascii?Q?fVXgA9UBtKTOBEYL3gXzuqmTfHcOf9/zzFqE2mEKvAq9Jxbjaf88SxO8+6lN?=
 =?us-ascii?Q?7nlz4TK49Olui2ZCgc6dH10nSVHrQw2bxtYoP92Mu1JEKg/lqnwSWTBpK9PC?=
 =?us-ascii?Q?UGuG/hpvW5SGWWvsAbW3/WWbMPwCe2Y9N47A+POm5CH7KR9zmRgpU0curYAn?=
 =?us-ascii?Q?eJXKikXrmseFryz5W6z4+yBTAah1ApIHkqVoxMrH3cSqM28oiXoy3gwp05FI?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3543c90-68b6-4cd0-7816-08da9d815ef7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:39.7683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jsp/t3xVyzCCvC/HuDWMQcy1d/FLZSiIJ2ztq5n1tX3iBqI1uOeIZZnHBmqsWfWbDR14ijz/TdMtn0XV3ksIfA==
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

Since the driver does not act upon the max_sdu argument, deny any other
values except the default all-zeroes, which means that all traffic
classes should use the same MTU as the port itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/ethernet/microchip/lan966x/lan966x_taprio.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_taprio.c b/drivers/net/ethernet/microchip/lan966x/lan966x_taprio.c
index 3f5b212066c5..96367819ff96 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_taprio.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_taprio.c
@@ -219,8 +219,16 @@ static int lan966x_taprio_find_list(struct lan966x_port *port,
 static int lan966x_taprio_check(struct tc_taprio_qopt_offload *qopt)
 {
 	u64 total_time = 0;
+	int tc;
 	u32 i;
 
+	/* Offloading queueMaxSDU is not supported at the moment,
+	 * only accept the default port MTU
+	 */
+	for (tc = 0; tc < 8; tc++)
+		if (qopt->max_sdu[tc])
+			return -EOPNOTSUPP;
+
 	/* This is not supported by th HW */
 	if (qopt->cycle_time_extension)
 		return -EOPNOTSUPP;
-- 
2.34.1

