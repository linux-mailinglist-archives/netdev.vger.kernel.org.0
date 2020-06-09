Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9471F447E
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 20:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387632AbgFISFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 14:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731641AbgFISFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 14:05:07 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A86C05BD1E;
        Tue,  9 Jun 2020 11:05:07 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id d7so13050359lfi.12;
        Tue, 09 Jun 2020 11:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E72f62k907pEGGDAmY58sKnU0wz5NsdC2/nMF5C2jzo=;
        b=EJOHR6ACE+uwEdKEzAu2IVyEJZQKrqfjjdvLX216CBDLGPcWYdTE5KilyQvN5LyLbO
         Nu/psTZTR8Rtf8YWXnouOmKEgG21CcJyAHJWlugDlWMU4o7R8VGzHp1oFrCVqbo1nD06
         qOJFQx/na0hqwduWyUA9VUS9ybStlZgVGxspEl+MFaUnfk4iPOJ9FiyvGCO3Txludmi9
         Ak+tSUq3Zx55viBlLex5uU39/EYF7aSR9rzopSLB0/zBstMchQqrt22A0y4a46uPlPzV
         KfwV/i6Rg4wTSpxSFYQOqulfvjvsbIyEb8hx8JYcNgAecSH6tbz6OctvL78ZJeYYNGZR
         SDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E72f62k907pEGGDAmY58sKnU0wz5NsdC2/nMF5C2jzo=;
        b=uXj3lktafMf2/RxVhy5UuceJXfJBfVVSPLYaFiZKdRmOu+1tCXIs8OwFOl4aXQ6Qfk
         TccX83DZy90WJzZ0yn9jdrpi4XIyS852Wau9dJMgO5bhAEaT1NVZsvZwa7dmqTa5wAJR
         L7JRKQHn3bWNEKiA8xN6a09IxuQp4GvG+61sHKf//BA1fThFPn4qbd/SLCznpTWroZV5
         PXW1ntaWaVpQoipLlG8T5MUDM/+GGNtJGzfC4QmSs+HzMPG7Omr/MGh8K+qnQYKgqdau
         RQWDbb/BmEWiW5m/TYFyiUCAOQtQc5WEI1n/VNkpsqVtQTM+9YCvgzPL5eP6G7C0Zang
         lWmQ==
X-Gm-Message-State: AOAM533hxP7kg0aoKf7pQpuwZAlGFATIHwouF02jzKA/8a8IHZt/sojd
        wQ4MV8CSb2/WqCcgA7GHAE+wirN+Nf43LWFSLmU5ehhW
X-Google-Smtp-Source: ABdhPJyO+ykNXeYnAqvegZJhaZo22uFOtt5f24H21FKWGoBfRhm+3RdkpRtW+ckoKe2Ef9C2ukFtvO/CTf9KtRI2zbc=
X-Received: by 2002:ac2:544b:: with SMTP id d11mr15864232lfn.157.1591725905570;
 Tue, 09 Jun 2020 11:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200607205229.2389672-1-jakub@cloudflare.com>
 <20200607205229.2389672-3-jakub@cloudflare.com> <5edfc23e1bb3e_5cca2af6a27f45b8df@john-XPS-13-9370.notmuch>
