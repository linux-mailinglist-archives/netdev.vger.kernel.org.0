Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEB942C6A9
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbhJMQqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237193AbhJMQqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 12:46:43 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714E5C061570;
        Wed, 13 Oct 2021 09:44:40 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id n65so7908457ybb.7;
        Wed, 13 Oct 2021 09:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HBAQt+eju2fHVOe7BtoAfzY1sx0dCQ1f+XJnu9p+gz4=;
        b=ostrvaVP7bDhDpkQxor1hIGnbsScrLCosNgTW0wrZjf31OB4VkskUKMS7LvngdlBZH
         gD+loBm0LQGWoPXtZWLWatWxMJkbKj+eaTNw5ok1eQzTCEbviQ1PNgBkt+huYRWYHMiX
         JrFFA4wQidTP5+CCmE8uwVgfWqAyqgmddwayxpLhdaXbHd+R9/ez4i3TwMaVDBK4WXwu
         E48ODLobltj5BrnY9qw7YbwfmEKy8tL9WBUidHtvVjmGLCKZ3RYTp3tTvWWAs18+bGHa
         1iYDOaS0fF90eqe6d7Dr74hgjj79gkgqCPh7wCWrLL2Mny4F6S+0SNJKstC8T5SmRU35
         NqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HBAQt+eju2fHVOe7BtoAfzY1sx0dCQ1f+XJnu9p+gz4=;
        b=sLRrhDdZ7vUDu/c3keXufDcCB6Bxqx3edH83CGwAgGleZTdkj/uyI3Hq917kD1UcwG
         ef54vF8H4KHOOmXRgHipngQEVpaR1XmYZ176hJJzPf83prsqJZnA7CE0ZHCZNtN2nqKR
         SQga1KuOCT4zPv85TVRXkYV7doRuRJ1QGNNKsiYtmjYBeFH8mNTSg6MYxDtrYNZPfPZv
         NjE092ViC6BS8W+pl6+3/b7wN8TZsSjbOcqezxRLbSRcJQWdwNqVMTpELpBg6itQlDnk
         3l3GOVDNrEchp4xQWmpr1ktQVBVhcCSOVNLlz1wxolvTYnzY57C0eLfZKrzFbhy/6r6m
         XfzQ==
X-Gm-Message-State: AOAM533xfTxLpz9iNLS81WN5iWwjaavkppdcIB8AN7ZlchuqnX2TshgV
        uq6GMZx+hA2drkYd47Dh8WkAv+nvSOQspCXv6Fs=
X-Google-Smtp-Source: ABdhPJwy17CGw+zfSal5MFH5FZWjrp3O2y/qyCuL4l6Y/qHNFP6hl7vlrrX9rFRYJ+dMBS1V/umW5C9/RX4YnKrmKZc=
X-Received: by 2002:a25:c88:: with SMTP id 130mr488484ybm.176.1634143479749;
 Wed, 13 Oct 2021 09:44:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211007195147.28462-1-xiyou.wangcong@gmail.com> <6166e806d00ea_48c5d208be@john-XPS-13-9370.notmuch>
In-Reply-To: <6166e806d00ea_48c5d208be@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 13 Oct 2021 09:44:28 -0700
Message-ID: <CAM_iQpU11gHXS416D9KjTd5CoEGyhNT3kkejUMhymoOmnGUrcw@mail.gmail.com>
Subject: Re: [Patch bpf v3] skmsg: check sk_rcvbuf limit before queuing to ingress_skb
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 7:07 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Jiang observed OOM frequently when testing our AF_UNIX/UDP
> > proxy. This is due to the fact that we do not actually limit
> > the socket memory before queueing skb to ingress_skb. We
> > charge the skb memory later when handling the psock backlog,
> > and it is not limited either.
> >
> > This patch adds checks for sk->sk_rcvbuf right before queuing
> > to ingress_skb and drops or retries the packets if this limit
> > exceeds. This is very similar to UDP receive path. Ideally we
> > should set the skb owner before this check too, but it is hard
> > to make TCP happy with sk_forward_alloc.
> >
> > For TCP, we can not just drop the packets on errors. TCP ACKs
> > are already sent for those packet before reaching
> > ->sk_data_ready(). Instead, we use best effort to retry, this
> > works because TCP does not remove the skb from receive queue
> > at that point and exceeding sk_rcvbuf limit is a temporary
> > situation.
> >
> > Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>
> Makes sense to include a fixes tag here.
>
> > ---
> > v3: add retry logic for TCP
> > v2: add READ_ONCE()
>
> I agree this logic is needed, but I think the below is not
> complete. I can get the couple extra fixes in front of this
> today/tomorrow on my side and kick it through some testing here.
> Then we should push it as a series. Your patch + additions.

Sounds good. As long as we have this limit, it will be okay to me.

>
> >
> >  net/core/skmsg.c | 15 +++++++++------
> >  net/ipv4/tcp.c   |  2 ++
> >  2 files changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index 2d6249b28928..356c314cd60c 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
>
> All the skmsg changes are good.
>
>
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index e8b48df73c85..8b243fcdbb8f 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -1665,6 +1665,8 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> >                       if (used <= 0) {
> >                               if (!copied)
> >                                       copied = used;
> > +                             if (used == -EAGAIN)
> > +                                     continue;
>
> This is not a good idea, looping through read_sock because we have
> hit a memory limit is not going to work. If something is holding the
> memlimit pinned this could loop indefinately.
>
> Also this will run the verdict multiple times on the same bytes. For
> apply/cork logic this will break plus just basic parsers will be
> confused when they see duplicate bytes.

Good point! I run out of ideas for dealing with this TCP case,
dropping is not okay, retrying is hard, reworking TCP ACKing
is even harder. :-/

>
> We need to do a workqueue and then retry later.
>
> Final missing piece is that strparser logic would still not handle
> this correctly.
>
> I don't mind spending some time on this today. I'll apply your
> patch and then add a few fixes for above.

Ideally, we should move TCP ACK after ->sk_data_ready()
so that dropping in ->sk_data_ready() would be fine, but this is
certainly not easy even if it is doable.

Thanks.
