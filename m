Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BACB1C036E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgD3RB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:01:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50053 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727773AbgD3RBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:01:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B82905C0115;
        Thu, 30 Apr 2020 13:01:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 13:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=TMpaMcYxpeDEPGkFCF+o5jF2L9EJ1I/jmqhh9UPgm/c=; b=Ig7Yp01z
        utAwfPGexTyMt2+1cS00rg29xzTXMjgBLCFf0xtmIek3top0sOVVmoeeJWJQuNL2
        gIhVL//AmmPaEZpsX19dlv06FkkkJB5BLBekFCm0CSb86bp0FR3pTkcHQ/P6Q4mR
        dcwpvFW2/VzB+ELD1kSYKf9rGDCDi8d2ZlvjeJEcxnRqdy212bG9VXB+MJTipQVe
        NK82vLW8YlmoN9llSYKf/RM1AVZInAqoQS/TW6P4jPBc/M6k3kBNIVQK5IkM9ZFa
        ykRYWGWhLC9cgvNY8Ach/FaMvB+TJGKpRPTFieud+IwCcgYaGSwK+Zcimec73LOq
        IPYZIl5KzX+Vrg==
X-ME-Sender: <xms:gQSrXlUtUTpoEL4O52VQPpSSJXJ02HL5N-f9us4-GjjmicrUx9cpSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudektddrheegrdduudei
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:gQSrXp2gy-RegPTYFIW8jqwofzXwX1lKtbl8N-Nod3Tjtv3nDJXZig>
    <xmx:gQSrXsZdZ1VK5gFn4acnhf9PJ-vPIVDcSXiTpeSwhwvAT6g9F9v__A>
    <xmx:gQSrXsrayXAONK3IbMXl5UVc-Rd9F1SL7ZoN_JZmLl_8vyGU331FMQ>
    <xmx:gQSrXkFC10SkmrtbSAWfB1riEjArdT9Mw2cvcPAcu80aqVnzKK7TUQ>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 27C273065F39;
        Thu, 30 Apr 2020 13:01:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/9] mlxsw: spectrum_span: Add APIs to bind / unbind a SPAN agent
Date:   Thu, 30 Apr 2020 20:01:12 +0300
Message-Id: <20200430170116.4081677-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200430170116.4081677-1-idosch@idosch.org>
References: <20200430170116.4081677-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, a SPAN agent can only be bound to a per-port trigger where
the trigger is either an incoming packet (INGRESS) or an outgoing packet
(EGRESS) to / from the port.

A follow-up patch set will introduce the concept of global triggers and
per-{port, TC} enablement. With global triggers, the trigger entry is
only keyed by a trigger and not by a port and a trigger. The trigger can
be, for example, a packet that was early dropped.

While the binding between the SPAN agent and the trigger is performed
only once, the trigger entry needs to be reference counted, as the
trigger can be enabled on multiple ports.

Add APIs to bind / unbind a SPAN agent to a trigger and reference count
the trigger entry in preparation for global triggers.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 169 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  18 ++
 2 files changed, 187 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 2b9d8ce93b13..de9012ab94d5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -23,6 +23,7 @@ struct mlxsw_sp_span {
 	struct mlxsw_sp *mlxsw_sp;
 	struct list_head analyzed_ports_list;
 	struct mutex analyzed_ports_lock; /* Protects analyzed_ports_list */
+	struct list_head trigger_entries_list;
 	atomic_t active_entries_count;
 	int entries_count;
 	struct mlxsw_sp_span_entry entries[];
@@ -35,6 +36,14 @@ struct mlxsw_sp_span_analyzed_port {
 	bool ingress;
 };
 
+struct mlxsw_sp_span_trigger_entry {
+	struct list_head list; /* Member of trigger_entries_list */
+	refcount_t ref_count;
+	u8 local_port;
+	enum mlxsw_sp_span_trigger trigger;
+	struct mlxsw_sp_span_trigger_parms parms;
+};
+
 static void mlxsw_sp_span_respin_work(struct work_struct *work);
 
 static u64 mlxsw_sp_span_occ_get(void *priv)
@@ -61,6 +70,7 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 	atomic_set(&span->active_entries_count, 0);
 	mutex_init(&span->analyzed_ports_lock);
 	INIT_LIST_HEAD(&span->analyzed_ports_list);
+	INIT_LIST_HEAD(&span->trigger_entries_list);
 	span->mlxsw_sp = mlxsw_sp;
 	mlxsw_sp->span = span;
 
@@ -91,6 +101,7 @@ void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
 
 		WARN_ON_ONCE(!list_empty(&curr->bound_ports_list));
 	}
