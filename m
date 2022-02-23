Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27E94C14F4
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241321AbiBWOBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241326AbiBWOBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:01:44 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140050.outbound.protection.outlook.com [40.107.14.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED05B0EA2
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1HPEJjl6GSp98gm1qg1ryfWFubaEUJY1BE3eJ1InExh+T2wH9eHrN4HACzK80iYbaMZ2CROSoTcv2BzgT0WqhVePZTjWppE1rBZDKj7zNuZhiNPnS7x8ZQvQ6AHY8tpxC5Gg9CQq0FimLhdqJI9SWTdEXaiq6kPniyIhawQUrqmCKHfyML7gO/pCOaQqQ2o16bm0N80MMNmML6IHY4HM6vYTTd+jOQ0VRi2YiZeR2ukY1XngJ+G6q6JYMct5IxulgQaxWalDc+nOeLYBRQueAnMdd9yTXGBRe8UEpIP7I2givyeBeDFwDO141X4YYzRQlxMNjCRNIkp6dzOpZd1Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGuCq8mueI5tXkT5QJSW1CPp86jdsvXpDWBtCWIE8F0=;
 b=gCN0qoCAC6GguNeBUQ2kSyAu8tfbh0DxtYUPR3cjQExBdq5aAH0mJUQeoSGl4Fru2vFHNhA428TSYdrRBbyhpkAmnthiRWiPa/aHWpisHLu9zSbDTqgaCs5a1nASgHJj1ez6na1zXzMj4WU/GaNCa22kjU5zga31E3lLAAuBpzwRt+9ZPAL6a7wDTVm96LW1OxaYGgtb9lU1c+R+ugE/WUNkLrYh/Iq0d9mzfyao2SOQzMygdmXqWVm1Br5twDnMGwV9OJ1+x4nLnnLKOCh6seQ54cNlr7a/ab5FA2c50DAe8IprrtNOpaUfIADZjOmzK0+A17RDvLxaOVQARPbsFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGuCq8mueI5tXkT5QJSW1CPp86jdsvXpDWBtCWIE8F0=;
 b=cBxzh1sjl5pNnNW64UgxkDYZSAzoBO1zK6J545HzgRjINDbGQ+dkr8d/yEa0nvFFKeewrp//dpRq1dOuU8altipxEpjkTyI7pfGueLObxep/8SdnmDvdc6xP9nmP7dykguNybEbF6Bd90LnRG71S2Sam1xFW/vUCDPMp0GEQjhU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8701.eurprd04.prod.outlook.com (2603:10a6:102:21c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v5 net-next 05/11] net: dsa: mv88e6xxx: use dsa_switch_for_each_port in mv88e6xxx_lag_sync_masks
Date:   Wed, 23 Feb 2022 16:00:48 +0200
Message-Id: <20220223140054.3379617-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
References: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f49ebfef-e236-48ce-b54c-08d9f6d4f29a
X-MS-TrafficTypeDiagnostic: PAXPR04MB8701:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB87016CD688357526EBDD63ADE03C9@PAXPR04MB8701.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: embeQ1tHugxi4vC47JTxHVuGhO5nUMSHCXIi9WjeZbgOQ5dSYzTSJAaCAdhuzW2+ZDbMI9Z394r7S6+WcXJ/XMeSBA1vsopaWSlPc6nI6/pR5hR5dDk8lf/QUXYASrD0zsa8PD2J4rPCuC4QGLbKzSRS5qtfNSbihJQVgmFRr0n3/hFik+jbkngJs3BRAAd7dL9HR9glk/eSmJ55DYSF0fBuvlFF/ZjFqGy9mQ3/YK93lM9ULMQcpGNqBRwdHxiJMv5ikx5kp9JPlkds1teg6PhPLRIbBgmv2pPuBhJC+F56ajFA+t/2D2M2C85l0nT6LVLmmbTV5ijj9rD/Cf+k21SuJZ9SVBBEl/7uYYT120GGh66K73ATqxpYzBz405iJ2VPWa0iUPjnWXZX19K/teIHWiZmpDrd07Bc4lwnR+qCfQjkNCx6ORnDp7EyKCNILFII+XJk6pZhGU+8t/OHySXCMj46CAnqcSVdtiwCuhzOtfk3CsKodFicI8Y+javd7rTsY2af5To9O9ZmEYzybTeWemgFRwbQKcnc27roWX7tUQuPVeyIFVYCiM70C4qPdIZiLHssfm27BjAg+jn1DqBaVouweUTJndeBja4x8i77clQO9m+yFZEap4XiJPD3xOzQpsy9OIcmP/aFJqWzXVHGTysjn0H7lURmhKgVCzuQPVkw8SNwwmk18PKfc3vAM+oqbvBnWgJ1LXoCOJ2sU5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(83380400001)(4744005)(38100700002)(38350700002)(6506007)(508600001)(52116002)(6512007)(6666004)(66946007)(6486002)(2616005)(4326008)(7416002)(44832011)(54906003)(66476007)(1076003)(6916009)(2906002)(316002)(66556008)(8676002)(26005)(5660300002)(86362001)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?91zYxZeB7EMx+1a+eao+0sk842Mg3GZINNbwCma9rdat4oyKAPOQ/eVG8Q/v?=
 =?us-ascii?Q?G/x7CO85b/crwt3YpAuUTLBiWUGOd7vRpkX/86AXKWg8UF0ad4BY2encGq4R?=
 =?us-ascii?Q?kAog9kYCJVp6TMz7+LcuNKzjvmNY2g/UD8xEm//V4rmorLXxkFQYnVcSJ/7+?=
 =?us-ascii?Q?py4PF/ByyXUGB00272kQYmAFnhreDbZ0qNcWTQbq3XayZ7tjcpTEcAJrI/JS?=
 =?us-ascii?Q?OfffiiYXxtWFhaO/C1Xl6uwrb2nZGSuT41rSOlQqOMZpKgjWA8yYZy9rt+b9?=
 =?us-ascii?Q?31edOt2wRBUpNHRZlT4lrX4nD4+NabZKp03uYy5GpLfsZLz8FBpfsoEoN59m?=
 =?us-ascii?Q?u2We1U1tWJrlUWGDn9dSIGVcXKUVWuMIr3LNcXZgg1kv0l6NkKffoWyOecHC?=
 =?us-ascii?Q?hshTE0/tkPEhECqdEtfq94UwhqnH9+LbdBllIey4w6pJj1fD1bk1fYQTWIsE?=
 =?us-ascii?Q?f6H5m0kj83UqQXn3W1wkznwuymdJVsOm0A/yYAcDfhyQPywPEiqWqPaU33Xz?=
 =?us-ascii?Q?VFWsVob1ktHuzKWMNLF75STDkRBoU4lsK0cL6nUb3by4oEYylMvrqquD4w9j?=
 =?us-ascii?Q?OkxsVBhG3aYqYes7ylqzT+jt27yr5nsVlianlXYm8jULCYrFjfe+nqgLTVUo?=
 =?us-ascii?Q?1Woh68ac/hzxiEa1ghxyVh/88x+nf05xC5pOFxezMs/g2ywHbbs90SbIOBr8?=
 =?us-ascii?Q?bPfwYAA/vmtmM2bXPP/Qa70aAuMejeIVnuETAjD71U9ICNyFgxltNU+hSwBz?=
 =?us-ascii?Q?hQSSZ8XBb/iqhvhr82a8O6jEjew43ySWD51zpeq722qGkgp/X1/f5dA3+KzN?=
 =?us-ascii?Q?9S5P8c0bNtjJgTeRkDq4rqJjoKdwcCDF1z5+XwZRCWhS4i6wrdRJQ/qrtXDX?=
 =?us-ascii?Q?CUHABoGOyl6OwLi+hSfmnIJ/B2TDWjfvclhtCVyiDZYmlYp6oMCtcMl/AwSD?=
 =?us-ascii?Q?E7l5YDBAzDeuYHBlmW9XoaeYgFmTQ1j+hnVLghFj9t+mnGPNizAdPYKvJD1t?=
 =?us-ascii?Q?gWpPu67N2OBNqtrxna1q3CWXW1Ul5A7jx6fp3E9Fq9QmlYD1PEzX4Ez7ewdy?=
 =?us-ascii?Q?aLBezF/tTFHlPjEgzhA3Hbphh1IJ4v4gZubDoCBQbH5wkhOwdCNeSA7vag7d?=
 =?us-ascii?Q?T5y5ik6D8Yk7lrR03s3sI1XVALczxRt3jkgftbqp7bnnWUD1BRMQVmPQPu9V?=
 =?us-ascii?Q?jnkaAspxcdAszKIXUi0BNMhvWsDpR3/CzhG0w8WrW9W0+/Klu+jf2Wezsk1R?=
 =?us-ascii?Q?ONyb6TWafhlerg+50X9KMOzAY8ZlpFbrTrw8yCFJD/BGHPNc2+bKoeSjszv7?=
 =?us-ascii?Q?Ppe7tl+jH2buig8KYYamr+sRiKvFZqTrRN+2Y9CgPb8njkFztZpacQZj37rF?=
 =?us-ascii?Q?bRcK7csk8aYSHp3z6LUHMlWBX++qETUv6GU2bpve6gNRUaZ73Q6X0aW5NZDY?=
 =?us-ascii?Q?WL0//9+N81ibaJ4x+VpeYXEP76vLn7QJe4rXuxmn4Er7Sv/MP1A3Nj+ZHys/?=
 =?us-ascii?Q?jAV+mMBeHgbPOnyfQ/2BAmmdqfVKWdz3LbR50b2O1OUu8oO5yByRnSHeL5XJ?=
 =?us-ascii?Q?VLB/tc7pSv4XaCRmn6lj4MBs37RwNkv/3xTPtKOMqno6K5hC51KZ3G+6i0LY?=
 =?us-ascii?Q?RYQx2/Q01mOm3xBjKpMUMcA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f49ebfef-e236-48ce-b54c-08d9f6d4f29a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:11.5391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxZCFZ9heUGdhCaJbgOWCQPLEXn5W3ijilhEqaO09Bz/j8q3OBI7HxtQHAoodJDdoC3gKKAPCwHnhhV8mR8OpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8701
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the intent of the code more clear by using the dedicated helper for
iterating over the ports of a switch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v5: none

 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 23151287387c..8868110fcc9c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6280,8 +6280,8 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 	ivec = BIT(mv88e6xxx_num_ports(chip)) - 1;
 
 	/* Disable all masks for ports that _are_ members of a LAG. */
-	list_for_each_entry(dp, &ds->dst->ports, list) {
-		if (!dp->lag_dev || dp->ds != ds)
+	dsa_switch_for_each_port(dp, ds) {
+		if (!dp->lag_dev)
 			continue;
 
 		ivec &= ~BIT(dp->index);
-- 
2.25.1

