Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805293E2B6A
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 15:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344078AbhHFNbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 09:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344073AbhHFNbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 09:31:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE93C061799
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 06:31:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBzwe-0004a4-Kz; Fri, 06 Aug 2021 15:31:28 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:b3bb:9a52:557b:dafe])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0B589661F90;
        Fri,  6 Aug 2021 13:31:26 +0000 (UTC)
Date:   Fri, 6 Aug 2021 15:31:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/1] can: esd: add support for esd GmbH PCIe/402 CAN
 interface family
Message-ID: <20210806133125.k7yiz4zood3gvrdc@pengutronix.de>
References: <20210730173805.3926-1-Stefan.Maetje@esd.eu>
 <20210730173805.3926-2-Stefan.Maetje@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xumgh6swjfevthav"
Content-Disposition: inline
In-Reply-To: <20210730173805.3926-2-Stefan.Maetje@esd.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xumgh6swjfevthav
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 30.07.2021 19:38:05, Stefan M=C3=A4tje wrote:
> This patch adds support for the PCI based PCIe/402 CAN interface family
> from esd GmbH that is available with various form factors
> (https://esd.eu/en/products/402-series-can-interfaces).

Thanks for the patch!

> All boards utilize a FPGA based CAN controller solution developed
> by esd (esdACC). For more information on the esdACC see
> https://esd.eu/en/products/esdacc.
>=20
> This driver detects all available CAN interface boards but atm.
> operates the CAN-FD capable devices in Classic-CAN mode only!
> A later patch will introduce the CAN-FD functionality in this
> driver.

Ok, please remove what's inside the #if ACC_ENABLE_CANFD for now, it can
be added in a later patch.

One general note about the devm_*() helper functions. The idea is that
you don't have to free the resources allocated with the devm_*()
functions, they are automatically freed in reverse order of allocation.
So it usually doesn't make any sense to have devm_kfree(). Same for the
IRQ handler.


This device supports HW timestamping. Please don't roll your own
conversion functions. Please make use of the timecounter/cyclecounter
API, have a look at the mcp251xfd driver for example:

https://elixir.bootlin.com/linux/v5.13/source/drivers/net/can/spi/mcp251xfd=
/mcp251xfd-timestamp.c#L52

The idea is that there is a counter of a certain with (here 32 bit) that
has a certain frequency (here: priv->can.clock.freq).

|	cc->read =3D mcp251xfd_timestamp_read;
|	cc->mask =3D CYCLECOUNTER_MASK(32);
|	cc->shift =3D 1;
|	cc->mult =3D clocksource_hz2mult(priv->can.clock.freq, cc->shift);

The conversion from the register value to ns in done with:
| ns =3D ((reg & mask) * mult) >> shift;
In the above example I'm using a shift of "1" as 1ns is an integer
multiple of the used frequency (which is 20 or 40 MHz).

To cope with overflows of the cycle counter, read the current timestamp
with timecounter_read() with at least the double frequency of the
overflows happening (plus some slack). The mcp251xfd driver sets up a
worker for this. The mcp251xfd drive does this every 45 seconds, with an
overflow happening every 107s.

This is not a complete review yet, but see some comments inside.

> Signed-off-by: Stefan M=C3=A4tje <Stefan.Maetje@esd.eu>
> ---
>  drivers/net/can/Kconfig                |   1 +
>  drivers/net/can/Makefile               |   1 +
>  drivers/net/can/esd/Kconfig            |  12 +
>  drivers/net/can/esd/Makefile           |   7 +
>  drivers/net/can/esd/esd_402_pci-core.c | 530 ++++++++++++++++++
>  drivers/net/can/esd/esdacc.c           | 717 +++++++++++++++++++++++++
>  drivers/net/can/esd/esdacc.h           | 394 ++++++++++++++
>  7 files changed, 1662 insertions(+)
>  create mode 100644 drivers/net/can/esd/Kconfig
>  create mode 100644 drivers/net/can/esd/Makefile
>  create mode 100644 drivers/net/can/esd/esd_402_pci-core.c
>  create mode 100644 drivers/net/can/esd/esdacc.c
>  create mode 100644 drivers/net/can/esd/esdacc.h
>=20
> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> index fff259247d52..47cfb6ae0772 100644
> --- a/drivers/net/can/Kconfig
> +++ b/drivers/net/can/Kconfig
> @@ -170,6 +170,7 @@ config PCH_CAN
> =20
>  source "drivers/net/can/c_can/Kconfig"
>  source "drivers/net/can/cc770/Kconfig"
> +source "drivers/net/can/esd/Kconfig"
>  source "drivers/net/can/ifi_canfd/Kconfig"
>  source "drivers/net/can/m_can/Kconfig"
>  source "drivers/net/can/mscan/Kconfig"
> diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
> index a2b4463d8480..5d5aeaaf02d7 100644
> --- a/drivers/net/can/Makefile
> +++ b/drivers/net/can/Makefile
> @@ -12,6 +12,7 @@ obj-y				+=3D rcar/
>  obj-y				+=3D spi/
>  obj-y				+=3D usb/
>  obj-y				+=3D softing/
> +obj-y				+=3D esd/

Nitpick:

That obj-y list is not sorted, however please move "esd/" after "dev/".

> =20
>  obj-$(CONFIG_CAN_AT91)		+=3D at91_can.o
>  obj-$(CONFIG_CAN_CC770)		+=3D cc770/
> diff --git a/drivers/net/can/esd/Kconfig b/drivers/net/can/esd/Kconfig
> new file mode 100644
> index 000000000000..54bfc366634c
> --- /dev/null
> +++ b/drivers/net/can/esd/Kconfig
> @@ -0,0 +1,12 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config CAN_ESD_402_PCI
> +	tristate "esd electronics gmbh CAN-PCI(e)/402 family"
> +	depends on PCI && HAS_DMA
> +	help
> +	  Support for C402 card family from esd electronics gmbh.
> +	  This card family is based on the ESDACC CAN controller and
> +	  available in several form factors:  PCI, PCIe, PCIe Mini,
> +	  M.2 PCIe, CPCIserial, PMC, XMC  (see https://esd.eu/en)
> +
> +	  This driver can also be built as a module. In this case the
> +	  module will be called esd_402_pci.
> diff --git a/drivers/net/can/esd/Makefile b/drivers/net/can/esd/Makefile
> new file mode 100644
> index 000000000000..5dd2d470c286
> --- /dev/null
> +++ b/drivers/net/can/esd/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +#  Makefile for esd gmbh ESDACC controller driver
> +#
> +esd_402_pci-objs :=3D esdacc.o esd_402_pci-core.o
> +
> +obj-$(CONFIG_CAN_ESD_402_PCI) +=3D esd_402_pci.o
> diff --git a/drivers/net/can/esd/esd_402_pci-core.c b/drivers/net/can/esd=
/esd_402_pci-core.c
> new file mode 100644
> index 000000000000..191e7f45c5d9
> --- /dev/null
> +++ b/drivers/net/can/esd/esd_402_pci-core.c
> @@ -0,0 +1,530 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (C) 2015 - 2017 esd electronic system design gmbh
> + * Copyright (C) 2017 - 2021 esd electronics gmbh
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/pci.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/netdevice.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/can.h>
> +#include <linux/can/dev.h>
> +#include <linux/can/netlink.h>
> +
> +#include "esdacc.h"
> +
> +#define DRV_NAME			"esd_402_pci"
> +
> +#define ESD_PCI_DEVICE_ID_PCIE402	0x0402
> +
> +#define PCI402_FPGA_VER_MIN		0x003d
> +#define PCI402_MAX_CORES		4
> +#define PCI402_BAR			0
> +#define PCI402_IO_OV_OFFS		0
> +#define PCI402_IO_PCIEP_OFFS		0x10000
> +#define PCI402_IO_LEN_TOTAL		0x20000
> +#define PCI402_IO_LEN_CORE		0x2000
> +#define PCI402_PCICFG_MSICAP_CSR	0x52
> +#define PCI402_PCICFG_MSICAP_ADDR	0x54
> +#define PCI402_PCICFG_MSICAP_DATA	0x5c
> +
> +#define PCI402_DMA_MASK			(DMA_BIT_MASK(32) & 0xffff0000)
> +#define PCI402_DMA_SIZE			ALIGN(0x10000, PAGE_SIZE)

The DMA API guarantees the memory to be aligned to pages and requested
size:

| The CPU virtual address and the DMA address are both guaranteed to be
| aligned to the smallest PAGE_SIZE order which is greater than or equal
| to the requested size. This invariant exists (for example) to
| guarantee that if you allocate a chunk which is smaller than or equal
| to 64 kilobytes, the extent of the buffer you receive will not cross a
| 64K boundary.

> +
> +#define PCI402_PCIEP_OF_INT_ENABLE	0x0050
> +#define PCI402_PCIEP_OF_BM_ADDR_LO	0x1000
> +#define PCI402_PCIEP_OF_BM_ADDR_HI	0x1004
> +#define PCI402_PCIEP_OF_MSI_ADDR_LO	0x1008
> +#define PCI402_PCIEP_OF_MSI_ADDR_HI	0x100c
> +
> +/* The BTR register capabilities described by the can_bittiming_const st=
ructures
> + * below are valid since ESDACC version 0x0032.
> + */
> +
> +/* Used if the ESDACC FPGA is built as CAN-Classic version. */
> +static const struct can_bittiming_const pci402_bittiming_const =3D {
> +	.name =3D "esd_402",
> +	.tseg1_min =3D 1,
> +	.tseg1_max =3D 16,
> +	.tseg2_min =3D 1,
> +	.tseg2_max =3D 8,
> +	.sjw_max =3D 4,
> +	.brp_min =3D 1,
> +	.brp_max =3D 512,
> +	.brp_inc =3D 1,
> +};
> +
> +/* Used if the ESDACC FPGA is built as CAN-FD version. */
> +static const struct can_bittiming_const pci402_bittiming_const_canfd =3D=
 {
> +	.name =3D "esd_402fd",
> +	.tseg1_min =3D 1,
> +	.tseg1_max =3D 256,
> +	.tseg2_min =3D 1,
> +	.tseg2_max =3D 128,
> +	.sjw_max =3D 128,
> +	.brp_min =3D 1,
> +	.brp_max =3D 256,
> +	.brp_inc =3D 1,
> +};
> +
> +#if ACC_ENABLE_CANFD
> +static const struct can_bittiming_const pci402_bittiming_const_canfd_dat=
a =3D {
> +	.name =3D "esd_402fd",
> +	.tseg1_min =3D 1,
> +	.tseg1_max =3D 32,
> +	.tseg2_min =3D 1,
> +	.tseg2_max =3D 16,
> +	.sjw_max =3D 16,
> +	.brp_min =3D 1,
> +	.brp_max =3D 256,
> +	.brp_inc =3D 1,
> +};
> +#endif
> +
> +static const struct net_device_ops pci402_acc_netdev_ops =3D {
> +	.ndo_open =3D acc_open,
> +	.ndo_stop =3D acc_close,
> +	.ndo_start_xmit =3D acc_start_xmit,
> +	.ndo_change_mtu =3D can_change_mtu
> +};
> +
> +struct pci402_card {
> +	/* Actually mapped io space, all other iomem derived from this */
> +	void __iomem *addr;
> +	void __iomem *addr_pciep;
> +
> +	void *dma_buf;
> +	dma_addr_t dma_hnd;
> +
> +	struct acc_ov ov;
> +	struct acc_core cores[PCI402_MAX_CORES];
> +
> +	bool msi_enabled;
> +	int irq_stack;
> +};
> +
> +static irqreturn_t pci402_interrupt(int irq, void *dev_id)
> +{
> +	struct pci_dev *pdev =3D dev_id;
> +	struct pci402_card *card =3D pci_get_drvdata(pdev);
> +	irqreturn_t irq_status;
> +	int irq_level_out;
> +	int irq_level_in;
> +
> +	/* Use <irq_stack> to check for IRQ multi service on multiple CPUs. */
> +	irq_level_in =3D __sync_fetch_and_add(&card->irq_stack, 1);
> +
> +	irq_status =3D acc_card_interrupt(&card->ov, card->cores);
> +
> +	irq_level_out =3D __sync_sub_and_fetch(&card->irq_stack, 1);
> +
> +	if (irq_level_in || irq_level_out) {
> +		pci_warn(pdev, "%s(): Bad level, in %d, out %d\n",
> +			 __func__, irq_level_in, irq_level_out);
> +	}
> +
> +	return irq_status;
> +}
> +
> +static int pci402_set_msiconfig(struct pci_dev *pdev)
> +{
> +	struct pci402_card *card =3D pci_get_drvdata(pdev);
> +	u32 addr_lo_offs =3D 0;
> +	u32 addr_lo =3D 0;
> +	u32 addr_hi =3D 0;
> +	u32 data =3D 0;
> +	u16 csr =3D 0;
> +	int err;
> +
> +	err =3D pci_read_config_word(pdev, PCI402_PCICFG_MSICAP_CSR, &csr);
> +	if (err)
> +		goto failed;
> +
> +	err =3D pci_read_config_dword(pdev, PCI402_PCICFG_MSICAP_ADDR, &addr_lo=
);
> +	if (err)
> +		goto failed;
> +	err =3D pci_read_config_dword(pdev, PCI402_PCICFG_MSICAP_ADDR + 4,
> +				    &addr_hi);
> +	if (err)
> +		goto failed;
> +
> +	err =3D pci_read_config_dword(pdev, PCI402_PCICFG_MSICAP_DATA, &data);
> +	if (err)
> +		goto failed;
> +
> +	addr_lo_offs =3D addr_lo & 0x0000ffff;
> +	addr_lo &=3D 0xffff0000;
> +
> +	if (addr_hi)
> +		addr_lo |=3D 1; /* Enable 64-Bit addressing in address space */
> +
> +	if (!(csr & 0x0001)) { /* Enable bit */
> +		err =3D -EINVAL;
> +		goto failed;
> +	}
> +
> +	iowrite32(addr_lo, card->addr_pciep + PCI402_PCIEP_OF_MSI_ADDR_LO);
> +	iowrite32(addr_hi, card->addr_pciep + PCI402_PCIEP_OF_MSI_ADDR_HI);
> +	acc_ov_write32(&card->ov, ACC_OV_OF_MSI_ADDRESSOFFSET, addr_lo_offs);
> +	acc_ov_write32(&card->ov, ACC_OV_OF_MSI_DATA, data);
> +
> +	return 0;
> +
> +failed:
> +	pci_warn(pdev, "Error while setting MSI configuration:\n"
> +		 "CSR: 0x%.4x, addr: 0x%.8x%.8x, data: 0x%.8x\n",
> +		 csr, addr_hi, addr_lo, data);
> +
> +	return err;
> +}
> +
> +static int pci402_init_card(struct pci_dev *pdev)
> +{
> +	struct pci402_card *card =3D pci_get_drvdata(pdev);
> +
> +	card->ov.addr =3D card->addr + PCI402_IO_OV_OFFS;
> +	card->addr_pciep =3D card->addr + PCI402_IO_PCIEP_OFFS;
> +
> +	acc_reset_fpga(&card->ov);
> +	acc_init_ov(&card->ov, &pdev->dev);
> +
> +	if (card->ov.version < PCI402_FPGA_VER_MIN) {
> +		pci_err(pdev,
> +			"ESDACC version (0x%.4x) outdated, please update\n",
> +			card->ov.version);
> +		return -EINVAL;
> +	}
> +
> +	if (card->ov.active_cores > PCI402_MAX_CORES) {
> +		pci_warn(pdev,
> +			 "Card has more active cores than supported by driver, %u core(s) wil=
l be ignored\n",
> +			 card->ov.active_cores - PCI402_MAX_CORES);
> +		card->ov.active_cores =3D PCI402_MAX_CORES;

Is this a valid concern? You may want to allocate the memory for the
cores dynamically.

> +	}
> +
> +	if (card->ov.features & ACC_OV_REG_FEAT_MASK_CANFD) {
> +		pci_warn(pdev,
> +			 "ESDACC with CAN-FD feature detected. This driver doesn't support CA=
N-FD yet.\n");
> +	}
> +
> +#ifdef __LITTLE_ENDIAN
> +	/* So card converts all busmastered data to LE for us: */
> +	acc_ov_set_bits(&card->ov, ACC_OV_OF_MODE,
> +			ACC_OV_REG_MODE_MASK_ENDIAN_LITTLE);
> +#endif
> +
> +	return 0;
> +}
> +
> +static int pci402_init_interrupt(struct pci_dev *pdev)
> +{
> +	struct pci402_card *card =3D pci_get_drvdata(pdev);
> +	int err;
> +
> +	err =3D pci_enable_msi(pdev);
> +	if (!err) {
> +		err =3D pci402_set_msiconfig(pdev);
> +		if (!err) {
> +			card->msi_enabled =3D true;
> +			acc_ov_set_bits(&card->ov, ACC_OV_OF_MODE,
> +					ACC_OV_REG_MODE_MASK_MSI_ENABLE);
> +			pci_info(pdev, "MSI enabled\n");
> +		}
> +	}
> +
> +	err =3D devm_request_irq(&pdev->dev, pdev->irq, pci402_interrupt,
> +			       IRQF_SHARED, dev_name(&pdev->dev), pdev);
> +	if (err)
> +		goto failure_msidis;
> +
> +	iowrite32(1, card->addr_pciep + PCI402_PCIEP_OF_INT_ENABLE);
> +
> +	return 0;
> +
> +failure_msidis:
> +	if (card->msi_enabled) {
> +		acc_ov_clear_bits(&card->ov, ACC_OV_OF_MODE,
> +				  ACC_OV_REG_MODE_MASK_MSI_ENABLE);
> +		pci_disable_msi(pdev);
> +		card->msi_enabled =3D false;
> +	}
> +
> +	return err;
> +}
> +
> +static void pci402_finish_interrupt(struct pci_dev *pdev)
> +{
> +	struct pci402_card *card =3D pci_get_drvdata(pdev);
> +
> +	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_INT_ENABLE);
> +	devm_free_irq(&pdev->dev, pdev->irq, pdev);
> +
> +	if (card->msi_enabled) {
> +		acc_ov_clear_bits(&card->ov, ACC_OV_OF_MODE,
> +				  ACC_OV_REG_MODE_MASK_MSI_ENABLE);
> +		pci_disable_msi(pdev);
> +		card->msi_enabled =3D false;
> +	}
> +}
> +
> +static int pci402_init_dma(struct pci_dev *pdev)
> +{
> +	struct pci402_card *card =3D pci_get_drvdata(pdev);
> +	int err;
> +
> +	err =3D pci_set_consistent_dma_mask(pdev, PCI402_DMA_MASK);

The consistent functions seem to be outdated, use dma_set_coherent_mask ins=
tead.

> +	if (err) {
> +		pci_err(pdev, "DMA set mask failed!\n");
> +		return err;
> +	}
> +
> +	card->dma_buf =3D pci_alloc_consistent(pdev, PCI402_DMA_SIZE,
> +					     &card->dma_hnd);

Please use dma_alloc_coherent() instead.

> +	if (!card->dma_buf) {
> +		pci_err(pdev, "DMA alloc failed!\n");
> +		return -ENOMEM;
> +	}
> +	if ((card->dma_hnd & PCI402_DMA_MASK) !=3D card->dma_hnd) {

I think the dma core will give you properly aligned memory...

> +		pci_err(pdev, "Misaligned DMA buffer: address %px, DMA %pad, mask %llx=
\n",
> +			card->dma_buf, &card->dma_hnd, (u64)PCI402_DMA_MASK);
> +		pci_free_consistent(pdev, PCI402_DMA_SIZE, card->dma_buf,
> +				    card->dma_hnd);
> +		card->dma_buf =3D NULL;
> +		return -ENOMEM;
> +	}
> +
> +	acc_init_bm_ptr(&card->ov, card->cores, card->dma_buf);
> +
> +	iowrite32((u32)card->dma_hnd,
> +		  card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_LO);
> +	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_HI);
> +
> +	pci_set_master(pdev);
> +
> +	acc_ov_set_bits(&card->ov, ACC_OV_OF_MODE,
> +			ACC_OV_REG_MODE_MASK_BM_ENABLE);
> +
> +	return 0;
> +}
> +
> +static void pci402_finish_dma(struct pci_dev *pdev)
> +{
> +	struct pci402_card *card =3D pci_get_drvdata(pdev);
> +	int i;
> +
> +	acc_ov_clear_bits(&card->ov, ACC_OV_OF_MODE,
> +			  ACC_OV_REG_MODE_MASK_BM_ENABLE);
> +
> +	pci_clear_master(pdev);
> +
> +	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_LO);
> +	iowrite32(0, card->addr_pciep + PCI402_PCIEP_OF_BM_ADDR_HI);
> +
> +	card->ov.bmfifo.messages =3D NULL;
> +	card->ov.bmfifo.irq_cnt =3D NULL;
> +	for (i =3D 0; i < card->ov.active_cores; i++) {
> +		struct acc_core *core =3D &card->cores[i];
> +
> +		core->bmfifo.messages =3D NULL;
> +		core->bmfifo.irq_cnt =3D NULL;
> +	}
> +
> +	pci_free_consistent(pdev, PCI402_DMA_SIZE, card->dma_buf,
> +			    card->dma_hnd);
> +	card->dma_buf =3D NULL;
> +}
> +
> +static int pci402_init_cores(struct pci_dev *pdev)
> +{
> +	struct pci402_card *card =3D pci_get_drvdata(pdev);
> +	int err;
> +	int i;
> +
> +	for (i =3D 0; i < card->ov.active_cores; i++) {
> +		struct acc_core *core =3D &card->cores[i];
> +		struct acc_net_priv *priv;
> +		struct net_device *netdev;
> +		u32 fifo_config;
> +
> +		core->addr =3D card->ov.addr + (i + 1) * PCI402_IO_LEN_CORE;
> +
> +		fifo_config =3D acc_read32(core, ACC_CORE_OF_TXFIFO_CONFIG);
> +		core->tx_fifo_size =3D (u8)(fifo_config >> 24);
> +		if (core->tx_fifo_size <=3D 1) {
> +			pci_err(pdev, "Invalid tx_fifo_size!\n");
> +			err =3D -EINVAL;
> +			goto failure;
> +		}
> +
> +		netdev =3D alloc_candev(sizeof(*priv), core->tx_fifo_size);
> +		if (!netdev) {
> +			err =3D -ENOMEM;
> +			goto failure;
> +		}
> +		core->net_dev =3D netdev;
> +
> +		netdev->flags |=3D IFF_ECHO;
> +		netdev->netdev_ops =3D &pci402_acc_netdev_ops;
> +		SET_NETDEV_DEV(netdev, &pdev->dev);
> +
> +		priv =3D netdev_priv(netdev);
> +		priv->can.state =3D CAN_STATE_STOPPED;
> +		priv->can.ctrlmode_supported =3D CAN_CTRLMODE_LISTENONLY |
> +			CAN_CTRLMODE_BERR_REPORTING |
> +			CAN_CTRLMODE_CC_LEN8_DLC |
> +			CAN_CTRLMODE_LOOPBACK;
> +		priv->can.clock.freq =3D card->ov.core_frequency;
> +		priv->can.bittiming_const =3D
> +			(card->ov.features & ACC_OV_REG_FEAT_MASK_CANFD) ?
> +			&pci402_bittiming_const_canfd :
> +			&pci402_bittiming_const;
> +		priv->can.do_set_bittiming =3D acc_set_bittiming;
> +		priv->can.do_set_mode =3D acc_set_mode;
> +		priv->can.do_get_berr_counter =3D acc_get_berr_counter;
> +
> +		priv->core =3D core;
> +		priv->ov =3D &card->ov;
> +
> +		err =3D register_candev(netdev);
> +		if (err) {
> +			free_candev(core->net_dev);
> +			core->net_dev =3D NULL;
> +			goto failure;
> +		}
> +
> +		netdev_info(netdev, "registered\n");
> +	}
> +
> +	return 0;
> +
> +failure:
> +	for (i--; i >=3D 0; i--) {
> +		struct acc_core *core =3D &card->cores[i];
> +
> +		netdev_info(core->net_dev, "unregistering...\n");
> +		unregister_candev(core->net_dev);
> +
> +		free_candev(core->net_dev);
> +		core->net_dev =3D NULL;
> +	}
> +
> +	return err;
> +}
> +
> +static void pci402_finish_cores(struct pci_dev *pdev)
> +{
> +	struct pci402_card *card =3D pci_get_drvdata(pdev);
> +	int i;
> +
> +	for (i =3D 0; i < card->ov.active_cores; i++) {
> +		struct acc_core *core =3D &card->cores[i];
> +
> +		netdev_info(core->net_dev, "unregister\n");
> +		unregister_candev(core->net_dev);
> +
> +		free_candev(core->net_dev);
> +		core->net_dev =3D NULL;
> +	}
> +}
> +
> +static int pci402_probe(struct pci_dev *pdev, const struct pci_device_id=
 *ent)
