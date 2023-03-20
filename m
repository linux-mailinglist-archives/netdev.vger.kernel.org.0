Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0096C1F66
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjCTSUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbjCTSTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:19:54 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE89D3A873
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:13:21 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h8so13390138plf.10
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679335995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+T9xTHeMIwID7Pu526YKiYIxJQvr2vclqjAP5NF9me4=;
        b=Ia7l+Z/wgqKnPl31bedHOeifONS9OMFbR32mmKCeYZlijemaLjl9mYG3ufxHGDOZ8f
         7S4/yslUJmZP85BKAIxuKLzQpFBZiPpq9jSsxS3sUNPcuhnPnAiEupXReXHUPwUOkvrp
         xbVNYjW4j4U/cyl8yKeMabN/JiO2M26cwJJHgmSxvwLpZjm7I42pRcoeBq8Eix4LtzFX
         au2TgFSekC1pl9mr0s7ZUP4rJe1dQYj72pkab1OVRn6W7Hty8WcmyjbwKqztB82IgQWf
         h7FLwOEwoNfmfLmiHfurk8aZCyimo5iiMhitLINvcjR50enn02NovlIXrJvE/8MofO3t
         nQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679335995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+T9xTHeMIwID7Pu526YKiYIxJQvr2vclqjAP5NF9me4=;
        b=snGwN1yWLhG+cnGLGZI8qsS7PJkNaHfxjnf4MU2E/+FZsA5KaVBsGOhVxSpQb1DLmD
         Vu9TY40Dx8PmDgXU7erzWeeRkRctCdxzcBMp2Fsvyrcz33uBKUTNGn4UfWE9PTU5TY+K
         GLU+QEm4I/nvENjV7ALwxZvjQEXVHxNxANWxQi81oflcqLEgAGj+a7F0c75vAEMqTf5C
         zNZ63y0YFV5Hk+RLr2JK4EMmLsoEjp+lHD1vhVlDN4grDDCp+ZV2dykNFHHx8pLFxrsh
         eqQNNyH04l15c7ZmjHfLyWlx3sVNPWdeK1sbr0TuHJ+8RHaSmOa1y0bxHFYvmrZ0nLqh
         6ikg==
X-Gm-Message-State: AO0yUKUX9k0Pcn59nh6Y2TDf++3D/LCASt9aCLAijlXcQ5rULYMvt2zl
        +P2NdHYX3c+zaCNKOzBNaA72rbzJoGJgn2dCpzRWFg==
X-Google-Smtp-Source: AK7set+tHZT4GsqSkgow6jIyVvgzJBzSB1wkjFzefpKJkrKT3Z03/NELfDrjESy1E7FS87dwQd8xej2abcofvt7VESk=
X-Received: by 2002:a17:90a:6606:b0:23b:5161:f66f with SMTP id
 l6-20020a17090a660600b0023b5161f66fmr29732pjj.9.1679335995362; Mon, 20 Mar
 2023 11:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230319191913.61236-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20230319191913.61236-1-xiyou.wangcong@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 20 Mar 2023 11:13:03 -0700
Message-ID: <CAKH8qBtoYREbbRaedAfv=cEv2a5gBEYLSLy2eqcMYvsN7sqE=Q@mail.gmail.com>
Subject: Re: [Patch net-next v3] sock_map: dump socket map id via diag
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Sun, Mar 19, 2023 at 12:19=E2=80=AFPM Cong Wang <xiyou.wangcong@gmail.co=
m> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> Currently there is no way to know which sockmap a socket has been added
> to from outside, especially for that a socket can be added to multiple
> sockmap's. We could dump this via socket diag, as shown below.
>
> Sample output:
>
>   # ./iproute2/misc/ss -tnaie --bpf-map
>   ESTAB  0      344329     127.0.0.1:1234     127.0.0.1:40912 ino:21098 s=
k:5 cgroup:/user.slice/user-0.slice/session-c1.scope <-> sockmap: 1
>
>   # bpftool map
>   1: sockmap  flags 0x0
>         key 4B  value 4B  max_entries 2  memlock 4096B
>         pids echo-sockmap(549)
>   4: array  name pid_iter.rodata  flags 0x480
>         key 4B  value 4B  max_entries 1  memlock 4096B
>         btf_id 10  frozen
>         pids bpftool(624)
>
> In the future, we could dump other sockmap related stats too, hence I
> make it a nested attribute.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Looks fine from my POW, will let others comment.

