Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC4F387DF2
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 18:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350917AbhERQ4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 12:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346785AbhERQ4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 12:56:02 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD4BC061573;
        Tue, 18 May 2021 09:54:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s19so5596388pfe.8;
        Tue, 18 May 2021 09:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7VyHTF7P6/V7TAb2zviEJdAaxlxLmrPOedPfzAMxz+8=;
        b=G/LDJ2R9J8ITfHHEDssOw/OoAFRUBjDlDBZy8yRJuMI3hTci6FJsbD0OO7WtiSOU9p
         vCToNiKd9kxGdvZO8Fer9JuHwENW+8FjuNmjHcJR5BmyfAWajjGBy4EHwI3tNiuUczvM
         u/Xfc4kP24XyapN833twVjlxAm1jIOITBPMWFS17FyTSwi/IZM0gdXylmIMDOZO3mNUr
         uvnZF+h0UiNWA/M58kdIGAq85Q8QVe9wOxDRK90UtH0IO7xgOV9VJQE5CX5GrQuqFPJx
         zP94S5P2nnRKb7sd8R/2BOsqjus/t79ag0A5AV7t4ONfSeV/6ODvZfPFkWm91yFMFift
         Ec4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7VyHTF7P6/V7TAb2zviEJdAaxlxLmrPOedPfzAMxz+8=;
        b=GO5JLo6rS5Es3d5NISzjtJTAOhYyKTeKfRKbf1AyTtTFKpY8L/+c8Mozn2rtDtOhBA
         xVGLK1E161x7UaSy86Jb7mXXGun3W7qqaee1kgwgi+iXIhw7cbBqBtJGw9pNqOIPd0E0
         ElCj/B8lnFJ9WmOcDvpBFThRlUyFS7TRexI+acStyj8Gj6SrB2FzUtO/s6DhZyeF9OnC
         N4CTqavEUf79PAGxLCECdZT+uC4YDFt7ds52NTNvCHY9XppsiEQpy0dCKdl1NtDC9nVM
         GgM4WI5uQ9Kdr+AM93gzXT0VI+IZ2agKrlPdeBSHwGEB7l2z1+tVvCO03LbW+kpAxyyV
         htoQ==
X-Gm-Message-State: AOAM532soiZpP/owLXb7Stxr4Z9o+xYXyYT8kuSSx5U7z+ckqonNTDMv
        RXgMjvs15eVW4fEThbTaWlL8BY7OqBBsjLIzbQE=
X-Google-Smtp-Source: ABdhPJwdhp+AR0v6zt0VS/f7wcNZni7XeO2u2OaGaND19cExk+QyaQNH+JXgfaFXhzMIqK064iNiM7GCgmC6tVI94EQ=
X-Received: by 2002:a63:d014:: with SMTP id z20mr5952639pgf.428.1621356883957;
 Tue, 18 May 2021 09:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com> <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch>
In-Reply-To: <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 18 May 2021 09:54:33 -0700
Message-ID: <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
Subject: Re: [Patch bpf] udp: fix a memory leak in udp_read_sock()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 10:36 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > sk_psock_verdict_recv() clones the skb and uses the clone
> > afterward, so udp_read_sock() should free the original skb after
> > done using it.
>
> The clone only happens if sk_psock_verdict_recv() returns >0.

Sure, in case of error, no one uses the original skb either,
so still need to free it.

>
> >
> > Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/ipv4/udp.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 15f5504adf5b..e31d67fd5183 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1798,11 +1798,13 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> >               if (used <= 0) {
> >                       if (!copied)
> >                               copied = used;
> > +                     kfree_skb(skb);
>
> This case is different from the TCP side, if there is an error
> the sockmap side will also call kfree_skb(). In TCP side we peek
> the skb because we don't want to drop it. On UDP side this will
> just drop data on the floor. Its not super friendly, but its
> UDP so we are making the assumption this is ok? We've tried
> to remove all the drop data cases from TCP it would be nice
> to not drop data on UDP side if we can help it. Could we
> requeue or peek the UDP skb to avoid this?

TCP is special because it supports splice() where we can
do a partial read, so it needs to peek the skb, right? UDP only
supports sockmap, where we always read a whole skb, so we
do not need to peek here?

Thanks.
