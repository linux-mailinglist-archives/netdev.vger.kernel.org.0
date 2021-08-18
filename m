Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD963F0334
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhHRMEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:04:49 -0400
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:39586
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236417AbhHRMEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7uxa5vqDtZXmzi4nTuyuv4lCfwcMq1rhKtnkwqEQ58uzXVFIjpOw+5wQsZzLkQQ74R6gDg041O6eAAxPbg3Wr9E+XhUAj7/nUbVgh+yJKpQI/c9sJPnbyTDS9jiKQ4mtwkoWxPvkI3Ytw6mXk5N2JHnY2iJ5sgUrdpHJZEwrS4F/XfXQxDrMwPk9x+tjVlyg459VoYkqo+1CZtWVKDfOyYh9fBDyUCYGzzV6Am/+Y3uU4JAG9c8l0oR68Ow+aqTPzz7i98eU2GW4ZHs9qEr916a1idmraBwWnu7LYr6iaOkEHmrWUuPEnyHi35HdbH+2Uh/IdbXaeZdRSMhH2n6Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42qOyEGqyDcrl0xp2CU/fZoXQV6Xj6iwz8MeoQA8PPM=;
 b=ddOcqrnDxq+fEAnzEBUKdWNFwuBiG/OFyrBbd5N5iE5A1wOMynR2guSYJzm/cGYGRCD1zIUTM1/z2xmrGq8GD7Zvay5t4mK8B+Cb4OhAXM/qEtK4O2/tNrY4YKgX9L8gPSjAR3VHwOYwbqYqS903gSuMM7AgCnBwId+jon8wuS9bbxF4qa7LbQfWEhtcehcICH/Jf6agVivRRppOHGufnXlSYhY4RgbEKzuikBXrVfV7+As1tBJR3qHKNbmBml5qSR41zodvsIzkbNmebJIOKTs0yds0E2HNuMJAj+15sF3yZUwrO0v7HUh7lzLyludngfNiQN0Uzp0yQIyYa9j0+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42qOyEGqyDcrl0xp2CU/fZoXQV6Xj6iwz8MeoQA8PPM=;
 b=Q3re+qF/Fv6oAa8mdJH9H8umUIMpAnWW3s1NaK5DddUVTDuCmWlK/Aqz/sxF10CCEDyj0WibrBpP0ZqXObALMxM/mh4O9z+w5OSHVIrQOYlRRl/VOfgNyr7dsXkHwuGGgEjQyz8GoCeWYtTPJKMKThW8vPM3GOrmJjg/6wYwuTA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:03:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [RFC PATCH net-next 13/20] net: dsa: tag_8021q: rename dsa_8021q_bridge_tx_fwd_offload_vid
