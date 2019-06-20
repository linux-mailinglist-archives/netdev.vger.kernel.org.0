Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FA24DC6A
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 23:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfFTVYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 17:24:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfFTVYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 17:24:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6ZBQKs2/yVUjNvtjwcTFDBVkLpiqErioK4XMeYKkv3Y=; b=ksyu4vVwc4ueBi222BLlN6VaZY
        V5xMqWkPZo2CyueIzNtHs6kHIjCndfDq7/HKxGqmd0xGAiUugydMKnBbt0qZctBsxCez0lIKBnHpo
        L9vOocINxjhpDUm5F8RCBn3bLHPF988McCUWdmqcFaPnFBhhzlCfLZUnT5mM0+LhSvhE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1he4Y3-0002Cp-IG; Thu, 20 Jun 2019 23:24:47 +0200
Date:   Thu, 20 Jun 2019 23:24:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/18] ionic: Add basic framework for IONIC
 Network device driver
Message-ID: <20190620212447.GJ31306@lunn.ch>
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-2-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620202424.23215-2-snelson@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
> +
> +#ifndef _IONIC_H_
> +#define _IONIC_H_
> +
> +#define DRV_NAME		"ionic"
> +#define DRV_DESCRIPTION		"Pensando Ethernet NIC Driver"
> +#define DRV_VERSION		"0.11.0-k"

DRV_VERSION is pretty useless. What you really want to know is the
kernel git tree and commit. The big distributions might backport this
version of the driver back to the old kernel with a million
patches. At which point 0.11.0-k tells you nothing much.
> +
> +// TODO: register these with the official include/linux/pci_ids.h
> +#define PCI_VENDOR_ID_PENSANDO			0x1dd8

That file has a comment:

 *      Do not add new entries to this file unless the definitions
 *      are shared between multiple drivers.

Is it going to be shared?

 +
> +#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
> +#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
> +#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT	0x1004
> +
> +#define IONIC_SUBDEV_ID_NAPLES_25	0x4000
> +#define IONIC_SUBDEV_ID_NAPLES_100_4	0x4001
> +#define IONIC_SUBDEV_ID_NAPLES_100_8	0x4002
> +
> +struct ionic {
> +	struct pci_dev *pdev;
> +	struct device *dev;
> +};
> +
> +#endif /* _IONIC_H_ */
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus.h b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
> new file mode 100644
> index 000000000000..94ba0afc6f38
> --- /dev/null
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
> +
> +#ifndef _IONIC_BUS_H_
> +#define _IONIC_BUS_H_
> +
> +int ionic_bus_register_driver(void);
> +void ionic_bus_unregister_driver(void);
> +
> +#endif /* _IONIC_BUS_H_ */
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> new file mode 100644
> index 000000000000..ab6206c162d4
> --- /dev/null
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> @@ -0,0 +1,61 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
> +
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/pci.h>
> +
> +#include "ionic.h"
> +#include "ionic_bus.h"
> +
> +/* Supported devices */
> +static const struct pci_device_id ionic_id_table[] = {
> +	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF) },
> +	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF) },
> +	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT) },
> +	{ 0, }	/* end of table */
> +};
> +MODULE_DEVICE_TABLE(pci, ionic_id_table);
> +
> +static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ionic *ionic;
> +
> +	ionic = devm_kzalloc(dev, sizeof(*ionic), GFP_KERNEL);
> +	if (!ionic)
> +		return -ENOMEM;
> +
> +	ionic->pdev = pdev;
> +	pci_set_drvdata(pdev, ionic);
> +	ionic->dev = dev;
> +	dev_info(ionic->dev, "attached\n");

probed would be more accurate. But in general, please avoid all but
the minimum of such info messages.

> +
> +	return 0;
> +}
> +
> +static void ionic_remove(struct pci_dev *pdev)
> +{
> +	struct ionic *ionic = pci_get_drvdata(pdev);
> +
> +	pci_set_drvdata(pdev, NULL);
> +	dev_info(ionic->dev, "removed\n");

Not very useful dev_info().

Also, i think the core will NULL out the drive data for you. But you
should check.
> +}
> +
> +static struct pci_driver ionic_driver = {
> +	.name = DRV_NAME,
> +	.id_table = ionic_id_table,
> +	.probe = ionic_probe,
> +	.remove = ionic_remove,
> +};
> +
> +int ionic_bus_register_driver(void)
> +{
> +	return pci_register_driver(&ionic_driver);
> +}
> +
> +void ionic_bus_unregister_driver(void)
> +{
> +	pci_unregister_driver(&ionic_driver);
> +}

It looks like you can use module_pci_driver() and remove a lot of
boilerplate.

	Andrew
