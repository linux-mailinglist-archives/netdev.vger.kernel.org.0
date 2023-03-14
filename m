Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95ED6B9DB3
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCNR6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjCNR6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:58:44 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C217C2E0F8
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:58:37 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id s20-20020a056a00179400b005c4d1dedc1fso8814913pfg.11
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678816717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gygX4kq/ZsAfg9wDSGwp5ki4q05ZaWQ+cRo13bsvPoQ=;
        b=d1zDJRGdKuXjd4tCr2o1eV2TxWt8oXv2yV5fJM7h2DtdrcmOp3MVWLm9d8G8644htc
         4JPdGpQnnXEuQI1eiZemcbnFo3Ec1V196MJV6cfy83DB8CMSiefrN0R5W5ryqRGRq/9A
         Rw0xYEqNvoIVdELdUFp46AtSZEOmTj5YkxySHBVmYuI6aBtIM1ySK7CR+ndlCoYkoOG2
         xx8kXfIUXdtFUPjA+ZnwB+42ob3wK+UG+VQEkEVmWLenWeJzhG7nHZCj3XeH+Vet1wqc
         ZLZrPUOp8eelAqJG/QXugCZduXmhezzmxQo2S8fGUnr7kDh51FsY7oOq9heWh80oQOMc
         7m+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678816717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gygX4kq/ZsAfg9wDSGwp5ki4q05ZaWQ+cRo13bsvPoQ=;
        b=IoI3mrH/JLmcwMKM0ME2p6kuCZcaA6cK2p6HKTBBrHoHv8TnCmv0Ave8hKRu8CPsss
         Y+K0uSTG5LYrf5Cb79Y00zZ0J1zSnYNtBYmHfa+/UcvcevG4m4FcC7wqEvmyLa6yq60f
         ecHls6LM5EEOPEV2oL/nEhzDzyU0YgMVl5oZMf+UWc/EEIxybgLpx29skcJCKGH0l7WJ
         R2mQ2TJFmxC8L7cP0WAjwcIleNomKklF7FgOo4vUJNQ1YYazPHAcoZdPVkiXBlSVC5BK
         4hVrqenyvuSUY2x+LTcUTbRbi058/rdZOpNfbn0IlxaUQZlw5gb3bq2Vaytjjta5V6lE
         PmFA==
X-Gm-Message-State: AO0yUKWz5Y0dpMUYi94rw81Z2j9bVAK7A0fpB5NxeNWXyARJm13FKwmJ
        48I+1s3zY1LhD0kvLRIwapasYZM=
X-Google-Smtp-Source: AK7set8cpH+I1J3fUKerSgNfaFHh4TmPKMPBEgBjbT5N3pAZTrCfAYO1rb6TEenNwXkspAHWH4/hZj8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a62:7992:0:b0:625:7ed5:3510 with SMTP id
 u140-20020a627992000000b006257ed53510mr571453pfc.3.1678816717098; Tue, 14 Mar
 2023 10:58:37 -0700 (PDT)
Date:   Tue, 14 Mar 2023 10:58:35 -0700
In-Reply-To: <20230313041619.394914-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
References: <20230313041619.394914-1-xiyou.wangcong@gmail.com>
Message-ID: <ZBC1y4tuZgcQ1YZz@google.com>
Subject: Re: [Patch net-next v2] sock_map: dump socket map id via diag
From:   Stanislav Fomichev <sdf@google.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/12, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>

> Currently there is no way to know which sockmap a socket has been added
> to from outside, especially for that a socket can be added to multiple
> sockmap's. We could dump this via socket diag, as shown below.

> Sample output:

>    # ./iproute2/misc/ss -tnaie --sockmap
>    ESTAB  0      344329     127.0.0.1:1234     127.0.0.1:40912 ino:21098  
> sk:5 cgroup:/user.slice/user-0.slice/session-c1.scope <-> sockmap: 1

>    # bpftool map
>    1: sockmap  flags 0x0
>    	key 4B  value 4B  max_entries 2  memlock 4096B
> 	pids echo-sockmap(549)
>    4: array  name pid_iter.rodata  flags 0x480
> 	key 4B  value 4B  max_entries 1  memlock 4096B
> 	btf_id 10  frozen
> 	pids bpftool(624)

> In the future, we could dump other sockmap related stats too, hence I
> make it a nested attribute.

> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
> v2: rename enum's with more generic names
>      sock_map_idiag_dump -> sock_map_diag_dump()
>      make sock_map_diag_dump() return number of maps

>   include/linux/bpf.h            |  1 +
>   include/uapi/linux/inet_diag.h |  1 +
>   include/uapi/linux/sock_diag.h |  8 ++++++
>   include/uapi/linux/unix_diag.h |  1 +
>   net/core/sock_map.c            | 51 ++++++++++++++++++++++++++++++++++
>   net/ipv4/inet_diag.c           |  5 ++++
>   net/unix/diag.c                |  6 ++++
>   7 files changed, 73 insertions(+)

> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 6792a7940e1e..4cc315ce26a9 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2638,6 +2638,7 @@ int sock_map_bpf_prog_query(const union bpf_attr  
> *attr,
>   void sock_map_unhash(struct sock *sk);
>   void sock_map_destroy(struct sock *sk);
>   void sock_map_close(struct sock *sk, long timeout);
> +int sock_map_diag_dump(struct sock *sk, struct sk_buff *skb, int attr);
>   #else
>   static inline int bpf_dev_bound_kfunc_check(struct bpf_verifier_log *log,
>   					    struct bpf_prog_aux *prog_aux)
> diff --git a/include/uapi/linux/inet_diag.h  
> b/include/uapi/linux/inet_diag.h
> index 50655de04c9b..d1f1e4522633 100644
> --- a/include/uapi/linux/inet_diag.h
> +++ b/include/uapi/linux/inet_diag.h
> @@ -161,6 +161,7 @@ enum {
>   	INET_DIAG_SK_BPF_STORAGES,
>   	INET_DIAG_CGROUP_ID,
>   	INET_DIAG_SOCKOPT,
> +	INET_DIAG_BPF_MAP,
>   	__INET_DIAG_MAX,
>   };

> diff --git a/include/uapi/linux/sock_diag.h  
> b/include/uapi/linux/sock_diag.h
> index 5f74a5f6091d..7c961940b408 100644
> --- a/include/uapi/linux/sock_diag.h
> +++ b/include/uapi/linux/sock_diag.h
> @@ -62,4 +62,12 @@ enum {

>   #define SK_DIAG_BPF_STORAGE_MAX        (__SK_DIAG_BPF_STORAGE_MAX - 1)

> +enum {
> +	SK_DIAG_BPF_MAP_NONE,
> +	SK_DIAG_BPF_MAP_IDS,
> +	__SK_DIAG_BPF_MAP_MAX,
> +};
> +
> +#define SK_DIAG_BPF_MAP_MAX        (__SK_DIAG_BPF_MAP_MAX - 1)
> +
>   #endif /* _UAPI__SOCK_DIAG_H__ */
> diff --git a/include/uapi/linux/unix_diag.h  
> b/include/uapi/linux/unix_diag.h
> index a1988576fa8a..b95a2b33521d 100644
> --- a/include/uapi/linux/unix_diag.h
> +++ b/include/uapi/linux/unix_diag.h
> @@ -42,6 +42,7 @@ enum {
>   	UNIX_DIAG_MEMINFO,
>   	UNIX_DIAG_SHUTDOWN,
>   	UNIX_DIAG_UID,
> +	UNIX_DIAG_BPF_MAP,

>   	__UNIX_DIAG_MAX,
>   };
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 9b854e236d23..8c4b3044e7a9 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -1656,6 +1656,57 @@ void sock_map_close(struct sock *sk, long timeout)
>   }
>   EXPORT_SYMBOL_GPL(sock_map_close);

> +int sock_map_diag_dump(struct sock *sk, struct sk_buff *skb, int  
> attrtype)
> +{
> +	struct sk_psock_link *link;
> +	struct nlattr *nla, *attr;
> +	int nr_links = 0, ret = 0;
> +	struct sk_psock *psock;
> +	u32 *ids;
> +

[..]

> +	rcu_read_lock();

Looks like sk_psock_get already starts RCU read section and returns
a refcnt'ed psock. So maybe drop rcu_read_lock/rcu_read_unlock?

> +	psock = sk_psock_get(sk);
> +	if (unlikely(!psock)) {
> +		rcu_read_unlock();
> +		return 0;
> +	}
> +
> +	nla = nla_nest_start_noflag(skb, attrtype);
> +	if (!nla) {
> +		sk_psock_put(sk, psock);
> +		rcu_read_unlock();
> +		return -EMSGSIZE;
> +	}
> +	spin_lock_bh(&psock->link_lock);
> +	list_for_each_entry(link, &psock->link, list)
> +		nr_links++;
> +
> +	attr = nla_reserve(skb, SK_DIAG_BPF_MAP_IDS,
> +			   sizeof(link->map->id) * nr_links);
> +	if (!attr) {
> +		ret = -EMSGSIZE;
> +		goto unlock;
> +	}
> +
> +	ids = nla_data(attr);
> +	list_for_each_entry(link, &psock->link, list) {
> +		*ids = link->map->id;
> +		ids++;
> +	}
> +unlock:
> +	spin_unlock_bh(&psock->link_lock);
> +	sk_psock_put(sk, psock);
> +	rcu_read_unlock();
> +	if (ret) {
> +		nla_nest_cancel(skb, nla);
> +	} else {
> +		ret = nr_links;
> +		nla_nest_end(skb, nla);
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sock_map_diag_dump);
> +
>   static int sock_map_iter_attach_target(struct bpf_prog *prog,
>   				       union bpf_iter_link_info *linfo,
>   				       struct bpf_iter_aux_info *aux)
> diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> index b812eb36f0e3..0949909d5b46 100644
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -197,6 +197,11 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct  
> sk_buff *skb,
>   		    &inet_sockopt))
>   		goto errout;

> +#ifdef CONFIG_BPF_SYSCALL
> +	if (sock_map_diag_dump(sk, skb, INET_DIAG_BPF_MAP) < 0)
> +		goto errout;
> +#endif
> +
>   	return 0;
>   errout:
>   	return 1;
> diff --git a/net/unix/diag.c b/net/unix/diag.c
> index 616b55c5b890..54aa8da2831e 100644
> --- a/net/unix/diag.c
> +++ b/net/unix/diag.c
> @@ -6,6 +6,7 @@
>   #include <linux/skbuff.h>
>   #include <linux/module.h>
>   #include <linux/uidgid.h>
> +#include <linux/bpf.h>
>   #include <net/netlink.h>
>   #include <net/af_unix.h>
>   #include <net/tcp_states.h>
> @@ -172,6 +173,11 @@ static int sk_diag_fill(struct sock *sk, struct  
> sk_buff *skb, struct unix_diag_r
>   	    sk_diag_dump_uid(sk, skb, user_ns))
>   		goto out_nlmsg_trim;

> +#ifdef CONFIG_BPF_SYSCALL
> +	if (sock_map_diag_dump(sk, skb, UNIX_DIAG_BPF_MAP) < 0)
> +		goto out_nlmsg_trim;
> +#endif
> +
>   	nlmsg_end(skb, nlh);
>   	return 0;

> --
> 2.34.1

