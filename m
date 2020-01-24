Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B13E1485EA
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389612AbgAXNYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:15 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58321 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389518AbgAXNYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:14 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B99F421F32;
        Fri, 24 Jan 2020 08:24:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=atn48cDpK3vzxNNmizqcqqY9JkMedmuY89Lgdg1QKlk=; b=DnjDaMBV
        wrQLpoVFtGNilZBomQ6uCWAmi1t/IYBVHTlGe1A/irnM9LWLAShtFuBJoG2vGHzr
        jd59+0Tp9rsrrnD53Om9zWPBmq5Q2USrRHBRBluQJ+jy5f7dbmZuQ3EzTVWolnjC
        GyWgJyA6in5dvmCV7oVPg0ErX18+3X5luMT5wQmU3GVgR7jtZZszXv66xQkv3LTg
        M6uLlSytRFvET2Vj7dHaWvnDgDk2yPTNHRc88mX7ZLj0mACJ/1OsaRXwu4Vhf1Sf
        3MlFIxu7YonVDg2kqa7GfihyEfGGfBSlrkkROsU0JHj74/E5kjwFUWmqh7OX2VdI
        Kbk0qeRkWA9RAA==
X-ME-Sender: <xms:_e8qXku49o45pes4W67i6F7uON63nUQd6wCU07lmgPtq_DLU22hMeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:_e8qXs1wTJDFU5rYS-_hrObF-Wd7KbkxUtWIf-2TNJAfblbgNwSy2w>
    <xmx:_e8qXtq59Tim88V4s91q5PWywneqzA98Spief2_Ecj-WoWcNpGdY2A>
    <xmx:_e8qXiWHrg2anf6WsKbeCkomNOQYq1vqnwb6B62r1mBEIjVIsVaEtg>
    <xmx:_e8qXunS3hOVyFlkdiUnMM-4sLEa6lbNELZG3i_qnWDwNy0YgYyKpQ>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9CF613060E01;
        Fri, 24 Jan 2020 08:24:11 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/14] mlxsw: spectrum_qdisc: Extract a common leaf unoffload function
Date:   Fri, 24 Jan 2020 15:23:09 +0200
Message-Id: <20200124132318.712354-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

When the RED Qdisc is unoffloaded, it needs to reduce the reported backlog
by the amount that is in the HW, so that only the SW backlog is contained
in the counter. The same thing will need to be done by TBF, and likely any
other leaf Qdisc as well.

Extract a helper mlxsw_sp_qdisc_leaf_unoffload() and call it from
mlxsw_sp_qdisc_red_unoffload().

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index a0f07e951607..57b014a95bc8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -421,19 +421,28 @@ mlxsw_sp_qdisc_red_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static void
-mlxsw_sp_qdisc_red_unoffload(struct mlxsw_sp_port *mlxsw_sp_port,
-			     struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
-			     void *params)
+mlxsw_sp_qdisc_leaf_unoffload(struct mlxsw_sp_port *mlxsw_sp_port,
+			      struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			      struct gnet_stats_queue *qstats)
 {
-	struct tc_red_qopt_offload_params *p = params;
 	u64 backlog;
 
 	backlog = mlxsw_sp_cells_bytes(mlxsw_sp_port->mlxsw_sp,
 				       mlxsw_sp_qdisc->stats_base.backlog);
-	p->qstats->backlog -= backlog;
+	qstats->backlog -= backlog;
 	mlxsw_sp_qdisc->stats_base.backlog = 0;
 }
 
+static void
+mlxsw_sp_qdisc_red_unoffload(struct mlxsw_sp_port *mlxsw_sp_port,
+			     struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			     void *params)
+{
+	struct tc_red_qopt_offload_params *p = params;
+
+	mlxsw_sp_qdisc_leaf_unoffload(mlxsw_sp_port, mlxsw_sp_qdisc, p->qstats);
+}
+
 static int
 mlxsw_sp_qdisc_get_red_xstats(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
-- 
2.24.1

