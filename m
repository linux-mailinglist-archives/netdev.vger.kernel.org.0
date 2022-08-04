Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C30589717
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 06:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbiHDEfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 00:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbiHDEfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 00:35:41 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B66F6372;
        Wed,  3 Aug 2022 21:35:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzXKmJfzFrVSOVQ3FFpEjQ41Z/LF+gPk5kZ+Nn2ts0gjtz0DYuOeps2f/21gLarC9MQZeJ42hScbQdkIyqcGO/7PnRiRJfxs426I3gHr7cN1iTDTIE6CV8t48/qXaFPT8bt4eMm6vc451bQ3vfQ5G4XTxtGNDMlPOM6qdZzSika679LKIf/HuPeEDkxMHcAyMrcPiJDDoLsVs9t72+8t30tpbosyrOroAS0+VeHpmLXqQsa84IcZw+8XZcnutqTFXFEriaPMyyQ/24EgCwxYwtMCGUSD3YjFqrq0VrDoaj+mvI692Dg1E2EbkCjt0zt6FoYrYr3SjOpe9lLJBRYLLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WnRBIluF//u41KR47BcOjmbpeweonwGbRRlBMxpp/+I=;
 b=DbF8AeP4h/x9iaF5amhBCHKag16qgIsH0U5WsRgPhltcqwTvfDvzHu415ZIs/mACk0hY4JGGaWiMPtNTvLObi12FpBA5sKYhdf6kmDPUGCTojC/xhtfoZnPUklP7mcEk7Xe4/PLjbe6IeYmLW5CksU0YpAVNg6ehtnO3A9exr+6A//4dlq+sWQCB1J8dgTLrvRgpISWS4WuuxfyqqZ+kPkoYyafxcpeYgK5Bs5HFNCbFoKx3ZPPj7MyLNFrI+0+Tv469D8GlTO5L93iMoxNzI/HzuBiiITkwOgVP0nISLZCTgR3Yulsh7HY+G7YiJnnU/HlVyyz0ZZBQHHeoNjOXiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnRBIluF//u41KR47BcOjmbpeweonwGbRRlBMxpp/+I=;
 b=dS4TFbxXkTWTygDtnUjVvj7Fd/5AfW/iPKvg1jm3AQ6YhxAOJHDTlTo6GRcVeL+oz8ht8bhYr/P8G2DeNi8oDm7pG01bfBLzIroyA42c3WSE/TIc33/DZN6J47UkywqLsUTB/fq1Ma0aGoZehvAzKjIR9os9nAvz1+Zb7lyWRhU=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by BN8PR12MB4788.namprd12.prod.outlook.com (2603:10b6:408:a3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 04:35:31 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::444f:f2a:5b01:7ba6]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::444f:f2a:5b01:7ba6%5]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 04:35:31 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Harini Katakam <harini.katakam@xilinx.com>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "andrei.pistirica@microchip.com" <andrei.pistirica@microchip.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Subject: RE: [PATCH 0/2] Macb PTP enhancements
Thread-Topic: [PATCH 0/2] Macb PTP enhancements
Thread-Index: AQHYplzFWk164uxtMkW/IEqXxo8RKq2eCMkAgAAhI0A=
Date:   Thu, 4 Aug 2022 04:35:30 +0000
Message-ID: <BYAPR12MB477398D36AA066E9DB639F099E9F9@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20220802104346.29335-1-harini.katakam@xilinx.com>
 <20220803193444.3b43730d@kernel.org>
