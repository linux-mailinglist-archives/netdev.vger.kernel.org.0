Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0211F4CB71F
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiCCGlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiCCGlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:41:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4DD1688CE;
        Wed,  2 Mar 2022 22:40:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13B3BB823F7;
        Thu,  3 Mar 2022 06:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C86C004E1;
        Thu,  3 Mar 2022 06:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646289632;
        bh=4VZm6LvFsQzBvkZ1Z9ZsQuTBOWLyfQ/dgJPYMcv+B38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J70GEyKMuq0CQh/hswgFpQM206UbbqzuG8fN82fyl2VtIA4GIBpwkatRojOOXrldT
         51WJaFJQ8sV22ABzWJ9hi/NFzWm0vcEbAvUbqmJG/WndUJ94ML77o+18G0Us2u2Vl6
         rm2/QHIDE//2fQDnDOXmKjOHOFq8vakTDAlnY5pW4xLDgq9HNP6zaZDz5uCjzM3UjE
         TRisb7L+T4isA65Ai6lNn29WorWXYE5HqxwhN5yWHYqZbgnkW9Sar0fseIhubrJRxw
         E+1B0u3a90v9BWfe1lKWJe2twUiBouJw/KRO49jH9uzE9ODELk0+ffhXrFTATLaxbq
         atk0y1OGLPx8Q==
Date:   Wed, 2 Mar 2022 22:40:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        soren.brinkmann@xilinx.com, scott.mcnutt@siriusxm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH net] net: macb: Fix lost RX packet wakeup race in NAPI
 receive
Message-ID: <20220302224031.72fb62a9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220228183328.338143-1-robert.hancock@calian.com>
References: <20220228183328.338143-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 12:33:28 -0600 Robert Hancock wrote:
> There is an oddity in the way the RSR register flags propagate to the
> ISR register (and the actual interrupt output) on this hardware: it
> appears that RSR register bits only result in ISR being asserted if the
> interrupt was actually enabled at the time, so enabling interrupts with
> RSR bits already set doesn't trigger an interrupt to be raised. There
> was already a partial fix for this race in the macb_poll function where
> it checked for RSR bits being set and re-triggered NAPI receive.
> However, there was a still a race window between checking RSR and
> actually enabling interrupts, where a lost wakeup could happen. It's
> necessary to check again after enabling interrupts to see if RSR was set
> just prior to the interrupt being enabled, and re-trigger receive in that
> case.
> 
> This issue was noticed in a point-to-point UDP request-response protocol
> which periodically saw timeouts or abnormally high response times due to
> received packets not being processed in a timely fashion. In many
> applications, more packets arriving, including TCP retransmissions, would
> cause the original packet to be processed, thus masking the issue.
> 
> Also change from using napi_reschedule to napi_schedule, as the only
> difference is the presence of a return value which wasn't used here
> anyway.

Let's leave that out from this particular patch - fixes should be
minimal, this sounds like cleanup.

> Fixes: 02f7a34f34e3 ("net: macb: Re-enable RX interrupt only when RX is done")
> Cc: stable@vger.kernel.org
> Co-developed-by: Scott McNutt <scott.mcnutt@siriusxm.com>
> Signed-off-by: Scott McNutt <scott.mcnutt@siriusxm.com>
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 26 ++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 98498a76ae16..338660fe1d93 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -1573,14 +1573,36 @@ static int macb_poll(struct napi_struct *napi, int budget)
>  	if (work_done < budget) {
>  		napi_complete_done(napi, work_done);
>  
> -		/* Packets received while interrupts were disabled */
> +		/* RSR bits only seem to propagate to raise interrupts when
> +		 * interrupts are enabled at the time, so if bits are already
> +		 * set due to packets received while interrupts were disabled,
> +		 * they will not cause another interrupt to be generated when
> +		 * interrupts are re-enabled.
> +		 * Check for this case here.
> +		 */
>  		status = macb_readl(bp, RSR);

Which case is more likely - status == 0 or != 0?

Because MMIO reads are usually expensive so if status is likely 
to be zero your other suggestion could be lower overhead.
It'd be good to mention this expectation in the commit message 
or comment here.

>  		if (status) {
>  			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>  				queue_writel(queue, ISR, MACB_BIT(RCOMP));
> -			napi_reschedule(napi);
> +			napi_schedule(napi);
>  		} else {
>  			queue_writel(queue, IER, bp->rx_intr_mask);
> +
> +			/* Packets could have been received in the window
> +			 * between the check above and re-enabling interrupts.
> +			 * Therefore, a double-check is required to avoid
> +			 * losing a wakeup. This can potentially race with
> +			 * the interrupt handler doing the same actions if an
> +			 * interrupt is raised just after enabling them, but
> +			 * this should be harmless.
> +			 */
> +			status = macb_readl(bp, RSR);
> +			if (unlikely(status)) {
> +				queue_writel(queue, IDR, bp->rx_intr_mask);
> +				if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> +					queue_writel(queue, ISR, MACB_BIT(RCOMP));
> +				napi_schedule(napi);
> +			}
>  		}
>  	}
>  

