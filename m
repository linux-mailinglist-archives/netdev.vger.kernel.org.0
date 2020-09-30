Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2A927E004
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 07:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgI3FQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 01:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI3FQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 01:16:09 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1419C20706;
        Wed, 30 Sep 2020 05:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601442967;
        bh=SJE8qgDBaO5fpzPTqw/YRJd4rSzy2/dP3aSQEiEi464=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fnEzQTQApoqC4dWa5VSd21G+K72nTI9+satJMDLSor9k/Y4kqkeDeH8Pw/aXgbPdB
         Q3kch+mWaY/aoMJnvfd+4C+kOqH36LWcD8wKM3Y+LWPNVPcLwQxJGX5bxNV8wxSvMC
         +IMwk+ufywrnQ2L2O/sdSZXSX+7DqE+y4nYQsg/w=
Date:   Wed, 30 Sep 2020 08:16:02 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [v2] wireless: Initial driver submission for pureLiFi
 devices
Message-ID: <20200930051602.GJ3094@unreal>
References: <20200924151910.21693-1-srini.raju@purelifi.com>
 <20200928102008.32568-1-srini.raju@purelifi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928102008.32568-1-srini.raju@purelifi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 03:49:49PM +0530, Srinivasan Raju wrote:
> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices, which provide lightweight, highspeed secure and
> fully networked wireless communications via light.
>
> This driver implementation has been based on the zd1211rw driver
>
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture
>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
> ---
>  MAINTAINERS                                   |    5 +
>  drivers/net/wireless/Kconfig                  |    1 +
>  drivers/net/wireless/Makefile                 |    1 +
>  drivers/net/wireless/purelifi/Kconfig         |   38 +
>  drivers/net/wireless/purelifi/Makefile        |    3 +
>  drivers/net/wireless/purelifi/chip.c          |  120 ++
>  drivers/net/wireless/purelifi/chip.h          |   81 +
>  drivers/net/wireless/purelifi/def.h           |   46 +
>  drivers/net/wireless/purelifi/log.h           |   15 +
>  drivers/net/wireless/purelifi/mac.c           |  957 +++++++++
>  drivers/net/wireless/purelifi/mac.h           |  178 ++
>  .../net/wireless/purelifi/mac_usb_interface.h |   38 +
>  drivers/net/wireless/purelifi/usb.c           | 1872 +++++++++++++++++
>  drivers/net/wireless/purelifi/usb.h           |  148 ++
>  14 files changed, 3503 insertions(+)
>  create mode 100644 drivers/net/wireless/purelifi/Kconfig
>  create mode 100644 drivers/net/wireless/purelifi/Makefile
>  create mode 100644 drivers/net/wireless/purelifi/chip.c
>  create mode 100644 drivers/net/wireless/purelifi/chip.h
>  create mode 100644 drivers/net/wireless/purelifi/def.h
>  create mode 100644 drivers/net/wireless/purelifi/log.h
>  create mode 100644 drivers/net/wireless/purelifi/mac.c
>  create mode 100644 drivers/net/wireless/purelifi/mac.h
>  create mode 100644 drivers/net/wireless/purelifi/mac_usb_interface.h
>  create mode 100644 drivers/net/wireless/purelifi/usb.c
>  create mode 100644 drivers/net/wireless/purelifi/usb.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 42c69d2eeece..0e8cd1decafe 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14098,6 +14098,11 @@ T:	git git://linuxtv.org/media_tree.git
>  F:	Documentation/admin-guide/media/pulse8-cec.rst
>  F:	drivers/media/cec/usb/pulse8/
>
> +PUREILIFI USB DRIVER
> +M:	Srinivasan Raju <srini.raju@purelifi.com>
> +S:	Maintained
> +F:	drivers/net/wireless/purelifi
> +
>  PVRUSB2 VIDEO4LINUX DRIVER
>  M:	Mike Isely <isely@pobox.com>
>  L:	pvrusb2@isely.net	(subscribers-only)
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index 170a64e67709..b87da3139f94 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -48,6 +48,7 @@ source "drivers/net/wireless/st/Kconfig"
>  source "drivers/net/wireless/ti/Kconfig"
>  source "drivers/net/wireless/zydas/Kconfig"
>  source "drivers/net/wireless/quantenna/Kconfig"
> +source "drivers/net/wireless/purelifi/Kconfig"
>
>  config PCMCIA_RAYCS
>  	tristate "Aviator/Raytheon 2.4GHz wireless support"
> diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
> index 80b324499786..c403dda7a14e 100644
> --- a/drivers/net/wireless/Makefile
> +++ b/drivers/net/wireless/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_WLAN_VENDOR_ST) += st/
>  obj-$(CONFIG_WLAN_VENDOR_TI) += ti/
>  obj-$(CONFIG_WLAN_VENDOR_ZYDAS) += zydas/
>  obj-$(CONFIG_WLAN_VENDOR_QUANTENNA) += quantenna/
> +obj-$(WLAN_VENDOR_PURELIFI) += purelifi/

