Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72BDEDCA2A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405727AbfJRQBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:01:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52686 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfJRQBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 12:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SMevRHn5yAEfndygCJGs4e6HW+7R6WGQ8pVjp6LF3ck=; b=BEErwb0u6hMrDSuQYoY0HlkHWz
        0gIyUCWa/abTfBKoco0WYf/7oWnJTsQPdB5bRDVguZACXvtAPCqpBkBv5AM1Nt8GCXigGHD9QWJ8V
        mnp39WvOEaavIcJj5BbQEhNfzkU96y4Vr7cmmnKMZzaBeWy0EipOK5A00odRjeI9n6rA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLUgm-0001qG-Py; Fri, 18 Oct 2019 18:01:16 +0200
Date:   Fri, 18 Oct 2019 18:01:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII
 connections
Message-ID: <20191018160116.GD24810@lunn.ch>
References: <20191015224953.24199-3-f.fainelli@gmail.com>
 <4feb3979-1d59-4ad3-b2f1-90d82cfbdf54@gmail.com>
 <c4244c9a-28cb-7e37-684d-64e6cdc89b67@gmail.com>
 <CA+h21hrLHe2n0OxJyCKTU0r7mSB1zK9ggP1-1TCednFN_0rXfg@mail.gmail.com>
 <20191018130121.GK4780@lunn.ch>
 <CA+h21hoPrwcgz-q=UROAu0PC=6JbKtbdPhJtZg5ge32_2xJ3TQ@mail.gmail.com>
 <20191018132316.GI25745@shell.armlinux.org.uk>
 <CA+h21hqVZ=LF3bQGtqFh4uMu6AhNFcrwQuUcEH-Fc1VrWku-eg@mail.gmail.com>
 <20191018135411.GJ25745@shell.armlinux.org.uk>
 <CA+h21hrqRtxWp1c-8F-9qPPsYxA_w_B_131DRayLBd8xjpOzPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrqRtxWp1c-8F-9qPPsYxA_w_B_131DRayLBd8xjpOzPg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I don't think you are following the big picture of what I am saying. I
> was trying to follow Florian's intention (first make sure I understand
> it) and suggest that the FCS checking code in the patch he submitted
> is not doing what it was intended to. I am getting apparent FCS
> mismatches reported by the program, when I know full well that the MAC
> I am testing on would have dropped those frames were they really
> invalid.

I think this FCS check is not needed. If we feed the MAC random data,
something like 1 in 65535 will have a valid FCS and get passed up.
I've not seen this happen with Ethernet, but i have seen other network
technologies wrong decoding noise on the line and passing up frames
with around 1 in 65536 probability.

But then having the correct Ethertype is another 1 in 65536. So it
seem pretty improbably we do receiver a packet in this method which is
bad. So i would say, any packet received here is a good packet, and
indicate the RGMII mode works. If we don't receive a packet, the mode
is very probably bad.

	 Andrew
