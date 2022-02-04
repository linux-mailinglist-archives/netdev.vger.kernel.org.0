Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455394A91E7
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 02:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356381AbiBDBJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 20:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353229AbiBDBJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 20:09:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987CCC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 17:09:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35B7A617A7
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 01:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26ADC340E8;
        Fri,  4 Feb 2022 01:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643936943;
        bh=qc6ZxeqZJBwM62nlsHKZlN/Dqs+tYLgObSZzFwiBGKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CKeB84n/oAeD56o7up7I9RRsUXLQPO+fOSwQwMw+jw/FtKqrPvsX8uo8hqHTgcnvU
         /Qph/hdfWPt6xGBAlbnp5bnN91S5ysfMW7idaeRPI4stLz8VHTD9R9I5j5sZa/NxKL
         oMVjxhKQrAhsnqQUCr6kzHtXQsZg1TADDeE5NT92wQf/7JkAxhSMGxc+WBqESN8Ia0
         /t64NJlfvKTlenY9dIRBCZAxeWEOFtD6flwaXNX+lMfg+8P7nCWXQXuQbUTf2y+hNx
         xwUX4qpIXvCN0aUYJXrLzsIFOMP/IR3SWwp+ccx/9CMCka6bul5/QzHIYXgHJmEv6x
         XD3KjKNzyhhPw==
Date:   Thu, 3 Feb 2022 17:09:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
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
Message-ID: <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
        <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
        <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 00:40:41 +0100 Yannick Vignon wrote:
> Maybe some background on how I came to this would be helpful. I have 
> been chasing down sources of latencies in processing rx packets on a 
> PREEMPT_RT kernel and the stmmac driver. I observed that the main ones 
> were bh_dis/en sections, preventing even my high-prio, (force-)threaded 
> rx irq from being handled in a timely manner. Given that explicitly 
> threaded irq handlers were not enclosed in a bh_dis/en section, and that 
> from what I saw the stmmac interrupt handler didn't need such a 
> protection anyway, I modified the stmmac driver to request threaded 
> interrupts. This worked, safe for that "NOHZ" message: because 
> __napi_schedule was now called from a kernel thread context, the softirq 
> was no longer triggered.
> (note that the problem solves itself when enabling threaded NAPI)

Let's be clear that the problem only exists when switching to threaded
IRQs on _non_ PREEMPT_RT kernel (or old kernels). We already have a
check in __napi_schedule_irqoff() which should handle your problem on
PREEMPT_RT.

We should slap a lockdep warning for non-irq contexts in
____napi_schedule(), I think, it was proposed by got lost.
