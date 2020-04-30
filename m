Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27ED1C036D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgD3RBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:01:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59205 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgD3RBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:01:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2D9115C0118;
        Thu, 30 Apr 2020 13:01:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 13:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ezh9uupVyKuPr0J1tCqo9lHb8ATfh29DVrGOq22duHM=; b=ohizH+OC
        sMyjVjE+zyKTw6BJf7qAJcRxVsu0eyOV+JypgD6B4F2jRIvwBOyr7xUNSj+9Fqf5
        j0wfzKD2y21Tkw1QSpN6vH5tVQn1aI1bePi9CHQOoFw7Y9ljrr9IPXiATr8DDBkh
        ON2CzWLqYkJc1zbVXaT+Pc/+jYw2v97RYUEVIEv4Tg0kV6pD5+fJ4m733HRLQzWh
        tGcBzQ0fAJaFYSOIofBFyOowLCXgnQfTah1dA3xF3G7H2eyK9qYbSKumLkm24jnL
        eMkl07z4c4tDlU1kSFHF4YrHX8g/01gW1BKhlOi2h6Gkk51PVQYWAlPj9kcuW8Nq
        leZhdY/oXBxlkA==
X-ME-Sender: <xms:fwSrXrJooBEl-EZaRn9FwZfT_ol6avgJ0Ne1jA-qVt1fZGOPknZ3Gg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudektddrheegrdduudei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:fwSrXlLRXP4-xPkyvRHYMaoHp76Ds55d2xO-QnZ89-HDsoHO_jjWBA>
    <xmx:fwSrXgK1KXjyrtNsBblO-IsQdsM2GW4guBNwU_lWwMs_cIwjioWbgA>
    <xmx:fwSrXp_-prAoyg0LtnkuOpt9-N2vg198M5F6Jk-TqtuMC8D06wcbJg>
    <xmx:gASrXgHD2xiwlM25KMTPGUwZ2oMM32w4tMWFFF8HZk4XJtBjoJ9mNw>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 975693065F36;
        Thu, 30 Apr 2020 13:01:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/9] mlxsw: spectrum_span: Wrap buffer change in a function
Date:   Thu, 30 Apr 2020 20:01:11 +0300
Message-Id: <20200430170116.4081677-5-idosch@idosch.org>
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

The code that adjusts the egress buffer size is not symmetric at the
moment. The update is done via a call to
mlxsw_sp_span_port_buffer_update(), but the disablement is done inline
by invoking the write to SBIB register directly.

Wrap the disablement code in mlxsw_sp_span_port_buffer_disable().

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Suggested-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index c52f79a97f36..2b9d8ce93b13 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -803,6 +803,15 @@ mlxsw_sp_span_port_buffer_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
 }
 
+static void mlxsw_sp_span_port_buffer_disable(struct mlxsw_sp *mlxsw_sp,
+					      u8 local_port)
+{
+	char sbib_pl[MLXSW_REG_SBIB_LEN];
+
+	mlxsw_reg_sbib_pack(sbib_pl, local_port, 0);
+	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
+}
+
 int mlxsw_sp_span_port_mtu_update(struct mlxsw_sp_port *port, u16 mtu)
 {
 	/* If port is egress mirrored, the shared buffer size should be
@@ -1154,15 +1163,13 @@ mlxsw_sp_span_analyzed_port_destroy(struct mlxsw_sp_span *span,
 				    analyzed_port)
 {
 	struct mlxsw_sp *mlxsw_sp = span->mlxsw_sp;
-	char sbib_pl[MLXSW_REG_SBIB_LEN];
 
 	/* Remove egress mirror buffer now that port is no longer analyzed
 	 * at egress.
 	 */
-	if (!analyzed_port->ingress) {
-		mlxsw_reg_sbib_pack(sbib_pl, analyzed_port->local_port, 0);
-		mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
-	}
+	if (!analyzed_port->ingress)
+		mlxsw_sp_span_port_buffer_disable(mlxsw_sp,
+						  analyzed_port->local_port);
 
 	list_del(&analyzed_port->list);
 	kfree(analyzed_port);
-- 
2.24.1

