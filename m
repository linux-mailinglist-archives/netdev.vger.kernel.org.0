Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE91F88BA
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKLGtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:49:32 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52403 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbfKLGtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:49:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0775A2210D;
        Tue, 12 Nov 2019 01:49:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 12 Nov 2019 01:49:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=buEXbe/Hh5okI0dnQOzcBVMFz8m3WUvQKZPRC890HLo=; b=NHSMhJVh
        JA7Ybd65wc5uwtTB6OIg0gMqqKxe3bo3axt1yjELCP2X2HjeWxm6pDXjuzVlF3FI
        HMFLt77q3cH4309DFdhFU+QEIih04S25q9sEebTP1VRwQioJBs6T/19Zh5MzTLgz
        LWsPix/sEG2VZ0XkhgqVYuBv7owabzEi8wX3ZP+i9oVeVNtGRNK4PmpGDRE7OBiB
        sAT8waldjZcc1HJ5TcdmNd3sgMKEgx0coqdzSsSvVf251aTQibb2p+QA3s+LRGS5
        myGL8b4DJ1NAqwGykPeGXdI6olCE9xTOG9MZaP50FKdxyB7sFZbJxHTyIxFyWNOI
        yxAdu2ga8KcSwQ==
X-ME-Sender: <xms:-lXKXQEyAnN-lgr8CdEdVofz_rla6GfumH4IVLSkP7D6KKhcjk-C6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvkedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:-lXKXa83kf3G6d4gYg0v3LRBin5KIuiF3yCISEgifgFTm4NZ-2rAeg>
    <xmx:-lXKXePU8ezDXHeWz40J32hiIxS1jPn-sZBTJn3DlXDRjlj85ogbBA>
    <xmx:-lXKXYg9kQkpY5qBKX_IfgQPjuKwpQlR2SO_BIndiB3wlsJmhSmYmw>
    <xmx:-lXKXUYk1JHOv8vRG-GN6PSd9NKQenElOiZvkx4A7L_YQ7szgI4I_A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D04C580069;
        Tue, 12 Nov 2019 01:49:28 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 1/7] mlxsw: core: Parse TLVs' offsets of incoming EMADs
Date:   Tue, 12 Nov 2019 08:48:24 +0200
Message-Id: <20191112064830.27002-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191112064830.27002-1-idosch@idosch.org>
References: <20191112064830.27002-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Until now the code assumes a fixed structure which makes it difficult to
support EMADs with and without new TLVs.

Make it more generic by parsing the TLVs when the EMADs are received and
store the offset to the different TLVs in the control block. Using these
offsets to extract information from the EMADs without relying on a specific
structure.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 53 +++++++++++++++++-----
 1 file changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 42e1ce3e39e1..698c7bcb1aad 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -361,20 +361,45 @@ static void mlxsw_emad_construct(struct sk_buff *skb,
 	mlxsw_emad_construct_eth_hdr(skb);
 }
 
+struct mlxsw_emad_tlv_offsets {
+	u16 op_tlv;
+	u16 reg_tlv;
+};
+
+static void mlxsw_emad_tlv_parse(struct sk_buff *skb)
+{
+	struct mlxsw_emad_tlv_offsets *offsets =
+		(struct mlxsw_emad_tlv_offsets *) skb->cb;
+
+	offsets->op_tlv = MLXSW_EMAD_ETH_HDR_LEN;
+	offsets->reg_tlv = MLXSW_EMAD_ETH_HDR_LEN +
+			   MLXSW_EMAD_OP_TLV_LEN * sizeof(u32);
+}
+
 static char *mlxsw_emad_op_tlv(const struct sk_buff *skb)
 {
-	return ((char *) (skb->data + MLXSW_EMAD_ETH_HDR_LEN));
+	struct mlxsw_emad_tlv_offsets *offsets =
+		(struct mlxsw_emad_tlv_offsets *) skb->cb;
+
+	return ((char *) (skb->data + offsets->op_tlv));
 }
 
 static char *mlxsw_emad_reg_tlv(const struct sk_buff *skb)
 {
-	return ((char *) (skb->data + MLXSW_EMAD_ETH_HDR_LEN +
-				      MLXSW_EMAD_OP_TLV_LEN * sizeof(u32)));
+	struct mlxsw_emad_tlv_offsets *offsets =
+		(struct mlxsw_emad_tlv_offsets *) skb->cb;
+
+	return ((char *) (skb->data + offsets->reg_tlv));
 }
 
