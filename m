Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638C9689C6B
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjBCO6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjBCO6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:58:38 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551F217CD8
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:58:36 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-4ff1fa82bbbso71280627b3.10
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 06:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R66z+1oAAn5XixOHYtAutegom53TXh0tIPMW3UILVsI=;
        b=aa53U0/xXx4j4CR5r3nNIwTL/UaJVOwXyn7zDhOmYHBSlnfBqV5KfAYqTsu5JUK9nf
         07Y/ZeXuZejvEk1FTh8ewWrI5tgW53SXH7zGjTTL9cqf8iR3TD9vM/WzTLdpTbrWqlmX
         F9VNED9GYG3RDhv62CdE197+s2zBmHdesnSwGxnUr21fjAw/UJOU8AMoauKsdsEgADia
         2kytDEYnPhu2lYrmg23ps4bVrV6+m2vqH4QTvIycpGFufiQY8meRBMGQ8nwaso7KqwqA
         oqqP2hKWRjq6mbg/e84aqrizVSWsEeOEyrqYKyeyz1InP9jRA06CZRxpbAkydJa/OUTC
         vk4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R66z+1oAAn5XixOHYtAutegom53TXh0tIPMW3UILVsI=;
        b=PPDFD/IRcGMK2gCmo1lB7Na0SMWeugg+c5lc7DRLp9iUTTU5z0wdZB2wzhnTT54JXT
         BuFIX//MljdvpU/SE9+5L/z1XW7pc22VwUd89/u9n3TWtW4Mkq/kL/5fm1Za5B13r5AF
         P1ZomIRflPj/tXorb7R6eGTK1hsPPYwJW3PshLU95QnvyHNG5ZDG0JxvCac//JO2QujF
         PNr3xhXRDcdDox/2AkrS3hhfg6rm0VWGXPeOvZWR7nyuWIBzVNBSB+UB5ojXw5zElEe9
         ReRhkh/jUKffwJkT5dSBWcYGXkhl1tSaAf0KTc2CrgfrqazUfGYnZYDcTi2oEGdOl/p+
         iVHg==
X-Gm-Message-State: AO0yUKXKnhQO+gnHkL28I75nKVuytxzxUlI4KTAKE8hwgqzMcIMc6I22
        DBCtRXmzV8OJQlDJ/WuftG8Y3LsrNxUb60aQa/uPcg==
X-Google-Smtp-Source: AK7set8bUrYTpIR3XHzb3DjXecgazgm8mURwLQdtdlPJgSNXBX0nBSX33c3gKac1q51b+/75laK9s3aE8NDvJceW3d0=
X-Received: by 2002:a05:690c:b82:b0:500:ac2c:80fb with SMTP id
 ck2-20020a05690c0b8200b00500ac2c80fbmr1154347ywb.90.1675436315286; Fri, 03
 Feb 2023 06:58:35 -0800 (PST)
MIME-Version: 1.0
References: <20230131-tuntap-sk-uid-v2-0-29ec15592813@diag.uniroma1.it> <20230131-tuntap-sk-uid-v2-1-29ec15592813@diag.uniroma1.it>
In-Reply-To: <20230131-tuntap-sk-uid-v2-1-29ec15592813@diag.uniroma1.it>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Feb 2023 15:58:23 +0100
Message-ID: <CANn89i+QMipmfOywjAX2jqZGs80zorE6yKFOsi9rXQbToZLbhQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] tun: tun_chr_open(): correctly initialize
 socket uid
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 3, 2023 at 3:30 PM Pietro Borrello
<borrello@diag.uniroma1.it> wrote:
>
> sock_init_data() assumes that the `struct socket` passed in input is
> contained in a `struct socket_alloc` allocated with sock_alloc().
> However, tun_chr_open() passes a `struct socket` embedded in a `struct
> tun_file` allocated with sk_alloc().
> This causes a type confusion when issuing a container_of() with
> SOCK_INODE() in sock_init_data() which results in assigning a wrong
> sk_uid to the `struct sock` in input.
> On default configuration, the type confused field overlaps with the
> high 4 bytes of `struct tun_struct __rcu *tun` of `struct tun_file`,
> NULL at the time of call, which makes the uid of all tun sockets 0,
> i.e., the root one.  Fix the assignment by overriding it with the
> correct uid.
>
> Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> ---
>  drivers/net/tun.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index a7d17c680f4a..ccffbc439c95 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -3450,6 +3450,11 @@ static int tun_chr_open(struct inode *inode, struct file * file)
>
>         sock_init_data(&tfile->socket, &tfile->sk);
>
> +       /* Assign sk_uid from the inode argument, since tfile->socket
> +        * passed to sock_init_data() has no corresponding inode
> +        */
> +       tfile->sk.sk_uid = inode->i_uid;
> +
>         tfile->sk.sk_write_space = tun_sock_write_space;
>         tfile->sk.sk_sndbuf = INT_MAX;
>


This seems very fragile...
"struct inode" could be made bigger, and __randomize_layout could move i_uid
at the end of it.

KASAN could then detect an out-of-bound access in sock_init_data()

I would rather add a wrapper like this [1], then change tun/tap to use
sock_init_data_uid()

diff --git a/include/net/sock.h b/include/net/sock.h
index 9e464f6409a7175cef5f8ec22e70cade19df5e60..a7e1396d1b778c8a7ed664d149bd6c82cf2ae422
100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1946,6 +1946,8 @@ void sk_common_release(struct sock *sk);
  */

 /* Initialise core socket variables */
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid);
+
 void sock_init_data(struct socket *sock, struct sock *sk);

 /*
diff --git a/net/core/sock.c b/net/core/sock.c
index a3ba0358c77c0e44db1cfbaeb420f8b80ad7cf98..d811cd0d204f37b1791ae94ccfe95114a2286caf
100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3357,7 +3357,7 @@ void sk_stop_timer_sync(struct sock *sk, struct
timer_list *timer)
 }
 EXPORT_SYMBOL(sk_stop_timer_sync);

-void sock_init_data(struct socket *sock, struct sock *sk)
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid)
 {
        sk_init_common(sk);
        sk->sk_send_head        =       NULL;
@@ -3376,11 +3376,10 @@ void sock_init_data(struct socket *sock,
struct sock *sk)
                sk->sk_type     =       sock->type;
                RCU_INIT_POINTER(sk->sk_wq, &sock->wq);
                sock->sk        =       sk;
-               sk->sk_uid      =       SOCK_INODE(sock)->i_uid;
        } else {
                RCU_INIT_POINTER(sk->sk_wq, NULL);
-               sk->sk_uid      =       make_kuid(sock_net(sk)->user_ns, 0);
        }
+       sk->sk_uid      =       uid;

        rwlock_init(&sk->sk_callback_lock);
        if (sk->sk_kern_sock)
@@ -3439,6 +3438,16 @@ void sock_init_data(struct socket *sock, struct sock *sk)
        refcount_set(&sk->sk_refcnt, 1);
        atomic_set(&sk->sk_drops, 0);
 }
+EXPORT_SYMBOL(sock_init_data_uid);
+
+void sock_init_data(struct socket *sock, struct sock *sk)
+{
+       kuid_t uid = sock ?
+               SOCK_INODE(sock)->i_uid :
+               make_kuid(sock_net(sk)->user_ns, 0);
+
+       sock_init_data_uid(sock, sk, uid);
+}
 EXPORT_SYMBOL(sock_init_data);

 void lock_sock_nested(struct sock *sk, int subclass)
