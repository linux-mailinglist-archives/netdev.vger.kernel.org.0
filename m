Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA2F6D56E2
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjDDCq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDDCqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:46:55 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3404173B
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 19:46:53 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id ew6so124814676edb.7
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 19:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680576412; x=1683168412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rp0xXhf5yR3ynGJvG8T6uIZvHl44PvDswtcigLe7UM8=;
        b=EF6kDtc6XzBSSNi9KhLy+a7x43qbYqnnAfasbSkYPv0BuKgy2v7DVs0aaxwos6qFzW
         l5H6i3kEvvM/uNAZe1MTJ4g/kPd6dFYwApowT84j/bbSny/96uBWvzLghe4YVLZmZhFP
         bpP+1fADVNwyiAP22QhS4Y4aW5DVuD6/AL8u45IDU//hczw7BXTRtMecEJKsxBBlpAR8
         9Jb8G5K0mz3MWUHg1zSvJQOGSVESZ5uUOOUjZEQW2wWRq3geXWtY/aZcJfi49KQE9l+X
         MDRvRKTWmwJnwpbf5z0QC827slqmO68DgvMS9h8Y/rZsKq06CW1k8wrkpjpQg/KleIKZ
         xCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680576412; x=1683168412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rp0xXhf5yR3ynGJvG8T6uIZvHl44PvDswtcigLe7UM8=;
        b=4eP6gG3XL4Jg4z/k6Uo0eUnI8gJqrqZ8utC1U9orsU0z/DNWByCfugYDYrl8mKlitv
         a0kAAIbCG85ZBY8eGso4kcrybYcSPKxpwUbQIHdlREcJc7hJlkqfRaPggjM7H56QNwOM
         xHbI8pBnFvzDWXF6Aj6aVxjaWjlSQQ2mbmR8wxfejNm3Ik6OVagN/Qbc1U7xm6RcTPQR
         FIxdzPlppFX9L4RCLwA9cWDuqKzpK4P/C+iCvZPB8aISiwjbTY5jYlsIQnPd0QGR+W/g
         9IaIsEJ+5H3Q9bWYERwXDD8ZZ8oa4dKhDJEZMM2XXmuks368mdJB3WRRWYlMVTvzCD9X
         5NPA==
X-Gm-Message-State: AAQBX9dQKsicDuv4oAGJovjzHsNWlTE4mHSAR1UH8atnfPTM5h4Vwni5
        zVvNrTu4Qk0hfetxXR2ibb3qcfoKcaNv3GA3uRg=
X-Google-Smtp-Source: AKy350YTEiI3lf+6maXfIr3LLQhkFBb2p0Cbkxr+Qlt/qtcSxq97gjcmuN44COSG8TLa9CApN/iVsAJrD7amYkeZAuE=
X-Received: by 2002:a17:907:b60a:b0:930:42bd:ef1d with SMTP id
 vl10-20020a170907b60a00b0093042bdef1dmr401784ejc.11.1680576411997; Mon, 03
 Apr 2023 19:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230403194959.48928-1-kuniyu@amazon.com> <20230403194959.48928-2-kuniyu@amazon.com>
