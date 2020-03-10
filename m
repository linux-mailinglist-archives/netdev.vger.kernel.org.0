Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D4117F64C
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 12:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgCJLas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 07:30:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54960 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgCJLas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 07:30:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id n8so963403wmc.4
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 04:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=BDa1YO2/RALGyErbrpZqUvTc6Odd/nO7uq3xDCn4cZA=;
        b=v2WCplYnUmir2Hd+CRsiDhzdlxgRXVzLn0q1HefaCTWrQr3E+VJDBDXWDpyKkeQzXr
         SwIGlgY/qANjHq0YLBijILCbnolyD9dIOlz6lL1w/Co08KrChWJszTEUcLjaENYgJuGz
         MFBOAfMr/VyVKwmwFKO40HigPTbYod9HydOII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=BDa1YO2/RALGyErbrpZqUvTc6Odd/nO7uq3xDCn4cZA=;
        b=lx7U4c433mOVf+WWXOIcLR196PE115QdP9wFsNspJVQtVm2kMJv58pcI8YTlO8WvsV
         lNvXJXMJOw45HRIlm5qpH+bxmThtOgSOzaKtpQRCy3mHsGMuNv22XL4LxLTzR4n0kEGA
         HVNGOwqmx2XR+lANb2Q4JtE82qC3FyElKcqs15y4DwvRr5ED3/hyBDZOpjCYyQa9s8uX
         BgBgfyOba5HdBnoSU1JGm8D18mCfF0ljnZixwcAcrpQ1Bue8j5Qk1Bl3uL10iM8+LsNl
         qs5dFT85azOmT4KeEmXp7PsbJ7HQVRT/XRvfUh4S9UbJ1AVaApcYGw+epoUEbsOuqYa5
         AQtw==
X-Gm-Message-State: ANhLgQ1WDcU+qgh75PopfalexxPwBkxtd6dM26C0T7F5duIesztKSTDu
        oT7F5TGd0aqHtUaUoQ6GPQJheg==
X-Google-Smtp-Source: ADFU+vvyXGNiUOQ5Vw9lPs7cqtd6F+Y5z6OqOuWXLNjEPFr3304/XHYd17a0/PQA10bULKpERAUPxw==
X-Received: by 2002:a7b:c118:: with SMTP id w24mr1758114wmi.77.1583839844432;
        Tue, 10 Mar 2020 04:30:44 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id x17sm26547932wrt.31.2020.03.10.04.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 04:30:43 -0700 (PDT)
References: <20200206111652.694507-1-jakub@cloudflare.com> <5e3c6c7f8730e_22ad2af2cbd0a5b4a4@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf 0/3] Fix locking order and synchronization on sockmap/sockhash tear-down
In-reply-to: <5e3c6c7f8730e_22ad2af2cbd0a5b4a4@john-XPS-13-9370.notmuch>
Date:   Tue, 10 Mar 2020 12:30:42 +0100
Message-ID: <8736agzbtp.fsf@cloudflare.com>
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
>
> Hi Jakub,
>
> Untested at the moment, but this should also be fine per your suggestion
> (if I read it correctly).  The reason we have stab->lock and bucket->locks
> here is to handle checking EEXIST in update/delete cases. We need to
> be careful that when an update happens and we check for EEXIST that the
> socket is added/removed during this check. So both map_update_common and
> sock_map_delete need to guard from being run together potentially deleting
> an entry we are checking, etc. But by the time we get here we just did
> a synchronize_rcu() in the line above so no updates/deletes should be
> in flight. So it seems safe to drop these locks because of the condition
> no updates in flight.
>
> So with patch below we keep the sync rcu but that is fine IMO these
> map free's are rare. Take a look and make sure it seems sane to you
> as well.
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

Hi John,

We would like to get rid of lockdep splats we are seeing in testing.

Mind if I submit the above fix for bpf-next on your behalf?

That is, of course, unless you have cycles to tend to it yourself.

Thanks,
-jkbs
