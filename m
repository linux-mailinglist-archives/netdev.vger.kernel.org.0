Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6868815D383
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 09:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgBNIKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 03:10:22 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:7483 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgBNIKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 03:10:22 -0500
Received: from [10.193.191.83] (vinay-kumar.asicdesigners.com [10.193.191.83])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01E8A37G002040;
        Fri, 14 Feb 2020 00:10:04 -0800
Subject: Re: [PATCH] crypto: chelsio - remove extra allocation for chtls_dev
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephen Kitt <steve@sk2.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Atul Gupta <atul.gupta@chelsio.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200124222051.1925415-1-steve@sk2.org>
 <20200213054751.4okuxe3hr2i4dxzs@gondor.apana.org.au>
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Message-ID: <23d0939e-0a7b-f822-ae64-0cb64f6aefc2@chelsio.com>
Date:   Fri, 14 Feb 2020 13:40:02 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200213054751.4okuxe3hr2i4dxzs@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert,

On 2/13/2020 11:17 AM, Herbert Xu wrote:
> On Fri, Jan 24, 2020 at 11:20:51PM +0100, Stephen Kitt wrote:
>> chtls_uld_add allocates room for info->nports net_device structs
>> following the chtls_dev struct, presumably because it was originally
>> intended that the ports array would be stored there. This is suggested
>> by the assignment which was present in initial versions and removed by
>> c4e848586cf1 ("crypto: chelsio - remove redundant assignment to
>> cdev->ports"):
>>
>> 	cdev->ports = (struct net_device **)(cdev + 1);
>>
>> This assignment was never used, being overwritten by lldi->ports
>> immediately afterwards, and I couldn't find any uses of the memory
>> allocated past the end of the struct.
>>
>> Signed-off-by: Stephen Kitt <steve@sk2.org>
> Thanks for the patch!
>
> I think the problem goes deeper though.  It appears that instead
> of allocating a ports array this function actually hangs onto the
> array from the function argument "info".  This seems to be broken
> and possibly the extra memory allocated was meant to accomodate
> the ports array.  Indeed, the code removed by the commit that you
> mentioned indicates this as well (although the memory was never
> actually used).

Yes, memory was never used. Author allocated port array but later 
realized that he can use port array allocated by lld(cxgb4) and missed 
to remove memory allocation at commit mentioned in patch. I think this 
patch will correct memory allocation.

>
> Dave, I think we should talk about the maintainence of the chelsio
> net/crypto drivers.  They have quite a bit of overlap and there is
> simply not enough people on the crypto side to review these drivers
> properly.  Would it be possible for all future changes to these
> drivers to go through the net tree?
>   
> Cheers,
