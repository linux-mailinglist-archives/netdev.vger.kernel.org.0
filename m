Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24A9474EF8
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 01:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238395AbhLOARC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 19:17:02 -0500
Received: from mail-eopbgr10064.outbound.protection.outlook.com ([40.107.1.64]:5505
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238399AbhLOARB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 19:17:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DU3cYAnKCXc34jXtMy9N2kApCvnNK//SfHti1gPJ43Fv9xT8ApeVI+DKdtVfH/l1GKvbAKWSjSEGU/lohLqduc8dIkv6AVSjgHCHhv0MsZDszCKMWUzdTsb+0pJg4K9UiNvcHfW5tJ5YmzuOuUgwAbE3HIqUVsYedJFhT7m7ZUSp/QXFfrsHAe5avFBlf6C2efaK6E+XpyoIgvJ8EcKufkChd82By436HUnz7bsBsmo7mucBPPMQAF0UuKFAvovMbTlYDzNieCiwhAnGv8zjnddYYeDQP2gIXGJP9pSKHKEb9/5HrQT4FqDLxHwtqQoP2DcOpL31wiob2OuBcUN9Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1KnPxeRTp+hXg3QdF496i7Mafp0n4qaupT9CkLXh2YU=;
 b=ZTjmitIxXpJRAKIaColqiawL548Tl47ffZdPaKwF4JXzqWFzVKWh4uSNzOS23JEsQCIkB2b+QMoIg+McnXwA7rJ2NufgrkC5vLwWL7Us04mKv0gO2pGNOtk/t6JOKXsjroxxFiCQq6w0XjiqwyQ+kMAyD7lKYUH2B9Gfj2qpTLFgBtE4a9snV+TVHagyJ97CMm/Nxgsk2DWU3G3d85oPzQQp6/ssJVcIOstul9SsWnQNxBjhAE4v9VHIyuh91rEGjg9nezMAOXETb3oFKmPKHAfoP3Joa4v4y32ZkVA8TYWo5Dwiv9hQLkmPB1i1sUKzlmdKMJ/8KpDfkmL23i0BVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KnPxeRTp+hXg3QdF496i7Mafp0n4qaupT9CkLXh2YU=;
 b=NFZpKBS3rz+vyiwnNIZmpBeC+GK1aWacKguSmWGugTlPoQh+CnjLMmp8DruWPkRBpNtZGx4qt23LBxTZaB+/Z0tT8Y5u+qnXG0U1nwNgD4gi4uKRdgorDI4ekLdUNLj2SErYKm4PuAHRGc0Y0bBgdXSGfcIW29hTYoI8GCaYzOQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB5366.eurprd03.prod.outlook.com (2603:10a6:10:f5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 00:16:58 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 00:16:58 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH] net: phylink: Pass state to pcs_config
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marcin Wojtas <mw@semihalf.com>, UNGLinuxDriver@microchip.com,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211214233450.1488736-1-sean.anderson@seco.com>
 <YbkshnqgXP7Gd188@shell.armlinux.org.uk>
Message-ID: <de1f7214-58c8-cdc6-1d29-08c979ce68f1@seco.com>
Date:   Tue, 14 Dec 2021 19:16:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YbkshnqgXP7Gd188@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:208:32b::24) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 345e1fc9-e433-47ee-f657-08d9bf60353e
X-MS-TrafficTypeDiagnostic: DBBPR03MB5366:EE_
X-Microsoft-Antispam-PRVS: <DBBPR03MB53660816176820783024121596769@DBBPR03MB5366.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4wzK8JyGxCtU1w178xOZuMCk+fKn/EIp0A4MyEHfzNJfbSg9NDzlPOU3/V26Vl7Nap9zGVuoDg0IfD+y/Sf1gSgd/R1lMsXVkcGTgIVhqxqq88u/YtSYvfVQRjjTeDY5x8BHEEGUswRTeOV6fucg+JfUs9VP1s09yjp9Vln4y01oxaIM/kmB0lI7eNcu7Qd43DP9E96f89MSFAD0D8hsY2thu3guTqssHX4HgUU82hLF1NdkWucw5KrQql9oOkhlfx8X0CLBso6JUmCLRvKy9qstmtX1W8jgZK/3oJhed4FZ49UjsYxtEpnymmVogEuPjUFCmTHfPK9trHj0/SD4ZJzAA70/kYARalG4RdRlbQxP8bvvZwtliyxRKqUc4EH554yofoLpnvIKQaT2vkCJEd8J3M2S8g26Psf4Mtoy+sXgiiAp5gujEFi8hdaXwhd56ON0yO6BH1FtP58V9+/+R1N6yHUGRFuJ0jKctal+N93KVfvXKiK5VUKvGibQ3RQNfYb4Z3Z0kgg/+xKDXqIcN3grckOigdrZvTaaF0B2ZmQnqh4oqAMQNyMKylfieGc1ff6Q4xtf1f04givfr/ar2lgWBl4cldoCkPUZFexflQuG7r3f+kX4jZCRzYI0hgrsRL5KRT+ruQ/hOl5UdktGjXQ1bZaBBktkMNmEi4B+a1Vs+nHWcKp0wO9gTEsDf8MTphCwCM6FjM0YRjA+1jkXoL3VuEvjvpDkI62nVaNV79A7JEzAfAi2dr0kxSpbjzgQqbPgXcn4vvGh/jmj7wQT4X0s7goWUgWBfE3lRkIAD3zILrtv3ncR3i25OUeyH7He
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(2616005)(5660300002)(36756003)(52116002)(4326008)(31696002)(6506007)(86362001)(66556008)(66476007)(83380400001)(66946007)(54906003)(2906002)(44832011)(53546011)(8676002)(6916009)(7416002)(31686004)(186003)(26005)(38350700002)(38100700002)(6666004)(508600001)(8936002)(6512007)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXhaaWxGdTlGUjF5eXRWMHFoaElCTG9kUEE4TmVrMXhyQ2E2ZjhyVzNlNVBF?=
 =?utf-8?B?d1hlejdNdTUwaHdVU1RkSzB0c2kwUW13a0JnOEtkZXhoREZXNVd0RmVxblky?=
 =?utf-8?B?YkFXdWZOVVZ2NEhtZkU5dFR0RG9jSytyVDB1M3loWTljTm8xRWkrNnYzYW9x?=
 =?utf-8?B?cmlFM2hhb2d2Y3J0K2hUaW43dDh2cktBbzlLY0NueEVZbk1wLzV1RVlEcUdU?=
 =?utf-8?B?UzdQVDVwcEM3eTR5Znh4dnZTamx6M1dibzlYTzk1Ry93bGVKR05TYTVWbUZL?=
 =?utf-8?B?NEFFdWtEblIrUEJvTzdLREFGcnhFMEFXTyt6ak0xaVJiQjNMNGpZU3FMQlIw?=
 =?utf-8?B?U2hWUlA2TkJxNS9Hck5xT0dMcEdWREhMUnIyMXlXYzB5OXVuZGd2ZWxMbVlp?=
 =?utf-8?B?dFJsQzQ1aFEwUTgvWk81VVkxR1hEZ1ZyLzZQVERMd2pPY2ZZZld6MlhBamQr?=
 =?utf-8?B?R3JUbjhuYmFQL2hvZE9JYjdiL3IzSnpCZ2hadGFzcFY3NTJ1dDU4bHY4NE5C?=
 =?utf-8?B?OWhCMGR3OGx6WElUWVBtL0Vpa0ZjNUxYVEhjQUdWL0ZjQ3ZadElmSkpva1hv?=
 =?utf-8?B?ajRnNGIxZzZCc3hOTWRCaU84VXA0djdHTHN6QkZibkVNUG5CdnJJcWg2Z2tt?=
 =?utf-8?B?bGZaSURBSk5yYlRXVUp3dmJQeFlMTWl4SFphMTFGUDZEVVc4TVFQVzY3V05x?=
 =?utf-8?B?V1JJZWt2aVhjNmJYcUVnQ0xkV28yMG12NUxSK0lqa3hKTGU4KytpWWR2WHFF?=
 =?utf-8?B?ajFiRlVISVVwYU85UytTVkhsV2F6K3Z3TkZQd29yVGkxYTFQWEZBTDhNejl6?=
 =?utf-8?B?TUp6K1pKRDNOa2VvS1hpMjVmR3EwTVB4QktZdzZBODY2SVBCZHJkTGJZdFFv?=
 =?utf-8?B?K0NlazdpZllvTVdVT3ladGtjSmFDek9yRUM3c3JHSWJpM0JBZVpPN3pPcGpr?=
 =?utf-8?B?aDRjcTI2UG9hdGFKMUxrMDk1L3N3dG1WSG9UM04xbTRkS1FnVmtFTWJnbVdY?=
 =?utf-8?B?NEZzYkp2SHFLanl4bHcwSUFNV2Nqa3Q3eHVxdXFYMHRDbU1xMC80cUMrVXRE?=
 =?utf-8?B?Rm5mdTY4SEdBV0piYmRZYW4veFBJNVR6TGZHenR5eHllZ25EODlPZ05xZm9O?=
 =?utf-8?B?QmphdGh5bUlVQTg1OGZFc20vamc2bGJKeG55d2p0dXJYKzFQSFhUdDA3anJs?=
 =?utf-8?B?V3l6TklSYXRkZlFkY2EzT2M3OVJRWkk3b2ljREJWVDQ3ZVRoTExzQjJLd3FT?=
 =?utf-8?B?SVNLZ1pKM2Z0bXk4aWFSUUxjOFlDQlg1UlViUTRKbzduUS9ZTVVuM1dTWTBR?=
 =?utf-8?B?S3h0MnBZc2VuTEtJMEY4OVR0SW0zdnpDbTR5Z0hVeUpUQldZL1RGUDBsUUFZ?=
 =?utf-8?B?UWVOajBXTVdzUlBmM0tFYkE5NGk1cXRsTUpnZmpobjA4NXAvYXdVRFlKaHBx?=
 =?utf-8?B?azhoNlB6WDhEYkF0Y1d6eVZEWFErcGhncTFZRDNXYjhJRjkwVlhNZ2h5S05t?=
 =?utf-8?B?aFpOTnpleVBRMEVoeVpodnhKV0RnR2xHUGFSS1o3bi9YUU8ySmhLWTJJelhQ?=
 =?utf-8?B?UjJTd2lJT1lSaE9YODNGei91MWhjZVdKRk5wV0VoQTNoc28rQ01ndTNkSFZR?=
 =?utf-8?B?THRlWTRQWXJGMWpmelhLa3U4dFJELzA1UmdDOXN3RUFMTXJxV0M3Yk9NbEVk?=
 =?utf-8?B?Q1ArZEZvSHlmVFM4K0wrUmZMMjF3d2RXNXhPWVgzR0ttSHdwSlBneXpNdHcv?=
 =?utf-8?B?YlBaaC9NWnVaSkVjY1lsZDVpMVFiWkhORmJZLzY3VmU3U2MyY3NIRXM2OXZF?=
 =?utf-8?B?TEc5U1FIclAzMHZTQkp1VVFzM3hsTHhRL2k5VWFZeTlUOGhwMlNNM0JNUVk3?=
 =?utf-8?B?V29XbVlOOUlJa2Z0UmVpSGprU2V1eUlyclFZLzFzb2F2aXZXWFlFbHNueTFR?=
 =?utf-8?B?UGMrcXhyY2RpYzcwMHRmKzRobU5SN3l5ajdPcWpSUFR6ZEtXRHNoM2tuTW5n?=
 =?utf-8?B?ejFra3F0MFRnQmd5Y3VMYkdzcFk2Vm5EbUFWVW5uSUZCcVZoejF5UEJKbW9J?=
 =?utf-8?B?RWNaQm1nK3k5UEFIMGRqQWV3NjhMbWVUVDNONHpDVG91bUlibnF6WTNVREUv?=
 =?utf-8?B?aXZqVCtuWDRjeHpWdFFmV01DOGJ4WmUyeW1oMXVSUElUV0J1d1pacnFsdEJU?=
 =?utf-8?Q?QgIxN8UhpDANbHHtmSL/ta0=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 345e1fc9-e433-47ee-f657-08d9bf60353e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 00:16:58.1769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wnqD8aMshgmqO8B0K3AaWp5FcqbdBjwLSJFt/0T02HilW1MP3tAJYwtaC3U9kq0uaGeii7hrWEM87x3okVhHAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/21 6:45 PM, Russell King (Oracle) wrote:
