Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1611121F3C7
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgGNOVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:21:48 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40507 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728208AbgGNOVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E345F5C010B;
        Tue, 14 Jul 2020 10:21:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=DG27DzmaRZq5YjEANqwgczVUAcA55//5XIYXfdgBaq8=; b=fSTSuW5e
        hYz44P7B3hkextPFqP91Mc3qrfNRTWhgLaUo+hBeG71dYFC+n62Mz+QbqX+SJo3j
        nvh1so2nZQ2xnGhh2pQbJFQ3PhPuscSTBO74hGdxxhVPJH/4X1xAmJFCR35+U9Pq
        QPYuGKDlIbk4qrlW8CNlYpn/4kUl/3Ka6SvtrEvZFsi+1kVm5ovunblSaz2oXknT
        TDgzsDnScxAFzWwqt406RiFPm/xazkgcy2XJaM/qGc+YppuDQbAyvqQNYgkP+Bhi
        Sb9Lsbg5zaYV1RgaJs5DLQ5R94xC2N/RP2sogbe/njnaZYiKtCbkDz1u+VhIKUyQ
        GmZSJJOzmsAmhA==
X-ME-Sender: <xms:eb8NX9hXA4D9tAigA0QyMjKrFDA6wV8GazijIlwKRKmGCLzf3lXKag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:eb8NXyCTbhVilha1mqB-7Tmne9u6mFzga2-4_Tox9haQiDt9uEWwOw>
    <xmx:eb8NX9G8I9EbuJq6tN7OE4XtH06AHitOOYPeq-UK4vLscOFz72bdsg>
    <xmx:eb8NXySXarsxifeJTWZVnte8hw6ggGTdIF6KtMOGAGWKsVIk31n_wA>
    <xmx:eb8NX--0GBexlRsdgyZtvAJx_-KNhfeOZExT5OkCX9FW9F7XUHr_HQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9AEF630600A9;
        Tue, 14 Jul 2020 10:21:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/13] mlxsw: spectrum_span: Add support for mirroring towards CPU port
Date:   Tue, 14 Jul 2020 17:20:59 +0300
Message-Id: <20200714142106.386354-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714142106.386354-1-idosch@idosch.org>
References: <20200714142106.386354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The Spectrum-2 and Spectrum-3 ASICs are able to mirror packets towards
the CPU. These packets are then trapped like any other packet, but with
a special packet trap and additional metadata such as why the packet was
mirrored.

The ability to mirror packets towards the CPU will be utilized by a
subsequent patch set that will mirror packets that were dropped by the
ASIC for various buffer-related reasons, such as tail-drop and
early-drop.

Add mirroring towards the CPU as a new SPAN agent type and re-use the
functions that mirror to a physical port where possible.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 88 +++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 0ef9505d336f..0336edb29cc3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -128,6 +128,38 @@ void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
 	kfree(mlxsw_sp->span);
 }
 
