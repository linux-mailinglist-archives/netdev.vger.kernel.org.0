Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362F122E2CC
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 23:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgGZVnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 17:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbgGZVnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 17:43:50 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E71A6206E3;
        Sun, 26 Jul 2020 21:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595799830;
        bh=NuinqTC0rRk064ZYaZrnWrKR4dJgNmfjHMZTY6hKTfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B4gf2fhYJm5YLqR9bfCvTfldNU9zzEFC+pMm7ITyYgpS26nnCT+Glfb/wxMDjh10K
         nCpkwM4QFtcd1PUOGiq+OxV41i6G9cecZ7FhfQeuiw3d9nwdCcd9VReNWpN05iEEwq
         0G33u82aN29vlmDe1TY29LViiDzkJ/U4CsIA2AZ0=
Received: by pali.im (Postfix)
        id 8D35076D; Sun, 26 Jul 2020 23:43:47 +0200 (CEST)
Date:   Sun, 26 Jul 2020 23:43:47 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, netdev@vger.kernel.org
Subject: Re: IPv6: proxy_ndp to a network range
Message-ID: <20200726214347.gezdwrn4l745vtsc@pali>
References: <31ff66eb-38bd-0186-9e81-0543f0558323@zytor.com>
 <20160509083903.GA2462@omega>
 <A2319CD4-6907-4B21-A4DD-03CCA38328FA@zytor.com>
 <20160509145109.GB7267@omega>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160509145109.GB7267@omega>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, I would like to brisk up this thread again!

On Monday 09 May 2016 16:51:10 Alexander Aring wrote:
> Hi,
> 
> On Mon, May 09, 2016 at 01:46:13AM -0700, H. Peter Anvin wrote:
> > On May 9, 2016 1:39:08 AM PDT, Alexander Aring <alex.aring@gmail.com> wrote:
> > >Hi,
> > >
> > >On Mon, May 09, 2016 at 01:06:51AM -0700, H. Peter Anvin wrote:
> > >> Hello,
> > >> 
> > >> There currently doesn't seem to be any support for proxy_ndp of a whole
> > >> network mask, as IPv4 proxy_arp seems to permit.
> > >> 
> > >> a) Am I actually correct in this, or am I just missing something important?
> > >> 

IPv4 proxy_arp has ioctl API for specifying subnet (not only one
address), but support for it was removed in Linux kernel version 2.1.79
which was released long time ago. And therefore since Linux kernel 2.2
support for specifying netmask different than 255.255.255.255 is not
possible anymore.

There is for example still HOWTO guide for old Linux kernel 2.0 how to
setup proxy arp with subnetting via "arp" command line utility.

https://www.tldp.org/HOWTO/Proxy-ARP-Subnet/setup.html

That "arp" utility in Linux distributions in recent versions still
supports specifying "netmask" argument, but recent kernel versions just
returns -EINVAL when netmask is specified to value different than
255.255.255.255.

I do not know what was the reason for removing this functionality...
Maybe there were some optimizations in lookup tables and authors decided
that such functionality was not used and did not reimplemented it? Just
guessing, who knows...

> > >> b) Is there a technical reason for this, or is it just a limitation of the
> > >> current implementation?
> > >> 

I think this is just limitation of the current implementation (for both
IPv4 and IPv6). I think that there were no interested users in such
functionality and therefore nobody implemented it (again for IPv4).

From technical point of view, it is probably harder to have optimized
implementation as it would require some smart data structure with
support for merging and splitting radix trees for fast query if address
is in some proxy range or not.

> > >
> > >So far I know you can do this with the ndppd [0] userspace tool which listen
> > >NS/NA messages and do the ip -6 neigh add proxy for you.
> > >
> > >- Alex
> > >
> > >[0] https://github.com/DanielAdolfsson/ndppd
> > 
> > Sure, but it seems like a workaround for something that ought to be simpler?
> 
> I don't know if there exists a simpler way, but I would also be
> interested into that.
> 
> There are some people @linux-wpan which wants to plugin an ethernet cable
> and everything works out of the box to access the 6LoWPAN network over
> the ethernet connection without doing routing setup stuff.
> 
> "ndppd" was on my list to test for realize such setup. :-)

There are already more userspace daemons which are doing this IPv6 NDP
proxy either by forwarding packets or automatically answering NDP
replies.

So such setup / functionality is not rare and is already used by lot of
people.

> ---
> 
> For the simpler solution do you want to move the actually mechanism what
> "ndppd" does into the kernel?

Because we already have support for IPv4 ARP and IPv6 NDP proxies in
kernel, with limitation to one address, I think it make sense to extend
this implementation also for netmask/range.

Personally, I would like to see this feature in kernel (again). There
are lot of setup which requires NDP proxy in IPv6 world (e.g. when ISP
provides only link prefix, not routed prefix) or also in IPv4 world
(e.g. when ISP provides block of addresses via one PPPoE tunnel).

For IPv4 we already have existing (ioctl) API and existing utilities
which are using this API. But for IPv6 (and ideally also for IPv4) would
be needed to extend netlink API which is used by "ip neighbour" utility.


Alex and Peter, are you still interested in in-kernel IPv6 NDP proxy?
