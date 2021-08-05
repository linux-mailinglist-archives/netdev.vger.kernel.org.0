Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB5C3E1C20
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242224AbhHETHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241406AbhHETHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:07:13 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83553C061765;
        Thu,  5 Aug 2021 12:06:59 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id c137so10403270ybf.5;
        Thu, 05 Aug 2021 12:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LuHXKdr41otBPVM2gg/1dOJSL5potWIuI6htGDgGDKQ=;
        b=ICf0PMtbjQGAdbzhpc75k0eb0oyEiwVD6U21ACued/xRcWDf9KOBPSlM/lGLa3aorH
         118AVyXqraqmCITuwKqwgLoaovjbQGOgDi4bYOX/3CiQBAdZ3CR94usv9jlj/E3I+xoJ
         xuODAv9OmhDIu+ZZVN2RbzA/BVgfabK82oAzMqpa6e0yN7LumLW5ex+IdK7YMRsrXv1H
         jdS3HbEahE2lkb4V/AHm4cJ6HMw/1BKKAm3ayg+DLT30SHKRsg0+A/QlVMfssuxdOWcz
         5PfN7dNM5K3lk1TzLvLZ3ErWF9GAuWxg59nrY0R92J5IkIx+d5M7mBjwzdGIWgM7EUQx
         Qifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LuHXKdr41otBPVM2gg/1dOJSL5potWIuI6htGDgGDKQ=;
        b=hjlSe86Fco7OuOf1tDompG4KBRCQNAyhe0yfilHcXaY652Eqt1rCuI2zb907LRhCk6
         u9FAaixR/rJf9EVeUkncsJJ0ZQ8dWEiv4mwSrf7oOS2yeCpZpiDJTTP5chNI3FemmB22
         wjLTcJBNTbb2Osn7Zp1CEJmfQVIp4S5guB9YhmOQ0E9ecCgfSvDP9K7j0M85dsYUPLLG
         K85qFvFMdqYwc8oXkE0oLIg+/aP8wpA2eqxfPxiZUmMeT9/h1ncQlEL/RDmDCP+Wmm8M
         /IZRVvTcHKmF5RwQnMc8Y9pa72+Avn6jM7O78OashF6/cmhU5NSQ2fNcIbn7Jf6JZsva
         Kxmw==
X-Gm-Message-State: AOAM531clCc4AzUDm9NdesHPExLudajcGpqntCj4SCWMnq9pf4jO7527
        GA/NW1LZCtzUJZBCSScwqczF4Sc3L0JL+hqEUZY=
X-Google-Smtp-Source: ABdhPJz0gfmBCUEliNsEVULa3oJqIIZ2cbDdYe0uE92esELwKo8D0MOprxvCnPsAOwdEx/cR1xU+qAaWz00wrj6n9/Y=
X-Received: by 2002:a25:9b03:: with SMTP id y3mr7123064ybn.264.1628190418769;
 Thu, 05 Aug 2021 12:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210804154712.929986-1-desmondcheongzx@gmail.com> <20210804154712.929986-2-desmondcheongzx@gmail.com>
In-Reply-To: <20210804154712.929986-2-desmondcheongzx@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 5 Aug 2021 12:06:47 -0700
Message-ID: <CABBYNZ+5-wEyLJDUU0fC3fogAkJiXD+8np_8c_M0yfYZVUYbww@mail.gmail.com>
Subject: Re: [RESEND PATCH v5 1/6] Bluetooth: schedule SCO timeouts with delayed_work
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, sudipm.mukherjee@gmail.com,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Desmond,

