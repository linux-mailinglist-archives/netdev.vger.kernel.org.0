Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7931583EC
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfF0NyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:54:02 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55913 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbfF0NyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:54:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D68EE21F30;
        Thu, 27 Jun 2019 09:53:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:53:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=/s6cp4/khaM2ZYH7pdhoX1xo9qUhKwjMH4ma8Gbs22M=; b=dWL3193+
        l3xOTZgVPsimt9udImbLxiEcec/VqXg2am9YJE3FCIq0mARM2p24gTeDT3PgN4pc
        SM4Q0jhqvA+j90pB6485p63wBmmSXnuao9KgiZZgW3I1/ci7OzU5CVOzqjhF8AZU
        qPiy0ecg1kqsfge5fmHtMsrdtGNK9wgafDRD+zPqHnOxDi9xu7ZKAiWJcmHI38LT
        p8W/1aVBiRDdUst8HtiLJFz7Ll7XYFuYTL4J8DqxVDHdGSlHDP5qXL4C4CQi/U+Z
        HlDjIOmN1UMtC+fAp8rRBIxeUXShyVm7StHtLxT/MV5EqJcS3U3UCo2z2L/p9SVT
        Peb6wnpYxpErLw==
X-ME-Sender: <xms:d8oUXatsTV_6K8-Hh0FEsy3eWBUX5_ccs-M_UBzxD7k2fQkspnrzjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddu
X-ME-Proxy: <xmx:d8oUXbULXwNMdkHHjUYXbhgxo7GyFLLcpOhOf0bk46bWbTS9wbza1Q>
    <xmx:d8oUXWcX_2PFsnxn3DvYISAkFMn_RKvZmWZXGow2ZFB6e6Y1ZvrPJw>
    <xmx:d8oUXQa0wCtHWMkEyHiZ8hHU_QLddcI1_2_zUZ0DkaSJGKnQKMZcDQ>
    <xmx:d8oUXUHzsq8XYyl54j0nOuxTYCgOFUPK6ks3dJRBnbzzzBIQFvExbg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id F24F78006A;
        Thu, 27 Jun 2019 09:53:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/16] mlxsw: spectrum: PTP: Support timestamping on Spectrum-1
Date:   Thu, 27 Jun 2019 16:52:55 +0300
Message-Id: <20190627135259.7292-13-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
References: <20190627135259.7292-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

On Spectrum-1, timestamps arrive through a pair of dedicated events:
MLXSW_TRAP_ID_PTP_ING_FIFO and _EGR_FIFO. The payload delivered with
those traps is contents of the timestamp FIFO at a given port in a given
direction. Add a Spectrum-1-specific handler for these two events which
decodes the timestamps and forwards them to the PTP module.

Add a function that parses a packet, dispatching to ptp_classify_raw(),
and decodes PTP message type, domain number, and sequence ID. Add a new
mlxsw dependency on the PTP classifier.

Add helpers that can store and retrieve unmatched timestamps and SKBs to
the hash table added in a preceding patch.

Add the matching code itself: upon arrival of a timestamp or a packet,
look up the corresponding unmatched entry, and match it up. If there is
none, add a new unmatched entry. This logic is the same on ingress as on
egress.

Packets and timestamps that never matched need to be eventually disposed
of. A garbage collector added in a follow-up patch will take care of
that. Since currently all this code is turned off, no crud will
accumulate in the hash table.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  43 +++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   5 +
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 324 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  13 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   4 +
 6 files changed, 388 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index b5d64aed259e..06c80343d9ed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -84,6 +84,7 @@ config MLXSW_SPECTRUM
 	select OBJAGG
 	select MLXFW
 	imply PTP_1588_CLOCK
+	select NET_PTP_CLASSIFY if PTP_1588_CLOCK
 	default m
 	---help---
 	  This driver supports Mellanox Technologies Spectrum Ethernet
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 6cb7aeac0657..87e7964ba496 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3970,6 +3970,46 @@ static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 	}
 }
 
