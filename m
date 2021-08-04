Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E253E0288
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238557AbhHDNzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:55:50 -0400
Received: from mail-am6eur05on2087.outbound.protection.outlook.com ([40.107.22.87]:27905
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238510AbhHDNzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:55:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFEvd1y6feLl3ysUPg4GGv0cu7E1EWoOTVRNAvd5YKZjdTv7KsWIcMvTg0VvLEkX63Az25J4uAtgU5cpZlNnjArq/0+W9ryoeP/VDgyKrSkiidBXPNC1yY9+ozaaj3EfTC3hoKwPHTocoL61XrqZhAM9vWLDu81Iscf6wXp9w/0soD9MZgX5ALGrxcNCHV22b9fF9FzlD8z1y7tPB7FJb5I7RSiKrpbDJqzBqpm1EuUNyW592sRwYu7nSg2iNbzj2gwAnrQhlRdVVe7Ox2CFz4qlifDXjZnG3uD43sHLO6wj56bCISVA/X5NJwa8ZnYO2v07TM9BncfsAGPjL9ju2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFP0ZDXnCmxYhygfqgxLl3BCxbUOVWsrQ3TY81MvUAI=;
 b=H3Xpdhexm3mfecvFbKbIJ1qtl+pLmaq9I+0OUlEvfrTQv+ZMp1rdg5bgLP0SUCoTVgeyhNpoIy98vrqvXUnaIpDWkh6ptKRKbdPfq+7CKNyrqglH3qBKBDaZgxLj9KAlKpxchc8y2ggzGPwCgDUythEWkUbUwtE7QI6YmMTZcDhmMZU+KvNP1THGMzzQInBdY2NtUEp3MMpXfUJLOi4HwULz34KmTZOjL26x2gtFlMk5AkyDf3EIeUoVFVrUetqMmpyBQ3r2xgRZRqhDuxu07XU3qPL7DwxUSRLXQU0ns+WAsIxmVxIEL+eXRsKgxGTr2Htp8Jp4/ZxpgIP4+vKlYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFP0ZDXnCmxYhygfqgxLl3BCxbUOVWsrQ3TY81MvUAI=;
 b=ULZ3TkIB4f5NsfbRNmQaeq+cdlNbdcemWd9kLAA5jC+ZB3xQSkC8u8/YC/VwiCMzagRqAm2fdsCoMpIKEvsRBH6h0sAPcg95/O1q3Ky3sBAcT97FhXVbGcXmz39MblHPwVqXgQ28i/zHbWYOT8HBQ48VBnxkI/uXAntx6IM+Dx0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 13:55:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:55:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 8/8] net: dsa: sja1105: enable address learning on cascade ports