It should be CONFIG_WLAN_VENDOR_PURELIFI

>
>  # 16-bit wireless PCMCIA client drivers
>  obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
> diff --git a/drivers/net/wireless/purelifi/Kconfig b/drivers/net/wireless/purelifi/Kconfig
> new file mode 100644
> index 000000000000..ff05eaf0a8d4
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/Kconfig
> @@ -0,0 +1,38 @@
> +# SPDX-License-Identifier: GPL-2.0
> +config WLAN_VENDOR_PURELIFI
> +	bool "pureLiFi devices"
> +	default y

"N" is preferred default.

> +	help
> +	  If you have a pureLiFi device, say Y.
> +
> +	  Note that the answer to this question doesn't directly affect the
> +	  kernel: saying N will just cause the configurator to skip all the
> +	  questions about these cards. If you say Y, you will be asked for
> +	  your specific card in the following questions.

The text above makes no sense. Of course, it makes a lot of sense to
disable this device for whole world.

> +
> +if WLAN_VENDOR_PURELIFI
> +
> +config PURELIFI
> +
> +	tristate "pureLiFi device support"
> +	depends on CFG80211 && MAC80211 && USB
> +	help
> +	   Say Y if you want to use LiFi.
> +
> +	   This driver makes the adapter appear as a normal WLAN interface.
> +
> +	   The pureLiFi device requires external STA firmware to be loaded.
> +
> +	   To compile this driver as a module, choose M here: the module will
> +	   be called purelifi.
> +
> +config PURELIFI_AP
> +
> +	tristate "pureLiFi device Access Point support"
> +	depends on PURELIFI
> +	help
> +	   Say Y if you want to use LiFi in Access Point mode.
> +
> +	   The pureLiFi device requires external AP firmware to be loaded.
> +
> +endif # WLAN_VENDOR_PURELIFI
> diff --git a/drivers/net/wireless/purelifi/Makefile b/drivers/net/wireless/purelifi/Makefile
> new file mode 100644
> index 000000000000..1f20055e741f
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0
> +obj-$(CONFIG_PURELIFI)		:= purelifi.o

Please refactor the code to place PURELIFI_AP separately and not as
it is placed now interleaved with PURELIFI.

> +purelifi-objs 		+= chip.o usb.o mac.o
> diff --git a/drivers/net/wireless/purelifi/chip.c b/drivers/net/wireless/purelifi/chip.c
> new file mode 100644
> index 000000000000..32e6984703b6
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/chip.c
> @@ -0,0 +1,120 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +
> +#include "def.h"
> +#include "chip.h"
> +#include "mac.h"
> +#include "usb.h"
> +#include "log.h"
> +
> +void purelifi_chip_init(struct purelifi_chip *chip,
> +			struct ieee80211_hw *hw,
> +			struct usb_interface *intf)
> +{
> +	memset(chip, 0, sizeof(*chip));
> +	mutex_init(&chip->mutex);
> +	purelifi_usb_init(&chip->usb, hw, intf);
> +}
> +
> +void purelifi_chip_release(struct purelifi_chip *chip)
> +{
> +	PURELIFI_ASSERT(!mutex_is_locked(&chip->mutex));
> +	purelifi_usb_release(&chip->usb);
> +	mutex_destroy(&chip->mutex);
> +}

All those one time called functions are better to be removed and
embedded into the callers.

