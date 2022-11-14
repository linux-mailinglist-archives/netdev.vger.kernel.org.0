Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1A0628930
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 20:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbiKNTU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 14:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbiKNTUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 14:20:53 -0500
Received: from mxout014.mail.hostpoint.ch (mxout014.mail.hostpoint.ch [IPv6:2a00:d70:0:e::314])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3D921260
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 11:20:51 -0800 (PST)
Received: from [10.0.2.45] (helo=asmtp012.mail.hostpoint.ch)
        by mxout014.mail.hostpoint.ch with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1ouf0i-000Kbz-LI;
        Mon, 14 Nov 2022 20:20:48 +0100
Received: from [82.197.179.206] (helo=[192.168.169.11])
        by asmtp012.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1ouf0i-000BAf-Em;
        Mon, 14 Nov 2022 20:20:48 +0100
X-Authenticated-Sender-Id: thomas@kupper.org
Message-ID: <5fb7e87f-83fb-252b-1590-c6ff5862bbaa@kupper.org>
Date:   Mon, 14 Nov 2022 20:20:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 net 1/1] amd-xgbe: fix active cable
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>, netdev@vger.kernel.org,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Raju Rangoju <Raju.Rangoju@amd.com>
References: <b65b029d-c6c4-000f-dc9d-2b5cabad3a5c@kupper.org>
 <b2dedffc-a740-ed01-b1d4-665c53537a08@amd.com>
 <28351727-f1ba-5b57-2f84-9eccff6d627f@kupper.org>
 <64edbded-51af-f055-9c2f-c1f81b0d3698@kupper.org>
 <9180965b-fe96-7500-d139-013d1987c498@amd.com>
From:   Thomas Kupper <thomas@kupper.org>
In-Reply-To: <9180965b-fe96-7500-d139-013d1987c498@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/14/22 18:39, Tom Lendacky wrote:
> On 11/12/22 13:12, Thomas Kupper wrote:
>> On 11/11/22 17:00, Thomas Kupper wrote:
>>> On 11/11/22 15:18, Tom Lendacky wrote:
>>>> On 11/11/22 02:46, Thomas Kupper wrote:
>>>>> When determine the type of SFP, active cables were not handled.
>>>>>
>>>>> Add the check for active cables as an extension to the passive cable check.
>>>>
>>>> Is this fixing a particular problem? What SFP is this failing for? A more descriptive commit message would be good.
>>>>
>>>> Also, since an active cable is supposed to be advertising it's capabilities in the eeprom, maybe this gets fixed via a quirk and not a general check this field.
>>
>> Tom,
>>
>> are you sure that an active cable has to advertising it's speed? Searching for details about it I read in "SFF-8472 Rev 12.4", 5.4.2, Table 5-5 Transceiver Identification Examples:
>>
>> Transceiver Type Transceiver Description    Byte    Byte    Byte    Byte    Byte    Byte    Byte    Byte
>>                         3    4    5    6    7     8    9    10
>> ...
>>         10GE Active cable with SFP(3,4)     00h    00h    00h    00h    00h    08h    00h    00h
>>
>> And footnotes:
>> 3) See A0h Bytes 60 and 61 for compliance of these media to industry electrical specifications
>> 4) For Ethernet and SONET applications, rate capability of a link is identified in A0h Byte 12 [nominal signaling
>> rate identifier]. This is due to no formal IEEE designation for passive and active cable interconnects, and lack
>> of corresponding identifiers in Table 5-3.
>>
>> Wouldn't that suggest that byte 3 to 10 are all zero, except byte 8?
> 
> This issue seems to be from my misinterpretation of active vs passive.
> IIUC now, active and passive only applies to copper cables with SFP+ end
> connectors. In which case the driver likely needs an additional enum cable
> type, XGBE_SFP_CABLE_FIBER, as the default cable type and slightly
> different logic.
> 
> Can you try the below patch? If it works, I'll work with Shyam to do some
> testing to ensure it doesn't break anything.

Thanks Tom for getting back to me so soon.

Your patch works well for me, with a passive, an active cable and a GBIC.

