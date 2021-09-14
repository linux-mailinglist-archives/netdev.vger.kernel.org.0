Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66B040AF72
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhINNpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:45:02 -0400
Received: from mail-db8eur05on2055.outbound.protection.outlook.com ([40.107.20.55]:16097
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233199AbhINNpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:45:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pe4FtpF6DkvWHS7Q6iWq13bkbgfEteZaKt3unWoNgwXbRQsJbdYd6wK7y7yyXMKoROMaU8CYWPaQV1jIR+mgywDF8Rdmflpzb1fsjAYEhBYGhMqI2eSjtPeuGMYqQhelp7XRP5h/dZCL0l9hAua3ez7VHESh67kHMube7JuSCU/gjF07LHM32NeE4G9fPSY/qBOE1BUJVxfXadHIEOV5xwkPnmJoELv1VqWTMXdTvlm3dj3KPYLoTvRN71uDgFIcTWV8/0dTmERbAaeJKVj7YSJ+hM/xHvPRT44IpWVqfnnCUenP+QuDfvW78y5OXXTr2oWyjWmLFQvO9dWDSwxfBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RHCcdIzaous9CXwb9h4l/wjBH1qiDUhUVfoniCBGMXk=;
 b=VHWOWTKzrUM+soHO7Qz25vtNcqmiQjN8K6Li7Lt+jCeD9bN1ij0QTViLtooGgeIjVu2OeyYPwuLtUylVIX7COqStuYVVMi8Fgt7AYaY33o6M0d5oHCMI5j6Mpdyzs7ADiLWBz36oyipKELbmdSXVjGT9T9il9U4aMlt+SiA1prJLg97vRLBf6YIRczgTAh4jgIe+ESesgGMg6aA6ixcr4cYZMfVS7AZk98L5OayTUnUAh5Bm9yT2QlU0tLdk4/sK40uhwJsqJK6rardiSU8eMlvPCstAF8jws7vSA+ggQNRft/1Ws3hf9sGJHyXOm9bmmQx+RgUsdgoNkcVKg30heQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHCcdIzaous9CXwb9h4l/wjBH1qiDUhUVfoniCBGMXk=;
 b=TiMrgMWztvdKvjZcF07UH1vc5Y1YS5CoP300i1qBjRKyHDaHC1kwf2zUmwmRLB6HKp4/Q3rgY5glwu697HJhjSPiOev+sjZQYL1BNkjVrkpCKLAJ11POwEL4YYNHecqPn+XWviS20iG/tVcSTmi/sjFypsCK+b5B7wKzSApSbEg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Tue, 14 Sep
 2021 13:43:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 13:43:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v2 net] net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup
