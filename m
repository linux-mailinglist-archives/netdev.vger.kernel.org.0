Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC111154B81
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 20:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgBFS77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 13:59:59 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36175 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgBFS76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 13:59:58 -0500
Received: by mail-pg1-f195.google.com with SMTP id k3so3202107pgc.3;
        Thu, 06 Feb 2020 10:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Mhrdlreibd+nURVd1UhixUAEn1bwcDj1E4A6BAlfU7k=;
        b=Zp4HvXgNtfDRNPdpAgoo9VTCViyYvfcui3vgQ7r23fpb9UfMPIixnbgscQ/qL/XB4I
         cVSnH5HgxfR2zNOmg3NKWMnfG5yELprsPnFuDwgrnkgtcHvrchc5eKusL2t289i5yW8z
         rfw3WJ7lJwClNzJjGJAykuU+c/OE7O/obmdRmrXGQkKGHnhQByNxo78P57GpjWOVxDBZ
         9DLTPKqY8cMEpOJQwOa6am9HxDTWfmnG0yHxRvBDmtKGrrodNtuOE1amOyKdSOjBleZX
         RALwiCSwTY1+487bR9GhSGADfEF9nrud5PaZRyURmX6gjeBUPd3+00YDVezVqextcXOW
         6qwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Mhrdlreibd+nURVd1UhixUAEn1bwcDj1E4A6BAlfU7k=;
        b=sQsGTNDWz5l1hSY8oMvmi+V1XiS95yvjVCVFPBA4CCF8JbWlcdqRPrENyEeLZW/I1v
         graJw+a/SXyed3XSysmRtu6mcQWpTstZlEmwX4RyrE2d3ExWLzI0cR21q2VsxIBvkPU4
         oaY7YD3f88AmqArP0E9okqBva5Js6tt1UGmMoXdnUwEuAu7nqXVt88XuUPp2CQJQJgSR
         3TPalF3fsqGlYmClmo8RbxPIm/fxx78btuwPDOi+RVPsADiP066V5e2v7wJN/o/dYTA7
         M5WtaAyUcjFMSstx3VAMlPbrGxs/6aiezF5qkbTNHGIRpi6wdhCmdqmV11bprcxn4BMR
         qkTg==
X-Gm-Message-State: APjAAAWqyeOh7/0J5+xQz+lP8E/WgUhF7N0w08F0dFUbpixkPDmp4mHM
        211hfaky3HhdzSJWrr7wpJoe+/cL
X-Google-Smtp-Source: APXvYqwE73RqY+go9W8N/ydNBi/jQgF/XIB2qtVRmPyh/wnCgXuBQ9ieuy5KiIcHZdzeNBEabC5UJw==
X-Received: by 2002:a63:d301:: with SMTP id b1mr5087594pgg.321.1581015598034;
        Thu, 06 Feb 2020 10:59:58 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y2sm132000pff.139.2020.02.06.10.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 10:59:57 -0800 (PST)
Date:   Thu, 06 Feb 2020 10:59:49 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5e3c6225ba251_22ad2af2cbd0a5b41@john-XPS-13-9370.notmuch>
In-Reply-To: <20200206111652.694507-2-jakub@cloudflare.com>
References: <20200206111652.694507-1-jakub@cloudflare.com>
 <20200206111652.694507-2-jakub@cloudflare.com>
Subject: RE: [PATCH bpf 1/3] bpf, sockmap: Don't sleep while holding RCU lock
 on tear-down
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> rcu_read_lock is needed to protect access to psock inside sock_map_unref
> when tearing down the map. However, we can't afford to sleep in lock_sock
> while in RCU read-side critical section. Grab the RCU lock only after we
> have locked the socket.
> 
> This fixes RCU warnings triggerable on a VM with 1 vCPU when free'ing a
> sockmap/sockhash that contains at least one socket:
> 
> | =============================
> | WARNING: suspicious RCU usage
> | 5.5.0-04005-g8fc91b972b73 #450 Not tainted
> | -----------------------------
> | include/linux/rcupdate.h:272 Illegal context switch in RCU read-side critical section!
> |
> | other info that might help us debug this:
> |
> |
> | rcu_scheduler_active = 2, debug_locks = 1
> | 4 locks held by kworker/0:1/62:
> |  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #2: ffffffff82065d20 (rcu_read_lock){....}, at: sock_map_free+0x5/0x170
> |  #3: ffff8881368c5df8 (&stab->lock){+...}, at: sock_map_free+0x64/0x170
> |
> | stack backtrace:
> | CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04005-g8fc91b972b73 #450
> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> | Workqueue: events bpf_map_free_deferred
> | Call Trace:
> |  dump_stack+0x71/0xa0
> |  ___might_sleep+0x105/0x190
> |  lock_sock_nested+0x28/0x90
> |  sock_map_free+0x95/0x170
> |  bpf_map_free_deferred+0x58/0x80
> |  process_one_work+0x260/0x5e0
> |  worker_thread+0x4d/0x3e0
> |  kthread+0x108/0x140
> |  ? process_one_work+0x5e0/0x5e0
> |  ? kthread_park+0x90/0x90
> |  ret_from_fork+0x3a/0x50
> 
> | =============================
> | WARNING: suspicious RCU usage
> | 5.5.0-04005-g8fc91b972b73-dirty #452 Not tainted
> | -----------------------------
> | include/linux/rcupdate.h:272 Illegal context switch in RCU read-side critical section!
> |
> | other info that might help us debug this:
> |
> |
> | rcu_scheduler_active = 2, debug_locks = 1
> | 4 locks held by kworker/0:1/62:
> |  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
> |  #2: ffffffff82065d20 (rcu_read_lock){....}, at: sock_hash_free+0x5/0x1d0
> |  #3: ffff888139966e00 (&htab->buckets[i].lock){+...}, at: sock_hash_free+0x92/0x1d0
> |
> | stack backtrace:
> | CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04005-g8fc91b972b73-dirty #452
> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> | Workqueue: events bpf_map_free_deferred
> | Call Trace:
> |  dump_stack+0x71/0xa0
> |  ___might_sleep+0x105/0x190
> |  lock_sock_nested+0x28/0x90
> |  sock_hash_free+0xec/0x1d0
> |  bpf_map_free_deferred+0x58/0x80
> |  process_one_work+0x260/0x5e0
> |  worker_thread+0x4d/0x3e0
> |  kthread+0x108/0x140
> |  ? process_one_work+0x5e0/0x5e0
> |  ? kthread_park+0x90/0x90
> |  ret_from_fork+0x3a/0x50
> 
> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/sock_map.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Thanks! Fixes for fixes agh.

Acked-by: John Fastabend <john.fastabend@gmail.com>