> +
> +int purelifi_set_beacon_interval(struct purelifi_chip *chip, u16 interval,
> +				 u8 dtim_period, int type)
> +{
> +	if (!interval || (chip->beacon_set &&
> +			  chip->beacon_interval == interval)) {
> +		return 0;
> +	}
> +
> +	chip->beacon_interval = interval;
> +	chip->beacon_set = true;
> +	return usb_write_req((const u8 *)&chip->beacon_interval,
> +			     sizeof(chip->beacon_interval),
> +			     USB_REQ_BEACON_INTERVAL_WR);
> +}
> +
> +static void print_chip_info(struct purelifi_chip *chip)
> +{
> +	u8 *addr = purelifi_mac_get_perm_addr(purelifi_chip_to_mac(chip));
> +	struct usb_device *udev = interface_to_usbdev(chip->usb.intf);
> +
> +	pr_info("purelifi chip %04hx:%04hx v%04hx  %02x-%02x-%02x %s\n",
> +		le16_to_cpu(udev->descriptor.idVendor),
> +		le16_to_cpu(udev->descriptor.idProduct),
> +		le16_to_cpu(udev->descriptor.bcdDevice),
> +		addr[0], addr[1], addr[2],
> +		speed(udev->speed));
> +}

Another one time function.

> +
> +int purelifi_chip_init_hw(struct purelifi_chip *chip)
> +{
> +	print_chip_info(chip);
> +	return purelifi_set_beacon_interval(chip, 100, 0, 0);
> +}
> +
> +int purelifi_chip_switch_radio(struct purelifi_chip *chip, u32 value)
> +{
> +	int r;
> +
> +	r = usb_write_req((const u8 *)&value, sizeof(value), USB_REQ_POWER_WR);
> +	if (r)
> +		pl_dev_err(purelifi_chip_dev(chip), "%s::r=%d",
> +			   __func__, r);
> +	return r;
> +}
> +
> +int purelifi_chip_switch_radio_on(struct purelifi_chip *chip)
> +{
> +	return purelifi_chip_switch_radio(chip, 1);
> +}
> +
> +int purelifi_chip_switch_radio_off(struct purelifi_chip *chip)
> +{
> +	return purelifi_chip_switch_radio(chip, 0);
> +}

Ditto

> +
> +void purelifi_chip_enable_rxtx_urb_complete(struct urb *urb_struct)
> +{
> +}

This function is not used.

