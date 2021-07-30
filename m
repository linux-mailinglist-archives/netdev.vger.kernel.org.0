Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9863DBD96
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhG3RTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:19:14 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:45569
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230251AbhG3RSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:18:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HU2IOZCMEKyFsdkGuyBWSHhX4pbRwIO39/XbUqQ3xXMCfaq5JJdUsfSYCuGqhJlheTexWk/hKEwwn1EnGh8K+RQq0iqqpHN2ySkz79xozIT/LhLOrGUId4t9uP7/PxqEz+7SosrHfT0dfTJEuqWL9vtG06VjofRsDZBXSp8UHfTGhKPnyCzwuAGMrrBcV+X8E/w3bX4bGUA2/FK+MIB55AyD+msalIP8IavxjKNMhJY/PToPcu652ZxvbXdrN8JFCWCDzQbMcH6b+UPbESpENRf6mLYNDEHXQI8C4GSHLkPZL7CwSBLAHEJ1tbt8ddVcJ+1l1TUQDAm0QiLcir1LtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6isRyCG/7HzIzO6bIZio6G8gyoGZBNzk6xDybmiCWaI=;
 b=cuox+Af0itaZai8Zvgo4whExmJeUbcthjoWq+lYJ9xzci8y+9cyZ80iXlJoT2ZcYxFPLD49pRm8oHyTk6hs63sw37XDj6ACwsSR2DVxuBW3biRFlLpg9GnUWnSw/kxkqJZYpNNvDJwSMdGUUKZIwqsd32Ybf56Y6rcKANBcAQowYcQrOtkvCE+uIKoHu9slBGFVJWQbfca66dfyMLHoJBiJnmLgVxGUIpTK1SxpZQBNT9+nC5r3fRnpCOdwWwB/CcsnB/IJGi1w9txLIjZlSJEByNQi64G0V7BIe26qwtBU09zfAve1GnNqSTS44OwvKPTt8DEoncEz/ex4p3+pDvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6isRyCG/7HzIzO6bIZio6G8gyoGZBNzk6xDybmiCWaI=;
 b=PHMa/OsgMzEgzhXSVXpgstzSaM8DmawfXuFhsGybnQ9zAK8Tx5ydrUL2SgqjHghJtCOcIY3pU/oHHk1mp7RZ8qTFQFSd/JDlyvLVKKwv5yimVbL2jURu8V0f5nTwwJgNkFyTe/GLK2Wa9j5UHCCUnCC0PIlbPLmyRT9vIM/vTZ4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Fri, 30 Jul
 2021 17:18:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 17:18:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net 5/6] net: dsa: sja1105: be stateless with FDB entries on SJA1105P/Q/R/S/SJA1110 too
