Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2829343B71E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbhJZQ3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:29:16 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:16928
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231880AbhJZQ3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:29:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXBYJBHccCEdAotGc1HPhkEABBlunx8wRtsBBKC59P3Y3FRxSq4ZyCuPYdTlSXDDMjvNHmj0Dqyu70EPVRAulmbshJiZ+acvJ7XaEQeLxK1mn/xSQIgMvLLuJdQ0CWcvW0uUz31sVT7dgXAEr9qQIEkM0Tle5kwjzoVpK1f5iM1IAqym4S/YRiFlz7ZDp8am/6U3Xfi3AtvGV+KQP2zwnxUojmfeTyY1jWiRXqVSo1Pln+czsXWGd8C0h2RMvCeIq2cnylF1maMbCNrxwHeL4m6sg/IJ5BGYIkvkNXzEHLHnK5e0w2Yk0khv3BQGrtYGXrNF7URw7C7kbyTFSR8iuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9QvIOLK7Vlx7iz/iQy4i4JnJvRyGiVBSrY1Xahh5/+w=;
 b=WmjHyL2L5/SHQ6sVJW1A3kRIzkAoc/1wHCyPA1gnsLNnLlZFMTOMFy03X81gaKvuznw0LIeEgz568o6gX6rbDsq3EwvQ2+MY6FcVIPeXt82hAJk9SxoiWQdfJiC/C8vf90oaTNGlb00m8unjGTGWNp05mLflHOWdkQTSmeA1TQMh1EDavyyxrCi9xCbhzGWHM6YJyVglZMs574azBecvwYjWodwsWRu6MpSgv7MQctkrcMcdDazqTFTX3e9vTHfZgusULObUMeGB0Wa34Km6JPO+FYk+0PJ+/gBycbvHC7k8Pdp3jxJWa+1KvbzvgvkUM2vEmdAH/LMzzteWUxHdrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QvIOLK7Vlx7iz/iQy4i4JnJvRyGiVBSrY1Xahh5/+w=;
 b=EsDA+slW/UHSzxdvXd018j3tC8mg8dlKQZvKV9rdClu+L1QffgdSO+9HnuIi2Rb1Ss9a9hcBlaYu1b+1eRDbKgzUY1lAeRqpNuwOw4DSpt68Qyfy+SoBhE/RvoWO/Z33YdXrBDZjUyd92v3zZ9wyOcYV+8qPwkIMrIeCYynQcp4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 16:26:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:26:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [RFC PATCH net-next 0/6] Rework DSA bridge TX forwarding offload API
