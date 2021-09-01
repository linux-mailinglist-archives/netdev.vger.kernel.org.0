Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA1D3FE60C
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344953AbhIAXVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 19:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhIAXVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 19:21:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46E6B60F4B;
        Wed,  1 Sep 2021 23:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630538412;
        bh=jRDi0tXYcFMrWm0Yh9b1bdEmEczF5T2ak4Op6iKq0ao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NxvRQDGcBoFWPfpKZbJO6U1ejv3xRHNzmu5RnOJMjMI+RY/i4ERucpAHr2NDMsoSs
         U4Nq1t6w0D30e+9gQWxf0Jh5vRvwb2uGkw9jzYGXXcMKxbmUWAAiC2HiW4jKug/bC/
         hF0i7UNL9NLkknlPXnLY+bEhcCGpFiuAZgOSseAuqMZEXltqh3HppTjDDJZw4ySTxJ
         W7cedSq+MzWcNcfutQQoNrYsVWEWxhl9hxZTuPEi0JtwaPDhazHh3M+gj4EZGgN1hE
         Meh6s4fkcOpZjzrSplkRerQhuPjFdQJxf001ikiUIkdTswfvN5qXpGreGt3XPYSz2u
         mjWudzNK+JWMA==
Date:   Wed, 1 Sep 2021 16:20:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "David S. Miller" <davem@davemloft.net>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] net: don't unconditionally copy_from_user a struct
 ifreq for socket ioctls
Message-ID: <20210901162011.3ce5f012@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMn1gO5OmHg_10s698tNqf4X-hJ_gn17D8afyRhbW1nKpvLzWQ@mail.gmail.com>
References: <20210826194601.3509717-1-pcc@google.com>
        <20210831093006.6db30672@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bf0f47974d7141358d810d512d4b9a00@AcuMS.aculab.com>
        <20210901070356.750ea996@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMn1gO5OmHg_10s698tNqf4X-hJ_gn17D8afyRhbW1nKpvLzWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Sep 2021 11:01:32 -0700 Peter Collingbourne wrote:
> > > To stop the copy_from_user() faulting when the user buffer
> > > isn't long enough.
> > > In particular for iasatty() on arm with tagged pointers.  
> >
> > Let me rephrase. is_socket_ioctl_cmd() is always true here. There were
> > only two callers, both check cmd is of specific, "sockety" type.  
> 
> I see, it looks like we don't need the check on the compat path then.
> 
> I can send a followup to clean this up but given that I got a comment
> from another reviewer saying that we should try to make the native and
> compat paths as similar as possible, maybe it isn't too bad to leave
> things as is?

I have a weak preference to get rid of it, the code is a little
complex and extra dead code makes it harder to follow, but up to you.

IMO the "right place" for the check is:

static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
[...]
		default:
			/* --> here <-- */
			err = sock_do_ioctl(net, sock, cmd, arg);
			break;

Since that's the point where we take all the remaining cmd values and
call a function which assumes struct ifreq.

Compat code does not have a default statement.

But as I said no big deal, feel free to ignore.
