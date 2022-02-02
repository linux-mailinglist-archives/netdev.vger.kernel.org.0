Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D804A7280
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344676AbiBBOBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:01:51 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:35303 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344673AbiBBOBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:01:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V3Rtt6E_1643810506;
Received: from 192.168.0.104(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V3Rtt6E_1643810506)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Feb 2022 22:01:47 +0800
Message-ID: <6e91332f-6d40-1e72-ea90-319a49c759ac@linux.alibaba.com>
Date:   Wed, 2 Feb 2022 22:01:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 2/3] net/smc: Limits backlog connections
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, matthieu.baerts@tessares.net
References: <cover.1643380219.git.alibuda@linux.alibaba.com>
 <e22553bd881bcc3b455bad9d77b392ca3ced5c6e.1643380219.git.alibuda@linux.alibaba.com>
 <YfTEfWBSCsxK0zyF@TonyMac-Alibaba>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <YfTEfWBSCsxK0zyF@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The overhead will certainly exist, but compared with the benefits, I 
think it should be acceptable. If you do care, maybe we can add a switch 
to control it.


> I am wondering if there would introduce more overhead, compared with
> original implement?
> 
>> +
>> +drop:
>> +	dst_release(dst);
>> +	tcp_listendrop(sk);
>> +	return NULL;
>> +}
>> +
>>   static struct smc_hashinfo smc_v4_hashinfo = {
>>   	.lock = __RW_LOCK_UNLOCKED(smc_v4_hashinfo.lock),
>>   };
>> @@ -1491,6 +1519,9 @@ static void smc_listen_out(struct smc_sock *new_smc)
>>   	struct smc_sock *lsmc = new_smc->listen_smc;
>>   	struct sock *newsmcsk = &new_smc->sk;
>>   
>> +	if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
>> +		atomic_dec(&lsmc->smc_pendings);
>> +
>>   	if (lsmc->sk.sk_state == SMC_LISTEN) {
>>   		lock_sock_nested(&lsmc->sk, SINGLE_DEPTH_NESTING);
>>   		smc_accept_enqueue(&lsmc->sk, newsmcsk);
>> @@ -2096,6 +2127,9 @@ static void smc_tcp_listen_work(struct work_struct *work)
>>   		if (!new_smc)
>>   			continue;
>>   
>> +		if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
>> +			atomic_inc(&lsmc->smc_pendings);
>> +
>>   		new_smc->listen_smc = lsmc;
>>   		new_smc->use_fallback = lsmc->use_fallback;
>>   		new_smc->fallback_rsn = lsmc->fallback_rsn;
>> @@ -2163,6 +2197,15 @@ static int smc_listen(struct socket *sock, int backlog)
>>   	smc->clcsock->sk->sk_data_ready = smc_clcsock_data_ready;
>>   	smc->clcsock->sk->sk_user_data =
>>   		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
>> +
>> +	/* save origin ops */
>> +	smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
>> +
>> +	smc->af_ops = *smc->ori_af_ops;
>> +	smc->af_ops.syn_recv_sock = smc_tcp_syn_recv_sock;
>> +
>> +	inet_csk(smc->clcsock->sk)->icsk_af_ops = &smc->af_ops;
> 


Only save syn_recv_sock? Maybe this comment is confusing，
  ‘Copy the origin ops’ is better, the origin ops is pointer to a const 
structure, we must copy it all, and repointer it to our structure. so 
the copy/save is necessary.

Thanks.

> Consider to save syn_recv_sock this field only? There seems no need to
> save this ops all.
> 
> Thank you,
> Tony Lu
