Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E713B60E204
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbiJZNWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiJZNWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:22:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A1912AB8
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:22:25 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666790543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S7h/xEUlVT+1Sszjr4kXpQk+TDp4K6BxE9IuveEklEU=;
        b=REY43BBVnqorjQmFZmBo+MpK2yJAX7Nd2PCbrC1qGO7Sr/OtBjeJPTumIGinq1KEPvpxTp
        oh+eqDtUL3IYqMUGYC1QWHAmTIUunY3siWFUeNQw7vDXo8m3kdbxjcSY4s+vMY+Krz/1a1
        oPZr37ihuTAbkCFo9JZpBaHrzTL7YXCE20ZMI+ZIGvOU6PKIlzKSet+kkoupawMVI+Y2uF
        vnl/+VzNf/p0ojMKjl8p/pKTb3TzgNx9pCL9DzmBTT68A87A1qzPPGAzGAXYOWUDiIzxpn
        k65HvcGe4u8zKFTd95o+qx0iQeuDCJGT2z7is3tGg7WTgdTTIXjIls2ofnFFTA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666790543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S7h/xEUlVT+1Sszjr4kXpQk+TDp4K6BxE9IuveEklEU=;
        b=Yy+xufqbkYyKYTCOnjiDtHM6f+O916n8GotgZezSJ9IBPRmQVhhUmmyxigoTsuaO45GjuW
        OEcxFqvUcvpVJeDA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH net-next 2/2] net: Remove the obsolte u64_stats_fetch_*_irq() users (net).
Date:   Wed, 26 Oct 2022 15:22:15 +0200
Message-Id: <20221026132215.696950-3-bigeasy@linutronix.de>
In-Reply-To: <20221026132215.696950-1-bigeasy@linutronix.de>
References: <20221026132215.696950-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Now that the 32bit UP oddity is gone and 32bit uses always a sequence
count, there is no need for the fetch_irq() variants anymore.

