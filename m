Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B0B602139
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 04:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiJRCeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 22:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiJRCd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 22:33:59 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708759410A
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 19:33:58 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-3560e81aa1dso124968187b3.2
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 19:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RmYMH/D9o69ljuh0b19U75FUwWrsC/vK99UC/3PjRHE=;
        b=EIXWrVxbarYXs3cqFWdo74LmkBf9bDYrAXRiVC8rx0Ln+EJ79qx6CrYCo1GDUZWB7P
         rb6V4q7xtX3uOrmlhdm7vpeN7R795mAzE6fE/1bUYlYxIdGRBIlGwLsTXohu83eEFsMT
         PvUnUtnw0TUP+T/COdMB4me2I7q1RvsHtEmPf1+i7juPhEJNaQthxYai66wmaUNXOUvV
         AUwCt2gvbbGAhPVRo3NE3ybyudrFHYT7XAYT2KPaMqUd+LHWIIBWJtTGZvF80aEqS3Oj
         1cZP8ry5PYJyp4N0z0+OxmJsUtvGuhhe7XC1wvFJ9hT4DmMXI98KDOMTkN3LO6w/bOLi
         yAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RmYMH/D9o69ljuh0b19U75FUwWrsC/vK99UC/3PjRHE=;
        b=cIswGJ06wYmZn5TP3a6ssNx4HAdeagu2NbwMJBrRlgoF70fKB+ma8tIfSkP85c2w8B
         8YZyjEoysQpFFULncQE5xtgWU1LwIZtsYwqKW225nYNFha4rhIpxSrgauX8lCRWUfPFu
         UlLybzVcMBZhJW3BEW0QpRBTHbNqIBty91jLPJEoLitrUcvBtsZ9PKNvePwV0gmYMmkg
         2WdMNNBpwiW+mq2DwE3mAegfhJ9RyJggseykvdoL8j0aeidqrXhzWeGmAE79cZGQ9EYH
         fkQI37yUZvnXfa09tsTvMrkwt1PIlaNdpHE8UOcbAA0O1TI0hdH7sfFkYJfdSCMmqDdO
         a60A==
X-Gm-Message-State: ACrzQf0vSnQVy3tVOB7XB4c+J3AojZiQLUBKYWZmDsIwA3omlrLjbpeo
        BFhTeJJFv8Njva2GWJjYEogK8pKno29D39e1e1lMP/Bb1zbhZQ==
X-Google-Smtp-Source: AMsMyM5oDQcNMkomPx89pQ+miuPJECyB81V+9S9nmKgkMmNyawtyycMFJ9JWjln/6SjwXkiAh4M67V5oCMrPjnjiAGk=
X-Received: by 2002:a81:9202:0:b0:35e:face:a087 with SMTP id
 j2-20020a819202000000b0035efacea087mr649349ywg.55.1666060437411; Mon, 17 Oct
 2022 19:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <20221017080331.16878-1-shaozhengchao@huawei.com>
 <CANn89iJdZx=e2QN_AXPiZQDh4u4EY5dOrzgdsqgWTCpvLhJVcQ@mail.gmail.com> <c482c66b-a455-ff6e-7a6a-a8c5d717c457@huawei.com>
In-Reply-To: <c482c66b-a455-ff6e-7a6a-a8c5d717c457@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 17 Oct 2022 19:33:46 -0700
Message-ID: <CANn89iJVFVZwcbZbE8zHUct+UOZNXrwi64Xi0GosP5N+ohPZtg@mail.gmail.com>
Subject: Re: [PATCH net] ip6mr: fix UAF issue in ip6mr_sk_done() when
 addrconf_init_net() failed
To:     shaozhengchao <shaozhengchao@huawei.com>
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

