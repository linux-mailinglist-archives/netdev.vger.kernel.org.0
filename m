Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A52C49CAFC
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbiAZNiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240383AbiAZNiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:38:06 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF70FC061755;
        Wed, 26 Jan 2022 05:38:05 -0800 (PST)
Received: from [IPV6:2003:e9:d72b:2eaa:447d:e748:10d2:36ed] (p200300e9d72b2eaa447de74810d236ed.dip0.t-ipconnect.de [IPv6:2003:e9:d72b:2eaa:447d:e748:10d2:36ed])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id A9EE3C038E;
        Wed, 26 Jan 2022 14:38:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643204282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wbNKPmgJEiNFOnTRv+PLwEdswWmhQgNJusEBa/wyE0M=;
        b=pd+V5CoQurY2v68KBDCVsqSOuMIwbwyBMVrgM+N+Cqgi35vCJoKo81V2j/dc1Suto6u/Pt
        0yJXd348d3eVCG3ff5aXymhYMeEizfjTejLbmGe6FFXmjbTjsOCbplur3v5r26zbl3rz3U
        IUTkoS1IGVW9BP//i4BDyCFRiWgFlWybBtbxPHogDIXR7j1LB1HCrET0LKcGqVbcM4btQK
        8nNe3MXXMZkXGa6epQ6j4aU1aJGe4dFMMFyW7qlWKJ2yNP49iCdweB/ACfdEhXApgD5vAH
        fbXajcknO3dMWVUoaYIfYlhKd6nmW9FCeGjLp6NmMwHXlllqIdLRBfLRciDbfg==
Message-ID: <89726c29-bf7d-eaf1-2af0-da1914741bec@datenfreihafen.org>
Date:   Wed, 26 Jan 2022 14:38:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan v3 1/6] net: ieee802154: hwsim: Ensure proper channel
 selection at probe time
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220125121426.848337-1-miquel.raynal@bootlin.com>
 <20220125121426.848337-2-miquel.raynal@bootlin.com>
 <d3cab1bb-184d-73f9-7bd8-8eefc5e7e70c@datenfreihafen.org>
 <20220125174849.31501317@xps13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220125174849.31501317@xps13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 25.01.22 17:48, Miquel Raynal wrote:
> Hi Stefan,
> 
> stefan@datenfreihafen.org wrote on Tue, 25 Jan 2022 15:28:11 +0100:
> 
>> Hello.
>>
>> On 25.01.22 13:14, Miquel Raynal wrote:
>>> Drivers are expected to set the PHY current_channel and current_page
>>> according to their default state. The hwsim driver is advertising being
>>> configured on channel 13 by default but that is not reflected in its own
>>> internal pib structure. In order to ensure that this driver consider the
>>> current channel as being 13 internally, we at least need to set the
>>> pib->channel field to 13.
>>>
>>> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
>>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>>> ---
>>>    drivers/net/ieee802154/mac802154_hwsim.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
>>> index 8caa61ec718f..00ec188a3257 100644
>>> --- a/drivers/net/ieee802154/mac802154_hwsim.c
>>> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
>>> @@ -786,6 +786,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
>>>    		goto err_pib;
>>>    	}
>>>    > +	pib->page = 13;
>>
>> You want to set channel not page here.
> 
> Oh crap /o\ I've messed that update badly. Of course I meant
> pib->channel here, as it is in the commit log.
> 
> I'll wait for Alexander's feedback before re-spinning. Unless the rest
> looks good for you both, I don't know if your policy allows you to fix
> it when applying, anyhow I'll do what is necessary.

If Alex has nothing else and there is no re-spin I fix this when 
applying, no worries.

regards
Stefan Schmidt
