Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4432D0866
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgLGAAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:00:48 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:53705
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727661AbgLGAAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:00:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0GD9odS1BqzHlzfNu7/pfjUBfbcQhvXo1vmvLoGKor9oSrxXoUXcxGE5YzNQKVxx5acfR3uqZVXhrqAjCRCRdAUsFCCDlXuHRuNVpLnDLtRMRoFUYAQS8274jvkGrKAw/Tn1ynjw0M4RJYNJmnXMXJiHzU9cNNa2ddwBtnVI7FlvdTtykcFlAR+dP02Bmj9Pi/U/ZxJ+Rk4fkhnkX9DTjgHN3yF/nU552aOS/9o58x0mk3paqSK9kWj1+STfAuvDdC9p43vd9KXVN+icoDbUaP4QvsHnLvu6yHT69TsZfBfqneJEYfNkE12xzpDvh5drMQvPSUhKN7DxePYNEE0wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzSc2uXk+B9rny00uQrPtEptdCy/bXPB1Qa8fZNCU/c=;
 b=dfsKDeemTmqshChoas4AgKCspi2MZUI+1nI6LUHmRzW8MGtVAyjuFgoaZe/og4BeNzThz+t4NaWjgmcS1xRWhT99NIhOoIES427VdhZfADElba/slbtR/EtAdRxfHFOyzDKjkAbq8hVZmL9KdWHgtG7C2N+/LuGm2dKC2ipeM+RmfL4KHvIRBJSj3PAqTFYXRSYLlrGsC8pwTzkokwm/90rJ9fRmnDdoHMoarA6sGi6/uZNTyAh3UH8qRiwC0fesEyWo4Kgalr0QToup/JcHhb4K/Jy31W6EWbeCQFfpuJUlxwWIPKtAEJ1bw+460ky+hynO3FtWkvlKQA4IUKeofg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzSc2uXk+B9rny00uQrPtEptdCy/bXPB1Qa8fZNCU/c=;
 b=kB209zSesDKpe5jBELUp+gBaHcWGUeSW8dbV2YRW7gsolh7zbtSxNWdGdDHbXV7Uf5/uNspZmvYMJaXFaopwexd4jdesMKVGToiLHPylVF8eOGKJdHcgg3f8FvJnpCRGLwevAEClNWZPTa4ehtt01tVswb3nqqnCQjDmekvqEXY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Sun, 6 Dec
 2020 23:59:58 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Sun, 6 Dec 2020
 23:59:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Leon Romanovsky <leon@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [RFC PATCH net-next 00/13] Make .ndo_get_stats64 sleepable
Date:   Mon,  7 Dec 2020 01:59:06 +0200
Message-Id: <20201206235919.393158-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Sun, 6 Dec 2020 23:59:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7e91e613-46eb-46c7-7b1b-08d89a43093c
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637BF6EC62C4966A8E63A42E0CF0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: seMWeIR1jjklbH6woYYKLWxNRnChfwvvi5pEW1T4eotQHZK3U/d/p33XOgOAOLpSGjRuRotPffPQIqvuTzKAJznBc1lEQy22Mj+VG1OWHMDo5RfCcAuVrUU66OqCtZo43bfHX4EYEvfZm2oRrB0n08cmNT2K9rKftVmkVoTKhuP+6MyL2Eh9903Sm56vMC71CF2hCaNN78pMUe+DL0tquyjVmuwJOlTZ5XDz/5DdMI6zzVnCP1VAkripTpULRn74x3H7kWP4ebuvWy3T4tg1DCkcrMKx5+lkaiV49+YJwedGUlratFZUtG3rINuwsFVtFLJr6kqQhstWaZee0sxXQsCFh9hP/VQQi5fTrvWW1M69HfPcelxx4MLY2n/ZJzExt9+Woi4wjXVmNpd8l0yLn73TFhctn3xMue31r84XhuE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GAfUBujZF/Aycxau8T0RDvJL7pijGPPa9eNQe2DakdYCNwDvcIQjkIekpJm2?=
 =?us-ascii?Q?M0mDnZuvva9it7K3vz0YpwlSX4wXVZMfQLF6L9XJjhZpUB0fQzf66UZ2vJz5?=
 =?us-ascii?Q?bboaceCMCblr9MASWBOf0bvGU9HoxBxluc7m+gXCX1Gx7n3ZSdHU66AAM0HU?=
 =?us-ascii?Q?XyX8b8Rx4Soj5frCyxtWL2HHDllaA1HkYM3ay+QgEvprQwTNS/faKplKHB9c?=
 =?us-ascii?Q?79qUpmiU2r49BEDTeebVVery1P0j/1rie0ZjgCTZJZMDkRwfqPB7u7VrvNet?=
 =?us-ascii?Q?TRkCuven2YYu6ULF30cwJNXPHm467Dc9pZLpKQkLknyCtVgcNKoxwsnQ+D1I?=
 =?us-ascii?Q?TjTbObgJICj5AMv0znUzQ5XlTtJXDnopc484NOKZDmBdowA559aOVH4MT9n8?=
 =?us-ascii?Q?j2TmQ8t0x/duIiqa3RFc/XGTYPgqUIuM7E1GUyXaM7CpUY//zFIjhUZXknQN?=
 =?us-ascii?Q?3ArlIkuA7q9W9wisEIrRlLjzwaBCSbHuRy9fPrrnEuzlyt5WL7zIQb/7rTIi?=
 =?us-ascii?Q?q28ygFQAXdXmej/RILDLCpLn1Ut3HFhn1IjdJxCbuQtYutJYOIcmq+jXWXaZ?=
 =?us-ascii?Q?lA4xZrMx8DVR+02sqDaCaKDMqtUw31CoPawHRmLdkdTHK8VQbCy4hjou52Uj?=
 =?us-ascii?Q?neJRjlaCHarHuNhBfH4sm42ybvJxkz4yKbR3XqT5pNx/P98ONhrQg5wsuAyt?=
 =?us-ascii?Q?6bFSB6qfOYtyaLOaujcad8T6HphC4KolqUTpwaOTGbxWdV2VOwtMBKkADRIx?=
 =?us-ascii?Q?XyRhDSv9dqJUlje3PDr19iIBdTIpLl5j85CgpEispJxQxuVJmP6Ue5ZzeYH+?=
 =?us-ascii?Q?0kAer8MO9/7wnH2FmDv7DggK07q48HzdeciU/2ssW1paxY7ETP2oAPNUvO1+?=
 =?us-ascii?Q?OpbQoKofILPaCNOZulP1M/PZWk/ftLEMvg4MwyHyn1c7Rlq8xNQSwSzQMqoE?=
 =?us-ascii?Q?jHer2eU+fcRgO+UKHDmd4BXmQy7gzD67aTEBSaySrSOUTB2CVdFw6a6B7zax?=
 =?us-ascii?Q?S7YC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e91e613-46eb-46c7-7b1b-08d89a43093c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2020 23:59:58.4038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hLlxJ183ZUAf1s7qpnluVZXJenbSX7tztGCvXO3PPY7Klf3/NFWApugEHd4X5bKf/lRGZLIIuuie4TLwrAuvEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series converts all callers of dev_get_stats() to be in sleepable