Date:   Tue, 14 Sep 2021 16:43:31 +0300
Message-Id: <20210914134331.2303380-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0005.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM0PR02CA0005.eurprd02.prod.outlook.com (2603:10a6:208:3e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 13:43:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 150e4280-9e60-4bf5-9c16-08d97785aaa0
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7471C2A279DF1B838F69FB72E0DA9@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hakBoB2q9lkfeAuW9ErJieUkytUkWXEnRxLj7Qe/yk0PwG69tDFpWAqEZMBboWgucVdRSiECovVKCHF/5EwxaRLeDgdbgKbePd+y/QYuDZBDW4QzNWUqKQiJC5FJtrCGJ5RW58ZRa1C8mDQL9xNbpfa/hf1JLrddhemBmugj7i6KMzu/tuVvaAU/RV37fLSwqMYpPrcp6DnETS8OxTOXDEl/NlZP5FS4RaU2gRmEo6pL5XNHMm4bWgrikhcoC828YxV9YojZIZuB3ZKZme2pcm5t4qQG7uPfOt6omofKxnYl+SYmNp2eNF+dJNsUc56/3p0pmY4DsEBvNvVdnSErFhKR3OsGqTUTSRcuGc7OMiVrHDMfdwknL6huo19+x12ma4NiGyv/8qM/+6RrlkkbnzFA0OBwCj43W2K7fmdAWFlg0ebtIP4tb+a4jB2k0Fn/JqydUnIxcipD+I4jxOZXkVj69q54+Y0xdvSKE4ZBIwA85LppcEEtJoq0hWFMYHl3MLzPPRcEbxUsg9/8RyxkX9cLMo3J1not/lGq98Hpt4ruW/fN5CIony4/rWyTnW1kknJID7JSueb6lCvRYi8NU4g8lDHppbJVFaca+Yq4GeQynNmUCKxbkKFeRAqSIgBaqHE3CA9LcUnuuWH3pNymnhLKKqarJn0oiMXy8kOwA7wU8RDx2S8BMOmPXPjPS2ZJr3hzgDbdMLHHY3u2zzn1CVG94jPC2jfOA6pO13aXrb28Zj1Kh4NvCQz1mBnOgbYmxQJ7qWGPGaXcDYVbqonQq+PHapWCYzGmVC+UdrMKdDE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(54906003)(5660300002)(26005)(38100700002)(52116002)(6512007)(38350700002)(4326008)(966005)(956004)(186003)(6916009)(478600001)(83380400001)(8676002)(8936002)(86362001)(6506007)(316002)(66946007)(44832011)(2906002)(66476007)(66556008)(1076003)(6666004)(2616005)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fITAwDC/dMsEkyo7KIRKdzHN2helagypHD++qBJIlW12/p1aOMteDAoYHXpt?=
 =?us-ascii?Q?BTQNn79h5zupGme5jSSQbNtzjS9VFPGsV5HC12iMN6Rsar5Zj1EuO5lYb0jQ?=
 =?us-ascii?Q?RhfU52ZM9PAQtSVSxnt8ElYyKRCRBDq6FDSlMxo6BFzwQtm7CJQi87tcED6y?=
 =?us-ascii?Q?9F/7mlw9oTcboESaxE1SAvYJISS4p9GA/L4+f1mvUfY6r1AHJa+y389oY44l?=
 =?us-ascii?Q?5HsNhmtjlRmwiKjlCKgS+jD5Qsaf/zWJK3gnt8UUd4+Gt8KtQO+MSAZvTzTk?=
 =?us-ascii?Q?NkFq1b0ragn5a0MpF6p+tt40bxF/NqrpxYwjBUe6pKSTr1IqB48YfbN5c4Tv?=
 =?us-ascii?Q?Qk85pj8oP/fNzcYCcTLjbGlfel87usdzCwKzxLrvjlqQOrgvOqw/IoQ+LqvV?=
 =?us-ascii?Q?xySyoQzk3tWHpJM6gR4QgOiFcxkKHLBYqQ1oic2NV9e9sUGIDVY7MzOdDv3c?=
 =?us-ascii?Q?/QHY1xLGIkByWX+CkMtkro9wXS0jD5PhpNnU2wRE1S/QYG+HNpmfcWf+7sdg?=
 =?us-ascii?Q?cz2/TLMlUG+TeB8wuiEmxYSWGp+VX/KSEYtqWOJU2nBaZ9HMQ6Jtn1IjzBxy?=
 =?us-ascii?Q?MCBEuF1BLtXTt5AJ0az8uL0Gm7FZeT4NOwfaQ7s6fbp8JKPpMaS72PETdGMS?=
 =?us-ascii?Q?5xtsOMlfvMVAOipvigZEV6AfeCnLiIIMJ790JJwfHjJIjfYHM5fc0WcPo9dk?=
 =?us-ascii?Q?wNZ0CcfMqlBt0lrkaelkqAtYLPxCHtDExDfPCJ/LLgTFQH1vtbSp4Gu87a81?=
 =?us-ascii?Q?51vHAYYUl6dsmjeej4Y65UndUGvayTt24OSzZ1hOrpUHUNBgz4vlv2X8kMhx?=
 =?us-ascii?Q?flCV7B4NwZ5knLCFBQ5G3+5/CJAfpKKB2Oe8+jnXxtPOm01OGEbSBW2LTAdy?=
 =?us-ascii?Q?7elCNwcJsSxiAtq9ji92ql0yk7/y22pMtrPyAZrE7bq0wL+HfEykpEY18Zyz?=
 =?us-ascii?Q?5ZM7lH5gk9BuNY9ULqxoYi+/n+m/NHNU3pS1FwpoctOjge2A74qRZhIDk3lW?=
 =?us-ascii?Q?HuLDbClzbbjFijh4P1lEL5A0NAU6W4pEGsOhnOZRpB5APPnLgt5rq4b0rBBb?=
 =?us-ascii?Q?S2b/OkE58P+BdO/vhVQn2+A1itvySq/bbH0x2gKidTQEYuQLnJ+3ArLdCkLr?=
 =?us-ascii?Q?WwjQut6EVHrSDiNmFtPysxb/sbFbhFaorDsFu2/xxOVUq/OhMWRjNnJS3GgL?=
 =?us-ascii?Q?kapE5pf4hyvkUKAmQJK0LntVGm7Yk7whQzidHag4M8JyE4lX6skWBD7aI4Xc?=
 =?us-ascii?Q?5me2VePxRPBwTxffC0K7zuTZ2pPF5lxoDRyAaC+TZ/FyRhD9P4HUMAV28QKw?=
 =?us-ascii?Q?Jtp6u1kYAjt3+AMjYprk/5dS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 150e4280-9e60-4bf5-9c16-08d97785aaa0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 13:43:42.9332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TBgEkTJJ8gielePGU3qHcK+/mLWyWXaaa9ED4vJTrJBr9DfGxLV76IDwivTfwabNuV+bbqOPaTtNS5Z3RAZCfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA supports connecting to a phy-handle, and has a fallback to a non-OF
based method of connecting to an internal PHY on the switch's own MDIO
bus, if no phy-handle and no fixed-link nodes were present.

The -ENODEV error code from the first attempt (phylink_of_phy_connect)
is what triggers the second attempt (phylink_connect_phy).

However, when the first attempt returns a different error code than
-ENODEV, this results in an unbalance of calls to phylink_create and
phylink_destroy by the time we exit the function. The phylink instance
has leaked.

There are many other error codes that can be returned by
phylink_of_phy_connect. For example, phylink_validate returns -EINVAL.
So this is a practical issue too.

Fixes: aab9c4067d23 ("net: dsa: Plug in PHYLINK support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
v1->v2: broken up from larger patch series:
https://patchwork.kernel.org/project/netdevbpf/patch/20210901225053.1205571-3-vladimir.oltean@nxp.com/

 net/dsa/slave.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 662ff531d4e2..a2bf2d8ac65b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1854,13 +1854,11 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		 * use the switch internal MDIO bus instead
 		 */
 		ret = dsa_slave_phy_connect(slave_dev, dp->index, phy_flags);
-		if (ret) {
-			netdev_err(slave_dev,
-				   "failed to connect to port %d: %d\n",
-				   dp->index, ret);
-			phylink_destroy(dp->pl);
-			return ret;
-		}
+	}
+	if (ret) {
+		netdev_err(slave_dev, "failed to connect to PHY: %pe\n",
+			   ERR_PTR(ret));
+		phylink_destroy(dp->pl);
 	}
 
 	return ret;
-- 
2.25.1

