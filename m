Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3354943B73F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237259AbhJZQfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:35:07 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62531 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237245AbhJZQfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 12:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635265962; x=1666801962;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=2oV2jsQDut8kk1kEd2a+08PbjkWAiBWL7hG3S+p04aM=;
  b=Y/1hLqMcoRBQEHDg3+qW26wma4V1g25TxHy4U9fyBJ5+KByePNFVkeBr
   sMYS67oLgsaKfLQ4hwOmVO6x7JbV/I8rcYrkgsZrrjQFH0ZB5MMOepYh0
   T1F1Sz7x+8y4hswYjCSO8HTQXeHUOhQ66bcUZ9tO8UPfTZmxDs0JFlsXt
   XAT0IuVhAl5t+Jv4D6XeTiCP1VXOEFM/+/Om8vKtIN65qZlGq2Jqubb0M
   8qTwThC0+X0cu0mTbiG45OjZoFmv5fu5hgdApzIPTRlU9HS13JrXzOyFK
   IDannnz6cZ0xhrhyPeMdsb9//6ouJSjCZfBZob88XrIpSWBsgrivmBD6m
   Q==;
IronPort-SDR: aVVH5Y545dt6eY5vvvfhiopcE/0azaY4+ubUrJB5hSwzmoyZfsqm+E6sqXaezkJnRFMXHmbwsd
 L+ur0RH5cMfBviXFbZRbWjIBu0G8W/xlIwKf9rTKmmHfiapHrypNMsUXnam4h6MZRGVdahutvj
 XoAXNOGIfxOmeUmIJ8p1BzPVwemf6ZKEtrTJxqGBdknIXOaeV05Ta/k3lDb26A7zICaJN5f+bM
 Q8LPLNKnQ9Zz30lCLxMtIMNHirJJwtv83sBLk+LwwwcwxSIHR/zhZBrg3CmH7U90GFB8j/T2C7
 5aaqr3hbP/b4lKTj7o1W07xP
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="149584936"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Oct 2021 09:32:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 26 Oct 2021 09:32:41 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 26 Oct 2021 09:32:40 -0700
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
To:     Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Russell King <linux@armlinux.org.uk>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <20211025174401.1de5e95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4e430fbb-0908-fd3b-bb6e-ec316ea8d66a@seco.com>
 <20211026083939.11dc6b16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <c115a484-7aa5-cfe6-d26a-89efee3ee3fe@microchip.com>
Date:   Tue, 26 Oct 2021 18:32:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211026083939.11dc6b16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 at 17:39, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, 26 Oct 2021 11:30:08 -0400 Sean Anderson wrote:
>> Hi Jakub,
>>
>> On 10/25/21 8:44 PM, Jakub Kicinski wrote:
>>> On Mon, 25 Oct 2021 13:24:05 -0400 Sean Anderson wrote:
>>>> There were several cases where validate() would return bogus supported
>>>> modes with unusual combinations of interfaces and capabilities. For
>>>> example, if state->interface was 10GBASER and the macb had HIGH_SPEED
>>>> and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
>>>> another case, SGMII could be enabled even if the mac was not a GEM
>>>> (despite this being checked for later on in mac_config()). These
>>>> inconsistencies make it difficult to refactor this function cleanly.
>>>
>>> Since you're respinning anyway (AFAIU) would you mind clarifying
>>> the fix vs refactoring question? Sounds like it could be a fix for
>>> the right (wrong?) PHY/MAC combination, but I don't think you're
>>> intending it to be treated as a fix.
>>>
>>> If it's a fix it needs [PATCH net] in the subject and a Fixes tag,
>>> if it's not a fix it needs [PATCH net-next] in the subject.
>>>
>>> This will make the lifes of maintainers and backporters easier,
>>> thanks :)
>>
>> I don't know if it's a "fix" per se. The current logic isn't wrong,
>> since I believe that the configurations where the above patch would make
>> a difference do not exist. However, as noted in the commit message, this
>> makes refactoring difficult.
> 
> Ok, unless one of the PHY experts can help us make a call let's go
> for net-next and no Fixes tag.

Agreed.

Regards,
   Nicolas

>> For example, one might want to implement supported_interfaces like
>>
>>          if (bp->caps & MACB_CAPS_HIGH_SPEED &&
>>              bp->caps & MACB_CAPS_PCS)
>>                  __set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
>>          if (macb_is_gem(bp) && bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
>>                  __set_bit(PHY_INTERFACE_MODE_GMII, supported);
>>                phy_interface_set_rgmii(supported);
>>                  if (bp->caps & MACB_CAPS_PCS)
>>                          __set_bit(PHY_INTERFACE_MODE_SGMII, supported);
>>          }
>>          __set_bit(PHY_INTERFACE_MODE_MII, supported);
>>          __set_bit(PHY_INTERFACE_MODE_RMII, supported);
>>
>> but then you still need to check for GIGABIT_MODE in validate to
>> determine whether 10GBASER should "support" 10/100. See [1] for more
>> discussion.
>>
>> If you think this fixes a bug, then the appropriate tag is
>>
>> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
>>
>> --Sean
>>
>> [1] https://lore.kernel.org/netdev/YXaIWFB8Kx9rm%2Fj9@shell.armlinux.org.uk/
> 


-- 
Nicolas Ferre
