Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BA51E86CE
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgE2Shi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:38 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35299 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727950AbgE2Shf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 226435C00B2;
        Fri, 29 May 2020 14:37:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=NUqMwhTGtAMV8cOQi3EL7HzMFatsWdJNO+1J3S7EMAo=; b=REceyEwI
        kfRLoED71u2RzoOLf6KmH+amZpBv/0ZKMIOwzG2vxhX417Q061j7LOoPtnw8cPtP
        zpN/XNfGLdys/5jpupKTjU9MXk0dEnZchCWq9UnlmQ+O1JN5q+sdgojiIDoC93yW
        ty9Ej11RbFWQVWBXrfW814zupNvSAMbKCQwr56N6XOk+Ie+raBuf1YnZy3kmUXkz
        I3nftBKHH2UaQOE62MESVvf7K52cIq2r8afmBZLUqZV9Q8cXQ7H6TYERoPzqpd+b
        tJS34xG2pUBatuOua8UUzk1qlKB3iJZicqjGL1n1m/bCVf8YJjrYE1/iftC9b37Z
        rw/SYHDJCzOTSw==
X-ME-Sender: <xms:b1bRXk89l5wrCYE4lbWv4Dr93RrLMU6ODoNq3f4HaF7ncLMVRt23jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:b1bRXsswRNy3O_w2dOrxPNo_-Lsu5jLnyOBiTN4u_t0GzfDaPfiaCA>
    <xmx:b1bRXqCAYwmOffTiXH2Q-mR7NeUqnQaNmb-TsUnka5FuITCal-HVXw>
    <xmx:b1bRXkfwUP3STIW_nTqwKeCDQUpr0JodKXduCuQfpP2sR1B53VEoBQ>
    <xmx:b1bRXn0dRduUq_Jg9E8C7iDSAsgCKUUYVvWF5wMphc3KCb6mEtx5sQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D8D823060F09;
        Fri, 29 May 2020 14:37:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/14] mlxsw: spectrum_trap: Factor out common Rx listener function
Date:   Fri, 29 May 2020 21:36:45 +0300
Message-Id: <20200529183649.1602091-11-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529183649.1602091-1-idosch@idosch.org>
References: <20200529183649.1602091-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

We currently have an Rx listener function for exception traps that marks
received skbs with 'offload_fwd_mark' and injects them to the kernel's
Rx path. The marking is done because all these exceptions occur during
L3 forwarding, after the packets were potentially flooded at L2.

A subsequent patch will add support for control traps. Packets received
via some of these control traps need different handling:

1. Packets might not need to be marked with 'offload_fwd_mark'. For
   example, if packet was trapped before L2 forwarding

2. Packets might not need to be injected to the kernel's Rx path. For
   example, sampled packets are reported to user space via the psample
   module

Factor out a common Rx listener function that only reports trapped
packets to devlink. Call it from mlxsw_sp_rx_no_mark_listener() and
mlxsw_sp_rx_mark_listener() that will inject the packets to the kernel's
Rx path, without and with the marking, respectively.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 29 +++++++++++++++----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index dc2217f1a07f..206751963a4f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -125,8 +125,8 @@ static void mlxsw_sp_rx_acl_drop_listener(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
-static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
-					   void *trap_ctx)
+static int __mlxsw_sp_rx_no_mark_listener(struct sk_buff *skb, u8 local_port,
+					  void *trap_ctx)
 {
 	struct devlink_port *in_devlink_port;
 	struct mlxsw_sp_port *mlxsw_sp_port;
@@ -139,7 +139,7 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 
 	err = mlxsw_sp_rx_listener(mlxsw_sp, skb, local_port, mlxsw_sp_port);
 	if (err)
-		return;
+		return err;
 
 	devlink = priv_to_devlink(mlxsw_sp->core);
 	in_devlink_port = mlxsw_core_port_devlink_port_get(mlxsw_sp->core,
@@ -147,10 +147,29 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 	skb_push(skb, ETH_HLEN);
 	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port, NULL);
 	skb_pull(skb, ETH_HLEN);
-	skb->offload_fwd_mark = 1;
+
+	return 0;
+}
+
+static void mlxsw_sp_rx_no_mark_listener(struct sk_buff *skb, u8 local_port,
+					 void *trap_ctx)
+{
+	int err;
+
+	err = __mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
+	if (err)
+		return;
+
 	netif_receive_skb(skb);
 }
 
+static void mlxsw_sp_rx_mark_listener(struct sk_buff *skb, u8 local_port,
+				      void *trap_ctx)
+{
+	skb->offload_fwd_mark = 1;
+	mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
+}
+
 #define MLXSW_SP_TRAP_DROP(_id, _group_id)				      \
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
@@ -183,7 +202,7 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 		      SET_FW_DEFAULT, SP_##_dis_group_id)
 
 #define MLXSW_SP_RXL_EXCEPTION(_id, _group_id, _action)			      \
-	MLXSW_RXL(mlxsw_sp_rx_exception_listener, _id,			      \
+	MLXSW_RXL(mlxsw_sp_rx_mark_listener, _id,			      \
 		   _action, false, SP_##_group_id, SET_FW_DEFAULT)
 
 #define MLXSW_SP_TRAP_POLICER(_id, _rate, _burst)			      \
-- 
2.26.2

