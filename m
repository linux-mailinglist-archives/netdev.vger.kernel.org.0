Return-Path: <netdev+bounces-9314-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 819FB7286BF
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BB90281711
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82A7B1DCD7;
	Thu,  8 Jun 2023 17:58:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF4319930
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80501C433D2;
	Thu,  8 Jun 2023 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686247128;
	bh=H9vqqvqGv5gqr9XhvSYtAft9XyQ3waxGL9wQkTYdZSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YGadLPHWvUuYpZJzVtNKteHBmHXberFWobCwJzXC9V+hm7og0zVsBB3NougAt4YgA
	 W8e9YTf0FM5IAJWYglyDBjnFXWcVkxUuQ9u4tLtS9XuVQ03MPfSsQgbLvoOz5e8Z+b
	 4N4WUDAJQKaJ5zh1Es8bXVv2Ao9RjALoM7YUT1BWLo1xAwKL0jnYOtJNziaXaSwZxx
	 45XwgjGenK1LwtoX85Gl7AvQ1ZXI+bAMAcHpvSCtIGC1Aqf9cKnaMyaKVWJ6C38V2c
	 efczC+CmQNTL3Si87fcPWj9r79IhmYct0m2su4t0bdgjH1/zA/TAA2HFDEmboRu03r
	 tVoOuoCCy+oWw==
Date: Thu, 8 Jun 2023 18:58:43 +0100
From: Lee Jones <lee@kernel.org>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Eric Dumazet <edumazet@google.com>, xiyou.wangcong@gmail.com,
	jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH v2 1/1] net/sched: cls_u32: Fix reference counter leak
 leading to overflow
Message-ID: <20230608175843.GA3635807@google.com>
References: <20230608072903.3404438-1-lee@kernel.org>
 <CANn89iKtkzTKhmeK15BO4uZOBQJhQWgQkaUgT+cxo+BwxE6Ofw@mail.gmail.com>
 <20230608074701.GD1930705@google.com>
 <CAM0EoM=osXFK7FLzF2QB3PvZ+W4sr=pnPD5jG1FjrzSbw-emWQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoM=osXFK7FLzF2QB3PvZ+W4sr=pnPD5jG1FjrzSbw-emWQ@mail.gmail.com>

On Thu, 08 Jun 2023, Jamal Hadi Salim wrote:

> On Thu, Jun 8, 2023 at 3:47 AM Lee Jones <lee@kernel.org> wrote:
> >
> > On Thu, 08 Jun 2023, Eric Dumazet wrote:
> >
> > > On Thu, Jun 8, 2023 at 9:29 AM Lee Jones <lee@kernel.org> wrote:
> > > >
> > > > In the event of a failure in tcf_change_indev(), u32_set_parms() will
> > > > immediately return without decrementing the recently incremented
> > > > reference counter.  If this happens enough times, the counter will
> > > > rollover and the reference freed, leading to a double free which can be
> > > > used to do 'bad things'.
> > > >
> > > > In order to prevent this, move the point of possible failure above the
> > > > point where the reference counter is incremented.  Also save any
> > > > meaningful return values to be applied to the return data at the
> > > > appropriate point in time.
> > > >
> > > > This issue was caught with KASAN.
> > > >
> > > > Fixes: 705c7091262d ("net: sched: cls_u32: no need to call tcf_exts_change for newly allocated struct")
> > > > Suggested-by: Eric Dumazet <edumazet@google.com>
> > > > Signed-off-by: Lee Jones <lee@kernel.org>
> > > > ---
> > >
> > > Thanks Lee !
> >
> > No problem.  Thanks for your help.
> >
> > > Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

Thanks Jamal.

-- 
Lee Jones [李琼斯]

