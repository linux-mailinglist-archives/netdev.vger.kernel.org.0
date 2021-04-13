Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3C835D9AD
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbhDMIKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 04:10:33 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:47654 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhDMIKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 04:10:30 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 81B1FEA;
        Tue, 13 Apr 2021 01:10:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 81B1FEA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1618301410;
        bh=uCji7ZHwBsHQai89pTi9GBVvZ1MCQ70Q2BC0rXU52jM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gTaLiZWymu31q+wirurSln9KiNUVBFpz0wHI5STJwq15q9y4niPHEeboFkcjC3FiA
         2+txDYEv3BWOCb+yDsuR1z6DJLvHJnO1qITVdZo5J7QfD4MOll5gzx5yBl2CzYnMnm
         ijjpk/mUwKmma5vZJbVwu6lHXmyNrSXtKTnZe1/0=
Received: from [10.230.42.155] (unknown [10.230.42.155])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 45A4D1874BD;
        Tue, 13 Apr 2021 01:10:04 -0700 (PDT)
Subject: Re: [PATCH 2/2] brcmfmac: support parse country code map from DT
To:     Shawn Guo <shawn.guo@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
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
 <b2e07b41-a83e-5b5d-be1d-7a3e8493abd6@broadcom.com>
 <20210413074509.GD15093@dragon>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5c3f2328-87bc-3103-70bd-d7add0bf464f@broadcom.com>
Date:   Tue, 13 Apr 2021 10:10:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210413074509.GD15093@dragon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13-04-2021 09:45, Shawn Guo wrote:
> On Mon, Apr 12, 2021 at 10:09:38AM +0200, Arend van Spriel wrote:
>> On 08-04-2021 13:30, Shawn Guo wrote:
>>> With any regulatory domain requests coming from either user space or
>>> 802.11 IE (Information Element), the country is coded in ISO3166
>>> standard.  It needs to be translated to firmware country code and
>>> revision with the mapping info in settings->country_codes table.
>>> Support populate country_codes table by parsing the mapping from DT.
>>
>> comment below, but you may add...
>>
>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> Thanks for reviewing, Arend.
> 
>>> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>>> ---
>>>    .../wireless/broadcom/brcm80211/brcmfmac/of.c | 53 +++++++++++++++++++
>>>    1 file changed, 53 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
>>> index a7554265f95f..ea5c7f434c2c 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
>>
>> [...]
>>
>>> @@ -47,6 +96,10 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>>>    	    !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
>>>    		return;
>>> +	ret = brcmf_of_get_country_codes(dev, settings);
>>> +	if (ret)
>>> +		dev_warn(dev, "failed to get OF country code map\n");
>>
>> First of all I prefer to use brcmf_err and add ret value to the print
>> message " (err=%d)\n".
> 
> Okay.
> 
>> Another thing is that this mapping is not only
>> applicable for SDIO devices so you may consider doing this for other bus
>> types as well which requires a bit more rework here.
> 
> Right. I will take care of it, if we can convince Kalle that having
> this data in DT is not such a bad idea.

Sure. So let me explain a bit how our internal regulatory data is 
organized. The country revision is needed because the rf parameters that 
provide regulatory compliance are tweaked per platform/customer so 
depending on the rf path tight to the chip we need to use a certain 
country revision. As such they could be seen as device specific 
calibration data which is something that is already supported in the 
devicetree bindings.

Regards,
Arend
