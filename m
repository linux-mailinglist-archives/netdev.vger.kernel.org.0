Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421B621F3CE
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgGNOWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:22:04 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55435 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728478AbgGNOWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:22:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A48BE5C016C;
        Tue, 14 Jul 2020 10:22:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=fgXElEykIDWY+seXoquHxyMTbQX9DBvSDoThC1Gkk70=; b=gZU++pza
        9X2RaMIb2WtQdEolVg8je+SunRA8DOaXoSa8GWARp6c0WqMMKS0LAn0GAD3K3edw
        F+P1XQxZ1RKY/aAQXAcIB9SJ3Z25Qn0ZLiawYVJ3SqixG1Z5iIwj1zljs/kBqREq
        8ZmZ4BkTCmeqj+5GfLegCKCyDrx2eiUKINhAyPk2P/6b5aNxtEuAetDnD/zXnP8e
        sjSuIKdkbFQ3usE1sXrOd/EI2zJtw7uW7dk3O/SGp9mBG88SV8oJFZKJCwTLLeVj
        539A+U3AV3GRvyjSdNCOZw2YxE/zwEgSfGZ/8+j58uf6Ciohut7f0UwokHvEBqvC
        r9Q9SqYKgSjZ3g==
X-ME-Sender: <xms:ib8NX0kmUovSM2gk2wU5zysquK-k8EGqDaC5vQGOmgFam10VKo533w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeduvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ib8NXz3_oQF6iLlMvsj3LSCiPx3JSoSQIQsKcU3Ztk-LF6j8Pr5xzw>
    <xmx:ib8NXyrT5ma2vicaKGPexqXucbcbLkAVqnphnHNfpxXDF3I_8tbvzQ>
    <xmx:ib8NXwkRm42e9KxMXwsP1kreh7Q5cyNp_Iq03MCBJrp47pVy1rBKZw>
    <xmx:ib8NX3z2HxMpbrw7Vyg9RG2MLI4hiZ_pv1qkaIhOarhVeRoEkpnxtQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0F7F306005F;
        Tue, 14 Jul 2020 10:21:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 13/13] mlxsw: core: Use mirror reason during Rx listener lookup
Date:   Tue, 14 Jul 2020 17:21:06 +0300
Message-Id: <20200714142106.386354-14-idosch@idosch.org>
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

The Rx listener abstraction allows the switch driver (e.g.,
mlxsw_spectrum) to register a function that is called when a packet is
received (trapped) for a specific reason.

Up until now, the Rx listener lookup was solely based on the trap
identifier. However, when a packet is mirrored to the CPU the trap
identifier merely indicates that the packet was mirrored, but not why it
was mirrored. This makes it impossible for the switch driver to register
different Rx listeners for different mirror reasons.

Solve this by allowing the switch driver to register a Rx listener with
a mirror reason and by extending the Rx listener lookup to take the
mirror reason into account.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/core.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 8b3791d73c99..1363168b3c82 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1524,7 +1524,8 @@ static bool __is_rx_listener_equal(const struct mlxsw_rx_listener *rxl_a,
 {
 	return (rxl_a->func == rxl_b->func &&
 		rxl_a->local_port == rxl_b->local_port &&
-		rxl_a->trap_id == rxl_b->trap_id);
+		rxl_a->trap_id == rxl_b->trap_id &&
+		rxl_a->mirror_reason == rxl_b->mirror_reason);
 }
 
 static struct mlxsw_rx_listener_item *
@@ -2044,7 +2045,8 @@ void mlxsw_core_skb_receive(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
 		rxl = &rxl_item->rxl;
 		if ((rxl->local_port == MLXSW_PORT_DONT_CARE ||
 		     rxl->local_port == local_port) &&
-		    rxl->trap_id == rx_info->trap_id) {
+		    rxl->trap_id == rx_info->trap_id &&
+		    rxl->mirror_reason == rx_info->mirror_reason) {
 			if (rxl_item->enabled)
 				found = true;
 			break;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index c736b8673791..c1c1e039323a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -61,6 +61,7 @@ void mlxsw_core_ptp_transmitted(struct mlxsw_core *mlxsw_core,
 struct mlxsw_rx_listener {
 	void (*func)(struct sk_buff *skb, u8 local_port, void *priv);
 	u8 local_port;
+	u8 mirror_reason;
 	u16 trap_id;
 };
 
-- 
2.26.2

