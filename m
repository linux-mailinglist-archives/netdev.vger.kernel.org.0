Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5081848452E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiADPtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:49:07 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:52038 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiADPtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:49:06 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jan 2022 10:49:06 EST
Received: from [IPV6:2003:e9:d728:ec47:4b31:73e4:34c5:505a] (p200300e9d728ec474b3173e434c5505a.dip0.t-ipconnect.de [IPv6:2003:e9:d728:ec47:4b31:73e4:34c5:505a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 120EAC055C;
        Tue,  4 Jan 2022 16:40:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1641310843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fzrSYWdpug8dV2D+vjEBY0DdwVSV7UgruGe2VxZhMYQ=;
        b=wMtj+/+SQEzNvk7geCsi6F8u7AI0xwhhl98uuCWCZNgKfj6mugjmItNNOXweG1ESnJYKvv
        1Xjpl9tjKW0IPX9xK5g/1C+TQM9blc0CxuUUqyhC5Q6G6OcW0s1Pt0Mj2WygkrGqz18Twk
        H6OdYiPDZQTLzBd1Bq7ZVEP2gNpb5eexDji955LofwwI3j35/HloYjyUnoFaq7OgYSSCs6
        ciYVNffIlOiuWFPj44xtDZIrE4LUBH/UyYTfUWZUPy2vmE9UESYZobGM0B6fgai+/TGGWs
        JuR7TOHx22BlMHDf5G9fYwVGwNv+MvKy5CwqK6dsTsxFvhwkROqtxqRBBVwBpA==
Message-ID: <ed39cbe6-0885-a3ab-fc30-7c292e1acc53@datenfreihafen.org>
Date:   Tue, 4 Jan 2022 16:40:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2] ieee802154: atusb: fix uninit value in
 atusb_set_extended_addr
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Potapenko <glider@google.com>
References: <CAB_54W50xKFCWZ5vYuDG2p4ijpd63cSutRrV4MLs9oasLmKgzQ@mail.gmail.com>
 <20220103120925.25207-1-paskripkin@gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220103120925.25207-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 03.01.22 13:09, Pavel Skripkin wrote:
> Alexander reported a use of uninitialized value in
> atusb_set_extended_addr(), that is caused by reading 0 bytes via
> usb_control_msg().
> 
> Fix it by validating if the number of bytes transferred is actually
> correct, since usb_control_msg() may read less bytes, than was requested
> by caller.
> 
> Fail log:
> 
> BUG: KASAN: uninit-cmp in ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
> BUG: KASAN: uninit-cmp in atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
> BUG: KASAN: uninit-cmp in atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
> Uninit value used in comparison: 311daa649a2003bd stack handle: 000000009a2003bd
>   ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
>   atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
>   atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
>   usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396
> 
> Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Changes in v2:
> 	- Reworked fix approach, since moving to new USB API is not
> 	  suitable for backporting to stable kernels
> 
> ---
>   drivers/net/ieee802154/atusb.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> index 23ee0b14cbfa..e6cc816dd7a1 100644
> --- a/drivers/net/ieee802154/atusb.c
> +++ b/drivers/net/ieee802154/atusb.c
> @@ -93,7 +93,9 @@ static int atusb_control_msg(struct atusb *atusb, unsigned int pipe,
>   
>   	ret = usb_control_msg(usb_dev, pipe, request, requesttype,
>   			      value, index, data, size, timeout);
> -	if (ret < 0) {
> +	if (ret < size) {
> +		ret = ret < 0 ? ret : -ENODATA;
> +
>   		atusb->err = ret;
>   		dev_err(&usb_dev->dev,
>   			"%s: req 0x%02x val 0x%x idx 0x%x, error %d\n",
> 

It compiles, but does not work on the real hardware.

[    1.114698] usb 1-1: new full-speed USB device number 2 using uhci_hcd
[    1.261691] usb 1-1: New USB device found, idVendor=20b7, 
idProduct=1540, bcdDevice= 0.01
[    1.263421] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=1
[    1.264952] usb 1-1: SerialNumber: 4630333438371502231a
[    1.278042] usb 1-1: ATUSB: AT86RF231 version 2
[    1.281087] usb 1-1: Firmware: major: 0, minor: 3, hardware type: 
ATUSB (2)
[    1.285191] usb 1-1: atusb_control_msg: req 0x01 val 0x0 idx 0x0, 
error -61
[    1.286903] usb 1-1: failed to fetch extended address, random address set
[    1.288757] usb 1-1: atusb_probe: initialization failed, error = -61
[    1.290922] atusb: probe of 1-1:1.0 failed with error -61


Without your patch it works as expected:

[    1.091925] usb 1-1: new full-speed USB device number 2 using uhci_hcd
[    1.237743] usb 1-1: New USB device found, idVendor=20b7, 
idProduct=1540, bcdDevice= 0.01
[    1.239788] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=1
[    1.241432] usb 1-1: SerialNumber: 4630333438371502231a
[    1.255012] usb 1-1: ATUSB: AT86RF231 version 2
[    1.258073] usb 1-1: Firmware: major: 0, minor: 3, hardware type: 
ATUSB (2)
[    1.262170] usb 1-1: Firmware: build #132 Mo 28. Nov 16:20:35 CET 2016
[    1.266195] usb 1-1: Read permanent extended address 
10:e2:d5:ff:ff:00:02:e8 from device

regards
Stefan Schmidt

