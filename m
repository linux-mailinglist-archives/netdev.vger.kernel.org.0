Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D823494A8E
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 10:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241595AbiATJUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 04:20:06 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:48449 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239702AbiATJUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 04:20:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V2Lw44Q_1642670401;
Received: from 30.43.104.217(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0V2Lw44Q_1642670401)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 17:20:02 +0800
Message-ID: <220be582-a2c2-bc3c-ce6b-0eda2a297ba1@linux.alibaba.com>
Date:   Thu, 20 Jan 2022 17:20:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
 <YekcWYwg399vR18R@unreal>
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
In-Reply-To: <YekcWYwg399vR18R@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/1/20 16:24, Leon Romanovsky wrote:
> On Thu, Jan 20, 2022 at 02:51:40PM +0800, Guangguan Wang wrote:
>> This implement rq flow control in smc-r link layer. QPs
>> communicating without rq flow control, in the previous
>> version, may result in RNR (reveive not ready) error, which
>> means when sq sends a message to the remote qp, but the
>> remote qp's rq has no valid rq entities to receive the message.
>> In RNR condition, the rdma transport layer may retransmit
>> the messages again and again until the rq has any entities,
>> which may lower the performance, especially in heavy traffic.
>> Using credits to do rq flow control can avoid the occurrence
>> of RNR.
>>
>> Test environment:
>> - CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4.
>> - redis benchmark 6.2.3 and redis server 6.2.3.
>> - redis server: redis-server --save "" --appendonly no
>>   --protected-mode no --io-threads 7 --io-threads-do-reads yes
>> - redis client: redis-benchmark -h 192.168.26.36 -q -t set,get
>>   -P 1 --threads 7 -n 2000000 -c 200 -d 10
>>
>>  Before:
>>  SET: 205229.23 requests per second, p50=0.799 msec
>>  GET: 212278.16 requests per second, p50=0.751 msec
>>
>>  After:
>>  SET: 623674.69 requests per second, p50=0.303 msec
>>  GET: 688326.00 requests per second, p50=0.271 msec
>>
>> The test of redis-benchmark shows that more than 3X rps
>> improvement after the implementation of rq flow control.
>>
>> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
>> ---
>>  net/smc/af_smc.c   | 12 ++++++
>>  net/smc/smc_cdc.c  | 10 ++++-
>>  net/smc/smc_cdc.h  |  3 +-
>>  net/smc/smc_clc.c  |  3 ++
>>  net/smc/smc_clc.h  |  3 +-
>>  net/smc/smc_core.h | 17 ++++++++-
>>  net/smc/smc_ib.c   |  6 ++-
>>  net/smc/smc_llc.c  | 92 +++++++++++++++++++++++++++++++++++++++++++++-
>>  net/smc/smc_llc.h  |  5 +++
>>  net/smc/smc_wr.c   | 30 ++++++++++++---
>>  net/smc/smc_wr.h   | 54 ++++++++++++++++++++++++++-
>>  11 files changed, 222 insertions(+), 13 deletions(-)
> 
> <...>
> 
>> +		// set peer rq credits watermark, if less than init_credits * 2/3,
>> +		// then credit announcement is needed.
> 
> <...>
> 
>> +		// set peer rq credits watermark, if less than init_credits * 2/3,
>> +		// then credit announcement is needed.
> 
> <...>
> 
>> +	// credits have already been announced to peer
> 
> <...>
> 
>> +	// set local rq credits high watermark to lnk->wr_rx_cnt / 3,
>> +	// if local rq credits more than high watermark, announcement is needed.
> 
> <...>
> 
>> +// get one tx credit, and peer rq credits dec
> 
> <...>
> 
>> +// put tx credits, when some failures occurred after tx credits got
>> +// or receive announce credits msgs
>> +static inline void smc_wr_tx_put_credits(struct smc_link *link, int credits, bool wakeup)
> 
> <...>
> 
>> +// to check whether peer rq credits is lower than watermark.
>> +static inline int smc_wr_tx_credits_need_announce(struct smc_link *link)
> 
> <...>
> 
>> +// get local rq credits and set credits to zero.
>> +// may called when announcing credits
>> +static inline int smc_wr_rx_get_credits(struct smc_link *link)
> 
> Please try to use C-style comments.
> 
> Thanks

Thanks for your advice, I will modify it in the next version of patch.
