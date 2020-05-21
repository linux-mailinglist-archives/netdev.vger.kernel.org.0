Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE601DD847
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgEUUaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:30:00 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:56598 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728522AbgEUU37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 16:29:59 -0400
Received: from [10.193.177.185] (chethan-pc.asicdesigners.com [10.193.177.185] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04LKTqvC002625;
        Thu, 21 May 2020 13:29:53 -0700
Subject: Re: [PATCH net-next] net/tls: fix race condition causing kernel panic
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        secdev@chelsio.com
References: <20200519074327.32433-1-vinay.yadav@chelsio.com>
 <20200519.121641.1552016505379076766.davem@davemloft.net>
 <99faf485-2f28-0a45-7442-abaaee8744aa@chelsio.com>
 <20200520125844.20312413@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0a5d0864-2830-6bc8-05e8-232d10c0f333@chelsio.com>
 <20200521115623.134eeb83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Message-ID: <c7a03544-89ec-696c-fa71-4a46e99d1e66@chelsio.com>
Date:   Fri, 22 May 2020 02:02:10 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521115623.134eeb83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub

On 5/22/2020 12:26 AM, Jakub Kicinski wrote:
> On Thu, 21 May 2020 14:28:27 +0530 Vinay Kumar Yadav wrote:
>> Considering the lock in fix ("pending" is local variable), when writer reads
>> pending == 0 [pending = atomic_read(&ctx->encrypt_pending); --> from tls_sw_sendmsg()],
>> that means encrypt complete() [from tls_encrypt_done()] is already called.
> Please indulge me with full sentences. I can't parse this.

Here, I am explaining that your scenario is covered in this fix.

# writer code. spin_lock_bh(&ctx->encrypt_compl_lock);
pending = atomic_read(&ctx->encrypt_pending);
spin_unlock_bh(&ctx->encrypt_compl_lock);
if (pending)
  			crypto_wait_req(-EINPROGRESS, &ctx->async_wait);

# Completion code.

spin_lock_bh(&ctx->encrypt_compl_lock);
  	pending = atomic_dec_return(&ctx->encrypt_pending);
  
  	if (!pending && READ_ONCE(ctx->async_notify))
  		complete(&ctx->async_wait.completion);
spin_unlock_bh(&ctx->encrypt_compl_lock); # "pending" is local variable.
  
Your scenario:

     # 1. writer queues first record on CPU0
     # 2. encrypt completes on CPU1

  	    pending = atomic_dec_return(&ctx->decrypt_pending);
	    # pending is 0
  
     # IRQ comes and CPU1 goes off to do something else with spin lock held
     # writer proceeds to encrypt next record on CPU0
     # writer is done, enters wait

	    smp_store_mb(ctx->async_notify, true);

     # Now CPU1 is back from the interrupt, does the check

  	    if (!pending && READ_ONCE(ctx->async_notify))
  		   complete(&ctx->async_wait.completion);

     # and it completes the wait, even though the atomic decrypt_pending was
     #   bumped back to 1

Explanation:

When writer reads pending == 0,
that means completion is already called complete().
its okay writer to  initialize completion. When writer reads pending == 1,
that means writer is going to wait for completion.

This way, writer is not going to proceed to encrypt next record on CPU0 without complete().

>
>> and if pending == 1 [pending = atomic_read(&ctx->encrypt_pending); --> from tls_sw_sendmsg()],
>> that means writer is going to wait for atomic_dec_return(&ctx->decrypt_pending) and
>> complete() [from tls_encrypt_done()]  to be called atomically.
>>
>> This way, writer is not going to proceed to encrypt next record on CPU0 without complete().
