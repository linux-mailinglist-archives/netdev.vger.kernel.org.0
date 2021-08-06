Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17FA3E1FEB
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 02:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbhHFAUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 20:20:54 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:14702
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229997AbhHFAUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 20:20:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lF8Vs2GKU+tjrLIrES6WMn3XeqPzi2W6eFAA4JwaKr0nJrLjvcU5KHNTVXWhMrOqP3hOZw8ksWlO2txFOh6Bd3zJ/MEQUAtM05WQJjxBFTbCXqU00KBU/Ef5clgC8PdxQ0qmroxwAn6p40AbrOY9axHK4WYx8k6NJXSDZCyeYWJPqZMS31Clq1vUZ9gO0brTTegtTg1lrYV1OZQyZqFmjm8G8wRbS6Wmp70S+n1tAODB03XObW7QaQNVDKBiI7YmXtSDKL4HCwnnhfVW7K/aQJQJcopc+xcNyJ4QCmUICpjo9ocPnxgqRhwOGHyyG57nSj/C50bWjStc4CCEi+Rnfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffKQC5WfAw2q0CLVjlvmvdab854eV2Z8G22JRa1sldA=;
 b=awcoebxWVPa1+39gkJz4PUjOI4+qT4fAPoWiwuPruRAT0EdEkKH4UR5hgGyEdSIyCELxV5DZ1220q0pa6yoHf7GQgq0pi77DLSpVgXp923CPnU+/e8xV+aLMSlPyABtPAZQGiKe1lRILxtdPeuMLWqe60N6CPqehXstECgfTZfOdW1fkuSgIJGp30GaVunfvu5Nf8pYVFlSEYLSbwoDfnARwt9OhFa8plfqcaaJ9J6p4gg7S6fA82ZigoNjIulPR1WVUeXZw72xkaLeJyyNJFYzQlXOnzBKgKjd3IpgmsI5r2sBaQfEKg1a8+9fp6aRkrWu5lJVjgnh9DlITkBahfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffKQC5WfAw2q0CLVjlvmvdab854eV2Z8G22JRa1sldA=;
 b=lIQhvRCOUu5hwRpaB9G4rfJZ0pHpPQRkQdRycPzhTxPrKaUmMOBUhob5dHqIxyTYxMlojkxtlVrIyTAmYy2ogUcraQSJwK22vgHE+ZNcRDn6cXMq3OYJ18p3YACu9nkzMOFIdxLUp28Ayj57NvSpZG/Z4r4WbGYRnUcoJcu+7wc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Fri, 6 Aug
 2021 00:20:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.017; Fri, 6 Aug 2021
 00:20:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 0/3] Always flood multicast to the DSA CPU port