+static void mlxsw_sp1_ptp_fifo_event_func(struct mlxsw_sp *mlxsw_sp,
+					  char *mtpptr_pl, bool ingress)
+{
+	u8 local_port;
+	u8 num_rec;
+	int i;
+
+	local_port = mlxsw_reg_mtpptr_local_port_get(mtpptr_pl);
+	num_rec = mlxsw_reg_mtpptr_num_rec_get(mtpptr_pl);
+	for (i = 0; i < num_rec; ++i) {
+		u8 domain_number;
+		u8 message_type;
+		u16 sequence_id;
+		u64 timestamp;
+
+		mlxsw_reg_mtpptr_unpack(mtpptr_pl, i, &message_type,
+					&domain_number, &sequence_id,
+					&timestamp);
+		mlxsw_sp1_ptp_got_timestamp(mlxsw_sp, ingress, local_port,
+					    message_type, domain_number,
+					    sequence_id, timestamp);
+	}
+}
+
+static void mlxsw_sp1_ptp_ing_fifo_event_func(const struct mlxsw_reg_info *reg,
+					      char *mtpptr_pl, void *priv)
+{
+	struct mlxsw_sp *mlxsw_sp = priv;
+
+	mlxsw_sp1_ptp_fifo_event_func(mlxsw_sp, mtpptr_pl, true);
+}
+
+static void mlxsw_sp1_ptp_egr_fifo_event_func(const struct mlxsw_reg_info *reg,
+					      char *mtpptr_pl, void *priv)
+{
+	struct mlxsw_sp *mlxsw_sp = priv;
+
+	mlxsw_sp1_ptp_fifo_event_func(mlxsw_sp, mtpptr_pl, false);
+}
+
 void mlxsw_sp_rx_listener_no_mark_func(struct sk_buff *skb,
 				       u8 local_port, void *priv)
 {
@@ -4151,6 +4191,9 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 };
 
 static const struct mlxsw_listener mlxsw_sp1_listener[] = {
+	/* Events */
+	MLXSW_EVENTL(mlxsw_sp1_ptp_egr_fifo_event_func, PTP_EGR_FIFO, SP_PTP0),
+	MLXSW_EVENTL(mlxsw_sp1_ptp_ing_fifo_event_func, PTP_ING_FIFO, SP_PTP0),
 };
 
 static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 7e1808179a2a..7f8427c1a997 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -266,6 +266,11 @@ struct mlxsw_sp_port {
 	unsigned acl_rule_count;
 	struct mlxsw_sp_acl_block *ing_acl_block;
 	struct mlxsw_sp_acl_block *eg_acl_block;
+	struct {
+		struct hwtstamp_config hwtstamp_config;
+		u16 ing_types;
+		u16 egr_types;
+	} ptp;
 };
 
 struct mlxsw_sp_port_type_speed_ops {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 1eb6eefa1afc..e87066f65860 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -6,6 +6,10 @@
 #include <linux/timecounter.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
+#include <linux/rhashtable.h>
+#include <linux/ptp_classify.h>
+#include <linux/if_ether.h>
+#include <linux/if_vlan.h>
 
 #include "spectrum.h"
 #include "spectrum_ptp.h"
@@ -293,6 +297,166 @@ void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
 	kfree(clock);
 }
 
