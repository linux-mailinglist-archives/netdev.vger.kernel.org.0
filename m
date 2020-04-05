Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8081219E99D
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 08:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgDEGuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 02:50:55 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38371 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgDEGuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 02:50:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 260965C0181;
        Sun,  5 Apr 2020 02:50:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 05 Apr 2020 02:50:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=UOQtmmVfAZFxzRMUAhjeB6LUnm/aae6mEIGxqH7nViA=; b=FlSlStUO
        HtGDVAdWs8T/oVKXyME4oyz3gbpOZYGxJ/xVuN4UPeAXPuTCX19TdZ0e0vieY/4w
        ptvxy9PrNhye9W5VFOIy5ygdeBDVEuPsgW8h7PKtAUcF3rtzZ8T7C2LNChX0epfz
        eSATYERwFsYjgGFAvjF0dz/KEBea7E8b31s/bDcgGCX5gwPMo+ldniM7+xSG7K08
        f+0bt9EtFGF2xjhOXImn/X60TdG0fwKh/M9NmBEjIUXSWaTkW2N9z19e+NAf63S4
        miWnVultBcrPBfsTH7ZwlfxEapmtsFjTyvOmCVydvfpQFUS/TTD0tOa8cOX635dJ
        HQ9g8TKYYF3pFw==
X-ME-Sender: <xms:zn-JXiXCzqDDjsLAXhgqmMGB4yfd3Jqxk8-ba1tUEJoM7skAa-15kA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:zn-JXqo8QCwLSbhhmEg8f_VD6moI0Ekzt5zfe6JXSPkwRZZet2ZQAA>
    <xmx:zn-JXjHf0hnB84_X5DllPLQ5ZsanmWOdYsR7j1v9MX1B0_oNjFfNxQ>
    <xmx:zn-JXvo7pNOi5FMc90Dn5kqMT6fsg2oSJMsO5KvjctXhme0ZMRu--g>
    <xmx:zn-JXmu1LOdoydAUsKtSREVu73Qyk5s1Lnuv843Eu79gZbdNxULC0A>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2FC9306D1F4;
        Sun,  5 Apr 2020 02:50:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net v2 1/2] mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_PRIORITY
Date:   Sun,  5 Apr 2020 09:50:21 +0300
Message-Id: <20200405065022.2578662-2-idosch@idosch.org>
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

The handler for FLOW_ACTION_PRIORITY ends by returning whatever the
lower-level function that it calls returns. If there are more actions lined
up after this action, those are never offloaded. Fix by only bailing out
when the called function returns an error.

Fixes: 463957e3fbab ("mlxsw: spectrum_flower: Offload FLOW_ACTION_PRIORITY")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 2f76908cae73..69f77615c816 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -155,9 +155,12 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 							   proto, prio, extack);
 			}
 		case FLOW_ACTION_PRIORITY:
-			return mlxsw_sp_acl_rulei_act_priority(mlxsw_sp, rulei,
-							       act->priority,
-							       extack);
+			err = mlxsw_sp_acl_rulei_act_priority(mlxsw_sp, rulei,
+							      act->priority,
+							      extack);
+			if (err)
+				return err;
+			break;
 		case FLOW_ACTION_MANGLE: {
 			enum flow_action_mangle_base htype = act->mangle.htype;
 			__be32 be_mask = (__force __be32) act->mangle.mask;
-- 
2.24.1

