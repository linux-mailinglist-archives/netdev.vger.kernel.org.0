Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D0059C8CD
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238752AbiHVT2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238526AbiHVT2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:28:21 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56AF55097
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:23:02 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3246910dac3so321199647b3.12
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=JSHBrSz1Ou0FqLUgBygTAnGOj6KBPEZHFWs1kvzp8hs=;
        b=qEGRvcrc4mBZn1Yh5Snv8ke42whlDAYv98NGHgzcRHehmMdpj9ADfGb33ewJ6qQgNB
         5msGn252y0OHJVbB5zRA+jRWg/dnEvT5iJ+UoQtgQIa4S4ancG0TujbH1A0dGUfnXYVR
         5mtZGWOFing9pZeTHXXI3wIe74xbfSz0lwwyYp7+yaSQrzUqSJm9W1AMyBOFciVFIQln
         w8lC8yggPWstqRk6lzJnBvDFelnMyESfm8zmnDt7WYANMOMquHX1sV/R6PUU3lFXonBu
         HZY+NaP3BQvyKCqoYpRHzlmlcpNkfH5tcOaoQFlCQGj6v9mQdjPVzxXAtzWDFySPM/2O
         O5Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=JSHBrSz1Ou0FqLUgBygTAnGOj6KBPEZHFWs1kvzp8hs=;
        b=Y5ldVoeh80KZrYlykFhNk0O1W40iSB7iLAz4lPhCuxBdmeG4SrGQ4NReAvenxPs0rD
         AchMpBvhqR6ENG0W4o5OTSVefCqgaHJOGrIWtdHuiTGQCzs28e0PeuBoS9ZV1sd4x0wj
         16xw8vu/OupVCgtGKesx/VmwTKTlH24LAdVDHUL2qiDD2sYCl/LPMNXL+EuqagHcR6w0
         bM+ULQ6tQ1FQI0bRmpoVHx/lApEa55UcDY+/xiq14HETJUAnw6/Djn8IgDnpAwxogKWv
         bBmd+/OKYHmpT6ATKvYZYm+kDzOGXpGavFwXxfNojS80fW2K1U4VGOGV2fduQIqwQaij
         AbsQ==
X-Gm-Message-State: ACgBeo3Fuh8BeIrNZePgwQHKl16TyTjHPucPC0tZP41UlXbdvDRc5KCw
        cXvRVQQYDfk4txki5UsgcejQgIr2Tx784o42GASNtcCOSQTggg==
X-Google-Smtp-Source: AA6agR4e3WpR9u6b7mXMSdrEszuVWIfZuIV5yQI7wdLby4ScUhQFve8O208MzZZBJM35UTRQNqfJD0cBPWgSXLzIDhM=
X-Received: by 2002:a25:880f:0:b0:67c:2727:7e3c with SMTP id
 c15-20020a25880f000000b0067c27277e3cmr21413020ybl.36.1661196166586; Mon, 22
 Aug 2022 12:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89i+amoiCtNuGO6e1dx=9vfdfQSe09MZ7iRKQ+sdo6K=uzA@mail.gmail.com>
 <20220822191445.21807-1-kuniyu@amazon.com>
In-Reply-To: <20220822191445.21807-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 22 Aug 2022 12:22:35 -0700
Message-ID: <CANn89iJfWanX5xA3Qhp2LF0UJAU20WBbVjj2oMcbu2e43OXWcw@mail.gmail.com>
Subject: Re: [PATCH v3 net 05/17] ratelimit: Fix data-races in ___ratelimit().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 12:15 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Mon, 22 Aug 2022 12:00:11 -0700
> > On Thu, Aug 18, 2022 at 11:29 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > While reading rs->interval and rs->burst, they can be changed
> > > concurrently.  Thus, we need to add READ_ONCE() to their readers.
> > >
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > ---
> > >  lib/ratelimit.c | 8 +++++---
> > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/lib/ratelimit.c b/lib/ratelimit.c
> > > index e01a93f46f83..b59a1d3d0cc3 100644
> > > --- a/lib/ratelimit.c
> > > +++ b/lib/ratelimit.c
> > > @@ -26,10 +26,12 @@
> > >   */
> > >  int ___ratelimit(struct ratelimit_state *rs, const char *func)
> > >  {
> > > +       int interval = READ_ONCE(rs->interval);
> > > +       int burst = READ_ONCE(rs->burst);
> >
> > I thought rs->interval and rs->burst were constants...
> >
> > Can you point to the part where they are changed ?
> >
> > Ideally such a patch should also add corresponding WRITE_ONCE(), and
> > comments to pair them,
> >  this would really help reviewing it.
>
> In this case, &net_ratelimit_state.(burst|interval) are directly
> passed to proc_handlers, and exactly the relation is unclear.
>
> As Jakub pointed out, two reads can be inconsistent, so I'll add
> a spin lock in struct ratelimit_state and two dedicated proc
> handlers for each member.

This seems overkill to me... Adding a comment explaining why a race
(or inconsistency) is acceptable is enough I think.

Otherwise, we will have to review all other 'struct ratelimit_state'
which expose
in r/w mode their @interval or @burst field.


>  Then, I'll add few more comments to
> make that relation clear.
>
> Thanks for feedback!
>
>
> > >         unsigned long flags;
> > >         int ret;
> > >
> > > -       if (!rs->interval)
> > > +       if (!interval)
> > >                 return 1;
> > >
> > >         /*
> > > @@ -44,7 +46,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
> > >         if (!rs->begin)
> > >                 rs->begin = jiffies;
> > >
> > > -       if (time_is_before_jiffies(rs->begin + rs->interval)) {
> > > +       if (time_is_before_jiffies(rs->begin + interval)) {
> > >                 if (rs->missed) {
> > >                         if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
> > >                                 printk_deferred(KERN_WARNING
> > > @@ -56,7 +58,7 @@ int ___ratelimit(struct ratelimit_state *rs, const char *func)
> > >                 rs->begin   = jiffies;
> > >                 rs->printed = 0;
> > >         }
> > > -       if (rs->burst && rs->burst > rs->printed) {
> > > +       if (burst && burst > rs->printed) {
> > >                 rs->printed++;
> > >                 ret = 1;
> > >         } else {
> > > --
> > > 2.30.2
> > >
