Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B8B1EA1C1
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgFAKVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbgFAKVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 06:21:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A289206C3;
        Mon,  1 Jun 2020 10:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591006910;
        bh=TaB04dQ7qWOoOckA6A6BZQDLASBjooiOp/G6JOq2HkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RsnnnY8R9RdD+SK0AeHwotge5Fk+7M+x4sdFlqpMjkGQoiNDzJCMvGZq/RGd+UWO7
         icI3lnibK2Ta/KtR9cUwZTPui5p7FunWCp/y+If2jZhkzQkEaU/65BbmvvPUhHwhaD
         AoRqu35nqrR86uBkUQyDau9sBhNqLI1Qdq38/yeM=
Date:   Mon, 1 Jun 2020 12:21:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        sergei.shtylyov@cogentembedded.com, bgolaszewski@baylibre.com,
        mika.westerberg@linux.intel.com, efremov@linux.com,
        ztuowen@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] devres: keep both device name and resource name in
 pretty name
Message-ID: <20200601102148.GA7229@kroah.com>
References: <20200601095826.1757621-1-olteanv@gmail.com>
 <20200601100441.GA1845725@kroah.com>
 <CA+h21hp2UmMqE_=Ky5J=B=X-ZdU78Fp52zb=vWEPGw9CbcjjVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hp2UmMqE_=Ky5J=B=X-ZdU78Fp52zb=vWEPGw9CbcjjVw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 01:13:16PM +0300, Vladimir Oltean wrote:
