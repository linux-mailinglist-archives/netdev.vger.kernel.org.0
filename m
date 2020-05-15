Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698201D45F2
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 08:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgEOGd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 02:33:27 -0400
Received: from verein.lst.de ([213.95.11.211]:55034 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgEOGd1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 02:33:27 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 499BB68BFE; Fri, 15 May 2020 08:33:24 +0200 (CEST)
Date:   Fri, 15 May 2020 08:33:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Miller <davem@davemloft.net>
Cc:     hch@lst.de, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ipv6: symbol_get to access a sit symbol
Message-ID: <20200515063324.GA31377@lst.de>
References: <20200514145101.3000612-1-hch@lst.de> <20200514145101.3000612-5-hch@lst.de> <20200514.175355.167885308958584692.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200514.175355.167885308958584692.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 05:53:55PM -0700, David Miller wrote:
> You're not undoing one, but two levels of abstraction here.
> 
> Is this "ipip6_tunnel_locate()" call part of the SIT ioctl implementation?

Yes.  Take a look at the convoluted case handling the
SIOCADDTUNNEL and SIOCCHGTUNNEL commands in ipip6_tunnel_ioctl.

> Where did it come from?   Why are ->ndo_do_ioctl() implementations no longer
> allowed from here?

The problem is that we feed kernel pointers to it, which requires
set_fs address space overrides that I plan to kill off entirely.

> Honestly, this feels like a bit much.

My initial plan was to add a ->tunnel_ctl method to the net_device_ops,
and lift the copy_{to,from}_user for SIOCADDTUNNEL, SIOCCHGTUNNEL,
SIOCDELTUNNEL and maybe SIOCGETTUNNEL to net/socket.c.  But that turned
out to have two problems:

 - first these ioctls names use SIOCDEVPRIVATE range, that can also
   be implemented by other drivers
 - the ip_tunnel_parm struture is only used by the ipv4 tunneling
   drivers (including sit), the "real" ipv6 tunnels use a
   ip6_tnl_parm or ip6_tnl_parm structure instead

But if you don't like the symbol_get approach, I could do the
tunnel_ctl operation, just for the іpv4-ish tunnels, and only for
the kernel callers.

---end quoted text---
