Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D4623B23E
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgHDBVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgHDBVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:21:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94CDC06174A;
        Mon,  3 Aug 2020 18:21:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCD061278B058;
        Mon,  3 Aug 2020 18:05:00 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:21:45 -0700 (PDT)
Message-Id: <20200803.182145.2300252460016431673.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        ioana.ciornei@nxp.com, Jiafei.Pan@nxp.com, yangbo.lu@nxp.com,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] enetc: use napi_schedule to be compatible
 with PREEMPT_RT
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803201009.613147-2-olteanv@gmail.com>
References: <20200803201009.613147-1-olteanv@gmail.com>
        <20200803201009.613147-2-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 18:05:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon,  3 Aug 2020 23:10:09 +0300

> From: Jiafei Pan <Jiafei.Pan@nxp.com>
> 
> The driver calls napi_schedule_irqoff() from a context where, in RT,
> hardirqs are not disabled, since the IRQ handler is force-threaded.
> 
> In the call path of this function, __raise_softirq_irqoff() is modifying
> its per-CPU mask of pending softirqs that must be processed, using
> or_softirq_pending(). The or_softirq_pending() function is not atomic,
> but since interrupts are supposed to be disabled, nobody should be
> preempting it, and the operation should be safe.
> 
> Nonetheless, when running with hardirqs on, as in the PREEMPT_RT case,
> it isn't safe, and the pending softirqs mask can get corrupted,
> resulting in softirqs being lost and never processed.
> 
> To have common code that works with PREEMPT_RT and with mainline Linux,
> we can use plain napi_schedule() instead. The difference is that
> napi_schedule() (via __napi_schedule) also calls local_irq_save, which
> disables hardirqs if they aren't already. But, since they already are
> disabled in non-RT, this means that in practice we don't see any
> measurable difference in throughput or latency with this patch.
> 
> Signed-off-by: Jiafei Pan <Jiafei.Pan@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied.
