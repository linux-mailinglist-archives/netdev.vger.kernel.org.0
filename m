Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D19B4258D3
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243053AbhJGRG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:06:29 -0400
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:49890
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243021AbhJGRGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 13:06:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dF6dpYhc5L1MdU57A2+FIU7uCevCGSsaGMliURUdhbguFh8ocRKXdQZvWO+c9fdBDO3DGVbGy4Axb5A3ypyOoa7Orrk8KRtynFvCesfeQWzPpMnRM28iVsGc4XXMczgFWuE4q65DOu+r8FMpBP6jFobmeWnweABLsK4dHo373O6s79+z4GBA9AYzdSZrnRaxC8j/LHsC2IYW/DllqUcKANsgIxKk/pTHxxjqAdDV/uuspJRStJdvHJXSRTNrawoCmmEwykryTL0+Rv2XS497Sug5s2Zd715Z/RUxSxFJRp8O4FcL9f4sp4U1zt2XvZWPNmv8uCy6Xavm4vyawWucCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M25ClWXYrK1qjGdnoXQeD+iF3KYxMvz5B7i0bmNZ5EU=;
 b=GnnbQTJlzBPhoc9CuO+rNzHUYn69Rzwr+fk5tURfh1r8XbMc8OGXyONpIyQjzH17VX9xPQRn3q+jshnxJOh0eI1ylXoOhSLcHCGHRqkCHSJXSJDD/5n+eor/AfqhDSu+hCjFsJxxJmfVo1K9v3PorGd1/NOBoKVxO+blphmJuuiM1ew+c1UlYXRZM4SyjvEqw8OhFPw9Gua/XfbHjtfW/7gWe/ZdfxAsYlBraL49bfeF2keCAm8kKZyCZ9lJW+D7Bf2/GFFMGgNSaxOP3Z5RdjDm1tca46YUc58z8GsJ8FkoQQdMqc64Kps+Tf04aODLsENii/1PGkbZOw52UZHjgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M25ClWXYrK1qjGdnoXQeD+iF3KYxMvz5B7i0bmNZ5EU=;
 b=TVmhy6xfRfFrMxkGYz+zOvWwZeroJBybr5L7tqrSNFKXQY2F73IH5hq8tJtM7l1GlLhg+yyEvnxN+/YIC7z21/GAWd/FKgkN4KoBVnJc6TDuCDtK07xlr8y4eJPuK+2iMCkOEPXZqF9fa5Nyxc1jYQ/vXkQAunj/xZwui8ARiG0=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0302MB2824.eurprd03.prod.outlook.com (2603:10a6:4:ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Thu, 7 Oct
 2021 17:04:29 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.019; Thu, 7 Oct 2021
 17:04:29 +0000
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
 <7c92218c-baec-a991-9d6b-af42dfabbad3@seco.com>
 <YVyfEOu+emsX/ERr@shell.armlinux.org.uk>
 <ddb81bf5-af74-1619-b083-0dba189a5061@seco.com>
 <YVzPgTAS0grKl6CN@shell.armlinux.org.uk>
 <YV7NHZRFZ9U3Xj8v@shell.armlinux.org.uk>
 <YV7Z/MF7geOp+JM2@shell.armlinux.org.uk>
 <YV8fCAkcIGY+yEmQ@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <1f7fb0a4-e830-7548-b4fc-8abf6f446f83@seco.com>
Date:   Thu, 7 Oct 2021 13:04:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YV8fCAkcIGY+yEmQ@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:208:256::25) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1PR13CA0020.namprd13.prod.outlook.com (2603:10b6:208:256::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Thu, 7 Oct 2021 17:04:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 251b59ea-a940-4017-4749-08d989b48636
X-MS-TrafficTypeDiagnostic: DB6PR0302MB2824:
X-Microsoft-Antispam-PRVS: <DB6PR0302MB28249D18ABE958AF1FEA2E0296B19@DB6PR0302MB2824.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LaZRq+decfYfR8aUtOYgzlZmm4DwoHVsbnTOVNFE7zRO3Rb71okI8ZdsSiGV//4hlr97ahbJuYT/sEvDJ4aCvsujEh5dHqcIOTFVIM6/dvV+oZcGBiw58SL372/yvLe1sS1FWcgGDJOt14JPR22h16wVMSTLmt5Ef1VmiO3Ume1wb9xlapY7Lag/GRc5eYoH/TkmKwVgxZxustHyvll9OjqM9A4izmguBJzVMPtYkdpcvNJy0SweHPg01zJ/rr4H8X4t9MRGH4ZH74R18il3+xRsOZmZdYkLayn5fTZWEByDvtrZ8XAZIdJqR/eUii6pbkbkn+J0VNj895O0czJhlOprnQZ6nvxjyIyMacb7Tq1i2Yg8BIlEXEea5VVW5oWaKmaqq4xpaiq9DFcEJN3VuvcGNLr4Lwjr8QjqBZjCgJJaMK9Lc0VfjrrryMLL1vk8E5uKdNOMd2LK/IKsHgdY+NjBRAMrA2nEdmVfEt4tkZyBrcSxwUGZCLcnc4XZsrTPTvJ6AzHthRaZyxPrVFh/jYQSzSUrVS5L7Oi0q6C04d9itUmxOEGg3sFdTW6n/s8GmrIuvLZPbxt8lIK9Lkig1u7AIF2NbBWuDwCqrJlFp1th1yxVwyR5UxkHdD+2Bv+y1Mix5zLL5ImeLhTvHuNudkZWsJRoOsJ22T+1fag3xLtxLOBa8nQO7oGch5JsQUtS1W8BQIytPqOfJ8L3Z+12y17UMXoQ0mhSp0sBa7zP7sBnQf7grMtH7yelyymSGu4XdI1KcFGSVlV9lw/RteB/28shG+lz8hVuTVUudyHVDdyEw99ktmqru2RULF8OL8c27sryT2G8nOPrInsNEZt79Lvs9vIrKCeeKPT6P95Ab+c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(956004)(38100700002)(31696002)(31686004)(86362001)(36756003)(6486002)(66946007)(83380400001)(6666004)(8676002)(6916009)(44832011)(5660300002)(66556008)(26005)(53546011)(66476007)(508600001)(16576012)(2906002)(52116002)(966005)(2616005)(54906003)(4326008)(186003)(316002)(38350700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3IrMCtaVUJoOGtlaEMzcWxoZzl0a1dQMDNFNlRjUWxNdEJ3clhwcmltQkYy?=
 =?utf-8?B?dGZWYURGM0lUS0dWU2wzekpBSTNZbkZuVjhPb1lwNytnOStmaTFiT2FGZHJ2?=
 =?utf-8?B?SVUzMUpEZi9RQzN1MnFhUmFlNnh0aXRyNkFXcG9SNXhxTTFVdENoN202NitK?=
 =?utf-8?B?cWQwSTBJcTBPbnQ2VWhJaDlqbitiMERvdEk0S3ZvNCt5SnRFK3RxK2JiVnF4?=
 =?utf-8?B?V0w4ckdJeVdrYzEzVmRlcnc4WWkrVU5ZUDY2TWIwQW5hMHAyMGVMUDV6eHVZ?=
 =?utf-8?B?TFptaCtWOTBCOThaa1B5bzk3RW4wN3k5NGV2dFNFRWtuYmpxdFJIUUZiaUN0?=
 =?utf-8?B?ZWJDVk9TRHZyVFZXVkdsbnpIald2MmJGS05US2VPa1VrK3hZV1VvbXhvWW1x?=
 =?utf-8?B?Sm16alE0elJSNnB1SS9LdGpLcGtuTGY2YWNpNVhhSHFzOHV1UlJuU2Z6bFZz?=
 =?utf-8?B?VHNxUVFEYnJWaUh0V3lOOVJVaWpuUnE0NUpHUXlWcGQ2NlFNeXVXbXM4MkJL?=
 =?utf-8?B?QzVWNVFmU3FuZVRueE9IdHdZZ3MzMEYza1JNYW1WVGtqUEQ0TVJCNmpXajJG?=
 =?utf-8?B?T09pOVQ1cENFR3J3TG1lOUpKdXFIWWtTdnN4ajJoZjhKNm9yQVd6T1M5ZUxY?=
 =?utf-8?B?enBlRWxQbkNsNHFQT2t0Q0pXYUg0eU43K0VvUEF5cUE0ZXBzMThRQ2I0dVkr?=
 =?utf-8?B?OE81L3J0ZW4yL0thOGo1RWZmU29OQlllSVpFZFBrVU5rQlkyOVY3cmowUmJD?=
 =?utf-8?B?N1RPaHBEalU3UVp1RUx5dStCQ2pIeXNXb1k1bFFUTkxIc2dyalo0eFA2dkpI?=
 =?utf-8?B?dUVDTzAzbXZienMyMWEwdzF0UWVDVm9iZ3pjTGZ1UW03Zi9XcFQzQVZwNDVv?=
 =?utf-8?B?bVFFUVFRSnJKVFRvUnc4Zm8yQ0ViTk1KUHZmVERNMENlNGxTZ2l1VXp0K2hC?=
 =?utf-8?B?QkZNSDdXZmc1VHp1TFYwdUx3dGIvckw4anVoY0NpZmZDaDFCMVRkWVRGem14?=
 =?utf-8?B?ZDFhUnRyVUZleHR6TGIyTm5pcllPdUNhQUFjUkZsRjZ3NThSWEkxd0kvWFcw?=
 =?utf-8?B?Sk9DRDlPNnJHOXVucEh2bjNpTS96bnQzbmNpdDloOGJzL3ZYNU9oYUh4bDR4?=
 =?utf-8?B?cy9ZZm5LS3hPcjQxMHMveFdJUHJ0ZVRrODI3TWZNQ1R1N2Mvb1U0c0ZmSGRm?=
 =?utf-8?B?T0YreFpIK0tpeDQvS2NKQlE1UHloUWk5THowYmVIbSt4ZitmZTAvRXdnNlRi?=
 =?utf-8?B?VWZVdXN3RWdxaUJuUnhoYUFDTHVqUi90TGw1RDVQNUw2bHYyaXcrUGVReW8z?=
 =?utf-8?B?THdIOUo2UkVvOUpYZXdWTlMvQlFpNU5Wdno3ajFCQlJVV25FVDQ0SCs0bERO?=
 =?utf-8?B?WDNscmIyVE8vMzNnNEVqZ1RRNXpuWXl2SUJSa0xvVmNMOFVSeXlmN0ZKZEk2?=
 =?utf-8?B?Ry9KZzZPWWxmd1JtV0xOVlJGdzQvQzJyUG93T254RHJSZlVkTFFnKzRmQ0Fq?=
 =?utf-8?B?c0FvY3NNeXpESXE1VHFkdlZjUTgvRkNYdlhTY3JMZkZhd2NHbG9jaktGQ3Fx?=
 =?utf-8?B?ckdONWlKbmFOdWRDRk52K3V1OVNEWWRodCtmNENmTkRwQ204Sk1HUU01MXJ0?=
 =?utf-8?B?YzU5cUpITWwxTGcwWmJ1NGQ5RFUxTWxIcDdlNVpMRktXWjArVWxwT3NiZW5p?=
 =?utf-8?B?YkR0ditBN3hVNUxRMEVrTTZzUUc1OFdtdGFTUm1VY0JSNDVSaTNQSlYwbzZW?=
 =?utf-8?Q?qoaCvmvBiVQGRpjjheRCVNH5uDh2yWVMnJKrodW?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 251b59ea-a940-4017-4749-08d989b48636
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 17:04:29.1007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +oPJKwz+Ys4QfPbwGce7e0Rs8QTjTWLX6IDl2WZm8hf+0ZYOK676HLhCvMw8F8KOqJJGZq7oqU/Por5p762v+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0302MB2824
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/21 12:23 PM, Russell King (Oracle) wrote:
> On Thu, Oct 07, 2021 at 12:29:00PM +0100, Russell King (Oracle) wrote:
>> Here's a patch which illustrates roughly what I'm thinking at the
>> moment - only build tested.
>> 
>> mac_select_pcs() should not ever fail in phylink_major_config() - that
>> would be a bug. I've hooked mac_select_pcs() also into the validate
>> function so we can catch problems there, but we will need to involve
>> the PCS in the interface selection for SFPs etc.
>> 
>> Note that mac_select_pcs() must be inconsequential - it's asking the
>> MAC which PCS it wishes to use for the interface mode.
>> 
>> I am still very much undecided whether we wish phylink to parse the
>> pcs-handle property and if present, override the MAC - I feel that
>> logic depends in the MAC driver, since a single PCS can be very
>> restrictive in terms of what interface modes are supportable. If the
>> MAC wishes pcs-handle to override its internal ones, then it can
>> always do:
>> 
>> 	if (port->external_pcs)
>> 		return port->external_pcs;
>> 
>> in its mac_select_pcs() implementation. This gives us a bit of future
>> flexibility.
>> 
>> If we parse pcs-handle in phylink, then if we end up with multiple PCS
>> to choose from, we then need to work out how to either allow the MAC
>> driver to tell phylink not to parse pcs-handle, or we need some way for
>> phylink to ask the MAC "these are the PCS I have, which one should I
>> use" which is yet another interface.
>> 
>> What I don't like about the patch is the need to query the PCS based on
>> interface - when we have a SFP plugged in, it may support multiple
>> interfaces. I think we still need the MAC to restrict what it returns
>> in its validate() method according to the group of PCS that it has
>> available for the SFP interface selection to work properly. Things in
>> this regard should become easier _if_ I can switch phylink over to
>> selecting interface based on phy_interface_t bitmaps rather than the
>> current bodge using ethtool link modes, but that needs changes to phylib
>> and all MAC drivers, otherwise we have to support two entirely separate
>> ways to select the interface mode.
>> 
>> My argument against that is... I'll end up converting the network
>> interfaces that I use to the new implementation, and the old version
>> will start to rot. I've already stopped testing phylink without a PCS
>> attached for this very reason. The more legacy code we keep, the worse
>> this problem becomes.
> 
> Having finished off the SFP side of the phy_interface_t bitmap
> (http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=net-queue)
> and I think the mac_select_pcs() approach will work.
> 
> See commit
> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=3e0d51c361f5191111af206e3ed024d4367fce78
> where we have a set of phy_interface_t to choose one from, and if
> we add PCS selection into that logic, the loop becomes:
> 
> static phy_interface_t phylink_select_interface(struct phylink *pl,
> 						const unsigned long *intf
> 						const char *intf_name)
> {
> 	phy_interface_t interface, intf;
> 
> 	...
> 
> 	interface = PHY_INTERFACE_MODE_NA;
> 	for (i = 0; i < ARRAY_SIZE(phylink_sfp_interface_preference); i++) {
> 		intf = phylink_sfp_interface_preference[i];
> 
> 		if (!test_bit(intf, u))
> 			continue;
> 
> 		pcs = pl->pcs;
> 		if (pl->mac_ops->mac_select_pcs) {
> 			pcs = pl->mac_ops->mac_select_pcs(pl->config, intf);
> 			if (!pcs)
> 				continue;
> 		}
> 
> 		if (pcs && !test_bit(intf, pcs->supported_interfaces))
> 			continue;
> 
> 		interface = intf;
> 		break;
> 	}
> 	...
> }
> 
> The alternative would be to move some of that logic into
> phylink_sfp_config_nophy(), and will mean knocking out bits from
> the mask supplied to phylink_select_interface() each time we select
> an interface mode that the PCS doesn't support... which sounds rather
> more yucky to me.
> 

With appropriate helper functions, I don't think we would need to have a
separate mac_select_pcs callback:

probe()
{
	priv->pl = phylink_create();
	priv->pcs1 = my_internal_pcs;
	priv->pcs2 = phylink_find_pcs();
}

validate()
{
	switch (state->interface) {
	case PHY_INTERFACE_MODE_NA:
	case PHY_INTERFACE_GMII:
		phylink_set(mask, 1000baseT_Full);
		phylink_set(mask, 1000baseX_Full);
		if (one)
			break;
		fallthrough;
	default:
		matched = phylink_set_pcs_modes(mask, priv->pcs1, state);
		matched ||= phylink_set_pcs_modes(mask, priv->pcs2, state);
		if (matched)
			break;
		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
		return;
	}
	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
}

prepare()
{
	switch (state->interface) {
	case PHY_INTERFACE_GMII:
		enable_gmii();
		break;
	default:
		if (phylink_attach_matching_pcs(priv->pl, priv->pcs1, state->interface)) {
			enable_internal_pcs();
			break;
		}
		if (phylink_attach_matching_pcs(priv->pl, priv->pcs2, state->interface)) {
			enable_external_pcs();
			break;	
		}
		BUG();
	}
}

int phylink_set_interface_mode(mask, iface)
{
	/* switch statement from phylink_parse_mode here */
}

bool phylink_set_pcs_modes(mask, pcs, state)
{
	if (state->interface != PHY_INTERFACE_MODE_NA) {
		if (!test_bit(state->interface, pcs->supported_interfaces))
			return false;
		phylink_set_interface_mode(mask, state->interface);
		return true;
	}
	
	for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++) {
		if (test_bit(i, pcs->supported_interfaces))
			phylink_set_interface_mode(mask, state->interface);
	}
	return true;
}

bool phylink_attach_matching_pcs(pl, pcs, iface)
{
	if (!test_bit(iface, pcs->supported_interfaces))
		return false;
	phylink_set_pcs(pl, pcs);
	return true;
}

I think this has some advantages over a separate mac_select_pcs():

- In validate() you get all the available interfaces.
- The MAC can set the priority of its PCSs however it likes, which is
   probably good enough for almost every case.
- The MAC doesn't care about what interfaces the PCSs actually support.
- phylink can do whatever logic it wants for selection under the hood.
- From phylink's POV, drivers behave the same way no matter whether they
   use these helpers or whether they just say "If we use SGMII, then use
   our internal PCS)".

--Sean
