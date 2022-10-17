Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FA3601317
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 17:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiJQP6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 11:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiJQP6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 11:58:32 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BF16DAD0
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 08:58:32 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id k3so13768204ybk.9
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 08:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NzD+Tg7PE9+gjhi7CR1d4v32mJlUuw67dSVHgFthTqY=;
        b=qUB9wf7YDVgTTusDwfF1LSudBlZMqkClxa5Wwb5/dWL+Vm+sMBsPncactMM4cedf2g
         y6DgHinJP47w4XzUzyGOizbkwoLAzddoYbu2KmwNTIDnif07+ptb0dW4gJM5sxxif9Bv
         JjiqLpRQJKHt4l7V3XwNhpdMtz4bUclQ+YeLol2r1OtYoRmg+sLQxSibAcboXMABsbKq
         fM6+LGGNWoCR6CsIuCDNnxp78PvS+Sv5/VBALmIpV9jLGV9dFLgw3d6J8M40lgFMqZbJ
         DFkUQ9qaSecfvlqtjCLwQyGpPH9jlEEYBz2K1066waFoqly5/m8V1VfybBOFXyDoaDyF
         EdWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NzD+Tg7PE9+gjhi7CR1d4v32mJlUuw67dSVHgFthTqY=;
        b=lahSE59wVtYBYwhIkW+nrBVvmnk0MjyzQMBdl2dnIlss4MPiqYmTWfxPrmHV2SprJ7
         KAyge+UViixv0sp1Fq0xhSeoITu6wlKh8hlP/wNb+C3KP/XvaJ4SxRhW7HC+nq32dRDh
         42TU+nq8Fcw3nOWM5PAYZ4afLMwfmHhCrJcfoKRH4s8ZXw131woL4uHxIjngeeB0ftLn
         ExY9xvX7qNXjVkwIhY0/I1VhkdFhPvdCfHKqbYhIUi5WTzg+0/ADELa433vCazH6IsDV
         4TzWVA9LfkAG87bjJKqFmMqSreZRvrWLPt4ADlZC1RHiE5Feal3FbHHbdTTWEhTpj7Vd
         2fjg==
X-Gm-Message-State: ACrzQf0rmcAF1ijTU2PZ1DoFsg9DvyRJ3yLgjArXLlcFvenapgA0iRiX
        Q7puxaqvkyHBqEALB76HNBYW0qOzgOI2QvaaUiP6xw==
X-Google-Smtp-Source: AMsMyM6Z9lsceeZJBtuJwGGuoDTbw9ZtMEo1D0AMTAWODwOc2QM6SomqLR3wA33MSS6d1henIDl81k9QfQT4VG1zbcc=
X-Received: by 2002:a25:3187:0:b0:6c1:822b:eab1 with SMTP id
 x129-20020a253187000000b006c1822beab1mr9350186ybx.427.1666022311003; Mon, 17
 Oct 2022 08:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <20221017080331.16878-1-shaozhengchao@huawei.com>
In-Reply-To: <20221017080331.16878-1-shaozhengchao@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 17 Oct 2022 08:58:17 -0700
Message-ID: <CANn89iJdZx=e2QN_AXPiZQDh4u4EY5dOrzgdsqgWTCpvLhJVcQ@mail.gmail.com>
Subject: Re: [PATCH net] ip6mr: fix UAF issue in ip6mr_sk_done() when
 addrconf_init_net() failed
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Mon, Oct 17, 2022 at 12:55 AM Zhengchao Shao
<shaozhengchao@huawei.com> wrote:
>
> If the initialization fails in calling addrconf_init_net(), devconf_all is
> the pointer that has been released. Then ip6mr_sk_done() is called to
> release the net, accessing devconf->mc_forwarding directly causes invalid
> pointer access.
>
> The process is as follows:
> setup_net()
>         ops_init()
>                 addrconf_init_net()
>                 all = kmemdup(...)           ---> alloc "all"
>                 ...
>                 net->ipv6.devconf_all = all;
>                 __addrconf_sysctl_register() ---> failed
>                 ...
>                 kfree(all);                  ---> ipv6.devconf_all invalid
>                 ...
>         ops_exit_list()
>                 ...
>                 ip6mr_sk_done()
>                         devconf = net->ipv6.devconf_all;
>                         //devconf is invalid pointer
>                         if (!devconf || !atomic_read(&devconf->mc_forwarding))
>
>
> Fixes: 7d9b1b578d67 ("ip6mr: fix use-after-free in ip6mr_sk_done()")

Hmmm. I wonder if you are not masking a more serious bug.

When I wrote this patch ( 7d9b1b578d67) I was following the standard
rule of ops->exit() being called
only if the corresponding ops->init() function had not failed.

net/core/net_namespace.c:setup_net() even has some comments about this rule:

out_undo:
        /* Walk through the list backwards calling the exit functions
         * for the pernet modules whose init functions did not fail.
         */
        list_add(&net->exit_list, &net_exit_list);
        saved_ops = ops;
        list_for_each_entry_continue_reverse(ops, &pernet_list, list)
                ops_pre_exit_list(ops, &net_exit_list);

        synchronize_rcu();

        ops = saved_ops;
        list_for_each_entry_continue_reverse(ops, &pernet_list, list)
                ops_exit_list(ops, &net_exit_list);

        ops = saved_ops;
        list_for_each_entry_continue_reverse(ops, &pernet_list, list)
                ops_free_list(ops, &net_exit_list);

        rcu_barrier();
        goto out;



> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/ipv6/addrconf.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 417834b7169d..9c3f5202a97b 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -7214,9 +7214,11 @@ static int __net_init addrconf_init_net(struct net *net)
>         __addrconf_sysctl_unregister(net, all, NETCONFA_IFINDEX_ALL);
>  err_reg_all:
>         kfree(dflt);
> +       net->ipv6.devconf_dflt = NULL;
>  #endif
>  err_alloc_dflt:
>         kfree(all);
> +       net->ipv6.devconf_all = NULL;
>  err_alloc_all:
>         kfree(net->ipv6.inet6_addr_lst);
>  err_alloc_addr:
> --
> 2.17.1
>
