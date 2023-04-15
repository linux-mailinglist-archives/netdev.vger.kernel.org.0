Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30496E32BB
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjDORGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjDORGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:06:30 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2051.outbound.protection.outlook.com [40.107.105.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CFF46BC;
        Sat, 15 Apr 2023 10:06:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsihMWmnnZjwJ2Xpre8S/u3a5Cx1b3fhdA3Hawo+kY27fjk1q0dtVB1gGP6NhfqX3JrCWX+XEgg/88ixuCpy/CmK5X1qLS6aTika4rVuYOONRuw0WawgoKdjKp82qHzBNCvjrOYZWvqQ1x/gP+XFuPcdMRB6XpnaZ6gK6eIsEnLi4efAtDdbZJwDaLximnO5uq8TLLMKvQZIGmWcUS6NB7H8cnitXntzckVKqxwBJmz+Ka9gTArOo8ftJBRu0xOcSSSa+r22ELpARwLiCrZtEXg8yeCoze00Nv5KNJ2YCYxXp6a85+LLejICp6GBp6AfeZwBkiBpDqDnGDvnbIp05A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1TIe18DGAVW1oSl4hweCgt6ZFYXuzJddgRPT2/nE8Fw=;
 b=dbErm1HhNOA4NszI1AQLXryiHeFd3KloomTuBoik9Wuv0RqaFXi1tl+Dm8fAbQzDCoABMiSJuanl5EdW8IqC7AIFN/KxlnBPEY21mJaSxW9uZ17X4PiYi81SbjkP5bgT5lgocpjsy1uU+Pz1ytXFn4HmNdutgUU2Of1/n/x0G1J8HWgbU194wdmvEEb6omCYc3g/sGDdqITlxbmFede7KboO/MfDoYYFBxqaddDVtwwGO7N1IopjUN04p+Sj8vq6fs2iXVG4G6nUm4XOxs23l7zRZ4RZzp+tQAaXt7FLogVGChXvO+1/yFpAJvEWk2BuO50Z1GfhNXVZ7anzWlmF8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TIe18DGAVW1oSl4hweCgt6ZFYXuzJddgRPT2/nE8Fw=;
 b=eWStsXaAtKg1II1dFAMdDo4cG6NS2zqVpIfcjPdX2qhWFV2aGYUxYBFBQx2Z11ny6OsiomV1Ld35gAB1me0YO5jNA/pLTO2W4RTGFu1qLzjl6ED0H6SJazZBH27mHtNa6CEpxnbxHBYeBqNgiPvHdMamVxR2snA2bKov4LAhBq4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8158.eurprd04.prod.outlook.com (2603:10a6:102:1c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:06:09 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 17:06:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 6/7] net: dsa: felix: act upon the mqprio qopt in taprio offload
Date:   Sat, 15 Apr 2023 20:05:50 +0300
Message-Id: <20230415170551.3939607-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::6) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e3ff0c3-f056-4d75-2556-08db3dd3b549
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MgblMzVNNuD4gfnltgwY5c4aoxQk8q6GPJ7TlmvkNoIh5+bDwgPtc93jimtcRBjczMSN44lGxpUtvIcJ9l5bftL/wLJt+kX8PWye26IWjduM0BUvxNma9w1HNnlGsnBS4O7tRko96DRMq2PGFH0aVkGMGcCoxKdclrTLmFKGqWb78kT6YBOsviX/8AboIJ4AnxKmOFWOGT4AObeQ5STfrKiOl8cz6Fd45Bzqctwp8cXn6mkoHYFtVCGf+HJ8T+kEctgY6NaSKROAyTzDdhKIEle80YGWrrowV1DqwIwQ9qx5ldZm6nS3Vq5SmMJrMZtTDAUGAtEUv/h2rWqSv+m83pD3aPFXhCR8aj6vVz5eu+lZzKkxtJT0/dCoWFLD5yjAh/f2usHUHv+xpc4eE4nm8UDTgzB2LXsEFSIrgwjGKOiR3e0sIhJB9hr7Pp6VZUiZmyqE+Pw2TLiYT3F0kXrns9/9ga16HVSUmx+qsA9LvxwESnJLJOSWjhSopekrSRrJjV2nCKCzQYeGew9TKM+6ZJfJq+D2amIapY1DGeOnwHAzXfi7CSYbyreQF2W5xX2eW5olzUGMES0zYs6i6MSK1OvwATqnSp9WWZtAuzqDGXs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(316002)(4326008)(38100700002)(38350700002)(6916009)(66556008)(66946007)(66476007)(5660300002)(44832011)(2616005)(6666004)(52116002)(36756003)(86362001)(6486002)(966005)(41300700001)(54906003)(1076003)(186003)(6506007)(26005)(6512007)(2906002)(8676002)(7416002)(8936002)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+md8sdp2tUPUO7YkkNsThEzn+14ar2fnd75L/xr/Kr6DhJO7H2xiENa4Sl9X?=
 =?us-ascii?Q?RDUTXYKMkBYOr69nmQPgK96rI6tE6ix4y8V5AU9LtdzkFlRDS315aCjC9HLO?=
 =?us-ascii?Q?enQE6EMHMTYOoGdpJPFJMCwWKRIoy/kPAa0Ic4Wi6FJCDMYu7fug5fiI0O7P?=
 =?us-ascii?Q?MTBKB4T8TF5JE7vsoqvljbgIbPnMDwmtQUbjanzGznKmPpeOlZiFmaSNCYNx?=
 =?us-ascii?Q?akom17FgVArDNZvSra4LSVtak+uK2Cf9EVxNfd+VwLW5UyuDXsIXvZsi7Ll+?=
 =?us-ascii?Q?TGnuUy79pIPDxUMn44TtzaNyd+7NO7HigDljx/79Omg3jnWwvU4FC/TbUI07?=
 =?us-ascii?Q?pWMC97z2hkOo0khXU9lQrRI13kpUHYlReV/aKswq4JhQy8U0h3DGZcbG75We?=
 =?us-ascii?Q?XaOhSk53Y9ikh9pDu5Jsl/VoGDQ2C0DUL6vwPyt+yjQ63DPCmcnblt9BXjS/?=
 =?us-ascii?Q?OEAbf5DMmDhbug7LBNVfKsEp1OwXWxgoX5RqVO8uS7maFl2xVD2SboSE1CYO?=
 =?us-ascii?Q?Y/48GAI6q2jhtkyUmgl5U4fQbU8m9QexB3lJOzgLe0igZkiWCwWlIgXWCEwF?=
 =?us-ascii?Q?V7Ws2AcTzmeYu0ssApn068c7wPRNTnLNW+EWJX/kds+nhgoySKjkFmMJE5Uc?=
 =?us-ascii?Q?puqPVw7TZ/142thbRX7hgwx+HQSe/bQR3NmWbi1JRzQ54mS4Ao1I8XmiJY7h?=
 =?us-ascii?Q?2YR5VgYmJAOYG54wula4rIcdaUUOoRvKx5ARdYRPNM8P9yfLild1KZD91fyz?=
 =?us-ascii?Q?JNUK4k+hG2UoFg9Xb3jpwsRjtX74PePOPx7jG9FD2LWrnzCg45BwlmKyJ0eU?=
 =?us-ascii?Q?+j+43BePZbFuB1qXBhm02kTIrkzMg6vjzn4uA7h2RL4sYs0bLT/u3eE67VNw?=
 =?us-ascii?Q?9UyNjeu2NO7dEkWPT5HqDU8wnADF0Kp36V4+rIGCpDOWZzn7iBfPyRpa/TVe?=
 =?us-ascii?Q?HwnE65wgkRCL6Sbzy15nBunmEeov9mY04KPS3AAYCxm55K7cKRYARcpsH2YD?=
 =?us-ascii?Q?jJjJ27hMtt3UGokilh2J0uPg/kmJJb6jB52onG7JCrLk4MsVkqG9wdQosd1Q?=
 =?us-ascii?Q?zFm3Nd6GxHrVMk0kRhB8fNL+6VmTuM7YGvR2LeXLovZoD3jduQL0N/B+ThpA?=
 =?us-ascii?Q?/rxLXCyynh7tajYFjFoxbSfuXJ9TsqhTaJRF2hgjHYaph9lhRdpyuk3Wo9xO?=
 =?us-ascii?Q?4Iso2QGDlROXf+Rp8M9/aYlLnd10v/RbwJIoo/HqbQpbDe51GmrsjYLZnxeG?=
 =?us-ascii?Q?RJX8r/JZLc68W6c2ggR+f08iV961jtntbIKiACjH+xkTHFGD0h32IzrN6ovu?=
 =?us-ascii?Q?89iTDQXH7gKbDKql0LpS4SvcEoltVGZm6KPqbpJ4DaiU1pTXrMHEXBbc1v/S?=
 =?us-ascii?Q?iI5lvPLOREUWLk523rLbQ55IOmO0tKbkTPALUUkvKBFhPDpU8T4LJGu5zU7s?=
 =?us-ascii?Q?0TiXCzf8czCZIAgWGg4Di3eFO9UrzY2cIWL8KaoOZLj3lBAQZSdq2yfIVArC?=
 =?us-ascii?Q?vT78UJ6lNVMNXeTL+N0CtU4OUktRX6dP4FaAppF9ZlyeZhfjw9VaZPnEsQLd?=
 =?us-ascii?Q?42q0fVVTNiZL59yT2xO00ruBN83rMEKrK4P7rQupaPYSSwAk5tkgxrxtkuqF?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3ff0c3-f056-4d75-2556-08db3dd3b549
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 17:06:09.3976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xNLQvlWDsleaUQPXw4N1RvAUGhWpIQAiQUoosJuiME4Pq4ChMjqnDVx3UmcZG0nQIUkVVY/7SGOflRhQIz2Ywg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
Diff vs
https://lore.kernel.org/netdev/20230220122343.1156614-12-vladimir.oltean@nxp.com/:
none

 drivers/net/dsa/ocelot/felix_vsc9959.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 66ec2740e3cb..e055b3980ccc 100644
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

