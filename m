Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A3E1DF358
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbgEVXxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:53:07 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:15428
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387425AbgEVXxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:53:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHnoimxuRNMUw2crNacOukNGs1eHufnkwZLxuRydFNa0HvKuT8j1ClTNBg/bhEvC1rCsdK8PZZp0O1hn844FH2Xvl7C25L68eURkgx9BY0/+R76cGZLtmFVQrj7RL9kj1e6JpC8A6O6zXVRT2/P4K8ew+xshYC6Qr0F0qpNWdYgUAMiOT0cJMNnPudlalZvquBBitH7IU8cY4K3Ka3lBe3L3O74OOnp/aNdBvzq5a+Q9itDO6jSrNFtAVKWbx6ULSikW1dqiCNvxoZAk8sOYoUg2bc4y4WagOu9fRpcThlgThopocxpCMT7RE2FKuKjfdtTo+5xbP/jqenXT2T6h/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5j0Xj3ejeUt6XlKxINnV6Gk6iScQgTvR8JJALI4fAI8=;
 b=KTdaq4DR9ilnn4JxzaMoA3PUCew/+KIRrPMFU/5qfvHzqNx4nXbaPSEf8VOoMPpEbPTViVEGxLgQthAkCAU2BXqyXc2ioaS25GyCmH44onXQfMXyW5oDX8GX1htszwxndFvKjCJWqKdf5jme3uAVKQrqyi+yY4grRKpjZ60+MnHMpIU4vTXtZPHS2ZABXF1jZO2AlFZz20KwygyCocICHXcDvbuM/Ltu/sNBqCeQTBdk39MfKfThkjvg5Dt6nJm5Lwx+upghPime3fkQKEKfoh5qjT2CqnlBvPu3UE2sqNdIdZTDKnosyajBbQaeRUlmF5lDhP4tGA/uMvYx/0148Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5j0Xj3ejeUt6XlKxINnV6Gk6iScQgTvR8JJALI4fAI8=;
 b=c1AQordFXz9E/SFlmFKnR13hkfvrPcxelANABvxI0MDRboyh0kZ+9rzwtQpndVj2dMZwyzJpmM/ZEl2n+yYNhd1Eyc5jhJX+MS/mrbP5/whYIscRo8en3rNP2p0oKGftn87Nqdd1ZM5eEmFfhtXcepwM44fd3hVhvix/6AxMJas=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 23:52:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:52:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/10] net/mlx5e: Add support for hw decapsulation of MPLS over UDP
Date:   Fri, 22 May 2020 16:51:47 -0700
Message-Id: <20200522235148.28987-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200522235148.28987-1-saeedm@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Fri, 22 May 2020 23:52:27 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0c848ea4-b279-4864-9301-08d7feab3075
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB454409FF36DCB44487174970BEB40@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BxuJUfMizWjgLJB5cPWo0MQA5oHRb5w0Ule5tVxR1s7O629+QCMSG2qRJK9KmGrNlDsl/wIpoQ+IQFOreKA3uiY8GozUnpSKvzlB+j4+UuO4kUd49I5UoqLRE3Te/8jFJ8SmbWlvoRGL6wiZCCkjLPmZJJOQhD34NN8pEIcrPhDNaGdpYy1wA0sU/2a0D8SJsQI+8fv/TmQzaHAX4Y/9QIXuRCb/uXBM8rU7/CvtsrQYrpx0AlTxEwPdZH/dxHSQCyEGOuI81vOAiR/rupHpk9RO7/K5cAuyzOmmrdgnxSVXbm1GZvmNb+BvGVsv3MxLtPV1uVHGKmev0M7MDqTxfuJXKLMzUqhgFxQBT2BpLZ4qhEB0A8/HX4gT6KLyCpI8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(66476007)(956004)(6506007)(66556008)(2616005)(66946007)(107886003)(6512007)(1076003)(16526019)(478600001)(186003)(52116002)(26005)(4326008)(6666004)(30864003)(316002)(6486002)(86362001)(8676002)(54906003)(36756003)(8936002)(2906002)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4Hn0BBuicBmJ0uE1FDSwgBmH8pxuR371PgaosRdHu5qvwuYLSO4vBk98kXpK/6pv0Ksc8Scd6rH1yNVnKHuNGrn7CL+MfXtJlGpboiyzFThul6DKbMZHEGnV2iiHI+E2DSYGR2rJLBxinVPx1OxZ9yAC53YbvgBZX+CoXtEeYhXvz4LNNNA9SqLivJ0j54lSNp+snfsNrox08ufdketuqCGiJy4XrMZdr0bWQEiaJEISatXV/8UCTd4SdhWQa3S2Eo/ZdKyAms0JKQvcRzDgRJrURx5WQlp4CgUkALmJfKxsC5jqJGxIetjs4y0QjEu7+jT1pu6A/perUuluLIhiLVhOM9jo8JDh3Nni2zLHVLcHL7Yoj7epqitnQDSh0dZp6FBLC+aV0DfvCFx20iGcOuYfwn4g1xEgi1V4XuX+Q3yXGS9hqv56hktpfDEjmo9CyvYyQB91zwEuaO7l84E87NqfjDI6xQp1P5KpEuvNFeo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c848ea4-b279-4864-9301-08d7feab3075
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 23:52:30.5876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NysKxl9TC9+4g8+4hN6wmQYvB6QHAdsrGU1VJH82GpT732xbyyWEwqgJvmizX03ubS94ZlP2uua5QtWKjW+f8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

