Return-Path: <netdev+bounces-4748-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8548A70E182
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:14:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CD521C20D8F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F800200D8;
	Tue, 23 May 2023 16:14:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE770200CE
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66727C433D2;
	Tue, 23 May 2023 16:14:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ho9GhgHN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1684858461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=03lmNUAB17A9ca+oGO7O4py68GtfGLSGU69TNAskS4o=;
	b=ho9GhgHN5EnNp5DUHniUPEBPl6Kqd2MJACQhBAZKWYh9S9hKPioKW4g69yu94yVedbEl6C
	vj9ET3YZpLf3MWvN+6ydsNB2gLMmUqwQfG2FVNh69dlW3amnHINuZ4Sbd7N2d8T8LldRce
	y1D3SRzJrxN6QvVk+rSb93V1fl0+h/c=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f9d47816 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 23 May 2023 16:14:21 +0000 (UTC)
Date: Tue, 23 May 2023 18:14:18 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: edumazet@google.com,
	syzbot <syzbot+c2775460db0e1c70018e@syzkaller.appspotmail.com>,
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	pabeni@redhat.com, wireguard@lists.zx2c4.com, jann@thejh.net
Subject: Re: [syzbot] [wireguard?] KASAN: slab-use-after-free Write in
 enqueue_timer
Message-ID: <ZGzmWtd7itw6oFsI@zx2c4.com>
References: <000000000000c0b11d05fa917fe3@google.com>
 <ZGzfzEs-vJcZAySI@zx2c4.com>
 <20230523090512.19ca60b6@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230523090512.19ca60b6@kernel.org>

On Tue, May 23, 2023 at 09:05:12AM -0700, Jakub Kicinski wrote:
> On Tue, 23 May 2023 17:46:20 +0200 Jason A. Donenfeld wrote:
> > > Freed by task 41:
> > >  __kmem_cache_free+0x264/0x3c0 mm/slub.c:3799
> > >  device_release+0x95/0x1c0
> > >  kobject_cleanup lib/kobject.c:683 [inline]
> > >  kobject_release lib/kobject.c:714 [inline]
> > >  kref_put include/linux/kref.h:65 [inline]
> > >  kobject_put+0x228/0x470 lib/kobject.c:731
> > >  netdev_run_todo+0xe5a/0xf50 net/core/dev.c:10400  
> > 
> > So that means the memory in question is actually the one that's
> > allocated and freed by the networking stack. Specifically, dev.c:10626
> > is allocating a struct net_device with a trailing struct wg_device (its
> > priv_data). However, wg_device does not have any struct timer_lists in
> > it, and I don't see how net_device's watchdog_timer would be related to
> > the stacktrace which is clearly operating over a wg_peer timer.
> > 
> > So what on earth is going on here?
> 
> Your timer had the pleasure of getting queued _after_ a dead watchdog
> timer, no? IOW it tries to update the ->next pointer of a queued
> watchdog timer. 

Ahh, you're right! Specifically,

> hlist_add_head include/linux/list.h:945 [inline]
> enqueue_timer+0xad/0x560 kernel/time/timer.c:605

The write on line 945 refers to the side of the timer base, not the
peer's timer_list being queued. So indeed, the wireguard netdev is still
alive at this point, but it's being queued to a timer in a different
netdev that's already been freed (whether watchdog or otherwise in some
privdata). So, IOW, not a wireguard bug, right?

Jason

