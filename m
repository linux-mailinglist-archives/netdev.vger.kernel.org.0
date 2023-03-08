Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61CD6B0223
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjCHI43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCHI4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:56:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D2C98853
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 00:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678265738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nSUxl7P5hQy+/YtrpvxvlD1qQxLj804ODoUh/9ZocfE=;
        b=gbyqIJdwkkfrAht1WIrPhs9d2q3IfNS29MHYZ1jQfLJaNPm7j82Rlvmtx+s3P5EhXmr0d5
        Gij5J2KZaVnATJxu4huz6oP+mBwZO7hSk4TthbhHdw7HoU7gowK1NRtqyusU7JU/01OuBf
        ttMI3tZSLnL0vcMRYpGjfvHTNOyVsjc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-Sm64YDTdMDiu0Ep2nhMo7Q-1; Wed, 08 Mar 2023 03:55:36 -0500
X-MC-Unique: Sm64YDTdMDiu0Ep2nhMo7Q-1
Received: by mail-qk1-f198.google.com with SMTP id ea22-20020a05620a489600b00742cec04043so9066886qkb.7
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 00:55:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678265736;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nSUxl7P5hQy+/YtrpvxvlD1qQxLj804ODoUh/9ZocfE=;
        b=zv3f1UJPsXPAuEXora6/FtcqTfa7Ssg81IjGDTQBPAZ0xJjOjcbd5R6vRcmrkMN6jc
         ZDXPROX75CD2YtIXKwk9lb9aJHiYvnWbCkw3UKORSC6c6YLTyWPkZ77hxnjSqUq0kInZ
         CgTn5L5BYoIHyA1750HbZQcFeuz+J+YjnU+cEz7xYrS600Cg351zypHNjIwJhc8/rh+l
         yEWz9ThLZ6ql3oDX5HDbDXc+XltT/V8UWjMln1LS6L/ThlCghiZD6hpUAFpyIiPadFTz
         HHTd/bSfiMI84zsYCoz59RndNEVAw3Fysb2EQBvFOb4ePPymglYd/hO/ke11oOzJEYgc
         mMyw==
X-Gm-Message-State: AO0yUKVqPD9uZrdMYqRfv9bST4s5LCRZVvOLhCTpFLan2oPmKdhvi1Ub
        v5RHUGWra+t74gwJxFLVwJTxG8g5THAqTQeN2W5tTaVDdnWbVH5MGjQtWuMumKFBmlrK+zDmPhA
        +TibbMAOGdkBW2aT7
X-Received: by 2002:a05:622a:11c2:b0:3bd:1c0f:74f3 with SMTP id n2-20020a05622a11c200b003bd1c0f74f3mr34312762qtk.2.1678265736303;
        Wed, 08 Mar 2023 00:55:36 -0800 (PST)
X-Google-Smtp-Source: AK7set/LqHuuLs+iFiwPadK3SrLCod1w1FhHVbxTYMTJFEjslFMf2nSsbvaQDDBDwAJn7wd7IT5/rQ==
X-Received: by 2002:a05:622a:11c2:b0:3bd:1c0f:74f3 with SMTP id n2-20020a05622a11c200b003bd1c0f74f3mr34312738qtk.2.1678265735941;
        Wed, 08 Mar 2023 00:55:35 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-28.dyn.eolo.it. [146.241.121.28])
        by smtp.gmail.com with ESMTPSA id d1-20020ac85ac1000000b003b9e1d3a502sm11377180qtd.54.2023.03.08.00.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 00:55:35 -0800 (PST)
Message-ID: <f049d74b59323ed2ad16a0b52de86f157ae353ce.camel@redhat.com>
Subject: Re: [PATCH v4 RESEND] epoll: use refcount to reduce ep_mutex
 contention
From:   Paolo Abeni <pabeni@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org
Date:   Wed, 08 Mar 2023 09:55:31 +0100
In-Reply-To: <20230307133057.1904d8ffab2980f8e23ee3cc@linux-foundation.org>
References: <e8228f0048977456466bc33b42600e929fedd319.1678213651.git.pabeni@redhat.com>
         <20230307133057.1904d8ffab2980f8e23ee3cc@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-07 at 13:30 -0800, Andrew Morton wrote:
> On Tue,  7 Mar 2023 19:46:37 +0100 Paolo Abeni <pabeni@redhat.com> wrote:
>=20
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
> > Additionally, this introduces a new 'dying' flag to prevent races betwe=
en
> > the EP file close() and the monitored file close().
> > ep_eventpoll_release() marks, under f_lock spinlock, each epitem as bef=
ore
>=20
> "as dying"?
>=20
> > removing it, while EP file close() does not touch dying epitems.
>=20
> The need for this dying flag is somewhat unclear to me.  I mean, if we
> have refcounting done correctly, why the need for this flag?  Some
> additional description of the dynamics would be helpful.
>=20
> Methinks this flag is here to cope with the delayed freeing via
> hlist_del_rcu(), but that's a guess?