In-Reply-To: <20230403194959.48928-2-kuniyu@amazon.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 4 Apr 2023 10:46:15 +0800
Message-ID: <CAL+tcoB911=NZYiiAHV8vRv+=GdWmXqNv0YWd9mc4vLaTgjN1g@mail.gmail.com>
Subject: Re: [PATCH v1 net 1/2] raw: Fix NULL deref in raw_get_next().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        "Dae R . Jeong" <threeearcat@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 4:02=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> Dae R. Jeong reported a NULL deref in raw_get_next() [0].
>
> It seems that the repro was running these sequences in parallel so
> that one thread was iterating on a socket that was being freed in
> another netns.
>
>   unshare(0x40060200)
>   r0 =3D syz_open_procfs(0x0, &(0x7f0000002080)=3D'net/raw\x00')
>   socket$inet_icmp_raw(0x2, 0x3, 0x1)
>   pread64(r0, &(0x7f0000000000)=3D""/10, 0xa, 0x10000000007f)
>
> After commit 0daf07e52709 ("raw: convert raw sockets to RCU"), we
> use RCU and hlist_nulls_for_each_entry() to iterate over SOCK_RAW
> sockets.  However, we should use spinlock for slow paths to avoid
> the NULL deref.
>
> Also, SOCK_RAW does not use SLAB_TYPESAFE_BY_RCU, and the slab object
> is not reused during iteration in the grace period.  In fact, the
> lockless readers do not check the nulls marker with get_nulls_value().
> So, SOCK_RAW should use hlist instead of hlist_nulls.
>
> Instead of adding an unnecessary barrier by sk_nulls_for_each_rcu(),
> let's convert hlist_nulls to hlist and use sk_for_each_rcu() for
> fast paths and sk_for_each() and spinlock for /proc/net/raw.
>
> [0]:
> general protection fault, probably for non-canonical address 0xdffffc0000=
000005: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
> CPU: 2 PID: 20952 Comm: syz-executor.0 Not tainted 6.2.0-g048ec869bafd-di=
rty #7
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-=
g155821a1990b-prebuilt.qemu.org 04/01/2014
> RIP: 0010:read_pnet include/net/net_namespace.h:383 [inline]
> RIP: 0010:sock_net include/net/sock.h:649 [inline]
> RIP: 0010:raw_get_next net/ipv4/raw.c:974 [inline]
> RIP: 0010:raw_get_idx net/ipv4/raw.c:986 [inline]
> RIP: 0010:raw_seq_start+0x431/0x800 net/ipv4/raw.c:995
> Code: ef e8 33 3d 94 f7 49 8b 6d 00 4c 89 ef e8 b7 65 5f f7 49 89 ed 49 8=
3 c5 98 0f 84 9a 00 00 00 48 83 c5 c8 48 89 e8 48 c1 e8 03 <42> 80 3c 30 00=
 74 08 48 89 ef e8 00 3d 94 f7 4c 8b 7d 00 48 89 ef
> RSP: 0018:ffffc9001154f9b0 EFLAGS: 00010206
> RAX: 0000000000000005 RBX: 1ffff1100302c8fd RCX: 0000000000000000
> RDX: 0000000000000028 RSI: ffffc9001154f988 RDI: ffffc9000f77a338
> RBP: 0000000000000029 R08: ffffffff8a50ffb4 R09: fffffbfff24b6bd9
> R10: fffffbfff24b6bd9 R11: 0000000000000000 R12: ffff88801db73b78
> R13: fffffffffffffff9 R14: dffffc0000000000 R15: 0000000000000030
> FS:  00007f843ae8e700(0000) GS:ffff888063700000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055bb9614b35f CR3: 000000003c672000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  seq_read_iter+0x4c6/0x10f0 fs/seq_file.c:225
>  seq_read+0x224/0x320 fs/seq_file.c:162
>  pde_read fs/proc/inode.c:316 [inline]
>  proc_reg_read+0x23f/0x330 fs/proc/inode.c:328
>  vfs_read+0x31e/0xd30 fs/read_write.c:468
>  ksys_pread64 fs/read_write.c:665 [inline]
>  __do_sys_pread64 fs/read_write.c:675 [inline]
>  __se_sys_pread64 fs/read_write.c:672 [inline]
>  __x64_sys_pread64+0x1e9/0x280 fs/read_write.c:672
>  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x478d29
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f843ae8dbe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
> RAX: ffffffffffffffda RBX: 0000000000791408 RCX: 0000000000478d29
> RDX: 000000000000000a RSI: 0000000020000000 RDI: 0000000000000003
> RBP: 00000000f477909a R08: 0000000000000000 R09: 0000000000000000
> R10: 000010000000007f R11: 0000000000000246 R12: 0000000000791740
> R13: 0000000000791414 R14: 0000000000791408 R15: 00007ffc2eb48a50
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:read_pnet include/net/net_namespace.h:383 [inline]
> RIP: 0010:sock_net include/net/sock.h:649 [inline]
> RIP: 0010:raw_get_next net/ipv4/raw.c:974 [inline]
> RIP: 0010:raw_get_idx net/ipv4/raw.c:986 [inline]
> RIP: 0010:raw_seq_start+0x431/0x800 net/ipv4/raw.c:995
> Code: ef e8 33 3d 94 f7 49 8b 6d 00 4c 89 ef e8 b7 65 5f f7 49 89 ed 49 8=
3 c5 98 0f 84 9a 00 00 00 48 83 c5 c8 48 89 e8 48 c1 e8 03 <42> 80 3c 30 00=
 74 08 48 89 ef e8 00 3d 94 f7 4c 8b 7d 00 48 89 ef
