Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46470527052
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 11:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiENJhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 05:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiENJhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 05:37:01 -0400
Received: from out199-17.us.a.mail.aliyun.com (out199-17.us.a.mail.aliyun.com [47.90.199.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6C61B8;
        Sat, 14 May 2022 02:36:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VD6nEFN_1652521014;
Received: from 30.15.218.194(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0VD6nEFN_1652521014)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 14 May 2022 17:36:55 +0800
Message-ID: <8a2be07b-acf6-1148-e299-8196c18cfeed@linux.alibaba.com>
Date:   Sat, 14 May 2022 17:36:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 1/2] net/smc: send cdc msg inline if qp has
 sufficient inline space
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220513071551.22065-1-guangguan.wang@linux.alibaba.com>
 <20220513071551.22065-2-guangguan.wang@linux.alibaba.com>
 <Yn9GB3QwHiY/vtdc@unreal>
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
In-Reply-To: <Yn9GB3QwHiY/vtdc@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.7 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/5/14 14:02, Leon Romanovsky wrote:
>> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
>> index 24be1d03fef9..8a2f9a561197 100644
>> --- a/net/smc/smc_wr.c
>> +++ b/net/smc/smc_wr.c
>> @@ -554,10 +554,11 @@ void smc_wr_remember_qp_attr(struct smc_link *lnk)
>>  static void smc_wr_init_sge(struct smc_link *lnk)
>>  {
>>  	int sges_per_buf = (lnk->lgr->smc_version == SMC_V2) ? 2 : 1;
>> +	bool send_inline = (lnk->qp_attr.cap.max_inline_data >= SMC_WR_TX_SIZE);
> 
> When will it be false? You are creating QPs with max_inline_data == SMC_WR_TX_SIZE?
> 
>>  	u32 i;
>>  
>>  	for (i = 0; i < lnk->wr_tx_cnt; i++) {
>> -		lnk->wr_tx_sges[i].addr =
>> +		lnk->wr_tx_sges[i].addr = send_inline ? (u64)(&lnk->wr_tx_bufs[i]) :
>>  			lnk->wr_tx_dma_addr + i * SMC_WR_BUF_SIZE;
>>  		lnk->wr_tx_sges[i].length = SMC_WR_TX_SIZE;
>>  		lnk->wr_tx_sges[i].lkey = lnk->roce_pd->local_dma_lkey;
>> @@ -575,6 +576,8 @@ static void smc_wr_init_sge(struct smc_link *lnk)
>>  		lnk->wr_tx_ibs[i].opcode = IB_WR_SEND;
>>  		lnk->wr_tx_ibs[i].send_flags =
>>  			IB_SEND_SIGNALED | IB_SEND_SOLICITED;
>> +		if (send_inline)
>> +			lnk->wr_tx_ibs[i].send_flags |= IB_SEND_INLINE;
> 
> If you try to transfer data == SMC_WR_TX_SIZE, you will get -ENOMEM error.
> IB drivers check that length < qp->max_inline_data.
> 
> Thanks
> 

Got it. 

I should create qps with max_inline_data == 0, and get the actual max_inline_data by query_qp.
And I should use lnk->qp_attr.cap.max_inline_data > SMC_WR_TX_SIZE to decide whether to send inline or not.

Thank you.


