Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88226422D4F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbhJEQFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:05:50 -0400
Received: from mail-am6eur05on2047.outbound.protection.outlook.com ([40.107.22.47]:61888
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231513AbhJEQFs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:05:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7jyrJb5n3TFaju3gzjL50AtsSMP5CNGPNEQwApGVfUbCOk1eBDBoZb5Yuzu8/DyIkKEgHen+S7d5ODpkZgWlOwydNY4SRJrpeIMVfFB5QdM3tB91ypjrEouDPItd8IWIeoZFgwDwlCso0DsUxwNo1RPjNG6h9oj17BdEahypVKmqrPrqlpEo8/QBD4JPjIht8iT6ZBb1gapmiNVDvkRY4dLLJECl9d/fYWx7SKsiD5k+Q8Ar8NRRE3AsJ+2TPniHoWH/gPKloOR72SOD983AVX+BHg0EmUJu40h3vDviFBP948Z8W0IFf7LbC6dygmgwgD3xPUm0gJqqSho2r21Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mat2pyjPTqLoKIUYMIcDaZk/LbhHYpR1e8iYVSI4qoE=;
 b=IdtRGw8k9pk9lW0UYa0JoU6vpIp6ggBcf/unLsVGdbiYkbSZJ79Y1yj0l3gO3XW6JY48Igm5K6jjLwjeWrCZBKlXs55SNtogiF5e0/IERC7Uwrjtqpb8rXhnxRyhZkHeOIYgNbPz6zZS58Zmpk9fJs8fhys0+m1qW93onKPNs8gw15pHU4wi7hr4GZJjpzzGNv8iAJxkeRe5hlEbeUvWhHa1MDiHJU5lBu4KqoEzqq54pE1TJVzGUOVe/roCxne1EQ3a+KmlzJ4H1mRV+uB/CIRA33SSRXpVdDTPTTb1GGnGUVYrJJAqZFNJS4rBHIiNv01bDcnok0ot8ZIe9IlsBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mat2pyjPTqLoKIUYMIcDaZk/LbhHYpR1e8iYVSI4qoE=;
 b=cIT84UBQoUwCzIhazn1abVnjZaft0i4I6a3nEfaizqjSjtxTSK7hX2s8FdlcdyuY9ponlw36HsBTzjbWt8lPEMKzg/W4/GwSQsfsg1stdA/naGghf/kUOj3CxyxuLssLHtYRgNKhTIpoZrq3+IlgHxwGeSuzHAOC7pT40QRQslI=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7514.eurprd03.prod.outlook.com (2603:10a6:10:22a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 16:03:55 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 16:03:55 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC net-next PATCH 10/16] net: macb: Move PCS settings to PCS
 callbacks
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-11-sean.anderson@seco.com>
 <YVwjjghGcXaEYgY+@shell.armlinux.org.uk>
Message-ID: <7c92218c-baec-a991-9d6b-af42dfabbad3@seco.com>
Date:   Tue, 5 Oct 2021 12:03:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YVwjjghGcXaEYgY+@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P221CA0014.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::26) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1P221CA0014.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 16:03:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b35d93c-af73-4c5b-a495-08d98819bb4f
X-MS-TrafficTypeDiagnostic: DB9PR03MB7514:
X-Microsoft-Antispam-PRVS: <DB9PR03MB75144721CE176546EF1298DD96AF9@DB9PR03MB7514.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BSEjNIh6V4jLvyv7ozey+za5MLhaS49CY6PxPyEeyl/nfTM0uQCZllX+B0L8E95wi3NeVD69JmRBAW3vx90M9b0/1QawewInW2kH8WBo5784R2zdLun1QXHhA141MMkjsZ7K1XQK6ec77SfEOwngtNjrwyBoTkDdCzAAzcB8aXNZf1Y6blk/D66ij5lp9VoRD5OvRM1mrLG9NKQ60kge7RmAN4kjVQO1v1OCY1kbsP3WrfxKoXOJD9ivzd2d99AqCciEHMeT1ugmMYSsyIbP8hga2w7lrAK/JijUTTSPe0Oe0fH10XlvHdue7D9THl8zt5/2KH2QbeY3fk0MVf6tYgwbe9c1EGspC0Lo2T3T1A0fFRzH3e+QelsaEp5qQaSMt0jMhuPP1SiX7QPFro3SBz8FzHF0RQ+qa+4VmZI5/POoGnYeiKTcb7yirL24KF9rCZk/wZKKUdu3kCkOzr8Ags51ZjR5aIdHCbghT+8sLmyIqpM51+cy3j5wmqGBZAsWUKHaD/Ix8sPFoNaUsEb7Uty/M2XHT5xlK1adlkin0yNlLfC3nWMtovTMmuRAYlfIlm3glXOh2m/o/OaPA4zhIrcroZm7jnNCHU9NKNFUzVlD12RbGVsxR82i62sCDl4SHOQEOxGEmNwKRFOFvbA1otGEJYjUmxlABwcdTYrtVkRKMYEILbqX+3v5wwRcHS8xOIUkg7HOG3Hi9VXunE1qTacrOqMalsZffmYJN8fH8EQJ4lvh33F4BcCbsEpslzLz7TsTMAfl3fjUpZTyQ0rHIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(956004)(508600001)(5660300002)(2616005)(66476007)(52116002)(316002)(66946007)(83380400001)(66556008)(4326008)(186003)(2906002)(86362001)(44832011)(8936002)(31696002)(16576012)(36756003)(38100700002)(38350700002)(31686004)(54906003)(6486002)(8676002)(26005)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXZBdjdGbTdJdjdlcExEd1c2UWNwZFQwclhWZWxVcXdQdEp1U2lIRXE0ODNR?=
 =?utf-8?B?K1BhZ2lES1QzTHpqaW00d2p3bTdUcEw2bnU2d0E2MGE2M2VyMWsweTNSYktL?=
 =?utf-8?B?V1dTWE4xMFJOK29adjluSm9mQjg3S1RKVHYvcEFnVFV5NWJqRCtseHVydkxF?=
 =?utf-8?B?QVpVRXBIL2RJdWVHK1I1VHhycVZINk1PaXpxYlIxZTdDY0VOeHVOQ2R2MUdr?=
 =?utf-8?B?b0cydjRibFZFVTJtK0F2bitQSDF4WGJ0LytvcXVQbFdtWWxxSmpiZ0lMQThm?=
 =?utf-8?B?WHdIbTFYQW1MTkszUG0ySjdzbElLSVZmeDNpTWlaRDhPV2lkNVVuRElrWUlE?=
 =?utf-8?B?a2dzK0dwZ1BaYiswL1E5MFdobU9UL1k2V2toWTZFMDNCVytJVVpkY1YyOUFj?=
 =?utf-8?B?NzFpbmVUYng1Z2wvQktiTDBJYnFWVURYdjB4aGZKRlhEajRrZ0dUcFJ3M0hm?=
 =?utf-8?B?NFBLRjhRSE5SckNscXJ5SWhEalcwZDVVTnpURFh5RzNNVkJSakJ1c3lkV3dO?=
 =?utf-8?B?T01jQTI0TUhLLzZwTC8xeEh3L08zZkN0aWJxdkVRTVRwS0ZDTGlGa1M4a05G?=
 =?utf-8?B?b3RqY3lnQkZUd2RxVUtySW1zOFlOVDBETStnWExFdG9JN2Z5QmpYUVJyb1cx?=
 =?utf-8?B?TWhwbnpGNWM3ajZ5di9Wa1Fhc05MMm5FZm9MMU1sdUtURWRaUWJRb1phZ0V5?=
 =?utf-8?B?VzhLcSt2S1R5ejZUN1VPek90VUlJUnFzQ0RLTlYyditkOWlRWmhNbVpldGxK?=
 =?utf-8?B?QnkrdUczdDFHWVNINU9ha2V0cW16bGR1VTlVNVVQcVk3ZnhNeWs1STFHTFc3?=
 =?utf-8?B?eEZHZ2hsajNzMUplZ3dxL3VMR1o3aUc3eTJSYWFkdXpJd3lWb2hrZXY4Qms3?=
 =?utf-8?B?N1BIdUFNdU5SeFpua2ZtSDgzT3c4dFBaZEk5czA0T3pFdGFFK3d4MTc1Mjc5?=
 =?utf-8?B?Witic210ODQrUGJjVDVMRkl2eFBGQ2RQVjN5eDRkTjc1cU8xaVNubkF6ODh6?=
 =?utf-8?B?elF2NTgzQ2RRNyttKzIwYlBTZVVoTTdrM1VhRXhuWjdvbnZtZU1lN0lCMCth?=
 =?utf-8?B?RGprdHJieUdMNDVESUZxOFdCOXE4YjBNUXhXRk9jZHEvMEMrR1ZIaG1Db1I4?=
 =?utf-8?B?SWdLYldvS0diM0IzQ3J2L0N3ZVE5LzJkWGlKajJlRXBRRytyenZkV0FyZ1hW?=
 =?utf-8?B?N1FpeTgyb250WlQyWHRDWVFmZEpaUzlzbFFyZXFnanBZQWl1SitCMTNKbkFS?=
 =?utf-8?B?UkI1ZUtXemMxZ1ZsYkpQMVRJWnhrTDVtWGZYK0UvM2RpNmRiNWhZWHFzQWZQ?=
 =?utf-8?B?ZVErNUp3VUtEOGxmZDhuY3N0V1FMcHRmNlBsdSt1WWRNZDZKN0wzSWxjZHFR?=
 =?utf-8?B?Qi9UMHk1QXhhWkxZU2xTTm5pQ2ZPdjVOZ0podFJQL3RQWXVmTEtzMDM0aUtl?=
 =?utf-8?B?dEZTWkJ4S1V4U1g1MUsrSUxtL0t3Qi9zS1g1ZVFVV2pqUVVqYVFhZmh3QVZJ?=
 =?utf-8?B?M0tDMTI3b2NPNUhBOXZIQzIyR2x2aXJZSFZpc3VSeVMxVitPdmJweC9jNytv?=
 =?utf-8?B?cHdEbDRvYWNVRTRzc2FzdDJBcVdJcVpGRU05eE1QM0RFQ1ZzSzBuNUdCN1pm?=
 =?utf-8?B?ZnJLM2JqeHZHYnBjZUZvUG5FTVd6TFBWYXAwc3doNmYwZEVYTU9KekVYcUV3?=
 =?utf-8?B?NDRkeHIwN05UMkZKcEFiaDFnYmhiNzNjSWNtTFAzV2N0RjlQaWxNMWF0UFlX?=
 =?utf-8?Q?Oq0ok/HNmIdX6KoFNTp/aunNDBkKbt1SYuoo9mN?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b35d93c-af73-4c5b-a495-08d98819bb4f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 16:03:55.1323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7C9mw9u4Pr/3Q+avf8Sb75NcV2IBISiM8xP55Gq/Hd6Hpr/6K2Aak+xBG3GEZKxJ71QvI10dxmIePO3b0ONukQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7514
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 10/5/21 6:06 AM, Russell King (Oracle) wrote:
> On Mon, Oct 04, 2021 at 03:15:21PM -0400, Sean Anderson wrote:
>> +static void macb_pcs_get_state(struct phylink_pcs *pcs,
>> +			       struct phylink_link_state *state)
>> +{
>> +	struct macb *bp = pcs_to_macb(pcs);
>> +
>> +	if (gem_readl(bp, NCFGR) & GEM_BIT(SGMIIEN))
>> +		state->interface = PHY_INTERFACE_MODE_SGMII;
>> +	else
>> +		state->interface = PHY_INTERFACE_MODE_1000BASEX;
>
> There is no requirement to set state->interface here. Phylink doesn't
> cater for interface changes when reading the state. As documented,
> phylink will set state->interface already before calling this function
> to indicate what interface mode it is currently expecting from the
> hardware.

Ok, so instead I should be doing something like

if (gem_readl(bp, NCFGR) & GEM_BIT(SGMIIEN))
	interface = PHY_INTERFACE_MODE_SGMII;
else
	interface = PHY_INTERFACE_MODE_1000BASEX;

if (interface != state->interface) {
	state->link = 0;
	return;
}

?

>> +static int macb_pcs_config_an(struct macb *bp, unsigned int mode,
>> +			      phy_interface_t interface,
>> +			      const unsigned long *advertising)
>> +{
>> +	bool changed = false;
>> +	u16 old, new;
>> +
>> +	old = gem_readl(bp, PCSANADV);
>> +	new = phylink_mii_c22_pcs_encode_advertisement(interface, advertising,
>> +						       old);
>> +	if (old != new) {
>> +		changed = true;
>> +		gem_writel(bp, PCSANADV, new);
>> +	}
>> +
>> +	old = new = gem_readl(bp, PCSCNTRL);
>> +	if (mode == MLO_AN_INBAND)
>
> Please use phylink_autoneg_inband(mode) here.

Ok.

>
>> +		new |= BMCR_ANENABLE;
>> +	else
>> +		new &= ~BMCR_ANENABLE;
>> +	if (old != new) {
>> +		changed = true;
>> +		gem_writel(bp, PCSCNTRL, new);
>> +	}
>
> There has been the suggestion that we should allow in-band AN to be
> disabled in 1000base-X if we're in in-band mode according to the
> ethtool state.

This logic is taken from phylink_mii_c22_pcs_config. Maybe I should add
another _encode variant? I hadn't done this here because the logic was
only one if statement.

> I have a patch that adds that.

Have you posted it?

>> +	return changed;
>> +}
>> +
>> +static int macb_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>> +			   phy_interface_t interface,
>> +			   const unsigned long *advertising,
>> +			   bool permit_pause_to_mac)
>> +{
>> +	bool changed = false;
>> +	struct macb *bp = pcs_to_macb(pcs);
>> +	u16 old, new;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&bp->lock, flags);
>> +	old = new = gem_readl(bp, NCFGR);
>> +	if (interface == PHY_INTERFACE_MODE_SGMII) {
>> +		new |= GEM_BIT(SGMIIEN);
>> +	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
>> +		new &= ~GEM_BIT(SGMIIEN);
>> +	} else {
>> +		spin_lock_irqsave(&bp->lock, flags);
>> +		return -EOPNOTSUPP;
>
> You can't actually abort at this point - phylink will print the error
> and carry on regardless. The checking is all done via the validate()
> callback and if that indicates the interface mode is acceptable, then
> it should be accepted.

Ok, so where can the PCS NAK an interface? This is the only callback
which has a return code, so I assumed this was the correct place to say
"no, we don't support this." This is what lynx_pcs_config does as well.

>>  static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
>>  	.pcs_get_state = macb_usx_pcs_get_state,
>>  	.pcs_config = macb_usx_pcs_config,
>> -	.pcs_link_up = macb_usx_pcs_link_up,
>>  };
>>
>>  static const struct phylink_pcs_ops macb_phylink_pcs_ops = {
>>  	.pcs_get_state = macb_pcs_get_state,
>> -	.pcs_an_restart = macb_pcs_an_restart,
>
> You don't want to remove this.

Hm, I didn't realized I had removed this, so I add it back in the next
patch. I will merge that one into this one.


> When operating in 1000BASE-X mode, it
> will be called if a restart is required (e.g. macb_pcs_config()
> returning positive, or an ethtool request.) You need to keep the empty
> function.

Ok, perhaps I can add some sanity checks for this in pcs_register.

--Sean

> That may also help the diff algorithm to produce a cleaner
> patch too.
