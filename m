Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29AE21F3CB
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgGNOV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:21:58 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38065 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728456AbgGNOV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6861F5C016C;
        Tue, 14 Jul 2020 10:21:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=A7if9B5R1hpzRjWR1amqwErVDxum+zx8JarRCTsLXDA=; b=ffE1yGi4
        vXVF5m9bJDWzMxyKLwZhSRGsphOTqzsgadzdbFteY9P+dROHss64SI3RUQ1U1IWv
        zh2OypjTo4ydm+b8xQ/tKEYFafkP8wDwl+131JhL8yFKtT9nlOXTHJ9UTdkFAVws
        80hw4UlEwTy1WD4qhdx2vJcC+fiRpV/a+lSEIFQNsIi3LmlLpg7eB1uO1DvVJC0O
        WXHoy4yJU8pDHEs6k/qlccUZ+rZ2ezP+mPkvUWUuj/Ko4kwXvXjA1dXO9cRJLlar
        h9q67mNXN5B/6Q0TkT/vxXLxluNMcElIlEdaUUTXF2k8JxxQuuDH9/GUr2wDltaz
        dkekhiEfENvlQQ==
X-ME-Sender: <xms:g78NX8MoWR5rfB7A8WDdEpHKu2O2UcyWa9uhcLx9DaswCWDj-e7uuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:g78NXy-pT_yZje3W3XQnPUKbPeN-AnCEJeUkXblboNAmMRYAuymPUg>
    <xmx:g78NXzSbn7CVHbhZbQYOKBLPlLIr-fabLg-lLuuosvRFw275MbkgNA>
    <xmx:g78NX0s5OQrbTV-tIotqegakhRQ-W0TXAmXC45zy6HX5HBxtJOaz9g>
    <xmx:g78NX84dYkXEVhZ0V79FFtZE_iwyu3-OM-Q-tsYrtb2Db7QrX7yPXA>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5920430600B4;
        Tue, 14 Jul 2020 10:21:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/13] mlxsw: trap: Add trap identifiers for mirrored packets
Date:   Tue, 14 Jul 2020 17:21:03 +0300
Message-Id: <20200714142106.386354-11-idosch@idosch.org>
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

Packets that are mirrored to the CPU port are trapped with one of eight
trap identifiers. Add them.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/trap.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 8cbb9cf5b57b..33909887d0ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -107,6 +107,14 @@ enum {
 	MLXSW_TRAP_ID_ACL2 = 0x1C2,
 	MLXSW_TRAP_ID_DISCARD_INGRESS_ACL = 0x1C3,
 	MLXSW_TRAP_ID_DISCARD_EGRESS_ACL = 0x1C4,
+	MLXSW_TRAP_ID_MIRROR_SESSION0 = 0x220,
+	MLXSW_TRAP_ID_MIRROR_SESSION1 = 0x221,
+	MLXSW_TRAP_ID_MIRROR_SESSION2 = 0x222,
+	MLXSW_TRAP_ID_MIRROR_SESSION3 = 0x223,
+	MLXSW_TRAP_ID_MIRROR_SESSION4 = 0x224,
+	MLXSW_TRAP_ID_MIRROR_SESSION5 = 0x225,
+	MLXSW_TRAP_ID_MIRROR_SESSION6 = 0x226,
+	MLXSW_TRAP_ID_MIRROR_SESSION7 = 0x227,
 
 	MLXSW_TRAP_ID_MAX = 0x3FF,
 };
-- 
2.26.2

