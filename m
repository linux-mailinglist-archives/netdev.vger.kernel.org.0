Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59E76B247D
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCIMsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCIMsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:48:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD43AE7754
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 04:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678366049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ehW2nevq00V5yC0+7FXoqhGhXSAe2U1rSyspc8Zvdg=;
        b=NZxY7sYQRZMxfvjJ1k0kDZz2c4Llu59idYMVV5GWOl8ZHQLTyNVp0+zehfBctZDDNd2oXs
        vCrckBbSCYbINjncA87bqU3pn45+rAtP4qfwTUUxxsqEkjyVB4ApV5tuFV8PQbQVZbU0Cd
        bMDvfNJQvy7xX6TvVAk4rdAIHcysIGg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-YUu1CB_tMBK4oNV_yx9d_g-1; Thu, 09 Mar 2023 07:47:28 -0500
X-MC-Unique: YUu1CB_tMBK4oNV_yx9d_g-1
Received: by mail-qv1-f72.google.com with SMTP id jh21-20020a0562141fd500b0053c23b938a0so1106136qvb.17
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 04:47:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678366047;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ehW2nevq00V5yC0+7FXoqhGhXSAe2U1rSyspc8Zvdg=;
        b=ZcHLfd5tvdV6VVtFdDjLpyK6VCw9bDP3372DG3YfLWwbv/mUPnudhBYVaxPwejlJUH
         PtnpclBei/5hoemmRe5IPJ4yX5iMojUeW5OHHq/zCZpsYh2JybEku9zkH2rF+SIV9NpE
         Ll6YMxUN2CLD7hU473j6chh+BFXJ9ao8VIPSCYWDAtuFnOCXv0/OdkifAw/FghK+tNqE
         dMzrmLSYpb0Azru2KumrDe2eRXdxu9sWzB0amcXNrMS/Dw4uOxu1azucl9kw+gkp7RtX
         JZslsrKzgDr6NGBRyOc3Po8MScvdx+PDtP5YKhXs/dXENCplUwzEQCGfulL6MseGiAw1
         x5LQ==
X-Gm-Message-State: AO0yUKWfbeP1n38PP8lkdHPWNJ0iMCuuHOdu9OH8Ki2vjm8tEII5cSyK
        ySL/6Fy1IfoHM2hdgG+TWFpvH7li6jEpjDUdD1QRQoxSCyF/z/hl/fr9CL8xGCJgkiA5WtfEOMO
        YfXHVZOyZmyWNrMfw1Jsg5Ir/
X-Received: by 2002:a05:622a:118a:b0:3bf:cc1b:9512 with SMTP id m10-20020a05622a118a00b003bfcc1b9512mr4614227qtk.1.1678366047573;
        Thu, 09 Mar 2023 04:47:27 -0800 (PST)
X-Google-Smtp-Source: AK7set+07iNYp4QytjfgvdXz6Ibrp+MLL2JCpqrWePXQSZuPccULPXLzvOuBUsaA/SXIruJvl7nHcg==
X-Received: by 2002:a05:622a:118a:b0:3bf:cc1b:9512 with SMTP id m10-20020a05622a118a00b003bfcc1b9512mr4614198qtk.1.1678366047241;
        Thu, 09 Mar 2023 04:47:27 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-28.dyn.eolo.it. [146.241.121.28])
        by smtp.gmail.com with ESMTPSA id 4-20020a370304000000b0073bb00eb0besm13431307qkd.22.2023.03.09.04.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 04:47:26 -0800 (PST)
Message-ID: <5de48abb24e033a5eb457007d0a5b6b391831fd4.camel@redhat.com>
Subject: Re: [PATCH v5] epoll: use refcount to reduce ep_mutex contention
From:   Paolo Abeni <pabeni@redhat.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     netdev@vger.kernel.org, Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org
Date:   Thu, 09 Mar 2023 13:47:23 +0100
In-Reply-To: <20230309111803.2z242amw4f5nwfwu@wittgenstein>
References: <323de732635cc3513c1837c6cbb98f012174f994.1678312201.git.pabeni@redhat.com>
         <20230309111803.2z242amw4f5nwfwu@wittgenstein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-03-09 at 12:18 +0100, Christian Brauner wrote:
