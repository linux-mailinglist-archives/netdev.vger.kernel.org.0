Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D322C1472
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgKWTVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbgKWTVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 14:21:33 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7FD42063A;
        Mon, 23 Nov 2020 19:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606159292;
        bh=KfxFlQuajCenee109XhJxaPlP6rp+PMyf3C8Ncdk2po=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DXm8tTZ1fX/p3Uq97wd2sMjm2hWpHsGJ6szg81SyFhIL5DePVGGap8aEYTfcKVlOl
         sPewyuV4iTVbrW7Yzhg0x7VgEZu2t4nDD4u6mBa3BOM7Pkd2oCfNpTIsPLQjyEErxw
         +G/zSxG812maajLAGNfhFPci6WfSL7RXvL2DkR4U=
Date:   Mon, 23 Nov 2020 11:21:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit@kernel.org>, Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: netconsole deadlock with virtnet
Message-ID: <20201123112130.759b9487@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123140934.38748be3@gandalf.local.home>
References: <20201117102341.GR47002@unreal>
        <20201117093325.78f1486d@gandalf.local.home>
        <X7SK9l0oZ+RTivwF@jagdpanzerIV.localdomain>
        <X7SRxB6C+9Bm+r4q@jagdpanzerIV.localdomain>
        <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
        <20201118091257.2ee6757a@gandalf.local.home>
        <20201123110855.GD3159@unreal>
        <20201123093128.701cf81b@gandalf.local.home>
        <20201123105252.1c295138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201123140934.38748be3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 14:09:34 -0500 Steven Rostedt wrote:
> On Mon, 23 Nov 2020 10:52:52 -0800
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Mon, 23 Nov 2020 09:31:28 -0500 Steven Rostedt wrote:  
> > > On Mon, 23 Nov 2020 13:08:55 +0200
> > > Leon Romanovsky <leon@kernel.org> wrote:
> > > 
> > >     
> > > >  [   10.028024] Chain exists of:
> > > >  [   10.028025]   console_owner --> target_list_lock --> _xmit_ETHER#2      
> > > 
> > > Note, the problem is that we have a location that grabs the xmit_lock while
> > > holding target_list_lock (and possibly console_owner).    
> > 
> > Well, it try_locks the xmit_lock. Does lockdep understand try-locks?
> > 
> > (not that I condone the shenanigans that are going on here)  
> 
> Does it?
> 
> 	virtnet_poll_tx() {
> 		__netif_tx_lock() {
> 			spin_lock(&txq->_xmit_lock);

Umpf. Right. I was looking at virtnet_poll_cleantx()

> That looks like we can have:
> 
> 
> 	CPU0		CPU1
> 	----		----
>    lock(xmit_lock)
> 
> 		    lock(console)
> 		    lock(target_list_lock)
> 		    __netif_tx_lock()
> 		        lock(xmit_lock);
> 
> 			[BLOCKED]
> 
>    <interrupt>
>    lock(console)
> 
>    [BLOCKED]
> 
> 
> 
>  DEADLOCK.
> 
> 
> So where is the trylock here?
> 
> Perhaps you need the trylock in virtnet_poll_tx()?

That could work. Best if we used normal lock if !!budget, and trylock
when budget is 0. But maybe that's too hairy.

I'm assuming all this trickiness comes from virtqueue_get_buf() needing
locking vs the TX path? It's pretty unusual for the completion path to
need locking vs xmit path.
