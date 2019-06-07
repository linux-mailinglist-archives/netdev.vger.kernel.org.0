Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DDA39346
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbfFGRb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:31:56 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36869 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731506AbfFGRby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 13:31:54 -0400
Received: by mail-lf1-f66.google.com with SMTP id m15so2223781lfh.4
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 10:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=3PplQV5+m1qokffMTO1dh4OfvdHHOPEnjKd0OoqlmW8=;
        b=WGDTdMwJrTO/Mlt6mYN3QQtz5vXkOi2UFA6REpQ4TxrE9dax35rKhCRl1raPDqeA9X
         tX+mkT0a8CPsIIwh2XFjCseyWLRjMtnm7X4em3YHWtD06/2fiYHaBbG6jcsF1z+numqp
         H5q62Rl9gxm697DfC3+l/8VvLXX6vx/XyWiyPScdk6sEjj5VMoXSfixjup7D2FfPEKiC
         KkHd5TjobLQ1r9kNB4F4cc1SSaxo9iefL3wV7mED2YbEWehPFNbLtgXY644PudhuBuK4
         R5r9EIUE2IU3y0itoYa2BDr13RiBXZqqrtIE8c9jWCxy2ZgFWq4PE0HWshsMQDE4IQXK
         Nk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=3PplQV5+m1qokffMTO1dh4OfvdHHOPEnjKd0OoqlmW8=;
        b=rotPR16rFGFKG7LTOM6QUs0hgdaGxo2/+tYZ2A3XFeQ77P1UDXsBtuUkeUw381aBn7
         dJAWoxeY0+91mWpsmLleoQls/Iwqtp4Etuuffj6kpGYzGY6tFjVGAlfOKxLziYoakJnb
         6yz6MXoKOO8ooFT0GJa++QuLLmiHg3tgdN9iKPdejwOmsUhQWdpJBuu5n3QF/UfwO+ed
         fFWCcJy7UnMZWLQM+g3tMzLzqy3xKZtxzGolo5VSltPcFWqekx/1UCzH56rzvJN+SVY1
         LhPxDX+n9TPJtvKKb5sVNK/dMzyzaqfVolJ155ELykYLswsFSnK+oNgpAmi+/k2ar4kT
         qDHg==
X-Gm-Message-State: APjAAAWfCK3wVK9U0zGfpRugdIbzPh6M2UXWqDbu/yk4mikWKu+94D4D
        b1x4Xn4Crmt9PRbLRPbpZNFOFMwMkA0QS+J+xpq+L2z9
X-Google-Smtp-Source: APXvYqzy0rncdPPTc28/7eqJBAfHsRB1deJkihDmnTvELfCQ8vc1eK5nE+EHUujhSXEDBzd9ktY8t9SGI6XgO+TF4wY=
X-Received: by 2002:a19:f00a:: with SMTP id p10mr18619073lfc.68.1559928712270;
 Fri, 07 Jun 2019 10:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190607172628.31471-1-sergej.benilov@googlemail.com>
In-Reply-To: <20190607172628.31471-1-sergej.benilov@googlemail.com>
From:   Sergej Benilov <sergej.benilov@googlemail.com>
Date:   Fri, 7 Jun 2019 19:31:40 +0200
Message-ID: <CAC9-QvCyZm10wrVd=6Z-9H-Y9mkb_e_4mkhs6KxGUEozy6BsVQ@mail.gmail.com>
Subject: Re: [PATCH] sis900: re-enable high throughput
To:     venza@brownhat.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jun 2019 at 19:26, Sergej Benilov
<sergej.benilov@googlemail.com> wrote:
>
> Since commit 605ad7f184b60cfaacbc038aa6c55ee68dee3c89 "tcp: refine TSO autosizing",
> the TSQ limit is computed as the smaller of
> sysctl_tcp_limit_output_bytes and max(2 * skb->truesize, sk->sk_pacing_rate >> 10).
> For some connections this approach sets a low limit, reducing throughput dramatically.
>
> Add a call to skb_orphan() to sis900_start_xmit()
> to speed up packets delivery from the kernel to the driver.
>
> Test:
> netperf -H remote -l -2000000 -- -s 1000000
>
> before patch:
>
> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to remote () port 0 AF_INET : demo
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
>
>  87380 327680 327680    341.79      0.05
>
> after patch:
>
> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to remote () port 0 AF_INET : demo
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
>
>  87380 327680 327680    1.29       12.54
>
> Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
> ---
>  drivers/net/ethernet/sis/sis900.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
> index fd812d2e..ca17b50c 100644
> --- a/drivers/net/ethernet/sis/sis900.c
> +++ b/drivers/net/ethernet/sis/sis900.c
> @@ -1604,6 +1604,7 @@ sis900_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
>         unsigned int  index_cur_tx, index_dirty_tx;
>         unsigned int  count_dirty_tx;
>
> +       skb_orphan(skb);
>         spin_lock_irqsave(&sis_priv->lock, flags);
>
>         /* Calculate the next Tx descriptor entry. */
> --
> 2.17.1
>

Thanks to Eric Dumazet for suggesting this patch
