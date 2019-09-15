Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A832B2EBA
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 08:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfIOGsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 02:48:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52239 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbfIOGsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 02:48:30 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1CF5221B55;
        Sun, 15 Sep 2019 02:48:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 15 Sep 2019 02:48:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=sBrQ/Lm0gZpn1jIKigKCw4B18lRHEL1+/WH7k8TM7QU=; b=o/0Cmiqj
        XlWjbI87xh7/1VmMTwD4aWX3V4GbXWc8kJgHxsg74a1/R+fReoRtjko9xqIQBTmA
        wrR/XMwfHea9G5zY8kupC0JsMb4l3yvuwnjhl+U6ZgKvZzvtPO1i9ujT8IJyiNR9
        dTaBWhzOR9BHLUXo82cJ6McHNlPEDfv3nVUZwuLJS7at9tujy99NoT1yPS/6N9+g
        CrjDlZI6TvkAoQXC7hJujBjmxxjbl9cQDM+LXp1b14oRyHa8G4wVlBsRMHoiHqxX
        EJs68sfEavvCodwE6KEzPA8dl8c//SKeM/MTlyFqdVqmNihYtp9qGVpzFkmqlJCk
        Mh58GRvdHYjIpQ==
X-ME-Sender: <xms:vd59XQLYf0OtJR6jfSjuLuKR6eJo896MMxsaHvwZVG4-1863DV4qgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:vd59XYUXIUZ1Tx_MOnq9PRxdwRqXhAjxRKz8aCaAHYgxmCBsoygwyw>
    <xmx:vd59XYCTHZvgHemQ-XPRxsi6gKolpc5WTXTpcLcr5NdanhHeV6Ty4w>
    <xmx:vd59XbHzDegd-_cZ2PqX4Y_jupMiYsWTqXovVmRkh_xz57VFZ6d6vQ>
    <xmx:vt59XXyLyJyvDwROVOQylDSoJOPLExlzSC3qmhlILzHOwMk-fleZuw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF67A8006B;
        Sun, 15 Sep 2019 02:48:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, nhorman@tuxdriver.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] drop_monitor: Better sanitize notified packets
Date:   Sun, 15 Sep 2019 09:46:36 +0300
Message-Id: <20190915064636.6884-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190915064636.6884-1-idosch@idosch.org>
References: <20190915064636.6884-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When working in 'packet' mode, drop monitor generates a notification
with a potentially truncated payload of the dropped packet. The payload
is copied from the MAC header, but I forgot to check that the MAC header
was set, so do it now.

Fixes: ca30707dee2b ("drop_monitor: Add packet alert mode")
Fixes: 5e58109b1ea4 ("drop_monitor: Add support for packet alert mode for hardware drops")
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index cc60cc22e2db..536e032d95c8 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -487,6 +487,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	struct sk_buff *nskb;
 	unsigned long flags;
 
+	if (!skb_mac_header_was_set(skb))
+		return;
+
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb)
 		return;
@@ -900,6 +903,9 @@ net_dm_hw_packet_probe(struct sk_buff *skb,
 	struct sk_buff *nskb;
 	unsigned long flags;
 
+	if (!skb_mac_header_was_set(skb))
+		return;
+
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb)
 		return;
-- 
2.21.0

