Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7292F5A2B23
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbiHZP0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344526AbiHZPZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:25:01 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5689412AB1
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:20:18 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-33da3a391d8so44278817b3.2
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=fHBBM1OLk/xoOhKyacBzlN1wekNRqbx5WNXFqgp7row=;
        b=H/TUUPDrXyDpqRV7Lyp/PA8zzzDW9v54FM5LBg2mVCrdI31VAofqoY6VrtiLBYsb1f
         DHneMHgg1aWq6Ng65kCnXzEF8mg3YmA9BXmt8X0/EeHSOb5Ks+CKb/Ja7XNNJuwoNJ07
         7P9ocTP45/vu61xBXZ9p9eXBxbXBA9sPx959vIkLFauOAMVBxWqchBQrZ5foMHNxA+PX
         nHWbL1adYybhueQ/eDTJIi9GwnRP6y9UA1haBjQJOFFYohFSXvybyZHPx+dNpwGnwYDx
         yyc96RirJviVZbQ13CVANFFPsINg1qeL0gp65DEHcWX0U36Ng6omNzXwzy0VHF+l+NHu
         jlgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=fHBBM1OLk/xoOhKyacBzlN1wekNRqbx5WNXFqgp7row=;
        b=XJq0MmUO5JRER8DlUYyDg73OHG1bCvpQaWRnW0U+9XytYK6ijhB69799nqojxpVepU
         0zOFJW7OyKgS1XNBy57Tar/UJrHnuHgC2YSbiRU3ARtXipUyxd2ebN1nY6lhabay44u3
         LO4OIRr3ZlXQbHc7qffErYu5hhYoWaaqHF/9tcq0jpHuqtdRyp+Pd8oXYklnJXL9p2Vc
         Z73Xc0AmJNm+ZKsULOudPok1bfeJo8DdcCxWNEhyuXUM0nMMN3xZcYXM0ZPB+iIMFNJP
         YEzt10o4I4iNr+fO1GR/yki366GWnUk3w6aceNlFrkAhj/qc6bKSd6J1UGZVHeKh1wxn
         Pxew==
X-Gm-Message-State: ACgBeo17gPj3KD0ybE9cHYZmAsbjMQ+/029E+JL9jXjIC+Axf7FJ5NTw
        O4nK+VHNlei84szn3iOpEfu3OLLnuNEOLWbVTMiBzw==
X-Google-Smtp-Source: AA6agR44Ahh4VQhTlLmX9Bb9/64T1AhqiQCnUDGh7OtOKoc3vpU1qPaOUOzdEXJ7fuPFcRtLeFfjfUQpln/WGKKsMOI=
X-Received: by 2002:a05:6902:1081:b0:695:e7c8:886b with SMTP id
 v1-20020a056902108100b00695e7c8886bmr160847ybu.598.1661527217993; Fri, 26 Aug
 2022 08:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220826000445.46552-1-kuniyu@amazon.com> <20220826000445.46552-5-kuniyu@amazon.com>
In-Reply-To: <20220826000445.46552-5-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Aug 2022 08:20:06 -0700
Message-ID: <CANn89i+7dwkOnKRhiK6-bNi-aK9n885muc4u_RnTCUt-AxyoQg@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 04/13] net: Introduce init2() for pernet_operations.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 5:06 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> This patch adds a new init function for pernet_operations, init2().

Why ?

This seems not really needed...

TCP ops->init can trivially reach the parent net_ns if needed,
because the current process is the one doing the creation of a new net_ns.

>
> We call each init2() during clone() or unshare() only, where we can
> access the parent netns for a child netns creation.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/net_namespace.h |  3 +++
>  net/core/net_namespace.c    | 18 +++++++++++-------
>  2 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index 8c3587d5c308..3ca426649756 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -410,6 +410,8 @@ struct pernet_operations {
>          * from register_pernet_subsys(), unregister_pernet_subsys()
>          * register_pernet_device() and unregister_pernet_device().
>          *
> +        * init2() is called during clone() or unshare() only.
> +        *
>          * Exit methods using blocking RCU primitives, such as
>          * synchronize_rcu(), should be implemented via exit_batch.
>          * Then, destruction of a group of net requires single
> @@ -422,6 +424,7 @@ struct pernet_operations {
>          * the calls.
>          */
>         int (*init)(struct net *net);
> +       int (*init2)(struct net *net, struct net *old_net);
>         void (*pre_exit)(struct net *net);
>         void (*exit)(struct net *net);
>         void (*exit_batch)(struct list_head *net_exit_list);
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index 6b9f19122ec1..b120ff97d9f5 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -116,7 +116,8 @@ static int net_assign_generic(struct net *net, unsigned int id, void *data)
>         return 0;
>  }
>
> -static int ops_init(const struct pernet_operations *ops, struct net *net)
> +static int ops_init(const struct pernet_operations *ops,
> +                   struct net *net, struct net *old_net)
>  {
>         int err = -ENOMEM;
>         void *data = NULL;
> @@ -133,6 +134,8 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
>         err = 0;
>         if (ops->init)
>                 err = ops->init(net);
> +       if (!err && ops->init2 && old_net)
> +               err = ops->init2(net, old_net);

If an error comes here, while ops->init() was a success, we probably
leave things in a bad state (memory leak ?)

>         if (!err)
>                 return 0;
>
> @@ -301,7 +304,8 @@ EXPORT_SYMBOL_GPL(get_net_ns_by_id);
>  /*
>   * setup_net runs the initializers for the network namespace object.
>   */
> -static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
> +static __net_init int setup_net(struct net *net, struct net *old_net,
> +                               struct user_namespace *user_ns)
>  {
>         /* Must be called with pernet_ops_rwsem held */
>         const struct pernet_operations *ops, *saved_ops;
> @@ -323,7 +327,7 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
>         mutex_init(&net->ipv4.ra_mutex);
>
>         list_for_each_entry(ops, &pernet_list, list) {
> -               error = ops_init(ops, net);
> +               error = ops_init(ops, net, old_net);
>                 if (error < 0)
>                         goto out_undo;
>         }
> @@ -469,7 +473,7 @@ struct net *copy_net_ns(unsigned long flags,
>         if (rv < 0)
>                 goto put_userns;
>
> -       rv = setup_net(net, user_ns);
> +       rv = setup_net(net, old_net, user_ns);
>
>         up_read(&pernet_ops_rwsem);
>
> @@ -1107,7 +1111,7 @@ void __init net_ns_init(void)
>         init_net.key_domain = &init_net_key_domain;
>  #endif
>         down_write(&pernet_ops_rwsem);
> -       if (setup_net(&init_net, &init_user_ns))
> +       if (setup_net(&init_net, NULL, &init_user_ns))
>                 panic("Could not setup the initial network namespace");
>
>         init_net_initialized = true;
> @@ -1148,7 +1152,7 @@ static int __register_pernet_operations(struct list_head *list,
>
>                         memcg = mem_cgroup_or_root(get_mem_cgroup_from_obj(net));
>                         old = set_active_memcg(memcg);
> -                       error = ops_init(ops, net);
> +                       error = ops_init(ops, net, NULL);
>                         set_active_memcg(old);
>                         mem_cgroup_put(memcg);
>                         if (error)
> @@ -1188,7 +1192,7 @@ static int __register_pernet_operations(struct list_head *list,
>                 return 0;
>         }
>
> -       return ops_init(ops, &init_net);
> +       return ops_init(ops, &init_net, NULL);
>  }
>
>  static void __unregister_pernet_operations(struct pernet_operations *ops)
> --
> 2.30.2
>
