Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0356E70AA
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 03:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjDSBMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 21:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjDSBMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 21:12:01 -0400
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADA05FFE;
        Tue, 18 Apr 2023 18:12:00 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
        by mail-m11875.qiye.163.com (Hmail) with ESMTPA id ACCD92801F5;
        Wed, 19 Apr 2023 09:11:49 +0800 (CST)
Message-ID: <ff2e0a06-abbb-213a-40ed-20c8e8b2f429@sangfor.com.cn>
Date:   Wed, 19 Apr 2023 09:11:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RESEND PATCH net 1/2] iavf: Fix use-after-free in free_netdev
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        keescook@chromium.org, grzegorzx.szczurek@intel.com,
        mateusz.palczewski@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
References: <20230417074016.3920-1-dinghui@sangfor.com.cn>
 <20230417074016.3920-2-dinghui@sangfor.com.cn>
 <ZD70DKC3+K6gngTh@corigine.com>
From:   Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <ZD70DKC3+K6gngTh@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZTEMaVkJOH00aSBpOT05CGVUTARMWGhIXJBQOD1
        lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a87971175d02eb1kusnaccd92801f5
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mgw6DCo5Tj0JGhESLzEsKkI0
        TB8aFChVSlVKTUNKQ01NTEpMTU9KVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFPT0xONwY+
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/19 3:48, Simon Horman wrote:
> Hi Ding Hui,
> 
> On Mon, Apr 17, 2023 at 03:40:15PM +0800, Ding Hui wrote:
>> We do netif_napi_add() for all allocated q_vectors[], but potentially
>> do netif_napi_del() for part of them, then kfree q_vectors and lefted
> 
> nit: lefted -> leave
> 

Thanks, I'll update in v2.

>> invalid pointers at dev->napi_list.
>>
>> If num_active_queues is changed to less than allocated q_vectors[] by
>> unexpected, when iavf_remove, we might see UAF in free_netdev like this:
>>

...

>>
>> Fix it by letting netif_napi_del() match to netif_napi_add().
>>
>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>> Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
>> CC: Huang Cun <huangcun@sangfor.com.cn>
> 
> as this is a fix it probably should have a fixes tag.
> I wonder if it should be:
> 
> Fixes: cc0529271f23 ("i40evf: don't use more queues than CPUs")

I don't think so.
I searched the git log, and found that the mismatched usage was
introduced since the beginning of i40evf_main.c, so I'll add

Fixes: 5eae00c57f5e ("i40evf: main driver core")

in v2.

> 
> Code change looks good to me.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 

Thanks.

And sorry for you confusion since my RESEND.

>> ---
>>   drivers/net/ethernet/intel/iavf/iavf_main.c | 6 +-----
>>   1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
>> index 095201e83c9d..a57e3425f960 100644
>> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
>> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
>> @@ -1849,19 +1849,15 @@ static int iavf_alloc_q_vectors(struct iavf_adapter *adapter)
>>   static void iavf_free_q_vectors(struct iavf_adapter *adapter)
>>   {
>>   	int q_idx, num_q_vectors;
>> -	int napi_vectors;
>>   
>>   	if (!adapter->q_vectors)
>>   		return;
>>   
>>   	num_q_vectors = adapter->num_msix_vectors - NONQ_VECS;
>> -	napi_vectors = adapter->num_active_queues;
>>   
>>   	for (q_idx = 0; q_idx < num_q_vectors; q_idx++) {
>>   		struct iavf_q_vector *q_vector = &adapter->q_vectors[q_idx];
>> -
>> -		if (q_idx < napi_vectors)
>> -			netif_napi_del(&q_vector->napi);
>> +		netif_napi_del(&q_vector->napi);
>>   	}
>>   	kfree(adapter->q_vectors);
>>   	adapter->q_vectors = NULL;
>> -- 
>> 2.17.1
>>
> 

-- 
Thanks,
- Ding Hui