Convert to the regular interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 net/8021q/vlan_dev.c           |  4 ++--
 net/bridge/br_multicast.c      |  4 ++--
 net/bridge/br_vlan.c           |  4 ++--
 net/core/dev.c                 |  4 ++--
 net/core/devlink.c             |  4 ++--
 net/core/drop_monitor.c        |  8 ++++----
 net/core/gen_stats.c           | 16 ++++++++--------
 net/dsa/slave.c                |  4 ++--
 net/ipv4/af_inet.c             |  4 ++--
 net/ipv6/seg6_local.c          |  4 ++--
 net/mac80211/sta_info.c        |  8 ++++----
 net/mpls/af_mpls.c             |  4 ++--
 net/netfilter/ipvs/ip_vs_ctl.c |  4 ++--
 net/netfilter/nf_tables_api.c  |  4 ++--
 net/openvswitch/datapath.c     |  4 ++--
 net/openvswitch/flow_table.c   |  9 ++++-----
 16 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index e1bb41a443c43..296d0145932f4 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -712,13 +712,13 @@ static void vlan_dev_get_stats64(struct net_device *d=
ev,
=20
 		p =3D per_cpu_ptr(vlan_dev_priv(dev)->vlan_pcpu_stats, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&p->syncp);
+			start =3D u64_stats_fetch_begin(&p->syncp);
 			rxpackets	=3D u64_stats_read(&p->rx_packets);
 			rxbytes		=3D u64_stats_read(&p->rx_bytes);
 			rxmulticast	=3D u64_stats_read(&p->rx_multicast);
 			txpackets	=3D u64_stats_read(&p->tx_packets);
 			txbytes		=3D u64_stats_read(&p->tx_bytes);
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
=20
 		stats->rx_packets	+=3D rxpackets;
 		stats->rx_bytes		+=3D rxbytes;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index db4f2641d1cd1..7e2a9fb5786c9 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4899,9 +4899,9 @@ void br_multicast_get_stats(const struct net_bridge *=
br,
 		unsigned int start;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start =3D u64_stats_fetch_begin(&cpu_stats->syncp);
 			memcpy(&temp, &cpu_stats->mstats, sizeof(temp));
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
=20
 		mcast_stats_add_dir(tdst.igmp_v1queries, temp.igmp_v1queries);
 		mcast_stats_add_dir(tdst.igmp_v2queries, temp.igmp_v2queries);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6e53dc9914094..f2fc284abab38 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1378,12 +1378,12 @@ void br_vlan_get_stats(const struct net_bridge_vlan=
 *v,
=20
 		cpu_stats =3D per_cpu_ptr(v->stats, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start =3D u64_stats_fetch_begin(&cpu_stats->syncp);
 			rxpackets =3D u64_stats_read(&cpu_stats->rx_packets);
 			rxbytes =3D u64_stats_read(&cpu_stats->rx_bytes);
 			txbytes =3D u64_stats_read(&cpu_stats->tx_bytes);
 			txpackets =3D u64_stats_read(&cpu_stats->tx_packets);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
=20
 		u64_stats_add(&stats->rx_packets, rxpackets);
 		u64_stats_add(&stats->rx_bytes, rxbytes);
diff --git a/net/core/dev.c b/net/core/dev.c
index 3be256051e99b..b3aa0e9b33e6a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10477,12 +10477,12 @@ void dev_fetch_sw_netstats(struct rtnl_link_stats=
64 *s,
=20
 		stats =3D per_cpu_ptr(netstats, cpu);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&stats->syncp);
+			start =3D u64_stats_fetch_begin(&stats->syncp);
 			rx_packets =3D u64_stats_read(&stats->rx_packets);
 			rx_bytes   =3D u64_stats_read(&stats->rx_bytes);
 			tx_packets =3D u64_stats_read(&stats->tx_packets);
 			tx_bytes   =3D u64_stats_read(&stats->tx_bytes);
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
=20
 		s->rx_packets +=3D rx_packets;
 		s->rx_bytes   +=3D rx_bytes;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 89baa7c0938b9..0a16ad45520eb 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8304,10 +8304,10 @@ static void devlink_trap_stats_read(struct devlink_=
stats __percpu *trap_stats,
=20
 		cpu_stats =3D per_cpu_ptr(trap_stats, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start =3D u64_stats_fetch_begin(&cpu_stats->syncp);
 			rx_packets =3D u64_stats_read(&cpu_stats->rx_packets);
 			rx_bytes =3D u64_stats_read(&cpu_stats->rx_bytes);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
=20
 		u64_stats_add(&stats->rx_packets, rx_packets);
 		u64_stats_add(&stats->rx_bytes, rx_bytes);
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index f084a4a6b7ab2..11aa6e8a30981 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1432,9 +1432,9 @@ static void net_dm_stats_read(struct net_dm_stats *st=
ats)
 		u64 dropped;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start =3D u64_stats_fetch_begin(&cpu_stats->syncp);
 			dropped =3D u64_stats_read(&cpu_stats->dropped);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
=20
 		u64_stats_add(&stats->dropped, dropped);
 	}
@@ -1476,9 +1476,9 @@ static void net_dm_hw_stats_read(struct net_dm_stats =
*stats)
 		u64 dropped;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start =3D u64_stats_fetch_begin(&cpu_stats->syncp);
 			dropped =3D u64_stats_read(&cpu_stats->dropped);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
=20
 		u64_stats_add(&stats->dropped, dropped);
 	}
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index c8d137ef5980e..b71ccaec09914 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -135,10 +135,10 @@ static void gnet_stats_add_basic_cpu(struct gnet_stat=
s_basic_sync *bstats,
 		u64 bytes, packets;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&bcpu->syncp);
+			start =3D u64_stats_fetch_begin(&bcpu->syncp);
 			bytes =3D u64_stats_read(&bcpu->bytes);
 			packets =3D u64_stats_read(&bcpu->packets);
-		} while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));
+		} while (u64_stats_fetch_retry(&bcpu->syncp, start));
=20
 		t_bytes +=3D bytes;
 		t_packets +=3D packets;
@@ -162,10 +162,10 @@ void gnet_stats_add_basic(struct gnet_stats_basic_syn=
c *bstats,
 	}
 	do {
 		if (running)
-			start =3D u64_stats_fetch_begin_irq(&b->syncp);
+			start =3D u64_stats_fetch_begin(&b->syncp);
 		bytes =3D u64_stats_read(&b->bytes);
 		packets =3D u64_stats_read(&b->packets);
-	} while (running && u64_stats_fetch_retry_irq(&b->syncp, start));
+	} while (running && u64_stats_fetch_retry(&b->syncp, start));
=20
 	_bstats_update(bstats, bytes, packets);
 }
