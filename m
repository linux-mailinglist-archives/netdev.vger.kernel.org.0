Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E7836D6F0
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 14:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhD1MD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 08:03:57 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33132 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229645AbhD1MD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 08:03:57 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 1F0217A21;
        Wed, 28 Apr 2021 05:03:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 1F0217A21
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1619611392;
        bh=sqPprGDrxRqE813qXyK+XiwtTWISQ3rJhLBDakpzkSk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HRpYGSHCqxNp7Nx007mpVQ8NfSTtGYjv/vdVYC/fGnrWPKwOyhEO4+4TvrFjgg02x
         Uw091ENOQIZ5OByL3iWK6KvsF6DOfviY4otN6rI+2S958oYysaO2ymUaOmhr1cLnFQ
         qt+PRh/HT81IpC2c0u6ny0tnwIe2Xeqfor3grLhM=
Received: from [10.230.32.233] (unknown [10.230.32.233])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 9EDBB1874BE;
        Wed, 28 Apr 2021 05:03:09 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: use ISO3166 country code and 0 rev as fallback
To:     Shawn Guo <shawn.guo@linaro.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20210425110200.3050-1-shawn.guo@linaro.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b6c5713f-ebf0-9eaf-e871-d5690a6b7c10@broadcom.com>
Date:   Wed, 28 Apr 2021 14:03:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210425110200.3050-1-shawn.guo@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/2021 1:02 PM, Shawn Guo wrote:
> Instead of aborting country code setup in firmware, use ISO3166 country
> code and 0 rev as fallback, when country_codes mapping table is not
> configured.  This fallback saves the country_codes table setup for recent
> brcmfmac chipsets/firmwares, which just use ISO3166 code and require no
> revision number.

I am somewhat surprised, but with the brcm-spinoffs (cypress/infineon 
and synaptics) my understanding may have been surpassed by reality. 
Would you happen to know which chipsets/firmwares require only ISO3166 
code and no rev?

Regards,
Arend
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>   .../broadcom/brcm80211/brcmfmac/cfg80211.c      | 17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index f4405d7861b6..6cb09c7c37b6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -7442,18 +7442,23 @@ static s32 brcmf_translate_country_code(struct brcmf_pub *drvr, char alpha2[2],
>   	s32 found_index;
>   	int i;
>   
> -	country_codes = drvr->settings->country_codes;
> -	if (!country_codes) {
> -		brcmf_dbg(TRACE, "No country codes configured for device\n");
> -		return -EINVAL;
> -	}
> -
>   	if ((alpha2[0] == ccreq->country_abbrev[0]) &&
>   	    (alpha2[1] == ccreq->country_abbrev[1])) {
>   		brcmf_dbg(TRACE, "Country code already set\n");
>   		return -EAGAIN;
>   	}
>   
> +	country_codes = drvr->settings->country_codes;
> +	if (!country_codes) {
> +		brcmf_dbg(TRACE, "No country codes configured for device, using ISO3166 code and 0 rev\n");
> +		memset(ccreq, 0, sizeof(*ccreq));
> +		ccreq->country_abbrev[0] = alpha2[0];
> +		ccreq->country_abbrev[1] = alpha2[1];
> +		ccreq->ccode[0] = alpha2[0];
> +		ccreq->ccode[1] = alpha2[1];
> +		return 0;
> +	}
> +
>   	found_index = -1;
>   	for (i = 0; i < country_codes->table_size; i++) {
>   		cc = &country_codes->table[i];
> 
