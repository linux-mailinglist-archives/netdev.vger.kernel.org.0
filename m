Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFAA7153712
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 18:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgBERzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 12:55:42 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37970 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgBERzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 12:55:41 -0500
Received: by mail-lf1-f65.google.com with SMTP id r14so2135030lfm.5
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 09:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=1Yrg3T6KZS2OyA+ADGtO1u0bSFpjplnhjmg6jfz5vhY=;
        b=wtd3ITEppKCHCEO4iKtaXhljPGbMo9Kvvxk9ii/DFRDO1rHBAVgykPoCrtuoKV6o/3
         0WzHjm9HIYJhRNLqZSimAmjsEXSb4Xth9S9XhZ4A1WzdWLfFrm6p0g3k7ru4SwiGuykV
         kGXn314LVa0j5JYjVdMC3pLI6YoR7Dl4PcVCU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=1Yrg3T6KZS2OyA+ADGtO1u0bSFpjplnhjmg6jfz5vhY=;
        b=thZShBOYoYb3HTQ5tpZZL9IuXaBs2xPtAXHE0oCFkba+0sOn5NuCL/cbA7WPknHDPt
         UCWBFmIF0hJa8/WnVj06GjfMmM1uHYk9Hxggfya9iLzfSV8Sh7RR5memNlckNJBU6Bml
         w1913AIXZhnKK0hct1gm6wSnPg3ftCZw67dDJhDbGDz/5yRnsfnnBd4AI0P2IhCAEOfL
         KLVFAxJPQjv8q1GH5KvCKrNiZyeIqEthV05PnJ2u3Rhw7uYhObq0c9aiwdMB2E/lrl2f
         6EcNNxu7Vhcwc/TWPzG38eiis+yf+y6DrTx6xu4EpBFpUKPXYlLxdafPmUs7VA9XQi/j
         6FRQ==
X-Gm-Message-State: APjAAAXL2UNiFoLt43neU5rm6buZLIfdJ0+zxGUnUDPETJp0sk433vY0
        yz+t3D9M+I0qSyZjbo7gWQSHHsbfTywYpw==
X-Google-Smtp-Source: APXvYqwg06H2ll3jXVyWP1Sw1iK3UoOhzbE5XP0kbkD6/rBo5o6XIsWopp+Q9BK/F3XqJ/o1f+xdjA==
X-Received: by 2002:ac2:4a89:: with SMTP id l9mr18233750lfp.121.1580925337603;
        Wed, 05 Feb 2020 09:55:37 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 3sm91527lja.65.2020.02.05.09.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 09:55:36 -0800 (PST)
References: <20200111061206.8028-1-john.fastabend@gmail.com> <20200111061206.8028-3-john.fastabend@gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, song@kernel.org, jonathan.lemon@gmail.com
Subject: Re: [bpf PATCH v2 2/8] bpf: sockmap, ensure sock lock held during tear down
In-reply-to: <20200111061206.8028-3-john.fastabend@gmail.com>
Date:   Wed, 05 Feb 2020 18:55:34 +0100
Message-ID: <8736boor55.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 07:12 AM CET, John Fastabend wrote:
> The sock_map_free() and sock_hash_free() paths used to delete sockmap
> and sockhash maps walk the maps and destroy psock and bpf state associated
> with the socks in the map. When done the socks no longer have BPF programs
> attached and will function normally. This can happen while the socks in
> the map are still "live" meaning data may be sent/received during the walk.
>
> Currently, though we don't take the sock_lock when the psock and bpf state
> is removed through this path. Specifically, this means we can be writing
> into the ops structure pointers such as sendmsg, sendpage, recvmsg, etc.
> while they are also being called from the networking side. This is not
> safe, we never used proper READ_ONCE/WRITE_ONCE semantics here if we
> believed it was safe. Further its not clear to me its even a good idea
> to try and do this on "live" sockets while networking side might also
> be using the socket. Instead of trying to reason about using the socks
> from both sides lets realize that every use case I'm aware of rarely
> deletes maps, in fact kubernetes/Cilium case builds map at init and
> never tears it down except on errors. So lets do the simple fix and
> grab sock lock.
>
> This patch wraps sock deletes from maps in sock lock and adds some
> annotations so we catch any other cases easier.
>
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Cc: stable@vger.kernel.org
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/skmsg.c    | 2 ++
>  net/core/sock_map.c | 7 ++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index ded2d5227678..3866d7e20c07 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -594,6 +594,8 @@ EXPORT_SYMBOL_GPL(sk_psock_destroy);
>
>  void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
>  {
> +	sock_owned_by_me(sk);
> +
>  	sk_psock_cork_free(psock);
>  	sk_psock_zap_ingress(psock);
>
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index eb114ee419b6..8998e356f423 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -241,8 +241,11 @@ static void sock_map_free(struct bpf_map *map)
>  		struct sock *sk;
>
>  		sk = xchg(psk, NULL);
> -		if (sk)
> +		if (sk) {
> +			lock_sock(sk);
>  			sock_map_unref(sk, psk);
> +			release_sock(sk);
> +		}
>  	}
>  	raw_spin_unlock_bh(&stab->lock);
>  	rcu_read_unlock();

John, I've noticed this is triggering warnings that we might sleep in
lock_sock while (1) in RCU read-side section, and (2) holding a spin
lock:

=============================
WARNING: suspicious RCU usage
5.5.0-04012-g38c811e4cd3c #443 Not tainted
-----------------------------
include/linux/rcupdate.h:272 Illegal context switch in RCU read-side critical section!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
4 locks held by kworker/0:1/62:
 #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
 #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
 #2: ffffffff82065d20 (rcu_read_lock){....}, at: sock_map_free+0x5/0x170
 #3: ffff8881383dbdf8 (&stab->lock){+.-.}, at: sock_map_free+0x64/0x170

