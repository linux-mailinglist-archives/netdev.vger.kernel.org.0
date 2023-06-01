Return-Path: <netdev+bounces-7096-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 754BF719E58
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D307E1C21071
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DFD620994;
	Thu,  1 Jun 2023 13:32:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E31423423
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 13:32:51 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9337FE5C
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685626354; x=1717162354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bk1JO/AW7i9/mzNN6Z9OmbHTMgQGX3HzydrVnmPCRyk=;
  b=Leec8x3PDJWLhskkHIRUeEXP1XFckiIf+NO4jX9GufxH+fYIA7ZAFq02
   6IQC6vH1cnILS3otR087yPP7fJ1KAwOsHu7gtj6DGn/to0c4r/ju8spfF
   l+6Q7wY1m3G0lNw98XNcMYF6mRJRX0Y5Ba1VbJW6DOtBSUAQz3yHmriro
   9fCJbde5fhbOZZqwdgwLewcLp1nqZMQhjAPETqZKSxUzrAnu0u90GvCBF
   N7MShLudXbDNGu+p5gJw57z9i/V0+Cv9l5P8WM+SJPR/Pn8BHUUzS6fKz
   v6UBmYgDcU3w7YkPFrP5g6S6vrjtWSzBKm128w9xNc32etZYQJq1RWMTf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="335906200"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="335906200"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 06:32:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="772427608"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="772427608"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jun 2023 06:32:05 -0700
Received: from giewont.igk.intel.com (giewont.igk.intel.com [10.211.8.15])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 4EF5634927;
	Thu,  1 Jun 2023 14:32:03 +0100 (IST)
From: Marcin Szycik <marcin.szycik@linux.intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	wojciech.drewek@intel.com,
	michal.swiatkowski@linux.intel.com,
	alexandr.lobakin@intel.com,
	davem@davemloft.net,
	kuba@kernel.org,
	jiri@resnulli.us,
	pabeni@redhat.com,
	jesse.brandeburg@intel.com,
	simon.horman@corigine.com,
	idosch@nvidia.com,
	Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [RFC PATCH iwl-next 2/6] ip_tunnel: convert __be16 tunnel flags to bitmaps
Date: Thu,  1 Jun 2023 15:19:25 +0200
Message-Id: <20230601131929.294667-3-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230601131929.294667-1-marcin.szycik@linux.intel.com>
References: <20230601131929.294667-1-marcin.szycik@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexander Lobakin <alexandr.lobakin@intel.com>

Historically, tunnel flags like TUNNEL_CSUM or TUNNEL_ERSPAN_OPT
have been defined as __be16. Now all of those 16 bits are occupied
and there's no more free space for new flags.
It can't be simply switched to a bigger container with no
adjustments to the values, since it's an explicit Endian storage,
and on LE systems (__be16)0x0001 equals to
(__be64)0x0001000000000000.
We could probably define new 64-bit flags depending on the
Endianness, i.e. (__be64)0x0001 on BE and (__be64)0x00010000... on
LE, but that would introduce an Endianness dependency and spawn a
ton of Sparse warnings. To mitigate them, all of those places which
were adjusted with this change would be touched anyway, so why not
define stuff properly if there's no choice.

Define IP_TUNNEL_*_BIT counterparts as a bit number instead of the
value already coded and a fistful of <16 <-> bitmap> converters and
helpers. The two flags which have a different bit position are
SIT_ISATAP_64 and VTI_ISVTI_64, as they were defined not as
__cpu_to_be16(), but as (__force __be16), i.e. had different
positions on LE and BE. Now they have a strongly defined place.
Change all __be16 fields which were used to store those flags, to
IP_TUNNEL_DECLARE_FLAGS() -> DECLARE_BITMAP(__IP_TUNNEL_FLAG_NUM) ->
unsigned long[1] for now, and replace all TUNNEL_* occurencies to
their 64-bit bitmap counterparts. Use the converters in the places
which talk to the userspace, hardware (NFP) or other hosts (GRE
header). The rest must explicitly use the new flags only. This must
be done at once, otherwise there will be too much conversions
throughout the code in the intermediate commits.
Finally, disable the old __be16 flags for use in the kernel code
(except for the two 'irregular' flags mentioned above), to prevent
any accidential (mis)use of them. For the userspace, nothing is
changed, only additions were made.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
---
 drivers/net/bareudp.c                         |  19 ++-
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |   2 +-
 .../mellanox/mlx5/core/en/tc_tun_encap.c      |   6 +-
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     |  12 +-
 .../mellanox/mlx5/core/en/tc_tun_gre.c        |   9 +-
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  15 +-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  32 +++--
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |   6 +-
 .../ethernet/netronome/nfp/flower/action.c    |  26 +++-
 drivers/net/geneve.c                          |  46 +++---
 drivers/net/vxlan/vxlan_core.c                |  14 +-
 include/net/dst_metadata.h                    |  10 +-
 include/net/flow_dissector.h                  |   2 +-
 include/net/gre.h                             |  59 ++++----
 include/net/ip6_tunnel.h                      |   4 +-
 include/net/ip_tunnels.h                      |  90 ++++++++++--
 include/net/udp_tunnel.h                      |   4 +-
 include/uapi/linux/if_tunnel.h                |  33 +++++
 net/bridge/br_vlan_tunnel.c                   |   5 +-
 net/core/filter.c                             |  20 +--
 net/core/flow_dissector.c                     |  12 +-
 net/ipv4/fou_bpf.c                            |   2 +-
 net/ipv4/gre_demux.c                          |   2 +-
 net/ipv4/ip_gre.c                             | 131 +++++++++++-------
 net/ipv4/ip_tunnel.c                          |  51 ++++---
 net/ipv4/ip_tunnel_core.c                     |  81 +++++++----
 net/ipv4/ip_vti.c                             |  31 +++--
 net/ipv4/ipip.c                               |  21 ++-
 net/ipv4/udp_tunnel_core.c                    |   5 +-
 net/ipv6/ip6_gre.c                            |  87 +++++++-----
 net/ipv6/ip6_tunnel.c                         |  14 +-
 net/ipv6/sit.c                                |   9 +-
 net/netfilter/ipvs/ip_vs_core.c               |   6 +-
 net/netfilter/ipvs/ip_vs_xmit.c               |  20 +--
 net/netfilter/nft_tunnel.c                    |  45 +++---
 net/openvswitch/flow_netlink.c                |  55 ++++----
 net/psample/psample.c                         |  26 ++--
 net/sched/act_tunnel_key.c                    |  39 +++---
 net/sched/cls_flower.c                        |  27 ++--
 40 files changed, 695 insertions(+), 392 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 683203f87ae2..f5b001c7f48c 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -61,6 +61,7 @@ struct bareudp_dev {
 static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 {
 	struct metadata_dst *tun_dst = NULL;
+	IP_TUNNEL_DECLARE_FLAGS(key) = { };
 	struct bareudp_dev *bareudp;
 	unsigned short family;
 	unsigned int len;
@@ -137,7 +138,10 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		bareudp->dev->stats.rx_dropped++;
 		goto drop;
 	}
-	tun_dst = udp_tun_rx_dst(skb, family, TUNNEL_KEY, 0, 0);
+
+	__set_bit(IP_TUNNEL_KEY_BIT, key);
+
+	tun_dst = udp_tun_rx_dst(skb, family, key, 0, 0);
 	if (!tun_dst) {
 		bareudp->dev->stats.rx_dropped++;
 		goto drop;
@@ -291,10 +295,10 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			    struct bareudp_dev *bareudp,
 			    const struct ip_tunnel_info *info)
 {
+	bool udp_sum = test_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags);
 	bool xnet = !net_eq(bareudp->net, dev_net(bareudp->dev));
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct socket *sock = rcu_dereference(bareudp->sock);
-	bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
 	const struct ip_tunnel_key *key = &info->key;
 	struct rtable *rt;
 	__be16 sport, df;
@@ -320,7 +324,8 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 				  true);
 	tos = ip_tunnel_ecn_encap(key->tos, ip_hdr(skb), skb);
 	ttl = key->ttl;
-	df = key->tun_flags & TUNNEL_DONT_FRAGMENT ? htons(IP_DF) : 0;
+	df = test_bit(IP_TUNNEL_DONT_FRAGMENT_BIT, key->tun_flags) ?
+	     htons(IP_DF) : 0;
 	skb_scrub_packet(skb, xnet);
 
 	err = -ENOSPC;
@@ -342,7 +347,8 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	udp_tunnel_xmit_skb(rt, sock->sk, skb, saddr, info->key.u.ipv4.dst,
 			    tos, ttl, df, sport, bareudp->port,
 			    !net_eq(bareudp->net, dev_net(bareudp->dev)),
-			    !(info->key.tun_flags & TUNNEL_CSUM));
+			    !test_bit(IP_TUNNEL_CSUM_BIT,
+				      info->key.tun_flags));
 	return 0;
 
 free_dst:
@@ -354,10 +360,10 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			     struct bareudp_dev *bareudp,
 			     const struct ip_tunnel_info *info)
 {
+	bool udp_sum = test_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags);
 	bool xnet = !net_eq(bareudp->net, dev_net(bareudp->dev));
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct socket *sock  = rcu_dereference(bareudp->sock);
-	bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
 	const struct ip_tunnel_key *key = &info->key;
 	struct dst_entry *dst = NULL;
 	struct in6_addr saddr, daddr;