> On Wed, Mar 08, 2023 at 10:51:31PM +0100, Paolo Abeni wrote:
> > We are observing huge contention on the epmutex during an http
> > connection/rate test:
> >=20
> >  83.17% 0.25%  nginx            [kernel.kallsyms]         [k] entry_SYS=
CALL_64_after_hwframe
> > [...]
> >            |--66.96%--__fput
> >                       |--60.04%--eventpoll_release_file
> >                                  |--58.41%--__mutex_lock.isra.6
> >                                            |--56.56%--osq_lock
> >=20
> > The application is multi-threaded, creates a new epoll entry for
> > each incoming connection, and does not delete it before the
> > connection shutdown - that is, before the connection's fd close().
> >=20
> > Many different threads compete frequently for the epmutex lock,
> > affecting the overall performance.
> >=20
> > To reduce the contention this patch introduces explicit reference count=
ing
> > for the eventpoll struct. Each registered event acquires a reference,
> > and references are released at ep_remove() time.
> >=20
> > The eventpoll struct is released by whoever - among EP file close() and
> > and the monitored file close() drops its last reference.
> >=20
> > Additionally, this introduces a new 'dying' flag to prevent races betwe=
en
> > the EP file close() and the monitored file close().
> > ep_eventpoll_release() marks, under f_lock spinlock, each epitem as dyi=
ng
> > before removing it, while EP file close() does not touch dying epitems.
> >=20
> > The above is needed as both close operations could run concurrently and
> > drop the EP reference acquired via the epitem entry. Without the above
> > flag, the monitored file close() could reach the EP struct via the epit=
em
> > list while the epitem is still listed and then try to put it after its
> > disposal.
> >=20
> > An alternative could be avoiding touching the references acquired via
> > the epitems at EP file close() time, but that could leave the EP struct
> > alive for potentially unlimited time after EP file close(), with nasty
> > side effects.
> >=20
> > With all the above in place, we can drop the epmutex usage at disposal =
time.
> >=20
> > Overall this produces a significant performance improvement in the
> > mentioned connection/rate scenario: the mutex operations disappear from
> > the topmost offenders in the perf report, and the measured connections/=
rate
> > grows by ~60%.
> >=20
> > To make the change more readable this additionally renames ep_free() to
> > ep_clear_and_put(), and moves the actual memory cleanup in a separate
> > ep_free() helper.
> >=20
> > Tested-by: Xiumei Mu <xmu@redhiat.com>
>=20
> Is that a typo "redhiat" in the mail?

Indeed yes! Thanks for noticing. Should I share a new revision to
address that?

[...]

> > @@ -700,6 +733,11 @@ static int ep_remove(struct eventpoll *ep, struct =
epitem *epi)
> > =20
> >  	/* Remove the current item from the list of epoll hooks */
> >  	spin_lock(&file->f_lock);
> > +	if (epi->dying && !force) {
> > +		spin_unlock(&file->f_lock);
> > +		return false;
> > +	}
>=20
> It's a bit unfortunate that we have to acquire the spinlock just to immed=
iately
> having to drop it. Slighly ugly but workable could be but that depends on=
 how
> likely we find it that we end up with !force and a dying fd...

The concurrent close() of both the EP file and the monitored file
should be a quite rare event, I *think* over-optimizing it should not
be worthy. Additionally, even with the spinlock, the proposed patch
should be considerably faster then the previous code even in that
specific scenario, as before we the epmutex conflicting with a much
larger scope.=20

The only doubt I have about the suggested code, should we add a
READ_ONCE() even on the later 'dying' check? My understanding is that
the compiler should be allowed to emit a single read instruction,
before the spinlock itself.

Cheers,

Paolo

