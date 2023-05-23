Return-Path: <netdev+bounces-4776-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E2BA70E2BB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC607280BD7
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCCEF209B5;
	Tue, 23 May 2023 17:29:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7814C91
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 17:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA51C433D2;
	Tue, 23 May 2023 17:28:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="CB+AWCXr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1684862936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bCbw3sck91JI8j5eCygSPRLzknR7AWXoCmQ+oX+qRr8=;
	b=CB+AWCXrDI9jvFQ6iye2JxcJfHeYEcwqnpevMWDiWz+jxcjEN7vy1iUyHaqzaKe+nhP0n/
	ISF9HZFmTdgNb4YX3JF/A9qziYTbkAidh4BSJl5O5m4NRabFgn57kEHsQW7jyRzLJ7l42e
	JElag0RgCKIywBjPzp8GHI++UMCe/4w=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cab93579 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 23 May 2023 17:28:56 +0000 (UTC)
Date: Tue, 23 May 2023 19:28:54 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: edumazet@google.com,
	syzbot <syzbot+c2775460db0e1c70018e@syzkaller.appspotmail.com>,
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	pabeni@redhat.com, wireguard@lists.zx2c4.com, jann@thejh.net
Subject: Re: [syzbot] [wireguard?] KASAN: slab-use-after-free Write in
 enqueue_timer
Message-ID: <ZGz31pkpzt3RVQDd@zx2c4.com>
References: <000000000000c0b11d05fa917fe3@google.com>
 <ZGzfzEs-vJcZAySI@zx2c4.com>
 <20230523090512.19ca60b6@kernel.org>
 <ZGzmWtd7itw6oFsI@zx2c4.com>
 <20230523094606.6f4f8f4f@kernel.org>
 <CAHmME9pEu2cvrSQd+Rg8Cp=KDfKEfjeiPPgF-WecXLHyRZVjcw@mail.gmail.com>
 <ZGz05BI29KBb2fdz@zx2c4.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZGz05BI29KBb2fdz@zx2c4.com>

On Tue, May 23, 2023 at 07:16:20PM +0200, Jason A. Donenfeld wrote:
> On Tue, May 23, 2023 at 06:47:41PM +0200, Jason A. Donenfeld wrote:
> > On Tue, May 23, 2023 at 6:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue, 23 May 2023 18:14:18 +0200 Jason A. Donenfeld wrote:
> > > > So, IOW, not a wireguard bug, right?
> > >
> > > What's slightly concerning is that there aren't any other timers
> > > leading to
> > >
> > >   KASAN: slab-use-after-free Write in enqueue_timer
> > >
> > > :( If WG was just an innocent bystander there should be, right?
> > 
> > Well, WG does mod this timer for every single packet in its RX path.
> > So that's bound to turn things up I suppose.
> 
> Here's one that is seemingly the same -- enqueuing a timer to a freed
> base -- with the allocation and free being the same netdev core
> function, but the UaF trigger for it is a JBD2 transaction thing:
> https://syzkaller.appspot.com/text?tag=CrashReport&x=17dd2446280000
> No WG at all in it, but there's still the mysterious 5376 value...

In this one, you see the free happens in some infiniband code.  Looking
at ipoib_dev_priv, and going to the member at net_device+ipoib_dev_priv,
we get this at 5320:

        struct delayed_work        neigh_reap_task;

5376-5320=56, which doesn't quite put us at the timer_list. Close but no
cigar?

