Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6486B420ABB
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhJDMUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:20:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47374 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhJDMUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 08:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wnM2im3ufvccxVTb57umAjuJY+JPdwLkdD8qwKSUKpE=; b=zlTxWnoIPG58Q/uH2SdnGtUEpj
        WdpDlaA/bKJpvAjN37oaTs9jzaCm93IR9W8NH6cff1jmwJwNIGWeX8dODGjvAUvdQGFkqTsusvwSM
        UF6r4ZT8D787cXyNOix9tQW55brjkT67IbVrwac7VI/VegUar1SB7TPb7NfmoKjB1NMA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXMvm-009XIC-U2; Mon, 04 Oct 2021 14:18:54 +0200
Date:   Mon, 4 Oct 2021 14:18:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] dsa: tag_dsa: Handle !CONFIG_BRIDGE_VLAN_FILTERING
 case
Message-ID: <YVrxLvHqkyvdYIfb@lunn.ch>
References: <20211003155141.2241314-1-andrew@lunn.ch>
 <20211003210354.tiyaqsdje6ju7arz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211003210354.tiyaqsdje6ju7arz@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 03, 2021 at 09:03:55PM +0000, Vladimir Oltean wrote:
> On Sun, Oct 03, 2021 at 05:51:41PM +0200, Andrew Lunn wrote:
> > If CONFIG_BRIDGE_VLAN_FILTERING is disabled, br_vlan_enabled() is
> > replaced with a stub which returns -EINVAL.
> 
> br_vlan_enabled() returns bool, so it cannot hold -EINVAL. The stub for
> that returns false. We negate that false, make it true, and then call
> br_vlan_get_pvid_rcu() which returns -EINVAL because of _its_ stub
> implementation.

Yeh, i got the names of the functions wrong. I will fix that.

> In fact it is actually wrong to inject into the switch using the
> bridge's pvid, if VLAN awareness is turned off. We should be able to
> send and receive packets in that mode regardless of whether a pvid
> exists for the bridge device or not. That is also what we document in
> Documentation/networking/switchdev.rst.
> 
> So if VLAN 0 does that trick, perfect, we should just delete the entire
> "if (!br_vlan_enabled(br))" block.

I will rework the patch and test it without the if.

Thanks
	Andrew
