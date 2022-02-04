Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF504A9F82
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377792AbiBDSuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:50:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34728 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377784AbiBDSui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:50:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6474461C3D
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 18:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89E9C004E1;
        Fri,  4 Feb 2022 18:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644000637;
        bh=8mPtbwOIZwq2yt6iTtPwDTwnhtfMp3EJj1NVM3nxTP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kUuO/8xp3AsB+hAXr2WgzxOLECZ8JcvsdBt+NROIJ88ifK0MH0RvDXG8blGUFrZn/
         G2i6S0im+WZHhuaxFs3KrY2l+Z6ld41GIW34vO4qNJTrgMdNc9bl2uGGZJF64uKauO
         UWjj3cuwsbWYcJwKmg1U5z/f2ZISWOW6vpcIqfjhYKGVsi8W3FZf3+Tbx8KkmZbY9b
         RJN7VJd/u/F2SGqRo/MhpmSZmTxYbs3C7EeecUN9t9WsrgvBvdBKm0Oeow5+Nkiot6
         ENDm6+YCHO4eE4IIU5ClRU+/2bxyGtULR80EYRyLbaxy9gDISCIavOjICv4EofAexY
         kPODHo2KzmaNw==
Date:   Fri, 4 Feb 2022 10:50:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed
 after scheduling NAPI
Message-ID: <20220204105035.4e207e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yf1qc7R5rFoALsCo@linutronix.de>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
        <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
        <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
        <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YfzhioY0Mj3M1v4S@linutronix.de>
        <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
        <20220204094522.4a233a2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yf1qc7R5rFoALsCo@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 19:03:31 +0100 Sebastian Andrzej Siewior wrote:
> On 2022-02-04 09:45:22 [-0800], Jakub Kicinski wrote:
> > Coincidentally, I believe the threaded NAPI wake up is buggy - 
> > we assume the thread is only woken up when NAPI gets scheduled,
> > but IIUC signal delivery and other rare paths may wake up kthreads,
> > randomly.  
> 
> I had to look into NAPI-threads for some reason.
> What I dislike is that after enabling it via sysfs I have to:
> - adjust task priority manual so it is preferred over other threads.
>   This is usually important on RT. But then there is no overload
>   protection.
> 
> - set an affinity-mask for the thread so it does not migrate from one
>   CPU to the other. This is worse for a RT task where the scheduler
>   tries to keep the task running.
> 
> Wouldn't it work to utilize the threaded-IRQ API and use that instead
> the custom thread? Basically the primary handler would what it already
> does (disable the interrupt) and the threaded handler would feed packets
> into the stack. In the overload case one would need to lower the
> thread-priority.

Sounds like an interesting direction if you ask me! That said I have
not been able to make threaded NAPI useful in my experiments / with my
workloads so I'd defer to Wei for confirmation.

To be clear -- are you suggesting that drivers just switch to threaded
NAPI, or a more dynamic approach where echo 1 > /proc/irq/$n/threaded
dynamically engages a thread in a generic fashion?
