Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2388346DCA1
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbhLHUJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:20 -0500
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:43105
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239963AbhLHUJU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnT+tiCTL5olP3/zgR+pdY8pcAJhvxs1rxO4DoUC0NHKWhPq23HjkGmjJQ7vkJ/PfB0/8K78q+jKZi1/FdAqMNd6p1x0PdZ0pdAmqCyEFYo7CAycblXXH66RKNdX7uh/r2cNdAEcFKQb9nrOJ5zXGhdgsuiDZZKFwkI8zYDW3w7DgO559ph5oXMILO5W0BQ7U4bM/NpcqVNDlHjMbh+XKw5JVzcV7BhxYpr3KO6p6DBTE3qrRJ0fMdavKgQ8SujdhdsCIlud/9RGThZKpBUdCVAl/cD8bGg7NvP/uGgcIrhoBwBremg3IYeYMedC7akyAeV7ZKt7RRsZ3lnpFKUEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwhvT2veCr8vbQF5kMs6BHSi3LioGSwwNrjVUbdH+iw=;
 b=GUIGNeqyKRwUDXxhZ33zQA0obNzhd76jofhlpdpf3/lnPa32zV4xWd1xRr6EX6yu2uNWyT89JC45TK8iq70tX46zj69aXjwJS1eGP2wZrbLw+qxh8WQY0nuq9MELmaB2OmEQy840TorLMHQ1d5Mbr4B0KTnGk3QvvmKyRkssZfelFSRK3BNsUoOzRsNncsuefma6U9UoWWDkLmLVs89afLb0lR0huNCrgTid9wa75nCzsItXdWBPxbm3p0S7lkTJWK8+1MaTD9qUj0skuPso7sc+1l+STl1H+vJMiJE56pVxsZGb+LGKrPBuuREfKbLiyVFf9ci6XWPZcJdS+Vv/4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwhvT2veCr8vbQF5kMs6BHSi3LioGSwwNrjVUbdH+iw=;
 b=Vo4WMgws+PDJ4Vyg/wyTC1Ms4EaD1awaM0o++90AAjTSfESc3LoDTKDaloaqKif7xEGEkWQ/zv6NTRqGugOsFa9b7cYVZVT/twmhUkjCpBlqVDieVIUXbBa3DNwGaTZBPVvoAlgNPAPrqnlA8/myPht3FD0bgRACoGVnig1C1gA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 20:05:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 00/11] Replace DSA dp->priv with tagger-owned storage
