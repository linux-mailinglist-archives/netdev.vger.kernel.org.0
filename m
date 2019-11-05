Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02453EF797
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbfKEI4P convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Nov 2019 03:56:15 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38547 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729765AbfKEI4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:56:15 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xA58tnut001916, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xA58tnut001916
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 5 Nov 2019 16:55:50 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Tue, 5 Nov
 2019 16:55:49 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "oliver@neukum.org" <oliver@neukum.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] r8152: Add macpassthru support for ThinkPad Thunderbolt 3 Dock Gen 2
Thread-Topic: [PATCH v2] r8152: Add macpassthru support for ThinkPad
 Thunderbolt 3 Dock Gen 2
Thread-Index: AQHVk7E2UAb+vVEL20O/iFfFubpdn6d8PDnA
Date:   Tue, 5 Nov 2019 08:55:49 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18F4E9E@RTITMBSVM03.realtek.com.tw>
References: <20191105081526.4206-1-kai.heng.feng@canonical.com>
In-Reply-To: <20191105081526.4206-1-kai.heng.feng@canonical.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng [mailto:kai.heng.feng@canonical.com]
> Sent: Tuesday, November 05, 2019 4:15 PM
> To: davem@davemloft.net; oliver@neukum.org
[...]
> +	if (test_bit(LENOVO_MACPASSTHRU, &tp->flags)) {
> +		bypass_test = true;
> +		mac_obj_name = "\\MACA";
> +		mac_obj_type = ACPI_TYPE_STRING;
> +		mac_strlen = 0x16;
>  	} else {
> -		/* test for RTL8153-BND and RTL8153-BD */
> -		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
> -		if ((ocp_data & BND_MASK) == 0 && (ocp_data & BD_MASK) == 0) {
> -			netif_dbg(tp, probe, tp->netdev,
> -				  "Invalid variant for MAC pass through\n");
> -			return -ENODEV;
> +		bypass_test = false;
> +		mac_obj_name = "\\_SB.AMAC";
> +		mac_obj_type = ACPI_TYPE_BUFFER;
> +		mac_strlen = 0x17;
> +	}
> +
> +	if (!bypass_test) {

Maybe you could combine this with the "else" above.
Then, the variable "bypass_test" could be removed.
And the declaration of "ocp_data" could be moved after the "else".

> +		/* test for -AD variant of RTL8153 */
> +		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
> +		if ((ocp_data & AD_MASK) == 0x1000) {
> +			/* test for MAC address pass-through bit */
> +			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, EFUSE);
> +			if ((ocp_data & PASS_THRU_MASK) != 1) {
> +				netif_dbg(tp, probe, tp->netdev,
> +						"No efuse for RTL8153-AD MAC pass
> through\n");
> +				return -ENODEV;
> +			}
> +		} else {
> +			/* test for RTL8153-BND and RTL8153-BD */
> +			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
> +			if ((ocp_data & BND_MASK) == 0 && (ocp_data & BD_MASK)
> == 0) {
> +				netif_dbg(tp, probe, tp->netdev,
> +						"Invalid variant for MAC pass through\n");
> +				return -ENODEV;
> +			}
>  		}
>  	}
> 
>  	/* returns _AUXMAC_#AABBCCDDEEFF# */
> -	status = acpi_evaluate_object(NULL, "\\_SB.AMAC", NULL, &buffer);
> +	status = acpi_evaluate_object(NULL, mac_obj_name, NULL, &buffer);
>  	obj = (union acpi_object *)buffer.pointer;
>  	if (!ACPI_SUCCESS(status))
>  		return -ENODEV;
> -	if (obj->type != ACPI_TYPE_BUFFER || obj->string.length != 0x17) {
> +	if (obj->type != mac_obj_type || obj->string.length != mac_strlen) {
>  		netif_warn(tp, probe, tp->netdev,
>  			   "Invalid buffer for pass-thru MAC addr: (%d, %d)\n",
>  			   obj->type, obj->string.length);
>  		goto amacout;
>  	}
> +
>  	if (strncmp(obj->string.pointer, "_AUXMAC_#", 9) != 0 ||
>  	    strncmp(obj->string.pointer + 0x15, "#", 1) != 0) {
>  		netif_warn(tp, probe, tp->netdev,
> @@ -6629,6 +6649,10 @@ static int rtl8152_probe(struct usb_interface *intf,
>  		netdev->hw_features &= ~NETIF_F_RXCSUM;
>  	}
> 
> +	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO &&
> +	    le16_to_cpu(udev->descriptor.idProduct) == 0x3082)
> +		set_bit(LENOVO_MACPASSTHRU, &tp->flags);
> +
>  	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial
> &&
>  	    (!strcmp(udev->serial, "000001000000") ||
>  	     !strcmp(udev->serial, "000002000000"))) {
> @@ -6755,6 +6779,7 @@ static const struct usb_device_id rtl8152_table[] = {
>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f)},
>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062)},
>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069)},
> +	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082)},
>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c)},
>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214)},
> --
> 2.17.1


Best Regards,
Hayes


