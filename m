Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44286184E84
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgCMSV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:21:28 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35583 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbgCMSV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:21:28 -0400
Received: by mail-ot1-f65.google.com with SMTP id k26so11153998otr.2
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 11:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jvgie+98XAcLUZjmK0gZL1xK29t5iJQ3boxdpV5AHJA=;
        b=XZlmJ0Et5y8dK3d1HO77b44fE2JL3KYXvJgxn/YVtvlarSYnW+VTwMMvwA5SMX7Jv7
         AvyuMlkAdhzOr28C/pFoABEBk2KzWBRPTB1WxT7Jby6exPXRvXOqd8Y4Nnks6/I0rxoC
         GEO2lI7sz9GVS5nkcY0EH/EOIC3tehOcuwi0hGOnxS2XN3jpLAiH1Q7l3u9DPnjyO+0k
         Df21puGyuBcijp/t6hnElZY7heW5DNI6dD6O56RkDintB4XigNgvJEQSayQRBaLJA9ks
         AYu/GdnRbiEH1oovahiH9vL2niengHYD3DMF4l9Gx0r58SkihDyO3dB6d2IC9VFkwV/H
         Hq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jvgie+98XAcLUZjmK0gZL1xK29t5iJQ3boxdpV5AHJA=;
        b=h6M9L/ujLyLvs0RX0lBIf8AbSLnRWX7KA9Gm1uULt+0lud+OuuC41arIkeBdTB/cW/
         1JL4TCa+OUoa5Ufv+Va61zJ4RaZTggO/MlcY2tXF5uv4nW1eJJCmxMXk4gkCTr8y2iRP
         RTgn2Pq1v+QGC+vwmgZVd+WknxViuR7+egNsVO+lpNIvzr++w4FUqvuBPXuoUxlvehek
         uPG85wwJ3VSTsWAgaeZkqTN2pHTgYiy+Vydr9sm32MyNjeL9DZIjajcvkRSfBWzB//AX
         Onqlenx3I4xGO8oFR4dGJSSk4jqwHjLhS1maYBUiAT+50W4tBWos6Bqn2uaa/3/OIlb8
         f7eQ==
X-Gm-Message-State: ANhLgQ1HXdfKvlR/KjDe/x5lSkDXf7IsdQ8uGnBK3GFS3JMBo7MDrc6v
        pm20pSyoOq/iqXNq2IOFlU922tRtUZTOjWRMpDnM6t+JYUc=
X-Google-Smtp-Source: ADFU+vsMMhTEiRFy4i4QsT4zCg4kUOXFXQLAJyH9jr7excPcVLGOVZYbuGL/xpP1CRd7LgJDT9nTN63GW7+XMEMjFSI=
X-Received: by 2002:a9d:7a47:: with SMTP id z7mr12901647otm.341.1584123685942;
 Fri, 13 Mar 2020 11:21:25 -0700 (PDT)
MIME-Version: 1.0
References: <1584118044-9798-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1584118044-9798-1-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 13 Mar 2020 14:21:03 -0400
Message-ID: <CADVnQymxAXO038MONZKTR3HxaVNANRL_BtQzhgUXefr5zr1czQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] tcp: fix stretch ACK bugs in BIC
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 12:48 PM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> Neal Cardwell submits a series of patches to handle stretched ACKs,
> which start with commit e73ebb0881ea ("tcp: stretch ACK fixes prep").
>
> This patch changes BIC to properly handle stretch ACKs in additive
> increase mode by passing in the count of ACKed packets to
> tcp_cong_avoid_ai().
>
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---
>  net/ipv4/tcp_bic.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/tcp_bic.c b/net/ipv4/tcp_bic.c
> index 645cc30..f5f588b 100644
> --- a/net/ipv4/tcp_bic.c
> +++ b/net/ipv4/tcp_bic.c
> @@ -145,12 +145,13 @@ static void bictcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
>         if (!tcp_is_cwnd_limited(sk))
>                 return;
>
> -       if (tcp_in_slow_start(tp))
> -               tcp_slow_start(tp, acked);
> -       else {
> -               bictcp_update(ca, tp->snd_cwnd);
> -               tcp_cong_avoid_ai(tp, ca->cnt, 1);
> +       if (tcp_in_slow_start(tp)) {
> +               acked = tcp_slow_start(tp, acked);
> +               if (!acked)
> +                       return;
>         }
> +       bictcp_update(ca, tp->snd_cwnd);
> +       tcp_cong_avoid_ai(tp, ca->cnt, acked);
>  }
>
>  /*
> --

Acked-by: Neal Cardwell <ncardwell@google.com>

thanks,
neal
