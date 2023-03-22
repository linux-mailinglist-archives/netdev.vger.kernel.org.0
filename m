Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE3A6C5A90
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjCVXit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjCVXin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:38:43 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2048.outbound.protection.outlook.com [40.107.8.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADD81912B;
        Wed, 22 Mar 2023 16:38:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJlBk9ICT7bSBcc4DzNi0IWE1m1Ht3I3mGbJn4ERy8IoBx1TIxVzdlFPu5IyL6R1YifolGINluE/AODYk3ciVRuwfuhyhPtHnQPeVxupw6ZO+QiCim4SRIIoEmlKxhcedZtLZWugnLeIWjuyyD39bey9gSybNvdzyUpsGjfHsCZFL7mwenLdPtfWHUURHrBLoMOqc8x/6NVkA0BIUawyyBUQd4LDXSPy5edqR46wUhuW909Kq4zCeY1qYpyZlSBgKjrKnaFQFYcHVDi8FFFTiABQUa0tqQDVGk02wpmcuLyasL+si6fFCKoBxyGHiuK/f3fDuMeiGC9tFLkOqciICw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMqwWlF76BPvn64Yt1dgtuQx/bzT8eTVldu38bx/etU=;
 b=ShAuz7o4jksDA4lN30vQyMBvZ6Au8urH4XYZKOxMJJtBb365M08wubsafCGopYPFvT51+tpcB/6TfhVsmhQdnOQG83F5QkwmD5sdGxZxpjzxMRlLZACYY01lY/arFGaYAmL5LcAYUgod8G+Ax7mXlsdUafIX3H2AetJQubW00W4d962o+6z/VrpaGkm3svau6ZNsLQn4URwpqA/4weYBKWWMEYguConHa7ta0Dm9M8BYNUZEVcgkW/yLe+vY1BwiDWMsOCgwWTpcKN1HCZ5uPSOaBfRuac1wtdgdszYOSWI8nKhWiS2I9APa1eu0ZSTdVHUbmitw0X9xYoUQA4nsEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMqwWlF76BPvn64Yt1dgtuQx/bzT8eTVldu38bx/etU=;
 b=mFa/6Ql2WT3UX0rK36/FTSi6GTxZ0I3qvydM64m6QNtGJS0Oydvk8g1kjhgTdg5H4AQUJkiC+1DO+KEF/MZ6bgo022RBD6wKng5FNB+hDrFYDlYgs3nUS3BACPou6p3frHIt7mfTdBc6jCuHeaq1Swhvsqjq0qes5bmWf6CTMME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7263.eurprd04.prod.outlook.com (2603:10a6:800:1af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 23:38:37 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Wed, 22 Mar 2023
 23:38:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/9] net: vlan: introduce skb_vlan_eth_hdr()
Date:   Thu, 23 Mar 2023 01:38:16 +0200
Message-Id: <20230322233823.1806736-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: e2676b32-c267-45b1-9b59-08db2b2e8f41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3OselxUFFAwEHWZUe/0Wow+JfLbfJkiS3tKpXGrfp3txowUxei+U3kVGC7aB7eIWyt6How6EdmH6kZ5L+O9Qdo8xt1IwhDizUZtsd5OD2CMZlVs6iFptFk47sXk4KK+qLwGtMEdvIcQT34sORuhWZObHK7Wtd94/fkREpNvX+eJgw1pFXwn4+Ln0T/8Fbk62I0H5ADJ5boEPgBH565CrrRrUMg7rSQOGDCLQnc7OmqATuSfKWoU5BjUSZ1fyGPnFXc6AD7l4jGfub1mczsglPnASWEzkLWhkAfm7JeI574YozL5zoITT/FrQSSjZJ7WzHTPYlF9Lyqo3fg0UZtbfqGF1GhX22Hmoxv0d1iwY3Wc98WOQ1b0hY98Tt1Nvvlmn5qha0+JIIlVqiHoFTDjnMgDcPL3y8k39HyejpO65HjHxPzxhFC5XXl35dprpynG4u3NZlluaF/WSY9ix/rmGPrMIaya+0vDHMvcqfEInSIj7j6c0UzoLbL5xLXXiSW91AQwHmJp6Ti0WdKkggDl0xXHhR5J473IbG+PmVLScbWUo/da44L9mTA5gwRiRpuAsaQ55YkkwEWvmMKZGWdWtGydiNc+N9TRZhxw8l0DCWI72Ln7cFK3DHz1NJhnXbUQR91seU8pBCQp2rAy5eEQx1+ukkUe3tKeokKjG81pJFPGNgX0vEJ9Y8XvNPXmhWK7WHBehBDc6duMbU2zU0u2B+rTbwF6qUlmgOTMRAkiaZX1QN5jOp0DrRnfJW4eKY1YT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199018)(54906003)(66556008)(6486002)(6916009)(316002)(66476007)(8676002)(66946007)(478600001)(6666004)(4326008)(52116002)(41300700001)(6506007)(1076003)(6512007)(26005)(8936002)(186003)(44832011)(5660300002)(2906002)(2616005)(36756003)(83380400001)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/3AglQ79NJbjTbSr07ajCUhtHW9F5Aoot0W4KN5BbOrZu2iJkcGqLVuDFv4I?=
 =?us-ascii?Q?vJpPmcfJ7u3YX5pyKtmsaL2TmV9CXA+OH5/pin74ushkWoUCIseV+u8BlPPq?=
 =?us-ascii?Q?7HrvvsNRwb2CcQUzogO+oYjolq6IA5aNoG7FtYjXDHTf6hvoMcIqa7kc86km?=
 =?us-ascii?Q?MFpkLJ0im9OzTOUKBWvvYEvgaA49/c2NrzOiMIWtcvpL1TcYOUxDYF6q6CbQ?=
 =?us-ascii?Q?RLCZo2jfTtFnDOIaSZumZ0ArAExK9FIUX1NrByV6gOhPBumnSsCW6qS/ZQLO?=
 =?us-ascii?Q?5rYWx9oEFPY8pvCzoXMEMxCihUwpShlntDq2P4ggicIDOFXX4LPzmWRiOC7N?=
 =?us-ascii?Q?dzVeI/m+a42v3n0cP3n9giAeBTKvnvW0c+3bLkmyZjs/L81qfcO0/9cw8fam?=
 =?us-ascii?Q?tctfx/Lgyj4OH5nuX2aWQHahBWSzFJhJ/ipwGEL2UVy2yvWH+NKnvpksZOEM?=
 =?us-ascii?Q?6UDAuWp76D1hSlIyzr7JHY+QrGJ6aPonj2X38Wt2HJAN2xMWTgmcD7jbmAjA?=
 =?us-ascii?Q?eWXkdg8jeomX3nVEQm+8jWKNWPPdIHEFy/cq62QBvM5gOnoBVdbkHAWXG9p2?=
 =?us-ascii?Q?61EgZRlTnuSRS01QO+1lC7j42yZxhrADgxatf1pF5OcZVrsusE39wR/5Sigf?=
 =?us-ascii?Q?OEKKA+snlqjQ6aCac8oJL2qLSzn5Xk6Fkc/czC1If/kzvk6Y88QZc2HUhDFG?=
 =?us-ascii?Q?egqWyGkNNy+ITmE8oYjLlNCPRrLN3oTd1XOpJWgQ3SVMdlUILz4Iy14ESyXz?=
 =?us-ascii?Q?oetZz3auIhXrQheGeB5UE9HNEsQxg6kibLMW1KOlj/4Xdfh9f0iS/ZF2AhZz?=
 =?us-ascii?Q?FGfTKReHvpc97Y0MGdeYy/k2aKNSiBZTycuK2AqAmGB3LRlpHDccWZHWryid?=
 =?us-ascii?Q?0QW9XRFR0L4eYIseTWMuVhY/vXDUhEDLPvPLz+4IVAQY//ksGtPpZhRQy00t?=
 =?us-ascii?Q?UjhtPUoBTAYxbmb4xru6Y+DlOJwDwnbmJI7VuQpR5fkAxRrAg6w8YV312Kqg?=
 =?us-ascii?Q?+4tKe/DgInMRD/zLqHsY8DgYCKn5mfDkZ7iqNq611O/9rKsQ+bOhAQJH2tIg?=
 =?us-ascii?Q?4bKOHxmZE6k7mk8QwRnucO90HJOt9APLjO3+Ut2d6G4grEXSIepBqv4L6wZq?=
 =?us-ascii?Q?rFJGIJ7uuUm1oEVAgLj4lATd/zOKZo1GA5K4PxChIGNhb6zZyauucule38KB?=
 =?us-ascii?Q?jXz02XqXwGRIwqPttR2xpY2jnCOFv4/sieG9+RqITQ6bXWMkqrBqbICd4J4c?=
 =?us-ascii?Q?CsnrnxKXeo4/KdCmGgcOxiOMgfAkxEFOQ9mrTRcAu2JW7T1H7ZH/NQR2Rme2?=
 =?us-ascii?Q?sLG31hHIr3uUXJM28RIdxu5Qc3FsVDd6WIbTd3+C+ASi0QuK0Es3cN49zcCK?=
 =?us-ascii?Q?fRZuLijg8Z+vPHQx9zKzPZHCkDNcRqpdpkOHxXblio4+MmStFeH45Q9dPzBi?=
 =?us-ascii?Q?CzrHquKUI8/QN3u8jUfrE7cIO/QSrKKnPD6pn0FoN5KjL2mCdWXUtqzrfhx0?=
 =?us-ascii?Q?djAXVor+udXPH+Yrn6CipKMh2uEzz+dbgrQslt/A6S5IrFETbaWl7X+5Rzqd?=
 =?us-ascii?Q?W5a9Wg/Iw0E3I08c/ol0eB15F+MwInyQoAv+LRImWEH47VRFqjr+TtYZVqxY?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2676b32-c267-45b1-9b59-08db2b2e8f41
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 23:38:37.6863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IWl9oac/suGJq+SrxKmAmzhYlLZlf+dSAsw/0zJJNGUwSXkIoGlSD0iyrgEIOeOzlsxa0Xd50tQzCnoy3rss1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7263
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to skb_eth_hdr() introduced in commit 96cc4b69581d ("macvlan: do
not assume mac_header is set in macvlan_broadcast()"), let's introduce a
skb_vlan_eth_hdr() helper which can be used in TX-only code paths to get
to the VLAN header based on skb->data rather than based on the
skb_mac_header(skb).

We also consolidate the drivers that dereference skb->data to go through
this helper.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c      |  3 +--
 drivers/net/ethernet/emulex/benet/be_main.c          |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c      |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c          |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c        |  2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c       |  4 ++--
 drivers/net/ethernet/sfc/tx_tso.c                    |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |  7 ++-----
 drivers/staging/gdm724x/gdm_lte.c                    |  4 ++--
 include/linux/if_vlan.h                              | 12 ++++++++++--
 net/batman-adv/soft-interface.c                      |  2 +-
 12 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 16c490692f42..4950fde82d17 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1923,8 +1923,7 @@ u16 bnx2x_select_queue(struct net_device *dev, struct sk_buff *skb,
 
 		/* Skip VLAN tag if present */
 		if (ether_type == ETH_P_8021Q) {
-			struct vlan_ethhdr *vhdr =
-				(struct vlan_ethhdr *)skb->data;
+			struct vlan_ethhdr *vhdr = skb_vlan_eth_hdr(skb);
 
 			ether_type = ntohs(vhdr->h_vlan_encapsulated_proto);
 		}
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index aed1b622f51f..7e408bcc88de 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1124,7 +1124,7 @@ static struct sk_buff *be_lancer_xmit_workarounds(struct be_adapter *adapter,
 						  struct be_wrb_params
 						  *wrb_params)
 {
-	struct vlan_ethhdr *veh = (struct vlan_ethhdr *)skb->data;
+	struct vlan_ethhdr *veh = skb_vlan_eth_hdr(skb);
 	unsigned int eth_hdr_len;
 	struct iphdr *ip;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5caea154362f..7356ad965487 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1532,7 +1532,7 @@ static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 	if (unlikely(rc < 0))
 		return rc;
 
-	vhdr = (struct vlan_ethhdr *)skb->data;
+	vhdr = skb_vlan_eth_hdr(skb);
 	vhdr->h_vlan_TCI |= cpu_to_be16((skb->priority << VLAN_PRIO_SHIFT)
 					 & VLAN_PRIO_MASK);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 32cce90abbb4..81856f444d38 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3063,7 +3063,7 @@ static inline int i40e_tx_prepare_vlan_flags(struct sk_buff *skb,
 			rc = skb_cow_head(skb, 0);
 			if (rc < 0)
 				return rc;
-			vhdr = (struct vlan_ethhdr *)skb->data;
+			vhdr = skb_vlan_eth_hdr(skb);
 			vhdr->h_vlan_TCI = htons(tx_flags >>
 						 I40E_TX_FLAGS_VLAN_SHIFT);
 		} else {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 773c35fecace..eae6c89e62f4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8818,7 +8818,7 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 
 			if (skb_cow_head(skb, 0))
 				goto out_drop;
-			vhdr = (struct vlan_ethhdr *)skb->data;
+			vhdr = skb_vlan_eth_hdr(skb);
 			vhdr->h_vlan_TCI = htons(tx_flags >>
 						 IXGBE_TX_FLAGS_VLAN_SHIFT);
 		} else {
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 59d0dd862fd1..1d1e183d3a8b 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1854,7 +1854,7 @@ netxen_tso_check(struct net_device *netdev,
 
 	if (protocol == cpu_to_be16(ETH_P_8021Q)) {
 
-		vh = (struct vlan_ethhdr *)skb->data;
+		vh = skb_vlan_eth_hdr(skb);
 		protocol = vh->h_vlan_encapsulated_proto;
 		flags = FLAGS_VLAN_TAGGED;
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 92930a055cbc..41894d154013 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -318,7 +318,7 @@ static void qlcnic_send_filter(struct qlcnic_adapter *adapter,
 
 	if (adapter->flags & QLCNIC_VLAN_FILTERING) {
 		if (protocol == ETH_P_8021Q) {
-			vh = (struct vlan_ethhdr *)skb->data;
+			vh = skb_vlan_eth_hdr(skb);
 			vlan_id = ntohs(vh->h_vlan_TCI);
 		} else if (skb_vlan_tag_present(skb)) {
 			vlan_id = skb_vlan_tag_get(skb);
@@ -468,7 +468,7 @@ static int qlcnic_tx_pkt(struct qlcnic_adapter *adapter,
 	u32 producer = tx_ring->producer;
 
 	if (protocol == ETH_P_8021Q) {
-		vh = (struct vlan_ethhdr *)skb->data;
+		vh = skb_vlan_eth_hdr(skb);
 		flags = QLCNIC_FLAGS_VLAN_TAGGED;
 		vlan_tci = ntohs(vh->h_vlan_TCI);
 		protocol = ntohs(vh->h_vlan_encapsulated_proto);
diff --git a/drivers/net/ethernet/sfc/tx_tso.c b/drivers/net/ethernet/sfc/tx_tso.c
index 898e5c61d908..d381d8164f07 100644
--- a/drivers/net/ethernet/sfc/tx_tso.c
+++ b/drivers/net/ethernet/sfc/tx_tso.c
@@ -147,7 +147,7 @@ static __be16 efx_tso_check_protocol(struct sk_buff *skb)
 	EFX_WARN_ON_ONCE_PARANOID(((struct ethhdr *)skb->data)->h_proto !=
 				  protocol);
 	if (protocol == htons(ETH_P_8021Q)) {
-		struct vlan_ethhdr *veh = (struct vlan_ethhdr *)skb->data;
+		struct vlan_ethhdr *veh = skb_vlan_eth_hdr(skb);
 
 		protocol = veh->h_vlan_encapsulated_proto;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8f543c3ab5c5..918de65fb707 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4554,13 +4554,10 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static void stmmac_rx_vlan(struct net_device *dev, struct sk_buff *skb)
 {
-	struct vlan_ethhdr *veth;
-	__be16 vlan_proto;
+	struct vlan_ethhdr *veth = skb_vlan_eth_hdr(skb);
+	__be16 vlan_proto = veth->h_vlan_proto;
 	u16 vlanid;
 
-	veth = (struct vlan_ethhdr *)skb->data;
-	vlan_proto = veth->h_vlan_proto;
-
 	if ((vlan_proto == htons(ETH_P_8021Q) &&
 	     dev->features & NETIF_F_HW_VLAN_CTAG_RX) ||
 	    (vlan_proto == htons(ETH_P_8021AD) &&
diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index 671ee8843c88..5703a9ddb6d0 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -349,7 +349,7 @@ static s32 gdm_lte_tx_nic_type(struct net_device *dev, struct sk_buff *skb)
 	/* Get ethernet protocol */
 	eth = (struct ethhdr *)skb->data;
 	if (ntohs(eth->h_proto) == ETH_P_8021Q) {
-		vlan_eth = (struct vlan_ethhdr *)skb->data;
+		vlan_eth = skb_vlan_eth_hdr(skb);
 		mac_proto = ntohs(vlan_eth->h_vlan_encapsulated_proto);
 		network_data = skb->data + VLAN_ETH_HLEN;
 		nic_type |= NIC_TYPE_F_VLAN;
@@ -435,7 +435,7 @@ static netdev_tx_t gdm_lte_tx(struct sk_buff *skb, struct net_device *dev)
 	 * driver based on the NIC mac
 	 */
 	if (nic_type & NIC_TYPE_F_VLAN) {
-		struct vlan_ethhdr *vlan_eth = (struct vlan_ethhdr *)skb->data;
+		struct vlan_ethhdr *vlan_eth = skb_vlan_eth_hdr(skb);
 
 		nic->vlan_id = ntohs(vlan_eth->h_vlan_TCI) & VLAN_VID_MASK;
 		data_buf = skb->data + (VLAN_ETH_HLEN - ETH_HLEN);
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 90b76d63c11c..3698f2b391cd 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -62,6 +62,14 @@ static inline struct vlan_ethhdr *vlan_eth_hdr(const struct sk_buff *skb)
 	return (struct vlan_ethhdr *)skb_mac_header(skb);
 }
 
+/* Prefer this version in TX path, instead of
+ * skb_reset_mac_header() + vlan_eth_hdr()
+ */
+static inline struct vlan_ethhdr *skb_vlan_eth_hdr(const struct sk_buff *skb)
+{
+	return (struct vlan_ethhdr *)skb->data;
+}
+
 #define VLAN_PRIO_MASK		0xe000 /* Priority Code Point */
 #define VLAN_PRIO_SHIFT		13
 #define VLAN_CFI_MASK		0x1000 /* Canonical Format Indicator / Drop Eligible Indicator */
@@ -529,7 +537,7 @@ static inline void __vlan_hwaccel_put_tag(struct sk_buff *skb,
  */
 static inline int __vlan_get_tag(const struct sk_buff *skb, u16 *vlan_tci)
 {
-	struct vlan_ethhdr *veth = (struct vlan_ethhdr *)skb->data;
+	struct vlan_ethhdr *veth = skb_vlan_eth_hdr(skb);
 
 	if (!eth_type_vlan(veth->h_vlan_proto))
 		return -EINVAL;
@@ -713,7 +721,7 @@ static inline bool skb_vlan_tagged_multi(struct sk_buff *skb)
 		if (unlikely(!pskb_may_pull(skb, VLAN_ETH_HLEN)))
 			return false;
 
-		veh = (struct vlan_ethhdr *)skb->data;
+		veh = skb_vlan_eth_hdr(skb);
 		protocol = veh->h_vlan_encapsulated_proto;
 	}
 
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 125f4628687c..d3fdf82282af 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -439,7 +439,7 @@ void batadv_interface_rx(struct net_device *soft_iface,
 		if (!pskb_may_pull(skb, VLAN_ETH_HLEN))
 			goto dropped;
 
-		vhdr = (struct vlan_ethhdr *)skb->data;
+		vhdr = skb_vlan_eth_hdr(skb);
 
 		/* drop batman-in-batman packets to prevent loops */
 		if (vhdr->h_vlan_encapsulated_proto != htons(ETH_P_BATMAN))
-- 
2.34.1

