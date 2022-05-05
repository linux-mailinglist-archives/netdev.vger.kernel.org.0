Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FBE51B78F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243770AbiEEFsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243711AbiEEFrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:47:53 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2097.outbound.protection.outlook.com [40.107.236.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3289C35879
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 22:44:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwAPCmomCo6B9XZ8WJ5Vmsf0zSeYNUuzBBCpPqNTGSIKNzWxpY0ldWholUI6uVDfVPt/MuwFfTTQtu01hkcwrfMQQN6SzSbTUUlJOpGiDATUQot1bNUhgwyYWUH7zXXWbp1DovyTHgYiJ+4UWoULLJeRUZniOrPXURS85gYT9ih8s1KJXBsk0CPorDk/PoW+8IDBqNURo0zHlg8MjpUZ2n3zGW1gz31TqGms9FwUPo/iAMmtaAFgb+7mMRBK0A2tzNnVlKMAAI7cc9yS6lYJzjseXT+VE7FPHLtmb2wKXVCpoL777ZRUAJKv2aavkD66gtFWCu4gk7tFQRkYRfQPQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oO1SIZnCiwpQ0hbd/J93xvZtf9I/5IqnH1pY2GPfTU8=;
 b=iYFg4De7lcyvEN5yxN7i8O2ZeOlG3CXKVQiD0e7XO+C8l4kFOdc2/A1VqROj4iEXUunuH1m3IJ/H9ilpHucUB2yea0CRnaq3kOkReD1iXPbi3Zs61+AM0IRsmKzZkNuAXzNQocNDrH1Nl7L9pOBMJW5v61zoKHpkr2FpC679p3rnGjctsbitI3UDGKq8t3J9t66/UcGl61ZPiBktfwvGYoWVI1SeNMIMWoIvNPHbJnFNZGAdRdDJU8qKEb68+GS1ljDX2ukYx8xfJzXdbL4ZJPLKF9iknchBrOnAOjqxDF1nnN0YkGwmSQYgmVKO4ApchR0Zr9GX4KsOaFNWVbLi5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oO1SIZnCiwpQ0hbd/J93xvZtf9I/5IqnH1pY2GPfTU8=;
 b=Uj3AHnbIL/pUKyQP7bGJ87JMOrfYXEXTlhbteIGj8O+o84Ri/h5E4jfAKV8cYy+OwwuqxvmKx9rWGJ5j3W+FTcRB7+2I7POyLg9+iiaA5NvpCVbyj56lrApoMlX8NLSuq6IFY6TAvQsgy7PKBk8BK8LRhbxPq+B3PRfdMx6iERI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR13MB1257.namprd13.prod.outlook.com (2603:10b6:3:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.16; Thu, 5 May
 2022 05:44:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Thu, 5 May 2022
 05:44:13 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 7/9] nfp: flower: link pre_tun flow rules with neigh entries
Date:   Thu,  5 May 2022 14:43:46 +0900
Message-Id: <20220505054348.269511-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505054348.269511-1-simon.horman@corigine.com>
References: <20220505054348.269511-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0082.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b5b0579-c89e-452e-1347-08da2e5a48d6
X-MS-TrafficTypeDiagnostic: DM5PR13MB1257:EE_
X-Microsoft-Antispam-PRVS: <DM5PR13MB125762D473DDE749521C6CC4E8C29@DM5PR13MB1257.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oRIEiO+HxJF2h303enoSX67MMABr/dA2Jj5cFQbBTvz0ufXkKf0lCSkqLnJCw9VEkA+dQMsuuofvWS1r4Eawb5vEu3VJ+znyUPLW4wEAd2Y7yFUGa7dS02r5+DjlzLE2DjoUAa1lVrXI8jqin70nTMNLjyQ1llU8d7SAwcfVAuIkholoLyIWSaubLRUJKtvwIsSnmsuwOlxF4ujRZOjhYy6ZEj9nPtEEq5SVd6HSNKnjackoTZdVQBwDw/eIOmhzaTriXx85Q0QkuaS7rvJjEufWZwU0pZN7TL+seiRsRSk5tMR2EFQA6tpfm7nOkpvRjp9icl8tV7Djkcin1rsy+QB450dRbd4/s/W62TFGVxDXVJ6+3jxTWh8dcUW96QU9N/OAw1g1zcxhQtqy0B49nIe6ojIvGKc55umyit+I7oP4lbJiXXNrk3grAfD3DBP3P5YlB0IOCfjf251zWCQlwgNn+VvVbHDYnSIt6g2r4uVCDU8909IQ0IYj3j6NMeOQg5pyQvyeIIL9aMDlSU3QLM5HDc8ZSwVkWUKMyN54QKCfzXdzmWdzxs0Abhmdt8d3DRBN6ZOZC7YtioEg/5KWi7wXiH+BnJS5nWjI9EBLYXS/cixwPB5frTDbs0WQ0hwv5SC9WjUrTa641EnStMqCOkvWD+regbpDTp1D0LV/KWvmvlxiL4ePdVX/IR85Pt9RlcLuuSdK4GaOOFgAORQCeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(376002)(136003)(396003)(39830400003)(66556008)(66946007)(6506007)(8676002)(4326008)(5660300002)(52116002)(1076003)(186003)(6486002)(36756003)(2616005)(316002)(110136005)(83380400001)(107886003)(66476007)(6512007)(8936002)(38100700002)(38350700002)(86362001)(508600001)(26005)(6666004)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qd3hSfhWJmO8iHw9kJMdL3ILmlJQgl6Nz40Sb00wOZBg9mGJFJvD2FXBf/By?=
 =?us-ascii?Q?MEu9sJlkgUTWrN/P5Mlp6F2u6Xg2PuFpsJkeIl/xQ3B/0C+jJ1QHJhh4fHTO?=
 =?us-ascii?Q?gZQVGY+Crm7WIJnSZkaYcpfYpdi5MAPrXWOFvzNfkcgNgI9/zEvoRSyw51Ir?=
 =?us-ascii?Q?LmXM4o9wiKNm48u9nVXjci+vNro2AAeK6ghVaqUTQMGqk0MD2lpBvtjzMiXt?=
 =?us-ascii?Q?GC/6qWZgnCA9n8KsZp4PpqS7hvn16yWinvzxkhwxnYtWy84Yhg1L34W00SLh?=
 =?us-ascii?Q?yYxgzqnQ5tBqqiA8Te9dzp8IN1nGK2H92I3AzFGcYCETkGEcJ6RECYO1VsSh?=
 =?us-ascii?Q?mt7Ip2Ph4ct2Vk4z2f8iKh35ie7/ptMN2coYJpmorQWNUK0+AzaMdxYKQTgY?=
 =?us-ascii?Q?RnWNwJ9bAwyqrttFhYFh8N686b0chCx0vL6yeIAXamKpaeFMmMi4OIr2t9bf?=
 =?us-ascii?Q?2pc/tEKAc2C3YDEE/kJ4HU4p13I06PWiT5bDMYTP6o2rjJf/my+sXN96tyHw?=
 =?us-ascii?Q?OLVHUfXpvAMpCMEIRMdRxep8kGwNLXn2+1pK6s8dRKO7vn6hBm9HT2HnaExW?=
 =?us-ascii?Q?AVljitXOT+ArZ/ee3X+SzR4G+GV/iG7tLJGtbOK4+D2U6mrTtx8cdYcB+xQG?=
 =?us-ascii?Q?UOCqC9V/QxLQ5XFbWEMvoYSLg1aSfFgychIfzM2mKmU7+Ob5hyeGlwQARKUz?=
 =?us-ascii?Q?fi0ruY9yoy/JSKXIOlmTxBqE9Mbeo36J7lvs8TAOovT2QbgCex8Rswmg1tUV?=
 =?us-ascii?Q?MNHNd5K314maSLHoos5sV2nWRTa9yQaF05gm43FO64HqfOJs1QMo2S+cg+Bi?=
 =?us-ascii?Q?Fwy3GwmMyGdXZX59RR5/gV9QXO1K8GrK+s3oDFg4YykRlsz0bxZgVyHluM+q?=
 =?us-ascii?Q?Sn9RBeYj8zd/7aL0qmQlAC3VQ8cpgvmZJbCpsNeysmlHeLO/D//4J08xkBhd?=
 =?us-ascii?Q?haKKeniw//27P2a0jGN1yRjjO5Q456sCfTAZyrkL6TobGXTiy2Wv6aH8lKMW?=
 =?us-ascii?Q?Pg6R1mt+hPNFL7qNfW8X6FNAQXldTYFOMAZ6YH8/zljBLLtsHOx2oyx9/rb6?=
 =?us-ascii?Q?sRyq/NTbo+LPiHaJ9pdtjtKtqQ4IDXUXuPgXtLiTYB04NlcNBDGdCO3sC9so?=
 =?us-ascii?Q?rmiBbcCXPO7jPgQfVeuqHXw+MvL8DKwYO8Db5JFXWt41xhTaqT+m/kZnkYwp?=
 =?us-ascii?Q?xTnPkX6gRdiNrdQG0yWtk9s8HGhtsBP0hMmpGc6FDCtbxNPlUdnrAS0K+AiU?=
 =?us-ascii?Q?gq8fXSeKXx5L1t7r65Hn9v1T6aCyB85p7kptPvlcKU+Qq8Xgycr+3B1HalEs?=
 =?us-ascii?Q?tEsUCA203MEordqBDoi+QiIqhu47RtrCYrx2YqVoLVuW9OhNFQqWpQhXwUaU?=
 =?us-ascii?Q?+AJ0/qtsn1ZKabaqzJnXJhycfmGIAS4B1eFBah+vXe4lCiF+RdQKTECMbLSk?=
 =?us-ascii?Q?kvvS/KjeXlvz80zbZ0Uy/KTHrt97By0z7pXWKxTuJznBDVKGvRL4+BsRC/IG?=
 =?us-ascii?Q?tDT5H5EPFgDX1y8LBtJ+JRd3ZQbytrjwDho5AZovrAneDUv1SRPsfyJL4cCC?=
 =?us-ascii?Q?MrMC7kT2a/vAFG683IDvS+C/RHhQQQx391qk7qH9oJSHPeeIwbGu5V/ft24R?=
 =?us-ascii?Q?mNDVVMb4SJvF6A0/xdr6UMIWQK19gj0zq8UqqK1uj0XdKyKhzICGmQEDb7cl?=
 =?us-ascii?Q?CXVjGn031AW8wUUckTCEEx/GWtkDibb+7wdFY4cF5XiJr5mXx9cUD9+0FTL6?=
 =?us-ascii?Q?aJEqJ3S0F0EZQxWSuoTVlNpT9jmtcuc=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5b0579-c89e-452e-1347-08da2e5a48d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 05:44:13.2613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6iqFgfh5LYBmFXXnspgeOPwX4TYwSqbo15oiNeFJB1w5xNSevFY9XIMMRHj7KQ/6wli76quAoPbz+mQH49kyJF7pwHzkL4ay+R8W5PRh4Es=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1257
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add helper functions that can create links between flow rules
and cached neighbour entries. Also add the relevant calls to
these functions.

* When a new neighbour entry gets added cycle through the saved
  pre_tun flow list and link any relevant matches. Update the
  neighbour table on the nfp with this new information.
* When a new pre_tun flow rule gets added iterate through the
  save neighbour entries and link any relevant matches. Once
  again update the nfp neighbour table with any new links.
* Do the inverse when deleting - remove any created links and
  also inform the nfp of this.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |   4 +
 .../ethernet/netronome/nfp/flower/offload.c   |   4 +-
 .../netronome/nfp/flower/tunnel_conf.c        | 147 ++++++++++++++++++
 3 files changed, 154 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 2c011d60c212..6bc7a9cbf131 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -675,6 +675,10 @@ void
 nfp_flower_non_repr_priv_put(struct nfp_app *app, struct net_device *netdev);
 u32 nfp_flower_get_port_id_from_netdev(struct nfp_app *app,
 				       struct net_device *netdev);
+void nfp_tun_link_and_update_nn_entries(struct nfp_app *app,
+					struct nfp_predt_entry *predt);
+void nfp_tun_unlink_and_update_nn_entries(struct nfp_app *app,
+					  struct nfp_predt_entry *predt);
 int nfp_flower_xmit_pre_tun_flow(struct nfp_app *app,
 				 struct nfp_fl_payload *flow);
 int nfp_flower_xmit_pre_tun_del_flow(struct nfp_app *app,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 5fea3e3415fe..9d65459bdba5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1402,8 +1402,9 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 			INIT_LIST_HEAD(&predt->nn_list);
 			spin_lock_bh(&priv->predt_lock);
 			list_add(&predt->list_head, &priv->predt_list);
-			spin_unlock_bh(&priv->predt_lock);
 			flow_pay->pre_tun_rule.predt = predt;
+			nfp_tun_link_and_update_nn_entries(app, predt);
+			spin_unlock_bh(&priv->predt_lock);
 		} else {
 			err = nfp_flower_xmit_pre_tun_flow(app, flow_pay);
 		}
@@ -1590,6 +1591,7 @@ nfp_flower_del_offload(struct nfp_app *app, struct net_device *netdev,
 			predt = nfp_flow->pre_tun_rule.predt;
 			if (predt) {
 				spin_lock_bh(&priv->predt_lock);
+				nfp_tun_unlink_and_update_nn_entries(app, predt);
 				list_del(&predt->list_head);
 				spin_unlock_bh(&priv->predt_lock);
 				kfree(predt);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 4ca149501409..fa9df24bec27 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -301,6 +301,150 @@ nfp_flower_xmit_tun_conf(struct nfp_app *app, u8 mtype, u16 plen, void *pdata,
 	return 0;
 }
 
+static void
+nfp_tun_mutual_link(struct nfp_predt_entry *predt,
+		    struct nfp_neigh_entry *neigh)
+{
+	struct nfp_fl_payload *flow_pay = predt->flow_pay;
+	struct nfp_tun_neigh_ext *ext;
+	struct nfp_tun_neigh *common;
+
+	if (flow_pay->pre_tun_rule.is_ipv6 != neigh->is_ipv6)
+		return;
+
+	/* In the case of bonding it is possible that there might already
+	 * be a flow linked (as the MAC address gets shared). If a flow
+	 * is already linked just return.
+	 */
+	if (neigh->flow)
+		return;
+
+	common = neigh->is_ipv6 ?
+		 &((struct nfp_tun_neigh_v6 *)neigh->payload)->common :
+		 &((struct nfp_tun_neigh_v4 *)neigh->payload)->common;
+	ext = neigh->is_ipv6 ?
+		 &((struct nfp_tun_neigh_v6 *)neigh->payload)->ext :
+		 &((struct nfp_tun_neigh_v4 *)neigh->payload)->ext;
+
+	if (memcmp(flow_pay->pre_tun_rule.loc_mac,
+		   common->src_addr, ETH_ALEN) ||
+	    memcmp(flow_pay->pre_tun_rule.rem_mac,
+		   common->dst_addr, ETH_ALEN))
+		return;
+
+	list_add(&neigh->list_head, &predt->nn_list);
+	neigh->flow = predt;
+	ext->host_ctx = flow_pay->meta.host_ctx_id;
+	ext->vlan_tci = flow_pay->pre_tun_rule.vlan_tci;
+	ext->vlan_tpid = flow_pay->pre_tun_rule.vlan_tpid;
+}
+
+static void
+nfp_tun_link_predt_entries(struct nfp_app *app,
+			   struct nfp_neigh_entry *nn_entry)
+{
+	struct nfp_flower_priv *priv = app->priv;
+	struct nfp_predt_entry *predt, *tmp;
+
+	list_for_each_entry_safe(predt, tmp, &priv->predt_list, list_head) {
+		nfp_tun_mutual_link(predt, nn_entry);
+	}
+}
+
+void nfp_tun_link_and_update_nn_entries(struct nfp_app *app,
+					struct nfp_predt_entry *predt)
+{
+	struct nfp_flower_priv *priv = app->priv;
+	struct nfp_neigh_entry *nn_entry;
+	struct rhashtable_iter iter;
+	size_t neigh_size;
+	u8 type;
+
+	rhashtable_walk_enter(&priv->neigh_table, &iter);
+	rhashtable_walk_start(&iter);
+	while ((nn_entry = rhashtable_walk_next(&iter)) != NULL) {
+		if (IS_ERR(nn_entry))
+			continue;
+		nfp_tun_mutual_link(predt, nn_entry);
+		neigh_size = nn_entry->is_ipv6 ?
+			     sizeof(struct nfp_tun_neigh_v6) :
+			     sizeof(struct nfp_tun_neigh_v4);
+		type = nn_entry->is_ipv6 ? NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6 :
+					   NFP_FLOWER_CMSG_TYPE_TUN_NEIGH;
+		nfp_flower_xmit_tun_conf(app, type, neigh_size,
+					 nn_entry->payload,
+					 GFP_ATOMIC);
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+}
+
+static void nfp_tun_cleanup_nn_entries(struct nfp_app *app)
+{
+	struct nfp_flower_priv *priv = app->priv;
+	struct nfp_neigh_entry *neigh;
+	struct nfp_tun_neigh_ext *ext;
+	struct rhashtable_iter iter;
+	size_t neigh_size;
+	u8 type;
+
+	rhashtable_walk_enter(&priv->neigh_table, &iter);
+	rhashtable_walk_start(&iter);
+	while ((neigh = rhashtable_walk_next(&iter)) != NULL) {
+		if (IS_ERR(neigh))
+			continue;
+		ext = neigh->is_ipv6 ?
+			 &((struct nfp_tun_neigh_v6 *)neigh->payload)->ext :
+			 &((struct nfp_tun_neigh_v4 *)neigh->payload)->ext;
+		ext->host_ctx = cpu_to_be32(U32_MAX);
+		ext->vlan_tpid = cpu_to_be16(U16_MAX);
+		ext->vlan_tci = cpu_to_be16(U16_MAX);
+
+		neigh_size = neigh->is_ipv6 ?
+			     sizeof(struct nfp_tun_neigh_v6) :
+			     sizeof(struct nfp_tun_neigh_v4);
+		type = neigh->is_ipv6 ? NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6 :
+					   NFP_FLOWER_CMSG_TYPE_TUN_NEIGH;
+		nfp_flower_xmit_tun_conf(app, type, neigh_size, neigh->payload,
+					 GFP_ATOMIC);
+
+		rhashtable_remove_fast(&priv->neigh_table, &neigh->ht_node,
+				       neigh_table_params);
+		if (neigh->flow)
+			list_del(&neigh->list_head);
+		kfree(neigh);
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+}
+
+void nfp_tun_unlink_and_update_nn_entries(struct nfp_app *app,
+					  struct nfp_predt_entry *predt)
+{
+	struct nfp_neigh_entry *neigh, *tmp;
+	struct nfp_tun_neigh_ext *ext;
+	size_t neigh_size;
+	u8 type;
+
+	list_for_each_entry_safe(neigh, tmp, &predt->nn_list, list_head) {
+		ext = neigh->is_ipv6 ?
+			 &((struct nfp_tun_neigh_v6 *)neigh->payload)->ext :
+			 &((struct nfp_tun_neigh_v4 *)neigh->payload)->ext;
+		neigh->flow = NULL;
+		ext->host_ctx = cpu_to_be32(U32_MAX);
+		ext->vlan_tpid = cpu_to_be16(U16_MAX);
+		ext->vlan_tci = cpu_to_be16(U16_MAX);
+		list_del(&neigh->list_head);
+		neigh_size = neigh->is_ipv6 ?
+			     sizeof(struct nfp_tun_neigh_v6) :
+			     sizeof(struct nfp_tun_neigh_v4);
+		type = neigh->is_ipv6 ? NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6 :
+					   NFP_FLOWER_CMSG_TYPE_TUN_NEIGH;
+		nfp_flower_xmit_tun_conf(app, type, neigh_size, neigh->payload,
+					 GFP_ATOMIC);
+	}
+}
+
 static bool
 __nfp_tun_has_route(struct list_head *route_list, spinlock_t *list_lock,
 		    void *add, int add_len)
@@ -497,6 +641,7 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 			nfp_tun_add_route_to_cache_v4(app, &payload->dst_ipv4);
 		}
 
+		nfp_tun_link_predt_entries(app, nn_entry);
 		nfp_flower_xmit_tun_conf(app, mtype, neigh_size,
 					 nn_entry->payload,
 					 GFP_ATOMIC);
@@ -1482,4 +1627,6 @@ void nfp_tunnel_config_stop(struct nfp_app *app)
 	/* Destroy rhash. Entries should be cleaned on netdev notifier unreg. */
 	rhashtable_free_and_destroy(&priv->tun.offloaded_macs,
 				    nfp_check_rhashtable_empty, NULL);
+
+	nfp_tun_cleanup_nn_entries(app);
 }
-- 
2.30.2

