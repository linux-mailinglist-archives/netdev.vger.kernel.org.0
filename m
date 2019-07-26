Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEF8576B6D
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 16:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfGZOVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 10:21:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:46178 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfGZOVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 10:21:34 -0400
Received: from ALA-HCA.corp.ad.wrs.com ([147.11.189.40])
        by mail.windriver.com (8.15.2/8.15.1) with ESMTPS id x6QELHDd021105
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Fri, 26 Jul 2019 07:21:17 -0700 (PDT)
Received: from [128.224.155.90] (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.468.0; Fri, 26 Jul
 2019 07:21:16 -0700
Subject: Re: [PATCH] net: tipc: Fix a possible null-pointer dereference in
 tipc_publ_purge()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, <jon.maloy@ericsson.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
References: <20190725092021.15855-1-baijiaju1990@gmail.com>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <31091d78-8c10-f07d-b738-4c082d33f1c9@windriver.com>
Date:   Fri, 26 Jul 2019 22:10:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190725092021.15855-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.155.90]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/19 5:20 PM, Jia-Ju Bai wrote:
> In tipc_publ_purge(), there is an if statement on 215 to 
> check whether p is NULL: 
>     if (p)
> 
> When p is NULL, it is used on line 226:
>     kfree_rcu(p, rcu);
> 
> Thus, a possible null-pointer dereference may occur.
> 
> To fix this bug, p is checked before being used.
> 
> This bug is found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  net/tipc/name_distr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
> index 44abc8e9c990..241ed2274473 100644
> --- a/net/tipc/name_distr.c
> +++ b/net/tipc/name_distr.c
> @@ -223,7 +223,8 @@ static void tipc_publ_purge(struct net *net, struct publication *publ, u32 addr)
>  		       publ->key);
>  	}
>  
> -	kfree_rcu(p, rcu);
> +	if (p)

No, I don't think so because kfree_rcu() will internally check if "p"
pointer is NULL or not.

> +		kfree_rcu(p, rcu);
>  }
>  
>  /**
> 
