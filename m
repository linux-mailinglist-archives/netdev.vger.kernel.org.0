Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E781555FC
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgBGKpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:45:15 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44143 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgBGKpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:45:15 -0500
Received: by mail-wr1-f66.google.com with SMTP id m16so2034191wrx.11
        for <netdev@vger.kernel.org>; Fri, 07 Feb 2020 02:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=KqQzuRdPMPOG5mvjCjRuZwWVETa5Pi85Il5pP6jiguM=;
        b=WXh6q482tbum4z157UvZlaJG2F5uV1yZ8xuPWTNEegpX2DRzu4qeSqs5ePPafXK+5J
         2xaVY7iqb9JZV/7MMbrFvJrWXQCJhPpPB3sUM6KgwJ+KVConyjnu6L8RxWmru9kgyRsZ
         wUhIeOmnyv0hxghpHxBJLIMxdIsrgn/pn7suw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=KqQzuRdPMPOG5mvjCjRuZwWVETa5Pi85Il5pP6jiguM=;
        b=m+aVB3HjPaJGJe8GJcsNeAMskiMPX/S9oS+O9dv9otqwMFbd/nOuhFFzobC9i/RENn
         Gx67pSeZjqf/jiKzyxX/hSAtlek15kTFfQ7pryxlqfLfkEpUbaiByxmhKjkqr3eVYs5D
         AT6rwmu1IS9jTwsVR+xUUDHBRz4/bw50GzF0jfFHCR53/Vxf75nDHoXxZBdGj+MFeF/D
         xs6a2XZlhiVdzgnxoVMFxxA8+HgxaQyK6yfSwxsNCTLrKx/5wJiVEZDK4StUYZgWEu3O
         jBkLdmxtGBqtxylmSWXfF7FbZGTaRhbLHxJ+JsCiEw1H2C3eeDTmJyVWNeuArNZ97FaK
         16fg==
X-Gm-Message-State: APjAAAWowEnhTzR88iuIv6WxejTgToI7Xk9GGDvaPGWk3wvQ8o+BJRuw
        RwC6bneA2H6/qS6cKX3VCCl1D8NRKbu0Ew==
X-Google-Smtp-Source: APXvYqw5RGwG3xdwNs6Z94+DDPvZr95vbF6+nSnkoCGTe4+iNQzCtapyyMl0mtYF5m8ZEmPe+hBLwA==
X-Received: by 2002:adf:ee86:: with SMTP id b6mr4075589wro.61.1581072311408;
        Fri, 07 Feb 2020 02:45:11 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id 124sm3019974wmc.29.2020.02.07.02.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 02:45:10 -0800 (PST)
References: <20200206111652.694507-1-jakub@cloudflare.com> <5e3c6c7f8730e_22ad2af2cbd0a5b4a4@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf 0/3] Fix locking order and synchronization on sockmap/sockhash tear-down
In-reply-to: <5e3c6c7f8730e_22ad2af2cbd0a5b4a4@john-XPS-13-9370.notmuch>
Date:   Fri, 07 Feb 2020 11:45:09 +0100
Message-ID: <87zhdun0ay.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 06, 2020 at 08:43 PM CET, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> Couple of fixes that came from recent discussion [0] on commit
>> 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down").
>>
>> This series doesn't address the sleeping while holding a spinlock
>> problem. We're still trying to decide how to fix that [1].
>>
>> Until then sockmap users might see the following warnings:
>>
>> | BUG: sleeping function called from invalid context at net/core/sock.c:2935
>> | in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 62, name: kworker/0:1
>> | 3 locks held by kworker/0:1/62:
>> |  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
>> |  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
>> |  #2: ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
>> | CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04008-g7b083332376e #454
>> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
>> | Workqueue: events bpf_map_free_deferred
>> | Call Trace:
>> |  dump_stack+0x71/0xa0
>> |  ___might_sleep.cold+0xa6/0xb6
>> |  lock_sock_nested+0x28/0x90
>> |  sock_map_free+0x5f/0x180
>> |  bpf_map_free_deferred+0x58/0x80
>> |  process_one_work+0x260/0x5e0
>> |  worker_thread+0x4d/0x3e0
>> |  kthread+0x108/0x140
>> |  ? process_one_work+0x5e0/0x5e0
>> |  ? kthread_park+0x90/0x90
>> |  ret_from_fork+0x3a/0x50
>> |
>> | ======================================================
>> | WARNING: possible circular locking dependency detected
>> | 5.5.0-04008-g7b083332376e #454 Tainted: G        W
>> | ------------------------------------------------------
>> | kworker/0:1/62 is trying to acquire lock:
>> | ffff88813b280130 (sk_lock-AF_INET){+.+.}, at: sock_map_free+0x5f/0x180
>> |
>> | but task is already holding lock:
>> | ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
>> |
>> | which lock already depends on the new lock.
>> |
>> |
>> | the existing dependency chain (in reverse order) is:
>> |
>> | -> #1 (&stab->lock){+...}:
>> |        _raw_spin_lock_bh+0x39/0x80
>> |        sock_map_update_common+0xdc/0x300
>> |        sock_map_update_elem+0xc3/0x150
>> |        __do_sys_bpf+0x1285/0x1620
>> |        do_syscall_64+0x6d/0x690
>> |        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> |
>> | -> #0 (sk_lock-AF_INET){+.+.}:
>> |        __lock_acquire+0xe2f/0x19f0
>> |        lock_acquire+0x95/0x190
>> |        lock_sock_nested+0x6b/0x90
>> |        sock_map_free+0x5f/0x180
>> |        bpf_map_free_deferred+0x58/0x80
>> |        process_one_work+0x260/0x5e0
>> |        worker_thread+0x4d/0x3e0
>> |        kthread+0x108/0x140
>> |        ret_from_fork+0x3a/0x50
>> |
>> | other info that might help us debug this:
>> |
>> |  Possible unsafe locking scenario:
>> |
>> |        CPU0                    CPU1
>> |        ----                    ----
>> |   lock(&stab->lock);
>> |                                lock(sk_lock-AF_INET);
>> |                                lock(&stab->lock);
>> |   lock(sk_lock-AF_INET);
>> |
>> |  *** DEADLOCK ***
>> |
>> | 3 locks held by kworker/0:1/62:
>> |  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
>> |  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
>> |  #2: ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
>> |
>> | stack backtrace:
>> | CPU: 0 PID: 62 Comm: kworker/0:1 Tainted: G        W         5.5.0-04008-g7b083332376e #454
>> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
>> | Workqueue: events bpf_map_free_deferred
>> | Call Trace:
>> |  dump_stack+0x71/0xa0
>> |  check_noncircular+0x176/0x190
>> |  __lock_acquire+0xe2f/0x19f0
>> |  lock_acquire+0x95/0x190
>> |  ? sock_map_free+0x5f/0x180
>> |  lock_sock_nested+0x6b/0x90
>> |  ? sock_map_free+0x5f/0x180
>> |  sock_map_free+0x5f/0x180
>> |  bpf_map_free_deferred+0x58/0x80
>> |  process_one_work+0x260/0x5e0
>> |  worker_thread+0x4d/0x3e0
>> |  kthread+0x108/0x140
>> |  ? process_one_work+0x5e0/0x5e0
>> |  ? kthread_park+0x90/0x90
>> |  ret_from_fork+0x3a/0x50

