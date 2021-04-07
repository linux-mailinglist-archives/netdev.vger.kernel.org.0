Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4E935694E
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 12:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350863AbhDGKUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 06:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbhDGKUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 06:20:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C7AC061756
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 03:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:To:From:Date:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0ubU+S206yyBNnPlxXi3JDbjQjgFzpSPDz3I7WoiVRk=; b=LzZhV0sdRz5ShPPG5v2ItJGI2
        0C/E30SWWUKn86IjubZQ6E/FysCLOwPxLBUn9UofIiesJLsMXGfEcOpRp+oQl2G5+3wULrCpH7DIF
        Tc57A5u38J59Z6o5jVzmEN/fDIdSwmmeavbXNeMSiwMsa1son7iUkZwk6s5UWt6q9TtbwMXve55U1
        CfM/ZvRwkoDZ8F57yGCLxaH3KWHGni/7dDbbV0RlTuXmgjyrB5o1MbY6fW9vXflM3ko1V4T/r4QDw
        3Bca0tWYWfjSSxrybjva0q5tlgtiGvpK0F2BXhjMrzNizvAJfbWNgFr6rnnSr2f7MF6HalWBeVveH
        T30dY9J7A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52180)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lU5Hq-00089q-NU
        for netdev@vger.kernel.org; Wed, 07 Apr 2021 11:19:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lU5Hq-0001uh-Fe
        for netdev@vger.kernel.org; Wed, 07 Apr 2021 11:19:50 +0100
Date:   Wed, 7 Apr 2021 11:19:50 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org
Subject: Re: Semantics of AF_PACKET sockets on bridge port interface - patch
Message-ID: <20210407101950.GG1477@shell.armlinux.org.uk>
References: <20210403095418.GC1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403095418.GC1463@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 10:54:18AM +0100, Russell King - ARM Linux admin wrote:
> Hi,
> 
> This question has probably come up several times before, but there
> doesn't seem to be a solution yet.
> 
> Scenario: a network interface, such as a wireless adapter or a
> network interface supporting PTP, is part of a bridge. Userspace
> wishes to capture packets sent using a specific Ethernet protocol
> to the ethernet address of that network interface, such as EAPOL
> frames or PTP frames.
> 
> Problem 1: __netif_receive_skb_core() scans the global ptype_all and
> skb->dev->ptype_all lists to deliver to any packet capture sockets,
> then checks skb->dev->rx_handler (which bridge sets), and from which
> it returns RX_HANDLER_CONSUMED from. This bypasses AF_PACKET listeners
> attached via the ->ptype_specific list, resulting in such a socket
> not receiving any packets.
> 
> Problem 2: detecting the port being a bridge port, and having the
> application also bind to the bridge interface is not a solution; the
> bridge can have a different MAC address to the bridge interface, so
> e.g. EAPOL frames sent to the WiFi MAC address will not be routed to
> the bridge interface. (hostapd does this but it's fragile for this
> reason, and it doesn't work for ptp nor does it work for Network
> Manager based bridged Wi-Fi which uses wpa_supplicant.)
> 
> So, this problem really does need solving, but it doesn't look to be
> trivial.  Moving the scanning of the device's ptype_specific list
> has implications for ingress and vlan handling.
> 
> I'm aware of a large patch set in 2019 that contained a single patch
> that claimed to fix it, but it looks like it was ignored, which is
> not surprising given the size and content of the series.
> https://lore.kernel.org/patchwork/patch/1066146/
> This patch no longer applies to current kernels since the bridge code
> has changed, and in any case, I suspect the fix is wrong.
> 
> Is there a solution for this, or are AF_PACKET ethernet-protocol
> specific sockets just not supportable on bridge ports?

The patch below is a hack I've tried to fix this problem, and with this
I can configure a Wi-Fi AP in Network Manager beneath a bridge, and
have it accept clients onto the network. Without this patch, they fail
while trying to complete the EAPOL authentication. This setup uses
wpa_supplicant attached to the Wi-Fi interface which has no knowledge
that the interface is attached to a bridge.

diff --git a/net/core/dev.c b/net/core/dev.c
index 449b45b843d4..41f9ce764654 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5208,6 +5208,10 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 			goto out;
 	}
 
+	type = skb->protocol;
+	deliver_ptype_list_skb(skb, &pt_prev, orig_dev, type,
+			       &orig_dev->ptype_specific);
+
 	rx_handler = rcu_dereference(skb->dev->rx_handler);
 	if (rx_handler) {
 		if (pt_prev) {
@@ -5276,9 +5280,6 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 						   PTYPE_HASH_MASK]);
 	}
 
-	deliver_ptype_list_skb(skb, &pt_prev, orig_dev, type,
-			       &orig_dev->ptype_specific);
-
 	if (unlikely(skb->dev != orig_dev)) {
 		deliver_ptype_list_skb(skb, &pt_prev, orig_dev, type,
 				       &skb->dev->ptype_specific);

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