@@ -187,10 +187,10 @@ static void gnet_stats_read_basic(u64 *ret_bytes, u64=
 *ret_packets,
 			u64 bytes, packets;
=20
 			do {
-				start =3D u64_stats_fetch_begin_irq(&bcpu->syncp);
+				start =3D u64_stats_fetch_begin(&bcpu->syncp);
 				bytes =3D u64_stats_read(&bcpu->bytes);
 				packets =3D u64_stats_read(&bcpu->packets);
-			} while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));
+			} while (u64_stats_fetch_retry(&bcpu->syncp, start));
=20
 			t_bytes +=3D bytes;
 			t_packets +=3D packets;
@@ -201,10 +201,10 @@ static void gnet_stats_read_basic(u64 *ret_bytes, u64=
 *ret_packets,
 	}
 	do {
 		if (running)
-			start =3D u64_stats_fetch_begin_irq(&b->syncp);
+			start =3D u64_stats_fetch_begin(&b->syncp);
 		*ret_bytes =3D u64_stats_read(&b->bytes);
 		*ret_packets =3D u64_stats_read(&b->packets);
-	} while (running && u64_stats_fetch_retry_irq(&b->syncp, start));
+	} while (running && u64_stats_fetch_retry(&b->syncp, start));
 }
=20
 static int
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a9fde48cffd43..83e419afa89e8 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -976,12 +976,12 @@ static void dsa_slave_get_ethtool_stats(struct net_de=
vice *dev,
=20
 		s =3D per_cpu_ptr(dev->tstats, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&s->syncp);
+			start =3D u64_stats_fetch_begin(&s->syncp);
 			tx_packets =3D u64_stats_read(&s->tx_packets);
 			tx_bytes =3D u64_stats_read(&s->tx_bytes);
 			rx_packets =3D u64_stats_read(&s->rx_packets);
 			rx_bytes =3D u64_stats_read(&s->rx_bytes);
-		} while (u64_stats_fetch_retry_irq(&s->syncp, start));
+		} while (u64_stats_fetch_retry(&s->syncp, start));
 		data[0] +=3D tx_packets;
 		data[1] +=3D tx_bytes;
 		data[2] +=3D rx_packets;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 3dd02396517df..585f13b6fef68 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1706,9 +1706,9 @@ u64 snmp_get_cpu_field64(void __percpu *mib, int cpu,=
 int offt,
 	bhptr =3D per_cpu_ptr(mib, cpu);
 	syncp =3D (struct u64_stats_sync *)(bhptr + syncp_offset);
 	do {
-		start =3D u64_stats_fetch_begin_irq(syncp);
+		start =3D u64_stats_fetch_begin(syncp);
 		v =3D *(((u64 *)bhptr) + offt);
-	} while (u64_stats_fetch_retry_irq(syncp, start));
+	} while (u64_stats_fetch_retry(syncp, start));
=20
 	return v;
 }
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 8370726ae7bf1..487f8e98deaa0 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1644,13 +1644,13 @@ static int put_nla_counters(struct sk_buff *skb, st=
ruct seg6_local_lwt *slwt)
=20
 		pcounters =3D per_cpu_ptr(slwt->pcpu_counters, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&pcounters->syncp);
+			start =3D u64_stats_fetch_begin(&pcounters->syncp);
=20
 			packets =3D u64_stats_read(&pcounters->packets);
 			bytes =3D u64_stats_read(&pcounters->bytes);
 			errors =3D u64_stats_read(&pcounters->errors);
=20
-		} while (u64_stats_fetch_retry_irq(&pcounters->syncp, start));
+		} while (u64_stats_fetch_retry(&pcounters->syncp, start));
=20
 		counters.packets +=3D packets;
 		counters.bytes +=3D bytes;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index cebfd148bb406..1e922f95a98d3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2396,9 +2396,9 @@ static inline u64 sta_get_tidstats_msdu(struct ieee80=
211_sta_rx_stats *rxstats,
 	u64 value;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&rxstats->syncp);
+		start =3D u64_stats_fetch_begin(&rxstats->syncp);
 		value =3D rxstats->msdu[tid];
-	} while (u64_stats_fetch_retry_irq(&rxstats->syncp, start));
+	} while (u64_stats_fetch_retry(&rxstats->syncp, start));
=20
 	return value;
 }
@@ -2464,9 +2464,9 @@ static inline u64 sta_get_stats_bytes(struct ieee8021=
1_sta_rx_stats *rxstats)
 	u64 value;