One thing I still don't understand here: what is missing from the
socket iterators to implement this? Is it all the sk_psock_get magic?
I remember you dismissed Yonghong's suggestion on v1, but have you
actually tried it?

Also: a test would be nice to have. I know you've tested it with the
iproute2, but having something regularly exercised by the ci seems
good to have (and not a ton of work).

> ---
> v3: remove redundant rcu read lock
>     use likely() for psock check
>
> v2: rename enum's with more generic names
>     sock_map_idiag_dump -> sock_map_diag_dump()
>     make sock_map_diag_dump() return number of maps
>
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/inet_diag.h |  1 +
>  include/uapi/linux/sock_diag.h |  8 ++++++
>  include/uapi/linux/unix_diag.h |  1 +
>  net/core/sock_map.c            | 46 ++++++++++++++++++++++++++++++++++
>  net/ipv4/inet_diag.c           |  5 ++++
>  net/unix/diag.c                |  6 +++++
>  7 files changed, 68 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 6792a7940e1e..4cc315ce26a9 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2638,6 +2638,7 @@ int sock_map_bpf_prog_query(const union bpf_attr *a=
ttr,
>  void sock_map_unhash(struct sock *sk);
>  void sock_map_destroy(struct sock *sk);
>  void sock_map_close(struct sock *sk, long timeout);
> +int sock_map_diag_dump(struct sock *sk, struct sk_buff *skb, int attr);
>  #else
>  static inline int bpf_dev_bound_kfunc_check(struct bpf_verifier_log *log=
,
>                                             struct bpf_prog_aux *prog_aux=
)
> diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_dia=
g.h
> index 50655de04c9b..d1f1e4522633 100644
> --- a/include/uapi/linux/inet_diag.h
> +++ b/include/uapi/linux/inet_diag.h
> @@ -161,6 +161,7 @@ enum {
>         INET_DIAG_SK_BPF_STORAGES,
>         INET_DIAG_CGROUP_ID,
>         INET_DIAG_SOCKOPT,
> +       INET_DIAG_BPF_MAP,
>         __INET_DIAG_MAX,
>  };
>
> diff --git a/include/uapi/linux/sock_diag.h b/include/uapi/linux/sock_dia=
g.h
> index 5f74a5f6091d..7c961940b408 100644
> --- a/include/uapi/linux/sock_diag.h
> +++ b/include/uapi/linux/sock_diag.h
> @@ -62,4 +62,12 @@ enum {
>
>  #define SK_DIAG_BPF_STORAGE_MAX        (__SK_DIAG_BPF_STORAGE_MAX - 1)
>
> +enum {
> +       SK_DIAG_BPF_MAP_NONE,
> +       SK_DIAG_BPF_MAP_IDS,
> +       __SK_DIAG_BPF_MAP_MAX,
> +};
> +
> +#define SK_DIAG_BPF_MAP_MAX        (__SK_DIAG_BPF_MAP_MAX - 1)
> +
>  #endif /* _UAPI__SOCK_DIAG_H__ */
> diff --git a/include/uapi/linux/unix_diag.h b/include/uapi/linux/unix_dia=
g.h
> index a1988576fa8a..b95a2b33521d 100644
> --- a/include/uapi/linux/unix_diag.h
> +++ b/include/uapi/linux/unix_diag.h
> @@ -42,6 +42,7 @@ enum {
>         UNIX_DIAG_MEMINFO,
>         UNIX_DIAG_SHUTDOWN,
>         UNIX_DIAG_UID,
> +       UNIX_DIAG_BPF_MAP,
>
>         __UNIX_DIAG_MAX,
>  };
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 9b854e236d23..c4049095f64e 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -1656,6 +1656,52 @@ void sock_map_close(struct sock *sk, long timeout)
>  }
>  EXPORT_SYMBOL_GPL(sock_map_close);
>
> +int sock_map_diag_dump(struct sock *sk, struct sk_buff *skb, int attrtyp=
e)
> +{
> +       struct sk_psock_link *link;
> +       struct nlattr *nla, *attr;
> +       int nr_links =3D 0, ret =3D 0;
> +       struct sk_psock *psock;
> +       u32 *ids;
> +
> +       psock =3D sk_psock_get(sk);
> +       if (likely(!psock))
> +               return 0;
> +
> +       nla =3D nla_nest_start_noflag(skb, attrtype);
> +       if (!nla) {
> +               sk_psock_put(sk, psock);
> +               return -EMSGSIZE;
> +       }
> +       spin_lock_bh(&psock->link_lock);
> +       list_for_each_entry(link, &psock->link, list)
> +               nr_links++;
> +
> +       attr =3D nla_reserve(skb, SK_DIAG_BPF_MAP_IDS,
> +                          sizeof(link->map->id) * nr_links);
> +       if (!attr) {
> +               ret =3D -EMSGSIZE;
> +               goto unlock;
> +       }
> +
> +       ids =3D nla_data(attr);
> +       list_for_each_entry(link, &psock->link, list) {
> +               *ids =3D link->map->id;
> +               ids++;
> +       }
> +unlock:
> +       spin_unlock_bh(&psock->link_lock);
> +       sk_psock_put(sk, psock);
> +       if (ret) {
> +               nla_nest_cancel(skb, nla);
> +       } else {
> +               ret =3D nr_links;
> +               nla_nest_end(skb, nla);
> +       }
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(sock_map_diag_dump);
> +
>  static int sock_map_iter_attach_target(struct bpf_prog *prog,
>                                        union bpf_iter_link_info *linfo,
>                                        struct bpf_iter_aux_info *aux)
> diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> index b812eb36f0e3..0949909d5b46 100644
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -197,6 +197,11 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct=
 sk_buff *skb,
>                     &inet_sockopt))
>                 goto errout;
>
> +#ifdef CONFIG_BPF_SYSCALL
> +       if (sock_map_diag_dump(sk, skb, INET_DIAG_BPF_MAP) < 0)
> +               goto errout;
> +#endif
> +
>         return 0;
>  errout:
>         return 1;
> diff --git a/net/unix/diag.c b/net/unix/diag.c
> index 616b55c5b890..54aa8da2831e 100644
> --- a/net/unix/diag.c
> +++ b/net/unix/diag.c
> @@ -6,6 +6,7 @@
>  #include <linux/skbuff.h>
>  #include <linux/module.h>
>  #include <linux/uidgid.h>
> +#include <linux/bpf.h>
>  #include <net/netlink.h>
>  #include <net/af_unix.h>
>  #include <net/tcp_states.h>
> @@ -172,6 +173,11 @@ static int sk_diag_fill(struct sock *sk, struct sk_b=
uff *skb, struct unix_diag_r
>             sk_diag_dump_uid(sk, skb, user_ns))
>                 goto out_nlmsg_trim;
>
> +#ifdef CONFIG_BPF_SYSCALL
> +       if (sock_map_diag_dump(sk, skb, UNIX_DIAG_BPF_MAP) < 0)
> +               goto out_nlmsg_trim;
> +#endif
> +
>         nlmsg_end(skb, nlh);
>         return 0;
>
> --
> 2.34.1
>
