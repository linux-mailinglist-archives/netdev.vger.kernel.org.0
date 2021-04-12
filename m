Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2F135BC01
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 10:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbhDLIXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 04:23:15 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45832 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237091AbhDLIXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 04:23:13 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id D126DE5;
        Mon, 12 Apr 2021 01:22:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com D126DE5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1618215775;
        bh=HJdBJDNgUONeECqTexzrkugjzVR76e6uToFT5Qmyats=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=arrfH05ETUVzgHvXgnMIjDle7PSxIocQoHQw66vyuxvK84vhdHKWPaCkHGXCOINvc
         e2blUERQA1nBfM02P5m0A8t93nHXBprUG0bvCOBktVZg/6LW1kTZ0Zw1WbtrgVCXoD
         h3dta9rT/imQVCF/lceEzulpLLYGy4aW902VyPrQ=
Received: from [10.230.42.155] (unknown [10.230.42.155])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 2B6EF1874BD;
        Mon, 12 Apr 2021 01:22:49 -0700 (PDT)
Subject: Re: [PATCH 2/2] brcmfmac: support parse country code map from DT
To:     Shawn Guo <shawn.guo@linaro.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20210408113022.18180-1-shawn.guo@linaro.org>
 <20210408113022.18180-3-shawn.guo@linaro.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <82182ad8-c728-d313-047c-79478c9ee85f@broadcom.com>
Date:   Mon, 12 Apr 2021 10:22:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210408113022.18180-3-shawn.guo@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08-04-2021 13:30, Shawn Guo wrote:
> With any regulatory domain requests coming from either user space or
> 802.11 IE (Information Element), the country is coded in ISO3166
> standard.  It needs to be translated to firmware country code and
> revision with the mapping info in settings->country_codes table.
> Support populate country_codes table by parsing the mapping from DT.

one more thing though...

> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/of.c | 53 +++++++++++++++++++
>   1 file changed, 53 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index a7554265f95f..ea5c7f434c2c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -12,12 +12,61 @@
>   #include "common.h"
>   #include "of.h"
>   
> +static int brcmf_of_get_country_codes(struct device *dev,
> +				      struct brcmf_mp_device *settings)
> +{

[...]

> +		/* String format e.g. US-Q2-86 */
> +		strncpy(cce->iso3166, map, 2);
> +		strncpy(cce->cc, map + 3, 2);
> +
> +		ret = kstrtos32(map + 6, 10, &cce->rev);
> +		if (ret < 0)
> +			dev_warn(dev, "failed to read rev of map %s: %d",
> +				 cce->iso3166, ret);

Do we need a stronger validation of the string format, eg. use sscanf or 
strstr. Would also be nice to have brcmf_dbg(INFO, ...) here to print 
the entry.

Regards,
Arend
