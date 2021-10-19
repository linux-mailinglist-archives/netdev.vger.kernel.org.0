Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5434330C6
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbhJSIK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:10:29 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47291 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234561AbhJSIKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:10:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3CA9C5C015C;
        Tue, 19 Oct 2021 04:08:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 19 Oct 2021 04:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=W2rGgMMLI3MtLFJQfvVLF+wTP/lX2SYmN0PkhicNKKI=; b=iWw3pVSR
        IO6IV0cDfLHKrVw08tFgKugcIylLJcDtPvhudHwL5tSpAOApIundZ6GnpNbX6IeH
        phsoXAdNp22q96XSuotk7BpK21DJfFc2ApzZwbfn89DfKvwlCpvYmpPmhxB3A9An
        D9L2s7ClpROnqIre3fH3UbAUj/b+li2rgBdEizL3NAErSmay1Nlf0/vSgc7Tu4Kn
        q+JXaVgtsjz9CbUP4JPBU1Ro38stzoQjd9TGzB4dM3BcGcuDqk6QFycSh7lVlEm0
        xRq/iW/b6Gpb6HS5CF75QrRs2+Z30h838nIJ/jLsnMWs1ukAOzDQ8SWraIAmMYWn
        IYSz04guE80EjQ==
X-ME-Sender: <xms:6nxuYY_zU-mN5v2ZyM2_9wHPwIevPfvaHETlrtAiys3OVmZ10pM3Yg>
    <xme:6nxuYQtKW5fFMYh9gUS1tmcS_xAgNkuJmLv0goOfVnxUyxBmT6zCuFbraAO6wwFtg
    IvnztYFLvuFK3A>
X-ME-Received: <xmr:6nxuYeDA6Dm52Ctc0jtJ8r6bOYdSCbXhtuIYKhxX3UJmEfWMss95oKF1cHnxC8dcxdh05xHLk8IdFBYoip8L0ouf4GKeiZAK0KWXjumFlec>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6nxuYYfLxhgGzO8qxkAamL9TfYDen7_ICSpEKVhh8-ziZx1iIbtRWA>
    <xmx:6nxuYdO2Nxbbelh-c5BnCcFXSZ7uz51rtFj5ulnMjvyjxhZH8Qs-zw>
    <xmx:6nxuYSkGZYm9BJRxSyUwy9dF8tIUkS93JsGX6LuQCFEKzhR1Q0cZ3w>
    <xmx:6nxuYZBacY4xg8mRlhaJABisW1PSC6e-giuyKATq_7ruFwcuVgin2Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 04:08:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/9] mlxsw: spectrum_qdisc: Destroy children in mlxsw_sp_qdisc_destroy()
Date:   Tue, 19 Oct 2021 11:07:07 +0300
Message-Id: <20211019080712.705464-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019080712.705464-1-idosch@idosch.org>
References: <20211019080712.705464-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Currently ETS and PRIO are the only offloaded classful qdiscs. Since they
are both similar, their destroy handler is the same, and it handles
children destruction itself. But now it is possible to do it generically
for any classful qdisc. Therefore promote the recursive destruction from
the ETS handler to mlxsw_sp_qdisc_destroy(), so that RED and TBF pick it up
in follow-up patches.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 7f29f51bdf1b..8ececee1b79b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -232,6 +232,7 @@ mlxsw_sp_qdisc_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp_qdisc *root_qdisc = &mlxsw_sp_port->qdisc->root_qdisc;
 	int err_hdroom = 0;
 	int err = 0;
+	int i;
 
 	if (!mlxsw_sp_qdisc)
 		return 0;
@@ -249,6 +250,9 @@ mlxsw_sp_qdisc_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!mlxsw_sp_qdisc->ops)
 		return 0;
 
+	for (i = 0; i < mlxsw_sp_qdisc->num_classes; i++)
+		mlxsw_sp_qdisc_destroy(mlxsw_sp_port,
+				       &mlxsw_sp_qdisc->qdiscs[i]);
 	mlxsw_sp_qdisc_reduce_parent_backlog(mlxsw_sp_qdisc);
 	if (mlxsw_sp_qdisc->ops->destroy)
 		err = mlxsw_sp_qdisc->ops->destroy(mlxsw_sp_port,
@@ -1123,8 +1127,6 @@ static int __mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 		mlxsw_sp_port_ets_set(mlxsw_sp_port,
 				      MLXSW_REG_QEEC_HR_SUBGROUP,
 				      i, 0, false, 0);
-		mlxsw_sp_qdisc_destroy(mlxsw_sp_port,
-				       &mlxsw_sp_qdisc->qdiscs[i]);
 	}
 
 	kfree(mlxsw_sp_qdisc->ets_data);
-- 
2.31.1

