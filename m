Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B13634211
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbiKVRAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiKVRA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:00:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FD27723E
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669136363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tcwj7zKb9FBT/27d+SqzgATb/+/cwGoTvbOKyV2oUC0=;
        b=iHEkcRHPLgjafGUvDi2GKLRYnJNsWpEQNSOH/AG3yzkPVG11fS6Axu2JSGpyllTg5AvNso
        j9aa/WhcDDiEgrxXV3mAVzhO8/ATJRq/fpXwjPsNI3OILqXqK+hJJQo3k5IlPXorZfsQC3
        3tCO6ddQDJxB5Ba6u0XysiGXmTxC4yw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-1RdastJbOjSm7DFUz_crjQ-1; Tue, 22 Nov 2022 11:59:22 -0500
X-MC-Unique: 1RdastJbOjSm7DFUz_crjQ-1
Received: by mail-wm1-f72.google.com with SMTP id p14-20020a05600c204e00b003cf4cce4da5so4295211wmg.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:59:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tcwj7zKb9FBT/27d+SqzgATb/+/cwGoTvbOKyV2oUC0=;
        b=D+Ea2psyaa8C3/rmjaaiid6CrhTGAj0Hstu6HGhEDr+loV2jLza1hvOp+nsY4aADzx
         wzOhkgN1tIkkKvevBP3aXY2gpVhG1ZgRRW8LA7OeD2Hg2RU6qZi5SlBwmQYRaMDs5zFW
         MNApkzkyZp7LDngbMUazVptY8PI6OVRkFuXPHKuK07mnkRV5+gCd/c8oTpXeRnCi6yoA
         vLVbmGfF2DwzrXHifHeLvthxp+7DpME/WiyBATj7sYr58IytPDCgr5A+/BLIz5A5jk/G
         ByzTlkl3LexmyRbjExoRmTeGu1H6fNAQ2UXPLTbY4QIh1Syxav6qAi4PWw1WotTw4CTU
         hqCg==
X-Gm-Message-State: ANoB5pl02f6deB499c0FhH7iC8isz/q+IDaB1WOyTYu1aHoQPY4Oj3Rj
        Os3bp4VudCE6A+3W9HkBaEdgGWVJOXXv0/ijJWvzYETONzHFc1vSusx7NgHx0KYMt9gLO/3HHmt
        RrGryYz2aji7XT813
X-Received: by 2002:adf:ffd2:0:b0:236:59ab:cf33 with SMTP id x18-20020adfffd2000000b0023659abcf33mr14799064wrs.568.1669136360580;
        Tue, 22 Nov 2022 08:59:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5ipsttDVyqGsvGwOwucuPtVofF5/nvmxT4xT5wxGK/GIy0z+5wA9kNhYU6aZgNw7rXtz8gyA==
X-Received: by 2002:adf:ffd2:0:b0:236:59ab:cf33 with SMTP id x18-20020adfffd2000000b0023659abcf33mr14799050wrs.568.1669136360259;
        Tue, 22 Nov 2022 08:59:20 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id k1-20020a5d6281000000b0022ae0965a8asm14469756wru.24.2022.11.22.08.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 08:59:19 -0800 (PST)
Message-ID: <819762b6eb549f74d0ebbb6663f042ae9b6cd86d.camel@redhat.com>
Subject: Re: [REPOST PATCH] epoll: use refcount to reduce ep_mutex contention
From:   Paolo Abeni <pabeni@redhat.com>
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>,
        Roman Penyaev <rpenyaev@suse.de>, netdev@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>
Date:   Tue, 22 Nov 2022 17:59:18 +0100
In-Reply-To: <CACSApvYq=r3YAyZ_XceoRz1BuU+Q+MypXaG_S1fMoYCyFEpbrw@mail.gmail.com>
References: <e102081e103d897cc0b76908acdac1bf0b65050d.1669130955.git.pabeni@redhat.com>
         <CACSApvYq=r3YAyZ_XceoRz1BuU+Q+MypXaG_S1fMoYCyFEpbrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Thank you for the prompt feedback!

