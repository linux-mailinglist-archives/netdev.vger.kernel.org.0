Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D0F49E03F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239995AbiA0LIU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Jan 2022 06:08:20 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40596 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbiA0LIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:08:18 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20RB7kJU2003652, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20RB7kJU2003652
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Jan 2022 19:07:46 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 19:07:46 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 03:07:46 -0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Thu, 27 Jan 2022 19:07:46 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Aaron Ma <aaron.ma@canonical.com>,
        "Mario.Limonciello@amd.com" <Mario.Limonciello@amd.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: RE: [PATCH] net: usb: r8152: Add MAC passthrough support for RTL8153BL
Thread-Topic: [PATCH] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Thread-Index: AQHYE2TZXHAE8lX/mkKmF3IMrnZ/+Kx2sI0Q
Date:   Thu, 27 Jan 2022 11:07:46 +0000
Message-ID: <35834c36763b4c24a9f1ab8a292732b5@realtek.com>
References: <20220127100109.12979-1-aaron.ma@canonical.com>
In-Reply-To: <20220127100109.12979-1-aaron.ma@canonical.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/1/27_=3F=3F_08:15:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aaron Ma <aaron.ma@canonical.com>
> Sent: Thursday, January 27, 2022 6:01 PM
[...]
> @@ -1606,31 +1607,34 @@ static int vendor_mac_passthru_addr_read(struct
> r8152 *tp, struct sockaddr *sa)
>  	acpi_object_type mac_obj_type;
>  	int mac_strlen;
> 
> +	/* test for -AD variant of RTL8153 */
> +	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
> +	if ((ocp_data & AD_MASK) == 0x1000) {
> +		/* test for MAC address pass-through bit */
> +		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, EFUSE);
> +		if ((ocp_data & PASS_THRU_MASK) != 1) {
> +			netif_dbg(tp, probe, tp->netdev,
> +					"No efuse for RTL8153-AD MAC pass through\n");
> +			return -ENODEV;
> +		}
> +	} else {
> +		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
> +		if (tp->version == RTL_VER_09 && (ocp_data & BL_MASK)) {
> +			/* test for RTL8153BL for Lenovo */
> +			tp->lenovo_macpassthru = 1;
> +		} else if ((ocp_data & BND_MASK) == 0 && (ocp_data & BD_MASK)
> == 0) {
> +			/* test for RTL8153-BND and RTL8153-BD */
> +			netif_dbg(tp, probe, tp->netdev,
> +					"Invalid variant for MAC pass through\n");
> +			return -ENODEV;

I think the devices with the VID/PID of Lenovo, such as 0x17EF/0x3082 and 0x17EF/0xA387,
would always return -ENODEV here. Is it what you want?


Best Regards,
Hayes


> +		}
> +	}
> +
>  	if (tp->lenovo_macpassthru) {
>  		mac_obj_name = "\\MACA";
>  		mac_obj_type = ACPI_TYPE_STRING;
>  		mac_strlen = 0x16;
>  	} else {
> -		/* test for -AD variant of RTL8153 */
> -		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
> -		if ((ocp_data & AD_MASK) == 0x1000) {
> -			/* test for MAC address pass-through bit */
> -			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, EFUSE);
> -			if ((ocp_data & PASS_THRU_MASK) != 1) {
> -				netif_dbg(tp, probe, tp->netdev,
> -						"No efuse for RTL8153-AD MAC pass through\n");
> -				return -ENODEV;
> -			}
> -		} else {
> -			/* test for RTL8153-BND and RTL8153-BD */
> -			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
> -			if ((ocp_data & BND_MASK) == 0 && (ocp_data & BD_MASK)
> == 0) {
> -				netif_dbg(tp, probe, tp->netdev,
> -						"Invalid variant for MAC pass through\n");
> -				return -ENODEV;
> -			}
> -		}
> -
>  		mac_obj_name = "\\_SB.AMAC";
>  		mac_obj_type = ACPI_TYPE_BUFFER;
>  		mac_strlen = 0x17;
> --
> 2.32.0

