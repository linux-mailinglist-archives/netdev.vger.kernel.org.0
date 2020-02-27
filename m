Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29773171FA3
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 15:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732734AbgB0Ogh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 09:36:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21336 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732563AbgB0Ogh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 09:36:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582814190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9tIesucwMqH+2V5E2X7KW3mciip11JU2RizdKZJEE5I=;
        b=SxKRJku29AQDMff4NJiHi5OgnjD+S0r6NYzQ9CM+W46jPCKllPZSzDM9r0ARsYx4hAwGPN
        np1G3ScrnaC3B1T0NPWaVxKvxXA/S9k0Va309L3PzlEWbSMK+dmxCBpmy5OCi3AWnqDeyd
        sJzhUbhx2XsAB1N7AL26/mAmICdx8BY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250--7nvov-LOUG1TJypGDKdqw-1; Thu, 27 Feb 2020 09:36:26 -0500
X-MC-Unique: -7nvov-LOUG1TJypGDKdqw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DD671005512;
        Thu, 27 Feb 2020 14:36:22 +0000 (UTC)
Received: from ovpn-117-88.ams2.redhat.com (ovpn-117-88.ams2.redhat.com [10.36.117.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE22D19E9C;
        Thu, 27 Feb 2020 14:36:20 +0000 (UTC)
Message-ID: <240ebdbd3f8df2712e542db18d8137f928a1f08d.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] net: datagram: drop 'destructor' argument
 from several helpers
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kirill Tkhai <ktkhai@virtuozzo.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 27 Feb 2020 15:36:19 +0100
In-Reply-To: <8ccc7d2f-dfa9-a67d-1c0d-d012efa7d81d@virtuozzo.com>
References: <cover.1582802470.git.pabeni@redhat.com>
         <42639d3f3b1da6959ed42c683780c48a8fe08f4e.1582802470.git.pabeni@redhat.com>
         <8ccc7d2f-dfa9-a67d-1c0d-d012efa7d81d@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-02-27 at 15:31 +0300, Kirill Tkhai wrote:
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> > index 145a3965341e..194e7b93e404 100644
> > --- a/net/unix/af_unix.c
> > +++ b/net/unix/af_unix.c
> > @@ -2102,9 +2102,11 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> >  
> >  		skip = sk_peek_offset(sk, flags);
> >  		skb = __skb_try_recv_datagram(sk, &sk->sk_receive_queue, flags,
> > -					      scm_stat_del, &skip, &err, &last);
> > -		if (skb)
> > +					      &skip, &err, &last);
> > +		if (skb) {
> > +			scm_stat_del(sk, skb);
> 
> Shouldn't we care about MSG_PEEK here?

Thank you for checking this! You are right, I'll fix in the next
iteration.

Cheers,

Paolo

