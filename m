Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF844AEA4A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 07:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiBIG2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 01:28:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234932AbiBIGYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 01:24:22 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F672C00875D;
        Tue,  8 Feb 2022 22:24:25 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V3zg98L_1644387858;
Received: from 30.225.28.54(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V3zg98L_1644387858)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 14:24:23 +0800
Message-ID: <e8764a6e-7542-3048-fb30-cdb7fd4dcde2@linux.alibaba.com>
Date:   Wed, 9 Feb 2022 14:24:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next v5 1/5] net/smc: Make smc_tcp_listen_work()
 independent
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <58c544cb206d94b759ff0546bcffe693c3cbfb98.1644323503.git.alibuda@linux.alibaba.com>
 <0d1363b7-6080-5fb3-1dcb-cdedf82303fa@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <0d1363b7-6080-5fb3-1dcb-cdedf82303fa@linux.ibm.com>
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

It is indeed okay to use system_wq at present. Dues to the load 
balancing issues we found, queue_work() always submits tasks to the 
worker on the current CPU. tcp_listen_work() execution once may submit a 
large number of tasks to the worker of the current CPU, causing 
unnecessary pending, even though worker on other CPU are totaly free. I 
was plan to make tcp_listen_work() blocked wait on worker of every CPU, 
so I create a new workqueue, and that's the only reason for it. But this 
problem is not very urgent, and I don't have strong opinion too...


在 2022/2/9 上午1:06, Karsten Graul 写道:
> On 08/02/2022 13:53, D. Wythe wrote:
>> +static struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
>>   struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
>>   struct workqueue_struct	*smc_close_wq;	/* wq for close work */
>>   
>> @@ -2227,7 +2228,7 @@ static void smc_clcsock_data_ready(struct sock *listen_clcsock)
>>   	lsmc->clcsk_data_ready(listen_clcsock);
>>   	if (lsmc->sk.sk_state == SMC_LISTEN) {
>>   		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
>> -		if (!queue_work(smc_hs_wq, &lsmc->tcp_listen_work))
>> +		if (!queue_work(smc_tcp_ls_wq, &lsmc->tcp_listen_work))
>>   			sock_put(&lsmc->sk);
> 
> It works well this way, but given the fact that there is one tcp_listen worker per
> listen socket and these workers finish relatively quickly, wouldn't it be okay to
> use the system_wq instead of using an own queue? But I have no strong opinion about that...