In-Reply-To: <20220803193444.3b43730d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f36afa34-f775-401f-a095-08da75d2c381
x-ms-traffictypediagnostic: BN8PR12MB4788:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cIIXqsBxcXKkvjnCwLueoLuoGc/4ZoWM7swEpa1dMqKBLdNpr7CuP+gi4D8dfuci1W9VcuOCo7rDUyr3sFUMEacR3RCf6wmi7blidVDUuxsWZFQBDqlawj2wvv4ZWQwT4q6y0gFLPIyh9JRF2unWfvR69ombxnVs3jXdMDquq0NqSdfVHW9I0OEIO4bdr9izzTfUiyNsi6LpGSw9lO7VyQ7N+xfa4Fe2Q5gEODvkO7R00wfX2ILlUK9/V1+XNG0GlLQ3nsQS9yzoRXT3aLZcdmgi3JZq+hPS0zETrGc5u/35Hnrz5WTMyLYxibIRSEoTH6XECPxjk/7JmYlT0ZNw8+irNdX9C/6YIkR2FU25pOVr/6ATGByeQJic9v4fHWporJ4qEgmO0+yFz4xrHFoxxzZvkD9OX/f2DYoORbjgH9PwWlkpaiFj6K2HbPATYsllej/2NwEmN8hRPQqQFqbI6HJ/RP0VZDsQ3eSQwrFFZrPMnYtBkMT87TQlYeNFnvUx+jt3l3CLcCpDS6z+qCgLdvd/1JOZ0mrb+mmVmNj/kMv/SB6eaz8QjjHhaYRORC04QEMdsrfoPYgIZfP1nUS9jax67lGvozzzUNP5XCu/rHgzXiJKAkrLIrn1PFc+oN1sJl9B6p1hPNM/RiLSZ/ja5dcfPrfKENdwQYXxpgWEuslLDnSyDqv2T9cbhixd0ueJUcCNLvl/dM0ogfvX1PWaE1v7e/Icg65kXRvUl7PyKiYM+FSaxyJEw/bNowQashnAc7tcSAqeJOLZ/HFz/PsqYD02KzQ4fHuAlPPU1jLRu0qNxLY/awtT4ETptol25+IaJ9as976lIn23GroieM1szui0yK6DLZIx3YAXPb1TAlYDvSS+0FUthRtzfh6IqlS7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(26005)(966005)(186003)(9686003)(33656002)(478600001)(41300700001)(71200400001)(38100700002)(316002)(54906003)(66946007)(122000001)(86362001)(66556008)(53546011)(5660300002)(2906002)(110136005)(76116006)(8936002)(7416002)(66476007)(38070700005)(83380400001)(6506007)(7696005)(55016003)(66446008)(52536014)(64756008)(4326008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a4GqOPQYysejTUNJbTSVdl1QTgTz30sRQQ0bMISXkGngINLlu9rgTlBd+faC?=
 =?us-ascii?Q?FCmdteUX5YzODoyQYFOz0ABy8dtPWiBIQAcLwvuj/t7GR7XX9ky4/YeASOo1?=
 =?us-ascii?Q?89BeRkU8hYy15Zbj2qJS1t6NyTf/WuSsn23H+nAZGLYSxkzm/NTIsSr+naGs?=
 =?us-ascii?Q?p2lLWMANhkpPYHbHO85CNRu+RQgd7/S+Z5/syoCVyzzteUm+f/mWDzLCpdFj?=
 =?us-ascii?Q?fp3S033AJK7gte8SzhmoQOqG6UQOADpRt6oqE6scwfDZCuBTi4PyH/QRhycI?=
 =?us-ascii?Q?qPrKZFDGG4DPXqXpVpjWyu9Tqrlue9pRoCEH3G7+YC3iLe24TLJl7LWNA4HC?=
 =?us-ascii?Q?LTFMhHHDNESsCF+PNlShuWtnabyi7kyKTfsuv5Pp7lVwUVCZQqnepvmAa/aS?=
 =?us-ascii?Q?oKlBUi5RX8aFXBtWZGXV2Z4iorbfSDO4XnBqGMc7K9FkAGY9Ml5kB1vChYws?=
 =?us-ascii?Q?FkIPyuGfN3GbkBR3z4Mr7CrLsikOqYqPtnIxfQ48hbKLkSzag2faULq4BPhH?=
 =?us-ascii?Q?LLjaggCKfyu68pkSKHcEq4myZXWG7w9NaILEGpDPo/XBFNOLnUoEKkvfgGLP?=
 =?us-ascii?Q?HGA89HNkhUW3GV/t4JsihCHnYY7ftSxB1NXy6Wtk1yirasWTlje3ijIzF+Wd?=
 =?us-ascii?Q?+s4BCyiGZaKgivEXiXKb2e8J2wgVfvlPmFID68Rgfnx3qnh1RFdwShkcKlum?=
 =?us-ascii?Q?wBcjHGY+fGxto++IJR6hsK50z0DX5utPqAPJZxbQU9gXlUjiE0Sa7VQn+Gw3?=
 =?us-ascii?Q?61SD0r5VoCN3ZdTb38cYrFF973efjKfOvC93+LUNU53XAYoITIvO+JoZBCEB?=
 =?us-ascii?Q?SdPyN4EGZG9HeFY/Fv9D6o3FYLvaAj33pooR53EYZS2DoFc6Wz/4tpW8MKZL?=
 =?us-ascii?Q?fwjh8XlOLEPZAo24KYXb3L2R08OrvivWqHgUvcBf+iDwbmQ0hwyrts3U5RTC?=
 =?us-ascii?Q?UBjoGi509b+Bb4ZIbLBryjvCUh5RcITJA8x0mBKDI0Xzg81mjhP+ci8IW+OI?=
 =?us-ascii?Q?8z+Cpe8Ry4A/V9IVmLVzwWBsgsRU8jEsjQDIZBMNRf4QZsIRx5hlv//MhX7c?=
 =?us-ascii?Q?hlWqHG/629hUkaMVlEW3ElD7bCCzu/EnyaPHo7n2y4GEZ4xGFvzrv5GweL6K?=
 =?us-ascii?Q?29p43m27LpDWYLRus8GQuPCsZtCPHfCKk98Ve+Y5mPOK1hyLbPY+EPRROcmM?=
 =?us-ascii?Q?f0Y8DZSY0KyhIrhG0pQ+tRmItK0m58VbGHX9cVXYvhJMJ94Kkmk6XO0MI3hy?=
 =?us-ascii?Q?d30Gv08PN7Q1cGf0fZ12Ig0LKZ/U104d1ZReB7zHU844RYQI+qYmz3/g2Vnw?=
 =?us-ascii?Q?SLeOIcDRzc0ljREkfOBTe4JJQ0jomHr6Zf9QYfs+jw+748HKG4eNiB3U0H1N?=
 =?us-ascii?Q?VJ1K9/OFq2/ZvA+5Rsn2tYeOi6F40b6KpbyIfhqw4wRC8eKfnfnAh8NvB/ep?=
 =?us-ascii?Q?eaYWdD2KgK/TI7qbSUjuwAXEVtsUw4ZgQJY+RRMYiMpId6I94B8Y29e0emEp?=
 =?us-ascii?Q?c9n8DOicGBdju9nze8x4gw6CjnVfFUZ8BvdsZ5m3w+4DegoTW6JvkOvtmtak?=
 =?us-ascii?Q?0Pv9y3+MvqIjcRjCaJk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36afa34-f775-401f-a095-08da75d2c381
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 04:35:30.9355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +wpo5OknIZGsWmfxDlJy6LHJfU7hohMUpcM+zXuI8wWLDVBaawcofZtXN+NmuRuZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4788
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, August 4, 2022 8:05 AM
> To: Harini Katakam <harini.katakam@xilinx.com>
> Cc: nicolas.ferre@microchip.com; davem@davemloft.net;
> richardcochran@gmail.com; claudiu.beznea@microchip.com;
> andrei.pistirica@microchip.com; edumazet@google.com;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; michal.simek@xilinx.com;
> harinikatakamlinux@gmail.com; Simek, Michal <michal.simek@amd.com>;
> Katakam, Harini <harini.katakam@amd.com>; Pandey, Radhey Shyam
> <radhey.shyam.pandey@amd.com>
> Subject: Re: [PATCH 0/2] Macb PTP enhancements
>=20
> On Tue, 2 Aug 2022 16:13:44 +0530 Harini Katakam wrote:
> > From: Harini Katakam <harini.katakam@amd.com>
> >
> > This series is a follow up for patches 2 and 3 from a previous series:
> > https://lore.kernel.org/all/ca4c97c9-1117-a465-5202-e1bf276fe75b@micro
> > chip.com/
> > https://lore.kernel.org/all/20220517135525.GC3344@hoboy.vegasvil.org/
> > Sorry for the delay.
> >
> > ACK is added only to patch 3 (now patch 2).
> > Patch 1 is updated with check for gem_has_ptp as per Claudiu's comments=
.
>=20
> These were separated from the earlier series as non-fixes, right?
> But we are in the period of merge window right now, when all the new
> features flow to Linus's tree and we only take fixes to avoid conflicts a=
nd give
> maintainers time to settle the existing ones.
> So these need to wait until -rc1 is cut. (Or is patch 1 a bug fix?
> I can't tell.)

Sorry, I missed the window. Yes, both are non-fixes and I'll resend after t=
he
Tree is open.

Regards,
Harini
