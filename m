Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE5A14F52B
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 00:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgAaXRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 18:17:35 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43144 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbgAaXRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 18:17:35 -0500
Received: by mail-oi1-f196.google.com with SMTP id p125so8948941oif.10;
        Fri, 31 Jan 2020 15:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lddKnZfH3lxsqX+cctMtAF3GKo7RkvSibOmZGG8SAIs=;
        b=PLoXMCEda9R3gUvpKaNePwsEU/qVq4fAUarhKcls49k95JxuiiKVH1X2z+Qn1pVSn7
         nKtXcynoUA+ICqsCo2uQjtrZNjNJeM1fzatWmB6ncYYs8Ululfp2I1nWUNpcLaP/lANq
         Z6iJGNgsM8FnRszEBi4FJkRCpPr8onpI3CgLwLco8SFhyIbnIiS+K7eWtVbSTpo7kS1Y
         lCX3/tT37J2kMWlsvxeyxqi6D2/UnucI0HiuZ/nzA0KEME8WkSJsscKvUf46jgYL3dN/
         z2NmaTiVfGrmDWLrrPrLjDhN4mhwVd04ETJrWhdqI1nY48HZD5x+sYYL3WeUpbYCENIS
         XpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lddKnZfH3lxsqX+cctMtAF3GKo7RkvSibOmZGG8SAIs=;
        b=Ln4MbrLUaEns8w6kFRWFVWLZ9Tkt5/3zkeTIstPg67vAR9A4AyTo36c2TLBZ5PXkcY
         1o4EHS1oxYmkhljzroWD9kllYsFlU0tHqBOq6QsyU+YWPA5e5u9AugTexMMb0xJJwegh
         CVco2jwW9HXXoM5bvsKbjUhminIFbpCo96b3jTsGBLjOXxHK0XrLbigQzOAD1D4KWP6I
         y6xje+YXXjFCZnbNzKQ48UEGuAmfIxkGggtN+c+RxiaSTfcbQK1mWDCW0+RR8np+zK5h
         8IBZHhJt9ngMb906pIk+Deds7kmRsaOLlYhq7C6GqFlchhKMNtknds9FlOOkjwJX5l3M
         wvOQ==
X-Gm-Message-State: APjAAAVl95F/mo78q9KHej+ggpJ215O3vNDlBZGT9wJ12XU0HdKC/gax
        AN++SV1B9DDCIow7c1LiU+RPb6oTy7aNoo/VF4QAjewn
X-Google-Smtp-Source: APXvYqwAFpx2ptMnWs0Qup1u24eWLus5feskSUgyrC6DdLdqvtC5Dfx5F/ZlpNNgVqkO4XsFrbGDgFtXdZ0dbS6OuaM=
X-Received: by 2002:aca:1e11:: with SMTP id m17mr8062026oic.5.1580512654439;
 Fri, 31 Jan 2020 15:17:34 -0800 (PST)
MIME-Version: 1.0
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
 <20200131205216.22213-2-xiyou.wangcong@gmail.com> <20200131220856.GK795@breakpoint.cc>
In-Reply-To: <20200131220856.GK795@breakpoint.cc>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 31 Jan 2020 15:17:23 -0800
Message-ID: <CAM_iQpUOhFZdxZruk46uapQNvfaqUqkB=giWnozdSDcRa2R=nA@mail.gmail.com>
Subject: Re: [Patch nf 1/3] xt_hashlimit: avoid OOM for user-controlled vmalloc
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

On Fri, Jan 31, 2020 at 2:08 PM Florian Westphal <fw@strlen.de> wrote:
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
> >  net/netfilter/xt_hashlimit.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
> > index bccd47cd7190..885a266d8e57 100644
> > --- a/net/netfilter/xt_hashlimit.c
> > +++ b/net/netfilter/xt_hashlimit.c
> > @@ -293,8 +293,9 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
> >               if (size < 16)
> >                       size = 16;
> >       }
> > -     /* FIXME: don't use vmalloc() here or anywhere else -HW */
> > -     hinfo = vmalloc(struct_size(hinfo, hash, size));
> > +     /* FIXME: don't use __vmalloc() here or anywhere else -HW */
> > +     hinfo = __vmalloc(struct_size(hinfo, hash, size),
> > +                       GFP_USER | __GFP_NOWARN | __GFP_NORETRY, PAGE_KERNEL);
>
> Rationale looks sane, wonder if it makes sense to drop Haralds comment
> though, I don't see what other solution other than vmalloc could be used
> here.

I will remove it.

Thanks.
