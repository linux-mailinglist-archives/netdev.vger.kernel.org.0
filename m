Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395334A5708
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiBAFmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiBAFmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:42:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A48C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 21:42:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3A2561482
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 05:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66ACCC340EB;
        Tue,  1 Feb 2022 05:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643694121;
        bh=WB08/LR2dg+e0cJ9SEimd/R7pFyv3SnlNg9ssAmgP0Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oc20MYGBGJdMnJBghpowejeXiFu3+VeIj5An53nwXdKcsUDnioe8/edjIlsqKQkjf
         FzBMw6+olrf5Yjl7TxPxbUpn2AijtS52TNM/6ZmKlUw/lEZRpYxbPyaISwaac0s9dW
         4Dxj0L5hTKwhrX/ZZsTLhQKywKVxpFxTSelI4kiR+0Fez9yIyTG4w2Fg5yJyAVxwfO
         +RXMPqBHZJjrYlmvYbVuaPa7YhvK5pbz0SOJG23fE0NZrAfLlbdUBkCerKpQ+KIXEB
         RTgX3Uym9uYZtKvyngdoFekp0Nu8UI98nFuuFEmQtYxC2euMY3mOFX4DWHbeWhmYXg
         gVwfK74WcMcsg==
Date:   Mon, 31 Jan 2022 21:42:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net-next] net: stmmac: optimize locking around PTP clock
 reads
Message-ID: <20220131214200.168f3c60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128170257.42094-1-yannick.vignon@oss.nxp.com>
References: <20220128170257.42094-1-yannick.vignon@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 18:02:57 +0100 Yannick Vignon wrote:
> Reading the PTP clock is a simple operation requiring only 2 register
> reads. Under a PREEMPT_RT kernel, protecting those reads by a spin_lock is
> counter-productive:
>  * if the task is preempted in-between the 2 reads, the return time value
> could become inconsistent,
>  * if the 2nd task preempting the 1st has a higher prio but needs to
> read time as well, it will require 2 context switches, which will pretty
> much always be more costly than just disabling preemption for the duration
> of the 2 reads.
> 
> Improve the above situation by:
> * replacing the PTP spinlock by a rwlock, and using read_lock for PTP
> clock reads so simultaneous reads do not block each other,

Are you sure the reads don't latch the other register? Otherwise this
code is buggy, it should check for wrap around. (e.g. during 1.99 ->
2.00 transition driver can read .99, then 2, resulting in 2.99).

> * protecting the register reads by local_irq_save/local_irq_restore, to
> ensure the code is not preempted between the 2 reads, even with PREEMPT_RT.

>  	/* Get the TSSS value */
>  	ns = readl(ioaddr + PTP_STNSR);
>  	/* Get the TSS and convert sec time value to nanosecond */
>  	ns += readl(ioaddr + PTP_STSR) * 1000000000ULL;
