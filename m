Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2AE3F3C77
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 23:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhHUVBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 17:01:17 -0400
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:58336
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230107AbhHUVBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 17:01:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7QA3fgfrTsgIumAHi0Qi6PwBjXxBvSTVk7X5/q76a+UzU62SSfoagzSkNd6yRXp9l1EqLjFS35OcXitYqiw6bCCXeoxbl6I2MOBgMFuS/ip6WNuxfBiOXXDyGADajPwgTKgCRr/MI0lkdQavbupKnkR7slRpqP1tiLU7uob/6vL9MutTJp1gsSO9pngIXPrR5cZyxAGMUZMQ4Fnn8rMSuQgWrCRrJfMC3UNOZ4SZcQ8xR7YUMFaLNFJ9RLVn6kfMJ31LnPnxRtMLnR/oaSeM0kT7rW7vFiDT/QMUDyeHABA659DDZHsodAr28ss9yrhuXBD6gmFMF6usBHrITQeng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBEuEiEbXQZXIsRYOdsPGHzM2lQoSNQWfQNpBF1ffMk=;
 b=fBbFUhnDNbYaDKvlAdBhjMAjATECDJVgurcTzsZfGVWb/Gfs7wrVUm2PWTOLOE6PSm93gNPUgbI5FSf55Y3R2mPJ0y8pNStnhJ3QsX17y8wplC+UyaDdqR9SFFSaMJgqolMRfLe9aYQeGjiSaADfzKtLvJghi1DGHLhQWLcjbujNgr55K8IopzfLvho5YtjUxkbl5v4+Ipyh2oY4FQrzHP+BnAJiUuQSKUi/DflfOsY9b73X0euy7UbAr0jFimAkjJAio+ZTlthO6K1tXA9Xg5vOYt9GFwKTk676pEzWILQkOW/UJcDjjhm7xEqFHgJKv1xYyfTR8SKRpXFXs6ax5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBEuEiEbXQZXIsRYOdsPGHzM2lQoSNQWfQNpBF1ffMk=;
 b=hYksonDBS2Ebcg79EYUWL4qFdCpe1azfPL6dIL9c5Tokr9R8xwe3/Y+7iUwv4NrKE17NT2SdIE1BdKajcEezzMU+DOs2e8SUze3TT75YLPSz6RrlePx8iaQYwfG7ueE3SlqwXizulFE4JCcRZb3PyydzN0tf0OyYfrnUVR0pLfQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 21 Aug
 2021 21:00:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.022; Sat, 21 Aug 2021
 21:00:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Subject: [RFC PATCH 0/4] Faster ndo_fdb_dump for drivers with shared FDB