> +{
> +	struct pci402_card *card =3D NULL;
> +	int err;
> +
> +	err =3D pci_enable_device(pdev);
> +	if (err)
> +		return err;
> +
> +	card =3D devm_kzalloc(&pdev->dev, sizeof(*card), GFP_KERNEL);
> +	if (!card)
> +		goto failure_disable_pci;
> +
> +	pci_set_drvdata(pdev, card);
> +
> +	err =3D pci_request_regions(pdev, pci_name(pdev));
> +	if (err)
> +		goto failure_free_card;
> +
> +	card->addr =3D pci_iomap(pdev, PCI402_BAR, PCI402_IO_LEN_TOTAL);
> +	if (!card->addr) {
> +		err =3D -ENOMEM;
> +		goto failure_release_regions;
> +	}
> +
> +	err =3D pci402_init_card(pdev);
> +	if (err)
> +		goto failure_unmap;
> +
> +	err =3D pci402_init_dma(pdev);
> +	if (err)
> +		goto failure_unmap;
> +
> +	err =3D pci402_init_interrupt(pdev);
> +	if (err)
> +		goto failure_finish_dma;
> +
> +	err =3D pci402_init_cores(pdev);
> +	if (err)
> +		goto failure_finish_interrupt;
> +
> +	return 0;
> +
> +failure_finish_interrupt:
> +	pci402_finish_interrupt(pdev);
> +
> +failure_finish_dma:
> +	pci402_finish_dma(pdev);
> +
> +failure_unmap:
> +	pci_iounmap(pdev, card->addr);
> +
> +failure_release_regions:
> +	pci_release_regions(pdev);
> +
> +failure_free_card:
> +	devm_kfree(&pdev->dev, card);
> +
> +failure_disable_pci:
> +	pci_disable_device(pdev);
> +
> +	return err;
> +}
> +
> +static void pci402_remove(struct pci_dev *pdev)
> +{
> +	struct pci402_card *card =3D pci_get_drvdata(pdev);
> +
> +	pci402_finish_interrupt(pdev);
> +	pci402_finish_cores(pdev);
> +	pci402_finish_dma(pdev);
> +	pci_iounmap(pdev, card->addr);
> +	pci_release_regions(pdev);
> +	pci_disable_device(pdev);
> +	devm_kfree(&pdev->dev, card);
> +}
> +
> +static const struct pci_device_id pci402_tbl[] =3D {
> +	{ PCI_VENDOR_ID_ESDGMBH, ESD_PCI_DEVICE_ID_PCIE402,
> +			PCI_ANY_ID, PCI_ANY_ID, },
> +	{ 0, }
> +};
> +MODULE_DEVICE_TABLE(pci, pci402_tbl);
> +
> +static struct pci_driver pci402_driver =3D {
> +	.name =3D DRV_NAME,
> +	.id_table =3D pci402_tbl,
> +	.probe =3D pci402_probe,
> +	.remove =3D pci402_remove,
> +};
> +
> +module_pci_driver(pci402_driver);
> +
> +MODULE_DESCRIPTION("Socket-CAN driver for esd CAN PCI(e)/402 cards");
> +MODULE_AUTHOR("Thomas K=C3=B6rper <thomas.koerper@esd.eu>");
> +MODULE_AUTHOR("Stefan M=C3=A4tje <stefan.maetje@esd.eu>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/net/can/esd/esdacc.c b/drivers/net/can/esd/esdacc.c
> new file mode 100644
> index 000000000000..bc85b948db6c
> --- /dev/null
> +++ b/drivers/net/can/esd/esdacc.c
> @@ -0,0 +1,717 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (C) 2015 - 2017 esd electronic system design gmbh
> + * Copyright (C) 2017 - 2021 esd electronics gmbh
> + */
> +
> +#include <linux/ktime.h>
> +#include <linux/gcd.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include "esdacc.h"
> +
> +/* ecc value of esdACC equals SJA1000's ECC register */
> +#define ACC_ECC_SEG			0x1f
> +#define ACC_ECC_DIR			0x20
> +#define ACC_ECC_BIT			0x00
> +#define ACC_ECC_FORM			0x40
> +#define ACC_ECC_STUFF			0x80
> +#define ACC_ECC_MASK			0xc0
> +
> +#define ACC_BM_IRQ_UNMASK_ALL		0x55555555U
> +#define ACC_BM_IRQ_MASK_ALL		0xaaaaaaaaU
> +#define ACC_BM_IRQ_MASK			0x2U
> +#define ACC_BM_IRQ_UNMASK		0x1U
> +#define ACC_BM_LENFLAG_TX		0x20
> +
> +#define ACC_REG_STATUS_IDX_STATUS_DOS	16
> +#define ACC_REG_STATUS_IDX_STATUS_ES	17
> +#define ACC_REG_STATUS_IDX_STATUS_EP	18
> +#define ACC_REG_STATUS_IDX_STATUS_BS	19
> +#define ACC_REG_STATUS_IDX_STATUS_RBS	20
> +#define ACC_REG_STATUS_IDX_STATUS_RS	21
> +#define ACC_REG_STATUS_MASK_STATUS_DOS	BIT(ACC_REG_STATUS_IDX_STATUS_DOS)
> +#define ACC_REG_STATUS_MASK_STATUS_ES	BIT(ACC_REG_STATUS_IDX_STATUS_ES)
> +#define ACC_REG_STATUS_MASK_STATUS_EP	BIT(ACC_REG_STATUS_IDX_STATUS_EP)
> +#define ACC_REG_STATUS_MASK_STATUS_BS	BIT(ACC_REG_STATUS_IDX_STATUS_BS)
> +#define ACC_REG_STATUS_MASK_STATUS_RBS	BIT(ACC_REG_STATUS_IDX_STATUS_RBS)
> +#define ACC_REG_STATUS_MASK_STATUS_RS	BIT(ACC_REG_STATUS_IDX_STATUS_RS)
> +
> +static void acc_resetmode_enter(struct acc_core *core)
> +{
> +	int i;
> +
> +	acc_set_bits(core, ACC_CORE_OF_CTRL_MODE,
> +		     ACC_REG_CONTROL_MASK_MODE_RESETMODE);
> +
> +	for (i =3D 0; i < 10; i++) {
> +		if (acc_resetmode_entered(core))
> +			return;
> +
> +		udelay(5);
> +	}
> +
> +	netdev_warn(core->net_dev, "Entering reset mode timed out\n");
> +}
> +
> +static void acc_resetmode_leave(struct acc_core *core)
> +{
> +	int i;
> +
> +	acc_clear_bits(core, ACC_CORE_OF_CTRL_MODE,
> +		       ACC_REG_CONTROL_MASK_MODE_RESETMODE);
> +
> +	for (i =3D 0; i < 10; i++) {
> +		if (!acc_resetmode_entered(core))
> +			return;
> +
> +		udelay(5);
> +	}
> +
> +	netdev_warn(core->net_dev, "Leaving reset mode timed out\n");
> +}
> +
> +static void acc_txq_put(struct acc_core *core, u32 acc_id, u8 acc_dlc,
> +			const void *data)
> +{
> +	acc_write32_noswap(core, ACC_CORE_OF_TXFIFO_DATA_1,
> +			   *((const u32 *)(data + 4)));
> +	acc_write32_noswap(core, ACC_CORE_OF_TXFIFO_DATA_0,
> +			   *((const u32 *)data));
> +	acc_write32(core, ACC_CORE_OF_TXFIFO_DLC, acc_dlc);
> +	/* CAN id must be written at last. This write starts TX. */
> +	acc_write32(core, ACC_CORE_OF_TXFIFO_ID, acc_id);
> +}
> +
> +/* Prepare conversion factor from ESDACC time stamp ticks to ns
> + *
> + * The conversion factor ts2ns from time stamp counts to ns is basically
> + *	ts2ns =3D NSEC_PER_SEC / timestamp_frequency
> + *
> + * To avoid an overflow, the ts2ns fraction is truncated with its gcd and
> + * only the truncated numerator and denominator are used further.
> + */
> +static void acc_init_ov_ts2ns(struct acc_ov *ov)
> +{
> +	u32 ts2ns_gcd =3D (u32)gcd(NSEC_PER_SEC, ov->timestamp_frequency);
> +
> +	ov->ts2ns_numerator =3D (u32)NSEC_PER_SEC / ts2ns_gcd;
> +	ov->ts2ns_denominator =3D ov->timestamp_frequency / ts2ns_gcd;
> +}
> +
> +static ktime_t acc_ts2ktime(struct acc_ov *ov, u64 ts)
> +{
> +	u64 ns;
> +
> +	ts =3D ts * ov->ts2ns_numerator;
> +	ns =3D div_u64(ts, ov->ts2ns_denominator);
> +
> +	return ns_to_ktime(ns);
> +}
> +
> +void acc_init_ov(struct acc_ov *ov, struct device *dev)
> +{
> +	u32 temp;
> +	/* For the justification of this see comment on struct acc_bmmsg*
> +	 * in esdacc.h.
> +	 */
> +	BUILD_BUG_ON(sizeof(struct acc_bmmsg) !=3D ACC_CORE_DMAMSG_SIZE);
> +
> +	temp =3D acc_ov_read32(ov, ACC_OV_OF_VERSION);
> +	ov->version =3D (u16)temp;
> +	ov->features =3D (u16)(temp >> 16);
> +
> +	temp =3D acc_ov_read32(ov, ACC_OV_OF_INFO);
> +	ov->total_cores =3D (u8)temp;
> +	ov->active_cores =3D (u8)(temp >> 8);
> +
> +	ov->core_frequency =3D acc_ov_read32(ov, ACC_OV_OF_CANCORE_FREQ);
> +	ov->timestamp_frequency =3D acc_ov_read32(ov, ACC_OV_OF_TS_FREQ_LO);
> +	acc_init_ov_ts2ns(ov);
> +
> +	/* Depending on ESDACC feature NEW_PSC enable the new prescaler
> +	 * or adjust core_frequency according to the implicit division by 2.
> +	 */
> +	if (ov->features & ACC_OV_REG_FEAT_MASK_NEW_PSC) {
> +		acc_ov_set_bits(ov, ACC_OV_OF_MODE,
> +				ACC_OV_REG_MODE_MASK_NEW_PSC_ENABLE);
> +	} else {
> +		ov->core_frequency /=3D 2;
> +	}
> +
> +	dev_info(dev,
> +		 "ESDACC v%u, freq: %u/%u, feat/strap: 0x%x/0x%x, cores: %u/%u\n",
> +		 ov->version, ov->core_frequency, ov->timestamp_frequency,
> +		 ov->features, acc_ov_read32(ov, ACC_OV_OF_INFO) >> 16,
> +		 ov->active_cores, ov->total_cores);
> +	dev_dbg(dev, "ESDACC ts2ns: numerator %u, denominator %u\n",
> +		ov->ts2ns_numerator, ov->ts2ns_denominator);
> +}
> +
> +void acc_init_bm_ptr(struct acc_ov *ov, struct acc_core *cores, const vo=
id *mem)
> +{
> +	unsigned int u;
> +
> +	/* DMA buffer layout as follows where N is the number of CAN cores
> +	 * implemented in the FPGA, i.e. N =3D ov->total_cores
> +	 *
> +	 *   Layout                   Section size
> +	 * +-----------------------+
> +	 * | FIFO Card/Overview	   |  ACC_CORE_DMABUF_SIZE
> +	 * |			   |
> +	 * +-----------------------+
> +	 * | FIFO Core0		   |  ACC_CORE_DMABUF_SIZE
> +	 * |			   |
> +	 * +-----------------------+
> +	 * | ...		   |  ...
> +	 * |			   |
> +	 * +-----------------------+
> +	 * | FIFO CoreN		   |  ACC_CORE_DMABUF_SIZE
> +	 * |			   |
> +	 * +-----------------------+
> +	 * | irq_cnt Card/Overview |  sizeof(u32)
> +	 * +-----------------------+
> +	 * | irq_cnt Core0	   |  sizeof(u32)
> +	 * +-----------------------+
> +	 * | ...		   |  ...
> +	 * +-----------------------+
> +	 * | irq_cnt CoreN	   |  sizeof(u32)
> +	 * +-----------------------+
> +	 */
> +	ov->bmfifo.messages =3D mem;
> +	ov->bmfifo.irq_cnt =3D mem + (ov->total_cores + 1U) * ACC_CORE_DMABUF_S=
IZE;
> +
> +	for (u =3D 0U; u < ov->active_cores; u++) {
> +		struct acc_core *core =3D &cores[u];
> +
> +		core->bmfifo.messages =3D mem + (u + 1U) * ACC_CORE_DMABUF_SIZE;
> +		core->bmfifo.irq_cnt =3D ov->bmfifo.irq_cnt + (u + 1U);
> +	}
> +}
> +
> +int acc_open(struct net_device *netdev)
> +{
> +	struct acc_net_priv *priv =3D netdev_priv(netdev);
> +	u32 ctrl_mode;
> +	int err;
> +
> +	err =3D open_candev(netdev);
> +	if (err)
> +		return err;
> +
> +	ctrl_mode =3D ACC_REG_CONTROL_MASK_IE_RXTX |
> +			ACC_REG_CONTROL_MASK_IE_TXERROR |
> +			ACC_REG_CONTROL_MASK_IE_ERRWARN |
> +			ACC_REG_CONTROL_MASK_IE_OVERRUN |
> +			ACC_REG_CONTROL_MASK_IE_ERRPASS;
> +
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)
> +		ctrl_mode |=3D ACC_REG_CONTROL_MASK_IE_BUSERR;
> +
> +	acc_set_bits(priv->core, ACC_CORE_OF_CTRL_MODE, ctrl_mode);
> +
> +	priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
> +	netif_start_queue(netdev);
> +	return 0;
> +}
> +
> +int acc_close(struct net_device *netdev)
> +{
> +	struct acc_net_priv *priv =3D netdev_priv(netdev);
> +
> +	acc_clear_bits(priv->core, ACC_CORE_OF_CTRL_MODE,
> +		       ACC_REG_CONTROL_MASK_IE_RXTX |
> +		       ACC_REG_CONTROL_MASK_IE_TXERROR |
> +		       ACC_REG_CONTROL_MASK_IE_ERRWARN |
> +		       ACC_REG_CONTROL_MASK_IE_OVERRUN |
> +		       ACC_REG_CONTROL_MASK_IE_ERRPASS |
> +		       ACC_REG_CONTROL_MASK_IE_BUSERR);
> +
> +	netif_stop_queue(netdev);
> +	priv->can.state =3D CAN_STATE_STOPPED;
> +
> +	close_candev(netdev);
> +	return 0;
> +}
> +
> +netdev_tx_t acc_start_xmit(struct sk_buff *skb, struct net_device *netde=
v)
> +{
> +	struct acc_net_priv *priv =3D netdev_priv(netdev);
> +	struct acc_core *core =3D priv->core;
> +	struct can_frame *cf =3D (struct can_frame *)skb->data;
> +	u8 tx_fifo_head =3D core->tx_fifo_head;
> +	int fifo_usage;
> +	u32 acc_id;
> +	u8 acc_dlc;
> +
> +	/* Access core->tx_fifo_tail only once because it may be changed
> +	 * from the interrupt level.
> +	 */
> +	fifo_usage =3D tx_fifo_head - core->tx_fifo_tail;
> +	if (fifo_usage < 0)
> +		fifo_usage +=3D core->tx_fifo_size;
> +
> +	if (fifo_usage >=3D core->tx_fifo_size - 1) {
> +		netdev_err(core->net_dev,
> +			   "BUG: TX ring full when queue awake!\n");
> +		netif_stop_queue(netdev);
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	if (fifo_usage =3D=3D core->tx_fifo_size - 2)
> +		netif_stop_queue(netdev);
> +
> +	acc_dlc =3D can_get_cc_dlc(cf, priv->can.ctrlmode);
> +	if (cf->can_id & CAN_RTR_FLAG)
> +		acc_dlc |=3D ACC_CAN_RTR_FLAG;
> +
> +	if (cf->can_id & CAN_EFF_FLAG) {
> +		acc_id =3D cf->can_id & CAN_EFF_MASK;
> +		acc_id |=3D ACC_CAN_EFF_FLAG;
> +	} else {
> +		acc_id =3D cf->can_id & CAN_SFF_MASK;
> +	}
> +
> +	can_put_echo_skb(skb, netdev, core->tx_fifo_head, 0);
> +
> +	++tx_fifo_head;
> +	if (tx_fifo_head >=3D core->tx_fifo_size)
> +		tx_fifo_head =3D 0U;
> +	core->tx_fifo_head =3D tx_fifo_head;
> +
> +	acc_txq_put(core, acc_id, acc_dlc, cf->data);
> +
> +	return NETDEV_TX_OK;
> +}
> +
> +int acc_get_berr_counter(const struct net_device *netdev,
> +			 struct can_berr_counter *bec)
> +{
> +	struct acc_net_priv *priv =3D netdev_priv(netdev);
> +	u32 core_status =3D acc_read32(priv->core, ACC_CORE_OF_STATUS);
> +
> +	bec->txerr =3D (core_status >> 8) & 0xff;
> +	bec->rxerr =3D core_status & 0xff;
> +
> +	return 0;
> +}
> +
> +int acc_set_mode(struct net_device *netdev, enum can_mode mode)
> +{
> +	struct acc_net_priv *priv =3D netdev_priv(netdev);
> +
> +	switch (mode) {
> +	case CAN_MODE_START:
> +		acc_resetmode_leave(priv->core);
> +		netif_wake_queue(netdev);
> +		break;
> +
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +int acc_set_bittiming(struct net_device *netdev)
> +{
> +	struct acc_net_priv *priv =3D netdev_priv(netdev);
> +	const struct can_bittiming *bt =3D &priv->can.bittiming;
> +#if ACC_ENABLE_CANFD
> +	const struct can_bittiming *dbt =3D &priv->can.data_bittiming;
> +#endif
> +	u32 brp =3D bt->brp - 1;
> +	u32 btr;
> +
> +	acc_resetmode_enter(priv->core);
> +
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
> +		acc_set_bits(priv->core, ACC_CORE_OF_CTRL_MODE,
> +			     ACC_REG_CONTROL_MASK_MODE_LOM);
> +	else
> +		acc_clear_bits(priv->core, ACC_CORE_OF_CTRL_MODE,
> +			       ACC_REG_CONTROL_MASK_MODE_LOM);
> +
> +	if (priv->ov->features & ACC_OV_REG_FEAT_MASK_CANFD) {
> +		u32 fbtr =3D 0;
> +
> +		netdev_dbg(priv->core->net_dev,
> +			   "bit timing: brp %u, prop %u, ph1 %u ph2 %u, sjw %u\n",
> +			   bt->brp, bt->prop_seg,
> +			   bt->phase_seg1, bt->phase_seg2, bt->sjw);
> +
> +		/* BRP: 8 bits @ bits 7..0 */
> +		brp &=3D 0xff;
> +
> +		/* TSEG1: 8 bits @ bits 7..0 */
> +		btr =3D (bt->phase_seg1 + bt->prop_seg - 1) & 0xff;
> +		/* TSEG2: 7 bits @ bits 22..16 */
> +		btr |=3D ((bt->phase_seg2 - 1) & 0x7f) << 16;
> +		/* SJW: 7 bits @ bits 30..24 */
> +		btr |=3D ((bt->sjw - 1) & 0x7f) << 24;
> +
> +		/* Keep order of accesses to ACC_CORE_OF_BRP and ACC_CORE_OF_BTR. */
> +		acc_write32(priv->core, ACC_CORE_OF_BRP, brp);
> +		acc_write32(priv->core, ACC_CORE_OF_BTR, btr);
> +
> +#if ACC_ENABLE_CANFD
> +		/* Add setup of ACC_CORE_OF_FBTR for CAN-FD data phase here. */
> +		acc_write32(priv->core, ACC_CORE_OF_FBTR, fbtr);
> +#endif
> +
> +		netdev_info(priv->core->net_dev,
> +			    "ESDACC: BRP %u, NBTR 0x%08x, DBTR 0x%08x",
> +			    brp, btr, fbtr);
> +	} else {
> +		netdev_dbg(priv->core->net_dev,
> +			   "bit timing: brp %u, prop %u, ph1 %u ph2 %u, sjw %u\n",
> +			   bt->brp, bt->prop_seg,
> +			   bt->phase_seg1, bt->phase_seg2, bt->sjw);
> +
> +		/* BRP: 9 bits @ bits 8..0 */
> +		brp &=3D 0x1ff;
> +
> +		/* TSEG1: 4 bits @ bits 3..0 */
> +		btr =3D (bt->phase_seg1 + bt->prop_seg - 1) & 0xf;
> +		/* TSEG2: 3 bits @ bits 18..16*/
> +		btr |=3D ((bt->phase_seg2 - 1) & 0x7) << 16;
> +		/* SJW: 2 bits @ bits 25..24 */
> +		btr |=3D ((bt->sjw - 1) & 0x3) << 24;
> +
> +		/* Keep order of accesses to ACC_CORE_OF_BRP and ACC_CORE_OF_BTR. */
> +		acc_write32(priv->core, ACC_CORE_OF_BRP, brp);
> +		acc_write32(priv->core, ACC_CORE_OF_BTR, btr);
> +
> +		netdev_info(priv->core->net_dev, "ESDACC: BRP %u, BTR 0x%08x",
> +			    brp, btr);
> +	}
> +
> +	acc_resetmode_leave(priv->core);
> +	priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
> +
> +	return 0;
> +}
> +
> +static void handle_core_msg_rxtxdone(struct acc_core *core,
> +				     const struct acc_bmmsg_rxtxdone *msg)
> +{
> +	struct acc_net_priv *priv =3D netdev_priv(core->net_dev);
> +	struct net_device_stats *stats =3D &core->net_dev->stats;
> +	struct sk_buff *skb;
> +
> +	if (msg->dlc.rxtx.len & ACC_BM_LENFLAG_TX) {
> +		u8 tx_fifo_tail =3D core->tx_fifo_tail;
> +
> +		if (core->tx_fifo_head =3D=3D tx_fifo_tail) {
> +			netdev_warn(core->net_dev,
> +				    "TX interrupt, but queue is empty!?\n");
> +			return;
> +		}
> +
> +		/* Direct access echo skb to attach HW time stamp. */
> +		skb =3D priv->can.echo_skb[tx_fifo_tail];
> +		if (skb) {
> +			skb_hwtstamps(skb)->hwtstamp =3D
> +				acc_ts2ktime(priv->ov, msg->ts);
> +		}
> +
> +		stats->tx_packets++;
> +		stats->tx_bytes +=3D can_get_echo_skb(core->net_dev, tx_fifo_tail,
> +						    NULL);
> +
> +		++tx_fifo_tail;
> +		if (tx_fifo_tail >=3D core->tx_fifo_size)
> +			tx_fifo_tail =3D 0U;
> +		core->tx_fifo_tail =3D tx_fifo_tail;
> +
> +		netif_wake_queue(core->net_dev);
> +
> +	} else {
> +		struct can_frame *cf;
> +
> +		skb =3D alloc_can_skb(core->net_dev, &cf);
> +		if (!skb) {
> +			stats->rx_dropped++;
> +			return;
> +		}
> +
> +		cf->can_id =3D msg->id & CAN_EFF_MASK;
> +		if (msg->id & ACC_CAN_EFF_FLAG)
> +			cf->can_id |=3D CAN_EFF_FLAG;
> +
> +		can_frame_set_cc_len(cf, msg->dlc.rx.len & ACC_CAN_DLC_MASK,
> +				     priv->can.ctrlmode);
> +
> +		if (msg->dlc.rx.len & ACC_CAN_RTR_FLAG)
> +			cf->can_id |=3D CAN_RTR_FLAG;
> +		else
> +			memcpy(cf->data, msg->data, cf->len);
> +
> +		skb_hwtstamps(skb)->hwtstamp =3D acc_ts2ktime(priv->ov, msg->ts);
> +
> +		stats->rx_packets++;
> +		stats->rx_bytes +=3D cf->len;
> +		netif_rx(skb);
> +	}
> +}
> +
> +static void handle_core_msg_txabort(struct acc_core *core,
> +				    const struct acc_bmmsg_txabort *msg)
> +{
> +	struct net_device_stats *stats =3D &core->net_dev->stats;
> +	unsigned int u;
> +
> +	/* abort_mask signals which frames were aborted in card's fifo */
> +	for (u =3D 0U; u < sizeof(msg->abort_mask) * BITS_PER_BYTE; u++) {
> +		if (!(msg->abort_mask & (1U << u)))
> +			continue;
> +
> +		if (core->tx_fifo_head =3D=3D core->tx_fifo_tail) {
> +			netdev_warn(core->net_dev,
> +				    "TX Err interrupt, but queue is empty!?\n");
> +			break;
> +		}
> +		stats->tx_errors++;
> +
> +		can_free_echo_skb(core->net_dev, core->tx_fifo_tail, NULL);
> +		core->tx_fifo_tail++;
> +		if (core->tx_fifo_tail >=3D core->tx_fifo_size)
> +			core->tx_fifo_tail =3D 0;
> +	}
> +
> +	if (!acc_resetmode_entered(core))
> +		netif_wake_queue(core->net_dev);
> +}
> +
> +static void handle_core_msg_overrun(struct acc_core *core,
> +				    const struct acc_bmmsg_overrun *msg)
> +{
> +	struct acc_net_priv *priv =3D netdev_priv(core->net_dev);
> +	struct net_device_stats *stats =3D &core->net_dev->stats;
> +	struct can_frame *cf;
> +	struct sk_buff *skb;
> +
> +	skb =3D alloc_can_err_skb(core->net_dev, &cf);
> +	if (!skb)
> +		return;
> +
> +	/* lost_cnt may be 0 if not supported by ESDACC version */
> +	if (msg->lost_cnt) {
> +		stats->rx_dropped +=3D msg->lost_cnt;
> +		stats->rx_over_errors +=3D msg->lost_cnt;
> +	} else {
> +		stats->rx_dropped++;
> +		stats->rx_over_errors++;
> +	}
> +
> +	cf->can_id |=3D CAN_ERR_CRTL;
> +	cf->data[1] =3D CAN_ERR_CRTL_RX_OVERFLOW;
> +
> +	skb_hwtstamps(skb)->hwtstamp =3D acc_ts2ktime(priv->ov, msg->ts);
> +
> +	stats->rx_packets++;
> +	stats->rx_bytes +=3D cf->len;
> +	netif_rx(skb);
> +}
> +
> +static void handle_core_msg_buserr(struct acc_core *core,
> +				   const struct acc_bmmsg_buserr *msg)
> +{
> +	struct acc_net_priv *priv =3D netdev_priv(core->net_dev);
> +	struct net_device_stats *stats =3D &core->net_dev->stats;
> +	struct can_frame *cf;
> +	struct sk_buff *skb;
> +
> +	priv->can.can_stats.bus_error++;
> +
> +	skb =3D alloc_can_err_skb(core->net_dev, &cf);
> +	if (!skb)
> +		return;
> +
> +	cf->can_id |=3D CAN_ERR_PROT | CAN_ERR_BUSERROR;
> +
> +	/* msg->ecc acts like SJA1000's ECC register */
> +	switch (msg->ecc & ACC_ECC_MASK) {
> +	case ACC_ECC_BIT:
> +		cf->data[2] |=3D CAN_ERR_PROT_BIT;
> +		break;
> +	case ACC_ECC_FORM:
> +		cf->data[2] |=3D CAN_ERR_PROT_FORM;
> +		break;
> +	case ACC_ECC_STUFF:
> +		cf->data[2] |=3D CAN_ERR_PROT_STUFF;
> +		break;
> +	default:
> +		cf->data[2] |=3D CAN_ERR_PROT_UNSPEC;
> +		break;
> +	}
> +
> +	/* Set error location */
> +	cf->data[3] =3D msg->ecc & ACC_ECC_SEG;
> +
> +	/* Error occurred during transmission? */
> +	if ((msg->ecc & ACC_ECC_DIR) =3D=3D 0) {
> +		cf->data[2] |=3D CAN_ERR_PROT_TX;
> +		stats->tx_errors++;
> +	} else {
> +		stats->rx_errors++;
> +	}
> +
> +	skb_hwtstamps(skb)->hwtstamp =3D acc_ts2ktime(priv->ov, msg->ts);
> +
> +	stats->rx_packets++;
> +	stats->rx_bytes +=3D cf->len;
> +	netif_rx(skb);
> +}
> +
> +static void
> +handle_core_msg_errstatechange(struct acc_core *core,
> +			       const struct acc_bmmsg_errstatechange *msg)
> +{
> +	struct acc_net_priv *priv =3D netdev_priv(core->net_dev);
> +	struct net_device_stats *stats =3D &core->net_dev->stats;
> +	struct can_frame *cf =3D NULL;
> +	struct sk_buff *skb;
> +	const u32 reg_status =3D msg->reg_status;
> +	const u8 txerr =3D (u8)(reg_status >> 8);
> +	const u8 rxerr =3D (u8)reg_status;
> +	enum can_state new_state;
> +
> +	if (reg_status & ACC_REG_STATUS_MASK_STATUS_BS)
> +		new_state =3D CAN_STATE_BUS_OFF;
> +	else if (reg_status & ACC_REG_STATUS_MASK_STATUS_EP)
> +		new_state =3D CAN_STATE_ERROR_PASSIVE;
> +	else if (reg_status & ACC_REG_STATUS_MASK_STATUS_ES)
> +		new_state =3D CAN_STATE_ERROR_WARNING;
> +	else
> +		new_state =3D CAN_STATE_ERROR_ACTIVE;
> +
> +	skb =3D alloc_can_err_skb(core->net_dev, &cf);
> +
> +	if (new_state !=3D priv->can.state) {
> +		enum can_state tx_state, rx_state;
> +
> +		tx_state =3D (txerr >=3D rxerr) ?
> +			new_state : CAN_STATE_ERROR_ACTIVE;
> +		rx_state =3D (rxerr >=3D txerr) ?
> +			new_state : CAN_STATE_ERROR_ACTIVE;
> +
> +		/* Always call can_change_state() to update the state
> +		 * even if alloc_can_err_skb() may have failed.
> +		 * can_change_state() can cope with a NULL cf pointer.
> +		 */
> +		can_change_state(core->net_dev, cf, tx_state, rx_state);
> +	}
> +
> +	if (skb) {
> +		cf->data[6] =3D txerr;
> +		cf->data[7] =3D rxerr;
> +
> +		skb_hwtstamps(skb)->hwtstamp =3D acc_ts2ktime(priv->ov, msg->ts);
> +
> +		stats->rx_packets++;
> +		stats->rx_bytes +=3D cf->len;
> +		netif_rx(skb);
> +	} else {
> +		stats->rx_dropped++;
> +	}
> +
> +	if (new_state =3D=3D CAN_STATE_BUS_OFF) {
> +		acc_write32(core, ACC_CORE_OF_TX_ABORT_MASK, 0xffff);
> +		can_bus_off(core->net_dev);
> +	}
> +}
> +
> +static void handle_core_interrupt(struct acc_core *core)
> +{
> +	u32 msg_fifo_head =3D core->bmfifo.local_irq_cnt & 0xff;
> +
> +	while (core->bmfifo.msg_fifo_tail !=3D msg_fifo_head) {
> +		const struct acc_bmmsg *msg =3D
> +			&core->bmfifo.messages[core->bmfifo.msg_fifo_tail];
> +
> +		switch (msg->u.msg_id) {
> +		case BM_MSG_ID_RXTXDONE:
> +			handle_core_msg_rxtxdone(core, &msg->u.rxtxdone);
> +			break;
> +
> +		case BM_MSG_ID_TXABORT:
> +			handle_core_msg_txabort(core, &msg->u.txabort);
> +			break;
> +
> +		case BM_MSG_ID_OVERRUN:
> +			handle_core_msg_overrun(core, &msg->u.overrun);
> +			break;
> +
> +		case BM_MSG_ID_BUSERR:
> +			handle_core_msg_buserr(core, &msg->u.buserr);
> +			break;
> +
> +		case BM_MSG_ID_ERRPASSIVE:
> +		case BM_MSG_ID_ERRWARN:
> +			handle_core_msg_errstatechange(core,
> +						       &msg->u.errstatechange);
> +			break;
> +
> +		default:
> +			/* Ignore all other BM messages (like the CAN-FD messages) */
> +			break;
> +		}
> +
> +		core->bmfifo.msg_fifo_tail =3D
> +				(core->bmfifo.msg_fifo_tail + 1) & 0xff;
> +	}
> +}
> +
> +irqreturn_t acc_card_interrupt(struct acc_ov *ov, struct acc_core *cores)
> +{
> +	u32		irqmask;
> +	int		i;
> +
> +	/* First we look for whom interrupts are pending, card/overview
> +	 * or any of the cores. Two bits in irqmask are used for each;
> +	 * set to ACC_BM_IRQ_MASK then:
> +	 */
> +	irqmask =3D 0;
> +	if (*ov->bmfifo.irq_cnt !=3D ov->bmfifo.local_irq_cnt) {
> +		irqmask |=3D ACC_BM_IRQ_MASK;
> +		ov->bmfifo.local_irq_cnt =3D *ov->bmfifo.irq_cnt;
> +	}
> +
> +	for (i =3D 0; i < ov->active_cores; i++) {
> +		struct acc_core *core =3D &cores[i];
> +
> +		if (*core->bmfifo.irq_cnt !=3D core->bmfifo.local_irq_cnt) {
> +			irqmask |=3D (ACC_BM_IRQ_MASK << (2 * (i + 1)));
> +			core->bmfifo.local_irq_cnt =3D *core->bmfifo.irq_cnt;
> +		}
> +	}
> +
> +	if (!irqmask)
> +		return IRQ_NONE;
> +
> +	/* At second we tell the card we're working on them by writing irqmask,
> +	 * call handle_{ov|core}_interrupt and then acknowledge the
> +	 * interrupts by writing irq_cnt:
> +	 */
> +	acc_ov_write32(ov, ACC_OV_OF_BM_IRQ_MASK, irqmask);
> +
> +	if (irqmask & ACC_BM_IRQ_MASK) {
> +		/* handle_ov_interrupt(); - no use yet. */
> +		acc_ov_write32(ov, ACC_OV_OF_BM_IRQ_COUNTER,
> +			       ov->bmfifo.local_irq_cnt);
> +	}
> +
> +	for (i =3D 0; i < ov->active_cores; i++) {
> +		struct acc_core *core =3D &cores[i];
> +
> +		if (irqmask & (ACC_BM_IRQ_MASK << (2 * (i + 1)))) {
> +			handle_core_interrupt(core);
> +			acc_write32(core, ACC_OV_OF_BM_IRQ_COUNTER,
> +				    core->bmfifo.local_irq_cnt);
> +		}
> +	}
> +
> +	acc_ov_write32(ov, ACC_OV_OF_BM_IRQ_MASK, ACC_BM_IRQ_UNMASK_ALL);
> +
> +	return IRQ_HANDLED;
> +}
> diff --git a/drivers/net/can/esd/esdacc.h b/drivers/net/can/esd/esdacc.h
> new file mode 100644
> index 000000000000..f594514c26fb
> --- /dev/null
> +++ b/drivers/net/can/esd/esdacc.h
> @@ -0,0 +1,394 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright (C) 2015 - 2017 esd electronic system design gmbh
> + * Copyright (C) 2017 - 2021 esd electronics gmbh
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/netdevice.h>
> +#include <linux/can/dev.h>
> +
> +#define ACC_ENABLE_CANFD			0
> +
> +#define ACC_CAN_EFF_FLAG			0x20000000
> +#define ACC_CAN_RTR_FLAG			0x10
> +#define ACC_CAN_DLC_MASK			0x0f
> +
> +#define ACC_OV_OF_PROBE				0x0000
> +#define ACC_OV_OF_VERSION			0x0004
> +#define ACC_OV_OF_INFO				0x0008
> +#define ACC_OV_OF_CANCORE_FREQ			0x000c
> +#define ACC_OV_OF_TS_FREQ_LO			0x0010
> +#define ACC_OV_OF_TS_FREQ_HI			0x0014
> +#define ACC_OV_OF_IRQ_STATUS_CORES		0x0018
> +#define ACC_OV_OF_TS_CURR_LO			0x001c
> +#define ACC_OV_OF_TS_CURR_HI			0x0020
> +#define ACC_OV_OF_IRQ_STATUS			0x0028
> +#define ACC_OV_OF_MODE				0x002c
> +#define ACC_OV_OF_BM_IRQ_COUNTER		0x0070
> +#define ACC_OV_OF_BM_IRQ_MASK			0x0074
> +#define ACC_OV_OF_MSI_DATA			0x0080
> +#define ACC_OV_OF_MSI_ADDRESSOFFSET		0x0084
> +
> +/* Feature flags are contained in the upper 16 bit of the version
> + * register at ACC_OV_OF_VERSION but only used with these masks after
> + * extraction into an extra variable =3D> (xx - 16).
> + */
> +#define ACC_OV_REG_FEAT_IDX_CANFD		(27 - 16)
> +#define ACC_OV_REG_FEAT_IDX_NEW_PSC		(28 - 16)
> +#define ACC_OV_REG_FEAT_MASK_CANFD		BIT(ACC_OV_REG_FEAT_IDX_CANFD)
> +#define ACC_OV_REG_FEAT_MASK_NEW_PSC		BIT(ACC_OV_REG_FEAT_IDX_NEW_PSC)
> +
> +#define ACC_OV_REG_MODE_MASK_ENDIAN_LITTLE	0x00000001
> +#define ACC_OV_REG_MODE_MASK_BM_ENABLE		0x00000002
> +#define ACC_OV_REG_MODE_MASK_MODE_LED		0x00000004
> +#define ACC_OV_REG_MODE_MASK_TIMER		0x00000070
> +#define ACC_OV_REG_MODE_MASK_TIMER_ENABLE	0x00000010
> +#define ACC_OV_REG_MODE_MASK_TIMER_ONE_SHOT	0x00000020
> +#define ACC_OV_REG_MODE_MASK_TIMER_ABSOLUTE	0x00000040
> +#define ACC_OV_REG_MODE_MASK_TS_SRC		0x00000180
> +#define ACC_OV_REG_MODE_MASK_I2C_ENABLE		0x00000800
> +#define ACC_OV_REG_MODE_MASK_MSI_ENABLE		0x00004000
> +#define ACC_OV_REG_MODE_MASK_NEW_PSC_ENABLE	0x00008000
> +#define ACC_OV_REG_MODE_MASK_FPGA_RESET		0x80000000
> +
> +#define ACC_CORE_OF_CTRL_MODE			0x0000
> +#define ACC_CORE_OF_STATUS_IRQ			0x0008
> +#define ACC_CORE_OF_BRP				0x000c
> +#define ACC_CORE_OF_BTR				0x0010
> +#define ACC_CORE_OF_FBTR			0x0014
> +#define ACC_CORE_OF_STATUS			0x0030
> +#define ACC_CORE_OF_TXFIFO_CONFIG		0x0048
> +#define ACC_CORE_OF_TXFIFO_STATUS		0x004c
> +#define ACC_CORE_OF_TX_STATUS_IRQ		0x0050
> +#define ACC_CORE_OF_TX_ABORT_MASK		0x0054
> +#define ACC_CORE_OF_BM_IRQ_COUNTER		0x0070
> +#define ACC_CORE_OF_TXFIFO_ID			0x00c0
> +#define ACC_CORE_OF_TXFIFO_DLC			0x00c4
> +#define ACC_CORE_OF_TXFIFO_DATA_0		0x00c8
> +#define ACC_CORE_OF_TXFIFO_DATA_1		0x00cc
> +
> +#define ACC_REG_CONTROL_IDX_MODE_RESETMODE	0
> +#define ACC_REG_CONTROL_IDX_MODE_LOM		1
> +#define ACC_REG_CONTROL_IDX_MODE_STM		2
> +#define ACC_REG_CONTROL_IDX_MODE_TRANSEN	5
> +#define ACC_REG_CONTROL_IDX_MODE_TS		6
> +#define ACC_REG_CONTROL_IDX_MODE_SCHEDULE	7
> +#define ACC_REG_CONTROL_MASK_MODE_RESETMODE	\
> +				BIT(ACC_REG_CONTROL_IDX_MODE_RESETMODE)
> +#define ACC_REG_CONTROL_MASK_MODE_LOM		\
> +				BIT(ACC_REG_CONTROL_IDX_MODE_LOM)
> +#define ACC_REG_CONTROL_MASK_MODE_STM		\
> +				BIT(ACC_REG_CONTROL_IDX_MODE_STM)
> +#define ACC_REG_CONTROL_MASK_MODE_TRANSEN	\
> +				BIT(ACC_REG_CONTROL_IDX_MODE_TRANSEN)
> +#define ACC_REG_CONTROL_MASK_MODE_TS		\
> +				BIT(ACC_REG_CONTROL_IDX_MODE_TS)
> +#define ACC_REG_CONTROL_MASK_MODE_SCHEDULE	\
> +				BIT(ACC_REG_CONTROL_IDX_MODE_SCHEDULE)
> +
> +#define ACC_REG_CONTROL_IDX_IE_RXTX	8
> +#define ACC_REG_CONTROL_IDX_IE_TXERROR	9
> +#define ACC_REG_CONTROL_IDX_IE_ERRWARN	10
> +#define ACC_REG_CONTROL_IDX_IE_OVERRUN	11
> +#define ACC_REG_CONTROL_IDX_IE_TSI	12
> +#define ACC_REG_CONTROL_IDX_IE_ERRPASS	13
> +#define ACC_REG_CONTROL_IDX_IE_BUSERR	15
> +#define ACC_REG_CONTROL_MASK_IE_RXTX	BIT(ACC_REG_CONTROL_IDX_IE_RXTX)
> +#define ACC_REG_CONTROL_MASK_IE_TXERROR BIT(ACC_REG_CONTROL_IDX_IE_TXERR=
OR)
> +#define ACC_REG_CONTROL_MASK_IE_ERRWARN BIT(ACC_REG_CONTROL_IDX_IE_ERRWA=
RN)
> +#define ACC_REG_CONTROL_MASK_IE_OVERRUN BIT(ACC_REG_CONTROL_IDX_IE_OVERR=
UN)
> +#define ACC_REG_CONTROL_MASK_IE_TSI	BIT(ACC_REG_CONTROL_IDX_IE_TSI)
> +#define ACC_REG_CONTROL_MASK_IE_ERRPASS BIT(ACC_REG_CONTROL_IDX_IE_ERRPA=
SS)
> +#define ACC_REG_CONTROL_MASK_IE_BUSERR	BIT(ACC_REG_CONTROL_IDX_IE_BUSERR)
> +
> +/* 256 BM_MSGs of 32 byte size */
> +#define ACC_CORE_DMAMSG_SIZE		32U
> +#define ACC_CORE_DMABUF_SIZE		(256U * ACC_CORE_DMAMSG_SIZE)
> +
> +enum acc_bmmsg_id {
> +	BM_MSG_ID_RXTXDONE =3D 0x01,
> +	BM_MSG_ID_TXABORT =3D 0x02,
> +	BM_MSG_ID_OVERRUN =3D 0x03,
> +	BM_MSG_ID_BUSERR =3D 0x04,
> +	BM_MSG_ID_ERRPASSIVE =3D 0x05,
> +	BM_MSG_ID_ERRWARN =3D 0x06,
> +	BM_MSG_ID_TIMESLICE =3D 0x07,
> +	BM_MSG_ID_HWTIMER =3D 0x08,
> +	BM_MSG_ID_HOTPLUG =3D 0x09,
> +	BM_MSG_ID_CANFDDATA0 =3D 0x0a,
> +	BM_MSG_ID_CANFDDATA1 =3D 0x0b
> +};
> +
> +/* The struct acc_bmmsg* structure declarations that follow here provide
> + * access to the ring buffer of bus master messages maintained by the FP=
GA
> + * bus master engine. All bus master messages have the same size of
> + * ACC_CORE_DMAMSG_SIZE and a minimum alignment of ACC_CORE_DMAMSG_SIZE =
in
> + * memory.
> + *
> + * All structure members are natural aligned. Therefore we should not ne=
ed
> + * a __packed attribute. All struct acc_bmmsg* declarations have at least
> + * reserved* members to fill the structure to the full ACC_CORE_DMAMSG_S=
IZE.
> + *
> + * A failure of this property due padding will be detected at compile ti=
me
> + * by BUILD_BUG_ON(sizeof(struct acc_bmmsg) !=3D ACC_CORE_DMAMSG_SIZE)
> + */
> +
> +struct acc_bmmsg_rxtxdone {
> +	u8 msg_id;
> +	u8 txfifo_level;
> +	u8 reserved1[2];
> +	u8 txtsfifo_level;
> +	u8 reserved2[3];
> +	u32 id;
> +	union {
> +		struct {
> +			u8 len;
> +			u8 reserved0;
> +			u8 bits;
> +			u8 state;
> +		} rxtx;
> +		struct {
> +			u8 len;
> +			u8 msg_lost;
> +			u8 bits;
> +			u8 state;
> +		} rx;
> +		struct {
> +			u8 len;
> +			u8 txfifo_idx;
> +			u8 bits;
> +			u8 state;
> +		} tx;
> +	} dlc;
> +	u8 data[8];
> +	/* Time stamps in struct acc_ov::timestamp_frequency ticks. */
> +	u64 ts;
> +};
> +
> +struct acc_bmmsg_txabort {
> +	u8 msg_id;
> +	u8 txfifo_level;
> +	u16 abort_mask;
> +	u8 txtsfifo_level;
> +	u8 reserved2[1];
> +	u16 abort_mask_txts;
> +	u64 ts;
> +	u32 reserved3[4];
> +};
> +
> +struct acc_bmmsg_overrun {
> +	u8 msg_id;
> +	u8 txfifo_level;
> +	u8 lost_cnt;
> +	u8 reserved1;
> +	u8 txtsfifo_level;
> +	u8 reserved2[3];
> +	u64 ts;
> +	u32 reserved3[4];
> +};
> +
> +struct acc_bmmsg_buserr {
> +	u8 msg_id;
> +	u8 txfifo_level;
> +	u8 ecc;
> +	u8 reserved1;
> +	u8 txtsfifo_level;
> +	u8 reserved2[3];
> +	u64 ts;
> +	u32 reg_status;
> +	u32 reg_btr;
> +	u32 reserved3[2];
> +};
> +
> +struct acc_bmmsg_errstatechange {
> +	u8 msg_id;
> +	u8 txfifo_level;
> +	u8 reserved1[2];
> +	u8 txtsfifo_level;
> +	u8 reserved2[3];
> +	u64 ts;
> +	u32 reg_status;
> +	u32 reserved3[3];
> +};
> +
> +struct acc_bmmsg_timeslice {
> +	u8 msg_id;
> +	u8 txfifo_level;
> +	u8 reserved1[2];
> +	u8 txtsfifo_level;
> +	u8 reserved2[3];
> +	u64 ts;
> +	u32 reserved3[4];
> +};
> +
> +struct acc_bmmsg_hwtimer {
> +	u8 msg_id;
> +	u8 reserved1[3];
> +	u32 reserved2[1];
> +	u64 timer;
> +	u32 reserved3[4];
> +};
> +
> +struct acc_bmmsg_hotplug {
> +	u8 msg_id;
> +	u8 reserved1[3];
> +	u32 reserved2[7];
> +};
> +
> +struct acc_bmmsg_canfddata {
> +	u8 msg_id;
> +	u8 reserved1[3];
> +	union {
> +		u8 ui8[28];
> +		u32 ui32[7];
> +	} d;
> +};
> +
> +struct acc_bmmsg {
> +	union {
> +		u8 msg_id;
> +		struct acc_bmmsg_rxtxdone rxtxdone;
> +		struct acc_bmmsg_canfddata canfddata;
> +		struct acc_bmmsg_txabort txabort;
> +		struct acc_bmmsg_overrun overrun;
> +		struct acc_bmmsg_buserr buserr;
> +		struct acc_bmmsg_errstatechange errstatechange;
> +		struct acc_bmmsg_timeslice timeslice;
> +		struct acc_bmmsg_hwtimer hwtimer;
> +	} u;
> +};
> +
> +/* Regarding Documentation/process/volatile-considered-harmful.rst the
> + * forth exception applies to the "irq_cnt" member of the structure
> + * below. The u32 variable "irq_cnt" points to is updated by the ESDACC
> + * FPGA via DMA.
> + */
> +struct acc_bmfifo {
> +	const struct acc_bmmsg *messages;
> +	/* Bits 0..7: bm_fifo head index */
> +	volatile const u32 *irq_cnt;
> +	u32 local_irq_cnt;
> +	u32 msg_fifo_tail;
> +};
> +
> +struct acc_core {
> +	void __iomem *addr;
> +	struct net_device *net_dev;
> +	struct acc_bmfifo bmfifo;
> +	u8 tx_fifo_size;
> +	u8 tx_fifo_head;
> +	u8 tx_fifo_tail;
> +};
> +
> +struct acc_ov {
> +	void __iomem *addr;
> +	struct acc_bmfifo bmfifo;
> +	u32 timestamp_frequency;
> +	u32 ts2ns_numerator;
> +	u32 ts2ns_denominator;
> +	u32 core_frequency;
> +	u16 version;
> +	u16 features;
> +	u8 total_cores;
> +	u8 active_cores;
> +};
> +
> +struct acc_net_priv {
> +	struct can_priv can; /* must be the first member! */
> +	struct acc_core *core;
> +	struct acc_ov *ov;
> +};
> +
> +static inline u32 acc_read32(struct acc_core *core, unsigned short offs)
> +{
> +	return ioread32be(core->addr + offs);
> +}
> +
> +static inline void acc_write32(struct acc_core *core,
> +			       unsigned short offs, u32 v)
> +{
> +	iowrite32be(v, core->addr + offs);
> +}
> +
> +static inline void acc_write32_noswap(struct acc_core *core,
> +				      unsigned short offs, u32 v)
> +{
> +	iowrite32(v, core->addr + offs);
> +}
> +
> +static inline void acc_set_bits(struct acc_core *core,
> +				unsigned short offs, u32 mask)
> +{
> +	u32 v =3D acc_read32(core, offs);
> +
> +	v |=3D mask;
> +	acc_write32(core, offs, v);
> +}
> +
> +static inline void acc_clear_bits(struct acc_core *core,
> +				  unsigned short offs, u32 mask)
> +{
> +	u32 v =3D acc_read32(core, offs);
> +
> +	v &=3D ~mask;
> +	acc_write32(core, offs, v);
> +}
> +
> +static inline int acc_resetmode_entered(struct acc_core *core)
> +{
> +	u32 ctrl =3D acc_read32(core, ACC_CORE_OF_CTRL_MODE);
> +
> +	return (ctrl & ACC_REG_CONTROL_MASK_MODE_RESETMODE) !=3D 0;
> +}
> +
> +static inline u32 acc_ov_read32(struct acc_ov *ov, unsigned short offs)
> +{
> +	return ioread32be(ov->addr + offs);
> +}
> +
> +static inline void acc_ov_write32(struct acc_ov *ov,
> +				  unsigned short offs, u32 v)
> +{
> +	iowrite32be(v, ov->addr + offs);
> +}
> +
> +static inline void acc_ov_set_bits(struct acc_ov *ov,
> +				   unsigned short offs, u32 b)
> +{
> +	u32 v =3D acc_ov_read32(ov, offs);
> +
> +	v |=3D b;
> +	acc_ov_write32(ov, offs, v);
> +}
> +
> +static inline void acc_ov_clear_bits(struct acc_ov *ov,
> +				     unsigned short offs, u32 b)
> +{
> +	u32 v =3D acc_ov_read32(ov, offs);
> +
> +	v &=3D ~b;
> +	acc_ov_write32(ov, offs, v);
> +}
> +
> +static inline void acc_reset_fpga(struct acc_ov *ov)
> +{
> +	acc_ov_write32(ov, ACC_OV_OF_MODE, ACC_OV_REG_MODE_MASK_FPGA_RESET);
> +
> +	/* Also reset I^2C, to re-detect card addons at every driver start: */
> +	acc_ov_clear_bits(ov, ACC_OV_OF_MODE, ACC_OV_REG_MODE_MASK_I2C_ENABLE);
> +	mdelay(2);
> +	acc_ov_set_bits(ov, ACC_OV_OF_MODE, ACC_OV_REG_MODE_MASK_I2C_ENABLE);
> +	mdelay(10);
> +}
> +
> +void acc_init_ov(struct acc_ov *ov, struct device *dev);
> +void acc_init_bm_ptr(struct acc_ov *ov, struct acc_core *cores,
> +		     const void *mem);
> +int acc_open(struct net_device *netdev);
> +int acc_close(struct net_device *netdev);
> +netdev_tx_t acc_start_xmit(struct sk_buff *skb, struct net_device *netde=
v);
> +int acc_get_berr_counter(const struct net_device *netdev,
> +			 struct can_berr_counter *bec);
> +int acc_set_mode(struct net_device *netdev, enum can_mode mode);
> +int acc_set_bittiming(struct net_device *netdev);
> +irqreturn_t acc_card_interrupt(struct acc_ov *ov, struct acc_core *cores=
);
> --=20
> 2.25.1
>=20
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xumgh6swjfevthav
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmENOaMACgkQqclaivrt
76k+WQf8CANVupXyftTzn7tJKmXoVwIl2teK48pFHTBFuA4eGgP/TV4fc/Y9NEzG
m4Ciop3NAiHO//qdsT7+BFCjebAvZj01Fugtn8Otx5OmdtMgjsi82vsloBu9sbtI
kbBZpynrnhePeEZj+ZZuIcj1GzJD9bfcXFpMRbQraq4u9IHUVc/PQoKkDEh+byoh
ArggIHbvJy762Oa+GdyD4UVn08YydxFFwhDZrNOBZEArySbkvojuotFCg3Zibx05
Vh2MKZPaIOw9BYhePiHdtvGsI+cVQc35i/Pg253DQhJYf8OVrEpgxuhw9BEVd4dU
7neRRG6AxlYBWQq3WLCW6BHbf4QfpQ==
=qEvB
-----END PGP SIGNATURE-----

--xumgh6swjfevthav--
