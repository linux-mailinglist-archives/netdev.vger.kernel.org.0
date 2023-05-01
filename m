Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44EA6F2F34
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 09:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbjEAHla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 03:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjEAHl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 03:41:29 -0400
Received: from mail-m11876.qiye.163.com (mail-m11876.qiye.163.com [115.236.118.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295F61B9;
        Mon,  1 May 2023 00:41:24 -0700 (PDT)
Received: from [IPV6:240e:3b7:327f:5c30:7d8b:c3e:1a47:99e8] (unknown [IPV6:240e:3b7:327f:5c30:7d8b:c3e:1a47:99e8])
        by mail-m11876.qiye.163.com (Hmail) with ESMTPA id 101163C021F;
        Mon,  1 May 2023 15:41:17 +0800 (CST)
Message-ID: <730cf5ed-2239-34f7-79a5-ffa4d9bb8fae@sangfor.com.cn>
Date:   Mon, 1 May 2023 15:41:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net v3 1/2] iavf: Fix use-after-free in free_netdev
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        keescook@chromium.org, grzegorzx.szczurek@intel.com,
        mateusz.palczewski@intel.com, mitch.a.williams@intel.com,
        gregory.v.rose@intel.com, jeffrey.t.kirsher@intel.com,
        michal.kubiak@intel.com, madhu.chittim@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pengdonglin@sangfor.com.cn,
        huangcun@sangfor.com.cn
References: <20230429132022.31765-1-dinghui@sangfor.com.cn>
 <20230429132022.31765-2-dinghui@sangfor.com.cn>
 <ZE9j4CHtQbm5S3cg@corigine.com>
From:   Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <ZE9j4CHtQbm5S3cg@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSUNNVh1LTx5KH0gaHU4YQlUTARMWGhIXJBQOD1
        lXWRgSC1lBWUlPSx5BSBlMQUhJTB1BThhIS0FMH0MZQRhIHkFKGk9MQUJCHkNZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a87d6423c432eb2kusn101163c021f
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N006Shw4KD0RCkIaHBQ5FA4I
        HT4KFBpVSlVKTUNJQklNQ0xDSkhPVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlJT0seQUgZTEFISUwdQU4YSEtBTB9DGUEYSB5BShpPTEFCQh5DWVdZCAFZQUhOT0M3Bg++
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/5/1 15:01, Simon Horman wrote:
> On Sat, Apr 29, 2023 at 09:20:21PM +0800, Ding Hui wrote:
>> We do netif_napi_add() for all allocated q_vectors[], but potentially
>> do netif_napi_del() for part of them, then kfree q_vectors and leave
>> invalid pointers at dev->napi_list.
>>
>> ...
>>
>> Although the patch #2 (of 2) can avoid the issuse triggered by this
>> repro.sh, there still are other potential risks that if num_active_queues
>> is changed to less than allocated q_vectors[] by unexpected, the
>> mismatched netif_napi_add/del() can also casue UAF.
> 
> nit: ./checkpatch --codespell tells me:
> 
>       s/casue/cause/
> 

Sorry, I'll fix it in v4.

>> Since we actually call netif_napi_add() for all allocated q_vectors
>> unconditionally in iavf_alloc_q_vectors(), so we should fix it by
>> letting netif_napi_del() match to netif_napi_add().
>>
>> Fixes: 5eae00c57f5e ("i40evf: main driver core")
>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>> Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
>> Cc: Huang Cun <huangcun@sangfor.com.cn>
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
>> Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
> 
> 
> 

-- 
Thanks,
-dinghui

