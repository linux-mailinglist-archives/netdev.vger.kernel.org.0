Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F9E33A4B0
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhCNMUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:20:51 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:60677 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235310AbhCNMUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:20:19 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1FA655808BA;
        Sun, 14 Mar 2021 08:20:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:20:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=EliAXeL7B1i8jSyzgOYvlb3tLKJUPJJQOPLLTSnFims=; b=c0RbyJqC
        DBr4aKMQBwik7lGMVLVDC/fUWXUuy42GEHfoy1ghNftAXyU6rPnX+xEoEa0AMuMY
        4AM9zOSDURG/KpuJZm3c1W89r1i2kCqWeOfP/EGDz065z+I9F2ZytilhHETUOTBR
        QBnH1xDNlTQtvCv8kiFxW8TP1Qf3032PZS9knUbD7fo45+RmKGkLkTRqkpZlqJyH
        3i0jZ4AVNcaGVsg39FGHfLmZubvnZaLvNEdvGBskJnsYcyOVyzct8NWgOh7+oESL
        IXSQlNUjnlIbl1yjm0QbGIG7H4jatjJz4I1u7KQRffreeSDxih+VOyGQRrLkE1/F
        4bUzi8MX3sV5gg==
X-ME-Sender: <xms:g_9NYLHMXbQuWCp1eph7u9AF6rk_4OXB-sYjE8lJP5ogIhdYYkmjBQ>
    <xme:g_9NYIVJ-YqeMHvaRrWScpo_iTV30u0h11Zoh28RhqE5NU4j9LmWLzLMixFvW9uVY
    l1snylJi8rhBX0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:g_9NYNIjLjiTa5GHovI8rPRGCWPjZqjOvxJIJRxVE_xnQDJveNp_HA>
    <xmx:g_9NYJFYT8ZbFRBkyIV2QVKXyK3mvdjZrpCKibnBvqXy0KZ1KXMirQ>
    <xmx:g_9NYBXASlnE2XMADvkz54GM7VmZwSGDb3sVga1RT1bg2ec_kl05Zg>
    <xmx:g_9NYNqk1dJzGJIlukkP2ytl-2DdsWZB22MOZwCdjO4TmzcjPLXoAg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6A992240057;
        Sun, 14 Mar 2021 08:20:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        yotam.gi@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/11] psample: Encapsulate packet metadata in a struct
Date:   Sun, 14 Mar 2021 14:19:30 +0200
Message-Id: <20210314121940.2807621-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314121940.2807621-1-idosch@idosch.org>
References: <20210314121940.2807621-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, callers of psample_sample_packet() pass three metadata
attributes: Ingress port, egress port and truncated size. Subsequent
patches are going to add more attributes (e.g., egress queue occupancy),
which also need an indication whether they are valid or not.

Encapsulate packet metadata in a struct in order to keep the number of
arguments reasonable.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |  8 ++++----
 include/net/psample.h                          | 14 +++++++++-----
 net/psample/psample.c                          |  6 ++++--
 net/sched/act_sample.c                         | 16 ++++++----------
 4 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 93b15b8c007e..3b15f8d728a3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2217,7 +2217,7 @@ void mlxsw_sp_sample_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	struct mlxsw_sp_port_sample *sample;
