Return-Path: <netdev+bounces-588-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 671FE6F857F
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8610C1C218D7
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2738C2D1;
	Fri,  5 May 2023 15:22:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76869BE7A
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 15:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CC3C433EF;
	Fri,  5 May 2023 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683300136;
	bh=PRjlYTE9vkTWmbfmsZZFn/vTUGFrafsbqg2Ejniz4rc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I4BqPWv2WW3BQbnzI+xJTZdMLCIHzyoqsyi4/3gT/tXMHVmvjWsPEUyZcsZx8UXoW
	 hQ8Qm4YM/OFLbaRBrFZcs1ClHNaXpmmyklxKeWQaAvexVY/bWlEivy36fU8f8S0F0G
	 uW/zHc13pnGVICSM7hnHEb3dh4i5hfMjo+7meeeIDuopfBqetRNvBwk9AQ0l7V8pmI
	 cGidm3G62Tp9S7yjDYOZBFwByOtgOFr+D7vRoSJjFgTuRRNdDxyTXDHAGWZ756+t3b
	 /QwmErH/iGQC0nceeQk18V0Ad2x0jCUmAWqrtMwos/P9y+1oYFYRgb2nXE6LuHEj+P
	 sfIrbAi/mafaA==
Message-ID: <58351b57-23a1-44ae-cb27-76eef35de419@kernel.org>
Date: Fri, 5 May 2023 09:22:14 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [BUG] Dependence of routing cache entries on the ignore-df flag
Content-Language: en-US
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Aleksey Shumnik <ashumnik9@gmail.com>, netdev@vger.kernel.org,
 waltje@uwalt.nl.mugnet.org, Jakub Kicinski <kuba@kernel.org>,
 gw4pts@gw4pts.ampr.org, kuznet@ms2.inr.ac.ru,
 "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
 gnault@redhat.com
References: <CAJGXZLjLXrUzz4S9C7SqeyszMMyjR6RRu52y1fyh_d6gRqFHdA@mail.gmail.com>
 <20230503113528.315485f1@hermes.local> <20230505031043.GA4009@u2004-local>
 <20230505080014.67bdd6cb@hermes.local>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230505080014.67bdd6cb@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/5/23 9:00 AM, Stephen Hemminger wrote:
> On Thu, 4 May 2023 21:10:43 -0600
> David Ahern <dsahern@kernel.org> wrote:
> 
>> On Wed, May 03, 2023 at 11:35:28AM -0700, Stephen Hemminger wrote:
>>> On Wed, 3 May 2023 18:01:03 +0300
>>> Aleksey Shumnik <ashumnik9@gmail.com> wrote:
>>>   
>>>> Might you answer the questions:
>>>> 1. How the ignore-df flag and adding entries to the routing cache is
>>>> connected? In which kernel files may I look to find this connection?
>>>> 2. Is this behavior wrong?
>>>> 3. Is there any way to completely disable the use of the routing
>>>> cache? (as far as I understand, it used to be possible to set the
>>>> rhash_entries parameter to 0, but now there is no such parameter)
>>>> 4. Why is an entry added to the routing cache if a suitable entry was
>>>> eventually found in the arp table (it is added directly, without being
>>>> temporarily added to the routing table)?  
>>>
>>> What kernel version. The route cache has been completely removed from
>>> the kernel for a long time.  
>>
>> These are exceptions (fib_nh_exception), not the legacy routing cache.
> 
> I tried to reproduce your example, and did not see anything.
> Could it be the multicast routing daemon (pimd) is watching and adding
> the entry?

That looks like a pmtu based entry - added by the kernel processing an ICMP.

