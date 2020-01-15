Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB1F13BEEB
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 12:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbgAOLyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 06:54:20 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36715 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730177AbgAOLyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 06:54:17 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4612222050;
        Wed, 15 Jan 2020 06:54:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Jan 2020 06:54:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/LLpFx4UaJYnxCe0NRsJzZoJbPqK0vx4Kcyl1BV3SEU=; b=Ks4IrCc9
        wu4FgyjGMkTB0yrzm1gF4vCH+utp4LjwYulPzufGHhRzGtcZAtlGfw5kjdcB/G6G
        7eUB2Cr8TCac89LyqxSWnjg9BipE4YXhkB0t+/83AXfONBhqwcVeVvEdCaGiB7bG
        hBdtzPh9GK/IpCHvz67uw9irswv3ioXJ6UmjKv7ffL1cjyxE4nkwXW2KbzIR0+0G
        UD9MQYYOJvt6yKe7QVRhr1+KmYiFq9nmgooCwyX/602DxommrmLFXylB/5vV5G2b
        vfESBvnosKZVZhdmRNdyC/F6FSrbQrAtnyKY7vB+PQoTkMlFN0516wS28ihLG+bG
        rBNsqm1h6xA4VQ==
X-ME-Sender: <xms:aP0eXkknDHSwW1QUCbgr2TLkKnTH27BHEQEB17S2dE4T9B-i6FSSZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:aP0eXlHVZI-5Lj9UIeGNwMHCeMCKSJ73RiMynWbOHBPmby64kBzYTQ>
    <xmx:aP0eXkY-CzHf1uL6R_07ftW0un8bBQno1xQmAOF_UjNWLWFke_Fg8Q>
    <xmx:aP0eXqDAwWgB3MsJNlC3X9gsMXsSRU74m5Kar2X7xqeO8S0DxUx9ag>
    <xmx:aP0eXtdQIlgNlYaYTYXQLo4pP9mKc3vTD165t01RISgneKJ-JHxt_w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0BBEF80065;
        Wed, 15 Jan 2020 06:54:14 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net v2 3/6] mlxsw: switchx2: Do not modify cloned SKBs during xmit
Date:   Wed, 15 Jan 2020 13:53:46 +0200
Message-Id: <20200115115349.1273610-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115115349.1273610-1-idosch@idosch.org>
References: <20200115115349.1273610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The driver needs to prepend a Tx header to each packet it is
transmitting. The header includes information such as the egress port
and traffic class.

The addition of the header requires the driver to modify the SKB's
header and therefore it must not be shared. Otherwise, we risk hitting
various race conditions.

For example, when a packet is flooded (cloned) by the bridge driver to
two switch ports swp1 and swp2:

t0 - mlxsw_sp_port_xmit() is called for swp1. Tx header is prepended with
     swp1's port number
t1 - mlxsw_sp_port_xmit() is called for swp2. Tx header is prepended with
     swp2's port number, overwriting swp1's port number
t2 - The device processes data buffer from t0. Packet is transmitted via
     swp2
t3 - The device processes data buffer from t1. Packet is transmitted via
     swp2

Usually, the device is fast enough and transmits the packet before its
Tx header is overwritten, but this is not the case in emulated
environments.

Fix this by making sure the SKB's header is writable by calling
skb_cow_head(). Since the function ensures we have headroom to push the
Tx header, the check further in the function can be removed.

v2:
* Use skb_cow_head() instead of skb_unshare() as suggested by Jakub
* Remove unnecessary check regarding headroom

Fixes: 31557f0f9755 ("mlxsw: Introduce Mellanox SwitchX-2 ASIC support")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index de6cb22f68b1..f0e98ec8f1ee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -299,22 +299,17 @@ static netdev_tx_t mlxsw_sx_port_xmit(struct sk_buff *skb,
 	u64 len;
 	int err;
 
+	if (skb_cow_head(skb, MLXSW_TXHDR_LEN)) {
+		this_cpu_inc(mlxsw_sx_port->pcpu_stats->tx_dropped);
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
 	memset(skb->cb, 0, sizeof(struct mlxsw_skb_cb));
 
 	if (mlxsw_core_skb_transmit_busy(mlxsw_sx->core, &tx_info))
 		return NETDEV_TX_BUSY;
 
-	if (unlikely(skb_headroom(skb) < MLXSW_TXHDR_LEN)) {
-		struct sk_buff *skb_orig = skb;
-
-		skb = skb_realloc_headroom(skb, MLXSW_TXHDR_LEN);
-		if (!skb) {
-			this_cpu_inc(mlxsw_sx_port->pcpu_stats->tx_dropped);
-			dev_kfree_skb_any(skb_orig);
-			return NETDEV_TX_OK;
-		}
-		dev_consume_skb_any(skb_orig);
-	}
 	mlxsw_sx_txhdr_construct(skb, &tx_info);
 	/* TX header is consumed by HW on the way so we shouldn't count its
 	 * bytes as being sent.
-- 
2.24.1

