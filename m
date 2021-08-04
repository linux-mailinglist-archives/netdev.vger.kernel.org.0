Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0463E0282
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbhHDNzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:55:37 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:28896
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238505AbhHDNzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:55:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ar7F0iyxWqnZ4KtzJGPkHENKfYFFSThn2XMRlmpBif/76QdJDBBO9bzZKyPThD+D+8RWI5bBCYH3V8aTukRshmllAfdXhlo02X1I/40I03rQed98w29122MTFLax7f3shOdIqMomC1es+ckJAyCdFyUaLKcnm+h5nJXPVCI2Sm2gK1QqkaJdQOWZS62/CgeN37jT15uCtfm8hJPPuOc+t4eBgD1hGv1+TrX6SeyMsebf4FQC9aBJpxUsxjQW1kWKz2udwF21nsupC9qwEem4VwtReyx6Pvbk3uO3odLXqhUQDKDs248miV0WQcpP0h0QjgyxSlGAytze1iSt9CBHkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwI0jm+ZWgmCnORWmGh1d1TegTIKQ6d1GNKUNNMaqnI=;
 b=If0X3elQROAAfdDrNpWILSw7iR2VpyLChfqpEuE8G6rkKsJYu6bLtcffF8KjN4mOGfYvSs+GwXDTvDYSmdxh/MR8YmMHB9xofdSyDFQnHvIjIeK9EsABm3Unz0luBLQQeUpigJldamKMGx795rcBJOCFfU6CsH1m1EU7/ZhNO9gG0F0kBQITdXv27nRPwWfAsbIcyI5x9rrndJNEb6lAXWk5w0SFCCrkC+ZXwJVQ25OnurETGsiw85zd3OlOExusGn+6ZL1zwC8/CVdW2gwkJpDrBNjW/uDmM5OhJIqnk0J5sfj8lx6Q/f4FH9K8XDMFtwae0Xp5uMIeUeToubSE/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwI0jm+ZWgmCnORWmGh1d1TegTIKQ6d1GNKUNNMaqnI=;
 b=SDJ2Oz57qiMoIZu7RsdAuQwxfl0lAtlBHNv2FsmGOMbg3J+NQkiplWZuji0dRMKAUPPDWZNdK2uP4gT6jaMUzm+AGH3uOsMrd3+y3qLeQEBp1Sr2IQbBVnSpN/7u3fCjxaRAFc2kz0/OHWthZXqhck8wjCmX/C0GscJPoP+wIls=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 13:55:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:55:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 5/8] net: dsa: sja1105: manage VLANs on cascade ports
