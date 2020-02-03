Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62751151005
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgBCSyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:54:53 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45184 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgBCSyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 13:54:53 -0500
Received: by mail-ot1-f67.google.com with SMTP id 59so14646245otp.12;
        Mon, 03 Feb 2020 10:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jtTiPAHoPdehMe7tTgXan4c5NOqxoO1V8vwYLOzh25k=;
        b=vgJEamG1+O71DbkHbORzUTlkh2csWrDmYmk1IH2YkIV3zMjlZOmxaKXjX+EnvmjGHE
         v3K1F+ASuOFe4crlHQudVXXC3tn1ZYuBiTFucUiKWUA1oXP30VWrxMHKiPeoaVniyKZR
         vqgvjVBNtacCxRK4Q1yyVlvbxEx79IAlGgakEshxWe3RAAVpOe7VpWSojYJ9T8mhtmI0
         cBCjY3OFzg3GkVni7gNjxBtuUiP4LNxu1E+4mOlvUNNRNmvh/Xg12J+fhUZ/cW2f6jZW
         aFwk6WLeGFCQ7MyfY4VLxLs+o0zR6/aplFzHYqewdFIO6Ed57ZCj+MuzCY/ttHn+SZuI
         fcag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jtTiPAHoPdehMe7tTgXan4c5NOqxoO1V8vwYLOzh25k=;
        b=OM1a3TniT0jHdlLib9k04XimTiIwtjEV6d3yRn0Hy5ZTjBBsNSMr1qCNerrUxQX2qV
         SfS1AuYT3fIcza20MTMZTNEzBMWCoitJv0ASgkm/+oj0PLiukqCUvE985HBM+ZJgWn+t
         5TsF4qMzWJxRgjZ8JYRivYe3mR2DarE67C0YlrxH5FHqwFTJuIFgaZEYEdHh+0LZ9kcl
         GvobqJHZJUMmoBNozMu1lBP5NIff2VnlWjB0Ik45uD/ubAd+Awzj6qRseNI6fU0Sm0Oh
         6v3FTZcr9Zo2Fj/HGnM3OxVr7ihM8A1dbiq2+Ftz1gRPXtkvxlTUwh7KvKtnIRUoIBZJ
         ANbA==
X-Gm-Message-State: APjAAAUq5XHalqR3x/hAVAcIiYR4epoTDD8OL2wT5ujeU14Tp80ZGVvT
        maF2Exp02OeJAH+v0tNlQKbq3euB3+GY5guOq00=
X-Google-Smtp-Source: APXvYqwbVf9z6tVUScBzjXfBK+nhuSfmtUMAJeVBycTNB1L0t+VZMK+Y4Ww41/lOeVFVDbd/3wyR5A/5I8VoEPKO5K4=
X-Received: by 2002:a9d:7559:: with SMTP id b25mr18044214otl.189.1580756091365;
 Mon, 03 Feb 2020 10:54:51 -0800 (PST)
MIME-Version: 1.0
References: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
 <20200203043053.19192-2-xiyou.wangcong@gmail.com> <20200203121612.GR795@breakpoint.cc>
In-Reply-To: <20200203121612.GR795@breakpoint.cc>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 3 Feb 2020 10:54:39 -0800
Message-ID: <CAM_iQpWhQgJXumEnoKvH5VaCRTkZKmQQdKLkRsChf3+GiN47qQ@mail.gmail.com>
Subject: Re: [Patch nf v2 1/3] xt_hashlimit: avoid OOM for user-controlled vmalloc
To:     Florian Westphal <fw@strlen.de>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 3, 2020 at 4:16 AM Florian Westphal <fw@strlen.de> wrote:
>
> Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > The hashtable size could be controlled by user, so use flags
> > GFP_USER | __GFP_NOWARN to avoid OOM warning triggered by user-space.
> >
> > Also add __GFP_NORETRY to avoid retrying, as this is just a
> > best effort and the failure is already handled gracefully.
> >
> > Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Cc: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > ---
> >  net/netfilter/xt_hashlimit.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
> > index bccd47cd7190..5d9943b37c42 100644
> > --- a/net/netfilter/xt_hashlimit.c
> > +++ b/net/netfilter/xt_hashlimit.c
> > @@ -293,8 +293,8 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
> >               if (size < 16)
> >                       size = 16;
> >       }
> > -     /* FIXME: don't use vmalloc() here or anywhere else -HW */
> > -     hinfo = vmalloc(struct_size(hinfo, hash, size));
> > +     hinfo = __vmalloc(struct_size(hinfo, hash, size),
> > +                       GFP_USER | __GFP_NOWARN | __GFP_NORETRY, PAGE_KERNEL);
>
> Sorry for not noticing this earlier: should that be GFP_KERNEL_ACCOUNT
> instead of GFP_USER?

Why do you think it should be accounted in kmemcg?

I think this one is controlled by user, so I pick GFP_USER,
like many other cases, for example,
proc_allowed_congestion_control().

GFP_KERNEL_ACCOUNT (or SLAB_ACCOUNT) is not
common in networking, it is typically for socket allocations.
GFP_USER is common.

Thanks.
