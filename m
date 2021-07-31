Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1933DC1DA
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbhGaAOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:14:48 -0400
Received: from mail-eopbgr40043.outbound.protection.outlook.com ([40.107.4.43]:13735
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234449AbhGaAOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:14:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqS7O+2mNvtyKupWSx5yPPT2j0g8zNk6XHCWutEXlkxto9Is6y7PKr+mrwFz7lf9eRxLkuBKk1Na7kyYyh5sd6/299YIOlGFn65GtPeIKCV/1Zrh3J1SU5LFdgdUs3ztBJa9Gn8OAogrj4DGmrK3ZorX8FxHGl9wtjqKI05wyb0BGoYIDRhGQ2LjZ5BxMN7PHEBvySxyd37acSTFEKcA6vygD+XuU01SEwlIBp6ITV5iIUqP/pc0U5gET3XXgrQ0dQWma9kt2uMA723afAWW0wL35VA0rjPR2rsmt1oXYo7aFpuqo57BY163qbDZsAscczQHE19aStkuntkcnf4ISQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEtCJ1X9G0kmqlnTdHcBIMQ0/dTooO5wwsOTtCqwSFQ=;
 b=WdQoalrLfsouYZfCXWWR2pdjpyCZBzOnrKs+Knfl+Ho0tZEvfAJNvjL85CGSZkc1VLNqAxugyl6savt1Py/jPpPjtje21ToeOZjMj+ZgVHNtn2JWrWR5Xj3PkiA0VYkfogkwQjUm3M5lW4i2u6jyDJIlw6QdEiXoRxzzWvwTuClDSD9OCi6jgHFdhh9I+dQ2IfYkhiWn+cTPJWlWFNnyIvUBWolc7c/eh/h21Mlt1uS9UoORuXuSbGQgXhzt25T7fFpyxcPLzgFa5lRaZ6a6rnLTkGTXgdHTq8ueYcmfZFj1TgJCVOzxyvCZUvX/ZjRcaOzpz76S7OzvX1O5ecK0qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEtCJ1X9G0kmqlnTdHcBIMQ0/dTooO5wwsOTtCqwSFQ=;
 b=nTt/Ea54N2OQAq9EqaM4dHHCO16YuvVzXmDPRF6jKxE/ee9PcV1DZ6z6fZ+5oRrsbdnVunNBb02FDG4SCeQQJIKOLQpo9IRrmIyqVf/bofwgfySelyqk0/FFtYTeI1H8kOuXqXbOyOjxKmjr/xKJDjhQanlOGVyPwslupQVzDAY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sat, 31 Jul
 2021 00:14:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 00:14:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH net-next 08/10] net: dsa: sja1105: increase MTU to account for VLAN header on DSA ports
