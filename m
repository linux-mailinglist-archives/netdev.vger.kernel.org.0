Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A2C233AE4
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbgG3Vc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730551AbgG3Vc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:32:58 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1822C061575
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:32:58 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id j9so20350370ilc.11
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AQBbAhFTyBSrglcyNo0R7cwbXKSUj5Es+XVNm5PBn+w=;
        b=I5BbvQHZRCGgbwSbkoJDzhF2+3xJSObl+3hFU/aKQf0HRevEdTPx2z0jGNmew6s+lH
         oOwOl9wRp1sJ+oFtkQGcHuRgz74UI8DafbN2+GEFlsJM3ETdWD2JhvQVDZbjQSmPM8EP
         vW216DgXZItCOOVVlTflnezjxp9r8rKuxRwwLVS/Yb70mRyZo40sp36+CJgq87jCaSrI
         k1a4Yrr4f6CgwjeecuBYrKrOeQ0llv+htoH4L1/ZrYq6SPKqYB/alip4j9Xrr8P5zpxV
         v1kDctMS/+EHmW+0UnGbs9blrHbIVYK5Vos+p38MmxEXY8vSQZe6D0acc2kEU0BTziQg
         GYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQBbAhFTyBSrglcyNo0R7cwbXKSUj5Es+XVNm5PBn+w=;
        b=QDV2Tyrsx8BOEzdUEu/4olWB1qpzvg0qdfefqbxMwa7ysUX4TfE8S0uXdfQmIvJG9t
         va5IQbAP2DjiwWLpnaS1QqQFN0ZvWrs0jlbVQcJLXLkgnmPp5HDp1rx9k/qegRYY4O36
         ukBM764SPFffT4CHdhB8jAuM+vxaNnRoijRhERh4edYOIW1TYjeSpEuZl1meu3dQfheQ
         UpUT+k8cy5sJhW5Du9n00N9QpHzZJ0/tQCvqtIv5Tl0uZp71TiUEqlAy9W9jyBUKaJTR
         I8STnrgxAC7pSvc4ZgpZ2GkXIoxpXsHaev1UdjhUpwrnSvah9Nbra07oL3PGGPJdxbJw
         5XGQ==
X-Gm-Message-State: AOAM532HR3VBN1stXjogJhMYDWmMMtEjkte15qJByBwZK1dsQ/d79nOU
        AC9qx8o22OMWGvyrM41NBPbic3KQvdbxlP/oLzQ9lg==
X-Google-Smtp-Source: ABdhPJykLzI1Z/S8NZeYpeN8fcephEvr68OTkcNMNoG7nyafUKmmJ+qzlRDAtZsUyXeNuDuatAazqXHaf4+A4cUN+kM=
X-Received: by 2002:a92:c608:: with SMTP id p8mr581749ilm.137.1596144777742;
 Thu, 30 Jul 2020 14:32:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200730210728.2051-1-f.fainelli@gmail.com> <CANn89iJETzud8PK7eTj=rXMSCjBtnmcSq1y0qF7EVK8b5M_vXA@mail.gmail.com>
 <2347a342-f0b0-903c-ebb6-6e95eb664864@gmail.com>
In-Reply-To: <2347a342-f0b0-903c-ebb6-6e95eb664864@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Jul 2020 14:32:46 -0700
Message-ID: <CANn89iJ=x8eYs9+cGYuyScMo7AD3JZqr6Jp1oZfJg41fHej8JQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Export tcp_write_queue_purge()
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 2:24 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 7/30/20 2:16 PM, Eric Dumazet wrote:
> > On Thu, Jul 30, 2020 at 2:07 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >> After tcp_write_queue_purge() got uninlined with commit ac3f09ba3e49
> >> ("tcp: uninline tcp_write_queue_purge()"), it became no longer possible
> >> to reference this symbol from kernel modules.
> >>
> >> Fixes: ac3f09ba3e49 ("tcp: uninline tcp_write_queue_purge()")
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >> ---
> >>  net/ipv4/tcp.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> >> index 6f0caf9a866d..ea9d296a8380 100644
> >> --- a/net/ipv4/tcp.c
> >> +++ b/net/ipv4/tcp.c
> >> @@ -2626,6 +2626,7 @@ void tcp_write_queue_purge(struct sock *sk)
> >>         tcp_sk(sk)->packets_out = 0;
> >>         inet_csk(sk)->icsk_backoff = 0;
> >>  }
> >> +EXPORT_SYMBOL(tcp_write_queue_purge);
> >>
> >>  int tcp_disconnect(struct sock *sk, int flags)
> >>  {
> >> --
> >> 2.17.1
> >>
> >
> > Hmmm.... which module would need this exactly ?
>
> None in tree unfortunately, and I doubt it would be published one day.
> For consistency one could argue that given it used to be accessible, and
> other symbols within net/ipv4/tcp.c are also exported, so this should
> one be. Not going to hold that line of argumentation more than in this
> email, if you object to it, that would be completely fine with me.

:)

>
> >
> > How come it took 3 years to discover this issue ?
>
> We just upgraded our downstream kernel from 4.9 to 5.4 and this is why
> it took so long.

It is not because TCP used an inline function in the past that it
means we have to keep
the equivalent function available for all possible out-of-tree modules.

Sorry, we can not accept that out-of-tree modules use TCP stack like that.

You will have to carry this change locally. Or even better get rid of it.
