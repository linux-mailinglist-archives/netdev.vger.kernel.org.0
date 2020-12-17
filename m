Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686082DCDF4
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 09:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgLQI6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 03:58:45 -0500
Received: from mail-eopbgr30043.outbound.protection.outlook.com ([40.107.3.43]:10627
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726533AbgLQI6p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 03:58:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehmYGEwJePEmLJQFvYdqvZHi0AIim6XDCOG8R8QP3yKtBUysKgYyHMw9qmAnIBGJ+LUHKwYsoa5hAinUt/XJvfW5GTW35PPSw8Ne6PjwhTEYaFE10YkjuEaNWAILdXBPYiZtTboWpV3tCSe34JfdfSjgyi4SVPCyaVpL3ZMiXPmQ5GUv0nEAbdEkiT1khk89dNl3l4D2GuVHyJ6xlm4XoSSZ7roB77VCD3KhvDZAYDNx2N930fuMWWuog9MVqSurkWzzp2FY0reTUZuKNxQIKpf8f3OKZLJlC4racyHHW/5R0hyoM52hQcd4PEcLBrZZzyzgcaiCxnbyxwndPYLQEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejvJ2/8LOAdrRvZrWys2RdZSUIgTHj7vS88FxoM9yiE=;
 b=LMQaD56KnGmNoH778W/GSZku0KYwGVsacvBENqteSpL9JqkrAT0lYM1T0CV20K/DZ6lXjuD1/DzznV043ohriiuNVg7uoOw28DmZuA+fzL7L2AevPLfQ9Mqi1Dltsu0rXtXHY/6DlpclGcWhl2Fp/pUTqtc38UzTZ3HlT54ceJaflJGTHCn8mMukg8WnBXrY77ov28kp2kgIkKTRgEl3kawKoOJL/+L11wc0JIhtn7yxVudBHq8jJ8a8xFwwirDBGn0pu/l4/qt3NgH/IVjKUP15hJ1SOLFpOmH1U0/OGB4FH4S2LJlhpqSHAAB+1/nefTSQM+iyBCvYRy+nkl36Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejvJ2/8LOAdrRvZrWys2RdZSUIgTHj7vS88FxoM9yiE=;
 b=jETT5I3OszbWsqK92390Y5t5TC8/mQyBM+vgiZRgrOfrsblhrsx+Mg7hHMsL75e1NLNiYs/kBbUla4eLCsmGq93e5h0e0XKG2VspYq8m9zEicI1txX8bKRdtlmsnrBZygIy65CJjfsn68Fl39uPSSA9HrQ3YD/7lTMs3i5j30NQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6674.eurprd05.prod.outlook.com (2603:10a6:20b:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Thu, 17 Dec
 2020 08:57:34 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be%7]) with mapi id 15.20.3654.021; Thu, 17 Dec 2020
 08:57:34 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v2 3/7] ethtool: Expose the number of lanes in use
