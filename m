Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4969943B759
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbhJZQjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:39:48 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47995 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235479AbhJZQjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 12:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635266245; x=1666802245;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=JZD14+Y3wNcn+2g9m2B3deRHTTx2bL+FuMwSUhXf/eQ=;
  b=PLHhAi6zMXs0Ai6s0FYETBB2Xoogc/OjD0+0Az2smuLrrW/gt3Vuo3ML
   N5pclPOZ6MhQ984Ehz+22Svr1VR4CCAtegZ7ylHMaU3DAUFeAV0L2tG/z
   9I5OQ/zk0z9dp567TgrsnFMg4prEjKrc/ZDzS+AKe1qN2xT9RZqzMgc8Q
   H/DDSvPNxYeSHunVCXin7i3fSi8XwU3nAr2W185dnXOJbi62NdaQvlNWQ
   ow/AhMNEFawzOUdXdb10VQziQUgGSkPkQckFC5IC+klp4ROBjl/SP0Ete
   4g6Q9yaltDL0dVjokin46GIZ8gTi/VSChqDgHz9u2OByal98Q2lObUgDO
   Q==;
IronPort-SDR: JEHshVQDSvAJzIPDPM8NaFtadxL//NwKL5cSPlcDzz9OWaJRt2SUugU0Cc+bAOoVpSKSUO41O2
 AaFGnJv2s8ilorUat2jZWd0zEe98OYJKfmS40zrcZfhbWYHi7/aQ1z+Hr6fcmtRA7I6WT3VLPB
 QQAOQirURVMcS3dntdGxHBMK3JzoB1S6H1fWFs5W9YqtKeVDa77SoNYk4SmnCDw+ByBszncj3s
 QnYXRPlWSwYuVlQGdLZbpwFlHzrbj9QiQmdiBJb6rSdbxZVK1K/kLrZO/Hk2rEWzdCpPosB/pB
 P2c1hniNaLvGtr0r0J7xXEQZ
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="141137004"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Oct 2021 09:37:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 26 Oct 2021 09:37:22 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 26 Oct 2021 09:37:21 -0700
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
To:     Sean Anderson <sean.anderson@seco.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <YXcfRciQWl9t3E5Y@shell.armlinux.org.uk>
 <5e946ab6-94fe-e760-c64b-5abaf8ac9068@seco.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <a0c6edd9-3057-45cf-ef2d-6d54a201c9b2@microchip.com>
