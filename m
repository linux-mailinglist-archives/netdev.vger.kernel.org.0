Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D27268B02D
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 15:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjBEOIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 09:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBEOIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 09:08:18 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2048.outbound.protection.outlook.com [40.107.6.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDE91F918;
        Sun,  5 Feb 2023 06:08:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gromoGcPMwVnqsrTZSX7Fxhw3ipnoDetJXyHtc8oVXyUobTjlKoR4/DzBw97f/qsufOGnIuZV/asziC2dh95Onqd9ExG20IW+K25jHKh4ztjNAyBpb8Zl0FKezUKIil/hNdR4xnFoWCXtBQayEyPZ1EHjMtWN4prKTNMKOSXjxL9uL138psKovofjPVSfkyhax6vUewxUFVMfAdTGg4jiJ/ZUamtxjJyHmaZIP9L7fcdMqVgGSBFR8klCHC0FX7Z9i3bY5e3u9AKbc5ugzQysiU7WBjCcLXxQDkZqcMKmv0cAHw1vmTOlCzOLUHT05euE6YaGDY1N8CQ3WNuKeYrxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jxxr2yQ5S/NthU3f8DVdtDcg4i5m1zYwVRueFbsz/zw=;
 b=bhadNPHMekdZiSgb5ZmlKlUREBNwXh7nYzBLFCBrstExwIWgKTK5A69/1hjJYlL9cfnKqBR/zSOHPvrevBq+9DT64iFHBA82GrRDMkwebLsxRyI5aUwT6Kmb+wM/kmFGwlTiGXaiQKGHi8kJEkTbr/uDY0JQOMmMSr33cvbaah3KEKblnWxYcvL6DJ4xTUhyITTIpY88I1f4Cmq9pQFgnogNy9v8TlEQg7scppnA0hkKVv4mmhvNnn2onla+26bJlwckou06GIi3drOd9g544xEUJKmUORbHBgL8LmMvwNHXAJsdOdzTv/sOVdMCO/zWG2irHthrIiHUKLd2shTdpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jxxr2yQ5S/NthU3f8DVdtDcg4i5m1zYwVRueFbsz/zw=;
 b=cMzbZyicTfqErMqYgmwnbOSdwDcL+wq+rqEW4S1XJjJoQHPzXy7s5KAmtyf2ARlzdbJoZj4gp719wPnDETVRolNqtnNqKtma/nDHfjEz/RDBmpptS5Y/7HVRyoZXjT0Om906MkA7b4pPzCq1X7xRncwH1vfjJYEc688qMX+7LQU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS8PR04MB9142.eurprd04.prod.outlook.com (2603:10a6:20b:449::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 14:08:13 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6064.034; Sun, 5 Feb 2023
 14:08:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU port becomes VLAN-aware
Date:   Sun,  5 Feb 2023 16:07:13 +0200
Message-Id: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::15) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|AS8PR04MB9142:EE_
X-MS-Office365-Filtering-Correlation-Id: 01156a90-22bf-4e7b-7613-08db07826787
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mDuriRDDKPIi6Pd5j6TNOGsvzbn7TG0Eh7i49wCvyjAedeT5rvBnw9n26MGXuuBFDabsuWMUHHBzBkYHTNy4x/bOC/GomhG9ketCt273TRT18CF8Ezfa6cbdDNWUXNBvN5X/XBQtOwDsd1tIRuHTCA7OnvklHRu1zxsnAkWZ/Vh+YE+O/4jIJxLAtc7uaejBvSWYsarT+rI79du4Gc+ZeKb42QXFCNJTfYcNaR5BKlws9yG1RfXBpeDz7SFVGe3hd3I4a118o6tx6Ejl9kWW0mtnXHDoJ+TaUeYOt9g0ZmYErTtjV52uNu5MoWD926kWFy64MMa7s76pEXK4vzVe2JwoBrmueni+iGSjXuC5vqSwDH6+N3HIt9ksU0p5rlEuz2se4h8/swH+JFsq7pwn9JFFuepbeyjEhSWHGqYe48g1i3sGr26K54va4uKF5VxYHp6rZFFMpGWm+N3HvvmMkdEdmwW3s+mc1zVY+BrL/WTiywI/JFhZueCqqHyJ3nDynXmz01gLX3BZoyl/xul3012VTPsGIrr3/yK2MQVSepMkYYrLNVAjxwpaU3ZKDZKjyxBPRPGQy3lZV5R4oOJltb+mtTbY+rTIiwCpOVQa3q+hy9vMizZUt5i7T5fYQHHia878xNZTQVExd+Hz1DAyWSeH0JxcEmQ6CcinIUVEkMHB5KcEv/T63V2npGQ1Bvh0n8MhOcDKW0lFH7RDtgpxCPgqFfvanEVo+cf/gCOBkDQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(451199018)(54906003)(316002)(8676002)(66556008)(66476007)(6916009)(4326008)(8936002)(41300700001)(66946007)(38350700002)(86362001)(36756003)(38100700002)(6666004)(6512007)(6506007)(1076003)(186003)(26005)(966005)(2906002)(52116002)(5660300002)(7416002)(83380400001)(44832011)(478600001)(6486002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?424KdFPL4lkEpiqAr2egW7yTREv8QTJlVKbwE2ClSfrmAJQKc3fr4G9n/csL?=
 =?us-ascii?Q?zLB03B7OU5hFn6z0vih2GMMTTzyxfFnIBKAa3wp0nPvaMkWm7Rm7GtqG68iu?=
 =?us-ascii?Q?8YAKchm6eMP2pcmt3aSOrmPB7ovGDCf9MIxxk4jpZA5ezeKaczGhRIHMR7AK?=
 =?us-ascii?Q?1oncKqO3CR8X5z99Z9BmEhu8IzDf7uFo2vke6/3YCilEgmkZEVxlXj+K8MfW?=
 =?us-ascii?Q?mCZvFSD72G2r6UVVbT1nF7oYm7R4dVvSzxdi3FUrKWfBrlMTjVHkr4K7Fpyg?=
 =?us-ascii?Q?BlE4IRqj+pMOoB8o2VrtTIkRvm2TboFX9SRGjxnY7aVU+eI5V0jEGpvFXlDM?=
 =?us-ascii?Q?aaAsNDcRhaR0RRm9gihxXTxNMeP5L+GM6ZpaCmgAOaH/m39NMjMhkt3EA8bz?=
 =?us-ascii?Q?GQV5kBQg+RfgiNYoNbH6frJZ476xWQFNRPVWEDjZV80pNkmJ2039Y1Iiaxbg?=
 =?us-ascii?Q?poNt/KjwYNpOHEw/SWaKcrVpae40SjLxFXyQm9VtlFbTRwzH/kIaZbssLS3x?=
 =?us-ascii?Q?hzLcbSX67uX3mrYsDWP2q+P3k84Jwkk2jktLkgcvurvWGiV+Wc5xBdtrxuVq?=
 =?us-ascii?Q?0Z35MHGhHnfpWk2tX2nSEu8rlzPTpP03Bp1K0pvtyHNrelOY17HrFmmh1AcX?=
 =?us-ascii?Q?OaYa68nSsXY05wD1Nszh13+8TLDgWcV5HnOhDp7R+Zb8NShuK/n0BXFebkKZ?=
 =?us-ascii?Q?z+Fgop8eq3uVVmg8yvv15oLGcG9pjeKL3HNIyZpsmtTcVvGA3bdJjK+2ttNS?=
 =?us-ascii?Q?r9kBx453TX8DKySykBaw22Z9U/JfcGAfyNgcAgT3zA9+DTYtgu0NhUAwq6uD?=
 =?us-ascii?Q?BLXSvEIB3Qddhevwtl2tSEIXc5ZwWbkhCMaGd+P8+uuQ0mheHE3PzYElhgSx?=
 =?us-ascii?Q?Rg2Y9FLfRu8iC/M2Q0thCt+0B+17dVXkDM5QOGi2xxPKIx+luLaF62pXjP64?=
 =?us-ascii?Q?Lxi+DNbsn63tZQbwTPe/ZUJp1EUq7eBg2hbbiponSVJLDd8sCmBi58RhSelo?=
 =?us-ascii?Q?cHJ+MuZP+Msrw6dVshrHNGfgrdUxCvPfeG/oUAubnr13PvJ51DkrAcT+Lcdo?=
 =?us-ascii?Q?de1LZZbCp7EaS5mZGmICiIY169pxTHNSSMObBCjGp40BELJKVpeBeR5HL2IF?=
 =?us-ascii?Q?0cSvy9IdttDDfcwsNSC5yE9Y8O2vE/tR9P4iAFZWF7Y1ZX1Svo9m557gwppa?=
 =?us-ascii?Q?r7g0URV3hHCfwrWbyooj2TASbaBhxixRUSwlPWVFDZ6uh3XhA//gTQBtcfoC?=
 =?us-ascii?Q?iyeeHEcLjRx8AR0IZNxFsEu0ren809NtVm9HDlu0gq3lEJpoyWWLU0nt6rO0?=
 =?us-ascii?Q?nI7jiyOTVYkMvbLhwnCcuapmj9Sx8CQEfCJPeLz4m5A3ZV87SCntCWdFEitQ?=
 =?us-ascii?Q?xs7PsoQc6dDEKv4kopzm4CbAeEZ9ayAcF7nEzHDxTPYTBELBlDORVsgSvOgC?=
 =?us-ascii?Q?aeyGu7wiTqm0AppmP2i0I8TUMTbftgFfBY61oNQwNRzpLrb7vvGpHCA0lvXD?=
 =?us-ascii?Q?03L/gQayczAS3gWXvpsCg549bY/n49eSClg9xjl1+DXGtVQL/nepykiSoZ2e?=
 =?us-ascii?Q?lRAntMwQnFmUNteTgueQZXni5WJZ9PkBVmHP58+Pj9NDTMUIuqVv+R4zzxts?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01156a90-22bf-4e7b-7613-08db07826787
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 14:08:06.9318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VRh21KfJ6BnixRAsjaUjbZqDNZTmGmVGC1WunK/LU22ljK2WRFEm+L5Rv6EdgKbWHTkjSQjFa4qVNhosnW9Ing==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9142
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frank reports that in a mt7530 setup where some ports are standalone and
some are in a VLAN-aware bridge, 8021q uppers of the standalone ports
lose their VLAN tag on xmit, as seen by the link partner.

This seems to occur because once the other ports join the VLAN-aware
bridge, mt7530_port_vlan_filtering() also calls
mt7530_port_set_vlan_aware(ds, cpu_dp->index), and this affects the way
that the switch processes the traffic of the standalone port.

Relevant is the PVC_EG_TAG bit. The MT7530 documentation says about it:

EG_TAG: Incoming Port Egress Tag VLAN Attribution
0: disabled (system default)
1: consistent (keep the original ingress tag attribute)

My interpretation is that this setting applies on the ingress port, and
"disabled" is basically the normal behavior, where the egress tag format
of the packet (tagged or untagged) is decided by the VLAN table
(MT7530_VLAN_EGRESS_UNTAG or MT7530_VLAN_EGRESS_TAG).

But there is also an option of overriding the system default behavior,
and for the egress tagging format of packets to be decided not by the
VLAN table, but simply by copying the ingress tag format (if ingress was
tagged, egress is tagged; if ingress was untagged, egress is untagged;
aka "consistent). This is useful in 2 scenarios:

- VLAN-unaware bridge ports will always encounter a miss in the VLAN
  table. They should forward a packet as-is, though. So we use
  "consistent" there. See commit e045124e9399 ("net: dsa: mt7530: fix
  tagged frames pass-through in VLAN-unaware mode").

- Traffic injected from the CPU port. The operating system is in god
  mode; if it wants a packet to exit as VLAN-tagged, it sends it as
  VLAN-tagged. Otherwise it sends it as VLAN-untagged*.

*This is true only if we don't consider the bridge TX forwarding offload
feature, which mt7530 doesn't support.

So for now, make the CPU port always stay in "consistent" mode to allow
software VLANs to be forwarded to their egress ports with the VLAN tag
intact, and not stripped.

Link: https://lore.kernel.org/netdev/trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36/
Fixes: e045124e9399 ("net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode")
Reported-by: Frank Wunderlich <frank-w@public-files.de>
Tested-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mt7530.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 616b21c90d05..3a15015bc409 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1302,14 +1302,26 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 		if (!priv->ports[port].pvid)
 			mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
 				   MT7530_VLAN_ACC_TAGGED);
-	}
 
-	/* Set the port as a user port which is to be able to recognize VID
-	 * from incoming packets before fetching entry within the VLAN table.
-	 */
-	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
-		   VLAN_ATTR(MT7530_VLAN_USER) |
-		   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
+		/* Set the port as a user port which is to be able to recognize
+		 * VID from incoming packets before fetching entry within the
+		 * VLAN table.
+		 */
+		mt7530_rmw(priv, MT7530_PVC_P(port),
+			   VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+			   VLAN_ATTR(MT7530_VLAN_USER) |
+			   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
+	} else {
+		/* Also set CPU ports to the "user" VLAN port attribute, to
+		 * allow VLAN classification, but keep the EG_TAG attribute as
+		 * "consistent" (i.o.w. don't change its value) for packets
+		 * received by the switch from the CPU, so that tagged packets
+		 * are forwarded to user ports as tagged, and untagged as
+		 * untagged.
+		 */
+		mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
+			   VLAN_ATTR(MT7530_VLAN_USER));
+	}
 }
 
 static void
-- 
2.34.1

