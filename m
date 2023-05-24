Return-Path: <netdev+bounces-5103-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4AB70FA88
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:38:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 468BE281482
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D18C819BA9;
	Wed, 24 May 2023 15:38:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605CD1993B
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B315EC433EF;
	Wed, 24 May 2023 15:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684942695;
	bh=KciUQIFL6wfb4PhBuozfCk8a+kMHVwemgG3RA/ML5TQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=T05xHDwKm/l+cIbLgSTIZaMQEuHWKWfLMaoc29V9KL3mHfU+3pd13QOHTAPqkRoCX
	 rdSOk7Bcv7GQwPYbNBI9sEv6QZPBV1OEI3ugxwuJCYawuuHZTCdfARqUkuKgukmmSM
	 /8NbtLbXWvkXjdC0GtZFKY4zfoGTqW2cc889BGGZu5PmbzFTGC4cLnNoJa0G7Co+eh
	 BX9dWdwYdqt3IVed/OkRgE4kqEyizveT6foRPF0yGAM5aQSyluAky8QnbV3CVhBJwS
	 fPG9QB6U0QHfc8XS70AM22dD+/FHBIKzQqZXMNG738d+6MU29aq6p5nMGJt+VocboR
	 8JWb4KPhtv5RQ==
Date: Wed, 24 May 2023 08:38:13 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Simon Horman <simon.horman@corigine.com>, Paolo Abeni
 <pabeni@redhat.com>, Louis Peens <louis.peens@corigine.com>, David Miller
 <davem@davemloft.net>, netdev@vger.kernel.org, oss-drivers@corigine.com,
 Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next] nfp: add L4 RSS hashing on UDP traffic
Message-ID: <20230524083813.65cdee0d@kernel.org>
In-Reply-To: <CAF=yD-JH2NHTXCg-Z=cUw-JK0g9Y9pb-pcyboq5AkES+ohShkg@mail.gmail.com>
References: <20230522141335.22536-1-louis.peens@corigine.com>
	<beea9ce517bf597fb7af13a39a53bb1f47e646d4.camel@redhat.com>
	<20230523142005.3c5cc655@kernel.org>
	<ZG31Plb6/UF3XKd3@corigine.com>
	<20230524082216.1e1fed93@kernel.org>
	<CAF=yD-JH2NHTXCg-Z=cUw-JK0g9Y9pb-pcyboq5AkES+ohShkg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 11:33:15 -0400 Willem de Bruijn wrote:
> The OCP draft spec already has this wording, which covers UDP:
> 
> "RSS defines two rules to derive queue selection input in a
> flow-affine manner from packet headers. Selected fields of the headers
> are extracted and concatenated into a byte array. If the packet is
> IPv4 or IPv6, not fragmented, and followed by a transport layer
> protocol with ports, such as TCP and UDP, then extract the
> concatenated 4-field byte array { source address, destination address,
> source port, destination port }. Else, if the packet is IPv4 or IPv6,
> extract 2-field byte array { source address, destination address }.
> IPv4 packets are considered fragmented if the more fragments bit is
> set or the fragment offset field is non-zero."

Ugh, that's what I thought. I swear I searched it for "fragment"
yesterday and the search came up empty. I blame google docs :|

We should probably still document the recommendation that if the NIC
does not comply and hashes on ports with MF set - it should disable 
UDP hashing by default (in kernel docs).

