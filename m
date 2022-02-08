Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D794ADCC8
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380405AbiBHPfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380534AbiBHPfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:35:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1022C06157B
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 07:35:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 640C1615D8
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 15:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB25C004E1;
        Tue,  8 Feb 2022 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644334522;
        bh=t+3kJOf8O7+AaYFgf1i8soy6PLrQrsBbW9fvPOW7ktU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XH3eza25RSQyuHb2FKvkMCKjixSlwahFmxfwe805U5SbtCeh8+Ned560gW4t+WmL7
         4ZB9e4RgCZXidkxV+Chq3o+121/iU6ohHxkuSVddzaqHKQLavKN4YkbXIo59ftVfeT
         6Rbg3cRRS280/DqGh0IGPQ8WcNwUXll0gWGevYaVR6J8BfFLeFzvsWMenJhMq7fH0j
         0H3lunWWVfQVh0GS+dbN4jrurLnG1eVCfWvTJfNjbvK8RqirQaz79BHquPNl58bSju
         V5e+C4yHaqAdHbqiTQnzCgihC3C8WJNbDKxzF6Wj3DySudwM6e0TLJ7FnzWyv7XvvM
         W/RX345IyxTYA==
Date:   Tue, 8 Feb 2022 07:35:20 -0800
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
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed
 after scheduling NAPI
Message-ID: <20220208073520.7197d638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YgJZK42urDmKQfgf@linutronix.de>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
        <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
        <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
        <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YfzhioY0Mj3M1v4S@linutronix.de>
        <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
        <20220204094522.4a233a2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yf1qc7R5rFoALsCo@linutronix.de>
        <20220204105035.4e207e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YgJZK42urDmKQfgf@linutronix.de>
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

On Tue, 8 Feb 2022 12:51:07 +0100 Sebastian Andrzej Siewior wrote:
> On 2022-02-04 10:50:35 [-0800], Jakub Kicinski wrote:
> > On Fri, 4 Feb 2022 19:03:31 +0100 Sebastian Andrzej Siewior wrote:  
> > > I had to look into NAPI-threads for some reason.
> > > What I dislike is that after enabling it via sysfs I have to:
> > > - adjust task priority manual so it is preferred over other threads.
> > >   This is usually important on RT. But then there is no overload
> > >   protection.
> > > 
> > > - set an affinity-mask for the thread so it does not migrate from one
> > >   CPU to the other. This is worse for a RT task where the scheduler
> > >   tries to keep the task running.
> > > 
> > > Wouldn't it work to utilize the threaded-IRQ API and use that instead
> > > the custom thread? Basically the primary handler would what it already
> > > does (disable the interrupt) and the threaded handler would feed packets
> > > into the stack. In the overload case one would need to lower the
> > > thread-priority.  
> > 
> > Sounds like an interesting direction if you ask me! That said I have
> > not been able to make threaded NAPI useful in my experiments / with my
> > workloads so I'd defer to Wei for confirmation.
> > 
> > To be clear -- are you suggesting that drivers just switch to threaded
> > NAPI, or a more dynamic approach where echo 1 > /proc/irq/$n/threaded
> > dynamically engages a thread in a generic fashion?  
> 
> Uhm, kind of, yes.
> 
> Now you have
> 	request_irq(, handler_irq);
> 	netif_napi_add(, , handler_napi);
> 
> The handler_irq() disables the interrupt line and schedules the softirq
> to process handler_napi(). Once handler_napi() is it re-enables the
> interrupt line otherwise it will be processed again on the next tick.
> 
> If you enable threaded NAPI then you end up with a thread and the
> softirq is no longer used. I don't know what the next action is but I
> guess you search for that thread and pin it manually to CPU and assign a
> RT priority (probably, otherwise it will compete with other tasks for
> CPU resources).

FWIW I don't think servers would want RT prio.

> Instead we could have
> 	request_threaded_irq(, handler_irq, handler_napi);
> 
> And we would have basically the same outcome. Except that handler_napi()
> runs that SCHED_FIFO/50 and has the same CPU affinity as the IRQ (and
> the CPU affinity is adjusted if the IRQ-affinity is changed).
> We would still have to work out the details what handler_irq() is
> allowed to do and how to handle one IRQ and multiple handler_napi().
> 
> If you wrap request_threaded_irq() in something like request_napi_irq()
> the you could switch between the former (softirq) and later (thread)
> based NAPI handling (since you have all the needed details).

One use case to watch out for is drivers which explicitly moved 
to threaded NAPI because they want to schedule multiple threads 
(NAPIs) from a single IRQ to spread processing across more cores.
