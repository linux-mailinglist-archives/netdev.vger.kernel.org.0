Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D659B353353
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 11:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbhDCJzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 05:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbhDCJyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 05:54:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8F7C0613E6
        for <netdev@vger.kernel.org>; Sat,  3 Apr 2021 02:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:To:From:Date:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZGNMe9gmS6C0mFAwEVbRRqOUj4wUnDqpk12OFOXOwKY=; b=bahgaXctQFWJcjOYL2oVG5rOo
        VuRBdBiUFHVdNaJJPAJ57gnPweotopg2X4fpkUvjjdsv1NNuP0eYDZdZxJwut8VjAmDRrCcgkXma9
        tv56qPt6dlGbeP8uD6ub1Yj9IJFRnCMQFLUdIZgn6mhe3f2bpxw0pPyUeHu6kbnoD4HN7LoCNZQ2n
        8wB3nBEGRTjfeaO/aFUcAyNGt8ZKe7Mg67/C8B3j+JqdkokVoy5resEvVnlcCLqFc0ag/fISGKIGt
        oScB0alhEbjg9iKSfCbvNsJTardK0/OJVVJajMkR4lsKXGxwNbWqSxdyLjDLxvYllQsleqWaW9tpL
        z0ieUiHPw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52066)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lScyx-0005Iy-72
        for netdev@vger.kernel.org; Sat, 03 Apr 2021 10:54:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lScyw-0006fB-SB
        for netdev@vger.kernel.org; Sat, 03 Apr 2021 10:54:18 +0100
Date:   Sat, 3 Apr 2021 10:54:18 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org
Subject: Semantics of AF_PACKET sockets on bridge port interface
Message-ID: <20210403095418.GC1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This question has probably come up several times before, but there
doesn't seem to be a solution yet.

Scenario: a network interface, such as a wireless adapter or a
network interface supporting PTP, is part of a bridge. Userspace
wishes to capture packets sent using a specific Ethernet protocol
to the ethernet address of that network interface, such as EAPOL
frames or PTP frames.

Problem 1: __netif_receive_skb_core() scans the global ptype_all and
skb->dev->ptype_all lists to deliver to any packet capture sockets,
then checks skb->dev->rx_handler (which bridge sets), and from which
it returns RX_HANDLER_CONSUMED from. This bypasses AF_PACKET listeners
attached via the ->ptype_specific list, resulting in such a socket
not receiving any packets.

Problem 2: detecting the port being a bridge port, and having the
application also bind to the bridge interface is not a solution; the
bridge can have a different MAC address to the bridge interface, so
e.g. EAPOL frames sent to the WiFi MAC address will not be routed to
the bridge interface. (hostapd does this but it's fragile for this
reason, and it doesn't work for ptp nor does it work for Network
Manager based bridged Wi-Fi which uses wpa_supplicant.)

So, this problem really does need solving, but it doesn't look to be
trivial.  Moving the scanning of the device's ptype_specific list
has implications for ingress and vlan handling.

I'm aware of a large patch set in 2019 that contained a single patch
that claimed to fix it, but it looks like it was ignored, which is
not surprising given the size and content of the series.
https://lore.kernel.org/patchwork/patch/1066146/
This patch no longer applies to current kernels since the bridge code
has changed, and in any case, I suspect the fix is wrong.

Is there a solution for this, or are AF_PACKET ethernet-protocol
specific sockets just not supportable on bridge ports?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
