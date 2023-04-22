Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52C46EB6EB
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 04:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjDVC57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 22:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVC56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 22:57:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC0A1FF3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 19:57:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 041AC6526C
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 02:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC14EC433EF;
        Sat, 22 Apr 2023 02:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682132276;
        bh=3/aeWPR/Z6Wr1zxdytuHA+3aGBTGu8bVrAGRSKr31kU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BeTxiXT+3/CvaR0ttI06GXSRPTYcifa8l8SRwmJ/q0NVSmBzHLVKdgFfqEfwL1RQs
         KZqztSZFp9wQF4vQ9ehb0z4DCWUPV3cehW7ET16nqVvugoekOeP9PT2IX9RNRpQGIj
         mTAD31l6hdTvHvJSAzu6nuzfbuvmC8Q6hsxc6cXmuIkiTjHPzKtOARdrbUKFs/upr+
         AllrPDmOw9tnPaoeyiVogcGJmvBavq+0MKycxBlxYtXFZtJyYXuM9Qd051S66XBmde
         pp4biuVkYQMyqqOXnN9BC2UeXVVxTBqVSJgc0lL/xvR/ED8UufcFGHy2YB6GNufu29
         Wn3N9iiBo2ffg==
Date:   Fri, 21 Apr 2023 19:57:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ingo Rohloff <ingo.rohloff@lauterbach.com>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Lars-Peter Clausen <lars@metafoo.de>,
        robert.hancock@calian.com, Nicolas.Ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, tomas.melin@vaisala.com
Subject: Re: [PATCH v2 1/1] net: macb: Avoid erroneously stopped TX ring.
Message-ID: <20230421195755.5e59a164@kernel.org>
In-Reply-To: <20230421130035.14346-2-ingo.rohloff@lauterbach.com>
References: <20230421130035.14346-1-ingo.rohloff@lauterbach.com>
        <20230421130035.14346-2-ingo.rohloff@lauterbach.com>
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

On Fri, 21 Apr 2023 15:00:35 +0200 Ingo Rohloff wrote:
> The SW puts a frame to be transmitted into the TX descriptor ring with
> macb_start_xmit().
> The last step of this operation is, that the SW clears the TX_USED bit
> of the first descriptor it wrote.
> The HW already reached and read this descriptor with a set TX_USED bit.
> The SW sets the TSTART bit in the NCR register.
> This is a race condition:
> 1) Either the HW already has processed the descriptor and has stopped the
>    transmission, so the TGO bit in the TSR register is cleared.
> 2) The HW has read, but not yet processed the descriptor.
> In case 2) the HW ignores the TSTART trigger and stops the
> transmission a little bit later.
> 
> You now have got a TX descriptor in the TX ring which is ready (TX_USED
> bit cleared), but the hardware does not process the fresh descriptor,
> because it ignored the corresponding TSTART trigger.
> 
> This patch checks if the hardware is processing the same descriptor, where
> the TX_USED bit was just cleared.
> If this is the case this patch ensures that the TSTART trigger is repeated
> if needed.

Were you able to measure the performance impact of the workaround?
Doesn't name a difference?

> +static void macb_fix_tstart_race(unsigned int tx_head,
> +				 struct macb *bp, struct macb_queue *queue)
> +{
> +	u32 macb_tsr, macb_tbqp, macb_ncr;
> +
> +	/* Controller was (probably) active when we wrote TSTART.
> +	 * This might be a race condition.
> +	 * Ensure TSTART is not ignored.
> +	 */
> +	for (;;) {
> +		macb_tbqp = queue_readl(queue, TBQP);
> +		macb_tbqp = macb_tbqp - lower_32_bits(queue->tx_ring_dma);
> +		macb_tbqp = macb_tbqp / macb_dma_desc_get_size(bp);
> +		macb_tbqp = macb_tx_ring_wrap(bp, macb_tbqp);
> +		if (tx_head != macb_tbqp) {
> +			/* Controller is working on different descriptor.
> +			 * There should be no problem.
> +			 */
> +			break;
> +		}
> +
> +		/* Controller works on the descriptor we just wrote.
> +		 * TSTART might not have worked. Check for TGO again.
> +		 */
> +		macb_tsr = macb_readl(bp, TSR);
> +		if (!(macb_tsr & MACB_BIT(TGO))) {
> +			/* Controller stopped... write TSTART again.
> +			 */
> +			macb_ncr = macb_readl(bp, NCR);
> +			macb_ncr = macb_ncr | MACB_BIT(TSTART);
> +			macb_writel(bp, NCR, macb_ncr);
> +			break;
> +		}
> +		/* Controller might stop or process our descriptor.
> +		 * Check again.
> +		 */

We should add (1) cpu_relax(), (2) a statistic which would count that
the condition was encountered, and (3) some form of limit on the loop,
so that we don't hang the host with irqs off if the NIC goes bad.

> +	}
> +}

>  	spin_lock_irq(&bp->lock);
> +	macb_tsr = macb_readl(bp, TSR);

-- 
pw-bot: cr
