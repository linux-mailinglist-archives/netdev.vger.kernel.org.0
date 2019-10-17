Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD26EDB77E
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503537AbfJQT2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:28:41 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38566 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503533AbfJQT2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:28:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so2269754pfe.5
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 12:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M0cpe+xAnf0JAQiBTTVlKo0dhMkW4kWT/0owzmu0PUM=;
        b=LT8WqTH2njDl5a6gaGh5t02NFTuw/adhE3nxuJqKyWYl0Sy/i8T4ibEOoJvwJhdcw4
         +Y4RIbnrUhAkL5aWexG7R+KRWoV1qO9Zvx0xEDscMbqWzPQgQvqogxgd9FpUSOYlu+u1
         O/A3k46H4cwUH5Guhbdf4Yh5cXfooaGZHp4gY2tB4yMGNR3CxBLJ9S7R+mFdV1yGRsB5
         ye9aUx/EgpmYqeiRx30WJH0PDGHGwyhLdJ670yPlDWf4gczPL9DI0OnYrmy7NyvyZVK7
         ksHKSYXk2ygXkYd7grKKwOStYoLLA3H+hLHRwqU5Q7F/8CDK2yD81NFfBVGVGQfqVhGE
         4WLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M0cpe+xAnf0JAQiBTTVlKo0dhMkW4kWT/0owzmu0PUM=;
        b=POQ1YzAC7cnewCPSPFYSPK9lkf7yGleDnucDLg4lpUr5nkSHVrsgFW5jpS09+WTKP0
         GwJunLMA9tFkiZoCUwhoY2GhnoLkIGxaLwn6qSoH5JIVx91vw78Xn+536efRx42a+A0F
         ORhOAHbom6eoXUgjWyzb60JTVlTwbCPd/DCQIuTnmDC6LRu+LVlVpNj7qAyV6BQ+pwVr
         eZmGi0YssVw6WutRhg3qd6gINXob7k+YGProuWTxaBT646H3keU7G1t1JtQucojwEM6l
         OJ/NbmheCHr5mQymJCVVr1AMuKNb0wy4+9MT+RRQGbHeTohQDYcpXgv5i6JHpwN9R9VQ
         JSQw==
X-Gm-Message-State: APjAAAXrGpt0cIpIsdSxLNIyprRZHvp0LE2MeQ4WZLMfLZ55u/zvHOUc
        I5kIgQ4SzSRc5FUjKcPYFciioDAV3kQi9PZtcK7sJFu9
X-Google-Smtp-Source: APXvYqy3wE1tmO6k/vfCQd3hlaVxrRkown+66dsdbM/EhDGXnuA9XDU8HPRMFDBVbz9qAtEB/nO/xPd+i5v6+lK1Sdg=
X-Received: by 2002:a63:3c47:: with SMTP id i7mr1729227pgn.237.1571340518383;
 Thu, 17 Oct 2019 12:28:38 -0700 (PDT)
MIME-Version: 1.0
References: <20191016160050.27703-1-jakub.kicinski@netronome.com>
 <CAM_iQpXw7xBTGctD2oLdWGZHc+mpeUAMq5Z4AYvKSiw68e=5EQ@mail.gmail.com>
 <20191016162210.5f2a8256@cakuba.netronome.com> <CAM_iQpW=S+UarEKCtL6q_ZyxVn0chVLgXQyfRNP_Kw-P8_Qt+Q@mail.gmail.com>
 <20191017114404.4fb502c6@cakuba.netronome.com>
In-Reply-To: <20191017114404.4fb502c6@cakuba.netronome.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 17 Oct 2019 12:28:27 -0700
Message-ID: <CAM_iQpWUfdmiaJQz1sL9CH=2VUj3DbxBP2rNJ427G9r_ygb8pw@mail.gmail.com>
Subject: Re: [PATCH net] net: netem: fix error path for corrupted GSO frames
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 11:44 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 17 Oct 2019 11:10:06 -0700, Cong Wang wrote:
> > On Wed, Oct 16, 2019 at 4:22 PM Jakub Kicinski wrote:
> > > On Wed, 16 Oct 2019 15:42:28 -0700, Cong Wang wrote:
> > > > > @@ -612,7 +613,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> > > > >                         }
> > > > >                         segs = skb2;
> > > > >                 }
> > > > > -               qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
> > > > > +               qdisc_tree_reduce_backlog(sch, !skb - nb, prev_len - len);
> > > >
> > > > Am I the only one has trouble to understand the expression
> > > > "!skb - nb"?
> > >
> > > The backward logic of qdisc_tree_reduce_backlog() always gives me a
> > > pause :S
> >
> > Yeah, reducing with a negative value is actually an add. Feel free
> > to add a wrapper for this if you think it is better.
>
> I was avoiding adding the wrapper due to stable, but perhaps it should
> be okay.

Up to you, you can defer the wrapper to net-next.

>
> How does this look?

"nb - 1" with a comment is much better than "!skb - nb".

Thanks.
