Return-Path: <netdev+bounces-4732-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F74970E0D1
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:46:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD9E8281360
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D521F955;
	Tue, 23 May 2023 15:46:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E058E1D2BA
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056F4C433EF;
	Tue, 23 May 2023 15:46:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LxFORCx6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1684856786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZFdwPMiKsAJH00ZycyuEFzC8QU6t6hCvFI46hFx9poA=;
	b=LxFORCx6IGTp+eoVZN08cdxdPDJfHG2XfKHIgHcph3kN8Zi1vX7c1p+GUKjjwwB2X5cmHY
	NKK4Q/my6z0Yfl6EF787V25Sa0464ZRxJQRhqQwF747S9FOEt4du8lTB3PoHbVvcg1giLF
	7xyZhIC13KAulKoyKtylbVUTHcm+HrA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 789880a0 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 23 May 2023 15:46:24 +0000 (UTC)
Date: Tue, 23 May 2023 17:46:20 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: syzbot <syzbot+c2775460db0e1c70018e@syzkaller.appspotmail.com>,
	edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
	wireguard@lists.zx2c4.com, jann@thejh.net
Subject: Re: [syzbot] [wireguard?] KASAN: slab-use-after-free Write in
 enqueue_timer
Message-ID: <ZGzfzEs-vJcZAySI@zx2c4.com>
References: <000000000000c0b11d05fa917fe3@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <000000000000c0b11d05fa917fe3@google.com>

Hey Syzkaller & Netdev folks,

I've been looking at this a bit and am slightly puzzled. At first I saw
this:

>  enqueue_timer+0xad/0x560 kernel/time/timer.c:605
>  internal_add_timer kernel/time/timer.c:634 [inline]
>  __mod_timer+0xa76/0xf40 kernel/time/timer.c:1131
>  mod_peer_timer+0x158/0x220 drivers/net/wireguard/timers.c:37
>  wg_packet_consume_data_done drivers/net/wireguard/receive.c:354 [inline]
>  wg_packet_rx_poll+0xd9e/0x2250 drivers/net/wireguard/receive.c:474

And I thought - darn, it's a bug where a struct wg_peer's timer is
modified -- in this case, timer_persistent_keepalive by way of
wg_timers_any_authenticated_packet_traversal() -- after the peer object
has been freed. This fits most clearly the designated line
receive.c:354, and the subsequent 8 byte write when enqueuing the timer.

So I traced through the peer shutdown code in peer.c -- the
peer_make_dead() + peer_remove_after_dead() combo -- and made sure the
peer->is_dead RCU logic was correct. And I couldn't find a bug.

But then I looked further down at the syzbot report:

> Allocated by task 16792:
>  kvzalloc include/linux/slab.h:705 [inline]
>  alloc_netdev_mqs+0x89/0xf30 net/core/dev.c:10626
>  rtnl_create_link+0x2f7/0xc00 net/core/rtnetlink.c:3315

and

> Freed by task 41:
>  __kmem_cache_free+0x264/0x3c0 mm/slub.c:3799
>  device_release+0x95/0x1c0
>  kobject_cleanup lib/kobject.c:683 [inline]
>  kobject_release lib/kobject.c:714 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  kobject_put+0x228/0x470 lib/kobject.c:731
>  netdev_run_todo+0xe5a/0xf50 net/core/dev.c:10400

So that means the memory in question is actually the one that's
allocated and freed by the networking stack. Specifically, dev.c:10626
is allocating a struct net_device with a trailing struct wg_device (its
priv_data). However, wg_device does not have any struct timer_lists in
it, and I don't see how net_device's watchdog_timer would be related to
the stacktrace which is clearly operating over a wg_peer timer.

So what on earth is going on here?

Jason

PS - Jakub, I have some WG fixes queued up for you, but I wanted to have
some resolution with this first before sending a tranche.

