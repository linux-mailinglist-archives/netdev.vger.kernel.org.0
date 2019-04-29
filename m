Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E2EDFF4
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 11:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfD2J7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 05:59:01 -0400
Received: from rp02.intra2net.com ([62.75.181.28]:44486 "EHLO
        rp02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbfD2J7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 05:59:01 -0400
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id D9268100093;
        Mon, 29 Apr 2019 11:58:58 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id B034D8B2;
        Mon, 29 Apr 2019 11:58:58 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.6,VDF=8.15.28.90)
X-Spam-Status: 
X-Spam-Level: 0
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id 48171302;
        Mon, 29 Apr 2019 11:58:56 +0200 (CEST)
Date:   Mon, 29 Apr 2019 11:58:56 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        Networking <netdev@vger.kernel.org>,
        Tilman Schmidt <tilman@imap.cc>,
        Paul Bolle <pebolle@tiscali.nl>,
        gigaset307x-common@lists.sourceforge.net,
        isdn4linux@listserv.isdn4linux.de,
        Al Viro <viro@zeniv.linux.org.uk>,
        Holger Schurig <holgerschurig@googlemail.com>
Subject: Re: [PATCH 5/5] isdn: move capi drivers to staging
Message-ID: <20190429095856.jedh4ujwjkslpyp5@intra2net.com>
References: <20190423151143.464992-1-arnd@arndb.de>
 <20190423151143.464992-12-arnd@arndb.de>
 <20190424092451.exkkwv2jkk5bwjfq@intra2net.com>
 <CAK8P3a0RKEdpk70tH8ac3QW=kjuz47Ghcz_CWLraoGV_Bb8Epw@mail.gmail.com>
 <20190424130625.uuqtujpvf7lyn4rc@intra2net.com>
 <CAK8P3a31NRqNJnBbZF=pUhQRrEoW0pZ37Wp-eABebG3iqXJe-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a31NRqNJnBbZF=pUhQRrEoW0pZ37Wp-eABebG3iqXJe-w@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

You wrote on Thu, Apr 25, 2019 at 01:24:09PM +0200:
> > > Right, this is what I'm trying to find out here. I realize that there
> > > are (very few) remaining users of ISDN voice services, but this only
> > > matters if someone uses them
> > >
> > > 1. with a modern Linux kernel, and planning to upgrade beyond linux-5.3
> > > 2. with a device driver that ships with the kernel
> > > 3. using the CAPI subsystem
> > >
> > > I suspect that all three of the above are true in isolation, but onless
> > > at least one person needs all three combined, that doesn't stop us
> > > from staging them out.
> >
> > 1. + 3. applies to us. The mISDN drivers are based on the kernel ones,
> > but maintained in an extra git tree on top of the kernel. The situation
> > is not ideal but that's what it currently is. git repo:
> > https://github.com/ISDN4Linux/mISDN
> 
> I'm still confused by this: You say here that you use the CAPI
> subsystem from the mainline kernel (i.e. /dev/capi20 rather
> than mISDNcapid), but this does not appear to interact at all with
> mISDN, neither the in-kernel variant nor the one you link to.

my working theory was that a userspace capi application
talks to mISDNcapid via the kernel's CAPI layer as a proxy.

Karsten's original announcement mentioned
mISDN v2 CAPI support is userspace only:
https://isdn4linux.listserv.isdn4linux.narkive.com/bRkOUkZG/announcement-misdn-fax-capi-2-0-support


I did some preliminary research by removing the /dev/capi20 device node
and checked if "capiinfo" still works via strace -> it does.

# strace -e open,connect capiinfo
open("/usr/lib/libcapi20.so.3", O_RDONLY|O_CLOEXEC) = 3
open("/dev/shm/sem.CAPI20_shared_sem.v01000010", O_RDWR|O_NOFOLLOW) = 3
open("/dev/shm/CAPI20_shared_memory.v01000010", O_RDWR|O_CREAT|O_NOFOLLOW|O_CLOEXEC, 0666) = 3
open("/usr/lib/capi/lib_capi_mod_misdn.so.2", O_RDONLY|O_CLOEXEC) = 5
open("/usr/lib/capi/lib_capi_mod_std.so.2", O_RDONLY|O_CLOEXEC) = 5
open("/root/.capi20rc", O_RDONLY)       = -1 ENOENT (No such file or directory)
open("/etc/capi20.conf", O_RDONLY)      = 4
open("/dev/capi20", O_RDWR)             = -1 ENOENT (No such file or directory)
open("/dev/isdn/capi20", O_RDWR)        = -1 ENOENT (No such file or directory)
connect(4, {sa_family=AF_UNIX, sun_path="/var/run/mISDNcapid/sock"}, 110) = 0
Number of Controllers : 1
connect(5, {sa_family=AF_UNIX, sun_path="/var/run/mISDNcapid/sock"}, 110) = 0
Controller 1:
Manufacturer: mISDN
CAPI Version: 2.0
Manufacturer Version: 0.1
Serial Number: 0000001
..

The trick is the lib_capi_mod_misdn.so library.
It's a plugin for the CAPI tools to directly talk to mISDNcapid.

I will do more thorough research next week if the CAPI userspace stuff runs with 
 the kernel CAPI layer disabled. It could be that the userspace tools like 
"capiinit" check for the presence of the kernel CAPI interface but don't really 
need it. We'll find out.

Intra2net officially supports AVM b1 and c4 cards for fax but we didn't
encounter these cards for years in customer support and I'm also 
willing to officially cancel support for those.

-> it's good to move the drivers to staging.

Best regards,
Thomas
