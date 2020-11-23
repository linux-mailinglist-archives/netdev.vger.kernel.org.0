Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592312C1434
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbgKWTJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:09:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728672AbgKWTJh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 14:09:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E840222252;
        Mon, 23 Nov 2020 19:09:35 +0000 (UTC)
Date:   Mon, 23 Nov 2020 14:09:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jakub Kicinski <kuba@kernel.org>
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
Message-ID: <20201123140934.38748be3@gandalf.local.home>
In-Reply-To: <20201123105252.1c295138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201117102341.GR47002@unreal>
        <20201117093325.78f1486d@gandalf.local.home>
        <X7SK9l0oZ+RTivwF@jagdpanzerIV.localdomain>
        <X7SRxB6C+9Bm+r4q@jagdpanzerIV.localdomain>
        <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
        <20201118091257.2ee6757a@gandalf.local.home>
        <20201123110855.GD3159@unreal>
        <20201123093128.701cf81b@gandalf.local.home>
        <20201123105252.1c295138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 10:52:52 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Mon, 23 Nov 2020 09:31:28 -0500 Steven Rostedt wrote:
> > On Mon, 23 Nov 2020 13:08:55 +0200
> > Leon Romanovsky <leon@kernel.org> wrote:
> > 
> >   
> > >  [   10.028024] Chain exists of:
> > >  [   10.028025]   console_owner --> target_list_lock --> _xmit_ETHER#2    
> > 
> > Note, the problem is that we have a location that grabs the xmit_lock while
> > holding target_list_lock (and possibly console_owner).  
> 
> Well, it try_locks the xmit_lock. Does lockdep understand try-locks?
> 
> (not that I condone the shenanigans that are going on here)

Does it?

	virtnet_poll_tx() {
		__netif_tx_lock() {
			spin_lock(&txq->_xmit_lock);

That looks like we can have:


	CPU0		CPU1
	----		----
   lock(xmit_lock)

		    lock(console)
		    lock(target_list_lock)
		    __netif_tx_lock()
		        lock(xmit_lock);

			[BLOCKED]

   <interrupt>
   lock(console)

   [BLOCKED]



 DEADLOCK.


So where is the trylock here?

Perhaps you need the trylock in virtnet_poll_tx()?

-- Steve
