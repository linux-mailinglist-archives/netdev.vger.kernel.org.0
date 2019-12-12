Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8811CA81
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfLLKWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:22:36 -0500
Received: from foss.arm.com ([217.140.110.172]:41272 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbfLLKWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 05:22:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64FED328;
        Thu, 12 Dec 2019 02:22:35 -0800 (PST)
Received: from [10.1.196.37] (e121345-lin.cambridge.arm.com [10.1.196.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF0D23F6CF;
        Thu, 12 Dec 2019 02:22:33 -0800 (PST)
Subject: Re: [PATCH v2 9/9] arm64: dts: rockchip: RockPro64: hook up bluetooth
 at uart0
To:     Soeren Moch <smoch@web.de>, Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, brcm80211-dev-list@cypress.com,
        linux-arm-kernel@lists.infradead.org
References: <20191211235253.2539-1-smoch@web.de>
 <20191211235253.2539-10-smoch@web.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <a0ad4723-db85-0eda-efb5-f0c9a2a6aec3@arm.com>
Date:   Thu, 12 Dec 2019 10:22:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191211235253.2539-10-smoch@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Soeren,

On 11/12/2019 11:52 pm, Soeren Moch wrote:
> With enabled wifi support (required for firmware loading) for the
> Ampak AP6359SA based wifi/bt combo module we now also can enable
> the bluetooth part.
> 
> Suggested-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Soeren Moch <smoch@web.de>
> ---
> changes in v2:
> - new patch
> 
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: brcm80211-dev-list@cypress.com
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-rockchip@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   .../boot/dts/rockchip/rk3399-rockpro64.dts    | 29 ++++++++++++++++++-
>   1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
> index 9fa92790d6e0..94cc462e234d 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
> +++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
> @@ -561,6 +561,20 @@
>   };
> 
>   &pinctrl {
> +	bt {
> +		bt_enable_h: bt-enable-h {
> +			rockchip,pins = <0 RK_PB1 RK_FUNC_GPIO &pcfg_pull_none>;
> +		};
> +
> +		bt_host_wake_l: bt-host-wake-l {
> +			rockchip,pins = <0 RK_PA4 RK_FUNC_GPIO &pcfg_pull_down>;
> +		};
> +
> +		bt_wake_l: bt-wake-l {
> +			rockchip,pins = <2 RK_PD3 RK_FUNC_GPIO &pcfg_pull_none>;
> +		};
> +	};
> +
>   	buttons {
>   		pwrbtn: pwrbtn {
>   			rockchip,pins = <0 RK_PA5 RK_FUNC_GPIO &pcfg_pull_up>;
> @@ -729,8 +743,21 @@
> 
>   &uart0 {
>   	pinctrl-names = "default";
> -	pinctrl-0 = <&uart0_xfer &uart0_cts>;
> +	pinctrl-0 = <&uart0_xfer &uart0_cts &uart0_rts>;
>   	status = "okay";
> +
> +	bluetooth {
> +		compatible = "brcm,bcm43438-bt";
> +		clocks = <&rk808 1>;
> +		clock-names = "extclk";

Is this right? Comparing the binding and the naming on the schematics, 
it seems more likely that this might be the LPO clock rather than the 
TXCO clock.

Robin.

> +		device-wakeup-gpios = <&gpio2 RK_PD3 GPIO_ACTIVE_HIGH>;
> +		host-wakeup-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_HIGH>;
> +		shutdown-gpios = <&gpio0 RK_PB1 GPIO_ACTIVE_HIGH>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&bt_host_wake_l &bt_wake_l &bt_enable_h>;
> +		vbat-supply = <&vcc3v3_sys>;
> +		vddio-supply = <&vcc_1v8>;
> +	};
>   };
> 
>   &uart2 {
> --
> 2.17.1
> 
> 
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
> 
