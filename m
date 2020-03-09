Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D1517E748
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgCISfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:35:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39469 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727323AbgCISfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:35:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 96A1822011;
        Mon,  9 Mar 2020 14:35:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 Mar 2020 14:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=URgnwmuMRPsfU7Kq9uUx/F+R/7my9XiqvMRqUKB2v7Q=; b=nReVBA9t
        PeZFpDsdRucNcUsCA8VdwW6IzdWqVoNu4aaIBgPhmIf8xmRWloWY3+LH/IiKiwxS
        cIKq5ecRT7JqhWG1CNtQ2YQ8eJmD7LSTzoAfpl9tqh/ETgyrBwLieOlIRCgxf+FB
        JNJ677H3Gt5S8NOcdUvUrI9TZOgSKL3MgA7SFiyU1q+zloza8UeQ3iHvwrLJ5EG0
        V3nbeXYaIC18wkeRXmpgKYr7kOOdKxY+stFnBlFdy/xY3cQzKoEvqf7chUUtfFNP
        CJZ8+XVHhxOkRry0RIgmmWe7TwBczt3e0WtxF7MpPTY0sttygDNslU5uIqI+3oHX
        CPihAsyRV8RU2g==
X-ME-Sender: <xms:iYxmXrOKY6mOs7-7H0TAVVc9fizLZ0UP8B0M31hW_9D46nhHFC87UA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeejrddufeekrddvgeelrddvtdelnecuvehluhhsth
    gvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:iYxmXh0vBoHdMHsa4LrHZCphxQM2BzFnXIbdfoqTOQN4UTwnyxevXw>
    <xmx:iYxmXlwExhtJ6lMAHlE_fDgJi1b6y8dfIBv0PpQAu9GZNiHFeq9PzQ>
    <xmx:iYxmXjptfdvHGczstV6csjPkZ8EDy0WWKRkC8DuKwiZV95XiKEJxmw>
    <xmx:iYxmXo-kIiV_RnmKIFTxO-u96cpkxm7IkRyarspa_f9ZTiWUdxr89A>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67D593060F09;
        Mon,  9 Mar 2020 14:35:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/6] mlxsw: spectrum_qdisc: Offload RED ECN tail-dropping mode
Date:   Mon,  9 Mar 2020 20:35:01 +0200
Message-Id: <20200309183503.173802-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309183503.173802-1-idosch@idosch.org>
References: <20200309183503.173802-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

RED ECN tail-dropping mode means that non-ECT traffic should not be
early-dropped, but enqueued normally instead. In Spectrum systems, this is
achieved by disabling CWTPM.ew (enable WRED) for a given traffic class.

So far CWTPM.ew was unconditionally enabled. Instead disable it when the
RED qdisc is in taildrop mode.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index b9f429ec0db4..dee89298122c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -323,7 +323,7 @@ mlxsw_sp_qdisc_get_tc_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 static int
 mlxsw_sp_tclass_congestion_enable(struct mlxsw_sp_port *mlxsw_sp_port,
 				  int tclass_num, u32 min, u32 max,
-				  u32 probability, bool is_ecn)
+				  u32 probability, bool is_wred, bool is_ecn)
 {
 	char cwtpm_cmd[MLXSW_REG_CWTPM_LEN];
 	char cwtp_cmd[MLXSW_REG_CWTP_LEN];
@@ -341,7 +341,7 @@ mlxsw_sp_tclass_congestion_enable(struct mlxsw_sp_port *mlxsw_sp_port,
 		return err;
 
 	mlxsw_reg_cwtpm_pack(cwtpm_cmd, mlxsw_sp_port->local_port, tclass_num,
-			     MLXSW_REG_CWTP_DEFAULT_PROFILE, true, is_ecn);
+			     MLXSW_REG_CWTP_DEFAULT_PROFILE, is_wred, is_ecn);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(cwtpm), cwtpm_cmd);
 }
@@ -445,8 +445,9 @@ mlxsw_sp_qdisc_red_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 	prob = DIV_ROUND_UP(prob, 1 << 16);
 	min = mlxsw_sp_bytes_cells(mlxsw_sp, p->min);
 	max = mlxsw_sp_bytes_cells(mlxsw_sp, p->max);
-	return mlxsw_sp_tclass_congestion_enable(mlxsw_sp_port, tclass_num, min,
-						 max, prob, p->is_ecn);
+	return mlxsw_sp_tclass_congestion_enable(mlxsw_sp_port, tclass_num,
+						 min, max, prob,
+						 !p->is_taildrop, p->is_ecn);
 }
 
 static void
-- 
2.24.1

