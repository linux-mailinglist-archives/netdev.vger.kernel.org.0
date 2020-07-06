Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12EA2161BB
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 00:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgGFW5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 18:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgGFW5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 18:57:33 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0543BC061755;
        Mon,  6 Jul 2020 15:57:32 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id o3so16991944ilo.12;
        Mon, 06 Jul 2020 15:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cLRzv4hA8fKGDAMnteKtx5+0LsnhAKMRWUKTqzh2WHc=;
        b=QqKPP9BRvPT774Kid7GZOFSH5Z/zic4cF8OBpRsxS3cMwb6XDwLhNvg3ohX9SC0ynE
         3QxSDmyrD8yvmer93+Sm2Z9Lc8IwxY/3mFx86fM+dmJdox+CoYSJnP+HJbhgZt3eHxyS
         E1enwiouoyE3+pRZs7Kny8dwOSJ7nuHW6zTYnBg3lYcPy1H8UoCyC8BubRGXI7Bb05eF
         bbAHrU3N7Cb7F8oblcFE4l+KsAohAs4W4Yo8JqsBXRfLHy10ll9SCdn9PAuh3XEiqoP+
         NHRntcgsQuypXPZZ8zXpcqYhUUSlW+FgMZduVFT7a72E5WRATuZxKweRzYgG37CX5eJa
         6hAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cLRzv4hA8fKGDAMnteKtx5+0LsnhAKMRWUKTqzh2WHc=;
        b=Eo1J+isXD1zR6CzaCpQbb5zxYoGQdiuxGIpfFfo1gH97govzLkmqqPmwMUiuL96Pn6
         5zVQdXtqlxnKpzWPjizNfvh4Z08g2lTChCQu0LuggHCcFoibP2ivn7zhAdPGAXttyPID
         pDPq7L9XgmfZ9xWY0CIhI6x4ZE1bPWSyOUoD2tD6bs7VJZCMyz3ePX5CRuehKfCrAE68
         /HyDDLct0iJgJ5lWKNC0EQNFsH2Kb1G630CkKGz6YY8QoCdhxJLnBQR4FxB+HbX2hHWY
         iG1zEdrViYF6fxT8pswIL2K/6o+Zsl/BXZNBbGJtOCMSY5komtyXzT1fbOswxkBQT+iL
         Hx4Q==
X-Gm-Message-State: AOAM533okMXTV6UDZmOgUyv8warhYBgq1bMWTUJaDGNZiPWKbYa6jAC6
        lSo51umT4hWrqnGJ2fH3m0VhicrHkrXeulknRdJ+2l6u
X-Google-Smtp-Source: ABdhPJz+qKkr14RsirSyXjgeDgBUS/0AgpSRxaQcx0aJYzX/H8nTtrOsIaDdzo0Fk9ZdYxEN6bfswWNBtqAl0D3WOR4=
X-Received: by 2002:a92:bd0f:: with SMTP id c15mr31522807ile.95.1594076252087;
 Mon, 06 Jul 2020 15:57:32 -0700 (PDT)
MIME-Version: 1.0
References: <1593027056-43779-1-git-send-email-sridhar.samudrala@intel.com>
 <CAKgT0UdD2cyikv8WgCoZSsHsxsbLm0-KZ9SxatbgEfgbb3z-FQ@mail.gmail.com> <e0a75c17-cc87-641d-50b3-0375be844a4b@intel.com>
In-Reply-To: <e0a75c17-cc87-641d-50b3-0375be844a4b@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 6 Jul 2020 15:57:21 -0700
Message-ID: <CAKgT0Uek8w7hA70qW6ADwb7M9WAGVVgLV0y2T9NCe2=6W+5puw@mail.gmail.com>
Subject: Re: [PATCH v2] fs/epoll: Enable non-blocking busypoll when epoll
 timeout is 0
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     linux-fsdevel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 3:33 PM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
>
>
> On 7/6/2020 1:36 PM, Alexander Duyck wrote:
> > On Wed, Jun 24, 2020 at 4:03 PM Sridhar Samudrala
> > <sridhar.samudrala@intel.com> wrote:
> >>
> >> This patch triggers non-blocking busy poll when busy_poll is enabled,
> >> epoll is called with a timeout of 0 and is associated with a napi_id.
> >> This enables an app thread to go through napi poll routine once by
> >> calling epoll with a 0 timeout.
> >>
> >> poll/select with a 0 timeout behave in a similar manner.
> >>
> >> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> >>
> >> v2:
> >> Added net_busy_loop_on() check (Eric)
> >>
> >> ---
> >>   fs/eventpoll.c | 13 +++++++++++++
> >>   1 file changed, 13 insertions(+)
> >>
> >> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> >> index 12eebcdea9c8..c33cc98d3848 100644
> >> --- a/fs/eventpoll.c
> >> +++ b/fs/eventpoll.c
> >> @@ -1847,6 +1847,19 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
> >>                  eavail = ep_events_available(ep);
> >>                  write_unlock_irq(&ep->lock);
> >>
> >> +               /*
> >> +                * Trigger non-blocking busy poll if timeout is 0 and there are
> >> +                * no events available. Passing timed_out(1) to ep_busy_loop
> >> +                * will make sure that busy polling is triggered only once.
> >> +                */
> >> +               if (!eavail && net_busy_loop_on()) {
> >> +                       ep_busy_loop(ep, timed_out);
> >> +                       write_lock_irq(&ep->lock);
> >> +                       eavail = ep_events_available(ep);
> >> +                       write_unlock_irq(&ep->lock);
> >> +               }
> >> +
> >>                  goto send_events;
> >>          }
> >
> > Doesn't this create a scenario where the NAPI ID will not be
> > disassociated if the polling fails?
> >
> > It seems like in order to keep parity with existing busy poll code you
> > should need to check for !eavail after you release the lock and if
> > that is true you should be calling ep_reset_busy_poll_napi_id so that
> > you disassociate the NAPI ID from the eventpoll.
>
> We are not going to sleep in this code path. I think napi id needs to be
> reset only if we are going to sleep and a wakeup is expected to set the
> nap_id again.

That wasn't my understanding of how that worked. Basically the whole
point of clearing the napi ID from the eventpoll instance is to handle
the fact that the NAPI instance may no longer be routing packets to
us. So when the NAPI instance failed to provide us with a packet when
we made a call to busy poll we would clear the napi_id which would
then allow a new napi_id to be assigned. Otherwise what you end up
with is an eventpoll with a static napi_id value since it will never
be cleared or updated once it is set, assuming all the calls to this
function have a timeout of 0 in your test case.

The problem is there isn't a 1:1 mapping between eventpolls and
sockets or NAPI IDs. It is a many:1 and as a result we have queues go
idle while others become busy so we need a way to shift from an idle
one to a busy one in the event of the traffic shifting from one port
to another.