+static int mlxsw_sp_ptp_parse(struct sk_buff *skb,
+			      u8 *p_domain_number,
+			      u8 *p_message_type,
+			      u16 *p_sequence_id)
+{
+	unsigned int offset = 0;
+	unsigned int ptp_class;
+	u8 *data;
+
+	data = skb_mac_header(skb);
+	ptp_class = ptp_classify_raw(skb);
+
+	switch (ptp_class & PTP_CLASS_VMASK) {
+	case PTP_CLASS_V1:
+	case PTP_CLASS_V2:
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	if (ptp_class & PTP_CLASS_VLAN)
+		offset += VLAN_HLEN;
+
+	switch (ptp_class & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
+		break;
+	case PTP_CLASS_IPV6:
+		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
+		break;
+	case PTP_CLASS_L2:
+		offset += ETH_HLEN;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	/* PTP header is 34 bytes. */
+	if (skb->len < offset + 34)
+		return -EINVAL;
+
+	*p_message_type = data[offset] & 0x0f;
+	*p_domain_number = data[offset + 4];
+	*p_sequence_id = (u16)(data[offset + 30]) << 8 | data[offset + 31];
+	return 0;
+}
+
+/* Returns NULL on successful insertion, a pointer on conflict, or an ERR_PTR on
+ * error.
+ */
+static struct mlxsw_sp1_ptp_unmatched *
+mlxsw_sp1_ptp_unmatched_save(struct mlxsw_sp *mlxsw_sp,
+			     struct mlxsw_sp1_ptp_key key,
+			     struct sk_buff *skb,
+			     u64 timestamp)
+{
+	struct mlxsw_sp_ptp_state *ptp_state = mlxsw_sp->ptp_state;
+	struct mlxsw_sp1_ptp_unmatched *unmatched;
+	struct mlxsw_sp1_ptp_unmatched *conflict;
+
+	unmatched = kzalloc(sizeof(*unmatched), GFP_ATOMIC);
+	if (!unmatched)
+		return ERR_PTR(-ENOMEM);
+
+	unmatched->key = key;
+	unmatched->skb = skb;
+	unmatched->timestamp = timestamp;
+
+	conflict = rhashtable_lookup_get_insert_fast(&ptp_state->unmatched_ht,
+					    &unmatched->ht_node,
+					    mlxsw_sp1_ptp_unmatched_ht_params);
+	if (conflict)
+		kfree(unmatched);
+
+	return conflict;
+}
+
+static struct mlxsw_sp1_ptp_unmatched *
+mlxsw_sp1_ptp_unmatched_lookup(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp1_ptp_key key)
+{
+	return rhashtable_lookup(&mlxsw_sp->ptp_state->unmatched_ht, &key,
+				 mlxsw_sp1_ptp_unmatched_ht_params);
+}
+
+static int
+mlxsw_sp1_ptp_unmatched_remove(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp1_ptp_unmatched *unmatched)
+{
+	return rhashtable_remove_fast(&mlxsw_sp->ptp_state->unmatched_ht,
+				      &unmatched->ht_node,
+				      mlxsw_sp1_ptp_unmatched_ht_params);
+}
+
+/* This function is called in the following scenarios:
+ *
+ * 1) When a packet is matched with its timestamp.
+ * 2) In several situation when it is necessary to immediately pass on
+ *    an SKB without a timestamp.
+ */
+static void mlxsw_sp1_ptp_packet_finish(struct mlxsw_sp *mlxsw_sp,
+					struct sk_buff *skb, u8 local_port,
+					bool ingress,
+					struct skb_shared_hwtstamps *hwtstamps)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port;
+
+	/* Between capturing the packet and finishing it, there is a window of
+	 * opportunity for the originating port to go away (e.g. due to a
+	 * split). Also make sure the SKB device reference is still valid.
+	 */
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	if (!mlxsw_sp_port && (!skb->dev || skb->dev == mlxsw_sp_port->dev)) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
+	if (ingress) {
+		if (hwtstamps)
+			*skb_hwtstamps(skb) = *hwtstamps;
+		mlxsw_sp_rx_listener_no_mark_func(skb, local_port, mlxsw_sp);
+	} else {
+		/* skb_tstamp_tx() allows hwtstamps to be NULL. */
+		skb_tstamp_tx(skb, hwtstamps);
+		dev_kfree_skb_any(skb);
+	}
+}
+
+static void mlxsw_sp1_packet_timestamp(struct mlxsw_sp *mlxsw_sp,
+				       struct mlxsw_sp1_ptp_key key,
+				       struct sk_buff *skb,
+				       u64 timestamp)
+{
+	struct skb_shared_hwtstamps hwtstamps;
+	u64 nsec;
+
+	spin_lock_bh(&mlxsw_sp->clock->lock);
+	nsec = timecounter_cyc2time(&mlxsw_sp->clock->tc, timestamp);
+	spin_unlock_bh(&mlxsw_sp->clock->lock);
+
+	hwtstamps.hwtstamp = ns_to_ktime(nsec);
+	mlxsw_sp1_ptp_packet_finish(mlxsw_sp, skb,
+				    key.local_port, key.ingress, &hwtstamps);
+}
+
+static void
+mlxsw_sp1_ptp_unmatched_finish(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp1_ptp_unmatched *unmatched)
+{
+	if (unmatched->skb && unmatched->timestamp)
+		mlxsw_sp1_packet_timestamp(mlxsw_sp, unmatched->key,
+					   unmatched->skb,
+					   unmatched->timestamp);
+	else if (unmatched->skb)
+		mlxsw_sp1_ptp_packet_finish(mlxsw_sp, unmatched->skb,
+					    unmatched->key.local_port,
+					    unmatched->key.ingress, NULL);
+	kfree_rcu(unmatched, rcu);
+}
+
 static void mlxsw_sp1_ptp_unmatched_free_fn(void *ptr, void *arg)
 {
 	struct mlxsw_sp1_ptp_unmatched *unmatched = ptr;
@@ -305,16 +469,172 @@ static void mlxsw_sp1_ptp_unmatched_free_fn(void *ptr, void *arg)
 	kfree_rcu(unmatched, rcu);
 }
 
+static void mlxsw_sp1_ptp_got_piece(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp1_ptp_key key,
+				    struct sk_buff *skb, u64 timestamp)
+{
+	struct mlxsw_sp1_ptp_unmatched *unmatched, *conflict;
+	int err;
+
+	rcu_read_lock();
+
+	unmatched = mlxsw_sp1_ptp_unmatched_lookup(mlxsw_sp, key);
+
+	spin_lock(&mlxsw_sp->ptp_state->unmatched_lock);
+
+	if (unmatched) {
+		/* There was an unmatched entry when we looked, but it may have
+		 * been removed before we took the lock.
+		 */
+		err = mlxsw_sp1_ptp_unmatched_remove(mlxsw_sp, unmatched);
+		if (err)
+			unmatched = NULL;
+	}
+
+	if (!unmatched) {
+		/* We have no unmatched entry, but one may have been added after
+		 * we looked, but before we took the lock.
+		 */
+		unmatched = mlxsw_sp1_ptp_unmatched_save(mlxsw_sp, key,
+							 skb, timestamp);
+		if (IS_ERR(unmatched)) {
+			if (skb)
+				mlxsw_sp1_ptp_packet_finish(mlxsw_sp, skb,
+							    key.local_port,
+							    key.ingress, NULL);
+			unmatched = NULL;
+		} else if (unmatched) {
+			/* Save just told us, under lock, that the entry is
+			 * there, so this has to work.
+			 */
+			err = mlxsw_sp1_ptp_unmatched_remove(mlxsw_sp,
+							     unmatched);
+			WARN_ON_ONCE(err);
+		}
+	}
+
+	/* If unmatched is non-NULL here, it comes either from the lookup, or
+	 * from the save attempt above. In either case the entry was removed
+	 * from the hash table. If unmatched is NULL, a new unmatched entry was
+	 * added to the hash table, and there was no conflict.
+	 */
+
+	if (skb && unmatched && unmatched->timestamp) {
+		unmatched->skb = skb;
+	} else if (timestamp && unmatched && unmatched->skb) {
+		unmatched->timestamp = timestamp;
+	} else if (unmatched) {
+		/* unmatched holds an older entry of the same type: either an
+		 * skb if we are handling skb, or a timestamp if we are handling
+		 * timestamp. We can't match that up, so save what we have.
+		 */
+		conflict = mlxsw_sp1_ptp_unmatched_save(mlxsw_sp, key,
+							skb, timestamp);
+		if (IS_ERR(conflict)) {
+			if (skb)
+				mlxsw_sp1_ptp_packet_finish(mlxsw_sp, skb,
+							    key.local_port,
+							    key.ingress, NULL);
+		} else {
+			/* Above, we removed an object with this key from the
+			 * hash table, under lock, so conflict can not be a
+			 * valid pointer.
+			 */
+			WARN_ON_ONCE(conflict);
+		}
+	}
+
+	spin_unlock(&mlxsw_sp->ptp_state->unmatched_lock);
+
+	if (unmatched)
+		mlxsw_sp1_ptp_unmatched_finish(mlxsw_sp, unmatched);
+
+	rcu_read_unlock();
+}
+
+static void mlxsw_sp1_ptp_got_packet(struct mlxsw_sp *mlxsw_sp,
+				     struct sk_buff *skb, u8 local_port,
+				     bool ingress)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct mlxsw_sp1_ptp_key key;
+	u8 types;
+	int err;
+
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	if (!mlxsw_sp_port)
+		goto immediate;
+
+	types = ingress ? mlxsw_sp_port->ptp.ing_types :
+			  mlxsw_sp_port->ptp.egr_types;
+	if (!types)
+		goto immediate;
+
+	memset(&key, 0, sizeof(key));
+	key.local_port = local_port;
+	key.ingress = ingress;
+
+	err = mlxsw_sp_ptp_parse(skb, &key.domain_number, &key.message_type,
+				 &key.sequence_id);
+	if (err)
+		goto immediate;
+
+	/* For packets whose timestamping was not enabled on this port, don't
+	 * bother trying to match the timestamp.
+	 */
+	if (!((1 << key.message_type) & types))
+		goto immediate;
+
+	mlxsw_sp1_ptp_got_piece(mlxsw_sp, key, skb, 0);
+	return;
+
+immediate:
+	mlxsw_sp1_ptp_packet_finish(mlxsw_sp, skb, local_port, ingress, NULL);
+}
+
+void mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
+				 u8 local_port, u8 message_type,
+				 u8 domain_number, u16 sequence_id,
+				 u64 timestamp)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct mlxsw_sp1_ptp_key key;
+	u8 types;
+
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	if (!mlxsw_sp_port)
+		return;
+
+	types = ingress ? mlxsw_sp_port->ptp.ing_types :
+			  mlxsw_sp_port->ptp.egr_types;
+
+	/* For message types whose timestamping was not enabled on this port,
+	 * don't bother with the timestamp.
+	 */
+	if (!((1 << message_type) & types))
+		return;
+
+	memset(&key, 0, sizeof(key));
+	key.local_port = local_port;
+	key.domain_number = domain_number;
+	key.message_type = message_type;
+	key.sequence_id = sequence_id;
+	key.ingress = ingress;
+
+	mlxsw_sp1_ptp_got_piece(mlxsw_sp, key, NULL, timestamp);
+}
+
 void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 			   u8 local_port)
 {
-	mlxsw_sp_rx_listener_no_mark_func(skb, local_port, mlxsw_sp);
+	skb_reset_mac_header(skb);
+	mlxsw_sp1_ptp_got_packet(mlxsw_sp, skb, local_port, true);
 }
 
 void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
 			       struct sk_buff *skb, u8 local_port)
 {
-	dev_kfree_skb_any(skb);
+	mlxsw_sp1_ptp_got_packet(mlxsw_sp, skb, local_port, false);
 }
 
 struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 0f66e63e229c..40c9e82e2920 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -28,6 +28,11 @@ void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
 			       struct sk_buff *skb, u8 local_port);
 
+void mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
+				 u8 local_port, u8 message_type,
+				 u8 domain_number, u16 sequence_id,
+				 u64 timestamp);
+
 #else
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -62,6 +67,14 @@ static inline void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
 	dev_kfree_skb_any(skb);
 }
 
+static inline void
+mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
+			    u8 local_port, u8 message_type,
+			    u8 domain_number,
+			    u16 sequence_id, u64 timestamp)
+{
+}
+
 #endif
 
 static inline struct mlxsw_sp_ptp_clock *
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index f05b7ff4b9df..19202bdb5105 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -78,6 +78,10 @@ enum {
 enum mlxsw_event_trap_id {
 	/* Port Up/Down event generated by hardware */
 	MLXSW_TRAP_ID_PUDE = 0x8,
+	/* PTP Ingress FIFO has a new entry */
+	MLXSW_TRAP_ID_PTP_ING_FIFO = 0x2D,
+	/* PTP Egress FIFO has a new entry */
+	MLXSW_TRAP_ID_PTP_EGR_FIFO = 0x2E,
 };
 
 #endif /* _MLXSW_TRAP_H */
-- 
2.20.1

