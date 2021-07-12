Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764953C5F09
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhGLPZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:07 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235436AbhGLPZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jW1sXt6N+k6Wyx/JpOaclyOHsJPjyNyDqYWuKYLmMfXcwTUyOvP0G0+CZ97zCQxrGlYYC1N5ELOluuB0XBfLo5PM+L5L58o5T6cJugvd7Oc1MOgVMR7wGjlJ7KGXeyiJ+x+HoRnfcP/GN+bG+vVdIo7CNX+PeDp7oW4e9+MrGB0woWlmJBguSEcnKJ7fnUj/y/gR3aaY+L4ErVWhiHFTSXbnUKyA0HQwrqiP48iYy4bZPQHNPGdqVLsCt9nVnJtRhGdmp4hbqFI6XOUOUlSborIBbbDP0+Ni5bsFX1MIpoe8NDoaWFh05VJhv3KgijF2SV/NLRIqtFnAmEYnxhmv9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVVFIz/Q/pDqurutfBde9vIxwGAg5CK6+yUwHAHk+P0=;
 b=QX2BdBF0b9BsbzE74oh5U2pogTKmlJoFnPZwv3lAjXrFjN/JocW4r58Y9IbXbbMeJfNSV79IZbkqdKhtXEvESWwyJb0XOqMn14cQSVi5rsp1SRdCXrikl1LnRPWGnTjHU02Ke7A9Hkpt1exWzu4m2iHDuapHl9JxANkHa1pMBEbDBseFUXtb0PMFwpCabIl312SF2dK9EOxbo448vKSv4HXSCizu6+AcbKRbMYGtnVUBGe16x/paUZDIGSXq2D+VAN8kyWSw6Fl662Agms7mB5piy/ZnG+GEZ+IAKIuMK/OnAcbp/9yrTYTMhKwZkT7t1Meh1RYrXddNU/AKQOKTng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVVFIz/Q/pDqurutfBde9vIxwGAg5CK6+yUwHAHk+P0=;
 b=oDev3WMBqte72/nvyIh9+CP9rAh4qddkxDvSFd9exhM3MpAIYjpwfeRr8V+WyJdvk1vNqX5m3rvukj/5GDRxVV3//dt0j97UzsYWNrpTi9KcMjN4X7MWQCwdoBs2rq5qFaaOisUkPare1+DcRcMdfBX3biCNulTSHC8BNBM0XpU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:13 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 05/24] net: prestera: if the LAG that we're joining is under a bridge, join it
