Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A1F526121
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379935AbiEMLlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379934AbiEMLlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:41:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A962853A50
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:41:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npTft-0006xA-UD; Fri, 13 May 2022 13:41:38 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1C4DC7D947;
        Fri, 13 May 2022 11:41:36 +0000 (UTC)
Date:   Fri, 13 May 2022 13:41:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     linux-can@vger.kernel.org, pisa@cmp.felk.cvut.cz,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        ondrej.ille@gmail.com, martin.jerabek01@gmail.com
Subject: Re: [RFC PATCH 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220513114135.lgbda6armyiccj3o@pengutronix.de>
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
 <20220512232706.24575-2-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lgjq2y6knusqxehg"
Content-Disposition: inline
In-Reply-To: <20220512232706.24575-2-matej.vasilevski@seznam.cz>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lgjq2y6knusqxehg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Matej,

thanks for our patch!

On 13.05.2022 01:27:05, Matej Vasilevski wrote:
> This patch adds support for retrieving hardware timestamps to RX and
> error CAN frames for platform devices. It uses timecounter and
> cyclecounter structures, because the timestamping counter width depends
> on the IP core implementation (it might not always be 64-bit).
> To enable HW timestamps, you have to enable it in the kernel config
> and provide the following properties in device tree:

Please no Kconfig option. There is a proper interface to enable/disable
time stamps form the user space. IIRC it's an ioctl. But I think the
overhead is neglectable here.

> - ts-used-bits

A property with "width" in the name seems to be more common. You
probably have to add the "ctu" vendor prefix. BTW: the bindings document
update should come before changing the driver.

> - add second clock phandle to 'clocks' property
> - create 'clock-names' property and name the second clock 'ts_clk'
>=20
> Alternatively, you can set property 'ts-frequency' directly with
> the timestamping frequency, instead of setting second clock.

For now, please use a clock property only. If you need ACPI bindings add
them later.

> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> ---
>  drivers/net/can/ctucanfd/Kconfig              |  10 ++
>  drivers/net/can/ctucanfd/Makefile             |   2 +-
>  drivers/net/can/ctucanfd/ctucanfd.h           |  25 ++++
>  drivers/net/can/ctucanfd/ctucanfd_base.c      | 123 +++++++++++++++++-
>  drivers/net/can/ctucanfd/ctucanfd_timestamp.c | 113 ++++++++++++++++
>  5 files changed, 267 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c
>=20
> diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/=
Kconfig
> index 48963efc7f19..d75931525ce7 100644
> --- a/drivers/net/can/ctucanfd/Kconfig
> +++ b/drivers/net/can/ctucanfd/Kconfig
> @@ -32,3 +32,13 @@ config CAN_CTUCANFD_PLATFORM
>  	  company. FPGA design https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-=
sja1000-top.
>  	  The kit description at the Computer Architectures course pages
>  	  https://cw.fel.cvut.cz/wiki/courses/b35apo/documentation/mz_apo/start=
 .
> +
> +config CAN_CTUCANFD_PLATFORM_ENABLE_HW_TIMESTAMPS
> +	bool "CTU CAN-FD IP core platform device hardware timestamps"
> +	depends on CAN_CTUCANFD_PLATFORM
> +	default n
> +	help
> +	  Enables reading hardware timestamps from the IP core for platform
> +	  devices by default. You will have to provide ts-bit-size and
> +	  ts-frequency/timestaping clock in device tree for CTU CAN-FD IP cores,
> +	  see device tree bindings for more details.

Please no Kconfig option, see above.

> diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd=
/Makefile
> index 8078f1f2c30f..78b7d9830098 100644
> --- a/drivers/net/can/ctucanfd/Makefile
> +++ b/drivers/net/can/ctucanfd/Makefile
> @@ -7,4 +7,4 @@ obj-$(CONFIG_CAN_CTUCANFD) :=3D ctucanfd.o
>  ctucanfd-y :=3D ctucanfd_base.o
> =20
>  obj-$(CONFIG_CAN_CTUCANFD_PCI) +=3D ctucanfd_pci.o
> -obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) +=3D ctucanfd_platform.o
> +obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) +=3D ctucanfd_platform.o ctucanfd_ti=
mestamp.o
> diff --git a/drivers/net/can/ctucanfd/ctucanfd.h b/drivers/net/can/ctucan=
fd/ctucanfd.h
> index 0e9904f6a05d..5690a85191df 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd.h
> +++ b/drivers/net/can/ctucanfd/ctucanfd.h
> @@ -20,10 +20,19 @@
>  #ifndef __CTUCANFD__
>  #define __CTUCANFD__
> =20
> +#include "linux/timecounter.h"
> +#include "linux/workqueue.h"
>  #include <linux/netdevice.h>
>  #include <linux/can/dev.h>
>  #include <linux/list.h>
> =20
> +#define CTUCANFD_MAX_WORK_DELAY_SEC 86400	/* one day =3D=3D 24 * 3600 */
> +#ifdef CONFIG_CAN_CTUCANFD_PLATFORM_ENABLE_HW_TIMESTAMPS
> +	#define CTUCANFD_TIMESTAMPS_ENABLED_BY_DEFAULT true
> +#else
> +	#define CTUCANFD_TIMESTAMPS_ENABLED_BY_DEFAULT false
> +#endif
> +
>  enum ctu_can_fd_can_registers;
> =20
>  struct ctucan_priv {
> @@ -51,6 +60,16 @@ struct ctucan_priv {
>  	u32 rxfrm_first_word;
> =20
>  	struct list_head peers_on_pdev;
> +
> +	struct cyclecounter cc;
> +	struct timecounter tc;
> +	struct delayed_work timestamp;
> +
> +	struct clk *timestamp_clk;

> +	u32 timestamp_freq;
> +	u32 timestamp_bit_size;

These two are not needed. Fill in struct cyclecounter directly.

> +	u32 work_delay_jiffies;
> +	bool timestamp_enabled;
>  };
> =20
>  /**
> @@ -79,4 +98,10 @@ int ctucan_probe_common(struct device *dev, void __iom=
em *addr,
>  int ctucan_suspend(struct device *dev) __maybe_unused;
>  int ctucan_resume(struct device *dev) __maybe_unused;
> =20
> +u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv);
> +int ctucan_calculate_and_set_work_delay(struct ctucan_priv *priv);
> +void ctucan_skb_set_timestamp(struct ctucan_priv *priv, struct sk_buff *=
skb,
> +			      u64 timestamp);
> +int ctucan_timestamp_init(struct ctucan_priv *priv);
> +void ctucan_timestamp_stop(struct ctucan_priv *priv);
>  #endif /*__CTUCANFD__*/
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/c=
tucanfd/ctucanfd_base.c
> index 2ada097d1ede..d568f7a106b2 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd_base.c
> +++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
> @@ -25,6 +25,7 @@
>  #include <linux/io.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/skbuff.h>
>  #include <linux/string.h>
>  #include <linux/types.h>
> @@ -148,6 +149,27 @@ static void ctucan_write_txt_buf(struct ctucan_priv =
*priv, enum ctu_can_fd_can_r
>  	priv->write_reg(priv, buf_base + offset, val);
>  }
> =20
> +static u64 concatenate_two_u32(u32 high, u32 low)
> +{
> +	return ((u64)high << 32) | ((u64)low);
> +}
> +
> +u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv)
> +{
> +	u32 ts_low;
> +	u32 ts_high;
> +	u32 ts_high2;
> +
> +	ts_high =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> +	ts_low =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_LOW);
> +	ts_high2 =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> +
> +	if (ts_high2 !=3D ts_high)
> +		ts_low =3D priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
> +
> +	return concatenate_two_u32(ts_high2, ts_low) & priv->cc.mask;
> +}
> +
>  #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF, ctucan_read=
32(priv, CTUCANFD_STATUS)))
>  #define CTU_CAN_FD_ENABLED(priv) (!!FIELD_GET(REG_MODE_ENA, ctucan_read3=
2(priv, CTUCANFD_MODE)))
> =20
> @@ -640,12 +662,16 @@ static netdev_tx_t ctucan_start_xmit(struct sk_buff=
 *skb, struct net_device *nde
>   * @priv:	Pointer to CTU CAN FD's private data
>   * @cf:		Pointer to CAN frame struct
>   * @ffw:	Previously read frame format word
> + * @skb:	Pointer to store timestamp
>   *
>   * Note: Frame format word must be read separately and provided in 'ffw'.
>   */
> -static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_=
frame *cf, u32 ffw)
> +static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_=
frame *cf,
> +				 u32 ffw, u64 *timestamp)
>  {
>  	u32 idw;
> +	u32 tstamp_high;
> +	u32 tstamp_low;
>  	unsigned int i;
>  	unsigned int wc;
>  	unsigned int len;
> @@ -682,9 +708,10 @@ static void ctucan_read_rx_frame(struct ctucan_priv =
*priv, struct canfd_frame *c
>  	if (unlikely(len > wc * 4))
>  		len =3D wc * 4;
> =20
> -	/* Timestamp - Read and throw away */
> -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> +	/* Timestamp */
> +	tstamp_low =3D ctucan_read32(priv, CTUCANFD_RX_DATA);
> +	tstamp_high =3D ctucan_read32(priv, CTUCANFD_RX_DATA);
> +	*timestamp =3D concatenate_two_u32(tstamp_high, tstamp_low) & priv->cc.=
mask;
> =20
>  	/* Data */
>  	for (i =3D 0; i < len; i +=3D 4) {
> @@ -713,6 +740,7 @@ static int ctucan_rx(struct net_device *ndev)
>  	struct net_device_stats *stats =3D &ndev->stats;
>  	struct canfd_frame *cf;
>  	struct sk_buff *skb;
> +	u64 timestamp;
>  	u32 ffw;
> =20
>  	if (test_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags)) {
> @@ -736,7 +764,9 @@ static int ctucan_rx(struct net_device *ndev)
>  		return 0;
>  	}
> =20
> -	ctucan_read_rx_frame(priv, cf, ffw);
> +	ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
> +	if (priv->timestamp_enabled)
> +		ctucan_skb_set_timestamp(priv, skb, timestamp);
> =20
>  	stats->rx_bytes +=3D cf->len;
>  	stats->rx_packets++;
> @@ -905,6 +935,11 @@ static void ctucan_err_interrupt(struct net_device *=
ndev, u32 isr)
>  	if (skb) {
>  		stats->rx_packets++;
>  		stats->rx_bytes +=3D cf->can_dlc;
> +		if (priv->timestamp_enabled) {
> +			u64 tstamp =3D ctucan_read_timestamp_counter(priv);
> +
> +			ctucan_skb_set_timestamp(priv, skb, tstamp);
> +		}
>  		netif_rx(skb);
>  	}
>  }
> @@ -950,6 +985,11 @@ static int ctucan_rx_poll(struct napi_struct *napi, =
int quota)
>  			cf->data[1] |=3D CAN_ERR_CRTL_RX_OVERFLOW;
>  			stats->rx_packets++;
>  			stats->rx_bytes +=3D cf->can_dlc;
> +			if (priv->timestamp_enabled) {
> +				u64 tstamp =3D ctucan_read_timestamp_counter(priv);
> +
> +				ctucan_skb_set_timestamp(priv, skb, tstamp);
> +			}
>  			netif_rx(skb);
>  		}
> =20
> @@ -1235,6 +1275,11 @@ static int ctucan_open(struct net_device *ndev)
>  		goto err_chip_start;
>  	}
> =20
> +	if (priv->timestamp_enabled && (ctucan_timestamp_init(priv) < 0)) {

ctucan_timestamp_init() will always return 0

> +		netdev_info(ndev, "Failed to init timestamping, it will be disabled.\n=
");
> +		priv->timestamp_enabled =3D false;
> +	}
> +
>  	netdev_info(ndev, "ctu_can_fd device registered\n");
>  	can_led_event(ndev, CAN_LED_EVENT_OPEN);
>  	napi_enable(&priv->napi);
> @@ -1268,6 +1313,9 @@ static int ctucan_close(struct net_device *ndev)
>  	ctucan_chip_stop(ndev);
>  	free_irq(ndev->irq, ndev);
>  	close_candev(ndev);
> +	if (priv->timestamp_enabled)
> +		ctucan_timestamp_stop(priv);
> +
> =20
>  	can_led_event(ndev, CAN_LED_EVENT_STOP);
>  	pm_runtime_put(priv->dev);
> @@ -1340,6 +1388,43 @@ int ctucan_resume(struct device *dev)
>  }
>  EXPORT_SYMBOL(ctucan_resume);
> =20
> +void ctucan_parse_dt_timestamp_bit_width(struct ctucan_priv *priv)
> +{
> +	if (of_property_read_u32(priv->dev->of_node, "ts-used-bits", &priv->tim=
estamp_bit_size)) {
> +		dev_info(priv->dev, "failed to read ts-used-bits property from device =
tree\n");
> +		priv->timestamp_enabled =3D false;
> +		return;
> +	}
> +	if (priv->timestamp_bit_size > 64) {
> +		dev_info(priv->dev, "ts-used-bits (value: %d) is too large, (max is 64=
)\n",
> +			 priv->timestamp_bit_size);
> +			 priv->timestamp_enabled =3D false;
> +	}
> +	if (priv->timestamp_bit_size =3D=3D 0) {
> +		dev_info(priv->dev, "ts-used-bits has to be greater than zero\n");
> +			 priv->timestamp_enabled =3D false;
> +	}
> +}
> +
> +void ctucan_parse_dt_timestamp_frequency(struct ctucan_priv *priv)
> +{
> +	struct device *dev =3D priv->dev;
> +
> +	if (!IS_ERR_OR_NULL(priv->timestamp_clk)) {
> +		priv->timestamp_freq =3D clk_get_rate(priv->timestamp_clk);
> +	} else {
> +		if (of_property_read_u32(dev->of_node, "ts-frequency", &priv->timestam=
p_freq)) {
> +			dev_info(dev, "failed to read ts-frequency property from device tree\=
n");
> +			priv->timestamp_enabled =3D false;
> +			return;
> +		}
> +		if (priv->timestamp_freq =3D=3D 0) {
> +			dev_info(dev, "ts-frequency has to be greater than zero\n");
> +			priv->timestamp_enabled =3D false;
> +		}
> +	}
> +}
> +
>  int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq,=
 unsigned int ntxbufs,
>  			unsigned long can_clk_rate, int pm_enable_call,
>  			void (*set_drvdata_fnc)(struct device *dev, struct net_device *ndev))
> @@ -1396,6 +1481,17 @@ int ctucan_probe_common(struct device *dev, void _=
_iomem *addr, int irq, unsigne
>  		can_clk_rate =3D clk_get_rate(priv->can_clk);
>  	}
> =20
> +	priv->timestamp_enabled =3D CTUCANFD_TIMESTAMPS_ENABLED_BY_DEFAULT;
> +	priv->timestamp_clk =3D NULL;
> +
> +	if (priv->timestamp_enabled) {
> +		priv->timestamp_clk =3D devm_clk_get(dev, "ts_clk");
> +		if (IS_ERR(priv->timestamp_clk)) {
> +			dev_info(dev, "Timestaping clock ts_clk not found with error %ld, exp=
ecting ts-frequency to be defined\n",
> +				 PTR_ERR(priv->timestamp_clk));
> +		}
> +	}
> +
>  	priv->write_reg =3D ctucan_write32_le;
>  	priv->read_reg =3D ctucan_read32_le;
> =20
> @@ -1426,6 +1522,23 @@ int ctucan_probe_common(struct device *dev, void _=
_iomem *addr, int irq, unsigne
> =20
>  	priv->can.clock.freq =3D can_clk_rate;
> =20
> +	if (priv->timestamp_enabled && dev->of_node) {
> +		ctucan_parse_dt_timestamp_bit_width(priv);
> +		ctucan_parse_dt_timestamp_frequency(priv);
> +		if (ctucan_calculate_and_set_work_delay(priv) < 0) {
> +			dev_info(dev, "Failed to calculate work delay jiffies, disabling time=
stamps\n");
> +			priv->timestamp_enabled =3D false;
> +		}
> +	} else {
> +		priv->timestamp_enabled =3D false;
> +	}
> +
> +	if (priv->timestamp_enabled)
> +		dev_info(dev, "Timestamping enabled with counter bit width %u, frequen=
cy %u, work delay in jiffies %u\n",
> +			 priv->timestamp_bit_size, priv->timestamp_freq, priv->work_delay_jif=
fies);
> +	else
> +		dev_info(dev, "Timestamping is disabled\n");

This is probably a bit too loud. Make it _dbg()?

> +
>  	netif_napi_add(ndev, &priv->napi, ctucan_rx_poll, NAPI_POLL_WEIGHT);
> =20
>  	ret =3D register_candev(ndev);
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_timestamp.c b/drivers/net/=
can/ctucanfd/ctucanfd_timestamp.c
> new file mode 100644
> index 000000000000..63ef2c72510b
> --- /dev/null
> +++ b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> @@ -0,0 +1,113 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/***********************************************************************=
********
> + *
> + * CTU CAN FD IP Core
> + *
> + * Copyright (C) 2022 Matej Vasilevski <matej.vasilevski@seznam.cz> FEE =
CTU
> + *
> + * Project advisors:
> + *     Jiri Novak <jnovak@fel.cvut.cz>
> + *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
> + *
> + * Department of Measurement         (http://meas.fel.cvut.cz/)
> + * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
> + * Czech Technical University        (http://www.cvut.cz/)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.

With the SPDX-License-Identifier you can skip this.

> + ***********************************************************************=
*******/
> +
> +#include "asm-generic/bitops/builtin-ffs.h"

Is linux/bitops.h not enough?

> +#include "linux/dev_printk.h"
> +#include <linux/clocksource.h>
> +#include <linux/math64.h>
> +#include <linux/timecounter.h>
> +#include <linux/workqueue.h>

please sort alphabetically

> +
> +#include "ctucanfd.h"
> +#include "ctucanfd_kregs.h"
> +
> +static u64 ctucan_timestamp_read(const struct cyclecounter *cc)
> +{
> +	struct ctucan_priv *priv;
> +
> +	priv =3D container_of(cc, struct ctucan_priv, cc);
> +	return ctucan_read_timestamp_counter(priv);
> +}
> +
> +static void ctucan_timestamp_work(struct work_struct *work)
> +{
> +	struct delayed_work *delayed_work =3D to_delayed_work(work);
> +	struct ctucan_priv *priv;
> +
> +	priv =3D container_of(delayed_work, struct ctucan_priv, timestamp);
> +	timecounter_read(&priv->tc);
> +	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
> +}
> +
> +int ctucan_calculate_and_set_work_delay(struct ctucan_priv *priv)
> +{
> +	u32 jiffies_order =3D fls(HZ);
> +	u32 max_shift_left =3D 63 - jiffies_order;
> +	s32 final_shift =3D (priv->timestamp_bit_size - 1) - max_shift_left;
> +	u64 tmp;
> +
> +	if (!priv->timestamp_freq || !priv->timestamp_bit_size)
> +		return -1;

please use proper error return values

> +
> +	/* The formula is work_delay_jiffies =3D 2**(bit_size - 1) / ts_frequen=
cy * HZ
> +	 * using (bit_size - 1) instead of full bit_size to read the counter
> +	 * roughly twice per period
> +	 */
> +	tmp =3D div_u64((u64)HZ << max_shift_left, priv->timestamp_freq);
> +
> +	if (final_shift > 0)
> +		priv->work_delay_jiffies =3D tmp << final_shift;
> +	else
> +		priv->work_delay_jiffies =3D tmp >> -final_shift;
> +
> +	if (priv->work_delay_jiffies =3D=3D 0)
> +		return -1;
> +
> +	if (priv->work_delay_jiffies > CTUCANFD_MAX_WORK_DELAY_SEC * HZ)
> +		priv->work_delay_jiffies =3D CTUCANFD_MAX_WORK_DELAY_SEC * HZ;

use min() (or min_t() if needed)

> +	return 0;
> +}
> +
> +void ctucan_skb_set_timestamp(struct ctucan_priv *priv, struct sk_buff *=
skb, u64 timestamp)

Can you make the priv pointer const?

> +{
> +	struct skb_shared_hwtstamps *hwtstamps =3D skb_hwtstamps(skb);
> +	u64 ns;
> +
> +	ns =3D timecounter_cyc2time(&priv->tc, timestamp);
> +	hwtstamps->hwtstamp =3D ns_to_ktime(ns);
> +}
> +
> +int ctucan_timestamp_init(struct ctucan_priv *priv)
> +{
> +	struct cyclecounter *cc =3D &priv->cc;
> +
> +	cc->read =3D ctucan_timestamp_read;
> +	cc->mask =3D CYCLECOUNTER_MASK(priv->timestamp_bit_size);
> +	cc->shift =3D 10;
> +	cc->mult =3D clocksource_hz2mult(priv->timestamp_freq, cc->shift);

If you frequency and width is not known, it's probably better not to
hard code the shift and use clocks_calc_mult_shift() instead:

| https://elixir.bootlin.com/linux/v5.17.7/source/kernel/time/clocksource.c=
#L47

There's no need to do the above init on open(), especially in your case.
I know the mcp251xfd does it this way....In your case, as you parse data
=66rom DT, it's better to do the parsing in probe and directly do all
needed calculations and fill the struct cyclecounter there.

> +

The following code should stay here.

> +	timecounter_init(&priv->tc, &priv->cc, 0);

You here set the offset of the HW clock to 1.1.1970. The mcp driver sets
the offset to current time. I think it's convenient to have the current
time here....What do you think.

> +
> +	INIT_DELAYED_WORK(&priv->timestamp, ctucan_timestamp_work);
> +	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
> +
> +	return 0;

make it void - it cannot fail.

> +}
> +
> +void ctucan_timestamp_stop(struct ctucan_priv *priv)
> +{
> +	cancel_delayed_work_sync(&priv->timestamp);
> +}
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

--lgjq2y6knusqxehg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ+Q+wACgkQrX5LkNig
013qwgf/Q0U/9PYCVOgJeZeNpLcGwinAXx/gc/FUDmgXKHrQJ6yGhVmBuaCt/pUe
2fBSmwlhFZ7X9YNjDHMLhWdxaRn+VW6NGfwI/wFzxAa7XZy3NQuuLXDo7pmelHCh
/9N225XBqlc6FQthzth6vfEppRu6lGlX5Hq7XAY/ch++s6ZRi5HXPlwW0jhGRQl7
+TS8WLqFgEDY12d5t78aV59kNDAmq2sExINbBD1Zi7YduqAvor9GG8N2VCungcLC
WIb4ZexhRU4SklYPmsHE6k0TFTvYE77lI7JwASN0rFX1g6vwLHeGFa+0egXzOmXT
kA7W9U6MdAUrTRTEZ5m7Nva2wm2aXg==
=/HpL
-----END PGP SIGNATURE-----

--lgjq2y6knusqxehg--
