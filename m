Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A05C19E99E
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 08:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDEGu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 02:50:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48015 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgDEGu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 02:50:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AB17B5C018E;
        Sun,  5 Apr 2020 02:50:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 05 Apr 2020 02:50:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=3RxEj2Lv1A7TjjUjOh+/y4F/Vhw2l0yzg8UakgCoVd4=; b=ZtsgXF9m
        euoXofDG25IGjAlNqiWlP/gECphlDQrzUf5COefcItO+SywM579iQEWJhUmwq2c4
        Xl/+SEQ1gEKSDkVK+6cxX/4xSmjZF5neGV1wRdNjwx+n7vP85pQOgt2v4QBV7J2R
        s8Ij74iRrVL0Nm7jDkHAJ7M+39tHso4WYcvGaK/FI/a/fob7yZkO4HFcNpln3bfu
        bFmx4e7ac7VChZiKBfyJ5CwlP6dYr7tCY/F52+vBFMnlEn71jqMR1f4nWpDOiLvM
        w33OmD61hiqW6gKDPVT4IreiuJyM8j/WkNRTzc5Et8fsoIQSfrwviFKs6l7kFJzo
        iEFtL/HtpRoXHA==
X-ME-Sender: <xms:z3-JXhsO_MKSJ_hVHysXtUjdsSXSREFsZYNMCq3TwV_2LJlZ1gxI9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:z3-JXsWbpg8_gNuciMzkuskorbRLA0Mr2jXIIO98ZuldP6pgowXyoA>
    <xmx:z3-JXp6C3bpSWfS8Dw594SR2MukICFkH621pRpbX5uEwbiuw6LYOTA>
    <xmx:z3-JXob6I0sKj6UjIITxwWf48HNvPlwwrnooSJgnr7m243u7XZy88Q>
    <xmx:z3-JXpdJzMKr78z-Z2rcr_U6ih0uLegEdBrsAv_N3pBVESEk4tXJIg>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3E7F0306D1F4;
        Sun,  5 Apr 2020 02:50:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net v2 2/2] mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE
Date:   Sun,  5 Apr 2020 09:50:22 +0300
Message-Id: <20200405065022.2578662-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200405065022.2578662-1-idosch@idosch.org>
References: <20200405065022.2578662-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The handler for FLOW_ACTION_VLAN_MANGLE ends by returning whatever the
lower-level function that it calls returns. If there are more actions lined
up after this action, those are never offloaded. Fix by only bailing out
when the called function returns an error.

Fixes: a150201a70da ("mlxsw: spectrum: Add support for vlan modify TC action")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 69f77615c816..51117a5a6bbf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -150,9 +150,12 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			u8 prio = act->vlan.prio;
 			u16 vid = act->vlan.vid;
 
-			return mlxsw_sp_acl_rulei_act_vlan(mlxsw_sp, rulei,
-							   act->id, vid,
-							   proto, prio, extack);
+			err = mlxsw_sp_acl_rulei_act_vlan(mlxsw_sp, rulei,
+							  act->id, vid,
+							  proto, prio, extack);
+			if (err)
+				return err;
+			break;
 			}
 		case FLOW_ACTION_PRIORITY:
 			err = mlxsw_sp_acl_rulei_act_priority(mlxsw_sp, rulei,
-- 
2.24.1

