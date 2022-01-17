Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2993A490207
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 07:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbiAQGgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 01:36:22 -0500
Received: from marcansoft.com ([212.63.210.85]:51534 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbiAQGgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 01:36:21 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 3D4D73FA5E;
        Mon, 17 Jan 2022 06:36:11 +0000 (UTC)
Subject: Re: [PATCH v2 09/35] brcmfmac: pcie: Perform firmware selection for
 Apple platforms
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-10-marcan@marcan.st>
 <0e169c4e-ce51-3592-f114-46cb3cde1f7d@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <61e21977-656c-86b1-9005-a9c792fa824b@marcan.st>
Date:   Mon, 17 Jan 2022 15:36:09 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0e169c4e-ce51-3592-f114-46cb3cde1f7d@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/01/2022 05.03, Arend van Spriel wrote:
>> The chip revision nominally comes from OTP on Apple platforms, but it
>> can be mapped to the PCI revision number, so we ignore the OTP revision
>> and continue to use the existing PCI revision mechanism to identify chip
>> revisions, as the driver already does for other chips. Unfortunately,
>> the mapping is not consistent between different chip types, so this has
>> to be determined experimentally.
> 
> Not sure I understand this. The chip revision comes from the chipcommon 
> register [1]. Maybe that is what you mean by "PCI revision number". For 
> some chips it is possible OTP is used to override that.

What I mean is the Apple custom OTP segment stores a textual revision
number, like "C0". Apple's driver uses this to pick a firmware. There is
an ad-hoc mapping between this and the numeric revision (which as you
say is present in chipcommon but AFAICT the same number also ends up as
the Revision ID in PCI config space).

> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>   .../broadcom/brcm80211/brcmfmac/pcie.c        | 58 ++++++++++++++++++-
>>   1 file changed, 56 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> index 74c9a4f74813..250e0bd40cb3 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> @@ -2094,8 +2094,62 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
>>   	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
>>   	fwreq->bus_nr = devinfo->pdev->bus->number;
>>   
>> -	brcmf_dbg(PCIE, "Board: %s\n", devinfo->settings->board_type);
>> -	fwreq->board_types[0] = devinfo->settings->board_type;
>> +	/* Apple platforms with fancy firmware/NVRAM selection */
>> +	if (devinfo->settings->board_type &&
>> +	    devinfo->settings->antenna_sku &&
>> +	    devinfo->otp.valid) {
>> +		char *buf;
>> +		int len;
>> +
>> +		brcmf_dbg(PCIE, "Apple board: %s\n",
>> +			  devinfo->settings->board_type);
> 
> maybe good to use local reference for devinfo->settings->board_type, 
> which is used several times below.

Yup, and also antenna_sku.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
