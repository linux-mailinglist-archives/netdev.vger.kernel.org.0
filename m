Return-Path: <netdev+bounces-8945-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C21D72660E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:33:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5788B280E11
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E673AE53;
	Wed,  7 Jun 2023 16:33:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7295B3AE42
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC76C433EF;
	Wed,  7 Jun 2023 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686155605;
	bh=QCnKZ26WwWsZZmxFpjnDjNK9QRag4GUfktjwtWuc8Bc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hl+EzPimVNm+GhziKVoNvfir+FO8nLrBKGWnZgRNoxEHw8lV1NrIxTkvJ+s58aKWP
	 o4jsYT2rgUcvndIJjMKuun5kGu69SH43CIbb4OMLTI1fL9ARrqOE3CMtjSRu1k+y9G
	 c+yg9XOvgYfqnahtH6L6T1avyqlXdwWVGJjC75s89bL6cKW9gZhPcnHHJF2ZEZ6noB
	 Evq1UQvZhmLg2WLH9pRgYVZA1XUPY9aRy8z5viWc29jbnE0jApwAp4lOMqHUteLvNY
	 P3CigiXfA+476TQERddX0JFWU7sk6I8wnv5sKM9EaLmQNCEWo+FYevB/tPzOysChJF
	 Ns00Da+1/B17g==
Date: Wed, 7 Jun 2023 09:33:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Gal Pressman <gal@nvidia.com>
Cc: Edwin Peer <espeer@gmail.com>, David Ahern <dsahern@gmail.com>, netdev
 <netdev@vger.kernel.org>, Andrew Gospodarek
 <andrew.gospodarek@broadcom.com>, Michael Chan <michael.chan@broadcom.com>,
 Stephen Hemminger <stephen@networkplumber.org>, Michal Kubecek
 <mkubecek@suse.cz>
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute
 list in nla_nest_end()
Message-ID: <20230607093324.2b7712d9@kernel.org>
In-Reply-To: <f2a02c4f-a9c0-a586-1bde-ff2779933270@nvidia.com>
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
	<20230606091706.47d2544d@kernel.org>
	<f2a02c4f-a9c0-a586-1bde-ff2779933270@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Jun 2023 16:31:48 +0300 Gal Pressman wrote:
> On 06/06/2023 19:17, Jakub Kicinski wrote:
> > On Tue, 6 Jun 2023 11:01:14 +0300 Gal Pressman wrote:  
> >> Jakub, sorry if this has been discussed already in the past, but can you
> >> please clarify what is an accepted (or more importantly, not accepted)
> >> solution for this issue? I'm not familiar with the history and don't
> >> want to repeat previous mistakes.  
> > 
> > The problem is basically that attributes can only be 64kB and 
> > the legacy SR-IOV API wraps all the link info in an attribute.  
> 
> Isn't that a second order issue? The skb itself is limited to 32kB AFAICT.

Hm, you're right. But allocation larger than 32kB are costly.
We can't make every link dump allocate 64kB, it will cause
regressions on systems under memory pressure (== real world).

You'd need to come up with some careful scheme of using larger
buffers.

> >> So far I've seen discussions about increasing the recv buffer size, and
> >> this patchset which changes the GETLINK ABI, both of which were nacked.  
> > 
> > Filtering out some of the info, like the stats, is okay, but that just
> > increases the limit. A limit still exists.  
> 
> Any objections to at least take the second patch here?
> It doesn't introduce any ABI changes, but will allow 'ip link show' to
> work properly (although 'ip -s link show' will remain broken).

Yup, retest / repost?

> >> Having 'ip link show' broken is very unfortunate :\, how should one
> >> approach this issue in 2023?  
> > 
> > Sure is, which is why we should be moving away from the legacy SR-IOV
> > APIs.  
> 
> Agreed!
> I do not suggest to extend/improve this API, just make sure it's not broken.
> 


