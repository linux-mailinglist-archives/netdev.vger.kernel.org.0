Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927A53346BE
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 19:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhCJS34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 13:29:56 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:50485 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232327AbhCJS3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 13:29:38 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 12AITZlW020406;
        Wed, 10 Mar 2021 19:29:35 +0100
Date:   Wed, 10 Mar 2021 19:29:35 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Henneberg - Systemdesign <lists@henneberg-systemdesign.com>
Cc:     netdev@vger.kernel.org
Subject: Re: TIOCOUTQ implementation for sockets vs. tty
Message-ID: <20210310182935.GC17851@1wt.eu>
References: <87ft12ri0t.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ft12ri0t.fsf@henneberg-systemdesign.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Mar 10, 2021 at 07:16:34PM +0100, Henneberg - Systemdesign wrote:
> Hi,
> 
> I have a question regarding the implementation of ioctl TIOCOUTQ for
> various sockets compared to the tty implementation.
> 
> For several sockets, e. g. AF_BLUETOOTH it is done like this
> 
> af_bluetooth.c:
> case TIOCOUTQ:
> 	if (sk->sk_state == BT_LISTEN)
> 		return -EINVAL;
> 
> 	amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
> 	if (amount < 0)
> 		amount = 0;
> 	err = put_user(amount, (int __user *)arg);
> 	break;
> 
> so the ioctl returns the available space in the send queue if I
> understand the code correctly (this is also what I observed from tests).
> 
> The tty does this:
> 
> n_tty.c:
> case TIOCOUTQ:
> 	return put_user(tty_chars_in_buffer(tty), (int __user *) arg);
> 
> so it returns the used space in the send queue. This is also what I
> would expect from the manpage description.
> 
> Is this mismatch intentional?

At least both man pages (tty_ioctl and tcp(7)) mention that TIOCOUTQ
should return the number of byte in queue.

What I suspect for sockets is that sk_sndbuf grows with allocations
and that sk_wmem_alloc_get() in fact returns the number of unused
allocations thus the difference would be the amount queued. But I
could be wrong and I would tend to read the code the same way as you
did.

Willy
