Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803D14A2B94
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 05:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352352AbiA2EYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 23:24:52 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:43941 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230242AbiA2EYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 23:24:51 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V34nRnN_1643430287;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V34nRnN_1643430287)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 29 Jan 2022 12:24:48 +0800
Date:   Sat, 29 Jan 2022 12:24:47 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     Stefan Raspl <raspl@linux.ibm.com>, kgraul@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Message-ID: <YfTBj6o8fpcWAfpL@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
 <1f13f001-e4d7-fdcd-6575-caa1be1526e1@linux.ibm.com>
 <a297c8cf-384c-2184-aabb-49ee32476d99@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a297c8cf-384c-2184-aabb-49ee32476d99@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 11:43:22AM +0800, Guangguan Wang wrote:
> 
> Yes, there are alternative ways, as RNR caused by the missmatch of send rate and receive rate, which means sending too fast
> or receiving too slow. What I have done in this patch is to backpressure the sending side when sending too fast.
> 
> Another solution is to process and refill the receive queue as quickly as posibble, which requires no protocol-level change. 
> The fllowing modifications are needed:
> - Enqueue cdc msgs to backlog queues instead of processing in rx tasklet. llc msgs remain unchanged.

It's a good idea to use backlog to free the work in softirq. Rx backlog
can help move the heavy logic out of softirq, and let extra kthread or
workqueue to handle it, then let kernel scheduler to deal with the
balance between userspace process and kthread.

There are two things to be careful, one for introducing more latency,
this should trade off latency and throughput, the other for backlog full.

> - A mempool is needed as cdc msgs are processed asynchronously. Allocate new receive buffers from mempool when refill receive queue.

Yes, we need a elastically expanding RX buffer, also elastically
shrinking. This looks like tcp_mem with tree elements to limit the
memory usage. We also need to free memory automatically, based on memcg
pressure is a good idea.

> - Schedule backlog queues to other cpus, which are calculated by 4-tuple or 5-tuple hash of the connections, to process the cdc msgs,
>   in order to reduce the usage of the cpu where rx tasklet runs on.

I am wondering if it is need for now. In general, it should spread the
CPU usage to different cores. The memory usage or CPU usage which one
will reach its limitation before trigger RNR. Maybe there should some
data to support it?

Thank you,
Tony Lu
