Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7EE5ECA16
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiI0Qvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiI0QuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:50:20 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3917C1F2F0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:50:18 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-345528ceb87so106097247b3.11
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vESNePe9n7uejPFfs1w+utJ1cwyq3VqYeQvjK+K3YTk=;
        b=aU3mY4mPAPL8Y2DkTOPUbIiQVySXBNqOsUTLmktA49l3UNs9/YlO2TV60ZgYj3vPXZ
         LUGZiSASvDb4yvODdmRKdB+QR/4fxv4qGnjLDH8pPMvHwX+7R+0OGDzUxQkYLgnRIMTA
         s6vBuGVmKpH2zduXU0kTUJmobtmghsBvRVEvcc3GVDwwY1ndmksJk0uGCYaGhIsS3OzW
         owBLL5/oNHuHgwYyJzghsb4sqQGRaJOSwkP3qQDaZUBLaMj3Tlcx5lUQDwb5itDbRZXp
         GqQi0FsJiZbiSsARlgbB0/xIorzd2ftsumw6B0mGhOfJ3OrYzLTvL9KRbSgjImhU2afu
         knNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vESNePe9n7uejPFfs1w+utJ1cwyq3VqYeQvjK+K3YTk=;
        b=4Q7Rjg8NxwFZcuxj9gUseR+oUK/vbYhnnE+4KuxB5n3T5CUOTeEGh1XhN+MKl/NbSZ
         2xLTg6SBZAJsiuFjt7Ba1+tPnUQFkskHjBb99t59twacjCabzMQZIpvCgdFl43mEytrR
         p1nr1XvwZ7/j1yvM0t/lPCp9s5ag5GKkFzU7/m61Ha5OGDwXbX/hdEQFtB05dOWByj07
         I7pGOOz5KFBNn/+87b/l9+IcOl/kFVfgd8+vLw4GreOEMsALZ+sWfM863R3hXte0d2fC
         rlQbl8ljb2zj3K8AtGoWF8RrMcNBCY6ppVoJz5Vd746xe8nkrZbpJWaxkpqzZqEj/vvX
         ObEQ==
X-Gm-Message-State: ACrzQf3oDEVQ5lj2iksCH4K8qPlMwYmm090/mmUXPhNlaD/Um82wWv+G
        n526zaB2XrafPZIBg1Zi4a+yYKLGnYzVha3+Jq5oPA==
X-Google-Smtp-Source: AMsMyM4CKKRtW+2RFnlNvNc6W+CBVYvfJ2xFQmhBp0HkkEjyqcmvPFQrarolp2eVeL6aIuHNXWImPeCeiR9ci7eeMNc=
X-Received: by 2002:a0d:d508:0:b0:352:43a6:7ddc with SMTP id
 x8-20020a0dd508000000b0035243a67ddcmr2574418ywd.55.1664297416738; Tue, 27 Sep
 2022 09:50:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220927161209.32939-1-kuniyu@amazon.com> <20220927161209.32939-4-kuniyu@amazon.com>
In-Reply-To: <20220927161209.32939-4-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 09:50:04 -0700
Message-ID: <CANn89iKguA1pAc7wUuWVwuSLJ7+dDRLscY0CEJXNPpg8gphJbg@mail.gmail.com>
Subject: Re: [PATCH v1 net 3/5] tcp/udp: Call inet6_destroy_sock() in IPv4 sk_prot->destroy().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vladislav Yasevich <vyasevic@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 9:13 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Originally, inet6_sk(sk)->XXX were changed under lock_sock(), so we were
> able to clean them up by calling inet6_destroy_sock() during the IPv6 ->
> IPv4 conversion by IPV6_ADDRFORM.  However, commit 03485f2adcde ("udpv6:
> Add lockless sendmsg() support") added a lockless memory allocation path,
> which could cause a memory leak:
>
> setsockopt(IPV6_ADDRFORM)                 sendmsg()
> +-----------------------+                 +-------+
> - do_ipv6_setsockopt(sk, ...)             - udpv6_sendmsg(sk, ...)
>   - lock_sock(sk)                           ^._ called via udpv6_prot
>   - WRITE_ONCE(sk->sk_prot, &tcp_prot)          before WRITE_ONCE()
>   - inet6_destroy_sock()
>   - release_sock(sk)                        - ip6_make_skb(sk, ...)
>                                               ^._ lockless fast path for
>                                                   the non-corking case
>
>                                               - __ip6_append_data(sk, ...)
>                                                 - ipv6_local_rxpmtu(sk, ...)
>                                                   - xchg(&np->rxpmtu, skb)
>                                                     ^._ rxpmtu is never freed.
>
>                                             - lock_sock(sk)
>
> For now, rxpmtu is only the case, but let's call inet6_destroy_sock()
> in both TCP/UDP v4 destroy functions not to miss the future change.
>
> We can consolidate TCP/UDP v4/v6 destroy functions, but such changes
> are too invasive to backport to stable.  So, they can be posted as a
> follow-up later for net-next.
>
> Fixes: 03485f2adcde ("udpv6: Add lockless sendmsg() support")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> Cc: Vladislav Yasevich <vyasevic@redhat.com>
> ---
>  net/ipv4/tcp_ipv4.c | 5 +++++
>  net/ipv4/udp.c      | 6 ++++++
>  net/ipv6/tcp_ipv6.c | 1 -
>  3 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 5b019ba2b9d2..035b6c52a243 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2263,6 +2263,11 @@ void tcp_v4_destroy_sock(struct sock *sk)
>         tcp_saved_syn_free(tp);
>
>         sk_sockets_allocated_dec(sk);
> +
> +#if IS_ENABLED(CONFIG_IPV6)
> +       if (sk->sk_prot_creator == &tcpv6_prot)
> +               inet6_destroy_sock(sk);
> +#endif
>  }

This is ugly, and will not compile with CONFIG_IPV6=m, right ?


>  EXPORT_SYMBOL(tcp_v4_destroy_sock);
>
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 560d9eadeaa5..cdf131c0a819 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -115,6 +115,7 @@
>  #include <net/udp_tunnel.h>
>  #if IS_ENABLED(CONFIG_IPV6)
>  #include <net/ipv6_stubs.h>
> +#include <net/transp_v6.h>
>  #endif
>
>  struct udp_table udp_table __read_mostly;
> @@ -2666,6 +2667,11 @@ void udp_destroy_sock(struct sock *sk)
>                 if (up->encap_enabled)
>                         static_branch_dec(&udp_encap_needed_key);
>         }
> +
> +#if IS_ENABLED(CONFIG_IPV6)
> +       if (sk->sk_prot_creator == &udpv6_prot)
> +               inet6_destroy_sock(sk);
> +#endif
>  }
>
>  /*
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index e54eee80ce5f..1ff6a92f7774 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -1945,7 +1945,6 @@ static int tcp_v6_init_sock(struct sock *sk)
>  static void tcp_v6_destroy_sock(struct sock *sk)
>  {
>         tcp_v4_destroy_sock(sk);
> -       inet6_destroy_sock(sk);
>  }
>
>  #ifdef CONFIG_PROC_FS
> --
> 2.30.2
>