Date:   Thu, 17 Dec 2020 10:57:13 +0200
Message-Id: <20201217085717.4081793-4-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217085717.4081793-1-danieller@mellanox.com>
References: <20201217085717.4081793-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0601CA0024.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::34) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by VI1PR0601CA0024.eurprd06.prod.outlook.com (2603:10a6:800:1e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 08:57:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e304a24c-7adb-4a96-0507-08d8a269cb99
X-MS-TrafficTypeDiagnostic: AM0PR05MB6674:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB66746484D4EDDE68C47EDFADD5C40@AM0PR05MB6674.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:175;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hfq9WaVt3I0+Xzav4YsTv/YzYMbSgsRQR8BPdEk325cLl34mOR1jrSCvlibogvpqETL9yG0l0Vwld8MjDGHgOwVg3pgyJQYgaSOWfy2eDIFKgg+tnqAG2RRWNOmVyz8McQ0br8nYZhqNVHSiWdgx/p4lRcBB89FqfWzha9ZbQvMm+AtoTVVThNhiDUKuFGo/Tdlhtx8ERQg2GgF8aIWKPdoAKpsGschAa3sLaTSb3qs0IWAPE+veMMWke23zT6R3/qvH3HULjqSrsGkXnOdXrq6o3fTH6eVcrOTAGhIxK+P6bbReRdrPRGpV+2XpgUrNWAjsDoPxcA1LoHHbTcfLbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(6916009)(316002)(86362001)(66476007)(2906002)(8936002)(5660300002)(2616005)(6512007)(6486002)(1076003)(4326008)(7416002)(6666004)(6506007)(36756003)(66556008)(26005)(8676002)(956004)(83380400001)(186003)(16526019)(66946007)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sKGNSSdOraLLzTscj+6+2wQStK6utM5Pif1QPLi59p1CYhGd+aAq+zl1nmfa?=
 =?us-ascii?Q?n3dmBAqxr5aOFLMKxzN/2yOILyJakNfb2zjGYfXo0i8qh98a1n/aNMQtdcDh?=
 =?us-ascii?Q?Nm+4/6Cr31SonT9Zy2ukLpd3EmdvFxlNXtTVwceB5Pdld+dr5BV/97pV1cJe?=
 =?us-ascii?Q?xT/U1OWKxJcim4bdLIs+Dj6AW7bueGnkTDQC3sKpUvG3SDT54stvxRG2CVRp?=
 =?us-ascii?Q?0jYTNNhhwzzKxrNDNCanW4ycb0zb+Sm+wuzZtSmWUpANWyu3icalobpetjYu?=
 =?us-ascii?Q?+ji3zP3iJmlCKopk5PsJ8h5Tf3vNMBaQC1V/PWMFfPjAPD+CP4pwP6WKddm/?=
 =?us-ascii?Q?xIcAscgyvwRYrndOt1K8TRTVTLi64DPFNBsIVkum8Kj0bJmdqyfVbXXgTdaL?=
 =?us-ascii?Q?DmjqfSQZBPP7wVCnOaRp/uWOkY9sD30bE3qB7siejqDpxWooHd8IToINZ6Cr?=
 =?us-ascii?Q?7UQOxiIUGZ3BKYGRcjcsvkbE7qreE1xXu3LR8cWTK4seUBo1ATR62PmPVvBX?=
 =?us-ascii?Q?KxWVyJf0laGV13+9RucOsyHeGAh9gaJmnRDJBJwNDud/XFOL74Gp11rdJD0w?=
 =?us-ascii?Q?OyG7c7+1GQDLuJW1UvUCIx9lDutggModAb1ymYQe56p8i/PxHGVSYSEp/kw2?=
 =?us-ascii?Q?LVb+347EsqbvtWBM+5pi91a5XV5jnNx1slHdy1yLuzcQcUkkKyIjWcBTfVNL?=
 =?us-ascii?Q?QkwSWw2E5/1SCZAohx12YNMR8rWKzAoHhwivxbZvu+t9crz8hJRLkhLmn4LQ?=
 =?us-ascii?Q?2QPPUic8JlFFvULaTJr0gjMp9Z2XvZ7Fz3HN6wIg7lLUCQsZSSa2gIxqzhQo?=
 =?us-ascii?Q?jiS9e/mC8YrgpZvRj47WMNzjxEcecnmEl+PSrokdxrLD0dvKy4mJ7J6SVvzV?=
 =?us-ascii?Q?4rm0rl4wia5bn/zjkwM7AUAAlBVOX++hTXzB7qQbv8AM65goT+Jfa4BaX4th?=
 =?us-ascii?Q?d14VN8BZzNsmXn540BdNstXbP9nRT7UIhPpc+hLESWMeHwTBkOW3IU93P+3/?=
 =?us-ascii?Q?3R/n?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 08:57:34.3224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: e304a24c-7adb-4a96-0507-08d8a269cb99
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcywAwn6uOwZGd3/4fGG0bxUQ30P+euAX2UHp95h5cEmnEFAg+/8qEm9SjwoHyvYJYPqHqa2RmiN4ZegyGRjyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6674
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

