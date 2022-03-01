Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5474C89C4
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbiCAKyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234395AbiCAKyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:54:17 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11782A24F;
        Tue,  1 Mar 2022 02:53:35 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V5xygUy_1646132012;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V5xygUy_1646132012)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 18:53:33 +0800
Date:   Tue, 1 Mar 2022 18:53:32 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 6/7] net/smc: don't req_notify until all CQEs
 drained
Message-ID: <20220301105332.GA9417@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220301094402.14992-1-dust.li@linux.alibaba.com>
 <20220301094402.14992-7-dust.li@linux.alibaba.com>
 <Yh3x93sPCS+w/Eth@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh3x93sPCS+w/Eth@unreal>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 12:14:15PM +0200, Leon Romanovsky wrote:
>On Tue, Mar 01, 2022 at 05:44:01PM +0800, Dust Li wrote:
>> When we are handling softirq workload, enable hardirq may
>> again interrupt the current routine of softirq, and then
>> try to raise softirq again. This only wastes CPU cycles
>> and won't have any real gain.
>> 
>> Since IB_CQ_REPORT_MISSED_EVENTS already make sure if
>> ib_req_notify_cq() returns 0, it is safe to wait for the
>> next event, with no need to poll the CQ again in this case.
>> 
>> This patch disables hardirq during the processing of softirq,
>> and re-arm the CQ after softirq is done. Somehow like NAPI.
>> 
>> Co-developed-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
>> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
>> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
>> ---
>>  net/smc/smc_wr.c | 49 +++++++++++++++++++++++++++---------------------
>>  1 file changed, 28 insertions(+), 21 deletions(-)
>> 
>> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
>> index 24be1d03fef9..34d616406d51 100644
>> --- a/net/smc/smc_wr.c
>> +++ b/net/smc/smc_wr.c
>> @@ -137,25 +137,28 @@ static void smc_wr_tx_tasklet_fn(struct tasklet_struct *t)
>>  {
>>  	struct smc_ib_device *dev = from_tasklet(dev, t, send_tasklet);
>>  	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
>> -	int i = 0, rc;
>> -	int polled = 0;
>> +	int i, rc;
>>  
>>  again:
>> -	polled++;
>>  	do {
>>  		memset(&wc, 0, sizeof(wc));
>>  		rc = ib_poll_cq(dev->roce_cq_send, SMC_WR_MAX_POLL_CQE, wc);
>> -		if (polled == 1) {
>> -			ib_req_notify_cq(dev->roce_cq_send,
>> -					 IB_CQ_NEXT_COMP |
>> -					 IB_CQ_REPORT_MISSED_EVENTS);
>> -		}
>> -		if (!rc)
>> -			break;
>>  		for (i = 0; i < rc; i++)
>>  			smc_wr_tx_process_cqe(&wc[i]);
>> +		if (rc < SMC_WR_MAX_POLL_CQE)
>> +			/* If < SMC_WR_MAX_POLL_CQE, the CQ should have been
>> +			 * drained, no need to poll again. --Guangguan Wang
>
>1. Please remove "--Guangguan Wang".
>2. We already discussed that. SMC should be changed to use RDMA CQ pool API
>drivers/infiniband/core/cq.c.
>ib_poll_handler() has much better implementation (tracing, IRQ rescheduling,
>proper error handling) than this SMC variant.

OK, I'll remove this patch in the next version.

Thanks