In-Reply-To: <5edfc23e1bb3e_5cca2af6a27f45b8df@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 9 Jun 2020 11:04:54 -0700
Message-ID: <CAADnVQLe-vks4TpJzcWc+HPa1jzO2z6yZg-M8iD2JNAmfm9dXQ@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] bpf, sockhash: Synchronize delete from bucket
 list on map free
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 9, 2020 at 10:51 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Jakub Sitnicki wrote:
> > We can end up modifying the sockhash bucket list from two CPUs when a
> > sockhash is being destroyed (sock_hash_free) on one CPU, while a socket
> > that is in the sockhash is unlinking itself from it on another CPU
> > it (sock_hash_delete_from_link).
> >
> > This results in accessing a list element that is in an undefined state as
> > reported by KASAN:
> >
> > | ==================================================================
> > | BUG: KASAN: wild-memory-access in sock_hash_free+0x13c/0x280
> > | Write of size 8 at addr dead000000000122 by task kworker/2:1/95
> > |
> > | CPU: 2 PID: 95 Comm: kworker/2:1 Not tainted 5.7.0-rc7-02961-ge22c35ab0038-dirty #691
> > | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> > | Workqueue: events bpf_map_free_deferred
> > | Call Trace:
> > |  dump_stack+0x97/0xe0
> > |  ? sock_hash_free+0x13c/0x280
> > |  __kasan_report.cold+0x5/0x40
> > |  ? mark_lock+0xbc1/0xc00
> > |  ? sock_hash_free+0x13c/0x280
> > |  kasan_report+0x38/0x50
> > |  ? sock_hash_free+0x152/0x280
> > |  sock_hash_free+0x13c/0x280
> > |  bpf_map_free_deferred+0xb2/0xd0
> > |  ? bpf_map_charge_finish+0x50/0x50
> > |  ? rcu_read_lock_sched_held+0x81/0xb0
> > |  ? rcu_read_lock_bh_held+0x90/0x90
> > |  process_one_work+0x59a/0xac0
> > |  ? lock_release+0x3b0/0x3b0
> > |  ? pwq_dec_nr_in_flight+0x110/0x110
> > |  ? rwlock_bug.part.0+0x60/0x60
> > |  worker_thread+0x7a/0x680
> > |  ? _raw_spin_unlock_irqrestore+0x4c/0x60
> > |  kthread+0x1cc/0x220
> > |  ? process_one_work+0xac0/0xac0
> > |  ? kthread_create_on_node+0xa0/0xa0
> > |  ret_from_fork+0x24/0x30
> > | ==================================================================
> >
> > Fix it by reintroducing spin-lock protected critical section around the
> > code that removes the elements from the bucket on sockhash free.
> >
> > To do that we also need to defer processing of removed elements, until out
> > of atomic context so that we can unlink the socket from the map when
> > holding the sock lock.
> >
> > Fixes: 90db6d772f74 ("bpf, sockmap: Remove bucket->lock from sock_{hash|map}_free")
> > Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > ---
> >  net/core/sock_map.c | 23 +++++++++++++++++++++--
> >  1 file changed, 21 insertions(+), 2 deletions(-)
>
> Thanks.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied both to bpf tree.

FYI I see this splat:
 ./test_sockmap
# 1/ 6  sockmap::txmsg test passthrough:OK
# 2/ 6  sockmap::txmsg test redirect:OK
# 3/ 6  sockmap::txmsg test drop:OK
# 4/ 6  sockmap::txmsg test ingress redirect:OK
[   19.180397]
[   19.180633] =============================
[   19.181042] WARNING: suspicious RCU usage
[   19.181517] 5.7.0-07177-g75e68e5bf2c7 #688 Not tainted
[   19.182048] -----------------------------
[   19.182570] include/linux/skmsg.h:284 suspicious
rcu_dereference_check() usage!
[   19.183341]
[   19.183341] other info that might help us debug this:
[   19.183341]
[   19.184215]
[   19.184215] rcu_scheduler_active = 2, debug_locks = 1
[   19.184875] 1 lock held by test_sockmap/291:
[   19.185356]  #0: ffff8881315b5b20 (sk_lock-AF_INET){+.+.}-{0:0},
at: tls_sw_recvmsg+0x128/0x810
[   19.186315]
[   19.186315] stack backtrace:
[   19.186774] CPU: 0 PID: 291 Comm: test_sockmap Not tainted
5.7.0-07177-g75e68e5bf2c7 #688
[   19.188497] Call Trace:
[   19.188757]  dump_stack+0x71/0xa0
[   19.189140]  sk_psock_skb_redirect.isra.0+0xa6/0xf0
[   19.189651]  sk_psock_tls_strp_read+0x1cc/0x250
[   19.190142]  tls_sw_recvmsg+0x6e4/0x810
[   19.190584]  inet_recvmsg+0x55/0x1d0
[   19.190963]  ____sys_recvmsg+0x73/0x130
[   19.191365]  ? import_iovec+0x27/0xd0
[   19.191800]  ? copy_msghdr_from_user+0x4c/0x70
[   19.192271]  ___sys_recvmsg+0x68/0x90
[   19.192682]  ? __might_fault+0x36/0x80
[   19.193078]  ? __audit_syscall_exit+0x242/0x2b0
[   19.193576]  __sys_recvmsg+0x46/0x80
[   19.193964]  do_syscall_64+0x4a/0x1b0
[   19.194355]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
[   19.194924] RIP: 0033:0x7fc915cc4490
