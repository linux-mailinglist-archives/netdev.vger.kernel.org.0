Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 588AE12863A
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 01:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLUAyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 19:54:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfLUAyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 19:54:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3EE2152F9C6C;
        Fri, 20 Dec 2019 16:54:48 -0800 (PST)
Date:   Fri, 20 Dec 2019 16:54:46 -0800 (PST)
Message-Id: <20191220.165446.1167328110197614173.davem@davemloft.net>
To:     dust.li@linux.alibaba.com
Cc:     xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        john.fastabend@gmail.com, jiri@resnulli.us,
        tonylu@linux.alibaba.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: sched: unify __gnet_stats_copy_xxx()
 for percpu and non-percpu
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217084718.52098-1-dust.li@linux.alibaba.com>
References: <20191217084718.52098-1-dust.li@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 16:54:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dust Li <dust.li@linux.alibaba.com>
Date: Tue, 17 Dec 2019 16:47:16 +0800

> Currently, __gnet_stats_copy_xxx() will overwrite the return value when
> percpu stats are not enabled. But when percpu stats are enabled, it will
> add the percpu stats to the result. This inconsistency brings confusion to
> its callers.
> 
> This patch series unify the behaviour of __gnet_stats_copy_basic() and
> __gnet_stats_copy_queue() for percpu and non-percpu stats and fix an
> incorrect statistic for mqprio class.
> 
> - Patch 1 unified __gnet_stats_copy_xxx() for both percpu and non-percpu
> - Patch 2 depending on Patch 1, fixes the problem that 'tc class show'
>   for mqprio class is always 0.

I think this is going to break the estimator.

The callers of est_fetch_counters() expect continually incrementing
statistics.  It does relative subtractions from previous values each
time, so if we just reset on the next statistics fetch it won't work.

Sorry I can't apply this.
