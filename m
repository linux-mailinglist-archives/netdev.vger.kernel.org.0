Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9744A8CA0
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353698AbiBCTmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:42:02 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55252 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353266AbiBCTmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:42:01 -0500
Date:   Thu, 3 Feb 2022 20:41:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643917320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s/tIP5S8a4jTxaN1sTfBrRBLHSCzarkR2Glrn1WV9GM=;
        b=drNznNXc/lxL4NHE6RokBsx19dtvp7mQqWy6vkY/dOn12nrORRjYdrgHitBKk5cK+AdK2D
        Vq+E1xjcfgyxXVMza3nicJzcTvza1wDAg1S4hcBldl+O32ozJX94DZqYAoscBDQNQfEjrM
        NaORzpMwHTDOXbt6h4gN/DZqgMMVTwOi8ZRpdFQ6sQtzmygMDOxXhw+FJY83t0LOVfrQSc
        tF/GlPoavUrpAwexOcdXyEKnknraVYKMns44DPMjl1zfU7vi+a4XHIb5hNMcIow9BebkQd
        beyzpa4Tpa1PRrUJN6tcGsOvJ4yD+scYETjVzv6ZKeSgJdpJJiyiTIgWNH255A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643917320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s/tIP5S8a4jTxaN1sTfBrRBLHSCzarkR2Glrn1WV9GM=;
        b=7iBcdvEeiZ2qqHDdkS1VKlc9nle9is+W3c23pEacj2WWdaASm0ATH8IuXk+PbawkKFb3ys
        xuFC57yUsvXFioAg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed
 after scheduling NAPI
Message-ID: <YfwwBvO2+xVjer/+@linutronix.de>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-03 19:40:30 [+0100], Yannick Vignon wrote:
> From: Yannick Vignon <yannick.vignon@nxp.com>
> 
> If NAPI was not scheduled from interrupt or softirq,
> __raise_softirq_irqoff would mark the softirq pending, but not
> wake up ksoftirqd. With force threaded IRQs, this is
> compensated by the fact that the interrupt handlers are
> protected inside a local_bh_disable()/local_bh_enable()

This is not compensated but one of the reasons why it has been added.

> section, and bh_enable will call do_softirq if needed. With
> normal threaded IRQs however, this is no longer the case
> (unless the interrupt handler itself calls local_bh_enable()),

Exactly.

> whic results in a pending softirq not being handled, and the
> following message being printed out from tick-sched.c:
> "NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #%02x!!!\n"

Yes. This also includes various other call sites.

> Call raise_softirq_irqoff instead to make sure ksoftirqd is
> woken up in such a case, ensuring __napi_schedule, etc behave
> normally in more situations than just from an interrupt,
> softirq or from within a bh_disable/bh_enable section.

I would suggest to add a bh dis/en around the function that is known to
raise BH. This change to ____napi_schedule() as you suggest will raise
ksoftirqd and is not what you want. What you want is to process NAPI in
your current context.

> Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>

Sebastian
