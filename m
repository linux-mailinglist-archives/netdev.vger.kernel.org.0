Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E993812A6
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhENVL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:11:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39440 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhENVL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:11:57 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621026644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HuQvs+H+wjkT6I+2nUWTUWeXuTsNhwlXdcp3435Vxqw=;
        b=jFTDsdR4VeSzUAc9RTs4K8LqgnhX2+5Zg30oHaSRUTTN1IbzGqXHs/wmihLDimHSl3ojbd
        fFIek99KoE2Ozxl1T3Z4pWt5bZp8yKnUbwkvs77uOgBsMRbwo3sfsaOPTRXndJ7kOvTSGX
        TjcQJ3kqPPgumkLLYjVyYsYqYx+2nPsLY+P30CFyxs2C0RtMFKfGOYKys+jTprmvPnSS5s
        BmXrfQkArcp0qAbG5a9K9EyHI/cRsPzIxTBco0o50NPlANgMuSUO3ToW9w+9RvI7q9aqM6
        RkGo++IRHxrpwln4kxxcEnUlPL0Zuyc9ECZSUB0SwmkosYjCMbnM+pSDKvsGZA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621026644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HuQvs+H+wjkT6I+2nUWTUWeXuTsNhwlXdcp3435Vxqw=;
        b=W+TRZDgQ8NNM1DyfaLuyZJriSpmzC8a+b9HuwW3natPtRwAOnFguGcyk05vtxadvYW7evk
        ALG+W4WP62EiyRAQ==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Michal Svec <msvec@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Thierry Reding <treding@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH RFC] r8152: Ensure that napi_schedule() is handled
In-Reply-To: <20210514134655.73d972cb@kicinski-fedora-PC1C0HJN>
References: <877dk162mo.ffs@nanos.tec.linutronix.de> <20210514123838.10d78c35@kicinski-fedora-PC1C0HJN> <87sg2p2hbl.ffs@nanos.tec.linutronix.de> <20210514134655.73d972cb@kicinski-fedora-PC1C0HJN>
Date:   Fri, 14 May 2021 23:10:43 +0200
Message-ID: <87fsyp2f8s.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14 2021 at 13:46, Jakub Kicinski wrote:
> On Fri, 14 May 2021 22:25:50 +0200 Thomas Gleixner wrote:
>> Except that some instruction cycle beancounters might complain about
>> the extra conditional for the sane cases.
>> 
>> But yes, I'm fine with that as well. That's why this patch is marked RFC :)
>
> When we're in the right context (irq/bh disabled etc.) the cost is just
> read of preempt_count() and jump, right? And presumably preempt_count()
> is in the cache already, because those sections aren't very long. Let me
> make this change locally and see if it is in any way perceivable.

Right. Just wanted to mention it :)

> Obviously if anyone sees a way to solve the problem without much
> ifdefinery and force_irqthreads checks that'd be great - I don't.

This is not related to force_irqthreads at all. This very driver invokes
it from plain thread context.

> I'd rather avoid pushing this kind of stuff out to the drivers.

You could have napi_schedule_intask() or something like that which would
do the local_bh_disable()/enable() dance around the invocation of
napi_schedule(). That would also document it clearly in the drivers. A
quick grep shows a bunch of instances which could be replaced:

drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c-5704-		local_bh_disable();
drivers/net/ethernet/mellanox/mlx4/en_netdev.c-1830-		local_bh_disable();
drivers/net/usb/r8152.c-1552-	local_bh_disable();
drivers/net/virtio_net.c-1355-	local_bh_disable();
drivers/net/wireless/intel/iwlwifi/pcie/rx.c-1650-	local_bh_disable();
drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2015-		local_bh_disable();
drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2225-		local_bh_disable();
drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2235-		local_bh_disable();
drivers/s390/net/qeth_core_main.c-3515-	local_bh_disable();

Thanks,

        tglx
