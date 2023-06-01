Return-Path: <netdev+bounces-7165-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 649D971EF75
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:48:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E93571C210BF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75EE019E6C;
	Thu,  1 Jun 2023 16:48:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6EF156F0
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FEDC433EF;
	Thu,  1 Jun 2023 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685638101;
	bh=LXnkDTkz1SKqT0x81Y2GOyRdBeWkTbwqHBn8qS6LGFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V9uvnkAwm4gdxD24L445/PkX1e77g1eiZH7cVy6Ob7zFqoG0PPxvERlqorV0WPwc2
	 dVdtj5swlzdh9t+51Ic4FBiR92OGrfL2V05l1N1sFThj/OKzzTQwMfY4QcYqtHDphx
	 ZXU4IH9X4ee9vUr4wvYi+rJlinI6dbgBHl2zlw6nWq+UwNBgHHD6onV577z8jn/LQS
	 LZdyjmSbbHI9wkEaXyA5FAEQRYraT/9diRWXus6KmybCQdjd5+Aij6LRCbxO78Tf80
	 cDHZ7YPNA/aKUEdivGQnM9cqDQUHRJeTU3HOaFQPWU2gfp+6huMWBSTE5/SGr5qimL
	 sY4vDsOhKz79A==
Date: Thu, 1 Jun 2023 17:48:17 +0100
From: Lee Jones <lee@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, xiyou.wangcong@gmail.com,
	jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/1] net/sched: cls_u32: Fix reference counter leak
 leading to overflow
Message-ID: <20230601164817.GH449117@google.com>
References: <20230531141556.1637341-1-lee@kernel.org>
 <CANn89iJw2N9EbF+Fm8KCPMvo-25ONwba+3PUr8L2ktZC1Z3uLw@mail.gmail.com>
 <CAM0EoMnUgXsr4UBeZR57vPpc5WRJkbWUFsii90jXJ=stoXCGcg@mail.gmail.com>
 <20230601140640.GG449117@google.com>
 <CANn89i+j7ymO2-wyZtavCotwODdgOAcJ5O_GFjLkegqAsx4F5A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+j7ymO2-wyZtavCotwODdgOAcJ5O_GFjLkegqAsx4F5A@mail.gmail.com>

On Thu, 01 Jun 2023, Eric Dumazet wrote:

> On Thu, Jun 1, 2023 at 4:06 PM Lee Jones <lee@kernel.org> wrote:
> >
> > On Wed, 31 May 2023, Jamal Hadi Salim wrote:
> >
> > > On Wed, May 31, 2023 at 11:03 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Wed, May 31, 2023 at 4:16 PM Lee Jones <lee@kernel.org> wrote:
> > > > >
> > > > > In the event of a failure in tcf_change_indev(), u32_set_parms() will
> > > > > immediately return without decrementing the recently incremented
> > > > > reference counter.  If this happens enough times, the counter will
> > > > > rollover and the reference freed, leading to a double free which can be
> > > > > used to do 'bad things'.
> > > > >
> > > > > Cc: stable@kernel.org # v4.14+
> > > >
> > > > Please add a Fixes: tag.
> >
> > Why?
> 
> How have you identified v4.14+ ?
> 
> Probably you did some research/"git archeology".
> 
> By adding the Fixes: tag, you allow us to double check immediately,
> and see if other bugs need to be fixed at the same time.
> 
> You can also CC blamed patch authors, to get some feedback.
> 
> Otherwise, we (people reviewing this patch) have to also do this
> research from scratch.
> 
> In this case, it seems bug was added in
> 
> commit 705c7091262d02b09eb686c24491de61bf42fdb2
> Author: Jiri Pirko <jiri@resnulli.us>
> Date:   Fri Aug 4 14:29:14 2017 +0200
> 
>     net: sched: cls_u32: no need to call tcf_exts_change for newly
> allocated struct
> 
> 
> A nice Fixes: tag would then be
> 
> Fixes: 705c7091262d ("net: sched: cls_u32: no need to call
> tcf_exts_change for newly allocated struct")

Thanks for digging this out.  I will add it.

-- 
Lee Jones [李琼斯]