MPLS over UDP is supported in hardware by using a packet reformat object
with reformat type equal L3_TUNNEL_TO_L2 which both decapsulates the
outer L3, L4 and MPLS headers, and allows for setting the L2 headers of
the resulting decapsulated packet. For the hardware to operate
correctly, the configuration of the firmware must have
FLEX_PARSER_PROFILE_ENABLE = 1.

Example tc rule:
  tc filter add dev bareudp0 protocol all prio 1 root flower enc_dst_port \
      6635 enc_src_ip 8.8.8.23 action mpls pop protocol ip pipe \
      action pedit ex munge eth dst set 00:11:22:33:44:21 pipe action \
      mirred egress redirect dev enp59s0f0_0

We use pedit to set the correct destination MAC.

For MPLS over UDP decapsulation to take place, the driver logic requires
the following:

1. flower filter added on bareudp device.
2. action mpls pop
3. zero or more pedit munge actions
4. one redirect action

Current implementation supports only IPv4 and no VLAN.

tc filter show output looks like this:
   filter protocol all pref 1 flower chain 0
   filter protocol all pref 1 flower chain 0 handle 0x1
     enc_src_ip 8.8.8.24
     enc_dst_port 6635
     in_hw in_hw_count 1
            action order 1: mpls  pop protocol ip pipe
             index 2 ref 1 bind 1

            action order 2:  pedit action pipe keys 2
             index 1 ref 1 bind 1
             key #0  at eth+0: val 00112233 mask 00000000
             key #1  at eth+4: val 44210000 mask 0000ffff

            action order 3: mirred (Egress Redirect to device enp59s0f0_0) stolen
            index 2 ref 1 bind 1

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  16 ++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 217 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   3 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   3 +
 .../mellanox/mlx5/core/eswitch_offloads.c     |   4 +
 5 files changed, 238 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 81ed06e58fea..93e911baacad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -158,6 +158,22 @@ struct mlx5e_neigh_hash_entry {
 enum {
 	/* set when the encap entry is successfully offloaded into HW */
 	MLX5_ENCAP_ENTRY_VALID     = BIT(0),
+	MLX5_REFORMAT_DECAP        = BIT(1),
+};
+
+struct mlx5e_decap_key {
+	struct ethhdr key;
+};
+
+struct mlx5e_decap_entry {
+	struct mlx5e_decap_key key;
+	struct list_head flows;
+	struct hlist_node hlist;
+	refcount_t refcnt;
+	struct completion res_ready;
+	int compl_result;
+	struct mlx5_pkt_reformat *pkt_reformat;
+	struct rcu_head rcu;
 };
 
 struct mlx5e_encap_entry {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 801fcd1b5f85..a6b18f0444e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -46,6 +46,7 @@
 #include <net/tc_act/tc_tunnel_key.h>
 #include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_csum.h>
+#include <net/tc_act/tc_mpls.h>
 #include <net/arp.h>
 #include <net/ipv6_stubs.h>
 #include <net/bareudp.h>
@@ -93,6 +94,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_NOT_READY	= MLX5E_TC_FLOW_BASE + 5,
 	MLX5E_TC_FLOW_FLAG_DELETED	= MLX5E_TC_FLOW_BASE + 6,
 	MLX5E_TC_FLOW_FLAG_CT		= MLX5E_TC_FLOW_BASE + 7,
+	MLX5E_TC_FLOW_FLAG_L3_TO_L2_DECAP = MLX5E_TC_FLOW_BASE + 8,
 };
 
 #define MLX5E_TC_MAX_SPLITS 1
@@ -126,6 +128,11 @@ struct mlx5e_tc_flow {
 	u64			cookie;
 	unsigned long		flags;
 	struct mlx5_flow_handle *rule[MLX5E_TC_MAX_SPLITS + 1];
+
+	/* flows sharing the same reformat object - currently mpls decap */
+	struct list_head l3_to_l2_reformat;
+	struct mlx5e_decap_entry *decap_reformat;
+
 	/* Flow can be associated with multiple encap IDs.
 	 * The number of encaps is bounded by the number of supported
 	 * destinations.
@@ -157,6 +164,7 @@ struct mlx5e_tc_flow_parse_attr {
 	struct mlx5_flow_spec spec;
 	struct mlx5e_tc_mod_hdr_acts mod_hdr_acts;
 	int mirred_ifindex[MLX5_MAX_FLOW_FWD_VPORTS];
+	struct ethhdr eth;
 };
 
 #define MLX5E_TC_TABLE_NUM_GROUPS 4
@@ -1124,6 +1132,11 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 			      struct netlink_ext_ack *extack,
 			      struct net_device **encap_dev,
 			      bool *encap_valid);
+static int mlx5e_attach_decap(struct mlx5e_priv *priv,
+			      struct mlx5e_tc_flow *flow,
+			      struct netlink_ext_ack *extack);
+static void mlx5e_detach_decap(struct mlx5e_priv *priv,
+			       struct mlx5e_tc_flow *flow);
 
 static struct mlx5_flow_handle *
 mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
@@ -1299,6 +1312,12 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	if (flow_flag_test(flow, L3_TO_L2_DECAP)) {
+		err = mlx5e_attach_decap(priv, flow, extack);
+		if (err)
+			return err;
+	}
+
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
 		int mirred_ifindex;
 
@@ -1408,6 +1427,9 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(attr->counter_dev, attr->counter);
+
+	if (flow_flag_test(flow, L3_TO_L2_DECAP))
+		mlx5e_detach_decap(priv, flow);
 }
 
 void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
@@ -1684,6 +1706,17 @@ static void mlx5e_encap_dealloc(struct mlx5e_priv *priv, struct mlx5e_encap_entr
 	kfree_rcu(e, rcu);
 }
 
+static void mlx5e_decap_dealloc(struct mlx5e_priv *priv,
+				struct mlx5e_decap_entry *d)
+{
+	WARN_ON(!list_empty(&d->flows));
+
+	if (!d->compl_result)
+		mlx5_packet_reformat_dealloc(priv->mdev, d->pkt_reformat);
+
+	kfree_rcu(d, rcu);
+}
+
 void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
@@ -1696,6 +1729,18 @@ void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
 	mlx5e_encap_dealloc(priv, e);
 }
 
+static void mlx5e_decap_put(struct mlx5e_priv *priv, struct mlx5e_decap_entry *d)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+
+	if (!refcount_dec_and_mutex_lock(&d->refcnt, &esw->offloads.decap_tbl_lock))
+		return;
+	hash_del_rcu(&d->hlist);
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+
+	mlx5e_decap_dealloc(priv, d);
+}
+
 static void mlx5e_detach_encap(struct mlx5e_priv *priv,
 			       struct mlx5e_tc_flow *flow, int out_index)
 {
@@ -1719,6 +1764,29 @@ static void mlx5e_detach_encap(struct mlx5e_priv *priv,
 	mlx5e_encap_dealloc(priv, e);
 }
 
+static void mlx5e_detach_decap(struct mlx5e_priv *priv,
+			       struct mlx5e_tc_flow *flow)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_decap_entry *d = flow->decap_reformat;
+
+	if (!d)
+		return;
+
+	mutex_lock(&esw->offloads.decap_tbl_lock);
+	list_del(&flow->l3_to_l2_reformat);
+	flow->decap_reformat = NULL;
+
+	if (!refcount_dec_and_test(&d->refcnt)) {
+		mutex_unlock(&esw->offloads.decap_tbl_lock);
+		return;
+	}
+	hash_del_rcu(&d->hlist);
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+
+	mlx5e_decap_dealloc(priv, d);
+}
+
 static void __mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_eswitch *esw = flow->priv->mdev->priv.eswitch;
@@ -1990,7 +2058,11 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 			return err;
 		}
 
-		flow->esw_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
+		/* With mpls over udp we decapsulate using packet reformat
+		 * object
+		 */
+		if (!netif_is_bareudp(filter_dev))
+			flow->esw_attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
 	}
 
 	if (!needs_mapping && !sets_mapping)
@@ -3285,12 +3357,22 @@ static inline int cmp_encap_info(struct encap_key *a,
 	       a->tc_tunnel->tunnel_type != b->tc_tunnel->tunnel_type;
 }
 
+static inline int cmp_decap_info(struct mlx5e_decap_key *a,
+				 struct mlx5e_decap_key *b)
+{
+	return memcmp(&a->key, &b->key, sizeof(b->key));
+}
+
 static inline int hash_encap_info(struct encap_key *key)
 {
 	return jhash(key->ip_tun_key, sizeof(*key->ip_tun_key),
 		     key->tc_tunnel->tunnel_type);
 }
 
+static inline int hash_decap_info(struct mlx5e_decap_key *key)
+{
+	return jhash(&key->key, sizeof(key->key), 0);
+}
 
 static bool is_merged_eswitch_dev(struct mlx5e_priv *priv,
 				  struct net_device *peer_netdev)
@@ -3305,13 +3387,16 @@ static bool is_merged_eswitch_dev(struct mlx5e_priv *priv,
 		same_hw_devs(priv, peer_priv));
 }
 
