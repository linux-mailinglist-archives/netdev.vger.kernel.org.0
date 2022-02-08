Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E094ADFDC
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384385AbiBHRp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiBHRp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:45:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9847BC061578
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 09:45:56 -0800 (PST)
Date:   Tue, 8 Feb 2022 18:45:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644342355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qt3AyHRcsLhI5VSxFVnX6zjGPLVMnO3EiXn9j2bxVH4=;
        b=Dv5/9GeRLpOBoPhhrUgNZYANg6K9DDcEjJRzFFJeZ7oDQJvJ/FQkERByGNsTZzEQbpOR58
        5IoUqFAjzGcYDvTdhyGzA9ga/X+TE4XGQOK4HkAfFc89c9syEBVtiX7ig2zvfzkCZ9ffzr
        bdq49GMaI66F5uMllU/9OmPi/eM+JW95XkRaF+98zgOZVWizwNunrorMhrqOPD9SP2npFI
        DgFAyn3W2TlPfOA0ijRU4Bj5s2x175iCeL9Y+zblze1YCHZFBpQPcwzfFDsy7fG7+7wXBo
        DO7IKm2SRIALSJCyF9JtFk+Ku06G9Ky1idyLF0+CRChqdMLauiUFdyUYzSKnPA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644342355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qt3AyHRcsLhI5VSxFVnX6zjGPLVMnO3EiXn9j2bxVH4=;
        b=PMqLd9B1Qem8vEiJwl47NihyjwI2mvfvEQSU7bIIXPpKwfswOaelrSuHJQM9Gm/ne1fwBX
        jgwq7uABpocl1iBA==
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
Message-ID: <YgKsUYJra2vtpRNZ@linutronix.de>
References: <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
 <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YfzhioY0Mj3M1v4S@linutronix.de>
 <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
 <20220204094522.4a233a2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Yf1qc7R5rFoALsCo@linutronix.de>
 <20220204105035.4e207e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YgJZK42urDmKQfgf@linutronix.de>
 <20220208073520.7197d638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220208073520.7197d638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-08 07:35:20 [-0800], Jakub Kicinski wrote:
> > If you enable threaded NAPI then you end up with a thread and the
> > softirq is no longer used. I don't know what the next action is but I
> > guess you search for that thread and pin it manually to CPU and assign a
> > RT priority (probably, otherwise it will compete with other tasks for
> > CPU resources).
> 
> FWIW I don't think servers would want RT prio.

but then the NAPI thread is treated the same way like your xz -9.

> > Instead we could have
> > 	request_threaded_irq(, handler_irq, handler_napi);
> > 
> > And we would have basically the same outcome. Except that handler_napi()
> > runs that SCHED_FIFO/50 and has the same CPU affinity as the IRQ (and
> > the CPU affinity is adjusted if the IRQ-affinity is changed).
> > We would still have to work out the details what handler_irq() is
> > allowed to do and how to handle one IRQ and multiple handler_napi().
> > 
> > If you wrap request_threaded_irq() in something like request_napi_irq()
> > the you could switch between the former (softirq) and later (thread)
> > based NAPI handling (since you have all the needed details).
> 
> One use case to watch out for is drivers which explicitly moved 
> to threaded NAPI because they want to schedule multiple threads 
> (NAPIs) from a single IRQ to spread processing across more cores.

the request_napi_irq() could have a sysfs switch (like we currently
have).
But you mentioned one IRQ and multiple NAPI threads, to distribute
across core. The usual case is that you have one IRQ for a network queue
and this network queue has one NAPI struct, right?

In the case where you would have one IRQ but two network queues, each
with one NAPI struct? And then you use the napi-threads and pin manually
queue-napi#1 to CPU#1 and queue-napi#2 to CPU#2 while the IRQ itself
fires on CPU#1?

Sebastian
