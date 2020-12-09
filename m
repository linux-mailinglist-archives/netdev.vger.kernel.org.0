Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BA72D4644
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbgLIQDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:03:25 -0500
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:36676
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728392AbgLIQDZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 11:03:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAlX0tXvoqstGAFoeCxLkXQQ0PRCYQJ0JAHGCrUlf/Xo0OtTl+hmM5aQdEMyEFKSnBftguYGZErkxMOQfuaoMW/2G5WScFYjoXklijmmzvrRrljiWnC1DcTsDVaK+QRrtLMTnhjs1Zy3z8u7vrGdmnoYomTBzzDzLbdnV7H5vUy1dRaETi3WFnGeBCvpAWd/0Kw+zDW3mLv6xY18RfJKem/HDZe1u5kW78g+mkHo46bZkGPR/YGwMNuNZw5ZlVF9ZhwtMDvcitSSiw6V5Q/ZJCIj+e+jnEPUo2/Bkp/wH3sVYjYDrUtRGCyxVR2rKnoYa+OOpsgDtfkD+iNCa5JFpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kefmn1qSkhJ8/N69hXYh7rBOB8LtZNwwnxoWD5nkyY=;
 b=gMiTJmCdZU9SdTh4Iyg1U+R7lEcRpc2w1miTeznYdeJAr94/eKdv1lKxz2FFZvhhJZgJH5fG3EdK+iFt+tW/oswR2YGVARAdGeNBMklOrK23Xi8I4L5wf5Ybb8U7wt8wnoaw0/BWRCuHYfcDN45kHzNtGVnqjKJHzVs7w23CyglpfPCl6sb0bBb5HayUwrJjUY1WrXyQxxB2Zn4y+fTzYLarc+IYHxb+7/JJ6sjNs2stev2ivm/Heg+nmB3elcBYpQfVR1ztaavcYEP0itfEUFSLMdOTNii5txZOX0VXwBI6gMiWZiMi9d3ULaIKvroOE79ze5r4+ID/OZps7LpKzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kefmn1qSkhJ8/N69hXYh7rBOB8LtZNwwnxoWD5nkyY=;
 b=jCumr8h9taRuKnlmeRu6mEpViXhzHrty+1BO6aqfaWm5REp+yRj8ijSQ70kp0DP2EeClLqtWcu1g3Y81Zaw3xGHX61MtsbTl1Gsyz28RUPe+h14ipAmB7x0xwDi5mIn2JLy59XdLLD4Ovfes0EVvIeDIA3MqMgay2b8TAwQ8q/M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB4149.eurprd05.prod.outlook.com (2603:10a6:209:50::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Wed, 9 Dec
 2020 16:02:36 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88%3]) with mapi id 15.20.3632.024; Wed, 9 Dec 2020
 16:02:36 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net-next 0/4] HTB offload
