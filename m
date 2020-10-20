Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5D52932F7
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 04:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390481AbgJTCN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 22:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:32868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730251AbgJTCN6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 22:13:58 -0400
Received: from [10.44.0.192] (unknown [103.48.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3578B222E8;
        Tue, 20 Oct 2020 02:13:55 +0000 (UTC)
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Chris Heally <cphealy@gmail.com>, netdev@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>
From:   Greg Ungerer <gerg@linux-m68k.org>
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Message-ID: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
Date:   Tue, 20 Oct 2020 12:14:04 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Commit f166f890c8f0 ("[PATCH] net: ethernet: fec: Replace interrupt 
driven MDIO with polled IO") breaks the FEC driver on at least one of
the ColdFire platforms (the 5208). Maybe others, that is all I have
tested on so far.

Specifically the driver no longer finds any PHY devices when it probes
the MDIO bus at kernel start time.

I have pinned the problem down to this one specific change in this commit:

> @@ -2143,8 +2142,21 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>  	if (suppress_preamble)
>  		fep->phy_speed |= BIT(7);
>  
> +	/* Clear MMFR to avoid to generate MII event by writing MSCR.
> +	 * MII event generation condition:
> +	 * - writing MSCR:
> +	 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> +	 *	  mscr_reg_data_in[7:0] != 0
> +	 * - writing MMFR:
> +	 *	- mscr[7:0]_not_zero
> +	 */
> +	writel(0, fep->hwp + FEC_MII_DATA);

At least by removing this I get the old behavior back and everything 
works as it did before.

With that write of the FEC_MII_DATA register in place it seems that
subsequent MDIO operations return immediately (that is FEC_IEVENT is
set) - even though it is obvious the MDIO transaction has not completed yet.

Any ideas?

Regards
Greg



