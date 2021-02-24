Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D5E323915
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 09:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhBXIyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 03:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234604AbhBXIx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 03:53:59 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC85C061786
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 00:53:19 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id n195so1107078ybg.9
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 00:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BGwJ0SHFnCl5BWg2YtrAv0Cs7u3OxCrNO9fhAiDyyc0=;
        b=sI++S4ETsAzOHE1Ik9dxQNVCfXfwgtiZoyvMOVvSERvzvyvLkk+1KJTj08NYT8Awrq
         mDvMPaqTS/XQop0MEqVKk/CI7p690Rp3cdkqt9MZBSpXl2cQ+SQAquMEBI56pMje4cIK
         sxtQDhChAjn47HWlLgXaQIZSkQ6kCFPcvYTa0fDzCYG8/EWhUlvpPFklNr7W170/0Q11
         cc+WIRo6e8Bt3FT8dPbLnheeuMn1CoIgzTanRe/m+CgwzHTWb+cwMLVql27ggg0ux+PL
         rr/C5JwvZx3DlT7Y2gZkBjFro3xQoJD+W76Muh44QAUCPeKkScIOtHSnmU5RmLNOGwaz
         rhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BGwJ0SHFnCl5BWg2YtrAv0Cs7u3OxCrNO9fhAiDyyc0=;
        b=nBHaMFt0sMoTpFw1x6uGGSz0l50x6e1Xm6VCDls39CTVLwAWpGIyHDqadMrlm4idQ/
         SW6NgCimXQd19icYMTJwj8Up3H8jw3dFYLHqMLoJLnieMTIjGrIoFoXgD94YsBPNothm
         XnV0bP0HFa6ktJgX0SGoJ8SE79ZzS+9dfK68M4nIbb1gfC5p9rPpNmlQaFcZU8g+wIg8
         I7ORLROrkZwoV+FJpNz/8l51jk1ILsBNDTmlcPuF28Sh/QrtHrFYYVDdXXMOQD9W0QI1
         IpDu3OcP6GuC04M1e9VzbPEjWOu8qRR+Ht4K6xXdV4ZclvnBxY4qjZ3SZa5iPsfz4I56
         P/GQ==
X-Gm-Message-State: AOAM530ExyxicssmhMHt870j5a/EMuYv3cAOnEpSpskzB8m2ULYnGBe7
        6jdW8oUF6luMGqjtNe6Xq1y8l9tXPHejT3Ric/YB7w==
X-Google-Smtp-Source: ABdhPJxjLulVroVfrHz8PIwjnx4bI6Q5vq/R8DvUGLL3tRfTN3KlsvS6H006ilRb7ikZXP92VZ5FwaNg+UfrHQ/zvHE=
X-Received: by 2002:a25:1d88:: with SMTP id d130mr47638433ybd.446.1614156798239;
 Wed, 24 Feb 2021 00:53:18 -0800 (PST)
