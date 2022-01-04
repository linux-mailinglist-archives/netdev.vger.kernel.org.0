Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E1D483E68
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiADIoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:44:09 -0500
Received: from marcansoft.com ([212.63.210.85]:37428 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232830AbiADIoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 03:44:06 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 2FC5841F5D;
        Tue,  4 Jan 2022 08:43:54 +0000 (UTC)
Message-ID: <7c8d5655-a041-e291-95c1-be200233f87f@marcan.st>
Date:   Tue, 4 Jan 2022 17:43:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 04/35] brcmfmac: firmware: Support having multiple alt
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
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-5-marcan@marcan.st>
 <5ddde705-f3fa-ff78-4d43-7a02d6efaaa6@gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <5ddde705-f3fa-ff78-4d43-7a02d6efaaa6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/04 17:26, Dmitry Osipenko wrote:
> 04.01.2022 10:26, Hector Martin пишет:
>> Apple platforms have firmware and config files identified with multiple
>> dimensions. We want to be able to find the most specific firmware
>> available for any given platform, progressively trying more general
>> firmwares.
>>
>> First, add support for having multiple alternate firmware paths.
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>  .../broadcom/brcm80211/brcmfmac/firmware.c    | 75 ++++++++++++++-----
>>  .../broadcom/brcm80211/brcmfmac/firmware.h    |  2 +
>>  2 files changed, 59 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>> index 0497b721136a..7570dbf22cdd 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>> @@ -427,6 +427,8 @@ void brcmf_fw_nvram_free(void *nvram)
>>  struct brcmf_fw {
>>  	struct device *dev;
>>  	struct brcmf_fw_request *req;
>> +	const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS];
>> +	int alt_index;
> 
> unsigned int

Ack.

> 
>>  	u32 curpos;
>>  	void (*done)(struct device *dev, int err, struct brcmf_fw_request *req);
>>  };
>> @@ -592,14 +594,18 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
>>  	return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
>>  }
>>  
>> -static char *brcm_alt_fw_path(const char *path, const char *board_type)
>> +static int brcm_alt_fw_paths(const char *path, const char *board_type,
>> +			     const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])>  {
>>  	char alt_path[BRCMF_FW_NAME_LEN];
>>  	const char *suffix;
>>  
>> +	memset(alt_paths, 0, array_size(sizeof(*alt_paths),
>> +					BRCMF_FW_MAX_ALT_PATHS));
> You don't need to use array_size() since size of a fixed array is
> already known.
> 
> memset(alt_paths, 0, sizeof(alt_paths));

It's a function argument, so that doesn't work and actually throws a
warning. Array function argument notation is informative only; they
behave strictly equivalent to pointers. Try it:

$ cat test.c
#include <stdio.h>

void foo(char x[42])
{
	printf("%ld\n", sizeof(x));
}

int main() {
	char x[42];

	foo(x);
}
$ gcc test.c
test.c: In function ‘foo’:
test.c:5:31: warning: ‘sizeof’ on array function parameter ‘x’ will
return size of ‘char *’ [-Wsizeof-array-argument]
    5 |         printf("%ld\n", sizeof(x));
      |                               ^
test.c:3:15: note: declared here
    3 | void foo(char x[42])
      |          ~~~~~^~~~~
$ ./a.out
8


> 
> ...
>> +static void
>> +brcm_free_alt_fw_paths(const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; alt_paths[i]; i++)
> 
> What if array is fully populated and there is no null in the end? Please
> don't do this, use BRCMF_FW_MAX_ALT_PATHS or ARRAY_SIZE().

Argh, forgot to change this one. I used BRCMF_FW_MAX_ALT_PATHS
elsewhere; ARRAY_SIZE won't work as I explained above.

> 
>> +		kfree(alt_paths[i]);
>>  }
>>  
>>  static int brcmf_fw_request_firmware(const struct firmware **fw,
>> @@ -617,19 +634,25 @@ static int brcmf_fw_request_firmware(const struct firmware **fw,
>>  {
>>  	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
>>  	int ret;
>> +	unsigned int i;
> 
> Keep reverse Xmas tree coding style.

First time I hear this one, heh. Sure.

> 
> ...
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
>> @@ -11,6 +11,8 @@
>>  
>>  #define BRCMF_FW_DEFAULT_PATH		"brcm/"
>>  
>> +#define BRCMF_FW_MAX_ALT_PATHS	8
> 
> Two tabs are needed here.

Will do.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
