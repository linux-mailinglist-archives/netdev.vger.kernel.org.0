Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8F2342875
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhCSWIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:08:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231180AbhCSWIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:08:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616191692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tpb6lNNIMtiqOobkkz7pgbvgA0UyB0HXjyiq4zy5RJI=;
        b=JuKJDelwV7x3D+Nky7u9xJGu3M9n9PYXQuoZWnf+K40XI5IZgDJY0eUpF2Hu4ILv6Otyd6
        E18tw+63gY0AMlSt/hYirbK+R6+iAd5FdGXKdb7KSO/3dK7AU2x7t9ika5Gq33eBoSeIbY
        RLesJF0PN9zGAa69o0v7EEoUb31Y5g8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-1i-LpwZ-PzyJX1vF6tfYUA-1; Fri, 19 Mar 2021 18:08:09 -0400
X-MC-Unique: 1i-LpwZ-PzyJX1vF6tfYUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3346A9113F;
        Fri, 19 Mar 2021 22:08:07 +0000 (UTC)
Received: from pick.fieldses.org (ovpn-115-237.rdu2.redhat.com [10.10.115.237])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C17745D72F;
        Fri, 19 Mar 2021 22:08:06 +0000 (UTC)
Received: by pick.fieldses.org (Postfix, from userid 2815)
        id 4EBF4121007; Fri, 19 Mar 2021 18:08:05 -0400 (EDT)
Date:   Fri, 19 Mar 2021 18:08:05 -0400
From:   "J. Bruce Fields" <bfields@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Chris Down <chris@chrisdown.name>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] SUNRPC: Output oversized frag reclen as ASCII if
 printable
Message-ID: <YFUgxdSXu34SvFsd@pick.fieldses.org>
References: <YFS7L4FIQBDtIY9d@chrisdown.name>
 <3844BF67-8820-4D6C-95BA-8BA0B0956BD0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3844BF67-8820-4D6C-95BA-8BA0B0956BD0@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 02:58:14PM +0000, Chuck Lever III wrote:
> Hi Chris-
> 
> > On Mar 19, 2021, at 10:54 AM, Chris Down <chris@chrisdown.name> wrote:
> > 
> > The reclen is taken directly from the first four bytes of the message
> > with the highest bit stripped, which makes it ripe for protocol mixups.
> > For example, if someone tries to send a HTTP GET request to us, we'll
> > interpret it as a 1195725856-sized fragment (ie. (u32)'GET '), and print
> > a ratelimited KERN_NOTICE with that number verbatim.
> > 
> > This can be confusing for downstream users, who don't know what messages
> > like "fragment too large: 1195725856" actually mean, or that they
> > indicate some misconfigured infrastructure elsewhere.
> 
> One wonders whether that error message is actually useful at all.
> We could, for example, turn this into a tracepoint, or just get
> rid of it.

Just going on vague memories here, but: I think we've seen both spurious
and real bugs reported based on this.

I'm inclined to go with a dprintk or tracepoint but not removing it
entirely.

--b.

> 
> 
> > To allow users to more easily understand and debug these cases, add the
> > number interpreted as ASCII if all characters are printable:
> > 
> >    RPC: fragment too large: 1195725856 (ASCII "GET ")
> > 
> > If demand grows elsewhere, a new printk format that takes a number and
> > outputs it in various formats is also a possible solution. For now, it
> > seems reasonable to put this here since this particular code path is the
> > one that has repeatedly come up in production.
> > 
> > Signed-off-by: Chris Down <chris@chrisdown.name>
> > Cc: Chuck Lever <chuck.lever@oracle.com>
> > Cc: J. Bruce Fields <bfields@redhat.com>
> > Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > ---
> > net/sunrpc/svcsock.c | 39 +++++++++++++++++++++++++++++++++++++--
> > 1 file changed, 37 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> > index 2e2f007dfc9f..046b1d104340 100644
> > --- a/net/sunrpc/svcsock.c
> > +++ b/net/sunrpc/svcsock.c
> > @@ -46,6 +46,7 @@
> > #include <linux/uaccess.h>
> > #include <linux/highmem.h>
> > #include <asm/ioctls.h>
> > +#include <linux/ctype.h>
> > 
> > #include <linux/sunrpc/types.h>
> > #include <linux/sunrpc/clnt.h>
> > @@ -863,6 +864,34 @@ static void svc_tcp_clear_pages(struct svc_sock *svsk)
> > 	svsk->sk_datalen = 0;
> > }
> > 
> > +/* The reclen is taken directly from the first four bytes of the message with
> > + * the highest bit stripped, which makes it ripe for protocol mixups. For
> > + * example, if someone tries to send a HTTP GET request to us, we'll interpret
> > + * it as a 1195725856-sized fragment (ie. (u32)'GET '), and print a ratelimited
> > + * KERN_NOTICE with that number verbatim.
> > + *
> > + * To allow users to more easily understand and debug these cases, this
> > + * function decodes the purported length as ASCII, and returns it if all
> > + * characters were printable. Otherwise, we return NULL.
> > + *
> > + * WARNING: Since we reuse the u32 directly, the return value is not null
> > + * terminated, and must be printed using %.*s with
> > + * sizeof(svc_sock_reclen(svsk)).
> > + */
> > +static char *svc_sock_reclen_ascii(struct svc_sock *svsk)
> > +{
> > +	u32 len_be = cpu_to_be32(svc_sock_reclen(svsk));
> > +	char *len_be_ascii = (char *)&len_be;
> > +	size_t i;
> > +
> > +	for (i = 0; i < sizeof(len_be); i++) {
> > +		if (!isprint(len_be_ascii[i]))
> > +			return NULL;
> > +	}
> > +
> > +	return len_be_ascii;
> > +}
> > +
> > /*
> >  * Receive fragment record header into sk_marker.
> >  */
> > @@ -870,6 +899,7 @@ static ssize_t svc_tcp_read_marker(struct svc_sock *svsk,
> > 				   struct svc_rqst *rqstp)
> > {
> > 	ssize_t want, len;
> > +	char *reclen_ascii;
> > 
> > 	/* If we haven't gotten the record length yet,
> > 	 * get the next four bytes.
> > @@ -898,9 +928,14 @@ static ssize_t svc_tcp_read_marker(struct svc_sock *svsk,
> > 	return svc_sock_reclen(svsk);
> > 
> > err_too_large:
> > -	net_notice_ratelimited("svc: %s %s RPC fragment too large: %d\n",
> > +	reclen_ascii = svc_sock_reclen_ascii(svsk);
> > +	net_notice_ratelimited("svc: %s %s RPC fragment too large: %d%s%.*s%s\n",
> > 			       __func__, svsk->sk_xprt.xpt_server->sv_name,
> > -			       svc_sock_reclen(svsk));
> > +			       svc_sock_reclen(svsk),
> > +			       reclen_ascii ? " (ASCII \"" : "",
> > +			       (int)sizeof(u32),
> > +			       reclen_ascii ?: "",
> > +			       reclen_ascii ? "\")" : "");
> > 	set_bit(XPT_CLOSE, &svsk->sk_xprt.xpt_flags);
> > err_short:
> > 	return -EAGAIN;
> > -- 
> > 2.30.2
> > 
> 
> --
> Chuck Lever
> 
> 
> 

