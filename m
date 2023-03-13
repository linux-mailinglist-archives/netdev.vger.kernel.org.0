Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5B56B6E18
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 04:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjCMDqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 23:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjCMDqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 23:46:13 -0400
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D0B3BD9D;
        Sun, 12 Mar 2023 20:46:11 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=kaishen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VdfE4BM_1678679168;
Received: from 30.221.113.94(mailfrom:KaiShen@linux.alibaba.com fp:SMTPD_---0VdfE4BM_1678679168)
          by smtp.aliyun-inc.com;
          Mon, 13 Mar 2023 11:46:09 +0800
Message-ID: <9e38121a-14ab-5ee4-b379-ad10371392f0@linux.alibaba.com>
Date:   Mon, 13 Mar 2023 11:46:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3] net/smc: Use percpu ref for wr tx reference
Content-Language: en-US
From:   Kai <KaiShen@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20230303082115.449-1-KaiShen@linux.alibaba.com>
 <ZAhHiZ5/3Q3dcL4c@TONYMAC-ALIBABA.local>
 <43cd6283-c8c4-7764-f828-39a59596e33c@linux.alibaba.com>
In-Reply-To: <43cd6283-c8c4-7764-f828-39a59596e33c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/13/23 9:20 AM, Kai wrote:
> 
> 
> On 3/8/23 4:30 PM, Tony Lu wrote:
>>> redis-benchmark on smc-r with atomic wr_tx_refcnt:
>>> SET: 525817.62 requests per second, p50=0.087 msec
>>> GET: 570841.44 requests per second, p50=0.087 msec
>>>
>>> redis-benchmark on the percpu_ref version:
>>> SET: 539956.81 requests per second, p50=0.087 msec
>>> GET: 587613.12 requests per second, p50=0.079 msec
>>
>> Does the test data need to be refreshed?
>>
> Will do.
>>> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
>>> index 08b457c2d294..1645fba0d2d3 100644
>>> --- a/net/smc/smc_core.h
>>> +++ b/net/smc/smc_core.h
>>> @@ -106,7 +106,10 @@ struct smc_link {
>>>       unsigned long        *wr_tx_mask;    /* bit mask of used 
>>> indexes */
>>>       u32            wr_tx_cnt;    /* number of WR send buffers */
>>>       wait_queue_head_t    wr_tx_wait;    /* wait for free WR send 
>>> buf */
>>> -    atomic_t        wr_tx_refcnt;    /* tx refs to link */
>>> +    struct {
>>> +        struct percpu_ref    wr_tx_refs;
>>> +    } ____cacheline_aligned_in_smp;
>>> +    struct completion    tx_ref_comp;
>>
>> For the variable names suffixed with wr_*_refs, should we continue to
>> use wr_*_refcnt?
>>
>> Thanks.
> In my opinion, we can't get the count of the percpu reference until it 
> we start to destroy it. So maybe using wr_*_refcnt here is more 
> appropriate？
I mean wr_*_refs here. Sorry for the mistake.
