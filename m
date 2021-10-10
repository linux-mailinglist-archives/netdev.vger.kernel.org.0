Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378794280E2
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhJJLmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:42:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37489 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232080AbhJJLmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:42:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 06D185C00AA;
        Sun, 10 Oct 2021 07:40:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 10 Oct 2021 07:40:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=63wQXSAukDigAlu66Mqp/EpnygVtJtmRDlKKFCR8npc=; b=Ll9+844f
        EaTTve/UZ00WASZyrEx/zCFNYP7rBLI6MyyGIylpBE8sHY980RtYE9cqnbhLU1PA
        yUmlJ6mqlo051ntI4jvCoAuNlSWvfEFyjJJbQiXpWfN+Kl19m3BjUZZhPiNKTSVs
        Y9w2oTxVBwwXvegV1F84o7+xrIciLbI7lyLexqFRhsrfjEknlsTlnYOZrHWpNwxw
        yaqrCqpsve56kPTDKm8HSBXDrIy7jD4akbP92HG+Rf10aA0eK6xdeKHoWwyLKyC6
        o1lhp7EofxHhJ2DZg7HIEL3MmSUzS8YtpsHIwlj5NwGvAofG7qGunWcqI4R/N5F5
        RgEzb4jsIPZ+JQ==
X-ME-Sender: <xms:PNFiYU2vrps7DPrKIc7v3y2MIm9z-DnWhXy_odAU1C8Gdg4srMM2Kw>
    <xme:PNFiYfHt0eMKhnN6wFdBV2ddnGzsLSsZyW0B2GEk3G6SsDwSIMLmygOdE7IrOam3k
    OXTWdwjTtx5b3I>
X-ME-Received: <xmr:PNFiYc4ttes-HpEjBhJLtPBceneOjqzJCoqvlnDCYH5e5ev2FTHZfsnXklTwDlZaU-4ZK--5s7soWUXGFi0NhQL6j-ARECsVN3drxmboVz4RRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:PNFiYd0AF0bqQC2oUV9O9FUWBXxUgsDeUxjgL8GuTc3aUUn2tcGy5w>
    <xmx:PNFiYXGwkTCD5cxFbLGDPMK3FcDE6iTEzxFLM3AHfaBa03168Xz8Zg>
    <xmx:PNFiYW9CoLnOpbgXsREea_6nj9522lrpoPBzPs5qvYdyIbl7g5RRoA>
    <xmx:PdFiYbiT9z81whKeZ1RZMKuRxrE3cqVJWtalHub-IAHKcXLMzH70Kw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Oct 2021 07:40:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/6] mlxsw: spectrum_qdisc: Track permissible actions per binding
Date:   Sun, 10 Oct 2021 14:40:15 +0300
Message-Id: <20211010114018.190266-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211010114018.190266-1-idosch@idosch.org>
References: <20211010114018.190266-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

One block can be bound to several qevents. The qevent type that the block
is bound to determines which actions make sense in a given context. In the
particular case of mlxsw, trap cannot be offloaded on a RED mark qevent,
because the trap contract specifies that the packet is dropped in the HW
datapath, and the HW trigger that the action is offloaded to is always
forwarding the packet (in addition to marking in).

Therefore keep track of which actions are permissible at each binding
block. When an attempt is made to bind a certain action at a binding point
where it is not supported, bounce the request.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 44 ++++++++++++++-----
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 3e3da5b909f5..2dfc9e38307d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -1472,6 +1472,7 @@ struct mlxsw_sp_qevent_binding {
 	u32 handle;
 	int tclass_num;
 	enum mlxsw_sp_span_trigger span_trigger;
+	unsigned int action_mask;
 };
 
 static LIST_HEAD(mlxsw_sp_qevent_block_cb_list);