Date:   Tue, 26 Oct 2021 19:26:19 +0300
Message-Id: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0121.eurprd05.prod.outlook.com
 (2603:10a6:207:2::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0121.eurprd05.prod.outlook.com (2603:10a6:207:2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 16:26:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4734218-6590-466b-0164-08d9989d68fe
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637D5CE5CEB52B2B0C9B8A7E0849@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Vox96hkGIpk7vcqCPDgum4OulsN/Cu7GDuAyKNaZP2FaBuFWVL7DkVxpXNV2SpqCD6E10xQJmL4OcUoZvtpB+qnQDE6l5KWfhkZd+y79pHdkzFmN6sU/uaxvQbO18a94Usy/eOaNnmBrvOlbEd6xHd+JYkmWBygzvrbOolrJTb+SBF89nyzlzM8WuCu/YbCcDudEW7f46kLH5ffQWiXdZbnnLeV7dspaWvDrfPp8XCsX/OKGTPrzwoI6M2C053nilqNDZpb/EgFiqiFdni3LDWvX104Q+ji5ZXEdYAzhFATgYVfntrx7CLT8UX4K0yLtG10Q3/nstrmmlWBw+MzU3BuQ0S/f06iFbQhe/4Y5DHqkpImmyMqmmbBI6sqWWljLOa1yWVCx9SQ2VLCh/SXvMWZ5L1SFhysqbWEkBJu8io++AQFPouTaJYWq4cK7S4FMRuT+JjM2WbHCUwmNdo6efDIBmKXul0/OeP2GqDywW6fjW14QKjJUV69qCd3l6PL5ROdsGxmJiFCLbm8d2qkQ4y53pabX27TJRH18STwLkZvhE9+zKBgW1UVtVXCgzURKw8jHGbBpKaHnVBe0W6HuMsBVJCg0+VzzJm8iN5drXBIkIj6n5LKNfY0+2R620MW4uXZVeD8dVXwqy3PraDv1E/gbYbrbbxL9ZCzVaK8tzRXIQt9KWuNgnxE/QE33amx2mzgFHtNIHSvFQnrcdYzhTuaDSnlc8vpWfHaSrBo+3O2k5q1HRqyGeO8VxU8I0v7s8MUu594et4a3zBFD00lZbv9QameDezLnhy/91yPWI4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(2616005)(1076003)(5660300002)(8676002)(86362001)(66556008)(54906003)(2906002)(38100700002)(316002)(8936002)(83380400001)(6666004)(66946007)(26005)(186003)(508600001)(36756003)(6486002)(966005)(6916009)(4326008)(6512007)(66476007)(44832011)(6506007)(956004)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ix0iOuP/QqTmcpQsFQihe4WKjgbXjIeqFSy7A6Hc4YdYdjFTq8EVi5BqdJgf?=
 =?us-ascii?Q?xO4ow1HvsBCDXbDY+x5QNnqwtaALWWG9B554awmO5unERGmJw+oNZMd44y1t?=
 =?us-ascii?Q?etGSCfxlksgwQMWYdIkY2Ls3we66ej/4qWtHp+j++AFrvU9x/Vov/JU6LaRq?=
 =?us-ascii?Q?cl+kgabWzpZvaMN7eBxlVTGm8ErbiTaXJxJfokfx772ps9naoSKk+F5vdO/B?=
 =?us-ascii?Q?p+Q+dKYP+PRXXPAt3duNaTwj1jFrDQBVExG6SpCsCoXLhbkbNltexpN4gm7y?=
 =?us-ascii?Q?uUDidWny82JGQzyVZPpHwfneHdMlU6pEi1oiJ86231zehGfb3R7dRpr4VGlv?=
 =?us-ascii?Q?ZZNpiy9+hrqOAJOGWqR3OtU9lGeMw2Vt+u/LICORCNIfQdl5x4VIP/BMyPjN?=
 =?us-ascii?Q?e4w5iXzefXlPjUT8PXan472aWzMzntHVMjQwcqunO60O8hcs5wFoHGoYse4n?=
 =?us-ascii?Q?coG7FBD2pjz6V2V++Xfpm2Q/my0yb8E3dAVr4xUVX8xxRymraqwV6SR4v13p?=
 =?us-ascii?Q?fxIfiYvNa//lUJzLSGNvEHd56FZUWvShI/nie029Q6GrEwD2PGCNKosMDkF6?=
 =?us-ascii?Q?mFSJ70QrfWIt4V1tkTF4EjQw7+MwQZmD+pTaCvHAfwZNMQK6uYyCO+tqd3tC?=
 =?us-ascii?Q?6b3aj8Bdbl6TWdfAwG9tdl8PNjhoRwwZ528baCpOOHoW4l3y3SfkgopRBrYi?=
 =?us-ascii?Q?GyKxXtkB+vYqZqf2YLgEoK+ooW58iZCBGUF9B4JFnwFB7WkCO7Tlk4AIHSwy?=
 =?us-ascii?Q?s5n15KkAwEqgjtsO72WKxB+1yFViDqWd5jWYCd0tVYFQe1Wr0cojv0PFua4A?=
 =?us-ascii?Q?kxBJYOx3TnbBMt4Vq2OwjU3hPZD+yex0Mto5/U5NzVe4K3ECE9YUq5fdUipS?=
 =?us-ascii?Q?vfttyzwen5xeuFO1rg/o8er83xHn+wlKM2289cWcWWjFwzMVyZVw6PeD5v3Z?=
 =?us-ascii?Q?FldZ6amzxhG9VXO158TvK+A3+8H2vWYyeAjGGoz7nvqMvG223Xh+1juaemRC?=
 =?us-ascii?Q?aLyaFij9MtDmk4Sh47BOttarDJq4QQ+V+WAhEAZ7lJNyZB2+4zECrSaVRUhd?=
 =?us-ascii?Q?YJqp9f8eJndngmsC/yyGW8qLirUVxPub67E147wsK1Zg84jV6eM+7eM7GZbc?=
 =?us-ascii?Q?+dogKF2K8MLUs/Ml5zEOGsxDBDtAs9RveH2KC62MCoQXeq0gZf6WXojEp1zF?=
 =?us-ascii?Q?QZifXTdi7gZgncPB3nm/nzr8TW5PubJtM54eTghJr9cjUvTnnGvfOvXKoOBx?=
 =?us-ascii?Q?i02tmfI2KNTNfcZBao59/VCYAcaUHepqgVshUB5GsuYkdBju3d2RjKIXqsm3?=
 =?us-ascii?Q?CcgmTBwU9iw5nws6Uku9Jt4p1s+IbjlUHyIejhP8OIZ6tqhO50xwRBe99Ad3?=
 =?us-ascii?Q?sQ3zxv0kqKezWUbijMVPgdhHJR70D3Xg0N7DYNLTGVD4iVm+m9WpteyGF6aQ?=
 =?us-ascii?Q?FpOu+JEbcAle/DcNg2HXZLwlOI35VvmSpviUngUxRC0rP+kEzxu4ViO9sAaH?=
 =?us-ascii?Q?66Xu5AINdDcrbGdTQyKT8NTYGG8aMdWYZByl9R5OAFNtl6pETjLdYklgYz3f?=
 =?us-ascii?Q?VbSoyIsBabMbStVyh+FmY+j2SXT1D2yFwlpSgM8IWuGWdZXYlpxX/vtTDK3N?=
 =?us-ascii?Q?W+V5jQbr2I3tJFzlC4iGe8I=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4734218-6590-466b-0164-08d9989d68fe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:26:48.9419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Ss+/DcFlDyerLiPtikm3TcmvSLDowu4VDaQSTlto6ZvCXFyTzhxzW1j6f/zpvq1XAuST+dEp0pRCbu1yG2WfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change set replaces struct net_device *dp->bridge_dev with a
struct dsa_bridge *dp->bridge that contains some extra information about
that bridge, like a unique number kept by DSA.

Up until now we computed that number only with the bridge TX forwarding
offload feature, but it will be needed for other features too, like for
isolation of FDB entries belonging to different bridges. Hardware
implementations vary, but one common pattern seems to be the presence of
a FID field which can be associated with that bridge number kept by DSA.
The idea was outlined here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210818120150.892647-16-vladimir.oltean@nxp.com/
(the difference being that with this new proposal, drivers would not
need to call dsa_bridge_num_find, instead the bridge_num would be part
of the struct dsa_bridge :: num passed as argument).

No functional change intended.

Vladimir Oltean (6):
  net: dsa: make dp->bridge_num one-based
  net: dsa: assign a bridge number even without TX forwarding offload
  net: dsa: hide dp->bridge_dev and dp->bridge_num behind helpers
  net: dsa: rename dsa_port_offloads_bridge to
    dsa_port_offloads_bridge_dev
  net: dsa: keep the bridge_dev and bridge_num as part of the same
    structure
  net: dsa: eliminate dsa_switch_ops :: port_bridge_tx_fwd_{,un}offload

 drivers/net/dsa/b53/b53_common.c       |   9 +-
 drivers/net/dsa/b53/b53_priv.h         |   5 +-
 drivers/net/dsa/dsa_loop.c             |   9 +-
 drivers/net/dsa/hirschmann/hellcreek.c |   5 +-
 drivers/net/dsa/lan9303-core.c         |   7 +-
 drivers/net/dsa/lantiq_gswip.c         |  25 +++--
 drivers/net/dsa/microchip/ksz_common.c |   5 +-
 drivers/net/dsa/microchip/ksz_common.h |   4 +-
 drivers/net/dsa/mt7530.c               |  18 +--
 drivers/net/dsa/mv88e6xxx/chip.c       | 145 ++++++++++++-------------
 drivers/net/dsa/ocelot/felix.c         |   8 +-
 drivers/net/dsa/qca8k.c                |  13 ++-
 drivers/net/dsa/rtl8366rb.c            |   9 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  40 +++++--
 drivers/net/dsa/xrs700x/xrs700x.c      |  10 +-
 include/linux/dsa/8021q.h              |   9 +-
 include/net/dsa.h                      | 102 +++++++++++++----
 net/dsa/dsa2.c                         |  57 ++++++----
 net/dsa/dsa_priv.h                     |  59 ++--------
 net/dsa/port.c                         | 123 +++++++++++----------
 net/dsa/slave.c                        |  34 +++---
 net/dsa/switch.c                       |  20 ++--
 net/dsa/tag_8021q.c                    |  20 ++--
 net/dsa/tag_dsa.c                      |   5 +-
 net/dsa/tag_ocelot.c                   |   2 +-
 net/dsa/tag_sja1105.c                  |  11 +-
 26 files changed, 414 insertions(+), 340 deletions(-)

-- 
2.25.1