-static char *mlxsw_emad_reg_payload(const char *op_tlv)
+static char *mlxsw_emad_reg_payload(const char *reg_tlv)
 {
-	return ((char *) (op_tlv + (MLXSW_EMAD_OP_TLV_LEN + 1) * sizeof(u32)));
+	return ((char *) (reg_tlv + sizeof(u32)));
+}
+
+static char *mlxsw_emad_reg_payload_cmd(const char *mbox)
+{
+	return ((char *) (mbox + (MLXSW_EMAD_OP_TLV_LEN + 1) * sizeof(u32)));
 }
 
 static u64 mlxsw_emad_get_tid(const struct sk_buff *skb)
@@ -535,11 +560,11 @@ static void mlxsw_emad_process_response(struct mlxsw_core *mlxsw_core,
 		mlxsw_emad_transmit_retry(mlxsw_core, trans);
 	} else {
 		if (err == 0) {
-			char *op_tlv = mlxsw_emad_op_tlv(skb);
+			char *reg_tlv = mlxsw_emad_reg_tlv(skb);
 
 			if (trans->cb)
 				trans->cb(mlxsw_core,
-					  mlxsw_emad_reg_payload(op_tlv),
+					  mlxsw_emad_reg_payload(reg_tlv),
 					  trans->reg->len, trans->cb_priv);
 		}
 		mlxsw_emad_trans_finish(trans, err);
@@ -556,6 +581,8 @@ static void mlxsw_emad_rx_listener_func(struct sk_buff *skb, u8 local_port,
 	trace_devlink_hwmsg(priv_to_devlink(mlxsw_core), true, 0,
 			    skb->data, skb->len);
 
+	mlxsw_emad_tlv_parse(skb);
+
 	if (!mlxsw_emad_is_resp(skb))
 		goto free_skb;
 
@@ -1395,12 +1422,16 @@ static void mlxsw_core_event_listener_func(struct sk_buff *skb, u8 local_port,
 	struct mlxsw_event_listener_item *event_listener_item = priv;
 	struct mlxsw_reg_info reg;
 	char *payload;
-	char *op_tlv = mlxsw_emad_op_tlv(skb);
-	char *reg_tlv = mlxsw_emad_reg_tlv(skb);
+	char *reg_tlv;
+	char *op_tlv;
+
+	mlxsw_emad_tlv_parse(skb);
+	op_tlv = mlxsw_emad_op_tlv(skb);
+	reg_tlv = mlxsw_emad_reg_tlv(skb);
 
 	reg.id = mlxsw_emad_op_tlv_register_id_get(op_tlv);
 	reg.len = (mlxsw_emad_reg_tlv_len_get(reg_tlv) - 1) * sizeof(u32);
-	payload = mlxsw_emad_reg_payload(op_tlv);
+	payload = mlxsw_emad_reg_payload(reg_tlv);
 	event_listener_item->el.func(&reg, payload, event_listener_item->priv);
 	dev_kfree_skb(skb);
 }
@@ -1713,7 +1744,7 @@ static int mlxsw_core_reg_access_cmd(struct mlxsw_core *mlxsw_core,
 	}
 
 	if (!err)
-		memcpy(payload, mlxsw_emad_reg_payload(out_mbox),
+		memcpy(payload, mlxsw_emad_reg_payload_cmd(out_mbox),
 		       reg->len);
 
 	mlxsw_cmd_mbox_free(out_mbox);
-- 
2.21.0

