Return-Path: <netdev+bounces-4745-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6D4570E16E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:05:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81BD6281364
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB842200CD;
	Tue, 23 May 2023 16:05:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EC51F954
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF066C4339B;
	Tue, 23 May 2023 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684857914;
	bh=dXkfpSXsBDC6nkGoXQeMfCAXVHWe5mwMnoyvyR0I+A8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FbPrT+KN+UEE9xj3n22Er0WmT2EWvwa4CzHRH5e+emfau0GCz7Yq2U6S6PdXw9L6r
	 30KdM6/cQvSPEGRMRwVMgAQw+CjWPGOxVOCd0K/+ANvtGZDX79BlR9wMnnStTgAPi4
	 6t0G1vQ1tq9YkqojC64LWVoUlfEutWL6BNqtmyPxgQ/zwGXQkTFfEdO9E7z+P67hpZ
	 2gTkK737pS6fNSnP+/1N0UWUEm1boaEliTHcmajosxRlvvv/cJVDKSqyh2z4nIuCsv
	 QnYhSNUZKJ6TzJwElAAjZOFElbiYMJ4aWyFur0x+0noY5slky5VgDatMo7P3UWBVOg
	 w+C4E9ZWbAMfw==
Date: Tue, 23 May 2023 09:05:12 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, edumazet@google.com
Cc: syzbot <syzbot+c2775460db0e1c70018e@syzkaller.appspotmail.com>,
 netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 davem@davemloft.net, linux-kernel@vger.kernel.org, pabeni@redhat.com,
 wireguard@lists.zx2c4.com, jann@thejh.net
Subject: Re: [syzbot] [wireguard?] KASAN: slab-use-after-free Write in
 enqueue_timer
Message-ID: <20230523090512.19ca60b6@kernel.org>
In-Reply-To: <ZGzfzEs-vJcZAySI@zx2c4.com>
References: <000000000000c0b11d05fa917fe3@google.com>
	<ZGzfzEs-vJcZAySI@zx2c4.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 17:46:20 +0200 Jason A. Donenfeld wrote:
> > Freed by task 41:
> >  __kmem_cache_free+0x264/0x3c0 mm/slub.c:3799
> >  device_release+0x95/0x1c0
> >  kobject_cleanup lib/kobject.c:683 [inline]
> >  kobject_release lib/kobject.c:714 [inline]
> >  kref_put include/linux/kref.h:65 [inline]
> >  kobject_put+0x228/0x470 lib/kobject.c:731
> >  netdev_run_todo+0xe5a/0xf50 net/core/dev.c:10400  
> 
> So that means the memory in question is actually the one that's
> allocated and freed by the networking stack. Specifically, dev.c:10626
> is allocating a struct net_device with a trailing struct wg_device (its
> priv_data). However, wg_device does not have any struct timer_lists in
> it, and I don't see how net_device's watchdog_timer would be related to
> the stacktrace which is clearly operating over a wg_peer timer.
> 
> So what on earth is going on here?

Your timer had the pleasure of getting queued _after_ a dead watchdog
timer, no? IOW it tries to update the ->next pointer of a queued
watchdog timer. We should probably do:

diff --git a/net/core/dev.c b/net/core/dev.c
index 374d38fb8b9d..f3ed20ebcf5a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10389,6 +10389,8 @@ void netdev_run_todo(void)
                WARN_ON(rcu_access_pointer(dev->ip_ptr));
                WARN_ON(rcu_access_pointer(dev->ip6_ptr));
 
+               WARN_ON(timer_shutdown_sync(&dev->watchdog_timer));
+
                if (dev->priv_destructor)
                        dev->priv_destructor(dev);
                if (dev->needs_free_netdev)

to catch how that watchdog_timer is getting queued. Would that make
sense, Eric?

