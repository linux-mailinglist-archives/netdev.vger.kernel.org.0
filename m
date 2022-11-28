Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056A263AD86
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 17:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbiK1QUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 11:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiK1QUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 11:20:45 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6D615F9F;
        Mon, 28 Nov 2022 08:20:43 -0800 (PST)
Date:   Mon, 28 Nov 2022 17:20:40 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH nf] netfilter: fix using __this_cpu_add in preemptible in
 nf_flow_table_offload
Message-ID: <Y4Tf2BaN5DzibJKl@salvia>
References: <9fc554880eeb0bc9d1749d9577e3aa058eb9f61c.1669312450.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9fc554880eeb0bc9d1749d9577e3aa058eb9f61c.1669312450.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 12:54:10PM -0500, Xin Long wrote:
> flow_offload_queue_work() can be called in workqueue without
> bh disabled, like the call trace showed in my act_ct testing,
> calling NF_FLOW_TABLE_STAT_INC() there would cause a call
> trace:
> 
>   BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u4:0/138560
>   caller is flow_offload_queue_work+0xec/0x1b0 [nf_flow_table]
>   Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work [act_ct]
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x33/0x46
>    check_preemption_disabled+0xc3/0xf0
>    flow_offload_queue_work+0xec/0x1b0 [nf_flow_table]
>    nf_flow_table_iterate+0x138/0x170 [nf_flow_table]
>    nf_flow_table_free+0x140/0x1a0 [nf_flow_table]
>    tcf_ct_flow_table_cleanup_work+0x2f/0x2b0 [act_ct]
>    process_one_work+0x6a3/0x1030
>    worker_thread+0x8a/0xdf0
> 
> This patch fixes it by using NF_FLOW_TABLE_STAT_INC_ATOMIC()
> instead in flow_offload_queue_work().
> 
> Note that for FLOW_CLS_REPLACE branch in flow_offload_queue_work(),
> it may not be called in preemptible path, but it's good to use
> NF_FLOW_TABLE_STAT_INC_ATOMIC() for all cases in
> flow_offload_queue_work().

Applied, thanks
