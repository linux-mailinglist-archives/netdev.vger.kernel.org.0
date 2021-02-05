Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA1D3115AD
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhBEWik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:38:40 -0500
Received: from mail-eopbgr10046.outbound.protection.outlook.com ([40.107.1.46]:8928
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229986AbhBENjS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:39:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQDpphT8/oiJsvwYs8Zem8wfA82yqNxDSMMWp31hfgD8vrdUQHmyV5wlRFtiq3W8lRYh5RQm5ButYJ+oTqVSySBMpE1+BGAZj1wai4oBHW5IhuiPIPIMiFKqSgmeh4BkK4em440mCrp1GNthWIJEhesgkHRHHAdklkCSdXq4Ca2SZGIxLkh4NLN+4jx6WLlrldybkjZS6D9PVg/ByduiD/EgNy8MAAWQMxlCYeyyjOpsl7omsfPgj7KWls8SzdXJxhC1Ifchkmck62Czxe8q/RKKrKR/WKfv8YtOnaX0vj1pN4bWpKg3y+h1kaDUvl3LIwGTrgj7WEEAgvVfcJR+PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvRbS3Gpd3VeGd9jDJi49eRbcej/hdmF8GvNTExog+E=;
 b=JgBv9P4PZqIjBgkKF0OPGWR3OLs8ZJbeMQzSMQgPOETpIcGk25Zy+4ryxn86dbFFK/aDcSISlO6MlKLCNCDAbePjiCfNWK5uwzHN7jethjcCJbJTYkXFc5mgmkbsn0GjLLfTDhZbxl6mMM9+JzRZyN7PHx/31Nn/8zL6Ec4IvpmbVxnQ7+tgkmDVId7yEKPWdOZ4pvBcefWsdp+xZcCgFjX1HvxkV3fLbnttX1TjrdDMqdpqUX3ity3fh66KatyFtj14RtsrQlr+nCDpovogumccY8F55xieYxJBe80uBphAdCQUuwWBOh73u7BVuGHPPyeTpDKjLwIvnLWO32TU8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvRbS3Gpd3VeGd9jDJi49eRbcej/hdmF8GvNTExog+E=;
 b=ZMxT2BSXS8aTqZrgOvQpiGNSWVu0Rk2/2M/3/xF+Js0L/TP/wR9ubBMavu4mAOni4DCPcsCHlcNjpZOBD3xM6Vji/HpPw5S4qWqE3B/qPb/pUDQW5R414bB1JTe/+MPQhRmdpS15VVvbEW8j2m81GE2NaEVoiMqOODKgxM2pyWE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Fri, 5 Feb
 2021 13:37:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:37:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v3 net-next 2/4] net: dsa: automatically bring user ports down when master goes down
