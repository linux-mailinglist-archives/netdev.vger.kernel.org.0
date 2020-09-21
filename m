Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D572718BF
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIUALe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:11:34 -0400
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:15744
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbgIUALe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 20:11:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/huHnkrQyC1X9zozNOesnex2JnbbUruTAK58U+mxOh6advzwdmwcR744SdYIQzQvVd8YRxVrr1C4U2NiANIO6luXUnoXpg85K8dcAES0QljHpukyAPSq20dZWA5VEmAU0guIXrsUIqUgYNUocopYZxtUb6x/9t1hZSUOjv3gsVp5bJ3NOFTPzNy4FYF7FLLhpQegdCrp5OQnCvjE/tmVJdLP7HZlRxP+q56pwdXNkiWL+/MqEY7paD2yD73XSmakudFoJ4NLqnXV6MguZ8FrUgqZMrDnEXlLJJ8d2VzEQWP8U85QbyH4XELh/JjcYOIOOsxSXgijyPrzzmJne/sGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXBviH3y0ZPE+PoCsknT7iZcE3S0wbcSj3IcF6wAvjM=;
 b=WIIqpYyX+2L6m01x5EzTWlIlo4aN/rI/0GejgnYollektc7xBrqZTO0Jw36AcWVG4kuWJ+ylUerrxGJsWkMi31hlWwBPVmRHuXnClwHVt+r3sgVAj7oYQzf68i8i15UD1j9qHnbFPPpOGFqRQ4qq1xWexyeaomsJYEXFIK2asXp1WOFG7gJ/LYU1RPJau0BA3TeMyqCs4AOe/JgtJam4luuT5mvwe2vA042/0UCxtm1snLihJl7ZFFOyu0YbWMTqPytnynGl+8izEvm5btRPnBIgBn7mv4m0C8rIlrx1QMcMehRzNLjvr8GcdycC4rPruJDV1aPWX5UtXu7k0UI7UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXBviH3y0ZPE+PoCsknT7iZcE3S0wbcSj3IcF6wAvjM=;
 b=KeZ2E8GbyqQXy3IcJ7Ev3vPjY45oYSxBL7DUW7gszeLT9Ku3qEtne4q+FpygPldxJrux2w8Zw12gdVs4iRLj9w9op8ZISh5geLKMC4LKLPm73Y4IgNgnagP/z939H1mkSomruvLoYM8Ki6IVqDVcc9BTuYxy88ElVvARNVSshoE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 00:10:51 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Mon, 21 Sep 2020
 00:10:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [PATCH v2 net-next 5/9] net: dsa: refuse configuration in prepare phase of dsa_port_vlan_filtering()
Date:   Mon, 21 Sep 2020 03:10:27 +0300
Message-Id: <20200921001031.3650456-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
References: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0048.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1P195CA0048.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 00:10:50 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ae09184-7f00-45ad-e85d-08d85dc2cc89
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB55015E6B71331F4BF590D178E03A0@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ksW+CLG/MyVZQNEto1w5J6mH4nTSThxCDyGqYzNnk4aRHKnRfsz6sX1VN9/tksIzPVtfcyc+vwfEKGZtzsfOIZ3bJ4iCuRUz/I9qXJ51UYbZwGz1lcsrNi46o+btmcuiraDjb7h9su5YR3TmJT0WXigTw6aaKnOzyvFQF1YYAsz4CTiolNl/zAl4ABPkS0lVK5Z6sbck9jWFw/sdaOuNslD88aa+2MJkCwUJujXe/v9o7t67xdnv1x+cMpTs6XjXQXpXcNxjuBH3Kpb5SeTsOunQMpcYicEwNWBlUY6qTz3HObbm2iHZvgtWkWIDmO/P4xLP//qMjepiP/ckQHIXqcpMXayA+slKEZCcxy27vIcvjVAz/aZHHJVk6ZePIUU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(16526019)(26005)(6666004)(186003)(44832011)(316002)(8676002)(5660300002)(8936002)(1076003)(6512007)(83380400001)(66556008)(66476007)(66946007)(86362001)(4326008)(956004)(52116002)(6486002)(36756003)(2616005)(2906002)(6506007)(69590400008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 26SP5auhd4HPZFcl6kKyY9i44C1Aczo8qur5bL8cWMKjFEhTn2P0s08GsQIsbsK1VvZVF2Ebpehs8C4lkQYqFlllkEtDFTfYnnmEALddLfZ5MlvVHlbiH2md1qyMkRTYr/XtsXnPcCteUZdPEeXx8fmaeoRK8+NMxsN9NEhOLv5Wiu4+fZ5cUPaUqzNxk32pDrEdlvLsCXU3H5vXoqLzMUXuF54k88sow8My/eh4PCv+dxptHNTDm5wP6YFaLhKhQtE4cypV9PTV4rBFBEuuA6Qz9c79RrIT+WZEZ/mrYP9LJQPELqKcd0UQEeloJIxHi9kvFgLPn/IMxxTiL93gL7tcJVZK6umxnTZad9VMvVfydpxmQVccp0tUzHWQ2SochyXmLjlJdYCv92BaFMYomnmnFsd5+lRzD1CcnugwZvhHCFK2w0AuJKQ2JWGStZ/k+3HTf/OEsQKERd1UfGhkpylQ4zHakDNWVELHRZVdZgUFbOz/atCbFgZl3blXU5p43MAoioGhSI/fZnXtjP1m7bQv8GIvoGvwuO1aHvOxMeeBk7ZV7C43MjRS+RhmUeBZp7BuY/Xy+iERMMMDUawnvLkGeaQI+uLA+BlS6nkg4xLpRYyYvhhAfybVij0XexqqmSrTWBkH3PIx5HpC6X5TWQ==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae09184-7f00-45ad-e85d-08d85dc2cc89
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 00:10:51.1462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYzSg7/ugagSOU7wZebPLBRbM6WBOdOjocdVVFnqWqXQdSGuOdrQQV7X9Soo37ehPI/fNMJ9JX5kBo3qFwbaUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current logic beats me a little bit. The comment that "bridge skips
-EOPNOTSUPP, so skip the prepare phase" was introduced in commit
fb2dabad69f0 ("net: dsa: support VLAN filtering switchdev attr").

