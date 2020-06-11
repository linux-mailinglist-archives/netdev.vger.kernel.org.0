Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2021F6174
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 08:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgFKGGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 02:06:37 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:52863 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgFKGGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 02:06:37 -0400
Received: from [10.193.177.148] (sreekanth.asicdesigners.com [10.193.177.148] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05B66C5a015891;
        Wed, 10 Jun 2020 23:06:16 -0700
Cc:     ayush.sawal@asicdesigners.com, davem@davemloft.net,
        netdev@vger.kernel.org, manojmalviya@chelsio.com
Subject: Re: [PATCH net-next 2/2] Crypto/chcr: Checking cra_refcnt before
 unregistering the algorithms
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <20200609212432.2467-1-ayush.sawal@chelsio.com>
 <20200609212432.2467-3-ayush.sawal@chelsio.com>
 <20200611034812.GA27335@gondor.apana.org.au>
From:   Ayush Sawal <ayush.sawal@chelsio.com>
Message-ID: <41e4ea2f-c586-55cb-db2f-5b542133a6d1@chelsio.com>
Date:   Thu, 11 Jun 2020 11:38:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200611034812.GA27335@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert,

On 6/11/2020 9:18 AM, Herbert Xu wrote:
> On Wed, Jun 10, 2020 at 02:54:32AM +0530, Ayush Sawal wrote:
>> This patch puts a check for algorithm unregister, to avoid removal of
>> driver if the algorithm is under use.
>>
>> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
>> ---
>>   drivers/crypto/chelsio/chcr_algo.c | 18 ++++++++++++++----
>>   1 file changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
>> index f8b55137cf7d..4c2553672b6f 100644
>> --- a/drivers/crypto/chelsio/chcr_algo.c
>> +++ b/drivers/crypto/chelsio/chcr_algo.c
>> @@ -4391,22 +4391,32 @@ static int chcr_unregister_alg(void)
>>   	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
>>   		switch (driver_algs[i].type & CRYPTO_ALG_TYPE_MASK) {
>>   		case CRYPTO_ALG_TYPE_SKCIPHER:
>> -			if (driver_algs[i].is_registered)
>> +			if (driver_algs[i].is_registered && refcount_read(
>> +			    &driver_algs[i].alg.skcipher.base.cra_refcnt)
>> +			    == 1) {
>>   				crypto_unregister_skcipher(
>>   						&driver_algs[i].alg.skcipher);
>> +				driver_algs[i].is_registered = 0;
>> +			}
> This is wrong.  cra_refcnt must not be used directly by drivers.
>
> Normally driver unregister is stopped by the module reference
> count.  This is not the case for your driver because of the existence
> of a path of unregistration that is not tied to module removal.
>
> To support that properly, we need to add code to the Crypto API
> to handle this, as opposed to adding hacks to the driver.
Sorry for this hack, Our problem was when ipsec is under use and device 
is dettached, then chcr_unregister_alg()
is called which unregisters the algorithms, but as ipsec is established 
the cra_refcnt is not 1 and it gives a kernel bug.
So i put a check of cra_refcnt there, taking the reference of a crypto 
driver  "marvell/octeontx/otx_cptvf_algs.c"
is_any_alg_used(void) function where cra_refcnt is checked before 
unregistering the algorithms.

Thanks,
Ayush


>
> Thanks,