> Hi Greg,
> 
> On Mon, 1 Jun 2020 at 13:04, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jun 01, 2020 at 12:58:26PM +0300, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > Sometimes debugging a device is easiest using devmem on its register
> > > map, and that can be seen with /proc/iomem. But some device drivers have
> > > many memory regions. Take for example a networking switch. Its memory
> > > map used to look like this in /proc/iomem:
> > >
> > > 1fc000000-1fc3fffff : pcie@1f0000000
> > >   1fc000000-1fc3fffff : 0000:00:00.5
> > >     1fc010000-1fc01ffff : sys
> > >     1fc030000-1fc03ffff : rew
> > >     1fc060000-1fc0603ff : s2
> > >     1fc070000-1fc0701ff : devcpu_gcb
> > >     1fc080000-1fc0800ff : qs
> > >     1fc090000-1fc0900cb : ptp
> > >     1fc100000-1fc10ffff : port0
> > >     1fc110000-1fc11ffff : port1
> > >     1fc120000-1fc12ffff : port2
> > >     1fc130000-1fc13ffff : port3
> > >     1fc140000-1fc14ffff : port4
> > >     1fc150000-1fc15ffff : port5
> > >     1fc200000-1fc21ffff : qsys
> > >     1fc280000-1fc28ffff : ana
> > >
> > > But after the patch in Fixes: was applied, the information is now
> > > presented in a much more opaque way:
> > >
> > > 1fc000000-1fc3fffff : pcie@1f0000000
> > >   1fc000000-1fc3fffff : 0000:00:00.5
> > >     1fc010000-1fc01ffff : 0000:00:00.5
> > >     1fc030000-1fc03ffff : 0000:00:00.5
> > >     1fc060000-1fc0603ff : 0000:00:00.5
> > >     1fc070000-1fc0701ff : 0000:00:00.5
> > >     1fc080000-1fc0800ff : 0000:00:00.5
> > >     1fc090000-1fc0900cb : 0000:00:00.5
> > >     1fc100000-1fc10ffff : 0000:00:00.5
> > >     1fc110000-1fc11ffff : 0000:00:00.5
> > >     1fc120000-1fc12ffff : 0000:00:00.5
> > >     1fc130000-1fc13ffff : 0000:00:00.5
> > >     1fc140000-1fc14ffff : 0000:00:00.5
> > >     1fc150000-1fc15ffff : 0000:00:00.5
> > >     1fc200000-1fc21ffff : 0000:00:00.5
> > >     1fc280000-1fc28ffff : 0000:00:00.5
> > >
> > > That patch made a fair comment that /proc/iomem might be confusing when
> > > it shows resources without an associated device, but we can do better
> > > than just hide the resource name altogether. Namely, we can print the
> > > device name _and_ the resource name. Like this:
> > >
> > > 1fc000000-1fc3fffff : pcie@1f0000000
> > >   1fc000000-1fc3fffff : 0000:00:00.5
> > >     1fc010000-1fc01ffff : 0000:00:00.5 sys
> > >     1fc030000-1fc03ffff : 0000:00:00.5 rew
> > >     1fc060000-1fc0603ff : 0000:00:00.5 s2
> > >     1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
> > >     1fc080000-1fc0800ff : 0000:00:00.5 qs
> > >     1fc090000-1fc0900cb : 0000:00:00.5 ptp
> > >     1fc100000-1fc10ffff : 0000:00:00.5 port0
> > >     1fc110000-1fc11ffff : 0000:00:00.5 port1
> > >     1fc120000-1fc12ffff : 0000:00:00.5 port2
> > >     1fc130000-1fc13ffff : 0000:00:00.5 port3
> > >     1fc140000-1fc14ffff : 0000:00:00.5 port4
> > >     1fc150000-1fc15ffff : 0000:00:00.5 port5
> > >     1fc200000-1fc21ffff : 0000:00:00.5 qsys
> > >     1fc280000-1fc28ffff : 0000:00:00.5 ana
> >
> > As this is changing the format of a user-visable file, what tools just
> > broke that are used to parsing the old format?
> >
> 
> All the same tools that broke after 8d84b18f5678 was merged. I am not
> entirely sure why the 'stable ABI' argument was not brought up there
> as well.
> 
> > And are you sure about this?  That's not how my system looks at all, I
> > have fun things like:
> >
> >    ac000000-da0fffff : PCI Bus 0000:03
> >     ac000000-da0fffff : PCI Bus 0000:04
> >       ac000000-c3efffff : PCI Bus 0000:06
> >       c3f00000-c3ffffff : PCI Bus 0000:39
> >         c3f00000-c3f0ffff : 0000:39:00.0
> >           c3f00000-c3f0ffff : xhci-hcd
> >       c4000000-d9ffffff : PCI Bus 0000:3a
> >         c4000000-d9ffffff : PCI Bus 0000:3b
> >           c4000000-c40fffff : PCI Bus 0000:3c
> >           c4000000-c400ffff : 0000:3c:00.0
> >           c4000000-c400ffff : xhci-hcd
> >           c4010000-c4010fff : 0000:3c:00.0
> >           c4011000-c4011fff : 0000:3c:00.0
> >           c4100000-c41fffff : PCI Bus 0000:3d
> >           c4100000-c410ffff : 0000:3d:00.0
> >           c4100000-c410ffff : xhci-hcd
> >           c4110000-c4110fff : 0000:3d:00.0
> >           c4111000-c4111fff : 0000:3d:00.0
> >           c4200000-c42fffff : PCI Bus 0000:3e
> >           c4200000-c4207fff : 0000:3e:00.0
> >           c4200000-c4207fff : xhci-hcd
> >           c4300000-c43fffff : PCI Bus 0000:3f
> >           c4300000-c437ffff : 0000:3f:00.0
> >           c4380000-c4383fff : 0000:3f:00.0
> >           c4400000-d9ffffff : PCI Bus 0000:40
> >       da000000-da0fffff : PCI Bus 0000:05
> >         da000000-da03ffff : 0000:05:00.0
> >         da040000-da040fff : 0000:05:00.0
> >
> >
> > which is a mix of the resources in some places, and just driver names in
> > others.
> >
> > But, that does imply that your change will not break anything as the
> > parsing of this mess is probably just "anything after the ':'
> > character...
> >
> > thanks,
> >
> > greg k-h
> 
> With this patch you'll just have more (potentially redundant)
> information. I'm not really sure how to satisfy everyone here. I was
> completely fine with pre-8d84b18f5678 behavior.

Fair enough, I'll try it out after 5.8-rc1 is out, as I can't do
anything about this until that happens.

thanks,

greg k-h