Date:   Wed,  4 Aug 2021 16:54:36 +0300
Message-Id: <20210804135436.1741856-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
References: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR01CA0155.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 13:55:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b7ccf8d-3966-4dfd-8368-08d9574f7c42
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2687A0AD0AA9C2C3393E3AC6E0F19@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wF/U2THdC+h0teHETrmrVT6OemKQPOkFgcueMU+RAi+GJf0zTKWudN4bXUQgdWtOYS8OWZ3hpgQW7j0vAoR0VRpi5Jq11wMQHkpBsltqKo2VxbFZ2VNSpNyC1Jw/FmFlOwtKu/gcUAeK7NGX67KstnNw8AwbRlQUM6KWzSbJhY5dN1E8dn9tih9FtPkkyVikQIRgDBrhtSvU/Pk+xuj+JSEHl8uV/Z9dkfv2B7ydSGtcC0WG8bzVci1w2ywJqtA9Fja8KNXEufJonlBWpp3XEDId4C5a7v49l4kMfIlMld9166i25YdRsqog+sbw4z580ssxA6MFzIdxLTvRST1JG1FWsUnLE3ZzT3r4C6s50ntATbjegByJaRIkcgVz3vBPil8wLU98KLLola6GfjhGjKFus9ycKonuD/lWK3Vb46NDGXLdUZinMI0TlAndS4tgrvR5rDcQW8d9jzi2+nkDaabV3D0/JEhDUGEU2snhDe0RpRX9aKyiVh+i/EfiKMZcVNg2Q3SwLvM62iWBNgGgfOJekWviD6UlPKSe0GNgDIkR9oK11vIfQwDQgrmZIf4ALizUkvOb9NqbdL8eq/GjqgaADtTMcZVrW8mnu1NvSP4496pWd0D9VP+ikyLRD1eEbpdGpCCXAW55CizoBcj8Ec92mL97cJgxt3IGs41lrPs0Xk7DTNRSVSjs+OuuE0edy2DKRbDxnHTcVDwmN2rURw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(6666004)(6486002)(5660300002)(478600001)(66946007)(1076003)(66476007)(4326008)(66556008)(54906003)(26005)(44832011)(38350700002)(86362001)(2616005)(52116002)(8676002)(6506007)(2906002)(36756003)(110136005)(83380400001)(38100700002)(956004)(6512007)(316002)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8UeEGJFqtcG93PUeWFtUtAla/NMjWWA7r4Uo027pCgM+4pY7/r4/Ag2yL3j1?=
 =?us-ascii?Q?MGOq3rHa4+HlldhTakaN3bGJisWAy9gVLfveRiJ+pD+NlQrgkVVNeVOxLCMr?=
 =?us-ascii?Q?K8auYPuNmzmRufJ+1j//BZTbAfQ4fG4dOApQIC0i9MZ4bo4F08UZC6PoyB7R?=
 =?us-ascii?Q?NwgDlGTlj085M3WJqVdEVeDGJ+8qtOBrTkhKKZi/sTxhpckmO6spzibByAsl?=
 =?us-ascii?Q?5MMy8lxterIfPkEu3m68l7nHDPo7NZbY6rI6G1FDqe/9Zdv1Ty+tfILNYfXw?=
 =?us-ascii?Q?nmexhNsI/L3MIdOU6CQ0Tw8VUlnmQOoR+eO8kvxfXyvRWTn/pMrD9FP8f3gk?=
 =?us-ascii?Q?G+aoGRLgSv1zGs/VWiDZzHT8aBLaZ7fg/dQrZ2lwUUgxpi48p1LP/h+RnxHp?=
 =?us-ascii?Q?97JXip1LFXXp4qN9fm2iGi8DwFfe64IVHXhlfT0drGfCojIo/ZwvewKv1wB7?=
 =?us-ascii?Q?lihFhru6w3HlOCAJMyXVdym5KOTXV6PRVk7VSU1DvqpKrOD7Vl7ODydQinxd?=
 =?us-ascii?Q?oSDQz8BxFdKIDxOFIt2VNNNkHHtItbJZCEJjbLdnd4g65T1FjBlPpczxEgN9?=
 =?us-ascii?Q?N6iiwlyPtLnLGtdtUpml929gIN20Ow0W1SOB+IpS3RPL3JACAOpRcAOIhQDI?=
 =?us-ascii?Q?yMw+JBkg9f+3QXTvmT9jH8WWSeH7sv3AdI4s2+VGYgm2lOCu4VFzAldXrhcK?=
 =?us-ascii?Q?p9d4QmYGTkQzUrLc8ANYJF9hrUl6eH8jqKshfMsQs8IlW2Wzgq8EK5xLl9V5?=
 =?us-ascii?Q?i+0qJ+QjWG0rs1BNxpiFRsk4f2/Oizski6XMkXlFdStpCjFBgaxe45+33kbG?=
 =?us-ascii?Q?/ZJWTXHoriq4P+qiWRMHRyFEDxKr0kDh8IRShayEsA+U/67DG1jNnwriRZHX?=
 =?us-ascii?Q?azdokSARjwZq33BM0ZFBnZDqGKAoLH7r5OAv4xnNsExULNUHA8bRoVURJW+B?=
 =?us-ascii?Q?9DH+WaOk1+dkm+m/9EnNrPEl1IhGJNk5x+QTxitIwY+fQeOiqki/oJrc/+FA?=
 =?us-ascii?Q?zHAtYdxUNyA0/k14LcU69dtFhudjvSCGxL/LhhXPznzFbFJcDmD7kkAR7RdC?=
 =?us-ascii?Q?bTn7HGypx44tUq/HULNPw+0aiD6MmODsN/+tvevVUzpizB6HBSnXg7GNbCUZ?=
 =?us-ascii?Q?Es/yDE3bihnzjblaeX/BEFytrN693MBEhxgeTtQUYWDeE23Yl23Gzg1oXZQs?=
 =?us-ascii?Q?7hNo4+eRYKqkCRWATZKPwCv1B6OmTUSF/+mCic/DAa418qtj1CfAvdgq5Xls?=
 =?us-ascii?Q?lJ3QGuZ4qFA1Xn/lDCGaiagCpgkKFxfMTmFltKvPtu28TUv6MXa6JQougYBQ?=
 =?us-ascii?Q?lfLt2Hq/j6/JYXK5e+EuLzI8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7ccf8d-3966-4dfd-8368-08d9574f7c42
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:55:14.9921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ODGNJzk5LE8a9RWnNzFVu2Th/D3KxaUAkYCPgE/bU+aUYgA2K2GVamWiA47S25ImF75ThYiEvy+jsTNVsUrCdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, address learning is disabled on DSA ports, which means that a
packet received over a DSA port from a cross-chip switch will be flooded
to unrelated ports.

