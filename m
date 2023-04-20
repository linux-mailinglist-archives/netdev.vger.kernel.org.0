Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31C76E9F86
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbjDTW41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbjDTW4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:56:20 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618703C0D;
        Thu, 20 Apr 2023 15:56:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lznu0NnVt6fGL3dRrIM9/Ddqwory3d3eQ+W+XvLlZ2EzqG60y7Ls8w/7n1dBLneVDM3QDF0w0FzmOI3hXQUG9jy2p1BCpcMINtVxUwmp7zehY+ZL0tHAA9YKaBoKNpBZikGCmeWIobwHjjlAtQ4BsyzrSF9Wi6iKQATXO45bwEFAfkYd6tQpxQB9bRi79cQ5/cTi3s5cKqRBy7zQeLHVQcbccs/JaRiH88Gy3oEDeCK2V7wUulUFrxnBRHBmSaoTKzrEZKJ/+0XCplYrb+ilaVDVl+nDBi8fZQX/IO/ipiZ6kLxinGmd+pFHY5lPmpTN+GbL1Z65mqh9yHmVeua1KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/0TNAANsp/qqmh1WtfphXOh9vFnOldTmvS9awJSo3js=;
 b=YKkyChVbbxDaPZgNUCvLxMy7CNP7RtPmnHNeGH3fdlSnU/YDj1VseaI4YrYUKMrxoYY23RuuYnW3apKsX3Ucwp9jfL8y9q/mlnWJCHvxEC36rwrG6o+oqzbFmNbt3wIqp6EMvVhfWxNYysqvz0QsqtQ7T+hPEX/PAj9ybMLpasG4SnzuFWM03KdodfNs3Cvaxnpqf4cP7sEZg9VtNnhYmaSIiWOXXAouRJ0+cYl6ob+s1Ij1FRPcLYehvVpQDRfye0JmI/0uZeAnIECG+Nm/42hnuhm47ZeSMUOKhWXAhK7Bnbkmr1G/iKXYEnyn0pz3ktfieRDI8442FeOzowQyJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0TNAANsp/qqmh1WtfphXOh9vFnOldTmvS9awJSo3js=;
 b=notalCUK9YFcG5Sgo0DLu8WrmQ4sQUpveiHe5FE01dJ5mD9AMX8Zu6fwL8JqERmqhEHGpuEC/zSf7WCxeANGmoPrS3SuajOkRqJAtARm5TcWXADiHN3Rc6xo88VwQRnu3ENzRJen4hntql3tQd2hxHMu2Yj+JorwSOZe9ItWHjk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9213.eurprd04.prod.outlook.com (2603:10a6:150:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 22:56:13 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 22:56:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 net-next 2/9] net: vlan: introduce skb_vlan_eth_hdr()
Date:   Fri, 21 Apr 2023 01:55:54 +0300
Message-Id: <20230420225601.2358327-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
References: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0088.eurprd03.prod.outlook.com
 (2603:10a6:208:69::29) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9213:EE_
