Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A9954F013
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 06:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379526AbiFQEXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 00:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiFQEXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 00:23:51 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6906E2EA1E
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 21:23:50 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id l11so5388255ybu.13
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 21:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sZNhmEOu8jjLdZkHTV6E1/wZ+VkQl9ztskYWd7HiJbU=;
        b=n+AQjW54uNiZ093Vy02DEMVsEaCv+D2btmFbxClAtI8lYVoMUSYM9bz9gFxt4uZzGX
         OfSNHReFR8Lwktq/HWTjuvMOt/pBCcXp8haCQ58sDA5zOV4X7dApWbRLGJbv5tGeL3qC
         NcF/ltkI6qHbB/5IrwEZRqsIIFnSL+admSlBNDP6cZNuBIvW+JMTVL3kYe0BZlxAFkWG
         h0RdX/n04UQDYqZFeEYgPDAsGoAnNim60a5txMD3MvUsiKdt2CoRtG8JgUyXR3VMXftc
         oSM91tI5cFRMhS6KcInGxGzTY2Vie26coIkZXUKjLT3zDgV23Ifrvwq71WHFBe+iOeIy
         nZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sZNhmEOu8jjLdZkHTV6E1/wZ+VkQl9ztskYWd7HiJbU=;
        b=tjXk/yjfbCY6J/n/O099EeTbehkzXWiiK03+R3jh/DvyA063hYx5a7KZkYrHQnV3Hf
         C2Tpe3Lo8hH6Ko7fiN8UdCsaQRtkVEfLfFPCtWwcN7Ar15doVmBpslsFGAo0ePTKqIji
         D8IHgI8AcGH/jEr41/IdSqJ0zcdu2DBVcWKWSGIaV4PFMaE8embk9yaafcQnZLA2SfSX
         /B7yR7WXEWUaYm24v9+EgrTHXPlNSoHQh8yGOSJyDEU5D3Yc0J0EbFx6LNIt3+2keQKb
         A6mpfH+nRiaOWazIIgBjwuuLxgHYZvUc7YWkWVyo4WN1NvpkloEfothrPzyyoGeETpJX
         D5Kg==
X-Gm-Message-State: AJIora9gG297yzYLvwWNyjNGaGCLF0ZSUGr49/7Rz2y6b+jzN4uR4AUR
        wKyxT94PnPGGzBYClf2+TYsSK1QfAxB/S+30+zu/gQ==
X-Google-Smtp-Source: AGRyM1su3OIBZFb9OcARHafH0xNIjEkJvYSF0gobJ9wDLTVp4RKHsvCg6QRi3QrlzEefv9NK998JeDI3lWbH1ruM+M0=
X-Received: by 2002:a25:d649:0:b0:65c:9e37:8bb3 with SMTP id
 n70-20020a25d649000000b0065c9e378bb3mr9044818ybg.387.1655439828942; Thu, 16
 Jun 2022 21:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220616234714.4291-1-kuniyu@amazon.com> <20220616234714.4291-4-kuniyu@amazon.com>
In-Reply-To: <20220616234714.4291-4-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Jun 2022 06:23:37 +0200
Message-ID: <CANn89i+JZT22NvQSiOY2X-XmBiOV4kPGohnpSDdjdptkUig6DQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 3/6] af_unix: Define a per-netns hash table.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Amit Shah <aams@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 1:48 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> This commit adds a per netns hash table for AF_UNIX.
>
> Note that its size is fixed as UNIX_HASH_SIZE for now.
>

Note: Please include memory costs for this table, including when LOCKDEP is on.


> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/af_unix.h    |  5 +++++
>  include/net/netns/unix.h |  2 ++
>  net/unix/af_unix.c       | 40 ++++++++++++++++++++++++++++++++++------
>  3 files changed, 41 insertions(+), 6 deletions(-)
>
> diff --git a/include/net/af_unix.h b/include/net/af_unix.h
> index acb56e463db1..0a17e49af0c9 100644
> --- a/include/net/af_unix.h
> +++ b/include/net/af_unix.h
> @@ -24,6 +24,11 @@ extern unsigned int unix_tot_inflight;
>  extern spinlock_t unix_table_locks[UNIX_HASH_SIZE];
>  extern struct hlist_head unix_socket_table[UNIX_HASH_SIZE];
>
> +struct unix_hashbucket {
> +       spinlock_t              lock;
> +       struct hlist_head       head;
> +};
> +
>  struct unix_address {
>         refcount_t      refcnt;
>         int             len;
> diff --git a/include/net/netns/unix.h b/include/net/netns/unix.h
> index 91a3d7e39198..975c4e3f8a5b 100644
> --- a/include/net/netns/unix.h
> +++ b/include/net/netns/unix.h
> @@ -5,8 +5,10 @@
>  #ifndef __NETNS_UNIX_H__
>  #define __NETNS_UNIX_H__
>
> +struct unix_hashbucket;
>  struct ctl_table_header;
>  struct netns_unix {
> +       struct unix_hashbucket  *hash;
>         int                     sysctl_max_dgram_qlen;
>         struct ctl_table_header *ctl;
>  };
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index c0804ae9c96a..3c07702e2349 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -3559,7 +3559,7 @@ static const struct net_proto_family unix_family_ops = {
>
>  static int __net_init unix_net_init(struct net *net)
>  {
> -       int error = -ENOMEM;
> +       int i;
>
>         net->unx.sysctl_max_dgram_qlen = 10;
>         if (unix_sysctl_register(net))
> @@ -3567,18 +3567,35 @@ static int __net_init unix_net_init(struct net *net)
>
>  #ifdef CONFIG_PROC_FS
>         if (!proc_create_net("unix", 0, net->proc_net, &unix_seq_ops,
> -                       sizeof(struct seq_net_private))) {
> -               unix_sysctl_unregister(net);
> -               goto out;
> +                            sizeof(struct seq_net_private)))
> +               goto err_sysctl;
> +#endif
> +
> +       net->unx.hash = kmalloc(sizeof(struct unix_hashbucket) * UNIX_HASH_SIZE,
> +                               GFP_KERNEL);

This will fail under memory pressure.

Prefer kvmalloc_array()

> +       if (!net->unx.hash)
> +               goto err_proc;
> +
> +       for (i = 0; i < UNIX_HASH_SIZE; i++) {
> +               INIT_HLIST_HEAD(&net->unx.hash[i].head);
> +               spin_lock_init(&net->unx.hash[i].lock);
>         }
> +
> +       return 0;
> +
> +err_proc:
> +#ifdef CONFIG_PROC_FS
> +       remove_proc_entry("unix", net->proc_net);
>  #endif
> -       error = 0;
> +err_sysctl:
> +       unix_sysctl_unregister(net);
>  out:
> -       return error;
> +       return -ENOMEM;
>  }
>
>  static void __net_exit unix_net_exit(struct net *net)
>  {
> +       kfree(net->unx.hash);

kvfree()

>         unix_sysctl_unregister(net);
>         remove_proc_entry("unix", net->proc_net);
>  }
> @@ -3666,6 +3683,16 @@ static int __init af_unix_init(void)
>
>         BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
>
> +       init_net.unx.hash = kmalloc(sizeof(struct unix_hashbucket) * UNIX_HASH_SIZE,
> +                                   GFP_KERNEL);

Why are you allocating the hash table twice ? It should be done
already in  unix_net_init() ?

> +       if (!init_net.unx.hash)
> +               goto out;
> +
> +       for (i = 0; i < UNIX_HASH_SIZE; i++) {
> +               INIT_HLIST_HEAD(&init_net.unx.hash[i].head);
> +               spin_lock_init(&init_net.unx.hash[i].lock);
> +       }
> +
>         for (i = 0; i < UNIX_HASH_SIZE; i++)
>                 spin_lock_init(&unix_table_locks[i]);
>
> @@ -3699,6 +3726,7 @@ static void __exit af_unix_exit(void)
>         proto_unregister(&unix_dgram_proto);
>         proto_unregister(&unix_stream_proto);
>         unregister_pernet_subsys(&unix_net_ops);
> +       kfree(init_net.unx.hash);

   Not needed.

>  }
>
>  /* Earlier than device_initcall() so that other drivers invoking
> --
> 2.30.2
>