Date:   Mon, 12 Jul 2021 18:21:23 +0300
Message-Id: <20210712152142.800651-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68f36dd8-33a4-4de6-e222-08d94548d343
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6271BE28E0C1B7B6C6676756E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:359;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRb2WumAnd0dngLz3W0e6OM+gHX+U4S1mYeyT1QNuFrD0bx7F1axPPVTP2mGjTuURYwbOfNabKUlV1SJz9NiOUCeJpiGSZSsHWTy8RV2ARwUCFxFwmj9nN2MaSSgiieX9pk5lKrvJNFPNK7cxZMwFYJNV4Bytbho9n0tS4uLrwTwvad0aRIKL/UTq5gUo+QSAIIZxdDDzDRCWJD7uenIacIkLkxKFUXY9KJF1N0VImDetfLuN/DeJqaC+FeBaqcZ2O2QuQd5DJXRMyl51hSPFPXI7AeXfwcQ1TBCqFhJ4nUz717MoLw6rZXuO70Z/S9qWc6CmxYD8ezX2+b0ZClx18PXY6xdgvB5YtHxOOiRUwY/OH8Dr2c+GqxtwozJ4qrdu9aaGdV1kqbxjHGY0a4sYSB6mYs/tHM9XGOcwhGY+1Ixnb5MGI+nQH3jIQLO10tOYdd5vluBlQFf9e9k9deWm3vLbhjjUtIJZolmmttWpXdkkbL3xPX+jsa5uZw8sR90X1PR9Lm9Z1UowvzTdSWdqGAtWHhOeMCaxyNhPjFAKjgdRGs0AEVMBJkhcFxIx33PrmE4rWKIxHwLRvUBdYxSig/KQnrzjW8b9//4XZhrdPFgQr53Zf92RmhN3mbS8JF0JpGai1jAGFiRWROO9rgBkpyy7gZfjukDtQgLG9qcSuAXzDknuQ6DSa4gcAuAotYz4MNe73QYflm6Y2OFDevRkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?spekLyg7zSnlbPwut0T0OXjjPNZDvSEgz5+r6l04p/LVU5oe8SAcdxZB32v3?=
 =?us-ascii?Q?h8l+aXsl7fiKLIGPMwNCJGtbed/EprrDFoDGD2lZVEK1Hwc3aV5HLvOlWOv6?=
 =?us-ascii?Q?Yyq/+qqB6fsoVCDbYZxA/8o1nWaWTJ0KVh1NZDMKim8W8P/lpaY3KRE4nkbq?=
 =?us-ascii?Q?avGrKfbShzdYw4aWJBqWBpwpT8+zLFVERg48q22oa99yCg/CVhSPukOxln6O?=
 =?us-ascii?Q?Ct3hDsTlRlWw/E+QrZtAivWGJHCjFIRWhu0RHCKogsWwoGtf3+z4GYA/MvOw?=
 =?us-ascii?Q?NeDDIwD9iIjCRKkypVxDZ1jb/3Riw/uFHRU6zoRapK/JT7ctLUiR2tOF5WqP?=
 =?us-ascii?Q?MUZA2jsXduSGt0j8x8ka1Qx5BfX8WHgJofSRHcJVKFq5YHiVeJuJS3sazZTg?=
 =?us-ascii?Q?GFUm45fSPrwvGVrCJbX9EjaW5sVhRYyQEu3twsX7UmsrsLvDN+Qx6cHFvoAe?=
 =?us-ascii?Q?+ILN2DR7Xou0gevnNNunGPvZzDwmD1n+bMqwmhFcPR2Wi/ZlAUQeQJ/hqzAX?=
 =?us-ascii?Q?MS5bSXns689KmgQP4pT2kLvXF9OpalQs9/dVyW+hLU7KaGtQHDcUdTWlhEJs?=
 =?us-ascii?Q?ABEHt+m/Qq+ayqLlXD3N90QbRoFG2NYsbHPQew7LGbX1fXw3TLGSA+sTF3K+?=
 =?us-ascii?Q?d18uRYa81znrIPcjKcAnE8VxFHhpOWMqc4xt+zk5Qu920MjPfmdp7CqH4nMP?=
 =?us-ascii?Q?VBToHqz6WDLebM3uiP+CK4hc/lVsxw1rjtNvFiQEpwxut+Pa7Qqs0CVWSsRH?=
 =?us-ascii?Q?87xS3bHQmyOoKJ7a/WkP60bkmGIcpRx1tW+63YK1Adv0QLj66FuO/EjBamcf?=
 =?us-ascii?Q?TYrTfIKeOn0k7rrcIi67qrEUkyOvoY+ZWb4nbA860VqhOSG7sMB3OjZWS2vl?=
 =?us-ascii?Q?+TxRVGcH+qDLs0xZuksnIM9vkGYgGSsdyhhEHkAG7aX6paGYQLsbCp3kRTK6?=
 =?us-ascii?Q?uiPockP9U7lS1Jgltx3MVp+PU8L8PoEJ7BMk82SEMKUv4eO+IjlaH2wKJZXT?=
 =?us-ascii?Q?BaxptFHELbEhzk1HZoWNjCR6O/0MZILr4C261636dJBvtSFmMm2vZNYEsmM4?=
 =?us-ascii?Q?IykezyOU3wHYy2I5L8ZfAbsPXwhGhN/hQe3jrAF7+Qj9ma9rwAA57a7Fkf/H?=
 =?us-ascii?Q?JP7KzBr8THz+YYf2LRjFlC9c6Dgd8Z78VbcsQjyssZpInYvzeIXcgLicNn5W?=
 =?us-ascii?Q?OaZXZI+ExX2wn2ixse0O3YCuoB9tPKChAGktlZ7VQNsJSR9LSLuwIS5OOsAx?=
 =?us-ascii?Q?qt/oJxfKPG5g1/zHchpS1fM0KQximVfcrwJbq1CPx0736szIy5Z9VM5RX+PT?=
 =?us-ascii?Q?vdnh4a6s0QQnR0XRKOJQgJya?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f36dd8-33a4-4de6-e222-08d94548d343
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:13.5708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VOJLLHgydbUDCpm0SqqJxquTKrkjArPzXF9WNWXeE6seRzlnGhr6BEReNdPTb+fKN6wNTRTjUHyk4BnaBhSpIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some switchdev drivers, like mlxsw, refuse to join a LAG that already is
under a bridge, while others, like DSA since commit 185c9a760a61 ("net:
dsa: call dsa_port_bridge_join when joining a LAG that is already in a
bridge"), prefer to handle that case and join the bridge that is an
upper of the LAG, if that exists.

The prestera driver does none of those, so let's replicate what DSA
does.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 226f4ff29f6e..979214ce1952 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -567,6 +567,14 @@ static int prestera_lag_port_add(struct prestera_port *port,
 	lag->member_count++;
 	port->lag = lag;
 
+	if (netif_is_bridge_port(lag_dev)) {
+		struct net_device *br_dev;
+
+		br_dev = netdev_master_upper_dev_get(lag_dev);
+
+		return prestera_bridge_port_join(br_dev, port);
+	}
+
 	return 0;
 }
 
-- 
2.25.1

