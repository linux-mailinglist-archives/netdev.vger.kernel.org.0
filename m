Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D14326401D
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbgIJIeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbgIJISq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 04:18:46 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E79C12067C;
        Thu, 10 Sep 2020 08:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599725925;
        bh=SD0dmJJv6vSBrUN7jvV2f2sRRzybcerT3eKetcVqdQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uEINzhZcpaEtvEKwQMgt6n/OBSCCc3nE3T7XkwdRNunnBiXTVTl07NW7DRlLUa5gs
         nOxa12Qm6wVU+JDb4DLdTBa5ho+WxQrShDZ447/Vpjj57UKaonLgIdbVhfd9mkZ+jx
         u/fVgau+DWMn+eg09xHeeP5XLzkgCAX7lK9HwGfQ=
Received: by pali.im (Postfix)
        id 49AEE582; Thu, 10 Sep 2020 10:18:42 +0200 (CEST)
Date:   Thu, 10 Sep 2020 10:18:42 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Joseph Hwang <josephsih@chromium.org>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, chromeos-bluetooth-upstreaming@chromium.org,
        josephsih@google.com, Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Bluetooth: btusb: define HCI packet sizes of USB
 Alts
Message-ID: <20200910081842.yunymr2l4fnle5nl@pali>
References: <20200910060403.144524-1-josephsih@chromium.org>
 <20200910140342.v3.1.I56de28ec171134cb9f97062e2c304a72822ca38b@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910140342.v3.1.I56de28ec171134cb9f97062e2c304a72822ca38b@changeid>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 10 September 2020 14:04:01 Joseph Hwang wrote:
> It is desirable to define the HCI packet payload sizes of
> USB alternate settings so that they can be exposed to user
> space.
> 
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> ---
> 
> Changes in v3:
> - Set hdev->sco_mtu to rp->sco_mtu if the latter is smaller.
> 
> Changes in v2:
> - Used sco_mtu instead of a new sco_pkt_len member in hdev.
> - Do not overwrite hdev->sco_mtu in hci_cc_read_buffer_size
>   if it has been set in the USB interface.
> 
>  drivers/bluetooth/btusb.c | 45 +++++++++++++++++++++++++++++----------
>  net/bluetooth/hci_event.c | 14 +++++++++++-
>  2 files changed, 47 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index fe80588c7bd3a8..651d5731a6c6cf 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -459,6 +459,24 @@ static const struct dmi_system_id btusb_needs_reset_resume_table[] = {
>  #define BTUSB_WAKEUP_DISABLE	14
>  #define BTUSB_USE_ALT1_FOR_WBS	15
>  
> +/* Per core spec 5, vol 4, part B, table 2.1,
> + * list the hci packet payload sizes for various ALT settings.
> + * This is used to set the packet length for the wideband speech.
> + * If a controller does not probe its usb alt setting, the default
> + * value will be 0. Any clients at upper layers should interpret it
> + * as a default value and set a proper packet length accordingly.
> + *
> + * To calculate the HCI packet payload length:
> + *   for alternate settings 1 - 5:
> + *     hci_packet_size = suggested_max_packet_size * 3 (packets) -
> + *                       3 (HCI header octets)
> + *   for alternate setting 6:
> + *     hci_packet_size = suggested_max_packet_size - 3 (HCI header octets)
> + *   where suggested_max_packet_size is {9, 17, 25, 33, 49, 63}
> + *   for alt settings 1 - 6.

Thank you for update, now I see what you mean!

> + */
> +static const int hci_packet_size_usb_alt[] = { 0, 24, 48, 72, 96, 144, 60 };

Now the another question, why you are using hci_packet_size_usb_alt[1]
and hci_packet_size_usb_alt[6] values from this array?

> +
>  struct btusb_data {
>  	struct hci_dev       *hdev;
>  	struct usb_device    *udev;
> @@ -3959,6 +3977,15 @@ static int btusb_probe(struct usb_interface *intf,
>  	hdev->notify = btusb_notify;
>  	hdev->prevent_wake = btusb_prevent_wake;
>  
> +	if (id->driver_info & BTUSB_AMP) {
> +		/* AMP controllers do not support SCO packets */
> +		data->isoc = NULL;
> +	} else {
> +		/* Interface orders are hardcoded in the specification */
> +		data->isoc = usb_ifnum_to_if(data->udev, ifnum_base + 1);
> +		data->isoc_ifnum = ifnum_base + 1;
> +	}
> +
>  #ifdef CONFIG_PM
>  	err = btusb_config_oob_wake(hdev);
>  	if (err)
> @@ -4022,6 +4049,10 @@ static int btusb_probe(struct usb_interface *intf,
>  		hdev->set_diag = btintel_set_diag;
>  		hdev->set_bdaddr = btintel_set_bdaddr;
>  		hdev->cmd_timeout = btusb_intel_cmd_timeout;
> +
> +		if (btusb_find_altsetting(data, 6))
> +			hdev->sco_mtu = hci_packet_size_usb_alt[6];

Why you are setting this sco_mtu only for Intel adapter? Is not this
whole code generic to USB?

> +
>  		set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
>  		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
>  		set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
> @@ -4063,15 +4094,6 @@ static int btusb_probe(struct usb_interface *intf,
>  		btusb_check_needs_reset_resume(intf);
>  	}
>  
> -	if (id->driver_info & BTUSB_AMP) {
> -		/* AMP controllers do not support SCO packets */
> -		data->isoc = NULL;
> -	} else {
> -		/* Interface orders are hardcoded in the specification */
> -		data->isoc = usb_ifnum_to_if(data->udev, ifnum_base + 1);
> -		data->isoc_ifnum = ifnum_base + 1;
> -	}
> -
>  	if (IS_ENABLED(CONFIG_BT_HCIBTUSB_RTL) &&
>  	    (id->driver_info & BTUSB_REALTEK)) {
>  		hdev->setup = btrtl_setup_realtek;
> @@ -4083,9 +4105,10 @@ static int btusb_probe(struct usb_interface *intf,
>  		 * (DEVICE_REMOTE_WAKEUP)
>  		 */
>  		set_bit(BTUSB_WAKEUP_DISABLE, &data->flags);
> -		if (btusb_find_altsetting(data, 1))
> +		if (btusb_find_altsetting(data, 1)) {
>  			set_bit(BTUSB_USE_ALT1_FOR_WBS, &data->flags);
> -		else
> +			hdev->sco_mtu = hci_packet_size_usb_alt[1];

And this part of code which you write is Realtek specific.

I thought that this is something generic to bluetooth usb as you pointed
to bluetooth documentation "core spec 5, vol 4, part B, table 2.1".

> +		} else
>  			bt_dev_err(hdev, "Device does not support ALT setting 1");
>  	}

Also this patch seems to be for me incomplete or not fully correct as
USB altsetting is chosen in function btusb_work() and it depends on
selected AIR mode (which is configured by another setsockopt).

So despite what is written in commit message, this patch looks for me
like some hack for Intel and Realtek bluetooth adapters and does not
solve problems in vendor independent manner.
