Return-Path: <netdev+bounces-8577-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F404E7249F3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AAA2280EC1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4281ED4E;
	Tue,  6 Jun 2023 17:15:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417ED1ED2C
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F62C433D2;
	Tue,  6 Jun 2023 17:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686071730;
	bh=pNyuVt+ynnkYZR2pnEL6KwHsOOVOjbLLbX3c665YwkI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ERW/jcmatJZEMii/hFGqKfnIitLfbHVChd8FhQhIkV5dwz7+gNJZJSSj63dmIvsEv
	 RlkAUKw2iVnZuPIAyek9566pGfOfshqZQxfVVEdvt+e2ruA15PcL2dWJK+1rs2Rk+f
	 ChIiYmFQPda8AWXXFqgB5tKgFjA2XlK7bxQzQwIJUOU/gZZDfnCwiJxu2E7QSdwuYo
	 CTklHm6IFegrQQBljc+16SM8ioH9u6KQl32ZyJPUu6TE7GnErKO/645qR6RqmR820g
	 08qNsrjpqOSOimZgdJ4Vnq6ZNIocmQ213AHp86VcyzEcdIOF+DOXZcmC4jjIxei5k3
	 x95aPQSXgVKyw==
Date: Tue, 6 Jun 2023 10:15:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jamal Hadi Salim <hadi@mojatatu.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
 deb.chatterjee@intel.com, tom@sipanda.io, p4tc-discussions@netdevconf.info,
 Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com,
 xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, khalidm@nvidia.com, toke@redhat.com
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 03/28] net/sched:
 act_api: increase TCA_ID_MAX
Message-ID: <20230606101529.6ea62da4@kernel.org>
In-Reply-To: <CAAFAkD9pU0DemGSOBcFoqJWkmvt4e6TLsDM0zzV+yaUY_m-MHg@mail.gmail.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
	<20230517110232.29349-3-jhs@mojatatu.com>
	<20230605103949.3317f1ed@kernel.org>
	<CAAFAkD9pU0DemGSOBcFoqJWkmvt4e6TLsDM0zzV+yaUY_m-MHg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jun 2023 13:04:18 -0400 Jamal Hadi Salim wrote:
> > > diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> > > index 5b66df3ec332..337411949ad0 100644
> > > --- a/include/uapi/linux/pkt_cls.h
> > > +++ b/include/uapi/linux/pkt_cls.h
> > > @@ -140,9 +140,9 @@ enum tca_id {
> > >       TCA_ID_MPLS,
> > >       TCA_ID_CT,
> > >       TCA_ID_GATE,
> > > -     TCA_ID_DYN,
> > > +     TCA_ID_DYN = 256,
> > >       /* other actions go here */
> > > -     __TCA_ID_MAX = 255
> > > +     __TCA_ID_MAX = 1023
> > >  };
> > >
> > >  #define TCA_ID_MAX __TCA_ID_MAX  
> >
> > I haven't look at any of the patches but this stands out as bad idea
> > on the surface.  
> 
> The idea is to reserve a range of the IDs for dynamic use in this case
> from 256-1023. The kernel will issue an action id from that range when
> we request it. The assumption is someone adding a "static" action ID
> will populate the above enum and is able to move the range boundaries.
> P4TC continues to work with old and new kernels and with old and new
> tc.
> Did i miss something you were alluding to?

Allocating action IDs for P4 at the same level as normal TC actions
makes the P4 stuff looks like a total parallel implementation to me.
Why is there not a TCA_ID_P4 which muxes internally?
AFAIU interpretation of action attributes depends on the ID, which
means that user space to parse the action attrs has to not only look 
at the ID but now also resolve what that ID means.

