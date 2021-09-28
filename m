Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9F741B4D4
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 19:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242003AbhI1RTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 13:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233219AbhI1RTk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 13:19:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A06F6128B;
        Tue, 28 Sep 2021 17:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632849480;
        bh=typQyCd3SNK3k7UUCXoQOKeKV93Xkib4KN6PGEcMTdE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=uGa9mwTlXnwIr5Kf6wCoNyN+BvhLq2l4vkpXGqv/vS/rHf4O+J1eFo/5GtF1QHbkM
         StGDGaAjkcQ/njgTon/aUGA2HmaHZOHzGTnFrsugbMdHGZvk/8cfeCgN6bfBTzOE9X
         5GfNMNqfWK1Xpb27EpyY+SBx0vh7SXfN6qkj0NtoYqrWgG4yrCeWDl5UtXg6Tzxl5A
         hlF8o9dBlHkyHu5hHR0rNqL1fUsfSZt4dX5cvyVVJ95MOdYOrgy27tXHH4e77YHy+o
         iFOf0sEpA9glBJabKt2NK1cd8+bSQx3yGF/wXpAOBTN3HzjG8lEB84rMRq7qqWicCT
         XeK5V44uMMx5g==
Date:   Tue, 28 Sep 2021 12:17:59 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        Oliver O'Halloran <oohall@gmail.com>,
        Russell Currey <ruscur@russell.cc>
Cc:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-pci@vger.kernel.org,
        kernel@pengutronix.de, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Michael Buesch <m@bues.ch>,
        Oliver O'Halloran <oohall@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH v4 4/8] PCI: replace pci_dev::driver usage that gets the
 driver name
Message-ID: <20210928171759.GA704204@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210927204326.612555-5-uwe@kleine-koenig.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+to Oliver, Russell for eeh_driver_name() question below]

On Mon, Sep 27, 2021 at 10:43:22PM +0200, Uwe Kleine-König wrote:
> From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> struct pci_dev::driver holds (apart from a constant offset) the same
> data as struct pci_dev::dev->driver. With the goal to remove struct
> pci_dev::driver to get rid of data duplication replace getting the
> driver name by dev_driver_string() which implicitly makes use of struct
> pci_dev::dev->driver.

When you repost to fix the build issue, can you capitalize the subject
line to match the other?

Also, would you mind using "pci_dev.driver" instead of
"pci_dev::driver"?  AFAIK, the "::" operator is not actually part of
C, so I think it's more confusing than useful.

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  arch/powerpc/include/asm/ppc-pci.h                   | 9 ++++++++-
>  drivers/bcma/host_pci.c                              | 7 ++++---
>  drivers/crypto/hisilicon/qm.c                        | 2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c   | 2 +-
>  drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
>  drivers/net/ethernet/mellanox/mlxsw/pci.c            | 2 +-
>  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 +-
>  drivers/ssb/pcihost_wrapper.c                        | 8 +++++---
>  8 files changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/ppc-pci.h b/arch/powerpc/include/asm/ppc-pci.h
> index 2b9edbf6e929..e8f1795a2acf 100644
> --- a/arch/powerpc/include/asm/ppc-pci.h
> +++ b/arch/powerpc/include/asm/ppc-pci.h
> @@ -57,7 +57,14 @@ void eeh_sysfs_remove_device(struct pci_dev *pdev);
>  
>  static inline const char *eeh_driver_name(struct pci_dev *pdev)
>  {
> -	return (pdev && pdev->driver) ? pdev->driver->name : "<null>";
> +	if (pdev) {
> +		const char *drvstr = dev_driver_string(&pdev->dev);
> +
> +		if (strcmp(drvstr, ""))
> +			return drvstr;
> +	}
> +
> +	return "<null>";

Can we just do this?

  if (pdev)
    return dev_driver_string(&pdev->dev);

  return "<null>";

I think it's more complicated than it's worth to include a strcmp().
It's possible this will change those error messages about "Might be
infinite loop in %s driver", but that doesn't seem like a huge deal.

I moved Oliver to "to:" and added Russell in case they object.

>  }
>  
>  #endif /* CONFIG_EEH */
> diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
> index 69c10a7b7c61..0973022d4b13 100644
> --- a/drivers/bcma/host_pci.c
> +++ b/drivers/bcma/host_pci.c
> @@ -175,9 +175,10 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
>  	if (err)
>  		goto err_kfree_bus;
>  
> -	name = dev_name(&dev->dev);
> -	if (dev->driver && dev->driver->name)
> -		name = dev->driver->name;
> +	name = dev_driver_string(&dev->dev);
> +	if (!strcmp(name, ""))
> +		name = dev_name(&dev->dev);
>  	err = pci_request_regions(dev, name);

