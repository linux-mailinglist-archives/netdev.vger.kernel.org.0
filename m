Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F0D47A3F6
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 04:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbhLTDje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 22:39:34 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:56276 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233995AbhLTDjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 22:39:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=cuibixuan@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0V.5JYCF_1639971569;
Received: from 30.43.68.48(mailfrom:cuibixuan@linux.alibaba.com fp:SMTPD_---0V.5JYCF_1639971569)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 20 Dec 2021 11:39:30 +0800
Message-ID: <c5c17989-4c1e-35d2-5a75-a27e58cf6673@linux.alibaba.com>
Date:   Mon, 20 Dec 2021 11:39:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH -next] SUNRPC: Clean XPRT_CONGESTED of xprt->state when
 rpc task is killed
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org
Cc:     bfields@fieldses.org, chuck.lever@oracle.com,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        davem@davemloft.net, kuba@kernel.org, pete.wl@alibaba-inc.com,
        wenan.mwa@alibaba-inc.com, xiaoh.peixh@alibaba-inc.com,
        weipu.zy@alibaba-inc.com
References: <1639490018-128451-1-git-send-email-cuibixuan@linux.alibaba.com>
 <1639490018-128451-2-git-send-email-cuibixuan@linux.alibaba.com>
From:   Bixuan Cui <cuibixuan@linux.alibaba.com>
In-Reply-To: <1639490018-128451-2-git-send-email-cuibixuan@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ping~

在 2021/12/14 下午9:53, Bixuan Cui 写道:
> When the values of tcp_max_slot_table_entries and
> sunrpc.tcp_slot_table_entries are lower than the number of rpc tasks,
> xprt_dynamic_alloc_slot() in xprt_alloc_slot() will return -EAGAIN, and
> then set xprt->state to XPRT_CONGESTED:
>    xprt_retry_reserve
>      ->xprt_do_reserve
>        ->xprt_alloc_slot
>          ->xprt_dynamic_alloc_slot // return -EAGAIN and task->tk_rqstp is NULL
>            ->xprt_add_backlog // set_bit(XPRT_CONGESTED, &xprt->state);
>
> When rpc task is killed, XPRT_CONGESTED bit of xprt->state will not be
> cleaned up and nfs hangs:
>    rpc_exit_task
>      ->xprt_release // if (req == NULL) is true, then XPRT_CONGESTED
> 		   // bit not clean
>
> Add xprt_wake_up_backlog(xprt) to clean XPRT_CONGESTED bit in
> xprt_release().
>
> Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
> Signed-off-by: Xiaohui Pei <xiaoh.peixh@alibaba-inc.com>
> ---
>   net/sunrpc/xprt.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
> index a02de2b..70d11ae 100644
> --- a/net/sunrpc/xprt.c
> +++ b/net/sunrpc/xprt.c
> @@ -1952,6 +1952,7 @@ void xprt_release(struct rpc_task *task)
>   	if (req == NULL) {
>   		if (task->tk_client) {
>   			xprt = task->tk_xprt;
> +			xprt_wake_up_backlog(xprt);
>   			xprt_release_write(xprt, task);
>   		}
>   		return;