-
-
 bool mlx5e_encap_take(struct mlx5e_encap_entry *e)
 {
 	return refcount_inc_not_zero(&e->refcnt);
 }
 
+static bool mlx5e_decap_take(struct mlx5e_decap_entry *e)
+{
+	return refcount_inc_not_zero(&e->refcnt);
+}
+
 static struct mlx5e_encap_entry *
 mlx5e_encap_get(struct mlx5e_priv *priv, struct encap_key *key,
 		uintptr_t hash_key)
@@ -3332,6 +3417,24 @@ mlx5e_encap_get(struct mlx5e_priv *priv, struct encap_key *key,
 	return NULL;
 }
 
+static struct mlx5e_decap_entry *
+mlx5e_decap_get(struct mlx5e_priv *priv, struct mlx5e_decap_key *key,
+		uintptr_t hash_key)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_decap_key r_key;
+	struct mlx5e_decap_entry *e;
+
+	hash_for_each_possible_rcu(esw->offloads.decap_tbl, e,
+				   hlist, hash_key) {
+		r_key = e->key;
+		if (!cmp_decap_info(&r_key, key) &&
+		    mlx5e_decap_take(e))
+			return e;
+	}
+	return NULL;
+}
+
 static struct ip_tunnel_info *dup_tun_info(const struct ip_tunnel_info *tun_info)
 {
 	size_t tun_size = sizeof(*tun_info) + tun_info->options_len;
@@ -3477,6 +3580,84 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	return err;
 }
 
