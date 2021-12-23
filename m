Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA4947E418
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 14:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348645AbhLWN2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 08:28:46 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:40261 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348650AbhLWN2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 08:28:45 -0500
Received: (Authenticated sender: repk@triplefau.lt)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id BDC531BF20E;
        Thu, 23 Dec 2021 13:28:42 +0000 (UTC)
Date:   Thu, 23 Dec 2021 14:33:40 +0100
From:   Remi Pommarel <repk@triplefau.lt>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Networking <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: bridge: fix ioctl old_deviceless bridge argument
Message-ID: <YcR6tAsH9/+sAawW@pilgrim>
References: <20211222191320.17662-1-repk@triplefau.lt>
 <CAK8P3a18b63GoPKiTey8KpEusyffbN97gxP+NM3fyZnOYXv5zg@mail.gmail.com>
 <YcRW1ckSr3ZSCDf9@pilgrim>
 <CAK8P3a0PTu2qCHGr63TBMgnjL9fQwn4=7CrURKMHQufffwOg9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0PTu2qCHGr63TBMgnjL9fQwn4=7CrURKMHQufffwOg9Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 12:38:14PM +0100, Arnd Bergmann wrote:
> On Thu, Dec 23, 2021 at 12:00 PM Remi Pommarel <repk@triplefau.lt> wrote:
> >
> > On Wed, Dec 22, 2021 at 10:52:20PM +0100, Arnd Bergmann wrote:
> > > On Wed, Dec 22, 2021 at 8:13 PM Remi Pommarel <repk@triplefau.lt> wrote:
> > [...]
> > >
> > > The intention of my broken patch was to make it work for compat mode as I did
> > > in br_dev_siocdevprivate(), as this is now the only bit that remains broken.
> > >
> > > This could be done along the lines of the patch below, if you see any value in
> > > it. (not tested, probably not quite right).
> >
> > Oh ok, because SIOC{S,G}IFBR compat ioctl was painfully done with
> > old_bridge_ioctl() I didn't think those needed compat. So I adapted and
> > fixed your patch to get that working.
> 
> Ok, thanks!
> 
> > Here is my test results.
> >
> > With my initial patch only :
> >   - 64bit busybox's brctl (working)
> >     # brctl show
> >     bridge name     bridge id               STP enabled     interfaces
> >     br0             8000.000000000000       n
> >
> >   - CONFIG_COMPAT=y + 32bit busybox's brctl (not working)
> >     # brctl show
> >     brctl: SIOCGIFBR: Invalid argument
> >
> > With both my intial patch and the one below :
> >   - 64bit busybox's brctl (working)
> >     # brctl show
> >     bridge name     bridge id               STP enabled     interfaces
> >     br0             8000.000000000000       n
> >
> >   - CONFIG_COMPAT=y + 32bit busybox's brctl (working)
> >     # brctl show
> >     bridge name     bridge id               STP enabled     interfaces
> >     br0             8000.000000000000       n
> >
> > If you think this has enough value to fix those compatility issues I can
> > either send the below patch as a V2 replacing my initial one for net
> > or sending it as a separate patch for net-next. What would you rather
> > like ?
> 
> If 32-bit busybox still uses those ioctls in moderately recent
> versions, then it's probably worth doing this, but that would
> be up to the bridge maintainers.
> 
> Your patch looks good to me, I see you caught a few mistakes
> in my prototype. I would however suggest basing it on top of
> your original fix, so that can be applied first and backported
> to stable kernels, while the new patch would go on top and
> not get backported.
> 
> If that works with everyone, please submit those two, and add
> these tags to the second patch:
> 
> Co-developed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Ok thanks a lot, will send a new patch serie with both patches so
that bridge maintainers could only pick one or both patches.

-- 
Remi