Date:   Sun, 22 Aug 2021 00:00:14 +0300
Message-Id: <20210821210018.1314952-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0010.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0601CA0010.eurprd06.prod.outlook.com (2603:10a6:800:1e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sat, 21 Aug 2021 21:00:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4c64a10-2093-4b53-26dc-08d964e6b6e1
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2687401274076015F3591215E0C29@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cbm9LdpXht/rkldwNLfgxgd50fW/MvGzQptwNvhraQAnBOOUMe1hMSPkCW9+u/yMAVlqNj/1s7+j1BK3o9pkJbxJ8Vti3fuQRRh1sc+ob/87d3sQf8HqLbHkr9wj1xhfE1K0VQNY3b/AZtzCkKxdwxRIvIgbp+6IuOMV+P/IDjIMgE5cZC6TTyAvekWTnY/CATyhxkBHW73oEVzdMNUtfG0UqlGNN0V1eiqYwug5oj+dfcBtIK9qIK1+uLewtXZ5su2Qe+45wJH3qGEv3o+xrSi5Ir90rFUU1v5gFOzifKXB9FxmeUhmsVL/Th0EoEC1wl87opfetlls+kWyHW04ur0fM6r/Xak7ygVcGrsNUAgXDFQ4WCL+5MR3Zv5NmAVFnQXv1RY6tVAH76fbflY8GYIMSfdnaOuw0xqAWQgIqc09RySA/fzegh/DssicG3iI5lL345R/y8wyz6BqvopGKEIgP+bnIt56Pmfy7lzXR2HdOJj5DiGvOTDSt4T/B0czyyLizzMjc4laWljypFA92ZR5VugY0T2KAQsDkeof3yZHb2QBY3N7ON/Ge0Qx8wdYVf0U7NWTm4dGUmlshngBgQ5jO8MddD5QO0Js/+fMtDtTKt1Mbo0DI3+cZJwYHaAYunxrdifsvnA9aqHlIg3w/bJ6A6cu8UMgR/oxZWA1qtV7S6GYD9wdlezWqIEfOwTe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(346002)(376002)(136003)(6666004)(86362001)(6486002)(6506007)(6512007)(83380400001)(66946007)(66556008)(66476007)(52116002)(26005)(8936002)(478600001)(36756003)(316002)(956004)(8676002)(44832011)(5660300002)(38100700002)(2616005)(38350700002)(186003)(6916009)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bvi2+rhvmqy4dISBAr2mME/kY/NZbgluhRNULtFfTQgmoC1889qftCKeyHva?=
 =?us-ascii?Q?QOyTWmIkllnZZziY4k8U4fBYKuu1v/1hMP4V/89oSJm/6Y5GC1ng3f1IeEsI?=
 =?us-ascii?Q?oD/MxYPzAPkATWEedlUOFvpwtGliM4LiAxKvYhcsHBcNc4NGSTdJAR0IA9iJ?=
 =?us-ascii?Q?lzT2XpNdNU8gtPcU8R1rKTXt6oK09XxME1yH187F6MsMSAZlCQaAvTDGY3Qv?=
 =?us-ascii?Q?l3rARgj921q+ORkYF2kHJLFAKmO4bYiak4v9Mu4ZSWdsjLI6SwfVn78MRnH3?=
 =?us-ascii?Q?ZbnZwJMhQzs87WTkypDnsm++kGBzoymNSkJB5bNUXBfXAey92BgYQVZQIyMv?=
 =?us-ascii?Q?m01qXir7fLQSl6v2oFnncFcskqy5s+LIV8qVcZNKqy93yrYJNQn71b+f0nlm?=
 =?us-ascii?Q?iaFCYPk2gNu/SX/6YLjtqDYqq01IjQR4Aj8KQrTnnXTK1nm/hPD5L+Sr+Txi?=
 =?us-ascii?Q?rgRBRnxxTi10Kwe21TS6+kEr14W7TLqPNffuxzZp0hqxIk4BHz/ef+Cc/KFM?=
 =?us-ascii?Q?XuYatAniMRfa9Dy1hTqae/ObX9W4eB5W0pFqQMkuhwuxlDjfLediNpCZvNys?=
 =?us-ascii?Q?yfBbQGyP+30lZMcuL2aR8z8RslIr6pv6Cp7TStERZOXfp13d19PpAdzQawA1?=
 =?us-ascii?Q?MDR5nRG1EmRq00hloJIpUXyXjPHTKoAZg1aadLj+muF8pfPKdZ9tWMh9A4vW?=
 =?us-ascii?Q?UydjRiFyjFS9SZ8AJ1Kbzez3A2Tkozs/9cTPaS9/iXPw18o1viF70aHx43r2?=
 =?us-ascii?Q?tW+g0WE7Z7jfjNukZDLmRYRFM6uoisV6Xv7RJiYZVvE1ikcr9YzETgxtmtT8?=
 =?us-ascii?Q?p/4dvlVwdH2x4qA/uL7/dUkWQRbbwdXRxGCZRRqTfA+5rPCypMHzW+FScmI8?=
 =?us-ascii?Q?z4cDkD1WrPQK8vOobtjrui4Ucnbx7jGZKLNmFLI2avFTl4Wm2KMyi8XgXlS+?=
 =?us-ascii?Q?lQ9aHgPcs9ffrszyTTUm7ddOxQ4s3hww47MV1LRuhR58BNuDm15lrS51H2G9?=
 =?us-ascii?Q?Pfcu0ogJSGFWUuiBFgObH4HI226TnCQuLhJlThQDzHWP9XoqPzPRodhNqdS4?=
 =?us-ascii?Q?djR6oznBCxybpCHkrfWhkZu8gU9+9LYy1IXPj99JF90ywPKd85b5NC8WsdT8?=
 =?us-ascii?Q?8KOgHjeEgaghaCeXpoJOZd8yYsvhpugoc8YAvMbLrCP2I4TBw3ybTn+oiJ9b?=
 =?us-ascii?Q?it82ZBfrEc3wHF4y0YRWtNt2j9A/80noSQcecJ1EJYMGs2C1xUqj5OoG2hJB?=
 =?us-ascii?Q?B/AYTTf8vCxEqCdJkBQ321jY1MA0EazjsDKOGMjumzFhAfhHhx48/6Imz9V4?=
 =?us-ascii?Q?+2RZyE6HRmhanLq4U1XLndau?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c64a10-2093-4b53-26dc-08d964e6b6e1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2021 21:00:32.5039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fhZAJaXxteCQZmvdLHvFOM3Q4AHvK9SKY3FmdeHoPSyYSrlOWcErgPCdAeuGkmS4nYSBXKQIn3Sy2kQFPx+0vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a board where it is painfully slow to run "bridge fdb". It has 16
switch ports which are accessed over an I2C controller -> I2C mux 1 ->
I2C mux 2 -> I2C-to-SPI bridge.

It doesn't really help either that we traverse the hardware FDB of each
switch for every netdev, even though we already know all there is to
know the first time we traversed it. In fact, I hacked up some rtnetlink
and DSA changes, and with those, the time to run 'bridge fdb' on this
board decreases from 207 seconds to 26 seconds (2 FDB traversals instead
of 16), turning something intolerable into 'tolerable'.

I don't know how much we care about .ndo_fdb_dump implemented directly
by drivers (and that's where I expect this to be most useful), because
of SWITCHDEV_FDB_ADD_TO_BRIDGE and all that. So this is RFC in case it
is helpful for somebody, at least during debugging.

Vladimir Oltean (4):
  net: rtnetlink: create a netlink cb context struct for fdb dump
  net: rtnetlink: add a minimal state machine for dumping shared FDBs
  net: dsa: implement a shared FDB dump procedure
  net: dsa: sja1105: implement shared FDB dump

 drivers/net/dsa/sja1105/sja1105_main.c        |  50 +++--
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   9 +-
 drivers/net/ethernet/mscc/ocelot.c            |   5 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   4 +
 drivers/net/vxlan.c                           |   8 +-
 include/linux/rtnetlink.h                     |  25 +++
 include/net/dsa.h                             |  17 ++
 net/bridge/br_fdb.c                           |   6 +-
 net/core/rtnetlink.c                          | 105 +++++++---
 net/dsa/dsa2.c                                |   2 +
 net/dsa/dsa_priv.h                            |   1 +
 net/dsa/slave.c                               | 189 ++++++++++++++++--
 net/dsa/switch.c                              |   8 +
 13 files changed, 368 insertions(+), 61 deletions(-)

-- 
2.25.1

