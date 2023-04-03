Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5081D6D41C8
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjDCKTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjDCKTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:19:11 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7AD12BD2;
        Mon,  3 Apr 2023 03:18:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=kaishen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VfHQgtD_1680517135;
Received: from 30.221.116.42(mailfrom:KaiShen@linux.alibaba.com fp:SMTPD_---0VfHQgtD_1680517135)
          by smtp.aliyun-inc.com;
          Mon, 03 Apr 2023 18:18:56 +0800
Message-ID: <a32eff21-fe49-5284-2485-25b4f14a7239@linux.alibaba.com>
Date:   Mon, 3 Apr 2023 18:18:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
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
 <7fa69883-9af5-4b2a-7853-9697ff30beba@linux.alibaba.com>
 <df825d71-eb6d-ac73-7f7f-33277fde6b12@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <df825d71-eb6d-ac73-7f7f-33277fde6b12@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/29/23 5:41 PM, Wenjia Zhang wrote:
> 
> 
> 
> On 24.03.23 08:26, Kai wrote:
>>
>>
>> On 3/23/23 1:09 AM, Wenjia Zhang wrote:
>>>
>>>
>>> On 21.03.23 08:19, Kai Shen wrote:
>>>> SMC-R performs not so well on fallback situations right now,
>>>> especially on short link server fallback occasions. We are planning
>>>> to make SMC-R widely used and handling this fallback performance
>>>> issue is really crucial to us. Here we introduce a shadow socket
>>>> method to try to relief this problem.
>>>>
>>> Could you please elaborate the problem?
>>
>> Here is the background. We are using SMC-R to accelerate server-client 
>> applications by using SMC-R on server side, but not all clients use 
>> SMC-R. So in these occasions we hope that the clients using SMC-R get 
>> acceleration while the clients that fallback to TCP will get the 
>> performance no worse than TCP.
> 
> I'm wondering how the usecase works? How are the server-client 
> applications get accelerated by using SMC-R? If your case rely on the 
> fallback, why don't use TCP/IP directly?
> 

Our goal is to replace TCP with SMC-R on Cloud as much as possible.
Many applications will use SMC-R by default but not all(like they are
not using then latest OS). So a SMC-R using server must be ready to
serve SMC-R clients and TCP clients in the mean time. As a result
fallback will happend.

In these cases we hope clients using SMC-R get accelerated and clients
using TCP get no performance loss. The server using SMC-R can't tell if
the next client use SMC-R or TCP util their TCP SYN comes and this lead
to fallback when a client use TCP. But the current SMC-R server fallback
path which handles incoming TCP connection requests will compromise the
performance of TCP clients. So we want to optimize SMC-R server fallback
path.

Thanks.
