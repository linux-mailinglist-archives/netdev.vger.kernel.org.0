Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8973F05C3
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238743AbhHROIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 10:08:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:11730 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238406AbhHROIu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 10:08:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="280066329"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="280066329"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 07:08:14 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="511212717"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 07:08:07 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mGMEW-00B8AF-Ie; Wed, 18 Aug 2021 17:07:56 +0300
Date:   Wed, 18 Aug 2021 17:07:56 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     David Thompson <davthompson@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Liming Sun <limings@nvidia.com>
Subject: Re: [PATCH v1 5/6] TODO: gpio: mlxbf2: Introduce IRQ support
Message-ID: <YR0UPG2451aGt9Xg@smile.fi.intel.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-6-andriy.shevchenko@linux.intel.com>
 <CH2PR12MB3895ACF821C8242AA55A1DCDD7FD9@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB3895ACF821C8242AA55A1DCDD7FD9@CH2PR12MB3895.namprd12.prod.outlook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 09:34:50PM +0000, Asmaa Mnebhi wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com> 
> Sent: Monday, August 16, 2021 8:00 AM

...

> +static irqreturn_t mlxbf2_gpio_irq_handler(int irq, void *ptr) {
> 
> So how do you suggest registering this handler?

As usual. This handler should be probably registered via standard mechanisms.
Perhaps it's hierarchical IRQ, then use that facility of GPIO library.
(see gpio-dwapb.c for the example).

> 1) should I still use BF_RSH0_DEVICE_YU_INT shared interrupt signal?

I don't know your hardware connection between GPIO and GIC. You have to look
into TRM and see how they are connected and what should be programmed for the
mode you want to run this in.

> 2) or does Linux kernel know (based on parsing GpioInt) how trigger the
> handler based on the GPIO datain changing (active low/high)? In this case,
> the kernel will call this handler whenever the GPIO pin (9 or 12) value
> changes.

After driver in place kernel will know how to map, register and handle the GPIO
interrupt. But the GIC part is out of the picture here. It may be you will need
additional stuff there, like disabling (or else) the interrupts, or providing a
bypass. I can't answer to this.

> I need to check whether GPIO is active low/high but lets assume for
> now it is open drain active low. We will use acpi_dev_gpio_irq_get to
> translate GpioInt to a Linux IRQ number:

> irq = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(dev), "phy-gpios", 0);
> ret = devm_request_irq(dev, irq, mlxbf2_gpio_irq_handler, IRQF_ONESHOT | IRQF_SHARED, dev_name(dev), gs);

Yes.
(I dunno about one short and shared flags, but you should know it better than me)

> And I will need to add GpioInt to the GPI0 ACPI table as follows:

But you told me that it's already on the market, how are you suppose to change
existing tables?

> // GPIO Controller
>       Device(GPI0) {
>        Name(_HID, "MLNXBF22")
>         Name(_UID, Zero)
>         Name(_CCA, 1)
>         Name(_CRS, ResourceTemplate() {
>           // for gpio[0] yu block
>          Memory32Fixed(ReadWrite, 0x0280c000, 0x00000100)
>          GpioInt (Level, ActiveLow, Exclusive, PullDefault, , " \\_SB.GPI0") {9}
>         })
>         Name(_DSD, Package() {
>           ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>           Package() {
>             Package () { "phy-gpios", Package() {^GPI0, 0, 0, 0 }},
>             Package () { "rst-pin", 32 }, // GPIO pin triggering soft reset on BlueSphere and PRIS
>           }
>         })
>       }

No, it's completely wrong. The resources are provided by GPIO controller and
consumed by devices. You showed me the table for the consumer, which is good
(of course if you wish to use Edge triggered interrupts there).

...

> +		handle_nested_irq(nested_irq);

> Now how can the mlxbf_gige_main.c driver also retrieve this nested_irq to
> register its interrupt handler as well? This irq.domain is only visible to
> the gpio-mlxbf2.c driver isn't it?  phydev->irq (below) should be populated
> with nested_irq at init time because it is used to register the phy interrupt
> in this generic function:

nested here is an example, you have to check which one to use.

Moreover the code misses ->irq_set_type() callback.

So, yes, domain will be GPIOs but IRQ core will handle it properly.

> void phy_request_interrupt(struct phy_device *phydev)
> {
> 	int err;
> 
> 	err = request_threaded_irq(phydev->irq, NULL, phy_interrupt,
> 				   IRQF_ONESHOT | IRQF_SHARED,
> 				   phydev_name(phydev), phydev);

You have several IRQ resources (Interrupt() and GpioInt() ones) in the consumer
device node. I don't know how your hardware is designed, but if you want to use
GPIO, then this phydev->irq should be a Linux vIRQ returned from above
mentioned acpi_dev_gpio_irq_get_by() call. Everything else is magically happens.

...

> +	int offset = irqd_to_hwirq(irqd) % MLXBF2_GPIO_MAX_PINS_PER_BLOCK;

> Why is the modulo needed? Isn't the hwirq returned a number between 0 and
> MLXBF2_GPIO_MAX_PINS_PER_BLOCK-1 ?

It's copy'n'paste from somewhere, since you have device per bank you don't
need it.

...

> We also need to make sure that the gpio driver is loaded before the
> mlxbf-gige driver. Otherwise, the mlxbf-gige 1G interface fails to come up.
> I have implemented this dependency on the gpio driver before, something like
> this at the end of the mlxbf-gige driver:

> MODULE_SOFTDEP("pre: gpio_mlxbf2");

No, when you have GPIO device is listed in the tables the IRQ mapping will
return you deferred probe. It doesn't matter when device will appear, but it
will be functional only when all resource requirements are satisfied.

Above soft dependency doesn't guarantee this, deferred probe does.

-- 
With Best Regards,
Andy Shevchenko


