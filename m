Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BFC6E7088
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 02:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjDSAxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 20:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjDSAxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 20:53:45 -0400
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A7593C2;
        Tue, 18 Apr 2023 17:53:43 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
        by mail-m11875.qiye.163.com (Hmail) with ESMTPA id A0EC62802EC;
        Wed, 19 Apr 2023 08:53:33 +0800 (CST)
Message-ID: <63170820-473b-5f50-a8ff-3cba91fe5046@sangfor.com.cn>
Date:   Wed, 19 Apr 2023 08:53:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 2/2] iavf: Fix out-of-bounds when setting channels on
 remove
Content-Language: en-US
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        keescook@chromium.org, grzegorzx.szczurek@intel.com,
        mateusz.palczewski@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Donglin Peng <pengdonglin@sangfor.com.cn>,
        Huang Cun <huangcun@sangfor.com.cn>
References: <20230408140030.5769-1-dinghui@sangfor.com.cn>
 <20230408140030.5769-3-dinghui@sangfor.com.cn>
 <ZD7BMI+OjggaQmZg@localhost.localdomain>
From:   Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <ZD7BMI+OjggaQmZg@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZTBgZVkMfGhpJSx1NHh1LHlUTARMWGhIXJBQOD1
        lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVSktLVUtZBg++
X-HM-Tid: 0a879700bc852eb1kusna0ec62802ec
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NE06USo4GD0OGhEdKDUjCkpO
        FEpPFBVVSlVKTUNKQ01OTUlKTUtLVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFITUlJNwY+
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/19 0:11, Michal Kubiak wrote:
> On Sat, Apr 08, 2023 at 10:00:30PM +0800, Ding Hui wrote:
>> If we set channels greater when iavf_remove, the waiting reset done
>> will be timeout, then returned with error but changed num_active_queues
>> directly, that will lead to OOB like the following logs. Because the
>> num_active_queues is greater than tx/rx_rings[] allocated actually.
>>

...

>>
>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>> index 6f171d1d85b7..d8a3c0cfedd0 100644
>> --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>> +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>> @@ -1857,13 +1857,15 @@ static int iavf_set_channels(struct net_device *netdev,
>>   	/* wait for the reset is done */
>>   	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
>>   		msleep(IAVF_RESET_WAIT_MS);
>> +		if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
>> +			return -EOPNOTSUPP;
>>   		if (adapter->flags & IAVF_FLAG_RESET_PENDING)
>>   			continue;
>>   		break;
>>   	}
>>   	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
>>   		adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
>> -		adapter->num_active_queues = num_req;
>> +		adapter->num_req_queues = 0;
>>   		return -EOPNOTSUPP;
>>   	}
>>   
> 
> Looks OK to me.
> Just consider moving repro scripts from the cover letter to the commit
> message.
> 

Sure, I will. Thanks again.

-- 
Thanks,
- Ding Hui

