Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4065C6B6D08
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 02:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjCMBUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 21:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjCMBUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 21:20:32 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5537836086;
        Sun, 12 Mar 2023 18:20:29 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=kaishen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VdeSqPR_1678670425;
Received: from 30.221.113.94(mailfrom:KaiShen@linux.alibaba.com fp:SMTPD_---0VdeSqPR_1678670425)
          by smtp.aliyun-inc.com;
          Mon, 13 Mar 2023 09:20:26 +0800
Message-ID: <43cd6283-c8c4-7764-f828-39a59596e33c@linux.alibaba.com>
Date:   Mon, 13 Mar 2023 09:20:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
From:   Kai <KaiShen@linux.alibaba.com>
Subject: Re: [PATCH net-next v3] net/smc: Use percpu ref for wr tx reference
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20230303082115.449-1-KaiShen@linux.alibaba.com>
 <ZAhHiZ5/3Q3dcL4c@TONYMAC-ALIBABA.local>
Content-Language: en-US
In-Reply-To: <ZAhHiZ5/3Q3dcL4c@TONYMAC-ALIBABA.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/23 4:30 PM, Tony Lu wrote:
>> redis-benchmark on smc-r with atomic wr_tx_refcnt:
>> SET: 525817.62 requests per second, p50=0.087 msec
>> GET: 570841.44 requests per second, p50=0.087 msec
>>
>> redis-benchmark on the percpu_ref version:
>> SET: 539956.81 requests per second, p50=0.087 msec
>> GET: 587613.12 requests per second, p50=0.079 msec
> 
> Does the test data need to be refreshed?
> 
Will do.
>> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
>> index 08b457c2d294..1645fba0d2d3 100644
>> --- a/net/smc/smc_core.h
>> +++ b/net/smc/smc_core.h
>> @@ -106,7 +106,10 @@ struct smc_link {
>>   	unsigned long		*wr_tx_mask;	/* bit mask of used indexes */
>>   	u32			wr_tx_cnt;	/* number of WR send buffers */
>>   	wait_queue_head_t	wr_tx_wait;	/* wait for free WR send buf */
>> -	atomic_t		wr_tx_refcnt;	/* tx refs to link */
>> +	struct {
>> +		struct percpu_ref	wr_tx_refs;
>> +	} ____cacheline_aligned_in_smp;
>> +	struct completion	tx_ref_comp;
> 
> For the variable names suffixed with wr_*_refs, should we continue to
> use wr_*_refcnt?
> 
> Thanks.
In my opinion, we can't get the count of the percpu reference until it 
we start to destroy it. So maybe using wr_*_refcnt here is more 
appropriate？
