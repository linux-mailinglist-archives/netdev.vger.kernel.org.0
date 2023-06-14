Return-Path: <netdev+bounces-10592-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 557F472F3ED
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:05:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33FE41C20C0B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697D0642;
	Wed, 14 Jun 2023 05:05:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0A9361;
	Wed, 14 Jun 2023 05:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE6CC433C0;
	Wed, 14 Jun 2023 05:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686719109;
	bh=lqfQbJAQZd06+abR9A08Hw+k3lRkhhEnD9V9drW6m5g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rTraGRTAkAvqzwoBAy2iuH7DjLZ8AxNKRNeJI0ogBhNqJdAKKxonXB23bZ/G5oOpm
	 I5QxN590wl4efECf71hDGvHZtjoecHeJONQdrKB1qRrEmelqw8fXGyXX7q0p4QnwAK
	 f+YB8xvsNjuffNIwSrk2Y4keeladVNmmaXJ8jdz006Hh6xpbGsp8fxtBuQU1m0drw7
	 6z7S5q8Vpc4fGAgF1J7yG85Td8f6Wqo5qdMTr/TPGVgbTET0vRSt+brB+jOUqIYm+T
	 UuenL/17dM+KX5gHCjemufIVSdbCilGZ0Gff6CnHJyvYqCc7H+m9TBuyEOe85g216D
	 a2GwCFetvWqyw==
Date: Tue, 13 Jun 2023 22:05:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Ahern <dsahern@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org,
 ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
 john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
 jolsa@kernel.org, willemb@google.com, magnus.karlsson@intel.com,
 bjorn@kernel.org, maciej.fijalkowski@intel.com, netdev@vger.kernel.org
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
Message-ID: <20230613220507.0678bd02@kernel.org>
In-Reply-To: <70d0f31b-3358-d615-a00c-7e664f5f789f@kernel.org>
References: <20230612172307.3923165-1-sdf@google.com>
	<20230613203125.7c7916bc@kernel.org>
	<70d0f31b-3358-d615-a00c-7e664f5f789f@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Jun 2023 20:54:26 -0700 David Ahern wrote:
> On 6/13/23 9:31 PM, Jakub Kicinski wrote:
> > On Mon, 12 Jun 2023 10:23:00 -0700 Stanislav Fomichev wrote:  
> >> The goal of this series is to add two new standard-ish places
> >> in the transmit path:
> >>
> >> 1. Right before the packet is transmitted (with access to TX
> >>    descriptors)  
> 
> If a device requires multiple Tx descriptors per skb or multibuf frame,
> how would that be handled within the XDP API?
> 
> > I'm not sure that the Tx descriptors can be populated piecemeal.  
> 
> If it is host memory before the pidx move, why would that matter? Do you
> have a specific example in mind?

I don't mean it's impossible implement, but it's may get cumbersome.
TSO/CSO/crypto may all need to know where L4 header starts, f.e.
Some ECN marking in the NIC may also want to know where L3 is.
So the offsets will get duplicated in each API.

> > If we were ever to support more standard offload features, which
> > require packet geometry (hdr offsets etc.) to be described "call
> > per feature" will end up duplicating arguments, and there will be
> > a lot of args..
> > 
> > And if there is an SKB path in the future combining the normal SKB
> > offloads with the half-rendered descriptors may be a pain.  
> 
> Once the descriptor(s) is (are) populated, the skb is irrelevant is it
> not? Only complication that comes to mind is wanting to add or remove
> headers (e.g., tunnels) which will be much more complicated at this
> point, but might still be possible on a per NIC (and maybe version) basis.

I guess one can write the skb descriptors first, then modify them from
the BPF. Either way I feel like the helper approach for Tx will result
in drivers saving the info into some local struct and then rendering
the descriptors after. We'll see.

