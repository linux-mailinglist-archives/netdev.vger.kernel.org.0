Return-Path: <netdev+bounces-4773-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74B4B70E2AB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:16:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27DF01C20CF2
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE9B20991;
	Tue, 23 May 2023 17:16:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CED4C91
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 17:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFA9C433D2;
	Tue, 23 May 2023 17:16:27 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="looCTqoH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1684862183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HFJsOQSB9/S2uFWepKjivi/bXH52kAWTnSyImng+RbA=;
	b=looCTqoHUH8IwlqRFT2RLLuymENVAFpFMDKuKRob0jaZv/KuJ4X2rY145Qw0VMLyV+FUMg
	Wl7DZwJoR3KV8t31OjBtOTz4JXPduUqzq1gRX+FpX2HpKLSRkLOdr2Jwa2DgBZ94BTCoIb
	2xf1z8W9ENJE0liw6gW4oY6TmX/XSys=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c151c9eb (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 23 May 2023 17:16:23 +0000 (UTC)
Date: Tue, 23 May 2023 19:16:20 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: edumazet@google.com,
	syzbot <syzbot+c2775460db0e1c70018e@syzkaller.appspotmail.com>,
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	pabeni@redhat.com, wireguard@lists.zx2c4.com, jann@thejh.net
Subject: Re: [syzbot] [wireguard?] KASAN: slab-use-after-free Write in
 enqueue_timer
Message-ID: <ZGz05BI29KBb2fdz@zx2c4.com>
References: <000000000000c0b11d05fa917fe3@google.com>
 <ZGzfzEs-vJcZAySI@zx2c4.com>
 <20230523090512.19ca60b6@kernel.org>
 <ZGzmWtd7itw6oFsI@zx2c4.com>
 <20230523094606.6f4f8f4f@kernel.org>
 <CAHmME9pEu2cvrSQd+Rg8Cp=KDfKEfjeiPPgF-WecXLHyRZVjcw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHmME9pEu2cvrSQd+Rg8Cp=KDfKEfjeiPPgF-WecXLHyRZVjcw@mail.gmail.com>

On Tue, May 23, 2023 at 06:47:41PM +0200, Jason A. Donenfeld wrote:
> On Tue, May 23, 2023 at 6:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 23 May 2023 18:14:18 +0200 Jason A. Donenfeld wrote:
> > > So, IOW, not a wireguard bug, right?
> >
> > What's slightly concerning is that there aren't any other timers
> > leading to
> >
> >   KASAN: slab-use-after-free Write in enqueue_timer
> >
> > :( If WG was just an innocent bystander there should be, right?
> 
> Well, WG does mod this timer for every single packet in its RX path.
> So that's bound to turn things up I suppose.

Here's one that is seemingly the same -- enqueuing a timer to a freed
base -- with the allocation and free being the same netdev core
function, but the UaF trigger for it is a JBD2 transaction thing:
https://syzkaller.appspot.com/text?tag=CrashReport&x=17dd2446280000
No WG at all in it, but there's still the mysterious 5376 value...

Jason

