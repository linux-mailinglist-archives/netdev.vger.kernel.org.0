Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C21B5812E6
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbiGZMN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiGZMNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:13:25 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F3F2CDFE
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 05:13:23 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-31f56c42ab5so3755897b3.10
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 05:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SYVsTQz5iwpU0rHGKZZgCLqu05YE3tSgDiLqaqsQFZc=;
        b=I4SIBzqyPiJK44vXYIn9HzlkRiGAuDEjVXWCFZzL9W23tqMIPwDLFsRjQv+hLcH9L8
         lhkrI58QRuEKQX/3jfxD2Q2EqfObegRdPWkxJr4nBgE5ockTjO3P8M4cuvHxuhTOhzlR
         P9Z3t31P0nGlz9+v/gGkXr0LD9nhrKj3sKF/OMbYnCHLZJxZzllxwQ3lrBwho2yCZtAU
         G+hMEJkSvIiZaQgVwnnokGiMBMGISWp45NrZ9n2Ig1bRcfNpNWGXotv1+vpr4midaRNk
         cJNpehTh8rBj220IzjYZQJYH+UlSQmzEsAOeGPB0fhFKa4TkspP7CggSz+yT11XznJQG
         d2mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SYVsTQz5iwpU0rHGKZZgCLqu05YE3tSgDiLqaqsQFZc=;
        b=OYHPLhtIlb24nBtQzkF3m+AM6G/TpYYRroDiEjzLczTnIjNjrDovUWTLJkmmbRiMvS
         qpPhhroc0Re0YYVh/7cppTIHRqb3HY400h06Lw3nSfabwBc/5wKBze9oNHCChjJPY6nc
         mDgXoLrbirMyoOPMsv/adE5uFGBW4Fj8GBUSKvMPE07x1q3eWUWhZClKvzv21v4sm0Yy
         i3aXZfELgMF2EKgsSv+UPBNncvAT6M0Z5FyoIO8NtCL+U9cWQB5P73VoUUOUekC4drtV
         xByKg2q8Ftr7mh8bWTtVIw80sEjB/aCYZu+CXpTLqsTLFqVN4Pqv7ZH1oIJEKwDK5Rzz
         w3MA==
X-Gm-Message-State: AJIora/yx3QYcV1MBKZ62FhKpFWS8ySBOWUa6mI6AsWrA1SDWM7U44pq
        NBAlshTgCB5y2vYLyC9SGWu4wplPxRunPwSB8mvUSA==
X-Google-Smtp-Source: AGRyM1vCoW0at0inCp9kKhtLsvjvyEabqC0bZ7Nq4V5biDVHEhlcOWZwhm/ClzwcqIGZrFugaaV9v6SEZedcNJbGtM4=
X-Received: by 2002:a0d:f104:0:b0:31f:268a:43da with SMTP id
 a4-20020a0df104000000b0031f268a43damr5960083ywf.332.1658837602287; Tue, 26
 Jul 2022 05:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220726115028.3055296-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220726115028.3055296-1-william.xuanziyang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 26 Jul 2022 14:13:10 +0200
Message-ID: <CANn89iJNHhq9zbmL2DF-up_hBRHuwkPiNUpMS+LHoumy5ohQZA@mail.gmail.com>
Subject: Re: [PATCH net v2] ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
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

On Tue, Jul 26, 2022 at 1:50 PM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
>
> Change net device's MTU to smaller than IPV6_MIN_MTU or unregister
> device while matching route. That may trigger null-ptr-deref bug
> for ip6_ptr probability as following.
>
> =========================================================
> BUG: KASAN: null-ptr-deref in find_match.part.0+0x70/0x134
> Read of size 4 at addr 0000000000000308 by task ping6/263
>
> CPU: 2 PID: 263 Comm: ping6 Not tainted 5.19.0-rc7+ #14
> Call trace:
>  dump_backtrace+0x1a8/0x230
>  show_stack+0x20/0x70
>  dump_stack_lvl+0x68/0x84
>  print_report+0xc4/0x120
>  kasan_report+0x84/0x120
>  __asan_load4+0x94/0xd0
>  find_match.part.0+0x70/0x134
>  __find_rr_leaf+0x408/0x470
>  fib6_table_lookup+0x264/0x540
>  ip6_pol_route+0xf4/0x260
>  ip6_pol_route_output+0x58/0x70
>  fib6_rule_lookup+0x1a8/0x330
>  ip6_route_output_flags_noref+0xd8/0x1a0
>  ip6_route_output_flags+0x58/0x160
>  ip6_dst_lookup_tail+0x5b4/0x85c
>  ip6_dst_lookup_flow+0x98/0x120
>  rawv6_sendmsg+0x49c/0xc70
>  inet_sendmsg+0x68/0x94
>
> Reproducer as following:
> Firstly, prepare conditions:
> $ip netns add ns1
> $ip netns add ns2
> $ip link add veth1 type veth peer name veth2
> $ip link set veth1 netns ns1
> $ip link set veth2 netns ns2
> $ip netns exec ns1 ip -6 addr add 2001:0db8:0:f101::1/64 dev veth1
> $ip netns exec ns2 ip -6 addr add 2001:0db8:0:f101::2/64 dev veth2
> $ip netns exec ns1 ifconfig veth1 up
> $ip netns exec ns2 ifconfig veth2 up
> $ip netns exec ns1 ip -6 route add 2000::/64 dev veth1 metric 1
> $ip netns exec ns2 ip -6 route add 2001::/64 dev veth2 metric 1
>
> Secondly, execute the following two commands in two ssh windows
> respectively:
> $ip netns exec ns1 sh
> $while true; do ip -6 addr add 2001:0db8:0:f101::1/64 dev veth1; ip -6 route add 2000::/64 dev veth1 metric 1; ping6 2000::2; done
>
> $ip netns exec ns1 sh
> $while true; do ip link set veth1 mtu 1000; ip link set veth1 mtu 1500; sleep 5; done
>
> It is because ip6_ptr has been assigned to NULL in addrconf_ifdown() firstly,
> then ip6_ignore_linkdown() accesses ip6_ptr directly without NULL check.
>
>         cpu0                    cpu1
> fib6_table_lookup
> __find_rr_leaf
>                         addrconf_notify [ NETDEV_CHANGEMTU ]
>                         addrconf_ifdown
>                         RCU_INIT_POINTER(dev->ip6_ptr, NULL)
> find_match
> ip6_ignore_linkdown
>
> So we can add NULL check for ip6_ptr before using in ip6_ignore_linkdown() to
> fix the null-ptr-deref bug.
>
> Fixes: 6d3d07b45c86 ("ipv6: Refactor fib6_ignore_linkdown")

If we need to backport, I guess dcd1f572954f ("net/ipv6: Remove fib6_idev")
already had the bug.

> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>
> ---
> v2:
>   - Use NULL check in ip6_ignore_linkdown() but synchronize_net() in
>     addrconf_ifdown()
>   - Add timing analysis of the problem
>
> ---
>  include/net/addrconf.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> index f7506f08e505..c04f359655b8 100644
> --- a/include/net/addrconf.h
> +++ b/include/net/addrconf.h
> @@ -405,6 +405,9 @@ static inline bool ip6_ignore_linkdown(const struct net_device *dev)
>  {
>         const struct inet6_dev *idev = __in6_dev_get(dev);
>
> +       if (unlikely(!idev))
> +               return true;
> +

Note that we might read a non NULL pointer here, but read it again
later in rt6_score_route(),
since another thread could switch the pointer under us ?

>         return !!idev->cnf.ignore_routes_with_linkdown;
>  }
>
> --
> 2.25.1
>