@@ -1596,6 +1597,11 @@ mlxsw_sp_qevent_entry_configure(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_qevent_binding *qevent_binding,
 				struct netlink_ext_ack *extack)
 {
+	if (!(BIT(mall_entry->type) & qevent_binding->action_mask)) {
+		NL_SET_ERR_MSG(extack, "Action not supported at this qevent");
+		return -EOPNOTSUPP;
+	}
+
 	switch (mall_entry->type) {
 	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
 		return mlxsw_sp_qevent_mirror_configure(mlxsw_sp, mall_entry, qevent_binding);
@@ -1840,7 +1846,8 @@ static void mlxsw_sp_qevent_block_release(void *cb_priv)
 
 static struct mlxsw_sp_qevent_binding *
 mlxsw_sp_qevent_binding_create(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle, int tclass_num,
-			       enum mlxsw_sp_span_trigger span_trigger)
+			       enum mlxsw_sp_span_trigger span_trigger,
+			       unsigned int action_mask)
 {
 	struct mlxsw_sp_qevent_binding *binding;
 
@@ -1852,6 +1859,7 @@ mlxsw_sp_qevent_binding_create(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 	binding->handle = handle;
 	binding->tclass_num = tclass_num;
 	binding->span_trigger = span_trigger;
+	binding->action_mask = action_mask;
 	return binding;
 }
 
@@ -1877,9 +1885,11 @@ mlxsw_sp_qevent_binding_lookup(struct mlxsw_sp_qevent_block *block,
 	return NULL;
 }
 
-static int mlxsw_sp_setup_tc_block_qevent_bind(struct mlxsw_sp_port *mlxsw_sp_port,
-					       struct flow_block_offload *f,
-					       enum mlxsw_sp_span_trigger span_trigger)
+static int
+mlxsw_sp_setup_tc_block_qevent_bind(struct mlxsw_sp_port *mlxsw_sp_port,
+				    struct flow_block_offload *f,
+				    enum mlxsw_sp_span_trigger span_trigger,
+				    unsigned int action_mask)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_qevent_binding *qevent_binding;
@@ -1919,8 +1929,11 @@ static int mlxsw_sp_setup_tc_block_qevent_bind(struct mlxsw_sp_port *mlxsw_sp_po
 		goto err_binding_exists;
 	}
 
-	qevent_binding = mlxsw_sp_qevent_binding_create(mlxsw_sp_port, f->sch->handle,
-							qdisc->tclass_num, span_trigger);
+	qevent_binding = mlxsw_sp_qevent_binding_create(mlxsw_sp_port,
+							f->sch->handle,
+							qdisc->tclass_num,
+							span_trigger,
+							action_mask);
 	if (IS_ERR(qevent_binding)) {
 		err = PTR_ERR(qevent_binding);
 		goto err_binding_create;
@@ -1979,15 +1992,19 @@ static void mlxsw_sp_setup_tc_block_qevent_unbind(struct mlxsw_sp_port *mlxsw_sp
 	}
 }
 
-static int mlxsw_sp_setup_tc_block_qevent(struct mlxsw_sp_port *mlxsw_sp_port,
-					  struct flow_block_offload *f,
-					  enum mlxsw_sp_span_trigger span_trigger)
+static int
+mlxsw_sp_setup_tc_block_qevent(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct flow_block_offload *f,
+			       enum mlxsw_sp_span_trigger span_trigger,
+			       unsigned int action_mask)
 {
 	f->driver_block_list = &mlxsw_sp_qevent_block_cb_list;
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		return mlxsw_sp_setup_tc_block_qevent_bind(mlxsw_sp_port, f, span_trigger);
+		return mlxsw_sp_setup_tc_block_qevent_bind(mlxsw_sp_port, f,
+							   span_trigger,
+							   action_mask);
 	case FLOW_BLOCK_UNBIND:
 		mlxsw_sp_setup_tc_block_qevent_unbind(mlxsw_sp_port, f, span_trigger);
 		return 0;
@@ -1999,7 +2016,12 @@ static int mlxsw_sp_setup_tc_block_qevent(struct mlxsw_sp_port *mlxsw_sp_port,
 int mlxsw_sp_setup_tc_block_qevent_early_drop(struct mlxsw_sp_port *mlxsw_sp_port,
 					      struct flow_block_offload *f)
 {
-	return mlxsw_sp_setup_tc_block_qevent(mlxsw_sp_port, f, MLXSW_SP_SPAN_TRIGGER_EARLY_DROP);
+	unsigned int action_mask = BIT(MLXSW_SP_MALL_ACTION_TYPE_MIRROR) |
+				   BIT(MLXSW_SP_MALL_ACTION_TYPE_TRAP);
+
+	return mlxsw_sp_setup_tc_block_qevent(mlxsw_sp_port, f,
+					      MLXSW_SP_SPAN_TRIGGER_EARLY_DROP,
+					      action_mask);
 }
 
 int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
-- 
2.31.1