Date:   Fri, 30 Jul 2021 20:18:14 +0300
Message-Id: <20210730171815.1773287-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
References: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0008.eurprd02.prod.outlook.com
 (2603:10a6:200:89::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0202CA0008.eurprd02.prod.outlook.com (2603:10a6:200:89::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 30 Jul 2021 17:18:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ff5ba6a-4d14-4fb2-608b-08d9537e15e0
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB396743E3D9EDA9CD47368942E0EC9@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PdA//IMv8xwpWoeWkzCo7m8yi+HiFeHY91X4HUjitCzi95yFD4L9PU4s0cvCDyN5cUUswuPshqNl+WdGIMiUSIaYaBEVJGchKf9uDcj/LsA/Gq1pTdehzn3/lFULkCcRk+UYSmf4GvtuARQuY/4+eVaWedFUYW+6DfE3c59R2XIxWEqXX2Ab+JKjqmej1govLEFZkxegBn0jAubYDgQkq1WAXFie6oFqbWTdS0PZla0nTi6GxXRzcu7q4eHTf7jRkI7kuckBLrg6LKQOuAnd5anGFtgr2Sw3UIUVkafclLelkXM/hZ8X7+j3sdWm8agj6thditZBddxR6ZH1vGVdbJUHKYaIp02Gd9LJ5n6mjuQbZKTX+KsToLNZ7IyQ+9BvYdP4HcFVOvYBxJNCGckaXNNHTKek6rWz6WTOcme94W03AShiLLKMCoW3qfkolGXhOKoMgeEbi17y9tYa83e7e3nW18+C1xzfFhFwALNmrKUEaZAqO4mlzL6lFTOvUGMb8vAhLkoc9UJRK+BQbKv1ja/maT54LfXiGh1AFU8H2KIBxtbQZGqUbbxLZZvWWEe3XAUUNzjIZXL472xcevhUQVVzfF0D2XNdKboTfOrnn44BdrPdxycS6TpUQgKXXVMRrhha8tChw0NWPEHOk/M8AoAhRhb9HRYUueGZfvphd8aL3YpU3ZPWnElByES52GpJdRhLDx+igKGemXGUGAhN+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39850400004)(366004)(2906002)(86362001)(6512007)(6506007)(478600001)(956004)(83380400001)(2616005)(316002)(38100700002)(36756003)(6666004)(38350700002)(6486002)(44832011)(52116002)(186003)(4326008)(26005)(66476007)(8936002)(66556008)(5660300002)(110136005)(1076003)(8676002)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6/8ljFP5leP/kl2Pzmm7ICye23PdRWzx/dm5fxtYgdQGPeIwY4L3oOAGfWgI?=
 =?us-ascii?Q?V9o5TgXs5aOIWlZkPVj6IaM9sEao2ctr9bz6627A/+rtk3raH76oBQdqV9rp?=
 =?us-ascii?Q?EqQp1H/OJlwX1rU7icGdJsul3DbEVhhxVyAuLHz0Zd2s3YwXKgQhPTLxg7fA?=
 =?us-ascii?Q?4F7JEmvzE8m80skeccNCpt7SWhILrTZOzoldD7UI4HBJ0Xevqk8VR8fpYgwb?=
 =?us-ascii?Q?kPGgEbBq/HqhPdfNy+ZWVGcc91kie+GxwHBqU9apxXaZ+YRk07oJsh8hTuro?=
 =?us-ascii?Q?7B4egVutMWrezOelxn0Hl/jVakZHDjiMJwMAljWuFzv84X5J/t+GglXiWErZ?=
 =?us-ascii?Q?dypLJKag7vQiLtq2vObtUTwlZK/AE3Mo7bugv1GeE+IvZ876eBkAYVS5oj7J?=
 =?us-ascii?Q?Q53CznYn6ggTh+Tpq7Ke80KNe1QQAUZwQ9zf7DB4rf5AIK8HNaYlgJw16Pi1?=
 =?us-ascii?Q?CfMa+6QeI9knFNi9hsw1BGzOreq9BbFsAtWgqP1MeMfFnhLSlcEFvld/bG7j?=
 =?us-ascii?Q?nHN6qxvj/yuxHc8EP0mX+ADI0Q+sbWpcrSucU6isnmqfo/vX+SeoKkpQ77mH?=
 =?us-ascii?Q?Khm+ny9ghnoWHGhXn8KggdlABa3jzMzuvCmJOaD/OhGgzAWg/KGi2otMvLQH?=
 =?us-ascii?Q?mkALecQMwyE4pBHoEsOjPNcF6oMPYRwRHxve/8HLcJLo+P+h+M0lWGo3aJs2?=
 =?us-ascii?Q?cqZa1Z6TBNZlDykZXnTrLMZMVL1V79DKG09rHCLYUMolUoOr/Xfgav7v/Kyt?=
 =?us-ascii?Q?xtheESaTgoe9bDNzuxDmq5sObBDg5mUPYhzyt+8ADowcfdDhOouilaInEuZn?=
 =?us-ascii?Q?zZJro4qqOqxfELDIrGdaC2Zdkt1o+nGIFwgRKIflyTPDKwUD3m+8I5hCspTs?=
 =?us-ascii?Q?hCYJ5dbSbLS8LX0rFJNSUCOAoGJTARXjRVh5HJhhOSnLQjuOJDcHQYNA4F5s?=
 =?us-ascii?Q?Vg+ecdbw1NW621ZNUUSJ6256qOxZnsryHKfd2bnLzTSekL70OTee/KaymdNv?=
 =?us-ascii?Q?8YQIQW+n3O62zgWHQwoUHYSEIrTqKbvadw/JmSu64s14pqGF7iYcrruagcJq?=
 =?us-ascii?Q?eWxihX7XzjeaAQVrKu/QwqezdRBxVTdm7zQAv5MrQkkiUCl4SvS1IIp/eLNh?=
 =?us-ascii?Q?sd7j3ysqfPvAFrCW7OGJovz4C5daqMUrr5lOKgjoNz44j3S4AGs9Vup+gtVy?=
 =?us-ascii?Q?LDL2P7zzlCBMkVxquMLu4pxOyts/c7Rpuz0xy0vf+Trx3r2QH21xWpRn7d2G?=
 =?us-ascii?Q?0VR2AOt5J4TjRQH97vsz1JTCF2Ec6V2CrS3PHu96QqOLiBWjEhSGsjfEBFRu?=
 =?us-ascii?Q?Nf0/2xKORhI62/pngQ/VrQ2G?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff5ba6a-4d14-4fb2-608b-08d9537e15e0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 17:18:44.9175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GUwej1ZIxsO7dGKCH/ulGrpfvIVD5MFsU88rL0otukFjkKmu/1bw684o6jWBYKwpjTFGwc7MWfWhpjfYyom9tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar but not quite the same with what was done in commit b11f0a4c0c81
("net: dsa: sja1105: be stateless when installing FDB entries") for
SJA1105E/T, it is desirable to drop the priv->vlan_aware check and
simply go ahead and install FDB entries in the VLAN that was given by
the bridge.

As opposed to SJA1105E/T, in SJA1105P/Q/R/S and SJA1110, the FDB is a
maskable TCAM, and we are installing VLAN-unaware FDB entries with the
VLAN ID masked off. However, such FDB entries might completely obscure
VLAN-aware entries where the VLAN ID is included in the search mask,
because the switch looks up the FDB from left to right and picks the
first entry which results in a masked match. So it depends on whether
the bridge installs first the VLAN-unaware or the VLAN-aware FDB entries.

Anyway, if we had a VLAN-unaware FDB entry towards one set of DESTPORTS
and a VLAN-aware one towards other set of DESTPORTS, the result is that
the packets in VLAN-aware mode will be forwarded towards the DESTPORTS
specified by the VLAN-unaware entry.

To solve this, simply do not use the masked matching ability of the FDB
for VLAN ID, and always match precisely on it. In VLAN-unaware mode, we
configure the switch for shared VLAN learning, so the VLAN ID will be
ignored anyway during lookup, so it is redundant to mask it off in the
TCAM.

This patch conflicts with net-next commit 0fac6aa098ed ("net: dsa: sja1105:
delete the best_effort_vlan_filtering mode") which changed this line:
	if (priv->vlan_state != SJA1105_VLAN_UNAWARE) {
into:
	if (priv->vlan_aware) {

When merging with net-next, the lines added by this patch should take
precedence in the conflict resolution (i.e. the "if" condition should be
deleted in both cases).

Fixes: 1da73821343c ("net: dsa: sja1105: Add FDB operations for P/Q/R/S series")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5d8739b30d8c..335b608bad11 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1447,13 +1447,8 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	if (priv->vlan_state != SJA1105_VLAN_UNAWARE) {
-		l2_lookup.mask_vlanid = VLAN_VID_MASK;
-		l2_lookup.mask_iotag = BIT(0);
-	} else {
-		l2_lookup.mask_vlanid = 0;
-		l2_lookup.mask_iotag = 0;
-	}
+	l2_lookup.mask_vlanid = VLAN_VID_MASK;
+	l2_lookup.mask_iotag = BIT(0);
 	l2_lookup.destports = BIT(port);
 
 	tmp = l2_lookup;
@@ -1545,13 +1540,8 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	if (priv->vlan_state != SJA1105_VLAN_UNAWARE) {
-		l2_lookup.mask_vlanid = VLAN_VID_MASK;
-		l2_lookup.mask_iotag = BIT(0);
-	} else {
-		l2_lookup.mask_vlanid = 0;
-		l2_lookup.mask_iotag = 0;
-	}
+	l2_lookup.mask_vlanid = VLAN_VID_MASK;
+	l2_lookup.mask_iotag = BIT(0);
 	l2_lookup.destports = BIT(port);
 
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
-- 
2.25.1

