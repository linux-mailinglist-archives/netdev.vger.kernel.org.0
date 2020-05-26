Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926D21E2958
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388957AbgEZRsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:48:18 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:38200 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgEZRsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 13:48:18 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04QHmCBk033300;
        Tue, 26 May 2020 12:48:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590515292;
        bh=2WPRrdT9w8zDCVHBZqeCHpQW4EnwADnt8oLLDTr2XxI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=l5g1bYITzSyPQnkWcHhX1xrW0MdQ2UjtYwF3K2LD5MfsRmvMQCTAHadJhL64eDWau
         J9otJ50cYlH0eiCBiVnOC+nmwNA80GacjxMmggUvVzgK5Y1rS7s+WFSj6mB69f8m66
         atoj7/YW9UgaTtbCrygmw1AjHbfwdJMJtjYSTU1Q=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04QHmCeq124373
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 May 2020 12:48:12 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 26
 May 2020 12:48:12 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 26 May 2020 12:48:12 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QHmCkL088235;
        Tue, 26 May 2020 12:48:12 -0500
Subject: Re: [PATCH net-next v2 4/4] net: dp83869: Add RGMII internal delay
 configuration
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200522122534.3353-1-dmurphy@ti.com>
 <20200522122534.3353-5-dmurphy@ti.com>
 <a1ec8ef0-1536-267b-e8f7-9902ed06c883@gmail.com>
 <948bfa24-97ad-ba35-f06c-25846432e506@ti.com>
 <20200523150951.GK610998@lunn.ch>
 <a59412a5-7cc6-dc70-b851-c7d65c1635b7@ti.com>
 <20200523220741.GO610998@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <b8648d0d-6064-f481-6ecf-6151736f1899@ti.com>
Date:   Tue, 26 May 2020 12:48:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200523220741.GO610998@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/23/20 5:07 PM, Andrew Lunn wrote:
>>> Any why is your PHY special, in that is does care about out of range
>>> delays, when others using new the new core helper don't?
>> We are not rounding to nearest here.  Basically the helper works to find the
>> best match
>>
>> If the delay passed in is less than or equal to the smallest delay then
>> return the smallest delay index
>>
>> If the delay passed in is greater then the largest delay then return the max
>> delay index
> +               /* Find an approximate index by looking up the table */
> +               if (delay > delay_values[i - 1] &&
> +                   delay < delay_values[i]) {
> +                       if (delay - delay_values[i - 1] < delay_values[i] - delay)
> +                               return i - 1;
> +                       else
> +                               return i;
>
> This appears to round to the nearest value when it is not an exact
> match.
>
> The documentation is a hint to the DT developer what value to put in
> DT. By saying it rounders, the developer does not need to go digging
> through the source code to find an exact value, otherwise -EINVAL will
> be returned. They can just use the value the HW engineer suggested,
> and the PHY will pick whatever is nearest.
>
>> Not sure what you mean about this PHY being special.  This helper is
>> not PHY specific.
> As you said, if out of range, the helper returns the top/bottom
> value. Your PHY is special, the top/bottom value is not good enough,
> you throw an error.
>
> The point of helpers is to give uniform behaviour. We have one line
> helpers, simply because they give uniform behaviour, rather than have
> each driver do it subtlety different. But it also means drivers should
> try to not add additional constraints over what the helper already
> has, unless it is actually required by the hardware.
>
>> After I think about this more I am thinking a helper may be over kill here
>> and the delay to setting should be done within the PHY driver itself
> The helper is useful, it will result in uniform handling of rounding
> between DT values and what the PHY can actually do. But please also
> move your range check and error message inside the helper.


I re-worked v3 to be a bit more of a helper and incorporated Florian's 
and you comments

Dan


>       Andrew
