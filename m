Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118724436A4
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 20:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhKBTs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 15:48:57 -0400
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:52865
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229813AbhKBTs4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 15:48:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=duxKEaYoTsoL19A0aq4HnSLQRgDUctg4G2bV225sPYNSwrmalUddPiJ9UG/ufTmodmpywcWnLyNTm8VoTMQ9H2ucy/K6mnO+6VKj4suB4oVqwYoyR+WXzH5EQiVNGxPw/S9RM7yHs4YCkY86mYXvYJ/AWu8i9hRhYQyTexGkCc39DGT2MuA4VGsKy+kj45ukvXiIA205rJg1bueToGvffj3sSBnmduZdVWW75NuVcSQQjSQSSWGhMU4M1zQ1qBQfZYe/nJHE9HICDJH+FRD1v9BxPNeKXiw46k7YDpNOCeIA+RtENL5NuXaJLAriSoPFXuigU058qv6vEzprPETuQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsMYHXHkHO1UqAQtpCZOAmvD0N+kNV//6mEqHIGyvMQ=;
 b=nDrHB4IEM9rFhwLT7+RLvyy0deP6LUDacvx18j8lo5+yrrzLxvGHfJTMu8287xs0X9hNIU7YYnMJkH3U9DYJ6MDUjc9+O9xLK4fJY1oSgRszv0KM8VDj8RI03T7Uk+SyROAldyrjwrpM/c9I4giCyH8pYVhNPnuk2w4mps3e3orbvqkK3RPtvuvXxNPCigVt0SzAS1OOsr90NugTj3SeaxtBz610NtItZg7fDSrahwYDHwaekOYVxUR3nNQT1SyGfALUZBcyStIqszqpcs9KEHLOjrRTj2BzBqC7hMW6XH053+K81fyouts0vUtAmiY9wSifjhEbKUBBmiywTlRQag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsMYHXHkHO1UqAQtpCZOAmvD0N+kNV//6mEqHIGyvMQ=;
 b=rlgBwr2ICgGe4hNCDUh28dQMqO8G/lb9a40vcbDh8ZfAi7y7lqkJDSJPqstSbowfTTpPsZNV4otVrl60/hfz438WIxD4KrdTHFzH6slEsk4k7j7YMGmu46WknTC25XV+WNc5CeQTYFf1ZLrT29dhX6Jljcxb5wAUhdOsbcH561I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB5368.eurprd03.prod.outlook.com (2603:10a6:10:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 2 Nov
 2021 19:46:18 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4649.019; Tue, 2 Nov 2021
 19:46:18 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch> <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
 <YYCLJnY52MoYfxD8@lunn.ch> <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
 <YYFx0YJ2KlDhbfQB@lunn.ch>
Message-ID: <ff601233-0b54-b0ad-37ce-1c18f0b7ca47@seco.com>
Date:   Tue, 2 Nov 2021 15:46:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YYFx0YJ2KlDhbfQB@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:208:236::14) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR05CA0045.namprd05.prod.outlook.com (2603:10b6:208:236::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4 via Frontend Transport; Tue, 2 Nov 2021 19:46:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b49181a1-5775-4221-4436-08d99e397074
X-MS-TrafficTypeDiagnostic: DBBPR03MB5368:
X-Microsoft-Antispam-PRVS: <DBBPR03MB5368FED0599714609EAB836B968B9@DBBPR03MB5368.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yQ9FIbX8DMuowuC1PbCxwpiGDXRLrXRH3uggLaCkcsKrtSoaEiLtYEG5K4Ua1m/Z+Rhg8dUxbEDmWKEVMEEbEHvG2pr7OeMjkLItGGZP0zfyY3jPQH6EPMqbLOEVfHQgHuirGTjR8H8ovRCXqqXoze5ctmY9helKBkyG5qwds3XAyOVMMiF8A8lToCzpGhnp9VQjxb9JbCvjGmK2/I/qWwtASO0Nat9xxAMJozr3EEswZssrUEiA1FsJkO0erUsRnoFzqE5z4WwOU2PEfzmPaPzussbQ1Xq4UW6H8jR/oeD31AlY0Zec0aDZXveqr3OF71xUoDOwby+CaXrYav4UfirF6tkAP0u9BcIdV8u6oYJXFHj3BZ09zyUxMzu3u3pRtf+L1afa/ZV0vksZU2i0zVJrMVITTSQJFrD3mU7BB938UC4MRTm+8eOCRXFphKO3GTcB3uahAJ+/OOivYDpSrUxVP44RAXvtvTA9BSoub/0TWjQ2xnjsxNSNt+yQxI3RTJ9yUMMJTv9t4eDydBPjJsHAlkbS/LEQSj9wMrhRCzQZ7g1giv51SYW+Pqdg6hHsTuW0j5Bw2/EOFnrIzmDjaat+6EQguBsNPe8hUZUxmeVVIQ33M+i3PUceaNNAMxUQPjq6lvmbDFfbugQz2g6XH+vOnoGCKUbsjyQ7N99F3RQMRdOFd5lJyA4rGakvmUqo1otD4KnSHSP/VPONEqWTP8vEs+t53flC/qEpDXFTst5rkiu50DKaDwcXec61q3yeG/nCUTYNMwx171TNDfTo81fFDt1Byz7whtm2nhXyKsrYgzK3k/VprFNfXXfq0V4a7NYLnm1YMsZ2KazWM+ed0A5WcVZtxmZO6zLn/fiM7uE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(36756003)(38100700002)(38350700002)(26005)(8936002)(316002)(2906002)(83380400001)(31696002)(7416002)(8676002)(86362001)(53546011)(4326008)(508600001)(31686004)(956004)(966005)(110136005)(66476007)(66556008)(44832011)(66946007)(54906003)(186003)(6486002)(6666004)(5660300002)(2616005)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXB5RkZKRmVGMUJoYjhWeU1tQXZhdTdyK29jZWgvTTc5KzZVKzd0RGhzMUIz?=
 =?utf-8?B?SDUrelJsSVlHL0lyU2RCQ3lVdWxodlZaY3lxUzRmMVpnUTJtRndZZjU1ZXRC?=
 =?utf-8?B?SWE5cXNDbU1WUXR0clJ4WTdUQkJIWURQRjMvTUljZDAxajU1V3pnV3V2ckdo?=
 =?utf-8?B?dEl5MStjWmNSb1ljamxnUkhCSVd0TWYvVTBqN1JPZGY4by9yWXdrdFRwWGtR?=
 =?utf-8?B?akRURE9Ga3FMSm9nNlpyd2pNdTRSdmRSTXN4U00zTzdFc3BLdSt6RSsrVFdr?=
 =?utf-8?B?a1VMcGJpSVB3b3VpNnZEcUZWa3JkUkNpelg3NHpHRTFDdkR0Y2s1anNyTjgy?=
 =?utf-8?B?K2Z1d0wzMXF1dkVCbkd1aEVzdmVTVVc3SU5NaU9SMDM5T2dXY0dTQkdmMyt3?=
 =?utf-8?B?TXFGSnlGQ3NqcDMwZWYzYkVNM0QzZGRseTQwTmlZV0RDdHQ2VDlSZjVqUjZs?=
 =?utf-8?B?QjFRNW85NDQ2RSszeGVSMWsxbC9LK2txcUdIU0tjcUhLanZRc2VOaUtHdStw?=
 =?utf-8?B?a29RM3N5NXZuM2ZzTTlhT1FVUXUyZFgrZGh6dDNxWmgvWW4rNE9nOWc2aEcy?=
 =?utf-8?B?cmJmMnhFQnFkcVYrNGpTMlJtK2QxSFFTLzI1MUwrRHhCUnpMckxXaGRVcHdv?=
 =?utf-8?B?QXdrdEY0UUkwR3U1bVR2cUFCVkM1R2xWckNFRWxORHJ4UjRiYWdKZTBQQXdY?=
 =?utf-8?B?Z2pWKzErWC9JNFJnaWlGUXJ0WUdLa1JPRlExYVVSYmhJVWlHSFJYNkdsM3Ix?=
 =?utf-8?B?VmN1dlc3UkZaMktPR2ZEZG84YUdHMnFYUUQrODJMYmtaWkhHSDF1SHk3UExp?=
 =?utf-8?B?NnFTZG1KUml3WHBVdmVGVU55WlV0ZHVGVFRJTEFmNUNXVDEraHF4NzVlYk50?=
 =?utf-8?B?NDRwSTZzOUtIK2xoNmxQZU1ZUE1rYksxQnVwZHJEYTNRdUE3RlprUG1PR0M1?=
 =?utf-8?B?ZnVrZ0FxblpkN0pOZ0hMK0xicW9SUW00NlhRdm1Vd3BEY01aaXp0QjAwdVpG?=
 =?utf-8?B?ZFFSdE84RGtRSDMzV3hjUW16endnVnNNU3hrcVpuYnh4bEdScTdhUUUwd1NR?=
 =?utf-8?B?aTJXT0NBU1RsM2J2YlppZm1MYWk4U21CM004S2lnS1h4T0xjTEZuaHVPTWsz?=
 =?utf-8?B?cC9WRC80dDlKR0JRY3ZOankwSDVrK09VOFVRNTlKZks1Ri8xRzQ1RWFhSjNv?=
 =?utf-8?B?Z0dZU2NFdkNNUkRZN2w1cUs4YzdPbUFPT2dDR1VSK05GM1N5d0ozbUsxTFhk?=
 =?utf-8?B?VzJrQ1lLQm04dEV6NThnOGgzWmM4SjBCWHFINmMrZW9XRWM4VFd3SzF6bVky?=
 =?utf-8?B?ajBVdVc1UDB4SW4xdS9RczFEMGFCNGgxY0JrNmthOGxKUHMvY0h0N3NhRnY1?=
 =?utf-8?B?NVNhaVNmUC9mY0xOUkJvREtSSUlWQUtWc3dOVEZULzJKTTM2RWVBUXRBL0RB?=
 =?utf-8?B?ZXdsTGF6eDlEa0NHcitPNzVJSSszZEVMQ1F3aElwK0g3TjN0MzJtSlRyYk5x?=
 =?utf-8?B?TW1PcVZpV2txQjZvaWwvK2hMeWEybnEwc1YxdW1WV0JnbWNkMWdTTzNKQ1hJ?=
 =?utf-8?B?K01FU0tBbWRReE8yamxRc3BGaWJFSUZDV3lxcnlrSDZkR2s5SzBTQUowb0tS?=
 =?utf-8?B?Z1hnMFNTMUhzRXVMN3IzZUhpTGxHMTU0VFplYjlsQS90anUwZnBxdWVML3Jo?=
 =?utf-8?B?QkRQVEVoUVlLUEpvMk9jMmFwLzhaaGhsSmpaZDFmSFFnWEQ0UVNJZ1VNMjJr?=
 =?utf-8?B?Q1ltMDFvTEwrN3RvSldGSEFQRStUL1h2aFcrOWJUSEdUeFloUEpIRVB4TTZN?=
 =?utf-8?B?eDZidzRDQlhHTVM1NlNHS3dEbHprRXQzdTZ0WU41TW9idUQzalkvamgxanJC?=
 =?utf-8?B?UEtxNGhSZm12ak5hKzFjNjU0ZVk1VjZXZFlRVHpMUy8xSmtBOWFGVzNiRnB3?=
 =?utf-8?B?aDczRlFNQm8xQlB4WE5tellVR3d4Q0h3ME1mbVNEWDJyUkNsZUdvUmVENVJY?=
 =?utf-8?B?MGJrdmYyRC92elJrSE5IbTRsNHM2cGlmQytqVWR3bUI4Y3h0QlRCRngxSWxK?=
 =?utf-8?B?RG1lWXZxMWhGTi8rcnYwc1gwa2RpTzVDRWUza3JqVFVEMlVwQUFCN2RlTkJq?=
 =?utf-8?B?NTZSRHhjeU1mUEhIcmVsNjdFcm5ZMEYvVXlsUGdrNk8rVkZPWmtEdHc5UDl2?=
 =?utf-8?Q?sWg0GxpKPNmA5+EqjlSbjGM=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b49181a1-5775-4221-4436-08d99e397074
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 19:46:18.7417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QaB14L+1i7qXv5M2AWfmli/01aetH3pvdN1kwnnwT9fng2ufQ4MzuPOgzxUfJiXp+NkZCjBEv51jenGV+tClIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5368
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/21 1:13 PM, Andrew Lunn wrote:
> On Tue, Nov 02, 2021 at 12:39:52PM +0000, Russell King (Oracle) wrote:
>> On Tue, Nov 02, 2021 at 01:49:42AM +0100, Andrew Lunn wrote:
>> > > The use of the indirect registers is specific to PHYs, and we already
>> > > know that various PHYs don't support indirect access, and some emulate
>> > > access to the EEE registers - both of which are handled at the PHY
>> > > driver level.
>> >
>> > That is actually an interesting point. Should the ioctl call actually
>> > use the PHY driver read_mmd and write_mmd? Or should it go direct to
>> > the bus? realtek uses MII_MMD_DATA for something to do with suspend,
>> > and hence it uses genphy_write_mmd_unsupported(), or it has its own
>> > function emulating MMD operations.
>> >
>> > So maybe the ioctl handler actually needs to use __phy_read_mmd() if
>> > there is a phy at the address, rather than go direct to the bus?
>> >
>> > Or maybe we should just say no, you should do this all from userspace,
>> > by implementing C45 over C22 in userspace, the ioctl allows that, the
>> > kernel does not need to be involved.
>>
>> Yes and no. There's a problem accessing anything that involves some kind
>> of indirect or paged access with the current API - you can only do one
>> access under the bus lock at a time, which makes the whole thing
>> unreliable. We've accepted that unreliability on the grounds that this
>> interface is for debugging only, so if it does go wrong, you get to keep
>> all the pieces!
>
> Agreed.
>
>> That said, the MII ioctls are designed to be a bus level thing - you can
>> address anything on the MII bus with them. Pushing the ioctl up to the
>> PHY layer means we need to find the right phy device to operate on. What
>> if we attempt a C45 access at an address that there isn't a phy device?
>
> Yes, i think we need to keep with, this API is for MDIO bus access. If
> you want to do C45 over C22, you need to do it in user space, since
> that builds on top of basic MDIO bus accesses.
>
>> Personally, my feeling would be that if we want to solve this, we need
>> to solve this properly - we need to revise the interface so it's
>> possible to request the kernel to perform a group of MII operations, so
>> that userspace can safely access any paged/indirect register. With that
>> solved, there will be no issue with requiring userspace to know what
>> it's doing with indirect C45 accesses.
>
> I'm against that. It opens up an API to allow user space drivers,
> which i have always pushed back against. The current API is good
> enough you can use it for debug, but at the same time it is
> sufficiently broken that anybody trying to do user space drivers over
> it is asking for trouble. That seems like a good balance to me.

I have not found this to be the case. As soon as you need to access
something using phylink, the emulated registers make the ioctls useless
(especially because there may be multiple phy-like devices for one
interface).

Currently, I use [1] to debug phys without having to worry about what
phylink is trying to simulate. I would much prefer something like what
regmap does: reads are allowed through debugfs, but writes require
editing the kernel source. This allows useful debugging, while making
zero-edit userspace drivers impossible.

And fundamentally, you can always load a module which lets you do your
driver development from userspace anyway (as [1] demonstrates, though I
personally compile it in). I don't really understand why we have to have
worse debug tools to prevent something which is trivial to implement
anyway.

--Sean

[1] https://github.com/wkz/mdio-tools
