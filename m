Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A6A5CFF9
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 15:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfGBNDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 09:03:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37040 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfGBNDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 09:03:53 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3404FC05FBD7;
        Tue,  2 Jul 2019 13:03:53 +0000 (UTC)
Received: from ovpn-116-72.ams2.redhat.com (ovpn-116-72.ams2.redhat.com [10.36.116.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D6F378380;
        Tue,  2 Jul 2019 13:03:50 +0000 (UTC)
Message-ID: <a2806dab7e472b5316da87318f1b8e48ff68cd4b.camel@redhat.com>
Subject: Re: [PATCH net-next 5/5] ipv4: use indirect call wrappers for
 {tcp,udp}_{recv,send}msg()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Tue, 02 Jul 2019 15:03:50 +0200
In-Reply-To: <CA+FuTSfHF_LRuZeW3ZiX5a662=fdAu9zmmpa67WpOkZqkt8Srw@mail.gmail.com>
References: <cover.1561999976.git.pabeni@redhat.com>
         <8c32b92eee12bf0725ead331e7607d8c4012d51f.1561999976.git.pabeni@redhat.com>
         <CA+FuTSfHF_LRuZeW3ZiX5a662=fdAu9zmmpa67WpOkZqkt8Srw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 02 Jul 2019 13:03:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-07-01 at 15:07 -0400, Willem de Bruijn wrote:
> On Mon, Jul 1, 2019 at 1:10 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > This avoids an indirect call per syscall for common ipv4 transports
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  net/ipv4/af_inet.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index 8421e2f5bbb3..9a2f17d0c5f5 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -797,6 +797,8 @@ int inet_send_prepare(struct sock *sk)
> >  }
> >  EXPORT_SYMBOL_GPL(inet_send_prepare);
> > 
> > +INDIRECT_CALLABLE_DECLARE(int udp_sendmsg(struct sock *, struct msghdr *,
> > +                                         size_t));
> 
> Small nit: this is already defined in include/net/udp.h, which is
> included. So like tcp_sendmsg, probably no need to declare.

Thank you for the review!

You are right, that declaration can be dropped.
> 
> If defining inet6_sendmsg and inet6_recvmsg in include/net/ipv6.h,
> perhaps do the same for the other missing functions, instead of these
> indirect declarations at the callsite?

Uhm... since inet6_{send,recv}msg exists only for retpoline sake and
are not exported, I think is probably better move their declaration to
socket.c via INDIRECT_CALLABLE_DECLARE(), to that ICWs are all self-
contained.

Unless there are objections about spamming, I can repost the series
with the above changes.

Cheers,

Paolo

