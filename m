Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D5D21F3C3
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgGNOVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:21:41 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35587 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgGNOVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 587455C00EC;
        Tue, 14 Jul 2020 10:21:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=zo7AadPaHNpyVjWMrNsWmwE+fGmg7NJBJovxCmd7VvA=; b=jjQadOfY
        /G1KU9Sab9j/3Dqh/KKQtFsUVR9uhWlyPC+VKKdsyJOI5h2J9uNGGPIDosCRSqbH
        5jfgJjjqQH2j6uDNt9K5wzoFJcICCB34r5JbLS2F79ShGQPWbjkZPusXOuvitU/G
        A2Yx1Pmzk4lGTu4dFB/uIAv/BDV0ArmbJN9ah+97/J89eRF7Gf4NHBfCDQwaOiFi
        eDPuym0K1Kr7U0f+YpEmePlvqlI+tFtEyi1ni+XnmthVLeXKjfp+FY9AzZIWwXS+
        Nn8dwWIemaWdEvhdhx2iZHnOfxz2kl122v2AO/10dX4YBpgX9kUWYWwI6WpNWIIu
        a7B47nP8abditA==
X-ME-Sender: <xms:c78NX4nXHCcZDP1kme-u4fjRH9DaLSFM5739_SetzT9kyFNc04JMFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:c78NX333Llnf5KEEi2qC4ay0Fb_-fYPcB5IVvag-AP_IBzriCFUERg>
    <xmx:c78NX2oG9q_A5nXrtzGrtcu5JeY7CoJZeSoO9NUGxgQ2-haMirG4Tw>
    <xmx:c78NX0ljHxA8iWKN9UGKELvA3MNN6UIZBGb_186HXNc7JpF4pRCA8A>
    <xmx:c78NX7x6z6ypEg801F5yEFFOpw7cAqfNuOzYXnSSThUd1GUaOh7wRQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A7A730600A9;
        Tue, 14 Jul 2020 10:21:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/13] mlxsw: spectrum_span: Add per-ASIC SPAN agent operations
Date:   Tue, 14 Jul 2020 17:20:56 +0300
Message-Id: <20200714142106.386354-4-idosch@idosch.org>
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

The various SPAN agent types differ in their mirror targets (i.e.,
physical port netdev vs. VLAN netdev) and the encapsulation headers that
they need to encapsulate the mirrored packets with.

The Spectrum-2 and Spectrum-3 ASICs support a SPAN agent type that is
able to mirror towards the CPU, whereas the Spectrum-1 ASIC does not.

Prepare for the addition of this new SPAN agent type by splitting the
SPAN agent operations to be per-ASIC.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 31 ++++++++++++++++---
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 6374765a112d..6a257eb0df49 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -22,6 +22,8 @@ struct mlxsw_sp_span {
 	struct work_struct work;
 	struct mlxsw_sp *mlxsw_sp;
 	const struct mlxsw_sp_span_trigger_ops **span_trigger_ops_arr;
+	const struct mlxsw_sp_span_entry_ops **span_entry_ops_arr;
+	size_t span_entry_ops_arr_size;
 	struct list_head analyzed_ports_list;
 	struct mutex analyzed_ports_lock; /* Protects analyzed_ports_list */
 	struct list_head trigger_entries_list;
@@ -626,7 +628,19 @@ struct mlxsw_sp_span_entry_ops mlxsw_sp_span_entry_ops_vlan = {
 };
 
 static const
-struct mlxsw_sp_span_entry_ops *const mlxsw_sp_span_entry_types[] = {
+struct mlxsw_sp_span_entry_ops *mlxsw_sp1_span_entry_ops_arr[] = {
+	&mlxsw_sp_span_entry_ops_phys,
+#if IS_ENABLED(CONFIG_NET_IPGRE)
+	&mlxsw_sp_span_entry_ops_gretap4,
+#endif
+#if IS_ENABLED(CONFIG_IPV6_GRE)
+	&mlxsw_sp_span_entry_ops_gretap6,
+#endif
+	&mlxsw_sp_span_entry_ops_vlan,
+};
+
+static const
+struct mlxsw_sp_span_entry_ops *mlxsw_sp2_span_entry_ops_arr[] = {
 	&mlxsw_sp_span_entry_ops_phys,
 #if IS_ENABLED(CONFIG_NET_IPGRE)
 	&mlxsw_sp_span_entry_ops_gretap4,
@@ -894,11 +908,12 @@ static const struct mlxsw_sp_span_entry_ops *
 mlxsw_sp_span_entry_ops(struct mlxsw_sp *mlxsw_sp,
 			const struct net_device *to_dev)
 {
+	struct mlxsw_sp_span *span = mlxsw_sp->span;
 	size_t i;
 
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_span_entry_types); ++i)
-		if (mlxsw_sp_span_entry_types[i]->can_handle(to_dev))
-			return mlxsw_sp_span_entry_types[i];
+	for (i = 0; i < span->span_entry_ops_arr_size; ++i)
+		if (span->span_entry_ops_arr[i]->can_handle(to_dev))
+			return span->span_entry_ops_arr[i];
 
 	return NULL;
 }
@@ -1519,7 +1534,11 @@ void mlxsw_sp_span_trigger_disable(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int mlxsw_sp1_span_init(struct mlxsw_sp *mlxsw_sp)
 {
+	size_t arr_size = ARRAY_SIZE(mlxsw_sp1_span_entry_ops_arr);
+
 	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp1_span_trigger_ops_arr;
+	mlxsw_sp->span->span_entry_ops_arr = mlxsw_sp1_span_entry_ops_arr;
+	mlxsw_sp->span->span_entry_ops_arr_size = arr_size;
 
 	return 0;
 }
@@ -1536,7 +1555,11 @@ const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
 
 static int mlxsw_sp2_span_init(struct mlxsw_sp *mlxsw_sp)
 {
+	size_t arr_size = ARRAY_SIZE(mlxsw_sp2_span_entry_ops_arr);
+
 	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp2_span_trigger_ops_arr;
+	mlxsw_sp->span->span_entry_ops_arr = mlxsw_sp2_span_entry_ops_arr;
+	mlxsw_sp->span->span_entry_ops_arr_size = arr_size;
 
 	return 0;
 }
-- 
2.26.2

