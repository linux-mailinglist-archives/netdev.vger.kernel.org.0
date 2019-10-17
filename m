Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEFBDB59C
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440691AbfJQSKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:10:20 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41380 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395229AbfJQSKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:10:20 -0400
Received: by mail-pf1-f194.google.com with SMTP id q7so2141430pfh.8
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PtSSdC0EZfjKozynpiLiINWQgdqhWHKcWTUnhKVgIm4=;
        b=tXJnOBSPqAYHeNOTHLY9fBXPpQohc2VZyMhJ53PxSUeXkiRX1RCJg7bOoijd32xW5c
         2/M1Ev8qnS1u7xWuRKmfuS3MB29WGJV32Acxj/RzA+t4mYknz3+FICmPIztaRLEusuWG
         UCGzMfqdY+8IYA7tkyZhxYm/qjkZMm6pc0hbb9bOqgvYLQp8lF9lo+3J2QK/YSS0j7mT
         MNdlkFCi4AkvBnzs7bJn72erzUMsxSU0Cq7IcMTTxVJC+NzuXSUArbi+cAah43/FEc3f
         cqVPJ0s1MZkvDTlgMDKn/59mDONMassR50k0PwME3p6xb84l9RWn/HByX9QJmfXkMPtB
         2QPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PtSSdC0EZfjKozynpiLiINWQgdqhWHKcWTUnhKVgIm4=;
        b=bTCbWEEI3btx1CaKy1zObEszitQoBvNi6DEFfHffphqqslHXLpRJGAgJb0RPvVQGhC
         Dqw09kbZA1m9k88IzPkvlv82k6zjG9qQY6hPmQN2V3RBHvze1lZYQApJJYG8iL36tBr+
         U43Sp2UAsIu/tPqMaqMLmnVZ+CZGDG2StotZ1GD/F7TIhZLdDBJVuOSkjpbV09ao1Wy2
         zjLEIyx4FRc97Xf3M+N6VbsswTg+Vnw0wmGgvkdS9sa0/6aZSdcElO/1RI5H96J373dL
         XA97F4pm8stUlpVl56gTvENx7iLIbrOAaNKPd/TK4bh185rcGdEA7rDH3xdmb/5Qh+RZ
         5VAA==
X-Gm-Message-State: APjAAAXuM3xAWnZiZ2zwrAnAAkuiyEYyRRFtZy8DhNJta+k67x8gW7La
        I8BCvBb9MgoxoGxY6Bzog5gU3w6OtR9EwVV5nDU=
X-Google-Smtp-Source: APXvYqyhcQwL5Gbqob9kvgEj6eCuU5K9gcLdgDFKA/uIMYJyqzxDExaf6UvY08t+Oholpm9WPYAMuTqFEn21KEFiWCE=
X-Received: by 2002:a17:90a:c48:: with SMTP id u8mr6075171pje.16.1571335818349;
 Thu, 17 Oct 2019 11:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191016160050.27703-1-jakub.kicinski@netronome.com>
 <CAM_iQpXw7xBTGctD2oLdWGZHc+mpeUAMq5Z4AYvKSiw68e=5EQ@mail.gmail.com> <20191016162210.5f2a8256@cakuba.netronome.com>
In-Reply-To: <20191016162210.5f2a8256@cakuba.netronome.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 17 Oct 2019 11:10:06 -0700
Message-ID: <CAM_iQpW=S+UarEKCtL6q_ZyxVn0chVLgXQyfRNP_Kw-P8_Qt+Q@mail.gmail.com>
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

On Wed, Oct 16, 2019 at 4:22 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 16 Oct 2019 15:42:28 -0700, Cong Wang wrote:
> > > @@ -612,7 +613,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> > >                         }
> > >                         segs = skb2;
> > >                 }
> > > -               qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
> > > +               qdisc_tree_reduce_backlog(sch, !skb - nb, prev_len - len);
> >
> > Am I the only one has trouble to understand the expression
> > "!skb - nb"?
>
> The backward logic of qdisc_tree_reduce_backlog() always gives me a
> pause :S

Yeah, reducing with a negative value is actually an add. Feel free
to add a wrapper for this if you think it is better.

>
> Is
> -nb + !skb
> any better?

I don't see how they are different. :-/


>
> The point is we have a "credit" for the "head" skb we dropped. If we
> didn't manage to queue any of the segs then the expression becomes
> ...reduce_backlog(sch, 1, prev_len) basically cleaning up after the
> head.
>
> My knee jerk reaction was -> we should return DROP if head got dropped,
> but that just makes things more nasty because we requeue the segs
> directly into netem so if we say DROP we have to special case all the
> segs which succeeded, that gets even more hairy.

Hmm? My understanding is that !skb is either 0 or 1, so you end up
with either "-nb" or "1 - nb". The formal is easy to understand, while
the later is harder as I don't see why you need to plus 1.

>
> I'm open to suggestions.. :(

Why not write the code in a more readable way, for instance with the :?
operator? And, adding a comment in the code?

Thanks.
