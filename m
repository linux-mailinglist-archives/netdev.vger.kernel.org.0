Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB29F6C78D5
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 08:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjCXH1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 03:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjCXH1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 03:27:04 -0400
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D34C14227;
        Fri, 24 Mar 2023 00:27:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=kaishen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VeWlpf8_1679642804;
Received: from 30.221.112.234(mailfrom:KaiShen@linux.alibaba.com fp:SMTPD_---0VeWlpf8_1679642804)
          by smtp.aliyun-inc.com;
          Fri, 24 Mar 2023 15:26:58 +0800
Message-ID: <7fa69883-9af5-4b2a-7853-9697ff30beba@linux.alibaba.com>
Date:   Fri, 24 Mar 2023 15:26:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
From:   Kai <KaiShen@linux.alibaba.com>
Subject: Re: [PATCH net-next] net/smc: introduce shadow sockets for fallback
 connections
To:     Wenjia Zhang <wenjia@linux.ibm.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20230321071959.87786-1-KaiShen@linux.alibaba.com>
 <170b35d9-2071-caf3-094e-6abfb7cefa75@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <170b35d9-2071-caf3-094e-6abfb7cefa75@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/23/23 1:09 AM, Wenjia Zhang wrote:
> 
> 
> On 21.03.23 08:19, Kai Shen wrote:
>> SMC-R performs not so well on fallback situations right now,
>> especially on short link server fallback occasions. We are planning
>> to make SMC-R widely used and handling this fallback performance
>> issue is really crucial to us. Here we introduce a shadow socket
>> method to try to relief this problem.
>>
> Could you please elaborate the problem?

Here is the background. We are using SMC-R to accelerate server-client 
applications by using SMC-R on server side, but not all clients use 
SMC-R. So in these occasions we hope that the clients using SMC-R get 
acceleration while the clients that fallback to TCP will get the 
performance no worse than TCP.
What's more, in short link scenario we may use fallback on purpose for
SMC-R perform badly with its highly cost connection establishing path.
So it is very important that SMC-R perform similarly as TCP on fallback 
occasions since we use SMC-R as a acceleration method and performance 
compromising should not happen when user use TCP client to connect a 
SMC-R server.
In our tests, fallback SMC-R accepting path on server-side contribute to 
the performance gap compared to TCP a lot as mentioned in the patch and 
we are trying to solve this problem.

> 
> Generally, I don't have a good feeling about the two non-listenning 
> sockets, and I can not see why it is necessary to introduce the socket 
> actsock instead of using the clcsock itself. Maybe you can convince me 
> with a good reason.
>
First let me explain why we use two sockets here.
We want the fallback accept path to be similar as TCP so all the 
fallback connection requests should go to the fallback sock(accept 
queue) and go a shorter path (bypass tcp_listen_work) while clcsock 
contains both requests with syn_smc and fallback requests. So we pick 
requests with syn_smc to actsock and fallback requests to fbsock.
I think it is the right strategy that we have two queues for two types 
of incoming requests (which will lead to good performance too).
On the other hand, the implementation of this strategy is worth discussing.
As Paolo said, in this implementation only the shadow socket's receive 
queue is needed. I use this two non-listenning sockets for these 
following reasons.
1. If we implement a custom accept, some of the symbols are not 
accessible since they are not exported(like mem_cgroup_charge_skmem).
2. Here we reuse the accept path of TCP so that the future update of TCP
may not lead to problems caused by the difference between the custom 
accept and future TCP accept.
3. SMC-R is trying to behave like TCP and if we implement custom accept, 
there may be repeated code and looks not cool.

Well, i think two queues is the right strategy but I am not so sure 
about which implement is better and we really want to solve this 
problem. Please give advice.

>> +static inline bool tcp_reqsk_queue_empty(struct sock *sk)
>> +{
>> +    struct inet_connection_sock *icsk = inet_csk(sk);
>> +    struct request_sock_queue *queue = &icsk->icsk_accept_queue;
>> +
>> +    return reqsk_queue_empty(queue);
>> +}
>> +
> Since this is only used by smc, I'd like to suggest to use 
> smc_tcp_reqsk_queue_empty instead of tcp_reqsk_queue_empty.
>
Will do.

Thanks

Kai