Date:   Tue, 26 Oct 2021 18:37:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5e946ab6-94fe-e760-c64b-5abaf8ac9068@seco.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/10/2021 at 23:35, Sean Anderson wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 10/25/21 5:19 PM, Russell King (Oracle) wrote:
>> On Mon, Oct 25, 2021 at 01:24:05PM -0400, Sean Anderson wrote:
>>> There were several cases where validate() would return bogus supported
>>> modes with unusual combinations of interfaces and capabilities. For
>>> example, if state->interface was 10GBASER and the macb had HIGH_SPEED
>>> and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
>>> another case, SGMII could be enabled even if the mac was not a GEM
>>> (despite this being checked for later on in mac_config()). These
>>> inconsistencies make it difficult to refactor this function cleanly.
>>>
>>> This attempts to address these by reusing the same conditions used to
>>> decide whether to return early when setting mode bits. The logic is
>>> pretty messy, but this preserves the existing logic where possible.
>>>
>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>> ---
>>>
>>> Changes in v4:
>>> - Drop cleanup patch
>>>
>>> Changes in v3:
>>> - Order bugfix patch first
>>>
>>> Changes in v2:
>>> - New
>>>
>>>   drivers/net/ethernet/cadence/macb_main.c | 59 +++++++++++++++++-------
>>>   1 file changed, 42 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>>> index 309371abfe23..40bd5a069368 100644
>>> --- a/drivers/net/ethernet/cadence/macb_main.c
>>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>>> @@ -510,11 +510,16 @@ static void macb_validate(struct phylink_config *config,
>>>                         unsigned long *supported,
>>>                         struct phylink_link_state *state)
>>>   {
>>> +    bool have_1g = true, have_10g = true;
>>>       struct net_device *ndev = to_net_dev(config->dev);
>>>       __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>>
>> I think DaveM would ask for this to be reverse-christmas-tree, so the
>> new bool should be here.
> 
> Ah, I wasn't aware that there was another variable-ordering style in use for net.
> 
>>>       struct macb *bp = netdev_priv(ndev);
>>>
>>> -    /* We only support MII, RMII, GMII, RGMII & SGMII. */
>>> +    /* There are three major types of interfaces we support:
>>> +     * - (R)MII supporting 10/100 Mbit/s
>>> +     * - GMII, RGMII, and SGMII supporting 10/100/1000 Mbit/s
>>> +     * - 10GBASER supporting 10 Gbit/s only
>>> +     */
>>>       if (state->interface != PHY_INTERFACE_MODE_NA &&
>>>           state->interface != PHY_INTERFACE_MODE_MII &&
>>>           state->interface != PHY_INTERFACE_MODE_RMII &&
>>> @@ -526,27 +531,48 @@ static void macb_validate(struct phylink_config *config,
>>>               return;
>>>       }
>>>
>>> -    if (!macb_is_gem(bp) &&
>>> -        (state->interface == PHY_INTERFACE_MODE_GMII ||
>>> -         phy_interface_mode_is_rgmii(state->interface))) {
>>> -            linkmode_zero(supported);
>>> -            return;
>>> +    /* For 1G and up we must have both have a GEM and GIGABIT_MODE */
>>> +    if (!macb_is_gem(bp) ||
>>> +        (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
>>> +            if (state->interface == PHY_INTERFACE_MODE_GMII ||
>>> +                phy_interface_mode_is_rgmii(state->interface) ||
>>> +                state->interface == PHY_INTERFACE_MODE_SGMII ||
>>> +                state->interface == PHY_INTERFACE_MODE_10GBASER) {
>>> +                    linkmode_zero(supported);
>>> +                    return;
>>> +            } else if (state->interface == PHY_INTERFACE_MODE_NA) {
>>> +                    have_1g = false;
>>> +                    have_10g = false;
>>> +            }
>>>       }
>>
>> Would it make more sense to do:
>>
>>        bool have_1g = false, have_10g = false;
>>
>>        if (macb_is_gem(bp) &&
>>            (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
>>                if (bp->caps & MACB_CAPS_PCS)
>>                        have_1g = true;
>>                if (bp->caps & MACB_CAPS_HIGH_SPEED)
>>                        have_10g = true;
>>        }
>>
>>        switch (state->interface) {
>>        case PHY_INTERFACE_MODE_NA:
>>        case PHY_INTERFACE_MODE_MII:
>>        case PHY_INTERFACE_MODE_RMII:
>>                break;
>>
>>        case PHY_INTERFACE_MODE_GMII:
>>        case PHY_INTERFACE_MODE_RGMII:
>>        case PHY_INTERFACE_MODE_RGMII_ID:
>>        case PHY_INTERFACE_MODE_RGMII_RXID:
>>        case PHY_INTERFACE_MODE_RGMII_TXID:
>>        case PHY_INTERFACE_MODE_SGMII:
>>                if (!have_1g) {
>>                        linkmode_zero(supported);
>>                        return;
>>                }
>>                break;
>>
>>        case PHY_INTERFACE_MODE_10GBASER:
>>                if (!have_10g) {
>>                        linkmode_zero(supported);
>>                        return;
>>                }
>>                break;
>>
>>        default:
>>                linkmode_zero(supported);
>>                return;
>>        }
>>
>> This uses positive logic to derive have_1g and have_10g, and then uses
>> the switch statement to validate against those. Would the above result
>> in more understandable code?
> 
> I experimented with something like the above, but I wasn't able to
> express it cleanly. I think what you have would work nicely.

I like it as well. Thanks a lot for these enhancements.

Regards,
   Nicolas


-- 
Nicolas Ferre
