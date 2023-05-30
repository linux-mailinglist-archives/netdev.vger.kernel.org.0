Return-Path: <netdev+bounces-6480-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D90967167E6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:51:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79D901C20C36
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56496271FB;
	Tue, 30 May 2023 15:51:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137F717AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861FFC433EF;
	Tue, 30 May 2023 15:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685461893;
	bh=IAf+rEpXOaeXEGH00mRkOM64mmES44Ei1iOcq8JfugQ=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=ZDTlGpG+2Dd4qeK3WPI9PdjGjRwNT+GF/LA7YrHHoz8PLv4ji3kd3VZ1CsCwpLr9A
	 BkaTNqvyz6qvpsgIx5qJVD88jjaJxuj6+FqYGJqaNWhg0BiszOUeHW2jMgF3jzl954
	 KNa9maY3TPjQqPC0F8DGmA68x777Hz0k1whefg83DFDjedxQ0bGkuZ2UVjtDXVC9WX
	 xnfIXbTnYJ+WOfR9cuznTrXLKzWj8ZC6St21VsIXmMVs3glb++Dl3zimDXkaoMKVoR
	 SjyqdkrfcVJ8tIK1zERm4otNZc8eOo63sK6kOI3kmKxRrrbYMyR801b9y26Kv+kK+E
	 18lJt/gGF4ZCA==
Message-ID: <76ce09d8-13d9-c49c-49b4-e2adf71dbacb@kernel.org>
Date: Tue, 30 May 2023 09:51:32 -0600
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
To: Parav Pandit <parav@nvidia.com>, "edumazet@google.com"
 <edumazet@google.com>, "davem@davemloft.net" <davem@davemloft.net>,
 "kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com"
 <pabeni@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230529134430.492879-1-parav@nvidia.com>
 <b4940bfa-aab6-644a-77d3-20bf9a876a6a@kernel.org>
 <PH0PR12MB5481B447D6D667ECB97886CEDC4B9@PH0PR12MB5481.namprd12.prod.outlook.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <PH0PR12MB5481B447D6D667ECB97886CEDC4B9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/23 9:39 AM, Parav Pandit wrote:
>> From: David Ahern <dsahern@kernel.org>
>> Sent: Tuesday, May 30, 2023 11:26 AM
>>
>> On 5/29/23 7:44 AM, Parav Pandit wrote:
>>> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c index
>>> 45dda7889387..88f9b0081ee7 100644
>>> --- a/net/ipv4/tcp_offload.c
>>> +++ b/net/ipv4/tcp_offload.c
>>> @@ -296,7 +296,7 @@ struct sk_buff *tcp_gro_receive(struct list_head
>> *head, struct sk_buff *skb)
>>>  	return pp;
>>>  }
>>>
>>> -int tcp_gro_complete(struct sk_buff *skb)
>>> +void tcp_gro_complete(struct sk_buff *skb)
>>>  {
>>>  	struct tcphdr *th = tcp_hdr(skb);
>>>
>>> @@ -311,8 +311,6 @@ int tcp_gro_complete(struct sk_buff *skb)
>>>
>>>  	if (skb->encapsulation)
>>>  		skb->inner_transport_header = skb->transport_header;
>>> -
>>> -	return 0;
>>>  }
>>>  EXPORT_SYMBOL(tcp_gro_complete);
>>
>> tcp_gro_complete seems fairly trivial. Any reason not to make it an inline and
>> avoid another function call in the datapath?
>>
> Sounds good to me.
> With inline it should mostly improve the perf, but I do not have any of the 3 adapters which are calling this API to show perf results.
> 
> Since, it is a different change touching the performance, I prefer to do follow up patch that bnx owners can test.
> Is that ok?

sure.

