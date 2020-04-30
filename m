Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D881E1C036F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgD3RB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:01:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48201 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726404AbgD3RB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:01:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4237C5C0118;
        Thu, 30 Apr 2020 13:01:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 13:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=EpLbL+lyTvWtu9UAT6Oka2BbeZo/1uNl8ZuAerQLtbg=; b=QZtjQNg6
        N+iawDI1T/uZ+J9IVVFcxkHdgmMEjzEMUC0F162Ad0I41o+3Y8RKslmdJv/g7p72
        L0eQl/1ZYJ7DXO2g+pkMKCBK+SiChSqrJAEuBYTjIm1affaWayt+jRbecq49UeMQ
        n5rwGGoyyuEG93bHprWpVww16JuG2cSj1XHbiBA7gjc5K1U7XQJI7CZDnVbHEU/5
        WLALBXQl8G5e0kyTTHlkIvAqUQKqehhFn+Dg6bA7EXew1ehBzrZgROrnJ8CqQd91
        Eo7XEPIXyhphT2gVQZ7fAT5uKlOIqjAzN0BzdSyKD2zOOp6hI3fnZNTajLNwyAHL
        k0YP1NP3ZfzgpA==
X-ME-Sender: <xms:gwSrXgZbNu33bujFaEKDhCaINQZ0tPwShxspKN93EgpyWISccSigqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudektddrheegrdduudei
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:gwSrXlZDXWjYbYOLmx1U5EM6xNxeVSftt03b6Eic7NSoxl0raXg5Aw>
    <xmx:gwSrXhl-uwlJq0wwe3GbAbEHKECpz6vCUEZdzx3dwMaitE8iLIyzAg>
    <xmx:gwSrXo0k42Us_ZS53u8vrCN6fV6oEDvXy40yLWLqIq1JoDoLUl6tTQ>
    <xmx:gwSrXuHFl0DOXg5sMGYIudiDJ6JJo5PL7b1T2cE7CgObhs4MBneJNQ>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id D0F7C3065F39;
        Thu, 30 Apr 2020 13:01:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/9] mlxsw: spectrum: Convert matchall-based mirroring to new SPAN API
Date:   Thu, 30 Apr 2020 20:01:13 +0300
Message-Id: <20200430170116.4081677-7-idosch@idosch.org>
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

In matchall-based mirroring, mirroring is not done with ACLs, but a SPAN
agent is bound to the ingress / egress of a port and all incoming /
outgoing traffic is mirrored.

Convert this type of mirroring to use the new API.

First the SPAN agent is resolved, then the port is marked as analyzed
and its egress mirror buffer is potentially allocated. Lastly, the
binding is performed.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_matchall.c        | 52 ++++++++++++++-----
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index 889da63072be..da1c05f44cec 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -48,31 +48,57 @@ static int
 mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_mall_entry *mall_entry)
 {
-	enum mlxsw_sp_span_type span_type;
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_span_trigger_parms parms;
+	enum mlxsw_sp_span_trigger trigger;
+	int err;
 
 	if (!mall_entry->mirror.to_dev) {
 		netdev_err(mlxsw_sp_port->dev, "Could not find requested device\n");
 		return -EINVAL;
 	}
 
-	span_type = mall_entry->ingress ? MLXSW_SP_SPAN_INGRESS :
-					  MLXSW_SP_SPAN_EGRESS;
-	return mlxsw_sp_span_mirror_add(mlxsw_sp_port,
-					mall_entry->mirror.to_dev,
-					span_type, true,
-					&mall_entry->mirror.span_id);
+	err = mlxsw_sp_span_agent_get(mlxsw_sp, mall_entry->mirror.to_dev,
+				      &mall_entry->mirror.span_id);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port,
+					      mall_entry->ingress);
+	if (err)
+		goto err_analyzed_port_get;
+
+	trigger = mall_entry->ingress ? MLXSW_SP_SPAN_TRIGGER_INGRESS :
+					MLXSW_SP_SPAN_TRIGGER_EGRESS;
+	parms.span_id = mall_entry->mirror.span_id;
+	err = mlxsw_sp_span_agent_bind(mlxsw_sp, trigger, mlxsw_sp_port,
+				       &parms);
+	if (err)
+		goto err_agent_bind;
+
+	return 0;
+
+err_agent_bind:
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, mall_entry->ingress);
+err_analyzed_port_get:
+	mlxsw_sp_span_agent_put(mlxsw_sp, mall_entry->mirror.span_id);
+	return err;
 }
 
 static void
 mlxsw_sp_mall_port_mirror_del(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_mall_entry *mall_entry)
 {
-	enum mlxsw_sp_span_type span_type;
-
-	span_type = mall_entry->ingress ? MLXSW_SP_SPAN_INGRESS :
-					  MLXSW_SP_SPAN_EGRESS;
-	mlxsw_sp_span_mirror_del(mlxsw_sp_port, mall_entry->mirror.span_id,
-				 span_type, true);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_span_trigger_parms parms;
+	enum mlxsw_sp_span_trigger trigger;
+
+	trigger = mall_entry->ingress ? MLXSW_SP_SPAN_TRIGGER_INGRESS :
+					MLXSW_SP_SPAN_TRIGGER_EGRESS;
+	parms.span_id = mall_entry->mirror.span_id;
+	mlxsw_sp_span_agent_unbind(mlxsw_sp, trigger, mlxsw_sp_port, &parms);
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, mall_entry->ingress);
+	mlxsw_sp_span_agent_put(mlxsw_sp, mall_entry->mirror.span_id);
 }
 
 static int mlxsw_sp_mall_port_sample_set(struct mlxsw_sp_port *mlxsw_sp_port,
-- 
2.24.1

