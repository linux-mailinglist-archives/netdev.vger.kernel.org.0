Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9671C036B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgD3RBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:01:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44743 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgD3RBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:01:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F0DE05C0103;
        Thu, 30 Apr 2020 13:01:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 13:01:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=nlN0A1F8FAO5O5NSWbIb+QENpd026vSfr7J/BPgboRU=; b=UzZzbe+R
        RyMFLnIsARj8wwqgrJ0KKphE3PU0lUIta4qgSvcUuMboGpYq/VT9rrd0k9DSLEIg
        wAsNW5jczio61jkTGbgEASHfp8zwO5a1ontNS7FAQ9sGodKLH8jme96YfkKQmPyw
        Z9THf8Vkg+84zhGdP53mnek2LwdpIvfCUO9oQ/PZHWBM8GeQUyDgYIdx0mRQKTkK
        ZnGA9fwWQUdLB7QyYMVGjbS+CdEu30+VdCC+FZLEwED/hMNpIVtdxSr9GTXB6I9S
        iN4CFNchnzXc38YyGbYy7OSX0TQ9oI4/V9wdXG2EM9sSrOxj94kEyzr5Q68AeOPC
        G1iqsxSF8Au/Eg==
X-ME-Sender: <xms:fASrXpUItQ8yBUdsH7av3_1SkHqyJA4_yilX64ftpnzoUrFbxJEzOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudektddrheegrdduudei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:fASrXt16SxZGjn9kVzJZG79ToQKLR4ZtyrmW8C6Ryw7CCuchN9T0Tg>
    <xmx:fASrXgbL7Plu1XaAP6B7uHsg0jPCyZsx06P1QaQ8JOPUJ5WSgQGKFw>
    <xmx:fASrXgrfwJTZ0YMmGbie4EI-Iraa0e0o0gyUWSReT17qdIy5pp0eyg>
    <xmx:fASrXoEXJeOJGEfVSUvaRauSXBxwCqt4IYb6whSz7dRTQeKNSDCIAw>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 875473065F3A;
        Thu, 30 Apr 2020 13:01:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/9] mlxsw: spectrum_span: Add APIs to get / put an analyzed port
Date:   Thu, 30 Apr 2020 20:01:09 +0300
Message-Id: <20200430170116.4081677-3-idosch@idosch.org>
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

An analyzed port is a port whose incoming / outgoing traffic is mirrored
to a SPAN agent and analyzed on a remote server.

A port can be analyzed by multiple tc filters and therefore the
corresponding analyzed port entry needs to be reference counted. This is
significant because ports whose outgoing traffic is analyzed need to
have an egress mirror buffer.

Add APIs to get / put an analyzed port. Allocate an egress mirror buffer
on a port when it is first inspected at egress and free the buffer when
it is no longer inspected at egress.

Protect the list of analyzed ports with a mutex, as a later patch will
traverse it from a context in which RTNL lock is not held.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 136 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |   4 +
 2 files changed, 140 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index c4159f4a66e2..5edf9d1bf937 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -3,6 +3,7 @@
 
 #include <linux/if_bridge.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/refcount.h>
 #include <linux/rtnetlink.h>
 #include <linux/workqueue.h>
@@ -20,11 +21,20 @@
 struct mlxsw_sp_span {
 	struct work_struct work;
 	struct mlxsw_sp *mlxsw_sp;
+	struct list_head analyzed_ports_list;
+	struct mutex analyzed_ports_lock; /* Protects analyzed_ports_list */
 	atomic_t active_entries_count;
 	int entries_count;
 	struct mlxsw_sp_span_entry entries[];
 };
 
+struct mlxsw_sp_span_analyzed_port {
+	struct list_head list; /* Member of analyzed_ports_list */
+	refcount_t ref_count;
+	u8 local_port;
+	bool ingress;
+};
+
 static void mlxsw_sp_span_respin_work(struct work_struct *work);
 
 static u64 mlxsw_sp_span_occ_get(void *priv)
@@ -49,6 +59,8 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 		return -ENOMEM;
 	span->entries_count = entries_count;
 	atomic_set(&span->active_entries_count, 0);
+	mutex_init(&span->analyzed_ports_lock);
+	INIT_LIST_HEAD(&span->analyzed_ports_list);
 	span->mlxsw_sp = mlxsw_sp;
 	mlxsw_sp->span = span;
 
@@ -79,6 +91,8 @@ void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
 
 		WARN_ON_ONCE(!list_empty(&curr->bound_ports_list));
 	}
+	WARN_ON_ONCE(!list_empty(&mlxsw_sp->span->analyzed_ports_list));
+	mutex_destroy(&mlxsw_sp->span->analyzed_ports_lock);
 	kfree(mlxsw_sp->span);
 }
 
@@ -1082,3 +1096,125 @@ void mlxsw_sp_span_agent_put(struct mlxsw_sp *mlxsw_sp, int span_id)
 
 	mlxsw_sp_span_entry_put(mlxsw_sp, span_entry);
 }