Date:   Fri,  6 Aug 2021 03:20:05 +0300
Message-Id: <20210806002008.2577052-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0087.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0087.eurprd08.prod.outlook.com (2603:10a6:800:d3::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 00:20:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a74143f-dc28-4c2d-1d35-08d95870034f
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7341136C2349613DD4E4312DE0F39@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZlUhThEIR2Iv4x/q3+/QcAqRmH3TlEkG4eRruMi6Y++IQNnn11rIxA2XA4x1NgUZaee3T+HwJYRMW7G2IDdXfqQFYcAnkNBmnotIx8C9tbVcQyLWoZZ1oA9vV63mVcmGV3Vs/QDFHmajeh3A4cZ2RKo3ctm6ffGndsRAaTeOxJPh53yM1buBibDWJmXfXxxSGJ0G93u/sRL0OmSAwM3v+6srrc3BZXsO+jLNe9bwmmw/hJhyLiXFp6nrwGw0biCO5nwl5u2EO8KebVPOJc/Jh94dwB1GT3qjABewd0S1eEX9ypUdBrX+BPhOUOYh9E3dcnQC+7bxrv+XZAB6DGyrfBku94quhNhyZ6M/Mj69KktTut0ukuygZu9+XwnXTXknAXY3g6XmbxmfhaQklJO6HXzy+VDtrQBicif3HfLnDwZB9kOvrcgjuV0Mltk89sUOiIrxQaNI/7mgd9IyyQ4ABIdL43xRDPAIyrnnpDhPN3C7MBBE3pICopks/iTg9PwBjlpgvlZlgO6JpHxxhnztA/a0vwNZ9Yiz9gBy0R4vdSwRvRjDLsM662TCewN7lE/u99a1Wt0ZMKdAGBOzl4YDdJwyXqWsH55RTX3DKTX5BECeoNcjiZovG7azmXR/sL1QYAnC4kEOWd/m0o2YHtK620hxKqH70eiKTnUcB67UKAlNC83bG/H4MJ2CC1LKZNGuUj/T9i9gLb0iZCmhdneFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(8676002)(44832011)(478600001)(8936002)(6506007)(5660300002)(110136005)(86362001)(316002)(4326008)(54906003)(26005)(186003)(1076003)(2616005)(6512007)(66946007)(66574015)(956004)(83380400001)(66476007)(6666004)(6486002)(52116002)(7416002)(38100700002)(36756003)(66556008)(2906002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ncaF5mJPmi+HrnnX9xMD2qw7bowq5nVAEnrS5a2JQ3xYkmnrcvTdoSJOjM0p?=
 =?us-ascii?Q?tcdPjIV4DyF7oef7JvEvLBP9OYWsI9Id/p6TrmXY0nbEiS6yS58+QVI2PtwZ?=
 =?us-ascii?Q?F83ZvCTZ3ss4i8jXLfOfDB6ajMkVRBpFG2+waBnwWuoTDsDibqv03s2p9HBH?=
 =?us-ascii?Q?ZnumneoFpOGrqT57+tt3pYqRl/BZVM/NipLgeh0Se5LeFtXmUkA8TFDRwJRG?=
 =?us-ascii?Q?GvV47L6K7ISAXb766up43GDwk9mweqyXvJ/m1q04UCDfrkZLlD+bAqSbtQwt?=
 =?us-ascii?Q?KyJdU54jQKprnb+MfC2ZbtvpG2ONIukr36lTImIJ1KnouSL9pE/800QxAHFi?=
 =?us-ascii?Q?7Un8gbMXDOPnlAujwgidv+LPgIgv1thYKUIMzrrhCzhQ0tuqL+wcTuZPoPXC?=
 =?us-ascii?Q?tNWnF5HUb8ItwIf/h9OvJeBS231vJ62Kcdltrnzod6dx7L7knXsV11XoCcWv?=
 =?us-ascii?Q?F8/F6d59hoceP++xDx/tep3YTp7CDBH2I+sqD68crSTlovIuxJ3rh1JHM988?=
 =?us-ascii?Q?pcJuNbaaXJVMWU/ivHqR+AfDy8jov+KCLdMNyLMXnkDjL+S2UaHaI7IpZkKA?=
 =?us-ascii?Q?XfUPf5aeb6ty/CeewvT1hzm2urbvECN3GY8F4SKgnBDE98n5NJgI/Y6J+YMb?=
 =?us-ascii?Q?uzULAGT85mIr8HtYoKv7KWb4Hw7OvnxRliQnaIEx0xIiIJ/l6vtIrBF1eOui?=
 =?us-ascii?Q?m0Fmev/PlM5U1UBK6P5o/olXzKWRaef+D0/GgzsZT2UATfO3QmnxoPzaqTKw?=
 =?us-ascii?Q?/grC5tjCiTi+iVY9fhZSijcFMhNTKQCCUtnFnr/Tb3RKiTuapza9smD5QCs2?=
 =?us-ascii?Q?At2BdtZhmL0I5i1F6vx79Y/ZBwvthNkhA8AJha29RfXPSXSBcHlmfIn5W62e?=
 =?us-ascii?Q?8gCA48xgkU+dtkG9Ygj637tACm/JOB+taBfU6oQQGhQE6Vh7wDSdZvC1ELnp?=
 =?us-ascii?Q?iolwOzqk4UaIrLx99gTJO0YLhHa+f6R4XFg1m7E6v+VCDqtFNznl8m3HW7xm?=
 =?us-ascii?Q?bSp1/ZUOhz5htQwnuWsizTdQXbJXh4aUkM2TI4EJHaIATpK4eeWzTSH1kv+l?=
 =?us-ascii?Q?vklzbirpSVm8Zc9r3zOLWrHvD2kBW4vPVOfxrDBWXAPrG01eRIssMXf/HSDh?=
 =?us-ascii?Q?IzqzqdsppP8ARynDeqh0Fkh87o6O4yOEZa90rKVQmTfbtxVZ7EtFJidJtsMh?=
 =?us-ascii?Q?BdZm9962LcvOLbI6UFM1qbhMtVsLAndlahlhz3cOOb8TpjuYJ+CrdhBGydfw?=
 =?us-ascii?Q?lnzOyGhgTkasTsObOu6mAX844j7MWQ42XRHVX9+zjZK7iLFjAmrMSL8Jrg1d?=
 =?us-ascii?Q?FoX1sLbL3kwaA34NKdhbcS2R?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a74143f-dc28-4c2d-1d35-08d95870034f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 00:20:36.6003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3S6dl+DqEpDUz29elLV1Gt9I+E473Fkg+CD12ZOM2SYkhrsC/DM33/5NS3r0zswCEhV/Y1vX8JSCkPrrlu5TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Discussing with Qingfang, it became obvious that DSA is not prepared to
disable multicast flooding towards the CPU port under any circumstance
right now, and this in fact breaks traffic quite blatantly.

This series is a revert done in reverse chronological order. These
should be propagated to stable trees up to commit a8b659e7ff75 ("net:
dsa: act as passthrough for bridge port flags") which is in v5.12.
For older kernels, that commit blocks further backporting, so I need to
send a modified version of patch 3 separately to Greg after these go
into "net".

v1->v2: delete unused b53_set_mrouter function prototype

Vladimir Oltean (3):
  net: dsa: stop syncing the bridge mcast_router attribute at join time
  net: dsa: mt7530: remove the .port_set_mrouter implementation
  net: dsa: don't disable multicast flooding to the CPU even without an
    IGMP querier

 drivers/net/dsa/b53/b53_common.c | 10 ----------
 drivers/net/dsa/b53/b53_priv.h   |  2 --
 drivers/net/dsa/bcm_sf2.c        |  1 -
 drivers/net/dsa/mt7530.c         | 13 -------------
 drivers/net/dsa/mv88e6xxx/chip.c | 18 ------------------
 include/net/dsa.h                |  2 --
 net/dsa/dsa_priv.h               |  2 --
 net/dsa/port.c                   | 21 ---------------------
 net/dsa/slave.c                  |  6 ------
 9 files changed, 75 deletions(-)

-- 
2.25.1

