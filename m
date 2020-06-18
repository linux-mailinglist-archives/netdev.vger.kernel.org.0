Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC321FFA13
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbgFRRXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:23:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47356 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731381AbgFRRXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 13:23:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlyFk-0019Cr-H8; Thu, 18 Jun 2020 19:23:04 +0200
Date:   Thu, 18 Jun 2020 19:23:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 3/9] net: dsa: hellcreek: Add PTP clock support
Message-ID: <20200618172304.GG240559@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de>
 <20200618064029.32168-4-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618064029.32168-4-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static u64 __hellcreek_ptp_clock_read(struct hellcreek *hellcreek)
> +{
> +	u16 nsl, nsh, secl, secm, sech;
> +
> +	/* Take a snapshot */
> +	hellcreek_ptp_write(hellcreek, PR_COMMAND_C_SS, PR_COMMAND_C);
> +
> +	/* The time of the day is saved as 96 bits. However, due to hardware
> +	 * limitations the seconds are not or only partly kept in the PTP
> +	 * core. That's why only the nanoseconds are used and the seconds are
> +	 * tracked in software. Anyway due to internal locking all five
> +	 * registers should be read.
> +	 */
> +	sech = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
> +	secm = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
> +	secl = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
> +	nsh  = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
> +	nsl  = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
> +
> +	return (u64)nsl | ((u64)nsh << 16);

Hi Kurt

What are the hardware limitations? There seems to be 48 bits for
seconds? That allows for 8925104 years?

> +static u64 __hellcreek_ptp_gettime(struct hellcreek *hellcreek)
> +{
> +	u64 ns;
> +
> +	ns = __hellcreek_ptp_clock_read(hellcreek);
> +	if (ns < hellcreek->last_ts)
> +		hellcreek->seconds++;
> +	hellcreek->last_ts = ns;
> +	ns += hellcreek->seconds * NSEC_PER_SEC;

So the assumption is, this gets called at least once per second. And
if that does not happen, there is no recovery. The second is lost.

I'm just wondering if there is something more robust using what the
hardware does provide, even if the hardware is not perfect.

	 Andrew
