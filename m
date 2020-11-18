Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE452B7F33
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgKRONB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726306AbgKRONB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 09:13:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A03722240;
        Wed, 18 Nov 2020 14:12:59 +0000 (UTC)
Date:   Wed, 18 Nov 2020 09:12:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit@kernel.org>, Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: netconsole deadlock with virtnet
Message-ID: <20201118091257.2ee6757a@gandalf.local.home>
In-Reply-To: <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
References: <20201117102341.GR47002@unreal>
        <20201117093325.78f1486d@gandalf.local.home>
        <X7SK9l0oZ+RTivwF@jagdpanzerIV.localdomain>
        <X7SRxB6C+9Bm+r4q@jagdpanzerIV.localdomain>
        <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[ Adding netdev as perhaps someone there knows ]

On Wed, 18 Nov 2020 12:09:59 +0800
Jason Wang <jasowang@redhat.com> wrote:

> > This CPU0 lock(_xmit_ETHER#2) -> hard IRQ -> lock(console_owner) is
> > basically
> > 	soft IRQ -> lock(_xmit_ETHER#2) -> hard IRQ -> printk()
> >
> > Then CPU1 spins on xmit, which is owned by CPU0, CPU0 spins on
> > console_owner, which is owned by CPU1?  

It still looks to me that the target_list_lock is taken in IRQ, (which can
be the case because printk calls write_msg() which takes that lock). And
someplace there's a:

	lock(target_list_lock)
	lock(xmit_lock)

which means you can remove the console lock from this scenario completely,
and you still have a possible deadlock between target_list_lock and
xmit_lock.

> 
> 
> If this is true, it looks not a virtio-net specific issue but somewhere 
> else.
> 
> I think all network driver will synchronize through bh instead of hardirq.

I think the issue is where target_list_lock is held when we take xmit_lock.
Is there anywhere in netconsole.c that can end up taking xmit_lock while
holding the target_list_lock? If so, that's the problem. As
target_list_lock is something that can be taken in IRQ context, which means
*any* other lock that is taking while holding the target_list_lock must
also protect against interrupts from happening while it they are held.

-- Steve
