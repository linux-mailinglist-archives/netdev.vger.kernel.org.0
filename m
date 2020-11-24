Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6B22C1F57
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 09:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgKXICB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 03:02:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgKXICB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 03:02:01 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45C6C206B2;
        Tue, 24 Nov 2020 08:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606204917;
        bh=EDmGqKWfP1BJURlqQVKhMsODP0f5WK2V4tGKfcjOcDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qL2nio79sg3EzZoAagtmOiIAhR1f8ajLOHlC1OrlrNAgo3PeLE1uGQ635+QqZmxxD
         yEvTUaPsZzukOViVUSaz/ygqzQNCIDrBr917OGFojSaT7KvlJ3tA25kebvPWb+ktdd
         cE3pDIIU4XO7Arori1ub69q0B4lCh757Sg+TFmCU=
Date:   Tue, 24 Nov 2020 10:01:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit@kernel.org>, Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: netconsole deadlock with virtnet
Message-ID: <20201124080152.GG3159@unreal>
References: <X7SK9l0oZ+RTivwF@jagdpanzerIV.localdomain>
 <X7SRxB6C+9Bm+r4q@jagdpanzerIV.localdomain>
 <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
 <20201118091257.2ee6757a@gandalf.local.home>
 <20201123110855.GD3159@unreal>
 <20201123093128.701cf81b@gandalf.local.home>
 <20201123105252.1c295138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201123140934.38748be3@gandalf.local.home>
 <20201123112130.759b9487@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1133f1a4-6772-8aa3-41dd-edbc1ee76cee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1133f1a4-6772-8aa3-41dd-edbc1ee76cee@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 11:22:03AM +0800, Jason Wang wrote:
>
> On 2020/11/24 上午3:21, Jakub Kicinski wrote:
> > On Mon, 23 Nov 2020 14:09:34 -0500 Steven Rostedt wrote:
> > > On Mon, 23 Nov 2020 10:52:52 -0800
> > > Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > > On Mon, 23 Nov 2020 09:31:28 -0500 Steven Rostedt wrote:
> > > > > On Mon, 23 Nov 2020 13:08:55 +0200
> > > > > Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > >   [   10.028024] Chain exists of:
> > > > > >   [   10.028025]   console_owner --> target_list_lock --> _xmit_ETHER#2
> > > > > Note, the problem is that we have a location that grabs the xmit_lock while
> > > > > holding target_list_lock (and possibly console_owner).
> > > > Well, it try_locks the xmit_lock. Does lockdep understand try-locks?
> > > >
> > > > (not that I condone the shenanigans that are going on here)
> > > Does it?
> > >
> > > 	virtnet_poll_tx() {
> > > 		__netif_tx_lock() {
> > > 			spin_lock(&txq->_xmit_lock);
> > Umpf. Right. I was looking at virtnet_poll_cleantx()
> >
> > > That looks like we can have:
> > >
> > >
> > > 	CPU0		CPU1
> > > 	----		----
> > >     lock(xmit_lock)
> > >
> > > 		    lock(console)
> > > 		    lock(target_list_lock)
> > > 		    __netif_tx_lock()
> > > 		        lock(xmit_lock);
> > >
> > > 			[BLOCKED]
> > >
> > >     <interrupt>
> > >     lock(console)
> > >
> > >     [BLOCKED]
> > >
> > >
> > >
> > >   DEADLOCK.
> > >
> > >
> > > So where is the trylock here?
> > >
> > > Perhaps you need the trylock in virtnet_poll_tx()?
> > That could work. Best if we used normal lock if !!budget, and trylock
> > when budget is 0. But maybe that's too hairy.
>
>
> If we use trylock, we probably lose(or delay) tx notification that may have
> side effects to the stack.
>
>
> >
> > I'm assuming all this trickiness comes from virtqueue_get_buf() needing
> > locking vs the TX path? It's pretty unusual for the completion path to
> > need locking vs xmit path.
>
>
> Two reasons for doing this:
>
> 1) For some historical reason, we try to free transmitted tx packets in xmit
> (see free_old_xmit_skbs() in start_xmit()), we can probably remove this if
> we remove the non tx interrupt mode.
> 2) virtio core requires virtqueue_get_buf() to be synchronized with
> virtqueue_add(), we probably can solve this but it requires some non trivial
> refactoring in the virtio core

So how will we solve our lockdep issues?

Thanks

>
> Btw, have a quick search, there are several other drivers that uses tx lock
> in the tx NAPI.
>
> Thanks
>
> >
>
