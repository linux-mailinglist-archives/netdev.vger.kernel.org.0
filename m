Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D238749DBB0
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 08:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237364AbiA0HdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 02:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbiA0HdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 02:33:20 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCD9C061714;
        Wed, 26 Jan 2022 23:33:19 -0800 (PST)
Received: from [IPV6:2003:e9:d70e:d66f:5a35:69f1:72f5:373] (p200300e9d70ed66f5a3569f172f50373.dip0.t-ipconnect.de [IPv6:2003:e9:d70e:d66f:5a35:69f1:72f5:373])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id D3F62C0824;
        Thu, 27 Jan 2022 08:33:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643268797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y8DY7UBqf6EvdHkEUzasa8wET6ZUZeG8iI0Uuvl5nTI=;
        b=Z4eDUn5CWJpCMSSSoq1djY+GR92eh3OzfS9IGd5ZdD3W1LsjLz4E5Nw6j9g8ocZyIOnm0s
        EvtFfVDLekzK1ImBKI4O0RahG0he9drlZPUmCrClPYMij4PrgDJ4NDd/FGEd9iMG/QkFd+
        kKGeHPP44A7+TZzX07jVptZgruSK2SnV1sGNweOK7xoxr9sO5y3V6HXYjFt5MvcjyzhJyh
        H+vnBPx6GHIwhJb7D9oatZVLItB2pbdboLFd8pj6zfVoHxVX+ike+cL0gS5vug6aN2b4xh
        wrH9h6Loz5l49R0LyIBUWxe+f7joApHrnLF+F5OJPZl4O1q750sEdBrXfN64cA==
Message-ID: <344c7192-20b6-15f5-021c-092148f87bca@datenfreihafen.org>
Date:   Thu, 27 Jan 2022 08:33:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan v3 1/6] net: ieee802154: hwsim: Ensure proper channel
 selection at probe time
Content-Language: en-US
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220125121426.848337-1-miquel.raynal@bootlin.com>
 <20220125121426.848337-2-miquel.raynal@bootlin.com>
 <d3cab1bb-184d-73f9-7bd8-8eefc5e7e70c@datenfreihafen.org>
 <20220125174849.31501317@xps13>
 <89726c29-bf7d-eaf1-2af0-da1914741bec@datenfreihafen.org>
 <CAB_54W4TGvLeXdKLpxDwTrt4a19WPtSWDXq7kX4i-Ypd6euLnQ@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAB_54W4TGvLeXdKLpxDwTrt4a19WPtSWDXq7kX4i-Ypd6euLnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 26.01.22 23:54, Alexander Aring wrote:
> Hi,
> 
> On Wed, Jan 26, 2022 at 8:38 AM Stefan Schmidt
> <stefan@datenfreihafen.org> wrote:
>>
>>
>> Hello.
>>
>> On 25.01.22 17:48, Miquel Raynal wrote:
>>> Hi Stefan,
>>>
>>> stefan@datenfreihafen.org wrote on Tue, 25 Jan 2022 15:28:11 +0100:
>>>
>>>> Hello.
>>>>
>>>> On 25.01.22 13:14, Miquel Raynal wrote:
>>>>> Drivers are expected to set the PHY current_channel and current_page
>>>>> according to their default state. The hwsim driver is advertising being
>>>>> configured on channel 13 by default but that is not reflected in its own
>>>>> internal pib structure. In order to ensure that this driver consider the
>>>>> current channel as being 13 internally, we at least need to set the
>>>>> pib->channel field to 13.
>>>>>
>>>>> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
>>>>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>>>>> ---
>>>>>     drivers/net/ieee802154/mac802154_hwsim.c | 1 +
>>>>>     1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
>>>>> index 8caa61ec718f..00ec188a3257 100644
>>>>> --- a/drivers/net/ieee802154/mac802154_hwsim.c
>>>>> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
>>>>> @@ -786,6 +786,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
>>>>>              goto err_pib;
>>>>>      }
>>>>>     > +      pib->page = 13;
>>>>
>>>> You want to set channel not page here.
>>>
>>> Oh crap /o\ I've messed that update badly. Of course I meant
>>> pib->channel here, as it is in the commit log.
>>>
>>> I'll wait for Alexander's feedback before re-spinning. Unless the rest
>>> looks good for you both, I don't know if your policy allows you to fix
>>> it when applying, anyhow I'll do what is necessary.
>>
>> If Alex has nothing else and there is no re-spin I fix this when
>> applying, no worries.
> 
> Everything is fine.
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>
> 
> On the whole series. Thanks.

Fixed up this commit and applied the whole patchset.

Next one we should look at would be the 3 split out cleanup patches.

regards
Stefan Schmidt