Hey John,

> Untested at the moment, but this should also be fine per your suggestion
> (if I read it correctly).  The reason we have stab->lock and bucket->locks
> here is to handle checking EEXIST in update/delete cases. We need to
> be careful that when an update happens and we check for EEXIST that the
> socket is added/removed during this check. So both map_update_common and
> sock_map_delete need to guard from being run together potentially deleting
> an entry we are checking, etc.

Okay, thanks for explanation. IOW, we're serializing map writers.

> But by the time we get here we just did a synchronize_rcu() in the
> line above so no updates/deletes should be in flight. So it seems safe
> to drop these locks because of the condition no updates in flight.

This part is not clear to me. I might be missing something.

Here's my thinking - for any map writes (update/delete) to start,
map->refcnt needs to be > 0, and the ref is not dropped until the write
operation has finished.

Map FDs hold a ref to map until the FD gets released. And BPF progs hold
refs to maps until the prog gets unloaded.

This would mean that map_free will get scheduled from __bpf_map_put only
when no one is holding a map ref, and could start a write that would be
happening concurrently with sock_{map,hash}_free:

/* decrement map refcnt and schedule it for freeing via workqueue
 * (unrelying map implementation ops->map_free() might sleep)
 */
static void __bpf_map_put(struct bpf_map *map, bool do_idr_lock)
{
	if (atomic64_dec_and_test(&map->refcnt)) {
		/* bpf_map_free_id() must be called first */
		bpf_map_free_id(map, do_idr_lock);
		btf_put(map->btf);
		INIT_WORK(&map->work, bpf_map_free_deferred);
		schedule_work(&map->work);
	}
}

> So with patch below we keep the sync rcu but that is fine IMO these
> map free's are rare. Take a look and make sure it seems sane to you
> as well.

I can't vouch for the need to keep synchronize_rcu here because I don't
understand that part, but otherwise the change LGTM.

-jkbs

>
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index f36e13e577a3..1d56ec20330c 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -233,8 +233,11 @@ static void sock_map_free(struct bpf_map *map)
>  	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
>  	int i;
>
> +	/* After the sync no updates or deletes will be in-flight so it
> +	 * is safe to walk map and remove entries without risking a race
> +	 * in EEXIST update case.
> +	 */
>  	synchronize_rcu();
> -	raw_spin_lock_bh(&stab->lock);
>  	for (i = 0; i < stab->map.max_entries; i++) {
>  		struct sock **psk = &stab->sks[i];
>  		struct sock *sk;
> @@ -248,7 +251,6 @@ static void sock_map_free(struct bpf_map *map)
>  			release_sock(sk);
>  		}
>  	}
> -	raw_spin_unlock_bh(&stab->lock);
>
>  	/* wait for psock readers accessing its map link */
>  	synchronize_rcu();
> @@ -859,10 +861,13 @@ static void sock_hash_free(struct bpf_map *map)
>  	struct hlist_node *node;
>  	int i;
>
> +	/* After the sync no updates or deletes will be in-flight so it
> +	 * is safe to walk hash and remove entries without risking a race
> +	 * in EEXIST update case.
> +	 */
>  	synchronize_rcu();
>  	for (i = 0; i < htab->buckets_num; i++) {
>  		bucket = sock_hash_select_bucket(htab, i);
> -		raw_spin_lock_bh(&bucket->lock);
>  		hlist_for_each_entry_safe(elem, node, &bucket->head, node) {
>  			hlist_del_rcu(&elem->node);
>  			lock_sock(elem->sk);
> @@ -871,7 +876,6 @@ static void sock_hash_free(struct bpf_map *map)
>  			rcu_read_unlock();
>  			release_sock(elem->sk);
>  		}
> -		raw_spin_unlock_bh(&bucket->lock);
>  	}
>
>  	/* wait for psock readers accessing its map link */
