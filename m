Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25E943B9FE
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 20:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbhJZSzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 14:55:35 -0400
Received: from mail-vi1eur05on2088.outbound.protection.outlook.com ([40.107.21.88]:65120
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231592AbhJZSzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 14:55:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LELGOMZljhztIZuc2Se24Bak4PnZyKcGgLTOU5eC9PrqYOcnNEZYUcGzov89kfAa5PLMf4Zs66HU7S6iwJWlQsPf5reB709mVD4zF6Cr6Cvj8xZs1T7d8/cScuvlhHI1U6UAuYZtZeb6fBs5xLc++f+zfM/ePgPog572QtivDK9w1tQ1QDjXBZKkwFYKGAZ2pSDFO5gWEQ9PlYpennUlz7cPvZpr3Mmz7iBbwkc4tSn3Rn+XPfogzfxswioRviZ23187tC1Y927Eqzlq7eAm66uuOV41MUvxHrJd+pgDv6kJ+XCjD5agb/kvd8gmDlF31sM1cLfZT0ngBKrOt4edmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xj5O8N3BZuKXLSjLjlvbx4sTx/gm4mcO0pW1Jq+BTlM=;
 b=W7PjCRz/u1r/XlFU+8fSvf2svFWAvjC8WR5AtHNEER8puSBDq/NmcCQk38zg0X7MMKjCz6g3hXiweF9kEanj/tLxv3XtYuu6zyTqrc7OgZ6Y7jErc0r/ek2UlxIbZm1VALE2n8hGtBfOvbebk2wF+egESA0WNcdPp+bOhc3gNnxvTPV1DI04nRLFGJNAkVNbLUQeSPZYKKq3XJNQNIg30U6c3OxMWYlm1IhOHpuA3AM/8HIcW+RPjI0EZwck5E9oV6qCZU1LmKzY4ISycOFTTH+VzGR9CBS5M8W7wnIh5rMJpZjImEeZUQrmYhkLx7PXUiSo3waWmvbAycbnJX8jxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xj5O8N3BZuKXLSjLjlvbx4sTx/gm4mcO0pW1Jq+BTlM=;
 b=GnT5uLRPxk4YxQMhY4o7yN+HBDgPWJgWUQ76PZbzuHddlK9BdEv2lvIzxpGDzLD1W/ejSlkZt8I8k8kbGjY0YrRzsz6x7YQ6rH9glI0PCr/SSGDNmYyFwfByKjRhttVFipgWVoirvlH4GqZ+VuuiTFCp1dCwhEGSYGOdcHzbz9M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0302MB2629.eurprd03.prod.outlook.com (2603:10a6:4:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Tue, 26 Oct
 2021 18:53:04 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 18:53:04 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Parshuram Thombare <pthombar@cadence.com>,
        Milind Parab <mparab@cadence.com>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <YXcfRciQWl9t3E5Y@shell.armlinux.org.uk>
 <5e946ab6-94fe-e760-c64b-5abaf8ac9068@seco.com>
 <a0c6edd9-3057-45cf-ef2d-6d54a201c9b2@microchip.com>
 <YXg1F7cGOEjd2a+c@shell.armlinux.org.uk>
 <61d9f92e-78d8-5d14-50d1-1ed886ec0e17@seco.com>
 <YXg/DP2d1UM831+c@shell.armlinux.org.uk>
 <b911cfcc-1c6f-1092-3803-6a57f785bde1@seco.com>
 <YXhIvQiTTiHrmrBm@shell.armlinux.org.uk>
Message-ID: <7d3d60af-d089-c7bd-bef7-d60d86b97333@seco.com>
Date:   Tue, 26 Oct 2021 14:52:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YXhIvQiTTiHrmrBm@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:208:160::16) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR13CA0003.namprd13.prod.outlook.com (2603:10b6:208:160::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend Transport; Tue, 26 Oct 2021 18:53:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4872bfc3-45b0-4f24-748e-08d998b1d772
X-MS-TrafficTypeDiagnostic: DB6PR0302MB2629:
X-Microsoft-Antispam-PRVS: <DB6PR0302MB2629FCED3D4C2BDD8CD29DC596849@DB6PR0302MB2629.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hAZIZptkU9NIocrx+WEZwmk+YAkhFQDC0FIplRdDwpabC27KBV6ejsiZaMGITO55JCEnQ9UYVazg9DOsOeOA6CsGONIvco/PuFw55MhIhQDiU37ZOeCbeT1K0HT+0hxn6NUG37pGc0vb4gKnkThX0hNCREn/kBFQDdIC7ymOZG5f0cQKxlSCDwMfk6kLOFOI2yXts1EM/ULp7isP/Fl4NmAjrgNotnadE8zUBUCKymSrxEXMfJS1YUPSToiKVWnXG+BKQRASPce/9Fig7qSpwZtgufzqlVhI1qYUlQJu3VuFKVIi7YwJd/biBkrFKNf9o9+rHCFaSVK+pvppJ/KAhU2+Zj3wSjV42YUxIFBXh8oTKAoJ9UvogQuFAiILJiQ9SEDPQEckpl7MHTAFVAs7xozTdAwPKFOIUXIn/0iNlx/RZZRDbUBUiwiObgAsghTBNY9/NXNWlZAX9B6OCrb8CgPH/xR8o99sIj2PS9uMUI0C285/2GUZT1VcZd3Zpcb7/3ZfmgqPzI2ShcBfP8Wk3/rnHyqGupW0xZ9McEEX2NV4Tzg4JzByTv2rTR2i35079zpUtccTuu7oMzwrVNjFiVtTz7BBYjkJeynaZMFreaoTIWlxn4OsXrJAtZ8nhhya2g06wJJwOSfS98iXKYLfoa6WBfkKJGpqiZHPJ+ZSl852p1mggsL0QU6Ae2O6V1vMfT+sLLYyXdutWcz2/lwf8GkfbMBfPag+H93HkmsZ2nkD9hKKYdp7XfHMz6NqeZShFvdL+UB04qfSt1xc61XBv0xSvHdm6rpRjT0ZtXWILNo/sGWeW5zgps0ssRGseSDd+XjdBCaR3yNlYLDPRMmtiU4yZjhoGTiiLtxv0ZzE2Vw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(2616005)(186003)(66946007)(8936002)(38350700002)(26005)(31696002)(966005)(5660300002)(6666004)(508600001)(44832011)(83380400001)(16576012)(54906003)(6486002)(31686004)(316002)(52116002)(86362001)(66556008)(4326008)(36756003)(2906002)(6916009)(53546011)(956004)(66476007)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clhUVjdVTy9qMXM2RUxEbTVsTGh1TE9ZU2NJTkhQSnp0ZjFHRkF3em8vRUlJ?=
 =?utf-8?B?Rzl4TEVYL0FFNmk3Zm8zdTdkbkhXRVd5RWlvSHg0bWlTMm9ncVcvTHR0RnQw?=
 =?utf-8?B?ZzAyN2Z3ejM0T1gwYUJZQkxFQU9ERzdIR0ZOUGs0SGw3WjFBVE5HTHFNQUdD?=
 =?utf-8?B?ZXdCVm0yVVhOUHl0VVpXWGxoOUhidzJFa1JldTl2NkhTb2w4MmM4WlYwTVFX?=
 =?utf-8?B?ZDJJelJ6SWVZUEZRTnpkVmdCOWNpSE1RNFlHVTc4d0pNRVNqcE1PQ1hDMjQx?=
 =?utf-8?B?dWl4RjNqS2V6cEJtRTB0b3FycTR3Sm5XUDE4MmloaUs0VUtvWm5oYnp0VWhv?=
 =?utf-8?B?RVVQMXVON0Z1WGZieE9FMVUrcTF6ZlNKQXRLNnI4TXVNUThUTE1QeTNpUzBk?=
 =?utf-8?B?QlBRcUk0YWs4T0RBemh4amsxOENmaGFVTVdSS0h5MkhCc0lrbmFuYjUvUXp1?=
 =?utf-8?B?VjVrOVg5UkUzc2dMbUxTeXdXTFdPZUt3cUNLM0hhOSt6SW5ZakNidGpCODJV?=
 =?utf-8?B?dlh5MGJodXNOVkd5ZkRIRlh2T1d5bktJbHI1TmpQck1FYVZ2Nk9oOS9IUVB3?=
 =?utf-8?B?d0JpUDNmRTZOZlNlS1FPdUtzcmV6Ky95ckI5SmgrSTNFYS9lWUdXUTg1Si9j?=
 =?utf-8?B?bU5TbVdjUS80YUlha2NrdjJiS3hyZTl1RzViellRRmpkS2Jrc1N1ZGhpVXFT?=
 =?utf-8?B?TyttUU5xR0xxaDl1eU5QekFuRTNKT2FMaTVCQTAxVkJSbDN6ZWk1RXhTZlhR?=
 =?utf-8?B?M2pocGVRdCtYYUJZVk5nRUF1bmo3SGFyU0tnMEJseHBIZlhQWkhjMm5NT1JI?=
 =?utf-8?B?aUZWN2o4bjlocXJ1Y3JzZFAvZkRjMzdwbERFamlxWWdpZUllSkRJaW5NTHps?=
 =?utf-8?B?QXVXRWY3amZtRkRhNTRrZUl6SmhXSXlaN3dmR1BaUUJGRUo2K1JMWC85Rkoy?=
 =?utf-8?B?ZjRESmtTU2hWNnQ3MlJvU3dCU0xjY0NoSVpUWCs4SHA0cG13RldUa0RXdlJR?=
 =?utf-8?B?aFFNT1ZzUGdHdG5yZWh0VXFkcFMyelJtY0RCOWNsdHFram1vNHROcDNlV0Ir?=
 =?utf-8?B?blUrek45MExXM3RnanF4YUhzdHN1MTNqMVlCWVI1K1ZCVHBMT1N2aFprQlJm?=
 =?utf-8?B?cTVESkM4eTV3OC9GZkcwQ2c3Mzk2cnliZ3QzNDBrdWtsWDBnNlZZWFR1eFRP?=
 =?utf-8?B?MjhuY3p4OWRwVzdqMzJ0dXRoN1F6aFp5RDRWTUlUVkJnVlIwSWIzZnVobXJr?=
 =?utf-8?B?U2ZiSkY2V1pPZXZFaG5jeGhhZk1oZmVIU2lWR0FKQUtSZG9DTW8vbUl6SkVo?=
 =?utf-8?B?cTRkZXBIUkdWQUx5b2k1WG95b25IVXhvQzRZMnhjY1J0Z3dMYlJGUUU3bmxa?=
 =?utf-8?B?YmRkaWZ2Z2FtNFg1WlAwcEpxOVdtOFFQb2lhWEJRbng0UFBRTmY4RFhQVngz?=
 =?utf-8?B?SWU1aGNhU1IwL0NWVHpIRmVqS3ZUQk5tenpEeWhGOUdQVkRBNGlCckRyZ2hT?=
 =?utf-8?B?WHQvRk5VNVRNM0JLQVNiUzdMU0U4cmJjQVFrU3dTZldkZFRtNDB4VjlEVndr?=
 =?utf-8?B?bVFKY3ZoRGpUQkJHNC9YenY5ZXRHS0ZpQ1NEU25wMWVjci9MQlJVOWI3U1Rs?=
 =?utf-8?B?aFVkUEppNGFsZ1BpYzA5VEpDcFNWUnVBMURDbXpGb2JkckpReVQwMkV5YlJQ?=
 =?utf-8?B?NGFSS0Q5ZStMb1Ird2FTTWpUSXZuUW4reDRXaW03R0FUMzB3Y1NQdjVtNmNn?=
 =?utf-8?B?eW9ldk9WcmdrbDIvMGhQbVJDa1ZHUVliSGluWkV1ditmZm1IZ013WTRMOUNH?=
 =?utf-8?B?WEVoOUZHYkoyWDV1QWNwbkFEV1pZaVlHelpPRTIrUnE1bSt3SkpjbzdKQkhq?=
 =?utf-8?B?ZmRic3IvejhCN2tydGxRUFRmN2R6ZW5zTXJkYU1qTUdoQnFObzR1U3RHTDJn?=
 =?utf-8?B?SWhvWk5BOFBCV3RsUlV4K2RCMVlDajc4VUd2WEtHWSthQkNjNDZ1UVU5b1Y3?=
 =?utf-8?B?aUxKUjByTmRZK01QUnJJenQraU1XVFNIWEJTVW95U0VrdkF4ZTFzMTM2cEZi?=
 =?utf-8?B?bWx4ZVo2eEw4WWV3ZWJSU01XbXJyNGxzZnVCNDBqb3B6MHFEa3ZaTzZPNDV4?=
 =?utf-8?B?UC85QUhPT1ZsNnk2YnBzVk56MDRjSWpOZUVlSlFQK1RGS3FxRWhVZE1PSWp5?=
 =?utf-8?Q?RW/GvYZb9wmXUfoZu/U9sMw=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4872bfc3-45b0-4f24-748e-08d998b1d772
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 18:53:04.2480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XK41+57IheKzquMBkmLNAZ99lVdVEGIHX94w97V11KuR2JwGxRsaoIS1LvvlirZXsH0MqFrLrZMwU2fkBkMbKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0302MB2629
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/21 2:28 PM, Russell King (Oracle) wrote:
> On Tue, Oct 26, 2021 at 01:49:03PM -0400, Sean Anderson wrote:
>> On 10/26/21 1:46 PM, Russell King (Oracle) wrote:
>> > On Tue, Oct 26, 2021 at 01:28:15PM -0400, Sean Anderson wrote:
>> > > Actually, according to the Zynq UltraScale+ Devices Register Reference
>> > > [1], the PCS does not support 10/100. So should SGMII even fall through
>> > > here?
>> > >
>> > > [1] https://www.xilinx.com/html_docs/registers/ug1087/gem___pcs_control.html
>> >
>> > Hmm. That brings with it fundamental question: if the PCS supports 1G
>> > only, does it _actually_ support Cisco SGMII, or does it only support
>> > 1000base-X?
>> >
>>
>> Of course, in the technical reference manual [1], they say
>>
>> > The line rate is 1 Gb/s as SGMII hardwired to function at 1 Gb/s only.
>> > However, the data transfer rate can be forced down to 100 Mb/s or 10
>> > Mb/s if the link partner is not capable.
>>
>> which sounds like the normal byte-repetition of SGMII...
>>
>> And they also talk about how the autonegotiation timeout and control words are different.
>
> This document looks a little comical. "GEM supports the serial gigabit
> media-independent interface (SGMII, 1000BASE-SX and 1000BASE-LX) at
> 1000 Gb/s using the PS-GTR interface."
>
> So:
> a) it supports terabyte speeds?
> b) it provides an optical connection direct from the SoC?
>     (the L and S in 1000BASE-X refer to the laser wavelength!)
>
> They really should just be saying "1000BASE-X" rather than specifying
> an optical standard, but lets ignore that fundamental mistake for now.
>
> In the section "SGMII, 1000BASE-SX, or 1000BASE-LX" it says:
>
> "When bit [27] (SGMII mode) in the network configuration register
> (GEM(0:3).network_config[sgmii_mode_enable]) is set, it changes the
> behavior of the auto-negotiation advertisement and link partner ability
> registers to meet the requirements of SGMII. Additionally, the time
> duration of the link timer is reduced from 10ms to 1.6ms."
>
> That bodes well for Cisco SGMII support, but it says nothing about how
> that affects the PCS registers themselves.
>
> As you say above, it goes on to say:
>
> "The line rate is 1 Gb/s as SGMII hardwired to function at 1 GB/s
> only."
>
> That statement is confused. Cisco SGMII and 1000Base-X actually operate
> at 1.25Gbaud line rate due to the 4B5B encoding on the Serdes. However,
> the underlying data rate is 1Gbps, with 100 and 10Mbps achieved by
> symbol replication of only the data portions of the packet transfer.
> This replication does not, however, apply to non-data symbols though.
>
> I suppose they _could_ have implemented Cisco SGMII by having the PCS
> fixed in 1G mode, and then replicate the data prior to the PCS. That
> would be rather peculiar though, and I'm not sure whether that could
> work for the non-data symbols. I suppose it depends whether they just
> slow down the transmission rate into the PCS, or do only data portion
> replication before the PCS.
>
> I've also just found the register listing in HTML form (so less
> searchable than a PDF),