+static int mlx5e_attach_decap(struct mlx5e_priv *priv,
+			      struct mlx5e_tc_flow *flow,
+			      struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct mlx5e_decap_entry *d;
+	struct mlx5e_decap_key key;
+	uintptr_t hash_key;
+	int err;
+
+	parse_attr = attr->parse_attr;
+	if (sizeof(parse_attr->eth) > MLX5_CAP_ESW(priv->mdev, max_encap_header_size)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "encap header larger than max supported");
+		return -EOPNOTSUPP;
+	}
+
+	key.key = parse_attr->eth;
+	hash_key = hash_decap_info(&key);
+	mutex_lock(&esw->offloads.decap_tbl_lock);
+	d = mlx5e_decap_get(priv, &key, hash_key);
+	if (d) {
+		mutex_unlock(&esw->offloads.decap_tbl_lock);
+		wait_for_completion(&d->res_ready);
+		mutex_lock(&esw->offloads.decap_tbl_lock);
+		if (d->compl_result) {
+			err = -EREMOTEIO;
+			goto out_free;
+		}
+		goto found;
+	}
+
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
+	if (!d) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	d->key = key;
+	refcount_set(&d->refcnt, 1);
+	init_completion(&d->res_ready);
+	INIT_LIST_HEAD(&d->flows);
+	hash_add_rcu(esw->offloads.decap_tbl, &d->hlist, hash_key);
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+
+	d->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
+						     MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2,
+						     sizeof(parse_attr->eth),
+						     &parse_attr->eth,
+						     MLX5_FLOW_NAMESPACE_FDB);
+	if (IS_ERR(d->pkt_reformat)) {
+		err = PTR_ERR(d->pkt_reformat);
+		d->compl_result = err;
+	}
+	mutex_lock(&esw->offloads.decap_tbl_lock);
+	complete_all(&d->res_ready);
+	if (err)
+		goto out_free;
+
+found:
+	flow->decap_reformat = d;
+	attr->decap_pkt_reformat = d->pkt_reformat;
+	list_add(&flow->l3_to_l2_reformat, &d->flows);
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+	return 0;
+
+out_free:
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+	mlx5e_decap_put(priv, d);
+	return err;
+
+out_err:
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+	return err;
+}
+
 static int parse_tc_vlan_action(struct mlx5e_priv *priv,
 				const struct flow_action_entry *act,
 				struct mlx5_esw_flow_attr *attr,
@@ -3688,7 +3869,8 @@ static int verify_uplink_forwarding(struct mlx5e_priv *priv,
 static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct flow_action *flow_action,
 				struct mlx5e_tc_flow *flow,
-				struct netlink_ext_ack *extack)
+				struct netlink_ext_ack *extack,
+				struct net_device *filter_dev)
 {
 	struct pedit_headers_action hdrs[2] = {};
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
@@ -3727,8 +3909,32 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			}
 			mpls_push = true;
 			break;