@@ -404,7 +410,8 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	udp_tunnel6_xmit_skb(dst, sock->sk, skb, dev,
 			     &saddr, &daddr, prio, ttl,
 			     info->key.label, sport, bareudp->port,
-			     !(info->key.tun_flags & TUNNEL_CSUM));
+			     !test_bit(IP_TUNNEL_CSUM_BIT,
+				       info->key.tun_flags));
 	return 0;
 
 free_dst:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index 92065568bb19..6873c1201803 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -117,7 +117,7 @@ bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
 
 bool mlx5e_tc_tun_encap_info_equal_options(struct mlx5e_encap_key *a,
 					   struct mlx5e_encap_key *b,
-					   __be16 tun_flags);
+					   u32 tun_type);
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif //__MLX5_EN_TC_TUNNEL_H__
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 6a052c6cfc15..9203af8436ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -573,7 +573,7 @@ bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
 
 bool mlx5e_tc_tun_encap_info_equal_options(struct mlx5e_encap_key *a,
 					   struct mlx5e_encap_key *b,
-					   __be16 tun_flags)
+					   u32 tun_type)
 {
 	struct ip_tunnel_info *a_info;
 	struct ip_tunnel_info *b_info;
@@ -582,8 +582,8 @@ bool mlx5e_tc_tun_encap_info_equal_options(struct mlx5e_encap_key *a,
 	if (!mlx5e_tc_tun_encap_info_equal_generic(a, b))
 		return false;
 
-	a_has_opts = !!(a->ip_tun_key->tun_flags & tun_flags);
-	b_has_opts = !!(b->ip_tun_key->tun_flags & tun_flags);
+	a_has_opts = test_bit(tun_type, a->ip_tun_key->tun_flags);
+	b_has_opts = test_bit(tun_type, b->ip_tun_key->tun_flags);
 
 	/* keys are equal when both don't have any options attached */
 	if (!a_has_opts && !b_has_opts)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index 2bcd10b6d653..bf969212cc77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -106,12 +106,13 @@ static int mlx5e_gen_ip_tunnel_header_geneve(char buf[],
 	memset(geneveh, 0, sizeof(*geneveh));
 	geneveh->ver = MLX5E_GENEVE_VER;
 	geneveh->opt_len = tun_info->options_len / 4;
-	geneveh->oam = !!(tun_info->key.tun_flags & TUNNEL_OAM);
-	geneveh->critical = !!(tun_info->key.tun_flags & TUNNEL_CRIT_OPT);
+	geneveh->oam = test_bit(IP_TUNNEL_OAM_BIT, tun_info->key.tun_flags);
+	geneveh->critical = test_bit(IP_TUNNEL_CRIT_OPT_BIT,
+				     tun_info->key.tun_flags);
 	mlx5e_tunnel_id_to_vni(tun_info->key.tun_id, geneveh->vni);
 	geneveh->proto_type = htons(ETH_P_TEB);
 
-	if (tun_info->key.tun_flags & TUNNEL_GENEVE_OPT) {
+	if (test_bit(IP_TUNNEL_GENEVE_OPT_BIT, tun_info->key.tun_flags)) {
 		if (!geneveh->opt_len)
 			return -EOPNOTSUPP;
 		ip_tunnel_info_opts_get(geneveh->options, tun_info);
@@ -188,7 +189,7 @@ static int mlx5e_tc_tun_parse_geneve_options(struct mlx5e_priv *priv,
 
 	/* make sure that we're talking about GENEVE options */
 
-	if (enc_opts.key->dst_opt_type != TUNNEL_GENEVE_OPT) {
+	if (enc_opts.key->dst_opt_type != IP_TUNNEL_GENEVE_OPT_BIT) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Matching on GENEVE options: option type is not GENEVE");
 		netdev_warn(priv->netdev,
@@ -337,7 +338,8 @@ static int mlx5e_tc_tun_parse_geneve(struct mlx5e_priv *priv,
 static bool mlx5e_tc_tun_encap_info_equal_geneve(struct mlx5e_encap_key *a,
 						 struct mlx5e_encap_key *b)
 {
-	return mlx5e_tc_tun_encap_info_equal_options(a, b, TUNNEL_GENEVE_OPT);
+	return mlx5e_tc_tun_encap_info_equal_options(a, b,
+						     IP_TUNNEL_GENEVE_OPT_BIT);
 }
 
 struct mlx5e_tc_tunnel geneve_tunnel = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
index ada14f0574dc..bd4746195e3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
@@ -31,12 +31,17 @@ static int mlx5e_gen_ip_tunnel_header_gretap(char buf[],
 	const struct ip_tunnel_key *tun_key  = &e->tun_info->key;
 	struct gre_base_hdr *greh = (struct gre_base_hdr *)(buf);
 	__be32 tun_id = tunnel_id_to_key32(tun_key->tun_id);
+	IP_TUNNEL_DECLARE_FLAGS(unsupp) = { };
 	int hdr_len;
 
 	*ip_proto = IPPROTO_GRE;
 
 	/* the HW does not calculate GRE csum or sequences */
-	if (tun_key->tun_flags & (TUNNEL_CSUM | TUNNEL_SEQ))
+	__set_bit(IP_TUNNEL_CSUM_BIT, unsupp);
+	__set_bit(IP_TUNNEL_SEQ_BIT, unsupp);
+
+	if (bitmap_and(unsupp, tun_key->tun_flags, unsupp,
+		       __IP_TUNNEL_FLAG_NUM))
 		return -EOPNOTSUPP;
 
 	greh->protocol = htons(ETH_P_TEB);
@@ -44,7 +49,7 @@ static int mlx5e_gen_ip_tunnel_header_gretap(char buf[],
 	/* GRE key */
 	hdr_len	= mlx5e_tc_tun_calc_hlen_gretap(e);
 	greh->flags = gre_tnl_flags_to_gre_flags(tun_key->tun_flags);
-	if (tun_key->tun_flags & TUNNEL_KEY) {
+	if (test_bit(IP_TUNNEL_KEY_BIT, tun_key->tun_flags)) {
 		__be32 *ptr = (__be32 *)(((u8 *)greh) + hdr_len - 4);
 		*ptr = tun_id;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index a184d739d5f8..e4e487c8431b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -90,7 +90,7 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	const struct vxlan_metadata *md;
 	struct vxlanhdr *vxh;
 
-	if ((tun_key->tun_flags & TUNNEL_VXLAN_OPT) &&
+	if (test_bit(IP_TUNNEL_VXLAN_OPT_BIT, tun_key->tun_flags) &&
 	    e->tun_info->options_len != sizeof(*md))
 		return -EOPNOTSUPP;
 	vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
@@ -99,7 +99,7 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	udp->dest = tun_key->tp_dst;
 	vxh->vx_flags = VXLAN_HF_VNI;
 	vxh->vx_vni = vxlan_vni_field(tun_id);
-	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT) {
+	if (test_bit(IP_TUNNEL_VXLAN_OPT_BIT, tun_key->tun_flags)) {
 		md = ip_tunnel_info_opts(e->tun_info);
 		vxlan_build_gbp_hdr(vxh, md);
 	}
@@ -125,7 +125,7 @@ static int mlx5e_tc_tun_parse_vxlan_gbp_option(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (enc_opts.key->dst_opt_type != TUNNEL_VXLAN_OPT) {
+	if (enc_opts.key->dst_opt_type != IP_TUNNEL_VXLAN_OPT_BIT) {
 		NL_SET_ERR_MSG_MOD(extack, "Wrong VxLAN option type: not GBP");
 		return -EOPNOTSUPP;
 	}
@@ -208,7 +208,8 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 static bool mlx5e_tc_tun_encap_info_equal_vxlan(struct mlx5e_encap_key *a,
 						struct mlx5e_encap_key *b)
 {
-	return mlx5e_tc_tun_encap_info_equal_options(a, b, TUNNEL_VXLAN_OPT);
+	return mlx5e_tc_tun_encap_info_equal_options(a, b,
+						     IP_TUNNEL_VXLAN_OPT_BIT);
 }
 
 static int mlx5e_tc_tun_get_remote_ifindex(struct net_device *mirred_dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1b0906cb57ef..0aa566686a23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5431,6 +5431,7 @@ static bool mlx5e_tc_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct tunnel_match_enc_opts enc_opts = {};
 	struct mlx5_rep_uplink_priv *uplink_priv;
+	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 	struct mlx5e_rep_priv *uplink_rpriv;
 	struct metadata_dst *tun_dst;
 	struct tunnel_match_key key;
@@ -5438,6 +5439,8 @@ static bool mlx5e_tc_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb
 	struct net_device *dev;
 	int err;
 
+	__set_bit(IP_TUNNEL_KEY_BIT, flags);
+
 	enc_opts_id = tunnel_id & ENC_OPTS_BITS_MASK;
 	tun_id = tunnel_id >> ENC_OPTS_BITS;
 
@@ -5470,14 +5473,14 @@ static bool mlx5e_tc_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb
 	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
 		tun_dst = __ip_tun_set_dst(key.enc_ipv4.src, key.enc_ipv4.dst,
 					   key.enc_ip.tos, key.enc_ip.ttl,
-					   key.enc_tp.dst, TUNNEL_KEY,
+					   key.enc_tp.dst, flags,
 					   key32_to_tunnel_id(key.enc_key_id.keyid),
 					   enc_opts.key.len);
 		break;
 	case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
 		tun_dst = __ipv6_tun_set_dst(&key.enc_ipv6.src, &key.enc_ipv6.dst,
 					     key.enc_ip.tos, key.enc_ip.ttl,
-					     key.enc_tp.dst, 0, TUNNEL_KEY,
+					     key.enc_tp.dst, 0, flags,
 					     key32_to_tunnel_id(key.enc_key_id.keyid),
 					     enc_opts.key.len);
 		break;
@@ -5495,11 +5498,15 @@ static bool mlx5e_tc_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb
 
 	tun_dst->u.tun_info.key.tp_src = key.enc_tp.src;
 
-	if (enc_opts.key.len)
+	if (enc_opts.key.len) {
+		bitmap_zero(flags, __IP_TUNNEL_FLAG_NUM);
+		__set_bit(enc_opts.key.dst_opt_type, flags);
+
 		ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
 					enc_opts.key.data,
 					enc_opts.key.len,
-					enc_opts.key.dst_opt_type);
+					flags);
+	}
 
 	skb_dst_set(skb, (struct dst_entry *)tun_dst);
 	dev = dev_get_by_index(&init_net, key.filter_ifindex);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index d67df358a52f..adc6bd42d4ca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -27,23 +27,23 @@ mlxsw_sp_ipip_netdev_parms6(const struct net_device *ol_dev)
 static bool
 mlxsw_sp_ipip_parms4_has_ikey(const struct ip_tunnel_parm_kern *parms)
 {
-	return !!(parms->i_flags & TUNNEL_KEY);
+	return test_bit(IP_TUNNEL_KEY_BIT, parms->i_flags);
 }
 
 static bool mlxsw_sp_ipip_parms6_has_ikey(const struct __ip6_tnl_parm *parms)
 {
-	return !!(parms->i_flags & TUNNEL_KEY);
+	return test_bit(IP_TUNNEL_KEY_BIT, parms->i_flags);
 }
 
 static bool
 mlxsw_sp_ipip_parms4_has_okey(const struct ip_tunnel_parm_kern *parms)
 {
-	return !!(parms->o_flags & TUNNEL_KEY);
+	return test_bit(IP_TUNNEL_KEY_BIT, parms->o_flags);
 }
 
 static bool mlxsw_sp_ipip_parms6_has_okey(const struct __ip6_tnl_parm *parms)
 {
-	return !!(parms->o_flags & TUNNEL_KEY);
+	return test_bit(IP_TUNNEL_KEY_BIT, parms->o_flags);
 }
 
 static u32 mlxsw_sp_ipip_parms4_ikey(const struct ip_tunnel_parm_kern *parms)
@@ -242,12 +242,18 @@ static bool mlxsw_sp_ipip_can_offload_gre4(const struct mlxsw_sp *mlxsw_sp,
 					   const struct net_device *ol_dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(ol_dev);
-	__be16 okflags = TUNNEL_KEY; /* We can't offload any other features. */
 	bool inherit_ttl = tunnel->parms.iph.ttl == 0;
 	bool inherit_tos = tunnel->parms.iph.tos & 0x1;
+	IP_TUNNEL_DECLARE_FLAGS(okflags) = { };
+	IP_TUNNEL_DECLARE_FLAGS(filter);
 
-	return (tunnel->parms.i_flags & ~okflags) == 0 &&
-	       (tunnel->parms.o_flags & ~okflags) == 0 &&
+	/* We can't offload any other features. */
+	__set_bit(IP_TUNNEL_KEY_BIT, okflags);
+
+	return !bitmap_andnot(filter, tunnel->parms.i_flags, okflags,
+			      __IP_TUNNEL_FLAG_NUM) &&
+	       !bitmap_andnot(filter, tunnel->parms.o_flags, okflags,
+			      __IP_TUNNEL_FLAG_NUM) &&
 	       inherit_ttl && inherit_tos &&
 	       mlxsw_sp_ipip_tunnel_complete(MLXSW_SP_L3_PROTO_IPV4, ol_dev);
 }
@@ -443,10 +449,16 @@ static bool mlxsw_sp_ipip_can_offload_gre6(const struct mlxsw_sp *mlxsw_sp,
 	struct __ip6_tnl_parm tparm = mlxsw_sp_ipip_netdev_parms6(ol_dev);
 	bool inherit_tos = tparm.flags & IP6_TNL_F_USE_ORIG_TCLASS;
 	bool inherit_ttl = tparm.hop_limit == 0;
-	__be16 okflags = TUNNEL_KEY; /* We can't offload any other features. */
+	IP_TUNNEL_DECLARE_FLAGS(okflags) = { };
+	IP_TUNNEL_DECLARE_FLAGS(filter);
+
+	/* We can't offload any other features. */
+	__set_bit(IP_TUNNEL_KEY_BIT, okflags);
 
-	return (tparm.i_flags & ~okflags) == 0 &&
-	       (tparm.o_flags & ~okflags) == 0 &&
+	return !bitmap_andnot(filter, tparm.i_flags, okflags,
+			      __IP_TUNNEL_FLAG_NUM) &&
+	       !bitmap_andnot(filter, tparm.o_flags, okflags,
+			      __IP_TUNNEL_FLAG_NUM) &&
 	       inherit_ttl && inherit_tos &&
 	       mlxsw_sp_ipip_tunnel_complete(MLXSW_SP_L3_PROTO_IPV6, ol_dev);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index ee08184bd60f..a7150de1676d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -461,7 +461,8 @@ mlxsw_sp_span_entry_gretap4_parms(struct mlxsw_sp *mlxsw_sp,
 
 	if (!(to_dev->flags & IFF_UP) ||
 	    /* Reject tunnels with GRE keys, checksums, etc. */
-	    tparm.i_flags || tparm.o_flags ||
+	    !bitmap_empty(tparm.i_flags, __IP_TUNNEL_FLAG_NUM) ||
+	    !bitmap_empty(tparm.o_flags, __IP_TUNNEL_FLAG_NUM) ||
 	    /* Require a fixed TTL and a TOS copied from the mirrored packet. */
 	    inherit_ttl || !inherit_tos ||
 	    /* A destination address may not be "any". */
@@ -565,7 +566,8 @@ mlxsw_sp_span_entry_gretap6_parms(struct mlxsw_sp *mlxsw_sp,
 
 	if (!(to_dev->flags & IFF_UP) ||
 	    /* Reject tunnels with GRE keys, checksums, etc. */
-	    tparm.i_flags || tparm.o_flags ||
+	    !bitmap_empty(tparm.i_flags, __IP_TUNNEL_FLAG_NUM) ||
+	    !bitmap_empty(tparm.o_flags, __IP_TUNNEL_FLAG_NUM) ||
 	    /* Require a fixed TTL and a TOS copied from the mirrored packet. */
 	    inherit_ttl || !inherit_tos ||
 	    /* A destination address may not be "any". */
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 2b383d92d7f5..6516c484aa26 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -396,6 +396,16 @@ nfp_fl_push_geneve_options(struct nfp_fl_payload *nfp_fl, int *list_len,
 	return 0;
 }
 
+#define NFP_FL_CHECK(flag) ({				\
+	IP_TUNNEL_DECLARE_FLAGS(__check) = { };		\
+	__be16 __res;					\
+							\
+	__set_bit(IP_TUNNEL_##flag##_BIT, __check);	\
+	__res = ip_tunnel_flags_to_be16(__check);	\
+	BUILD_BUG_ON(!__builtin_constant_p(__res));	\
+	BUILD_BUG_ON(NFP_FL_TUNNEL_##flag != __res);	\
+})
+
 static int
 nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 	       const struct flow_action_entry *act,
@@ -410,6 +420,7 @@ nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 	u32 tmp_set_ip_tun_type_index = 0;
 	/* Currently support one pre-tunnel so index is always 0. */
 	int pretun_idx = 0;
+	__be16 tun_flags;
 
 	if (!IS_ENABLED(CONFIG_IPV6) && ipv6)
 		return -EOPNOTSUPP;
@@ -417,9 +428,10 @@ nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 	if (ipv6 && !(priv->flower_ext_feats & NFP_FL_FEATS_IPV6_TUN))
 		return -EOPNOTSUPP;
 
-	BUILD_BUG_ON(NFP_FL_TUNNEL_CSUM != TUNNEL_CSUM ||
-		     NFP_FL_TUNNEL_KEY	!= TUNNEL_KEY ||
-		     NFP_FL_TUNNEL_GENEVE_OPT != TUNNEL_GENEVE_OPT);
+	NFP_FL_CHECK(CSUM);
+	NFP_FL_CHECK(GENEVE_OPT);
+	NFP_FL_CHECK(KEY);
+
 	if (ip_tun->options_len &&
 	    (tun_type != NFP_FL_TUNNEL_GENEVE ||
 	    !(priv->flower_ext_feats & NFP_FL_FEATS_GENEVE_OPT))) {
@@ -427,7 +439,9 @@ nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 		return -EOPNOTSUPP;
 	}
 
-	if (ip_tun->key.tun_flags & ~NFP_FL_SUPPORTED_UDP_TUN_FLAGS) {
+	tun_flags = ip_tunnel_flags_to_be16(ip_tun->key.tun_flags);
+	if (!ip_tunnel_flags_is_be16_compat(ip_tun->key.tun_flags) ||
+	    (tun_flags & ~NFP_FL_SUPPORTED_UDP_TUN_FLAGS)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "unsupported offload: loaded firmware does not support tunnel flag offload");
 		return -EOPNOTSUPP;
@@ -442,7 +456,7 @@ nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 		FIELD_PREP(NFP_FL_PRE_TUN_INDEX, pretun_idx);
 
 	set_tun->tun_type_index = cpu_to_be32(tmp_set_ip_tun_type_index);
-	if (ip_tun->key.tun_flags & NFP_FL_TUNNEL_KEY)
+	if (tun_flags & NFP_FL_TUNNEL_KEY)
 		set_tun->tun_id = ip_tun->key.tun_id;
 
 	if (ip_tun->key.ttl) {
@@ -486,7 +500,7 @@ nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 	}
 
 	set_tun->tos = ip_tun->key.tos;
-	set_tun->tun_flags = ip_tun->key.tun_flags;
+	set_tun->tun_flags = tun_flags;
 
 	if (tun_type == NFP_FL_TUNNEL_GENEVE) {
 		set_tun->tun_proto = htons(ETH_P_TEB);
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 78f9d588f712..0fc4b40f1e11 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -225,10 +225,13 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 	void *oiph;
 
 	if (ip_tunnel_collect_metadata() || gs->collect_md) {
-		__be16 flags;
+		IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 
-		flags = TUNNEL_KEY | (gnvh->oam ? TUNNEL_OAM : 0) |
-			(gnvh->critical ? TUNNEL_CRIT_OPT : 0);
+		__set_bit(IP_TUNNEL_KEY_BIT, flags);
+		if (gnvh->oam)
+			__set_bit(IP_TUNNEL_OAM_BIT, flags);
+		if (gnvh->critical)
+			__set_bit(IP_TUNNEL_CRIT_OPT_BIT, flags);
 
 		tun_dst = udp_tun_rx_dst(skb, geneve_get_sk_family(gs), flags,
 					 vni_to_tunnel_id(gnvh->vni),
@@ -238,9 +241,11 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 			goto drop;
 		}
 		/* Update tunnel dst according to Geneve options. */
+		bitmap_zero(flags, __IP_TUNNEL_FLAG_NUM);
+		__set_bit(IP_TUNNEL_GENEVE_OPT_BIT, flags);
 		ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
 					gnvh->options, gnvh->opt_len * 4,
-					TUNNEL_GENEVE_OPT);
+					flags);
 	} else {
 		/* Drop packets w/ critical options,
 		 * since we don't support any...
@@ -738,14 +743,15 @@ static void geneve_build_header(struct genevehdr *geneveh,
 {
 	geneveh->ver = GENEVE_VER;
 	geneveh->opt_len = info->options_len / 4;
-	geneveh->oam = !!(info->key.tun_flags & TUNNEL_OAM);
-	geneveh->critical = !!(info->key.tun_flags & TUNNEL_CRIT_OPT);
+	geneveh->oam = test_bit(IP_TUNNEL_OAM_BIT, info->key.tun_flags);
+	geneveh->critical = test_bit(IP_TUNNEL_CRIT_OPT_BIT,
+				     info->key.tun_flags);
 	geneveh->rsvd1 = 0;
 	tunnel_id_to_vni(info->key.tun_id, geneveh->vni);
 	geneveh->proto_type = inner_proto;
 	geneveh->rsvd2 = 0;
 
-	if (info->key.tun_flags & TUNNEL_GENEVE_OPT)
+	if (test_bit(IP_TUNNEL_GENEVE_OPT_BIT, info->key.tun_flags))
 		ip_tunnel_info_opts_get(geneveh->options, info);
 }
 
@@ -754,7 +760,7 @@ static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
 			    bool xnet, int ip_hdr_len,
 			    bool inner_proto_inherit)
 {
-	bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
+	bool udp_sum = test_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags);
 	struct genevehdr *gnvh;
 	__be16 inner_proto;
 	int min_headroom;
@@ -958,7 +964,8 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		tos = ip_tunnel_ecn_encap(key->tos, ip_hdr(skb), skb);
 		ttl = key->ttl;
 
-		df = key->tun_flags & TUNNEL_DONT_FRAGMENT ? htons(IP_DF) : 0;
+		df = test_bit(IP_TUNNEL_DONT_FRAGMENT_BIT, key->tun_flags) ?
+		     htons(IP_DF) : 0;
 	} else {
 		tos = ip_tunnel_ecn_encap(full_tos, ip_hdr(skb), skb);
 		if (geneve->cfg.ttl_inherit)
@@ -991,7 +998,8 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	udp_tunnel_xmit_skb(rt, gs4->sock->sk, skb, fl4.saddr, fl4.daddr,
 			    tos, ttl, df, sport, geneve->cfg.info.key.tp_dst,
 			    !net_eq(geneve->net, dev_net(geneve->dev)),
-			    !(info->key.tun_flags & TUNNEL_CSUM));
+			    !test_bit(IP_TUNNEL_CSUM_BIT,
+				      info->key.tun_flags));
 	return 0;
 }
 
@@ -1071,7 +1079,8 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	udp_tunnel6_xmit_skb(dst, gs6->sock->sk, skb, dev,
 			     &fl6.saddr, &fl6.daddr, prio, ttl,
 			     info->key.label, sport, geneve->cfg.info.key.tp_dst,
-			     !(info->key.tun_flags & TUNNEL_CSUM));
+			     !test_bit(IP_TUNNEL_CSUM_BIT,
+				       info->key.tun_flags));
 	return 0;
 }
 #endif
@@ -1351,7 +1360,8 @@ static struct geneve_dev *geneve_find_dev(struct geneve_net *gn,
 
 static bool is_tnl_info_zero(const struct ip_tunnel_info *info)
 {
-	return !(info->key.tun_id || info->key.tun_flags || info->key.tos ||
+	return !(info->key.tun_id || info->key.tos ||
+		 !bitmap_empty(info->key.tun_flags, __IP_TUNNEL_FLAG_NUM) ||
 		 info->key.ttl || info->key.label || info->key.tp_src ||
 		 memchr_inv(&info->key.u, 0, sizeof(info->key.u)));
 }
@@ -1489,7 +1499,7 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 					    "Remote IPv6 address cannot be Multicast");
 			return -EINVAL;
 		}
-		info->key.tun_flags |= TUNNEL_CSUM;
+		__set_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags);
 		cfg->use_udp6_rx_checksums = true;
 #else
 		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_GENEVE_REMOTE6],
@@ -1564,7 +1574,7 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 			goto change_notsup;
 		}
 		if (nla_get_u8(data[IFLA_GENEVE_UDP_CSUM]))
-			info->key.tun_flags |= TUNNEL_CSUM;
+			__set_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags);
 	}
 
 	if (data[IFLA_GENEVE_UDP_ZERO_CSUM6_TX]) {
@@ -1574,7 +1584,7 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 			goto change_notsup;
 		}
 		if (nla_get_u8(data[IFLA_GENEVE_UDP_ZERO_CSUM6_TX]))
-			info->key.tun_flags &= ~TUNNEL_CSUM;
+			__clear_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags);
 #else
 		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_GENEVE_UDP_ZERO_CSUM6_TX],
 				    "IPv6 support not enabled in the kernel");
@@ -1807,7 +1817,8 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
 				    info->key.u.ipv4.dst))
 			goto nla_put_failure;
 		if (nla_put_u8(skb, IFLA_GENEVE_UDP_CSUM,
-			       !!(info->key.tun_flags & TUNNEL_CSUM)))
+			       test_bit(IP_TUNNEL_CSUM_BIT,
+					info->key.tun_flags)))
 			goto nla_put_failure;
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1816,7 +1827,8 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
 				     &info->key.u.ipv6.dst))
 			goto nla_put_failure;
 		if (nla_put_u8(skb, IFLA_GENEVE_UDP_ZERO_CSUM6_TX,
-			       !(info->key.tun_flags & TUNNEL_CSUM)))
+			       !test_bit(IP_TUNNEL_CSUM_BIT,
+					 info->key.tun_flags)))
 			goto nla_put_failure;
 #endif
 	}
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 78744549c1b3..1621aed08ebd 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1509,7 +1509,8 @@ static void vxlan_parse_gbp_hdr(struct vxlanhdr *unparsed,
 
 	tun_dst = (struct metadata_dst *)skb_dst(skb);
 	if (tun_dst) {
-		tun_dst->u.tun_info.key.tun_flags |= TUNNEL_VXLAN_OPT;
+		__set_bit(IP_TUNNEL_VXLAN_OPT_BIT,
+			  tun_dst->u.tun_info.key.tun_flags);
 		tun_dst->u.tun_info.options_len = sizeof(*md);
 	}
 	if (gbp->dont_learn)
@@ -1669,9 +1670,11 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 			goto drop;
 
 	if (vxlan_collect_metadata(vs)) {
+		IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 		struct metadata_dst *tun_dst;
 
-		tun_dst = udp_tun_rx_dst(skb, vxlan_get_sk_family(vs), TUNNEL_KEY,
+		__set_bit(IP_TUNNEL_KEY_BIT, flags);
+		tun_dst = udp_tun_rx_dst(skb, vxlan_get_sk_family(vs), flags,
 					 key32_to_tunnel_id(vni), sizeof(*md));
 
 		if (!tun_dst)
@@ -2459,7 +2462,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		vni = tunnel_id_to_key32(info->key.tun_id);
 		ifindex = 0;
 		dst_cache = &info->dst_cache;
-		if (info->key.tun_flags & TUNNEL_VXLAN_OPT) {
+		if (test_bit(IP_TUNNEL_VXLAN_OPT_BIT, info->key.tun_flags)) {
 			if (info->options_len < sizeof(*md))
 				goto drop;
 			md = ip_tunnel_info_opts(info);
@@ -2469,7 +2472,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 #if IS_ENABLED(CONFIG_IPV6)
 		label = info->key.label;
 #endif
-		udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
+		udp_sum = test_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags);
 	}
 	src_port = udp_flow_src_port(dev_net(dev), skb, vxlan->cfg.port_min,
 				     vxlan->cfg.port_max, true);
@@ -2511,7 +2514,8 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 				     old_iph->frag_off & htons(IP_DF)))
 					df = htons(IP_DF);
 			}
-		} else if (info->key.tun_flags & TUNNEL_DONT_FRAGMENT) {
+		} else if (test_bit(IP_TUNNEL_DONT_FRAGMENT_BIT,
+				    info->key.tun_flags)) {
 			df = htons(IP_DF);
 		}
 
diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 1b7fae4c6b24..d020fd37bcbc 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -198,7 +198,7 @@ static inline struct metadata_dst *__ip_tun_set_dst(__be32 saddr,
 						    __be32 daddr,
 						    __u8 tos, __u8 ttl,
 						    __be16 tp_dst,
-						    __be16 flags,
+						    const unsigned long *flags,
 						    __be64 tunnel_id,
 						    int md_size)
 {
@@ -215,7 +215,7 @@ static inline struct metadata_dst *__ip_tun_set_dst(__be32 saddr,
 }
 
 static inline struct metadata_dst *ip_tun_rx_dst(struct sk_buff *skb,
-						 __be16 flags,
+						 const unsigned long *flags,
 						 __be64 tunnel_id,
 						 int md_size)
 {
@@ -230,7 +230,7 @@ static inline struct metadata_dst *__ipv6_tun_set_dst(const struct in6_addr *sad
 						      __u8 tos, __u8 ttl,
 						      __be16 tp_dst,
 						      __be32 label,
-						      __be16 flags,
+						      const unsigned long *flags,
 						      __be64 tunnel_id,
 						      int md_size)
 {
@@ -243,7 +243,7 @@ static inline struct metadata_dst *__ipv6_tun_set_dst(const struct in6_addr *sad
 
 	info = &tun_dst->u.tun_info;
 	info->mode = IP_TUNNEL_INFO_IPV6;
-	info->key.tun_flags = flags;
+	bitmap_copy(info->key.tun_flags, flags, __IP_TUNNEL_FLAG_NUM);
 	info->key.tun_id = tunnel_id;
 	info->key.tp_src = 0;
 	info->key.tp_dst = tp_dst;
@@ -259,7 +259,7 @@ static inline struct metadata_dst *__ipv6_tun_set_dst(const struct in6_addr *sad
 }
 
 static inline struct metadata_dst *ipv6_tun_rx_dst(struct sk_buff *skb,
-						   __be16 flags,
+						   const unsigned long *flags,
 						   __be64 tunnel_id,
 						   int md_size)
 {
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 8b41668c77fc..65cf51a456b6 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -97,7 +97,7 @@ struct flow_dissector_key_enc_opts {
 					 * here but seems difficult to #include
 					 */
 	u8 len;
-	__be16 dst_opt_type;
+	u32 dst_opt_type;
 };
 
 struct flow_dissector_key_keyid {
diff --git a/include/net/gre.h b/include/net/gre.h
index 4e209708b754..46fbde2aea86 100644
--- a/include/net/gre.h
+++ b/include/net/gre.h
@@ -49,67 +49,66 @@ static inline bool netif_is_ip6gretap(const struct net_device *dev)
 	       !strcmp(dev->rtnl_link_ops->kind, "ip6gretap");
 }
 
-static inline int gre_calc_hlen(__be16 o_flags)
+static inline int gre_calc_hlen(const unsigned long *o_flags)
 {
 	int addend = 4;
 
-	if (o_flags & TUNNEL_CSUM)
+	if (test_bit(IP_TUNNEL_CSUM_BIT, o_flags))
 		addend += 4;
-	if (o_flags & TUNNEL_KEY)
+	if (test_bit(IP_TUNNEL_KEY_BIT, o_flags))
 		addend += 4;
-	if (o_flags & TUNNEL_SEQ)
+	if (test_bit(IP_TUNNEL_SEQ_BIT, o_flags))
 		addend += 4;
 	return addend;
 }
 
-static inline __be16 gre_flags_to_tnl_flags(__be16 flags)
+static inline void gre_flags_to_tnl_flags(unsigned long *dst, __be16 flags)
 {
-	__be16 tflags = 0;
+	bitmap_zero(dst, __IP_TUNNEL_FLAG_NUM);
 
 	if (flags & GRE_CSUM)
-		tflags |= TUNNEL_CSUM;
+		__set_bit(IP_TUNNEL_CSUM_BIT, dst);
 	if (flags & GRE_ROUTING)
-		tflags |= TUNNEL_ROUTING;
+		__set_bit(IP_TUNNEL_ROUTING_BIT, dst);
 	if (flags & GRE_KEY)
-		tflags |= TUNNEL_KEY;
+		__set_bit(IP_TUNNEL_KEY_BIT, dst);
 	if (flags & GRE_SEQ)
-		tflags |= TUNNEL_SEQ;
+		__set_bit(IP_TUNNEL_SEQ_BIT, dst);
 	if (flags & GRE_STRICT)
-		tflags |= TUNNEL_STRICT;
+		__set_bit(IP_TUNNEL_STRICT_BIT, dst);
 	if (flags & GRE_REC)
-		tflags |= TUNNEL_REC;
+		__set_bit(IP_TUNNEL_REC_BIT, dst);
 	if (flags & GRE_VERSION)
-		tflags |= TUNNEL_VERSION;
-
-	return tflags;
+		__set_bit(IP_TUNNEL_VERSION_BIT, dst);
 }
 
-static inline __be16 gre_tnl_flags_to_gre_flags(__be16 tflags)
+static inline __be16 gre_tnl_flags_to_gre_flags(const unsigned long *tflags)
 {
 	__be16 flags = 0;
 
-	if (tflags & TUNNEL_CSUM)
+	if (test_bit(IP_TUNNEL_CSUM_BIT, tflags))
 		flags |= GRE_CSUM;
-	if (tflags & TUNNEL_ROUTING)
+	if (test_bit(IP_TUNNEL_ROUTING_BIT, tflags))
 		flags |= GRE_ROUTING;
-	if (tflags & TUNNEL_KEY)
+	if (test_bit(IP_TUNNEL_KEY_BIT, tflags))
 		flags |= GRE_KEY;
-	if (tflags & TUNNEL_SEQ)
+	if (test_bit(IP_TUNNEL_SEQ_BIT, tflags))
 		flags |= GRE_SEQ;
-	if (tflags & TUNNEL_STRICT)
+	if (test_bit(IP_TUNNEL_STRICT_BIT, tflags))
 		flags |= GRE_STRICT;
-	if (tflags & TUNNEL_REC)
+	if (test_bit(IP_TUNNEL_REC_BIT, tflags))
 		flags |= GRE_REC;
-	if (tflags & TUNNEL_VERSION)
+	if (test_bit(IP_TUNNEL_VERSION_BIT, tflags))
 		flags |= GRE_VERSION;
 
 	return flags;
 }
 
 static inline void gre_build_header(struct sk_buff *skb, int hdr_len,
-				    __be16 flags, __be16 proto,
+				    const unsigned long *flags, __be16 proto,
 				    __be32 key, __be32 seq)
 {
+	IP_TUNNEL_DECLARE_FLAGS(cond) = { };
 	struct gre_base_hdr *greh;
 
 	skb_push(skb, hdr_len);
@@ -120,18 +119,22 @@ static inline void gre_build_header(struct sk_buff *skb, int hdr_len,
 	greh->flags = gre_tnl_flags_to_gre_flags(flags);
 	greh->protocol = proto;
 
-	if (flags & (TUNNEL_KEY | TUNNEL_CSUM | TUNNEL_SEQ)) {
+	__set_bit(IP_TUNNEL_KEY_BIT, cond);
+	__set_bit(IP_TUNNEL_CSUM_BIT, cond);
+	__set_bit(IP_TUNNEL_SEQ_BIT, cond);
+
+	if (bitmap_and(cond, flags, cond, __IP_TUNNEL_FLAG_NUM)) {
 		__be32 *ptr = (__be32 *)(((u8 *)greh) + hdr_len - 4);
 
-		if (flags & TUNNEL_SEQ) {
+		if (test_bit(IP_TUNNEL_SEQ_BIT, flags)) {
 			*ptr = seq;
 			ptr--;
 		}
-		if (flags & TUNNEL_KEY) {
+		if (test_bit(IP_TUNNEL_KEY_BIT, flags)) {
 			*ptr = key;
 			ptr--;
 		}
-		if (flags & TUNNEL_CSUM &&
+		if (test_bit(IP_TUNNEL_CSUM_BIT, flags) &&
 		    !(skb_shinfo(skb)->gso_type &
 		      (SKB_GSO_GRE | SKB_GSO_GRE_CSUM))) {
 			*ptr = 0;
diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 74b369bddf49..399592405c72 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -30,8 +30,8 @@ struct __ip6_tnl_parm {
 	struct in6_addr laddr;	/* local tunnel end-point address */
 	struct in6_addr raddr;	/* remote tunnel end-point address */
 
-	__be16			i_flags;
-	__be16			o_flags;
+	IP_TUNNEL_DECLARE_FLAGS(i_flags);
+	IP_TUNNEL_DECLARE_FLAGS(o_flags);
 	__be32			i_key;
 	__be32			o_key;
 
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 0ff44ff3b940..7113ed79617d 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -36,6 +36,9 @@
 	(sizeof_field(struct ip_tunnel_key, u) -		\
 	 sizeof_field(struct ip_tunnel_key, u.ipv4))
 
+#define IP_TUNNEL_DECLARE_FLAGS(name)				\
+	DECLARE_BITMAP(name, __IP_TUNNEL_FLAG_NUM)
+
 struct ip_tunnel_key {
 	__be64			tun_id;
 	union {
@@ -48,10 +51,10 @@ struct ip_tunnel_key {
 			struct in6_addr dst;
 		} ipv6;
 	} u;
-	__be16			tun_flags;
+	IP_TUNNEL_DECLARE_FLAGS(tun_flags);
+	__be32			label;		/* Flow Label for IPv6 */
 	u8			tos;		/* TOS for IPv4, TC for IPv6 */
 	u8			ttl;		/* TTL for IPv4, HL for IPv6 */
-	__be32			label;		/* Flow Label for IPv6 */
 	__be16			tp_src;
 	__be16			tp_dst;
 	__u8			flow_flags;
@@ -109,14 +112,14 @@ struct ip_tunnel_prl_entry {
 
 struct metadata_dst;
 
-/* Kernel-side copy of ip_tunnel_parm */
+/* Kernel-side variant of ip_tunnel_parm */
 struct ip_tunnel_parm_kern {
 	char			name[IFNAMSIZ];
-	int			link;
-	__be16			i_flags;
-	__be16			o_flags;
+	IP_TUNNEL_DECLARE_FLAGS(i_flags);
+	IP_TUNNEL_DECLARE_FLAGS(o_flags);
 	__be32			i_key;
 	__be32			o_key;
+	int			link;
 	struct iphdr		iph;
 };
 
@@ -167,7 +170,7 @@ struct ip_tunnel {
 };
 
 struct tnl_ptk_info {
-	__be16 flags;
+	IP_TUNNEL_DECLARE_FLAGS(flags);
 	__be16 proto;
 	__be32 key;
 	__be32 seq;
@@ -189,11 +192,69 @@ struct ip_tunnel_net {
 	int type;
 };
 
+static inline void ip_tunnel_set_options_present(unsigned long *flags)
+{
+	__set_bit(IP_TUNNEL_GENEVE_OPT_BIT, flags);
+	__set_bit(IP_TUNNEL_VXLAN_OPT_BIT, flags);
+	__set_bit(IP_TUNNEL_ERSPAN_OPT_BIT, flags);
+	__set_bit(IP_TUNNEL_GTP_OPT_BIT, flags);
+}
+
+static inline void ip_tunnel_clear_options_present(unsigned long *flags)
+{
+	__clear_bit(IP_TUNNEL_GENEVE_OPT_BIT, flags);
+	__clear_bit(IP_TUNNEL_VXLAN_OPT_BIT, flags);
+	__clear_bit(IP_TUNNEL_ERSPAN_OPT_BIT, flags);
+	__clear_bit(IP_TUNNEL_GTP_OPT_BIT, flags);
+}
+
+static inline bool ip_tunnel_is_options_present(const unsigned long *flags)
+{
+	IP_TUNNEL_DECLARE_FLAGS(test_flags) = { };
+
+	ip_tunnel_set_options_present(test_flags);
+
+	return bitmap_and(test_flags, flags, test_flags, __IP_TUNNEL_FLAG_NUM);
+}
+
+static inline bool ip_tunnel_flags_is_be16_compat(const unsigned long *flags)
+{
+	IP_TUNNEL_DECLARE_FLAGS(supp) = { };
+
+	bitmap_set(supp, 0, BITS_PER_TYPE(__be16));
+	__set_bit(IP_TUNNEL_VTI_BIT, supp);
+
+	return !bitmap_andnot(supp, flags, supp, __IP_TUNNEL_FLAG_NUM);
+}
+
+static inline void ip_tunnel_flags_from_be16(unsigned long *dst, __be16 flags)
+{
+	bitmap_zero(dst, __IP_TUNNEL_FLAG_NUM);
+
+	*dst = be16_to_cpu(flags);
+
+	if (flags & VTI_ISVTI)
+		__set_bit(IP_TUNNEL_VTI_BIT, dst);
+}
+
+static inline __be16 ip_tunnel_flags_to_be16(const unsigned long *flags)
+{
+	__be16 ret;
+
+	ret = cpu_to_be16(*flags & U16_MAX);
+
+	if (test_bit(IP_TUNNEL_VTI_BIT, flags))
+		ret |= VTI_ISVTI;
+
+	return ret;
+}
+
 static inline void ip_tunnel_key_init(struct ip_tunnel_key *key,
 				      __be32 saddr, __be32 daddr,
 				      u8 tos, u8 ttl, __be32 label,
 				      __be16 tp_src, __be16 tp_dst,
-				      __be64 tun_id, __be16 tun_flags)
+				      __be64 tun_id,
+				      const unsigned long *tun_flags)
 {
 	key->tun_id = tun_id;
 	key->u.ipv4.src = saddr;
@@ -203,7 +264,7 @@ static inline void ip_tunnel_key_init(struct ip_tunnel_key *key,
 	key->tos = tos;
 	key->ttl = ttl;
 	key->label = label;
-	key->tun_flags = tun_flags;
+	bitmap_copy(key->tun_flags, tun_flags, __IP_TUNNEL_FLAG_NUM);
 
 	/* For the tunnel types on the top of IPsec, the tp_src and tp_dst of
 	 * the upper tunnel are used.
@@ -226,7 +287,7 @@ ip_tunnel_dst_cache_usable(const struct sk_buff *skb,
 		return false;
 	if (!info)
 		return true;
-	if (info->key.tun_flags & TUNNEL_NOCACHE)
+	if (test_bit(IP_TUNNEL_NOCACHE_BIT, info->key.tun_flags))
 		return false;
 
 	return true;
@@ -308,7 +369,7 @@ int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict);
 int ip_tunnel_change_mtu(struct net_device *dev, int new_mtu);
 
 struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
-				   int link, __be16 flags,
+				   int link, const unsigned long *flags,
 				   __be32 remote, __be32 local,
 				   __be32 key);
 
@@ -514,12 +575,13 @@ static inline void ip_tunnel_info_opts_get(void *to,
 
 static inline void ip_tunnel_info_opts_set(struct ip_tunnel_info *info,
 					   const void *from, int len,
-					   __be16 flags)
+					   const unsigned long *flags)
 {
 	info->options_len = len;
 	if (len > 0) {
 		memcpy(ip_tunnel_info_opts(info), from, len);
-		info->key.tun_flags |= flags;
+		bitmap_or(info->key.tun_flags, info->key.tun_flags, flags,
+			  __IP_TUNNEL_FLAG_NUM);
 	}
 }
 
@@ -563,7 +625,7 @@ static inline void ip_tunnel_info_opts_get(void *to,
 
 static inline void ip_tunnel_info_opts_set(struct ip_tunnel_info *info,
 					   const void *from, int len,
-					   __be16 flags)
+					   const unsigned long *flags)
 {
 	info->options_len = 0;
 }
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 0ca9b7a11baf..ff41b18651c4 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -162,8 +162,8 @@ int udp_tunnel6_xmit_skb(struct dst_entry *dst, struct sock *sk,
 void udp_tunnel_sock_release(struct socket *sock);
 
 struct metadata_dst *udp_tun_rx_dst(struct sk_buff *skb, unsigned short family,
-				    __be16 flags, __be64 tunnel_id,
-				    int md_size);
+				    const unsigned long *flags,
+				    __be64 tunnel_id, int md_size);
 
 #ifdef CONFIG_INET
 static inline int udp_tunnel_handle_offloads(struct sk_buff *skb, bool udp_csum)
diff --git a/include/uapi/linux/if_tunnel.h b/include/uapi/linux/if_tunnel.h
index 102119628ff5..d222e70d8621 100644
--- a/include/uapi/linux/if_tunnel.h
+++ b/include/uapi/linux/if_tunnel.h
@@ -161,6 +161,14 @@ enum {
 
 #define IFLA_VTI_MAX	(__IFLA_VTI_MAX - 1)
 
+#ifndef __KERNEL__
+/* Historically, tunnel flags have been defined as __be16 and now there are
+ * no free bits left. It is strongly advised to switch the already existing
+ * userspace code to u32/BIGINT and the new *_BIT definitions from down below,
+ * as __be16 can't be simply casted to a wider type on LE systems. All new
+ * flags and code must use *_BIT only.
+ */
+
 #define TUNNEL_CSUM		__cpu_to_be16(0x01)
 #define TUNNEL_ROUTING		__cpu_to_be16(0x02)
 #define TUNNEL_KEY		__cpu_to_be16(0x04)
@@ -181,5 +189,30 @@ enum {
 #define TUNNEL_OPTIONS_PRESENT \
 		(TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT | \
 		TUNNEL_GTP_OPT)
+#endif
+
+enum {
+	IP_TUNNEL_CSUM_BIT		= 0U,
+	IP_TUNNEL_ROUTING_BIT		= 1U,
+	IP_TUNNEL_KEY_BIT		= 2U,
+	IP_TUNNEL_SEQ_BIT		= 3U,
+	IP_TUNNEL_STRICT_BIT		= 4U,
+	IP_TUNNEL_REC_BIT		= 5U,
+	IP_TUNNEL_VERSION_BIT		= 6U,
+	IP_TUNNEL_NO_KEY_BIT		= 7U,
+	IP_TUNNEL_DONT_FRAGMENT_BIT	= 8U,
+	IP_TUNNEL_OAM_BIT		= 9U,
+	IP_TUNNEL_CRIT_OPT_BIT		= 10U,
+	IP_TUNNEL_GENEVE_OPT_BIT	= 11U,		/* OPTIONS_PRESENT */
+	IP_TUNNEL_VXLAN_OPT_BIT		= 12U,		/* OPTIONS_PRESENT */
+	IP_TUNNEL_NOCACHE_BIT		= 13U,
+	IP_TUNNEL_ERSPAN_OPT_BIT	= 14U,		/* OPTIONS_PRESENT */
+	IP_TUNNEL_GTP_OPT_BIT		= 15U,		/* OPTIONS_PRESENT */
+
+	IP_TUNNEL_VTI_BIT		= 16U,
+	IP_TUNNEL_SIT_ISATAP_BIT	= IP_TUNNEL_VTI_BIT,
+
+	__IP_TUNNEL_FLAG_NUM,
+};
 
 #endif /* _UAPI_IF_TUNNEL_H_ */
diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index 6399a8a69d07..cff57ab51e73 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -65,12 +65,15 @@ static int __vlan_tunnel_info_add(struct net_bridge_vlan_group *vg,
 {
 	struct metadata_dst *metadata = rtnl_dereference(vlan->tinfo.tunnel_dst);
 	__be64 key = key32_to_tunnel_id(cpu_to_be32(tun_id));
+	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 	int err;
 
 	if (metadata)
 		return -EEXIST;
 
-	metadata = __ip_tun_set_dst(0, 0, 0, 0, 0, TUNNEL_KEY,
+	__set_bit(IP_TUNNEL_KEY_BIT, flags);
+
+	metadata = __ip_tun_set_dst(0, 0, 0, 0, 0, flags,
 				    key, 0);
 	if (!metadata)
 		return -EINVAL;
diff --git a/net/core/filter.c b/net/core/filter.c
index 968139f4a1ac..58edf819effc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4593,7 +4593,7 @@ BPF_CALL_4(bpf_skb_get_tunnel_key, struct sk_buff *, skb, struct bpf_tunnel_key
 	to->tunnel_tos = info->key.tos;
 	to->tunnel_ttl = info->key.ttl;
 	if (flags & BPF_F_TUNINFO_FLAGS)
-		to->tunnel_flags = info->key.tun_flags;
+		to->tunnel_flags = ip_tunnel_flags_to_be16(info->key.tun_flags);
 	else
 		to->tunnel_ext = 0;
 
@@ -4636,7 +4636,7 @@ BPF_CALL_3(bpf_skb_get_tunnel_opt, struct sk_buff *, skb, u8 *, to, u32, size)
 	int err;
 
 	if (unlikely(!info ||
-		     !(info->key.tun_flags & TUNNEL_OPTIONS_PRESENT))) {
+		     !ip_tunnel_is_options_present(info->key.tun_flags))) {
 		err = -ENOENT;
 		goto err_clear;
 	}
@@ -4706,15 +4706,17 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *, skb,
 	memset(info, 0, sizeof(*info));
 	info->mode = IP_TUNNEL_INFO_TX;
 
-	info->key.tun_flags = TUNNEL_KEY | TUNNEL_CSUM | TUNNEL_NOCACHE;
+	__set_bit(IP_TUNNEL_KEY_BIT, info->key.tun_flags);
+	__set_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags);
+	__set_bit(IP_TUNNEL_NOCACHE_BIT, info->key.tun_flags);
 	if (flags & BPF_F_DONT_FRAGMENT)
-		info->key.tun_flags |= TUNNEL_DONT_FRAGMENT;
+		__set_bit(IP_TUNNEL_DONT_FRAGMENT_BIT, info->key.tun_flags);
 	if (flags & BPF_F_ZERO_CSUM_TX)
-		info->key.tun_flags &= ~TUNNEL_CSUM;
+		__clear_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags);
 	if (flags & BPF_F_SEQ_NUMBER)
-		info->key.tun_flags |= TUNNEL_SEQ;
+		__set_bit(IP_TUNNEL_SEQ_BIT, info->key.tun_flags);
 	if (flags & BPF_F_NO_TUNNEL_KEY)
-		info->key.tun_flags &= ~TUNNEL_KEY;
+		__clear_bit(IP_TUNNEL_KEY_BIT, info->key.tun_flags);
 
 	info->key.tun_id = cpu_to_be64(from->tunnel_id);
 	info->key.tos = from->tunnel_tos;
@@ -4752,13 +4754,15 @@ BPF_CALL_3(bpf_skb_set_tunnel_opt, struct sk_buff *, skb,
 {
 	struct ip_tunnel_info *info = skb_tunnel_info(skb);
 	const struct metadata_dst *md = this_cpu_ptr(md_dst);
+	IP_TUNNEL_DECLARE_FLAGS(present) = { };
 
 	if (unlikely(info != &md->u.tun_info || (size & (sizeof(u32) - 1))))
 		return -EINVAL;
 	if (unlikely(size > IP_TUNNEL_OPTS_MAX))
 		return -ENOMEM;
 
-	ip_tunnel_info_opts_set(info, from, size, TUNNEL_OPTIONS_PRESENT);
+	ip_tunnel_set_options_present(present);
+	ip_tunnel_info_opts_set(info, from, size, present);
 
 	return 0;
 }
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 481ca4080cbd..fb78df0e11d3 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -417,10 +417,18 @@ skb_flow_dissect_tunnel_info(const struct sk_buff *skb,
 						    target_container);
 
 		if (info->options_len) {
+			IP_TUNNEL_DECLARE_FLAGS(flags) = { };
+			u32 val;
+
 			enc_opt->len = info->options_len;
 			ip_tunnel_info_opts_get(enc_opt->data, info);
-			enc_opt->dst_opt_type = info->key.tun_flags &
-						TUNNEL_OPTIONS_PRESENT;
+
+			ip_tunnel_set_options_present(flags);
+			bitmap_and(flags, info->key.tun_flags, flags,
+				   __IP_TUNNEL_FLAG_NUM);
+
+			val = find_next_bit(flags, __IP_TUNNEL_FLAG_NUM, 0);
+			enc_opt->dst_opt_type = val;
 		}
 	}
 }
diff --git a/net/ipv4/fou_bpf.c b/net/ipv4/fou_bpf.c
index 3760a14b6b57..219554388921 100644
--- a/net/ipv4/fou_bpf.c
+++ b/net/ipv4/fou_bpf.c
@@ -66,7 +66,7 @@ __bpf_kfunc int bpf_skb_set_fou_encap(struct __sk_buff *skb_ctx,
 		info->encap.type = TUNNEL_ENCAP_NONE;
 	}
 
-	if (info->key.tun_flags & TUNNEL_CSUM)
+	if (test_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags))
 		info->encap.flags |= TUNNEL_ENCAP_FLAG_CSUM;
 
 	info->encap.sport = encap->sport;
diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
index cbb2b4bb0dfa..01765891f82b 100644
--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -73,7 +73,7 @@ int gre_parse_header(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 	if (unlikely(greh->flags & (GRE_VERSION | GRE_ROUTING)))
 		return -EINVAL;
 
-	tpi->flags = gre_flags_to_tnl_flags(greh->flags);
+	gre_flags_to_tnl_flags(tpi->flags, greh->flags);
 	hdr_len = gre_calc_hlen(tpi->flags);
 
 	if (!pskb_may_pull(skb, nhs + hdr_len))
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 22aa5faa1f8b..451560241074 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -265,6 +265,7 @@ static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 	struct net *net = dev_net(skb->dev);
 	struct metadata_dst *tun_dst = NULL;
 	struct erspan_base_hdr *ershdr;
+	IP_TUNNEL_DECLARE_FLAGS(flags);
 	struct ip_tunnel_net *itn;
 	struct ip_tunnel *tunnel;
 	const struct iphdr *iph;
@@ -272,18 +273,20 @@ static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 	int ver;
 	int len;
 
+	bitmap_copy(flags, tpi->flags, __IP_TUNNEL_FLAG_NUM);
+
 	itn = net_generic(net, erspan_net_id);
 	iph = ip_hdr(skb);
 	if (is_erspan_type1(gre_hdr_len)) {
 		ver = 0;
-		tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
-					  tpi->flags | TUNNEL_NO_KEY,
+		__set_bit(IP_TUNNEL_NO_KEY_BIT, flags);
+		tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, flags,
 					  iph->saddr, iph->daddr, 0);
 	} else {
 		ershdr = (struct erspan_base_hdr *)(skb->data + gre_hdr_len);
 		ver = ershdr->ver;
-		tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
-					  tpi->flags | TUNNEL_KEY,
+		__set_bit(IP_TUNNEL_KEY_BIT, flags);
+		tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, flags,
 					  iph->saddr, iph->daddr, tpi->key);
 	}
 
@@ -307,10 +310,9 @@ static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 			struct ip_tunnel_info *info;
 			unsigned char *gh;
 			__be64 tun_id;
-			__be16 flags;
 
-			tpi->flags |= TUNNEL_KEY;
-			flags = tpi->flags;
+			__set_bit(IP_TUNNEL_KEY_BIT, tpi->flags);
+			bitmap_copy(flags, tpi->flags, __IP_TUNNEL_FLAG_NUM);
 			tun_id = key32_to_tunnel_id(tpi->key);
 
 			tun_dst = ip_tun_rx_dst(skb, flags,
@@ -333,7 +335,8 @@ static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 						       ERSPAN_V2_MDSIZE);
 
 			info = &tun_dst->u.tun_info;
-			info->key.tun_flags |= TUNNEL_ERSPAN_OPT;
+			__set_bit(IP_TUNNEL_ERSPAN_OPT_BIT,
+				  info->key.tun_flags);
 			info->options_len = sizeof(*md);
 		}
 
@@ -376,10 +379,14 @@ static int __ipgre_rcv(struct sk_buff *skb, const struct tnl_ptk_info *tpi,
 
 		tnl_params = &tunnel->parms.iph;
 		if (tunnel->collect_md || tnl_params->daddr == 0) {
-			__be16 flags;
+			IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 			__be64 tun_id;
 
-			flags = tpi->flags & (TUNNEL_CSUM | TUNNEL_KEY);
+			__set_bit(IP_TUNNEL_CSUM_BIT, flags);
+			__set_bit(IP_TUNNEL_KEY_BIT, flags);
+			bitmap_and(flags, tpi->flags, flags,
+				   __IP_TUNNEL_FLAG_NUM);
+
 			tun_id = key32_to_tunnel_id(tpi->key);
 			tun_dst = ip_tun_rx_dst(skb, flags, tun_id, 0);
 			if (!tun_dst)
@@ -459,12 +466,15 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 		       __be16 proto)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
-	__be16 flags = tunnel->parms.o_flags;
+	IP_TUNNEL_DECLARE_FLAGS(flags);
+
+	bitmap_copy(flags, tunnel->parms.o_flags, __IP_TUNNEL_FLAG_NUM);
 
 	/* Push GRE header. */
 	gre_build_header(skb, tunnel->tun_hlen,
 			 flags, proto, tunnel->parms.o_key,
-			 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
+			 test_bit(IP_TUNNEL_SEQ_BIT, flags) ?
+			 htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
 
 	ip_tunnel_xmit(skb, dev, tnl_params, tnl_params->protocol);
 }
@@ -478,10 +488,10 @@ static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
 			__be16 proto)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
+	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 	struct ip_tunnel_info *tun_info;
 	const struct ip_tunnel_key *key;
 	int tunnel_hlen;
-	__be16 flags;
 
 	tun_info = skb_tunnel_info(skb);
 	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
@@ -495,14 +505,20 @@ static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
 		goto err_free_skb;
 
 	/* Push Tunnel header. */
-	if (gre_handle_offloads(skb, !!(tun_info->key.tun_flags & TUNNEL_CSUM)))
+	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT,
+					      tunnel->parms.o_flags)))
 		goto err_free_skb;
 
-	flags = tun_info->key.tun_flags &
-		(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
+	__set_bit(IP_TUNNEL_CSUM_BIT, flags);
+	__set_bit(IP_TUNNEL_KEY_BIT, flags);
+	__set_bit(IP_TUNNEL_SEQ_BIT, flags);
+	bitmap_and(flags, tun_info->key.tun_flags, flags,
+		   __IP_TUNNEL_FLAG_NUM);
+
 	gre_build_header(skb, tunnel_hlen, flags, proto,
 			 tunnel_id_to_key32(tun_info->key.tun_id),
-			 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
+			 test_bit(IP_TUNNEL_SEQ_BIT, flags) ?
+			 htonl(atomic_fetch_inc(&tunnel->o_seqno)) : 0);
 
 	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, tunnel_hlen);
 
@@ -516,6 +532,7 @@ static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
 static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
+	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 	struct ip_tunnel_info *tun_info;
 	const struct ip_tunnel_key *key;
 	struct erspan_metadata *md;
@@ -531,7 +548,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto err_free_skb;
 
 	key = &tun_info->key;
-	if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
+	if (!test_bit(IP_TUNNEL_ERSPAN_OPT_BIT, tun_info->key.tun_flags))
 		goto err_free_skb;
 	if (tun_info->options_len < sizeof(*md))
 		goto err_free_skb;
@@ -583,8 +600,9 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto err_free_skb;
 	}
 
-	gre_build_header(skb, 8, TUNNEL_SEQ,
-			 proto, 0, htonl(atomic_fetch_inc(&tunnel->o_seqno)));
+	__set_bit(IP_TUNNEL_SEQ_BIT, flags);
+	gre_build_header(skb, 8, flags, proto, 0,
+			 htonl(atomic_fetch_inc(&tunnel->o_seqno)));
 
 	ip_md_tunnel_xmit(skb, dev, IPPROTO_GRE, tunnel_hlen);
 
@@ -655,7 +673,8 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 		tnl_params = &tunnel->parms.iph;
 	}
 
-	if (gre_handle_offloads(skb, !!(tunnel->parms.o_flags & TUNNEL_CSUM)))
+	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT,
+					      tunnel->parms.o_flags)))
 		goto free_skb;
 
 	__gre_xmit(skb, dev, tnl_params, skb->protocol);
@@ -696,7 +715,7 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
 	/* Push ERSPAN header */
 	if (tunnel->erspan_ver == 0) {
 		proto = htons(ETH_P_ERSPAN);
-		tunnel->parms.o_flags &= ~TUNNEL_SEQ;
+		__clear_bit(IP_TUNNEL_SEQ_BIT, tunnel->parms.o_flags);
 	} else if (tunnel->erspan_ver == 1) {
 		erspan_build_header(skb, ntohl(tunnel->parms.o_key),
 				    tunnel->index,
@@ -711,7 +730,7 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
 		goto free_skb;
 	}
 
-	tunnel->parms.o_flags &= ~TUNNEL_KEY;
+	__clear_bit(IP_TUNNEL_KEY_BIT, tunnel->parms.o_flags);
 	__gre_xmit(skb, dev, &tunnel->parms.iph, proto);
 	return NETDEV_TX_OK;
 
@@ -734,7 +753,8 @@ static netdev_tx_t gre_tap_xmit(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
-	if (gre_handle_offloads(skb, !!(tunnel->parms.o_flags & TUNNEL_CSUM)))
+	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT,
+					      tunnel->parms.o_flags)))
 		goto free_skb;
 
 	if (skb_cow_head(skb, dev->needed_headroom))
@@ -752,7 +772,6 @@ static netdev_tx_t gre_tap_xmit(struct sk_buff *skb,
 static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
-	__be16 flags;
 	int len;
 
 	len = tunnel->tun_hlen;
@@ -768,10 +787,9 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 	if (set_mtu)
 		dev->mtu = max_t(int, dev->mtu - len, 68);
 
-	flags = tunnel->parms.o_flags;
-
-	if (flags & TUNNEL_SEQ ||
-	    (flags & TUNNEL_CSUM && tunnel->encap.type != TUNNEL_ENCAP_NONE)) {
+	if (test_bit(IP_TUNNEL_SEQ_BIT, tunnel->parms.o_flags) ||
+	    (test_bit(IP_TUNNEL_CSUM_BIT, tunnel->parms.o_flags) &&
+	     tunnel->encap.type != TUNNEL_ENCAP_NONE)) {
 		dev->features &= ~NETIF_F_GSO_SOFTWARE;
 		dev->hw_features &= ~NETIF_F_GSO_SOFTWARE;
 	} else {
@@ -784,17 +802,25 @@ static int ipgre_tunnel_ctl(struct net_device *dev,
 			    struct ip_tunnel_parm_kern *p,
 			    int cmd)
 {
+	__be16 i_flags, o_flags;
 	int err;
 
+	if (!ip_tunnel_flags_is_be16_compat(p->i_flags) ||
+	    !ip_tunnel_flags_is_be16_compat(p->o_flags))
+		return -EOVERFLOW;
+
+	i_flags = ip_tunnel_flags_to_be16(p->i_flags);
+	o_flags = ip_tunnel_flags_to_be16(p->o_flags);
+
 	if (cmd == SIOCADDTUNNEL || cmd == SIOCCHGTUNNEL) {
 		if (p->iph.version != 4 || p->iph.protocol != IPPROTO_GRE ||
 		    p->iph.ihl != 5 || (p->iph.frag_off & htons(~IP_DF)) ||
-		    ((p->i_flags | p->o_flags) & (GRE_VERSION | GRE_ROUTING)))
+		    ((i_flags | o_flags) & (GRE_VERSION | GRE_ROUTING)))
 			return -EINVAL;
 	}
 
-	p->i_flags = gre_flags_to_tnl_flags(p->i_flags);
-	p->o_flags = gre_flags_to_tnl_flags(p->o_flags);
+	gre_flags_to_tnl_flags(p->i_flags, i_flags);
+	gre_flags_to_tnl_flags(p->o_flags, o_flags);
 
 	err = ip_tunnel_ctl(dev, p, cmd);
 	if (err)
@@ -803,15 +829,20 @@ static int ipgre_tunnel_ctl(struct net_device *dev,
 	if (cmd == SIOCCHGTUNNEL) {
 		struct ip_tunnel *t = netdev_priv(dev);
 
-		t->parms.i_flags = p->i_flags;
-		t->parms.o_flags = p->o_flags;
+		bitmap_copy(t->parms.i_flags, p->i_flags,
+			    __IP_TUNNEL_FLAG_NUM);
+		bitmap_copy(t->parms.o_flags, p->o_flags,
+			    __IP_TUNNEL_FLAG_NUM);
 
 		if (strcmp(dev->rtnl_link_ops->kind, "erspan"))
 			ipgre_link_update(dev, true);
 	}
 
-	p->i_flags = gre_tnl_flags_to_gre_flags(p->i_flags);
-	p->o_flags = gre_tnl_flags_to_gre_flags(p->o_flags);
+	i_flags = gre_tnl_flags_to_gre_flags(p->i_flags);
+	ip_tunnel_flags_from_be16(p->i_flags, i_flags);
+	o_flags = gre_tnl_flags_to_gre_flags(p->o_flags);
+	ip_tunnel_flags_from_be16(p->o_flags, o_flags);
+
 	return 0;
 }
 
@@ -951,7 +982,6 @@ static void ipgre_tunnel_setup(struct net_device *dev)
 static void __gre_tunnel_init(struct net_device *dev)
 {
 	struct ip_tunnel *tunnel;
-	__be16 flags;
 
 	tunnel = netdev_priv(dev);
 	tunnel->tun_hlen = gre_calc_hlen(tunnel->parms.o_flags);
@@ -963,14 +993,13 @@ static void __gre_tunnel_init(struct net_device *dev)
 	dev->features		|= GRE_FEATURES | NETIF_F_LLTX;
 	dev->hw_features	|= GRE_FEATURES;
 
-	flags = tunnel->parms.o_flags;
-
 	/* TCP offload with GRE SEQ is not supported, nor can we support 2
 	 * levels of outer headers requiring an update.
 	 */
-	if (flags & TUNNEL_SEQ)
+	if (test_bit(IP_TUNNEL_SEQ_BIT, tunnel->parms.o_flags))
 		return;
-	if (flags & TUNNEL_CSUM && tunnel->encap.type != TUNNEL_ENCAP_NONE)
+	if (test_bit(IP_TUNNEL_CSUM_BIT, tunnel->parms.o_flags) &&
+	    tunnel->encap.type != TUNNEL_ENCAP_NONE)
 		return;
 
 	dev->features |= NETIF_F_GSO_SOFTWARE;
@@ -1141,10 +1170,12 @@ static int ipgre_netlink_parms(struct net_device *dev,
 		parms->link = nla_get_u32(data[IFLA_GRE_LINK]);
 
 	if (data[IFLA_GRE_IFLAGS])
-		parms->i_flags = gre_flags_to_tnl_flags(nla_get_be16(data[IFLA_GRE_IFLAGS]));
+		gre_flags_to_tnl_flags(parms->i_flags,
+				       nla_get_be16(data[IFLA_GRE_IFLAGS]));
 
 	if (data[IFLA_GRE_OFLAGS])
-		parms->o_flags = gre_flags_to_tnl_flags(nla_get_be16(data[IFLA_GRE_OFLAGS]));
+		gre_flags_to_tnl_flags(parms->o_flags,
+				       nla_get_be16(data[IFLA_GRE_OFLAGS]));
 
 	if (data[IFLA_GRE_IKEY])
 		parms->i_key = nla_get_be32(data[IFLA_GRE_IKEY]);
@@ -1404,8 +1435,8 @@ static int ipgre_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (err < 0)
 		return err;
 
-	t->parms.i_flags = p.i_flags;
-	t->parms.o_flags = p.o_flags;
+	bitmap_copy(t->parms.i_flags, p.i_flags, __IP_TUNNEL_FLAG_NUM);
+	bitmap_copy(t->parms.o_flags, p.o_flags, __IP_TUNNEL_FLAG_NUM);
 
 	ipgre_link_update(dev, !tb[IFLA_MTU]);
 
@@ -1433,8 +1464,8 @@ static int erspan_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (err < 0)
 		return err;
 
-	t->parms.i_flags = p.i_flags;
-	t->parms.o_flags = p.o_flags;
+	bitmap_copy(t->parms.i_flags, p.i_flags, __IP_TUNNEL_FLAG_NUM);
+	bitmap_copy(t->parms.o_flags, p.o_flags, __IP_TUNNEL_FLAG_NUM);
 
 	return 0;
 }
@@ -1491,7 +1522,9 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
 	struct ip_tunnel_parm_kern *p = &t->parms;
-	__be16 o_flags = p->o_flags;
+	IP_TUNNEL_DECLARE_FLAGS(o_flags);
+
+	bitmap_copy(o_flags, p->o_flags, __IP_TUNNEL_FLAG_NUM);
 
 	if (nla_put_u32(skb, IFLA_GRE_LINK, p->link) ||
 	    nla_put_be16(skb, IFLA_GRE_IFLAGS,
@@ -1539,7 +1572,7 @@ static int erspan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 	if (t->erspan_ver <= 2) {
 		if (t->erspan_ver != 0 && !t->collect_md)
-			t->parms.o_flags |= TUNNEL_KEY;
+			__set_bit(IP_TUNNEL_KEY_BIT, t->parms.o_flags);
 
 		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
 			goto nla_put_failure;
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 1cc27f62b024..3838f048e956 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -57,16 +57,17 @@ static unsigned int ip_tunnel_hash(__be32 key, __be32 remote)
 }
 
 static bool ip_tunnel_key_match(const struct ip_tunnel_parm_kern *p,
-				__be16 flags, __be32 key)
+				const unsigned long *flags, __be32 key)
 {
-	if (p->i_flags & TUNNEL_KEY) {
-		if (flags & TUNNEL_KEY)
+	if (test_bit(IP_TUNNEL_KEY_BIT, p->i_flags)) {
+		if (test_bit(IP_TUNNEL_KEY_BIT, flags))
 			return key == p->i_key;
 		else
 			/* key expected, none present */
 			return false;
-	} else
-		return !(flags & TUNNEL_KEY);
+	} else {
+		return !test_bit(IP_TUNNEL_KEY_BIT, flags);
+	}
 }
 
 /* Fallback tunnel: no source, no destination, no key, no options
@@ -81,7 +82,7 @@ static bool ip_tunnel_key_match(const struct ip_tunnel_parm_kern *p,
    Given src, dst and key, find appropriate for input tunnel.
 */
 struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
-				   int link, __be16 flags,
+				   int link, const unsigned long *flags,
 				   __be32 remote, __be32 local,
 				   __be32 key)
 {
@@ -144,7 +145,8 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 	}
 
 	hlist_for_each_entry_rcu(t, head, hash_node) {
-		if ((!(flags & TUNNEL_NO_KEY) && t->parms.i_key != key) ||
+		if ((!test_bit(IP_TUNNEL_NO_KEY_BIT, flags) &&
+		     t->parms.i_key != key) ||
 		    t->parms.iph.saddr != 0 ||
 		    t->parms.iph.daddr != 0 ||
 		    !(t->dev->flags & IFF_UP))
@@ -183,7 +185,8 @@ static struct hlist_head *ip_bucket(struct ip_tunnel_net *itn,
 	else
 		remote = 0;
 
-	if (!(parms->i_flags & TUNNEL_KEY) && (parms->i_flags & VTI_ISVTI))
+	if (!test_bit(IP_TUNNEL_KEY_BIT, parms->i_flags) &&
+	    test_bit(IP_TUNNEL_VTI_BIT, parms->i_flags))
 		i_key = 0;
 
 	h = ip_tunnel_hash(i_key, remote);
@@ -212,12 +215,14 @@ static struct ip_tunnel *ip_tunnel_find(struct ip_tunnel_net *itn,
 {
 	__be32 remote = parms->iph.daddr;
 	__be32 local = parms->iph.saddr;
+	IP_TUNNEL_DECLARE_FLAGS(flags);
 	__be32 key = parms->i_key;
-	__be16 flags = parms->i_flags;
 	int link = parms->link;
 	struct ip_tunnel *t = NULL;
 	struct hlist_head *head = ip_bucket(itn, parms);
 
+	bitmap_copy(flags, parms->i_flags, __IP_TUNNEL_FLAG_NUM);
+
 	hlist_for_each_entry_rcu(t, head, hash_node) {
 		if (local == t->parms.iph.saddr &&
 		    remote == t->parms.iph.daddr &&
@@ -387,15 +392,15 @@ int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 	}
 #endif
 
-	if ((!(tpi->flags&TUNNEL_CSUM) &&  (tunnel->parms.i_flags&TUNNEL_CSUM)) ||
-	     ((tpi->flags&TUNNEL_CSUM) && !(tunnel->parms.i_flags&TUNNEL_CSUM))) {
+	if (test_bit(IP_TUNNEL_CSUM_BIT, tunnel->parms.i_flags) !=
+	    test_bit(IP_TUNNEL_CSUM_BIT, tpi->flags)) {
 		DEV_STATS_INC(tunnel->dev, rx_crc_errors);
 		DEV_STATS_INC(tunnel->dev, rx_errors);
 		goto drop;
 	}
 
-	if (tunnel->parms.i_flags&TUNNEL_SEQ) {
-		if (!(tpi->flags&TUNNEL_SEQ) ||
+	if (test_bit(IP_TUNNEL_SEQ_BIT, tunnel->parms.i_flags)) {
+		if (!test_bit(IP_TUNNEL_SEQ_BIT, tpi->flags) ||
 		    (tunnel->i_seqno && (s32)(ntohl(tpi->seq) - tunnel->i_seqno) < 0)) {
 			DEV_STATS_INC(tunnel->dev, rx_fifo_errors);
 			DEV_STATS_INC(tunnel->dev, rx_errors);
@@ -612,7 +617,7 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 		goto tx_error;
 	}
 
-	if (key->tun_flags & TUNNEL_DONT_FRAGMENT)
+	if (test_bit(IP_TUNNEL_DONT_FRAGMENT_BIT, key->tun_flags))
 		df = htons(IP_DF);
 	if (tnl_update_pmtu(dev, skb, rt, df, inner_iph, tunnel_hlen,
 			    key->u.ipv4.dst, true)) {
@@ -902,10 +907,10 @@ int ip_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm_kern *p,
 			goto done;
 		if (p->iph.ttl)
 			p->iph.frag_off |= htons(IP_DF);
-		if (!(p->i_flags & VTI_ISVTI)) {
-			if (!(p->i_flags & TUNNEL_KEY))
+		if (!test_bit(IP_TUNNEL_VTI_BIT, p->i_flags)) {
+			if (!test_bit(IP_TUNNEL_KEY_BIT, p->i_flags))
 				p->i_key = 0;
-			if (!(p->o_flags & TUNNEL_KEY))
+			if (!test_bit(IP_TUNNEL_KEY_BIT, p->o_flags))
 				p->o_key = 0;
 		}
 
@@ -992,8 +997,8 @@ int ip_tunnel_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 
 	strscpy(kp.name, p.name, sizeof(kp.name));
 	kp.link = p.link;
-	kp.i_flags = p.i_flags;
-	kp.o_flags = p.o_flags;
+	ip_tunnel_flags_from_be16(kp.i_flags, p.i_flags);
+	ip_tunnel_flags_from_be16(kp.o_flags, p.o_flags);
 	kp.i_key = p.i_key;
 	kp.o_key = p.o_key;
 	memcpy(&kp.iph, &p.iph, min(sizeof(kp.iph), sizeof(p.iph)));
@@ -1002,10 +1007,14 @@ int ip_tunnel_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 	if (err)
 		return err;
 
+	if (!ip_tunnel_flags_is_be16_compat(kp.i_flags) ||
+	    !ip_tunnel_flags_is_be16_compat(kp.o_flags))
+		return -EOVERFLOW;
+
 	strscpy(p.name, kp.name, sizeof(p.name));
 	p.link = kp.link;
-	p.i_flags = kp.i_flags;
-	p.o_flags = kp.o_flags;
+	p.i_flags = ip_tunnel_flags_to_be16(kp.i_flags);
+	p.o_flags = ip_tunnel_flags_to_be16(kp.o_flags);
 	p.i_key = kp.i_key;
 	p.o_key = kp.o_key;
 	memcpy(&p.iph, &kp.iph, min(sizeof(p.iph), sizeof(kp.iph)));
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 0c7cdb058855..0d7d1cbf9328 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -125,6 +125,7 @@ EXPORT_SYMBOL_GPL(__iptunnel_pull_header);
 struct metadata_dst *iptunnel_metadata_reply(struct metadata_dst *md,
 					     gfp_t flags)
 {
+	IP_TUNNEL_DECLARE_FLAGS(tun_flags) = { };
 	struct metadata_dst *res;
 	struct ip_tunnel_info *dst, *src;
 
@@ -144,10 +145,11 @@ struct metadata_dst *iptunnel_metadata_reply(struct metadata_dst *md,
 		       sizeof(struct in6_addr));
 	else
 		dst->key.u.ipv4.dst = src->key.u.ipv4.src;
-	dst->key.tun_flags = src->key.tun_flags;
+	bitmap_copy(dst->key.tun_flags, src->key.tun_flags,
+		    __IP_TUNNEL_FLAG_NUM);
 	dst->mode = src->mode | IP_TUNNEL_INFO_TX;
 	ip_tunnel_info_opts_set(dst, ip_tunnel_info_opts(src),
-				src->options_len, 0);
+				src->options_len, tun_flags);
 
 	return res;
 }
@@ -497,7 +499,7 @@ static int ip_tun_parse_opts_geneve(struct nlattr *attr,
 		opt->opt_class = nla_get_be16(attr);
 		attr = tb[LWTUNNEL_IP_OPT_GENEVE_TYPE];
 		opt->type = nla_get_u8(attr);
-		info->key.tun_flags |= TUNNEL_GENEVE_OPT;
+		__set_bit(IP_TUNNEL_GENEVE_OPT_BIT, info->key.tun_flags);
 	}
 
 	return sizeof(struct geneve_opt) + data_len;
@@ -525,7 +527,7 @@ static int ip_tun_parse_opts_vxlan(struct nlattr *attr,
 		attr = tb[LWTUNNEL_IP_OPT_VXLAN_GBP];
 		md->gbp = nla_get_u32(attr);
 		md->gbp &= VXLAN_GBP_MASK;
-		info->key.tun_flags |= TUNNEL_VXLAN_OPT;
+		__set_bit(IP_TUNNEL_VXLAN_OPT_BIT, info->key.tun_flags);
 	}
 
 	return sizeof(struct vxlan_metadata);
@@ -574,7 +576,7 @@ static int ip_tun_parse_opts_erspan(struct nlattr *attr,
 			set_hwid(&md->u.md2, nla_get_u8(attr));
 		}
 
-		info->key.tun_flags |= TUNNEL_ERSPAN_OPT;
+		__set_bit(IP_TUNNEL_ERSPAN_OPT_BIT, info->key.tun_flags);
 	}
 
 	return sizeof(struct erspan_metadata);
@@ -585,7 +587,7 @@ static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 {
 	int err, rem, opt_len, opts_len = 0;
 	struct nlattr *nla;
-	__be16 type = 0;
+	u32 type = 0;
 
 	if (!attr)
 		return 0;
@@ -598,7 +600,7 @@ static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 	nla_for_each_attr(nla, nla_data(attr), nla_len(attr), rem) {
 		switch (nla_type(nla)) {
 		case LWTUNNEL_IP_OPTS_GENEVE:
-			if (type && type != TUNNEL_GENEVE_OPT)
+			if (type && type != IP_TUNNEL_GENEVE_OPT_BIT)
 				return -EINVAL;
 			opt_len = ip_tun_parse_opts_geneve(nla, info, opts_len,
 							   extack);
@@ -607,7 +609,7 @@ static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 			opts_len += opt_len;
 			if (opts_len > IP_TUNNEL_OPTS_MAX)
 				return -EINVAL;
-			type = TUNNEL_GENEVE_OPT;
+			type = IP_TUNNEL_GENEVE_OPT_BIT;
 			break;
 		case LWTUNNEL_IP_OPTS_VXLAN:
 			if (type)
@@ -617,7 +619,7 @@ static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 			if (opt_len < 0)
 				return opt_len;
 			opts_len += opt_len;
-			type = TUNNEL_VXLAN_OPT;
+			type = IP_TUNNEL_VXLAN_OPT_BIT;
 			break;
 		case LWTUNNEL_IP_OPTS_ERSPAN:
 			if (type)
@@ -627,7 +629,7 @@ static int ip_tun_parse_opts(struct nlattr *attr, struct ip_tunnel_info *info,
 			if (opt_len < 0)
 				return opt_len;
 			opts_len += opt_len;
-			type = TUNNEL_ERSPAN_OPT;
+			type = IP_TUNNEL_ERSPAN_OPT_BIT;
 			break;
 		default:
 			return -EINVAL;
@@ -705,10 +707,16 @@ static int ip_tun_build_state(struct net *net, struct nlattr *attr,
 	if (tb[LWTUNNEL_IP_TOS])
 		tun_info->key.tos = nla_get_u8(tb[LWTUNNEL_IP_TOS]);
 
-	if (tb[LWTUNNEL_IP_FLAGS])
-		tun_info->key.tun_flags |=
-				(nla_get_be16(tb[LWTUNNEL_IP_FLAGS]) &
-				 ~TUNNEL_OPTIONS_PRESENT);
+	if (tb[LWTUNNEL_IP_FLAGS]) {
+		IP_TUNNEL_DECLARE_FLAGS(flags);
+
+		ip_tunnel_flags_from_be16(flags,
+					  nla_get_be16(tb[LWTUNNEL_IP_FLAGS]));
+		ip_tunnel_clear_options_present(flags);
+
+		bitmap_or(tun_info->key.tun_flags, tun_info->key.tun_flags,
+			  flags, __IP_TUNNEL_FLAG_NUM);
+	}
 
 	tun_info->mode = IP_TUNNEL_INFO_TX;
 	tun_info->options_len = opt_len;
@@ -812,18 +820,18 @@ static int ip_tun_fill_encap_opts(struct sk_buff *skb, int type,
 	struct nlattr *nest;
 	int err = 0;
 
-	if (!(tun_info->key.tun_flags & TUNNEL_OPTIONS_PRESENT))
+	if (!ip_tunnel_is_options_present(tun_info->key.tun_flags))
 		return 0;
 
 	nest = nla_nest_start_noflag(skb, type);
 	if (!nest)
 		return -ENOMEM;
 
-	if (tun_info->key.tun_flags & TUNNEL_GENEVE_OPT)
+	if (test_bit(IP_TUNNEL_GENEVE_OPT_BIT, tun_info->key.tun_flags))
 		err = ip_tun_fill_encap_opts_geneve(skb, tun_info);
-	else if (tun_info->key.tun_flags & TUNNEL_VXLAN_OPT)
+	else if (test_bit(IP_TUNNEL_VXLAN_OPT_BIT, tun_info->key.tun_flags))
 		err = ip_tun_fill_encap_opts_vxlan(skb, tun_info);
-	else if (tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT)
+	else if (test_bit(IP_TUNNEL_ERSPAN_OPT_BIT, tun_info->key.tun_flags))
 		err = ip_tun_fill_encap_opts_erspan(skb, tun_info);
 
 	if (err) {
@@ -846,7 +854,8 @@ static int ip_tun_fill_encap_info(struct sk_buff *skb,
 	    nla_put_in_addr(skb, LWTUNNEL_IP_SRC, tun_info->key.u.ipv4.src) ||
 	    nla_put_u8(skb, LWTUNNEL_IP_TOS, tun_info->key.tos) ||
 	    nla_put_u8(skb, LWTUNNEL_IP_TTL, tun_info->key.ttl) ||
-	    nla_put_be16(skb, LWTUNNEL_IP_FLAGS, tun_info->key.tun_flags) ||
+	    nla_put_be16(skb, LWTUNNEL_IP_FLAGS,
+			 ip_tunnel_flags_to_be16(tun_info->key.tun_flags)) ||
 	    ip_tun_fill_encap_opts(skb, LWTUNNEL_IP_OPTS, tun_info))
 		return -ENOMEM;
 
@@ -857,11 +866,11 @@ static int ip_tun_opts_nlsize(struct ip_tunnel_info *info)
 {
 	int opt_len;
 
-	if (!(info->key.tun_flags & TUNNEL_OPTIONS_PRESENT))
+	if (!ip_tunnel_is_options_present(info->key.tun_flags))
 		return 0;
 
 	opt_len = nla_total_size(0);		/* LWTUNNEL_IP_OPTS */
-	if (info->key.tun_flags & TUNNEL_GENEVE_OPT) {
+	if (test_bit(IP_TUNNEL_GENEVE_OPT_BIT, info->key.tun_flags)) {
 		struct geneve_opt *opt;
 		int offset = 0;
 
@@ -874,10 +883,10 @@ static int ip_tun_opts_nlsize(struct ip_tunnel_info *info)
 							/* OPT_GENEVE_DATA */
 			offset += sizeof(*opt) + opt->length * 4;
 		}
-	} else if (info->key.tun_flags & TUNNEL_VXLAN_OPT) {
+	} else if (test_bit(IP_TUNNEL_VXLAN_OPT_BIT, info->key.tun_flags)) {
 		opt_len += nla_total_size(0)	/* LWTUNNEL_IP_OPTS_VXLAN */
 			   + nla_total_size(4);	/* OPT_VXLAN_GBP */
-	} else if (info->key.tun_flags & TUNNEL_ERSPAN_OPT) {
+	} else if (test_bit(IP_TUNNEL_ERSPAN_OPT_BIT, info->key.tun_flags)) {
 		struct erspan_metadata *md = ip_tunnel_info_opts(info);
 
 		opt_len += nla_total_size(0)	/* LWTUNNEL_IP_OPTS_ERSPAN */
@@ -984,10 +993,17 @@ static int ip6_tun_build_state(struct net *net, struct nlattr *attr,
 	if (tb[LWTUNNEL_IP6_TC])
 		tun_info->key.tos = nla_get_u8(tb[LWTUNNEL_IP6_TC]);
 
-	if (tb[LWTUNNEL_IP6_FLAGS])
-		tun_info->key.tun_flags |=
-				(nla_get_be16(tb[LWTUNNEL_IP6_FLAGS]) &
-				 ~TUNNEL_OPTIONS_PRESENT);
+	if (tb[LWTUNNEL_IP6_FLAGS]) {
+		IP_TUNNEL_DECLARE_FLAGS(flags);
+		__be16 data;
+
+		data = nla_get_be16(tb[LWTUNNEL_IP6_FLAGS]);
+		ip_tunnel_flags_from_be16(flags, data);
+		ip_tunnel_clear_options_present(flags);
+
+		bitmap_or(tun_info->key.tun_flags, tun_info->key.tun_flags,
+			  flags, __IP_TUNNEL_FLAG_NUM);
+	}
 
 	tun_info->mode = IP_TUNNEL_INFO_TX | IP_TUNNEL_INFO_IPV6;
 	tun_info->options_len = opt_len;
@@ -1008,7 +1024,8 @@ static int ip6_tun_fill_encap_info(struct sk_buff *skb,
 	    nla_put_in6_addr(skb, LWTUNNEL_IP6_SRC, &tun_info->key.u.ipv6.src) ||
 	    nla_put_u8(skb, LWTUNNEL_IP6_TC, tun_info->key.tos) ||
 	    nla_put_u8(skb, LWTUNNEL_IP6_HOPLIMIT, tun_info->key.ttl) ||
-	    nla_put_be16(skb, LWTUNNEL_IP6_FLAGS, tun_info->key.tun_flags) ||
+	    nla_put_be16(skb, LWTUNNEL_IP6_FLAGS,
+			 ip_tunnel_flags_to_be16(tun_info->key.tun_flags)) ||
 	    ip_tun_fill_encap_opts(skb, LWTUNNEL_IP6_OPTS, tun_info))
 		return -ENOMEM;
 
@@ -1139,8 +1156,12 @@ void ip_tunnel_netlink_parms(struct nlattr *data[],
 	if (!data[IFLA_IPTUN_PMTUDISC] || nla_get_u8(data[IFLA_IPTUN_PMTUDISC]))
 		parms->iph.frag_off = htons(IP_DF);
 
-	if (data[IFLA_IPTUN_FLAGS])
-		parms->i_flags = nla_get_be16(data[IFLA_IPTUN_FLAGS]);
+	if (data[IFLA_IPTUN_FLAGS]) {
+		__be16 flags;
+
+		flags = nla_get_be16(data[IFLA_IPTUN_FLAGS]);
+		ip_tunnel_flags_from_be16(parms->i_flags, flags);
+	}
 
 	if (data[IFLA_IPTUN_PROTO])
 		parms->iph.protocol = nla_get_u8(data[IFLA_IPTUN_PROTO]);
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index f890807160ab..778b5ff6e751 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -51,8 +51,11 @@ static int vti_input(struct sk_buff *skb, int nexthdr, __be32 spi,
 	const struct iphdr *iph = ip_hdr(skb);
 	struct net *net = dev_net(skb->dev);
 	struct ip_tunnel_net *itn = net_generic(net, vti_net_id);
+	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 
-	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, TUNNEL_NO_KEY,
+	__set_bit(IP_TUNNEL_NO_KEY_BIT, flags);
+
+	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, flags,
 				  iph->saddr, iph->daddr, 0);
 	if (tunnel) {
 		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
@@ -322,8 +325,11 @@ static int vti4_err(struct sk_buff *skb, u32 info)
 	const struct iphdr *iph = (const struct iphdr *)skb->data;
 	int protocol = iph->protocol;
 	struct ip_tunnel_net *itn = net_generic(net, vti_net_id);
+	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
+
+	__set_bit(IP_TUNNEL_NO_KEY_BIT, flags);
 
-	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, TUNNEL_NO_KEY,
+	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, flags,
 				  iph->daddr, iph->saddr, 0);
 	if (!tunnel)
 		return -1;
@@ -383,20 +389,28 @@ vti_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm_kern *p, int cmd)
 			return -EINVAL;
 	}
 
-	if (!(p->i_flags & GRE_KEY))
+	if (!ip_tunnel_flags_is_be16_compat(p->i_flags) ||
+	    !ip_tunnel_flags_is_be16_compat(p->o_flags))
+		return -EOVERFLOW;
+
+	if (!(ip_tunnel_flags_to_be16(p->i_flags) & GRE_KEY))
 		p->i_key = 0;
-	if (!(p->o_flags & GRE_KEY))
+	if (!(ip_tunnel_flags_to_be16(p->o_flags) & GRE_KEY))
 		p->o_key = 0;
 
-	p->i_flags = VTI_ISVTI;
+	bitmap_zero(p->i_flags, __IP_TUNNEL_FLAG_NUM);
+	__set_bit(IP_TUNNEL_VTI_BIT, p->i_flags);
 
 	err = ip_tunnel_ctl(dev, p, cmd);
 	if (err)
 		return err;
 
 	if (cmd != SIOCDELTUNNEL) {
-		p->i_flags |= GRE_KEY;
-		p->o_flags |= GRE_KEY;
+		IP_TUNNEL_DECLARE_FLAGS(flags) = { };
+
+		ip_tunnel_flags_from_be16(flags, GRE_KEY);
+		bitmap_or(p->i_flags, p->i_flags, flags, __IP_TUNNEL_FLAG_NUM);
+		bitmap_or(p->o_flags, p->o_flags, flags, __IP_TUNNEL_FLAG_NUM);
 	}
 	return 0;
 }
@@ -539,7 +553,8 @@ static void vti_netlink_parms(struct nlattr *data[],
 	if (!data)
 		return;
 
-	parms->i_flags = VTI_ISVTI;
+	bitmap_zero(parms->i_flags, __IP_TUNNEL_FLAG_NUM);
+	__set_bit(IP_TUNNEL_VTI_BIT, parms->i_flags);
 
 	if (data[IFLA_VTI_LINK])
 		parms->link = nla_get_u32(data[IFLA_VTI_LINK]);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 0dd2d3b55c75..7ff44d4bb6f4 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -130,13 +130,16 @@ static int ipip_err(struct sk_buff *skb, u32 info)
 	struct net *net = dev_net(skb->dev);
 	struct ip_tunnel_net *itn = net_generic(net, ipip_net_id);
 	const struct iphdr *iph = (const struct iphdr *)skb->data;
+	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 	const int type = icmp_hdr(skb)->type;
 	const int code = icmp_hdr(skb)->code;
 	struct ip_tunnel *t;
 	int err = 0;
 
-	t = ip_tunnel_lookup(itn, skb->dev->ifindex, TUNNEL_NO_KEY,
-			     iph->daddr, iph->saddr, 0);
+	__set_bit(IP_TUNNEL_NO_KEY_BIT, flags);
+
+	t = ip_tunnel_lookup(itn, skb->dev->ifindex, flags, iph->daddr,
+			     iph->saddr, 0);
 	if (!t) {
 		err = -ENOENT;
 		goto out;
@@ -213,13 +216,16 @@ static int ipip_tunnel_rcv(struct sk_buff *skb, u8 ipproto)
 {
 	struct net *net = dev_net(skb->dev);
 	struct ip_tunnel_net *itn = net_generic(net, ipip_net_id);
+	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 	struct metadata_dst *tun_dst = NULL;
 	struct ip_tunnel *tunnel;
 	const struct iphdr *iph;
 
+	__set_bit(IP_TUNNEL_NO_KEY_BIT, flags);
+
 	iph = ip_hdr(skb);
-	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, TUNNEL_NO_KEY,
-			iph->saddr, iph->daddr, 0);
+	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, flags, iph->saddr,
+				  iph->daddr, 0);
 	if (tunnel) {
 		const struct tnl_ptk_info *tpi;
 
@@ -238,7 +244,9 @@ static int ipip_tunnel_rcv(struct sk_buff *skb, u8 ipproto)
 		if (iptunnel_pull_header(skb, 0, tpi->proto, false))
 			goto drop;
 		if (tunnel->collect_md) {
-			tun_dst = ip_tun_rx_dst(skb, 0, 0, 0);
+			bitmap_zero(flags, __IP_TUNNEL_FLAG_NUM);
+
+			tun_dst = ip_tun_rx_dst(skb, flags, 0, 0);
 			if (!tun_dst)
 				return 0;
 			ip_tunnel_md_udp_encap(skb, &tun_dst->u.tun_info);
@@ -340,7 +348,8 @@ ipip_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm_kern *p, int cmd)
 	}
 
 	p->i_key = p->o_key = 0;
-	p->i_flags = p->o_flags = 0;
+	bitmap_zero(p->i_flags, __IP_TUNNEL_FLAG_NUM);
+	bitmap_zero(p->o_flags, __IP_TUNNEL_FLAG_NUM);
 	return ip_tunnel_ctl(dev, p, cmd);
 }
 
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 5f8104cf082d..77510a544ca0 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -183,7 +183,8 @@ void udp_tunnel_sock_release(struct socket *sock)
 EXPORT_SYMBOL_GPL(udp_tunnel_sock_release);
 
 struct metadata_dst *udp_tun_rx_dst(struct sk_buff *skb,  unsigned short family,
-				    __be16 flags, __be64 tunnel_id, int md_size)
+				    const unsigned long *flags,
+				    __be64 tunnel_id, int md_size)
 {
 	struct metadata_dst *tun_dst;
 	struct ip_tunnel_info *info;
@@ -199,7 +200,7 @@ struct metadata_dst *udp_tun_rx_dst(struct sk_buff *skb,  unsigned short family,
 	info->key.tp_src = udp_hdr(skb)->source;
 	info->key.tp_dst = udp_hdr(skb)->dest;
 	if (udp_hdr(skb)->check)
-		info->key.tun_flags |= TUNNEL_CSUM;
+		__set_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags);
 	return tun_dst;
 }
 EXPORT_SYMBOL_GPL(udp_tun_rx_dst);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index da80974ad23a..77420df3447f 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -496,11 +496,11 @@ static int ip6gre_rcv(struct sk_buff *skb, const struct tnl_ptk_info *tpi)
 				      tpi->proto);
 	if (tunnel) {
 		if (tunnel->parms.collect_md) {
+			IP_TUNNEL_DECLARE_FLAGS(flags);
 			struct metadata_dst *tun_dst;
 			__be64 tun_id;
-			__be16 flags;
 
-			flags = tpi->flags;
+			bitmap_copy(flags, tpi->flags, __IP_TUNNEL_FLAG_NUM);
 			tun_id = key32_to_tunnel_id(tpi->key);
 
 			tun_dst = ipv6_tun_rx_dst(skb, flags, tun_id, 0);
@@ -548,14 +548,14 @@ static int ip6erspan_rcv(struct sk_buff *skb,
 
 		if (tunnel->parms.collect_md) {
 			struct erspan_metadata *pkt_md, *md;
+			IP_TUNNEL_DECLARE_FLAGS(flags);
 			struct metadata_dst *tun_dst;
 			struct ip_tunnel_info *info;
 			unsigned char *gh;
 			__be64 tun_id;
-			__be16 flags;
 
-			tpi->flags |= TUNNEL_KEY;
-			flags = tpi->flags;
+			__set_bit(IP_TUNNEL_KEY_BIT, tpi->flags);
+			bitmap_copy(flags, tpi->flags, __IP_TUNNEL_FLAG_NUM);
 			tun_id = key32_to_tunnel_id(tpi->key);
 
 			tun_dst = ipv6_tun_rx_dst(skb, flags, tun_id,
@@ -577,11 +577,11 @@ static int ip6erspan_rcv(struct sk_buff *skb,
 			md2 = &md->u.md2;
 			memcpy(md2, pkt_md, ver == 1 ? ERSPAN_V1_MDSIZE :
 						       ERSPAN_V2_MDSIZE);
-			info->key.tun_flags |= TUNNEL_ERSPAN_OPT;
+			__set_bit(IP_TUNNEL_ERSPAN_OPT_BIT,
+				  info->key.tun_flags);
 			info->options_len = sizeof(*md);
 
 			ip6_tnl_rcv(tunnel, skb, tpi, tun_dst, log_ecn_error);
-
 		} else {
 			ip6_tnl_rcv(tunnel, skb, tpi, NULL, log_ecn_error);
 		}
@@ -745,8 +745,8 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 			       __u32 *pmtu, __be16 proto)
 {
 	struct ip6_tnl *tunnel = netdev_priv(dev);
+	IP_TUNNEL_DECLARE_FLAGS(flags);
 	__be16 protocol;
-	__be16 flags;
 
 	if (dev->type == ARPHRD_ETHER)
 		IPCB(skb)->flags = 0;
@@ -778,8 +778,11 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		fl6->fl6_gre_key = tunnel_id_to_key32(key->tun_id);
 
 		dsfield = key->tos;
-		flags = key->tun_flags &
-			(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
+		bitmap_zero(flags, __IP_TUNNEL_FLAG_NUM);
+		__set_bit(IP_TUNNEL_CSUM_BIT, flags);
+		__set_bit(IP_TUNNEL_KEY_BIT, flags);
+		__set_bit(IP_TUNNEL_SEQ_BIT, flags);
+		bitmap_and(flags, flags, key->tun_flags, __IP_TUNNEL_FLAG_NUM);
 		tun_hlen = gre_calc_hlen(flags);
 
 		if (skb_cow_head(skb, dev->needed_headroom ?: tun_hlen + tunnel->encap_hlen))
@@ -788,19 +791,22 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		gre_build_header(skb, tun_hlen,
 				 flags, protocol,
 				 tunnel_id_to_key32(tun_info->key.tun_id),
-				 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno))
-						      : 0);
+				 test_bit(IP_TUNNEL_SEQ_BIT, flags) ?
+				 htonl(atomic_fetch_inc(&tunnel->o_seqno)) :
+				 0);
 
 	} else {
 		if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
 			return -ENOMEM;
 
-		flags = tunnel->parms.o_flags;
+		bitmap_copy(flags, tunnel->parms.o_flags,
+			    __IP_TUNNEL_FLAG_NUM);
 
 		gre_build_header(skb, tunnel->tun_hlen, flags,
 				 protocol, tunnel->parms.o_key,
-				 (flags & TUNNEL_SEQ) ? htonl(atomic_fetch_inc(&tunnel->o_seqno))
-						      : 0);
+				 test_bit(IP_TUNNEL_SEQ_BIT, flags) ?
+				 htonl(atomic_fetch_inc(&tunnel->o_seqno)) :
+				 0);
 	}
 
 	return ip6_tnl_xmit(skb, dev, dsfield, fl6, encap_limit, pmtu,
@@ -822,7 +828,8 @@ static inline int ip6gre_xmit_ipv4(struct sk_buff *skb, struct net_device *dev)
 		prepare_ip6gre_xmit_ipv4(skb, dev, &fl6,
 					 &dsfield, &encap_limit);
 
-	err = gre_handle_offloads(skb, !!(t->parms.o_flags & TUNNEL_CSUM));
+	err = gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT,
+						t->parms.o_flags));
 	if (err)
 		return -1;
 
@@ -856,7 +863,8 @@ static inline int ip6gre_xmit_ipv6(struct sk_buff *skb, struct net_device *dev)
 	    prepare_ip6gre_xmit_ipv6(skb, dev, &fl6, &dsfield, &encap_limit))
 		return -1;
 
-	if (gre_handle_offloads(skb, !!(t->parms.o_flags & TUNNEL_CSUM)))
+	if (gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT,
+					      t->parms.o_flags)))
 		return -1;
 
 	err = __gre6_xmit(skb, dev, dsfield, &fl6, encap_limit,
@@ -883,7 +891,8 @@ static int ip6gre_xmit_other(struct sk_buff *skb, struct net_device *dev)
 	    prepare_ip6gre_xmit_other(skb, dev, &fl6, &dsfield, &encap_limit))
 		return -1;
 
-	err = gre_handle_offloads(skb, !!(t->parms.o_flags & TUNNEL_CSUM));
+	err = gre_handle_offloads(skb, test_bit(IP_TUNNEL_CSUM_BIT,
+						t->parms.o_flags));
 	if (err)
 		return err;
 	err = __gre6_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu, skb->protocol);
@@ -936,6 +945,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	struct ip_tunnel_info *tun_info = NULL;
 	struct ip6_tnl *t = netdev_priv(dev);
 	struct dst_entry *dst = skb_dst(skb);
+	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 	bool truncate = false;
 	int encap_limit = -1;
 	__u8 dsfield = false;
@@ -978,7 +988,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	if (skb_cow_head(skb, dev->needed_headroom ?: t->hlen))
 		goto tx_err;
 
-	t->parms.o_flags &= ~TUNNEL_KEY;
+	__clear_bit(IP_TUNNEL_KEY_BIT, t->parms.o_flags);
 	IPCB(skb)->flags = 0;
 
 	/* For collect_md mode, derive fl6 from the tunnel key,
@@ -1003,7 +1013,8 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		fl6.fl6_gre_key = tunnel_id_to_key32(key->tun_id);
 
 		dsfield = key->tos;
-		if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
+		if (!test_bit(IP_TUNNEL_ERSPAN_OPT_BIT,
+			      tun_info->key.tun_flags))
 			goto tx_err;
 		if (tun_info->options_len < sizeof(*md))
 			goto tx_err;
@@ -1064,7 +1075,9 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	}
 
 	/* Push GRE header. */
-	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(atomic_fetch_inc(&t->o_seqno)));
+	__set_bit(IP_TUNNEL_SEQ_BIT, flags);
+	gre_build_header(skb, 8, flags, proto, 0,
+			 htonl(atomic_fetch_inc(&t->o_seqno)));
 
 	/* TooBig packet may have updated dst->dev's mtu */
 	if (!t->parms.collect_md && dst && dst_mtu(dst) > dst->dev->mtu)
@@ -1207,8 +1220,8 @@ static void ip6gre_tnl_copy_tnl_parm(struct ip6_tnl *t,
 	t->parms.proto = p->proto;
 	t->parms.i_key = p->i_key;
 	t->parms.o_key = p->o_key;
-	t->parms.i_flags = p->i_flags;
-	t->parms.o_flags = p->o_flags;
+	bitmap_copy(t->parms.i_flags, p->i_flags, __IP_TUNNEL_FLAG_NUM);
+	bitmap_copy(t->parms.o_flags, p->o_flags, __IP_TUNNEL_FLAG_NUM);
 	t->parms.fwmark = p->fwmark;
 	t->parms.erspan_ver = p->erspan_ver;
 	t->parms.index = p->index;
@@ -1237,8 +1250,8 @@ static void ip6gre_tnl_parm_from_user(struct __ip6_tnl_parm *p,
 	p->link = u->link;
 	p->i_key = u->i_key;
 	p->o_key = u->o_key;
-	p->i_flags = gre_flags_to_tnl_flags(u->i_flags);
-	p->o_flags = gre_flags_to_tnl_flags(u->o_flags);
+	gre_flags_to_tnl_flags(p->i_flags, u->i_flags);
+	gre_flags_to_tnl_flags(p->o_flags, u->o_flags);
 	memcpy(p->name, u->name, sizeof(u->name));
 }
 
@@ -1390,7 +1403,7 @@ static int ip6gre_header(struct sk_buff *skb, struct net_device *dev,
 	ipv6h->daddr = t->parms.raddr;
 
 	p = (__be16 *)(ipv6h + 1);
-	p[0] = t->parms.o_flags;
+	p[0] = ip_tunnel_flags_to_be16(t->parms.o_flags);
 	p[1] = htons(type);
 
 	/*
@@ -1454,19 +1467,17 @@ static void ip6gre_tunnel_setup(struct net_device *dev)
 static void ip6gre_tnl_init_features(struct net_device *dev)
 {
 	struct ip6_tnl *nt = netdev_priv(dev);
-	__be16 flags;
 
 	dev->features		|= GRE6_FEATURES | NETIF_F_LLTX;
 	dev->hw_features	|= GRE6_FEATURES;
 
-	flags = nt->parms.o_flags;
-
 	/* TCP offload with GRE SEQ is not supported, nor can we support 2
 	 * levels of outer headers requiring an update.
 	 */
-	if (flags & TUNNEL_SEQ)
+	if (test_bit(IP_TUNNEL_SEQ_BIT, nt->parms.o_flags))
 		return;
-	if (flags & TUNNEL_CSUM && nt->encap.type != TUNNEL_ENCAP_NONE)
+	if (test_bit(IP_TUNNEL_CSUM_BIT, nt->parms.o_flags) &&
+	    nt->encap.type != TUNNEL_ENCAP_NONE)
 		return;
 
 	dev->features |= NETIF_F_GSO_SOFTWARE;
@@ -1792,12 +1803,12 @@ static void ip6gre_netlink_parms(struct nlattr *data[],
 		parms->link = nla_get_u32(data[IFLA_GRE_LINK]);
 
 	if (data[IFLA_GRE_IFLAGS])
-		parms->i_flags = gre_flags_to_tnl_flags(
-				nla_get_be16(data[IFLA_GRE_IFLAGS]));
+		gre_flags_to_tnl_flags(parms->i_flags,
+				       nla_get_be16(data[IFLA_GRE_IFLAGS]));
 
 	if (data[IFLA_GRE_OFLAGS])
-		parms->o_flags = gre_flags_to_tnl_flags(
-				nla_get_be16(data[IFLA_GRE_OFLAGS]));
+		gre_flags_to_tnl_flags(parms->o_flags,
+				       nla_get_be16(data[IFLA_GRE_OFLAGS]));
 
 	if (data[IFLA_GRE_IKEY])
 		parms->i_key = nla_get_be32(data[IFLA_GRE_IKEY]);
@@ -2143,11 +2154,13 @@ static int ip6gre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct ip6_tnl *t = netdev_priv(dev);
 	struct __ip6_tnl_parm *p = &t->parms;
-	__be16 o_flags = p->o_flags;
+	IP_TUNNEL_DECLARE_FLAGS(o_flags);
+
+	bitmap_copy(o_flags, p->o_flags, __IP_TUNNEL_FLAG_NUM);
 
 	if (p->erspan_ver == 1 || p->erspan_ver == 2) {
 		if (!p->collect_md)
-			o_flags |= TUNNEL_KEY;
+			__set_bit(IP_TUNNEL_KEY_BIT, o_flags);
 
 		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, p->erspan_ver))
 			goto nla_put_failure;
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 5e80e517f071..df9dc01fddd5 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -799,17 +799,15 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 	const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	int err;
 
-	if ((!(tpi->flags & TUNNEL_CSUM) &&
-	     (tunnel->parms.i_flags & TUNNEL_CSUM)) ||
-	    ((tpi->flags & TUNNEL_CSUM) &&
-	     !(tunnel->parms.i_flags & TUNNEL_CSUM))) {
+	if (test_bit(IP_TUNNEL_CSUM_BIT, tunnel->parms.i_flags) !=
+	    test_bit(IP_TUNNEL_CSUM_BIT, tpi->flags)) {
 		DEV_STATS_INC(tunnel->dev, rx_crc_errors);
 		DEV_STATS_INC(tunnel->dev, rx_errors);
 		goto drop;
 	}
 
-	if (tunnel->parms.i_flags & TUNNEL_SEQ) {
-		if (!(tpi->flags & TUNNEL_SEQ) ||
+	if (test_bit(IP_TUNNEL_SEQ_BIT, tunnel->parms.i_flags)) {
+		if (!test_bit(IP_TUNNEL_SEQ_BIT, tpi->flags) ||
 		    (tunnel->i_seqno &&
 		     (s32)(ntohl(tpi->seq) - tunnel->i_seqno) < 0)) {
 			DEV_STATS_INC(tunnel->dev, rx_fifo_errors);
@@ -932,7 +930,9 @@ static int ipxip6_rcv(struct sk_buff *skb, u8 ipproto,
 		if (iptunnel_pull_header(skb, 0, tpi->proto, false))
 			goto drop;
 		if (t->parms.collect_md) {
-			tun_dst = ipv6_tun_rx_dst(skb, 0, 0, 0);
+			IP_TUNNEL_DECLARE_FLAGS(flags) = { };
+
+			tun_dst = ipv6_tun_rx_dst(skb, flags, 0, 0);
 			if (!tun_dst)
 				goto drop;
 		}
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 7b326f89c4e3..358edd7f231e 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -207,7 +207,7 @@ static int ipip6_tunnel_create(struct net_device *dev)
 	__dev_addr_set(dev, &t->parms.iph.saddr, 4);
 	memcpy(dev->broadcast, &t->parms.iph.daddr, 4);
 
-	if ((__force u16)t->parms.i_flags & SIT_ISATAP)
+	if (test_bit(IP_TUNNEL_SIT_ISATAP_BIT, t->parms.i_flags))
 		dev->priv_flags |= IFF_ISATAP;
 
 	dev->rtnl_link_ops = &sit_link_ops;
@@ -1209,8 +1209,8 @@ ipip6_tunnel_get6rd(struct net_device *dev, struct ip_tunnel_parm __user *data)
 
 		strscpy(kp.name, p.name, sizeof(kp.name));
 		kp.link = p.link;
-		kp.i_flags = p.i_flags;
-		kp.o_flags = p.o_flags;
+		ip_tunnel_flags_from_be16(kp.i_flags, p.i_flags);
+		ip_tunnel_flags_from_be16(kp.o_flags, p.o_flags);
 		kp.i_key = p.i_key;
 		kp.o_key = p.o_key;
 		memcpy(&kp.iph, &p.iph, min(sizeof(p.iph), sizeof(kp.iph)));
@@ -1715,7 +1715,8 @@ static int ipip6_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put_u8(skb, IFLA_IPTUN_PMTUDISC,
 		       !!(parm->iph.frag_off & htons(IP_DF))) ||
 	    nla_put_u8(skb, IFLA_IPTUN_PROTO, parm->iph.protocol) ||
-	    nla_put_be16(skb, IFLA_IPTUN_FLAGS, parm->i_flags) ||
+	    nla_put_be16(skb, IFLA_IPTUN_FLAGS,
+			 ip_tunnel_flags_to_be16(parm->i_flags)) ||
 	    nla_put_u32(skb, IFLA_IPTUN_FWMARK, tunnel->fwmark))
 		goto nla_put_failure;
 
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index cb83ca506c5c..e8fdabbe0170 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1550,6 +1550,7 @@ static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	if (!dest)
 		goto unk;
 	if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		IP_TUNNEL_DECLARE_FLAGS(flags);
 		__be16 type;
 
 		/* Only support version 0 and C (csum) */
@@ -1560,7 +1561,10 @@ static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
 		if (type != htons(ETH_P_IP))
 			goto unk;
 		*proto = IPPROTO_IPIP;
-		return gre_calc_hlen(gre_flags_to_tnl_flags(greh->flags));
+
+		gre_flags_to_tnl_flags(flags, greh->flags);
+
+		return gre_calc_hlen(flags);
 	}
 
 unk:
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index feb1d7fcb09f..6e70a62d2e07 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -390,10 +390,10 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 			    skb->ip_summed == CHECKSUM_PARTIAL)
 				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
 		} else if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
-			__be16 tflags = 0;
+			IP_TUNNEL_DECLARE_FLAGS(tflags) = { };
 
 			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
-				tflags |= TUNNEL_CSUM;
+				__set_bit(IP_TUNNEL_CSUM_BIT, tflags);
 			mtu -= gre_calc_hlen(tflags);
 		}
 		if (mtu < 68) {
@@ -553,10 +553,10 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 			    skb->ip_summed == CHECKSUM_PARTIAL)
 				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
 		} else if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
-			__be16 tflags = 0;
+			IP_TUNNEL_DECLARE_FLAGS(tflags) = { };
 
 			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
-				tflags |= TUNNEL_CSUM;
+				__set_bit(IP_TUNNEL_CSUM_BIT, tflags);
 			mtu -= gre_calc_hlen(tflags);
 		}
 		if (mtu < IPV6_MIN_MTU) {
@@ -1082,11 +1082,11 @@ ipvs_gre_encap(struct net *net, struct sk_buff *skb,
 {
 	__be16 proto = *next_protocol == IPPROTO_IPIP ?
 				htons(ETH_P_IP) : htons(ETH_P_IPV6);
-	__be16 tflags = 0;
+	IP_TUNNEL_DECLARE_FLAGS(tflags) = { };
 	size_t hdrlen;
 
 	if (cp->dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
-		tflags |= TUNNEL_CSUM;
+		__set_bit(IP_TUNNEL_CSUM_BIT, tflags);
 
 	hdrlen = gre_calc_hlen(tflags);
 	gre_build_header(skb, hdrlen, tflags, proto, 0, 0);
@@ -1165,11 +1165,11 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
 	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		IP_TUNNEL_DECLARE_FLAGS(tflags) = { };
 		size_t gre_hdrlen;
-		__be16 tflags = 0;
 
 		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
-			tflags |= TUNNEL_CSUM;
+			__set_bit(IP_TUNNEL_CSUM_BIT, tflags);
 		gre_hdrlen = gre_calc_hlen(tflags);
 
 		max_headroom += gre_hdrlen;
@@ -1309,11 +1309,11 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
 	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		IP_TUNNEL_DECLARE_FLAGS(tflags) = { };
 		size_t gre_hdrlen;
-		__be16 tflags = 0;
 
 		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
-			tflags |= TUNNEL_CSUM;
+			__set_bit(IP_TUNNEL_CSUM_BIT, tflags);
 		gre_hdrlen = gre_calc_hlen(tflags);
 
 		max_headroom += gre_hdrlen;
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index b059aa541798..21dd5a1293de 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -174,8 +174,8 @@ struct nft_tunnel_opts {
 		struct erspan_metadata	erspan;
 		u8	data[IP_TUNNEL_OPTS_MAX];
 	} u;
+	IP_TUNNEL_DECLARE_FLAGS(flags);
 	u32	len;
-	__be16	flags;
 };
 
 struct nft_tunnel_obj {
@@ -271,7 +271,8 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
 	opts->u.vxlan.gbp = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_VXLAN_GBP]));
 
 	opts->len	= sizeof(struct vxlan_metadata);
-	opts->flags	= TUNNEL_VXLAN_OPT;
+	bitmap_zero(opts->flags, __IP_TUNNEL_FLAG_NUM);
+	__set_bit(IP_TUNNEL_VXLAN_OPT_BIT, opts->flags);
 
 	return 0;
 }
@@ -325,7 +326,8 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
 	opts->u.erspan.version = version;
 
 	opts->len	= sizeof(struct erspan_metadata);
-	opts->flags	= TUNNEL_ERSPAN_OPT;
+	bitmap_zero(opts->flags, __IP_TUNNEL_FLAG_NUM);
+	__set_bit(IP_TUNNEL_ERSPAN_OPT_BIT, opts->flags);
 
 	return 0;
 }
@@ -366,7 +368,8 @@ static int nft_tunnel_obj_geneve_init(const struct nlattr *attr,
 	opt->length = data_len / 4;
 	opt->opt_class = nla_get_be16(tb[NFTA_TUNNEL_KEY_GENEVE_CLASS]);
 	opt->type = nla_get_u8(tb[NFTA_TUNNEL_KEY_GENEVE_TYPE]);
-	opts->flags = TUNNEL_GENEVE_OPT;
+	bitmap_zero(opts->flags, __IP_TUNNEL_FLAG_NUM);
+	__set_bit(IP_TUNNEL_GENEVE_OPT_BIT, opts->flags);
 
 	return 0;
 }
@@ -385,8 +388,8 @@ static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
 				    struct nft_tunnel_opts *opts)
 {
 	struct nlattr *nla;
-	__be16 type = 0;
 	int err, rem;
+	u32 type = 0;
 
 	err = nla_validate_nested_deprecated(attr, NFTA_TUNNEL_KEY_OPTS_MAX,
 					     nft_tunnel_opts_policy, NULL);
@@ -401,7 +404,7 @@ static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
 			err = nft_tunnel_obj_vxlan_init(nla, opts);
 			if (err)
 				return err;
-			type = TUNNEL_VXLAN_OPT;
+			type = IP_TUNNEL_VXLAN_OPT_BIT;
 			break;
 		case NFTA_TUNNEL_KEY_OPTS_ERSPAN:
 			if (type)
@@ -409,15 +412,15 @@ static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
 			err = nft_tunnel_obj_erspan_init(nla, opts);
 			if (err)
 				return err;
-			type = TUNNEL_ERSPAN_OPT;
+			type = IP_TUNNEL_ERSPAN_OPT_BIT;
 			break;
 		case NFTA_TUNNEL_KEY_OPTS_GENEVE:
-			if (type && type != TUNNEL_GENEVE_OPT)
+			if (type && type != IP_TUNNEL_GENEVE_OPT_BIT)
 				return -EINVAL;
 			err = nft_tunnel_obj_geneve_init(nla, opts);
 			if (err)
 				return err;
-			type = TUNNEL_GENEVE_OPT;
+			type = IP_TUNNEL_GENEVE_OPT_BIT;
 			break;
 		default:
 			return -EOPNOTSUPP;
@@ -454,7 +457,10 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
 	memset(&info, 0, sizeof(info));
 	info.mode		= IP_TUNNEL_INFO_TX;
 	info.key.tun_id		= key32_to_tunnel_id(nla_get_be32(tb[NFTA_TUNNEL_KEY_ID]));
-	info.key.tun_flags	= TUNNEL_KEY | TUNNEL_CSUM | TUNNEL_NOCACHE;
+	bitmap_zero(info.key.tun_flags, __IP_TUNNEL_FLAG_NUM);
+	__set_bit(IP_TUNNEL_KEY_BIT, info.key.tun_flags);
+	__set_bit(IP_TUNNEL_CSUM_BIT, info.key.tun_flags);
+	__set_bit(IP_TUNNEL_NOCACHE_BIT, info.key.tun_flags);
 
 	if (tb[NFTA_TUNNEL_KEY_IP]) {
 		err = nft_tunnel_obj_ip_init(ctx, tb[NFTA_TUNNEL_KEY_IP], &info);
@@ -483,11 +489,12 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
 			return -EOPNOTSUPP;
 
 		if (tun_flags & NFT_TUNNEL_F_ZERO_CSUM_TX)
-			info.key.tun_flags &= ~TUNNEL_CSUM;
+			__clear_bit(IP_TUNNEL_CSUM_BIT, info.key.tun_flags);
 		if (tun_flags & NFT_TUNNEL_F_DONT_FRAGMENT)
-			info.key.tun_flags |= TUNNEL_DONT_FRAGMENT;
+			__set_bit(IP_TUNNEL_DONT_FRAGMENT_BIT,
+				  info.key.tun_flags);
 		if (tun_flags & NFT_TUNNEL_F_SEQ_NUMBER)
-			info.key.tun_flags |= TUNNEL_SEQ;
+			__set_bit(IP_TUNNEL_SEQ_BIT, info.key.tun_flags);
 	}
 	if (tb[NFTA_TUNNEL_KEY_TOS])
 		info.key.tos = nla_get_u8(tb[NFTA_TUNNEL_KEY_TOS]);
@@ -583,7 +590,7 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 	if (!nest)
 		return -1;
 
-	if (opts->flags & TUNNEL_VXLAN_OPT) {
+	if (test_bit(IP_TUNNEL_VXLAN_OPT_BIT, opts->flags)) {
 		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_VXLAN);
 		if (!inner)
 			goto failure;
@@ -591,7 +598,7 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				 htonl(opts->u.vxlan.gbp)))
 			goto inner_failure;
 		nla_nest_end(skb, inner);
-	} else if (opts->flags & TUNNEL_ERSPAN_OPT) {
+	} else if (test_bit(IP_TUNNEL_ERSPAN_OPT_BIT, opts->flags)) {
 		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
 		if (!inner)
 			goto failure;
@@ -613,7 +620,7 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 			break;
 		}
 		nla_nest_end(skb, inner);
-	} else if (opts->flags & TUNNEL_GENEVE_OPT) {
+	} else if (test_bit(IP_TUNNEL_GENEVE_OPT_BIT, opts->flags)) {
 		struct geneve_opt *opt;
 		int offset = 0;
 
@@ -658,11 +665,11 @@ static int nft_tunnel_flags_dump(struct sk_buff *skb,
 {
 	u32 flags = 0;
 
-	if (info->key.tun_flags & TUNNEL_DONT_FRAGMENT)
+	if (test_bit(IP_TUNNEL_DONT_FRAGMENT_BIT, info->key.tun_flags))
 		flags |= NFT_TUNNEL_F_DONT_FRAGMENT;
-	if (!(info->key.tun_flags & TUNNEL_CSUM))
+	if (!test_bit(IP_TUNNEL_CSUM_BIT, info->key.tun_flags))
 		flags |= NFT_TUNNEL_F_ZERO_CSUM_TX;
-	if (info->key.tun_flags & TUNNEL_SEQ)
+	if (test_bit(IP_TUNNEL_SEQ_BIT, info->key.tun_flags))
 		flags |= NFT_TUNNEL_F_SEQ_NUMBER;
 
 	if (nla_put_be32(skb, NFTA_TUNNEL_KEY_FLAGS, htonl(flags)) < 0)
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index ead5418c126e..f64f1e16816f 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -667,8 +667,8 @@ static int ip_tun_from_nlattr(const struct nlattr *attr,
 			      bool log)
 {
 	bool ttl = false, ipv4 = false, ipv6 = false;
+	IP_TUNNEL_DECLARE_FLAGS(tun_flags) = { };
 	bool info_bridge_mode = false;
-	__be16 tun_flags = 0;
 	int opts_type = 0;
 	struct nlattr *a;
 	int rem;
@@ -694,7 +694,7 @@ static int ip_tun_from_nlattr(const struct nlattr *attr,
 		case OVS_TUNNEL_KEY_ATTR_ID:
 			SW_FLOW_KEY_PUT(match, tun_key.tun_id,
 					nla_get_be64(a), is_mask);
-			tun_flags |= TUNNEL_KEY;
+			__set_bit(IP_TUNNEL_KEY_BIT, tun_flags);
 			break;
 		case OVS_TUNNEL_KEY_ATTR_IPV4_SRC:
 			SW_FLOW_KEY_PUT(match, tun_key.u.ipv4.src,
@@ -726,10 +726,10 @@ static int ip_tun_from_nlattr(const struct nlattr *attr,
 			ttl = true;
 			break;
 		case OVS_TUNNEL_KEY_ATTR_DONT_FRAGMENT:
-			tun_flags |= TUNNEL_DONT_FRAGMENT;
+			__set_bit(IP_TUNNEL_DONT_FRAGMENT_BIT, tun_flags);
 			break;
 		case OVS_TUNNEL_KEY_ATTR_CSUM:
-			tun_flags |= TUNNEL_CSUM;
+			__set_bit(IP_TUNNEL_CSUM_BIT, tun_flags);
 			break;
 		case OVS_TUNNEL_KEY_ATTR_TP_SRC:
 			SW_FLOW_KEY_PUT(match, tun_key.tp_src,
@@ -740,7 +740,7 @@ static int ip_tun_from_nlattr(const struct nlattr *attr,
 					nla_get_be16(a), is_mask);
 			break;
 		case OVS_TUNNEL_KEY_ATTR_OAM:
-			tun_flags |= TUNNEL_OAM;
+			__set_bit(IP_TUNNEL_OAM_BIT, tun_flags);
 			break;
 		case OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS:
 			if (opts_type) {
@@ -752,7 +752,7 @@ static int ip_tun_from_nlattr(const struct nlattr *attr,
 			if (err)
 				return err;
 
-			tun_flags |= TUNNEL_GENEVE_OPT;
+			__set_bit(IP_TUNNEL_GENEVE_OPT_BIT, tun_flags);
 			opts_type = type;
 			break;
 		case OVS_TUNNEL_KEY_ATTR_VXLAN_OPTS:
@@ -765,7 +765,7 @@ static int ip_tun_from_nlattr(const struct nlattr *attr,
 			if (err)
 				return err;
 
-			tun_flags |= TUNNEL_VXLAN_OPT;
+			__set_bit(IP_TUNNEL_VXLAN_OPT_BIT, tun_flags);
 			opts_type = type;
 			break;
 		case OVS_TUNNEL_KEY_ATTR_PAD:
@@ -781,7 +781,7 @@ static int ip_tun_from_nlattr(const struct nlattr *attr,
 			if (err)
 				return err;
 
-			tun_flags |= TUNNEL_ERSPAN_OPT;
+			__set_bit(IP_TUNNEL_ERSPAN_OPT_BIT, tun_flags);
 			opts_type = type;
 			break;
 		case OVS_TUNNEL_KEY_ATTR_IPV4_INFO_BRIDGE:
@@ -795,7 +795,8 @@ static int ip_tun_from_nlattr(const struct nlattr *attr,
 		}
 	}
 
-	SW_FLOW_KEY_PUT(match, tun_key.tun_flags, tun_flags, is_mask);
+	SW_FLOW_KEY_MEMCPY(match, tun_key.tun_flags, tun_flags,
+			   sizeof(tun_flags), is_mask);
 	if (is_mask)
 		SW_FLOW_KEY_MEMSET_FIELD(match, tun_proto, 0xff, true);
 	else
@@ -820,13 +821,16 @@ static int ip_tun_from_nlattr(const struct nlattr *attr,
 		}
 		if (ipv4) {
 			if (info_bridge_mode) {
+				__clear_bit(IP_TUNNEL_KEY_BIT, tun_flags);
+
 				if (match->key->tun_key.u.ipv4.src ||
 				    match->key->tun_key.u.ipv4.dst ||
 				    match->key->tun_key.tp_src ||
 				    match->key->tun_key.tp_dst ||
 				    match->key->tun_key.ttl ||
 				    match->key->tun_key.tos ||
-				    tun_flags & ~TUNNEL_KEY) {
+				    !bitmap_empty(tun_flags,
+						  __IP_TUNNEL_FLAG_NUM)) {
 					OVS_NLERR(log, "IPv4 tun info is not correct");
 					return -EINVAL;
 				}
@@ -871,7 +875,7 @@ static int __ip_tun_to_nlattr(struct sk_buff *skb,
 			      const void *tun_opts, int swkey_tun_opts_len,
 			      unsigned short tun_proto, u8 mode)
 {
-	if (output->tun_flags & TUNNEL_KEY &&
+	if (test_bit(IP_TUNNEL_KEY_BIT, output->tun_flags) &&
 	    nla_put_be64(skb, OVS_TUNNEL_KEY_ATTR_ID, output->tun_id,
 			 OVS_TUNNEL_KEY_ATTR_PAD))
 		return -EMSGSIZE;
@@ -907,10 +911,10 @@ static int __ip_tun_to_nlattr(struct sk_buff *skb,
 		return -EMSGSIZE;
 	if (nla_put_u8(skb, OVS_TUNNEL_KEY_ATTR_TTL, output->ttl))
 		return -EMSGSIZE;
-	if ((output->tun_flags & TUNNEL_DONT_FRAGMENT) &&
+	if (test_bit(IP_TUNNEL_DONT_FRAGMENT_BIT, output->tun_flags) &&
 	    nla_put_flag(skb, OVS_TUNNEL_KEY_ATTR_DONT_FRAGMENT))
 		return -EMSGSIZE;
-	if ((output->tun_flags & TUNNEL_CSUM) &&
+	if (test_bit(IP_TUNNEL_CSUM_BIT, output->tun_flags) &&
 	    nla_put_flag(skb, OVS_TUNNEL_KEY_ATTR_CSUM))
 		return -EMSGSIZE;
 	if (output->tp_src &&
@@ -919,18 +923,20 @@ static int __ip_tun_to_nlattr(struct sk_buff *skb,
 	if (output->tp_dst &&
 	    nla_put_be16(skb, OVS_TUNNEL_KEY_ATTR_TP_DST, output->tp_dst))
 		return -EMSGSIZE;
-	if ((output->tun_flags & TUNNEL_OAM) &&
+	if (test_bit(IP_TUNNEL_OAM_BIT, output->tun_flags) &&
 	    nla_put_flag(skb, OVS_TUNNEL_KEY_ATTR_OAM))
 		return -EMSGSIZE;
 	if (swkey_tun_opts_len) {
-		if (output->tun_flags & TUNNEL_GENEVE_OPT &&
+		if (test_bit(IP_TUNNEL_GENEVE_OPT_BIT, output->tun_flags) &&
 		    nla_put(skb, OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS,
 			    swkey_tun_opts_len, tun_opts))
 			return -EMSGSIZE;
-		else if (output->tun_flags & TUNNEL_VXLAN_OPT &&
+		else if (test_bit(IP_TUNNEL_VXLAN_OPT_BIT,
+				  output->tun_flags) &&
 			 vxlan_opt_to_nlattr(skb, tun_opts, swkey_tun_opts_len))
 			return -EMSGSIZE;
-		else if (output->tun_flags & TUNNEL_ERSPAN_OPT &&
+		else if (test_bit(IP_TUNNEL_ERSPAN_OPT_BIT,
+				  output->tun_flags) &&
 			 nla_put(skb, OVS_TUNNEL_KEY_ATTR_ERSPAN_OPTS,
 				 swkey_tun_opts_len, tun_opts))
 			return -EMSGSIZE;
@@ -2026,7 +2032,7 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 	if ((swkey->tun_proto || is_mask)) {
 		const void *opts = NULL;
 
-		if (output->tun_key.tun_flags & TUNNEL_OPTIONS_PRESENT)
+		if (ip_tunnel_is_options_present(output->tun_key.tun_flags))
 			opts = TUN_METADATA_OPTS(output, swkey->tun_opts_len);
 
 		if (ip_tun_to_nlattr(skb, &output->tun_key, opts,
@@ -2742,7 +2748,8 @@ static int validate_geneve_opts(struct sw_flow_key *key)
 		opts_len -= len;
 	}
 
-	key->tun_key.tun_flags |= crit_opt ? TUNNEL_CRIT_OPT : 0;
+	if (crit_opt)
+		__set_bit(IP_TUNNEL_CRIT_OPT_BIT, key->tun_key.tun_flags);
 
 	return 0;
 }
@@ -2750,6 +2757,7 @@ static int validate_geneve_opts(struct sw_flow_key *key)
 static int validate_and_copy_set_tun(const struct nlattr *attr,
 				     struct sw_flow_actions **sfa, bool log)
 {
+	IP_TUNNEL_DECLARE_FLAGS(dst_opt_type) = { };
 	struct sw_flow_match match;
 	struct sw_flow_key key;
 	struct metadata_dst *tun_dst;
@@ -2757,9 +2765,7 @@ static int validate_and_copy_set_tun(const struct nlattr *attr,
 	struct ovs_tunnel_info *ovs_tun;
 	struct nlattr *a;
 	int err = 0, start, opts_type;
-	__be16 dst_opt_type;
 
-	dst_opt_type = 0;
 	ovs_match_init(&match, &key, true, NULL);
 	opts_type = ip_tun_from_nlattr(nla_data(attr), &match, false, log);
 	if (opts_type < 0)
@@ -2771,13 +2777,14 @@ static int validate_and_copy_set_tun(const struct nlattr *attr,
 			err = validate_geneve_opts(&key);
 			if (err < 0)
 				return err;
-			dst_opt_type = TUNNEL_GENEVE_OPT;
+
+			__set_bit(IP_TUNNEL_GENEVE_OPT_BIT, dst_opt_type);
 			break;
 		case OVS_TUNNEL_KEY_ATTR_VXLAN_OPTS:
-			dst_opt_type = TUNNEL_VXLAN_OPT;
+			__set_bit(IP_TUNNEL_VXLAN_OPT_BIT, dst_opt_type);
 			break;
 		case OVS_TUNNEL_KEY_ATTR_ERSPAN_OPTS:
-			dst_opt_type = TUNNEL_ERSPAN_OPT;
+			__set_bit(IP_TUNNEL_ERSPAN_OPT_BIT, dst_opt_type);
 			break;
 		}
 	}
diff --git a/net/psample/psample.c b/net/psample/psample.c
index 81a794e36f53..3fc90dfc1fdd 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -220,7 +220,7 @@ static int __psample_ip_tun_to_nlattr(struct sk_buff *skb,
 	const struct ip_tunnel_key *tun_key = &tun_info->key;
 	int tun_opts_len = tun_info->options_len;
 
-	if (tun_key->tun_flags & TUNNEL_KEY &&
+	if (test_bit(IP_TUNNEL_KEY_BIT, tun_key->tun_flags) &&
 	    nla_put_be64(skb, PSAMPLE_TUNNEL_KEY_ATTR_ID, tun_key->tun_id,
 			 PSAMPLE_TUNNEL_KEY_ATTR_PAD))
 		return -EMSGSIZE;
@@ -256,10 +256,10 @@ static int __psample_ip_tun_to_nlattr(struct sk_buff *skb,
 		return -EMSGSIZE;
 	if (nla_put_u8(skb, PSAMPLE_TUNNEL_KEY_ATTR_TTL, tun_key->ttl))
 		return -EMSGSIZE;
-	if ((tun_key->tun_flags & TUNNEL_DONT_FRAGMENT) &&
+	if (test_bit(IP_TUNNEL_DONT_FRAGMENT_BIT, tun_key->tun_flags) &&
 	    nla_put_flag(skb, PSAMPLE_TUNNEL_KEY_ATTR_DONT_FRAGMENT))
 		return -EMSGSIZE;
-	if ((tun_key->tun_flags & TUNNEL_CSUM) &&
+	if (test_bit(IP_TUNNEL_CSUM_BIT, tun_key->tun_flags) &&
 	    nla_put_flag(skb, PSAMPLE_TUNNEL_KEY_ATTR_CSUM))
 		return -EMSGSIZE;
 	if (tun_key->tp_src &&
@@ -268,15 +268,16 @@ static int __psample_ip_tun_to_nlattr(struct sk_buff *skb,
 	if (tun_key->tp_dst &&
 	    nla_put_be16(skb, PSAMPLE_TUNNEL_KEY_ATTR_TP_DST, tun_key->tp_dst))
 		return -EMSGSIZE;
-	if ((tun_key->tun_flags & TUNNEL_OAM) &&
+	if (test_bit(IP_TUNNEL_OAM_BIT, tun_key->tun_flags) &&
 	    nla_put_flag(skb, PSAMPLE_TUNNEL_KEY_ATTR_OAM))
 		return -EMSGSIZE;
 	if (tun_opts_len) {
-		if (tun_key->tun_flags & TUNNEL_GENEVE_OPT &&
+		if (test_bit(IP_TUNNEL_GENEVE_OPT_BIT, tun_key->tun_flags) &&
 		    nla_put(skb, PSAMPLE_TUNNEL_KEY_ATTR_GENEVE_OPTS,
 			    tun_opts_len, tun_opts))
 			return -EMSGSIZE;
-		else if (tun_key->tun_flags & TUNNEL_ERSPAN_OPT &&
+		else if (test_bit(IP_TUNNEL_ERSPAN_OPT_BIT,
+				  tun_key->tun_flags) &&
 			 nla_put(skb, PSAMPLE_TUNNEL_KEY_ATTR_ERSPAN_OPTS,
 				 tun_opts_len, tun_opts))
 			return -EMSGSIZE;
@@ -313,7 +314,7 @@ static int psample_tunnel_meta_len(struct ip_tunnel_info *tun_info)
 	int tun_opts_len = tun_info->options_len;
 	int sum = nla_total_size(0);	/* PSAMPLE_ATTR_TUNNEL */
 
-	if (tun_key->tun_flags & TUNNEL_KEY)
+	if (test_bit(IP_TUNNEL_KEY_BIT, tun_key->tun_flags))
 		sum += nla_total_size_64bit(sizeof(u64));
 
 	if (tun_info->mode & IP_TUNNEL_INFO_BRIDGE)
@@ -336,20 +337,21 @@ static int psample_tunnel_meta_len(struct ip_tunnel_info *tun_info)
 	if (tun_key->tos)
 		sum += nla_total_size(sizeof(u8));
 	sum += nla_total_size(sizeof(u8));	/* TTL */
-	if (tun_key->tun_flags & TUNNEL_DONT_FRAGMENT)
+	if (test_bit(IP_TUNNEL_DONT_FRAGMENT_BIT, tun_key->tun_flags))
 		sum += nla_total_size(0);
-	if (tun_key->tun_flags & TUNNEL_CSUM)
+	if (test_bit(IP_TUNNEL_CSUM_BIT, tun_key->tun_flags))
 		sum += nla_total_size(0);
 	if (tun_key->tp_src)
 		sum += nla_total_size(sizeof(u16));
 	if (tun_key->tp_dst)
 		sum += nla_total_size(sizeof(u16));
-	if (tun_key->tun_flags & TUNNEL_OAM)
+	if (test_bit(IP_TUNNEL_OAM_BIT, tun_key->tun_flags))
 		sum += nla_total_size(0);
 	if (tun_opts_len) {
-		if (tun_key->tun_flags & TUNNEL_GENEVE_OPT)
+		if (test_bit(IP_TUNNEL_GENEVE_OPT_BIT, tun_key->tun_flags))
 			sum += nla_total_size(tun_opts_len);
-		else if (tun_key->tun_flags & TUNNEL_ERSPAN_OPT)
+		else if (test_bit(IP_TUNNEL_ERSPAN_OPT_BIT,
+				  tun_key->tun_flags))
 			sum += nla_total_size(tun_opts_len);
 	}
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 0c8aa7e686ea..8a081a1b3274 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -219,8 +219,9 @@ tunnel_key_copy_erspan_opt(const struct nlattr *nla, void *dst, int dst_len,
 static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 				int dst_len, struct netlink_ext_ack *extack)
 {
-	int err, rem, opt_len, len = nla_len(nla), opts_len = 0, type = 0;
+	int err, rem, opt_len, len = nla_len(nla), opts_len = 0;
 	const struct nlattr *attr, *head = nla_data(nla);
+	u32 type = 0;
 
 	err = nla_validate_deprecated(head, len, TCA_TUNNEL_KEY_ENC_OPTS_MAX,
 				      enc_opts_policy, extack);
@@ -230,7 +231,7 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 	nla_for_each_attr(attr, head, len, rem) {
 		switch (nla_type(attr)) {
 		case TCA_TUNNEL_KEY_ENC_OPTS_GENEVE:
-			if (type && type != TUNNEL_GENEVE_OPT) {
+			if (type && type != IP_TUNNEL_GENEVE_OPT_BIT) {
 				NL_SET_ERR_MSG(extack, "Duplicate type for geneve options");
 				return -EINVAL;
 			}
@@ -247,7 +248,7 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 				dst_len -= opt_len;
 				dst += opt_len;
 			}
-			type = TUNNEL_GENEVE_OPT;
+			type = IP_TUNNEL_GENEVE_OPT_BIT;
 			break;
 		case TCA_TUNNEL_KEY_ENC_OPTS_VXLAN:
 			if (type) {
@@ -259,7 +260,7 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 			if (opt_len < 0)
 				return opt_len;
 			opts_len += opt_len;
-			type = TUNNEL_VXLAN_OPT;
+			type = IP_TUNNEL_VXLAN_OPT_BIT;
 			break;
 		case TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN:
 			if (type) {
@@ -271,7 +272,7 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 			if (opt_len < 0)
 				return opt_len;
 			opts_len += opt_len;
-			type = TUNNEL_ERSPAN_OPT;
+			type = IP_TUNNEL_ERSPAN_OPT_BIT;
 			break;
 		}
 	}
@@ -302,7 +303,7 @@ static int tunnel_key_opts_set(struct nlattr *nla, struct ip_tunnel_info *info,
 	switch (nla_type(nla_data(nla))) {
 	case TCA_TUNNEL_KEY_ENC_OPTS_GENEVE:
 #if IS_ENABLED(CONFIG_INET)
-		info->key.tun_flags |= TUNNEL_GENEVE_OPT;
+		__set_bit(IP_TUNNEL_GENEVE_OPT_BIT, info->key.tun_flags);
 		return tunnel_key_copy_opts(nla, ip_tunnel_info_opts(info),
 					    opts_len, extack);
 #else
@@ -310,7 +311,7 @@ static int tunnel_key_opts_set(struct nlattr *nla, struct ip_tunnel_info *info,
 #endif
 	case TCA_TUNNEL_KEY_ENC_OPTS_VXLAN:
 #if IS_ENABLED(CONFIG_INET)
-		info->key.tun_flags |= TUNNEL_VXLAN_OPT;
+		__set_bit(IP_TUNNEL_VXLAN_OPT_BIT, info->key.tun_flags);
 		return tunnel_key_copy_opts(nla, ip_tunnel_info_opts(info),
 					    opts_len, extack);
 #else
@@ -318,7 +319,7 @@ static int tunnel_key_opts_set(struct nlattr *nla, struct ip_tunnel_info *info,
 #endif
 	case TCA_TUNNEL_KEY_ENC_OPTS_ERSPAN:
 #if IS_ENABLED(CONFIG_INET)
-		info->key.tun_flags |= TUNNEL_ERSPAN_OPT;
+		__set_bit(IP_TUNNEL_ERSPAN_OPT_BIT, info->key.tun_flags);
 		return tunnel_key_copy_opts(nla, ip_tunnel_info_opts(info),
 					    opts_len, extack);
 #else
@@ -363,6 +364,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	bool bind = act_flags & TCA_ACT_FLAGS_BIND;
 	struct nlattr *tb[TCA_TUNNEL_KEY_MAX + 1];
 	struct tcf_tunnel_key_params *params_new;
+	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 	struct metadata_dst *metadata = NULL;
 	struct tcf_chain *goto_ch = NULL;
 	struct tc_tunnel_key *parm;
@@ -371,7 +373,6 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	__be16 dst_port = 0;
 	__be64 key_id = 0;
 	int opts_len = 0;
-	__be16 flags = 0;
 	u8 tos, ttl;
 	int ret = 0;
 	u32 index;
@@ -412,16 +413,16 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 
 			key32 = nla_get_be32(tb[TCA_TUNNEL_KEY_ENC_KEY_ID]);
 			key_id = key32_to_tunnel_id(key32);
-			flags = TUNNEL_KEY;
+			__set_bit(IP_TUNNEL_KEY_BIT, flags);
 		}
 
-		flags |= TUNNEL_CSUM;
+		__set_bit(IP_TUNNEL_CSUM_BIT, flags);
 		if (tb[TCA_TUNNEL_KEY_NO_CSUM] &&
 		    nla_get_u8(tb[TCA_TUNNEL_KEY_NO_CSUM]))
-			flags &= ~TUNNEL_CSUM;
+			__clear_bit(IP_TUNNEL_CSUM_BIT, flags);
 
 		if (nla_get_flag(tb[TCA_TUNNEL_KEY_NO_FRAG]))
-			flags |= TUNNEL_DONT_FRAGMENT;
+			__set_bit(IP_TUNNEL_DONT_FRAGMENT_BIT, flags);
 
 		if (tb[TCA_TUNNEL_KEY_ENC_DST_PORT])
 			dst_port = nla_get_be16(tb[TCA_TUNNEL_KEY_ENC_DST_PORT]);
@@ -663,15 +664,15 @@ static int tunnel_key_opts_dump(struct sk_buff *skb,
 	if (!start)
 		return -EMSGSIZE;
 
-	if (info->key.tun_flags & TUNNEL_GENEVE_OPT) {
+	if (test_bit(IP_TUNNEL_GENEVE_OPT_BIT, info->key.tun_flags)) {
 		err = tunnel_key_geneve_opts_dump(skb, info);
 		if (err)
 			goto err_out;
-	} else if (info->key.tun_flags & TUNNEL_VXLAN_OPT) {
+	} else if (test_bit(IP_TUNNEL_VXLAN_OPT_BIT, info->key.tun_flags)) {
 		err = tunnel_key_vxlan_opts_dump(skb, info);
 		if (err)
 			goto err_out;
-	} else if (info->key.tun_flags & TUNNEL_ERSPAN_OPT) {
+	} else if (test_bit(IP_TUNNEL_ERSPAN_OPT_BIT, info->key.tun_flags)) {
 		err = tunnel_key_erspan_opts_dump(skb, info);
 		if (err)
 			goto err_out;
@@ -741,7 +742,7 @@ static int tunnel_key_dump(struct sk_buff *skb, struct tc_action *a,
 		struct ip_tunnel_key *key = &info->key;
 		__be32 key_id = tunnel_id_to_key32(key->tun_id);
 
-		if (((key->tun_flags & TUNNEL_KEY) &&
+		if ((test_bit(IP_TUNNEL_KEY_BIT, key->tun_flags) &&
 		     nla_put_be32(skb, TCA_TUNNEL_KEY_ENC_KEY_ID, key_id)) ||
 		    tunnel_key_dump_addresses(skb,
 					      &params->tcft_enc_metadata->u.tun_info) ||
@@ -749,8 +750,8 @@ static int tunnel_key_dump(struct sk_buff *skb, struct tc_action *a,
 		      nla_put_be16(skb, TCA_TUNNEL_KEY_ENC_DST_PORT,
 				   key->tp_dst)) ||
 		    nla_put_u8(skb, TCA_TUNNEL_KEY_NO_CSUM,
-			       !(key->tun_flags & TUNNEL_CSUM)) ||
-		    ((key->tun_flags & TUNNEL_DONT_FRAGMENT) &&
+			       !test_bit(IP_TUNNEL_CSUM_BIT, key->tun_flags)) ||
+		    (test_bit(IP_TUNNEL_DONT_FRAGMENT_BIT, key->tun_flags) &&
 		     nla_put_flag(skb, TCA_TUNNEL_KEY_NO_FRAG)) ||
 		    tunnel_key_opts_dump(skb, info))
 			goto nla_put_failure;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 04adcde9eb81..8994c6fd547d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1410,12 +1410,13 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 		switch (nla_type(nla_opt_key)) {
 		case TCA_FLOWER_KEY_ENC_OPTS_GENEVE:
 			if (key->enc_opts.dst_opt_type &&
-			    key->enc_opts.dst_opt_type != TUNNEL_GENEVE_OPT) {
+			    key->enc_opts.dst_opt_type !=
+			    IP_TUNNEL_GENEVE_OPT_BIT) {
 				NL_SET_ERR_MSG(extack, "Duplicate type for geneve options");
 				return -EINVAL;
 			}
 			option_len = 0;
-			key->enc_opts.dst_opt_type = TUNNEL_GENEVE_OPT;
+			key->enc_opts.dst_opt_type = IP_TUNNEL_GENEVE_OPT_BIT;
 			option_len = fl_set_geneve_opt(nla_opt_key, key,
 						       key_depth, option_len,
 						       extack);
@@ -1426,7 +1427,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			/* At the same time we need to parse through the mask
 			 * in order to verify exact and mask attribute lengths.
 			 */
-			mask->enc_opts.dst_opt_type = TUNNEL_GENEVE_OPT;
+			mask->enc_opts.dst_opt_type = IP_TUNNEL_GENEVE_OPT_BIT;
 			option_len = fl_set_geneve_opt(nla_opt_msk, mask,
 						       msk_depth, option_len,
 						       extack);
@@ -1445,7 +1446,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 				return -EINVAL;
 			}
 			option_len = 0;
-			key->enc_opts.dst_opt_type = TUNNEL_VXLAN_OPT;
+			key->enc_opts.dst_opt_type = IP_TUNNEL_VXLAN_OPT_BIT;
 			option_len = fl_set_vxlan_opt(nla_opt_key, key,
 						      key_depth, option_len,
 						      extack);
@@ -1456,7 +1457,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			/* At the same time we need to parse through the mask
 			 * in order to verify exact and mask attribute lengths.
 			 */
-			mask->enc_opts.dst_opt_type = TUNNEL_VXLAN_OPT;
+			mask->enc_opts.dst_opt_type = IP_TUNNEL_VXLAN_OPT_BIT;
 			option_len = fl_set_vxlan_opt(nla_opt_msk, mask,
 						      msk_depth, option_len,
 						      extack);
@@ -1475,7 +1476,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 				return -EINVAL;
 			}
 			option_len = 0;
-			key->enc_opts.dst_opt_type = TUNNEL_ERSPAN_OPT;
+			key->enc_opts.dst_opt_type = IP_TUNNEL_ERSPAN_OPT_BIT;
 			option_len = fl_set_erspan_opt(nla_opt_key, key,
 						       key_depth, option_len,
 						       extack);
@@ -1486,7 +1487,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			/* At the same time we need to parse through the mask
 			 * in order to verify exact and mask attribute lengths.
 			 */
-			mask->enc_opts.dst_opt_type = TUNNEL_ERSPAN_OPT;
+			mask->enc_opts.dst_opt_type = IP_TUNNEL_ERSPAN_OPT_BIT;
 			option_len = fl_set_erspan_opt(nla_opt_msk, mask,
 						       msk_depth, option_len,
 						       extack);
@@ -1506,7 +1507,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 				return -EINVAL;
 			}
 			option_len = 0;
-			key->enc_opts.dst_opt_type = TUNNEL_GTP_OPT;
+			key->enc_opts.dst_opt_type = IP_TUNNEL_GTP_OPT_BIT;
 			option_len = fl_set_gtp_opt(nla_opt_key, key,
 						    key_depth, option_len,
 						    extack);
@@ -1517,7 +1518,7 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 			/* At the same time we need to parse through the mask
 			 * in order to verify exact and mask attribute lengths.
 			 */
-			mask->enc_opts.dst_opt_type = TUNNEL_GTP_OPT;
+			mask->enc_opts.dst_opt_type = IP_TUNNEL_GTP_OPT_BIT;
 			option_len = fl_set_gtp_opt(nla_opt_msk, mask,
 						    msk_depth, option_len,
 						    extack);
@@ -3040,22 +3041,22 @@ static int fl_dump_key_options(struct sk_buff *skb, int enc_opt_type,
 		goto nla_put_failure;
 
 	switch (enc_opts->dst_opt_type) {
-	case TUNNEL_GENEVE_OPT:
+	case IP_TUNNEL_GENEVE_OPT_BIT:
 		err = fl_dump_key_geneve_opt(skb, enc_opts);
 		if (err)
 			goto nla_put_failure;
 		break;
-	case TUNNEL_VXLAN_OPT:
+	case IP_TUNNEL_VXLAN_OPT_BIT:
 		err = fl_dump_key_vxlan_opt(skb, enc_opts);
 		if (err)
 			goto nla_put_failure;
 		break;
-	case TUNNEL_ERSPAN_OPT:
+	case IP_TUNNEL_ERSPAN_OPT_BIT:
 		err = fl_dump_key_erspan_opt(skb, enc_opts);
 		if (err)
 			goto nla_put_failure;
 		break;
-	case TUNNEL_GTP_OPT:
+	case IP_TUNNEL_GTP_OPT_BIT:
 		err = fl_dump_key_gtp_opt(skb, enc_opts);
 		if (err)
 			goto nla_put_failure;
-- 
2.31.1


