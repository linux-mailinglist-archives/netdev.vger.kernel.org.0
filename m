Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0025E217F35
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 07:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgGHFpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 01:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGHFpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 01:45:42 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D416C061755;
        Tue,  7 Jul 2020 22:45:42 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e13so40457464qkg.5;
        Tue, 07 Jul 2020 22:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=awhi+d5wH5Wdxkd6k5FS41hq5b4RJZc0gvjBaeKmGSM=;
        b=NBsOeke/oxzNWeKEHcXODw1lC4XSB+pceiaSLAJvojde2Rea6euQfJ2M+ZkS/6piJu
         4/Xfj/6x/KpARk7zomAfcx3DYLfWRDvnC90ueUGwhVgbRew5Hh0DyTx8QSFhL4n8GNm4
         m/cqv7C0PTF5RuXPA9HfA4u0h6270YG2/pyg7kxqdezZSpMwFd7SRC2boCpBDQDNGAhV
         LvejYVmS4Bf3ixdAuNFR405UACzHAgwxbZfkh6Q3pdKNaRfJ8PmOGzFHt6MYx2Yintp4
         4POYGquEPFImIU3m5k57qcCEDLgfILbHqI92Mrka6C2Q4eDuH9bZelieQInPZ4Qjsi/Z
         2BUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=awhi+d5wH5Wdxkd6k5FS41hq5b4RJZc0gvjBaeKmGSM=;
        b=Ud1CfAkOmrJSjrCfDuJT9S2eEbD0LgzBbEkfl62wA8X5ECqiYr53sUWt0aoIfkL4YU
         N4dHociPnWSyDzukb0AgIW39NvZgMKUwfIC1//1ahCsJs9AAi0oi4RB8kasYg4U4Du39
         3canbrCE+JYXTZLVgYGAMLiAgt8rvW4WaV0sSfXf+/ybZiI0VjAp3Ko481eE/Hv+CoGt
         D3iTYcC3qDjt04qmgOrgfc6c/XOXkfd2gINLhfGfcsuWu5BbML6xgQgtDu5gA3lKi+pY
         6VhLbwhWVDJ4voR7xJo5Fjsk3eST0jWPBT4sDtffPPj1M4Z3cR+6bU/qTbPAMt+oibo8
         n2yg==
X-Gm-Message-State: AOAM532aiqAT1UpHqKvsrAKstsYjh/fPIYXVC6EYVNsxMUAmWzMlj8xU
        eRD8GEdMOhLnDH/yLkIQ0biCX1V+PXZmk3Ogy3U=
X-Google-Smtp-Source: ABdhPJz5fHUsLfBnpak3+Pr0JOW/a0RDk4cpgNYA2KPf701NYRrDo2MZkGYXBdkVmeiDVARnMZUPEzDtQzwJGje2QTU=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr57737714qkn.36.1594187141257;
 Tue, 07 Jul 2020 22:45:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200708014413.1990641-1-kafai@fb.com> <20200708014426.1991187-1-kafai@fb.com>
In-Reply-To: <20200708014426.1991187-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Jul 2020 22:45:30 -0700
Message-ID: <CAEf4BzYXhcxMMGb0_ha8mVVyZzT50REmB8k_hneTg5prJJJTgA@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] bpf: net: Avoid incorrect bpf_sk_reuseport_detach call
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        James Chapman <jchapman@katalix.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 6:46 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> bpf_sk_reuseport_detach is currently called when sk->sk_user_data
> is not NULL.  It is incorrect because sk->sk_user_data may not be
> managed by the bpf's reuseport_array.  It has been report in [1] that,
> the bpf_sk_reuseport_detach() which is called from udp_lib_unhash() has
> corrupted the sk_user_data managed by l2tp.
>
> This patch solves it by using another bit (defined as SK_USER_DATA_BPF)
> of the sk_user_data pointer value.  It marks that a sk_user_data is
> managed/owned by BPF.
>
> The patch depends on a PTRMASK introduced in
> commit f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data pointer on clone if tagged").
>
> [ Note: sk->sk_user_data is used by bpf's reuseport_array only when a sk is
>   added to the bpf's reuseport_array.
>   i.e. doing setsockopt(SO_REUSEPORT) and having "sk->sk_reuseport == 1"
>   alone will not stop sk->sk_user_data being used by other means. ]
>
> [1]: https://lore.kernel.org/netdev/20200706121259.GA20199@katalix.com/
>
> Reported-by: James Chapman <jchapman@katalix.com>
> Cc: James Chapman <jchapman@katalix.com>
> Fixes: 5dc4c4b7d4e8 ("bpf: Introduce BPF_MAP_TYPE_REUSEPORT_SOCKARRAY")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/net/sock.h           | 3 ++-
>  kernel/bpf/reuseport_array.c | 5 +++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 3428619faae4..9fe42c890706 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -533,7 +533,8 @@ enum sk_pacing {
>   * be copied.
>   */
>  #define SK_USER_DATA_NOCOPY    1UL
> -#define SK_USER_DATA_PTRMASK   ~(SK_USER_DATA_NOCOPY)
> +#define SK_USER_DATA_BPF       2UL     /* Managed by BPF */
> +#define SK_USER_DATA_PTRMASK   ~3UL

nit: ~3UL looks like a random constant, while

~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF)

would clearly indicate what's going on. Original PTRMASK definition
had this logical connection with NOCOPY bit, I think it's worth it to
preserve that.

>
>  /**
>   * sk_user_data_is_nocopy - Test if sk_user_data pointer must not be copied
> diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
> index a95bc8d7e812..cae9d505e04a 100644
> --- a/kernel/bpf/reuseport_array.c
> +++ b/kernel/bpf/reuseport_array.c
> @@ -24,7 +24,7 @@ void bpf_sk_reuseport_detach(struct sock *sk)
>
>         write_lock_bh(&sk->sk_callback_lock);
>         sk_user_data = (uintptr_t)sk->sk_user_data;
> -       if (sk_user_data) {
> +       if (sk_user_data & SK_USER_DATA_BPF) {
>                 struct sock __rcu **socks;
>
>                 socks = (void *)(sk_user_data & SK_USER_DATA_PTRMASK);
> @@ -309,7 +309,8 @@ int bpf_fd_reuseport_array_update_elem(struct bpf_map *map, void *key,
>         if (err)
>                 goto put_file_unlock;
>
> -       sk_user_data = (uintptr_t)&array->ptrs[index] | SK_USER_DATA_NOCOPY;
> +       sk_user_data = (uintptr_t)&array->ptrs[index] | SK_USER_DATA_NOCOPY |
> +               SK_USER_DATA_BPF;
>         WRITE_ONCE(nsk->sk_user_data, (void *)sk_user_data);
>         rcu_assign_pointer(array->ptrs[index], nsk);
>         free_osk = osk;
> --
> 2.24.1
>