+		case FLOW_ACTION_MPLS_POP:
+			/* we only support mpls pop if it is the first action
+			 * and the filter net device is bareudp. Subsequent
+			 * actions can be pedit and the last can be mirred
+			 * egress redirect.
+			 */
+			if (i) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "mpls pop supported only as first action");
+				return -EOPNOTSUPP;
+			}
+			if (!netif_is_bareudp(filter_dev)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "mpls pop supported only on bareudp devices");
+				return -EOPNOTSUPP;
+			}
+
+			parse_attr->eth.h_proto = act->mpls_pop.proto;
+			action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			flow_flag_set(flow, L3_TO_L2_DECAP);
+			break;
 		case FLOW_ACTION_MANGLE:
 		case FLOW_ACTION_ADD:
+			if (flow_flag_test(flow, L3_TO_L2_DECAP))
+				return -EOPNOTSUPP;
+
 			err = parse_tc_pedit_action(priv, act, MLX5_FLOW_NAMESPACE_FDB,
 						    hdrs, extack);
 			if (err)
@@ -4093,6 +4299,7 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 		INIT_LIST_HEAD(&flow->encaps[out_index].list);
 	INIT_LIST_HEAD(&flow->mod_hdr);
 	INIT_LIST_HEAD(&flow->hairpin);
+	INIT_LIST_HEAD(&flow->l3_to_l2_reformat);
 	refcount_set(&flow->refcnt, 1);
 	init_completion(&flow->init_done);
 
@@ -4162,7 +4369,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
-	err = parse_tc_fdb_actions(priv, &rule->action, flow, extack);
+	err = parse_tc_fdb_actions(priv, &rule->action, flow, extack, filter_dev);
 	if (err)
 		goto err_free;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index c5eb4e7754a9..ac79b7c9aeb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2262,6 +2262,8 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	hash_init(esw->offloads.encap_tbl);
 	mutex_init(&esw->offloads.mod_hdr.lock);
 	hash_init(esw->offloads.mod_hdr.hlist);
+	mutex_init(&esw->offloads.decap_tbl_lock);
+	hash_init(esw->offloads.decap_tbl);
 	atomic64_set(&esw->offloads.num_flows, 0);
 	mutex_init(&esw->state_lock);
 	mutex_init(&esw->mode_lock);
@@ -2303,6 +2305,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	mutex_destroy(&esw->state_lock);
 	mutex_destroy(&esw->offloads.mod_hdr.lock);
 	mutex_destroy(&esw->offloads.encap_tbl_lock);
+	mutex_destroy(&esw->offloads.decap_tbl_lock);
 	kfree(esw->vports);
 	kfree(esw);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 4a1c6c78bb14..ccbbea3e0505 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -209,6 +209,8 @@ struct mlx5_esw_offload {
 	struct mutex peer_mutex;
 	struct mutex encap_tbl_lock; /* protects encap_tbl */
 	DECLARE_HASHTABLE(encap_tbl, 8);
+	struct mutex decap_tbl_lock; /* protects decap_tbl */
+	DECLARE_HASHTABLE(decap_tbl, 8);
 	struct mod_hdr_tbl mod_hdr;
 	DECLARE_HASHTABLE(termtbl_tbl, 8);
 	struct mutex termtbl_mutex; /* protects termtbl hash */
@@ -432,6 +434,7 @@ struct mlx5_esw_flow_attr {
 	struct mlx5_flow_table *fdb;
 	struct mlx5_flow_table *dest_ft;
 	struct mlx5_ct_attr ct_attr;
+	struct mlx5_pkt_reformat *decap_pkt_reformat;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 1c9be19ee025..554fc64d8ef6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -366,6 +366,10 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 			}
 		}
 	}
+
+	if (attr->decap_pkt_reformat)
+		flow_act.pkt_reformat = attr->decap_pkt_reformat;
+
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
 		dest[i].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
 		dest[i].counter_id = mlx5_fc_id(attr->counter);
-- 
2.25.4