> On Tue, Dec 14, 2021 at 06:34:50PM -0500, Sean Anderson wrote:
>> Although most PCSs only need the interface and advertising to configure
>> themselves, there is an oddly named "permit_pause_to_mac" parameter
>> included as well, and only used by mvpp2. This parameter indicates
>> whether pause settings should be autonegotiated or not. mvpp2 needs this
>> because it cannot both set the pause mode manually and and advertise
>> pause support. That is, if you want to set the pause mode, you have to
>> advertise that you don't support flow control. We can't just
>> autonegotiate the pause mode and then set it manually, because if
>> the link goes down we will start advertising the wrong thing. So
>> instead, we have to set it up front during pcs_config. However, we can't
>> determine whether we are autonegotiating flow control based on our
>> advertisement (since we advertise flow control even when it is set
>> manually).
>>
>> So we have had this strange additional argument tagging along which is
>> used by one driver (though soon to be one more since mvneta has the same
>> problem). We could stick MLO_PAUSE_AN in the "mode" parameter, since
>> that contains other autonegotiation configuration. However, there are a
>> lot of places in the codebase which do a direct comparison (e.g. mode ==
>> MLO_AN_FIXED), so it would be difficult to add an extra bit without
>> breaking things. But this whole time, mac_config has been getting the
>> whole state, and it has not suffered unduly. So just pass state and
>> eliminate these other parameters.
>
> Please no. This is a major step backwards.
>
> mac_config() suffers from the proiblem that people constantly
> mis-understand what they can access in "state" and what they can't.
> This patch introduces exactly the same problem but for a new API.
>
> I really don't want to make that same mistake again, and this patch
> is making that same mistake.
>
> The reason mvpp2 and mvneta are different is because they have a
> separate bit to allow the results of pause mode negotiation to be
> forwarded to the MAC, and that bit needs to be turned off if the
> pause autonegotiation is disabled

Ok, so let me clarify my understanding. Perhaps this can be eliminated
through a different approach.

When I read the datasheet for mvneta (which hopefully has the same
logic here, since I could not find a datasheet for an mvpp2 device), I
noticed that the Pause_Adv bit said

> It is valid only if flow control mode is defined by Auto-Negotiation
> (as defined by the <AnFcEn> bit).

Which I interpreted to mean that if AnFcEn was clear, then no flow
control was advertised. But perhaps it instead means that the logic is
something like

if (AnFcEn)
	Config_Reg.PAUSE = Pause_Adv;
else
	Config_Reg.PAUSE = SetFcEn;

which would mean that we can just clear AnFcEn in link_up if the
autonegotiated pause settings are different from the configured pause
settings.

> (which is entirely different from normal autonegotiation.)

AFAIK pause autonegotiation happens in the same autonegotiation word
transfer as e.g. duplex autonegotiation. So it is just a subset of the
other which is configurable separately in Linux.

--Sean
