Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272134A4C16
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380442AbiAaQ3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:29:14 -0500
Received: from marcansoft.com ([212.63.210.85]:40322 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380381AbiAaQ3J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 11:29:09 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 4DC93419BC;
        Mon, 31 Jan 2022 16:28:59 +0000 (UTC)
Subject: Re: [PATCH v2 33/35] brcmfmac: common: Add support for downloading
 TxCap blobs
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
 <20220104072658.69756-34-marcan@marcan.st>
 <45d5d6c1-f03f-d7ff-3d03-70bc45a36bfd@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <ff2232c8-fdf2-0a34-783b-5a5c8596f272@marcan.st>
Date:   Tue, 1 Feb 2022 01:28:57 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <45d5d6c1-f03f-d7ff-3d03-70bc45a36bfd@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/01/2022 16.36, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> The TxCap blobs are additional data blobs used on Apple devices, and
>> are uploaded analogously to CLM blobs. Add core support for doing this.
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>   .../broadcom/brcm80211/brcmfmac/bus.h         |  1 +
>>   .../broadcom/brcm80211/brcmfmac/common.c      | 97 +++++++++++++------
>>   2 files changed, 71 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
>> index b13af8f631f3..f4bd98da9761 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
>> @@ -39,6 +39,7 @@ enum brcmf_bus_protocol_type {
>>   /* Firmware blobs that may be available */
>>   enum brcmf_blob_type {
>>   	BRCMF_BLOB_CLM,
>> +	BRCMF_BLOB_TXCAP,
>>   };
>>   
>>   struct brcmf_mp_device;
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> index c84c48e49fde..d65308c3f070 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> 
> [...]
> 
>> @@ -165,20 +157,64 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
>>   	} while ((datalen > 0) && (err == 0));
>>   
> 
> [...]
> 
>> +static int brcmf_c_process_txcap_blob(struct brcmf_if *ifp)
>> +{
>> +	struct brcmf_pub *drvr = ifp->drvr;
>> +	struct brcmf_bus *bus = drvr->bus_if;
>> +	const struct firmware *fw = NULL;
>> +	s32 err;
>> +
>> +	brcmf_dbg(TRACE, "Enter\n");
>> +
>> +	err = brcmf_bus_get_blob(bus, &fw, BRCMF_BLOB_TXCAP);
>> +	if (err || !fw) {
>> +		brcmf_info("no txcap_blob available (err=%d)\n", err);
>> +		return 0;
>> +	}
>> +
>> +	brcmf_info("TxCap blob found, loading\n");
>> +	err = brcmf_c_download_blob(ifp, fw->data, fw->size,
>> +				    "txcapload", "txcapload_status");
> 
> Although unlikely that we end up here with a firmware that does not 
> support this command it is not impossible. Should we handle that here or 
> introduce a feature flag for txcap loading?

Hmm, like trying to read txcapload_status to set the feature flag?

Honestly though, if we end up here on an unsupported firmware that
sounds like a firmware loading error, since if we have a TxCap blob for
a given board we better have a firmware that supports it. So it doesn't
feel too wrong to just error out entirely so the user knows something is
horribly wrong, instead of trying to use what is probably the wrong
firmware.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