+
+static struct mlxsw_sp_span_analyzed_port *
+mlxsw_sp_span_analyzed_port_find(struct mlxsw_sp_span *span, u8 local_port,
+				 bool ingress)
+{
+	struct mlxsw_sp_span_analyzed_port *analyzed_port;
+
+	list_for_each_entry(analyzed_port, &span->analyzed_ports_list, list) {
+		if (analyzed_port->local_port == local_port &&
+		    analyzed_port->ingress == ingress)
+			return analyzed_port;
+	}
+
+	return NULL;
+}
+
+static struct mlxsw_sp_span_analyzed_port *
+mlxsw_sp_span_analyzed_port_create(struct mlxsw_sp_span *span,
+				   struct mlxsw_sp_port *mlxsw_sp_port,
+				   bool ingress)
+{
+	struct mlxsw_sp_span_analyzed_port *analyzed_port;
+	int err;
+
+	analyzed_port = kzalloc(sizeof(*analyzed_port), GFP_KERNEL);
+	if (!analyzed_port)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&analyzed_port->ref_count, 1);
+	analyzed_port->local_port = mlxsw_sp_port->local_port;
+	analyzed_port->ingress = ingress;
+	list_add_tail(&analyzed_port->list, &span->analyzed_ports_list);
+
+	/* An egress mirror buffer should be allocated on the egress port which
+	 * does the mirroring.
+	 */
+	if (!ingress) {
+		u16 mtu = mlxsw_sp_port->dev->mtu;
+
+		err = mlxsw_sp_span_port_buffsize_update(mlxsw_sp_port, mtu);
+		if (err)
+			goto err_buffsize_update;
+	}
+
+	return analyzed_port;
+
+err_buffsize_update:
+	list_del(&analyzed_port->list);
+	kfree(analyzed_port);
+	return ERR_PTR(err);
+}
+
+static void
+mlxsw_sp_span_analyzed_port_destroy(struct mlxsw_sp_span *span,
+				    struct mlxsw_sp_span_analyzed_port *
+				    analyzed_port)
+{
+	struct mlxsw_sp *mlxsw_sp = span->mlxsw_sp;
+	char sbib_pl[MLXSW_REG_SBIB_LEN];
+
+	/* Remove egress mirror buffer now that port is no longer analyzed
+	 * at egress.
+	 */
+	if (!analyzed_port->ingress) {
+		mlxsw_reg_sbib_pack(sbib_pl, analyzed_port->local_port, 0);
+		mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
+	}
+
+	list_del(&analyzed_port->list);
+	kfree(analyzed_port);
+}
+
+int mlxsw_sp_span_analyzed_port_get(struct mlxsw_sp_port *mlxsw_sp_port,
+				    bool ingress)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_span_analyzed_port *analyzed_port;
+	u8 local_port = mlxsw_sp_port->local_port;
+	int err = 0;
+
+	mutex_lock(&mlxsw_sp->span->analyzed_ports_lock);
+
+	analyzed_port = mlxsw_sp_span_analyzed_port_find(mlxsw_sp->span,
+							 local_port, ingress);
+	if (analyzed_port) {
+		refcount_inc(&analyzed_port->ref_count);
+		goto out_unlock;
+	}
+
+	analyzed_port = mlxsw_sp_span_analyzed_port_create(mlxsw_sp->span,
+							   mlxsw_sp_port,
+							   ingress);
+	if (IS_ERR(analyzed_port))
+		err = PTR_ERR(analyzed_port);
+
+out_unlock:
+	mutex_unlock(&mlxsw_sp->span->analyzed_ports_lock);
+	return err;
+}
+
+void mlxsw_sp_span_analyzed_port_put(struct mlxsw_sp_port *mlxsw_sp_port,
+				     bool ingress)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_span_analyzed_port *analyzed_port;
+	u8 local_port = mlxsw_sp_port->local_port;
+
+	mutex_lock(&mlxsw_sp->span->analyzed_ports_lock);
+
+	analyzed_port = mlxsw_sp_span_analyzed_port_find(mlxsw_sp->span,
+							 local_port, ingress);
+	if (WARN_ON_ONCE(!analyzed_port))
+		goto out_unlock;
+
+	if (!refcount_dec_and_test(&analyzed_port->ref_count))
+		goto out_unlock;
+
+	mlxsw_sp_span_analyzed_port_destroy(mlxsw_sp->span, analyzed_port);
+
+out_unlock:
+	mutex_unlock(&mlxsw_sp->span->analyzed_ports_lock);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index b79de9a125bb..1345eda5cc34 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -80,5 +80,9 @@ void mlxsw_sp_span_speed_update_work(struct work_struct *work);
 int mlxsw_sp_span_agent_get(struct mlxsw_sp *mlxsw_sp,
 			    const struct net_device *to_dev, int *p_span_id);
 void mlxsw_sp_span_agent_put(struct mlxsw_sp *mlxsw_sp, int span_id);
+int mlxsw_sp_span_analyzed_port_get(struct mlxsw_sp_port *mlxsw_sp_port,
+				    bool ingress);
+void mlxsw_sp_span_analyzed_port_put(struct mlxsw_sp_port *mlxsw_sp_port,
+				     bool ingress);
 
 #endif
-- 
2.24.1

