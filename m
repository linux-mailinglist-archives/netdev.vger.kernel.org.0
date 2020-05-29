Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED42B1E86C7
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgE2Sh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:28 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52577 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727094AbgE2Sh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 96DE25C00B6;
        Fri, 29 May 2020 14:37:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=+yuskCbsuZU1LTxSasNpU5PXnz4twlBSaL7OSsRfthg=; b=bR6D1TBO
        f9Uxbnp+in9sUGEsS/diEe7hMGJNGM/slrWtHvdCSJIYqgLmXb7+ZGZ0o1Q2dlE/
        9QEC+vg5tQM0kV46tc4UDOwoJN8UkoOygkevyKqaVmcvTcHSpXX+Aih9N096zrux
        IALJ8tmdX88NlBLsysDXRVcxFTEvxBuyDoyFhUULP7EzhThm7MQgMMH6PPByjYyO
        6OfYL08ZTBEMcXVs3RCk1rNNHCdpq8IxbpQGkfQ0m0KHywnjaMAEfH7ffZv/r34t
        D1TdgJ0iatTn7BAeclMWbnu7Av93bS8HcjCia8+1GXY2ljrRMWhYjZpabB/O5OYi
        +fAIzS/CBFYohg==
X-ME-Sender: <xms:ZVbRXhYTf47AzmJu0uloLF_loaParGuoHLUzlb8Sdzpowjh_kY6WLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ZVbRXoYAf8tCZb6fQ75pwHs8hTGXUbQ6Oc7cEetsZl0Ie0QAXfKI4Q>
    <xmx:ZVbRXj_1c2Z-_21ebIs4yAITGr39gj1KeqoMgtGnmhJB07YfqVWoMg>
    <xmx:ZVbRXvpxrcqc_42oVLCMBbH0Gl3AlZK2VC2IU9yXL4r4w14QMARy1g>
    <xmx:ZVbRXpACn7R6upVrLUPBZfJGFZmnegrFIMbt478Srx5Fn8FbleQhZQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 593F730618C1;
        Fri, 29 May 2020 14:37:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/14] netdevsim: Move layer 3 exceptions to exceptions trap group
Date:   Fri, 29 May 2020 21:36:38 +0300
Message-Id: <20200529183649.1602091-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529183649.1602091-1-idosch@idosch.org>
References: <20200529183649.1602091-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The layer 3 exceptions are still subject to the same trap policer, so
nothing changes, but user space can choose to assign a different one.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index dc3ff0e20944..09d947eff980 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -458,6 +458,7 @@ static const struct devlink_trap_policer nsim_trap_policers_arr[] = {
 static const struct devlink_trap_group nsim_trap_groups_arr[] = {
 	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
 	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS, 1),
+	DEVLINK_TRAP_GROUP_GENERIC(L3_EXCEPTIONS, 1),
 	DEVLINK_TRAP_GROUP_GENERIC(BUFFER_DROPS, 2),
 	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS, 3),
 };
@@ -471,7 +472,7 @@ static const struct devlink_trap nsim_traps_arr[] = {
 	NSIM_TRAP_DROP(PORT_LOOPBACK_FILTER, L2_DROPS),
 	NSIM_TRAP_DRIVER_EXCEPTION(FID_MISS, L2_DROPS),
 	NSIM_TRAP_DROP(BLACKHOLE_ROUTE, L3_DROPS),
-	NSIM_TRAP_EXCEPTION(TTL_ERROR, L3_DROPS),
+	NSIM_TRAP_EXCEPTION(TTL_ERROR, L3_EXCEPTIONS),
 	NSIM_TRAP_DROP(TAIL_DROP, BUFFER_DROPS),
 	NSIM_TRAP_DROP_EXT(INGRESS_FLOW_ACTION_DROP, ACL_DROPS,
 			   DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
-- 
2.26.2