Date:   Wed,  4 Aug 2021 16:54:33 +0300
Message-Id: <20210804135436.1741856-6-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM0PR01CA0155.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 13:55:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e2c3ec1-0a59-4d4f-afc8-08d9574f7a8c
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26878D720BC9C7EDD2D22900E0F19@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+vHxeRtd2OQu61nrmCa+wX7OMkoTsrQ9EqR6Xo05ICKUOeMH9F+fMcQawj+TqDPatxpFH9GTv6APlq6EeTMuo0zY5qEHMUOS02SFWtOdY4gzoKcoUaAEerhUcObHrqjzXcw/MHaO8J/crK+sRw8dgzDu4VsFawCAHC7lzmBZP0Y1NXTw69M6KYh61S7/Z5KEeXdJUCXW23iDxUt6mpfUGsh8cZF0fUg9HBBxGscqPwCjtWfxE9Cq3a9qMaoanl8kLmq1fNndk3D1ZZ2DKUaUBwwNhU68WO3vL0XO/6CQRF9qtx2/U1b5/fr87KArfG/yUJUplq8thiSrRWmSFaKne3Y2Ya0hhzFXmwTMRP9FpVJLcwz4pe7sPxohkiz3v4hfUPcNsK2fQRIYY82ZPiuuzUq6KxndcLx7AnKVaiYo2Yqk4wxsTc1+egRz9+ccqQxD+ecdgDF6C2RpWPihR9sQnzzCDNp2LsOcxKvq2mW6GqV7GaNIwY69VCwMAq3VPtF1t7HiAYPta89TEogyoEtzoleyltIvIgRW98PQBwlB//NIPDvi1Z1fih1bfm3Vr8zmzsUifyQhWYyxtht4ty+nw++FR550okavgo20Wup4AKJZHs8VsW0UDncnUylVnbpdQ/m0UnmTUwG9kSiroXSUFnWySfdLw17tRuIWpx4uCeWw+6E/ePK7cxr2DCtJdToUY6dSfvMQaRqxRErXLvSnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(6666004)(6486002)(5660300002)(478600001)(66946007)(1076003)(66476007)(4326008)(66556008)(54906003)(26005)(44832011)(38350700002)(86362001)(2616005)(52116002)(8676002)(6506007)(2906002)(36756003)(110136005)(83380400001)(38100700002)(956004)(6512007)(316002)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8pU6mvkvvdudiSQ4NRDI/dhh62m2Fgx/i8NJTI4wRdxxYmcu2+nGshST5Aer?=
 =?us-ascii?Q?ARJ1mZN/jSrvQC4dkayg+De494qEh3IydEzMGMOMTdDFuvf515lnINH4Gi1R?=
 =?us-ascii?Q?GvF2KoeckjNcr8BXGlQM+iVBWNhrVYgny7lvc4NOK7GPcN7ou1+DT+ZQt1h6?=
 =?us-ascii?Q?bYHeq5zqSERkHO72EBrQrlWMOxCpjEwVxid9dN20AkKKgk9x/jMMFN5FK/qJ?=
 =?us-ascii?Q?JbpoVtN5zklimGeE4tCS/HBR8HtDTbLBfKitsl3DF7n79TF2nZfJnHJ5a7KI?=
 =?us-ascii?Q?5aA8fxPdBjvP8QQ+UW6GKmuW7nPZYVRrtE8ovQh/cQ86BAOibGSnqHexOvJy?=
 =?us-ascii?Q?G4Lgqg2uMMwQhI2NyDs5Q/6CQq9cajxv/OnUVPfU/UI+aUWogWT+CqqdLJKE?=
 =?us-ascii?Q?8ZsfWuDsDVUd/aX0AAH6URNxapi5nXM2xd/FUT+WvQHH9JePcLiKVDkH4Y6Q?=
 =?us-ascii?Q?hBssybxAScpGq64vhsFpp+Bdsx7Y7Ym6M3WagDIZQZ3t5mqIr9Weig2g2n4E?=
 =?us-ascii?Q?S5h7EqKDKKV/Ykj4kwLBsC/qnGLNVMBG6z5WrUHVuDyCMLPL7TXax/WU3Ccs?=
 =?us-ascii?Q?nKwCGFxDzbB2FdRirlFjvk6gwBwbm+ZOHeneqhCHQRfZa9bfQPDRrEMKYrur?=
 =?us-ascii?Q?G9UdhdGZuYBmi00ojGcbNfUicCLBL+On/KOrS1c5uf1Kc+AVTmLCwXW6OvSC?=
 =?us-ascii?Q?h3V+hCQhKaTgvkmzeNgIhqWIJOfAeaQFt8LXOBEti+aGaGRpNokqUwmiJ+Oh?=
 =?us-ascii?Q?Zpu8zPK5yBjRbyHGKVW4+GAVIO6KBTYvvCOvXBDIgQq9YcJbXChwEMb6xG2F?=
 =?us-ascii?Q?qs2eESReav6M/pz6FrnjPliyzFMVBgx/nucqsPypInuY76M2PRttAqTFSOrQ?=
 =?us-ascii?Q?CeU7NeodE9Uuo5ZY5/zZ/PNf4IRUkpRwu2UIJSj3AEobJKjafLjokSngFPLB?=
 =?us-ascii?Q?EU4n/fKW5aBjB9YZs0gkCQ9P5/hkFAL7PNqIaZbovFMIJH15z1fEiTqSPSdJ?=
 =?us-ascii?Q?MeTCl13NQKlL2eqSc/Pr0Ty9kdP5Uti/UaHrbtgNmTwbUO2cQGBIH8CUe5bA?=
 =?us-ascii?Q?H8KVZOmldvGxcuYjpyDg6VLMxYzX6axBmOL9UFTTCylh44zP0gaTD6sNLgg6?=
 =?us-ascii?Q?WCl9binXEAqsqZF++BIIlaTalAG+blbMSiZSrb5uXbAfYj7wvNV5T4RvrcfB?=
 =?us-ascii?Q?BNPTAnP/F8zzb5O+eA2HpC1/RfqNBkvSIdfQ+PRkpBFvbg2Kgw0O2Cb9SQdI?=
 =?us-ascii?Q?cr1qhuFoag14zHS6gOwYY/wQHC8Pqk9dw/HguH1rObKAh5Kz89GzYlm30giU?=
 =?us-ascii?Q?qZrGs236NM6sc1djHLsyMdFV?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e2c3ec1-0a59-4d4f-afc8-08d9574f7a8c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:55:12.1178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YWi0oRTG209Vzq7lqx4BmTChx4pielAJnh7iLS+rxqAN3eVbnf4ussIvWxqI6Ny0PsQB9TKLb25KFFd10jRLJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ed040abca4c1 ("net: dsa: sja1105: use 4095 as the private
VLAN for untagged traffic"), this driver uses a reserved value as pvid
for the host port (DSA CPU port). Control packets which are sent as
untagged get classified to this VLAN, and all ports are members of it
(this is to be expected for control packets).

Manage all cascade ports in the same way and allow control packets to
egress everywhere.

Also, all VLANs need to be sent as egress-tagged on all cascade ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 66a54defde18..d1d4d956cae8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -460,7 +460,7 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 		pvid.vlan_bc |= BIT(port);
 		pvid.tag_port &= ~BIT(port);
 
-		if (dsa_is_cpu_port(ds, port)) {
+		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port)) {
 			priv->tag_8021q_pvid[port] = SJA1105_DEFAULT_VLAN;
 			priv->bridge_pvid[port] = SJA1105_DEFAULT_VLAN;
 		}
@@ -2310,8 +2310,8 @@ static int sja1105_bridge_vlan_add(struct dsa_switch *ds, int port,
 		return -EBUSY;
 	}
 
-	/* Always install bridge VLANs as egress-tagged on the CPU port. */
-	if (dsa_is_cpu_port(ds, port))
+	/* Always install bridge VLANs as egress-tagged on CPU and DSA ports */
+	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 		flags = 0;
 
 	rc = sja1105_vlan_add(priv, port, vlan->vid, flags);
-- 
2.25.1

