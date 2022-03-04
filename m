Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8B64CD534
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238312AbiCDNdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238102AbiCDNdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:33:50 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FCB1B718A;
        Fri,  4 Mar 2022 05:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jTtxcMJuXjpA8P+/ddsXhMdcxGXkQCXXk60N3KDtvFw=; b=bh51cjk0KOAk4XNPbv/pWvWeVi
        IOe2heuaW/ompLh9scL2n9D5WWEjHQv3RvvL18uPF1C3QIPtaW7I8yRRfBpiFGUC+Mjgb3bnY04aF
        5lXOLpp+1TZj9kyKmKKftFfrJCm+wT06jBMQKUVs3BqTkQ0JN76kR0u0qdZSROt24cDQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQ83F-009Ebc-G8; Fri, 04 Mar 2022 14:32:57 +0100
Date:   Fri, 4 Mar 2022 14:32:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        David Miller <davem@davemloft.net>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH v2] net: ethernet: sun: Remove redundant code
Message-ID: <YiIVCVnY6K5FQwVm@lunn.ch>
References: <20220304083653.66238-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304083653.66238-1-jiapeng.chong@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 04:36:53PM +0800, Jiapeng Chong wrote:
> Since the starting value in the for loop is greater than or equal to 1,
> the restriction is CAS_FLAG_REG_PLUS is in the file cassini.h is
> defined as 0x1 by macro, and the for loop and if condition is not
> satisfied, so the code here is redundant.

This still does not make much sense. Too late, David has merged it.

Taking a deeper look, we see:

https://elixir.bootlin.com/linux/v5.17-rc6/source/drivers/net/ethernet/sun/cassini.h#L2542
#define N_RX_COMP_RINGS               0x1 /* for mult. PCI interrupts */

So what the bot is reporting:

> drivers/net/ethernet/sun/cassini.c:3513 cas_start_dma() warn: we never
> enter this loop.
> 
> drivers/net/ethernet/sun/cassini.c:1239 cas_init_rx_dma() warn: we never
> enter this loop.
> 
> drivers/net/ethernet/sun/cassini.c:1247 cas_init_rx_dma() warn: we never
> enter this loop.
> 
> -	if (cp->cas_flags & CAS_FLAG_REG_PLUS) {
> -		for (i = 1; i < N_RX_COMP_RINGS; i++)
> -			readl(cp->regs + REG_PLUS_INTRN_STATUS_ALIAS(i));

has nothing to do with CAS_FLAG_REG_PLUS, which you say in your commit
message. It has to do with N_RX_COMP_RINGS. 

So you have 'fixed' a bots warning by removing code which cannot be
used. But is this the correct fix? Or has the bot actually found a
bug? Don't you think somebody wrote this code expecting it to be used?
Or do you think people write extra code which will never be used for
fun?

Looking at the git history, this code was actually written by DaveM.

Dave, this very old code, do you still remember this hardware? Bug or
dead code?

     Andrew