On Wed, Aug 4, 2021 at 8:48 AM Desmond Cheong Zhi Xi
<desmondcheongzx@gmail.com> wrote:
>
> struct sock.sk_timer should be used as a sock cleanup timer. However,
> SCO uses it to implement sock timeouts.
>
> This causes issues because struct sock.sk_timer's callback is run in
> an IRQ context, and the timer callback function sco_sock_timeout takes
> a spin lock on the socket. However, other functions such as
> sco_conn_del and sco_conn_ready take the spin lock with interrupts
> enabled.
>
> This inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock usage could
> lead to deadlocks as reported by Syzbot [1]:
>        CPU0
>        ----
>   lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>   <Interrupt>
>     lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>
> To fix this, we use delayed work to implement SCO sock timouts
> instead. This allows us to avoid taking the spin lock on the socket in
> an IRQ context, and corrects the misuse of struct sock.sk_timer.
>
> As a note, cancel_delayed_work is used instead of
> cancel_delayed_work_sync in sco_sock_set_timer and
> sco_sock_clear_timer to avoid a deadlock. In the future, the call to
> bh_lock_sock inside sco_sock_timeout should be changed to lock_sock to
> synchronize with other functions using lock_sock. However, since
> sco_sock_set_timer and sco_sock_clear_timer are sometimes called under
> the locked socket (in sco_connect and __sco_sock_close),
> cancel_delayed_work_sync might cause them to sleep until an
> sco_sock_timeout that has started finishes running. But
> sco_sock_timeout would also sleep until it can grab the lock_sock.
>
> Using cancel_delayed_work is fine because sco_sock_timeout does not
> change from run to run, hence there is no functional difference
> between:
> 1. waiting for a timeout to finish running before scheduling another
> timeout
> 2. scheduling another timeout while a timeout is running.
>
> Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]
> Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
> Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
> ---
>  net/bluetooth/sco.c | 41 +++++++++++++++++++++++++++++++++++------
>  1 file changed, 35 insertions(+), 6 deletions(-)
>
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index ffa2a77a3e4c..89cb987ca9eb 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -48,6 +48,8 @@ struct sco_conn {
>         spinlock_t      lock;
>         struct sock     *sk;
>
> +       struct delayed_work     timeout_work;
> +
>         unsigned int    mtu;
>  };
>
> @@ -74,9 +76,20 @@ struct sco_pinfo {
>  #define SCO_CONN_TIMEOUT       (HZ * 40)
>  #define SCO_DISCONN_TIMEOUT    (HZ * 2)
>
> -static void sco_sock_timeout(struct timer_list *t)
> +static void sco_sock_timeout(struct work_struct *work)
>  {
> -       struct sock *sk = from_timer(sk, t, sk_timer);
> +       struct sco_conn *conn = container_of(work, struct sco_conn,
> +                                            timeout_work.work);
> +       struct sock *sk;
> +
> +       sco_conn_lock(conn);
> +       sk = conn->sk;
> +       if (sk)
> +               sock_hold(sk);
> +       sco_conn_unlock(conn);
> +
> +       if (!sk)
> +               return;
>
>         BT_DBG("sock %p state %d", sk, sk->sk_state);
>
> @@ -91,14 +104,27 @@ static void sco_sock_timeout(struct timer_list *t)
>
>  static void sco_sock_set_timer(struct sock *sk, long timeout)
>  {
> +       struct delayed_work *work;

Minor nitpick but I don't think using a dedicated variable here makes
much sense.

> +       if (!sco_pi(sk)->conn)
> +               return;
> +       work = &sco_pi(sk)->conn->timeout_work;
> +
>         BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
> -       sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
> +       cancel_delayed_work(work);
> +       schedule_delayed_work(work, timeout);
>  }
>
>  static void sco_sock_clear_timer(struct sock *sk)
>  {
> +       struct delayed_work *work;

Ditto.

> +       if (!sco_pi(sk)->conn)
> +               return;
> +       work = &sco_pi(sk)->conn->timeout_work;
> +
>         BT_DBG("sock %p state %d", sk, sk->sk_state);
> -       sk_stop_timer(sk, &sk->sk_timer);
> +       cancel_delayed_work(work);
>  }
>
>  /* ---- SCO connections ---- */
> @@ -179,6 +205,9 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
>                 bh_unlock_sock(sk);
>                 sco_sock_kill(sk);
>                 sock_put(sk);
> +
> +               /* Ensure no more work items will run before freeing conn. */
> +               cancel_delayed_work_sync(&conn->timeout_work);
>         }
>
>         hcon->sco_data = NULL;
> @@ -193,6 +222,8 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
>         sco_pi(sk)->conn = conn;
>         conn->sk = sk;
>
> +       INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
> +
>         if (parent)
>                 bt_accept_enqueue(parent, sk, true);
>  }
> @@ -500,8 +531,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
>
>         sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
>
> -       timer_setup(&sk->sk_timer, sco_sock_timeout, 0);
> -
>         bt_sock_link(&sco_sk_list, sk);
>         return sk;
>  }
> --
> 2.25.1
>


-- 
Luiz Augusto von Dentz
