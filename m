Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69DA52523E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356343AbiELQNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356338AbiELQNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:13:38 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB9B66FB9
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:13:37 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id e12so10607207ybc.11
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vt7MP0PbmXUxQ+wkYU+wnb7elFAgY/w8eCWJ3rsU/vc=;
        b=TI2en8Nx2BcAI+GUnyrlg6W0ZWD85E565784lyHMl1/31bQFmD/7ZzHKfQLL30aIZ4
         2ZLOnfFXOTG3Q/MOmnFUGj0HpFjPr6+WQhUWBRV3C+A4QFcaDGcYN6UW8Z2tzgyvyD3b
         A5nDnDYMEfyrKD27wM7lyGo8PN3WHY+thk9/HruU/0mMY/Ya9nJ66kfnC9/fapOg57/a
         Tj9ZUb20WB3CILLaDLBWZjqTd5GnBsgzRPx8WzPPPl9pYeuybtlOqUK7lP17H0ijQV+p
         zvErGVf2lrzY2tNcmDzYf5/QG0NzOVGGsCyWvkT0ZcqvK089SELi6qK7AobyPrjYDY+r
         smDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vt7MP0PbmXUxQ+wkYU+wnb7elFAgY/w8eCWJ3rsU/vc=;
        b=j/caeekPPTANxCLDpmWa8ybm7m3AreY4VFAPjFyPFnh50NsVJJ5Z3h2lxyKZ2niQtP
         1RkyCt1wVwZUaK3qaJtnBH45bdHVcgSwOfY+7fq51Zh0ewNppeK2WcQmCXTub6HyKnVK
         IyvpAvNX9Npwa+BOF5Q3wTNTtZ8Kb5/1qpPSZzA5NiOeSzNKL7C/gu1ccHhgEbYwNkSA
         UQL8oHdmzPURxhYDnhhtA3HNyfsIAHGaBJ25DpF1MqZa16uDSCIg8Tre23cipzrt/O0c
         uY313m/V8D8Ab8f9vVPAF+CUOd61V2ZP3y65aFCFuEc5E0JLsqawBxcR7GVagwZwqVkU
         kl7Q==
X-Gm-Message-State: AOAM531SGt6RWg5HBH99YMNVlBo1Rv1WL4BU9Ob6+oVA3wrc1Yz80RIJ
        JrhYn+98nZjg1HGff502w/77yGYUXlGG4uXw/H3pseDz331J+gaE
X-Google-Smtp-Source: ABdhPJw1hkuAz5MQnKJh6qjRiQxL19by2pTpSTu1t8n2FDXfZvnHoSY3tV8FFrFstIIqgZKrY/CzQUXp6aUUlIbW0RQ=
X-Received: by 2002:a25:8b88:0:b0:64b:8a2:aae4 with SMTP id
 j8-20020a258b88000000b0064b08a2aae4mr561814ybl.231.1652372016166; Thu, 12 May
 2022 09:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220511233757.2001218-11-eric.dumazet@gmail.com> <202205122132.HUrst9JA-lkp@intel.com>
In-Reply-To: <202205122132.HUrst9JA-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 May 2022 09:13:25 -0700
Message-ID: <CANn89i+kG-2uW+7iqqVjJN8Q+bZF82f+4qONsmg+4zuW+qj0Ug@mail.gmail.com>
Subject: Re: [PATCH net-next 10/10] inet: add READ_ONCE(sk->sk_bound_dev_if)
 in INET_MATCH()
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>
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

