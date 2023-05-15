Return-Path: <netdev+bounces-2458-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E0B70210B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 03:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31C2428107D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 01:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47AE310F6;
	Mon, 15 May 2023 01:18:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF6510EA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 01:18:16 +0000 (UTC)
Received: from mail-m127104.qiye.163.com (mail-m127104.qiye.163.com [115.236.127.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7292E13D;
	Sun, 14 May 2023 18:18:12 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
	by mail-m127104.qiye.163.com (Hmail) with ESMTPA id 8453BA401A1;
	Mon, 15 May 2023 09:18:01 +0800 (CST)
Message-ID: <2e8da045-354f-43a1-72b9-9644d1e2f280@sangfor.com.cn>
Date: Mon, 15 May 2023 09:17:56 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [RFC PATCH] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
Content-Language: en-US
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: "jlayton@kernel.org" <jlayton@kernel.org>,
 "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
 "anna@kernel.org" <anna@kernel.org>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "edumazet@google.com" <edumazet@google.com>,
 "kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com"
 <pabeni@redhat.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230507091131.23540-1-dinghui@sangfor.com.cn>
 <EED05302-8BC6-4593-B798-BFC476FA190E@oracle.com>
 <19f9a9bb-7164-dca0-1aff-da4a46b0ee74@sangfor.com.cn>
 <53664FF4-A917-46FE-AEA7-45F31CE1CD88@oracle.com>
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <53664FF4-A917-46FE-AEA7-45F31CE1CD88@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTBhPVh9MTExMHR1ISEtPTFUTARMWGhIXJBQOD1
	lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a881cfc71feb282kuuu8453ba401a1
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MCo6Hxw6OD0WPxkWShIOKC0M
	MR0wCQxVSlVKTUNPSkpIT0NMSUhIVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFOTUtLNwY+
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/15 2:29, Chuck Lever III wrote:
> [ Removing the stale address for Bruce from the Cc, as he no longer
>    works at Red Hat. ]
> 
> 
>> On May 7, 2023, at 9:32 PM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>>
>> On 2023/5/7 23:26, Chuck Lever III wrote:
>>>> On May 7, 2023, at 5:11 AM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>>>>
>>>> After the listener svc_sock freed, and before invoking svc_tcp_accept()
>>>> for the established child sock, there is a window that the newsock
>>>> retaining a freed listener svc_sock in sk_user_data which cloning from
>>>> parent. In the race windows if data is received on the newsock, we will
>>>> observe use-after-free report in svc_tcp_listen_data_ready().
>>> My thought is that not calling sk_odata() for the newsock
>>> could potentially result in missing a data_ready event,
>>> resulting in a hung client on that socket.
>>
>> I checked the vmcore, found that sk_odata points to sock_def_readable(),
>> and the sk_wq of newsock is NULL, which be assigned by sk_clone_lock()
>> unconditionally.
>>
>> Calling sk_odata() for the newsock maybe do not wake up any sleepers.
>>
>>> IMO the preferred approach is to ensure that svsk is always
>>> safe to dereference in tcp_listen_data_ready. I haven't yet
>>> thought carefully about how to do that.
>>
>> Agree, but I don't have a good way for now.
>>
>>>> Reproduce by two tasks:
>>>>
>>>> 1. while :; do rpc.nfsd 0 ; rpc.nfsd; done
>>>> 2. while :; do echo "" | ncat -4 127.0.0.1 2049 ; done
> 
> I haven't been able to reproduce a crash with this snippet. But

KASAN report should be easier to reproduce than real crash.

> I've done some archaeology to understand the problem better.
> 
> I found that svc_tcp_listen_data_ready is actually invoked /three/
> times: once for the listener socket, and /twice/ for the child.
> The big comment, which pre-dates the git era, appears to be
> somewhat stale; or perhaps it's the specifics of this particular
> test that triggers the third call.
> 
> I reviewed several other tcp_listen_data_ready callbacks. They
> generally do not do anything at all with non-listener sockets,
> suggesting that approach would likely be safe for NFSD.
> 
> Prior to commit 939bb7ef901b ("[PATCH] Code cleanups in calbacks
> in svcsock"), this data_ready callback was a complete no-op for
> non-listener sockets as well. That commit is described as only
> a clean-up, but it indeed changes the logic.
> 
> I also note that most other data_ready callbacks take the
> sk_callback_lock, and svc_tcp_listen_data_ready does not. Not
> clear to me whether svc_tcp_listen_data_ready should be taking
> that lock too.
> 

I notice the lock too, IMO the sk_callback_lock should be used
to protect the svsk avoiding be freed during in the callbacks.

Perhaps it can be reproduced by increasing the processing time in
svc_tcp_listen_data_ready(), but anyway, it would be another issue.

> The upshot is that I think it would be reasonable to simply do
> nothing in svc_tcp_listen_data_ready() if state != TCP_LISTEN.
> 

Thanks for the information.

I will send the formal patch soon later.

-- 
Thanks,
- Ding Hui


