Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33CF6A64EB
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 02:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjCABou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 20:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCABot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 20:44:49 -0500
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42CC18AB5;
        Tue, 28 Feb 2023 17:44:46 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=kaishen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Vcl6C0o_1677635083;
Received: from 30.221.113.18(mailfrom:KaiShen@linux.alibaba.com fp:SMTPD_---0Vcl6C0o_1677635083)
          by smtp.aliyun-inc.com;
          Wed, 01 Mar 2023 09:44:44 +0800
Message-ID: <a1516a5e-4d8b-f00c-cecd-e1b2f124fdcd@linux.alibaba.com>
Date:   Wed, 1 Mar 2023 09:44:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2] net/smc: Use percpu ref for wr tx reference
Content-Language: en-US
To:     Wenjia Zhang <wenjia@linux.ibm.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        kgraul@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20230227121616.448-1-KaiShen@linux.alibaba.com>
 <b869713b-7f1d-4093-432c-9f958f5bd719@linux.ibm.com>
 <e10d76c4-3b2c-b906-07c3-9a42b1c485bb@linux.alibaba.com>
 <b0669898-f7b3-fa88-7365-e7e05a587d86@linux.alibaba.com>
 <d1b06606-f01c-918e-0921-5d6c697f9c89@linux.ibm.com>
From:   Kai <KaiShen@linux.alibaba.com>
In-Reply-To: <d1b06606-f01c-918e-0921-5d6c697f9c89@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/2/28 8:52 下午, Wenjia Zhang wrote:
> 
> 
> On 28.02.23 13:15, Guangguan Wang wrote:
>>
>> On 2023/2/28 19:34, Kai wrote:
>>>
>>>
>>> On 2023/2/28 6:55 下午, Wenjia Zhang wrote:
>>>
>>>> @Kai, the performance improvement seems not so giant, but the method 
>>>> looks good, indeed. However, to keep the consistency of the code, 
>>>> I'm wondering why you only use the perf_ref for wr_tx_wait, but not 
>>>> for wr_reg_refcnt?
>>> Didn't check the similar refcnt, my bad.
>>> On the other hand, Our work is inspired by performance analysis, it 
>>> seems wr_reg_refcnt is not on the IO path. It may not contribute to 
>>> performance improvement.
>>> And inspired by your comment, it seems we can also make the refcnt 
>>> cdc_pend_tx_wr a perfcpu one. I will look into this.
>>>
>>> Thanks
>>
>> cdc_pend_tx_wr needs to be zero value tested every time it decreases 
>> in smc_cdc_tx_handler.
>> I don't think this is the right scenario for percpu_ref.
> 
> I agree, that's why I didn't mention it;)
> 
> But could you please check about wr_reg_refcnt? Because we do need to 
> find the right balance between the code consistency and improvement
Will do
