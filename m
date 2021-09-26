Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D95D418934
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 15:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhIZOAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 10:00:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60840 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231777AbhIZOAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 10:00:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HjivBkUchm6JkPW5fbVo3EwXigbe6lkdP6wwmdWVHlI=; b=RwGCs+IqoHQ39s/L8ivaNLfIMT
        szIKmvdRaeuZmcGYEVS/T7r3RAVDntYMkasIMgVELoebCQc01I7zlSvI7e+6JGibBAevDlt1h6lw8
        vCS3GkxRFw04ADKyfK0xGeJ6xtZ/Yra4aG/GusMl7QEXan93UFq0qWmcricQr0NDH5oA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUUfZ-008Jwy-P3; Sun, 26 Sep 2021 15:58:17 +0200
Date:   Sun, 26 Sep 2021 15:58:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Justin Chen <justinpopo6@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>
Subject: Re: [PATCH net-next 3/5] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <YVB8ef3aMpJTEvgF@lunn.ch>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
 <1632519891-26510-4-git-send-email-justinpopo6@gmail.com>
 <YU9SHpn4ZJrjqNuF@lunn.ch>
 <c66c8bd1-940a-bf9d-ce33-5a39635e9f5b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c66c8bd1-940a-bf9d-ce33-5a39635e9f5b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static int bcmasp_set_priv_flags(struct net_device *dev, u32 flags)
> > > +{
> > > +	struct bcmasp_intf *intf = netdev_priv(dev);
> > > +
> > > +	intf->wol_keep_rx_en = flags & BCMASP_WOL_KEEP_RX_EN ? 1 : 0;
> > > +
> > > +	return 0;
> > 
> > Please could you explain this some more. How can you disable RX and
> > still have WoL working?
> 
> Wake-on-LAN using Magic Packets and network filters requires keeping the
> UniMAC's receiver turned on, and then the packets feed into the Magic Packet
> Detector (MPD) block or the network filter block. In that mode DRAM is in
> self refresh and there is local matching of frames into a tiny FIFO however
> in the case of magic packets the packets leading to a wake-up are dropped as
> there is nowhere to store them. In the case of a network filter match (e.g.:
> matching a multicast IP address plus protocol, plus source/destination
> ports) the packets are also discarded because the receive DMA was shut down.
> 
> When the wol_keep_rx_en flag is set, the above happens but we also allow the
> packets that did match a network filter to reach the small FIFO (Justin
> would know how many entries are there) that is used to push the packets to
> DRAM. The packet contents are held in there until the system wakes up which
> is usually just a few hundreds of micro seconds after we received a packet
> that triggered a wake-up. Once we overflow the receive DMA FIFO capacity
> subsequent packets get dropped which is fine since we are usually talking
> about very low bit rates, and we only try to push to DRAM the packets of
> interest, that is those for which we have a network filter.
> 
> This is convenient in scenarios where you want to wake-up from multicast DNS
> (e.g.: wake on Googlecast, Bonjour etc.) because then the packet that
> resulted in the system wake-up is not discarded but is then delivered to the
> network stack.

Thanks for the explanation. It would be easier for the user if you
automate this. Enable is by default for WoL types which have user
content?

> > > +	/* Per ch */
> > > +	intf->tx_spb_dma = priv->base + TX_SPB_DMA_OFFSET(intf);
> > > +	intf->res.tx_spb_ctrl = priv->base + TX_SPB_CTRL_OFFSET(intf);
> > > +	/*
> > > +	 * Stop gap solution. This should be removed when 72165a0 is
> > > +	 * deprecated
> > > +	 */
> > 
> > Is that an internal commit?
> 
> Yes this is a revision of the silicon that is not meant to see the light of
> day.

So this can all be removed?

   Andrew
