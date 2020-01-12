Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79151386FD
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 17:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733113AbgALQHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 11:07:11 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57887 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733064AbgALQHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 11:07:10 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2449E22076;
        Sun, 12 Jan 2020 11:07:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 12 Jan 2020 11:07:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=fbX9g5Z9mHki9I17GjdDTjOrweQRLr7zREd+KBWp/DU=; b=kAh9l62O
        PdyOZtXZKRpRxgPDdagRtTD2wAoOBbeXxXpIHa8VLDUS796/2LMuy9UmNw0M2sau
        hlCGOnAdhD2CBv2gIOZMVOUTnTs2bnpYK9pP1ULwP2tM7ev9+TTEIxxunB8OFV4j
        LIpxeMbJVyotbjK/rcboFuGfcvDl6SoJ11zKrr0akJa4/GSzK08q03h1Vpmdhe3w
        8V/hESyoWN+JdJ29iSyl0Mr+li40LOdkz3NRIV5GPBohjkqLRw6Aymkoj3Y0eXIz
        OVuC3ApgZkTLxZ1ODq7qNJVbEEl0NNsWxbJFa++N+y/lW00hKY5oOh7/4dz08Y3g
        6EYoNLlplX0w/g==
X-ME-Sender: <xms:LkQbXjg6vM0Mu2shCyljcIdaJ7T2NJpcUwsJjrTMoun6z7UJ29yNqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeikedgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:LkQbXqsO9cU5dfujlEXyrqChn04qhIPRmd57M0__EUO5OnYAiJC5jg>
    <xmx:LkQbXnFj8-UjplnIo2cx_yGnoKh1-uOx66K1yjNMyowyJikfM8kvrw>
    <xmx:LkQbXg8pwXpKkGwizssm-Mre3c5p0PqxPiuljB_01BndzjydOPkSzQ>
    <xmx:LkQbXlvdY0YZan1W7DiHWx2oGigede6hjYe3PBfgNHtOK-kTfy9GKw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8DB1C80059;
        Sun, 12 Jan 2020 11:07:08 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Shalom Toledo <shalomt@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 3/4] mlxsw: spectrum: Do not modify cloned SKBs during xmit
Date:   Sun, 12 Jan 2020 18:06:40 +0200
Message-Id: <20200112160641.282108-4-idosch@idosch.org>
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

Fixes: 56ade8fe3fe1 ("mlxsw: spectrum: Add initial support for Spectrum ASIC")
Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5408a964bd10..6c7bf93dd804 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -860,6 +860,10 @@ static netdev_tx_t mlxsw_sp_port_xmit(struct sk_buff *skb,
 	u64 len;
 	int err;
 
+	skb = skb_unshare(skb, GFP_ATOMIC);
+	if (unlikely(!skb))
+		return NETDEV_TX_BUSY;
+
 	memset(skb->cb, 0, sizeof(struct mlxsw_skb_cb));
 
 	if (mlxsw_core_skb_transmit_busy(mlxsw_sp->core, &tx_info))
-- 
2.24.1

