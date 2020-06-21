Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DCE2029AB
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgFUIe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:34:57 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54641 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729502AbgFUIez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 04:34:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7DDC45C00F0;
        Sun, 21 Jun 2020 04:34:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 21 Jun 2020 04:34:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=gVY3OPOFhDndFeeoi9TCVUY2gouoTa2YjemctMe5eMM=; b=JukFi0dN
        l/neruvoOp/8WiZd4jDtqTyfUbNrZGJeJL+VFNyWor252mrDxEoZm6bAGa7qR6K9
        l5j34chRBV7ARdr6oAsdSkaNPJTpXOUEWursY2JBhEkFt1yS9rDzb9rokOkC8fae
        uS8vQEFfWxGRD3DC52T+XyGDnlZCKvnP8s2o5Yb1rOI4NWdxLVgIa5O7lLn11bUM
        1qvVTrjlLL/I4Y2owWGiK/G4EREG8N7+EMTOe72gZwYaGD5ybbJmChL3OgxjeNFW
        SR7b55cSYWmdXMl8Xcg0+KksKnMrB3KW8cBwI8I/1fHmb4aDtXDWYWVQ87nphNp8
        GtDuAJeqkIBUJQ==
X-ME-Sender: <xms:rhvvXsmoFEoWf0cC7ETwlSsWabvq03LauqbMnc32jsBt-uPpsKgVqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudektddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeijedrkedruddvleen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:rhvvXr2Pskn4T8uMTJx2xnfx7F7vPZPSL9eLISvleNN6Mkv_d4BXHg>
    <xmx:rhvvXqpZxy3VdqmtwTwQ5Oa-QvylghQx7pzfeNoAxNOWx38sUSaHGA>
    <xmx:rhvvXolVC_LEHEgD4-cfg28vVnCFO6mSHmQELPPU3942gMbFakJx8w>
    <xmx:rhvvXoB71xpItNIEp-4GliYAHGYNMbavpEjO0TH-1qWx9mmu8Hmkdg>
