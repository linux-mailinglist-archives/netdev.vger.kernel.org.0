Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F49C18F010
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 08:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgCWHEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 03:04:10 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45822 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727164AbgCWHEK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 03:04:10 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 49B5B59097D5E94A2342;
        Mon, 23 Mar 2020 15:04:04 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.234) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Mon, 23 Mar 2020
 15:04:02 +0800
Subject: Re: [PATCH v2] xfrm: policy: Fix doulbe free in xfrm_policy_timer
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <20200318034839.57996-1-yuehaibing@huawei.com>
 <20200323014155.56376-1-yuehaibing@huawei.com>
 <20200323062914.GA5811@gondor.apana.org.au>
CC:     <steffen.klassert@secunet.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <timo.teras@iki.fi>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <52f2d9b2-e66a-f2aa-52fb-d0a3ca748a73@huawei.com>
Date:   Mon, 23 Mar 2020 15:04:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20200323062914.GA5811@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/3/23 14:29, Herbert Xu wrote:
> On Mon, Mar 23, 2020 at 09:41:55AM +0800, YueHaibing wrote:
>>
>> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
>> index dbda08ec566e..ae0689174bbf 100644
>> --- a/net/xfrm/xfrm_policy.c
>> +++ b/net/xfrm/xfrm_policy.c
>> @@ -434,6 +434,7 @@ EXPORT_SYMBOL(xfrm_policy_destroy);
>>  
>>  static void xfrm_policy_kill(struct xfrm_policy *policy)
>>  {
>> +	write_lock_bh(&policy->lock);
>>  	policy->walk.dead = 1;
>>  
>>  	atomic_inc(&policy->genid);
>> @@ -445,6 +446,7 @@ static void xfrm_policy_kill(struct xfrm_policy *policy)
>>  	if (del_timer(&policy->timer))
>>  		xfrm_pol_put(policy);
>>  
>> +	write_unlock_bh(&policy->lock);
> 
> Why did you expand the critical section? Can't you just undo the
> patch in xfrm_policy_kill?

Indeed, the critical section should not be expanded, thanks!

> 
> Cheers,
> 