Again seems more complicated than it's worth to me.  This is in the
driver's .probe() method, so really_probe() has already set
"dev->driver = drv", which means dev->driver is always set to
&bcma_pci_bridge_driver here, and bcma_pci_bridge_driver.name is
always "bcma-pci-bridge".

Almost all callers of pci_request_regions() just hardcode the driver
name or use a DRV_NAME #define

So I think we should just do:

  err = pci_request_regions(dev, "bcma-pci-bridge");

>  	if (err)
>  		goto err_pci_disable;
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index 369562d34d66..8f361e54e524 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -3085,7 +3085,7 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
>  	};
>  	int ret;
>  
> -	ret = strscpy(interface.name, pdev->driver->name,
> +	ret = strscpy(interface.name, dev_driver_string(&pdev->dev),
>  		      sizeof(interface.name));
>  	if (ret < 0)
>  		return -ENAMETOOLONG;
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> index 7ea511d59e91..f279edfce3f1 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> @@ -606,7 +606,7 @@ static void hns3_get_drvinfo(struct net_device *netdev,
>  		return;
>  	}
>  
> -	strncpy(drvinfo->driver, h->pdev->driver->name,
> +	strncpy(drvinfo->driver, dev_driver_string(&h->pdev->dev),
>  		sizeof(drvinfo->driver));
>  	drvinfo->driver[sizeof(drvinfo->driver) - 1] = '\0';
>  
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> index a250d394da38..a8f007f6dad2 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> @@ -720,7 +720,7 @@ static int prestera_fw_load(struct prestera_fw *fw)
>  static int prestera_pci_probe(struct pci_dev *pdev,
>  			      const struct pci_device_id *id)
>  {
> -	const char *driver_name = pdev->driver->name;
> +	const char *driver_name = dev_driver_string(&pdev->dev);
>  	struct prestera_fw *fw;
>  	int err;
>  
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
> index 13b0259f7ea6..8f306364f7bf 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
> @@ -1876,7 +1876,7 @@ static void mlxsw_pci_cmd_fini(struct mlxsw_pci *mlxsw_pci)
>  
>  static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
> -	const char *driver_name = pdev->driver->name;
> +	const char *driver_name = dev_driver_string(&pdev->dev);
>  	struct mlxsw_pci *mlxsw_pci;
>  	int err;
>  
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> index 0685ece1f155..23dfb599c828 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> @@ -202,7 +202,7 @@ nfp_get_drvinfo(struct nfp_app *app, struct pci_dev *pdev,
>  {
>  	char nsp_version[ETHTOOL_FWVERS_LEN] = {};
>  
> -	strlcpy(drvinfo->driver, pdev->driver->name, sizeof(drvinfo->driver));
> +	strlcpy(drvinfo->driver, dev_driver_string(&pdev->dev), sizeof(drvinfo->driver));
>  	nfp_net_get_nspinfo(app, nsp_version);
>  	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
>  		 "%s %s %s %s", vnic_version, nsp_version,
> diff --git a/drivers/ssb/pcihost_wrapper.c b/drivers/ssb/pcihost_wrapper.c
> index 410215c16920..4938ed5cfae5 100644
> --- a/drivers/ssb/pcihost_wrapper.c
> +++ b/drivers/ssb/pcihost_wrapper.c
> @@ -78,9 +78,11 @@ static int ssb_pcihost_probe(struct pci_dev *dev,
>  	err = pci_enable_device(dev);
>  	if (err)
>  		goto err_kfree_ssb;
> -	name = dev_name(&dev->dev);
> -	if (dev->driver && dev->driver->name)
> -		name = dev->driver->name;
> +
> +	name = dev_driver_string(&dev->dev);
> +	if (*name == '\0')
> +		name = dev_name(&dev->dev);
> +
>  	err = pci_request_regions(dev, name);

Also seems like more trouble than it's worth.  This one is a little
strange but is always called for either b43_pci_bridge_driver or
b44_pci_driver, both of which have .name set, so I think we should
simply do:

  err = pci_request_regions(dev, dev_driver_string(&dev->dev));

>  	if (err)
>  		goto err_pci_disable;
> -- 
> 2.30.2
> 
