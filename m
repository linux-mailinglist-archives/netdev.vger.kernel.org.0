Return-Path: <netdev+bounces-9151-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A1772791E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:47:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81A491C20FEE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471C879F0;
	Thu,  8 Jun 2023 07:47:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC80628
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 07:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638D5C433EF;
	Thu,  8 Jun 2023 07:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686210426;
	bh=hexUjmGVaD550ltGipYVsnItZsinP867PWCzA8Kpc6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qseVyII1AFg/7sj+nnd00HB53hHnIme3H5bFgsuhy0G9mGUpfKTF9VdGHOpuYLiZu
	 FFruR/60nIcknTgSmk84zRr7IpJsT1NQDYDJEWeT37fBXmwLVCkJrRretHv3ds11W3
	 Iivdg9slVae27pRz+OwTpdwWFROTMiOm0VqD1eW7jMnyR0X5e++VbFtmtQyhf2XQd7
	 jeE9LbK4eT3GefT6iec3QI5sWwAnDpFj6B559+Lv327JEZrKnsLMoJrDOY9tDT8Xg2
	 0uDocHAqFpceECfllyqbdRa5xHF8FEXns4sWszrtREM7VWNplJNa/luUqJj0+Eciz7
	 oqcCGmGEvNF/A==
Date: Thu, 8 Jun 2023 08:47:01 +0100
From: Lee Jones <lee@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	stable@kernel.org
Subject: Re: [PATCH v2 1/1] net/sched: cls_u32: Fix reference counter leak
 leading to overflow
Message-ID: <20230608074701.GD1930705@google.com>
References: <20230608072903.3404438-1-lee@kernel.org>
 <CANn89iKtkzTKhmeK15BO4uZOBQJhQWgQkaUgT+cxo+BwxE6Ofw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iKtkzTKhmeK15BO4uZOBQJhQWgQkaUgT+cxo+BwxE6Ofw@mail.gmail.com>

On Thu, 08 Jun 2023, Eric Dumazet wrote:

> On Thu, Jun 8, 2023 at 9:29 AM Lee Jones <lee@kernel.org> wrote:
> >
> > In the event of a failure in tcf_change_indev(), u32_set_parms() will
> > immediately return without decrementing the recently incremented
> > reference counter.  If this happens enough times, the counter will
> > rollover and the reference freed, leading to a double free which can be
> > used to do 'bad things'.
> >
> > In order to prevent this, move the point of possible failure above the
> > point where the reference counter is incremented.  Also save any
> > meaningful return values to be applied to the return data at the
> > appropriate point in time.
> >
> > This issue was caught with KASAN.
> >
> > Fixes: 705c7091262d ("net: sched: cls_u32: no need to call tcf_exts_change for newly allocated struct")
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Lee Jones <lee@kernel.org>
> > ---
> 
> Thanks Lee !

No problem.  Thanks for your help.

> Reviewed-by: Eric Dumazet <edumazet@google.com>

-- 
Lee Jones [李琼斯]