On Mon, Oct 17, 2022 at 6:48 PM shaozhengchao <shaozhengchao@huawei.com> wrote:
>
>
>
> On 2022/10/17 23:58, Eric Dumazet wrote:
> > On Mon, Oct 17, 2022 at 12:55 AM Zhengchao Shao
> > <shaozhengchao@huawei.com> wrote:
> >>
> >> If the initialization fails in calling addrconf_init_net(), devconf_all is
> >> the pointer that has been released. Then ip6mr_sk_done() is called to
> >> release the net, accessing devconf->mc_forwarding directly causes invalid
> >> pointer access.
> >>
> >> The process is as follows:
> >> setup_net()
> >>          ops_init()
> >>                  addrconf_init_net()
> >>                  all = kmemdup(...)           ---> alloc "all"
> >>                  ...
> >>                  net->ipv6.devconf_all = all;
> >>                  __addrconf_sysctl_register() ---> failed
> >>                  ...
> >>                  kfree(all);                  ---> ipv6.devconf_all invalid
> >>                  ...
> >>          ops_exit_list()
> >>                  ...
> >>                  ip6mr_sk_done()
> >>                          devconf = net->ipv6.devconf_all;
> >>                          //devconf is invalid pointer
> >>                          if (!devconf || !atomic_read(&devconf->mc_forwarding))
> >>
> >>
> >> Fixes: 7d9b1b578d67 ("ip6mr: fix use-after-free in ip6mr_sk_done()")
> >
> > Hmmm. I wonder if you are not masking a more serious bug.
> >
> > When I wrote this patch ( 7d9b1b578d67) I was following the standard
> > rule of ops->exit() being called
> > only if the corresponding ops->init() function had not failed.
> >
> > net/core/net_namespace.c:setup_net() even has some comments about this rule:
> >
> > out_undo:
> >          /* Walk through the list backwards calling the exit functions
> >           * for the pernet modules whose init functions did not fail.
> >           */
> >          list_add(&net->exit_list, &net_exit_list);
> >          saved_ops = ops;
> >          list_for_each_entry_continue_reverse(ops, &pernet_list, list)
> >                  ops_pre_exit_list(ops, &net_exit_list);
> >
> >          synchronize_rcu();
> >
> >          ops = saved_ops;
> >          list_for_each_entry_continue_reverse(ops, &pernet_list, list)
> >                  ops_exit_list(ops, &net_exit_list);
> >
> >          ops = saved_ops;
> >          list_for_each_entry_continue_reverse(ops, &pernet_list, list)
> >                  ops_free_list(ops, &net_exit_list);
> >
> >          rcu_barrier();
> >          goto out;
> >
> >
> Hi Eric:
>         Thank you for your reply. I wonder if fixing commit
> e0da5a480caf ("[NETNS]: Create ipv6 devconf-s for namespaces")
> would be more appropriate?

Do you have a repro ?

You could first use scripts/decode_stack.pl to get symbols from your
traces, to confirm the issue.

Freed by task 14554:
kasan_save_stack+0x1e/0x40
kasan_set_track+0x21/0x30
kasan_save_free_info+0x2a/0x40
____kasan_slab_free+0x155/0x1b0
slab_free_freelist_hook+0x11b/0x220
__kmem_cache_free+0xa4/0x360
addrconf_init_net+0x623/0x840
ops_init+0xa5/0x410
setup_net+0x5aa/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

>
> Zhengchao Shao
>
> >
> >> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> >> ---
> >>   net/ipv6/addrconf.c | 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> >> index 417834b7169d..9c3f5202a97b 100644
> >> --- a/net/ipv6/addrconf.c
> >> +++ b/net/ipv6/addrconf.c
> >> @@ -7214,9 +7214,11 @@ static int __net_init addrconf_init_net(struct net *net)
> >>          __addrconf_sysctl_unregister(net, all, NETCONFA_IFINDEX_ALL);
> >>   err_reg_all:
> >>          kfree(dflt);
> >> +       net->ipv6.devconf_dflt = NULL;
> >>   #endif
> >>   err_alloc_dflt:
> >>          kfree(all);
> >> +       net->ipv6.devconf_all = NULL;
> >>   err_alloc_all:
> >>          kfree(net->ipv6.inet6_addr_lst);
> >>   err_alloc_addr:
> >> --
> >> 2.17.1
> >>