> RSP: 0018:ffffc9001154f9b0 EFLAGS: 00010206
> RAX: 0000000000000005 RBX: 1ffff1100302c8fd RCX: 0000000000000000
> RDX: 0000000000000028 RSI: ffffc9001154f988 RDI: ffffc9000f77a338
> RBP: 0000000000000029 R08: ffffffff8a50ffb4 R09: fffffbfff24b6bd9
> R10: fffffbfff24b6bd9 R11: 0000000000000000 R12: ffff88801db73b78
> R13: fffffffffffffff9 R14: dffffc0000000000 R15: 0000000000000030
> FS:  00007f843ae8e700(0000) GS:ffff888063700000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f92ff166000 CR3: 000000003c672000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
> Fixes: 0daf07e52709 ("raw: convert raw sockets to RCU")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: Dae R. Jeong <threeearcat@gmail.com>
> Link: https://lore.kernel.org/netdev/ZCA2mGV_cmq7lIfV@dragonet/
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/raw.h   |  4 ++--
>  net/ipv4/raw.c      | 36 +++++++++++++++++++-----------------
>  net/ipv4/raw_diag.c | 10 ++++------
>  net/ipv6/raw.c      | 10 ++++------
>  4 files changed, 29 insertions(+), 31 deletions(-)
>
> diff --git a/include/net/raw.h b/include/net/raw.h
> index 2c004c20ed99..3af5289fdead 100644
> --- a/include/net/raw.h
> +++ b/include/net/raw.h
> @@ -37,7 +37,7 @@ int raw_rcv(struct sock *, struct sk_buff *);
>  struct raw_hashinfo {
>         spinlock_t lock;
>
> -       struct hlist_nulls_head ht[RAW_HTABLE_SIZE] ____cacheline_aligned=
;
> +       struct hlist_head ht[RAW_HTABLE_SIZE] ____cacheline_aligned;
>  };
>
>  static inline u32 raw_hashfunc(const struct net *net, u32 proto)
> @@ -51,7 +51,7 @@ static inline void raw_hashinfo_init(struct raw_hashinf=
o *hashinfo)
>
>         spin_lock_init(&hashinfo->lock);
>         for (i =3D 0; i < RAW_HTABLE_SIZE; i++)
> -               INIT_HLIST_NULLS_HEAD(&hashinfo->ht[i], i);
> +               INIT_HLIST_HEAD(&hashinfo->ht[i]);
>  }
>
>  #ifdef CONFIG_PROC_FS
> diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> index 94df935ee0c5..8088a5011e7d 100644
> --- a/net/ipv4/raw.c
> +++ b/net/ipv4/raw.c
> @@ -91,12 +91,12 @@ EXPORT_SYMBOL_GPL(raw_v4_hashinfo);
>  int raw_hash_sk(struct sock *sk)
>  {
>         struct raw_hashinfo *h =3D sk->sk_prot->h.raw_hash;
> -       struct hlist_nulls_head *hlist;
> +       struct hlist_head *hlist;
>
>         hlist =3D &h->ht[raw_hashfunc(sock_net(sk), inet_sk(sk)->inet_num=
)];
>
>         spin_lock(&h->lock);
> -       __sk_nulls_add_node_rcu(sk, hlist);
> +       sk_add_node_rcu(sk, hlist);
>         sock_set_flag(sk, SOCK_RCU_FREE);
>         spin_unlock(&h->lock);
>         sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
> @@ -110,7 +110,7 @@ void raw_unhash_sk(struct sock *sk)
>         struct raw_hashinfo *h =3D sk->sk_prot->h.raw_hash;
>
>         spin_lock(&h->lock);
> -       if (__sk_nulls_del_node_init_rcu(sk))
> +       if (sk_del_node_init_rcu(sk))
>                 sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
>         spin_unlock(&h->lock);
>  }
> @@ -163,16 +163,15 @@ static int icmp_filter(const struct sock *sk, const=
 struct sk_buff *skb)
