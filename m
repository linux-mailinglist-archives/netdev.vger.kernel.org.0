Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF092C49D6
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 22:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbgKYV0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 16:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731413AbgKYV0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 16:26:24 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 028FD206E0;
        Wed, 25 Nov 2020 21:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606339583;
        bh=xlVmgI/1tuUDmjoHsU+bOocWXs+9aWQwye1zxmYacjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NyoD/7pacUiN/UOWdzqe1A3IRmDDGJIE48q22IVgs3ZeI+St4evp56IeLhFGJuYiR
         eqElZ2a+vQZRRL9aUJWvy10WHK4HW8Pta1O8t+f+V1dyudQSNOHiUig0/jaWYG6UgN
         Ys72PSONPAFk3EXitvS01IHUWm0ICZ+8Vt8833tU=
Date:   Wed, 25 Nov 2020 13:26:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v7 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Message-ID: <20201125132621.628ac98b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124120330.32445-4-l.stelmach@samsung.com>
References: <20201124120330.32445-1-l.stelmach@samsung.com>
        <CGME20201124120337eucas1p268c7e3147ea36e62d40d252278c5dcb7@eucas1p2.samsung.com>
        <20201124120330.32445-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 13:03:30 +0100 =C5=81ukasz Stelmach wrote:
> +static int
> +ax88796c_start_xmit(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
> +
> +	skb_queue_tail(&ax_local->tx_wait_q, skb);
> +	if (skb_queue_len(&ax_local->tx_wait_q) > TX_QUEUE_HIGH_WATER) {
> +		netif_err(ax_local, tx_queued, ndev,
> +			  "Too many TX packets in queue %d\n",
> +			  skb_queue_len(&ax_local->tx_wait_q));

This will probably happen under heavy traffic. No need to print errors,
it's normal to back pressure.

> +		netif_stop_queue(ndev);
> +	}
> +
> +	set_bit(EVENT_TX, &ax_local->flags);
> +	schedule_work(&ax_local->ax_work);
> +
> +	return NETDEV_TX_OK;
> +}
> +
> +static void
> +ax88796c_skb_return(struct ax88796c_device *ax_local, struct sk_buff *sk=
b,
> +		    struct rx_header *rxhdr)
> +{
> +	struct net_device *ndev =3D ax_local->ndev;
> +	int status;
> +
> +	do {
> +		if (!(ndev->features & NETIF_F_RXCSUM))
> +			break;
> +
> +		/* checksum error bit is set */
> +		if ((rxhdr->flags & RX_HDR3_L3_ERR) ||
> +		    (rxhdr->flags & RX_HDR3_L4_ERR))
> +			break;
> +
> +		/* Other types may be indicated by more than one bit. */
> +		if ((rxhdr->flags & RX_HDR3_L4_TYPE_TCP) ||
> +		    (rxhdr->flags & RX_HDR3_L4_TYPE_UDP))
> +			skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> +	} while (0);
> +
> +	ax_local->stats.rx_packets++;
> +	ax_local->stats.rx_bytes +=3D skb->len;
> +	skb->dev =3D ndev;
> +
> +	skb->truesize =3D skb->len + sizeof(struct sk_buff);
> +	skb->protocol =3D eth_type_trans(skb, ax_local->ndev);
> +
> +	netif_info(ax_local, rx_status, ndev, "< rx, len %zu, type 0x%x\n",
> +		   skb->len + sizeof(struct ethhdr), skb->protocol);
> +
> +	status =3D netif_rx(skb);

If I'm reading things right this is in process context, so netif_rx_ni()

> +	if (status !=3D NET_RX_SUCCESS)
> +		netif_info(ax_local, rx_err, ndev,
> +			   "netif_rx status %d\n", status);

Again, it's inadvisable to put per packet prints without any rate
limiting in the data path.
