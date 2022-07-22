Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F320757DD06
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 11:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbiGVJAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiGVJAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:00:17 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2201DCC5
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:00:14 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-31bf3656517so40817697b3.12
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v/5aGhRoCHpFwV3qQjvwLeTWWInrloa7ON/9UyObNn4=;
        b=MWcTGmD4Lx9Tkn9xBtsn+tr4EuHYDuek8ixUxVXKG/QroY3v5SujnvaIyt/2cSewOr
         SIdK1qzvtsCQzdic/vSqYZDMTw0rXnCsoMB16nUi1H3uLAU1F4f7NINnYD4tKdvOdv2s
         qUdc6xHkVnzOmaZdWMw9bBOHRcdL5SFfmDD/F2flOTqqhR0/V9N8a8YFykjhZxB/6ka5
         ydR429E1KfZ6O/Ecr8Ng1ETKE24IjX9WUW3CF/cMZ5CC1GI1HH8CNXq9l80XZB7aHrLu
         t5AwszV265/1e+fLhJf1xOYIXqMeZlzTIZ7ygojq7Gz6R3b/0Uo1nnYanzDEd4SROqj+
         B/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v/5aGhRoCHpFwV3qQjvwLeTWWInrloa7ON/9UyObNn4=;
        b=Xwl2Ck1l3Mpoj/E6981VnWAzFB3kukuZv7utWuWK8jWCb6h5L6pCoSyD3r1gtjj9ZI
         EElGT77JU9Ngj7Gy7rcMKBVnoBmGj++cB6bCoypjs/Pmz9u1s0WEeIfjoMKwUjLhF1NA
         wPQUoQEY05ZhMemSN599XmBJmvx4WxjLIplLqT/8GxijrYRkqJC+qC1ZmD9rKPwBaGAU
         WrAvpWoPBHzAao8KEfpfYgT+Kwa+vq/YOhVOL3GvOMJ665tTGrDtyxdxEsZY5tvboHQQ
         +TrfMpY041aK7KusrzR+TklvFcN4dJciL3HXauaTseJ40wJbzv28jlfRylHAtsjHIs/f
         vd5Q==
X-Gm-Message-State: AJIora9Gi+XphfEvGKhZOdsWh0ZZioJwViqADIqFhVPZFPYx/SY8GYm6
        SOSzrgfnAS1mt2+zlivMjnkkTIAx9i4UHQOm5ucMOIt5Vis=
X-Google-Smtp-Source: AGRyM1ul/j0oQNstfeNuzgp2pIBZKLG0rMmpW8fWszcMoX39RJsUGt6YqesJD7QxVVnQBMZtE5nzkCJYQRVA+3hdXxE=
X-Received: by 2002:a05:690c:730:b0:31e:6237:533e with SMTP id
 bt16-20020a05690c073000b0031e6237533emr2203648ywb.55.1658480412986; Fri, 22
 Jul 2022 02:00:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220722074153.2454007-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220722074153.2454007-1-william.xuanziyang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Jul 2022 11:00:01 +0200
Message-ID: <CANn89iKWr-VJVus9GbafrghR2MKUz64sX9fg1YA=oHE0SYdZCg@mail.gmail.com>
Subject: Re: [net] ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 9:42 AM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
>
> Change net device's MTU to smaller than IPV6_MIN_MTU or unregister
> device while matching route. That may trigger null-ptr-deref bug
> for ip6_ptr probability as following.
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
> And in order to increase the probability of reproduce,
> we can add mdelay() in find_match() as following:
>
> static bool find_match(struct fib6_nh *nh, u32 fib6_flags,
>         if (nh->fib_nh_flags & RTNH_F_DEAD)
>                 goto out;
>
> +       mdelay(1000);

But adding a mdelay() in an rcu_read_lock() should not be possible.

I guess this means _this_ function is not properly using rcu protection.

>         if (ip6_ignore_linkdown(nh->fib_nh_dev) &&
>             nh->fib_nh_flags & RTNH_F_LINKDOWN &&
>             !(strict & RT6_LOOKUP_F_IGNORE_LINKSTATE))
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
>  sock_sendmsg+0x8c/0xb0
>
> It is because ip6_ptr has been assigned to NULL in addrconf_ifdown(),
> and ip6_ignore_linkdown() in find_match() accesses ip6_ptr directly.
> Although find_match() routine is under rcu_read_lock(), but there is
> not synchronize_net() before assign NULL to make rcu grace period end.
>

This is not how RCU works.

> So we can add synchronize_net() before assign ip6_ptr to NULL in
> addrconf_ifdown() to fix the null-ptr-deref bug.

This does not make sense to me.

>
> Fixes: 8814c4b53381 ("[IPV6] ADDRCONF: Convert addrconf_lock to RCU.")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/ipv6/addrconf.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 49cc6587dd77..63d33b29ad21 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -3757,6 +3757,7 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
>                 idev->dead = 1;
>
>                 /* protected by rtnl_lock */
> +               synchronize_net();

I do not think we want yet another expensive synchronize_net(),
especially  before setting ip6_ptr to NULL



>                 RCU_INIT_POINTER(dev->ip6_ptr, NULL);
>
>                 /* Step 1.5: remove snmp6 entry */
> --
> 2.25.1
>