=20
 	do {
-		start =3D u64_stats_fetch_begin_irq(&rxstats->syncp);
+		start =3D u64_stats_fetch_begin(&rxstats->syncp);
 		value =3D rxstats->bytes;
-	} while (u64_stats_fetch_retry_irq(&rxstats->syncp, start));
+	} while (u64_stats_fetch_retry(&rxstats->syncp, start));
=20
 	return value;
 }
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index b52afe316dc41..35b5f806fdda1 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1079,9 +1079,9 @@ static void mpls_get_stats(struct mpls_dev *mdev,
=20
 		p =3D per_cpu_ptr(mdev->stats, i);
 		do {
-			start =3D u64_stats_fetch_begin_irq(&p->syncp);
+			start =3D u64_stats_fetch_begin(&p->syncp);
 			local =3D p->stats;
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
=20
 		stats->rx_packets	+=3D local.rx_packets;
 		stats->rx_bytes		+=3D local.rx_bytes;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 988222fff9f02..4d62059a60215 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2296,13 +2296,13 @@ static int ip_vs_stats_percpu_show(struct seq_file =
*seq, void *v)
 		u64 conns, inpkts, outpkts, inbytes, outbytes;
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&u->syncp);
+			start =3D u64_stats_fetch_begin(&u->syncp);
 			conns =3D u->cnt.conns;
 			inpkts =3D u->cnt.inpkts;
 			outpkts =3D u->cnt.outpkts;
 			inbytes =3D u->cnt.inbytes;
 			outbytes =3D u->cnt.outbytes;
-		} while (u64_stats_fetch_retry_irq(&u->syncp, start));
+		} while (u64_stats_fetch_retry(&u->syncp, start));
=20
 		seq_printf(seq, "%3X %8LX %8LX %8LX %16LX %16LX\n",
 			   i, (u64)conns, (u64)inpkts,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 58d9cbc9ccdc7..f093c787fdc03 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1534,10 +1534,10 @@ static int nft_dump_stats(struct sk_buff *skb, stru=
ct nft_stats __percpu *stats)
 	for_each_possible_cpu(cpu) {
 		cpu_stats =3D per_cpu_ptr(stats, cpu);
 		do {
-			seq =3D u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			seq =3D u64_stats_fetch_begin(&cpu_stats->syncp);
 			pkts =3D cpu_stats->pkts;
 			bytes =3D cpu_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, seq));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, seq));
 		total.pkts +=3D pkts;
 		total.bytes +=3D bytes;
 	}
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index c8a9075ddd0a8..4c03ac2a5fb04 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -716,9 +716,9 @@ static void get_dp_stats(const struct datapath *dp, str=
uct ovs_dp_stats *stats,
 		percpu_stats =3D per_cpu_ptr(dp->stats_percpu, i);
=20
 		do {
-			start =3D u64_stats_fetch_begin_irq(&percpu_stats->syncp);
+			start =3D u64_stats_fetch_begin(&percpu_stats->syncp);
 			local_stats =3D *percpu_stats;
-		} while (u64_stats_fetch_retry_irq(&percpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&percpu_stats->syncp, start));
=20
 		stats->n_hit +=3D local_stats.n_hit;
 		stats->n_missed +=3D local_stats.n_missed;
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index d4a2db0b22998..0a0e4c283f02e 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -205,9 +205,9 @@ static void tbl_mask_array_reset_counters(struct mask_a=
rray *ma)
=20
 			stats =3D per_cpu_ptr(ma->masks_usage_stats, cpu);
 			do {
-				start =3D u64_stats_fetch_begin_irq(&stats->syncp);
+				start =3D u64_stats_fetch_begin(&stats->syncp);
 				counter =3D stats->usage_cntrs[i];
-			} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+			} while (u64_stats_fetch_retry(&stats->syncp, start));
=20
 			ma->masks_usage_zero_cntr[i] +=3D counter;
 		}
@@ -1136,10 +1136,9 @@ void ovs_flow_masks_rebalance(struct flow_table *tab=
le)
=20
 			stats =3D per_cpu_ptr(ma->masks_usage_stats, cpu);
 			do {
-				start =3D u64_stats_fetch_begin_irq(&stats->syncp);
+				start =3D u64_stats_fetch_begin(&stats->syncp);
 				counter =3D stats->usage_cntrs[i];
-			} while (u64_stats_fetch_retry_irq(&stats->syncp,
-							   start));
+			} while (u64_stats_fetch_retry(&stats->syncp, start));
=20
 			masks_and_count[i].counter +=3D counter;
 		}
--=20
2.37.2

