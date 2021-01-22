Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD533010F8
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbhAVXYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:24:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbhAVXYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:24:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C2423B52;
        Fri, 22 Jan 2021 23:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611357837;
        bh=3Ghs2qeMou3MnhukWcbgBBA10rRewXqVbX4hW12V3xk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fjeMbSQ1eqTX6j201kdy2HqL5TLLJklk5gp+IokuxCQMI57wsfFvza5QXH5CmCONo
         Gs1cbChcWJmpwxYXRYp0xw373/pp2twJgqx/9fNso6U4ub2dYo1Hb91RCIy6NRUy4H
         qSZqJNP4IsDXTdzvsXFj7j0/L2mg/nowA9LU7Vc7gJxEEobRem8cJbKP179mt/bd0L
         zwVeNA9Zq9PfFAghCumGLZ5CrdLzw59d+5B4LCqXxDEJhP1Rj6QyuQgY9WKB7dTwfW
         5l0CgTmoHklsl/J3R3H3KSYkZrFibgid4xmRrj3nMCuEXaxrjtEGrgNzv98+yI/cJK
         a0X0r149xQLZA==
Date:   Fri, 22 Jan 2021 15:23:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2 net-next 5/5] mptcp: implement delegated actions
Message-ID: <20210122152355.761ff148@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e093e7615490baad413ef6ba49154e3e4e98399a.camel@redhat.com>
References: <cover.1611153172.git.pabeni@redhat.com>
        <fbae7709d333eb2afcc79e69a8db3d952292564f.1611153172.git.pabeni@redhat.com>
        <20210121173437.1b945b01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e093e7615490baad413ef6ba49154e3e4e98399a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 09:25:07 +0100 Paolo Abeni wrote:
> On Thu, 2021-01-21 at 17:34 -0800, Jakub Kicinski wrote:
> > On Wed, 20 Jan 2021 15:39:14 +0100 Paolo Abeni wrote:  
> > > On MPTCP-level ack reception, the packet scheduler
> > > may select a subflow other then the current one.
> > > 
> > > Prior to this commit we rely on the workqueue to trigger
> > > action on such subflow.
> > > 
> > > This changeset introduces an infrastructure that allows
> > > any MPTCP subflow to schedule actions (MPTCP xmit) on
> > > others subflows without resorting to (multiple) process
> > > reschedule.  
> > 
> > If your work doesn't reschedule there should not be multiple 
> > rescheds, no?  
> 
> Thank you for looking into this.
> 
> With the workqueue it would be:
> 
> <running process> -> BH -> (process scheduler) -> MPTCP workqueue ->
> (process scheduler) -> <running process>
> 
> With this infra is:
> 
> <running process> -> BH -> BH -> <running process>

You assume your process is running when you got the Rx IRQ but also
is RPS enabled? For MPTCP there is no way to do reuseport to match Rx
CPU to processing thread, right?

> > > A dummy NAPI instance is used instead. When MPTCP needs to
> > > trigger action an a different subflow, it enqueues the target
> > > subflow on the NAPI backlog and schedule such instance as needed.
> > > 
> > > The dummy NAPI poll method walks the sockets backlog and tries
> > > to acquire the (BH) socket lock on each of them. If the socket
> > > is owned by the user space, the action will be completed by
> > > the sock release cb, otherwise push is started.
> > > 
> > > This change leverages the delegated action infrastructure
> > > to avoid invoking the MPTCP worker to spool the pending data,
> > > when the packet scheduler picks a subflow other then the one
> > > currently processing the incoming MPTCP-level ack.
> > > 
> > > Additionally we further refine the subflow selection
> > > invoking the packet scheduler for each chunk of data
> > > even inside __mptcp_subflow_push_pending().  
> > 
> > Is there much precedence for this sort of hijacking of NAPI 
> > for protocol work?   
> 
> AFAICS, xfrm is using a similar trick in the receive path.
> 
> Note that we uses TX-only NAPIs, so this does not pollute the napi hash
> table.

Ack, I think what you have should work with busy polling and threaded
IRQs as well. Just another piece of the puzzle to keep in one's head
when thinking about NAPI processing :)

> > Do you need it because of locking?  
> 
> This infrastructure is used to avoid the workqueue usage in the MPTCP
> receive path (to push pending data). With many mptcp connections
> established that would be very bad for tput and latency. This
> infrastructure is not strictly needed from a functinal PoV, but I was
> unable to find any other way to avoid the workqueue usage.

But it is due to locking or is it not? Because you're running the
callback in the same context, so otherwise why not just call the
function directly? Can't be batching, it's after GRO so we won't 
batch much more.

> Please let me know if the above is clear enough!

Sure thing, it just looks like interesting work. I'll apply end 
of the day if nobody has any comments.