Date:   Wed,  8 Dec 2021 22:04:53 +0200
Message-Id: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81dac6d7-ad62-4c23-13e4-08d9ba861e88
X-MS-TrafficTypeDiagnostic: VE1PR04MB6638:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VE1PR04MB663886D53AE4F5D84C706EA7E06F9@VE1PR04MB6638.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6H8vB1Jgt40VrrV1B5VQs4i9DhWB/Hjp20Jl4F3APO3WEnDs0XvefEzbjjWBU1wN9yBS8rQUQ3XHdVUtuhZTfClORMqeNQNjTu2XIu8sRJBgASkNKqjtlnD7U4MzA7Z8jndXIR2jlIpiBCdQKMAznpzrz4dTqJZzrAi+SHDRuMD5AD9umX4ElsiRtsjopMkB5v+ExpeOGwsYfUQgxboX4JwW1FTRd8DqTSxP9bK0jaU3hvcgVMCXykL13nZSRmzVsIhU4cU4ILmVTeC7OqRTPxR6tcY/C7MPVdC5LQ0iMwfZ6ae4d2mu5FTEQD9L8cs6EWwxweqz3fVm88T88/9H453ZRYRCHTmtC4KcCPt7dzxpR7mm2t8GUAU+w1cIafQNUhKXw7+W3uJbZAlF+IbcR1Qi9x05elUPX5DhFiL+a0L1ocEURNGujFGQgO8RJseOL2IshY8merBJY7lbyyEkiM007M6Y9EpcOdl+RO3g22JLazoylJxqw68co3ONPz2dkwReOAto093fSt3TD+UhEofnczsRPS19aQ23qFr3Il9NFIigarl6QhaO4v3sLwXDW4QJ+rkDd472RMNCZp9NHywScwwVrJnsMBNJTT+u8820HH4OWWScxBJDo7QkZv34NdA1bD+tQDZY/afnvK2hE9bfRM2QeReK/wQn06Jmo9emllbnZsbPH73tJ45vfzKw/TRaX445FVMsRm5S1TRtC8l3ubyHZKoS9cA7nZpi+UF9nmGiOX5FI65qGoSORDb0v8nDL20VmjOoY2KjsKvDeAVkkKLRoMFOzOJS4ZzVbPsJANgkgJ8PT8yoNt0qIPrXkiDfliirWdu87pKJ9SEt7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(5660300002)(508600001)(7416002)(54906003)(8676002)(2616005)(44832011)(4326008)(956004)(52116002)(6916009)(8936002)(966005)(38100700002)(38350700002)(6486002)(6512007)(6506007)(66946007)(186003)(6666004)(36756003)(2906002)(86362001)(83380400001)(1076003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VbZMYQTnsO0A8QrXOMU/8uBM4vcDR0FBNsgWFTUV+tJb128B33M0Y7DZdkZA?=
 =?us-ascii?Q?CQwf6Kapu7mPIPnR2nzIwU7kY1174tsn7ihE0rmEndvLlrxtjc4dWra64r8+?=
 =?us-ascii?Q?dCRB+tQCNSouqj7YgnrkBnRM5QNMM2nAoRaejlZerMnlQQpCZrWoMe5qjedF?=
 =?us-ascii?Q?XlGIOwSZyegZ5OaYOqo/6M8o8W1z6f40SBNhId9kEgOL03KPocZf9/qjIl1J?=
 =?us-ascii?Q?OqQ0Zmqk2Knj4tCGI7c/cx/9TSWHHDvCLcr6W/aul0SmlPmc+a7bMeSalZmi?=
 =?us-ascii?Q?WtpWjRdmZ0Fv7Cw6zhv+XNkWpvtbDlnUHAl0Hhtz1DKCE9n8FsEB6UC4wVlJ?=
 =?us-ascii?Q?fl1a2CSl3kAKrxzp1TP1wYMBVW2xm5bxO6sUREMflkhtTgDh7oZe7l/WZ+wk?=
 =?us-ascii?Q?+awY9x93n03aTUUEmsJrXfxMa6nQ4901d85B66guaMK0VxQF5oQZHyb2qHyH?=
 =?us-ascii?Q?Y+illQpjdhjkbC0WTJtG5QD4APlMSyT9LZgv+b1DurDP9h34UcYLYj49E18l?=
 =?us-ascii?Q?90PY2dO8OwJoFZcodLghLF0HN3Ca77cI6XfaaPfXIove8IOmnBerMUb5hQTR?=
 =?us-ascii?Q?zUdQ2pvoDO2CLhRin5ZOBmya0cL2CycKNKMVS+1AqgGDnkWkCcQZ200q7tQ2?=
 =?us-ascii?Q?ruPkvXXmrkwonXWbtKbOMAWDBhnjcM9kA7joByZg00eGMfbDGcJuWhhX5wzN?=
 =?us-ascii?Q?zPkMsCGORRQfUPJcE9KAf8PVtGwWsNyH48q0LHS5W8IQtesfHitr55OtosWV?=
 =?us-ascii?Q?A36JRezX/MK0aVzqq3Q4kyJfXNEBRu4RoxigID31DPaUOZ3bZBmP/0npU02E?=
 =?us-ascii?Q?EzLbS8ftpC0/wGSKh9nK8r5BtgGV4qiyI2MSHd6TLjnvXJcuE/On3Hq9ar1/?=
 =?us-ascii?Q?tEwt6Z8MMiRHiKkxYts8NgCMZvDCnnryPpdyhifG2qC8s3jUit9MZZcsvDj7?=
 =?us-ascii?Q?KFEidLcQaK+ZXTcIZLa1rfqqSV5cvE1+JvpaM9oQgAfDAU6p1ITUOWwHHy48?=
 =?us-ascii?Q?qOGtbnjhhUpzghQUXIcnS+vijD01Od7JyOlesH1LB2N3HXmkTgL8ZK4lIvS7?=
 =?us-ascii?Q?vBLsBWTkzeBtCbwukOvrRWTl6kyBbefZbyF/aJyBtwJ5LO4uHH8RgAcNfYju?=
 =?us-ascii?Q?jMPJe5Wnq0zP3lEEanRojbVbvrEQzua820BY7tnJi6iyqEWmr7pyWVCeo8vA?=
 =?us-ascii?Q?8wsuCmZqDh7jxoszzS24VIbYYqrSd6kh6vae0FQs7sUSL6XEH8Uc+GZ/3rxM?=
 =?us-ascii?Q?WRP0t5wKt1RV7n0FlxDWBrsk0g2NjmmeEGjPfETQ4Rert33J/wZL3lmV2fRk?=
 =?us-ascii?Q?xUhWZlHTcF9oIHsbMNryYFE6NET6wOmaq5LYy9AC1Qk5XJJBf6K6zZgFWdCS?=
 =?us-ascii?Q?I24vUJSLumeV4tkzPWtl7FTjfxM72BDKe4qveQvL6IMYFSiN8BfFdqbB/wdO?=
 =?us-ascii?Q?iJPkTEesTGuPsMg49iXpnTE5DyzYdQyZEb3f2XW8JRo3BJ94YDc1Vw3o5JsR?=
 =?us-ascii?Q?TmNM/oCHNcVIoBjavhdJfhvLPvh8RBTwMwFMAd5Uoyoy3q1p8lp7P4ZtDZ7s?=
 =?us-ascii?Q?ZcWUGFCi25lSGiPU7Y/Yqb1YbNi/LrMLdDfKU72+KW8nnsBz59Ddbsedve61?=
 =?us-ascii?Q?wF4UewoKA8JVAgGpl8L9IHc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81dac6d7-ad62-4c23-13e4-08d9ba861e88
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:45.4785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d64f0g0tTPzSdEW4IxJVdjdFcn1rMZeGegowr55pVTRC/9IHMpNhpS9rBnvS0nHB0xvRU0TKS9p4JQEiNed+Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ansuel's recent work on qca8k register access over Ethernet:
https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.7444-1-ansuelsmth@gmail.com/
has triggered me to do something which I should've done for a longer
time:
https://patchwork.kernel.org/project/netdevbpf/patch/20211109095013.27829-7-martin.kaistra@linutronix.de/#24585521
which is to replace dp->priv with something that has less caveats.

The dp->priv was introduced when sja1105 needed to hold stateful
information in the tagging protocol driver. In that design, dp->priv
held memory allocated by the switch driver, because the tagging protocol
driver design was 100% stateless.

Some years have passed and others have started to feel the need for
stateful information kept by the tagger, as well as passing data back
and forth between the tagging protocol driver and the switch driver.
This isn't possible cleanly in DSA due to a circular dependency which
leads to broken module autoloading:
https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/

This patchset introduces a framework that resembles something normal,
which allows data to be passed from the tagging protocol driver (things
like switch management packets, which aren't intended for the network
stack) to the switch driver, while the tagging protocol still remains
more or less stateless. The overall design of the framework was
discussed with Ansuel too and it appears to be flexible enough to cover
the "register access over Ethernet" use case. Additionally, the existing
uses of dp->priv, which have mainly to do with PTP timestamping, have
also been migrated.

Vladimir Oltean (11):
  net: dsa: introduce tagger-owned storage for private and shared data
  net: dsa: tag_ocelot: convert to tagger-owned data
  net: dsa: sja1105: let deferred packets time out when sent to ports
    going down
  net: dsa: sja1105: bring in line deferred xmit implementation with
    ocelot-8021q
  net: dsa: sja1105: remove hwts_tx_en from tagger data
  net: dsa: sja1105: make dp->priv point directly to sja1105_tagger_data
  net: dsa: sja1105: move ts_id from sja1105_tagger_data
  net: dsa: tag_sja1105: convert to tagger-owned data
  Revert "net: dsa: move sja1110_process_meta_tstamp inside the tagging
    protocol driver"
  net: dsa: tag_sja1105: split sja1105_tagger_data into private and
    public sections
  net: dsa: remove dp->priv

 drivers/net/dsa/ocelot/felix.c         |  64 ++-----
 drivers/net/dsa/sja1105/sja1105.h      |   6 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 121 ++++---------
 drivers/net/dsa/sja1105/sja1105_ptp.c  |  86 ++++++----
 drivers/net/dsa/sja1105/sja1105_ptp.h  |  24 +++
 include/linux/dsa/ocelot.h             |  12 +-
 include/linux/dsa/sja1105.h            |  61 +++----
 include/net/dsa.h                      |  18 +-
 net/dsa/dsa2.c                         |  73 +++++++-
 net/dsa/dsa_priv.h                     |   1 +
 net/dsa/switch.c                       |  14 ++
 net/dsa/tag_ocelot_8021q.c             |  73 +++++++-
 net/dsa/tag_sja1105.c                  | 224 +++++++++++++++++--------
 13 files changed, 483 insertions(+), 294 deletions(-)

-- 
2.25.1

