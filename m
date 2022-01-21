Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E484962B5
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381778AbiAUQWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:22:00 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:15740 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232442AbiAUQV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:21:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V2SWFOq_1642782106;
Received: from 30.39.181.79(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0V2SWFOq_1642782106)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 22 Jan 2022 00:21:47 +0800
Message-ID: <6f1b9813-483b-ea2e-f6da-c349edd34003@linux.alibaba.com>
Date:   Sat, 22 Jan 2022 00:21:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Content-Language: en-US
To:     dust.li@linux.alibaba.com, kgraul@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
 <20220120095130.GB41938@linux.alibaba.com>
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
In-Reply-To: <20220120095130.GB41938@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/1/20 17:51, dust.li wrote:
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
> 
> I'm wondering if SRQ can be used to solve this problem ?
> 
> One of my concern on credit-base flow control is if the RTT is
> a bit longer, we may have to wait RTT/2 for peer to grant us credit
> before we can really send more data. That may decrease the maximium
> bandwidth we can achive in this case.

Longer RTT can result in more inflight messages and increase
the announcement latency indeed.

The following items are used in this patch to reduce the pact
of this situation.
- More rqe. (average 2 credits per smc_connection now, longer RTT is
  a good case for me to check whether an average of 2 is enough. As
  each additional rqe only increases the memory by 104 Bytes,
  SRQ may be an icing on the cake option to reduce memory usage)
- Announce frequenly. (credits carried by every cdc msg)
- Avoid credit accumulation. (announce as soon as the low watermark(1/3 rq entities) is reached)
