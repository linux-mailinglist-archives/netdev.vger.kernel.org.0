Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F026482B86
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 15:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiABOSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 09:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiABOSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 09:18:16 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD8FC061761;
        Sun,  2 Jan 2022 06:18:16 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 6262D425C1;
        Sun,  2 Jan 2022 14:18:06 +0000 (UTC)
Message-ID: <e9ecbd0b-8741-1e7d-ae7a-f839287cb5c9@marcan.st>
Date:   Sun, 2 Jan 2022 23:18:04 +0900
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
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-4-marcan@marcan.st>
 <8e99eb47-2bc1-7899-5829-96f2a515b2cb@gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <8e99eb47-2bc1-7899-5829-96f2a515b2cb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/02 15:45, Dmitry Osipenko wrote:
> 26.12.2021 18:35, Hector Martin пишет:
>> -static char *brcm_alt_fw_path(const char *path, const char *board_type)
>> +static const char **brcm_alt_fw_paths(const char *path, const char *board_type)
>>  {
>>  	char alt_path[BRCMF_FW_NAME_LEN];
>> +	char **alt_paths;
>>  	char suffix[5];
>>  
>>  	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
>> @@ -609,27 +612,46 @@ static char *brcm_alt_fw_path(const char *path, const char *board_type)
>>  	strlcat(alt_path, board_type, BRCMF_FW_NAME_LEN);
>>  	strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
>>  
>> -	return kstrdup(alt_path, GFP_KERNEL);
>> +	alt_paths = kzalloc(sizeof(char *) * 2, GFP_KERNEL);
> 
> array_size()?

Of what array?

> 
>> +	alt_paths[0] = kstrdup(alt_path, GFP_KERNEL);
>> +
>> +	return (const char **)alt_paths;
> 
> Why this casting is needed?

Because implicit conversion from char ** to const char ** is not legal
in C, as that could cause const unsoundness if you do this:

char *foo[1];
const char **bar = foo;

bar[0] = "constant string";
foo[0][0] = '!'; // clobbers constant string

But it's fine in this case since the non-const pointer disappears so
nothing can ever write through it again.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
