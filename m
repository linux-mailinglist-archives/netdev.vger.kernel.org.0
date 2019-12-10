Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A45118D25
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 17:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfLJQAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 11:00:08 -0500
Received: from mail1.windriver.com ([147.11.146.13]:60069 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbfLJQAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 11:00:07 -0500
X-Greylist: delayed 4166 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2019 11:00:02 EST
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail1.windriver.com (8.15.2/8.15.2) with ESMTPS id xBAEoGvA023784
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 10 Dec 2019 06:50:16 -0800 (PST)
Received: from [128.224.155.90] (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.468.0; Tue, 10 Dec
 2019 06:50:15 -0800
Subject: Re: [PATCH net/tipc] Replace rcu_swap_protected() with
 rcu_replace_pointer()
To:     <paulmck@kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <jon.maloy@ericsson.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <torvalds@linux-foundation.org>, <mingo@kernel.org>,
        <kernel-team@fb.com>
References: <20191210033146.GA32522@paulmck-ThinkPad-P72>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <0e565b68-ece1-5ae6-bb5d-710163fb8893@windriver.com>
Date:   Tue, 10 Dec 2019 22:36:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191210033146.GA32522@paulmck-ThinkPad-P72>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.155.90]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 11:31 AM, Paul E. McKenney wrote:
> This commit replaces the use of rcu_swap_protected() with the more
> intuitively appealing rcu_replace_pointer() as a step towards removing
> rcu_swap_protected().
> 
> Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Jon Maloy <jon.maloy@ericsson.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: <netdev@vger.kernel.org>
> Cc: <tipc-discussion@lists.sourceforge.net>
> 
> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
> index 990a872..64cf831 100644
> --- a/net/tipc/crypto.c
> +++ b/net/tipc/crypto.c
> @@ -258,7 +258,7 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
>  	rcu_dereference_protected((rcu_ptr), lockdep_is_held(lock))
>  
>  #define tipc_aead_rcu_swap(rcu_ptr, ptr, lock)				\
> -	rcu_swap_protected((rcu_ptr), (ptr), lockdep_is_held(lock))
> +	rcu_replace_pointer((rcu_ptr), (ptr), lockdep_is_held(lock))

(ptr) = rcu_replace_pointer((rcu_ptr), (ptr), lockdep_is_held(lock))

>  
>  #define tipc_aead_rcu_replace(rcu_ptr, ptr, lock)			\
>  do {									\
> @@ -1189,7 +1189,7 @@ static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending)
>  
>  	/* Move passive key if any */
>  	if (key.passive) {
> -		tipc_aead_rcu_swap(rx->aead[key.passive], tmp2, &rx->lock);
> +		tmp2 = rcu_replace_pointer(rx->aead[key.passive], tmp2, &rx->lock);

tipc_aead_rcu_swap() is only called here in TIPC module. If we use
rcu_replace_pointer() to switch pointers instead of calling
tipc_aead_rcu_swap() macro, I think we should completely remove
tipc_aead_rcu_swap().

>  		x = (key.passive - key.pending + new_pending) % KEY_MAX;
>  		new_passive = (x <= 0) ? x + KEY_MAX : x;
>  	}
> 
