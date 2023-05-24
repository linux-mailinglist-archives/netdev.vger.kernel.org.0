Return-Path: <netdev+bounces-5084-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5D8070F9F9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:22:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 918FF28132B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE97B19538;
	Wed, 24 May 2023 15:22:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C5E19526
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FA2C433EF;
	Wed, 24 May 2023 15:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684941738;
	bh=JLviEyronnoscJlLTMNYyJVgttA8Pfz313qCaxvn7ME=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NITmt/2+plIX53/l2PqPoRAP4oH13HI9mBXRs3/Xgm7AOlf18sryvmDXN45OBNkO7
	 3Mvg7VIvvCFo691y9jxTAcEnLLErUaN5w90alyl7CMucBM9bMUVuS/uLw20gu72yFH
	 5XCiNo5Zna+5MaZSz8P4eK7mPJJcVNrcoHiVRiWO735D+fiA/sL00uFvlVNPSvBc15
	 6z5dQImmRnNcGsV+1frewGyo2LYcoPkNt4yo9rvwOc8BJpjL2dR6KyTb0F4zohfUOx
	 QyibpmxqWHk/fY8mra/INpy8brTXSwec3hMtKrnqMHUFtMt72EpPH9YGJ3sZdgIq5/
	 a9McluDBrHPmg==
Date: Wed, 24 May 2023 08:22:16 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Louis Peens <louis.peens@corigine.com>,
 David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
 oss-drivers@corigine.com, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next] nfp: add L4 RSS hashing on UDP traffic
Message-ID: <20230524082216.1e1fed93@kernel.org>
In-Reply-To: <ZG31Plb6/UF3XKd3@corigine.com>
References: <20230522141335.22536-1-louis.peens@corigine.com>
	<beea9ce517bf597fb7af13a39a53bb1f47e646d4.camel@redhat.com>
	<20230523142005.3c5cc655@kernel.org>
	<ZG31Plb6/UF3XKd3@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 13:30:06 +0200 Simon Horman wrote:
> On Tue, May 23, 2023 at 02:20:05PM -0700, Jakub Kicinski wrote:
> > Yup, that's the exact reason it was disabled by default, FWIW.
> > 
> > The Microsoft spec is not crystal clear on how to handles this:
> > https://learn.microsoft.com/en-us/windows-hardware/drivers/network/rss-hashing-types#ndis_hash_ipv4
> > There is a note saying:
> > 
> >   If a NIC receives a packet that has both IP and TCP headers,
> >   NDIS_HASH_TCP_IPV4 should not always be used. In the case of a
> >   fragmented IP packet, NDIS_HASH_IPV4 must be used. This includes
> >   the first fragment which contains both IP and TCP headers.
> > 
> > While NDIS_HASH_UDP_IPV4 makes no such distinction and talks only about
> > "presence" of the header.
> > 
> > Maybe we should document that device is expected not to use the UDP
> > header if MF is set?  
> 
> Yes, maybe.
> 
> Could you suggest where such documentation should go?

That's the hardest question, perhaps :)

Documentation/networking/scaling.rst and/or OCP NIC spec:

https://ocp-all.groups.io/g/OCP-Networking/topic/nic_software_core_offloads/98930671?p=,,,20,0,0,0::recentpostdate/sticky,,,20,2,0,98930671,previd%3D1684255676674808204,nextid%3D1676673801962532335&previd=1684255676674808204&nextid=1676673801962532335

