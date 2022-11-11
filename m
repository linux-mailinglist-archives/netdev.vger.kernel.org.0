Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4C7625F7F
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 17:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbiKKQ3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 11:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234292AbiKKQ3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 11:29:03 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA1C742ED
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 08:29:02 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 63so6408943ybq.4
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 08:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0BFAQmnkuUvPtfFGhzAbsEdzBkK1S4afgbyRM7b2v0A=;
        b=Ao7rkqlr1IqQ8Co3/EvS+n/pfEYybDyougTAPYEhZGZp2ajnzR+VfCxH3SmlqCaz1W
         bIHzAw2Rf5XtqgSYaayVeQuag5UH31Ct90DvfKTkiCY/pWbfjgQLm4tF6MO3/MzydX/f
         2R12od8pwwg6MCKUp8NgIe7t8DiwqEktGCc4uG/7vQIuvlwCgss0LpeLI/YYPV65SKLq
         gBbosT1kZ/wV6oLMRerCe21r6jEehyNwsENxvXaRKz/Vy8r0U6FZSyDDbbev2Lp/TCyC
         5LJGGduuWgX0nj0fz8cU5l6K0XJLqtw9YLZiH71YWDZ/jgj787INXA+0d07C2VQvpYD3
         xIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0BFAQmnkuUvPtfFGhzAbsEdzBkK1S4afgbyRM7b2v0A=;
        b=EsqjKCh5z8eJtwPsxf83eTsBFIavYMpQchYM6Bu6hS60Ie5POpiVlWLiPLWplLbMtZ
         fbCvMLBlFhXEiORLngh37+wK7GtHbgOhrRX2lClC38QE1AM4Ke5vsCqFfD7x67ws6nN8
         DJ4Nqx3k4iZMhsd0MQZYhnmB+WQvHWjlaSSN8TfHPtDcqWAzQdDce0zY9TrQBO7uyCpA
         wse/I2aZTFESNrZcCnTehmj85xTRar/cuuZAkc2C2go4bH3IMGJBKlMnB1heARlP6GNH
         ts47iI6SPk03djsyUC0YdKLIsXz5qL6iSdoomqcq7vIPFxkuGEW11AFqhUoqar8gjwYS
         qY0w==
X-Gm-Message-State: ANoB5plRvO3h75I09H5xS49YEKnJF5i4T4y8iDVADNQS94gfYatDLO3l
        RHgat50ZVwXh9lOl7lC2bZnqYWLjoyPmTEnvdwLQTQ==
X-Google-Smtp-Source: AA0mqf4DUZuramY0kcNIRn3tW+ZtztdQq8I2YOCSKpV1GfrHD9H+TeKfaPUUqKudC1PkAvBt8M+gZnHtuCPV9OCCtq0=
X-Received: by 2002:a5b:886:0:b0:6cb:7ce0:9e8e with SMTP id
 e6-20020a5b0886000000b006cb7ce09e8emr2496635ybq.55.1668184141005; Fri, 11 Nov
 2022 08:29:01 -0800 (PST)
MIME-Version: 1.0
References: <1668160371-39153-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1668160371-39153-1-git-send-email-wangyufen@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Nov 2022 08:28:50 -0800
Message-ID: <CANn89iKVBkbd=vmg0edybmStkDo+zM6N3BP2=71mNZmCG=T6HQ@mail.gmail.com>
Subject: Re: [PATCH] net: fix memory leak in security_sk_alloc()
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        martin.lau@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        pabeni@redhat.com, kuba@kernel.org,
        Stanislav Fomichev <sdf@google.com>
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

On Fri, Nov 11, 2022 at 1:32 AM Wang Yufen <wangyufen@huawei.com> wrote:
>
> kmemleak reports this issue:
>
> unreferenced object 0xffff88810b7835c0 (size 32):
>   comm "test_progs", pid 270, jiffies 4294969007 (age 1621.315s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000376cdeab>] kmalloc_trace+0x27/0x110
>     [<000000003bcdb3b6>] selinux_sk_alloc_security+0x66/0x110
>     [<000000003959008f>] security_sk_alloc+0x47/0x80
>     [<00000000e7bc6668>] sk_prot_alloc+0xbd/0x1a0
>     [<0000000002d6343a>] sk_alloc+0x3b/0x940
>     [<000000009812a46d>] unix_create1+0x8f/0x3d0
>     [<000000005ed0976b>] unix_create+0xa1/0x150
>     [<0000000086a1d27f>] __sock_create+0x233/0x4a0
>     [<00000000cffe3a73>] __sys_socket_create.part.0+0xaa/0x110
>     [<0000000007c63f20>] __sys_socket+0x49/0xf0
>     [<00000000b08753c8>] __x64_sys_socket+0x42/0x50
>     [<00000000b56e26b3>] do_syscall_64+0x3b/0x90
>     [<000000009b4871b8>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> The issue occurs in the following scenarios:
>
> unix_create1()
>   sk_alloc()
>     sk_prot_alloc()
>       security_sk_alloc()
>         call_int_hook()
>           hlist_for_each_entry()
>             entry1->hook.sk_alloc_security
>             <-- selinux_sk_alloc_security() succeeded,
>             <-- sk->security alloced here.
>             entry2->hook.sk_alloc_security
>             <-- bpf_lsm_sk_alloc_security() failed
>       goto out_free;
>         ...    <-- the sk->security not freed, memleak
>
> To fix, if security_sk_alloc() failed and sk->security not null,
> goto out_free_sec to reclaim resources.
>
> I'm not sure whether this fix makes sense, but if hook lists don't
> support this usage, might need to modify the
> "tools/testing/selftests/bpf/progs/lsm_cgroup.c" test case.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Really the bug has not been added in linux-2.6.12, but this year with
bpf lsm ...

> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> Cc: Stanislav Fomichev <sdf@google.com>
> ---
>  net/core/sock.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index a3ba035..e457a9d 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2030,8 +2030,11 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
>                 sk = kmalloc(prot->obj_size, priority);
>
>         if (sk != NULL) {
> -               if (security_sk_alloc(sk, family, priority))
> +               if (security_sk_alloc(sk, family, priority)) {

This does not make sense.

A proper fix should be in security_sk_alloc(), not in callers.

(Even if there is one caller today,)

> +                       if (sk->sk_security)
> +                               goto out_free_sec;
>                         goto out_free;
> +               }
>
>                 if (!try_module_get(prot->owner))
>                         goto out_free_sec;
> --
> 1.8.3.1
>