Received: from splinter.mtl.com (bzq-109-67-8-129.red.bezeqint.net [109.67.8.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B8073066D7A;
        Sun, 21 Jun 2020 04:34:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/4] mlxsw: spectrum_acl: Support FLOW_ACTION_MANGLE for TCP, UDP ports
Date:   Sun, 21 Jun 2020 11:34:35 +0300
Message-Id: <20200621083436.476806-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200621083436.476806-1-idosch@idosch.org>
References: <20200621083436.476806-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Spectrum-2 supports an ACL action L4_PORT, which allows TCP and UDP source
and destination port number change. Offload suitable mangles to this
action.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 25 +++++++++++++++++++
 .../mellanox/mlxsw/core_acl_flex_actions.h    |  2 ++
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 24 ++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index a0bf0b86e25b..30a7d5afdec7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -1710,3 +1710,28 @@ MLXSW_ITEM32(afa, l4port, s_d, 0x00, 31, 1);
  * Number of port to change to.
  */
 MLXSW_ITEM32(afa, l4port, l4_port, 0x08, 0, 16);
+
+static void mlxsw_afa_l4port_pack(char *payload, enum mlxsw_afa_l4port_s_d s_d, u16 l4_port)
+{
+	mlxsw_afa_l4port_s_d_set(payload, s_d);
+	mlxsw_afa_l4port_l4_port_set(payload, l4_port);
+}
+
+int mlxsw_afa_block_append_l4port(struct mlxsw_afa_block *block, bool is_dport, u16 l4_port,
+				  struct netlink_ext_ack *extack)
+{
+	enum mlxsw_afa_l4port_s_d s_d = is_dport ? MLXSW_AFA_L4PORT_S_D_DST :
+						   MLXSW_AFA_L4PORT_S_D_SRC;
+	char *act = mlxsw_afa_block_append_action(block,
+						  MLXSW_AFA_L4PORT_CODE,
+						  MLXSW_AFA_L4PORT_SIZE);
+
+	if (IS_ERR(act)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot append L4_PORT action");
+		return PTR_ERR(act);
+	}
+
+	mlxsw_afa_l4port_pack(act, s_d, l4_port);
+	return 0;
+}
+EXPORT_SYMBOL(mlxsw_afa_block_append_l4port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
index 8c2705e16ef7..a72350399bcf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
@@ -82,5 +82,7 @@ int mlxsw_afa_block_append_fid_set(struct mlxsw_afa_block *block, u16 fid,
 int mlxsw_afa_block_append_mcrouter(struct mlxsw_afa_block *block,
 				    u16 expected_irif, u16 min_mtu,
 				    bool rmid_valid, u32 kvdl_index);
+int mlxsw_afa_block_append_l4port(struct mlxsw_afa_block *block, bool is_dport, u16 l4_port,
+				  struct netlink_ext_ack *extack);
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index cadcec6dbe19..a671156a1428 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -508,6 +508,8 @@ enum mlxsw_sp_acl_mangle_field {
 	MLXSW_SP_ACL_MANGLE_FIELD_IP_DSFIELD,
 	MLXSW_SP_ACL_MANGLE_FIELD_IP_DSCP,
 	MLXSW_SP_ACL_MANGLE_FIELD_IP_ECN,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP_SPORT,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP_DPORT,
 };
 
 struct mlxsw_sp_acl_mangle_action {
@@ -538,13 +540,26 @@ struct mlxsw_sp_acl_mangle_action {
 	MLXSW_SP_ACL_MANGLE_ACTION(FLOW_ACT_MANGLE_HDR_TYPE_IP6,       \
 				   _offset, _mask, _shift, _field)
 
+#define MLXSW_SP_ACL_MANGLE_ACTION_TCP(_offset, _mask, _shift, _field) \
+	MLXSW_SP_ACL_MANGLE_ACTION(FLOW_ACT_MANGLE_HDR_TYPE_TCP, _offset, _mask, _shift, _field)
+
+#define MLXSW_SP_ACL_MANGLE_ACTION_UDP(_offset, _mask, _shift, _field) \
+	MLXSW_SP_ACL_MANGLE_ACTION(FLOW_ACT_MANGLE_HDR_TYPE_UDP, _offset, _mask, _shift, _field)
+
 static struct mlxsw_sp_acl_mangle_action mlxsw_sp_acl_mangle_actions[] = {
 	MLXSW_SP_ACL_MANGLE_ACTION_IP4(0, 0xff00ffff, 16, IP_DSFIELD),
 	MLXSW_SP_ACL_MANGLE_ACTION_IP4(0, 0xff03ffff, 18, IP_DSCP),
 	MLXSW_SP_ACL_MANGLE_ACTION_IP4(0, 0xfffcffff, 16, IP_ECN),
+
 	MLXSW_SP_ACL_MANGLE_ACTION_IP6(0, 0xf00fffff, 20, IP_DSFIELD),
 	MLXSW_SP_ACL_MANGLE_ACTION_IP6(0, 0xf03fffff, 22, IP_DSCP),
 	MLXSW_SP_ACL_MANGLE_ACTION_IP6(0, 0xffcfffff, 20, IP_ECN),
+
+	MLXSW_SP_ACL_MANGLE_ACTION_TCP(0, 0x0000ffff, 16, IP_SPORT),
+	MLXSW_SP_ACL_MANGLE_ACTION_TCP(0, 0xffff0000, 0,  IP_DPORT),
+
+	MLXSW_SP_ACL_MANGLE_ACTION_UDP(0, 0x0000ffff, 16, IP_SPORT),
+	MLXSW_SP_ACL_MANGLE_ACTION_UDP(0, 0xffff0000, 0,  IP_DPORT),
 };
 
 static int
@@ -594,6 +609,15 @@ static int mlxsw_sp2_acl_rulei_act_mangle_field(struct mlxsw_sp *mlxsw_sp,
 	if (err != -EOPNOTSUPP)
 		return err;
 
+	switch (mact->field) {
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP_SPORT:
+		return mlxsw_afa_block_append_l4port(rulei->act_block, false, val, extack);
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP_DPORT:
+		return mlxsw_afa_block_append_l4port(rulei->act_block, true, val, extack);
+	default:
+		break;
+	}
+
 	NL_SET_ERR_MSG_MOD(extack, "Unsupported mangle field");
 	return err;
 }
-- 
2.26.2

