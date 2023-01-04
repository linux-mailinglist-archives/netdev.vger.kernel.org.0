Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3230465DB8E
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbjADRwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbjADRwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:52:38 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D3933D51
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 09:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7mJmoztSto8v3dtrvgRUtp90HTxmf65Hn2Qbb/oe+zQ=; b=OMFXRunG+GwKm+8Hwc/vZi4NSc
        TabJny9ac9W2fYKWvD3DI/AVwWiIA9rWTz0PPgked58bQcHhfNbDJ6JtGKVmpFdC295MPXtd7LHeM
        CHmhqipWBfFfAwyxSjPQ6DtvRLGBc92mkURC/zPrrLPOYvgNw/8HYs0AcEZrN5VpaSgs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pD7wG-0019ci-OX; Wed, 04 Jan 2023 18:52:32 +0100
Date:   Wed, 4 Jan 2023 18:52:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harald Welte <laforge@osmocom.org>
Cc:     netdev@vger.kernel.org, khc@pm.waw.pl
Subject: Re: [PATCH] net: hdlc: Increase maximum HDLC MTU
Message-ID: <Y7W84D+J4iNx30zx@lunn.ch>
References: <20230104125724.3587015-1-laforge@osmocom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104125724.3587015-1-laforge@osmocom.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 01:57:24PM +0100, Harald Welte wrote:
> The FRF 1.2 specification clearly states:
> 
> > A maximum frame relay information field size of 1600 octets shall be
> > supported by the network and the user.
> 
> The linux kernel hdlc/fr code has so far had a maximum MTU of 1500
> octets.  This may have been sufficient to transport "regular" Ethernet
> frames of MTU 1500 via frame relay net-devices, but there are other
> use cases than Ethernet.
> 
> One such use case is the 3GPP Gb interface (TS 48.014, 48.016, 48.018)
> operated over Frame Relay.  There is open source software [2]
> implementing those interfaces by means of AF_PACKET sockets over
> Linux kernel hdlcX devices.
> 
> And before anyone asks: Even in 2023 there are real-world deployments of
> those interfaces over Frame Relay in production use.
> 
> This patch doesn't change the default hdlcX netdev MTU, but permits
> userspace to configure a higher MTU, in those cases needed.

I could be reading the code wrong, but:

https://elixir.bootlin.com/linux/latest/source/drivers/net/wan/hdlc.c#L231

static void hdlc_setup_dev(struct net_device *dev)
{
	/* Re-init all variables changed by HDLC protocol drivers,
	 * including ether_setup() called from hdlc_raw_eth.c.
	 */
	dev->flags		 = IFF_POINTOPOINT | IFF_NOARP;
	dev->priv_flags		 = IFF_WAN_HDLC;
	dev->mtu		 = HDLC_MAX_MTU;
	dev->min_mtu		 = 68;
	dev->max_mtu		 = HDLC_MAX_MTU;
	dev->type		 = ARPHRD_RAWHDLC;
	dev->hard_header_len	 = 0;
	dev->needed_headroom	 = 0;
	dev->addr_len		 = 0;
	dev->header_ops		 = &hdlc_null_ops;
}

This change does appear to change dev->mtu, not just dev->max_mtu?
So i'm not sure the commit message is correct?

   Andrew