I'm not sure:
(a) ok, the bridge skips -EOPNOTSUPP, but, so what, where are we
    returning -EOPNOTSUPP?
(b) even if we are, and I'm just not seeing it, what is the causality
    relationship between the bridge skipping -EOPNOTSUPP and DSA
    skipping the prepare phase, and just returning zero?

One thing is certain beyond doubt though, and that is that DSA currently
refuses VLAN filtering from the "commit" phase instead of "prepare", and
that this is not a good thing:

ip link add br0 type bridge
ip link add br1 type bridge vlan_filtering 1
ip link set swp2 master br0
ip link set swp3 master br1
[ 3790.379389] 001: sja1105 spi0.1: VLAN filtering is a global setting
[ 3790.379399] 001: ------------[ cut here ]------------
[ 3790.379403] 001: WARNING: CPU: 1 PID: 515 at net/switchdev/switchdev.c:157 switchdev_port_attr_set_now+0x9c/0xa4
[ 3790.379420] 001: swp3: Commit of attribute (id=6) failed.
[ 3790.379533] 001: [<c11ff588>] (switchdev_port_attr_set_now) from [<c11b62e4>] (nbp_vlan_init+0x84/0x148)
[ 3790.379544] 001: [<c11b62e4>] (nbp_vlan_init) from [<c11a2ff0>] (br_add_if+0x514/0x670)
[ 3790.379554] 001: [<c11a2ff0>] (br_add_if) from [<c1031b5c>] (do_setlink+0x38c/0xab0)
[ 3790.379565] 001: [<c1031b5c>] (do_setlink) from [<c1036fe8>] (__rtnl_newlink+0x44c/0x748)
[ 3790.379573] 001: [<c1036fe8>] (__rtnl_newlink) from [<c1037328>] (rtnl_newlink+0x44/0x60)
[ 3790.379580] 001: [<c1037328>] (rtnl_newlink) from [<c10315fc>] (rtnetlink_rcv_msg+0x124/0x2f8)
[ 3790.379590] 001: [<c10315fc>] (rtnetlink_rcv_msg) from [<c10926b8>] (netlink_rcv_skb+0xb8/0x110)
[ 3790.379806] 001: ---[ end trace 0000000000000002 ]---
[ 3790.379819] 001: sja1105 spi0.1 swp3: failed to initialize vlan filtering on this port

So move the current logic that may fail (except ds->ops->port_vlan_filtering,
that is way harder) into the prepare stage of the switchdev transaction.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 net/dsa/port.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 46c9bf709683..794a03718838 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -232,15 +232,15 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 	struct dsa_switch *ds = dp->ds;
 	int err;
 
-	/* bridge skips -EOPNOTSUPP, so skip the prepare phase */
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
+	if (switchdev_trans_ph_prepare(trans)) {
+		if (!ds->ops->port_vlan_filtering)
+			return -EOPNOTSUPP;
 
-	if (!ds->ops->port_vlan_filtering)
-		return 0;
+		if (!dsa_port_can_apply_vlan_filtering(dp, vlan_filtering))
+			return -EINVAL;
 
-	if (!dsa_port_can_apply_vlan_filtering(dp, vlan_filtering))
-		return -EINVAL;
+		return 0;
+	}
 
 	if (dsa_port_is_vlan_filtering(dp) == vlan_filtering)
 		return 0;
-- 
2.25.1

