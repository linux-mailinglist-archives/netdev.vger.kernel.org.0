Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347031386FC
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 17:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733108AbgALQHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 11:07:10 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48699 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733064AbgALQHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 11:07:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B80822063;
        Sun, 12 Jan 2020 11:07:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 12 Jan 2020 11:07:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zE9rI+tHnq7/fPAXaCF4dpCVO9XNiu1vfFM0DPAIkSw=; b=Zt/xKbUM
        LxXI68yQModRRguLAyjjADHPeMVrzwxhOD5L5nP83dCuXWTCgO6m8VfZ/UHiKk4T
        EINgeatlzAIv1SqVP85IxUPt2iD3sIsZn8x4gMk57CrN/+LSqIYvackd2fGlDFlQ
        JG4OTw2O3Zmw2eLfY6tpCo+OyL3lGVYBW63rO3SZ0hsJ+Bq1ewdANkOCuemaRLaI
        jd2iYzigeCjNX7Y8aETqQzDQZFeS9/yuxgraxcpB/VtQLS6uffPdWoG1c4z9vW5V
        f1TCCq0i0EowL4ZiKfdB2/xOaLH4bpFL3wxoMFtjXdrZYjJjhWz2+54y0vqVRc7E
        IJY/ngaLRxQd7A==
X-ME-Sender: <xms:LEQbXjv2y1iZSehr3eBDIKP2HvWUrDwo8Cpq6Gz1OrtV79_fm6K9kA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeikedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:LEQbXtquMWj5eSHxWijElzhpjpBKYWNpItV42J4p_9MpGM9Wr0EkCg>
    <xmx:LEQbXrCBJNoyNmeqgYFnKS9iCtIbWcb5QPV-QdvhH0zWNiAc74jy_A>
    <xmx:LEQbXn9at-vRV-hkac8g62PlpFxxnXDZLOIAeBvbHXk220pYyvpfUw>
    <xmx:LEQbXtOd_OMjGknMhE7ruBuPqFzCA27vsewdooIjp3f-WeQjRXVxQg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5EAA580059;
        Sun, 12 Jan 2020 11:07:06 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Shalom Toledo <shalomt@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/4] mlxsw: switchx2: Do not modify cloned SKBs during xmit
Date:   Sun, 12 Jan 2020 18:06:39 +0200
Message-Id: <20200112160641.282108-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200112160641.282108-1-idosch@idosch.org>
References: <20200112160641.282108-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

The driver needs to prepend a Tx header to each packet it is transmitting.
The header includes information such as the egress port and traffic class.

The addition of the header requires the driver to modify the SKB's data
buffer and therefore the SKB must be unshared first. Otherwise, we risk
hitting various race conditions with cloned SKBs.

For example, when a packet is flooded (cloned) by the bridge driver to two
switch ports swp1 and swp2:

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

Fix this by unsharing the SKB.

Fixes: 31557f0f9755 ("mlxsw: Introduce Mellanox SwitchX-2 ASIC support")
Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index de6cb22f68b1..47826e905e5c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -299,6 +299,10 @@ static netdev_tx_t mlxsw_sx_port_xmit(struct sk_buff *skb,
 	u64 len;
 	int err;
 
+	skb = skb_unshare(skb, GFP_ATOMIC);
+	if (unlikely(!skb))
+		return NETDEV_TX_BUSY;
+
 	memset(skb->cb, 0, sizeof(struct mlxsw_skb_cb));
 
 	if (mlxsw_core_skb_transmit_busy(mlxsw_sx->core, &tx_info))
-- 
2.24.1

