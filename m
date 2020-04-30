Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1541C0370
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgD3RB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:01:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33761 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727791AbgD3RB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:01:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C1D495C0115;
        Thu, 30 Apr 2020 13:01:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 13:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=eZcwYXGIKcAs40B9vScwqLbzUG92smo7SRJQup/HVao=; b=Vwy4sSit
        RodzW5yOGLElutZ88ak1ON4GEe/WaubzNYxg1Kc9zo/uRO6irah9twO+kOgSjArH
        EdgAzwICpRC2jLE2m6P3UU0MYkH5/sBVfHij3kl1BJUb4ZeCzGU3S+Lxf6X8hKni
        g77nnDjkS4IHlWQQa85DPKIVH6flGTZY4gUo2jrpfueVlznajt49Q3k2ZcfNYE3P
        F+gQzrvqNmTH4Gh/ohigkoNgctRK6bbo3wHKDmBnJzEQC7NDbaB5x7WIu7bnkxMc
        UjGh+hGjzfbUW7zSLfQeyycHGp7eiNev9Mp0pdjOkRKEmEF/LURKdN3Y9bpZHYlW
        JW8PvoB4PV2wdw==
X-ME-Sender: <xms:hASrXlRmv4z060c6XT2I1rwFj3mBIt-eVarmYKo0CH4WqOKbC9n_Qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudektddrheegrdduudei
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:hASrXjD_ArLLuISwG-05aX7Ze7kXu2Ay-hXzZnbWdD_eSUmLqOA7DA>
    <xmx:hASrXl20dh6glVSqTxR4R7_soN-3193r5_F3zRbfU5RGSrAS_trUAg>
    <xmx:hASrXhVjUZk6QD2WejogcMFNk8BNU68Qlem_Gisb0zFEmeAXjcdMyA>
    <xmx:hASrXrg0bAPus9yBcpvDUCJoh8HmP6suKXSVktQHE_3xwY2rLOqMhg>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5619C3065F39;
        Thu, 30 Apr 2020 13:01:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/9] mlxsw: spectrum_acl: Convert flower-based mirroring to new SPAN API
Date:   Thu, 30 Apr 2020 20:01:14 +0300
Message-Id: <20200430170116.4081677-8-idosch@idosch.org>
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

In flower-based mirroring, mirroring is done with ACLs and the SPAN
agent is not bound to a port. Instead its identifier is specified in an
ACL action.

Convert this type of mirroring to use the new API.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../mlxsw/spectrum_acl_flex_actions.c         | 31 ++++++++++++-------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
index e47d1d286e93..73d56012654b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
@@ -136,28 +136,35 @@ mlxsw_sp_act_mirror_add(void *priv, u8 local_in_port,
 			const struct net_device *out_dev,
 			bool ingress, int *p_span_id)
 {
-	struct mlxsw_sp_port *in_port;
+	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp *mlxsw_sp = priv;
-	enum mlxsw_sp_span_type type;
+	int err;
 
-	type = ingress ? MLXSW_SP_SPAN_INGRESS : MLXSW_SP_SPAN_EGRESS;
-	in_port = mlxsw_sp->ports[local_in_port];
+	err = mlxsw_sp_span_agent_get(mlxsw_sp, out_dev, p_span_id);
+	if (err)
+		return err;
+
+	mlxsw_sp_port = mlxsw_sp->ports[local_in_port];
+	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port, ingress);
+	if (err)
+		goto err_analyzed_port_get;
 
-	return mlxsw_sp_span_mirror_add(in_port, out_dev, type,
-					false, p_span_id);
+	return 0;
+
+err_analyzed_port_get:
+	mlxsw_sp_span_agent_put(mlxsw_sp, *p_span_id);
+	return err;
 }
 
 static void
 mlxsw_sp_act_mirror_del(void *priv, u8 local_in_port, int span_id, bool ingress)
 {
+	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp *mlxsw_sp = priv;
-	struct mlxsw_sp_port *in_port;
-	enum mlxsw_sp_span_type type;
-
-	type = ingress ? MLXSW_SP_SPAN_INGRESS : MLXSW_SP_SPAN_EGRESS;
-	in_port = mlxsw_sp->ports[local_in_port];
 
-	mlxsw_sp_span_mirror_del(in_port, span_id, type, false);
+	mlxsw_sp_port = mlxsw_sp->ports[local_in_port];
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, ingress);
+	mlxsw_sp_span_agent_put(mlxsw_sp, span_id);
 }
 
 const struct mlxsw_afa_ops mlxsw_sp1_act_afa_ops = {
-- 
2.24.1

