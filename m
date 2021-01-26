Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E704730403B
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 15:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405794AbhAZO0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 09:26:30 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:42679 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391796AbhAZN00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:26:26 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 064049AD;
        Tue, 26 Jan 2021 08:24:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 26 Jan 2021 08:24:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zwIbhvLChB9mzksDVsrC1qX4DJ/XJGT6G6n3TkVtF1c=; b=jIJT3FbZ
        SbLbKCVTRmMFJ8RilIFOHX3Bbwf2zhB4rOxdnX/TrJ0AFgNlMbQ4mlvhSWa3KW/s
        j1jk5RDCKen2t/cQnuvGfbcGsrbH2sdQmqY0lePMQWhEw4C8OWKVzhHpdN6wjT9c
        plovbWDUj0GpnR1zFSD3li5dSGvjwyzE/lF5/SRO4L9q6/AZPIeTvPqMRmExopb+
        lRk9fb1v6L3MJKcnvsKT4lm1YkF5OFVPhIA4wC6qA32mVf7LYZablpUxvzQg85wm
        B27oru8gZnAB2FbeRdaVDL5UxEMEIRI6agSdwdCRiJ+f1EbjqXMnWDzLqB1K4/64
        QCcc9r8ys8KCgQ==
X-ME-Sender: <xms:DhgQYGIxoY3YFttxVv2UUX98zMBEqBxHrAsp3PWp2B2ZiFhxqdkOMw>
    <xme:DhgQYHzF7H01TklPe1um78cYofFf2dP2dVTTP05HqTcJc_ucTScKaRJtNvbEwDYds
    Neab9WwN3Rlb4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:DhgQYGt1X59vr4kGOmH0JRYXsM9TRGnyTDysGu-5mBR1GMZNgwyxMQ>
    <xmx:DhgQYOsoRdwOMzleOebVKMUsByCcB4hAWzjDNHXIMSJ7GnHKTO7Zig>
    <xmx:DhgQYLMRpFfYWkrUNKuItKEUD0c6RiEosa5GyVoFW5NFPcQFe-sMGA>
    <xmx:DhgQYIEVxcHRedtA1iaPJPRwfYFjlxnaid7nLnjfPqWRRB9FuhxB5A>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id F3E92108005C;
        Tue, 26 Jan 2021 08:24:27 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        amcohen@nvidia.com, roopa@nvidia.com, sharpd@nvidia.com,
        bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/10] net: Do not call fib6_info_hw_flags_set() when IPv6 is disabled
Date:   Tue, 26 Jan 2021 15:23:08 +0200
Message-Id: <20210126132311.3061388-8-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126132311.3061388-1-idosch@idosch.org>
References: <20210126132311.3061388-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

With the next patch mlxsw and netdevsim will fail in compilation if
CONFIG_IPV6 is disabled.

Do not call fib6_info_hw_flags_set() when IPv6 is disabled.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c    | 16 ++++++++++++++++
 drivers/net/netdevsim/fib.c                      |  8 ++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 60acb9292451..1480d6b68ccf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4960,6 +4960,7 @@ mlxsw_sp_fib4_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 	fib_alias_hw_flags_set(mlxsw_sp_net(mlxsw_sp), &fri);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static void
 mlxsw_sp_fib6_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_fib_entry *fib_entry)
@@ -4979,7 +4980,15 @@ mlxsw_sp_fib6_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 		fib6_info_hw_flags_set(mlxsw_sp_net(mlxsw_sp), mlxsw_sp_rt6->rt,
 				       should_offload, !should_offload);
 }
+#else
+static void
+mlxsw_sp_fib6_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_fib_entry *fib_entry)
+{
+}
+#endif
 
+#if IS_ENABLED(CONFIG_IPV6)
 static void
 mlxsw_sp_fib6_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_fib_entry *fib_entry)
@@ -4993,6 +5002,13 @@ mlxsw_sp_fib6_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 		fib6_info_hw_flags_set(mlxsw_sp_net(mlxsw_sp), mlxsw_sp_rt6->rt,
 				       false, false);
 }
+#else
+static void
+mlxsw_sp_fib6_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_fib_entry *fib_entry)
+{
+}
+#endif
 
 static void
 mlxsw_sp_fib_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 21858edd2ec9..d6e846c652be 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -585,6 +585,7 @@ static int nsim_fib6_rt_append(struct nsim_fib_data *data,
 	return err;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static void nsim_fib6_rt_hw_flags_set(struct nsim_fib_data *data,
 				      const struct nsim_fib6_rt *fib6_rt,
 				      bool trap)
@@ -595,6 +596,13 @@ static void nsim_fib6_rt_hw_flags_set(struct nsim_fib_data *data,
 	list_for_each_entry(fib6_rt_nh, &fib6_rt->nh_list, list)
 		fib6_info_hw_flags_set(net, fib6_rt_nh->rt, false, trap);
 }
+#else
+static void nsim_fib6_rt_hw_flags_set(struct nsim_fib_data *data,
+				      const struct nsim_fib6_rt *fib6_rt,
+				      bool trap)
+{
+}
+#endif
 
 static int nsim_fib6_rt_add(struct nsim_fib_data *data,
 			    struct nsim_fib6_rt *fib6_rt)
-- 
2.29.2

