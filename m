Return-Path: <netdev+bounces-4382-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0108470C453
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6AC01C20B97
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B4216429;
	Mon, 22 May 2023 17:33:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B099F13AC9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 17:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9C5C433EF;
	Mon, 22 May 2023 17:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684776834;
	bh=3qPc6G08Jn9Bp0Ht/x/Mtqj5U8h5QTlMNQbXuZkNyD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fi5OJHqOQ47Onye5elrcOF3+9RsrDjMBtTluLMhm7gyZSRzOXFoyzJ5Ib5/Vh3BGV
	 HWMBeMVxPcdVZF9mIDXTEUk4ngqNIXdkYZLYuU6hL0rf6DPVxgvOQSIe975uaZlXGj
	 1iawUj6HuNP4rghhlIuBg2itRk1mAd5jgz8VnnsONe/gqIddjgrw4pqjm231/eXK5e
	 IfbLzb94DvLWMSOf/03k1z2A0oAiUcjFAnqXLDjIaIqv+xzpNrbBNM4CePlJFDaZY7
	 0qEHThSa18Qp7INUnuCg0Mb/LY4q4RnOyyJ0xAayUTkD22UjReTSsk/oUCdJucMZps
	 d1nqABMoUR4dw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	nmanthey@amazon.de,
	pabeni@redhat.com,
	ptyadav@amazon.de,
	willemb@google.com
Subject: Re: [PATCH net] net: fix skb leak in __skb_tstamp_tx()
Date: Mon, 22 May 2023 17:33:51 +0000
Message-Id: <20230522173351.90497-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230522172302.90235-1-sj@kernel.org>
References: 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 22 May 2023 17:23:02 +0000 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 22 May 2023 17:18:53 +0000 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Mon, 22 May 2023 10:04:30 -0700 Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > 
> > > From: SeongJae Park <sj@kernel.org>
> > > Date: Mon, 22 May 2023 16:55:05 +0000
> > > > Hi Pratyush,
> > > > 
> > > > On Mon, 22 May 2023 17:30:20 +0200 Pratyush Yadav <ptyadav@amazon.de> wrote:
> > > > 
> > > > > Commit 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with
> > > > > TX timestamp.") added a call to skb_orphan_frags_rx() to fix leaks with
> > > > > zerocopy skbs. But it ended up adding a leak of its own. When
> > > > > skb_orphan_frags_rx() fails, the function just returns, leaking the skb
> > > > > it just cloned. Free it before returning.
> > > > > 
> > > > > This bug was discovered and resolved using Coverity Static Analysis
> > > > > Security Testing (SAST) by Synopsys, Inc.
> > > > > 
> > > > > Fixes: 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.")
> > > > 
> > > > Seems the commit has merged in several stable kernels.  Is the bug also
> > > > affecting those?  If so, would it be better to Cc stable@vger.kernel.org?
> > > 
> > > In netdev, we add 'net' in Subject for bugfix, then netdev maintainers
> > > send a pull request weekly, and stable maintainers backport the fixes to
> > > affected trees.
> > > 
> > > So we usually need not CC stable for netdev patches.
> > 
> > Thank you for the nice explanation!  Seems it is also well documented at
> > https://www.kernel.org/doc/html/v5.10/networking/netdev-FAQ.html#q-i-see-a-network-patch-and-i-think-it-should-be-backported-to-stable
> > 
> > However, I don't show the 'net' subject rule on the document.  Is it documented
> > somewhere else?
> 
> Seems I overlooked this:
> https://www.kernel.org/doc/html/v5.10/networking/netdev-FAQ.html#q-how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in

Sorry for continuing adding noises, but seems the process is, or will be,
changed by to the mainline commit dbbe7c962c3a8 ("docs: networking: drop
special stable handling").


Thanks,
SJ

[...]

