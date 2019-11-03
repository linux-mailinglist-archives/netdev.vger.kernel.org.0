Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 498FDED295
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 09:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfKCIg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 03:36:29 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35695 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbfKCIg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 03:36:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B7DAF20F25;
        Sun,  3 Nov 2019 03:36:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 03 Nov 2019 03:36:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=XsR0lJB8OrfsB4FyQgXt6kpZ73joq6whpz9L3VGAGdA=; b=EJpMgTOU
        EnpyR4CH6gloJj6i/r3A+5e7osYPgoycOwkbsm2RXZ/j/AWSa19QCEP9sw8ciEGL
        T14akBESFiZIGlmazz0OfBTX91kNUx2n3qRlb285NxQFWrVNo+EmODBSDEbDgXLt
        0BJNaMI8nOEixmSGiQ7iQNhsVWvztmKYDAjIaSrRzU+pDcGOwDAcTTPHE7KXRlts
        d5J9cvRiP9CglwvKt4SfcDeDNLP6evSM+ZfCbCjwbDOQkUVUmqWib1FblbKOi3ff
        IyZZwEWgigkA/Bb0+NzMektNwSvOhxrnhIwQ2R0PGsiXLEnTYP6DNYaZkhI4dxMJ
        2hTDWy+4HvgxEw==
X-ME-Sender: <xms:i5G-XSmECfPWehJ8aAr6n_zVIO34snHEhryF1Gi1hkfD7KDjJo2FMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddutddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:i5G-XUMDBwqhjRsDdHuZgJp6haXEaQlaiGWmopjl2hkJ7XYFcV_jIg>
    <xmx:i5G-XcMWiEkmykDkhhvvJQro4SBKjVyO75gHnMxuFyvxEZnG3UHabA>
    <xmx:i5G-XQmeyPYVSRYBXnWaB2Rc6tA4tIMY3A9u5SEH_qM1QzX5lWGaYw>
    <xmx:i5G-XbCeXBTUXYt2sk4p8L1tLd4vPk-6En8Lwue03fhxZfqwk694Kg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 60F3C306005B;
        Sun,  3 Nov 2019 03:36:26 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/6] mlxsw: core: Parse TLVs' offsets of incoming EMADs
Date:   Sun,  3 Nov 2019 10:35:49 +0200
Message-Id: <20191103083554.6317-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191103083554.6317-1-idosch@idosch.org>
References: <20191103083554.6317-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Until now the code assumed a fixed structure which makes it difficult to
support EMADs with and without new TLVs.

Make it more generic by parsing the TLVs when the EMADs are received and
store the offset to the different TLVs in the control block. Use these
offsets to extract information from the EMADs without relying on a
specific structure.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 53 +++++++++++++++++-----
 1 file changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e1a90f5bddd0..3d92956047d5 100644
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
 
@@ -1390,12 +1417,16 @@ static void mlxsw_core_event_listener_func(struct sk_buff *skb, u8 local_port,
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
@@ -1708,7 +1739,7 @@ static int mlxsw_core_reg_access_cmd(struct mlxsw_core *mlxsw_core,
 	}
 
 	if (!err)
-		memcpy(payload, mlxsw_emad_reg_payload(out_mbox),
+		memcpy(payload, mlxsw_emad_reg_payload_cmd(out_mbox),
 		       reg->len);
 
 	mlxsw_cmd_mbox_free(out_mbox);
-- 
2.21.0