First thing first, thanks for the feedback!

Both ep_clear_and_put() and eventpoll_release_file() can release the
eventpoll struct. The second must acquire the file->f_lock spinlock to
reach/access such struct pointer. Callers of __ep_remove need to
acquire first the ep->mtx, so eventpoll_release_file() must release the
spinlock after fetching the pointer and before acquiring the mutex.

Meanwhile, without the 'dying' flag, ep_clear_and_put() could kick-in,
eventually on a different CPU, drop all the ep references and free the
struct.=C2=A0
An alternative to the 'dying' flag would be removing the following loop
from ep_clear_and_put():

	while ((rbp =3D rb_first_cached(&ep->rbr)) !=3D NULL) {
                epi =3D rb_entry(rbp, struct epitem, rbn);
                ep_remove_safe(ep, epi);
                cond_resched();
        }

So that ep_clear_and_put() would not release all the ep references
anymore. That option has the downside of keeping the ep struct alive
for an unlimited time after ep_clear_and_put(). A previous revision of
this patch implemented a similar behavior, but Eric Biggers noted it
could hurt some users:

https://lore.kernel.org/linux-fsdevel/Y3%2F4FW4mqY3fWRfU@sol.localdomain/

Please let me know if the above is clear enough.

> > The eventpoll struct is released by whoever - among EP file close() and
> > and the monitored file close() drops its last reference.
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
> > ...
> >=20
> > --- a/fs/eventpoll.c
> > +++ b/fs/eventpoll.c
> >=20
> > ...
> >=20
> > +	free_uid(ep->user);
> > +	wakeup_source_unregister(ep->ws);
> > +	kfree(ep);
> > +}
> > +
> >  /*
> >   * Removes a "struct epitem" from the eventpoll RB tree and deallocate=
s
> >   * all the associated resources. Must be called with "mtx" held.
> > + * If the dying flag is set, do the removal only if force is true.
>=20
> This comment describes "what" the code does, which is obvious from the
> code anwyay.  It's better if comments describe "why" the code does what
> it does.

What about appending the following?

"""
This prevents ep_clear_and_put() from dropping all the ep references
while running concurrently with eventpoll_release_file().
"""

(I'll keep the 'what' part to hopefully make the 'why' more clear)

> > + * Returns true if the eventpoll can be disposed.
> >   */
> > -static int ep_remove(struct eventpoll *ep, struct epitem *epi)
> > +static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool=
 force)
> >  {
> >  	struct file *file =3D epi->ffd.file;
> >  	struct epitems_head *to_free;
> >=20
> > ...
> >=20
> >  	/*
> > -	 * We don't want to get "file->f_lock" because it is not
> > -	 * necessary. It is not necessary because we're in the "struct file"
> > -	 * cleanup path, and this means that no one is using this file anymor=
e.
> > -	 * So, for example, epoll_ctl() cannot hit here since if we reach thi=
s
> > -	 * point, the file counter already went to zero and fget() would fail=
.
> > -	 * The only hit might come from ep_free() but by holding the mutex
> > -	 * will correctly serialize the operation. We do need to acquire
> > -	 * "ep->mtx" after "epmutex" because ep_remove() requires it when cal=
led
> > -	 * from anywhere but ep_free().
> > -	 *
> > -	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
> > +	 * Use the 'dying' flag to prevent a concurrent ep_cleat_and_put() fr=
om
>=20
> s/cleat/clear/
>=20
> > +	 * touching the epitems list before eventpoll_release_file() can acce=
ss
> > +	 * the ep->mtx.
> >  	 */
> > -	mutex_lock(&epmutex);
> > -	if (unlikely(!file->f_ep)) {
> > -		mutex_unlock(&epmutex);
> > -		return;
> > -	}
> > -	hlist_for_each_entry_safe(epi, next, file->f_ep, fllink) {
> > +again:
> > +	spin_lock(&file->f_lock);
> > +	if (file->f_ep && file->f_ep->first) {
> > +		/* detach from ep tree */
>=20
> Comment appears to be misplaced - the following code doesn't detach
> anything?

Indeed. This is a left-over from a previous revision. Can be dropped.


I have a process question: I understand this is queued for the mm-
nonmm-unstable branch. Should I send a v5 with the above comments
changes or an incremental patch or something completely different?

Thanks!

Paolo

