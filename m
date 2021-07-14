Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9193C8B8C
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 21:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240089AbhGNTXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 15:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhGNTXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 15:23:19 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0340C06175F;
        Wed, 14 Jul 2021 12:20:26 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id r135so5054271ybc.0;
        Wed, 14 Jul 2021 12:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jjSz1JmEJaotKApoc0SCfbkh4lIXQPiTHol15ysgTs0=;
        b=d1q07o+6HBG7oYjBg23TbFv555t1qmOmcDJkUv2Xzf6htne/ItLhesZHIqSii3TLg+
         W+5zQRQzaMkIdnP/NdXzUmfd5qK+u8Q7DXzT6QKsPBjPGDPCrdvmHJK6OYKpWYuwJrSP
         I/oL4ZaBGSxetWqzlZXIktVa6xf+anEAIPgdN8EkDyVXA8sOuba7ZZ1y6NrttJDqURRL
         YqtIaDUzRjcIWvJI/WCcaqLrEQaGmSkniX+xw11U0P+TdOPKFrtDia+uR9Qtw4hzw5Wi
         V2XIIQv0JuN/prYd8nHhGZACuQ21tGgfY54ITUAkII01DMMFcx4gcx90aJ5P6n3WblPb
         l73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jjSz1JmEJaotKApoc0SCfbkh4lIXQPiTHol15ysgTs0=;
        b=LmLI3APJt5muIzAN4gEKhW6EikeGUN0/tV4y62/zBb2UKhk7SL66sB+qVDQnpbBKHS
         QiYtgUtOuVvlDFKb39Hnk5TV9ovcjhps+jZR/ikeKVVBBihZjV9tAPnU1Tnx0tykTkKr
         /SpTeWY2PHF63J/7/3HA4GNR4R5N8kb4GUIoP/AyWtXjATh2B1NG5CXXXWSef3ocYya2
         z7PlpTDa1VkrZRP45YxH/FlJ6D/KLdBhYnsOJ7z3/Bk+rrszCi3GJakqeZ7A8YJnkQUj
         7kljhwmqywTFukteoNLBnHN1NTLgc8VklE2y6GRGMqQwM7rxouGaViTjwHbzlC8gJjlo
         UlaA==
X-Gm-Message-State: AOAM533aorhDESxD6xyHkZpBpX+iBjuMLK2HGORh0VrV6WKj2vIdwgET
        ih/firMQFYkB5uA18gAB5Ab7vefKBGBqAaIFNZt+SUcoX7wbYQ==
X-Google-Smtp-Source: ABdhPJyQvZrocf7QPQ2nhuK6uKl8uEmK6X6piIdPdvESIA9xatNnXIpJFGQguAwvs4HOL0wYvl2FDn2IssPgxXa79ZQ=
X-Received: by 2002:a25:8205:: with SMTP id q5mr15052420ybk.440.1626290425963;
 Wed, 14 Jul 2021 12:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp> <48d66166-4d39-4fe2-3392-7e0c84b9bdb3@i-love.sakura.ne.jp>
In-Reply-To: <48d66166-4d39-4fe2-3392-7e0c84b9bdb3@i-love.sakura.ne.jp>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 14 Jul 2021 12:20:15 -0700
Message-ID: <CABBYNZJKWktRo1pCMdafAZ22sE2ZbZeMuFOO+tHUxOtEtTDTeA@mail.gmail.com>
Subject: Re: [PATCH v3] Bluetooth: call lock_sock() outside of spinlock section
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Lin Ma <linma@zju.edu.cn>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tetsuo,

On Tue, Jul 13, 2021 at 4:28 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> syzbot is hitting might_sleep() warning at hci_sock_dev_event() due to
> calling lock_sock() with rw spinlock held [1]. Among three possible
> approaches [2], this patch chose holding a refcount via sock_hold() and
> revalidating the element via sk_hashed().
>
> Link: https://syzkaller.appspot.com/bug?extid=a5df189917e79d5e59c9 [1]
> Link: https://lkml.kernel.org/r/05535d35-30d6-28b6-067e-272d01679d24@i-love.sakura.ne.jp [2]
> Reported-by: syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Tested-by: syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>
> Fixes: e305509e678b3a4a ("Bluetooth: use correct lock to prevent UAF of hdev object")
> ---
> Changes in v3:
>   Don't use unlocked hci_pi(sk)->hdev != hdev test, for it is racy.
>   No need to defer hci_dev_put(hdev), for it can't be the last reference.
>
> Changes in v2:
>   Take hci_sk_list.lock for write in case bt_sock_unlink() is called after
>   sk_hashed(sk) test, and defer hci_dev_put(hdev) till schedulable context.

How about we revert back to use bh_lock_sock_nested but use
local_bh_disable like the following patch:

https://patchwork.kernel.org/project/bluetooth/patch/20210713162838.693266-1-desmondcheongzx@gmail.com/

>  net/bluetooth/hci_sock.c | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index b04a5a02ecf3..786a06a232fd 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -760,10 +760,18 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
>                 struct sock *sk;
>
>                 /* Detach sockets from device */
> +restart:
>                 read_lock(&hci_sk_list.lock);
>                 sk_for_each(sk, &hci_sk_list.head) {
> +                       /* This sock_hold(sk) is safe, for bt_sock_unlink(sk)
> +                        * is not called yet.
> +                        */
> +                       sock_hold(sk);
> +                       read_unlock(&hci_sk_list.lock);
>                         lock_sock(sk);
> -                       if (hci_pi(sk)->hdev == hdev) {
> +                       write_lock(&hci_sk_list.lock);
> +                       /* Check that bt_sock_unlink(sk) is not called yet. */
> +                       if (sk_hashed(sk) && hci_pi(sk)->hdev == hdev) {
>                                 hci_pi(sk)->hdev = NULL;
>                                 sk->sk_err = EPIPE;
>                                 sk->sk_state = BT_OPEN;
> @@ -771,7 +779,27 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
>
>                                 hci_dev_put(hdev);
>                         }
> +                       write_unlock(&hci_sk_list.lock);
>                         release_sock(sk);
> +                       read_lock(&hci_sk_list.lock);
> +                       /* If bt_sock_unlink(sk) is not called yet, we can
> +                        * continue iteration. We can use __sock_put(sk) here
> +                        * because hci_sock_release() will call sock_put(sk)
> +                        * after bt_sock_unlink(sk).
> +                        */
> +                       if (sk_hashed(sk)) {
> +                               __sock_put(sk);
> +                               continue;
> +                       }
> +                       /* Otherwise, we need to restart iteration, for the
> +                        * next socket pointed by sk->next might be already
> +                        * gone. We can't use __sock_put(sk) here because
> +                        * hci_sock_release() might have already called
> +                        * sock_put(sk) after bt_sock_unlink(sk).
> +                        */
> +                       read_unlock(&hci_sk_list.lock);
> +                       sock_put(sk);
> +                       goto restart;
>                 }
>                 read_unlock(&hci_sk_list.lock);
>         }
> --
> 2.18.4
>


-- 
Luiz Augusto von Dentz
