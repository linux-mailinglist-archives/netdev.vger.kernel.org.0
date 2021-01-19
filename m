Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399262FC2B6
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 22:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbhASVrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 16:47:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389596AbhASVqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 16:46:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ABC222E01;
        Tue, 19 Jan 2021 21:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611092759;
        bh=kruhdxPqhzyBqegCl6kwbaI4zJnzo6UfMpl35chwUTE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dVnUdrVRoybRE2url3sGJw/jBPjn4oeyw1lNmJ9DOO1/HH4AiW4mA4N4Jy7/W2zNr
         sTmZuoWPEh/V0rRj6JRhcPpmunyiYPzSbHoTR7M92MYIJSUvbBcCBunPbxg2EjcJ1N
         P01XODXIosk72N/Q2Zta2dOgG6BIB3CxD/CgfbHUScM12qlzgt0IuYZN0UrsepyJ/t
         tAv5FFggYGTk1Ejd2bGZlWPxMzyl0PsuwzIHMrG40yQnlcDt2TU3ar74A0t9OuG0tp
         vuiHGIkHaooNjquYXDiq58fylDuNxFjXkhMEAfdoLk406MMO8XGCDSxAzxXxD46MBt
         MiX5VYsLMWCNw==
Date:   Tue, 19 Jan 2021 13:45:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: usb: cdc_ncm: don't spew notifications
Message-ID: <20210119134558.5072a1cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210116052623.3196274-3-grundler@chromium.org>
References: <20210116052623.3196274-1-grundler@chromium.org>
        <20210116052623.3196274-3-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 21:26:23 -0800 Grant Grundler wrote:
> RTL8156 sends notifications about every 32ms.
> Only display/log notifications when something changes.
> 
> This issue has been reported by others:
> 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1832472
> 	https://lkml.org/lkml/2020/8/27/1083
> 
> ...
> [785962.779840] usb 1-1: new high-speed USB device number 5 using xhci_hcd
> [785962.929944] usb 1-1: New USB device found, idVendor=0bda, idProduct=8156, bcdDevice=30.00
> [785962.929949] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=6
> [785962.929952] usb 1-1: Product: USB 10/100/1G/2.5G LAN
> [785962.929954] usb 1-1: Manufacturer: Realtek
> [785962.929956] usb 1-1: SerialNumber: 000000001
> [785962.991755] usbcore: registered new interface driver cdc_ether
> [785963.017068] cdc_ncm 1-1:2.0: MAC-Address: 00:24:27:88:08:15
> [785963.017072] cdc_ncm 1-1:2.0: setting rx_max = 16384
> [785963.017169] cdc_ncm 1-1:2.0: setting tx_max = 16384
> [785963.017682] cdc_ncm 1-1:2.0 usb0: register 'cdc_ncm' at usb-0000:00:14.0-1, CDC NCM, 00:24:27:88:08:15
> [785963.019211] usbcore: registered new interface driver cdc_ncm
> [785963.023856] usbcore: registered new interface driver cdc_wdm
> [785963.025461] usbcore: registered new interface driver cdc_mbim
> [785963.038824] cdc_ncm 1-1:2.0 enx002427880815: renamed from usb0
> [785963.089586] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
> [785963.121673] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
> [785963.153682] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
> ...
> 
> This is about 2KB per second and will overwrite all contents of a 1MB
> dmesg buffer in under 10 minutes rendering them useless for debugging
> many kernel problems.
> 
> This is also an extra 180 MB/day in /var/logs (or 1GB per week) rendering
> the majority of those logs useless too.
> 
> When the link is up (expected state), spew amount is >2x higher:
> ...
> [786139.600992] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
> [786139.632997] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
> [786139.665097] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
> [786139.697100] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
> [786139.729094] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
> [786139.761108] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
> ...
> 
> Chrome OS cannot support RTL8156 until this is fixed.

> @@ -1867,7 +1876,8 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
>  		 * USB_CDC_NOTIFY_NETWORK_CONNECTION notification shall be
>  		 * sent by device after USB_CDC_NOTIFY_SPEED_CHANGE.
>  		 */
> -		usbnet_link_change(dev, !!event->wValue, 0);
> +		if (netif_carrier_ok(dev->net) != !!event->wValue)
> +			usbnet_link_change(dev, !!event->wValue, 0);
>  		break;
>  
>  	case USB_CDC_NOTIFY_SPEED_CHANGE:

Thanks for the patch, this looks like an improvement over:

59b4a8fa27f5 ("CDC-NCM: remove "connected" log message")

right? Should we bring the "network connection: connected" message back?


Do you want all of these patches to be applied to 5.11 and backported?
Feels to me like the last one is a fix and the rest can go into -next,
WDYT?
