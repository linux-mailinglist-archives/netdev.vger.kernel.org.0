Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6002943CE9C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhJ0QX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:23:59 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:57505
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232596AbhJ0QX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 12:23:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ao+ybp4Kwza66I9Ba8FY4RNNOFCpyAflUGRZIvbH6yZVS+D/CtiZjsIFjVDB8wfEFT4/vA0uE8I9QTU8sCs9UUmiGxtVP3sAeOkudZiyUXoiQdNfbS44scAs2PHuU8GECWlMXAqm/a3nIAlAP6NrJuMuvX1HuKdd+WAm2gF0CFxcDPRKppvp45b8h2ECRUYySIQxN/WwE0Gx0wuJNUYaC9mNOHrAayTmKKzKfW3O6nLLzyAH4snn/ezAOEfQvgqkSxNTAjmsLlHPHFdgtIbKOlT+BXOzAO3YotkWWtoUpiTqFD6kSRsmb1feRsj1anHrp8tHQcSjrWSdwzA3vYJaSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzAq1RuvyHK227urbmbFZg3UZAK9EukOguEOSSymSaY=;
 b=X/D4ZM0nu2QZYooreOEyajTRNJw227eBbjIWFmG/TZaEbZC9Qhvfpr+v+zxs8KI+mueBySn3Vf2xrU+4FMs12CjBaJGv4pBvc0xYF5ZeTU5lQP/2Oxvrj1+0ZfxarxXiAZx/KFXMqqBpT+CJj+H1dv/m52IuG0q5chalCgoRF7CpR3t9RFZOSuBvIFuvvof7YKJsA0WwioRCLLqHJLrk14+BYevivTBvK8WGD2TZZ3vyhyKYg1KNpIbdFhl7GoDBbMazb+VsLPWtsQNjA3JOvodtoCUSZ3BV54P1Io1gLbPq4p5cH/Wm5t6gsOYCX7gAXw45PfwDWlz/r8K/iz/ebg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzAq1RuvyHK227urbmbFZg3UZAK9EukOguEOSSymSaY=;
 b=qdo/eGgeGYcUWQQmyg7tiEBDlaZP6/aeeDb3pDkZIhoYd7hnLgFDJ1rqRdb4fNqUKEs01MVQ9oaX5cYLLGukOpSvMFKBTPLjv/Zgor1XzQKfOZzXLFr3CC6MBrg6knJTGJpffEbjsr+zukdccnwCcPVp4gw9dCGUPe20s67NJyI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6014.eurprd04.prod.outlook.com (2603:10a6:803:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 16:21:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 16:21:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/5] Code movement to br_switchdev.c