X-MS-Office365-Filtering-Correlation-Id: c44b64d4-4f40-4139-b3a5-08db41f270f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 18pUYwP3RxwYDu+S7QCSbmYdik6X/a9ArwSwVYs8XW7W9sZCKl0YRZTNwbGflmgvCLyF8MXtMS5hkyEnhkJoMbZarFFytDfB28aM3n/KCy5DHN+JkaYhzMi/XfbtJ872vc+IbyH/Lm9AdOC+b7ClrXGNJHZ9sHMNB8fM/oSjVyNdlvmCKuU6EIgP7Z8FRJysP75IJgb4V0QUVmu9rMpCE378lq1xQehnnGTGzvWYJnyTheU/ReLEvfTRfOstx0JM+ALEscoNSTkX0PMdFGJzNwyVSOpJEjgFQ0MrQ9+QpvKeSrc/LHWWnq/jxJNyTZSiZbn2nZBEISmIFiQ2DKZvh3m2af9/sub91mr3VFCg56E2EqK/9nQqU8gX87TrmEg6puejovjER7Bdgg5QSOUrJkWPJrYvr7hFeUkk/zKupRV0DlFoE7G8uK9mIxdvRFBgfZPj0Xxk4MSV3y4iuNBOLv0bJRKdk41XPwzLXbu9D51Ae4ZoHVjCwMEpxYQNwYMYPRByKlj8plHcblOLLK5q7kiVGIsqNdblR4P/lmIPms1beKxwGQ0ctc/ItbeOhLeKK6qefRRJHBWFwLWJ0O8ZEtrcFeJPwJTx70KJBcNjFrqIReB3DdnfYUtpT+d+W2CJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(2906002)(38350700002)(38100700002)(86362001)(478600001)(54906003)(316002)(41300700001)(66476007)(66946007)(66556008)(6916009)(4326008)(26005)(1076003)(6506007)(6512007)(6666004)(6486002)(52116002)(186003)(36756003)(8936002)(8676002)(83380400001)(5660300002)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zuA19TtWuXTpaDCpgyl8tPASqBy/vvX3QIGGgzM3Jjh0K8Rwf0Zc24hz4GnQ?=
 =?us-ascii?Q?eIm3GEpsmaf3VIBVamP7kJ/16e/NA+A800QWntDdWnWGcPpUx82dUUxIANJS?=
 =?us-ascii?Q?Vs2V1ubN4z3zybeUL9eic2+/0AePREsyauR3c1no5zt9tX190FuRIcYG2m2U?=
 =?us-ascii?Q?QDXc3lOnMsCxoc+AdP2DIRwM9XZWKsi7x/rRhTdFtRpjd/8XczHTZvG1EKJv?=
 =?us-ascii?Q?TAQuFaruz7URd0icPQV/vg6SF0F+tBo/XchJ430gGHhixV/YsfZpD70LixSd?=
 =?us-ascii?Q?P6NBXV7YqJYaXfkUvPmC7pRH0XSz5t5KYXKaIliUI+Mt9IJp+pQXrk2h8znj?=
 =?us-ascii?Q?GbPZcLclIgHYrgbUwbAz+4FYWXAFuzVQHOExlxlVjAQ3UVNzBmj8xkeJMovW?=
 =?us-ascii?Q?8T8dy/CsxZzElMxvUQ5AF7+SFzIlloo+sxmaSjaYgclfUsvzOPG34z24VqZr?=
 =?us-ascii?Q?RfVkaXupM/W2aEG90v+bDwMfRfwwWpTVuGCIBzD1RDAzgydqVKmJixsyjZ7w?=
 =?us-ascii?Q?YTtJBw5ZVZWnQyodp7lK0thTrNfvj4GAYhPaawechl+KxRd7vr3HbkLePxTp?=
 =?us-ascii?Q?DtiPmtULLfEoYTeb3iRlMrIznNYIGjPIptvi92UPnlKBXQtd5c8diR0jmXwb?=
 =?us-ascii?Q?tNXwFB+wjMBL56bkGBLGgjJUsZojvcizqabq7AHLRacvgIwK3Qb8XfRlZXqI?=
 =?us-ascii?Q?E3hqyFlcp6oV+eZCDfZwBG3PW3E5VGs30POfdrPhJOW2GtmHX/8+K2AH2c7+?=
 =?us-ascii?Q?Cum7/vq34QxFuaRPs23nTyuucAA1ZyT/S9copeRCqF9lztqFTIUbAsCWtGBj?=
 =?us-ascii?Q?vLQ89+qAju15dSVVuhH2Z36Z/w5BAmEPTGQ0uhnOvHzXfUsYUcJRaz95Nh/e?=
 =?us-ascii?Q?dBU06BE6QqyCMQpeRfnWSo1GtOF2DhleCtYJKHo3nWNI3FW36kMW1TmEamWv?=
 =?us-ascii?Q?HvDE4x0iFHr5BJXGNXpB0moOKK/nnEorycTuUASrLCsq4LYkyjDxAXU0zMyD?=
 =?us-ascii?Q?+i1sobpF09ynzHswIeRAOmyy2muxG3DhzUg44++cgOY5G2WbSuZVs5MiqgA6?=
 =?us-ascii?Q?6MH4oxylV+GYbj7sdS7mOPJ0yk6I2yJIb8OcJEHOhBrZkA3+B/hVcHGwFVoe?=
 =?us-ascii?Q?xNlKl5+02Nw+7n+3cCb98KA2oovWC/Qwmlrv9OoRpsz7FOAHQSF5Kh8heJlJ?=
 =?us-ascii?Q?KIQZta3hHafzvqMRjWFuFL5Ro++ZCdj9PMtWSFE5IMKTS3embpaDE6GJCRhM?=
 =?us-ascii?Q?1bL5/IV6g7CKlzvdm11yVaAQ94ZRxUYRVeR0MgBN+yqLYH6NqALmqZpw7wZI?=
 =?us-ascii?Q?LTEQDNJHTFDREQnmJVzl3wxasa7HLqZNy8se23o8EZFr+OJThKaXmM3nmbb/?=
 =?us-ascii?Q?rYo7VvTPVUEYEwdTjZ9wWktAuWNEuNmBBh48LZshLELnS6Wniq5ZQIcYNxWW?=
 =?us-ascii?Q?BHyeN8zMjwiJCGnsbQV4SXjJSk24OB9ZgaD+RizX7uCGn+yuah4SKGar4iGc?=
 =?us-ascii?Q?It6NSyFTLMJH7nU6zaHllS6jXGsk3WxIKf1L9Fftf5XE0O3HBgXxVyzxlVhJ?=
 =?us-ascii?Q?BToiK1h25UueLqbzMRjqR9qDToqX+mFvFQkbnjKaaamhIbU7fMIXR1jleZLP?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c44b64d4-4f40-4139-b3a5-08db41f270f1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 22:56:13.7397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27SXkNzm5YWrSO7KsXAdHf4uKWpFwl0GMub0EHHJhjmqY34YV5NNvmLOHLOlrpbzIUWmxXOyesI7FcNW1Lsnlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9213
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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
index 12083b9679b5..6ea5521074d3 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1935,8 +1935,7 @@ u16 bnx2x_select_queue(struct net_device *dev, struct sk_buff *skb,
 
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
index c8c2cbaa0ede..8b8bf4880faa 100644
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
index f2604fc05991..e961ef4bbf4d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8798,7 +8798,7 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 
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
index 47534310365a..b8e2bd752f89 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4569,13 +4569,10 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
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

