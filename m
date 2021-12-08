Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AE646C9D1
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 02:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhLHBSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 20:18:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44226 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230292AbhLHBSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 20:18:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IBOKcG1qaI9jepI2bCF3oCI/BCJ09P+8qve7w7qTBOM=; b=Ma7U5+qXsTd5kNRutCBYIya2j9
        oBT1sp+Rcm1CJP4CKfDmViheF/7cBmZMRR/+/DKc1rPl7sYOTTLtGVfCCa9IAhcCC4oHY8NSVf4Jy
        8xUXJmLy77v76Q9BBz+IxbRjZeTGi7sETSDdYFY4927kAdsl9xwvwQRVsa+iK7xEYoLQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mulY6-00FpWX-0N; Wed, 08 Dec 2021 02:15:10 +0100
Date:   Wed, 8 Dec 2021 02:15:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <YbAHHWZ8PlzPrGYU@lunn.ch>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <Ya/esX+GTet9PM+D@lunn.ch>
 <20211207234736.vpqurmattqx4a76h@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207234736.vpqurmattqx4a76h@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 01:47:36AM +0200, Vladimir Oltean wrote:
> On Tue, Dec 07, 2021 at 11:22:41PM +0100, Andrew Lunn wrote:
> > > I like the idea of tagger-owend per-switch-tree private data.
> > > Do we really need to hook logic?
> > 
> > We have two different things here.
> > 
> > 1) The tagger needs somewhere to store its own private data.
> > 2) The tagger needs to share state with the switch driver.
> > 
> > We can probably have the DSA core provide 1). Add the size to
> > dsa_device_ops structure, and provide helpers to go from either a
> > master or a slave netdev to the private data.
> 
> We cannot "add the size to the dsa_device_ops structure", because it is
> a singleton (const struct). It is not replicated at all, not per port,
> not per switch, not per tree, but global to the kernel. Not to mention
> const. Nobody needs state as shared as that.

What i'm suggesting is 

static const struct dsa_device_ops edsa_netdev_ops = {
        .name     = "edsa",
        .proto    = DSA_TAG_PROTO_EDSA,
        .xmit     = edsa_xmit,
        .rcv      = edsa_rcv,
        .needed_headroom = EDSA_HLEN,
	.priv_size = 42;
};

The priv_size indicates that an instance of this tagger needs 42 bytes
of private data. More likely it will be a sizeof(struct dsa_priv), but
that is a detail.

When a master is setup and the tagger instantiated, 42 bytes of memory
will be allocated and put somewhere it can be found via a helper.

This is not meant for shared state between the tagger and the switch
driver, this is private to the tagger. As such it is less likely to be
dependent on the number of ports etc. It is somewhere to store an skb
pointer, maybe a sequence number for the management message expected
as a reply from the switch etc.

   Andrew