Date:   Wed, 27 Oct 2021 19:21:14 +0300
Message-Id: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0057.eurprd05.prod.outlook.com
 (2603:10a6:200:68::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.175.102) by AM4PR0501CA0057.eurprd05.prod.outlook.com (2603:10a6:200:68::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 16:21:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62cacb64-3908-4d71-1fa7-08d99965d4fc
X-MS-TrafficTypeDiagnostic: VI1PR04MB6014:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6014E8CC1CC1C745841D9354E0859@VI1PR04MB6014.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LlxTSupr2NUdC0/Flx9NLpZRpOsBTtEJbcRbw9fTcM9ml0G90tFJtSo7Tc31vJn2kgc+4PW/8emUlRKnYWFQwSGmRGDqU6jCkKVwx+v4t1IOC52QZwVydGaX0a/YjshgUtpDbDhaK+T0htkhcWGnEZVToCoNORi2V02+XYJG4dMJEbCrAWNOkgji7HRtCuDwzv4kznQbdDX/Yoqyzi4uQD2SJBdpxV4yWdmnKTJDMcpCNJGHv3V5AwOS6zPJdXOg63oaAxX/G9iedLR1UPTnEMxz3q90Bo11iNlKCGgGmytFMM63tFQxJYTAR8gHAA9suLJW/8Ehs1lmH5Vf0zBRNVEixilBk6IbgERKi9zsWaQpw33aqWExCAATVljE5vGQrVuYWMsSsaYlm8kvyqSqwhYJe1cDL6QPrSNPMRjtck9BvFBngNy/gwveYJePjpIfr2pep+BAv+R3WPxs/jfASxDZwPfs2DltpsmSQs2bxd+ImQM0FGM1iQQelTTgLqf9afXbrnK03IMKQlbbbwX4F7OlYZypoJA+oNuB1QqxooAZFZhASuxMICCDs1zNgDPLo9URzbMddefk5cxCoUMHd/9NPPIFrpJpa6ybEiAXNPdcNWSlBQs+QTStjyDY4x+DQXfT6sNsVBCmtaVvghizDs0tRSsTf/9GRchsBj/VZQarlbEgrq3pIrdYtXl/DzzDJzCcgfFppXSgD1A5B8ssnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66476007)(52116002)(6506007)(2616005)(316002)(86362001)(4744005)(6512007)(83380400001)(508600001)(26005)(6916009)(4326008)(8676002)(66556008)(66946007)(5660300002)(8936002)(186003)(38100700002)(36756003)(54906003)(2906002)(38350700002)(6486002)(956004)(1076003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HYmWmsg6rftmtZY+8feWHZaASxAb+mUgx6RK/3n6NOwos/3JZ6hgySy+Hpwr?=
 =?us-ascii?Q?JxWPRlCfV7fRG2y+Xp1eb6R+KyV7/FiS9goelVKUUuRias/+7ymmdeveYIj3?=
 =?us-ascii?Q?C0gtZBCjzEBy73oUj2COzu9ld0XRzTiqyabQob6sQzNcFZGzHhCe+0QsbNRQ?=
 =?us-ascii?Q?mQ/7tDaJW1JdigG5fHm+0bMrPmZrLfw9DuPeLg6WdyxYk23r4AD2F/FpLb0n?=
 =?us-ascii?Q?6rDU/bC+cReYIQzPhCPb5y7QCC5/CXhYJ6TUIqI/If77s1j3Emjn+2WyI5w9?=
 =?us-ascii?Q?2nZ45vYGtomWqgrY7vpThbbvpnYhoBfhJa0pfNMoj3zgHe/PRpL8Zc8ZmBna?=
 =?us-ascii?Q?na73XVn+7Uy5W8oIYWKQ+YYFM8g4DwKuCJnOabVlRLu0bBDAVFfHv5WM8tZi?=
 =?us-ascii?Q?LyKNFm/kZVyIzI38ype8lb0uKTIvnri7CNw0VX7GLWD11p4oGM1OOP433F94?=
 =?us-ascii?Q?SN8dmKuQFgHntn20kEdYUZW6xZ+ElFikEtWhNJemCH83AewHdqv4cFef6Dq0?=
 =?us-ascii?Q?JBZgqQg4vd8PM8b4QNHqTMiY1j+RACTjjDokjsyUMt+2udBOoohWdk+BG2ck?=
 =?us-ascii?Q?wPJymv3k59i/ocyG36onXV9et7ohPdSnK4rl9CSXeO28yDF0VGFd+aqiy1ks?=
 =?us-ascii?Q?53kqzwfYWuGmgWDomEuy3ZPu7r2VQ29ST4wMwXVr1sVJpSrp2VOpDaMIa/jf?=
 =?us-ascii?Q?bPdSz6Pg081MHv9nNoskbRpC+xvOh9qq6FANhBCp1nBCNkPg1LrBYsKeooty?=
 =?us-ascii?Q?UzwjMrBHoNvpPB4pRE/rVxgPGnF+0wWSZbSTE+DIQQSdeFLgzan+mobdDxUB?=
 =?us-ascii?Q?DXNj505nFYh0Q7D8F5NF7wMK2yJ7AW52ejY8vYzqZfUuNIp6kmD4U6eSC4yG?=
 =?us-ascii?Q?Ph5zFNwnxxqTH31F9uOSTpY2Y5szsZWT/zBQNTkZtiP99M4CPerIuscOIMc/?=
 =?us-ascii?Q?guKuRVpm91XQjk+9uQCGcnDcfCf6nWp3ZbUjjkUT78Y/Jkw9c/bw155ABoPK?=
 =?us-ascii?Q?frs9uKVHEKE02D5Lm0qrf5eEmDviZEKLxJeK4SXjYuaFetlKgtP9G3GbStSc?=
 =?us-ascii?Q?V1GQc37yUy9DV0nsoU+VWAkqHMvd2D+IYnGa8N7rTkdTXSFq+QyPflZOw37a?=
 =?us-ascii?Q?yE1dV+2KDX539+p2jMRx9eZ+09mNWWCIIPiU2hxq+OhMGUY3pvIen9wTJrl1?=
 =?us-ascii?Q?cxd/xtvUF0XKq7Zea1liv4E+vaJ9KM3/muC+fdkhtYSFkFl/wrRGgzQu+cQy?=
 =?us-ascii?Q?EVJ5u/OJK27sl7wUc8kVMeVKhNfwSJ2bbfMZ+ZJKANn7KzJj2DSAC4pvJKQa?=
 =?us-ascii?Q?4qy+Vk6xsMkoYeupGaut1uNzpdTYwzyIgfueLNz+D+xgN1IuiRr7u6fg9dXc?=
 =?us-ascii?Q?i0CprKlZyvONSAQzg5rF8t1wlTJDCPXuE3siP0ewhInNqj70vWShUGmfmYf2?=
 =?us-ascii?Q?YjCrsvUqYm86IrR1/lOBhm4P2SnCDZubjsyHQW6l9TEzAxRkDSGpQjTWk4Th?=
 =?us-ascii?Q?YD1RpdpRlQ2kRkWFCOsdcC4WL7ZsXRGpV6AVYB3lNkb9iEaga/cGvByYbICl?=
 =?us-ascii?Q?0ZiWckqTU8AZzXsJi34K8/GCjCPFoHgt7h4uPf+U1xagpktEB3ycF2zqsyJD?=
 =?us-ascii?Q?0kuDExXvOx71Ljkaxo6qIFk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62cacb64-3908-4d71-1fa7-08d99965d4fc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 16:21:29.5984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dmyc+capksAun7pvADNlXyC576V4BNzo5xgkYMg6FjdTXNMNXFCzN5gLwW73I8kuJaRsRre695GKZ5ihEMrb8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6014
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is one more refactoring patch set for the Linux bridge, where more
logic that is specific to switchdev is moved into br_switchdev.c, which
is compiled out when CONFIG_NET_SWITCHDEV is disabled.

Vladimir Oltean (5):
  net: bridge: provide shim definition for br_vlan_flags
  net: bridge: move br_vlan_replay to br_switchdev.c
  net: bridge: split out the switchdev portion of br_mdb_notify
  net: bridge: mdb: move all switchdev logic to br_switchdev.c
  net: bridge: switchdev: consistent function naming

 net/bridge/br_mdb.c       | 238 +-----------------------
 net/bridge/br_private.h   |  28 ++-
 net/bridge/br_switchdev.c | 371 ++++++++++++++++++++++++++++++++++++--
 net/bridge/br_vlan.c      |  84 ---------
 4 files changed, 372 insertions(+), 349 deletions(-)

-- 
2.25.1