+	WARN_ON_ONCE(!list_empty(&mlxsw_sp->span->trigger_entries_list));
 	WARN_ON_ONCE(!list_empty(&mlxsw_sp->span->analyzed_ports_list));
 	mutex_destroy(&mlxsw_sp->span->analyzed_ports_lock);
 	kfree(mlxsw_sp->span);
@@ -1225,3 +1236,161 @@ void mlxsw_sp_span_analyzed_port_put(struct mlxsw_sp_port *mlxsw_sp_port,
 out_unlock:
 	mutex_unlock(&mlxsw_sp->span->analyzed_ports_lock);
 }
+
+static int
+__mlxsw_sp_span_trigger_entry_bind(struct mlxsw_sp_span *span,
+				   struct mlxsw_sp_span_trigger_entry *
+				   trigger_entry, bool enable)
+{
+	char mpar_pl[MLXSW_REG_MPAR_LEN];
+	enum mlxsw_reg_mpar_i_e i_e;
+
+	switch (trigger_entry->trigger) {
+	case MLXSW_SP_SPAN_TRIGGER_INGRESS:
+		i_e = MLXSW_REG_MPAR_TYPE_INGRESS;
+		break;
+	case MLXSW_SP_SPAN_TRIGGER_EGRESS:
+		i_e = MLXSW_REG_MPAR_TYPE_EGRESS;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	mlxsw_reg_mpar_pack(mpar_pl, trigger_entry->local_port, i_e, enable,
+			    trigger_entry->parms.span_id);
+	return mlxsw_reg_write(span->mlxsw_sp->core, MLXSW_REG(mpar), mpar_pl);
+}
+
+static int
+mlxsw_sp_span_trigger_entry_bind(struct mlxsw_sp_span *span,
+				 struct mlxsw_sp_span_trigger_entry *
+				 trigger_entry)
+{
+	return __mlxsw_sp_span_trigger_entry_bind(span, trigger_entry, true);
+}
+
+static void
+mlxsw_sp_span_trigger_entry_unbind(struct mlxsw_sp_span *span,
+				   struct mlxsw_sp_span_trigger_entry *
+				   trigger_entry)
+{
+	__mlxsw_sp_span_trigger_entry_bind(span, trigger_entry, false);
+}
+
+static struct mlxsw_sp_span_trigger_entry *
+mlxsw_sp_span_trigger_entry_create(struct mlxsw_sp_span *span,
+				   enum mlxsw_sp_span_trigger trigger,
+				   struct mlxsw_sp_port *mlxsw_sp_port,
+				   const struct mlxsw_sp_span_trigger_parms
+				   *parms)
+{
+	struct mlxsw_sp_span_trigger_entry *trigger_entry;
+	int err;
+
+	trigger_entry = kzalloc(sizeof(*trigger_entry), GFP_KERNEL);
+	if (!trigger_entry)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&trigger_entry->ref_count, 1);
+	trigger_entry->local_port = mlxsw_sp_port->local_port;
+	trigger_entry->trigger = trigger;
+	memcpy(&trigger_entry->parms, parms, sizeof(trigger_entry->parms));
+	list_add_tail(&trigger_entry->list, &span->trigger_entries_list);
+
+	err = mlxsw_sp_span_trigger_entry_bind(span, trigger_entry);
+	if (err)
+		goto err_trigger_entry_bind;
+
+	return trigger_entry;
+
+err_trigger_entry_bind:
+	list_del(&trigger_entry->list);
+	kfree(trigger_entry);
+	return ERR_PTR(err);
+}
+
+static void
+mlxsw_sp_span_trigger_entry_destroy(struct mlxsw_sp_span *span,
+				    struct mlxsw_sp_span_trigger_entry *
+				    trigger_entry)
+{
+	mlxsw_sp_span_trigger_entry_unbind(span, trigger_entry);
+	list_del(&trigger_entry->list);
+	kfree(trigger_entry);
+}
+
+static struct mlxsw_sp_span_trigger_entry *
+mlxsw_sp_span_trigger_entry_find(struct mlxsw_sp_span *span,
+				 enum mlxsw_sp_span_trigger trigger,
+				 struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	struct mlxsw_sp_span_trigger_entry *trigger_entry;
+
+	list_for_each_entry(trigger_entry, &span->trigger_entries_list, list) {
+		if (trigger_entry->trigger == trigger &&
+		    trigger_entry->local_port == mlxsw_sp_port->local_port)
+			return trigger_entry;
+	}
+
+	return NULL;
+}
+
+int mlxsw_sp_span_agent_bind(struct mlxsw_sp *mlxsw_sp,
+			     enum mlxsw_sp_span_trigger trigger,
+			     struct mlxsw_sp_port *mlxsw_sp_port,
+			     const struct mlxsw_sp_span_trigger_parms *parms)
+{
+	struct mlxsw_sp_span_trigger_entry *trigger_entry;
+	int err = 0;
+
+	ASSERT_RTNL();
+
+	if (!mlxsw_sp_span_entry_find_by_id(mlxsw_sp, parms->span_id))
+		return -EINVAL;
+
+	trigger_entry = mlxsw_sp_span_trigger_entry_find(mlxsw_sp->span,
+							 trigger,
+							 mlxsw_sp_port);
+	if (trigger_entry) {
+		if (trigger_entry->parms.span_id != parms->span_id)
+			return -EINVAL;
+		refcount_inc(&trigger_entry->ref_count);
+		goto out;
+	}
+
+	trigger_entry = mlxsw_sp_span_trigger_entry_create(mlxsw_sp->span,
+							   trigger,
+							   mlxsw_sp_port,
+							   parms);
+	if (IS_ERR(trigger_entry))
+		err = PTR_ERR(trigger_entry);
+
+out:
+	return err;
+}
+
+void mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
+				enum mlxsw_sp_span_trigger trigger,
+				struct mlxsw_sp_port *mlxsw_sp_port,
+				const struct mlxsw_sp_span_trigger_parms *parms)
+{
+	struct mlxsw_sp_span_trigger_entry *trigger_entry;
+
+	ASSERT_RTNL();
+
+	if (WARN_ON_ONCE(!mlxsw_sp_span_entry_find_by_id(mlxsw_sp,
+							 parms->span_id)))
+		return;
+
+	trigger_entry = mlxsw_sp_span_trigger_entry_find(mlxsw_sp->span,
+							 trigger,
+							 mlxsw_sp_port);
+	if (WARN_ON_ONCE(!trigger_entry))
+		return;
+
+	if (!refcount_dec_and_test(&trigger_entry->ref_count))
+		return;
+
+	mlxsw_sp_span_trigger_entry_destroy(mlxsw_sp->span, trigger_entry);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 1345eda5cc34..6821eeb3906b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -37,6 +37,15 @@ struct mlxsw_sp_span_parms {
 	u16 vid;
 };
 
+enum mlxsw_sp_span_trigger {
+	MLXSW_SP_SPAN_TRIGGER_INGRESS,
+	MLXSW_SP_SPAN_TRIGGER_EGRESS,
+};
+
+struct mlxsw_sp_span_trigger_parms {
+	int span_id;
+};
+
 struct mlxsw_sp_span_entry_ops;
 
 struct mlxsw_sp_span_entry {
@@ -84,5 +93,14 @@ int mlxsw_sp_span_analyzed_port_get(struct mlxsw_sp_port *mlxsw_sp_port,
 				    bool ingress);
 void mlxsw_sp_span_analyzed_port_put(struct mlxsw_sp_port *mlxsw_sp_port,
 				     bool ingress);
+int mlxsw_sp_span_agent_bind(struct mlxsw_sp *mlxsw_sp,
+			     enum mlxsw_sp_span_trigger trigger,
+			     struct mlxsw_sp_port *mlxsw_sp_port,
+			     const struct mlxsw_sp_span_trigger_parms *parms);
+void
+mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
+			   enum mlxsw_sp_span_trigger trigger,
+			   struct mlxsw_sp_port *mlxsw_sp_port,
+			   const struct mlxsw_sp_span_trigger_parms *parms);
 
 #endif
-- 
2.24.1

