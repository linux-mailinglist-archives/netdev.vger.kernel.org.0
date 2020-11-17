Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA002B6BE1
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgKQRg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:36:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729446AbgKQRg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:36:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605634587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttfvIb6ojFXvnD7jK5/JUSS/M1skJOwi75jp84lLKuo=;
        b=Pbw5I2kszJpjIblvjk4CV9QeSrVHQf6fw6P9RcXTQ09CaMFR7HryMSHqMKfGliKxOZ9xLn
        GZRkNCEmJUmWAElVZHNK8GWxdYhS6yV/MckUivUrtqLiHl0VSjWrTxUDtrOqznA17VaKyU
        1e3CdQ4XzxI5Gh5nyLXGp06/KcRw1gE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-eNcysYIoOmOK6P2OyOHoDw-1; Tue, 17 Nov 2020 12:36:23 -0500
X-MC-Unique: eNcysYIoOmOK6P2OyOHoDw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EE0D1084D61;
        Tue, 17 Nov 2020 17:36:21 +0000 (UTC)
Received: from ovpn-112-19.ams2.redhat.com (ovpn-112-19.ams2.redhat.com [10.36.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4BF160C04;
        Tue, 17 Nov 2020 17:36:19 +0000 (UTC)
Message-ID: <ad72a4d612d95e0d5c0b6923926e43239c506171.camel@redhat.com>
Subject: Re: [PATCH net-next] net: add annotation for sock_{lock,unlock}_fast
From:   Paolo Abeni <pabeni@redhat.com>
To:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-sparse@vger.kernel.org
Date:   Tue, 17 Nov 2020 18:36:18 +0100
In-Reply-To: <20201117165830.e44pu3nd5vx3jzmz@ltop.local>
References: <95cf587fe96127884e555f695fe519d50e63cc17.1605522868.git.pabeni@redhat.com>
         <20201116222750.nmfyxnj6jvd3rww4@ltop.local>
         <a41e88a82b4d7433dded23e9fbd0465ad8529e36.camel@redhat.com>
         <20201117165830.e44pu3nd5vx3jzmz@ltop.local>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2020-11-17 at 17:58 +0100, Luc Van Oostenryck wrote:
> On Tue, Nov 17, 2020 at 09:38:45AM +0100, Paolo Abeni wrote:
> > Hello,
> > 
> > Thank you for the feedback!
> > 
> > On Mon, 2020-11-16 at 23:27 +0100, Luc Van Oostenryck wrote:
> > > > @@ -1606,10 +1607,12 @@ bool lock_sock_fast(struct sock *sk);
> > > >   */
> > > >  static inline void unlock_sock_fast(struct sock *sk, bool slow)
> > > >  {
> > > > -	if (slow)
> > > > +	if (slow) {
> > > >  		release_sock(sk);
> > > > -	else
> > > > +		__release(&sk->sk_lock.slock);
> > > 
> > > The correct solution would be to annotate the declaration of
> > > release_sock() with '__releases(&sk->sk_lock.slock)'.
> > 
> > If I add such annotation to release_sock(), I'll get several sparse
> > warnings for context imbalance (on each lock_sock()/release_sock()
> > pair), unless I also add an '__acquires()' annotation to lock_sock(). 
> > 
> > The above does not look correct to me ?!? When release_sock() completes
> > the socket spin lock is not held.
> 
> Yes, that's fine, but I suppose it somehow releases the mutex that
> is taken in lock_sock_fast() when returning true, right?

Well, it has mutex semantics, but does not really acquire any mutex.

> > The annotation added above is
> > somewhat an artifact to let unlock_sock_fast() matches lock_sock_fast()
> > from sparse perspective. I intentionally avoided changing
> > the release_sock() annotation to avoid introducing more artifacts.
> > 
> > The proposed schema is not 100% accurate, as it will also allow e.g. a
> > really-not-fitting bh_lock_sock()/unlock_sock_fast() pair, but I could
> > not come-up with anything better.
> > 
> > Can we go with the schema I proposed?
> 
> Well, I suppose it's a first step.
> But can you then add a '__releases(...)' to unlock_sock_fast()?
> It's not needed by sparse because it's an inline function and sparse
> can then deduce it but it will help to see the pairing with
> lock_sock_fast() is OK.

Ok, I'll send a v2 with such annotation.

Thanks!

Paolo

