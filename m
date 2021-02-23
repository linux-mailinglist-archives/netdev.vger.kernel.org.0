Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA0E322465
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 04:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhBWDBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 22:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231269AbhBWDBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51DC964E02;
        Tue, 23 Feb 2021 03:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049255;
        bh=BM/BvExdZ320QdnWiPWhfUx9Hg67oT8NMu4OlXcckE4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rH8uD2MFNp90oPzOuaCzuyHDv9shc2sXfYAkDUWQMWfDEJ5rHUDt5mdkwFfnIwHqz
         gZcAjeWgk0H+lf0Dj2VgfJxrTJ+htkPknjBWT6b6pIznAm4z62kghxL9Bdgu4Ug8LR
         NXGe5PQR3i4aodt6g+ArlS1WYVkIMBGwc5gHth20UwqrV7+QkoSk0Q+WNQfPwWFWC+
         8PbZdpn75VRaR/h0uMSX76sPcObmTMYe3sqbRU8gnPYsftgKbMZXp4aGDIK+r1yT+H
         KEctsc8krqeAbIwHS+uWFlQEHVE758iW1/tWaEdK2k/aBj1HJoaA/69m5mHX1IZZ8t
         rTXrKGQuex3mw==
Date:   Mon, 22 Feb 2021 19:00:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/1] net: fec: ptp: avoid register access when ipg clock
 is disabled
Message-ID: <20210222190051.40fdc3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210220065654.25598-1-heiko.thiery@gmail.com>
References: <20210220065654.25598-1-heiko.thiery@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Feb 2021 07:56:55 +0100 Heiko Thiery wrote:
> When accessing the timecounter register on an i.MX8MQ the kernel hangs.
> This is only the case when the interface is down. This can be reproduced
> by reading with 'phc_ctrl eth0 get'.
> 
> Like described in the change in 91c0d987a9788dcc5fe26baafd73bf9242b68900
> the igp clock is disabled when the interface is down and leads to a
> system hang.
> 
> So we check if the ptp clock status before reading the timecounter
> register.
> 
> Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>

Please widen the CC list, you should CC Richard on PTP patches.

> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
> index 2e344aada4c6..c9882083da02 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -377,6 +377,9 @@ static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
>  	u64 ns;
>  	unsigned long flags;
>  
> +	/* Check the ptp clock */

Comment is rather redundant. Drop it or say _when_ ptp_clk_on may not
be true.

> +	if (!adapter->ptp_clk_on)
> +		return -EINVAL;

Why is the PTP interface registered when it can't be accessed?

Perhaps the driver should unregister the PTP clock when it's brought
down?

>  	spin_lock_irqsave(&adapter->tmreg_lock, flags);
>  	ns = timecounter_read(&adapter->tc);
>  	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