-	u32 size;
+	struct psample_metadata md = {};
 
 	if (unlikely(!mlxsw_sp_port)) {
 		dev_warn_ratelimited(mlxsw_sp->bus_info->dev, "Port %d: sample skb received for non-existent port\n",
@@ -2229,9 +2229,9 @@ void mlxsw_sp_sample_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 	sample = rcu_dereference(mlxsw_sp_port->sample);
 	if (!sample)
 		goto out_unlock;
-	size = sample->truncate ? sample->trunc_size : skb->len;
-	psample_sample_packet(sample->psample_group, skb, size,
-			      mlxsw_sp_port->dev->ifindex, 0, sample->rate);
+	md.trunc_size = sample->truncate ? sample->trunc_size : skb->len;
+	md.in_ifindex = mlxsw_sp_port->dev->ifindex;
+	psample_sample_packet(sample->psample_group, skb, sample->rate, &md);
 out_unlock:
 	rcu_read_unlock();
 out:
diff --git a/include/net/psample.h b/include/net/psample.h
index 68ae16bb0a4a..ac6dbfb3870d 100644
--- a/include/net/psample.h
+++ b/include/net/psample.h
@@ -14,6 +14,12 @@ struct psample_group {
 	struct rcu_head rcu;
 };
 
+struct psample_metadata {
+	u32 trunc_size;
+	int in_ifindex;
+	int out_ifindex;
+};
+
 struct psample_group *psample_group_get(struct net *net, u32 group_num);
 void psample_group_take(struct psample_group *group);
 void psample_group_put(struct psample_group *group);
@@ -21,15 +27,13 @@ void psample_group_put(struct psample_group *group);
 #if IS_ENABLED(CONFIG_PSAMPLE)
 
 void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
-			   u32 trunc_size, int in_ifindex, int out_ifindex,
-			   u32 sample_rate);
+			   u32 sample_rate, const struct psample_metadata *md);
 
 #else
 
 static inline void psample_sample_packet(struct psample_group *group,
-					 struct sk_buff *skb, u32 trunc_size,
-					 int in_ifindex, int out_ifindex,
-					 u32 sample_rate)
+					 struct sk_buff *skb, u32 sample_rate,
+					 const struct psample_metadata *md)
 {
 }
 
diff --git a/net/psample/psample.c b/net/psample/psample.c
index 482c07f2766b..065bc887d239 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -356,9 +356,11 @@ static int psample_tunnel_meta_len(struct ip_tunnel_info *tun_info)
 #endif
 
 void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
-			   u32 trunc_size, int in_ifindex, int out_ifindex,
-			   u32 sample_rate)
+			   u32 sample_rate, const struct psample_metadata *md)
 {
+	int out_ifindex = md->out_ifindex;
+	int in_ifindex = md->in_ifindex;
+	u32 trunc_size = md->trunc_size;
 #ifdef CONFIG_INET
 	struct ip_tunnel_info *tun_info;
 #endif
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index db8ee9e5c8c2..6a0c16e4351d 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -158,10 +158,8 @@ static int tcf_sample_act(struct sk_buff *skb, const struct tc_action *a,
 {
 	struct tcf_sample *s = to_sample(a);
 	struct psample_group *psample_group;
+	struct psample_metadata md = {};
 	int retval;
-	int size;
-	int iif;
-	int oif;
 
 	tcf_lastuse_update(&s->tcf_tm);
 	bstats_cpu_update(this_cpu_ptr(s->common.cpu_bstats), skb);
@@ -172,20 +170,18 @@ static int tcf_sample_act(struct sk_buff *skb, const struct tc_action *a,
 	/* randomly sample packets according to rate */
 	if (psample_group && (prandom_u32() % s->rate == 0)) {
 		if (!skb_at_tc_ingress(skb)) {
-			iif = skb->skb_iif;
-			oif = skb->dev->ifindex;
+			md.in_ifindex = skb->skb_iif;
+			md.out_ifindex = skb->dev->ifindex;
 		} else {
-			iif = skb->dev->ifindex;
-			oif = 0;
+			md.in_ifindex = skb->dev->ifindex;
 		}
 
 		/* on ingress, the mac header gets popped, so push it back */
 		if (skb_at_tc_ingress(skb) && tcf_sample_dev_ok_push(skb->dev))
 			skb_push(skb, skb->mac_len);
 
-		size = s->truncate ? s->trunc_size : skb->len;
-		psample_sample_packet(psample_group, skb, size, iif, oif,
-				      s->rate);
+		md.trunc_size = s->truncate ? s->trunc_size : skb->len;
+		psample_sample_packet(psample_group, skb, s->rate, &md);
 
 		if (skb_at_tc_ingress(skb) && tcf_sample_dev_ok_push(skb->dev))
 			skb_pull(skb, skb->mac_len);
-- 
2.29.2

