Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4D0675387
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 12:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjATLll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 06:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjATLlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 06:41:39 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22F0F10A8C;
        Fri, 20 Jan 2023 03:41:34 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:41:30 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ozsh@nvidia.com, marcelo.leitner@gmail.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v3 4/7] netfilter: flowtable: allow updating
 offloaded rules asynchronously
Message-ID: <Y8p96knLDtxnRtjz@salvia>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
 <20230119195104.3371966-5-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230119195104.3371966-5-vladbu@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

On Thu, Jan 19, 2023 at 08:51:01PM +0100, Vlad Buslov wrote:
> Following patches in series need to update flowtable rule several times
> during its lifetime in order to synchronize hardware offload with actual ct
> status. However, reusing existing 'refresh' logic in act_ct would cause
> data path to potentially schedule significant amount of spurious tasks in
> 'add' workqueue since it is executed per-packet. Instead, introduce a new
> flow 'update' flag and use it to schedule async flow refresh in flowtable
> gc which will only be executed once per gc iteration.

So the idea is to use a NF_FLOW_HW_UPDATE which triggers the update
from the garbage collector. I understand the motivation here is to
avoid adding more work to the workqueue, by simply letting the gc
thread pick up for the update.

I already proposed in the last year alternative approaches to improve
the workqueue logic, including cancelation of useless work. For
example, cancel a flying "add" work if "delete" just arrive and the
work is still sitting in the queue. Same approach could be use for
this update logic, ie. cancel an add UDP unidirectional or upgrade it
to bidirectional if, by the time we see traffic in both directions,
then work is still sitting in the queue.

I am sorry to say but it seems to me this approach based on flags is
pushing the existing design to the limit. The flag semantics is
already overloaded that this just makes the state machine behind the
flag logic more complicated. I really think we should explore for
better strategies for the offload work to be processed.

Thanks.
