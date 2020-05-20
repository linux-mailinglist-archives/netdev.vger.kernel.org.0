Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD321DBAB1
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgETRHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:07:21 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:57916 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETRHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:07:21 -0400
Received: from [10.193.177.175] (chethan-pc.asicdesigners.com [10.193.177.175] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04KH6t4M029220;
        Wed, 20 May 2020 10:06:57 -0700
Subject: Re: [PATCH net-next] net/tls: fix race condition causing kernel panic
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, secdev@chelsio.com
References: <20200519074327.32433-1-vinay.yadav@chelsio.com>
 <20200519.121641.1552016505379076766.davem@davemloft.net>
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Message-ID: <99faf485-2f28-0a45-7442-abaaee8744aa@chelsio.com>
Date:   Wed, 20 May 2020 22:39:11 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519.121641.1552016505379076766.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David

On 5/20/2020 12:46 AM, David Miller wrote:
> From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> Date: Tue, 19 May 2020 13:13:27 +0530
>
>> +		spin_lock_bh(&ctx->encrypt_compl_lock);
>> +		pending = atomic_read(&ctx->encrypt_pending);
>> +		spin_unlock_bh(&ctx->encrypt_compl_lock);
> The sequence:
>
> 	lock();
> 	x = p->y;
> 	unlock();
>
> Does not fix anything, and is superfluous locking.
>
> The value of p->y can change right after the unlock() call, so you
> aren't protecting the atomic'ness of the read and test sequence
> because the test is outside of the lock.

Here, by using lock I want to achieve atomicity of following statements.

pending = atomic_dec_return(&ctx->decrypt_pending);
       if (!pending && READ_ONCE(ctx->async_notify))
            complete(&ctx->async_wait.completion);

means, don't want to read (atomic_read(&ctx->decrypt_pending))
in middle of two statements

atomic_dec_return(&ctx->decrypt_pending);
and
complete(&ctx->async_wait.completion);

Why am I protecting only read, not test ?

complete() is called only if pending == 0
if we read atomic_read(&ctx->decrypt_pending) = 0
that means complete() is already called and its okay to
initialize completion (reinit_completion(&ctx->async_wait.completion))

if we read atomic_read(&ctx->decrypt_pending) as non zero that means:
1- complete() is going to be called or
2- complete() already called (if we read atomic_read(&ctx->decrypt_pending) == 1, then complete() is called just after unlock())
for both scenario its okay to go into wait (crypto_wait_req(-EINPROGRESS, &ctx->async_wait))


Thanks,
Vinay
