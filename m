Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B3C3D6B0D
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 02:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhGZXt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 19:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbhGZXtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 19:49:53 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC67C061757;
        Mon, 26 Jul 2021 17:30:20 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id k65so13189897yba.13;
        Mon, 26 Jul 2021 17:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WlahV91siRimjn5Od4QMmgRdTNqfaI93h5YP2ufAleM=;
        b=bRRDCCRM8Ysc/7n8ReGL7u0AZT6YqOT90xC4edP0CLn9VnnVFxzKJTY+nfBRtYZo+7
         fkNyQ/On/WId3txLmG5Lw4YuqaAAvAvUc1hcAsGQUfhkUd2tuQBMJuiAXdolDAswX9WT
         O+XaP8eKp0EcvzsoaH6LOZt5/AwckAt3RXDlHqJH9RSc2xyC12nOO6OYNpS4difxYyHY
         RpB85toIYVM7AxfOUwaShKbkBUsEqt3mcrVOCk1jB6w/0OVpmG+e9uG3zKQHFbeZB+vo
         gspifWERbt31O4wtJeqVNxgaQxupY5TUqHeq5i+JErPIKZ4aGknytJ3lzryKAGfnw7HQ
         F5nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WlahV91siRimjn5Od4QMmgRdTNqfaI93h5YP2ufAleM=;
        b=PV/RzWzMG1aqZ/G4QIPvMu15APdK3h1VFon4299I4Yfv+ivArg1LgOSGv8s4pe9DTp
         vCMOSzpMk/ODTtOfp2fumdFT8r4Ae0x6u26LDR6Yg3QPajMVCT+icp4OA/D74Rbuo8xs
         H2R319K2hpDKYtpgDSdHLddt2tcTvQD2lP0fCgIN4iTq/DPe9UGRO4ctK+NY/8gTJSq8
         GU4gu/Ooeq36XDGs6qOHORp37Yiet16WNyZYGD90FL346JLHB8jAO2tbHvqDhGBKnAt/
         VMVmsfVkcgQjA7dX83CEQv3KPYzuiSHeLW7H6ij48DqPpW2sJ41xP94lofnCkGsB9+kP
         tONQ==
X-Gm-Message-State: AOAM530gbHw3zokM0SSsHE3UzqHh655KbIV3kj4y4qs+4QDY810M4ZM3
        0zERmFJ/lQtxjfkSH98JsDv2dlGaqPf3vZNDRjI=
X-Google-Smtp-Source: ABdhPJxZXKGNSaIrmlXFd3lcCt8NDgz2o2kpO2hUE/I853+pYfA0WyPWplCnDd23A21flqbjJWotxIXUBVpOWxpK1xk=
X-Received: by 2002:a25:8205:: with SMTP id q5mr27524628ybk.440.1627345819451;
 Mon, 26 Jul 2021 17:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210721093832.78081-1-desmondcheongzx@gmail.com> <20210721093832.78081-2-desmondcheongzx@gmail.com>
In-Reply-To: <20210721093832.78081-2-desmondcheongzx@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 26 Jul 2021 17:30:08 -0700
Message-ID: <CABBYNZLus8GyPuTp4jmAeSEdsYTZ-4gK6OvGXqcABhci8tBOwA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Bluetooth: fix inconsistent lock state in SCO
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, matthieu.baerts@tessares.net,
        stefan@datenfreihafen.org,
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

On Wed, Jul 21, 2021 at 2:39 AM Desmond Cheong Zhi Xi
<desmondcheongzx@gmail.com> wrote:
>
> Syzbot reported an inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock
> usage in sco_conn_del and sco_sock_timeout that could lead to
> deadlocks.
>
> This inconsistent lock state can also happen in sco_conn_ready,
> rfcomm_connect_ind, and bt_accept_enqueue.
>
> The issue is that these functions take a spin lock on the socket with
> interrupts enabled, but sco_sock_timeout takes the lock in an IRQ
> context. This could lead to deadlocks:
>
>        CPU0
>        ----
>   lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>   <Interrupt>
>     lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

Having a second look at this, it does seem this is due to use of
sk->sk_timer which apparently run its callback on IRQ context, so I
wonder if wouldn't be a better idea to switch to a delayed_work to
avoid having to deal with the likes of local_bh_disable, in fact it
seems we have been misusing it since the documentation says it is for
sock cleanup not for handling things like SNDTIMEO, we don't really
use it for other socket types so I wonder when we start using
delayed_work we forgot about sco.c.

