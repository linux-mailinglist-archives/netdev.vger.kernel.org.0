Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A1A2218C5
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 02:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgGPAWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 20:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgGPAWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 20:22:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6228206F5;
        Thu, 16 Jul 2020 00:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594858973;
        bh=LifB723jX3wlK3H1LGnWV7Ko6nteEhN4t/6F+somndE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zrG75ktdf6FbaLNxaC+toAQYoXYcQQa3dTQWYcY0f5CNTf9DLfCmqxdz4ZHQ/4CSL
         DOtl5S75ezpvHmO6TsKpnf2orVV+tVAZdk/luIFtcrNeEDl5we8xh2DJccarUQQRll
         dLZosg0Y6wj+iXeuilEBesvciEmthgTNW8DMiah8=
Date:   Wed, 15 Jul 2020 17:22:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     John Ogness <john.ogness@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] af_packet: TPACKET_V3: replace busy-wait loop
Message-ID: <20200715172250.7b58f058@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+FuTSe1WXLGKd2zNLmQiKTZeNN64R-vGJTNMuVD_4VA8AN5Fg@mail.gmail.com>
References: <20200707152204.10314-1-john.ogness@linutronix.de>
        <20200715132141.2c72ae75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+FuTSe1WXLGKd2zNLmQiKTZeNN64R-vGJTNMuVD_4VA8AN5Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 18:35:00 -0400 Willem de Bruijn wrote:
> On Wed, Jul 15, 2020 at 4:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue,  7 Jul 2020 17:28:04 +0206 John Ogness wrote:  
> > > A busy-wait loop is used to implement waiting for bits to be copied
> > > from the skb to the kernel buffer before retiring a block. This is
> > > a problem on PREEMPT_RT because the copying task could be preempted
> > > by the busy-waiting task and thus live lock in the busy-wait loop.
> > >
> > > Replace the busy-wait logic with an rwlock_t. This provides lockdep
> > > coverage and makes the code RT ready.
> > >
> > > Signed-off-by: John Ogness <john.ogness@linutronix.de>  
> >
> > Is taking a lock and immediately releasing it better than a completion?
> > Seems like the lock is guaranteed to dirty a cache line, which would
> > otherwise be avoided here.
> >
> > Willem, would you be able to take a look as well? Is this path
> > performance sensitive in real life?  
> 
> No objections from me.
> 
> I guess this resolves the issue on preempt_rt, because the spinlocks act as
> mutexes. It will still spin on write_lock otherwise, no huge difference from
> existing logic.

Thanks!

If no one else objects I'm putting this in net-next.

Seems a little late for 5.8.