On Thu, May 12, 2022 at 6:16 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Eric,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-add-annotations-for-sk-sk_bound_dev_if/20220512-073914
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b57c7e8b76c646cf77ce4353a779a8b781592209
> config: hexagon-randconfig-r035-20220512 (https://download.01.org/0day-ci/archive/20220512/202205122132.HUrst9JA-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 18dd123c56754edf62c7042dcf23185c3727610f)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/c92cfd9f3ecb483ff055edb02f7498494b96ba68
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Eric-Dumazet/net-add-annotations-for-sk-sk_bound_dev_if/20220512-073914
>         git checkout c92cfd9f3ecb483ff055edb02f7498494b96ba68
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/ipv4/

Thank you for the instructions.
Unfortunately this is failing for me.

I have tested ARCH=i386 before sending the series, I am not sure what
the issue is for ARCH=hexagon and the cross compiler.

Maybe __always_unused is not yet understood for this combination.

It might be the time to just use __addrpair even on 32bit arches...

Then we can remove saddr,daddr args from INET_MATCH()

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 5d3fa071d754601149c9ad0dd559f074ac58deaa..34ddb54506dd02e702dd20cbe8b7dba006130c5a
100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -295,7 +295,6 @@ static inline struct sock
*inet_lookup_listener(struct net *net,
        ((__force __portpair)(((__u32)(__dport) << 16) | (__force
__u32)(__be16)(__sport)))
 #endif

-#if (BITS_PER_LONG == 64)
 #ifdef __BIG_ENDIAN
 #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
        const __addrpair __name = (__force __addrpair) ( \
@@ -325,30 +324,6 @@ static inline bool INET_MATCH(const struct sock
*sk, struct net *net,
        bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
        return bound_dev_if == dif || bound_dev_if == sdif;
 }
-#else /* 32-bit arch */
-#define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
-       const int __name __deprecated __always_unused
-
-static inline bool INET_MATCH(const struct sock *sk, struct net *net,
-                             const __addrpair __always_unused cookie,
-                             const __be32 saddr,
-                             const __be32 daddr,
-                             const __portpair ports,
-                             const int dif,
-                             const int sdif)
-{
-       int bound_dev_if;
-
-       if (!net_eq(sock_net(sk), net) ||
-           sk->sk_portpair != ports ||
-           sk->sk_daddr != saddr ||
-           sk->sk_rcv_saddr != daddr)
-               return false;
-
-       bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
-       return bound_dev_if == dif || bound_dev_if == sdif;
-}
-#endif /* 64-bit arch */


I will cook a small patch to simplify INET_MATCH(), then if/when
merged, I will resend the pach series about sk_bound_dev_if.

Thanks.




>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> net/ipv4/inet_hashtables.c:413:34: warning: variable 'acookie' is uninitialized when used here [-Wuninitialized]
>                    if (likely(INET_MATCH(sk, net, acookie,
>                                                   ^~~~~~~
>    include/linux/compiler.h:77:40: note: expanded from macro 'likely'
>    # define likely(x)      __builtin_expect(!!(x), 1)
>                                                ^
>    net/ipv4/inet_hashtables.c:398:2: note: variable 'acookie' is declared here
>            INET_ADDR_COOKIE(acookie, saddr, daddr);
>            ^
>    include/net/inet_hashtables.h:330:2: note: expanded from macro 'INET_ADDR_COOKIE'
>            const int __name __deprecated __always_unused
>            ^
>    net/ipv4/inet_hashtables.c:468:35: warning: variable 'acookie' is uninitialized when used here [-Wuninitialized]
>                    if (likely(INET_MATCH(sk2, net, acookie,
>                                                    ^~~~~~~
>    include/linux/compiler.h:77:40: note: expanded from macro 'likely'
>    # define likely(x)      __builtin_expect(!!(x), 1)
>                                                ^
>    net/ipv4/inet_hashtables.c:452:2: note: variable 'acookie' is declared here
>            INET_ADDR_COOKIE(acookie, saddr, daddr);
>            ^
>    include/net/inet_hashtables.h:330:2: note: expanded from macro 'INET_ADDR_COOKIE'
>            const int __name __deprecated __always_unused
>            ^
>    net/ipv4/inet_hashtables.c:535:38: warning: variable 'acookie' is uninitialized when used here [-Wuninitialized]
>                            if (unlikely(INET_MATCH(esk, net, acookie,
>                                                              ^~~~~~~
>    include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
>    # define unlikely(x)    __builtin_expect(!!(x), 0)
>                                                ^
>    net/ipv4/inet_hashtables.c:529:2: note: variable 'acookie' is declared here
>            INET_ADDR_COOKIE(acookie, sk->sk_daddr, sk->sk_rcv_saddr);
>            ^
>    include/net/inet_hashtables.h:330:2: note: expanded from macro 'INET_ADDR_COOKIE'
>            const int __name __deprecated __always_unused
>            ^
>    3 warnings generated.
> --
> >> net/ipv4/udp.c:2566:27: warning: variable 'acookie' is uninitialized when used here [-Wuninitialized]
>                    if (INET_MATCH(sk, net, acookie, rmt_addr,
>                                            ^~~~~~~
>    net/ipv4/udp.c:2561:2: note: variable 'acookie' is declared here
>            INET_ADDR_COOKIE(acookie, rmt_addr, loc_addr);
>            ^
>    include/net/inet_hashtables.h:330:2: note: expanded from macro 'INET_ADDR_COOKIE'
>            const int __name __deprecated __always_unused
>            ^
>    1 warning generated.
>
>
> vim +/acookie +413 net/ipv4/inet_hashtables.c
>
> 2c13270b441054 Eric Dumazet     2015-03-15  391
> c67499c0e77206 Pavel Emelyanov  2008-01-31  392  struct sock *__inet_lookup_established(struct net *net,
> c67499c0e77206 Pavel Emelyanov  2008-01-31  393                                   struct inet_hashinfo *hashinfo,
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  394                                   const __be32 saddr, const __be16 sport,
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  395                                   const __be32 daddr, const u16 hnum,
> 3fa6f616a7a4d0 David Ahern      2017-08-07  396                                   const int dif, const int sdif)
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  397  {
> c7228317441f4d Joe Perches      2014-05-13  398         INET_ADDR_COOKIE(acookie, saddr, daddr);
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  399         const __portpair ports = INET_COMBINED_PORTS(sport, hnum);
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  400         struct sock *sk;
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  401         const struct hlist_nulls_node *node;
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  402         /* Optimize here for direct hit, only listening connections can
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  403          * have wildcards anyways.
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  404          */
> 9f26b3add3783c Pavel Emelyanov  2008-06-16  405         unsigned int hash = inet_ehashfn(net, daddr, hnum, saddr, sport);
> f373b53b5fe67a Eric Dumazet     2009-10-09  406         unsigned int slot = hash & hashinfo->ehash_mask;
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  407         struct inet_ehash_bucket *head = &hashinfo->ehash[slot];
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  408
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  409  begin:
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  410         sk_nulls_for_each_rcu(sk, node, &head->chain) {
> ce43b03e888947 Eric Dumazet     2012-11-30  411                 if (sk->sk_hash != hash)
> ce43b03e888947 Eric Dumazet     2012-11-30  412                         continue;
> ce43b03e888947 Eric Dumazet     2012-11-30 @413                 if (likely(INET_MATCH(sk, net, acookie,
> 3fa6f616a7a4d0 David Ahern      2017-08-07  414                                       saddr, daddr, ports, dif, sdif))) {
> 41c6d650f6537e Reshetova, Elena 2017-06-30  415                         if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> 05dbc7b59481ca Eric Dumazet     2013-10-03  416                                 goto out;
> ce43b03e888947 Eric Dumazet     2012-11-30  417                         if (unlikely(!INET_MATCH(sk, net, acookie,
> 3fa6f616a7a4d0 David Ahern      2017-08-07  418                                                  saddr, daddr, ports,
> 3fa6f616a7a4d0 David Ahern      2017-08-07  419                                                  dif, sdif))) {
> 05dbc7b59481ca Eric Dumazet     2013-10-03  420                                 sock_gen_put(sk);
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  421                                 goto begin;
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  422                         }
> 05dbc7b59481ca Eric Dumazet     2013-10-03  423                         goto found;
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  424                 }
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  425         }
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  426         /*
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  427          * if the nulls value we got at the end of this lookup is
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  428          * not the expected one, we must restart lookup.
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  429          * We probably met an item that was moved to another chain.
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  430          */
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  431         if (get_nulls_value(node) != slot)
> 3ab5aee7fe840b Eric Dumazet     2008-11-16  432                 goto begin;
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  433  out:
> 05dbc7b59481ca Eric Dumazet     2013-10-03  434         sk = NULL;
> 05dbc7b59481ca Eric Dumazet     2013-10-03  435  found:
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  436         return sk;
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  437  }
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  438  EXPORT_SYMBOL_GPL(__inet_lookup_established);
> 77a5ba55dab7b4 Pavel Emelyanov  2007-12-20  439
>
> --
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
