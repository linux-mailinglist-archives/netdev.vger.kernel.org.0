Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A856F2EBE3F
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbhAFNIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:08:17 -0500
Received: from mail-eopbgr50089.outbound.protection.outlook.com ([40.107.5.89]:24773
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbhAFNIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:08:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzlALoMn9vKIVURpzDsCDEcfntrkduyogl3FON53u24ABj93lvu1dM1XwVrchlRxm9FWDgb2m7lWfZSkv8EhpsMqunByBk2Woq9fFf/lvC8ol0NsdI2AXABqqcO6Tw53kF1Y49aOYHfRcr+maLeinj4FtCuJBNQnY4zV+AIUWoM5Tv0DJsftM9lV3CIukZ9MkXdF0bm0P3SyKMVz4TZNCq0jUCAL/ywMEE0P7Q+tkuwQh4eHV56DrhaoVcxTp+tqynrptL3XQ4pNvO6mUT7aqjUjDQ2/2ykpu5/+cuKOBjEhzePwaIPR9ltczPcqKj/F25Md6wHMhy5DW+zd/ReVzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejvJ2/8LOAdrRvZrWys2RdZSUIgTHj7vS88FxoM9yiE=;
 b=g3RU+urfI38BP2En0wCdbJ9IJHDpcJa/NahfBFBjWfCsq0Hahn8BUod+ImHRdOkpr4SqBbxLUbSPgqpaFZkgPANOOB/GhiuH5tjLgJ0Gi603jf4G6kqEturdibMSoTJOqe9cVqfqsIJMOBjPeUxpV838NMIFVBiI/uaF01X7fo0q7hX66jLqZDA5TXkTWzuorwN6pClsMUlRBvxS+FcQYNJOlEOSuFQfrQL+3hUYPYUJ7NgC3bnygT3L8L0syQABUYjVHupe4KfmmhvbSZGFgBunz6LnzR3je5jEzoCLyPBkifgmLkMCQUigs9GXoIvzMFbbCzCuKdOfDFTE78d8Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejvJ2/8LOAdrRvZrWys2RdZSUIgTHj7vS88FxoM9yiE=;
 b=KuUX+mJR68bqePu+jVC4px8U03OiNoIm22V97YcebU6VCU126Ly1scZ91xIq68iBGK2kh1NDu/MVVaWb+s7IlRNJ6hYAfcK58uFULtLzB8yezI6SftTnnZoPWf70StGekfFqu4ijr6csEKPClpeKoX/lvvL9WK+ifK1y7KGNDBs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB4308.eurprd05.prod.outlook.com (2603:10a6:208:62::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Wed, 6 Jan
 2021 13:06:44 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:06:44 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next repost v2 3/7] ethtool: Expose the number of lanes in use
Date:   Wed,  6 Jan 2021 15:06:18 +0200
Message-Id: <20210106130622.2110387-4-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106130622.2110387-1-danieller@mellanox.com>
References: <20210106130622.2110387-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0102CA0100.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::41) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR0102CA0100.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:06:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b4189bd1-4a8a-4c09-8c78-08d8b243eafc
X-MS-TrafficTypeDiagnostic: AM0PR05MB4308:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB4308A6660538494A5D2482E2D5D00@AM0PR05MB4308.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:175;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R2IGMqp7BVeYiNcuU5XoPPmH4m5sHRS1H4DO27aKBhDansHyiy7BEqM/B2w+LV0dbnOjio31hMQn7lOOb5UwGjlBLhWU6AxiQPw2/L8AcfzXEFgE0Li+VMSk1akOinNqXR85rixhQDcvDaDUf24wGMIL1IxGOx/eOJeB+zPN17H5aDye3xWBZjAKD9fjULk8J9n5rngXRLpIj+bSlX619+HTsnvrXNvAi7GcIq+w4v6of7rixfcP/ws81kHPl9XLjHJCi83Vh3lewoJo8+MIBu/N2uYO/bC2rL62UxwIYkQMqOE2PoqBz+QqSixOkG5qXh5ttolpw34YSB6ZpSA/YrkspuIxcStWuNrARRUWbhy0b8VGcW6ep+hpsDo8CHMDKxzf04FnUwnDRn0Au48YUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(1076003)(186003)(478600001)(7416002)(26005)(6506007)(16526019)(83380400001)(6486002)(4326008)(52116002)(6512007)(2616005)(2906002)(316002)(6666004)(8676002)(8936002)(956004)(66476007)(66556008)(36756003)(86362001)(5660300002)(6916009)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7a8fHJkp3NOdzi8zGlWs67b+msSM4J1FhPi/ad43x9NmXC44Oo+Fau01dnb+?=
 =?us-ascii?Q?geNN4XjPqDuQP9sQUz+kM5yezlGB+FVo7yJ88ssIskZRxAZTvCgBvycmDPiJ?=
 =?us-ascii?Q?CJ9sjnZm6zGFvAFt7CX1bpaw3tsg5U3/55V01m7CXO0pufZN3Dq6UnIPbVc6?=
 =?us-ascii?Q?2a+ECR6Pq4z8ZlyLob4nHG2B5pDz9Cbx2kuHrgRURTA94OiL5V5K5D+MLB2I?=
 =?us-ascii?Q?u9Ed+IjJbav1nMnpDU+wwUF1ze+UCnn4tCIqiZ/GNMrEfEc81CrEPFHQ+1p6?=
 =?us-ascii?Q?0m8kcDFEgUIaC254cPn2LOjfnTdKga9WaFdIvU+7/ARnYyBgWRV+b7DbNfyw?=
 =?us-ascii?Q?zrQLxpn40DxQKE0g5o8ZZvfE0X/bGIN+exPm59uHODZnTkMMJ3Wz4W2KiEDH?=
 =?us-ascii?Q?qv9r+FmWZmHnggyxZGPAVBPWJNEDTpSJ1oZZDhDEBrHSXjUXUI8c2C4lHXXs?=
 =?us-ascii?Q?8NwOLK4whSICHhEIaqLkqxoZRFuZWJHE8a/8aR8IicC8MM23xY7Qi3Xm5PUY?=
 =?us-ascii?Q?dStUGA/YfqsMqAXyvyATzSoR96O+1OdzsC0xBcG3JVPDRl+ofDSckjw4vZl2?=
 =?us-ascii?Q?TivAbG9Cbfa5Dt0A2nGdn7B9Q6bPOiJwA+o3tAdb90yIEAe4oGvMvOsHS87f?=
 =?us-ascii?Q?VGkr/DVXTlK3KR1g3f46/oPvPCzdDvr/BK+zA0aB8K6B2Z1utnJ9uDPyW6Py?=
 =?us-ascii?Q?A1Zl+qLvRnzrdwbfPcysSo7bej+ORLu34osBgWuMS2OOqY/UgFgPyccS3ldz?=
 =?us-ascii?Q?mVZ87MgRhnEk7uzveDSlAdr0mQ3BCJLKCHXwFYKDgIzDoSXzrKTXsKKtfAIg?=
 =?us-ascii?Q?DJ15blXPIfVaGyCQATmkjKMIYcgdDoI2WWaQcFiSgNedpNsz563ndAxgtMYb?=
 =?us-ascii?Q?lH06/ucIaTIBcXT0NwiWDASQkJGL9fkFtmGHkZcmetJwv6ZE6McrnY01DrSR?=
 =?us-ascii?Q?3vIpN7MgxW+U0gdX8ieNiuawdNaQDfiFuGuiPUK1UNDrX72wMO2SpkUtLJtT?=
 =?us-ascii?Q?BG5I?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:06:44.7008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: b4189bd1-4a8a-4c09-8c78-08d8b243eafc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjirW7exMDPH/ZVeg1Tx8u6i0vsN8a16TOryw3Kw9p2JccG0FzxyjNDPpARTJbRH6j1pd48ilvLbuBuR3NP0KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4308
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, ethtool does not expose how many lanes are used when the
link is up.

