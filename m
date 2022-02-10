Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA604B03EC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 04:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbiBJD26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 22:28:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiBJD25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 22:28:57 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E143C23BD0;
        Wed,  9 Feb 2022 19:28:57 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V424pW2_1644463734;
Received: from 30.225.28.114(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V424pW2_1644463734)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Feb 2022 11:28:55 +0800
Message-ID: <a96cd721-4c0e-5f8c-0796-b3ee70270af5@linux.alibaba.com>
Date:   Thu, 10 Feb 2022 11:28:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
From:   "D. Wythe" <alibuda@linux.alibaba.com>
Subject: Re: [PATCH net-next v6 2/5] net/smc: Limit backlog connections
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644413637.git.alibuda@linux.alibaba.com>
 <412a5ddd496c5966a8910435a33552c78868d86d.1644413637.git.alibuda@linux.alibaba.com>
 <ed4c056d-03ee-d825-845d-a9e5b4d58c26@linux.ibm.com>
In-Reply-To: <ed4c056d-03ee-d825-845d-a9e5b4d58c26@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/2/10 上午12:02, Karsten Graul 写道:
> On 09/02/2022 15:11, D. Wythe wrote:
>> +static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
>> +					  struct request_sock *req,
>> +					  struct dst_entry *dst,
>> +					  struct request_sock *req_unhash,
>> +					  bool *own_req)
>> +{
>> +	struct smc_sock *smc;
>> +
>> +	smc = (struct smc_sock *)((uintptr_t)sk->sk_user_data & ~SK_USER_DATA_NOCOPY);
> 
> Did you run checkpatch.pl for these patches, for me this and other lines look longer
> than 80 characters.

The latest checkpacth removes this restriction, so I didn't find this 
problem, I'll fix it right away.

>> diff --git a/net/smc/smc.h b/net/smc/smc.h
>> index 37b2001..5e5e38d 100644
>> --- a/net/smc/smc.h
>> +++ b/net/smc/smc.h
>> @@ -252,6 +252,10 @@ struct smc_sock {				/* smc sock container */
>>   	bool			use_fallback;	/* fallback to tcp */
>>   	int			fallback_rsn;	/* reason for fallback */
>>   	u32			peer_diagnosis; /* decline reason from peer */
>> +	atomic_t                smc_pendings;   /* pending smc connections */
> 
> I don't like the name smc_pendings, its not very specific.
> What about queued_smc_hs?
> And for the comment: queued smc handshakes
> 
>> +	struct inet_connection_sock_af_ops		af_ops;
>> +	const struct inet_connection_sock_af_ops	*ori_af_ops;
>> +						/* origin af ops */
> origin -> original
>>   	int			sockopt_defer_accept;
>>   						/* sockopt TCP_DEFER_ACCEPT
>>   						 * value
> 

Copy that. I'll rename it all.
