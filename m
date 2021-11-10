Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A133B44CB8E
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 23:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbhKJWJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:09:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55360 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233321AbhKJWJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 17:09:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KUZYc+UYSCIQpV6CXLwxg5Aw9+FUL6qmdSzE/JqAMSA=; b=SWmF1CQvRfIWylqx5Ray/qVpjw
        9kka7ZmoJqdOIHEgbnyOSzdJ8PkZo0uSi8fh7w0OjrTSWRb84QtaNTF4X/gCfgfie/ZlvT/FhQtJC
        OleEAHPMjhBXdIxJWFGz6f+8bAqJ6oy9jK/Ui4NA74vAza6XyJnjlRnWYmguIwGx/ll4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkvjX-00D8wh-3m; Wed, 10 Nov 2021 23:06:19 +0100
Date:   Wed, 10 Nov 2021 23:06:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Apeksha Gupta <apeksha.gupta@nxp.com>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com, nipun.gupta@nxp.com
Subject: Re: [PATCH 2/5] net: fec: fec-uio driver
Message-ID: <YYxCWyLExiWgXf/L@lunn.ch>
References: <20211110054838.27907-1-apeksha.gupta@nxp.com>
 <20211110054838.27907-3-apeksha.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110054838.27907-3-apeksha.gupta@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 11:18:35AM +0530, Apeksha Gupta wrote:
> i.mx: fec-uio driver
> 
> This patch adds the userspace support. In this basic
> hardware initialization is performed in kernel via userspace
> input/output, while the majority of code is written in the
> userspace.

Where do i find this usespace code. Please include a URL to a git
repo.

> +static unsigned char macaddr[ETH_ALEN];
> +module_param_array(macaddr, byte, NULL, 0);
> +MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");

No module parameters please. Use the standard device tree bindings.

> +static int fec_enet_uio_init(struct net_device *ndev)
> +{
> +	unsigned int total_tx_ring_size = 0, total_rx_ring_size = 0;
> +	struct fec_enet_private *fep = netdev_priv(ndev);
> +	unsigned int dsize = sizeof(struct bufdesc);
> +	unsigned short tx_ring_size, rx_ring_size;
> +	int ret, i;
> +
> +	/* Check mask of the streaming and coherent API */
> +	ret = dma_set_mask_and_coherent(&fep->pdev->dev, DMA_BIT_MASK(32));
> +	if (ret < 0) {
> +		dev_warn(&fep->pdev->dev, "No suitable DMA available\n");
> +		return ret;
> +	}
> +
> +	tx_ring_size = TX_RING_SIZE;
> +	rx_ring_size = RX_RING_SIZE;
> +
> +	for (i = 0; i <	FEC_ENET_MAX_TX_QS; i++)
> +		total_tx_ring_size += tx_ring_size;
> +	for (i = 0; i <	FEC_ENET_MAX_RX_QS; i++)
> +		total_rx_ring_size += rx_ring_size;
> +
> +	bd_size = (total_tx_ring_size + total_rx_ring_size) * dsize;

These are the buffer descriptors, not buffers themselves. I assume the
user space driver is allocating the buffer? And your userspace then
set the descriptor to point to user allocated memory? Or some other
memory in the address space, and overwrite whatever you want on the
next DMA? Or DMAing kernel memory out as frames?

> +static int
> +fec_enet_uio_probe(struct platform_device *pdev)
> +{
> +	struct fec_uio_devinfo *dev_info;
> +	const struct of_device_id *of_id;
> +	struct fec_enet_private *fep;
> +	struct net_device *ndev;
> +	u32 ecntl = ETHER_EN;
> +	static int dev_id;
> +	bool reset_again;
> +	int ret = 0;
> +
> +	/* Init network device */
> +	ndev = alloc_etherdev_mq(sizeof(struct fec_enet_private) +
> +				FEC_PRIV_SIZE, FEC_MAX_Q);

Why do you need this. This is not a netdev driver, since it does not
connect to the network stack.

> +static int
> +fec_enet_uio_remove(struct platform_device *pdev)
> +{
> +	struct net_device *ndev = platform_get_drvdata(pdev);
> +	struct fec_enet_private *fep = netdev_priv(ndev);
> +
> +	kfree(fec_dev);
> +	iounmap(fep->hwp);
> +	dma_free_coherent(&fep->pdev->dev, bd_size, cbd_base, bd_dma);

Don't you have to assume that the userspace driver has crashed and
burned, leaving the hardware in an undefined state. It could still be
receiving, into buffers we have no idea about. Don't you need to stop
the hardware, and then wait for all DMA activity to stop, and only
then can you free the buffer descriptors?

     Andrew
