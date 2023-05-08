Return-Path: <netdev+bounces-811-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D856F9FE6
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1511C1C20953
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C681F33E3;
	Mon,  8 May 2023 06:29:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9D87E
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:29:30 +0000 (UTC)
Received: from mail-m127104.qiye.163.com (mail-m127104.qiye.163.com [115.236.127.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D1D150C0;
	Sun,  7 May 2023 23:29:14 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
	by mail-m127104.qiye.163.com (Hmail) with ESMTPA id 37CF1A403BC;
	Mon,  8 May 2023 14:29:00 +0800 (CST)
Message-ID: <04e00a96-5923-cd8f-78ab-752a6b34f8af@sangfor.com.cn>
Date: Mon, 8 May 2023 14:28:55 +0800
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
 <pabeni@redhat.com>, Bruce Fields <bfields@redhat.com>,
 Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230507091131.23540-1-dinghui@sangfor.com.cn>
 <EED05302-8BC6-4593-B798-BFC476FA190E@oracle.com>
 <19f9a9bb-7164-dca0-1aff-da4a46b0ee74@sangfor.com.cn>
 <47C36B96-581F-4D51-8247-3ED9F1B4B948@oracle.com>
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <47C36B96-581F-4D51-8247-3ED9F1B4B948@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTEhPVkpKSENKTBpIT0JMH1UTARMWGhIXJBQOD1
	lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a87fa0ca994b282kuuu37cf1a403bc
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBw6HQw5SD0XSjcpLy4XLEg6
	DD4wCTVVSlVKTUNITklMSE9MT0xJVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFPT05CNwY+
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/8 12:00, Chuck Lever III wrote:
> 
> 
>> On May 7, 2023, at 6:32 PM, Ding Hui <dinghui@sangfor.com.cn> wrote:
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
> 
> Would a smartly-placed svc_xprt_get() hold the listener in place
> until accept processing completes?
> 

It is difficult and complicated to me. I think it's a little bit out of
SUNRPC's control for the newsocks before accepted, e.g.: we don't know
how many they have.

Back to this RFC, I checked the code and thought it is safe by skipping
sk_odata() for the newsocks before accepted in **svc_tcp_listen_data_ready()**,
since these newsocks's sk_wq must be NULL, and will be assigned new one in
sock_alloc_inode() called by kernel_accept(), so we can say if the child sock
is not be accepted, there is nothing to be waked up.

> 
>>>> Reproduce by two tasks:
>>>> ...

-- 
Thanks,
- Ding Hui