On Tue, 2022-11-22 at 11:18 -0500, Soheil Hassas Yeganeh wrote:
> On Tue, Nov 22, 2022 at 10:43 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > We are observing huge contention on the epmutex during an http
> > connection/rate test:
> > 
> >  83.17% 0.25%  nginx            [kernel.kallsyms]         [k] entry_SYSCALL_64_after_hwframe
> > [...]
> >            |--66.96%--__fput
> >                       |--60.04%--eventpoll_release_file
> >                                  |--58.41%--__mutex_lock.isra.6
> >                                            |--56.56%--osq_lock
> > 
> > The application is multi-threaded, creates a new epoll entry for
> > each incoming connection, and does not delete it before the
> > connection shutdown - that is, before the connection's fd close().
> > 
> > Many different threads compete frequently for the epmutex lock,
> > affecting the overall performance.
> > 
> > To reduce the contention this patch introduces explicit reference counting
> > for the eventpoll struct. Each registered event acquires a reference,
> > and references are released at ep_remove() time. ep_free() doesn't touch
> > anymore the event RB tree, it just unregisters the existing callbacks
> > and drops a reference to the ep struct. The struct itself is freed when
> > the reference count reaches 0. The reference count updates are protected
> > by the mtx mutex so no additional atomic operations are needed.
> > 
> > Since ep_free() can't compete anymore with eventpoll_release_file()
> > for epitems removal, we can drop the epmutex usage at disposal time.
> > 
> > With the patched kernel, in the same connection/rate scenario, the mutex
> > operations disappear from the perf report, and the measured connections/rate
> > grows by ~60%.
> 
> I locally tried this patch and I can reproduce the results.  Thank you
> for the nice optimization!
> 
> > Tested-by: Xiumei Mu <xmu@redhat.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > This is just a repost reaching out for more recipents,
> > as suggested by Carlos.
> > 
> > Previous post at:
> > 
> > https://lore.kernel.org/linux-fsdevel/20221122102726.4jremle54zpcapia@andromeda/T/#m6f98d4ccbe0a385d10c04fd4018e782b793944e6
> > ---
> >  fs/eventpoll.c | 113 ++++++++++++++++++++++++++++---------------------
> >  1 file changed, 64 insertions(+), 49 deletions(-)
> > 
> > diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> > index 52954d4637b5..6e415287aeb8 100644
> > --- a/fs/eventpoll.c
> > +++ b/fs/eventpoll.c
> > @@ -226,6 +226,12 @@ struct eventpoll {
> >         /* tracks wakeup nests for lockdep validation */
> >         u8 nests;
> >  #endif
> > +
> > +       /*
> > +        * protected by mtx, used to avoid races between ep_free() and
> > +        * ep_eventpoll_release()
> > +        */
> > +       unsigned int refcount;
> 
> nitpick: Given that napi_id and nest are both macro protected, you
> might want to pull it right after min_wait_ts.

Just to be on the same page: the above is just for an aesthetic reason,
right? Is there some functional aspect I don't see?

[...]

> > @@ -2165,10 +2174,16 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
> >                         error = -EEXIST;
> >                 break;
> >         case EPOLL_CTL_DEL:
> > -               if (epi)
> > -                       error = ep_remove(ep, epi);
> > -               else
> > +               if (epi) {
> > +                       /*
> > +                        * The eventpoll itself is still alive: the refcount
> > +                        * can't go to zero here.
> > +                        */
> > +                       WARN_ON_ONCE(ep_remove(ep, epi));
> 
> There are similar examples of calling ep_remove() without checking the
> return value in ep_insert().

Yes, the error paths in ep_insert(). I added a comment referring to all
of them, trying to explain that ep_dispose() is not needed there.

> I believe we should add a similar comment there, and maybe a
> WARN_ON_ONCE.  I'm not sure, but it might be worth adding a new helper
> given this repeated pattern?

I like the idea of such helper. I'll use it in the next iteration, if
there is a reasonable agreement on this patch.

Whould 'ep_remove_safe()' fit as the helper's name?

Thanks,

Paolo

