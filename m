Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6858C3BA12
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbfFJQyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:54:37 -0400
Received: from foss.arm.com ([217.140.110.172]:46162 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728007AbfFJQyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 12:54:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D9C1337;
        Mon, 10 Jun 2019 09:54:34 -0700 (PDT)
Received: from [10.1.197.57] (bionic-guest.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E1473F246;
        Mon, 10 Jun 2019 09:54:33 -0700 (PDT)
Subject: Re: [PATCH 3/4] arm64: dts: meson: use the generic Ethernet PHY reset
 GPIO bindings
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20190610163736.6187-1-martin.blumenstingl@googlemail.com>
 <20190610163736.6187-4-martin.blumenstingl@googlemail.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <8075d0ee-36fa-c4f3-f640-98cf54aba87b@arm.com>
Date:   Mon, 10 Jun 2019 17:54:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190610163736.6187-4-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On 10/06/2019 17:37, Martin Blumenstingl wrote:
> The snps,reset-gpio bindings are deprecated in favour of the generic
> "Ethernet PHY reset" bindings.
> 
> Replace snps,reset-gpio from the &ethmac node with reset-gpios in the
> ethernet-phy node. The old snps,reset-active-low property is now encoded
> directly as GPIO flag inside the reset-gpios property.
> 
> snps,reset-delays-us is converted to reset-assert-us and
> reset-deassert-us. reset-assert-us is the second cell from
> snps,reset-delays-us while reset-deassert-us was the third cell.
> 
> Instead of blindly copying the old values (which seems strange since
> they gave the PHY one second to come out of reset) over this also
> updates the delays based on the datasheets:
> - the Realtek RTL8211F PHY needs a 10ms delay (this applies to the
>    following boards: GXBB NanoPi K2, GXBB Odroid-C2, GXBB Vega S95
>    variants, GXBB Wetek variants, GXL P230, GXM Khadas VIM2, GXM Nexbox
>    A1, GXM Q200, GXM RBox Pro)

 From the datasheets I've seen, RTL8211E/F specify an assert delay of 
10ms, but a deassert delay of 30ms.

Robin.

> - the ICPlus IP101GR PHY needs a 2.5ms delay (this applies to the GXBB
>    Nexbox A95X)
> - the Micrel KSZ9031 seems to require a 100us delay but use the same
>    (seemingly safe) values from RTL8211F due to lack of a board to verify
>    this (this appleis to the GXBB P200)
> 
> The GXBB P201 board is left out from this conversion because it doesn't
> have a dedicated PHY node (because it's not clear which PHY is used on
> that board).
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>   arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts  |  9 +++++----
>   .../arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts |  8 ++++----
>   arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts   |  9 +++++----
>   arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts       |  9 +++++----
>   arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi  |  9 +++++----
>   arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi     |  8 ++++----
>   arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts  | 11 ++++++-----
>   arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts | 10 +++++-----
>   arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts   |  8 ++++----
>   arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts        | 11 ++++++-----
>   arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts    |  8 ++++----
>   11 files changed, 53 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
> index 849c01650c4d..32e901538519 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
> @@ -154,10 +154,6 @@
>   
>   	amlogic,tx-delay-ns = <2>;
>   
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>   	mdio {
>   		compatible = "snps,dwmac-mdio";
>   		#address-cells = <1>;
> @@ -166,6 +162,11 @@
>   		eth_phy0: ethernet-phy@0 {
>   			/* Realtek RTL8211F (0x001cc916) */
>   			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <10000>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>   			interrupt-parent = <&gpio_intc>;
>   			/* MAC_INTR on GPIOZ_15 */
>   			interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts
> index 3c54f26eef15..c2f619a6a96c 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts
> @@ -162,10 +162,6 @@
>   	phy-handle = <&eth_phy0>;
>   	phy-mode = "rmii";
>   
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>   	mdio {
>   		compatible = "snps,dwmac-mdio";
>   		#address-cells = <1>;
> @@ -174,6 +170,10 @@
>   		eth_phy0: ethernet-phy@0 {
>   			/* IC Plus IP101GR (0x02430c54) */
>   			reg = <0>;
> +
> +			reset-assert-us = <2500>;
> +			reset-deassert-us = <2500>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
>   		};
>   	};
>   };
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
> index 5a139e7b1c60..fc0528a89b6c 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
> @@ -126,10 +126,6 @@
>   	phy-handle = <&eth_phy0>;
>   	phy-mode = "rgmii";
>   
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>   	amlogic,tx-delay-ns = <2>;
>   
>   	mdio {
> @@ -140,6 +136,11 @@
>   		eth_phy0: ethernet-phy@0 {
>   			/* Realtek RTL8211F (0x001cc916) */
>   			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <10000>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>   			interrupt-parent = <&gpio_intc>;
>   			/* MAC_INTR on GPIOZ_15 */
>   			interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts
> index 9d2406a7c4fa..eeea17767cab 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts
> @@ -68,10 +68,6 @@
>   
>   	amlogic,tx-delay-ns = <2>;
>   
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>   	mdio {
>   		compatible = "snps,dwmac-mdio";
>   		#address-cells = <1>;
> @@ -80,6 +76,11 @@
>   		eth_phy0: ethernet-phy@3 {
>   			/* Micrel KSZ9031 (0x00221620) */
>   			reg = <3>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <10000>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>   			interrupt-parent = <&gpio_intc>;
>   			/* MAC_INTR on GPIOZ_15 */
>   			interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
> index 18856f28fd60..a7c2d8bfdd0b 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
> @@ -116,10 +116,6 @@
>   
>   	amlogic,tx-delay-ns = <2>;
>   
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>   	mdio {
>   		compatible = "snps,dwmac-mdio";
>   		#address-cells = <1>;
> @@ -128,6 +124,11 @@
>   		eth_phy0: ethernet-phy@0 {
>   			/* Realtek RTL8211F (0x001cc916) */
>   			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <10000>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>   			interrupt-parent = <&gpio_intc>;
>   			/* MAC_INTR on GPIOZ_15 */
>   			interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
> index 9ef6858779c1..dc0d8c3b4eff 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
> @@ -137,10 +137,6 @@
>   
>   	amlogic,tx-delay-ns = <2>;
>   
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>   	mdio {
>   		compatible = "snps,dwmac-mdio";
>   		#address-cells = <1>;
> @@ -149,6 +145,10 @@
>   		eth_phy0: ethernet-phy@0 {
>   			/* Realtek RTL8211F (0x001cc916) */
>   			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <10000>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
>   		};
>   	};
>   };
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
> index 767b1763a612..003d6aa6964c 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
> @@ -70,11 +70,6 @@
>   
>   	amlogic,tx-delay-ns = <2>;
>   
> -	/* External PHY reset is shared with internal PHY Led signals */
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>   	/* External PHY is in RGMII */
>   	phy-mode = "rgmii";
>   };
> @@ -84,6 +79,12 @@
>   		/* Realtek RTL8211F (0x001cc916) */
>   		reg = <0>;
>   		max-speed = <1000>;
> +
> +		/* External PHY reset is shared with internal PHY Led signal */
> +		reset-assert-us = <10000>;
> +		reset-deassert-us = <10000>;
> +		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>   		interrupt-parent = <&gpio_intc>;
>   		interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
>   		eee-broken-1000t;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
> index ff4f0780824d..2b6003b605a4 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
> @@ -239,11 +239,6 @@
>   
>   	amlogic,tx-delay-ns = <2>;
>   
> -	/* External PHY reset is shared with internal PHY Led signals */
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>   	/* External PHY is in RGMII */
>   	phy-mode = "rgmii";
>   
> @@ -254,6 +249,11 @@
>   	external_phy: ethernet-phy@0 {
>   		/* Realtek RTL8211F (0x001cc916) */
>   		reg = <0>;
> +
> +		reset-assert-us = <10000>;
> +		reset-deassert-us = <10000>;
> +		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>   		interrupt-parent = <&gpio_intc>;
>   		/* MAC_INTR on GPIOZ_15 */
>   		interrupts = <25 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
> index 29715eae14a9..a2a7ec5c8fd6 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
> @@ -101,10 +101,6 @@
>   
>   	amlogic,tx-delay-ns = <2>;
>   
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>   	/* External PHY is in RGMII */
>   	phy-mode = "rgmii";
>   };
> @@ -114,6 +110,10 @@
>   		/* Realtek RTL8211F (0x001cc916) */
>   		reg = <0>;
>   		max-speed = <1000>;
> +
> +		reset-assert-us = <10000>;
> +		reset-deassert-us = <10000>;
> +		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
>   	};
>   };
>   
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
> index 8939c0fc5b62..044668228ece 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
> @@ -52,11 +52,6 @@
>   
>   	amlogic,tx-delay-ns = <2>;
>   
> -	/* External PHY reset is shared with internal PHY Led signals */
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>   	/* External PHY is in RGMII */
>   	phy-mode = "rgmii";
>   };
> @@ -66,6 +61,12 @@
>   		/* Realtek RTL8211F (0x001cc916) */
>   		reg = <0>;
>   		max-speed = <1000>;
> +
> +		/* External PHY reset is shared with internal PHY Led signal */
> +		reset-assert-us = <10000>;
> +		reset-deassert-us = <10000>;
> +		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>   		interrupt-parent = <&gpio_intc>;
>   		/* MAC_INTR on GPIOZ_15 */
>   		interrupts = <25 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
> index 13de1e8f58b5..04eae80585af 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
> @@ -101,10 +101,6 @@
>   	/* Select external PHY by default */
>   	phy-handle = <&external_phy>;
>   
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>   	amlogic,tx-delay-ns = <2>;
>   
>   	/* External PHY is in RGMII */
> @@ -116,6 +112,10 @@
>   		/* Realtek RTL8211F (0x001cc916) */
>   		reg = <0>;
>   		max-speed = <1000>;
> +
> +		reset-assert-us = <10000>;
> +		reset-deassert-us = <10000>;
> +		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
>   	};
>   };
>   
> 
