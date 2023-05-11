Return-Path: <netdev+bounces-1671-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA226FEC14
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 08:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACF852814D6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 06:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73D52771E;
	Thu, 11 May 2023 06:59:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A165C27712
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A830C433EF;
	Thu, 11 May 2023 06:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683788362;
	bh=14Asm+7wof0CJmQWPL4ntzhR/mqw4r5Qual/0mCeR+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j5hP7v8ewaC3lR+AU+zYOhlhhz1XNjW8XAgDXtpRnc2uYW1TkCXW6WsCGww4A6cgb
	 SJ7SLlPgUbIjnpNOiXI+4BZotIuRoCfx7df37qw2Zm1+OW4z3hRnyYjeno5T3BBwiq
	 YZt5K8neHu5KPQIsws/1ovdrESU6xkZ9q9yYWx340qQg+DHGsGrVRhKRKxa7MmnBaw
	 OHwPwiYxb/3NOF2MNCE+GXrqGLBEAvQ9y1LVBMzQ3XmVUwbj3xigaoGosdrfgRQNsB
	 9jGMfiMuXA9NlzsQ4ndpiLq5+EPt9073X0NmM4cg7+l9qde9urWFxFuJY9nTvIxsp/
	 Vbf7QlIyL2s6w==
Date: Thu, 11 May 2023 09:59:17 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Lukas Wunner <lukas@wunner.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Philipp Rosenberger <p.rosenberger@kunbus.com>,
	Zhi Han <hanzhi09@gmail.com>
Subject: Re: [PATCH net-next] net: enc28j60: Use threaded interrupt instead
 of workqueue
Message-ID: <20230511065917.GT38143@unreal>
References: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
 <20230509080627.GF38143@unreal>
 <20230509133620.GA14772@wunner.de>
 <20230509135613.GP38143@unreal>
 <20230510190517.26f11d4a@kernel.org>
 <33eec982e2ae94c7141d135f1de9bec02a60735b.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33eec982e2ae94c7141d135f1de9bec02a60735b.camel@redhat.com>

On Thu, May 11, 2023 at 08:36:46AM +0200, Paolo Abeni wrote:
> On Wed, 2023-05-10 at 19:05 -0700, Jakub Kicinski wrote:
> > On Tue, 9 May 2023 16:56:13 +0300 Leon Romanovsky wrote:
> > > > > This is part of changelog which doesn't belong to commit message. The
> > > > > examples which you can find in git log, for such format like you used,
> > > > > are usually reserved to maintainers when they apply the patch.  
> > > > 
> > > > Is that a new rule?  
> > > 
> > > No, this rule always existed, just some of the maintainers didn't care
> > > about it.
> > > 
> > > > 
> > > > Honestly I think it's important to mention changes applied to
> > > > someone else's patch, if only to let it be known who's to blame
> > > > for any mistakes.  
> > > 
> > > Right, this is why maintainers use this notation when they apply
> > > patches. In your case, you are submitter, patch is not applied yet
> > > and all changes can be easily seen through lore web interface.
> > > 
> > > > 
> > > > I'm seeing plenty of recent precedent in the git history where
> > > > non-committers fixed up patches and made their changes known in
> > > > this way, e.g.:  
> > > 
> > > It doesn't make it correct.
> > > Documentation/maintainer/modifying-patches.rst
> > 
> > TBH I'm not sure if this is the correct reading of this doc.
> > I don't see any problem with Lukas using the common notation.
> > It makes it quite obvious what he changed and the changes are
> > not invasive enough to warrant a major rewrite of the commit msg.
> 
> My reading of such documentation is that (sub-)maintainers could be
> (more frequently) called to this kind of editing, but such editing is
> not restricted.
> 
> In this specific case I could not find quickly via lore references to
> the originating patch.

And this is mainly the issue here. Lukas changes are not different from
what many of us doing when we submit internal patches. We change/update/rewrite
patches which make them different from internal variant.

Once the patches are public, they will have relevant changelog section.

I don't see how modifying-patches.rst can be seen differently.

BTW, Regarding know-to-blame reasoning, everyone who added his
Signed-off-by to the patch is immediately suspicious.

Thanks