>  static int raw_v4_input(struct net *net, struct sk_buff *skb,
>                         const struct iphdr *iph, int hash)
>  {
> -       struct hlist_nulls_head *hlist;
> -       struct hlist_nulls_node *hnode;
>         int sdif =3D inet_sdif(skb);
> +       struct hlist_head *hlist;
>         int dif =3D inet_iif(skb);
>         int delivered =3D 0;
>         struct sock *sk;
>
>         hlist =3D &raw_v4_hashinfo.ht[hash];
>         rcu_read_lock();
> -       sk_nulls_for_each(sk, hnode, hlist) {
> +       sk_for_each_rcu(sk, hlist) {
>                 if (!raw_v4_match(net, sk, iph->protocol,
>                                   iph->saddr, iph->daddr, dif, sdif))
>                         continue;
> @@ -264,10 +263,9 @@ static void raw_err(struct sock *sk, struct sk_buff =
*skb, u32 info)
>  void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
>  {
>         struct net *net =3D dev_net(skb->dev);
> -       struct hlist_nulls_head *hlist;
> -       struct hlist_nulls_node *hnode;
>         int dif =3D skb->dev->ifindex;
>         int sdif =3D inet_sdif(skb);
> +       struct hlist_head *hlist;
>         const struct iphdr *iph;
>         struct sock *sk;
>         int hash;
> @@ -276,7 +274,7 @@ void raw_icmp_error(struct sk_buff *skb, int protocol=
, u32 info)
>         hlist =3D &raw_v4_hashinfo.ht[hash];
>
>         rcu_read_lock();
> -       sk_nulls_for_each(sk, hnode, hlist) {
> +       sk_for_each_rcu(sk, hlist) {
>                 iph =3D (const struct iphdr *)skb->data;
>                 if (!raw_v4_match(net, sk, iph->protocol,
>                                   iph->daddr, iph->saddr, dif, sdif))
> @@ -950,14 +948,13 @@ static struct sock *raw_get_first(struct seq_file *=
seq, int bucket)
>  {
>         struct raw_hashinfo *h =3D pde_data(file_inode(seq->file));
>         struct raw_iter_state *state =3D raw_seq_private(seq);
> -       struct hlist_nulls_head *hlist;
> -       struct hlist_nulls_node *hnode;
> +       struct hlist_head *hlist;
>         struct sock *sk;
>
>         for (state->bucket =3D bucket; state->bucket < RAW_HTABLE_SIZE;
>                         ++state->bucket) {
>                 hlist =3D &h->ht[state->bucket];
> -               sk_nulls_for_each(sk, hnode, hlist) {
> +               sk_for_each(sk, hlist) {
>                         if (sock_net(sk) =3D=3D seq_file_net(seq))
>                                 return sk;
>                 }
> @@ -970,7 +967,7 @@ static struct sock *raw_get_next(struct seq_file *seq=
, struct sock *sk)
>         struct raw_iter_state *state =3D raw_seq_private(seq);
>
>         do {
> -               sk =3D sk_nulls_next(sk);
> +               sk =3D sk_next(sk);
>         } while (sk && sock_net(sk) !=3D seq_file_net(seq));
>
>         if (!sk)
> @@ -989,9 +986,12 @@ static struct sock *raw_get_idx(struct seq_file *seq=
, loff_t pos)
>  }
>
[...]
>  void *raw_seq_start(struct seq_file *seq, loff_t *pos)
> -       __acquires(RCU)
> +       __acquires(&h->lock)
>  {
> -       rcu_read_lock();
> +       struct raw_hashinfo *h =3D pde_data(file_inode(seq->file));
> +
> +       spin_lock(&h->lock);

I would like to ask two questions which make me confused:
1) Why would we use spin_lock to protect the socket in a raw hashtable
for reader's safety under the rcu protection? Normally, if we use the
RCU protection, we only make sure that we need to destroy the socket
by calling call_rcu() which would prevent the READER of the socket
from getting a NULL pointer.
2) Using spin lock when we're cating /proc/net/raw file may
block/postpone the action of hashing socket somewhere else?

Thanks,
Jason

> +
>         return *pos ? raw_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
>  }
>  EXPORT_SYMBOL_GPL(raw_seq_start);
> @@ -1010,9 +1010,11 @@ void *raw_seq_next(struct seq_file *seq, void *v, =
loff_t *pos)
>  EXPORT_SYMBOL_GPL(raw_seq_next);
>
>  void raw_seq_stop(struct seq_file *seq, void *v)
> -       __releases(RCU)
> +       __releases(&h->lock)
>  {
> -       rcu_read_unlock();
> +       struct raw_hashinfo *h =3D pde_data(file_inode(seq->file));
> +
> +       spin_unlock(&h->lock);
>  }
>  EXPORT_SYMBOL_GPL(raw_seq_stop);
>
> diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
> index 999321834b94..da3591a66a16 100644
> --- a/net/ipv4/raw_diag.c
> +++ b/net/ipv4/raw_diag.c
> @@ -57,8 +57,7 @@ static bool raw_lookup(struct net *net, struct sock *sk=
,
>  static struct sock *raw_sock_get(struct net *net, const struct inet_diag=
_req_v2 *r)
>  {
>         struct raw_hashinfo *hashinfo =3D raw_get_hashinfo(r);
> -       struct hlist_nulls_head *hlist;
> -       struct hlist_nulls_node *hnode;
> +       struct hlist_head *hlist;
>         struct sock *sk;
>         int slot;
>
> @@ -68,7 +67,7 @@ static struct sock *raw_sock_get(struct net *net, const=
 struct inet_diag_req_v2
>         rcu_read_lock();
>         for (slot =3D 0; slot < RAW_HTABLE_SIZE; slot++) {
>                 hlist =3D &hashinfo->ht[slot];
> -               sk_nulls_for_each(sk, hnode, hlist) {
> +               sk_for_each_rcu(sk, hlist) {
>                         if (raw_lookup(net, sk, r)) {
>                                 /*
>                                  * Grab it and keep until we fill
> @@ -142,9 +141,8 @@ static void raw_diag_dump(struct sk_buff *skb, struct=
 netlink_callback *cb,
>         struct raw_hashinfo *hashinfo =3D raw_get_hashinfo(r);
>         struct net *net =3D sock_net(skb->sk);
>         struct inet_diag_dump_data *cb_data;
> -       struct hlist_nulls_head *hlist;
> -       struct hlist_nulls_node *hnode;
>         int num, s_num, slot, s_slot;
> +       struct hlist_head *hlist;
>         struct sock *sk =3D NULL;
>         struct nlattr *bc;
>
> @@ -161,7 +159,7 @@ static void raw_diag_dump(struct sk_buff *skb, struct=
 netlink_callback *cb,
>                 num =3D 0;
>
>                 hlist =3D &hashinfo->ht[slot];
> -               sk_nulls_for_each(sk, hnode, hlist) {
> +               sk_for_each_rcu(sk, hlist) {
>                         struct inet_sock *inet =3D inet_sk(sk);
>
>                         if (!net_eq(sock_net(sk), net))
> diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
> index bac9ba747bde..a327aa481df4 100644
> --- a/net/ipv6/raw.c
> +++ b/net/ipv6/raw.c
> @@ -141,10 +141,9 @@ EXPORT_SYMBOL(rawv6_mh_filter_unregister);
>  static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
>  {
>         struct net *net =3D dev_net(skb->dev);
> -       struct hlist_nulls_head *hlist;
> -       struct hlist_nulls_node *hnode;
>         const struct in6_addr *saddr;
>         const struct in6_addr *daddr;
> +       struct hlist_head *hlist;
>         struct sock *sk;
>         bool delivered =3D false;
>         __u8 hash;
> @@ -155,7 +154,7 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int=
 nexthdr)
>         hash =3D raw_hashfunc(net, nexthdr);
>         hlist =3D &raw_v6_hashinfo.ht[hash];
>         rcu_read_lock();
> -       sk_nulls_for_each(sk, hnode, hlist) {
> +       sk_for_each_rcu(sk, hlist) {
>                 int filtered;
>
>                 if (!raw_v6_match(net, sk, nexthdr, daddr, saddr,
> @@ -333,15 +332,14 @@ void raw6_icmp_error(struct sk_buff *skb, int nexth=
dr,
>                 u8 type, u8 code, int inner_offset, __be32 info)
>  {
>         struct net *net =3D dev_net(skb->dev);
> -       struct hlist_nulls_head *hlist;
> -       struct hlist_nulls_node *hnode;
> +       struct hlist_head *hlist;
>         struct sock *sk;
>         int hash;
>
>         hash =3D raw_hashfunc(net, nexthdr);
>         hlist =3D &raw_v6_hashinfo.ht[hash];
>         rcu_read_lock();
> -       sk_nulls_for_each(sk, hnode, hlist) {
> +       sk_for_each_rcu(sk, hlist) {
>                 /* Note: ipv6_hdr(skb) !=3D skb->data */
>                 const struct ipv6hdr *ip6h =3D (const struct ipv6hdr *)sk=
b->data;
>
> --
> 2.30.2
>
