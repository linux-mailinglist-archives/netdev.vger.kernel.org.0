Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0A730195E
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 04:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbhAXDhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 22:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbhAXDhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 22:37:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C12AE22583;
        Sun, 24 Jan 2021 03:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611459386;
        bh=akMV4ADvawbd5xbEeRfWHTqtAQ9OXS7p8jk2hktPLqM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kA65blENSwCIRyopmG7/qZQr2tV13FW31+h8vPKRA0+GyXp762UMUwlkBXRLGlY8I
         poh8M0V0iUgCKZsQIyHZef5IOLYytkFGSx38X45TxgN1Gq2/UOPm4+bgWuCn8gT6l2
         Mda78BAlNfdyXIoBKg+KyRy0jKqA18QHnK2e08jX19AjcCm04qBW2TquPIEyJGG9c5
         bRAJfQgPAfK1Yj5lfQozmhjEIzhA9ECATg6hUXK/vcbbqtciEzbxWVlhHs5H2wx7R0
         NPVZr+GJEy7Y2RvXYL7WAbuiOHmPS99cvfe7O//Jk5AF6m7R7FUnSkXzbAsrMpvDCK
         Trahv4lHBQzog==
Date:   Sat, 23 Jan 2021 19:36:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Enke Chen <enkechen2020@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] tcp: make TCP_USER_TIMEOUT accurate for zero window
 probes
Message-ID: <20210123193624.6111b292@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210124005643.GH129261@localhost.localdomain>
References: <20210122191306.GA99540@localhost.localdomain>
        <20210122174325.269ac329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210123022823.GA100578@localhost.localdomain>
        <20210122183424.59c716a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210123024534.GB100578@localhost.localdomain>
        <CADVnQy=zzrFf=sF+oMwjm+Pp-VJ-veC93poVp0XUPFKRoiGRUQ@mail.gmail.com>
        <20210124005643.GH129261@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 16:56:43 -0800 Enke Chen wrote:
> On Sat, Jan 23, 2021 at 07:19:13PM -0500, Neal Cardwell wrote:
> > On Fri, Jan 22, 2021 at 9:45 PM Enke Chen <enkechen2020@gmail.com> wrote:  
> > > On Fri, Jan 22, 2021 at 06:34:24PM -0800, Jakub Kicinski wrote:  
> > > > On Fri, 22 Jan 2021 18:28:23 -0800 Enke Chen wrote:  
> > > > > In terms of backporting, this patch should go together with:
> > > > >
> > > > >     9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window  
> > > >
> > > > As in it:
> > > >
> > > > Fixes: 9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window
> > > >
> > > > or does it further fix the same issue, so:
> > > >
> > > > Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
> > > >
> > > > ?  
> > >
> > > Let me clarify:
> > >
> > > 1) 9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window
> > >
> > >    fixes the bug and makes it work.
> > >
> > > 2) The current patch makes the TCP_USER_TIMEOUT accurate for 0-window probes.
> > >    It's independent.  
> > 
> > Patch (2) ("tcp: make TCP_USER_TIMEOUT accurate for zero window
> > probes") is indeed conceptually independent of (1) but its
> > implementation depends on the icsk_probes_tstamp field defined in (1),
> > so AFAICT (2) cannot be backported further back than (1).
> > 
> > Patch (1) fixes a bug in 5.1:
> >     Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
> > 
> > So probably (1) and (2) should be backported as a pair, and only back
> > as far as 5.1. (That covers 2 LTS kernels, 5.4 and 5.10, so hopefully
> > that is good enough.)
> 
> What you described is more accurate, and is correct.

That makes it clear.

I added a Fixes tag, reworded the message slightly and applied, thanks!
