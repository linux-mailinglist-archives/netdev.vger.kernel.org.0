Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3710494F29
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 14:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239230AbiATNjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 08:39:39 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:58092 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232587AbiATNji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 08:39:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V2MrCwo_1642685974;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2MrCwo_1642685974)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 21:39:34 +0800
Date:   Thu, 20 Jan 2022 21:39:33 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, dust.li@linux.alibaba.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Message-ID: <YelmFWn7ot0iQCYG@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
 <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
 <20220105044049.GA107642@e02h04389.eu6sqa>
 <20220105085748.GD31579@linux.alibaba.com>
 <b98aefce-e425-9501-aacc-8e5a4a12953e@linux.ibm.com>
 <20220105150612.GA75522@e02h04389.eu6sqa>
 <d35569df-e0e0-5ea7-9aeb-7ffaeef04b14@linux.ibm.com>
 <YdaUuOq+SkhYTWU8@TonyMac-Alibaba>
 <5a5ba1b6-93d7-5c1e-aab2-23a52727fbd1@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a5ba1b6-93d7-5c1e-aab2-23a52727fbd1@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 09:07:51AM +0100, Karsten Graul wrote:
> On 06/01/2022 08:05, Tony Lu wrote:
> 
> I think of the following approach: the default maximum of active workers in a
> work queue is defined by WQ_MAX_ACTIVE (512). when this limit is hit then we
> have slightly lesser than 512 parallel SMC handshakes running at the moment,
> and new workers would be enqueued without to become active.
> In that case (max active workers reached) I would tend to fallback new connections
> to TCP. We would end up with lesser connections using SMC, but for the user space
> applications there would be nearly no change compared to TCP (no dropped TCP connection
> attempts, no need to reconnect).
> Imho, most users will never run into this problem, so I think its fine to behave like this.

This makes sense to me, thanks.

> 
> As far as I understand you, you still see a good reason in having another behavior 
> implemented in parallel (controllable by user) which enqueues all incoming connections
> like in your patch proposal? But how to deal with the out-of-memory problems that might 
> happen with that?

There is a possible scene, when the user only wants to use SMC protocol, such
as performance benchmark, or explicitly specify SMC protocol, they can
afford the lower speed of incoming connection creation, but enjoy the
higher QPS after creation.

> Lets decide that when you have a specific control that you want to implement. 
> I want to have a very good to introduce another interface into the SMC module,
> making the code more complex and all of that. The decision for the netlink interface 
> was also done because we have the impression that this is the NEW way to go, and
> since we had no interface before we started with the most modern way to implement it.
> 
> TCP et al have a history with sysfs, so thats why it is still there. 
> But I might be wrong on that...

Thanks for the information that I don't know about the decision for new
control interface. I am understanding your decision about the interface.
We are glad to contribute the knobs to smc_netlink.c in the next patches.

There is something I want to discuss here about the persistent
configuration, we need to store new config in system, and make sure that
it could be loaded correctly after boot up. A possible solution is to
extend smc-tools for new config, and work with systemd for auto-loading.
If it works, we are glad to contribute these to smc-tools.

Thank you.
Tony Lu
