Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0C327D1C7
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731477AbgI2OsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727328AbgI2OsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 10:48:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F6392075A;
        Tue, 29 Sep 2020 14:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601390887;
        bh=TyBOGcnt3KTr063bYJh8aFOEls7WaKnUYtPC+CVyuTQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0vlwcCEyX51iQemdJkiEdIWtZ6ZcUEdnk0O93vojupO/15OscUAWG6GGSojFM8SPU
         an3Lucmp/Q4w0I4jnlbxGhOILxMdrpd/ekWm5y+PQVJsq+KX44AX0Id2CM7YMG3oZS
         p1W5cEjnMw4SBzSqkWVGh8NP+x24oHecvL1ezAjI=
Date:   Tue, 29 Sep 2020 07:48:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     mkl@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH V4 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Message-ID: <20200929074806.389355c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929203041.29758-2-qiangqing.zhang@nxp.com>
References: <20200929203041.29758-1-qiangqing.zhang@nxp.com>
        <20200929203041.29758-2-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 04:30:39 +0800 Joakim Zhang wrote:
> @@ -1292,6 +1307,35 @@ static void flexcan_set_bittiming(struct net_device *dev)
>  		return flexcan_set_bittiming_ctrl(dev);
>  }
>  
> +static void flexcan_init_ram(struct net_device *dev)
> +{
> +	struct flexcan_priv *priv = netdev_priv(dev);
> +	struct flexcan_regs __iomem *regs = priv->regs;
> +	u32 reg_ctrl2;
> +
> +	/* 11.8.3.13 Detection and correction of memory errors:
> +	 * CTRL2[WRMFRZ] grants write access to all memory positions that
> +	 * require initialization, ranging from 0x080 to 0xADF and
> +	 * from 0xF28 to 0xFFF when the CAN FD feature is enabled.
> +	 * The RXMGMASK, RX14MASK, RX15MASK, and RXFGMASK registers need to
> +	 * be initialized as well. MCR[RFEN] must not be set during memory
> +	 * initialization.
> +	 */
> +	reg_ctrl2 = priv->read(&regs->ctrl2);
> +	reg_ctrl2 |= FLEXCAN_CTRL2_WRMFRZ;
> +	priv->write(reg_ctrl2, &regs->ctrl2);
> +
> +	memset_io(&regs->mb[0][0], 0,
> +		  (u8 *)&regs->rx_smb1[3] - &regs->mb[0][0] + 0x4);
> +
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
> +		memset_io(&regs->tx_smb_fd[0], 0,
> +			  (u8 *)&regs->rx_smb1_fd[17] - (u8 *)&regs->tx_smb_fd[0] + 0x4);
> +
> +	reg_ctrl2 &= ~FLEXCAN_CTRL2_WRMFRZ;
> +	priv->write(reg_ctrl2, &regs->ctrl2);
> +}
> +
>  /* flexcan_chip_start
>   *
>   * this functions is entered with clocks enabled

drivers/net/can/flexcan.c:1329:20: warning: cast removes address space '__iomem' of expression
drivers/net/can/flexcan.c:1329:43: error: subtraction of different types can't work (different address spaces)
