Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418A93CFB35
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbhGTNLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:11:09 -0400
Received: from mail-eopbgr10088.outbound.protection.outlook.com ([40.107.1.88]:40467
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239096AbhGTNHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:07:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oV2PNbQX9myRRPs6lov+/jf4gcBSjBEUb0ej6+Z7iNgDnLQi2CBJbJyMXpsW/NZ4byYydvqM4r/wIg33iykr9U5xp9ZQlqRhgLBjUWouke8+Tuc+qhKl7E21wT8KiogdP2IRsbtj9Sk+r1DaEPdzxZHb/1TKvYpaAAx/8QX/ULzfdggXC4P66arhvuBnnk332u/QjSGnYQn/ZONEfOIK2xJfzFTRcHcI6XDU/pBPSx+Cwd+NLLXCS2Tg9b0gieHFi1Z2WtXDJax1JJMbuPu+Skh7awo6aYHWPGcbPRNisZwdokC5bCiTD96VbcjojPbKJFvvSBQmccVwYvcwGtj/Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBi/m/e9fTm98LFndmKnwMPNFVaW1NGhQCY9cnxGwhM=;
 b=cj/8yuZQG5k4UupFEO7KxvjucV/eUjU7MEsXYsk8KQa9qCGifZEWdDzzFjUfBd86FodGpAOXTmCjoRG5WwYiKz8VGInSxfgx99rwCihrMRYTYm0nbJv5SeqCR2sOVS40gYMk1uV9yHbBMrh9WcUmeSVPC3R/eTS96hZ3hnnHvWDC11PxKsgq1Q1GFl9SAco1NQbYulZF9ZIblwNoMX51TtxBEvKHbZsTgrx/bJsG0T9K2mpYUTQbNGI/FH06f7YTUpfz5R8SohciHXSTq9i201g4H/rRt69+LTB2bVRc/m9pREysaTiTctx2wiMVcvdg42GGm2i9MI/P0xeq1ckL9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBi/m/e9fTm98LFndmKnwMPNFVaW1NGhQCY9cnxGwhM=;
 b=cCT851NTRm1GhX/3C0/+46MRVyQMRNK5yVju2SYzb6TZuzOfHjQq07DibOLuGV1acPpc8coHtAx0nPCOnsLKXqETCNGuZE63iHBA0hgEIzlKJtBl9ktTEgdV3LsUxPr7K593GIv0ehSsEZ5wtfAkOu6YhMYO41ax1OeJ+8+M03U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3551.eurprd04.prod.outlook.com (2603:10a6:803:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Tue, 20 Jul
 2021 13:47:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 13:47:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
Subject: [PATCH v5 net-next 06/10] net: switchdev: guard drivers against multiple obj replays on same bridge port
Date:   Tue, 20 Jul 2021 16:46:51 +0300
Message-Id: <20210720134655.892334-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720134655.892334-1-vladimir.oltean@nxp.com>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR3P191CA0002.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Tue, 20 Jul 2021 13:47:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 400a906e-2c46-42ad-1019-08d94b84e4ec
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3551:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB355167EDC6CC5B6A27680E6CE0E29@VI1PR0402MB3551.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OE/syqjuYaz/HlDOovTMuiBQtilsiGUhQFUNVExhSbHbfWA+bblSoib+fvNXXOiEsOzd1EXn8yNr18ne7/jbUQVWlJ4hiVPYFULiJPhhu3ALSit+RUcCSlKhfYtqtD2EBdC7DWPA14IHGTPpGr9VrbjmOlKMBQeW8e1N1PjQeE90E2E8oQO3p5Sxu4n2XkcGvd2uUFixDqjLNgkQ8M0ssavxujW8SzLnbEJWB+78UiNApHOIQIb2hpTRYzgiD4wT1z8Q9JZpF68mQoWkF+91bUvP3efCEfDLczGSAtliK/Jl9B+IPXi361ae9ukGCZ4ZGgg5sTx6KExEkHeESdDNqi/t8QO6GbFvjI8eca/ByLYdjTmo/jZANZvIQ4ttGMjm6u2lFCW7TLu4V6aGR5ILTMxwmf/MiRfjhaaicrd+2kZLKs1JG5LGWWFDH7JtmSH/yDtauuClInsOPHnlNzaP2k2Sq3oq5hg74o03HKrIUp5mcaisjpoMEuzbPtz2KbWYt+zLrNhu8SxSlIaJK9FoKLQLB7eGjUlGaEivY/8SrT+drTOVMBdekVKl2UG3wyfZSQi9WmqOCj5f+TIPZli7xwLDeAjB90zNlOGSD96ZvQW/jMEYWdv5jIasd3rL4ltjPnhMTInOzD3Cpuw2i7nKlRhMHQwYYtZJsdRiUHHd8AWTPaPYKjfMCd3Ipe+7IEa3ghFS9n0iE2QxenxxKw4weA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(478600001)(44832011)(316002)(38100700002)(2616005)(956004)(5660300002)(6486002)(54906003)(1076003)(38350700002)(2906002)(66946007)(6512007)(7416002)(110136005)(86362001)(66476007)(8936002)(186003)(4326008)(66556008)(6506007)(6666004)(26005)(36756003)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T8wIs/i1593dFtEwrGWJMlj2ti1fmXLIs45irhgEhyiF5+uF8Xfw9Qy96Cdf?=
 =?us-ascii?Q?H+bwTwxzvlfRlh46sLNL0scYU8NSXzKJ39roObzTEUj1Qu/5FB/rKJsMJ1HX?=
 =?us-ascii?Q?1dCfbdECL41fj6ISghSo+HdXs4QHFd4K0w0++IShZH93AZy+FzmSP5G8T4lG?=
 =?us-ascii?Q?ZNIO+WslGgWsfUlpJINOTS/TzHjn7eTOINbn0lCbwcwEDyRXKStEvNhHf7VC?=
 =?us-ascii?Q?/KDF+IXL6z0w3jHSdqNOtMo6GrETJ175ttVmMT62XOe4JK4EMqv2TbKFWkD/?=
 =?us-ascii?Q?Oo8Kh1zuoLHUMDuq8yGMakeT6yKEScacz60T+JSdIdESTT6UZDBOuIdMKffK?=
 =?us-ascii?Q?X7nioES59O27cPBr9XTRHpxdbhCo+3Mzyhtp3xy5PfUkaa0mMVj0mzIas82l?=
 =?us-ascii?Q?z4zyQfCPPoKSGQ6lEsiJXsZWaLNRW8X6wxDPIkEeQCLP5yvg/FnUFJJetSQU?=
 =?us-ascii?Q?ABvA2Z+OSSx30sFojyVWkAadbtOBd8+/SOvsbYAdBRqWueXuUfXjktoYvEfX?=
 =?us-ascii?Q?5TbbaLzETQxQpgfaSQwds7rzrF/RyqSVHN6HaPxrYkt2aUl3PZS+2B2ZXJZp?=
 =?us-ascii?Q?30OozumueMDVbTFmBCeFIg49VL0fCYS5RBpk8ojf+XETaF1RtjlCbhmF7632?=
 =?us-ascii?Q?ePae5VZgUAZVYGPyqKMgCtOm07WfuMaLDPgARYVGa/rnHGSRQNnWGr1fgjMp?=
 =?us-ascii?Q?F7x33YmTq81U+9Pn+0BKV4pvZg3KS5VHphOf5iC0xZbqy8oFDevHupNv6YAd?=
 =?us-ascii?Q?i/r5zgyDPWa/7zR+NTgDTY9miWgHnypT7WJ0Y9T6NrVkKLXFzsZHzzPNp/AS?=
 =?us-ascii?Q?5k0lACbht0WkCFBj/c8SMlfIdnaGyxR+YyKwp1Cz4U9ntKyIx0yv3i5XF16v?=
 =?us-ascii?Q?v77ag7UfUp8q1poa8FHDO4yVPbYUURwy5HVCRv8YNpdoLEu6rhjWhhWcTZul?=
 =?us-ascii?Q?ExY87L4TAUOtJGsz6/HzN3ozFLStpieZnazfi2MVY4VpZ+A/6yFItGHOCxul?=
 =?us-ascii?Q?fppWtEVWA5rHaQc7v4zjCJXhnZemUwez+n57pddDrUsH8cJ/ivQZ7JiWEj0Y?=
 =?us-ascii?Q?0B7zmBSk6tI5c+B3GNREG3+oJafp28Sl0UjCgo6yPshZT3bYVoXrsuJ40gAX?=
 =?us-ascii?Q?NiIWo1h8GoavpAc4bWRdSgPbWrCuKDMWZO0oCYjE+rvvTukKgfyMW1bsPwo/?=
 =?us-ascii?Q?n580gjA6OvqAPNrxCJ/OTq8/A0X0f/5hoJ7Z9YGxuCbg+vc+tIXqQV2Feq24?=
 =?us-ascii?Q?zhHGJQZWJffdu39wbW+5KL+Kyv1cQBSR7OchIYjx7DdYQYtOQIn4XNV+srE/?=
 =?us-ascii?Q?/l9cymOusj4NhiHuNQ6u/S5Z?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 400a906e-2c46-42ad-1019-08d94b84e4ec
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 13:47:19.9367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T4eRVN6TgYo5lFVEQKGuYHWRQ5duNtmt/XOEXp3YKhFb8ZJCMhrGFch/3o8rYwK9dgaUOjLprlMOvn5bCevlog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare the drivers which support LAG offload but don't have support for
switchdev object replay yet, i.e. the mlxsw and prestera drivers, to
deal with bridge switchdev objects being replayed on the LAG bridge port
multiple times, once for each time a physical port beneath the LAG calls
switchdev_bridge_port_offload().

Cc: Vadym Kochan <vkochan@marvell.com>
Cc: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v3->v4: squash mlxsw and prestera into a single patch
v4->v5: none

 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 0b3e8f2db294..a1fc4ab53ccf 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -1047,6 +1047,9 @@ static int prestera_port_obj_add(struct net_device *dev, const void *ctx,
 	struct prestera_port *port = netdev_priv(dev);
 	const struct switchdev_obj_port_vlan *vlan;
 
+	if (ctx && ctx != port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -1083,6 +1086,9 @@ static int prestera_port_obj_del(struct net_device *dev, const void *ctx,
 {
 	struct prestera_port *port = netdev_priv(dev);
 
+	if (ctx && ctx != port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		return prestera_port_vlans_del(port, SWITCHDEV_OBJ_PORT_VLAN(obj));
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 61911fed6aeb..5a0c7c94874e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1772,6 +1772,9 @@ static int mlxsw_sp_port_obj_add(struct net_device *dev, const void *ctx,
 	const struct switchdev_obj_port_vlan *vlan;
 	int err = 0;
 
+	if (ctx && ctx != mlxsw_sp_port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -1920,6 +1923,9 @@ static int mlxsw_sp_port_obj_del(struct net_device *dev, const void *ctx,
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	int err = 0;
 
+	if (ctx && ctx != mlxsw_sp_port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = mlxsw_sp_port_vlans_del(mlxsw_sp_port,
-- 
2.25.1

