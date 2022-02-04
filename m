Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A8B4A9DB5
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376924AbiBDRgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376906AbiBDRgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:36:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D135C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 09:36:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD3A661A3E
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 17:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CFEC004E1;
        Fri,  4 Feb 2022 17:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643996182;
        bh=FlSMt1E6jjdV2Q2wOFggV7eIQ0/8QLnNeLgsDQaPu1w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oWrCLQXOtkiACeLGmW8/i29Jo5gfc2e3i+M8f2/16m/OH3+XXEkxG/gb5xmyCf4m0
         4iwWQW52axJESzJB05hElSpwlMCUYUnIjOPRT7G6lhDc3dCr57rrkvUeKJAQILMqdP
         51tlP+oUepKx2zzUV2Poy4xUXHyvYBabu8ME6hvIlTXj6H/8BRglRbENAOAzWrSHj6
         vpDqka0nNnT8DlTSgOFW1ChnmJjThNgt3a0ZJS9zlDSDK2x1/xMY/3DyvauQ3q42rW
         qFa/iprkBD4pJc4h9T/13o00/rISdlat0d3dcjmXiF/zimIzrTMo0Gb18ryC5OmSmo
         t2q4HLZvSf/3Q==
Date:   Fri, 4 Feb 2022 09:36:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
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
Message-ID: <20220204093619.665c46ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
        <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
        <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
        <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YfzhioY0Mj3M1v4S@linutronix.de>
        <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 18:15:40 +0100 Yannick Vignon wrote:
> >> Be aware that this (the first assert) will trigger in dev_cpu_dead() and
> >> needs a bh-off/on around. I should have something in my RT tree :)  
> > 
> > Or we could push the asserts only into the driver-facing helpers
> > (__napi_schedule(), __napi_schedule_irqoff()).  
> 
> As I explained above, everything is working fine when using threaded 
> NAPI. Why then forbid such a use case?
> 
> How about something like this instead:
> in the (stmmac) threaded interrupt handler:
> if (test_bit(NAPI_STATE_THREADED, &napi->state))
> 	__napi_schedule();
> else {
> 	local_bh_disable();
> 	__napi_schedule();
> 	local_bh_enable();
> }

Looks slightly racy, we check the bit again in ____napi_schedule() and
it may change in between.

> Then in __napi_schedule, add the lockdep checks, but __below__ the "if 
> (threaded) { ... }" block.
> 
> Would that be an acceptable change? Because really, the whole point of 
> my patchqueue is to remove latencies imposed on network interrupts by 
> bh_disable/enable sections. If moving to explicitly threaded IRQs means 
> the bh_disable/enable section is simply moved down the path and around 
> __napi_schedule, there is just no point.

IMHO seems reasonable as long as it's coded up neatly.
