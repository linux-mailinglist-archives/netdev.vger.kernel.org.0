Return-Path: <netdev+bounces-12065-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99318735DB2
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74E1F1C20AC0
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0FF1427E;
	Mon, 19 Jun 2023 19:05:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16018D53B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 19:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC52C433C9;
	Mon, 19 Jun 2023 19:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687201516;
	bh=gd3acZnwvDULf6VisNuWpFCXVpO5cdtOMi2SDfzKdsU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Q9QyqatTt8FUgfHowG9AjRr9P7vqn/9E37rSAbDYQVfxLATxFkIs17+gPqtLNgwd6
	 D1plL8v1JwKj2XtjmZu7xbzPjvz2+xNVtQXqGD9KnIyH++0V05F3/V+NWkM4CcC5kI
	 7M2dXbNLh2fkI3Jo2MTS1QIcf7l/ltLazmdHhmQ24BEy77o7Wz3WsQnKIVSvbHAh6r
	 XwjY3LoMfFzKPg/6MGRbnnuYC6a41A3QScQrSoRQwoBEToeMaQ3+QaZJD0S+4K3dsB
	 DKbORhJ6FXDYvee6XVjm8MXGSdYVbuZ5RRs/NR8Q+hvtWNweeT+27igjVOZawbcbLC
	 rSl+RaDcdSk+g==
Date: Mon, 19 Jun 2023 12:05:15 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Saeed Mahameed <saeed@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, Saeed Mahameed <saeedm@nvidia.com>,
 <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Gal Pressman
 <gal@nvidia.com>
Subject: Re: [net-next 07/15] net/mlx5: Bridge, expose FDB state via debugfs
Message-ID: <20230619120515.5045132a@kernel.org>
In-Reply-To: <87r0q7uvqz.fsf@nvidia.com>
References: <20230616201113.45510-1-saeed@kernel.org>
	<20230616201113.45510-8-saeed@kernel.org>
	<20230617004811.46a432a4@kernel.org>
	<87v8fjvnhq.fsf@nvidia.com>
	<20230619112849.06252444@kernel.org>
	<87r0q7uvqz.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 19 Jun 2023 21:34:02 +0300 Vlad Buslov wrote:
> > Looks like my pw-bot shenanigans backfired / crashed, patches didn't
> > get marked as Changes Requested and Dave applied the series :S
> >
> > I understand the motivation but the information is easy enough to
> > understand to potentially tempt a user to start depending on it for
> > production needs. Then another vendor may get asked to implement
> > similar but not exactly the same set of stats etc. etc.  
> 
> That could happen (although consider that bridge offload functionality
> significantly predates mlx5 implementation and apparently no one really
> needed that until now), but such API would supplement, not replace the
> debugfs since we would like to have per-eswitch FDB state exposed
> together with our internal flags and everything as explained in my
> previous email.

Because crossing between eswitches incurs additional cost?

> > Do you have customer who will need this?  
> 
> Yes. But strictly for debugging (by human), not for building some
> proprietary weird user-space switch-controller application that would
> query this in normal mode of operation, if I understand your concern
> correctly.
> 
> > At the very least please follow up to make the files readable to only
> > root. Normal users should never look at debugfs IMO.  
> 
> Hmm, all other debugfs' in mlx5 that I tend to use for switching-related
> functionality debugging seems to be 0444 (lag, steering, tc hairpin).
> Why would this one be any different?

Querying the stats seems generally useful, so I'd like to narrow down
the access as much as possible. This way if the usage spreads we'll hear
complaints and can go back to creating a more appropriate API.

