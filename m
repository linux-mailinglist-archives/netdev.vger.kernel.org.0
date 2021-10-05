Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECF14232FD
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 23:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbhJEVqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 17:46:11 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:49643
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236600AbhJEVqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 17:46:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ia91+ttLmcuqdTg0Zp7joWvPLafDvDn3Oba7GTBoOq76TbOdz4aDmGx8YyeLmjMWrpcoGCUTTuOuES/Uh1pSqgAIt7cNkjpk5fRCnU3GIcn6dCJHyD2wet0WSaJNc4uJ+5g3IvcRXYC/wf0tP32oOHYH4KRiotvqXJUwFTnY0NcDPBrgmWjvfa/mi7YWdvrmvwAKo1TG3NsbubApVJ9dAkGJbSfYY5OGP7A6jmNysIJKrTXDFFgFF/UUmE7fmyffP0BRkZ7bY+SH4X59Sm8yJIGlmHbHiM8rgnOPYOYq6rZJFffiFtppniGaA/+OhvWU3lyh+SKshGvJYyILVToA6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rq68mG1bipaaGcvTdsMSVGccPcAmJhflzvQpTOWucuY=;
 b=AE7/qefwhnCo9wY4GCRvE+lBaTllApKbl0XhLSaO1JnONTgl9Sn88e6YmxUuM7GyBGFLeM7ZedjWfSH+12IEhEmzpLzxV45AeksLqxZesbXIvbM6eBKjucfo5Jleipz7aLiGNKSpHnHuB/4HSCMq8pwVJ9Ae7BKgXK45vnP4lfHUf8ftKMr2/xoy592+qFM84YoJKIvzmtKqQ/iVXG9Xm41Ciu3B+CErnHcDgYd+KdpEs/v0IMbx+XeZeCKyUFVYruW/qs+T3dYz7f6jlO4QhiCbGzSUL6Tywuiq3KFMvIl4gZRSy0C99vBskfdvtgMwyGPVU/JDIy4qJC3nEc3E9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rq68mG1bipaaGcvTdsMSVGccPcAmJhflzvQpTOWucuY=;
 b=mMRf5rTjoPkeHkLaP9XZtJruqaUW6HlRA2fgLh+qEjtD+mqfcP1GQ5Zdt3zjm3Q/kPflZXt6GE+xJtKnr5yS1tXe79CFXbmTbyR5DhxqEh1+RtrUqk6pR1ChQ0hlB75AVXOoB8xxSSA2caRE7VQvBfFyQgZPF+K+ljFl4l2KMx0=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7515.eurprd03.prod.outlook.com (2603:10a6:10:22a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.21; Tue, 5 Oct
 2021 21:44:17 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 21:44:17 +0000
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
 <7c92218c-baec-a991-9d6b-af42dfabbad3@seco.com>
 <YVyfEOu+emsX/ERr@shell.armlinux.org.uk>
Message-ID: <ddb81bf5-af74-1619-b083-0dba189a5061@seco.com>
Date:   Tue, 5 Oct 2021 17:44:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YVyfEOu+emsX/ERr@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0005.namprd11.prod.outlook.com
 (2603:10b6:208:23b::10) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR11CA0005.namprd11.prod.outlook.com (2603:10b6:208:23b::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 21:44:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21bc7b8c-ecb7-42b4-8d6f-08d9884947ed
X-MS-TrafficTypeDiagnostic: DB9PR03MB7515:
X-Microsoft-Antispam-PRVS: <DB9PR03MB7515933E7A8200716E1B428596AF9@DB9PR03MB7515.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qqWbVsXgQZe7pUmV76dYy4xSouwBYv2ngHTrkIV7IZiXey4fJPakQxux2wKzz1w0DNau+HYkRlD08BzwETYVgfTm/kBhC12DJUfOb1M0KcTmg6Cyc6k3O0/XVdephanJCXfomm1uWOLaud5u9bqnnAi4vITh7VqCzarHImAhWcDve4hFpaikg4aFf7kX1Cv6KG5PiUfKGTfzwx46nE0ytqb0FWVOQXGUKHQ4JV40BczXmCl+Dun05VPpFqCNoO5y+cjTAX/dcji7BTduD/QyTTSed6NvaMKsgQfPIY4SK41rA5CZYwxH3bHGAW27zDneAzSEuEw51V5wo15BLScNhkcw1STnfj0tz2p2k/3SYvQv/rRkCHLXiWr+IvRk4EQeoKye2FWDk0SgiTSnmk4MvwBaGgHd6qD4L3zHG2dXZi82ip4xmEymPyJQyJg+n5vKNYAoaXdOzAqzAjLY4kuo27Tk7JMDUmL9CVhEb+qtLv7TnHjHWlJPUO245aXT5DrOPgOh+lqYA37OpcAZDBE2gFj+eQW/J9kyQpnYTe+cF8JdW6hSL1j0Vk1wUm1/3EgezhCCbDF/XfZzJeuUHF6gDCTnD1kVjULHFnwP6AcRGb2XR5iabLg/mePw1Z5KOI9IgtEE1fcd+wJQp0Xv+IqirWGSwWZRZmSs8tOvRb9Ba5dlBth/PdkoC/WYqrCAbENkAA303R12LA89MRhY3VVbMIODY6nY/3kvCfsGft5Zc0dbRkiMxJ/Oi7KJm1K1+xLML4ooAPgULemul8NJPnB9NR88MprNq0yFdPxcQC/E67S6gc5H0Rq3SJWDMf1TS+XZT2coVH+5xw9/z2F/vXmHR9407STA8sUhBk1QKaUwZU/my7MnQ0t+ZeJgaAXiUyCT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(6666004)(6486002)(5660300002)(956004)(31686004)(186003)(83380400001)(26005)(36756003)(8936002)(66556008)(66476007)(8676002)(38350700002)(38100700002)(66946007)(316002)(44832011)(16576012)(31696002)(53546011)(86362001)(54906003)(6916009)(966005)(508600001)(2906002)(4326008)(52116002)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0g0ZkFWLy92V014VkFzT0F3STJyY2pIUGFGKzJxYmtKUENWcUdYRDRWY2hK?=
 =?utf-8?B?MnVQTXZnSU1WMnZZVVQ5TGlJVHlSeUR3VFdrK2pUTVBEVEo3c1RSKzhxQU15?=
 =?utf-8?B?ZzVkajE2bFg3dDhrOFRUUklZUFZaYTJLV3UzT094OFBCTVdpUlowcktEcGh0?=
 =?utf-8?B?NzRsRG01cVN0QmdqaGo2Yy8zcjVnSXg2ZUVlMFVVa3ZTb1l0SGoxaWVXTG51?=
 =?utf-8?B?NDVmNytMOFRwMFp1azc3WnNYYUY4cUZrTk0zTUpraHJGSHp3YkFiNGh0VXU2?=
 =?utf-8?B?QU9aUlJ3ODJRSkNISEZ6NVZCbkN3eU5JdXAzK3lkOUNOZ00rbWhHKzQrcmRs?=
 =?utf-8?B?aVhXUGE0WnJtTmpBUUtuZ2pDYnZadHR6MFJxdXh5NzIzaE9hSDZwbi9KaEVY?=
 =?utf-8?B?ak1ZdmIzaWNDWnJQMHE4SGpTWjJJejQxNEhrbVB6N2NTdE1vdDJOSEt5UmZ0?=
 =?utf-8?B?V2p1UWowOVdUYWtCSEtXSmNpTHZORDY0djdoVmpIaFRoYzN0NmZRV0IzUStR?=
 =?utf-8?B?UWVVR1pBSVptclJWK0x4Nm9SZjNTWVZLVHhYa1NaY0d1dVdtTk14eURuY3NZ?=
 =?utf-8?B?TmVPTkNNeWYrNlFUZVplU0FlZ3pCU21RdjBVU1F6aTg0dkNkRmNpQ0JmZVNU?=
 =?utf-8?B?emE5WFkxQ2w5T05UQU5iU0NpNTdvR05HT0FyUER5eThzSzBoYTBhd1B1YWx5?=
 =?utf-8?B?M05ld3ZxSEtQQzRKNm1OWlZoNVZXY25CcjVEa0hGdk9oS2NtWUIxSkN0cTRM?=
 =?utf-8?B?a1B0WmFpaWhweVNHekNQMldhbW9qVE1raTYzdkV5Y0RKUE5ERXVKVll3KzJT?=
 =?utf-8?B?ODFHRGdSZDJNRFpZeHQzR0RKTXpwWG5YOE9XUDRQbkNBT2tiaE82YWd2d25h?=
 =?utf-8?B?N0FSd0dFVkJNK2l3MXBHVklMWVZaR2FZY2xiL1AvL2U1b1VtUzVxWkpWWVhI?=
 =?utf-8?B?bm5xMCthS05lK2hvSXlrYVFXbHZWR2pSMm8wZVFwNHY1ZDlHa3dHQUFsQytY?=
 =?utf-8?B?VU1iRVljTzBRUm1mNmpBRTZ1c0Y4Qk1KMktzUW83ekI1S2hwbmhVU093Zm1Z?=
 =?utf-8?B?bWRDaUZoK2NaNkZiNk9xcmlpSG80Z1BnQXBTYXBwY1dwK3lRdFJqWXcrR0U1?=
 =?utf-8?B?a01uRExyVDd3N3FNdm1iTnlzL203MnplYzBBR2g4MU9uc0hVdUJnd0FDQjFZ?=
 =?utf-8?B?aStNRExyQnVxQUNMWGZDblhhOEZFcDhST0VoVjZBUE05QUpkYU1ITXpYWDZR?=
 =?utf-8?B?RlJCakF0dlpiSUZBbytyNmhjRFNoT2pCVk9uajZNS1lLaWFSVStpYWRxakxM?=
 =?utf-8?B?YU8yOFZYOFVZSVF3TVpLRlR4M29ZU040ZERva3lMUjZBSm1uSEUzYXhyaFRn?=
 =?utf-8?B?SWpxeUEvVmk1MkhJTkNGdGZYbVpvTUh3cFFmM2s5R29wTU9nNjFSdzFlUW53?=
 =?utf-8?B?bWk4V2M0aWpObFVOYkU3bTZlYVNpZHRGK2xDUGRqYnVTQ2NIWXFHMmRDSldC?=
 =?utf-8?B?Y0pBSklCS2VaSm16VkViMkpVTFF5dUtQcktaTjRGbWIxdFI4WS9WaGdQbVhB?=
 =?utf-8?B?dW1yQVJSZ21sYWhQbnF4TFRpeXo5akZXbm9Ib1IybGNSTysxZWVScDlmNHRW?=
 =?utf-8?B?T2U2bitSMCt3L0MvQlBRQnpRaEJzQnhTSXFBb3dKWFdNQzEvb3VGbjBvb1RX?=
 =?utf-8?B?bDl0OXFrT2hRSlNyeElGZjJWaE1LWmRQbGxwanlESkgrNWVpc3VCWVQwMjVW?=
 =?utf-8?Q?iIzm3boe9MRfM+ciya0FRv5660uYDRadJMqClrw?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21bc7b8c-ecb7-42b4-8d6f-08d9884947ed
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 21:44:17.1943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXmPLo/G/JvpHQfSkADf8sRlMinEwN7m725yQg/T0DnCkvzp9ELfvRRTMPuHWo3uGWsXW7lP4I8SYB/nw8/ZqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7515
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/21 2:53 PM, Russell King (Oracle) wrote:
> On Tue, Oct 05, 2021 at 12:03:50PM -0400, Sean Anderson wrote:
>> Hi Russell,
>>
>> On 10/5/21 6:06 AM, Russell King (Oracle) wrote:
>> > On Mon, Oct 04, 2021 at 03:15:21PM -0400, Sean Anderson wrote:
>> > > +static void macb_pcs_get_state(struct phylink_pcs *pcs,
>> > > +			       struct phylink_link_state *state)
>> > > +{
>> > > +	struct macb *bp = pcs_to_macb(pcs);
>> > > +
>> > > +	if (gem_readl(bp, NCFGR) & GEM_BIT(SGMIIEN))
>> > > +		state->interface = PHY_INTERFACE_MODE_SGMII;
>> > > +	else
>> > > +		state->interface = PHY_INTERFACE_MODE_1000BASEX;
>> >
>> > There is no requirement to set state->interface here. Phylink doesn't
>> > cater for interface changes when reading the state. As documented,
>> > phylink will set state->interface already before calling this function
>> > to indicate what interface mode it is currently expecting from the
>> > hardware.
>>
>> Ok, so instead I should be doing something like
>>
>> if (gem_readl(bp, NCFGR) & GEM_BIT(SGMIIEN))
>> 	interface = PHY_INTERFACE_MODE_SGMII;
>> else
>> 	interface = PHY_INTERFACE_MODE_1000BASEX;
>>
>> if (interface != state->interface) {
>> 	state->link = 0;
>> 	return;
>> }
>
> Why would it be different? If we've called the pcs_config method to
> set the interface to one mode, why would it change?

config() does not always come before get_state due to (e.g.)
phylink_ethtool_ksettings_get. Though in that instance, state->interface
is not read. And of course this ordering isn't documented.

That being said, I will just do

if (interface != PHY_INTERFACE_MODE_SGMII ||
     interface != PHY_INTERFACE_MODE_1000BASEX) {
	state->link = 0;
	return;
}

for next time.

>> > There has been the suggestion that we should allow in-band AN to be
>> > disabled in 1000base-X if we're in in-band mode according to the
>> > ethtool state.
>>
>> This logic is taken from phylink_mii_c22_pcs_config. Maybe I should add
>> another _encode variant? I hadn't done this here because the logic was
>> only one if statement.
>>
>> > I have a patch that adds that.
>>
>> Have you posted it?
>
> I haven't - it is a patch from Robert Hancock, "net: phylink: Support
> disabling autonegotiation for PCS". I've had it in my tree for a while,
> but I do want to make some changes to it before re-posting.

(for those following along this is [1])

OK. I'll add an _encode variant for this function in the next revision then.

[1] https://lore.kernel.org/netdev/20210630174927.1077249-1-robert.hancock@calian.com/

>> > You can't actually abort at this point - phylink will print the error
>> > and carry on regardless. The checking is all done via the validate()
>> > callback and if that indicates the interface mode is acceptable, then
>> > it should be accepted.
>>
>> Ok, so where can the PCS NAK an interface? This is the only callback
>> which has a return code, so I assumed this was the correct place to say
>> "no, we don't support this." This is what lynx_pcs_config does as well.
>
> At the moment, the PCS doesn't get to NAK an inappropriate interface.
> That's currently the job of the MAC's validate callback with the
> assumtion that the MAC knows what interfaces are supportable.

Which is a rather silly assumption because then you have to update the
MAC's validate function every time you add a new PCS. And this gets
messy rather fast. For example, you might want to connect your SFP
module to a MAC which only has an RGMII interface. So you put a DP83869
on your board connected like

MAC <--RGMII--> DP83869 <--SGMII--> SFP

For the moment, I think you have to just pretend that the DP83869 is the
only PHY in the system and hope that you don't need to talk to the SFP's
PHY. But if you want to use the DP83869 as a PCS, then you need to
update the MAC's validate() to allow SGMII, even though the MAC doesn't
support that without an external converter.

In an ideal world, the MAC would select its interface based on the PCS
(or lack of one), and the PCS would validate the interface mode. But of
course, there may be multiple PCSs available, so it is not so easy.

(Selecting between multiple PCSs (or no PCS at all) seems to be similar
in spirit to the PORT_XXX settings)

> Trying to do it later, once the configuration has been worked out can
> _only_ lead to a failure of some kind - in many paths, there is no way
> to report the problem except by printing a message into the kernel log.
>
> For example, by the time we reach pcs_config(), we've already prepared
> the MAC for a change to the interface, we've told the MAC to configure
> for that interface. Now the PCS rejects it - we have no record of the
> old configuration to restore. Even if we had a way to restore it, then
> we could return an error to the user - but the user doesn't get to
> control the interface themselves. If it was the result of a PHY changing
> its interface, then what - we can only log an error to the kernel log.
> If it's the result of a SFP being plugged in, we have no way to
> renegotiate.
>
> pcs_config() is too late to be making decisions about whether the
> requested configuration is acceptable or not. It needs to be done as
> part of the validation step.

Well, if these are the constraints, then IMO the PCS must have its own
validate() callback. Otherwise there is no way to tell a MAC that (for
example) supports both SGMII and 1000BASE-X that the PCS only supports
1000BASE-X. As another example, the MAC could support half duplex, but
the PCS might only suppport full duplex.

> However, the validation step is not purely just validation, but it's
> negotiation too for SFPs to be able to work out what interface mode
> they should use in combination with the support that the MAC/PCS
> offers.
>
> I do feel that the implementation around the validation/selection of
> interface for SFP etc is starting to creak, and I've some patches that
> introduce a bitmap of interface types that are supported by the various
> components. I haven't had the motivation to finish that off as my last
> attempt at making a phylink API change was not pleasant in terms of
> either help updating network drivers or getting patches tested. So I
> now try to avoid phylink API changes at all cost.
>
> People have whinged that phylink's API changes too quickly... I'm
> guessing we're now going to get other people arguing that it needs
> change to fix issues like this...

I think it should change, and I can help test things out on my own
setup, for whatever that's worth.

At the very least, it should be clearer what things are allowed to fail
for what reasons. Several callbacks are void when things can fail under
the hood (e.g. link_up or an_restart). And the API seems to have been
primarily designed around PCSs which are tightly-coupled to their MACs.

--Sean
