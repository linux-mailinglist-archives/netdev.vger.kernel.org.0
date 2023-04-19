Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC966E7093
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 03:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjDSBAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 21:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDSBAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 21:00:46 -0400
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBEDE71;
        Tue, 18 Apr 2023 18:00:44 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
        by mail-m11875.qiye.163.com (Hmail) with ESMTPA id 9995B2803A9;
        Wed, 19 Apr 2023 09:00:34 +0800 (CST)
Message-ID: <4831d6e8-72be-dd17-9c6c-6f37f58fa37c@sangfor.com.cn>
Date:   Wed, 19 Apr 2023 09:00:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 1/2] iavf: Fix use-after-free in free_netdev
Content-Language: en-US
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org
Cc:     jesse.brandeburg@intel.com, keescook@chromium.org,
        grzegorzx.szczurek@intel.com, mateusz.palczewski@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        Donglin Peng <pengdonglin@sangfor.com.cn>,
        Huang Cun <huangcun@sangfor.com.cn>
References: <20230408140030.5769-1-dinghui@sangfor.com.cn>
 <20230408140030.5769-2-dinghui@sangfor.com.cn>
 <be26a12c-6463-0e3b-9e05-eee8645e7fa6@intel.com>
From:   Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <be26a12c-6463-0e3b-9e05-eee8645e7fa6@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZQx5LVk5LH04eSUNJTBlDSlUTARMWGhIXJBQOD1
        lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a879707273b2eb1kusn9995b2803a9
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N006Djo*Cj0SDhEdOBUqLwMp
        QgFPFENVSlVKTUNKQ01NS09JS0hKVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFISktLNwY+
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/19 0:50, Tony Nguyen wrote:
> On 4/8/2023 7:00 AM, Ding Hui wrote:
>> We do netif_napi_add() for all allocated q_vectors[], but potentially
>> do netif_napi_del() for part of them, then kfree q_vectors and lefted
>> invalid pointers at dev->napi_list.
>>
>> If num_active_queues is changed to less than allocated q_vectors[] by
>> by unexpected, when iavf_remove, we might see UAF in free_netdev like 
>> this:
>>
>> [ 4093.900222] 
>> ==================================================================
>> [ 4093.900230] BUG: KASAN: use-after-free in free_netdev+0x308/0x390
>> [ 4093.900232] Read of size 8 at addr ffff88b4dc145640 by task 
>> test-iavf-1.sh/6699
> 
> ...
> 
>> Fix it by letting netif_napi_del() match to netif_napi_add().
>>
> 
> Should this have a Fixes:?
> 

Yes, I searched the git log, and found that the mismatched usage was
introduced since the beginning of i40evf_main.c, so I'll add

Fixes: 5eae00c57f5e ("i40evf: main driver core")

in v2.

-- 
Thanks,
- Ding Hui

