Return-Path: <netdev+bounces-3486-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B891707880
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 05:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 054531C21009
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 03:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31D3396;
	Thu, 18 May 2023 03:36:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A79A394
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6132FC433EF;
	Thu, 18 May 2023 03:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684380985;
	bh=fl9U0jWpsUyQvCBn1HZs6Qzmv+deOFBPH194cQUWHYs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fluakXh28A4lNO9lAKxA9QqJ8FPS/VKELZk8jHmymxqP5IDseM6baiSXeqj/SBQBO
	 PcjQctqKh34NL576JUv8v288ygnw+UlwEWqOswfo9UUM6jA6KxwHDizt9lqQGtkij1
	 uyXcYTz++8DzLkTBL0tNtAmCjX2hyDc6DtBH/frhGGJ3yrN4s/vN3d/QIx7ivo3AoV
	 yw7+fOuXTOI5qtW1DKLIr6XeLEJbqZo1VNsSspZJeaVDbhycOuSnC8IBNnC62BNoCo
	 eHbm7wNEv3FhUh5btXJEmw8kIRHADdO/0cGC1AuZloRiIbAejHisTu2Ptgie7wal5h
	 YnStE3innKxCw==
Message-ID: <5e3b8377-3349-ab10-774d-4bc8725710ae@kernel.org>
Date: Wed, 17 May 2023 21:36:24 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [RFC PATCH net-next v2 1/2] net: Remove expired routes with
 separated timers.
Content-Language: en-US
To: Kui-Feng Lee <thinker.li@gmail.com>, netdev@vger.kernel.org,
 ast@kernel.org, martin.lau@linux.dev, kernel-team@meta.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc: Kui-Feng Lee <kuifeng@meta.com>
References: <20230517183337.190591-1-kuifeng@meta.com>
 <20230517183337.190591-2-kuifeng@meta.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230517183337.190591-2-kuifeng@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/23 12:33 PM, Kui-Feng Lee wrote:
> @@ -179,6 +181,7 @@ struct fib6_info {
>  
>  	refcount_t			fib6_ref;
>  	unsigned long			expires;
> +	struct fib6_info_timer		*timer;

if this solution moves forward as a separate timer per route with an
expiration, the timer related info can be added inline. Current
fib6_info with a single nexthop is 264B so it is already rounded up to
512B on the allocation.



