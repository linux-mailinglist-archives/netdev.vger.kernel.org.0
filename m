Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2506C666AAB
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbjALFJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239023AbjALFJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:09:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75B74F12C;
        Wed, 11 Jan 2023 21:09:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EA93B81C0B;
        Thu, 12 Jan 2023 05:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD2DC433D2;
        Thu, 12 Jan 2023 05:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673500138;
        bh=5TFiVEhUBziE7GBztNTOvIp+q6DvX5FSQA25pZQ7M1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JWeirc7gi8NfIk/1a3GhDlVaClXc+AmJuHRPMQHJbMrU7nxbo8baIundGWPrg2tyd
         WPpb5J1pxLgsgVVf25gCLDxRgT1d7TVOzXnnw3A8e8EPVnX0/xGoj/x1wK56cc6PJ/
         dqbdCgFAZFknTBk/Dgac/DnqBk7CrCX/QVMYRtaP+k5O7g3vzWkHGYO4jjnPnBzYMA
         8hTB+vlNpx4yhrMJSRB4/cLZuAtR83LKmWkYNoQNixmPsbl6U5BwB2UoIHdS3HQ6p7
         SpNNywL1Va72nWi+jVkmsQoWUdboYYqhQZtyrZR07CXC+cfOxSOKlz8Wtr2PvxuK4h
         Dtu8w973pgD9w==
Date:   Wed, 11 Jan 2023 21:08:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     nikhil.gupta@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vakul.garg@nxp.com,
        rajan.gupta@nxp.com
Subject: Re: [PATCH] ptp_qoriq: fix latency in ptp_qoriq_adjtime()
 operation.
Message-ID: <20230111210856.745ef17c@kernel.org>
In-Reply-To: <20230110113024.7558-1-nikhil.gupta@nxp.com>
References: <20230110113024.7558-1-nikhil.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

please put [PATCH net-next] in the subject.

On Tue, 10 Jan 2023 17:00:24 +0530 nikhil.gupta@nxp.com wrote:
> From: Nikhil Gupta <nikhil.gupta@nxp.com>
> 
> 1588 driver loses about 1us in adjtime operation at PTP slave.
> This is because adjtime operation uses a slow non-atomic tmr_cnt_read()
> followed by tmr_cnt_write() operation.

So far so good..

> In the above sequence, since the timer counter operation loses about 1us.

s/operation/keeps incrementing after the read/ ?

but frankly I don't think this sentence adds much

> Instead, tmr_offset register should be programmed with the delta
> nanoseconds 

missing full stop at the end.
You should describe what the tmr_offset register does.

> This won't lead to timer counter stopping and losing time
> while tmr_cnt_write() is being done.

Stopping? The timer was actually stopping?

> This Patch adds api for tmr_offset_read/write to program the

Use imperative mood.

> delta nanoseconds in the Timer offset Register.
> 
> Signed-off-by: Nikhil Gupta <nikhil.gupta@nxp.com>
> Reviewed-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  drivers/ptp/ptp_qoriq.c | 36 ++++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
> index 08f4cf0ad9e3..5b6ea6d590be 100644
> --- a/drivers/ptp/ptp_qoriq.c
> +++ b/drivers/ptp/ptp_qoriq.c
> @@ -48,6 +48,29 @@ static void tmr_cnt_write(struct ptp_qoriq *ptp_qoriq, u64 ns)
>  	ptp_qoriq->write(&regs->ctrl_regs->tmr_cnt_h, hi);
>  }
>  
> +static void tmr_offset_write(struct ptp_qoriq *ptp_qoriq, u64 delta_ns)
> +{
> +	struct ptp_qoriq_registers *regs = &ptp_qoriq->regs;
> +	u32 hi = delta_ns >> 32;
> +	u32 lo = delta_ns & 0xffffffff;
> +
> +	ptp_qoriq->write(&regs->ctrl_regs->tmroff_l, lo);
> +	ptp_qoriq->write(&regs->ctrl_regs->tmroff_h, hi);
> +}
> +
> +static u64 tmr_offset_read(struct ptp_qoriq *ptp_qoriq)
> +{
> +	struct ptp_qoriq_registers *regs = &ptp_qoriq->regs;
> +	u64 ns;
> +	u32 lo, hi;

Order variable lines longest to shortest 

> +	lo = ptp_qoriq->read(&regs->ctrl_regs->tmroff_l);
> +	hi = ptp_qoriq->read(&regs->ctrl_regs->tmroff_h);
> +	ns = ((u64) hi) << 32;
> +	ns |= lo;
> +	return ns;
> +}
> +
>  /* Caller must hold ptp_qoriq->lock. */
>  static void set_alarm(struct ptp_qoriq *ptp_qoriq)
>  {
> @@ -55,7 +78,9 @@ static void set_alarm(struct ptp_qoriq *ptp_qoriq)
>  	u64 ns;
>  	u32 lo, hi;
>  
> -	ns = tmr_cnt_read(ptp_qoriq) + 1500000000ULL;
> +	ns = tmr_cnt_read(ptp_qoriq) + tmr_offset_read(ptp_qoriq)
> +				     + 1500000000ULL;
> +
>  	ns = div_u64(ns, 1000000000UL) * 1000000000ULL;
>  	ns -= ptp_qoriq->tclk_period;
>  	hi = ns >> 32;
> @@ -207,15 +232,12 @@ EXPORT_SYMBOL_GPL(ptp_qoriq_adjfine);
>  
>  int ptp_qoriq_adjtime(struct ptp_clock_info *ptp, s64 delta)
>  {
> -	s64 now;
>  	unsigned long flags;
>  	struct ptp_qoriq *ptp_qoriq = container_of(ptp, struct ptp_qoriq, caps);
>  
>  	spin_lock_irqsave(&ptp_qoriq->lock, flags);
>  
> -	now = tmr_cnt_read(ptp_qoriq);
> -	now += delta;
> -	tmr_cnt_write(ptp_qoriq, now);
> +	tmr_offset_write(ptp_qoriq, delta);

Writes to the offset register result in an add operation? 
Or it's a pure write? What will the offset be after a sequence of
following adjtime() calls: 
  adjtime(+100); 
  adjtime(+100); 
  adjtime(+100);
?

>  	set_fipers(ptp_qoriq);
>  
>  	spin_unlock_irqrestore(&ptp_qoriq->lock, flags);
> @@ -232,7 +254,7 @@ int ptp_qoriq_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
>  
>  	spin_lock_irqsave(&ptp_qoriq->lock, flags);
>  
> -	ns = tmr_cnt_read(ptp_qoriq);
> +	ns = tmr_cnt_read(ptp_qoriq) + tmr_offset_read(ptp_qoriq);
>  
>  	spin_unlock_irqrestore(&ptp_qoriq->lock, flags);
>  
> @@ -251,6 +273,8 @@ int ptp_qoriq_settime(struct ptp_clock_info *ptp,
>  
>  	ns = timespec64_to_ns(ts);
>  
> +	tmr_offset_write(ptp_qoriq, 0);

Shouldn't this be under the lock?

>  	spin_lock_irqsave(&ptp_qoriq->lock, flags);
>  
>  	tmr_cnt_write(ptp_qoriq, ns);