But do you think it's a good idea to just check for != XGBE_SFP_CABLE_FIBER? That would also be true for XGBE_SFP_CABLE_UNKNOWN.

     /* Determine the type of SFP */
-    if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+    if (phy_data->sfp_cable != XGBE_SFP_CABLE_FIBER &&
         xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
         phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
     else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)

Cheers
Thomas

> 
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 4064c3e3dd49..868a768f424c 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -189,6 +189,7 @@ enum xgbe_sfp_cable {
>      XGBE_SFP_CABLE_UNKNOWN = 0,
>      XGBE_SFP_CABLE_ACTIVE,
>      XGBE_SFP_CABLE_PASSIVE,
> +    XGBE_SFP_CABLE_FIBER,
>  };
>  
>  enum xgbe_sfp_base {
> @@ -1149,16 +1150,18 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
>      phy_data->sfp_tx_fault = xgbe_phy_check_sfp_tx_fault(phy_data);
>      phy_data->sfp_rx_los = xgbe_phy_check_sfp_rx_los(phy_data);
>  
> -    /* Assume ACTIVE cable unless told it is PASSIVE */
> +    /* Assume FIBER cable unless told otherwise */
>      if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_PASSIVE) {
>          phy_data->sfp_cable = XGBE_SFP_CABLE_PASSIVE;
>          phy_data->sfp_cable_len = sfp_base[XGBE_SFP_BASE_CU_CABLE_LEN];
> -    } else {
> +    } else if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_ACTIVE) {
>          phy_data->sfp_cable = XGBE_SFP_CABLE_ACTIVE;
> +    } else {
> +        phy_data->sfp_cable = XGBE_SFP_CABLE_FIBER;
>      }
>  
>      /* Determine the type of SFP */
> -    if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
> +    if (phy_data->sfp_cable != XGBE_SFP_CABLE_FIBER &&
>          xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>          phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
>      else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
> 
>>
>>
>> /Thomas
>>
>>>
>>> It is fixing a problem regarding a Mikrotik S+AO0005 AOC cable (we were in contact back in Feb to May). And your right I should have been more descriptive in the commit message.
>>>
>>>>>
>>>>> Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
>>>>> Signed-off-by: Thomas Kupper <thomas.kupper@gmail.com>
>>>>> ---
>>>>>  ??drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 5 +++--
>>>>>  ??1 file changed, 3 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>>>> index 4064c3e3dd49..1ba550d5c52d 100644
>>>>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>>>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>>>> @@ -1158,8 +1158,9 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
>>>>>  ????? }
>>>>>
>>>>>  ????? /* Determine the type of SFP */
>>>>> -??? if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
>>>>> -??? ??? xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>>>> +??? if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE ||
>>>>> +??? ???? phy_data->sfp_cable == XGBE_SFP_CABLE_ACTIVE) &&
>>>>> +??? ???? xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>>>
>>>> This is just the same as saying:
>>>>
>>>>  ????if (xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>>>
>>>> since the sfp_cable value is either PASSIVE or ACTIVE.
>>>>
>>>> I'm not sure I like fixing whatever issue you have in this way, though. If anything, I would prefer this to be a last case scenario and be placed at the end of the if-then-else block. But it may come down to applying a quirk for your situation.
>>>
>>> I see now that this cable is probably indeed not advertising its capabilities correctly, I didn't understand what Shyam did refer to in his mail from June 6.
>>>
>>> Unfortunately I haven't hear back from you guys after June 6 so I tried to fix it myself ... but do lack the knowledge in that area.
>>>
>>> A quirk seems a good option.
>>>
>>>  From my point of view this patch can be cancelled/aborted/deleted.
>>> I'll look into how to fix it using a quirk but maybe I'm not the hest suited candidate to do it.
>>>
>>> /Thomas
>>>
>>>>
>>>> Thanks,
>>>> Tom
>>>>
>>>>>  ????? ??? phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
>>>>>  ????? else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
>>>>>  ????? ??? phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
>>>>> -- 
>>>>> 2.34.1
>>>>>
