Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DAA322750
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 09:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhBWI4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 03:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbhBWI4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 03:56:37 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9882C061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 00:55:56 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id n195so15709115ybg.9
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 00:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lB/a4iMwzZXCVzQKA/wFs+7TeUdvCzpHO2+5MvW6yfU=;
        b=ANVQQS+Usc9OSyEkwQ0rKjoeqmy7t/RkfPSQKW/yfFbEW/2mjzUT2ghPUfiGN9I2Jw
         9298v+5cbHBiGasuLAljXkJs/uhAJ/PUbY1XwN/N34AeVliE087Dn3tXfXk2a66KMlbc
         vFv9gzp0rrpMDG1SHaPr+d78Y/64WEVObZjszfGmUK2pODzXOFa+ISUpkk4yBsBVSltI
         G3o47TvPg53VtBu4HPd397hYtKz1ejg4+SsRIYpHFLusNfauZg52IjGzxHwCaXrSzQCQ
         V1WCXwXMnr0MHh+yLbHGoC7RMKoz3VX9F4QCQYZWgqhzFp/LjEPwH5hyxZYO824Zr+GE
         jFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lB/a4iMwzZXCVzQKA/wFs+7TeUdvCzpHO2+5MvW6yfU=;
        b=YoJULkfVFUP70kCjOLUceo02rfzlek7UBAJxIS2WR6t3eGByWVOfkdgTlYqVpV40aT
         6vcSgnmkS0qV+SszsOiMZDFsZgYJHbMAo6iIyzvVDP2qrBTonejDh21lrQVCCiJnWWFb
         zESv3aNs5333q7w60soAgvwG2OKoR2gm5Low2kfSUGGUnmlHuf/G5uyppgSWU/qArbEt
         ZbYcDzQc7FXqCr+pQ3Z9qgsRSE3l449U2ScjPqA9A5jOAfWlH31/A6MdBndbLCe5H6gQ
         ThNRCukuphZwBrLLpbJRIM2Ds70rK1hb90XoNSua2wiEfuxEc1tXELqx/7CFu26CuE2C
         ZVMA==
X-Gm-Message-State: AOAM531okQMChXqucvR6vCXRUcfybo27qzuE+tTrPTLCY+UkMbnz/ybY
        kNQbUiQ04PASbgRigt4bujoc1xKql0Rfu1Wf4BHbKA==
X-Google-Smtp-Source: ABdhPJxiG98x7BOMr2s35CNt0d3MmkzHRwBqlPjTMbVGbt3kdfqoekbd94XMkb7+6aAZ3Vii4t6Zl4vrWx9AEn4pVDg=
X-Received: by 2002:a25:7306:: with SMTP id o6mr39702181ybc.132.1614070555696;
 Tue, 23 Feb 2021 00:55:55 -0800 (PST)
MIME-Version: 1.0
References: <20210223055321.3891-1-o.rempel@pengutronix.de> <20210223055321.3891-3-o.rempel@pengutronix.de>
In-Reply-To: <20210223055321.3891-3-o.rempel@pengutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 23 Feb 2021 09:55:43 +0100
Message-ID: <CANn89iJp6PeiJOQSnsXGRJBVmQ8QR1mNF=cHMnGMrg0J=UmPHQ@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] can: fix ref count warning if socket was
 closed before skb was cloned
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andre Naujoks <nautsch2@gmail.com>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 6:53 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> There are two ref count variables controlling the free()ing of a socket:
> - struct sock::sk_refcnt - which is changed by sock_hold()/sock_put()
> - struct sock::sk_wmem_alloc - which accounts the memory allocated by
>   the skbs in the send path.
>
> If the socket is closed the struct sock::sk_refcnt will finally reach 0
> and sk_free() is called. Which then calls
> refcount_dec_and_test(&sk->sk_wmem_alloc). If sk_wmem_alloc reaches 0
> the socket is actually free()ed.
>
> In case there are still TX skbs on the fly and the socket() is closed,
> the struct sock::sk_refcnt reaches 0. In the TX-path the CAN stack
> clones an "echo" skb, calls sock_hold() on the original socket and
> references it. This produces the following back trace:

Why not simply fix can_skb_set_owner() instead of adding yet another helper ?

diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index 685f34cfba20741d372d340fe7df1084767b2850..655f33aa99e330b8ffc804b0f3a1d61aa9b00b0b
100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -65,8 +65,7 @@ static inline void can_skb_reserve(struct sk_buff *skb)

 static inline void can_skb_set_owner(struct sk_buff *skb, struct sock *sk)
 {
-       if (sk) {
-               sock_hold(sk);
+       if (sk && refcount_inc_not_zero(&sk->sk_refcnt)) {
                skb->destructor = sock_efree;
                skb->sk = sk;
        }

IMO, CAN seems to use sock_hold() even for tx packets.

But tx packets usually have a reference on sockets based on sk->sk_wmem_alloc ,
look at skb_set_owner_w() for reference.

This might be the reason why you catch a zero sk_refcnt while packets
are still in flight ?



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
> To fix this problem, we have to take into account, that the socket
> technically still there but should not used (by any new skbs) any more.
> The function skb_clone_sk_optional() (introduced in the previous patch)
> takes care of this. It will only clone the skb, if the sk is set and the
> refcount has not reached 0.
>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Andre Naujoks <nautsch2@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Fixes: 0ae89beb283a ("can: add destructor for self generated skbs")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  include/linux/can/skb.h   | 3 +--
>  net/can/af_can.c          | 6 +++---
>  net/can/j1939/main.c      | 3 +--
>  net/can/j1939/socket.c    | 3 +--
>  net/can/j1939/transport.c | 4 +---
>  5 files changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
> index 685f34cfba20..bc1af38697a2 100644
> --- a/include/linux/can/skb.h
> +++ b/include/linux/can/skb.h
> @@ -79,13 +79,12 @@ static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
>  {
>         struct sk_buff *nskb;
>
> -       nskb = skb_clone(skb, GFP_ATOMIC);
> +       nskb = skb_clone_sk_optional(skb);
>         if (unlikely(!nskb)) {
>                 kfree_skb(skb);
>                 return NULL;
>         }
>
> -       can_skb_set_owner(nskb, skb->sk);
>         consume_skb(skb);
>         return nskb;
>  }
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index cce2af10eb3e..9e1bd60e7e1b 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -251,20 +251,20 @@ int can_send(struct sk_buff *skb, int loop)
>                  * its own. Example: can_raw sockopt CAN_RAW_RECV_OWN_MSGS
>                  * Therefore we have to ensure that skb->sk remains the
>                  * reference to the originating sock by restoring skb->sk
> -                * after each skb_clone() or skb_orphan() usage.
> +                * after each skb_clone() or skb_orphan() usage -
> +                * skb_clone_sk_optional() takes care of that.
>                  */
>
>                 if (!(skb->dev->flags & IFF_ECHO)) {
>                         /* If the interface is not capable to do loopback
>                          * itself, we do it here.
>                          */
> -                       newskb = skb_clone(skb, GFP_ATOMIC);
> +                       newskb = skb_clone_sk_optional(skb);
>                         if (!newskb) {
>                                 kfree_skb(skb);
>                                 return -ENOMEM;
>                         }
>
> -                       can_skb_set_owner(newskb, skb->sk);
>                         newskb->ip_summed = CHECKSUM_UNNECESSARY;
>                         newskb->pkt_type = PACKET_BROADCAST;
>                 }
> diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
> index da3a7a7bcff2..4f6852d48077 100644
> --- a/net/can/j1939/main.c
> +++ b/net/can/j1939/main.c
> @@ -47,12 +47,11 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
>          * the header goes into sockaddr.
>          * j1939 may not touch the incoming skb in such way
>          */
> -       skb = skb_clone(iskb, GFP_ATOMIC);
> +       skb = skb_clone_sk_optional(iskb);
>         if (!skb)
>                 return;
>
>         j1939_priv_get(priv);
> -       can_skb_set_owner(skb, iskb->sk);
>
>         /* get a pointer to the header of the skb
>          * the skb payload (pointer) is moved, so that the next skb_data
> diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> index 4e4a510d82f9..c1be6c26ff76 100644
> --- a/net/can/j1939/socket.c
> +++ b/net/can/j1939/socket.c
> @@ -305,12 +305,11 @@ static void j1939_sk_recv_one(struct j1939_sock *jsk, struct sk_buff *oskb)
>         if (!j1939_sk_recv_match_one(jsk, oskcb))
>                 return;
>
> -       skb = skb_clone(oskb, GFP_ATOMIC);
> +       skb = skb_clone_sk_optional(oskb);
>         if (!skb) {
>                 pr_warn("skb clone failed\n");
>                 return;
>         }
> -       can_skb_set_owner(skb, oskb->sk);
>
>         skcb = j1939_skb_to_cb(skb);
>         skcb->msg_flags &= ~(MSG_DONTROUTE);
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index e09d087ba240..e902557bbe17 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -1014,12 +1014,10 @@ static int j1939_simple_txnext(struct j1939_session *session)
>         if (!se_skb)
>                 return 0;
>
> -       skb = skb_clone(se_skb, GFP_ATOMIC);
> +       skb = skb_clone_sk_optional(se_skb);
>         if (!skb)
>                 return -ENOMEM;
>
> -       can_skb_set_owner(skb, se_skb->sk);
> -
>         j1939_tp_set_rxtimeout(session, J1939_SIMPLE_ECHO_TIMEOUT_MS);
>
>         ret = j1939_send_one(priv, skb);
> --
> 2.29.2
>
