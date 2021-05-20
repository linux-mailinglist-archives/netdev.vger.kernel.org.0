Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF2438B82C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbhETUQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbhETUQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 16:16:16 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE84C061574;
        Thu, 20 May 2021 13:14:54 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 191so18588727ybn.7;
        Thu, 20 May 2021 13:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bf1zYBZW2Wxvb0KWVamqbDm6yfJdXFOsZgPBES/iIWk=;
        b=po7E8EVQqIaheWO2BMqL8mABk4hyBfFEABACpKzao/p8G+/028J/tJNfyyTRxIKmIS
         OTYSn4HlxAfzYp4kdGKscrPZfBpPdbblRWCnd17IXbQ/frmpoUL2TsQH743I6xMs+w8J
         msTSNakDSda0Ir6rn4TLDo9UKlibNKJMeKRTeh1LQ5pUyLRlY+weA4bx4D3eBbBG3cUm
         Djyvw54IQKUEPoKLvJz8F+7C8XsviHZ5cOBKzIazm+Zv2ChTT4vLbiBrRqcsdgwUmyns
         EvQohFTAFx0SYPDM0IJjmUe/OuhY3N8DJiAMomalb3vp0BOH5C60yOQTBB4fvJVqOC6Y
         FY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bf1zYBZW2Wxvb0KWVamqbDm6yfJdXFOsZgPBES/iIWk=;
        b=Y1TDECAGJwllP56exq90iUoRlPxcXfRgHcRW9B4EPiwdXnbm34WOixd2ce9e2LFlDH
         1D0BiPLTGJlHCuf3fH0zSF7287F7yl1XSoJehe4WrpirJ+DWUkUxGIb4w/ToZmkv0zUi
         XefMkIDM6Gvme4EFlEFdIJBy2xu0o/DqsdxhN1O4Jd3ecg7U0ead/Vv2caMLEkjIAx/h
         6f4zsld+LcCZuWUbgH/AmqARNNvxCgU0AbzUQtX4/hOJuyEFaApbHMweinuzwrPhvhVH
         L8ptLeDjG6B40VonrHkwpv8UXxyvsFxZvp8VeTdo9yhWiAp7H/BOSOpTAZBfYxcYtcYH
         Rc2w==
X-Gm-Message-State: AOAM530nVAdpQhe6dfrMvG3by7wVG08UjU0WI/Z1gFXJgxrEUtB17X+c
        ysgr804SKlVv0Nz3vFjRETGiJoCq0yjt++vF5PISMP8K
X-Google-Smtp-Source: ABdhPJy5w47ZGWeEnp20H8/VZKr4R9nOnvimPJcLW5TAIieZa95cHGCZrcTxRSX6GUAN8c637W2hjVMvyXG6gapE274=
X-Received: by 2002:a25:3357:: with SMTP id z84mr9994534ybz.260.1621541693571;
 Thu, 20 May 2021 13:14:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210519204132.107247-1-xiyou.wangcong@gmail.com>
 <60a5896ca080d_2aaa720821@john-XPS-13-9370.notmuch> <CAM_iQpUC6ZOiH=ifUe1+cdXtTgiBMwPVLSsWB9zwBA7gWh8mgA@mail.gmail.com>
In-Reply-To: <CAM_iQpUC6ZOiH=ifUe1+cdXtTgiBMwPVLSsWB9zwBA7gWh8mgA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 May 2021 13:14:42 -0700
Message-ID: <CAEf4Bzb7+XrSbYx6x4hqsdfieJu6C5Ub6m4ptCO5v27dwbx_dA@mail.gmail.com>
Subject: Re: [Patch bpf] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 4:36 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, May 19, 2021 at 2:56 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > We use non-blocking sockets for testing sockmap redirections,
> > > and got some random EAGAIN errors from UDP tests.
> > >
> > > There is no guarantee the packet would be immediately available
> > > to receive as soon as it is sent out, even on the local host.
> > > For UDP, this is especially true because it does not lock the
> > > sock during BH (unlike the TCP path). This is probably why we
> > > only saw this error in UDP cases.
> > >
> > > No matter how hard we try to make the queue empty check accurate,
> > > it is always possible for recvmsg() to beat ->sk_data_ready().
> > > Therefore, we should just retry in case of EAGAIN.
> > >
> > > Fixes: d6378af615275 ("selftests/bpf: Add a test case for udp sockmap")
> > > Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > index 648d9ae898d2..b1ed182c4720 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > @@ -1686,9 +1686,13 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
> > >       if (pass != 1)
> > >               FAIL("%s: want pass count 1, have %d", log_prefix, pass);
> > >
> > > +again:
> > >       n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
> > > -     if (n < 0)
> > > +     if (n < 0) {
> > > +             if (errno == EAGAIN)
> > > +                     goto again;
> > >               FAIL_ERRNO("%s: read", log_prefix);
> >
> > Needs a counter and abort logic we don't want to loop forever in the
> > case the packet is lost.
>
> It should not be lost because selftests must be self-contained,
> if the selftests could not even predict whether its own packet is
> lost or not, we would have a much bigger trouble than just this
> infinite loop.

Bugs do happen though, so if you can detect some error condition
instead of having an infinite loop, then do it.

>
> Thanks.
