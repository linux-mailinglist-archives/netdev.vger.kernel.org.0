Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FD33CF31E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 06:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbhGTDoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 23:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhGTDoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 23:44:04 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CF4C061574;
        Mon, 19 Jul 2021 21:24:41 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id x192so31022913ybe.6;
        Mon, 19 Jul 2021 21:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gPhUF/uHHJlKK8me05sAmbzC0LuWJeGm9afwshlZzGw=;
        b=av6fx2TPOwB8VB0mVPMtKJVSv8DePQYE/mhdoQc65FqEeI2My/RWvp62AQrY/Q5A8i
         3zBUIUTN9ceuIri/eIwvuVCZzcx1F6+WzIcIfrORFrPAhzJDipjTUqX+Idda2akkUXvF
         zRo+HjwyRsrKc4nn9jjeSe3Qfyi/oeAnstbwDeNzUtFh9zfEOZlFnAN5b1MgehmExNMd
         Lmw3Oa6sFL3W+5aa06/Vo9sfScZWlxtwh7L3gjdJ9MsCUXUGJogmx6Alff7lrVVHWAIq
         IS9nNNDuzjWhtI2A9guG0h2rB2RfmXTt9gG64uMih8TN2bKob8DayvZD/Bo15JbacGKY
         Zvug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gPhUF/uHHJlKK8me05sAmbzC0LuWJeGm9afwshlZzGw=;
        b=Jt2fWbRHtn/HDFvOzzOaogumaMopGGWYe2biRam7RVfbC/dxFe9XMDVeMDPaiQGAcC
         hgS8Elf+VZj963Vr2Gxkfa06UWq7oUbd8qM89NUfZM9WNtohvwJlTkCa6mMyrOs2sq6H
         PJNcoygl0boGbaAHy9f0A8k18wkiqip+FcwVcRZzPsUyY82n4sCam4cWs8VM4NQJhWfs
         dT7R5w8yDNvy3uhTeTt6nv1jSMDlfWDdNkaW2m6TIaEB3QuDo1MGW+PhB9qy+dnByrWA
         dv+VwOvZAds3QM6yH62MrEhbAKHroemIBZEZREjw8OYlqaAfV5/+jVfLGMyb92HLD4uD
         lzZA==
X-Gm-Message-State: AOAM530F2t5VS7seJw3A2C1XuPpnP0hjdZB274FRrGaaVrLrKveHQoPI
        GeipJw7dAgM8UpSyj7hTW2XZ7JmTTV/KbT9Od9I=
X-Google-Smtp-Source: ABdhPJzlQhNsdeS+eWb9SZXda2twu5XzghBhOY0bySFPt9bhIOsBAq5XdVjXHon3yXqSL8YU1dTX9Rd73o3kWBYbl4c=
X-Received: by 2002:a05:6902:114c:: with SMTP id p12mr37297091ybu.282.1626755081153;
 Mon, 19 Jul 2021 21:24:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210719024937.9542-1-bobo.shaobowang@huawei.com>
 <20210719074829.2554-1-hdanton@sina.com> <97b64908-45d3-f074-bd9c-0bb04624bad1@huawei.com>
 <20210720021619.621-1-hdanton@sina.com>
In-Reply-To: <20210720021619.621-1-hdanton@sina.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 19 Jul 2021 21:24:30 -0700
Message-ID: <CABBYNZLfFs86Hiej6C2EMVutf4ygyamifBJrXdQK97JpTLBqKg@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: fix use-after-free error in lock_sock_nested()
To:     Hillf Danton <hdanton@sina.com>
Cc:     "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>,
        cj.chengjian@huawei.com, Wei Yongjun <weiyongjun1@huawei.com>,
        yuehaibing@huawei.com, huawei.libin@huawei.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+664818c59309176d03ee@syzkaller.appspotmail.com>,
        syzbot <syzbot+9a0875bc1b2ca466b484@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hillf,