>  *** DEADLOCK ***
>
> We fix this by ensuring that local bh is disabled before calling
> bh_lock_sock.
>
> After doing this, we additionally need to protect sco_conn_lock by
> disabling local bh.
>
> This is necessary because sco_conn_del makes a call to sco_chan_del
> while holding on to the sock lock, and sco_chan_del itself makes a
> call to sco_conn_lock. If sco_conn_lock is held elsewhere with
> interrupts enabled, there could still be a
> slock-AF_BLUETOOTH-BTPROTO_SCO --> &conn->lock#2 lock inversion as
> follows:
>
>         CPU0                    CPU1
>         ----                    ----
>    lock(&conn->lock#2);
>                                 local_irq_disable();
>                                 lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>                                 lock(&conn->lock#2);
>    <Interrupt>
>      lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>
>   *** DEADLOCK ***
>
> Although sco_conn_del disables local bh before calling sco_chan_del,
> we can still wrap the calls to sco_conn_lock in sco_chan_del, with
> local_bh_disable/enable as this pair of functions are reentrant.
>
> Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
> Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
> ---
>  net/bluetooth/sco.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index 3bd41563f118..34f3419c3330 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -140,10 +140,12 @@ static void sco_chan_del(struct sock *sk, int err)
>         BT_DBG("sk %p, conn %p, err %d", sk, conn, err);
>
>         if (conn) {
> +               local_bh_disable();
>                 sco_conn_lock(conn);
>                 conn->sk = NULL;
>                 sco_pi(sk)->conn = NULL;
>                 sco_conn_unlock(conn);
> +               local_bh_enable();
>
>                 if (conn->hcon)
>                         hci_conn_drop(conn->hcon);
> @@ -167,16 +169,22 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
>         BT_DBG("hcon %p conn %p, err %d", hcon, conn, err);
>
>         /* Kill socket */
> +       local_bh_disable();
>         sco_conn_lock(conn);
>         sk = conn->sk;
>         sco_conn_unlock(conn);
> +       local_bh_enable();
>
>         if (sk) {
>                 sock_hold(sk);
> +
> +               local_bh_disable();
>                 bh_lock_sock(sk);
>                 sco_sock_clear_timer(sk);
>                 sco_chan_del(sk, err);
>                 bh_unlock_sock(sk);
> +               local_bh_enable();
> +
>                 sco_sock_kill(sk);
>                 sock_put(sk);
>         }
> @@ -202,6 +210,7 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
>  {
>         int err = 0;
>
> +       local_bh_disable();
>         sco_conn_lock(conn);
>         if (conn->sk)
>                 err = -EBUSY;
> @@ -209,6 +218,7 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
>                 __sco_chan_add(conn, sk, parent);
>
>         sco_conn_unlock(conn);
> +       local_bh_enable();
>         return err;
>  }
>
> @@ -303,9 +313,11 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
>  {
>         struct sock *sk;
>
> +       local_bh_disable();
>         sco_conn_lock(conn);
>         sk = conn->sk;
>         sco_conn_unlock(conn);
> +       local_bh_enable();
>
>         if (!sk)
>                 goto drop;
> @@ -420,10 +432,12 @@ static void __sco_sock_close(struct sock *sk)
>                 if (sco_pi(sk)->conn->hcon) {
>                         sk->sk_state = BT_DISCONN;
>                         sco_sock_set_timer(sk, SCO_DISCONN_TIMEOUT);
> +                       local_bh_disable();
>                         sco_conn_lock(sco_pi(sk)->conn);
>                         hci_conn_drop(sco_pi(sk)->conn->hcon);
>                         sco_pi(sk)->conn->hcon = NULL;
>                         sco_conn_unlock(sco_pi(sk)->conn);
> +                       local_bh_enable();
>                 } else
>                         sco_chan_del(sk, ECONNRESET);
>                 break;
> @@ -1084,21 +1098,26 @@ static void sco_conn_ready(struct sco_conn *conn)
>
>         if (sk) {
>                 sco_sock_clear_timer(sk);
> +               local_bh_disable();
>                 bh_lock_sock(sk);
>                 sk->sk_state = BT_CONNECTED;
>                 sk->sk_state_change(sk);
>                 bh_unlock_sock(sk);
> +               local_bh_enable();
>         } else {
> +               local_bh_disable();
>                 sco_conn_lock(conn);
>
>                 if (!conn->hcon) {
>                         sco_conn_unlock(conn);
> +                       local_bh_enable();
>                         return;
>                 }
>
>                 parent = sco_get_sock_listen(&conn->hcon->src);
>                 if (!parent) {
>                         sco_conn_unlock(conn);
> +                       local_bh_enable();
>                         return;
>                 }
>
> @@ -1109,6 +1128,7 @@ static void sco_conn_ready(struct sco_conn *conn)
>                 if (!sk) {
>                         bh_unlock_sock(parent);
>                         sco_conn_unlock(conn);
> +                       local_bh_enable();
>                         return;
>                 }
>
> @@ -1131,6 +1151,7 @@ static void sco_conn_ready(struct sco_conn *conn)
>                 bh_unlock_sock(parent);
>
>                 sco_conn_unlock(conn);
> +               local_bh_enable();
>         }
>  }
>
> --
> 2.25.1
>


-- 
Luiz Augusto von Dentz
