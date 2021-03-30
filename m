Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E7C34EBFC
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhC3PSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:18:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232001AbhC3PS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617117506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pr4bChSWJM7AYql5fyoyzsCTRbjbB2bLsmB/N87criU=;
        b=JaF/nIsC3V4xEF4b5Ekb2ht7ByggwGpvN6Q2EJDAF+vrZPcQyr2QfsXwrWJ8a7J7Rtk/5t
        RyrpoCpy+nHslMsWZNZxM2J1SeO0v5/cr+dNX021ldWILEhUfBmMyrcNev24Y4woAqEn9B
        tledlh/ARTlih2nrYElaFXyD2MJXpNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-NabwYdECNXuLyZor4lHL-w-1; Tue, 30 Mar 2021 11:18:24 -0400
X-MC-Unique: NabwYdECNXuLyZor4lHL-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A6E8C7449;
        Tue, 30 Mar 2021 15:18:23 +0000 (UTC)
Received: from ovpn-115-56.ams2.redhat.com (ovpn-115-56.ams2.redhat.com [10.36.115.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B52360CE7;
        Tue, 30 Mar 2021 15:18:22 +0000 (UTC)
Message-ID: <99736955c48b19366a2a06f43ea4a0d507454dbc.camel@redhat.com>
Subject: Re: [PATCH net] net: let skb_orphan_partial wake-up waiters.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>
Date:   Tue, 30 Mar 2021 17:18:21 +0200
In-Reply-To: <CANn89iJkXuhMdU0==ZV3s8z75p1hrhjY3reR_MWUh1i-gJVeCg@mail.gmail.com>
References: <880d627b79b24c0f92a47203193ed11f48c3031e.1617113947.git.pabeni@redhat.com>
         <CANn89iJQRf5GVhiUp3PA5y9p3_Nqrm8J2CcfxA=0yd9_aB=17w@mail.gmail.com>
         <CANn89iJkXuhMdU0==ZV3s8z75p1hrhjY3reR_MWUh1i-gJVeCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-03-30 at 16:40 +0200, Eric Dumazet wrote:
> On Tue, Mar 30, 2021 at 4:39 PM Eric Dumazet <edumazet@google.com> wrote:
> > On Tue, Mar 30, 2021 at 4:25 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > Currently the mentioned helper can end-up freeing the socket wmem
> > > without waking-up any processes waiting for more write memory.
> > > 
> > > If the partially orphaned skb is attached to an UDP (or raw) socket,
> > > the lack of wake-up can hang the user-space.
> > > 
> > > Address the issue invoking the write_space callback after
> > > releasing the memory, if the old skb destructor requires that.
> > > 
> > > Fixes: f6ba8d33cfbb ("netem: fix skb_orphan_partial()")
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >  net/core/sock.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > index 0ed98f20448a2..7a38332d748e7 100644
> > > --- a/net/core/sock.c
> > > +++ b/net/core/sock.c
> > > @@ -2137,6 +2137,8 @@ void skb_orphan_partial(struct sk_buff *skb)
> > > 
> > >                 if (refcount_inc_not_zero(&sk->sk_refcnt)) {
> > >                         WARN_ON(refcount_sub_and_test(skb->truesize, &sk->sk_wmem_alloc));
> > > +                       if (skb->destructor == sock_wfree)
> > > +                               sk->sk_write_space(sk);
> > 
> > Interesting.
> > 
> > Why TCP is not a problem here ?

AFAICS, tcp_wfree() does not call sk->sk_write_space(). Processes
waiting for wmem are woken by ack processing.

> > I would rather replace WARN_ON(refcount_sub_and_test(skb->truesize,
> > &sk->sk_wmem_alloc)) by :
> >                         skb_orphan(skb);
> 
> And of course re-add
>                         skb->sk = sk;

Double checking to be sure. The patched slice of skb_orphan_partial()
will then look like:

	if (can_skb_orphan_partial(skb)) {
		struct sock *sk = skb->sk;
		
		if (refcount_inc_not_zero(&sk->sk_refcnt)) {
			skb_orphan(skb);
			skb->sk = sk;
			skb->destructor = sock_efree;
		}
	} // ...

Am I correct?

Thanks!

Paolo