MIME-Version: 1.0
References: <20210224075932.20234-1-o.rempel@pengutronix.de>
In-Reply-To: <20210224075932.20234-1-o.rempel@pengutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 24 Feb 2021 09:53:06 +0100
Message-ID: <CANn89iLEHpCphH8vKd=0BS7pgdP1YZDGqQfQPeGBkD09RoHtzg@mail.gmail.com>
Subject: Re: [PATCH net v3 1/1] can: can_skb_set_owner(): fix ref counting if
 socket was closed before setting skb ownership
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        Andre Naujoks <nautsch2@gmail.com>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 8:59 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> There are two ref count variables controlling the free()ing of a socket:
> - struct sock::sk_refcnt - which is changed by sock_hold()/sock_put()
> - struct sock::sk_wmem_alloc - which accounts the memory allocated by
>   the skbs in the send path.
>
> In case there are still TX skbs on the fly and the socket() is closed,
> the struct sock::sk_refcnt reaches 0. In the TX-path the CAN stack
> clones an "echo" skb, calls sock_hold() on the original socket and
> references it. This produces the following back trace:
>
> | WARNING: CPU: 0 PID: 280 at lib/refcount.c:25 refcount_warn_saturate+0x114/0x134
> | refcount_t: addition on 0; use-after-free.
> | Modules linked in: coda_vpu(E) v4l2_jpeg(E) videobuf2_vmalloc(E) imx_vdoa(E)
> | CPU: 0 PID: 280 Comm: test_can.sh Tainted: G            E     5.11.0-04577-gf8ff6603c617 #203
> | Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> | Backtrace:
> | [<80bafea4>] (dump_backtrace) from [<80bb0280>] (show_stack+0x20/0x24) r7:00000000 r6:600f0113 r5:00000000 r4:81441220
> | [<80bb0260>] (show_stack) from [<80bb593c>] (dump_stack+0xa0/0xc8)
> | [<80bb589c>] (dump_stack) from [<8012b268>] (__warn+0xd4/0x114) r9:00000019 r8:80f4a8c2 r7:83e4150c r6:00000000 r5:00000009 r4:80528f90
> | [<8012b194>] (__warn) from [<80bb09c4>] (warn_slowpath_fmt+0x88/0xc8) r9:83f26400 r8:80f4a8d1 r7:00000009 r6:80528f90 r5:00000019 r4:80f4a8c2
> | [<80bb0940>] (warn_slowpath_fmt) from [<80528f90>] (refcount_warn_saturate+0x114/0x134) r8:00000000 r7:00000000 r6:82b44000 r5:834e5600 r4:83f4d540
> | [<80528e7c>] (refcount_warn_saturate) from [<8079a4c8>] (__refcount_add.constprop.0+0x4c/0x50)
> | [<8079a47c>] (__refcount_add.constprop.0) from [<8079a57c>] (can_put_echo_skb+0xb0/0x13c)
> | [<8079a4cc>] (can_put_echo_skb) from [<8079ba98>] (flexcan_start_xmit+0x1c4/0x230) r9:00000010 r8:83f48610 r7:0fdc0000 r6:0c080000 r5:82b44000 r4:834e5600
> | [<8079b8d4>] (flexcan_start_xmit) from [<80969078>] (netdev_start_xmit+0x44/0x70) r9:814c0ba0 r8:80c8790c r7:00000000 r6:834e5600 r5:82b44000 r4:82ab1f00
> | [<80969034>] (netdev_start_xmit) from [<809725a4>] (dev_hard_start_xmit+0x19c/0x318) r9:814c0ba0 r8:00000000 r7:82ab1f00 r6:82b44000 r5:00000000 r4:834e5600
> | [<80972408>] (dev_hard_start_xmit) from [<809c6584>] (sch_direct_xmit+0xcc/0x264) r10:834e5600 r9:00000000 r8:00000000 r7:82b44000 r6:82ab1f00 r5:834e5600 r4:83f27400
> | [<809c64b8>] (sch_direct_xmit) from [<809c6c0c>] (__qdisc_run+0x4f0/0x534)
>
> To fix this problem, only set skb ownership to sockets which have still
> a ref count > 0.
>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Andre Naujoks <nautsch2@gmail.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Fixes: 0ae89beb283a ("can: add destructor for self generated skbs")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

SGTM

Reviewed-by: Eric Dumazet <edumazet@google.com>

> ---
>  include/linux/can/skb.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
> index 685f34cfba20..655f33aa99e3 100644
> --- a/include/linux/can/skb.h
> +++ b/include/linux/can/skb.h
> @@ -65,8 +65,7 @@ static inline void can_skb_reserve(struct sk_buff *skb)
>
>  static inline void can_skb_set_owner(struct sk_buff *skb, struct sock *sk)
>  {
> -       if (sk) {
> -               sock_hold(sk);
> +       if (sk && refcount_inc_not_zero(&sk->sk_refcnt)) {
>                 skb->destructor = sock_efree;
>                 skb->sk = sk;
>         }
> --
> 2.29.2
>
