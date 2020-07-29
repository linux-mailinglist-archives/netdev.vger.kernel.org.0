Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E52231C11
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgG2J11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:27:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55979 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726737AbgG2J10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:27:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5E18B5C00F1;
        Wed, 29 Jul 2020 05:27:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 29 Jul 2020 05:27:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=EqUWeHAUWB0jd/dZH20KUMPc4vzjNkPEYKOlYOZX2OU=; b=Jqy86kwt
        usj2YHQl3WfnBacZmfSt7FWfrC8uP+1wVqklfJ9oCycQMuGQIbSkqC2YIYOxHsyc
        Qr0hzTR2ESA+k/p2sUEFksrVOhUu9NqfURnlY+QqfBVixc3Lic36WtaolQfJ2FFd
        4KHn43/8FhN7ihLZpp5qxxkwj8sr6YiDV9FbGjWoU58OgUhquwRo+JX/SdoBwJBo
        iqK9ubHSuhxE/7xsunbE5HuJw4T56zPVn8wQNwGzRh/yDiC9xsWqbAvzsUpE+M8A
        wTuo7JS4arzdcvdbN7N2HlemA01t82HT0J/k43emQiy1LnNlu0jq16kl4/INctLX
        vKWeNZo/tX9fvg==
X-ME-Sender: <xms:_UAhX5PXI0GXhWYVTmD68CMPPgyK4sUpShTxnBjVN7ehhrfP8Hh59g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeggdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeejrddvhedt
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_UAhX7_3am2DWudKZtWo95TmiwSrkeWeSHT0j1Snsar85fEdCpK3MA>
    <xmx:_UAhX4Rula4uTIw7_lGiCxPHfEvc0UH8xxvP2qpnAhM93jcGL_3OgQ>
    <xmx:_UAhX1sSfjVu5wB1a0G9Sw9cdGIw7JrlInF-XPfMkjcNBkViDGR9Kg>
    <xmx:_UAhX14n8co2ljzMqGqneMZkVbbZCuk0dGPWUB8egSNTVMTlkVrXjA>
Received: from shredder.mtl.com (bzq-109-65-137-250.red.bezeqint.net [109.65.137.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7153B3280059;
        Wed, 29 Jul 2020 05:27:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        amitc@mellanox.com, alexve@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 3/6] mlxsw: core: Increase scope of RCU read-side critical section
Date:   Wed, 29 Jul 2020 12:26:45 +0300
Message-Id: <20200729092648.2055488-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729092648.2055488-1-idosch@idosch.org>
References: <20200729092648.2055488-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The lifetime of the Rx listener item ('rxl_item') is managed using RCU,
but is dereferenced outside of RCU read-side critical section, which can
lead to a use-after-free.

Fix this by increasing the scope of the RCU read-side critical section.

Fixes: 93c1edb27f9e ("mlxsw: Introduce Mellanox switch driver core")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index d6d6fe64887b..5e76a96a118e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2051,11 +2051,13 @@ void mlxsw_core_skb_receive(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
 			break;
 		}
 	}
-	rcu_read_unlock();
-	if (!found)
+	if (!found) {
+		rcu_read_unlock();
 		goto drop;
+	}
 
 	rxl->func(skb, local_port, rxl_item->priv);
+	rcu_read_unlock();
 	return;
 
 drop:
-- 
2.26.2

