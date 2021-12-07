Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFEF46C761
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbhLGW0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:26:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43970 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233310AbhLGW0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 17:26:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Vw5BOFkSJ3OQNTdGVx0WTiEgvdw+Ohj/vP1ysKtmUI4=; b=iFwtJcMYJ0oIOtuiqMWS+tzZM7
        Ku+fAUqqiWIloVgV3bonCGDS4Lgloj+U65C5OGfQWBWTDgWAzHFxUoBw3KVAn83UFrLZMCsR4AYWj
        7rIFRyKKD/NiZMxG0p+l7xtG+zZYR+hQrMFGVQuk0iO2zfAo5pIDQitqyqs6oVhcKqoc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muirB-00FonC-ON; Tue, 07 Dec 2021 23:22:41 +0100
Date:   Tue, 7 Dec 2021 23:22:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <Ya/esX+GTet9PM+D@lunn.ch>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The main problem here is that we really need a way to have shared data
> between tagger and dsa driver. I also think that it would be limiting
> using this only for mdio. For example qca8k can autocast mib with
> Ethernet port and that would be another feature that the tagger would
> handle.

The Marvell switches also have an efficient way to get the whole MIB
table. So this is something i would also want.

> I like the idea of tagger-owend per-switch-tree private data.
> Do we really need to hook logic?

We have two different things here.

1) The tagger needs somewhere to store its own private data.
2) The tagger needs to share state with the switch driver.

We can probably have the DSA core provide 1). Add the size to
dsa_device_ops structure, and provide helpers to go from either a
master or a slave netdev to the private data.

2) is harder. But as far as i know, we have an 1:N setup.  One switch
driver can use N tag drivers. So we need the switch driver to be sure
the tag driver is what it expects. We keep the shared state in the tag
driver, so it always has valid data, but when the switch driver wants
to get a pointer to it, it needs to pass a enum dsa_tag_protocol and
if it does not match, the core should return -EINVAL or similar.

   Andrew
