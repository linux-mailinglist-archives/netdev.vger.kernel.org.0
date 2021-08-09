Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5191C3E4987
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 18:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhHIQQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 12:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhHIQQn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 12:16:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17D4860EB9;
        Mon,  9 Aug 2021 16:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628525782;
        bh=C5/2dVgJImM/dgrdIjcufSzzf7XvsOxZHwVOIj8pShE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eSokIi1AXe7eH/E/RW+03kMmrL/YNf2bMht4nF6os6Baba65ELy1ADAw+/nYc6QBD
         1OH8WiLaKIcj1WbbpQMm9wTFh5ZDq7oc23tbUxElV9gtgpYRmlh8LCmUszq5N2CNXf
         I4yJHMaNWuqrRN0ZNc1p+0m+tdNrPwEBcMyagB/8Xas1ECKfWqTvN+neYebAHWPViB
         HlS/1l1FSxTUQiTrethkTKArmDhVFEnbewVICG95sc+6HdfgBUtnc6/y4uC9Euyiw6
         zvL6Q+wEMLwN2QI1HM1IS1KGIuFylqsQWc9viRx+33kiY5Ya0Mafv1az+ujYi3DTZn
         cdJ1STGr2qReg==
Date:   Mon, 9 Aug 2021 09:16:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: Add driver for LiteX's LiteETH network
 interface
Message-ID: <20210809091621.40c91f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACPK8XcCjNWm=85uXX2tubP=WAgfF8ewqMAMWO_wJVeHB-U_0w@mail.gmail.com>
References: <20210806054904.534315-1-joel@jms.id.au>
        <20210806054904.534315-3-joel@jms.id.au>
        <20210806161030.52a7ae93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACPK8XcCjNWm=85uXX2tubP=WAgfF8ewqMAMWO_wJVeHB-U_0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Aug 2021 12:03:36 +0000 Joel Stanley wrote:
> On Fri, 6 Aug 2021 at 23:10, Jakub Kicinski <kuba@kernel.org> wrote:
> > > +static int liteeth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
> > > +{
> > > +     struct liteeth *priv = netdev_priv(netdev);
> > > +     void __iomem *txbuffer;
> > > +     int ret;
> > > +     u8 val;
> > > +
> > > +     /* Reject oversize packets */
> > > +     if (unlikely(skb->len > MAX_PKT_SIZE)) {
> > > +             if (net_ratelimit())
> > > +                     netdev_dbg(netdev, "tx packet too big\n");
> > > +             goto drop;
> > > +     }
> > > +
> > > +     txbuffer = priv->tx_base + priv->tx_slot * LITEETH_BUFFER_SIZE;
> > > +     memcpy_toio(txbuffer, skb->data, skb->len);
> > > +     writeb(priv->tx_slot, priv->base + LITEETH_READER_SLOT);
> > > +     writew(skb->len, priv->base + LITEETH_READER_LENGTH);
> > > +
> > > +     ret = readl_poll_timeout_atomic(priv->base + LITEETH_READER_READY, val, val, 5, 1000);  
> >
> > Why the need for poll if there is an interrupt?
> > Why not stop the Tx queue once you're out of slots and restart
> > it when the completion interrupt comes?  
> 
> That makes sense.
> 
> In testing I have not been able to hit the LITEETH_READER_READY
> not-ready state. I assume it's there to say that the slots are full.

In that case it's probably best to stop the Tx queue in the xmit routine
once all the lots are used, and restart it from the interrupt. I was
guessing maybe the IRQ is not always there, but that doesn't seem to be
the case.
 
> > > +     if (ret == -ETIMEDOUT) {
> > > +             netdev_err(netdev, "LITEETH_READER_READY timed out\n");  
> >
> > ratelimit this as well, please
> >  
> > > +             goto drop;
> > > +     }
> > > +
> > > +     writeb(1, priv->base + LITEETH_READER_START);
> > > +
> > > +     netdev->stats.tx_bytes += skb->len;  
> >
> > Please count bytes and packets in the same place  
> 
> AFAIK we don't know the length when the interrupt comes in, so we need
> to count both here in xmit?

Either that or allocate a small array (num_tx_slots) to save the
lengths for IRQ routine to use.

> > > +     priv->tx_slot = (priv->tx_slot + 1) % priv->num_tx_slots;
> > > +     dev_kfree_skb_any(skb);
> > > +     return NETDEV_TX_OK;
> > > +drop:
> > > +     /* Drop the packet */
> > > +     dev_kfree_skb_any(skb);
> > > +     netdev->stats.tx_dropped++;
> > > +
> > > +     return NETDEV_TX_OK;
> > > +}  
