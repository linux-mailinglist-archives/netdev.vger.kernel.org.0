Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E92E598AC5
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344115AbiHRR4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239324AbiHRR4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:56:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42963B99FE;
        Thu, 18 Aug 2022 10:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC2FEB82370;
        Thu, 18 Aug 2022 17:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46551C433D6;
        Thu, 18 Aug 2022 17:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660845403;
        bh=5Ht2XWnsC3I+rFlT0EuuE3pBM0iTeqpxyLsKMfRcS2M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TvKJq54PjuQVRLavoAbgrKfglQI2H46TNBiRSZAcXdHVzaAi6a78ed92Ht3lU1Nx2
         A3EvH2IBvTCJo/h6l1D6T72Sk315IEJXCj4WlCjl5tt7gLseKkmwz2SYT6Xqa82AAE
         45CZi46mDIeSxgSZ2SKFAB5r1QkqNagJ8piz3DF7l47EiRd6MzX6nMBi9taLxOeqQj
         77qnSKKezmNcM+VJK+ThfoL7na9i5vR+HgsoiuQUwLIpLYebo7t+p5ojWLg3ABDTjP
         uWhW7/C+DRktqANwrWuBzOfoIAWWIgk7/waF3eH5EW8Qpr7Q4fdNmuwcRdVLRoRpJ8
         324SeCA2luWxQ==
Date:   Thu, 18 Aug 2022 10:56:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <brouer@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net/sched: fix netdevice reference leaks in
 attach_one_default_qdisc()
Message-ID: <20220818105642.6d58e9d4@kernel.org>
In-Reply-To: <20220817104646.22861-1-wanghai38@huawei.com>
References: <20220817104646.22861-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 18:46:46 +0800 Wang Hai wrote:
> In attach_default_qdiscs(), when attach default qdisc (fq_codel) fails
> and fallback to noqueue, if the original attached qdisc is not released
> and a new one is directly attached, this will cause netdevice reference
> leaks.

Could you provide more details on the failure path? My preference would
be to try to clean up properly there, if possible.

> The following is the bug log:
> 
> veth0: default qdisc (fq_codel) fail, fallback to noqueue
> unregister_netdevice: waiting for veth0 to become free. Usage count = 32
> leaked reference.
>  qdisc_alloc+0x12e/0x210
>  qdisc_create_dflt+0x62/0x140
>  attach_one_default_qdisc.constprop.41+0x44/0x70
>  dev_activate+0x128/0x290
>  __dev_open+0x12a/0x190
>  __dev_change_flags+0x1a2/0x1f0
>  dev_change_flags+0x23/0x60
>  do_setlink+0x332/0x1150
>  __rtnl_newlink+0x52f/0x8e0
>  rtnl_newlink+0x43/0x70
>  rtnetlink_rcv_msg+0x140/0x3b0
>  netlink_rcv_skb+0x50/0x100
>  netlink_unicast+0x1bb/0x290
>  netlink_sendmsg+0x37c/0x4e0
>  sock_sendmsg+0x5f/0x70
>  ____sys_sendmsg+0x208/0x280
> 
> In attach_one_default_qdisc(), release the old one before attaching
> a new qdisc to fix this bug.
> 
> Fixes: bf6dba76d278 ("net: sched: fallback to qdisc noqueue if default qdisc setup fail")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/sched/sch_generic.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index d47b9689eba6..87b61ef14497 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1140,6 +1140,11 @@ static void attach_one_default_qdisc(struct net_device *dev,
>  
>  	if (!netif_is_multiqueue(dev))
>  		qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
> +
> +	if (dev_queue->qdisc_sleeping &&
> +	    dev_queue->qdisc_sleeping != &noop_qdisc)
> +		qdisc_put(dev_queue->qdisc_sleeping);
> +
>  	dev_queue->qdisc_sleeping = qdisc;
>  }
>  

