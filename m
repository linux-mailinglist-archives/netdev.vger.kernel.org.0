Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87B511A0F6
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 03:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfLKCAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 21:00:46 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33349 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbfLKCAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 21:00:46 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 753A144473;
        Wed, 11 Dec 2019 13:00:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-language:x-mailer:content-transfer-encoding
        :content-type:content-type:mime-version:message-id:date:date
        :subject:subject:in-reply-to:references:from:from:received
        :received:received; s=mail_dkim; t=1576029642; bh=l2BCh4INk9Xjpe
        9P/beFH/83GOUPTtLsM+aYAl/XV6c=; b=nCYEQBF61ryWA+OV6FDSLHaFumv+df
        zbbjBAzawtlgOH2nvOCmwh+5Qm0UyIMZeYEg/jsCofyODFaPszM6F+DdjaYqPwjC
        MFI7L8Lcfs+OWjFex/2uLvsHEQY83EkQChNCiTyvVGGVho+XXrC+MIybahToejdD
        h1E35TKiFSMqk=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xnnyoYZzpIOv; Wed, 11 Dec 2019 13:00:42 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 400704BBFB;
        Wed, 11 Dec 2019 13:00:41 +1100 (AEDT)
Received: from VNLAP288VNPC (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 908CF44473;
        Wed, 11 Dec 2019 13:00:40 +1100 (AEDT)
From:   "Tuong Lien Tong" <tuong.t.lien@dektech.com.au>
To:     "'Ying Xue'" <ying.xue@windriver.com>, <paulmck@kernel.org>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mingo@kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <kernel-team@fb.com>, <torvalds@linux-foundation.org>,
        <davem@davemloft.net>
References: <20191210033146.GA32522@paulmck-ThinkPad-P72> <0e565b68-ece1-5ae6-bb5d-710163fb8893@windriver.com> <20191210223825.GS2889@paulmck-ThinkPad-P72> <54112a30-de24-f6b2-b02e-05bc7d567c57@windriver.com>
In-Reply-To: <54112a30-de24-f6b2-b02e-05bc7d567c57@windriver.com>
Subject: RE: [tipc-discussion] [PATCH net/tipc] Replace rcu_swap_protected() with rcu_replace_pointer()
Date:   Wed, 11 Dec 2019 09:00:39 +0700
Message-ID: <707801d5afc6$cac68190$605384b0$@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHn7R6lm2O6ODufE4ZTwpx6e2ZmvgEdJvCUAq0d++oCtrNyxadbqMjw
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ying, Paul,

Please see my comments inline. Thanks!

BR/Tuong

-----Original Message-----
From: Ying Xue <ying.xue@windriver.com> 
Sent: Wednesday, December 11, 2019 8:32 AM
To: paulmck@kernel.org
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; mingo@kernel.org;
tipc-discussion@lists.sourceforge.net; kernel-team@fb.com;
torvalds@linux-foundation.org; davem@davemloft.net
Subject: Re: [tipc-discussion] [PATCH net/tipc] Replace rcu_swap_protected()
with rcu_replace_pointer()

On 12/11/19 6:38 AM, Paul E. McKenney wrote:
> commit 4ee8e2c68b076867b7a5af82a38010fffcab611c
> Author: Paul E. McKenney <paulmck@kernel.org>
> Date:   Mon Dec 9 19:13:45 2019 -0800
> 
>     net/tipc: Replace rcu_swap_protected() with rcu_replace_pointer()
>     
>     This commit replaces the use of rcu_swap_protected() with the more
>     intuitively appealing rcu_replace_pointer() as a step towards removing
>     rcu_swap_protected().
>     
>     Link:
https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4g
g6Hw@mail.gmail.com/
>     Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>     Reported-by: kbuild test robot <lkp@intel.com>
>     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
>     Cc: Jon Maloy <jon.maloy@ericsson.com>
>     Cc: Ying Xue <ying.xue@windriver.com>
>     Cc: "David S. Miller" <davem@davemloft.net>
>     Cc: <netdev@vger.kernel.org>
>     Cc: <tipc-discussion@lists.sourceforge.net>
> 

Acked-by: Ying Xue <ying.xue@windriver.com>

> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
> index 990a872..978d2db 100644
> --- a/net/tipc/crypto.c
> +++ b/net/tipc/crypto.c
> @@ -257,9 +257,6 @@ static char *tipc_key_change_dump(struct tipc_key old,
struct tipc_key new,
>  #define tipc_aead_rcu_ptr(rcu_ptr, lock)				\
>  	rcu_dereference_protected((rcu_ptr), lockdep_is_held(lock))
>  
> -#define tipc_aead_rcu_swap(rcu_ptr, ptr, lock)
\
> -	rcu_swap_protected((rcu_ptr), (ptr), lockdep_is_held(lock))
> -
>  #define tipc_aead_rcu_replace(rcu_ptr, ptr, lock)			\
>  do {									\
>  	typeof(rcu_ptr) __tmp = rcu_dereference_protected((rcu_ptr),	\
> @@ -1189,7 +1186,7 @@ static bool tipc_crypto_key_try_align(struct
tipc_crypto *rx, u8 new_pending)
>  
>  	/* Move passive key if any */
>  	if (key.passive) {
> -		tipc_aead_rcu_swap(rx->aead[key.passive], tmp2, &rx->lock);
> +		tmp2 = rcu_replace_pointer(rx->aead[key.passive], tmp2,
&rx->lock);
The 3rd parameter should be the lockdep condition checking instead of the
spinlock's pointer i.e. "lockdep_is_held(&rx->lock)"?
That's why I'd prefer to use the 'tipc_aead_rcu_swap ()' macro, which is
clear & concise at least for the context here. It might be re-used later as
well...

>  		x = (key.passive - key.pending + new_pending) % KEY_MAX;
>  		new_passive = (x <= 0) ? x + KEY_MAX : x;
>  	}
> 


_______________________________________________
tipc-discussion mailing list
tipc-discussion@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/tipc-discussion

