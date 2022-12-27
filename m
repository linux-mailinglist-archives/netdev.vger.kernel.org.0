Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D76656BFD
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 15:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbiL0Oi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 09:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiL0OiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 09:38:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0223B1E
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 06:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672151846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgCz+tLYAfF9d3fkcqmVpnYWdED3weMm6ilwwtC+TyE=;
        b=fzPa3yTR0JMwQ2SRs2eYsCz1kzN+CqeiQ+fPLwe/jhSqbLDmFEFaa7BqFkGttHPamBvl+X
        uuyhCCXvSaHzRf79ttaQzO3nV+PYSj3eH+V3vuWktrdpwh0MC3+GdUZf+fA9J0dCe8cvRs
        bEGRzpsuNXBqAgDZ0r55h+CnYJPGWZ4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-436-t3JGbrlhM02Ro3m55oJ4XQ-1; Tue, 27 Dec 2022 09:37:25 -0500
X-MC-Unique: t3JGbrlhM02Ro3m55oJ4XQ-1
Received: by mail-wm1-f72.google.com with SMTP id fm17-20020a05600c0c1100b003d96f0a7f2eso6597503wmb.6
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 06:37:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xgCz+tLYAfF9d3fkcqmVpnYWdED3weMm6ilwwtC+TyE=;
        b=YY8vuL6xbR/7IeYcIvnfgf+613SMuoKoQ9zn5/hSVvdsaV9wPcMh+RBaJocUAx+Sdm
         lIomTMXHLl1jvFuTOfHX/F40CwLg/dx5Tzh8NH8z7HAodKawV/juJQt2X2TTVkkz1MpF
         pN26vtRJKVD/f/ZblkSsxjHtah7CzgkyI+XJ4BEokNX475XVwucphK93pATJ47unp9Dm
         mCEJ/teh7woI7Uj9tcWn+OvyRqQGJ4PI4vMDZPNPkTB6/uQWjNgGjh+o+ekj44XLs3Yf
         gI7rw33HU1JNDz+fEtqrMEw73xuSZe54j5MdnH8EzFbykZeTleJq23YVUD21MjzrIb8v
         fJMQ==
X-Gm-Message-State: AFqh2kp0quqRp+KoJpjyLdvTIre7Mh/AFMRq0gsBum98tvuplZ6xBxiq
        RgyqHm3SnYhLtoe5N/QhwTkBcxznqRu8qxOACl4CAKp+Me8yuR6T4vW90Z0AEz/mIdsFYFyNc8z
        nX+UaV3NrFzSsqcHB
X-Received: by 2002:adf:e810:0:b0:276:4089:81c2 with SMTP id o16-20020adfe810000000b00276408981c2mr7127719wrm.41.1672151843986;
        Tue, 27 Dec 2022 06:37:23 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuEQROGF+oitUSmj1Q8NX620ccWWcAn/1+eRYCelPItDeRg6waNVMMHTHrgmKbV/c3RtVQv9g==
X-Received: by 2002:adf:e810:0:b0:276:4089:81c2 with SMTP id o16-20020adfe810000000b00276408981c2mr7127707wrm.41.1672151843730;
        Tue, 27 Dec 2022 06:37:23 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id v18-20020a5d6792000000b0027e5501f7f5sm5002656wru.53.2022.12.27.06.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 06:37:23 -0800 (PST)
Date:   Tue, 27 Dec 2022 09:37:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Shunsuke Mie <mie@igel.co.jp>
Cc:     Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/9] vringh: unify the APIs for all accessors
Message-ID: <20221227075332-mutt-send-email-mst@kernel.org>
References: <20221227022528.609839-1-mie@igel.co.jp>
 <20221227022528.609839-5-mie@igel.co.jp>
 <20221227020007-mutt-send-email-mst@kernel.org>
 <CANXvt5pRy-i7=_ikNkZPp2HcRmWZYNJYpjO_ieBJJVc90nds+A@mail.gmail.com>
 <CANXvt5qUUOqB1CVgAk5KyL9sV+NsnJSKhatvdV12jH5=kBjjJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANXvt5qUUOqB1CVgAk5KyL9sV+NsnJSKhatvdV12jH5=kBjjJw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 07:22:36PM +0900, Shunsuke Mie wrote:
