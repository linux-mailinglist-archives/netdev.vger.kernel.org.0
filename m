Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF3F5AED4
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfF3GGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:06:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59951 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbfF3GGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:06:15 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B435B210AF;
        Sun, 30 Jun 2019 02:06:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jun 2019 02:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=rGOmR7dJTpMJRT0YGaCHxRAxh5vUVhxQ1E7oM/U231M=; b=CD78QHON
        xOfpDQOUfPAZe72ZMVPV96iJq4Rcs0GdCyFUEorm4NiFd6eO6pX8C7i/BqbZ66wz
        6FocHmP+yqTcBuI5leu8WycQ/wkBouIhAVcDAsT0K1Gv+a6h5DlTXRIxwgc/0t79
        NwodyaHVqB+TR6ZZ9QgfWbDme2L3ffKFUW7Jp8VBK9qZ34hOGZROxvMqM1bOuYRD
        uzG7X2xvaEpdW/27IThuEuyQXm70UzjyZC/+lj7IMD/2kLd/A+9R1rPCG0t/TARO
        /+hmGzYScZTvkBfVoSzV4p9JYevCyCbWpJpqz/cXwnWzdizRr4WS9FLlkb3ta36C
        6y3FAzMWhZivBw==
X-ME-Sender: <xms:VVEYXfqo7YoF6Fc_jlVogL0xwvGKbdfgzoPtvX8fqVtAEeq_hHmhMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeduud
X-ME-Proxy: <xmx:VVEYXaWawSQZN5-Q2tHtGB4ZrRiOVXVQBwTD9Ku23801uAT8msT1pA>
    <xmx:VVEYXXR9cmy3D7T6SWzr31eCOoSRSnpSYlwufk3zmMkjq2IgrMP31g>
    <xmx:VVEYXS50Nquv02wI0Ca_UBipQocmddGHsYpq10kJlvWmdZ3UFUOAyA>
    <xmx:VVEYXe1Rax6wGU7I8Mdp-UGuiFjp0FcaFnlBRJ7ItDTT2mc0zLXbvA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 386E280059;
        Sun, 30 Jun 2019 02:06:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 13/16] mlxsw: spectrum: PTP: Garbage-collect unmatched entries
Date:   Sun, 30 Jun 2019 09:04:57 +0300
Message-Id: <20190630060500.7882-14-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190630060500.7882-1-idosch@idosch.org>
References: <20190630060500.7882-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

On Spectrum-1, timestamped PTP packets and the corresponding timestamps
need to be kept in caches until both are available, at which point they are
matched up and packets forwarded as appropriate. However, not all packets
will ever see their timestamp, and not all timestamps will ever see their
packet. It is therefore necessary to dispose of such abandoned entries.

To that end, introduce a garbage collector to collect entries that have
not had their counterpart turn up within about a second. The GC
maintains a monotonously-increasing value of GC cycle. Every entry that
is put to the hash table is annotated with the GC cycle at which it
should be collected. When the GC runs, it walks the hash table, and
collects the objects according to their GC cycle annotation.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 86 +++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index e87066f65860..f0f0c20ecc2e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -19,9 +19,19 @@
 #define MLXSW_SP1_PTP_CLOCK_FREQ_KHZ		156257 /* 6.4nSec */
 #define MLXSW_SP1_PTP_CLOCK_MASK		64
 
