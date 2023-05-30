Return-Path: <netdev+bounces-6592-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D805B7170CB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B35B1C20D8F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F6ACBA31;
	Tue, 30 May 2023 22:36:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D637F2C80
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276F3C4339B;
	Tue, 30 May 2023 22:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685486204;
	bh=+F9ZahY9MwhnqLm1M88KU4bkqwdElaQgoKYSszuvPcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kHN3+CVqlZ5qQ0kVEg5rMBJ3ApM5DQJW8EPfeJxvyidI6KFG8eM2SbED07WeN1N8O
	 nVmPGjp3RS+9xLoKTpX/j+vZNvSAlShVEryHoTUAmD9S74kjfb9b6qyMe6aP1aYZPK
	 XZVHzFa9GZ2G6gHgDRCf9In1ApoHUquLh604HPZbtta3rEZJcPWwl5d1ExVUylMY6R
	 y/CurC3o54Jo4nikhl1AgqE3h7aD/dAXW+lH1RIqWPqMK2z3yr32VuAn1b0ehVl6c4
	 1l4AiHpY4lcOwHbK2Mqz3IwFT/hWqutjBvIHG9yzWTXri4m9QG9aY5C4faP+DoG438
	 gXGZgAaTmBchQ==
Message-ID: <cabcc033-89d2-de7b-d510-14f875942109@kernel.org>
Date: Tue, 30 May 2023 16:36:42 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] net: Make gro complete function to return void
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, Parav Pandit <parav@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
 pabeni@redhat.com, netdev@vger.kernel.org
References: <20230529134430.492879-1-parav@nvidia.com>
 <b4940bfa-aab6-644a-77d3-20bf9a876a6a@kernel.org>
 <CANn89iLxUk6KpQ1a=Q+pNb95nkS6fYbHsuBGdxyTX23fuTGo6g@mail.gmail.com>
 <20230530123929.42472e9f@kernel.org>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230530123929.42472e9f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/23 1:39 PM, Jakub Kicinski wrote:
> On Tue, 30 May 2023 17:48:22 +0200 Eric Dumazet wrote:
>>> tcp_gro_complete seems fairly trivial. Any reason not to make it an
>>> inline and avoid another function call in the datapath?  
>>
>> Probably, although it is a regular function call, not an indirect one.
>>
>> In the grand total of driver rx napi + GRO cost, saving a few cycles
>> per GRO completed packet is quite small.
> 
> IOW please make sure you include the performance analysis quantifying
> the win, if you want to make this a static inline. Or let us know if
> the patch is good as is, I'm keeping it in pw for now.

I am not suggesting holding up this patch; just constantly looking for
these little savings here and there to keep lowering the overhead.

100G, 1500 MTU, line rate is 8.3M pps so GRO wise that would be ~180k
fewer function calls.