After adding a possibility to advertise or force a specific number of
lanes, the lanes in use value can be either the maximum width of the port
or below.

Extend ethtool to expose the number of lanes currently in use for
drivers that support it.

For example:

$ ethtool -s swp1 speed 100000 lanes 4
$ ethtool -s swp2 speed 100000 lanes 4
$ ip link set swp1 up
$ ip link set swp2 up
$ ethtool swp1
Settings for swp1:
        Supported ports: [ FIBRE         Backplane ]
        Supported link modes:   1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
                                40000baseKR4/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                50000baseKR2/Full
                                100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
                                50000baseSR2/Full
                                10000baseCR/Full
                                10000baseSR/Full
                                10000baseLR/Full
                                10000baseER/Full
                                50000baseKR/Full
                                50000baseSR/Full
                                50000baseCR/Full
                                50000baseLR_ER_FR/Full
                                50000baseDR/Full
                                100000baseKR2/Full
                                100000baseSR2/Full
                                100000baseCR2/Full
                                100000baseLR2_ER2_FR2/Full
                                100000baseDR2/Full
                                200000baseKR4/Full
                                200000baseSR4/Full
                                200000baseLR4_ER4_FR4/Full
                                200000baseDR4/Full
                                200000baseCR4/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
                                40000baseKR4/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                50000baseKR2/Full
                                100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
                                50000baseSR2/Full
                                10000baseCR/Full
                                10000baseSR/Full
                                10000baseLR/Full
                                10000baseER/Full
                                200000baseKR4/Full
                                200000baseSR4/Full
                                200000baseLR4_ER4_FR4/Full
                                200000baseDR4/Full
                                200000baseCR4/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Advertised link modes:  100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Speed: 100000Mb/s
	Lanes: 4
	Duplex: Full
	Auto-negotiation: on
	Port: Direct Attach Copper
	PHYAD: 0
	Transceiver: internal
	Link detected: yes

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v2:
    	* Reword commit message.
    	* Since now we get a link mode from driver, instead of each
    	  parameter separately, simply derive lanes from it.

 net/ethtool/linkmodes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 505a9b395fce..f22761dcdb2e 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -166,11 +166,15 @@ static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
 		goto out;
 	}
 
