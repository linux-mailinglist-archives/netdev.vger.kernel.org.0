Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5E04AD7EA
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 12:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355764AbiBHLv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 06:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358725AbiBHLvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 06:51:12 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FBFC07D6BD
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 03:51:11 -0800 (PST)
Date:   Tue, 8 Feb 2022 12:51:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644321069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rgNB8V1G/BsnpTc2CQlRvrgoKfGkEHXkXK7IiCgvNUY=;
        b=1ybtIjSlrmP5X6ol4givI83H38Om5blSGBytUzuzef9hmgNKDS/+PaM1PCiNAbMGOYbdoX
        3zgy2rEUBVfkfYj3aMVkigtyifN9XZ4UEg9kiKWPYWqPhpRQhh6OQ4yP0UpvrxIqEctXbm
        TY7KkyZgYe2wsRdxGQEZIM8+U7lnTgSfGzWaCjJs1UriORVV5yPGbRL1hjCk7bOhh3K/Is
        VpfertWTlpO2tqgF/Dx9ePqLK6yXInNmDhBZESRic+TfjVjPDfuByVewtcyenZqGf5HQP6
        VPVr0pWObqtOkbwTFRJZWCgkLNnJulWt2/X+XgpS0lncmSz/82aLmfAt9fLcQw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644321069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rgNB8V1G/BsnpTc2CQlRvrgoKfGkEHXkXK7IiCgvNUY=;
        b=u3RtzFDpH43zwZu3Ij+EgOKObTMVhwpA8WhjeGOmbHIgJAnjwwWQ8q0hyfv3EvKtDbs3vm
        nbimLm99510SzpCw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
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
Message-ID: <YgJZK42urDmKQfgf@linutronix.de>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220204105035.4e207e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-04 10:50:35 [-0800], Jakub Kicinski wrote:
> On Fri, 4 Feb 2022 19:03:31 +0100 Sebastian Andrzej Siewior wrote:
> > On 2022-02-04 09:45:22 [-0800], Jakub Kicinski wrote:
> > > Coincidentally, I believe the threaded NAPI wake up is buggy - 
> > > we assume the thread is only woken up when NAPI gets scheduled,
> > > but IIUC signal delivery and other rare paths may wake up kthreads,
> > > randomly.  
> > 
> > I had to look into NAPI-threads for some reason.
> > What I dislike is that after enabling it via sysfs I have to:
> > - adjust task priority manual so it is preferred over other threads.
> >   This is usually important on RT. But then there is no overload
> >   protection.
> > 
> > - set an affinity-mask for the thread so it does not migrate from one
> >   CPU to the other. This is worse for a RT task where the scheduler
> >   tries to keep the task running.
> > 
> > Wouldn't it work to utilize the threaded-IRQ API and use that instead
> > the custom thread? Basically the primary handler would what it already
> > does (disable the interrupt) and the threaded handler would feed packets
> > into the stack. In the overload case one would need to lower the
> > thread-priority.
> 
> Sounds like an interesting direction if you ask me! That said I have
> not been able to make threaded NAPI useful in my experiments / with my
> workloads so I'd defer to Wei for confirmation.
> 
> To be clear -- are you suggesting that drivers just switch to threaded
> NAPI, or a more dynamic approach where echo 1 > /proc/irq/$n/threaded
> dynamically engages a thread in a generic fashion?

Uhm, kind of, yes.

Now you have
	request_irq(, handler_irq);
	netif_napi_add(, , handler_napi);

The handler_irq() disables the interrupt line and schedules the softirq
to process handler_napi(). Once handler_napi() is it re-enables the
interrupt line otherwise it will be processed again on the next tick.

If you enable threaded NAPI then you end up with a thread and the
softirq is no longer used. I don't know what the next action is but I
guess you search for that thread and pin it manually to CPU and assign a
RT priority (probably, otherwise it will compete with other tasks for
CPU resources).

Instead we could have
	request_threaded_irq(, handler_irq, handler_napi);

And we would have basically the same outcome. Except that handler_napi()
runs that SCHED_FIFO/50 and has the same CPU affinity as the IRQ (and
the CPU affinity is adjusted if the IRQ-affinity is changed).
We would still have to work out the details what handler_irq() is
allowed to do and how to handle one IRQ and multiple handler_napi().

If you wrap request_threaded_irq() in something like request_napi_irq()
the you could switch between the former (softirq) and later (thread)
based NAPI handling (since you have all the needed details).

Sebastian