+#define MLXSW_SP1_PTP_HT_GC_INTERVAL		500 /* ms */
+
+/* How long, approximately, should the unmatched entries stay in the hash table
+ * before they are collected. Should be evenly divisible by the GC interval.
+ */
+#define MLXSW_SP1_PTP_HT_GC_TIMEOUT		1000 /* ms */
+
 struct mlxsw_sp_ptp_state {
+	struct mlxsw_sp *mlxsw_sp;
 	struct rhashtable unmatched_ht;
 	spinlock_t unmatched_lock; /* protects the HT */
+	struct delayed_work ht_gc_dw;
+	u32 gc_cycle;
 };
 
 struct mlxsw_sp1_ptp_key {
@@ -38,6 +48,7 @@ struct mlxsw_sp1_ptp_unmatched {
 	struct rcu_head rcu;
 	struct sk_buff *skb;
 	u64 timestamp;
+	u32 gc_cycle;
 };
 
 static const struct rhashtable_params mlxsw_sp1_ptp_unmatched_ht_params = {
@@ -353,6 +364,7 @@ mlxsw_sp1_ptp_unmatched_save(struct mlxsw_sp *mlxsw_sp,
 			     struct sk_buff *skb,
 			     u64 timestamp)
 {
+	int cycles = MLXSW_SP1_PTP_HT_GC_TIMEOUT / MLXSW_SP1_PTP_HT_GC_INTERVAL;
 	struct mlxsw_sp_ptp_state *ptp_state = mlxsw_sp->ptp_state;
 	struct mlxsw_sp1_ptp_unmatched *unmatched;
 	struct mlxsw_sp1_ptp_unmatched *conflict;
@@ -364,6 +376,7 @@ mlxsw_sp1_ptp_unmatched_save(struct mlxsw_sp *mlxsw_sp,
 	unmatched->key = key;
 	unmatched->skb = skb;
 	unmatched->timestamp = timestamp;
+	unmatched->gc_cycle = mlxsw_sp->ptp_state->gc_cycle + cycles;
 
 	conflict = rhashtable_lookup_get_insert_fast(&ptp_state->unmatched_ht,
 					    &unmatched->ht_node,
@@ -396,6 +409,8 @@ mlxsw_sp1_ptp_unmatched_remove(struct mlxsw_sp *mlxsw_sp,
  * 1) When a packet is matched with its timestamp.
  * 2) In several situation when it is necessary to immediately pass on
  *    an SKB without a timestamp.
+ * 3) From GC indirectly through mlxsw_sp1_ptp_unmatched_finish().
+ *    This case is similar to 2) above.
  */
 static void mlxsw_sp1_ptp_packet_finish(struct mlxsw_sp *mlxsw_sp,
 					struct sk_buff *skb, u8 local_port,
@@ -637,6 +652,72 @@ void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp1_ptp_got_packet(mlxsw_sp, skb, local_port, false);
 }
 
+static void
+mlxsw_sp1_ptp_ht_gc_collect(struct mlxsw_sp_ptp_state *ptp_state,
+			    struct mlxsw_sp1_ptp_unmatched *unmatched)
+{
+	int err;
+
+	/* If an unmatched entry has an SKB, it has to be handed over to the
+	 * networking stack. This is usually done from a trap handler, which is
+	 * invoked in a softirq context. Here we are going to do it in process
+	 * context. If that were to be interrupted by a softirq, it could cause
+	 * a deadlock when an attempt is made to take an already-taken lock
+	 * somewhere along the sending path. Disable softirqs to prevent this.
+	 */
+	local_bh_disable();
+
+	spin_lock(&ptp_state->unmatched_lock);
+	err = rhashtable_remove_fast(&ptp_state->unmatched_ht,
+				     &unmatched->ht_node,
+				     mlxsw_sp1_ptp_unmatched_ht_params);
+	spin_unlock(&ptp_state->unmatched_lock);
+
+	if (err)
+		/* The packet was matched with timestamp during the walk. */
+		goto out;
+
+	/* mlxsw_sp1_ptp_unmatched_finish() invokes netif_receive_skb(). While
+	 * the comment at that function states that it can only be called in
+	 * soft IRQ context, this pattern of local_bh_disable() +
+	 * netif_receive_skb(), in process context, is seen elsewhere in the
+	 * kernel, notably in pktgen.
+	 */
+	mlxsw_sp1_ptp_unmatched_finish(ptp_state->mlxsw_sp, unmatched);
+
+out:
+	local_bh_enable();
+}
+
+static void mlxsw_sp1_ptp_ht_gc(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct mlxsw_sp1_ptp_unmatched *unmatched;
+	struct mlxsw_sp_ptp_state *ptp_state;
+	struct rhashtable_iter iter;
+	u32 gc_cycle;
+	void *obj;
+
+	ptp_state = container_of(dwork, struct mlxsw_sp_ptp_state, ht_gc_dw);
+	gc_cycle = ptp_state->gc_cycle++;
+
+	rhashtable_walk_enter(&ptp_state->unmatched_ht, &iter);
+	rhashtable_walk_start(&iter);
+	while ((obj = rhashtable_walk_next(&iter))) {
+		if (IS_ERR(obj))
+			continue;
+
+		unmatched = obj;
+		if (unmatched->gc_cycle <= gc_cycle)
+			mlxsw_sp1_ptp_ht_gc_collect(ptp_state, unmatched);
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+
+	mlxsw_core_schedule_dw(&ptp_state->ht_gc_dw,
+			       MLXSW_SP1_PTP_HT_GC_INTERVAL);
+}
+
 struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_ptp_state *ptp_state;
@@ -645,6 +726,7 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 	ptp_state = kzalloc(sizeof(*ptp_state), GFP_KERNEL);
 	if (!ptp_state)
 		return ERR_PTR(-ENOMEM);
+	ptp_state->mlxsw_sp = mlxsw_sp;
 
 	spin_lock_init(&ptp_state->unmatched_lock);
 
@@ -653,6 +735,9 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_hashtable_init;
 
+	INIT_DELAYED_WORK(&ptp_state->ht_gc_dw, mlxsw_sp1_ptp_ht_gc);
+	mlxsw_core_schedule_dw(&ptp_state->ht_gc_dw,
+			       MLXSW_SP1_PTP_HT_GC_INTERVAL);
 	return ptp_state;
 
 err_hashtable_init:
@@ -662,6 +747,7 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 
 void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
 {
+	cancel_delayed_work_sync(&ptp_state->ht_gc_dw);
 	rhashtable_free_and_destroy(&ptp_state->unmatched_ht,
 				    &mlxsw_sp1_ptp_unmatched_free_fn, NULL);
 	kfree(ptp_state);
-- 
2.20.1

