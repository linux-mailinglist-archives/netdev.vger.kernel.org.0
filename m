Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158B85ED414
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 07:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiI1FFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 01:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiI1FFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 01:05:22 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC49E11DC
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 22:05:21 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-345528ceb87so119807547b3.11
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 22:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=yIwHCyB8UXxDRVJ9blrFHmL2cOgSYQrgb8iwQ11BtQw=;
        b=lf7H9XzSfRnChh6O787k71OJIMDVadXy0DCFZVcRoGy3c5IpXgOtPLTqeEZhoZEN/A
         pyIrzG6ZOa5d+I71Dz0Vfd1EjJMEzr4dghuNRFTiTX4dBdOVNtLVtDe7VuHW7PjKv9cY
         jfbC02O98XLFClRxlrbUMOR+TOh1dd8FuKTCyoJJbwhzp0ln8O62C7geK2+KCDk044ta
         8E96I3RqlqeMJs2dqfM8+XDI8vGRsIz3GR+cKJrRpwS/smu5i1xetTaODYEql+YBmi8X
         mBddEV0szaTAekN1LWoDYjYc1O0QU99+iXC3JIz1t9aewqRgTGciySCAdsZZ9LI3Zxpl
         MuWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=yIwHCyB8UXxDRVJ9blrFHmL2cOgSYQrgb8iwQ11BtQw=;
        b=P2vuD4oB60FLyrPm0+yA2bZdXwyjf74iiTqcKG8Y3FWnvoDfbDm85ngII3aSFJTINI
         jHz9EyLK0KqKR5pL2PAaiWnQA1wl2TJbzACvonogznCKO8S+qpCjLEp6Xx9dNqMw0pos
         AgyUpz5VRBA7sBaWvsp6EG11ZhfwpHvYGVt2tCcDT/N8CeZKNP0xABQFjjDehiOkzaqK
         8ly1MyaWEUAIcDPQRdSTqC9XX3b3BeqUhgNFcm+1jTfUa5A0oJSJ5pWbY9DxRs2ewrq1
         xxuUR9siy6ZSocxu7NQA2p7q1MkrLPiwzWoc4qN5EXvtIs4e5fBYJp/tzzvyawET9fSM
         tLsw==
X-Gm-Message-State: ACrzQf0GzRYzL/+6y43jVXq3pg9u9ucY+wCtdbEZ5ogEySEmVqZkTdYC
        s3AxeXL82I2QarxuD4WM/aJrTcwaL4SKCWGh6S1B5A==
X-Google-Smtp-Source: AMsMyM4Pf0cMnBGHDqdcpLnN4zgl8yODbitHCUy93bdRojqz8HL8ukq+SFSjdKBEsmXxdshFtfaPLXa8JmLl6DLX3wY=
X-Received: by 2002:a81:4e0d:0:b0:351:99d8:1862 with SMTP id
 c13-20020a814e0d000000b0035199d81862mr7543465ywb.278.1664341520327; Tue, 27
 Sep 2022 22:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220928002741.64237-1-kuniyu@amazon.com> <20220928002741.64237-3-kuniyu@amazon.com>
In-Reply-To: <20220928002741.64237-3-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 22:05:09 -0700
Message-ID: <CANn89iK1HHhvJgDsym377DDxZ3hvL8b8_pbrjb-qeXFRbsvFKA@mail.gmail.com>
Subject: Re: [PATCH v2 net 2/5] udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>
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

On Tue, Sep 27, 2022 at 5:28 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Commit 4b340ae20d0e ("IPv6: Complete IPV6_DONTFRAG support") forgot
> to add a change to free inet6_sk(sk)->rxpmtu while converting an IPv6
> socket into IPv4 with IPV6_ADDRFORM.  After conversion, sk_prot is
> changed to udp_prot and ->destroy() never cleans it up, resulting in
> a memory leak.
>
> This is due to the discrepancy between inet6_destroy_sock() and
> IPV6_ADDRFORM, so let's call inet6_destroy_sock() from IPV6_ADDRFORM
> to remove the difference.
>
> However, this is not enough for now because rxpmtu can be changed
> without lock_sock() after commit 03485f2adcde ("udpv6: Add lockless
> sendmsg() support").  We will fix this case in the following patch.
>
> Fixes: 4b340ae20d0e ("IPv6: Complete IPV6_DONTFRAG support")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/ipv6/ipv6_sockglue.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index b61066ac8648..030a4cf23ceb 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -431,9 +431,6 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>                 if (optlen < sizeof(int))
>                         goto e_inval;
>                 if (val == PF_INET) {
> -                       struct ipv6_txoptions *opt;
> -                       struct sk_buff *pktopt;
> -
>                         if (sk->sk_type == SOCK_RAW)
>                                 break;
>
> @@ -464,7 +461,6 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>                                 break;
>                         }
>
> -                       fl6_free_socklist(sk);
>                         __ipv6_sock_mc_close(sk);
>                         __ipv6_sock_ac_close(sk);
>
> @@ -501,14 +497,9 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>                                 sk->sk_socket->ops = &inet_dgram_ops;
>                                 sk->sk_family = PF_INET;
>                         }
> -                       opt = xchg((__force struct ipv6_txoptions **)&np->opt,
> -                                  NULL);
> -                       if (opt) {
> -                               atomic_sub(opt->tot_len, &sk->sk_omem_alloc);
> -                               txopt_put(opt);
> -                       }
> -                       pktopt = xchg(&np->pktoptions, NULL);
> -                       kfree_skb(pktopt);
> +

 Why is this needed ? I think a comment could help.
> +                       np->rxopt.all = 0;

> +                       inet6_destroy_sock(sk);

This name is unfortunate. This really is an inet6_cleanup_sock() in
this context.

>
>                         /*
>                          * ... and add it to the refcnt debug socks count
> --
> 2.30.2
>