> 2022年12月27日(火) 16:49 Shunsuke Mie <mie@igel.co.jp>:
> >
> > 2022年12月27日(火) 16:04 Michael S. Tsirkin <mst@redhat.com>:
> > >
> > > On Tue, Dec 27, 2022 at 11:25:26AM +0900, Shunsuke Mie wrote:
> > > > Each vringh memory accessors that are for user, kern and iotlb has own
> > > > interfaces that calls common code. But some codes are duplicated and that
> > > > becomes loss extendability.
> > > >
> > > > Introduce a struct vringh_ops and provide a common APIs for all accessors.
> > > > It can bee easily extended vringh code for new memory accessor and
> > > > simplified a caller code.
> > > >
> > > > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> > > > ---
> > > >  drivers/vhost/vringh.c | 667 +++++++++++------------------------------
> > > >  include/linux/vringh.h | 100 +++---
> > > >  2 files changed, 225 insertions(+), 542 deletions(-)
> > > >
> > > > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > > > index aa3cd27d2384..ebfd3644a1a3 100644
> > > > --- a/drivers/vhost/vringh.c
> > > > +++ b/drivers/vhost/vringh.c
> > > > @@ -35,15 +35,12 @@ static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
> > > >  }
> > > >
> > > >  /* Returns vring->num if empty, -ve on error. */
> > > > -static inline int __vringh_get_head(const struct vringh *vrh,
> > > > -                                 int (*getu16)(const struct vringh *vrh,
> > > > -                                               u16 *val, const __virtio16 *p),
> > > > -                                 u16 *last_avail_idx)
> > > > +static inline int __vringh_get_head(const struct vringh *vrh, u16 *last_avail_idx)
> > > >  {
> > > >       u16 avail_idx, i, head;
> > > >       int err;
> > > >
> > > > -     err = getu16(vrh, &avail_idx, &vrh->vring.avail->idx);
> > > > +     err = vrh->ops.getu16(vrh, &avail_idx, &vrh->vring.avail->idx);
> > > >       if (err) {
> > > >               vringh_bad("Failed to access avail idx at %p",
> > > >                          &vrh->vring.avail->idx);
> > >
> > > I like that this patch removes more lines of code than it adds.
> > >
> > > However one of the design points of vringh abstractions is that they were
> > > carefully written to be very low overhead.
> > > This is why we are passing function pointers to inline functions -
> > > compiler can optimize that out.
> > >
> > > I think that introducing ops indirect functions calls here is going to break
> > > these assumptions and hurt performance.
> > > Unless compiler can somehow figure it out and optimize?
> > > I don't see how it's possible with ops pointer in memory
> > > but maybe I'm wrong.
> > I think your concern is correct. I have to understand the compiler
> > optimization and redesign this approach If it is needed.
> > > Was any effort taken to test effect of these patches on performance?
> > I just tested vringh_test and already faced little performance reduction.
> > I have to investigate that, as you said.
> I attempted to test with perf. I found that the performance of patched code
> is almost the same as the upstream one. However, I have to investigate way
> this patch leads to this result, also the profiling should be run on
> more powerful
> machines too.
> 
> environment:
> $ grep 'model name' /proc/cpuinfo
> model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
> model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
> model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
> model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
> 
> results:
> * for patched code
>  Performance counter stats for 'nice -n -20 ./vringh_test_patched
> --parallel --eventidx --fast-vringh --indirect --virtio-1' (20 runs):
> 
>           3,028.05 msec task-clock                #    0.995 CPUs
> utilized            ( +-  0.12% )
>             78,150      context-switches          #   25.691 K/sec
>                ( +-  0.00% )
>                  5      cpu-migrations            #    1.644 /sec
>                ( +-  3.33% )
>                190      page-faults               #   62.461 /sec
>                ( +-  0.41% )
>      6,919,025,222      cycles                    #    2.275 GHz
>                ( +-  0.13% )
>      8,990,220,160      instructions              #    1.29  insn per
> cycle           ( +-  0.04% )
>      1,788,326,786      branches                  #  587.899 M/sec
>                ( +-  0.05% )
>          4,557,398      branch-misses             #    0.25% of all
> branches          ( +-  0.43% )
> 
>            3.04359 +- 0.00378 seconds time elapsed  ( +-  0.12% )
> 
> * for upstream code
>  Performance counter stats for 'nice -n -20 ./vringh_test_base
> --parallel --eventidx --fast-vringh --indirect --virtio-1' (10 runs):
> 
>           3,058.41 msec task-clock                #    0.999 CPUs
> utilized            ( +-  0.14% )
>             78,149      context-switches          #   25.545 K/sec
>                ( +-  0.00% )
>                  5      cpu-migrations            #    1.634 /sec
>                ( +-  2.67% )
>                194      page-faults               #   63.414 /sec
>                ( +-  0.43% )
>      6,988,713,963      cycles                    #    2.284 GHz
>                ( +-  0.14% )
>      8,512,533,269      instructions              #    1.22  insn per
> cycle           ( +-  0.04% )
>      1,638,375,371      branches                  #  535.549 M/sec
>                ( +-  0.05% )
>          4,428,866      branch-misses             #    0.27% of all
> branches          ( +- 22.57% )
> 
>            3.06085 +- 0.00420 seconds time elapsed  ( +-  0.14% )


How you compiled it also matters. ATM we don't enable retpolines
and it did not matter since we didn't have indirect calls,
but we should. Didn't yet investigate how to do that for virtio tools.


> > Thank you for your comments.
> > > Thanks!
> > >
> > >
> > Best,
> > Shunsuke.

