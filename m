Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF79482B91
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 15:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbiABOZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 09:25:40 -0500
Received: from marcansoft.com ([212.63.210.85]:53004 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229760AbiABOZk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jan 2022 09:25:40 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 70505425C1;
        Sun,  2 Jan 2022 14:25:29 +0000 (UTC)
Message-ID: <f35bed9b-aefd-cdf1-500f-194d5699cffd@marcan.st>
Date:   Sun, 2 Jan 2022 23:25:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
 paths
Content-Language: en-US
To:     Dmitry Osipenko <digetx@gmail.com>,
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
        Wright Feng <wright.feng@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-4-marcan@marcan.st>
 <c79d67af-2d4c-2c9d-bb7d-630faf9de175@gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <c79d67af-2d4c-2c9d-bb7d-630faf9de175@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/02 16:08, Dmitry Osipenko wrote:
> 26.12.2021 18:35, Hector Martin пишет:
>> +static void brcm_free_alt_fw_paths(const char **alt_paths)
>> +{
>> +	int i;
>> +
>> +	if (!alt_paths)
>> +		return;
>> +
>> +	for (i = 0; alt_paths[i]; i++)
>> +		kfree(alt_paths[i]);
>> +
>> +	kfree(alt_paths);
>>  }
>>  
>>  static int brcmf_fw_request_firmware(const struct firmware **fw,
>>  				     struct brcmf_fw *fwctx)
>>  {
>>  	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
>> -	int ret;
>> +	int ret, i;
>>  
>>  	/* Files can be board-specific, first try a board-specific path */
>>  	if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
>> -		char *alt_path;
>> +		const char **alt_paths = brcm_alt_fw_paths(cur->path, fwctx);
>>  
>> -		alt_path = brcm_alt_fw_path(cur->path, fwctx->req->board_type);
>> -		if (!alt_path)
>> +		if (!alt_paths)
>>  			goto fallback;
>>  
>> -		ret = request_firmware(fw, alt_path, fwctx->dev);
>> -		kfree(alt_path);
>> -		if (ret == 0)
>> -			return ret;
>> +		for (i = 0; alt_paths[i]; i++) {
>> +			ret = firmware_request_nowarn(fw, alt_paths[i], fwctx->dev);
>> +			if (ret == 0) {
>> +				brcm_free_alt_fw_paths(alt_paths);
>> +				return ret;
>> +			}
>> +		}
>> +		brcm_free_alt_fw_paths(alt_paths);
>>  	}
>>  
>>  fallback:
>> @@ -641,6 +663,9 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
>>  	struct brcmf_fw *fwctx = ctx;
>>  	int ret;
>>  
>> +	brcm_free_alt_fw_paths(fwctx->alt_paths);
>> +	fwctx->alt_paths = NULL;
> 
> It looks suspicious that fwctx->alt_paths isn't zero'ed by other code
> paths. The brcm_free_alt_fw_paths() should take fwctx for the argument
> and fwctx->alt_paths should be set to NULL there.

There are multiple code paths for alt_paths; the initial firmware lookup
uses fwctx->alt_paths, and once we know the firmware load succeeded we
use blocking firmware requests for NVRAM/CLM/etc and those do not use
the fwctx member, but rather just keep alt_paths in function scope
(brcmf_fw_request_firmware). You're right that there was a rebase SNAFU
there though, I'll compile test each patch before sending v2. Sorry
about that. In this series the code should build again by patch #6.

Are you thinking of any particular code paths? As far as I saw when
writing this, brcmf_fw_request_done() should always get called whether
things succeed or fail. There are no other code paths that free
fwctx->alt_paths.

> On the other hand, I'd change the **alt_paths to a fixed-size array.
> This should simplify the code, making it easier to follow and maintain.
> 
> -	const char **alt_paths;
> +	char *alt_paths[BRCM_MAX_ALT_FW_PATHS];
> 
> Then you also won't need to NULL-terminate the array, which is a common
> source of bugs in kernel.

That sounds reasonable, it'll certainly make the code simpler. I'll do
that for v2.


-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
