Return-Path: <netdev+bounces-3675-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31DE97084D6
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A30A11C210B5
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C0821076;
	Thu, 18 May 2023 15:28:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A49453A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129CCC4339B;
	Thu, 18 May 2023 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684423719;
	bh=LWEzvh6lao/xrE+RCbDtCOj3/1hlWwmMTZLkoUbLONk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NMtRVGyewZAhtzyC/SKMa18Fj2Jff9gxcwRrNxJASXeEnXYiJtCJQHNdINtz/Y9/I
	 EgON/kW4cMn/KJZNQAfTODEqnIstVUdGK5yvcgZzY84+3jAfXMDnM/uiiduR/NeISO
	 64iwHltDCm0vdLPoZqHy66RNNYdtC1HIlltLecUwDCNTWIriYANDtoehv0JpQdpZeC
	 C0aKx2LCi849vA9A4oSUN7ft2U8RDJJkbJK0LPjqemjJgHXfNBJtylpDyisiDtIk/C
	 ZRDFMxsFNTmdqQW1AIW0JAMvmEnFnBm1BsxuFBgQ1rMpbOuK3pG4VrTohtrNUZKxs9
	 rMsafXYXAXm3g==
Message-ID: <15c7358b-ab69-38af-60fc-d6c8778f25e8@kernel.org>
Date: Thu, 18 May 2023 09:28:38 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [RFC PATCH net-next v2 0/2] Mitigate the Issue of Expired Routes
 in Linux IPv6 Routing Tables
Content-Language: en-US
To: Kui-Feng Lee <sinquersw@gmail.com>, Kui-Feng Lee <thinker.li@gmail.com>,
 netdev@vger.kernel.org, ast@kernel.org, martin.lau@linux.dev,
 kernel-team@meta.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com
Cc: Kui-Feng Lee <kuifeng@meta.com>, Ido Schimmel <idosch@idosch.org>
References: <20230517183337.190591-1-kuifeng@meta.com>
 <61248e45-c619-d5f2-95a0-5971593fbe8d@kernel.org>
 <337e31f2-9619-0db5-2782-dea1b0443d97@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <337e31f2-9619-0db5-2782-dea1b0443d97@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/17/23 11:40 PM, Kui-Feng Lee wrote:
> 
> 
> On 5/17/23 20:21, David Ahern wrote:
>> On 5/17/23 12:33 PM, Kui-Feng Lee wrote:
>>> This RFC is resent to ensure maintainers getting awared.  Also remove
>>> some forward declarations that we don't use anymore.
>>>
>>> The size of a Linux IPv6 routing table can become a big problem if not
>>> managed appropriately.  Now, Linux has a garbage collector to remove
>>> expired routes periodically.  However, this may lead to a situation in
>>> which the routing path is blocked for a long period due to an
>>> excessive number of routes.
>>
>> I take it this problem was seen internally to your org? Can you give
>> representative numbers on how many routes, stats on the blocked time,
>> and reason for the large time block (I am guessing the notifier)?
> 
> We don't have existing incidents so far.  Consider it as
> a potential issue.

So no data to compare how the system was operating before and after.

...

> 
> In contrast, the current GC has to walk every tree even only one route
> expired.  

As I recall the largest overhead is systems (e.g., switchdev) handling
the notifier. The tree walk scaling problem can be addressed with a much
simpler change -- e.g., add a list_head per fib6_table for fib6_info
entries that can expire and make the list time sorted. Then the gc only
needs to walk those lists up to the expired point.