On Mon, Jul 19, 2021 at 7:16 PM Hillf Danton <hdanton@sina.com> wrote:
>
> On Mon, 19 Jul 2021 17:03:53 +0800 Wang ShaoBo wrote:
> >
> >I have tried this before, this will trigger error "underflow of refcount
> >of chan" as following:
> >
> >[  118.708179][ T3086] ------------[ cut here ]------------
> >[  118.710172][ T3086] refcount_t: underflow; use-after-free.
> >[  118.713391][ T3086] WARNING: CPU: 4 PID: 3086 at lib/refcount.c:28
> >refcount_warn_saturate+0x30a/0x3c0
> >[  118.716774][ T3086] Modules linked in:
> >[  118.718279][ T3086] CPU: 4 PID: 3086 Comm: kworker/4:2 Not tainted
> >5.12.0-rc6+ #84
> >[  118.721005][ T3086] Hardware name: QEMU Standard PC (i440FX + PIIX,
> >1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> >[  118.722846][ T3086] Workqueue: events l2cap_chan_timeout
> >[  118.723786][ T3086] RIP: 0010:refcount_warn_saturate+0x30a/0x3c0
> >...
> >[  118.737912][ T3086] CR2: 0000000020000040 CR3: 0000000011029000 CR4:
> >00000000000006e0
> >[  118.739187][ T3086] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> >0000000000000000
> >[  118.740451][ T3086] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> >0000000000000400
> >[  118.741720][ T3086] Call Trace:
> >[  118.742262][ T3086]  l2cap_sock_close_cb+0x165/0x170
> >[  118.743124][ T3086]  ? l2cap_sock_teardown_cb+0x560/0x560
> >
> >Actually, if adding sock_hold(sk) in l2cap_sock_init(),
> >l2cap_sock_kill() will continue to excute untill it found
> >
> >now chan's refcount is 0, this is because sock was not freed in last
> >round execution of l2cap_sock_kill().
>
> Well double kill cannot be walked around without adding more - add the
> destroy callback to make the chan->data recorded sock survive kill. It
> will be released when chan is destroyed to cut the race in reguards to
> accessing sock by making chan->data stable throughout chan's lifespan.
>
>
> +++ x/net/bluetooth/l2cap_core.c
> @@ -485,7 +485,10 @@ static void l2cap_chan_destroy(struct kr
>         list_del(&chan->global_l);
>         write_unlock(&chan_list_lock);
>
> -       kfree(chan);
> +       if (chan->ops && chan->ops->destroy)
> +               chan->ops->destroy(chan);
> +       else
> +               kfree(chan);

While Im fine adding a destroy callback the kfree shall be still in
l2cap_chan_destroy:

if (chan->ops && chan->ops->destroy)
  /* Destroy chan->data */
  chan->ops->destroy(chan->data);

kfree(chan);

>  }
>
>  void l2cap_chan_hold(struct l2cap_chan *c)
> +++ x/net/bluetooth/l2cap_sock.c
> @@ -1220,11 +1220,13 @@ static void l2cap_sock_kill(struct sock
>
>         BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
>
> +       /* double kill means noop */
> +       if (sock_flag(sk, SOCK_DEAD))
> +               return;
>         /* Kill poor orphan */
>
>         l2cap_chan_put(l2cap_pi(sk)->chan);
>         sock_set_flag(sk, SOCK_DEAD);
> -       sock_put(sk);
>  }
>
>  static int __l2cap_wait_ack(struct sock *sk, struct l2cap_chan *chan)
> @@ -1504,6 +1506,14 @@ done:
>         return err;
>  }
>
> +static void l2cap_sock_destroy_cb(struct l2cap_chan *chan)
> +{
> +       struct sock *sk = chan->data;
> +
> +       sock_put(sk);
> +       kfree(chan);
> +}
> +
>  static void l2cap_sock_close_cb(struct l2cap_chan *chan)
>  {
>         struct sock *sk = chan->data;
> @@ -1690,6 +1700,7 @@ static const struct l2cap_ops l2cap_chan
>         .new_connection         = l2cap_sock_new_connection_cb,
>         .recv                   = l2cap_sock_recv_cb,
>         .close                  = l2cap_sock_close_cb,
> +       .destroy                = l2cap_sock_destroy_cb,

If you do the changes above you can probably have sock_put directly
set as .destroy.

>         .teardown               = l2cap_sock_teardown_cb,
>         .state_change           = l2cap_sock_state_change_cb,
>         .ready                  = l2cap_sock_ready_cb,



-- 
Luiz Augusto von Dentz
