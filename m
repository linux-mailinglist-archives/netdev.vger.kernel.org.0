Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFEC4C17D4
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242113AbiBWPzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242498AbiBWPzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:55:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FEAC24AA;
        Wed, 23 Feb 2022 07:55:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26C25B820C4;
        Wed, 23 Feb 2022 15:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3391BC340E7;
        Wed, 23 Feb 2022 15:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645631718;
        bh=pn0sQ7P9/1v/S2vg+chkjsn0VGfIaKHd6MtSPk1qjSI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L3PT8r0NYY1+xc/v3XSLp6zFyMsHLo/OKSmlowKHGM4k79bCJXG1tz4XOaZu0SBXP
         1daaKnbFuA0Z+s+i+x2Czf+miVPz7qIv5Jed9u6ryxnkhDhtiznICCT48GlEKsDuJq
         YU1W5IL4tosJN1z4IzIgoeHs0PcpF9NFLunQ1Eb5EXXZ2k3ISG6NtCVPu0y9Guhi4x
         dPzOFP0ZWid+47+St1/IopRPwhj63XFxG+K2mBVOdkvasqVU496GJ4fx4lmPN8JQa9
         pTB3ou4YKpy9rXbcaoVV7cakMqUTm/yHLihS5p9qwpRLl4trh+5BHZbLjniL0/ZMvT
         kuhG4xtokYe+w==
Date:   Wed, 23 Feb 2022 07:55:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@toke.dk>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@redhat.com>
Subject: Re: [PATCH net-next] net: Correct wrong BH disable in
 hard-interrupt.
Message-ID: <20220223075517.468dec75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YhXq18B1yCuSwun7@breakpoint.cc>
References: <Yg05duINKBqvnxUc@linutronix.de>
        <YhXq18B1yCuSwun7@breakpoint.cc>
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

On Wed, 23 Feb 2022 09:05:43 +0100 Sebastian Andrzej Siewior wrote:
> On 2022-02-16 18:50:46 [+0100], Sebastian Andrzej Siewior wrote:
> > I missed the obvious case where netif_ix() is invoked from hard-IRQ
> > context.
> > 
> > Disabling bottom halves is only needed in process context. This ensures
> > that the code remains on the current CPU and that the soft-interrupts
> > are processed at local_bh_enable() time.
> > In hard- and soft-interrupt context this is already the case and the
> > soft-interrupts will be processed once the context is left (at irq-exit
> > time).
> > 
> > Disable bottom halves if neither hard-interrupts nor soft-interrupts are
> > disabled. Update the kernel-doc, mention that interrupts must be enabled
> > if invoked from process context.
> > 
> > Fixes: baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
> > Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>  
> 
> This patch is marked as "Changes Requested" in patchwork. Could someone
> please explain?
> The USB/dwc3 fallout reported by Marek was addressed in 
>    usb: dwc3: gadget: Let the interrupt handler disable bottom halves.
>    https://lore.kernel.org/r/Yg/YPejVQH3KkRVd@linutronix.de
> 
> and is not a shortcoming in this patch but a problem in dwc3 that was
> just noticed.

Unclear, let me apply it now.
