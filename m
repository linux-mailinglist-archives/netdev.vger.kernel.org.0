Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3151535661C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 10:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbhDGIK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 04:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237818AbhDGIKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 04:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 865E86139C;
        Wed,  7 Apr 2021 08:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617783012;
        bh=LLv3HsHqxioPHLHPt0FtsjLo1qQsjXIdxq3Hj8vcjOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jab+GCrrT1PbACGOCAi6p9A+ENmFOoPOCrxkHzrhA8ccZgg1bz32mpUNlvW+/g73k
         anUTt6Au0vhOjtvSS/zSPQEwJhN5qFkXdsZhzIOGZgFG7T1rIv4JQbZCMfoiPSAGaD
         7vbq402GHsXdExqMXo2KNQZfVA8/JJrmkPwFWreFQo5oe7Yg1SR563NLAKgOE1n7ty
         lc6Uu+nu7Be/LkVqPuS0futeFjkKNGy3DoR1hvly6quk9M2vgAuSospjGWKorjsofo
         egh81ceF/sxekcxwXRdHXqWvZfv72+S2tO75F8SC5Jw8A+lErEQhByni1EfSEJeySY
         qnboMaFQ8/KOQ==
Date:   Wed, 7 Apr 2021 11:10:08 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        liuwe@microsoft.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YG1o4LXVllXfkUYO@unreal>
References: <20210406232321.12104-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406232321.12104-1-decui@microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 04:23:21PM -0700, Dexuan Cui wrote:
> Add a VF driver for Microsoft Azure Network Adapter (MANA) that will be
> available in the future.
> 
> Co-developed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  MAINTAINERS                                   |    4 +-
>  drivers/net/ethernet/Kconfig                  |    1 +
>  drivers/net/ethernet/Makefile                 |    1 +
>  drivers/net/ethernet/microsoft/Kconfig        |   29 +
>  drivers/net/ethernet/microsoft/Makefile       |    5 +
>  drivers/net/ethernet/microsoft/mana/Makefile  |    6 +
>  drivers/net/ethernet/microsoft/mana/gdma.h    |  731 +++++++
>  .../net/ethernet/microsoft/mana/gdma_main.c   | 1500 +++++++++++++
>  .../net/ethernet/microsoft/mana/hw_channel.c  |  851 ++++++++
>  .../net/ethernet/microsoft/mana/hw_channel.h  |  181 ++
>  drivers/net/ethernet/microsoft/mana/mana.h    |  529 +++++
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 1861 +++++++++++++++++
>  .../ethernet/microsoft/mana/mana_ethtool.c    |  276 +++
>  .../net/ethernet/microsoft/mana/shm_channel.c |  290 +++
>  .../net/ethernet/microsoft/mana/shm_channel.h |   19 +
>  15 files changed, 6283 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/microsoft/Kconfig
>  create mode 100644 drivers/net/ethernet/microsoft/Makefile
>  create mode 100644 drivers/net/ethernet/microsoft/mana/Makefile
>  create mode 100644 drivers/net/ethernet/microsoft/mana/gdma.h
>  create mode 100644 drivers/net/ethernet/microsoft/mana/gdma_main.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.h
>  create mode 100644 drivers/net/ethernet/microsoft/mana/mana.h
>  create mode 100644 drivers/net/ethernet/microsoft/mana/mana_en.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/mana_ethtool.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.h

<...>

> +int gdma_verify_vf_version(struct pci_dev *pdev)
> +{
> +	struct gdma_context *gc = pci_get_drvdata(pdev);
> +	struct gdma_verify_ver_req req = { 0 };
> +	struct gdma_verify_ver_resp resp = { 0 };
> +	int err;
> +
> +	gdma_init_req_hdr(&req.hdr, GDMA_VERIFY_VF_DRIVER_VERSION,
> +			  sizeof(req), sizeof(resp));
> +
> +	req.protocol_ver_min = GDMA_PROTOCOL_FIRST;
> +	req.protocol_ver_max = GDMA_PROTOCOL_LAST;
> +
> +	err = gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +	if (err || resp.hdr.status) {
> +		pr_err("VfVerifyVersionOutput: %d, status=0x%x\n", err,
> +		       resp.hdr.status);
> +		return -EPROTO;
> +	}
> +
> +	return 0;
> +}

<...>

> +static int gdma_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	struct gdma_context *gc;
> +	void __iomem *bar0_va;
> +	int bar = 0;
> +	int err;
> +
> +	err = pci_enable_device(pdev);
> +	if (err)
> +		return -ENXIO;
> +
> +	pci_set_master(pdev);
> +
> +	err = pci_request_regions(pdev, "gdma");
> +	if (err)
> +		goto disable_dev;
> +
> +	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (err)
> +		goto release_region;
> +
> +	err = -ENOMEM;
> +	gc = vzalloc(sizeof(*gc));
> +	if (!gc)
> +		goto release_region;
> +
> +	bar0_va = pci_iomap(pdev, bar, 0);
> +	if (!bar0_va)
> +		goto free_gc;
> +
> +	gc->bar0_va = bar0_va;
> +	gc->pci_dev = pdev;
> +
> +	pci_set_drvdata(pdev, gc);
> +
> +	gdma_init_registers(pdev);
> +
> +	shm_channel_init(&gc->shm_channel, gc->shm_base);
> +
> +	err = gdma_setup_irqs(pdev);
> +	if (err)
> +		goto unmap_bar;
> +
> +	mutex_init(&gc->eq_test_event_mutex);
> +
> +	err = hwc_create_channel(gc);
> +	if (err)
> +		goto remove_irq;
> +
> +	err = gdma_verify_vf_version(pdev);
> +	if (err)
> +		goto remove_irq;

Will this VF driver be used in the guest VM? What will prevent from users to change it? 
I think that such version negotiation scheme is not allowed.

Thanks