Date:   Wed,  9 Dec 2020 18:02:47 +0200
Message-Id: <20201209160251.19054-1-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [94.188.199.18]
X-ClientProxiedBy: AM0PR04CA0098.eurprd04.prod.outlook.com
 (2603:10a6:208:be::39) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0098.eurprd04.prod.outlook.com (2603:10a6:208:be::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 9 Dec 2020 16:02:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1d14de17-c138-4811-cd93-08d89c5bd882
X-MS-TrafficTypeDiagnostic: AM6PR05MB4149:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4149E1322BDCB317387CFB67D1CC0@AM6PR05MB4149.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5MTwWLrniF/5Q4KHs29Qw45huJNpRAuZr4P6bKVUhaO2Ca/J+MtsRyPCSxxx++aIW2W9TVLqGmzFPNzjAGS/n8eET5dh5o0uaXhVMuANggQvD5wJrtKzEAgMOXDwJp+1y/4lWPoHLjUtvjZY7vXXSGrNaMM97cAXQ4Yi8/lPhcDANgj/c8uKCa9K4TvOd01W+NW1pZRXrTwo4nuFml2JopC3V1cESDUx3ndzmH6JUUNW7Dn5EqlJ0Kx+p+mEmuUSG/rkUrhtbjbgmtWy0F2KBSwNPF1UIi/eWeoqmiWTQHWJtGa670WHqz+asD6FDiltU02Kuod977S5SIRGmP417PVfpMuxR7PsVLU5C2uDa77Fho/z7uVWPUPjMDofgQqKT3Pncm9TcoFWi7AafDY8ZNxT52FDCq+Fe6jIdXYrv32ci7XN+FYQsvBAlPs7EB4Jse3LAKlgugtzEW35eTfeXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(5660300002)(16526019)(966005)(186003)(26005)(86362001)(110136005)(956004)(2616005)(54906003)(52116002)(8936002)(107886003)(1076003)(6506007)(6512007)(508600001)(66556008)(34490700003)(66946007)(2906002)(66476007)(83380400001)(4326008)(6666004)(6486002)(8676002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xcksxFk8edKV7NSlKU7wGhOppoc6LJj2yGA5835prdeAeWM9CWdIEzufi2lh?=
 =?us-ascii?Q?u95GlpGrQfu/TFSgO2FK7zmcNP75oo9EMeQQfoiPLlFKkwZkHDfwfYCQR3c5?=
 =?us-ascii?Q?+3GnSLCRnvZBuGXp8gGqc5WqROpSlFRhWJjN4eGh+cYKa9evXNclu2Ilgn4t?=
 =?us-ascii?Q?3agoTSLZLyvbqSgf9tniTekgZaVIzgzXy8XAgnd+G/Kci1lMlm/fuHvRU9cc?=
 =?us-ascii?Q?Jrf56WrgCDqdknwnVlxh0LnIA/6tRjiwDRFa7LARbAMo9zL7aO10inE69vwT?=
 =?us-ascii?Q?EkcK3trW46tjpf37cudrOxn2tpwkTH70Ky5AJOwOp/0o2Qr03UrMDy3HPSC+?=
 =?us-ascii?Q?lEEB59gubNqAKomTUo4yMQ/tIvqzSIOvuM05U2L5gkjWoojo3YO5HBO066Je?=
 =?us-ascii?Q?h3NLejtsjWi4+qAYAVPEycIcniNgCRXce1GUvDu3v4TOFhMXT8HpyY/WZrg2?=
 =?us-ascii?Q?2vOCywqdn1wcI0MY5m3wg2DWzoczF10YVNsM+rj7Y7xS/U9wOfYX6Ml6Cuqz?=
 =?us-ascii?Q?67VWmjgj2c3zpP+mDUEOZRkMHyJ941PoEwIJVifTwdiXTeeUQXbqLjRjTVmz?=
 =?us-ascii?Q?JjiroN1uztZkhHgASoHCsdc2rL/WUMvZAKFrEnq4O1J4C0Paw7reS+IBdZQt?=
 =?us-ascii?Q?KFQ35max4ka8rz3du60CnNJcQRlQqFf2BlV+n7ggNJ2UAHXGMZxDpptndcAy?=
 =?us-ascii?Q?ibAAgbiVguCR6IxVae74OE6XM7Dnd66xUJ7KicTHxEe/l7Ioi2R18ESunREH?=
 =?us-ascii?Q?J9k0dqwHL3kfMaYl9QeyUBGfgbW6hUcwlobYd6j7cbv3ircCcca7Dn3tdDdE?=
 =?us-ascii?Q?LCH8BTQaGTCyBP0mEZ9/paNzgjFInHf7F/cxhq5kpjKbVz0sVixGJNCRnh64?=
 =?us-ascii?Q?8lLjjcijKRZrX5y034UPsfGOfJePQRAzYDbJ8m9u6TElnBzwuj1KntjV8bmb?=
 =?us-ascii?Q?e+LcWvyLEY5WqHhPic1i7U3l5CrSvZfO6WJ3XZpc2e8=3D?=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 16:02:36.0753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d14de17-c138-4811-cd93-08d89c5bd882
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7WbhvVf460E/ijpO89JtOJELhwBJoTkiQFOyfPX/0S01CUuAY7VR86Dlgg4U9/9UfFREnmPp/Nx6tF/p5/UsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for HTB offload to the HTB qdisc, and adds
usage to mlx5 driver.

The previous RFCs are available at [1], [2].

The feature is intended to solve the performance bottleneck caused by
the single lock of the HTB qdisc, which prevents it from scaling well.
The HTB algorithm itself is offloaded to the device, eliminating the
need to take the root lock of HTB on every packet. Classification part
is done in clsact (still in software) to avoid acquiring the lock, which
imposes a limitation that filters can target only leaf classes.

The speedup on Mellanox ConnectX-6 Dx was 14.2 times in the UDP
multi-stream test, compared to software HTB implementation (more details
in the mlx5 patch).

[1]: https://www.spinics.net/lists/netdev/msg628422.html
[2]: https://www.spinics.net/lists/netdev/msg663548.html

Maxim Mikityanskiy (4):
  net: sched: Add multi-queue support to sch_tree_lock
  sch_htb: Hierarchical QoS hardware offload
  sch_htb: Stats for offloaded HTB
  net/mlx5e: Support HTB offload

 .../net/ethernet/mellanox/mlx5/core/Makefile  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  27 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 935 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |  39 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  21 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 168 +++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 100 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  47 +-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  26 +
 drivers/net/ethernet/mellanox/mlx5/core/qos.c |  85 ++
 drivers/net/ethernet/mellanox/mlx5/core/qos.h |  28 +
 include/linux/mlx5/mlx5_ifc.h                 |  13 +-
 include/linux/netdevice.h                     |   1 +
 include/net/pkt_cls.h                         |  26 +
 include/net/sch_generic.h                     |  14 +-
 include/uapi/linux/pkt_sched.h                |   1 +
 net/sched/sch_htb.c                           | 510 +++++++++-
 tools/include/uapi/linux/pkt_sched.h          |   1 +
 21 files changed, 1972 insertions(+), 82 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/qos.h

-- 
2.20.1

