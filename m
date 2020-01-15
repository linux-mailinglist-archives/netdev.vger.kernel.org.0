Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE37713BEE9
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 12:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgAOLyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 06:54:17 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44783 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730166AbgAOLyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 06:54:16 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0B2622202A;
        Wed, 15 Jan 2020 06:54:15 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Jan 2020 06:54:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Eh8hLHyR8dynOI3n1O6c+pJAv+GKaFko3CsYR6FEKg8=; b=glM4SQEn
        Y+iQrXplvQxOR4G5+G/6o0U88eQuRSULRJQootwFujztQjI8RRUHqLgc1R5Ze4qm
        6Gf2DbzurF70r57TYppGv3jCE6Q3TlsTjHqokGZVImdDPYYJhectXb5C1G3eR685
        oMzDvmrccAU2qpRBkLlagIsmk3IUfQJ7zKos5tnK/iAO1R0zoHDZtL2D2puNOCOq
        ZtHDKtqU28goG0H0L+lig1lhjclXy75t2ewkgB4fUxeBcHNtfo/9OcWAR3/ndTgh
        a/t54XCub7kYL52MI3NT2dBcrOgyf+uv93jtt+UuNIyPab1gQQxO0HNxzgChVjcs
        XViK1HeLP36ttg==
X-ME-Sender: <xms:Zv0eXtFULmqayexFpNeX0q4OfTWOUvIsvdRztC2o4Vq8hteezs_lDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:Zv0eXuFMHF8QN_wHTppKL4pDvaPXXxxmBBwvAUNR5E4ud8hUvVkjzQ>
    <xmx:Zv0eXnthuek7XzEnnXLrQV3kqP3pu7ntBrhPMYXcL_3dz5XROv2T0Q>
    <xmx:Zv0eXkM5dZVOY4U3P64EMEbxl6GFzeA8phmor2czTYNhggE57vUDOg>
    <xmx:Z_0eXucYOG-REetVhoc8MqkL3tZJzI1m4sCCl87VjTIVHFNeZ93ccg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id AE29A8006A;
        Wed, 15 Jan 2020 06:54:13 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net v2 2/6] mlxsw: spectrum: Do not modify cloned SKBs during xmit
Date:   Wed, 15 Jan 2020 13:53:45 +0200
Message-Id: <20200115115349.1273610-3-idosch@idosch.org>
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

Fixes: 56ade8fe3fe1 ("mlxsw: spectrum: Add initial support for Spectrum ASIC")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5408a964bd10..2394c425b47d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -860,23 +860,17 @@ static netdev_tx_t mlxsw_sp_port_xmit(struct sk_buff *skb,
 	u64 len;
 	int err;
 
+	if (skb_cow_head(skb, MLXSW_TXHDR_LEN)) {
+		this_cpu_inc(mlxsw_sp_port->pcpu_stats->tx_dropped);
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
 	memset(skb->cb, 0, sizeof(struct mlxsw_skb_cb));
 
 	if (mlxsw_core_skb_transmit_busy(mlxsw_sp->core, &tx_info))
 		return NETDEV_TX_BUSY;
 
-	if (unlikely(skb_headroom(skb) < MLXSW_TXHDR_LEN)) {
-		struct sk_buff *skb_orig = skb;
-
-		skb = skb_realloc_headroom(skb, MLXSW_TXHDR_LEN);
-		if (!skb) {
-			this_cpu_inc(mlxsw_sp_port->pcpu_stats->tx_dropped);
-			dev_kfree_skb_any(skb_orig);
-			return NETDEV_TX_OK;
-		}
-		dev_consume_skb_any(skb_orig);
-	}
-
 	if (eth_skb_pad(skb)) {
 		this_cpu_inc(mlxsw_sp_port->pcpu_stats->tx_dropped);
 		return NETDEV_TX_OK;
-- 
2.24.1