Date:   Wed, 18 Aug 2021 15:01:43 +0300
Message-Id: <20210818120150.892647-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120150.892647-1-vladimir.oltean@nxp.com>
References: <20210818120150.892647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fdef58b-a08b-4cb4-6769-08d9624024ba
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839364FE8954514C0F350EDE0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pUKTSoVZ9LiCS5SmQs0P2m1OQvGpJrsnsjutkalpxhVH8B4U/e0ZDx3FDxLUssM1ZcJuh+2rkt2hoytKuaJ6Xq7YrmsBz4H+aJhUCcY54jyyyayGd3GfKpOFscvJp8EbWjXrf9LKg+EAy/wa5zXEQcqcxMHSDH5D2ZQRsE/vaqSavQuWNwfBfi+qVCKP6A83Xf7emNZ2YTBCj+KVyEdddDHVt83baY+L4cA71eHc3x3ZJjc2tHi4dsRh96LzuvmsNVerC2tg85qLXfAZXeTRdYZUrNhFJDvCLu0PX8SW7x7WmkFPg1Tu4QyQnU8CKhIF82YIliPha+3Yfw72SYiTNTRse0OUyXNA9r/rTl+BXqo+rx5hvmw8ysOKXiKaoUSSBV78g3gIHSGCWYL2l8DOGJJVPEYqJGsRvOoOBIVs7DmtyYrv8ldMuJV1JXeGfP7TGekxRadOanr40yr0prVRx+8H7darFk+SynN/VgEZoydwx6Wg1YNcctC8go1Xx8S2H5uktkBLwBImTEirjvk2ewzgKkzxrkJ9WlDAPw60mFM6E+Bs6RQKib8UKmAlwmJ/rmbat3sWFK+y4tzj0gN+fBqoP7i1UvoJlVhca6F2MHqvflkVurRriSoKip5f9cYjPC2T39Mt+CIHncqH5yklBY0JROiUQSEVtE9AzZu2wnz1Uka9ly4wLd880uSZrcqC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39850400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?neo91Z9+8OhFoU8tsP3hnIHPiDj+pc/C1Rm9BmbMVeFwne32avUs/4TGt3aB?=
 =?us-ascii?Q?/dmrtijytp3DeE/VTLLZviwecG2/fS8dTZdSo1+h0JZN4yCRrEHbwTX9Ifo0?=
 =?us-ascii?Q?c0HCuIfaicfnhzdx+EXaF9cDT0sY1RIMavM2wUkEZenJrUb/qNjlC7jM9kbK?=
 =?us-ascii?Q?Spki8i12GV3+ZXJOKU5p8z/sKc86WXNrv/VapKlpMxEws5XuUE1Eh4b5ea8N?=
 =?us-ascii?Q?eyp7AxqEP1tftbIDTo96qKYSC8GL8U/kuPL1JbtUUdDb7TKAZ9zwqaacMxJ+?=
 =?us-ascii?Q?YlHksnJkAqnuzF4CNM4HfcB/FRMQB3RvRYVvQA9jhKGXhcxSys9kf/5qU076?=
 =?us-ascii?Q?FxyX1Q35vI2gbVSVvA1LhT+F0UVqS3P8IhnsQeFnjWUf2gpGeYTyHjE4NaPa?=
 =?us-ascii?Q?wbTg7XeCrnSedtJPpOeOP6ienR8vRytonok9xzFBPFQRFkejNj6GtRjCvvBy?=
 =?us-ascii?Q?SEGuntkoBh1IobfTNMV+Vyg/h/PhsKLWNkPWWhn4y+9Buhzr5F/E37+dBuqv?=
 =?us-ascii?Q?C207dQyo8FqMcATOF/QmXCThSBBZrf0fNaM9OqT9suUefvE8BcgvA8fSvokp?=
 =?us-ascii?Q?1/cG4VCrRe/MEI44Gp9AxYg/YgDKUifLcqzabu/oEdShh5189hTzQE5SsDnF?=
 =?us-ascii?Q?FMnH/iH4UE4tSQB2SvTk4lKD5zKGQvLrVxo0iWXLwzZdkgdpGecH3QLflkbH?=
 =?us-ascii?Q?DpSvfjmJ2mHU7XJkOQjbtH9myeC0DCucVvVrzk/srEh8sPNEsgdU3K/fBQ2T?=
 =?us-ascii?Q?Vc4GrRrtBuFhtz+bleLBgQU6Is7ZnMliKOSN6gpEj9pQxSGe8EJlWEAvcQWi?=
 =?us-ascii?Q?TnA5lJjTSL3Gso/jVKTi3xXno9Zmj4cMY1kKPBkMHuf3AeHKubniuF1/ldJd?=
 =?us-ascii?Q?itAlncXmvLSUqP8Bu0Zy5RC93eqS7URoLH5qe6TbWLHy92dpXHPxwz7x2u9f?=
 =?us-ascii?Q?U7qNr/8ncUlFCdV/2KIp3N27UmUfQZwhqgphffnZg414S5Irh/CzEeiPqUid?=
 =?us-ascii?Q?4M6jB5Y9JaFazEPhU7PLTMYKfTBVWdojnpw5fjsQR85RnNfBuKw8wJtUHrdx?=
 =?us-ascii?Q?0WUBL9VJw2aDFzbMm53iT+B/du+1hjUqLdB9nI07P57z7pg8XPTLaZMfBE1L?=
 =?us-ascii?Q?dYJAmc1tO/YO1jG34kr0LYULKWyYo3V2CUZTN9eBwpjGULka36k1UJ6hzfhL?=
 =?us-ascii?Q?l3tLZ3rWLt89wUrbwI2W9XD2czsNcGi7cNmvpSrOpiHtccTCT+92RCawoQ1b?=
 =?us-ascii?Q?McAklLjI6zjq2OcCpTkoaACDan3U7i4CseVINIuEbNJ2AxF8B+xd8f4IBRfT?=
 =?us-ascii?Q?iD5vKhXdl6/Ayq3S14Bh/Ytn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fdef58b-a08b-4cb4-6769-08d9624024ba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:08.5599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7lnBn9E7ykgquX5Z9egW4OF6/qJ3xjMhBL8frwA1SlmXXAPB30YlkJNGuawhVsbWg5DN6eQGLtkvBQMA9TIyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa_8021q_bridge_tx_fwd_offload_vid is no longer used just for
