Return-Path: <netdev+bounces-4378-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54ACB70C42A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2301280FDD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E73716418;
	Mon, 22 May 2023 17:23:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A3179D2
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 17:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9BFC433EF;
	Mon, 22 May 2023 17:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684776185;
	bh=MhBBT1nMzudYiViBFfN67N0fmenBHnlHJ/Vr666rN4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YP47NsEXxkvHT0Iaww6+hxq4qgISGbD4M8slRTAeL0kPnHWc0kr+C6IR5wTDVJ/jF
	 7U7yJWltc6uktT7SdPKDQCErQG3AvIG1tZA5YHkg42+v+w6etsxPjY2QVhPtkyMAAo
	 BHPdPbBoKXJKkATP4CDQsze1hisiHnnudCYG/5v6T4tRXn2nlGd7ktJKo+18QpYwLN
	 LmkYcH/P4zNvnimJKWmCRHev/wACOOcrGell/xOYlLdRI2mLtkJhd83180tPU8PYOH
	 DsB3qziz/B1RVX0h5vqyJDDUf+mklXp5ZxcYDqqr1UZnp8GOcmeXdLldHqjsOBsbUt
	 /pofW4e5XZfWg==
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
Date: Mon, 22 May 2023 17:23:02 +0000
Message-Id: <20230522172302.90235-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230522171853.90173-1-sj@kernel.org>
References: 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 22 May 2023 17:18:53 +0000 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 22 May 2023 10:04:30 -0700 Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> 
> > From: SeongJae Park <sj@kernel.org>
> > Date: Mon, 22 May 2023 16:55:05 +0000
> > > Hi Pratyush,
> > > 
> > > On Mon, 22 May 2023 17:30:20 +0200 Pratyush Yadav <ptyadav@amazon.de> wrote:
> > > 
> > > > Commit 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with
> > > > TX timestamp.") added a call to skb_orphan_frags_rx() to fix leaks with
> > > > zerocopy skbs. But it ended up adding a leak of its own. When
> > > > skb_orphan_frags_rx() fails, the function just returns, leaking the skb
> > > > it just cloned. Free it before returning.
> > > > 
> > > > This bug was discovered and resolved using Coverity Static Analysis
> > > > Security Testing (SAST) by Synopsys, Inc.
> > > > 
> > > > Fixes: 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.")
> > > 
> > > Seems the commit has merged in several stable kernels.  Is the bug also
> > > affecting those?  If so, would it be better to Cc stable@vger.kernel.org?
> > 
> > In netdev, we add 'net' in Subject for bugfix, then netdev maintainers
> > send a pull request weekly, and stable maintainers backport the fixes to
> > affected trees.
> > 
> > So we usually need not CC stable for netdev patches.
> 
> Thank you for the nice explanation!  Seems it is also well documented at
> https://www.kernel.org/doc/html/v5.10/networking/netdev-FAQ.html#q-i-see-a-network-patch-and-i-think-it-should-be-backported-to-stable
> 
> However, I don't show the 'net' subject rule on the document.  Is it documented
> somewhere else?

Seems I overlooked this:
https://www.kernel.org/doc/html/v5.10/networking/netdev-FAQ.html#q-how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in


Thanks,
SJ

> 
> 
> Thanks,
> SJ
> 
> > 
> > Thanks,
> > Kuniyuki
> > 

