Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887041DC912
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 10:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgEUI4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 04:56:17 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:20856 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728389AbgEUI4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 04:56:17 -0400
Received: from [10.193.177.130] (shamnad.asicdesigners.com [10.193.177.130] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04L8u85l031946;
        Thu, 21 May 2020 01:56:10 -0700
Subject: Re: [PATCH net-next] net/tls: fix race condition causing kernel panic
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        secdev@chelsio.com
References: <20200519074327.32433-1-vinay.yadav@chelsio.com>
 <20200519.121641.1552016505379076766.davem@davemloft.net>
 <99faf485-2f28-0a45-7442-abaaee8744aa@chelsio.com>
 <20200520125844.20312413@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Message-ID: <0a5d0864-2830-6bc8-05e8-232d10c0f333@chelsio.com>
Date:   Thu, 21 May 2020 14:28:27 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520125844.20312413@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub

On 5/21/2020 1:28 AM, Jakub Kicinski wrote:
> On Wed, 20 May 2020 22:39:11 +0530 Vinay Kumar Yadav wrote:
>> On 5/20/2020 12:46 AM, David Miller wrote:
>>> From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
>>> Date: Tue, 19 May 2020 13:13:27 +0530
>>>   
>>>> +		spin_lock_bh(&ctx->encrypt_compl_lock);
>>>> +		pending = atomic_read(&ctx->encrypt_pending);
>>>> +		spin_unlock_bh(&ctx->encrypt_compl_lock);
>>> The sequence:
>>>
>>> 	lock();
>>> 	x = p->y;
>>> 	unlock();
>>>
>>> Does not fix anything, and is superfluous locking.
>>>
>>> The value of p->y can change right after the unlock() call, so you
>>> aren't protecting the atomic'ness of the read and test sequence
>>> because the test is outside of the lock.
>> Here, by using lock I want to achieve atomicity of following statements.
>>
>> pending = atomic_dec_return(&ctx->decrypt_pending);
>>         if (!pending && READ_ONCE(ctx->async_notify))
>>              complete(&ctx->async_wait.completion);
>>
>> means, don't want to read (atomic_read(&ctx->decrypt_pending))
>> in middle of two statements
>>
>> atomic_dec_return(&ctx->decrypt_pending);
>> and
>> complete(&ctx->async_wait.completion);
>>
>> Why am I protecting only read, not test ?
> Protecting code, not data, is rarely correct, though.
>
>> complete() is called only if pending == 0
>> if we read atomic_read(&ctx->decrypt_pending) = 0
>> that means complete() is already called and its okay to
>> initialize completion (reinit_completion(&ctx->async_wait.completion))
>>
>> if we read atomic_read(&ctx->decrypt_pending) as non zero that means:
>> 1- complete() is going to be called or
>> 2- complete() already called (if we read atomic_read(&ctx->decrypt_pending) == 1, then complete() is called just after unlock())
>> for both scenario its okay to go into wait (crypto_wait_req(-EINPROGRESS, &ctx->async_wait))
> First of all thanks for the fix, this completion code is unnecessarily
> complex and brittle if you ask me.
>
> That said I don't think your fix is 100%.
>
> Consider this scenario:
>
> # 1. writer queues first record on CPU0
> # 2. encrypt completes on CPU1
>
>   	pending = atomic_dec_return(&ctx->decrypt_pending);
> 	# pending is 0
>   
> # IRQ comes and CPU1 goes off to do something else with spin lock held
> # writer proceeds to encrypt next record on CPU0
> # writer is done, enters wait

Considering the lock in fix ("pending" is local variable), when writer reads
pending == 0 [pending = atomic_read(&ctx->encrypt_pending); --> from tls_sw_sendmsg()],
that means encrypt complete() [from tls_encrypt_done()] is already called.

and if pending == 1 [pending = atomic_read(&ctx->encrypt_pending); --> from tls_sw_sendmsg()],
that means writer is going to wait for atomic_dec_return(&ctx->decrypt_pending) and
complete() [from tls_encrypt_done()]  to be called atomically.

This way, writer is not going to proceed to encrypt next record on CPU0 without complete().

>
> 	smp_store_mb(ctx->async_notify, true);
>
> # Now CPU1 is back from the interrupt, does the check
>
>   	if (!pending && READ_ONCE(ctx->async_notify))
>   		complete(&ctx->async_wait.completion);
>
> # and it completes the wait, even though the atomic decrypt_pending was
> #   bumped back to 1
>
> You need to hold the lock around the async_notify false -> true
> transition as well. The store no longer needs to have a barrier.
>
> For async_notify true -> false transitions please add a comment
> saying that there can be no concurrent accesses, since we have no
> pending crypt operations.
>
>
> Another way to solve this would be to add a large value to the pending
> counter to indicate that there is a waiter:
>
> 	if (atomic_add_and_fetch(&decrypt_pending, 1000) > 1000)
> 		wait();
> 	else
> 		reinit();
> 	atomic_sub(decrypt_pending, 1000)
>
> completion:
>
> 	if (atomic_dec_return(&decrypt_pending) == 1000)
> 		complete()

Considering suggested solutions if this patch doesn't solve the problem.

