Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21588279BDE
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 20:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgIZS22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 14:28:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgIZS21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 14:28:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMEvp-00GIhh-9g; Sat, 26 Sep 2020 20:28:25 +0200
Date:   Sat, 26 Sep 2020 20:28:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net-next 06/16] net: dsa: add a generic procedure for
 the flow dissector
Message-ID: <20200926182825.GG3883417@lunn.ch>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
 <20200926173108.1230014-7-vladimir.oltean@nxp.com>
 <20200926180545.GD3883417@lunn.ch>
 <20200926181814.frtajym5dem4byx4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926181814.frtajym5dem4byx4@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 09:18:15PM +0300, Vladimir Oltean wrote:
> On Sat, Sep 26, 2020 at 08:05:45PM +0200, Andrew Lunn wrote:
> > Given spectra and meltdown etc, jumping through a pointer is expensive
> > and we try to avoid it on the hot path. Given most of the taggers are
> > going to use the generic version, maybe add a test here, is
> > ops->flow_dissect the generic version, and if so, call it directly,
> > rather than go through the pointer. Or only set ops->flow_dissect if
> > the generic version cannot be used.
> 
> Agree about the motivation to eliminate an indirect call if possible.
> 
> The situation is as follows:
> - Some taggers are before DMAC or before EtherType. These are the vast
>   majority, and dsa_tag_generic_flow_dissect works well for them. We can
>   keep the .flow_dissect callback as an override, but if this is absent,
>   then the flow dissector can call dsa_tag_generic_flow_dissect
>   directly.
> - Some taggers use tail tags. These don't need any massaging at all. But
>   we need to tell the flow dissector to not call
>   dsa_tag_generic_flow_dissect if it doesn't find a function pointer.
>   I'm thinking about adding another "bool tail_tag" in struct
>   dsa_device_ops, for this purpose and not only*.
>   *Usually tunnel interfaces need to set dev->needed_headroom for the
>   memory allocator. But DSA doesn't request that, and needs to check
>   manually in the xmit function if the headroom is large enough to push
>   a tag. BUT! tail tags don't need dev->needed_headroom, they need
>   dev->needed_tailroom, I think. So I was thinking about adding this
>   bool anyway, to distinguish between these 2 cases.
> 
> What do you think?

Sounds good.

       Andrew
