Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7EE732E7A7
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 13:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhCEMI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 07:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCEMH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 07:07:58 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FE1C061574;
        Fri,  5 Mar 2021 04:07:58 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 18so1981995pfo.6;
        Fri, 05 Mar 2021 04:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0T4sYjk3wRZzjG/QHAIvuP6rKIH4m6dqz5ONCAsok4U=;
        b=X9aYOJ2QUP2xz10GjaNI2tVnTar2w3YTbJkB56nhZ43TCzh4a0g4Kb7e8XS9lECzRG
         5BaePC2mMQk+/MQRKX0PGp2vpm3tkiA22y8AwJYIjs3X5Cb4tNKARktq6vkbAHcZpEGN
         Yzk5DU2q50UwaF4xlEagNR7sQDl2vsDpaI8MGk1LmIkxSUhGnzkBfiJdIPSD9YjZnyNa
         z1YfGjVkMVdCuwArFbDgpglD2TbV+2yMdfo6kvoEVGfKh5rKlrEnJMFxbOfCvicuiisY
         RNMr4au0QQrZJcaf6eXQcZQnCjd/vxDr+cnEu0ELaz6rMPx2rCf8B1ya358Qg+QSuTmv
         x0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0T4sYjk3wRZzjG/QHAIvuP6rKIH4m6dqz5ONCAsok4U=;
        b=TCto31YS7EouOtTyaWmRb/iuEU2nWAU08BaO+DE+yXb0BRGAyn2CippMV51mMot/sO
         kDEZvJONg/qwXLJZHCE4P/Cv95X8qIyyr0Aag8vHveDE4BdzqBn3Sq4RdUMAsXTTSS0j
         64oM9NcP0s9BgPqi+RJPu6wmyPyLwZPiw2oX381zFoaxNoxa/AbyjvkFJKvRDqiNLQxc
         YloSSxnECuVXcMtPReDHt92qByZCWwBZw7WjrZXMygX8/h46zqV4y6u3l4fW2Fj8+qVp
         dGs0sWCIeOyu7dlG5h3FYkb81YDlIOasebj8LvrC21oTpmDuDuRnh78ypy//LAUqya1t
         d6tQ==
X-Gm-Message-State: AOAM530CDL6FJxKh+8Vk/FQNKaSZFbkf2pg2fXjtutmqUcNu/wIrDJCq
        WkmzaJqI7eKHhFpF6Ix1R+9UGZ5e26nqxgmwk3I=
X-Google-Smtp-Source: ABdhPJwjqsfLw9ru8YkR/RGYr2KWgaGsQwQO4QmzMmJdg8R1OETnAH+U7oEtzJZBjg7l8BXUO4IWnv00awnX5hCZTkU=
X-Received: by 2002:a63:1906:: with SMTP id z6mr8464802pgl.292.1614946078278;
 Fri, 05 Mar 2021 04:07:58 -0800 (PST)
MIME-Version: 1.0
References: <20210305092534.13121-1-baijiaju1990@gmail.com>
In-Reply-To: <20210305092534.13121-1-baijiaju1990@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 5 Mar 2021 13:07:47 +0100
Message-ID: <CAJ8uoz3dkGsnMQ5wnFmyyFVfkMrz8Z2pqPZ+frFXj=Sy72xpcw@mail.gmail.com>
Subject: Re: [PATCH] net: xdp: fix error return code of xsk_generic_xmit()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 10:28 AM Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>
> When err is zero but xskq_prod_reserve() fails, no error return code of
> xsk_generic_xmit() is assigned.
> To fix this bug, err is assigned with the return value of
> xskq_prod_reserve(), and then err is checked.

This error is ignored by design. This so that the zero-copy path and
the copy/skb path will return the same value (success in this case)
when the completion ring does not have a spare entry we can put the
future completion in. The problem lies with the zero-copy path that is
asynchronous, in contrast to the skb path that is synchronous. The
zero-copy path cannot return an error when this happens as this
reservation in the completion ring is performed by the driver that
might concurrently run on another core without any way to feed this
back to the syscall that does not wait for the driver to execute in
any case. Introducing a return value for this condition right now for
the skb case, might break existing applications.

Though it would be really good if you could submit a small patch to
bpf-next that adds a comment explaining this to avoid any future
confusion. Something along the lines of: /* The error code of
xskq_prod_reserve is ignored so that skb mode will mimic the same
behavior as zero-copy mode that does not signal an error in this case
as it cannot. */. You could put it right after the if statement.

Thank you: Magnus

> The spinlock is only used to protect the call to xskq_prod_reserve().
>
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  net/xdp/xsk.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 4faabd1ecfd1..f1c1db07dd07 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -484,8 +484,14 @@ static int xsk_generic_xmit(struct sock *sk)
>                  * if there is space in it. This avoids having to implement
>                  * any buffering in the Tx path.
>                  */
> +               if (unlikely(err)) {
> +                       kfree_skb(skb);
> +                       goto out;
> +               }
> +
>                 spin_lock_irqsave(&xs->pool->cq_lock, flags);
> -               if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> +               err = xskq_prod_reserve(xs->pool->cq);
> +               if (unlikely(err)) {
>                         spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>                         kfree_skb(skb);
>                         goto out;
> --
> 2.17.1
>
