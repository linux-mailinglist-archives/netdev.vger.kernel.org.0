Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15C14AE5CE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 01:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbiBIAQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 19:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiBIAQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 19:16:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66142C06157B
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 16:16:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E69BB81C15
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 00:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267BAC004E1;
        Wed,  9 Feb 2022 00:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644365783;
        bh=lRb+wFGp4vReTY/31pSkSwneJqrGARN+1oIWUtx6yM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r+F9f5qN7R5aZcx91obXE0OAU/ysA0d8lITfEQB2K/q/JvGOaqNIe7WZ7fzZiEToB
         IUNTmzlxNPIognf+vyc7mFEhJH69yBA8OKhfpE0BbanAeLn3s77bj37DXsrGzyDgJM
         onFqWcTT46q2sj95WvuCEQTgVVL5FulFIzqfJmz0hOC1RgaSTtia8nrMgHrJAGTJRh
         Rw/wxPb+W702hFmc6riedkEF8Ch7EJgYyzVjb+/fh/SDAK4Vq2zMIZjWSLL+OTzVIt
         UNYXTHE9tc1YPP+wR1fxGvzalHjRgbA22sZSWk0d4EpsJEvUNARoPXGFBDirI92wRq
         gOVlTBmQoZXfQ==
Date:   Tue, 8 Feb 2022 16:16:21 -0800
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
Message-ID: <20220208161621.7b40619b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YgKsUYJra2vtpRNZ@linutronix.de>
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
        <YgKsUYJra2vtpRNZ@linutronix.de>
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

On Tue, 8 Feb 2022 18:45:53 +0100 Sebastian Andrzej Siewior wrote:
> On 2022-02-08 07:35:20 [-0800], Jakub Kicinski wrote:
> > > If you enable threaded NAPI then you end up with a thread and the
> > > softirq is no longer used. I don't know what the next action is but I
> > > guess you search for that thread and pin it manually to CPU and assign a
> > > RT priority (probably, otherwise it will compete with other tasks for
> > > CPU resources).  
> > 
> > FWIW I don't think servers would want RT prio.  
> 
> but then the NAPI thread is treated the same way like your xz -9.

You'd either pin the workload away from the network processing cores 
or, if there's no pinning, prefer requests to run to completion to
achieve lower latency.

> > > Instead we could have
> > > 	request_threaded_irq(, handler_irq, handler_napi);
> > > 
> > > And we would have basically the same outcome. Except that handler_napi()
> > > runs that SCHED_FIFO/50 and has the same CPU affinity as the IRQ (and
> > > the CPU affinity is adjusted if the IRQ-affinity is changed).
> > > We would still have to work out the details what handler_irq() is
> > > allowed to do and how to handle one IRQ and multiple handler_napi().
> > > 
> > > If you wrap request_threaded_irq() in something like request_napi_irq()
> > > the you could switch between the former (softirq) and later (thread)
> > > based NAPI handling (since you have all the needed details).  
> > 
> > One use case to watch out for is drivers which explicitly moved 
> > to threaded NAPI because they want to schedule multiple threads 
> > (NAPIs) from a single IRQ to spread processing across more cores.  
> 
> the request_napi_irq() could have a sysfs switch (like we currently
> have).
> But you mentioned one IRQ and multiple NAPI threads, to distribute
> across core. The usual case is that you have one IRQ for a network queue
> and this network queue has one NAPI struct, right?
> 
> In the case where you would have one IRQ but two network queues, each
> with one NAPI struct? And then you use the napi-threads and pin manually
> queue-napi#1 to CPU#1 and queue-napi#2 to CPU#2 while the IRQ itself
> fires on CPU#1?

It was mt76, the WiFi driver, I looked in the morning and I think it
had a NAPI for Tx and 2 NAPIs for Rx. The scheduler can spread them
around. Felix will have the exact details.