Unfortunately, AFAIK this is the only listing they have :l

(OTOH it is easy to link to)

> and the PCS register listing only shows
> 1000base-X layout for the advertisement and link partner registers.
> It seems to make no mention of "SGMII" mode.

The autonegotiation registers [2, 3] both mention SGMII "non SGMII".

The mux to turn on SGMII is in the network_config register [3].

[1] https://www.xilinx.com/html_docs/registers/ug1087/gem___pcs_an_adv.html
[2] https://www.xilinx.com/html_docs/registers/ug1087/gem___pcs_an_lp_base.html
[3] https://www.xilinx.com/html_docs/registers/ug1087/gem___network_config.html

> So we have an open question: do 10 and 100M speeds actually work on
> GEM, and if they do, how does one program it to operate at these
> speeds. Currently, the driver seems to change bits in NCFGR to change
> speed, and also reconfigure the transmit clock rate.
>
> Going back to the first point I mentioned above, how much should we
> take from these documents as actually being correct? Should we not
> assume anything, but instead just experiment with the hardware and
> see what works.

> For example, are the two speed bits in the PCS control register
> really read-only when in Cisco SGMII mode, or can they be changed -
> and if they can be changed, does that have an effect on the ethernet
> link?

Keep in mind that it is not only Zynq(MP) parts with have GEMs, but
several other SoCs as well. I have not reviewed their datasheets (except
for SiFive's which just say "go read the Linux driver"). It is possible
that other SoCs may not have these limitations. So any experimental
program will need to also experiment with e.g. sama.

Perhaps someone from cadence could comment on what is actually supported
by gem/macb?

--Sean
