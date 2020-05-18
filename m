Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E74C1D710D
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 08:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgERGar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 02:30:47 -0400
Received: from verein.lst.de ([213.95.11.211]:36998 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbgERGaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 02:30:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 970DF68AFE; Mon, 18 May 2020 08:30:43 +0200 (CEST)
Date:   Mon, 18 May 2020 08:30:43 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Miller <davem@davemloft.net>
Cc:     hch@lst.de, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ipv6: symbol_get to access a sit symbol
Message-ID: <20200518063043.GA19046@lst.de>
References: <20200514145101.3000612-5-hch@lst.de> <20200514.175355.167885308958584692.davem@davemloft.net> <20200515063324.GA31377@lst.de> <20200516.135548.2079608042651975047.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516.135548.2079608042651975047.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 01:55:48PM -0700, David Miller wrote:
> From: Christoph Hellwig <hch@lst.de>
> Date: Fri, 15 May 2020 08:33:24 +0200
> 
> > My initial plan was to add a ->tunnel_ctl method to the net_device_ops,
> > and lift the copy_{to,from}_user for SIOCADDTUNNEL, SIOCCHGTUNNEL,
> > SIOCDELTUNNEL and maybe SIOCGETTUNNEL to net/socket.c.  But that turned
> > out to have two problems:
> > 
> >  - first these ioctls names use SIOCDEVPRIVATE range, that can also
> >    be implemented by other drivers
> >  - the ip_tunnel_parm struture is only used by the ipv4 tunneling
> >    drivers (including sit), the "real" ipv6 tunnels use a
> >    ip6_tnl_parm or ip6_tnl_parm structure instead
> 
> Yes, this is the core of the problem, the user provided data's type
> is unknown until we are very deep in the call chains.
> 
> I wonder if there is some clever way to propagate this size value
> "up"?

As far as I can tell the only information vectors is the net_device
structure or its op vector.  But even then we have the problem that
other devices use the SIOCDEVPRIVATE range for something else.

I'll look into implenenting the tunnel_ctl method just for kernel
callers (plus maybe a generic helper for the ioctl), and we'll see if
you like that better.
