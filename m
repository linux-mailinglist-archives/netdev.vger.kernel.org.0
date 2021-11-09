Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1616D44A536
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 04:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242442AbhKIDP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 22:15:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235901AbhKIDP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 22:15:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7D3C6120A;
        Tue,  9 Nov 2021 03:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636427562;
        bh=Vj6mN47ETXHPlVPItotZdyR9KltKfth72u8woDTgtlM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vE87oTxLQiugl3AAx/5SlS0/ObJ6tzCuAyplAOAPfXhN8q2kKPfxv94RRYc/DRXfi
         MZilqVeHU5w1B59D43bMqiNpcQcmn5iU+xw6fvlsyM7RRDugxmo1gLYmJe7h45k8y+
         gYViGpMRsKLXEIHgp7OtjfW7lVUURfcFS0PKcgKDrT56uZLcUbV/uDQtQAqSFl2VWK
         N+yM2Ll5NxOqatp2ly6jYpSR+acACBlPJq9MHoGFLaOpFvvCVUYpjaBP8kyRcKpFSN
         W82CTLjvTbcXNCu/S0e6eyChtjr9GvydCwe4ZfLNwvRnITjeNgcJAAcmrUF8ALWo0f
         gpXMArWL6ubbA==
Date:   Tue, 9 Nov 2021 04:12:36 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v3 5/8] leds: trigger: netdev: add hardware control
 support
Message-ID: <20211109041236.5bacbc19@thinkpad>
In-Reply-To: <20211109022608.11109-6-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
        <20211109022608.11109-6-ansuelsmth@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Nov 2021 03:26:05 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> Add hardware control support for the Netdev trigger.
> The trigger on config change will check if the requested trigger can set
> to blink mode using LED hardware mode and if every blink mode is supported,
> the trigger will enable hardware mode with the requested configuration.
> If there is at least one trigger that is not supported and can't run in
> hardware mode, then software mode will be used instead.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/leds/trigger/ledtrig-netdev.c | 61 ++++++++++++++++++++++++++-
>  1 file changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
> index 0a3c0b54dbb9..28d9def2fbd0 100644
> --- a/drivers/leds/trigger/ledtrig-netdev.c
> +++ b/drivers/leds/trigger/ledtrig-netdev.c
> @@ -37,6 +37,7 @@
>   */
>  
>  struct led_netdev_data {
> +	bool hw_mode_supported;
>  	spinlock_t lock;
>  
>  	struct delayed_work work;
> @@ -61,9 +62,52 @@ enum netdev_led_attr {
>  
>  static void set_baseline_state(struct led_netdev_data *trigger_data)
>  {
> +	bool can_offload;
>  	int current_brightness;
> +	u32 hw_blink_mode_supported;
>  	struct led_classdev *led_cdev = trigger_data->led_cdev;
>  
> +	if (trigger_data->hw_mode_supported) {
> +		if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode) &&
> +		    led_trigger_blink_mode_is_supported(led_cdev, TRIGGER_NETDEV_LINK))
> +			hw_blink_mode_supported |= TRIGGER_NETDEV_LINK;
> +		if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) &&
> +		    led_trigger_blink_mode_is_supported(led_cdev, TRIGGER_NETDEV_TX))
> +			hw_blink_mode_supported |= TRIGGER_NETDEV_TX;
> +		if (test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode) &&
> +		    led_trigger_blink_mode_is_supported(led_cdev, TRIGGER_NETDEV_RX))
> +			hw_blink_mode_supported |= TRIGGER_NETDEV_RX;
> +
> +		/* All the requested blink mode can be triggered by hardware.
> +		 * Put it in hardware mode.
> +		 */
> +		if (hw_blink_mode_supported == trigger_data->mode)
> +			can_offload = true;
> +
> +		if (can_offload) {
> +			/* We are refreshing the blink modes. Reset them */
> +			led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_LINK,
> +						       BLINK_MODE_ZERO);
> +
> +			if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
> +				led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_LINK,
> +							       BLINK_MODE_ENABLE);
> +			if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode))
> +				led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_TX,
> +							       BLINK_MODE_ENABLE);
> +			if (test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
> +				led_cdev->hw_control_configure(led_cdev, TRIGGER_NETDEV_RX,
> +							       BLINK_MODE_ENABLE);
> +			led_cdev->hw_control_start(led_cdev);

Please nooo :)
This is exactly what I wanted to avoid, this logic should be in the LED
driver itself.

Can you please at least read my last proposal?

patch 2
https://lore.kernel.org/linux-leds/20210601005155.27997-3-kabel@kernel.org/
adds the trigger_offload() method. This may need to get changed to
trigger_offload_start() and trigger_offload_stop(), as per Andrew's
request.

patch 3
https://lore.kernel.org/linux-leds/20210601005155.27997-4-kabel@kernel.org/
moves the whole struct led_netdev_data to global include file
include/linux/ledtrig-netdev.h

patch 4
https://lore.kernel.org/linux-leds/20210601005155.27997-5-kabel@kernel.org/
makes netdev trigger to try to call the trigger_offload() method.

So after patch 4, netdev trigger calls trigger_offload() methods and
passes itself into it.

Example implementation is then in patch 10 of the series
https://lore.kernel.org/linux-leds/20210601005155.27997-11-kabel@kernel.org/
Look at omnia_led_trig_offload() function.

The benefit of this API is that it is flexible - all existing triggers
an be theoretically offloaded to HW (if there is HW that supports it)
without change to this API, and with minimal changes to the sw
implementations of the triggers.

Could you please at least try it?

I am willing to work with you on this. We can make a conference call
tomorrow, if you are able to.

Marek