It is desirable to eliminate that, but for that we need a breakdown of
the possibilities for the sja1105 driver. A DSA port can be:

- a downstream-facing cascade port. This is simple because it will
  always receive packets from a downstream switch, and there should be
  no other route to reach that downstream switch in the first place,
  which means it should be safe to learn that MAC address towards that
  switch.

- an upstream-facing cascade port. This receives packets either:
  * autonomously forwarded by an upstream switch (and therefore these
    packets belong to the data plane of a bridge, so address learning
    should be ok), or
  * injected from the CPU. This deserves further discussion, as normally,
    an upstream-facing cascade port is no different than the CPU port
    itself. But with "H" topologies (a DSA link towards a switch that
    has its own CPU port), these are more "laterally-facing" cascade
    ports than they are "upstream-facing". Here, there is a risk that
    the port might learn the host addresses on the wrong port (on the
    DSA port instead of on its own CPU port), but this is solved by
    DSA's RX filtering infrastructure, which installs the host addresses
    as static FDB entries on the CPU port of all switches in a "H" tree.
    So even if there will be an attempt from the switch to migrate the
    FDB entry from the CPU port to the laterally-facing cascade port, it
    will fail to do that, because the FDB entry that already exists is
    static and cannot migrate. So address learning should be safe for
    this configuration too.

Ok, so what about other MAC addresses coming from the host, not
necessarily the bridge local FDB entries? What about MAC addresses
dynamically learned on foreign interfaces, isn't there a risk that
cascade ports will learn these entries dynamically when they are
supposed to be delivered towards the CPU port? Well, that is correct,
and this is why we also need to enable the assisted learning feature, to
snoop for these addresses and write them to hardware as static FDB
entries towards the CPU, to make the switch's learning process on the
cascade ports ineffective for them. With assisted learning enabled, the
hardware learning on the CPU port must be disabled.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b3b5ae3ef408..f13a6766dd41 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -199,9 +199,13 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		mac[i] = default_mac;
 
 		/* Let sja1105_bridge_stp_state_set() keep address learning
-		 * enabled for the CPU port.
+		 * enabled for the DSA ports. CPU ports use software-assisted
+		 * learning to ensure that only FDB entries belonging to the
+		 * bridge are learned, and that they are learned towards all
+		 * CPU ports in a cross-chip topology if multiple CPU ports
+		 * exist.
 		 */
-		if (dsa_is_cpu_port(ds, i))
+		if (dsa_is_dsa_port(ds, i))
 			priv->learn_ena |= BIT(i);
 	}
 
@@ -2509,6 +2513,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 	ds->num_tx_queues = SJA1105_NUM_TC;
 
 	ds->mtu_enforcement_ingress = true;
+	ds->assisted_learning_on_cpu_port = true;
 
 	rc = sja1105_devlink_setup(ds);
 	if (rc < 0)
-- 
2.25.1