stack backtrace:
CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04012-g38c811e4cd3c #443
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
Workqueue: events bpf_map_free_deferred
Call Trace:
 dump_stack+0x71/0xa0
 ___might_sleep+0x105/0x190
 lock_sock_nested+0x28/0x90
 sock_map_free+0x95/0x170
 bpf_map_free_deferred+0x58/0x80
 process_one_work+0x260/0x5e0
 worker_thread+0x4d/0x3e0
 kthread+0x108/0x140
 ? process_one_work+0x5e0/0x5e0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x3a/0x50
BUG: sleeping function called from invalid context at net/core/sock.c:2942
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 62, name: kworker/0:1
4 locks held by kworker/0:1/62:
 #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
 #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
 #2: ffffffff82065d20 (rcu_read_lock){....}, at: sock_map_free+0x5/0x170
 #3: ffff8881383dbdf8 (&stab->lock){+.-.}, at: sock_map_free+0x64/0x170
CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04012-g38c811e4cd3c #443
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
Workqueue: events bpf_map_free_deferred
Call Trace:
 dump_stack+0x71/0xa0
 ___might_sleep.cold+0xa6/0xb6
 lock_sock_nested+0x28/0x90
 sock_map_free+0x95/0x170
 bpf_map_free_deferred+0x58/0x80
 process_one_work+0x260/0x5e0
 worker_thread+0x4d/0x3e0
 kthread+0x108/0x140
 ? process_one_work+0x5e0/0x5e0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x3a/0x50

Easy to trigger on a VM with 1 vCPU, reproducer below.

Here's an idea how to change the locking. I'm still wrapping my head
around what protects what in sock_map_free, so please bear with me:

1. synchronize_rcu before we iterate over the array is not needed,
   AFAICT. We are not free'ing the map just yet, hence any readers
   accessing the map via the psock are not in danger of use-after-free.

2. rcu_read_lock is needed to protect access to psock inside
   sock_map_unref, but we can't sleep while in RCU read-side.  So push
   it down, after we grab the sock lock.

3. Grabbing stab->lock seems not needed, either. We get called from
   bpf_map_free_deferred, after map refcnt dropped to 0, so we're not
   racing with any other map user to modify its contents.

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2cbde385e1a0..7f54e0d27d32 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -259,9 +259,6 @@ static void sock_map_free(struct bpf_map *map)
        struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
        int i;

-       synchronize_rcu();
-       rcu_read_lock();
-       raw_spin_lock_bh(&stab->lock);
        for (i = 0; i < stab->map.max_entries; i++) {
                struct sock **psk = &stab->sks[i];
                struct sock *sk;
@@ -269,12 +266,12 @@ static void sock_map_free(struct bpf_map *map)
                sk = xchg(psk, NULL);
                if (sk) {
                        lock_sock(sk);
+                       rcu_read_lock();
                        sock_map_unref(sk, psk);
+                       rcu_read_unlock();
                        release_sock(sk);
                }
        }
-       raw_spin_unlock_bh(&stab->lock);
-       rcu_read_unlock();

        synchronize_rcu();

> @@ -862,7 +865,9 @@ static void sock_hash_free(struct bpf_map *map)
>  		raw_spin_lock_bh(&bucket->lock);
>  		hlist_for_each_entry_safe(elem, node, &bucket->head, node) {
>  			hlist_del_rcu(&elem->node);
> +			lock_sock(elem->sk);
>  			sock_map_unref(elem->sk, elem);
> +			release_sock(elem->sk);
>  		}
>  		raw_spin_unlock_bh(&bucket->lock);
>  	}

Similar problems here. With one extra that it seems we're missing a
synchronize_rcu *after* walking over the htable for the same reason as
it got added to sock_map_free in 2bb90e5cc90e ("bpf: sockmap,
synchronize_rcu before free'ing map"):

    We need to have a synchronize_rcu before free'ing the sockmap because
    any outstanding psock references will have a pointer to the map and
    when they use this could trigger a use after free.

WDYT?

Reproducer follows.

---8<---

/* sockmap_update.c */

#include <errno.h>
#include <error.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#include <bpf/bpf.h>

#define fail(fmt...) error_at_line(1, errno, __func__, __LINE__, fmt)

int main(void)
{
	struct sockaddr_storage addr_ = {0};
	struct sockaddr *addr = (void *) &addr_;
	socklen_t len = sizeof(addr_);
	int srv, cli, map, key;

	srv = socket(AF_INET, SOCK_STREAM, 0);
	if (srv == -1)
		fail("socket(cli)");

	if (listen(srv, SOMAXCONN))
		fail("listen");

	if (getsockname(srv, addr, &len))
		fail("getsockname");

	cli = socket(AF_INET, SOCK_STREAM, 0);
	if (cli == -1)
		fail("socket(srv)");

	if (connect(cli, addr, len))
		fail("connect");

	map = bpf_create_map(BPF_MAP_TYPE_SOCKMAP, sizeof(int), sizeof(int), 1, 0);
	if (map == -1)
		fail("bpf_create_map");

	key = 0;
	if (bpf_map_update_elem(map, &key, &cli, BPF_NOEXIST))
		fail("bpf_map_update_elem");

	if (close(map))
		fail("close(map)");

	if (close(cli))
		fail("close(cli)");

	if (close(srv))
		fail("close(srv)");

	return 0;
}

--->8---
