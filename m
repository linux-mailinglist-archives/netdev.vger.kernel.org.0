Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294BA45CBAF
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345447AbhKXSCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 13:02:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50598 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243916AbhKXSCx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 13:02:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OVAQSV4rBJJ+HrJ8mrdZ5C3bcdsdqt2byVv40HAFtaQ=; b=OD++YWK3UCqM7JEyIB8cVtAg/D
        Q7i1tvUcEWHI7zdP/tfngIL9NHFQ/YvqfyQnS1ygNuyZc/Sb+XedTLn4uHDUspg8exiEWLrrDXLCO
        rUNzxWzEQ4NQIuHKSIlG/eJXnGmCJsBmNkXUGKhAN/sFKIMUqlNN3GwlGvMqhuy5QK4I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mpwYQ-00EX3A-Bi; Wed, 24 Nov 2021 18:59:34 +0100
Date:   Wed, 24 Nov 2021 18:59:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, p.zabel@pengutronix.de,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/6] net: lan966x: add port module support
Message-ID: <YZ59hpDWjNjvx5kP@lunn.ch>
References: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
 <20211123135517.4037557-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123135517.4037557-4-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void lan966x_ifh_inject(u32 *ifh, size_t val, size_t pos, size_t length)
> +{
> +	int i;
> +
> +	for (i = pos; i < pos + length; ++i) {
> +		if (val & BIT(i - pos))
> +			ifh[IFH_LEN - i / 32 - 1] |= BIT(i % 32);
> +		else
> +			ifh[IFH_LEN - i / 32 - 1] &= ~(BIT(i % 32));
> +	}
> +}
> +
> +static void lan966x_gen_ifh(u32 *ifh, struct lan966x_frame_info *info,
> +			    struct lan966x *lan966x)
> +{
> +	lan966x_ifh_inject(ifh, 1, IFH_POS_BYPASS, 1);
> +	lan966x_ifh_inject(ifh, info->port, IFH_POS_DSTS, IFH_WID_DSTS);
> +	lan966x_ifh_inject(ifh, info->qos_class, IFH_POS_QOS_CLASS,
> +			   IFH_WID_QOS_CLASS);
> +	lan966x_ifh_inject(ifh, info->ipv, IFH_POS_IPV, IFH_WID_IPV);
> +}
> +

> +	/* Write IFH header */
> +	for (i = 0; i < IFH_LEN; ++i) {
> +		/* Wait until the fifo is ready */
> +		while (!(QS_INJ_STATUS_FIFO_RDY_GET(lan_rd(lan966x, QS_INJ_STATUS)) &
> +			 BIT(grp)))
> +			;
> +
> +		lan_wr((__force u32)cpu_to_be32(ifh[i]), lan966x,
> +		       QS_INJ_WR(grp));

There is a lot of magic going on here constructing the IFH. Is it
possible to define the structure using bit fields and __be32. You
should then be able to skip this cpu_to_be32 and the ugly cast. And
the actual structure should be a lot clearer.

> +static int lan966x_rx_frame_word(struct lan966x *lan966x, u8 grp, bool ifh,
> +				 u32 *rval)
> +{
> +	u32 bytes_valid;
> +	u32 val;
> +
> +	val = lan_rd(lan966x, QS_XTR_RD(grp));
> +	if (val == XTR_NOT_READY) {
> +		if (ifh)
> +			return -EIO;
> +
> +		do {
> +			val = lan_rd(lan966x, QS_XTR_RD(grp));
> +		} while (val == XTR_NOT_READY);

I would add some sort of timeout here, just in case the hardware
breaks. You have quite a few such loops, it would be better to make
use of the helpers in linux/iopoll.h.