+static bool mlxsw_sp1_span_cpu_can_handle(const struct net_device *dev)
+{
+	return !dev;
+}
+
+static int mlxsw_sp1_span_entry_cpu_parms(struct mlxsw_sp *mlxsw_sp,
+					  const struct net_device *to_dev,
+					  struct mlxsw_sp_span_parms *sparmsp)
+{
+	return -EOPNOTSUPP;
+}
+
+static int
+mlxsw_sp1_span_entry_cpu_configure(struct mlxsw_sp_span_entry *span_entry,
+				   struct mlxsw_sp_span_parms sparms)
+{
+	return -EOPNOTSUPP;
+}
+
+static void
+mlxsw_sp1_span_entry_cpu_deconfigure(struct mlxsw_sp_span_entry *span_entry)
+{
+}
+
+static const
+struct mlxsw_sp_span_entry_ops mlxsw_sp1_span_entry_ops_cpu = {
+	.can_handle = mlxsw_sp1_span_cpu_can_handle,
+	.parms_set = mlxsw_sp1_span_entry_cpu_parms,
+	.configure = mlxsw_sp1_span_entry_cpu_configure,
+	.deconfigure = mlxsw_sp1_span_entry_cpu_deconfigure,
+};
+
 static int
 mlxsw_sp_span_entry_phys_parms(struct mlxsw_sp *mlxsw_sp,
 			       const struct net_device *to_dev,
@@ -633,6 +665,7 @@ struct mlxsw_sp_span_entry_ops mlxsw_sp_span_entry_ops_vlan = {
 
 static const
 struct mlxsw_sp_span_entry_ops *mlxsw_sp1_span_entry_ops_arr[] = {
+	&mlxsw_sp1_span_entry_ops_cpu,
 	&mlxsw_sp_span_entry_ops_phys,
 #if IS_ENABLED(CONFIG_NET_IPGRE)
 	&mlxsw_sp_span_entry_ops_gretap4,
@@ -643,8 +676,49 @@ struct mlxsw_sp_span_entry_ops *mlxsw_sp1_span_entry_ops_arr[] = {
 	&mlxsw_sp_span_entry_ops_vlan,
 };
 
+static bool mlxsw_sp2_span_cpu_can_handle(const struct net_device *dev)
+{
+	return !dev;
+}
+
+static int mlxsw_sp2_span_entry_cpu_parms(struct mlxsw_sp *mlxsw_sp,
+					  const struct net_device *to_dev,
+					  struct mlxsw_sp_span_parms *sparmsp)
+{
+	sparmsp->dest_port = mlxsw_sp->ports[MLXSW_PORT_CPU_PORT];
+	return 0;
+}
+
+static int
+mlxsw_sp2_span_entry_cpu_configure(struct mlxsw_sp_span_entry *span_entry,
+				   struct mlxsw_sp_span_parms sparms)
+{
+	/* Mirroring to the CPU port is like mirroring to any other physical
+	 * port. Its local port is used instead of that of the physical port.
+	 */
+	return mlxsw_sp_span_entry_phys_configure(span_entry, sparms);
+}
+
+static void
+mlxsw_sp2_span_entry_cpu_deconfigure(struct mlxsw_sp_span_entry *span_entry)
+{
+	enum mlxsw_reg_mpat_span_type span_type;
+
+	span_type = MLXSW_REG_MPAT_SPAN_TYPE_LOCAL_ETH;
+	mlxsw_sp_span_entry_deconfigure_common(span_entry, span_type);
+}
+
+static const
+struct mlxsw_sp_span_entry_ops mlxsw_sp2_span_entry_ops_cpu = {
+	.can_handle = mlxsw_sp2_span_cpu_can_handle,
+	.parms_set = mlxsw_sp2_span_entry_cpu_parms,
+	.configure = mlxsw_sp2_span_entry_cpu_configure,
+	.deconfigure = mlxsw_sp2_span_entry_cpu_deconfigure,
+};
+
 static const
 struct mlxsw_sp_span_entry_ops *mlxsw_sp2_span_entry_ops_arr[] = {
+	&mlxsw_sp2_span_entry_ops_cpu,
 	&mlxsw_sp_span_entry_ops_phys,
 #if IS_ENABLED(CONFIG_NET_IPGRE)
 	&mlxsw_sp_span_entry_ops_gretap4,
@@ -1540,6 +1614,13 @@ static int mlxsw_sp1_span_init(struct mlxsw_sp *mlxsw_sp)
 {
 	size_t arr_size = ARRAY_SIZE(mlxsw_sp1_span_entry_ops_arr);
 
+	/* Must be first to avoid NULL pointer dereference by subsequent
+	 * can_handle() callbacks.
+	 */
+	if (WARN_ON(mlxsw_sp1_span_entry_ops_arr[0] !=
+		    &mlxsw_sp1_span_entry_ops_cpu))
+		return -EINVAL;
+
 	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp1_span_trigger_ops_arr;
 	mlxsw_sp->span->span_entry_ops_arr = mlxsw_sp1_span_entry_ops_arr;
 	mlxsw_sp->span->span_entry_ops_arr_size = arr_size;
@@ -1561,6 +1642,13 @@ static int mlxsw_sp2_span_init(struct mlxsw_sp *mlxsw_sp)
 {
 	size_t arr_size = ARRAY_SIZE(mlxsw_sp2_span_entry_ops_arr);
 
+	/* Must be first to avoid NULL pointer dereference by subsequent
+	 * can_handle() callbacks.
+	 */
+	if (WARN_ON(mlxsw_sp2_span_entry_ops_arr[0] !=
+		    &mlxsw_sp2_span_entry_ops_cpu))
+		return -EINVAL;
+
 	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp2_span_trigger_ops_arr;
 	mlxsw_sp->span->span_entry_ops_arr = mlxsw_sp2_span_entry_ops_arr;
 	mlxsw_sp->span->span_entry_ops_arr_size = arr_size;
-- 
2.26.2

