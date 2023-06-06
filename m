Return-Path: <netdev+bounces-8555-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 497477248C7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:17:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96BF81C20A87
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36D6B30B93;
	Tue,  6 Jun 2023 16:17:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F7E37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391D8C4339B;
	Tue,  6 Jun 2023 16:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686068227;
	bh=fj73aW60IcK4Ac6zvS/nWXzMdOyCqRJ+FWVy8Lw8onI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UHxMx6HJc6jlhI6HdrUsVz4PZ0U6xkHe2WGCxCWMp+V5k+TwWZF1Etz8E04ZXruX0
	 4mGY9a5KedFw+OYB3c7J7NV0a9sIDxbnO5tIA/CmsYREPIgsRcOG6qvNYUxviDfhj7
	 v20D3mxAf6XKo/3+fecN7Iss9xY26Kiz2hVpDwjrTpsdz2Zu/NqsSeBmtfQYMtH5TS
	 EDflT00zIckMLFD4vagS3KTnPLR6Vmj46gqrtKefjuySDou4+ff0Zt9m/QJGLxE2A7
	 GfKGA1apKxsmrvZaZlbRDvb6gVg05kJoLLpYSpI+KTx6XPaou+qmfk3rCrM7j5WUdC
	 diduyEnYwh2BA==
Date: Tue, 6 Jun 2023 09:17:06 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Gal Pressman <gal@nvidia.com>
Cc: Edwin Peer <espeer@gmail.com>, David Ahern <dsahern@gmail.com>, netdev
 <netdev@vger.kernel.org>, Andrew Gospodarek
 <andrew.gospodarek@broadcom.com>, Michael Chan <michael.chan@broadcom.com>,
 Stephen Hemminger <stephen@networkplumber.org>, Michal Kubecek
 <mkubecek@suse.cz>
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute
 list in nla_nest_end()
Message-ID: <20230606091706.47d2544d@kernel.org>
In-Reply-To: <0c04665f-545a-7552-a4c2-c7b9b2ee4e6b@nvidia.com>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
	<20210123045321.2797360-2-edwin.peer@broadcom.com>
	<1dc163b0-d4b0-8f6c-d047-7eae6dc918c4@gmail.com>
	<CAKOOJTwKK5AgTf+g5LS4MMwR_HwbdFS6U7SFH0jZe8FuJMgNgA@mail.gmail.com>
	<CAKOOJTzwdSdwBF=H-h5qJzXaFDiMoX=vjrMi_vKfZoLrkt4=Lg@mail.gmail.com>
	<62a12b2c-c94e-8d89-0e75-f01dc6abbe92@gmail.com>
	<CAKOOJTwBcRJah=tngJH3EaHCCXb6T_ptAV+GMvqX_sZONeKe9w@mail.gmail.com>
	<cdbd5105-973a-2fa0-279b-0d81a1a637b9@nvidia.com>
	<20230605115849.0368b8a7@kernel.org>
	<CAOpCrH4-KgqcmfXdMjpp2PrDtSA4v3q+TCe3C9E5D3Lu-9YQKg@mail.gmail.com>
	<0c04665f-545a-7552-a4c2-c7b9b2ee4e6b@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jun 2023 11:01:14 +0300 Gal Pressman wrote:
> On 05/06/2023 22:27, Edwin Peer wrote:
> > Thanks for the CC, I left Broadcom quite some time ago and am no
> > longer subscribed to netdev as a result (been living in firmware land
> > doing work in Rust).
> > 
> > I have no immediate plans to pick this up, at least not in the short
> > to medium term. My work in progress was on the laptop I returned and I
> > cannot immediately recall what solution I had in mind here.
> 
> Jakub, sorry if this has been discussed already in the past, but can you
> please clarify what is an accepted (or more importantly, not accepted)
> solution for this issue? I'm not familiar with the history and don't
> want to repeat previous mistakes.

The problem is basically that attributes can only be 64kB and 
the legacy SR-IOV API wraps all the link info in an attribute.

> So far I've seen discussions about increasing the recv buffer size, and
> this patchset which changes the GETLINK ABI, both of which were nacked.

Filtering out some of the info, like the stats, is okay, but that just
increases the limit. A limit still exists.

> Having 'ip link show' broken is very unfortunate :\, how should one
> approach this issue in 2023?

Sure is, which is why we should be moving away from the legacy SR-IOV
APIs.

