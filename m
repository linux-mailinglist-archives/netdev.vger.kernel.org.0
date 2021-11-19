Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822E14578E3
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 23:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbhKSWqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 17:46:30 -0500
Received: from mail-co1nam11on2117.outbound.protection.outlook.com ([40.107.220.117]:22881
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231231AbhKSWqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 17:46:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y57LrukPSUZXN682GRucCoWI2i0476pyH8FU6W3tjFJR6mwcP/qPBX/S/141bz1dGZtW+3hyN6tPre36s+chIlaXtSMyLxRISy2PsAoWyKwl0iQp5/Zmr3/kdPy/i7km7vsVs4SY2xn03BuNkJEatG9otxkSs6IsRER8dcPJNOcQyg8UAZp0/VuR/hnkiI7rwcP73Cut9GzvNmnpPudKnRIHjQ5H8tB1T2kepGVqXAdbEPV56E9sLuraca9avKG6gE5OeFPTn/GEzhGUWuzT6FReq683wMe8wk/56FKJzq0k+hVYLOUoxYk7Do+CgwN7KeFsgo1CpSTW+c4+v07GAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3Zz4d2L95f4U+ta1PckduowNTdDByYB6IOALWxD360=;
 b=EPpV/XUlgVyk4vfN1WeYdyBjQS4jyE5RqY+hYXkH551AMmkaFbv/g+HDAVEmlScS9COhHEFgwfcOooD/+HIQZwhkDO0pTHgwt8/MZwu4yF6n5m9JLWv7pSvzcmQv674wQFK06EuPoL9OsUuGYcr+Z24zpPqPe6c0QeT7CjvxQ/ICcrhclh9WD9rR9qHiSndYvi453JGwsjlcIjz7D/aXDBWCQrrCgSYUiR/fPf4V3yu3fxLVBYJRiWYsY4Xvfqaq3A27YgjvjCg6N/ZfuKJqff7B7ukCp4Tk/nBBGTSUX1QxMLvGQyQYANAwkAGf7tURbEixao9Xe3j1rjp2lLou7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3Zz4d2L95f4U+ta1PckduowNTdDByYB6IOALWxD360=;
 b=iMpHC9bS0PrngnDzraR8smbdRTAlNXUr+ZfMrEE6jfHPKb6/WtbZaviWKeU2WGRuHMvGtzqKvEvuIJWkh6D0+2mukUxNpNojt1WYODT/2danhYlrymIpun0IBvoFnCml1Rb3xHX0QRVm+nig2Wkw+++W9jLO9XRUhLR4CRNZnBw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5701.namprd10.prod.outlook.com
 (2603:10b6:303:18b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 22:43:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 22:43:25 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v1 net-next 2/6] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
Date:   Fri, 19 Nov 2021 14:43:09 -0800
Message-Id: <20211119224313.2803941-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119224313.2803941-1-colin.foster@in-advantage.com>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0061.namprd19.prod.outlook.com
 (2603:10b6:300:94::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR19CA0061.namprd19.prod.outlook.com (2603:10b6:300:94::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 22:43:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02a61b92-4999-4837-3a90-08d9abadff7f
X-MS-TrafficTypeDiagnostic: MW4PR10MB5701:
X-Microsoft-Antispam-PRVS: <MW4PR10MB57015DB429DBA9BFF86AFA80A49C9@MW4PR10MB5701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HNRLawthGhc32LRUZarXA9UQuZneji8uUYSC/xK80TB1x4oGbzptuUp6GBw/gZOfGdwcoVqSvj5T/dWa4pGjbakRfi2ceWKfWemA3J+Jt7NPUuiJmL6sOxQCNAZLvY9B1o2EouVXz5b/TikR9MzGUa8CnPIVosaTynxA1pLXyxV5XDyCo6z7vkBuaOfOFHj8paccwENPboWobAKGqq41Wvr5Emt4zX+6AA0Iw9WU+ZZCbtgo9tRBrxmiHMvje+2DEqYC6Uq241ZDiJDb2jOL8Rpzig+X9d1YBbgzGQDxJSKeiZHrRT8qOmoB8w6B5S0m2bWrR5NKOhcK/lnaLaadqF6DUKT8Ig/EFONB3fzU8a0LSVr9+uIwyUKvlvEpyLfovECU+5hCdGvVvsWWpdOP2w/5MkjDR2t7bBKkDYgYBl8C3dYgG6FomL02pxbivUesWGa57mFE8wmjZbt3tVmhxF0xN5WnsQFrJZxAGNDGUYav56w7Mbieizjx7sm98P+salvMy8Y/nEjvDPNozyEn3I5JL28cavoNvOC135CzjAhy51V4OGsqFOp8sqKUzIoWmbrmCy67kXvvKumB0RmvNroThBd7d+X0+fSA4xevOway/CG/kb6umJKsWScZQ93Bdr4SJV7GKavot5TDuziUjnk4UflsXM8aNdrwnBwt5bZelhGEvA7dN8xgJ/N64ak/Pjaz6NExeIiZWarfoJ5KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(396003)(136003)(346002)(376002)(316002)(36756003)(44832011)(8936002)(8676002)(6486002)(4326008)(6506007)(508600001)(4744005)(956004)(2616005)(1076003)(7416002)(6512007)(26005)(86362001)(66476007)(66946007)(66556008)(83380400001)(2906002)(38100700002)(52116002)(38350700002)(186003)(54906003)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xNwn8ti+dqTu8zKwSm9ZmUZhR6DD+8XW9L69tlJ6f41MlKj6osfiyYdV9Urh?=
 =?us-ascii?Q?+whBivUh0lAbpwwl0P3LgFIAlRvCJZpYOX8Xt8MC7QEzBZFaoSqUf24ilpjD?=
 =?us-ascii?Q?mVjkT8zC7zeMUkWYoNs18LXsCQJoemJG3C8yhpPuYS9VrhXxoJN6EofKqKFm?=
 =?us-ascii?Q?NzekzqABa2tOsv65jX8iQNT3/54g4PTFjuBZRAOrRwYQ9eEwttILMdo8pBeD?=
 =?us-ascii?Q?Y/vm9NrywSUlQME1oKZ5b19ePPuVeX6FxLriIRCy2O7ukAoDb8oQSbZ0pSCm?=
 =?us-ascii?Q?QKUyij1C1oR6WmKy0taZECXUyb+V1BbMonsQfpHtfslqmy3k1VOaS36dBXrO?=
 =?us-ascii?Q?BS8jymYK/70sgkevwpQk3XQCTvwXbM1ANoPqfs1wEOYNHn85y0EHF3G7jHAW?=
 =?us-ascii?Q?olm32StHd4/RVNAx6PjiVXKfC5GBoZdWvqwpkn0AWWMiDmofB2UF4K05KLBP?=
 =?us-ascii?Q?dStwy+XXwkPjME2h5YlqbOka2rxjhKMxF0YUuDF0qD6b2TShg7XQvv25yGFS?=
 =?us-ascii?Q?qOBtpZxM5uVdtk3QtXk86dy5/tkzW0XnD5PWXm2rGvvGJoBFSdqxGHr3yDc3?=
 =?us-ascii?Q?veGMXCqmzXi3vKw1sdlBDMr+oAAytdWTJ7uGasVsb0U+gZunt0x5QeJAUA4u?=
 =?us-ascii?Q?dX69i3m06b9Li4YG4YSJCrf0UGiuU8wtyM5CiJLEKOrjXjZ9dSC8s8AUsk8d?=
 =?us-ascii?Q?ggKgmZE07o530HBmOf3Ty0pJ7t+2vrZqC8boMpRHgzhFshyckASvA2mUnmq5?=
 =?us-ascii?Q?zY/GReU0JjbOPRyeJ6DBBKvSFz8Dj0COtdUMlH4MFAoHFLKpUgY5ZY5Uh/q9?=
 =?us-ascii?Q?qxo/dTVjcj6Yb6U8zMm1LZlqiQ5lTlNTN+Y4b301vYNPxIGStG9h+t9BV55X?=
 =?us-ascii?Q?mDc0Pab/vhQVPd7/mUFsgwo/mOVxzBCg2KFwHd8JAFqDA6r6XbvOsnUGuUtb?=
 =?us-ascii?Q?X8ik0z0rEYAOQC1Ho/SS+1eH97PbahpdgqAMMunfcMvTEoXtfAgtMhIFNm/N?=
 =?us-ascii?Q?Lu+cTsa9Fe+fZ9Xa6dRPK9RaM05s44aV244wR0U4lHMWaKvoHwkxJBVUNA+0?=
 =?us-ascii?Q?LwsJGJESAseJuC7S3GAMWg7K/MnnfNk1XFBcNxW31K9iik16tnKrsuaolS1Y?=
 =?us-ascii?Q?rpKBUruuRyT65WxGTih3tE/HBPMpEsMlFD7hwBo6G8mkO5ee4vJwrHNQBc1R?=
 =?us-ascii?Q?+Ky1J78fQsVQDO427zkbimcMXPX6ggenA5zaT9j48uKg8R1dmrNfHXBKCpMY?=
 =?us-ascii?Q?Z0bJVub72Tn4MDIUvniqYjGflgZ3/vt9ojWdQJ+ZUETMCCk+yYsOl+1MI/rB?=
 =?us-ascii?Q?SZQKKWZJiPgqzHMdH2XE2H47YZj5WDsuJZbEagzK3PEzxWG0RJeDxOcUeVA3?=
 =?us-ascii?Q?3rTVE4ve+YL5iVJS86wh+kmypwQs3SZYacWV8yJkzOHCXKmb2YLPKFMEsycn?=
 =?us-ascii?Q?/0sApMMHcu3aKvGjhvJ8Fyjx7MZuwW+YsV6PRPQWJxq4e6EfKoTb6ntY0mKw?=
 =?us-ascii?Q?jcMXsbtpz6G7oWXl4W+I0GxcENJXAuQWgWR/QSkpu4SYfO+4lrm4U0fm9MVX?=
 =?us-ascii?Q?H6VdLZpvlp7yETm4FL+Ef182N5//r5MYhSUx5TTrLtqmDLG4zqHBsy6s7UTB?=
 =?us-ascii?Q?nYG9amFyvsEjpE+DGWC/6XKJPeQOrONZrpvRobDr6xLH1qIlgfL8z07hW5h/?=
 =?us-ascii?Q?T6WFlOhqyl5ozFRXxhYEaEKBjTE=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a61b92-4999-4837-3a90-08d9abadff7f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 22:43:25.5345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QKWFqjTPmscBtSMSYJionEtP3WbUiyTGt1aTn3jpiL668PQP1W/c+L1hasmFDLRJbqDgYUW1KncGB3UFgl67qbgotpskB+t5hTxZlXHmJjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing felix devices all have an initialized pcs array. Future devices
might not, so running a NULL check on the array before dereferencing it
will allow those future drivers to not crash at this point

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e487143709da..7b42d219545c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -820,7 +820,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
-	if (felix->pcs[port])
+	if (felix->pcs && felix->pcs[port])
 		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
-- 
2.25.1

