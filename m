Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720A24AEACC
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbiBIHLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236165AbiBIHLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:11:13 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A0CC05CB81;
        Tue,  8 Feb 2022 23:11:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V4-87Jr_1644390672;
Received: from 30.225.28.54(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4-87Jr_1644390672)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 15:11:13 +0800
Message-ID: <7f35f47b-af31-a07e-752a-11bb15aa0db9@linux.alibaba.com>
Date:   Wed, 9 Feb 2022 15:11:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next v5 2/5] net/smc: Limit backlog connections
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <c597e6c6d004e5b2a26a9535c8099d389214f273.1644323503.git.alibuda@linux.alibaba.com>
 <c28365d5-72e3-335b-372e-2a9069898df1@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <c28365d5-72e3-335b-372e-2a9069898df1@linux.ibm.com>
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


There are indirectly limits on smc accept queue with following code.

+	if (sk_acceptq_is_full(&smc->sk)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
+		goto drop;
+	}


In fact, we treat the connections in smc accept queue as Full 
establisted connection. As I wrote in patch commits, there are 
trade-offs to this implemets.

Thanks.

在 2022/2/9 上午1:13, Karsten Graul 写道:
> On 08/02/2022 13:53, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> Current implementation does not handling backlog semantics, one
>> potential risk is that server will be flooded by infinite amount
>> connections, even if client was SMC-incapable.
> 
> In this patch you count the number of inflight SMC handshakes as pending and
> check them against the defined max_backlog. I really like this improvement.
> 
> There is another queue in af_smc.c, the smc accept queue and any new client
> socket that completed the handshake process is enqueued there (in smc_accept_enqueue() )
> and is waiting to get accepted by the user space application. To apply the correct
> semantics here, I think the number of sockets waiting in the smc accept queue
> should also be counted as backlog connections, right? I see no limit for this queue
> now. What do you think?
