Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C662C6D60
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 23:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbgK0Wug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 17:50:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732165AbgK0WsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 17:48:13 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C797422228;
        Fri, 27 Nov 2020 22:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606517293;
        bh=Sg8zTtTClTAmUNuKgtvwctR4UUmlq6NbtJe7/oHzbBI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sXb1CPRkMHDdA6z0C/nY4GryLNTR3T2KNUTBUYb/OlM0lWXe1yjH+UKQBN8R6OuBn
         MBeZOfjv9mB8VKXSoCO9/OhLuxJY8nYeJdHhWdpyo4OH/ObdQq714fC4dKjYBOEp7m
         ZpQHpLRnWe6QwaD09FD8ACqS4JjraOG4xZWT/1qU=
Date:   Fri, 27 Nov 2020 14:48:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net/af_unix: don't create a path for a binded socket
Message-ID: <20201127144811.4b68f8be@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAOJe8K1EVPapfRrtzK1hD4_St9vqFT1aad4JvE1Ch6X-rD6=iA@mail.gmail.com>
References: <20201124122421.9859-1-kda@linux-powerpc.org>
        <20201125152742.05800094@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAOJe8K1EVPapfRrtzK1hD4_St9vqFT1aad4JvE1Ch6X-rD6=iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 17:22:08 +0300 Denis Kirjanov wrote:
> On 11/26/20, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 24 Nov 2020 15:24:21 +0300 Denis Kirjanov wrote:  
> >> in the case of the socket which is bound to an adress
> >> there is no sense to create a path in the next attempts  
> >  
> >> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> >> index 41c3303c3357..fd76a8fe3907 100644
> >> --- a/net/unix/af_unix.c
> >> +++ b/net/unix/af_unix.c
> >> @@ -1021,7 +1021,7 @@ static int unix_bind(struct socket *sock, struct
> >> sockaddr *uaddr, int addr_len)
> >>
> >>  	err = -EINVAL;
> >>  	if (addr_len < offsetofend(struct sockaddr_un, sun_family) ||
> >> -	    sunaddr->sun_family != AF_UNIX)
> >> +	    sunaddr->sun_family != AF_UNIX || u->addr)
> >>  		goto out;
> >>
> >>  	if (addr_len == sizeof(short)) {
> >> @@ -1049,10 +1049,6 @@ static int unix_bind(struct socket *sock, struct
> >> sockaddr *uaddr, int addr_len)
> >>  	if (err)
> >>  		goto out_put;
> >>
> >> -	err = -EINVAL;
> >> -	if (u->addr)
> >> -		goto out_up;
> >> -
> >>  	err = -ENOMEM;
> >>  	addr = kmalloc(sizeof(*addr)+addr_len, GFP_KERNEL);
> >>  	if (!addr)  
> >
> > Well, after your change the check on u->addr is no longer protected by
> > u->bindlock. Is that okay?  
> 
> Since we're just checking the assigned address and it's an atomic
> operation I think it's okay.

The access to the variable may be atomic, but what protects two
concurrent binds() from progressing past the check and binding to
different paths?

I don't know this code at all, but looks to me like the pattern is
basically:

	lock()
	if (obj->thing)
		goto err; /* already bound to a thing */

	thing = alloc()
	setup_thing(thing);

	obj->thing = thing;
err:
	unlock()

> A process performing binding is still protected.

Isn't checking "did someone already bind" not part of the process of
binding?
