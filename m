Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCBC381449
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhENXhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhENXhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 19:37:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DC3B61350;
        Fri, 14 May 2021 23:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621035386;
        bh=Go/6KJ1kVVTERD5P3YSzXrLX9Sd49Yljjv6pAwBuSOM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P7zHogRt3aZgGkSgK9LRssmr73C0H8VPL8C/xRIEq7+F0mQFjjNWGcP7vKsEH7GV1
         rBZjQ5ldYBEX6Ir4+EfJtJhHaTwlbuiR0IBnNc1NfwgUOwlks0WxM5nd6eXTgxb27i
         dsZciWebRAp9Y8BmNXln5CkZj1JuiMRpwN2/SW2NY+CzrkjSoWrgK6xBxQqn9GIMfI
         3psFWWbiVW6d0/xiOTOpzBDSx8zWzsnlF43HLFyINYFLd7K3vx2MhMmOlCCLfIbrRl
         oUVYycjyHxFgZCcvizBej6mC06ytlRClirdCpcc+Q8AMtdbkvMbHXPIpT7nY6xU9o5
         r627jDYAvnCeA==
Date:   Fri, 14 May 2021 16:36:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Michal Svec <msvec@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Thierry Reding <treding@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH RFC] r8152: Ensure that napi_schedule() is handled
Message-ID: <20210514163625.404f1f04@kicinski-fedora-PC1C0HJN>
In-Reply-To: <871ra83nop.ffs@nanos.tec.linutronix.de>
References: <877dk162mo.ffs@nanos.tec.linutronix.de>
        <20210514123838.10d78c35@kicinski-fedora-PC1C0HJN>
        <87sg2p2hbl.ffs@nanos.tec.linutronix.de>
        <20210514134655.73d972cb@kicinski-fedora-PC1C0HJN>
        <87fsyp2f8s.ffs@nanos.tec.linutronix.de>
        <20210514144130.7287af8e@kicinski-fedora-PC1C0HJN>
        <871ra83nop.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 May 2021 01:23:02 +0200 Thomas Gleixner wrote:
> On Fri, May 14 2021 at 14:41, Jakub Kicinski wrote:
> >> This is not related to force_irqthreads at all. This very driver invokes
> >> it from plain thread context.  
> >
> > I see, but a driver calling __napi_schedule_irqoff() from its IRQ
> > handler _would_ be an issue, right? Or do irq threads trigger softirq
> > processing on exit?  
> 
> Yes, they do. See irq_forced_thread_fn(). It has a local_bh_disable() /
> local_bh_ enable() pair around the invocation to ensure that.

Ah, excellent!

> >> You could have napi_schedule_intask() or something like that which would
> >> do the local_bh_disable()/enable() dance around the invocation of
> >> napi_schedule(). That would also document it clearly in the drivers. A
> >> quick grep shows a bunch of instances which could be replaced:
> >> 
> >> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c-5704-		local_bh_disable();
> >> drivers/net/ethernet/mellanox/mlx4/en_netdev.c-1830-		local_bh_disable();
> >> drivers/net/usb/r8152.c-1552-	local_bh_disable();
> >> drivers/net/virtio_net.c-1355-	local_bh_disable();
> >> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-1650-	local_bh_disable();
> >> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2015-		local_bh_disable();
> >> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2225-		local_bh_disable();
> >> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2235-		local_bh_disable();
> >> drivers/s390/net/qeth_core_main.c-3515-	local_bh_disable();  
> >
> > Very well aware, I've just sent a patch for mlx5 last week :)
> >
> > My initial reaction was the same as yours - we should add lockdep
> > check, and napi_schedule_intask(). But then I started wondering
> > if it's all for nothing on rt or with force_irqthreads, and therefore
> > we should just eat the extra check.  
> 
> We can make that work but sure I'm not going to argue when you decide to
> just go for raise_softirq_irqsoff().
> 
> I just hacked that check up which is actually useful beyond NAPI. It's
> straight forward except for that flush_smp_call_function_from_idle()
> oddball, which immeditately triggered that assert because block mq uses
> __raise_softirq_irqsoff() in a smp function call...
> 
> See below. Peter might have opinions though :)

Looks good to me, since my thinking that RT complicates things here was
wrong I'm perfectly happy with the lockdep + napi_schedule_intask().