+	if (!(dev->ethtool_ops->capabilities & ETHTOOL_CAP_LINK_LANES_SUPPORTED))
+		data->ksettings.lanes = ETHTOOL_LANES_UNKNOWN;
+
 	if (data->ksettings.link_mode) {
 		for (i = 0; i < __ETHTOOL_LINK_MODE_MASK_NBITS; i++) {
 			if (data->ksettings.link_mode == i) {
 				link_info = &link_mode_params[i];
 				data->lsettings->speed = link_info->speed;
+				data->ksettings.lanes = link_info->lanes;
 				data->lsettings->duplex = link_info->duplex;
 			}
 		}
@@ -196,6 +200,7 @@ static int linkmodes_reply_size(const struct ethnl_req_info *req_base,
 
 	len = nla_total_size(sizeof(u8)) /* LINKMODES_AUTONEG */
 		+ nla_total_size(sizeof(u32)) /* LINKMODES_SPEED */
+		+ nla_total_size(sizeof(u32)) /* LINKMODES_LANES */
 		+ nla_total_size(sizeof(u8)) /* LINKMODES_DUPLEX */
 		+ 0;
 	ret = ethnl_bitset_size(ksettings->link_modes.advertising,
@@ -253,6 +258,7 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
 	}
 
 	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
+	    nla_put_u32(skb, ETHTOOL_A_LINKMODES_LANES, ksettings->lanes) ||
 	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
 		return -EMSGSIZE;
 
-- 
2.26.2

