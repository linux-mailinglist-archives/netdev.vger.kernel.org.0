Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D121C77AD
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgEFRT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728336AbgEFRT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 13:19:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 303CA20736;
        Wed,  6 May 2020 17:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588785595;
        bh=Vx2laojPRA9af0b+TlZJnd1rj8BT6IbkCPf9uW8twE8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iuGK0qrhphha7crkNxqfd/exR5+vrUBVOQvCaqmSpI6mMtTv2Bb9e5KAxHVaNhOJf
         cqiBsvormrGZm4pmx0ZvNJS1V19n58ngNSsoNqdXvSsTy/98rlzZ+Y1iImcjRJgUcu
         qekIZfCuEXFEPE/QxUXdK/yglIY8ZHVMjybnLH2o=
Date:   Wed, 6 May 2020 10:19:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 06/11] net: ethernet: mtk-eth-mac: new driver
Message-ID: <20200506101953.208e5366@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMRc=MfmuKd64YaqrkhGFThDZd0_tRecR5H0QLY0cDJWSM-VgQ@mail.gmail.com>
References: <20200505140231.16600-1-brgl@bgdev.pl>
        <20200505140231.16600-7-brgl@bgdev.pl>
        <20200505110447.2404985c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMRc=MfmuKd64YaqrkhGFThDZd0_tRecR5H0QLY0cDJWSM-VgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 May 2020 09:09:52 +0200 Bartosz Golaszewski wrote:
> > > +}  
> >
> > Why do you clean the TX ring from a work rather than from the NAPI
> > context?
> 
> So this was unclear to me, that's why I went with a workqueue. The
> budget argument in napi poll is for RX. Should I put some cap on the
> number of TX descriptors processed in napi context?

The prevailing wisdom is to not count the TX cleanup as work at all.
I think the best practice is to first clean up all the TX you can, 
and then do at must @budget of RX.

Perhaps one day we will come up with a good way of capping TX, but
today not counting it towards budget is the safe choice.

> > > +static int mtk_mac_receive_packet(struct mtk_mac_priv *priv)
> > > +{
> > > +     struct net_device *ndev = mtk_mac_get_netdev(priv);
> > > +     struct mtk_mac_ring *ring = &priv->rx_ring;
> > > +     struct device *dev = mtk_mac_get_dev(priv);
> > > +     struct mtk_mac_ring_desc_data desc_data;
> > > +     struct sk_buff *new_skb;
> > > +     int ret;
> > > +
> > > +     mtk_mac_lock(priv);
> > > +     ret = mtk_mac_ring_pop_tail(ring, &desc_data);
> > > +     mtk_mac_unlock(priv);
> > > +     if (ret)
> > > +             return -1;
> > > +
> > > +     mtk_mac_dma_unmap_rx(priv, &desc_data);
> > > +
> > > +     if ((desc_data.flags & MTK_MAC_DESC_BIT_RX_CRCE) ||
> > > +         (desc_data.flags & MTK_MAC_DESC_BIT_RX_OSIZE)) {
> > > +             /* Error packet -> drop and reuse skb. */
> > > +             new_skb = desc_data.skb;
> > > +             goto map_skb;
> > > +     }
> > > +
> > > +     new_skb = mtk_mac_alloc_skb(ndev);
> > > +     if (!new_skb) {
> > > +             netdev_err(ndev, "out of memory for skb\n");  
> >
> > No need for printing, kernel will complain loudly about oom.
> >  
> > > +             ndev->stats.rx_dropped++;
> > > +             new_skb = desc_data.skb;
> > > +             goto map_skb;
> > > +     }
> > > +
> > > +     skb_put(desc_data.skb, desc_data.len);
> > > +     desc_data.skb->ip_summed = CHECKSUM_NONE;
> > > +     desc_data.skb->protocol = eth_type_trans(desc_data.skb, ndev);
> > > +     desc_data.skb->dev = ndev;
> > > +     netif_receive_skb(desc_data.skb);
> > > +
> > > +map_skb:
> > > +     desc_data.dma_addr = mtk_mac_dma_map_rx(priv, new_skb);
> > > +     if (dma_mapping_error(dev, desc_data.dma_addr)) {
> > > +             dev_kfree_skb(new_skb);
> > > +             netdev_err(ndev, "DMA mapping error of RX descriptor\n");
> > > +             return -ENOMEM;  
> >
> > In this case nothing will ever replenish the RX ring right? If we hit
> > this condition 128 times the ring will be empty?
> 
> Indeed. What should I do if this fails though?

I think if you move things around it should work:

	skb = pop_tail();
	if (!skb)
		return;

	new_skb = alloc();
	if (!new_skb)
		goto reuse;

	dma_map(new_skb);
	if (error)
		goto reuse;
	
	dma_unmap(skb);

	if (do_packet_processing()) 
		free(skb);
	else
		receive(skb);

	put_on_ring(new_skb);

