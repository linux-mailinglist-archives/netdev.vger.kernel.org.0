Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6C9445603
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 16:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhKDPI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 11:08:29 -0400
Received: from mail-eopbgr80083.outbound.protection.outlook.com ([40.107.8.83]:24577
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231248AbhKDPI2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 11:08:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJiFvLlK5YO7Ubz4vs9AcSgxNaqyK84u3toivVkjgJW3zgjLKXgazogc8+TWc4lKWVZ7ITy0sNsabW4LMNeoi+YcYqIFAkg59YfBbW06+++fTGMn0PqGS+VAVNLcmtiY6arN2tju3fgT9oDR2WPPFmceSBk5zNAAswJdaBX71j8PgJ31WRBjNDMUU8gD5JGROaLSH0b42T5ZvBNRfLu+E9ClE1f2Kt8iiy6lhuOTyBbWDQ5/gW8orscU3rzbUhZjyujDxctATgq4siHlxLwHmCj0HUt8i7jRgW+xKTw1CWrX1dPGbfppjQG3NkFyc7uYPmNQNFMLCfhLc6hGB4a2Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6AdRzp5z1BwBqY96xcLAr3PzQWh0CDpGpfhTPs7UHWE=;
 b=NWoB+2Zsf0IzSJOGC8Gt5JA2lrCqd27JRP27DYxTGuribDOQtG5EoU3/VlghLb/6B6r52Ouvhe6m1RL8mYYgIV5TX1o4IftHgH+qKW9GFKR0Rm1olRGn0Zeu8auuVZ9JxrrAUHNVfdfkxjjQsn5vIi/qbvb76oO3whz1M9C7SIttOyyxWlSTzMPrdleuvGQXDYQwK4DAcfnMnOjf0tfpf88OU6IQzyXb7b1X1SPPzneUFE8eZi8jp0eBUGe9j7jkUwFVgAJovfu6CVPNAeFbMdm7WACUY569YjOcacn5CVkPo6Gp2/hrSwPsrFE2WzVr43PvyRDPjY9OLEDq4C8/oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AdRzp5z1BwBqY96xcLAr3PzQWh0CDpGpfhTPs7UHWE=;
 b=kkr8Im62PBjXF2Q2ebLJh5vozui6r3u+shqfUIghQt7RiOhPnZ5oTL6gGOcM7qGeO/VqcpqmLk5cOStVTLFrv75+EB6ePApE3ISgg34POEcd/5PJ/b7+J9NjwGisLDQyCjBj3/kEq3TzZNFxg6TGEqm9LigsxyV6DLfDynmPGrc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBAPR03MB6549.eurprd03.prod.outlook.com (2603:10a6:10:19b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 15:05:46 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4649.021; Thu, 4 Nov 2021
 15:05:46 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch> <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
 <YYCLJnY52MoYfxD8@lunn.ch> <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
 <YYFx0YJ2KlDhbfQB@lunn.ch> <ff601233-0b54-b0ad-37ce-1c18f0b7ca47@seco.com>
 <YYHL82nNuh3ylXlq@shell.armlinux.org.uk>
Message-ID: <53f4af3b-442a-14dd-76cd-d2784a71d709@seco.com>
Date:   Thu, 4 Nov 2021 11:05:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YYHL82nNuh3ylXlq@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::13) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR07CA0003.namprd07.prod.outlook.com (2603:10b6:208:1a0::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13 via Frontend Transport; Thu, 4 Nov 2021 15:05:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db46dfdc-b4ac-4993-4691-08d99fa4940e
X-MS-TrafficTypeDiagnostic: DBAPR03MB6549:
X-Microsoft-Antispam-PRVS: <DBAPR03MB65497ED8376D91D84C38E016968D9@DBAPR03MB6549.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F6+dkp3ngcSQfUTnKVPeL3BzzO8jNOdidYxEo69z0MD/Xi7+exUt8eZFMPlRtTdvIaoRL6+U9BRzs4372jLEolx1zJf25KDyc08T69FGr5kEkm/WMRbLVWKFLaLNg0aQ2POrhO77XlkW2bafU5kAtDkV+ypEKWf52KQLiKDs07IHZsG8qbEY1KpnopqZ2w7YZAL1sLeftwF2afLq6v/bYbyWPXRAquClyaekP5smrmoj1r4tRj/arQlojZ43QX8GxBkAAzlzdPgH8B9HalylM9clw/jeJrJR9gNHsSLxMVK/7IWM4uyZ6WtfeQhxl35sActGOVzN15yrSYiYyFQOmoR+lGkN+rHgBwMn0H1JFqmq8NwR4Jzn+4zXSD5E2gEh642RpsiZbvzikceMz5xcXd6DVxYDuER5RdLYrIRMzT3KV63IE5CluLVaAJXgXPxVtgre6Qr8PzlY4Vdxvlp7N/SnfGEJCIQSgO3rkz0eKZbAOHXrcqtkCtjtXRf3Yypn+PNzovE7ZP4hl9Xg27MXZXXT3lhpNjVIiyKdWi+4ezxrWty474CVlzrUWNZkYkWT4fZ4o/L95I/L2Sfe8SIfoAEaPf/A61NdHsAjxSFqpv+zSURL9dsXbvCSMaEmFktpwlhWXej3tNexLXn9/hui0mnMFliRyoABPe7XuLGgwWmN/TYr27yFjeveC5JEy5C+wx7ey7NTCGsAzJ7m1xSe7oR3oYb1ZAjDZpgiJwk98PwO9LVTOfT1jiN3Q9wmBuRMcmNr0BSpTsweCzzLUkggQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(66946007)(66556008)(26005)(66476007)(186003)(6486002)(8936002)(5660300002)(4326008)(31686004)(6666004)(52116002)(53546011)(38100700002)(31696002)(8676002)(86362001)(316002)(16576012)(44832011)(83380400001)(956004)(2906002)(38350700002)(508600001)(54906003)(2616005)(6916009)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0krRFFzeWtrR29WdzZWZDlJYnE5eWkwTzF6M2IyK2t6Z2Jzb2FsTllraFly?=
 =?utf-8?B?NEZJMzBuMlVobmludEVPVHJVeGg5YUVWaGlIY2tFOW9iSWdZNjlLa01QZ1ly?=
 =?utf-8?B?THJoODRXNTZlLzBneThZZEFkY0xnMS9mbTBUeVhWVDhub2VOOC9EalFHamFD?=
 =?utf-8?B?cFdKaVRZSlJqTXR1alpqRmJGS0NMTHA4WkdVRmM2YVFMbUZJTTNXWkI5aG80?=
 =?utf-8?B?Z3MrTDZyNE1PWUpldWNOblRQZzNUMkVtaEY5dXlUd296VGN5Z3JIM3R0TzE5?=
 =?utf-8?B?VW83VUE5L29Cdng2bnNFN1lzOG9KYkhYYUozN2VKZmI5dnlpTVhiN2dobXAx?=
 =?utf-8?B?TlozUUtTdkpJUVk2V2FGNXViOEwvTGVEaWJFcnJzVXg5S2tqM0pQeU9oUmJX?=
 =?utf-8?B?T01wczZycnRQc1hxaEVpampWNnRJWk4vY1A5TUdtNWZablJnSVFheC8xa2l1?=
 =?utf-8?B?ZWlXTG44a09kRkh6WnVsclo1bDNHZjNRamVYQzRpWXZLR042RVNPbVc1aGVx?=
 =?utf-8?B?cEN4Sjd0b3pudDJxUTl5Skd6UjlRUlhEcjNUTVhNQzQwOEY4WlpvTW1IRTlh?=
 =?utf-8?B?NHdqTW1OWmxKTTNZRm12NmFtRDhoTW5OanZqM05wY3U5SmI4aitsRUhBZms3?=
 =?utf-8?B?bk11QzU4TWdvanZNQytBU0dkcFdnMXNGcG1LcjNlWEhoeTJDb1VFSUphdHph?=
 =?utf-8?B?S0xDM2g3QnlaTFByZnRsbHU0OTVYY00yd3dvNXJOUGk0SVZmMjR2dkVNdW00?=
 =?utf-8?B?UW1iWUtPRWtCWGNVL0Y3UllkVnJJaUEwcitVVzFUMCtNUXJNaXlLYUpKb1pL?=
 =?utf-8?B?V3JsL0wrT3dRVmRYWlllSHFseUNKNndiYVlTYWxVL0FFRUVRYzBoMmhwd3g4?=
 =?utf-8?B?Z1BUc09vNkNRTnQyL2dGaVMvY0VmcXFLRzEwdXE4bzhMekhHbHcvUDFkR2FH?=
 =?utf-8?B?cjdORzRucnBTVDNTZFBVSmdiL2FvU2pvajB3OVBzeDA3em1VS2NYK203cXp0?=
 =?utf-8?B?cTZUanczbGhzenBpcHJMMytHaGszRnBwRjliUCtScTN5OG1vNktZUEgwc3N3?=
 =?utf-8?B?QytHaWIvK3dPQUhqMzNIVVpZd0xFNURGZkVGbWdpWCtMT1BZQitiZG1ReWlK?=
 =?utf-8?B?UVQvWEJycGd2QUV0eDQrUUd2bnlxSFI0OWVQTEhqS0EvTzB5Zm51VmlwQVF3?=
 =?utf-8?B?c05mMVNLK0dhYmJZUkpyRmw2YVhKRHZUVjJMcU9zeHU2cWNpcGw3QzdrNU5x?=
 =?utf-8?B?ZUVIdlBmSWpwR1orLzR2MU5NdFhTSXZrRkNrSkV4Y05rTnU4SjFBR2lGYStz?=
 =?utf-8?B?QUtCSUY3ZEN5UkRuV2hHeW1GdDQvckRpVlNJazd6Q0QzNkwrbmdIR3VoaVZH?=
 =?utf-8?B?UlA5bWpkOExpSklWbjFkOW9MZHZvTi9uSVdGRVlsdGNtZnhDOHdRKzJBT3k5?=
 =?utf-8?B?Qyt4M3Bpb01YYjJ0enVhY1gzS0k0RTFFV29FVmxHL2J2NUtiQkNPNHBMbW5J?=
 =?utf-8?B?MzBncTA2R2JNRjBSTzBEcmtkRkVFbFNTWE03Y0R2Y0RtcEVhMFNCRDAvOTlJ?=
 =?utf-8?B?UnJBMHNabjlwMWlmYUJXSFAybTVscW5MemdGRTFYbGw3anA3ajZSMXF6S0Z2?=
 =?utf-8?B?bDhBckphWURLQVEyT0I5ZkJGQUJFNEFkb1F6Qm5TUlVoYUhSQmJzMG1ic2pv?=
 =?utf-8?B?MW80MWFmYXFUTW5Tc1EyMDJqZWpzZGhSLzliUGkxYThodHIxRk8xVVBGLzRh?=
 =?utf-8?B?aUpwbHFjSytVS2ZCUGY5cHJZVjJDdmQ5UEQxcXhQbUJqOTlhT1pXcm1EUHh3?=
 =?utf-8?B?VzM1d0VIRTlCR1FwckJNUnlkQ2Q3dUMxNTIwL2gwQ2pNTGJLMjlTRnRsTGZR?=
 =?utf-8?B?SFlwV3hacXVqV0Zwaks2eHp2bGwraFArakZzVzg4VEV4eGU4SHRwVGUrZysx?=
 =?utf-8?B?M2RtcXZBR0ZHcmoveTUrWmNWbDFiRnVBS00vZ2pHMng0cU1aTnJVWG1TMEVY?=
 =?utf-8?B?OE5JUFllcVlkT081bmtuZzNoZ21tZ2dxQ0l3bnlCeXFQWHBZbUw0Ui9IZSti?=
 =?utf-8?B?YmZKSlFnM2Y1UUdUWkpROENsSUNHVGNLMDZFeWVjUzFaWjJYSGdzeXl5ZVQ1?=
 =?utf-8?B?SkFaRkZvdE45ZzRvWU1xMlZlU1R2Nm9qVnFtTWdLYm5xeE1JekpmazN2YTg2?=
 =?utf-8?Q?bDGmnsqGshK0cVoHQ9YSh8w=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db46dfdc-b4ac-4993-4691-08d99fa4940e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 15:05:46.0310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XD6OluIhICQdrvab1UxaHuCB0Dx1//v+uoRZLj/RgBYIFMN0Yt867vCX/XauHOGWdGz0oCo1RHYeYPCga2yPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/21 7:38 PM, Russell King (Oracle) wrote:
> On Tue, Nov 02, 2021 at 03:46:13PM -0400, Sean Anderson wrote:
>> I have not found this to be the case. As soon as you need to access
>> something using phylink, the emulated registers make the ioctls useless
>> (especially because there may be multiple phy-like devices for one
>> interface).
>
> I think you're fundamentally misunderstanding something there.
>
> If there is a PHY present, phylink presents no different an interface
> from phylib - it does no emulation what so ever, and you can access any
> address. I use this on Macchiatobin when researching the 88x3310 PHY. I
> have a tool that allows me to view part of the register set in any MMD
> in almost real-time - and I can access either of the two PHYs on the
> xmdio bus from either of their network interfaces. Same for the clause
> 22 mdio bus. There is no emulation in this case, and you get full
> access to the MDIO/XMDIO bus just like via phylib. There is absolutely
> no difference.
>
> If there is no PHY connected, then phylink will emulate the accesses
> in just the same way as the fixed-phy support emulates accesses, and
> in a bug-compatible way with fixed-phy. It only emulates for PHY
> address 0. As there is no PHY, there is no MII bus known to phylink,
> so it there is no MII bus for phylink to pass any non-zero address on
> to.
>
> Split PCS support is relatively new, and this brings with it a whole
> host of issues:
>
> 1) the PCS may not be on a MII bus, and may not even have a PHY-like
>     set of registers. How do we export that kind of setup through the
>     MII ioctls?
>
> 2) when we have a copper SFP plugged in with its own PHY, we export it
>     through the MII ioctls because phylink now has a PHY (so it falls
>     in the "PHY present" case above). If we also have a PCS on a MII
>     bus, we now have two completely different MII buses. Which MII bus
>     do we export?
>
> 3) in the non-SFP case, the PHY and PCS may be sitting on different
>     MII buses. Again, which MII bus do we export?
>
> The MII ioctls have no way to indicate which MII bus should be
> accessed.  We can't just look at the address - what if the PHY and PCS
> are at the same address but on different buses?
>
> We may have cases where the PHY and PCS are sitting on the same MII bus
> - and in that case, phylink does not restrict whether you can access
> the PCS through the MII ioctls.
>
> Everything other case is "complicated" and unless we can come up with
> a sane way to fit everything into two or more buses into these
> antequated ioctls that are designed for a single MII bus, it's probably
> best not to even bodge something at the phylink level - it probably
> makes more sense for the network driver to do it. After all, the
> network driver probably has more knowledge about the hardware around it
> than phylink does.

I am specifically objecting to the statement

> The current API is good enough you can use it for debug

Because for debugging purposes, the current API is simply inadequate. As
you note above, there are many cases where there is no obvious mapping
between a single network interface and a single PHY on a single MDIO
bus. For this reason, it is necessary to allow userspace access to any
address on any MDIO bus for debugging.

Even a read-only debugfs interface would be useful, but from what I can
tell, such patches have been NAK'd. I find this very frustrating. I have
no opinion on the proposed patch above (due to the ioctl interface's
more fundamental issues, which you note). You will continue to get
patches trying to extend MDIO access until there is better debug
access.

--Sean
