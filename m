Return-Path: <netdev+bounces-5125-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B43970FBAF
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21B401C20CB6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C05219E65;
	Wed, 24 May 2023 16:28:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02E31951F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D116C433D2;
	Wed, 24 May 2023 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684945720;
	bh=JI7dZ2VEutI4MU0IXq8Td5AAsRPrhYdt0rSpfxY6PDc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lqTfxrZgdvn/lLdiWNouI9wgIW4Q7cxeU96EliYEDyz/xiP65GTMwItpVmt9Gdlx1
	 10IfeW1Nv7hwfSZAWP6z4r3shXS06kc13usA1jrnaLpw6Xm8kpm9GZwvjSn51iqF4O
	 +Mf2oWeO8GybpXQiu94hn+SSbrjjkg1M77oZpZpKqyMi5/tIuFzcGADwxLCCpjLPnU
	 IJmXQmqZs7dnk6C7xt0s9Y/B7seBta/KAWgnE1S+CQ7CGRWgRzDN8ExEcWg9s7tAeR
	 v9JZTwaVrFvQh+Id9Jx+VHDqkfERNEQ370zjpqaOs3SA6ig4BXP7kuLkXSlCElWpol
	 dKxKftoc7c41Q==
Date: Wed, 24 May 2023 09:28:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Willem de Bruijn  <willemdebruijn.kernel@gmail.com>, Simon Horman
 <simon.horman@corigine.com>, Louis Peens  <louis.peens@corigine.com>, David
 Miller <davem@davemloft.net>, netdev@vger.kernel.org,
 oss-drivers@corigine.com, Willem de Bruijn  <willemb@google.com>
Subject: Re: [PATCH net-next] nfp: add L4 RSS hashing on UDP traffic
Message-ID: <20230524092839.2688a15d@kernel.org>
In-Reply-To: <2ecb3189855ceb4f7399271bf99af5a27926e59c.camel@redhat.com>
References: <20230522141335.22536-1-louis.peens@corigine.com>
	<beea9ce517bf597fb7af13a39a53bb1f47e646d4.camel@redhat.com>
	<20230523142005.3c5cc655@kernel.org>
	<ZG31Plb6/UF3XKd3@corigine.com>
	<20230524082216.1e1fed93@kernel.org>
	<CAF=yD-JH2NHTXCg-Z=cUw-JK0g9Y9pb-pcyboq5AkES+ohShkg@mail.gmail.com>
	<20230524083813.65cdee0d@kernel.org>
	<2ecb3189855ceb4f7399271bf99af5a27926e59c.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 24 May 2023 18:14:55 +0200 Paolo Abeni wrote:
> > Ugh, that's what I thought. I swear I searched it for "fragment"
> > yesterday and the search came up empty. I blame google docs :|
> >=20
> > We should probably still document the recommendation that if the NIC
> > does not comply and hashes on ports with MF set - it should disable=20
> > UDP hashing by default (in kernel docs). =20
>=20
> FTR, the above schema could still move the same flow on different
> queues - if some datagrams in the given flow are fragmented and some
> are not.

Ah, you're right.

> Out of sheer ignorance I really don't know if/how many NICs implement
> RSS hashing=C2=A0with the above schema (using different data according to
> the IP header fragments related fields). I'm guessing some (most?) use
> a simpler schema (always L4 if available or never L4).
>=20
> I *think* we could as well suggest always using L4 for UDP. If users
> care about fragments they will have to explicitly deal with them
> anyway.

Makes sense. QUIC changed the math on how likely UDP fragmentation is.

