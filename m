Return-Path: <netdev+bounces-9022-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B148726985
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B0642812D2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B1A35B49;
	Wed,  7 Jun 2023 19:10:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F256118
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 19:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E68EC433EF;
	Wed,  7 Jun 2023 19:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686165008;
	bh=8D1/cxGhHDE49qugp8X6axwPXEqLwTjbyCSi4J025Js=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fRiFRWcFAxQg98gD5jA276ahg7V1ajs8KVdPYPNLoXTkP8UwdGtcFKYCj1qZG7OCI
	 2LHznSA9B5i/6Lpe136ECjTbMQSFjdlRyKIbY5DAYTDCTOWOJD5gvLmwXrBHB7muEA
	 w4wg/M45FSQdkuce8tXj264VuS0IrSlEDLnI4ihEGwkEIV+Qt6g8q5SI0suyFn5UTJ
	 5/71F0d2pj2MAU+EqF1fClQIIAoou8nGdCKU5slFBvVof3Pg1/XbUF3R7mAiEgWZMB
	 dY8jgIjc90Lf2eav3yLKWRj0nw468+Y4z1cuNCIayzLIf6JxOODkKI0mlbqy55FJtw
	 8hGv0LeJZDPiw==
Date: Wed, 7 Jun 2023 12:10:06 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>, Tony Nguyen
 <anthony.l.nguyen@intel.com>, davem@davemloft.net, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, emil.s.tantilov@intel.com,
 jesse.brandeburg@intel.com, sridhar.samudrala@intel.com,
 shiraz.saleem@intel.com, sindhu.devale@intel.com, willemb@google.com,
 decot@google.com, andrew@lunn.ch, leon@kernel.org, mst@redhat.com,
 simon.horman@corigine.com, shannon.nelson@amd.com,
 stephen@networkplumber.org, Alan Brady <alan.brady@intel.com>, Joshua Hay
 <joshua.a.hay@intel.com>, Madhu Chittim <madhu.chittim@intel.com>, Phani
 Burra <phani.r.burra@intel.com>, Shailendra Bhatnagar
 <shailendra.bhatnagar@intel.com>, Krishneil Singh
 <krishneil.k.singh@intel.com>
Subject: Re: [PATCH net-next 05/15] idpf: add create vport and netdev
 configuration
Message-ID: <20230607121006.59d57ca0@kernel.org>
In-Reply-To: <CAF=yD-KAQceDE9UmJAvepz8tWGgqyr+drv_WYp-q=7vEEUTfiA@mail.gmail.com>
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
	<20230530234501.2680230-6-anthony.l.nguyen@intel.com>
	<20230531232239.5db93c09@kernel.org>
	<3fe3bf2a-6cb2-c3a1-3fa3-ed9a5425e603@intel.com>
	<CAF=yD-KAQceDE9UmJAvepz8tWGgqyr+drv_WYp-q=7vEEUTfiA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Jun 2023 20:20:57 +0200 Willem de Bruijn wrote:
> > > Please use locks. Every single Intel driver comes with gazillion flags
> > > and endless bugs when the flags go out of sync.  
> >
> > Thanks for the feedback. Will use mutex lock instead of 'VC_MSG_PENDING'
> > flag.  
> 
> Was that the intent of the comment?
> 
> Or is it to replace these individual atomic test_and_set bit
> operations with a single spinlock-protected critical section around
> all the flag operations?

No, no. Intel drivers have a history of adding flags to work around
locking problems. Whatever this bit is protecting should be protected
by a normal synchronization primitive instead.

I don't understand why.

Replacing an atomic bitop with a spin lock is a non-change.

> That's how I read the suggestion.