> +
> +int purelifi_chip_enable_rxtx(struct purelifi_chip *chip)
> +{
> +	purelifi_usb_enable_tx(&chip->usb);
> +	return purelifi_usb_enable_rx(&chip->usb);
> +}
> +
> +void purelifi_chip_disable_rxtx(struct purelifi_chip *chip)
> +{
> +	u32 value;
> +
> +	value = 0;
> +	usb_write_req((const u8 *)&value, sizeof(value), USB_REQ_RXTX_WR);

You declared value as u32, but forwarded u8, doesn't sound right.

> +	purelifi_usb_disable_rx(&chip->usb);
> +	purelifi_usb_disable_tx(&chip->usb);
> +}
> +
> +int purelifi_chip_set_rate(struct purelifi_chip *chip, u32 rate)
> +{
> +	int r;
> +	static struct purelifi_chip *chip_p;
> +
> +	if (chip)
> +		chip_p = chip;
> +	if (!chip_p)
> +		return -EINVAL;
> +
> +	r = usb_write_req((const u8 *)&rate, sizeof(rate), USB_REQ_RATE_WR);

You better have proper types from the beginning.

> +	if (r)
> +		pl_dev_err(purelifi_chip_dev(chip), "%s::r=%d",
> +			   __func__, r);
> +	return r;
> +}
> +
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/net/wireless/purelifi/chip.h b/drivers/net/wireless/purelifi/chip.h
> new file mode 100644
> index 000000000000..892ecaf7d5d3
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/chip.h
> @@ -0,0 +1,81 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _LF_X_CHIP_H
> +#define _LF_X_CHIP_H
> +
> +#include <net/mac80211.h>
> +
> +#include "usb.h"
> +
> +enum unit_type_t {
> +	STA = 0,
> +	AP = 1,
> +};
> +
> +struct purelifi_chip {
> +	struct purelifi_usb usb;
> +	struct mutex mutex; /* lock to protect chip data */
> +	enum unit_type_t unit_type;
> +	u16 link_led;
> +	u8  beacon_set;
> +	u16 beacon_interval;
> +};
> +
> +struct purelifi_mc_hash {
> +	u32 low;
> +	u32 high;
> +};
> +
> +#define purelifi_chip_dev(chip) (&(chip)->usb.intf->dev)
> +
> +static inline struct purelifi_chip *purelifi_usb_to_chip(struct purelifi_usb
> +							 *usb
> +							)
> +{
> +	return container_of(usb, struct purelifi_chip, usb);
> +}
> +
> +void purelifi_chip_init(struct purelifi_chip *chip,
> +			struct ieee80211_hw *hw,
> +			struct usb_interface *intf);
> +void purelifi_chip_release(struct purelifi_chip *chip);
> +int purelifi_chip_init_hw(struct purelifi_chip *chip);
> +
> +/* Locking functions for reading and writing registers.
> + * The different parameters are intentional.

This comment is useless.

> + */
> +int purelifi_chip_switch_radio_on(struct purelifi_chip *chip);
> +int purelifi_chip_switch_radio_off(struct purelifi_chip *chip);
> +int purelifi_chip_enable_rxtx(struct purelifi_chip *chip);
> +void purelifi_chip_disable_rxtx(struct purelifi_chip *chip);
> +int purelifi_chip_set_rate(struct purelifi_chip *chip, u32 rate);
> +int purelifi_set_beacon_interval(struct purelifi_chip *chip, u16 interval,
> +				 u8 dtim_period, int type);
> +
> +static inline void purelifi_mc_clear(struct purelifi_mc_hash *hash)
> +{
> +	hash->low = 0;
> +	/* The interfaces must always received broadcasts.
> +	 * The hash of the broadcast address ff:ff:ff:ff:ff:ff is 63.
> +	 */
> +	hash->high = 0x80000000;
> +}
> +
> +static inline void purelifi_mc_add_all(struct purelifi_mc_hash *hash)
> +{
> +	hash->low = 0xffffffff;
> +	hash->high = 0xffffffff;
> +}
> +
> +static inline void purelifi_mc_add_addr(struct purelifi_mc_hash *hash,
> +					u8 *addr
> +					)
> +{
> +	unsigned int i = addr[5] >> 2;
> +
> +	if (i < 32)
> +		hash->low |= 1 << i;
> +	else
> +		hash->high |= 1 << (i - 32);
> +}
> +#endif /* _LF_X_CHIP_H */
> diff --git a/drivers/net/wireless/purelifi/def.h b/drivers/net/wireless/purelifi/def.h
> new file mode 100644
> index 000000000000..295dfb45b568
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/def.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _PURELIFI_DEF_H
> +#define _PURELIFI_DEF_H
> +
> +#include <linux/kernel.h>
> +#include <linux/stringify.h>
> +#include <linux/device.h>
> +
> +typedef u16 __nocast purelifi_addr_t;

?????