bridge TX forwarding offload, it is the private VLAN reserved for
VLAN-unaware bridging in a way that is compatible with FDB isolation.

So just rename it dsa_tag_8021q_bridge_vid.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/dsa/8021q.h | 2 +-
 net/dsa/tag_8021q.c       | 8 ++++----
 net/dsa/tag_sja1105.c     | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 5c67ac422282..c114663cd687 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -46,7 +46,7 @@ void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
 struct net_device *dsa_tag_8021q_find_port_by_vbid(struct net_device *master,
 						   int vbid);
 
-u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num);
+u16 dsa_tag_8021q_bridge_vid(int bridge_num);
 
 u16 dsa_tag_8021q_standalone_vid(struct dsa_port *dp);
 
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 76e4b99ecd89..e7890aa79df8 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -63,12 +63,12 @@
 #define DSA_8021Q_PORT(x)		(((x) << DSA_8021Q_PORT_SHIFT) & \
 						 DSA_8021Q_PORT_MASK)
 
-u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num)
+u16 dsa_tag_8021q_bridge_vid(int bridge_num)
 {
 	/* The VBID value of 0 is reserved for precise TX */
 	return DSA_8021Q_RSV | DSA_8021Q_VBID(bridge_num + 1);
 }
-EXPORT_SYMBOL_GPL(dsa_8021q_bridge_tx_fwd_offload_vid);
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_vid);
 
 /* Returns the VID that will be installed as pvid for this switch port, sent as
  * tagged egress towards the CPU port and decoded by the rcv function.
@@ -313,7 +313,7 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds, int port,
 	 * bridging VLAN
 	 */
 	standalone_vid = dsa_tag_8021q_standalone_vid(dp);
-	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
+	bridge_vid = dsa_tag_8021q_bridge_vid(bridge_num);
 
 	dsa_port_tag_8021q_vlan_del(dp, standalone_vid, false);
 
@@ -338,7 +338,7 @@ void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
 	 * standalone VLAN
 	 */
 	standalone_vid = dsa_tag_8021q_standalone_vid(dp);
-	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
+	bridge_vid = dsa_tag_8021q_bridge_vid(bridge_num);
 
 	dsa_port_tag_8021q_vlan_del(dp, bridge_vid, true);
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 52002aa2a045..0902e7334cf3 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -163,7 +163,7 @@ static struct sk_buff *sja1105_imprecise_xmit(struct sk_buff *skb,
 	 * TX VLAN that targets the bridge's entire broadcast domain,
 	 * instead of just the specific port.
 	 */
-	tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(dp->bridge_num);
+	tx_vid = dsa_tag_8021q_bridge_vid(dp->bridge_num);
 
 	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp), tx_vid);
 }
-- 
2.25.1