Date:   Sat, 31 Jul 2021 03:14:06 +0300
Message-Id: <20210731001408.1882772-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
References: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0161.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Sat, 31 Jul 2021 00:14:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce801eb5-445d-45a0-f8f2-08d953b82907
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6511A1984004A2230BF9E172E0ED9@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U2pJluD0FWyjB6wZ0vnTJd9kcCTaVIjDOpugfkvuDQb4ToiqPwdCqFneOZxg5XDbshlhzti7TkC9jjfMOPTU79LV/JEfcKADxb+Ymu8EwBvytcLlcbpFN8C6bBRBETWR0mV/Gs/BkhRWE8ieZ5fIUH6vDPXh7fo4McjkN+Meut+EKswFrsHJUSTJ82wveFBUr6AX7EgXs73xA326kaO3HNUrppFfNXzmaBy7uLGHmJ14DPhZgbXdvlc/fIft/URCcWZfk37y/A2OM5cSrB/zAhppMCyrQwcjiglYT6LAOuJ7GehSWidGF/vYgXsaq28qYXhnl+QVgmD1PotJBAFg1ZC85S/Dju2+andPb5ZbX0M5xBPdyxgkF84MfyZV7DLdKpeB7P/Ls7xJanCczL860TJ3zZogoh3LZYNEjFFYwZeaLqA2uabQS3U50PAhrARvT491NYcU01T2xTmFdRSlq7BuiP4lb8vdka4wNlp28Sz7T3s/j8f98LYJ3EWguFn22vk+7aMDVSe7MgK5mIpYgPJA0jog5QvY5s6peWk66KFkobkUEEQqmUypRwtcLUZ64i1JzgPzIVRD4i8f9N+ScW/y8D6TPkH0YPQmBpEW1WT4bDziM0iIqQlz17xDlp7xYGUd8JWnDHimAWTT2Lpq77UaVDASlqzfop/Evna6b63ocu3Sb1+KTu7CE7OxEVfe5juZ/aIMgr5+o8TdVf7wgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(8936002)(6486002)(6506007)(52116002)(6512007)(508600001)(66946007)(66476007)(4326008)(15650500001)(66556008)(956004)(5660300002)(36756003)(44832011)(38100700002)(38350700002)(83380400001)(54906003)(2906002)(8676002)(6666004)(1076003)(110136005)(2616005)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Prt0DLKyLFec0N+M/bfxMHXds00PEdsl2jKa4Qr/DTJRTjWIvXvVCcDybEF?=
 =?us-ascii?Q?xy22pB9i6XEGLEJUlASb0kQ5j2HpeN/wbtz2TGzx1uJ3ml0Ru5PUOsiw+sG+?=
 =?us-ascii?Q?bmTNmRCQv8y4xDyBY3m6xqRqXtd0DF7MFTduGc99eDYCBje3dZJrDIcsvcSd?=
 =?us-ascii?Q?TQeWwdG0Ar7WfRPPWUcifLYTb2LL1LuQD6x8WyyFdVNF/ujBMe6QMc6/6OuQ?=
 =?us-ascii?Q?gNS8g4NaRtUjOvTdYUQrjnbTAHd3kvys/ft3uuCGyz9Rbb3UH17/rQKBTnbX?=
 =?us-ascii?Q?vvnlOmpXvhItd5VReMwgnchx/q/QBOh+VQ9TWvEo6Zj8c9i/HSYiXV/aQCuP?=
 =?us-ascii?Q?FzaeswXBszlbVaSz0wKWt9TO3s7oJOhsGCIrjvalZlju3NUPQK35to3FMzUj?=
 =?us-ascii?Q?CBFpF5H8ySHe8Y8gsxOinoqAuTBFH4vdcj8i2htl8SVPlTdZ8+Z9k7VcLAxx?=
 =?us-ascii?Q?TYcghfwr1kfzCa9ePRvPxyAJcaBxm85ghX1ymcvuA6goG+GT0n4xw5p+rTwS?=
 =?us-ascii?Q?3AJK+sY3A2HBZ0NJKuzGaDn8w9JOwPrMKnougK8dCGCO7nG4hPZ0uxHu+B2k?=
 =?us-ascii?Q?mMB1gnqJN/yUvxN+94bh2ZPCV44tjZ42LwvycDGXnz6sltyyHXPkdmfUnc18?=
 =?us-ascii?Q?sFRwzqXM6BAUuKTxPp5zKmYB771NwwtgSCKymKBonl8TypZAFrnNsOsJIIQa?=
 =?us-ascii?Q?H1c/lcUBS0jLdIrLbWMVhNVblzzrUM91Mf5w258m4khgDhVVY7JaXiRtjur2?=
 =?us-ascii?Q?sDAqVyodBXRxqFqOY9d+0t2scUqmJ6tY0w+6zju6njBL95IJ6ON9f3YOUXw2?=
 =?us-ascii?Q?4LF7f61P7fszJ3BCiNr+mvU2ZQN8syd0hR53eaOcVfHy3vWV6uklQ7LUrLoC?=
 =?us-ascii?Q?Xb0si1VEMkGfxzfVRomBBxwOrjkmcT7IKbOlwW1vEMjAs0YS7uBZWrzOKom1?=
 =?us-ascii?Q?bJxtoJRWd+5X9CMhjWtvFIaKkJIy56+sgn7Oju9pWXa40kk4TVj/fnR1Fykq?=
 =?us-ascii?Q?eji9P+TQXGEdBtl6kUWcNIu7ShNBU46fn6x3XwXCSPVgCwgcGoJatcF3z4iT?=
 =?us-ascii?Q?tvHR2QRtcBXO53tHDx4qXwq3lQz2AfTfMVpiBr4ceCJoGOA/pZoM7un0hQv4?=
 =?us-ascii?Q?/BbPzYXqFllfb9nNaF8oQMI8V3K96e61RXFRTexOOGHLk5AAdkfuuEgqtF3E?=
 =?us-ascii?Q?FmNnMQdEuifM++0ef11BaiqnL2CP93ntuMM0JJ/c4Tn3Lf62xUYZS8QFTeKl?=
 =?us-ascii?Q?OU08DoC/FDUIoXeBUJ7b+eXqE8UYD49t1mAP9n4J1KcHKhd21vVVQYvQ2LTY?=
 =?us-ascii?Q?79Fn0Yo9pGfKm2J99h4KCCar?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce801eb5-445d-45a0-f8f2-08d953b82907
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 00:14:27.8901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FeiqD76GWyI/OQmyfyK3opiqJ8PtFBpZ3gSV8wJd+aIVuQv1Eo0vcD0Onrq5p3v4+KP98UxwwG4AdieKCSkdSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since all packets are transmitted as VLAN-tagged over a DSA link (this
VLAN tag represents the tag_8021q header), we need to increase the MTU
of these interfaces to account for the possibility that we are already
transporting a user-visible VLAN header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 31dd4b5a2c80..2bca922d7b8c 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1020,7 +1020,7 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	for (port = 0; port < ds->num_ports; port++) {
 		int mtu = VLAN_ETH_FRAME_LEN + ETH_FCS_LEN;
 
-		if (dsa_is_cpu_port(priv->ds, port))
+		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 			mtu += VLAN_HLEN;
 
 		policing[port].smax = 65535; /* Burst size in bytes */
@@ -2714,7 +2714,7 @@ static int sja1105_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 
 	new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;
 
-	if (dsa_is_cpu_port(ds, port))
+	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 		new_mtu += VLAN_HLEN;
 
 	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
-- 
2.25.1

