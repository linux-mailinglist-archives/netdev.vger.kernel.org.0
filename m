Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83373C701A
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbhGMMIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235797AbhGMMIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:08:01 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EECCC0613DD;
        Tue, 13 Jul 2021 05:05:10 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id k184so34335242ybf.12;
        Tue, 13 Jul 2021 05:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G4qUuiRcnCqECtHAPnwTFpmFpYXByDpjZoDpTuZyyA0=;
        b=m/+o0ouN8yGbzHGH+fsTvse9H7ZEqDZwjDRjh9TWqyhEcJI28Ywq2C6WgRHl7VUVqk
         dRux8kDtNTCWmv1K14fGv+U8qb6I/3tE/AMhMs5Hd+BjxxiD1QeTyrd6iYc4PmM9wCwm
         Tgn3BPqYifaSbHpAGcnYiJHQWC9CYGZkKPirQPjak+iwqvkZYd9XHe/ZFiARBO7BMNzh
         JJSsGRMrKjC92G+tVcD4R6yRHNkjms3DvKxHQzdqdIRrs/5yHW4HwHrYXEF0DYLlnVXz
         3RUVzivnJznL2Hrr8HIkO84Hg8nAzvyOD1L8AxysH2Gt3HmL14yX8HoeFfRotr17hOYw
         DD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G4qUuiRcnCqECtHAPnwTFpmFpYXByDpjZoDpTuZyyA0=;
        b=W//3IAOBx3y1+A7UG28Lj6wIPjAOlunT4PotCvYU0AdNuSwuFkFpCnW2Oit8U9QV1t
         ry1K7ez7Smg/bOBbfbRBRMH2nU3N8pq9aSZrRqxogqVwMVorItLCqedMB3BMOL593rHR
         eK4HENqYGma7S7svuVtNSNJ3COjdeEXYdDbH6dRSs+YrJkvisT5JLH5ij0Ni0+494+Vc
         PqZFsw3d33I+OHOVd+c8bfwooMwrUYwGxc/6UtBOmcVx5QHOvIYqj4bfpabfo5422Prb
         GMW0+ngf2sl8UB01gggCXini7+rIM/uCkYdRCa0NCDw7bYwencs4DEdMxoacgv6MCFjY
         UpcA==
X-Gm-Message-State: AOAM532C/QlE/JCD4wD53fBOtpqNSe07bd/fKc6HTuFLWYs9Vw+QiQmx
        UDuWUlHmyqnwjNB6fE6kxlmWNLftSQ/OxIRnSAE=
X-Google-Smtp-Source: ABdhPJxzbiMIFK6e9wYRrK4smZN209wow+vMaQRxI8Sn+Una/ZyJF+g1mVl1oHxCN5MYCBuxySSi/En7yAzSI+7pyXI=
X-Received: by 2002:a25:7415:: with SMTP id p21mr5056281ybc.464.1626177909786;
 Tue, 13 Jul 2021 05:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210713094158.450434-1-mudongliangabcd@gmail.com>
 <CAKXUXMwMvWmS1jMfGe15tJKXpKdqGnhjsOhBKPkQ6_+twZpKxA@mail.gmail.com> <CAD-N9QUipQHb7WS1V=3MXmuO4uweYqX-=BMfmV_fUVhSxqXFHA@mail.gmail.com>
In-Reply-To: <CAD-N9QUipQHb7WS1V=3MXmuO4uweYqX-=BMfmV_fUVhSxqXFHA@mail.gmail.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Tue, 13 Jul 2021 14:04:58 +0200
Message-ID: <CAKXUXMyFRN=p-JtgFHXneTx8rF+tWLb4sBgjLRWdzZ_wz=pZiw@mail.gmail.com>
Subject: Re: [PATCH] audit: fix memory leak in nf_tables_commit
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 1:52 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> On Tue, Jul 13, 2021 at 7:47 PM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
> >
> > On Tue, Jul 13, 2021 at 11:42 AM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > >

> > >
> > > Reported-by: syzbot <syzkaller@googlegroups.com>
> >
> > As far as I see, the more default way is to reference to syzbot by:
> >
> > Reported-by: syzbot+[[20-letter hex reference]]@syzkaller.appspotmail.com
> >
>
> Hi Lukas,
>
> this bug is not listed on the syzbot dashboard. I found this bug by
> setting up a local syzkaller instance, so I only list syzbot other
> than concrete syzbot id.
>

I see. Thanks for your explanation.

Lukas
