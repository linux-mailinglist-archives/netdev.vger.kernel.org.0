Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3636495008
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345832AbiATOWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:22:24 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:49231 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345781AbiATOWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 09:22:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V2MYk2g_1642688537;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2MYk2g_1642688537)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 22:22:17 +0800
Date:   Thu, 20 Jan 2022 22:22:16 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Message-ID: <YelwGOBhjBFsVPxA@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 02:51:40PM +0800, Guangguan Wang wrote:
> This implement rq flow control in smc-r link layer. QPs
> communicating without rq flow control, in the previous
> version, may result in RNR (reveive not ready) error, which
> means when sq sends a message to the remote qp, but the
> remote qp's rq has no valid rq entities to receive the message.
> In RNR condition, the rdma transport layer may retransmit
> the messages again and again until the rq has any entities,
> which may lower the performance, especially in heavy traffic.
> Using credits to do rq flow control can avoid the occurrence
> of RNR.
> 
> Test environment:
> - CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4.
> - redis benchmark 6.2.3 and redis server 6.2.3.
> - redis server: redis-server --save "" --appendonly no
>   --protected-mode no --io-threads 7 --io-threads-do-reads yes
> - redis client: redis-benchmark -h 192.168.26.36 -q -t set,get
>   -P 1 --threads 7 -n 2000000 -c 200 -d 10
> 
>  Before:
>  SET: 205229.23 requests per second, p50=0.799 msec
>  GET: 212278.16 requests per second, p50=0.751 msec
> 
>  After:
>  SET: 623674.69 requests per second, p50=0.303 msec
>  GET: 688326.00 requests per second, p50=0.271 msec
> 
> The test of redis-benchmark shows that more than 3X rps
> improvement after the implementation of rq flow control.

There seems lots of RNR retransmission in your environment. If would be
better to give out more benchmark data of different cases about this
patch. For different scenarios, such as large packets, perhaps we can
use more fine-grained flow control.
 
>  #include "smc_ib.h"
>  
> -#define SMC_RMBS_PER_LGR_MAX	255	/* max. # of RMBs per link group */
> +#define SMC_RMBS_PER_LGR_MAX	32	/* max. # of RMBs per link group. Correspondingly,
> +					 * SMC_WR_BUF_CNT should not be less than 2 *
> +					 * SMC_RMBS_PER_LGR_MAX, since every connection at
> +					 * least has two rq/sq credits in average, otherwise
> +					 * may result in waiting for credits in sending process.
> +					 */

This gives a fixed limit for per link group connections. Using tunable
knobs to control this for different workload would be better. It also
reduce the completion of free slots in the same link group and link.

Thank you,
Tony Lu