context, so that we can do more work in the .ndo_get_stats64 method.

The situation today is that if we have hardware that needs to be
accessed through a slow bus like SPI, or through a firmware, we cannot
do that directly in .ndo_get_stats64, so we have to poll counters
periodically and return a cached (not up to date) copy in the atomic NDO
callback. This is undesirable on both ends: more work than strictly
needed is being done, and the end result is also worse (not guaranteed
to be up to date). So converting the code paths to be compatible with
sleeping seems to make more sense.

Cc: Leon Romanovsky <leon@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: Sridhar Samudrala <sridhar.samudrala@intel.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Cc: Christian Brauner <christian.brauner@ubuntu.com>

Vladimir Oltean (13):
  RDMA/mlx4: remove bogus dev_base_lock usage
  net: mark dev_base_lock for deprecation
  net: introduce a mutex for the netns interface lists
  s390/appldata_net_sum: hold the netdev lists lock when retrieving
    device statistics
  net: bonding: hold the netdev lists lock when retrieving device
    statistics
  net_failover: hold the netdev lists lock when retrieving device
    statistics
  parisc/led: remove trailing whitespaces
  parisc/led: reindent the code that gathers device statistics
  parisc/led: hold the netdev lists lock when retrieving device
    statistics
  net: procfs: hold the netdev lists lock when retrieving device
    statistics
  net: sysfs: don't hold dev_base_lock while retrieving device
    statistics
  net: mark ndo_get_stats64 as being able to sleep
  net: remove obsolete comments about ndo_get_stats64 context from eth
    drivers

 Documentation/networking/netdevices.rst     |   4 +-
 Documentation/networking/statistics.rst     |   9 +-
 arch/s390/appldata/appldata_net_sum.c       |   8 +-
 drivers/infiniband/hw/mlx4/main.c           |   3 -
 drivers/net/bonding/bond_main.c             |  16 +-
 drivers/net/ethernet/cisco/enic/enic_main.c |   1 -
 drivers/net/ethernet/nvidia/forcedeth.c     |   2 -
 drivers/net/ethernet/sfc/efx_common.c       |   1 -
 drivers/net/ethernet/sfc/falcon/efx.c       |   1 -
 drivers/net/net_failover.c                  |  15 +-
 drivers/parisc/led.c                        | 164 ++++++++++----------
 include/net/bonding.h                       |   1 -
 include/net/net_failover.h                  |   3 -
 include/net/net_namespace.h                 |   5 +
 net/core/dev.c                              |  63 +++++---
 net/core/net-procfs.c                       |  13 +-
 net/core/net-sysfs.c                        |   3 +-
 17 files changed, 162 insertions(+), 150 deletions(-)

-- 
2.25.1