Date:   Fri,  5 Feb 2021 15:37:11 +0200
Message-Id: <20210205133713.4172846-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205133713.4172846-1-vladimir.oltean@nxp.com>
References: <20210205133713.4172846-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR09CA0138.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR09CA0138.eurprd09.prod.outlook.com (2603:10a6:803:12c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Fri, 5 Feb 2021 13:37:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8b549952-ec00-498d-a747-08d8c9db2e07
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-Microsoft-Antispam-PRVS: <VI1PR04MB49105448C4E83C9B1CBFE80FE0B29@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8lENxtC2ITizsM7q/KEE9SWgLWzMCf9C+EbT8W7pxWtGTQ6Qzv1EVi0CVOYQu2Ls/35JWGitcn8aJN9SySLedklMtJd1SNVu9R1n+yv9gMhYIfLiPTwB3Aw8K1j0V99fqp7Ihcbt+xDxufIBAopl2MJfljVsuepPiNrOuEA1qrLEvIuoHJYF/lDsfFBe9xVwB2B6wAI2HH5mUzF73m6QDpSJgLAZAvAJQBdBQrA2/GYmwn/jFs+p8dhiezmG+CFejKxFu6cV30hiIblzTtX0Fb28YPVpRvfjGzopZFspjO2bjgE5+EJrWbEVQMi75EerC6ft5Xdz7mnoQ33IhTxgZSX9ujrkJFGjZnlIqBAlR8uHF+0I11cBT6lxBBdFbbZZzskA4NvVrrIA/FMu7LQ3wxG8yQtw0oaSXJHG7W6v0qglPmRqAcJOZFAnVZL4QKuDRdmz+gK7zEaNjdOxdKfVDIQbX8adrQ/+93i8qeNIDEk/0uT5HczKRsbXb3uIoRChTgUGc6QMKFpImiGx/isFyC8sA2KapaHrMT0Xy9qcbCHvpoHg5NiKFHP4Mzbp0fD3S/LtXq5jQ1CbBCWAKROyrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(2906002)(16526019)(5660300002)(186003)(8936002)(69590400011)(8676002)(2616005)(1076003)(956004)(44832011)(6486002)(478600001)(4326008)(54906003)(6506007)(66946007)(83380400001)(86362001)(66556008)(66476007)(26005)(316002)(110136005)(6512007)(52116002)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?y7BS87z6m4UllbZh9cB8XQNjOqipzQLD0UdaTLui/SeDmVdRDYn4c13UhZej?=
 =?us-ascii?Q?AZv9CtzwyRLYznEz7VB27zaVU2NlMg0ENNTyYWUy0EbKRlCs0R5Pe7JxbmN4?=
 =?us-ascii?Q?XpGrRdHn3vlDGE/SCGXONYy/585Uk4obtxIkR8E2MQqJ3lz4c5dL2csM4vZS?=
 =?us-ascii?Q?0Pjf0b3CNLbE+ARy/QnVYOGsSV/BfmQsj4zraHWdQbY6RzV2PSWLsE6aT/dv?=
 =?us-ascii?Q?5bb9/1yqh8aq+zAiEe8+eA/TOXQEE8RXq/L7XzlIfX7016UC1q/VH8zqCFZi?=
 =?us-ascii?Q?Q2YRDN0IAXKZWnOmzdW4MWDjMfKy9RqRZSHo5omXaRNu/FOuvMGHvjJ+izga?=
 =?us-ascii?Q?Dma936eSEr/CwZA03VmuEHmM00HPut1A47lHkToju9aUivfD7FHUu0TgGTg4?=
 =?us-ascii?Q?jGLOCZmJN+vzJ2J2cJJIJ/Xg/BbQcwH+lLkRfvwR/BtyRouud3avCQARnAy1?=
 =?us-ascii?Q?PWZ+9J9Y01i6GFuerHUJU+QF7WoCNH66kQBAVPS5GElAvw2Ax2hWvFi81wMd?=
 =?us-ascii?Q?AE4L6ML38UtFOcrXPq4dx4W9VGnX7Us7UWAaY/ngNdvNgobBbINekGe//73V?=
 =?us-ascii?Q?IGA2cBTn8rhb0Yulu1JznqUXpvHMDPceOpjeD40cOgbzii/zc7G5WT0vXK+e?=
 =?us-ascii?Q?gTeEpbMFdjGAmSoZF6B/Q9mnhfhXO/vfEuv2JLxpv28t1xbFjluoiuLXG5/d?=
 =?us-ascii?Q?7P3epfv9hjuLHrbW/nfZmTRyB3YebkL/7VfsZNPnRr3qsl3oq8b6INsvyoAL?=
 =?us-ascii?Q?wg+o+ZylitDw57yqZiBmM+VyVXpKIhZhrGME+Byrkom5xsAI5EqmLyBImXeb?=
 =?us-ascii?Q?WFdCxQUjU1Ix2J8PjMSYuZoOzaekaFk0yaKbiofLcTXN2FR57YIKVl+LQdL6?=
 =?us-ascii?Q?m+7G6aQUtd7EpdVU0uoB15mquurf3qie/KukhkD3O+a7VC1Xw6u1Xy1LzSg0?=
 =?us-ascii?Q?bsQkGyiGpCGVoNRKlKQkHxxhHfD3JFp1a8MeJEFcthTuL/JBGBASxJ7Bz1mI?=
 =?us-ascii?Q?s/ClZpaBB0wD9SCCxyK3D9amHqXxDmQgQhHFePL9/Ns/H5DtnTvtVHeSoue3?=
 =?us-ascii?Q?GJbiNuTgLn197JJL3Ulb9OnrTBvILeEacTyla1qwT2vmmj+N026aZN4LROfQ?=
 =?us-ascii?Q?VqFW59O4C46V7Bj3Ib61iiAMCz0mQp8NU1/jjrIyQLE4KjgFeCYud0XK1iMG?=
 =?us-ascii?Q?xHQTjJpsGfWsDoXMw4ch36bkrfReA+dTBAz5pxQlPi/8UR3U9B1hxi47VoeT?=
 =?us-ascii?Q?JgMyTGfCR18YfrCNk+zY+ZMTdkf2kAXninOfcaswfsz1q7b2yNc2LU5wHFS3?=
 =?us-ascii?Q?PID00/1z6dlVAUvpOr9lQ0YM?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b549952-ec00-498d-a747-08d8c9db2e07
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:37:28.4357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oYDwezSZtWUT4ffOMoGOBDq+OP0KB6ez1jnArOAHH3cDS6XFO64AlqAatjfkin1aylEblbyeoEoHKgaBf4u6dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not fixing any actual bug that I know of, but having a DSA
interface that is up even when its lower (master) interface is down is
one of those things that just do not sound right.

Yes, DSA checks if the master is up before actually bringing the
user interface up, but nobody prevents bringing the master interface
down immediately afterwards... Then the user ports would attempt
dev_queue_xmit on an interface that is down, and wonder what's wrong.

This patch prevents that from happening. NETDEV_GOING_DOWN is the
notification emitted _before_ the master actually goes down, and we are
protected by the rtnl_mutex, so all is well.

For those of you reading this because you were doing switch testing
such as latency measurements for autonomously forwarded traffic, and you
needed a controlled environment with no extra packets sent by the
network stack, this patch breaks that, because now the user ports go
down too, which may shut down the PHY etc. But please don't do it like
that, just do instead:

tc qdisc add dev eno2 clsact
tc filter add dev eno2 egress flower action drop

Tested with two cascaded DSA switches:
$ ip link set eno2 down
sja1105 spi2.0 sw0p2: Link is Down
mscc_felix 0000:00:00.5 swp0: Link is Down
fsl_enetc 0000:00:00.2 eno2: Link is Down

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
Using dev_close_many as suggested by Jakub.

Changes in v2:
Fix typo: !dsa_is_user_port -> dsa_is_user_port.

 net/dsa/slave.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c95e3bdbe690..f77e9eeb1a62 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2081,6 +2081,30 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		err = dsa_port_lag_change(dp, info->lower_state_info);
 		return notifier_from_errno(err);
 	}
+	case NETDEV_GOING_DOWN: {
+		struct dsa_port *dp, *cpu_dp;
+		struct dsa_switch_tree *dst;
+		LIST_HEAD(close_list);
+
+		if (!netdev_uses_dsa(dev))
+			return NOTIFY_DONE;
+
+		cpu_dp = dev->dsa_ptr;
+		dst = cpu_dp->ds->dst;
+
+		list_for_each_entry(dp, &dst->ports, list) {
+			if (!dsa_is_user_port(dp->ds, dp->index))
+				continue;
+
+			list_add(&dp->slave->close_list, &close_list);
+		}
+
+		dev_close_many(&close_list, true);
+
+		return NOTIFY_OK;
+	}
+	default:
+		break;
 	}
 
 	return NOTIFY_DONE;
-- 
2.25.1

