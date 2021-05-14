Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DC4381341
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhENVmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:42:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhENVmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 17:42:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4AF561440;
        Fri, 14 May 2021 21:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621028491;
        bh=lg9f35+rrDvlQ80sjhZslmyam9EprM+Wdim+Cuy6BzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SC+UYqlmKsMj+EKe2VWIis4q5efC0eOPSn30CvwLLpvMwcmYp1e5i1UYd/NBotwiN
         qRzf/mhAsjv5SKuV0gmJMoMNh+vOxDvKJoHryJ2i7OnytlppcYbiyiEHAcpw+9gOBO
         TERz6/FLrQ30czZLr84FNYOOMtWbcfedq0gzckKuRKEW9cSgJlWo1StTMcuffbFqTc
         c3xphyAu+UJhLt/bxlHlY/VFN/zFxI36USEAeP2gXlU5yXO6NRblKrKZ8ab//p/k55
         HCqjizGOic5Lq/BVU+xckt5o/dhkzr1aeGs6raJ4RUZB4VJrNbG4XTBcHQRrYa8IKf
         OmrmPse09S3xA==
Date:   Fri, 14 May 2021 14:41:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Michal Svec <msvec@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Thierry Reding <treding@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH RFC] r8152: Ensure that napi_schedule() is handled
Message-ID: <20210514144130.7287af8e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87fsyp2f8s.ffs@nanos.tec.linutronix.de>
References: <877dk162mo.ffs@nanos.tec.linutronix.de>
        <20210514123838.10d78c35@kicinski-fedora-PC1C0HJN>
        <87sg2p2hbl.ffs@nanos.tec.linutronix.de>
        <20210514134655.73d972cb@kicinski-fedora-PC1C0HJN>
        <87fsyp2f8s.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 May 2021 23:10:43 +0200 Thomas Gleixner wrote:
> On Fri, May 14 2021 at 13:46, Jakub Kicinski wrote:
> > On Fri, 14 May 2021 22:25:50 +0200 Thomas Gleixner wrote:  
> >> Except that some instruction cycle beancounters might complain about
> >> the extra conditional for the sane cases.
> >> 
> >> But yes, I'm fine with that as well. That's why this patch is marked RFC :)  
> >
> > When we're in the right context (irq/bh disabled etc.) the cost is just
> > read of preempt_count() and jump, right? And presumably preempt_count()
> > is in the cache already, because those sections aren't very long. Let me
> > make this change locally and see if it is in any way perceivable.  
> 
> Right. Just wanted to mention it :)
> 
> > Obviously if anyone sees a way to solve the problem without much
> > ifdefinery and force_irqthreads checks that'd be great - I don't.  
> 
> This is not related to force_irqthreads at all. This very driver invokes
> it from plain thread context.

I see, but a driver calling __napi_schedule_irqoff() from its IRQ
handler _would_ be an issue, right? Or do irq threads trigger softirq
processing on exit?

> > I'd rather avoid pushing this kind of stuff out to the drivers.  
> 
> You could have napi_schedule_intask() or something like that which would
> do the local_bh_disable()/enable() dance around the invocation of
> napi_schedule(). That would also document it clearly in the drivers. A
> quick grep shows a bunch of instances which could be replaced:
> 
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c-5704-		local_bh_disable();
> drivers/net/ethernet/mellanox/mlx4/en_netdev.c-1830-		local_bh_disable();
> drivers/net/usb/r8152.c-1552-	local_bh_disable();
> drivers/net/virtio_net.c-1355-	local_bh_disable();
> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-1650-	local_bh_disable();
> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2015-		local_bh_disable();
> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2225-		local_bh_disable();
> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2235-		local_bh_disable();
> drivers/s390/net/qeth_core_main.c-3515-	local_bh_disable();

Very well aware, I've just sent a patch for mlx5 last week :)

My initial reaction was the same as yours - we should add lockdep
check, and napi_schedule_intask(). But then I started wondering
if it's all for nothing on rt or with force_irqthreads, and therefore
we should just eat the extra check.