> +
> +#define dev_printk_f(level, dev, fmt, args...) \
> +	dev_printk(level, dev, "%s() " fmt, __func__, ##args)
> +
> +#ifdef DEBUG
> +#  define dev_dbg_f(dev, fmt, args...) \
> +	  dev_printk_f(KERN_DEBUG, dev, fmt, ## args)
> +#  define dev_dbg_f_limit(dev, fmt, args...) do { \
> +	if (net_ratelimit()) \
> +		dev_printk_f(KERN_DEBUG, dev, fmt, ## args); \
> +} while (0)
> +#  define dev_dbg_f_cond(dev, cond, fmt, args...) ({ \
> +	bool __cond = !!(cond); \
> +	if (unlikely(__cond)) \
> +		dev_printk_f(KERN_DEBUG, dev, fmt, ## args); \
> +})
> +#else
> +#  define dev_dbg_f(dev, fmt, args...)  (void)(dev)
> +#  define dev_dbg_f_limit(dev, fmt, args...) (void)(dev)
> +#  define dev_dbg_f_cond(dev, cond, fmt, args...) (void)(dev)
> +#endif /* DEBUG */
> +
> +#ifdef DEBUG
> +#  define PURELIFI_ASSERT(x) \
> +do { \
> +	if (unlikely(!(x))) { \
> +		pr_debug("%s:%d ASSERT %s VIOLATED!\n", \
> +			__FILE__, __LINE__, __stringify(x)); \
> +		dump_stack(); \
> +	} \
> +} while (0)
> +#else
> +#  define PURELIFI_ASSERT(x) do { } while (0)
> +#endif

No to everything above, please don't obscure kernel primitives.

> +
> +#endif /* _PURELIFI_DEF_H */
> diff --git a/drivers/net/wireless/purelifi/log.h b/drivers/net/wireless/purelifi/log.h
> new file mode 100644
> index 000000000000..5e275da9ba12
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/log.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _PURELIFI_LOG
> +#define _PURELIFI_LOG
> +
> +#ifdef PL_DEBUG
> +#define pl_dev_info(dev, fmt, arg...) dev_info(dev, fmt, ##arg)
> +#define pl_dev_warn(dev, fmt, arg...) dev_warn(dev, fmt, ##arg)
> +#define  pl_dev_err(dev, fmt, arg...) dev_err(dev, fmt, ##arg)
> +#else
> +#define pl_dev_info(dev, fmt, arg...) (void)(dev)
> +#define pl_dev_warn(dev, fmt, arg...) (void)(dev)
> +#define  pl_dev_err(dev, fmt, arg...) (void)(dev)
> +#endif
> +#endif

Ditto

> diff --git a/drivers/net/wireless/purelifi/mac.c b/drivers/net/wireless/purelifi/mac.c
> new file mode 100644
> index 000000000000..c6be289f8431
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/mac.c
> @@ -0,0 +1,957 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/slab.h>
> +#include <linux/usb.h>
> +#include <linux/gpio.h>
> +#include <linux/jiffies.h>
> +#include <net/ieee80211_radiotap.h>
> +
> +#include "def.h"
> +#include "chip.h"
> +#include "mac.h"
> +#include "log.h"
> +
> +#ifndef IEEE80211_BAND_2GHZ
> +#define IEEE80211_BAND_2GHZ NL80211_BAND_2GHZ
> +#endif
> +
> +static const struct ieee80211_rate purelifi_rates[] = {
> +	{ .bitrate = 10,
> +		.hw_value = PURELIFI_CCK_RATE_1M, },
> +	{ .bitrate = 20,
> +		.hw_value = PURELIFI_CCK_RATE_2M,
> +		.hw_value_short = PURELIFI_CCK_RATE_2M
> +			| PURELIFI_CCK_PREA_SHORT,
> +		.flags = IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate = 55,
> +		.hw_value = PURELIFI_CCK_RATE_5_5M,
> +		.hw_value_short = PURELIFI_CCK_RATE_5_5M
> +			| PURELIFI_CCK_PREA_SHORT,
> +		.flags = IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate = 110,
> +		.hw_value = PURELIFI_CCK_RATE_11M,
> +		.hw_value_short = PURELIFI_CCK_RATE_11M
> +			| PURELIFI_CCK_PREA_SHORT,
> +		.flags = IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate = 60,
> +		.hw_value = PURELIFI_OFDM_RATE_6M,
> +		.flags = 0 },
> +	{ .bitrate = 90,
> +		.hw_value = PURELIFI_OFDM_RATE_9M,
> +		.flags = 0 },
> +	{ .bitrate = 120,
> +		.hw_value = PURELIFI_OFDM_RATE_12M,
> +		.flags = 0 },
> +	{ .bitrate = 180,
> +		.hw_value = PURELIFI_OFDM_RATE_18M,
> +		.flags = 0 },
> +	{ .bitrate = 240,
> +		.hw_value = PURELIFI_OFDM_RATE_24M,
> +		.flags = 0 },
> +	{ .bitrate = 360,
> +		.hw_value = PURELIFI_OFDM_RATE_36M,
> +		.flags = 0 },
> +	{ .bitrate = 480,
> +		.hw_value = PURELIFI_OFDM_RATE_48M,
> +		.flags = 0 },
> +	{ .bitrate = 540,
> +		.hw_value = PURELIFI_OFDM_RATE_54M,
> +		.flags = 0 },
> +};
> +
> +static const struct ieee80211_channel purelifi_channels[] = {
> +	{ .center_freq = 2412, .hw_value = 1 },
> +	{ .center_freq = 2417, .hw_value = 2 },
> +	{ .center_freq = 2422, .hw_value = 3 },
> +	{ .center_freq = 2427, .hw_value = 4 },
> +	{ .center_freq = 2432, .hw_value = 5 },
> +	{ .center_freq = 2437, .hw_value = 6 },
> +	{ .center_freq = 2442, .hw_value = 7 },
> +	{ .center_freq = 2447, .hw_value = 8 },
> +	{ .center_freq = 2452, .hw_value = 9 },
> +	{ .center_freq = 2457, .hw_value = 10 },
> +	{ .center_freq = 2462, .hw_value = 11 },
> +	{ .center_freq = 2467, .hw_value = 12 },
> +	{ .center_freq = 2472, .hw_value = 13 },
> +	{ .center_freq = 2484, .hw_value = 14 },
> +};
> +
> +static int purelifi_mac_config_beacon(struct ieee80211_hw *hw,
> +				      struct sk_buff *beacon, bool in_intr);
> +
> +int purelifi_mac_preinit_hw(struct ieee80211_hw *hw, unsigned char *hw_address)
> +{
> +	SET_IEEE80211_PERM_ADDR(hw, hw_address);
> +	return 0;
> +}
> +
> +void block_queue(struct purelifi_usb *usb, const u8 *mac, bool block)
> +{
> +#ifdef CONFIG_PURELIFI_AP
> +	struct ieee80211_vif *vif = purelifi_usb_to_mac(usb)->vif;
> +	struct ieee80211_sta *sta = ieee80211_find_sta(vif, mac);
> +
> +	if (!sta) {
> +		//Print Debugs

The code submitted to the kernel should be in release quality with
minimal debug prints, no C++ comments and really hard-to-do and not
important TODOs.

> +	} else {
> +		ieee80211_sta_block_awake(purelifi_usb_to_hw(usb), sta,
> +					  block);
> +	}
> +#else
> +	if (block)
> +		ieee80211_stop_queues(purelifi_usb_to_hw(usb));
> +	else
> +		ieee80211_wake_queues(purelifi_usb_to_hw(usb));
> +#endif
> +}
> +
> +int purelifi_mac_init_hw(struct ieee80211_hw *hw)
> +{
> +	int r;
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct purelifi_chip *chip = &mac->chip;
> +
> +	r = purelifi_chip_init_hw(chip);
> +	if (r) {
> +		pl_dev_warn(purelifi_mac_dev(mac), "%s::purelifi_chip_init_hw	failed. (%d)\n",
> +			    __func__, r);
> +		goto out;
> +	}
> +	PURELIFI_ASSERT(!irqs_disabled());
> +
> +	r = regulatory_hint(hw->wiphy, "CA");
> +out:
> +	return r;
> +}
> +
> +void purelifi_mac_release(struct purelifi_mac *mac)
> +{
> +	purelifi_chip_release(&mac->chip);
> +	lockdep_assert_held(&mac->lock);
> +}
> +
> +int purelifi_op_start(struct ieee80211_hw *hw)
> +{
> +	regulatory_hint(hw->wiphy, "EU");
> +	purelifi_hw_mac(hw)->chip.usb.initialized = 1;
> +	return 0;
> +}
> +
> +void purelifi_op_stop(struct ieee80211_hw *hw)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct purelifi_chip *chip = &mac->chip;
> +	struct sk_buff *skb;
> +	struct sk_buff_head *ack_wait_queue = &mac->ack_wait_queue;
> +
> +	pl_dev_info(purelifi_mac_dev(mac), "%s", __func__);
> +
> +	clear_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
> +
> +	/* The order here deliberately is a little different from the open()
> +	 * method, since we need to make sure there is no opportunity for RX
> +	 * frames to be processed by mac80211 after we have stopped it.
> +	 */
> +
> +	return;  //don't allow stop for debugging rx_urb_complete failure

Did you test the code?

> +	purelifi_chip_switch_radio_off(chip);
> +
> +	while ((skb = skb_dequeue(ack_wait_queue)))
> +		dev_kfree_skb_any(skb);
> +	return;  //don't allow stop for debugging rx_urb_complete failure
> +}
> +
> +int purelifi_restore_settings(struct purelifi_mac *mac)
> +{
> +	struct sk_buff *beacon;
> +	struct purelifi_mc_hash multicast_hash;
> +	int beacon_interval, beacon_period;
> +
> +	dev_dbg_f(purelifi_mac_dev(mac), "\n");
> +
> +	spin_lock_irq(&mac->lock);
> +	multicast_hash = mac->multicast_hash;
> +	beacon_interval = mac->beacon.interval;
> +	beacon_period = mac->beacon.period;
> +	spin_unlock_irq(&mac->lock);
> +
> +	if (mac->type == NL80211_IFTYPE_MESH_POINT ||
> +	    mac->type == NL80211_IFTYPE_ADHOC ||
> +			mac->type == NL80211_IFTYPE_AP) {
> +		if (mac->vif) {
> +			beacon = ieee80211_beacon_get(mac->hw, mac->vif);
> +			if (beacon) {
> +				purelifi_mac_config_beacon(mac->hw, beacon,
> +							   false);
> +				kfree_skb(beacon);
> +				/* Returned skb is used only once and lowlevel
> +				 *  driver is responsible for freeing it.
> +				 */
> +			}
> +		}
> +
> +		purelifi_set_beacon_interval(&mac->chip, beacon_interval,
> +					     beacon_period, mac->type);
> +
> +		spin_lock_irq(&mac->lock);
> +		mac->beacon.last_update = jiffies;
> +		spin_unlock_irq(&mac->lock);
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * purelifi_mac_tx_status - reports tx status of a packet if required
> + * @hw - a &struct ieee80211_hw pointer
> + * @skb - a sk-buffer
> + * @flags: extra flags to set in the TX status info
> + * @ackssi: ACK signal strength
> + * @success - True for successful transmission of the frame
> + *
> + * This information calls ieee80211_tx_status_irqsafe() if required by the
> + * control information. It copies the control information into the status
> + * information.
> + *
> + * If no status information has been requested, the skb is freed.
> + */
> +static void purelifi_mac_tx_status(struct ieee80211_hw *hw,
> +				   struct sk_buff *skb,
> +		int ackssi, struct tx_status *tx_status)
> +{
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	int success = 1, retry = 1;
> +
> +	ieee80211_tx_info_clear_status(info);
> +
> +	if (tx_status) {
> +		success = !tx_status->failure;
> +		retry = tx_status->retry + success;
> +	}
> +
> +	if (success)
> +		info->flags |= IEEE80211_TX_STAT_ACK;
> +	else
> +		info->flags &= ~IEEE80211_TX_STAT_ACK;
> +
> +	info->status.ack_signal = 50;
> +	ieee80211_tx_status_irqsafe(hw, skb);
> +}
> +
> +/**
> + * purelifi_mac_tx_to_dev - callback for USB layer
> + * @skb: a &sk_buff pointer
> + * @error: error value, 0 if transmission successful
> + *
> + * Informs the MAC layer that the frame has successfully transferred to the
> + * device. If an ACK is required and the transfer to the device has been
> + * successful, the packets are put on the @ack_wait_queue with
> + * the control set removed.
> + */
> +void purelifi_mac_tx_to_dev(struct sk_buff *skb, int error)
> +{
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct ieee80211_hw *hw = info->rate_driver_data[0];
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +
> +	ieee80211_tx_info_clear_status(info);
> +	skb_pull(skb, sizeof(struct purelifi_ctrlset));
> +
> +	if (unlikely(error ||
> +		     (info->flags & IEEE80211_TX_CTL_NO_ACK))) {
> +		//FIXME : do we need to fill in anything ?

Linux kernel is written in C, no C++ code, please.

> +		ieee80211_tx_status_irqsafe(hw, skb);
> +	} else {
> +		// ieee80211_tx_status_irqsafe(hw, skb);
> +		struct sk_buff_head *q = &mac->ack_wait_queue;
> +
> +		skb_queue_tail(q, skb);
> +		while (skb_queue_len(q)/* > PURELIFI_MAC_MAX_ACK_WAITERS*/) {
> +			purelifi_mac_tx_status(hw, skb_dequeue(q),
> +					       mac->ack_pending ?
> +					mac->ack_signal : 0,
> +					NULL);
> +			mac->ack_pending = 0;
> +		}
> +	}
> +}
> +
> +static int purelifi_mac_config_beacon(struct ieee80211_hw *hw,
> +				      struct sk_buff *beacon, bool in_intr)
> +{
> +	return usb_write_req((const u8 *)beacon->data, beacon->len,
> +			USB_REQ_BEACON_WR);
> +}
> +
> +static int fill_ctrlset(struct purelifi_mac *mac, struct sk_buff *skb)
> +{
> +	unsigned int frag_len = skb->len;
> +	unsigned int tmp;
> +	struct purelifi_ctrlset *cs;
> +
> +	if (skb_headroom(skb) >= sizeof(struct purelifi_ctrlset)) {
> +		cs = (struct purelifi_ctrlset *)skb_push(skb,
> +				sizeof(struct purelifi_ctrlset));
> +	} else {
> +		pl_dev_info(purelifi_mac_dev(mac), "Not enough hroom(1)\n");
> +		return 1;
> +	}
> +
> +	cs->id = USB_REQ_DATA_TX;
> +	cs->payload_len_nw = frag_len;
> +	cs->len = cs->payload_len_nw + sizeof(struct purelifi_ctrlset)
> +		- sizeof(cs->id) - sizeof(cs->len);
> +
> +	/* data packet lengths must be multiple of four bytes
> +	 * and must not be a multiple of 512
> +	 * bytes. First, it is attempted to append the
> +	 * data packet in the tailroom of the skb. In rare
> +	 * ocasions, the tailroom is too small. In this case,
> +	 * the content of the packet is shifted into
> +	 * the headroom of the skb by memcpy. Headroom is allocated
> +	 * at startup (below in this file). Therefore,
> +	 * there will be always enough headroom. The call skb_headroom
> +	 * is an additional safety which might be
> +	 * dropped.
> +	 */
> +
> +	/*check if 32 bit aligned */

Don't we have macro for that?

> +	tmp = skb->len & 3;
> +	if (tmp) {
> +		if (skb_tailroom(skb) >= (3 - tmp)) {
> +			skb_put(skb, 4 - tmp);
> +		} else {
> +			if (skb_headroom(skb) >= 4 - tmp) {
> +				u8 len;
> +				u8 *src_pt;
> +				u8 *dest_pt;
> +
> +				len = skb->len;
> +				src_pt = skb->data;
> +				dest_pt = skb_push(skb, 4 - tmp);
> +				memcpy(dest_pt, src_pt, len);
> +			} else {
> +				return 1;
> +			}
> +		}
> +		cs->len +=  4 - tmp;
> +	}
> +
> +	//check if not multiple of 512

Ditto

> +	tmp = skb->len & 0x1ff;
> +	if (!tmp) {
> +		if (skb_tailroom(skb) >= 4) {
> +			skb_put(skb, 4);
> +		} else {
> +			if (skb_headroom(skb) >= 4) {
> +				u8 len = skb->len;
> +				u8 *src_pt = skb->data;
> +				u8 *dest_pt = skb_push(skb, 4);
> +
> +				memcpy(dest_pt, src_pt, len);
> +			} else {
> +				/* should never happen b/c
> +				 * sufficient headroom was reserved
> +				 */
> +				return 1;
> +			}
> +		}
> +
> +		cs->len +=  4;
> +	}
> +
> +	cs->id = TO_NETWORK(cs->id);
> +	cs->len = TO_NETWORK(cs->len);
> +	cs->payload_len_nw = TO_NETWORK(cs->payload_len_nw);
> +
> +	return 0;
> +}
> +
> +/**
> + * purelifi_op_tx - transmits a network frame to the device
> + *
> + * @dev: mac80211 hardware device
> + * @skb: socket buffer
> + * @control: the control structure
> + *
> + * This function transmit an IEEE 802.11 network frame to the device. The
> + * control block of the skbuff will be initialized. If necessary the incoming
> + * mac80211 queues will be stopped.
> + */
> +extern void send_packet_from_data_queue(struct purelifi_usb *usb);
> +static void purelifi_op_tx(struct ieee80211_hw *hw,
> +			   struct ieee80211_tx_control *control,
> +			   struct sk_buff *skb)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct purelifi_usb *usb = &mac->chip.usb;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);

Reversed Christmas tree in all places, please.

I stopped here.

Thanks
