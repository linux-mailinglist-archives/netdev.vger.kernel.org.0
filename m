Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6402648B2A3
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbiAKQxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:53:17 -0500
Received: from mail-mw2nam10on2116.outbound.protection.outlook.com ([40.107.94.116]:8769
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238513AbiAKQxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 11:53:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1qefUSwJS9tfwL9WRjThCpoC7PfTswoATjALK9J+us2uH5Bre9H01LJ8ztGIObuqtaLM6IAh4eaUNu71+iSqr1XOKMXYVho4sCxtEWOqBNuGWdAisdRreQV/WNoBRev0jcG+J2OLiY3eRL3RRgDGZaqgwb6+MRlkHlq4lUbjksaofNgfKHhO00WxO84Fs7PImWfaXpxU6JT54Tfo9AkRnoZQ2LgQmysp1dHQZ8bq3k0x4fK3jtywcKrvtTQADHzH+ui8O5/V733Rhl2W7ooyfVxl5pPmhSMaScnlI0NWQeflX49cb6Tn+t8M+yfl0kGLhirZkypgIsH3lE1w5mgsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PWcgkz7jQn0HF4u5s0emSdhrlgdudujwoC/oj+5yqxk=;
 b=UVH2cv4X9vXtaPpjnfsw5LYPkREIb69sx83J7l8sD/w+clgRoFm8gU1Pfo2ZcbUqlg3JHYxp8OvmQ0CPl6JcNjO5YETiVQGWSTcuHnioPr+L+1c1Iok/kiIrUwty5xOumDSgbtuVSUedaZhinROaAn3TCMAaJwFmTqIXP0i1jQ5ech90ZIFsvjizqMV0o6jNmZuSe1JqLb5E8c8iuyeVjagkRMnathHmb38fumUFtuzrxsOfEBUNnL/NTJpK+vCgBUBrBkk7OLxjvEEozazPBAGiynH7GGdE02ptN+YoA6bW/JzHAYagQDFkQ3/lEN21iGtLHCofFP/NBhuK/PrKmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PWcgkz7jQn0HF4u5s0emSdhrlgdudujwoC/oj+5yqxk=;
 b=v6SVJpCptShr38bgUu7JLTn+Kym3bsSiQ4jr2FWJSM/cCh8o1wFJ1mmI99/bYoPWJHttbGkiFwQbk+yIpc/YUyj75Iaau1LZVrI7bdjUnKRabQPidDeDGtxamvgo6EQcUQwMXonYgyxAlaeAPOlDELHXj04kMtLku+KxqdnCBBk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1599.namprd10.prod.outlook.com
 (2603:10b6:300:28::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 16:53:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 16:53:13 +0000
Date:   Tue, 11 Jan 2022 08:53:30 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Lee Jones <lee.jones@linaro.org>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v5 net-next 01/13] mfd: ocelot: add support for external
 mfd control over SPI for the VSC7512
Message-ID: <20220111165330.GA28004@COLIN-DESKTOP1.localdomain>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-2-colin.foster@in-advantage.com>
 <Ycx9MMc+2ZhgXzvb@google.com>
 <20211230014300.GA1347882@euler>
 <Ydwju35sN9QJqJ/P@google.com>
 <20220111003306.GA27854@COLIN-DESKTOP1.localdomain>
 <Yd1YV+eUIaCnttYd@google.com>
 <Yd2JvH/D2xmH8Ry7@sirena.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd2JvH/D2xmH8Ry7@sirena.org.uk>
X-ClientProxiedBy: MW4PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:303:b8::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55f57d79-6f52-4c55-dc61-08d9d522db14
X-MS-TrafficTypeDiagnostic: MWHPR10MB1599:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB15991549F97582A340653748A4519@MWHPR10MB1599.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NvuIPIUFbbwnC4NBeysRHck8x8TRvwEbohvicC68Av+z1ATfMjIHE2fd3ue9O7yqA8PyC7kiL4DlAbJgXzeanh8ge0rXZMP4d9qVRb6uFw4JtcyDlKl//IDGf6bHUxH91kcaxw7zEpJD5O0+5Hf+6RUzQyMAjkqRwyDAYHqp7BiBiIkWpTZpOui1ylV4XW/66JbVMm3aGJ24PT0oRISdo/rarPDLqNWovinG98FbZYLwztX1BQFuIS/ICpC9R2rn8tXJ2awY3E+9wnmxg4OvPUWWsPwZCfvX2NIiK+I8wezTa4Aaf9/k9xYH2ZuB44YBoL2W96+hbJFEqII8oSNS9mVRzLg0cxrgP3bqdEhIBZ4lYdVYwwzv31ueFOzldCyTdoN5hVF+hYuJZzAmBjlWZQRUPxrZYlNL6tGeRW98rJ82/AAZQDR1zfgxz0OdJbgK75isthDgIfB+bgnsP4w8opyE/TcNZf1CjxHKvblzJ8QgNYJ28XLLhrzIvdHBZAd3qmGBYxSozNx707VFWJBE+C3xN+cI2sIFYX1l0xX4NFQIvICKsgnLmfZeWPFB3MU2r3U9pIsutLH8GylHhs4bwYdRCP25qpOscVWjdKaRjfXGmiRpgi2/AnIZMAbNpb/lSVIdAyakA2eGWOP08ft0PsCrwfZQSVBGGA3k/sTNtW9WvaIpsmUuCAK6B1T8pekRpmPr+5IagGuimJS7/xIRMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(42606007)(346002)(376002)(39830400003)(38350700002)(2906002)(6916009)(186003)(6506007)(52116002)(66946007)(316002)(8676002)(33656002)(6486002)(8936002)(6666004)(5660300002)(66476007)(38100700002)(7416002)(26005)(54906003)(1076003)(508600001)(86362001)(4326008)(44832011)(9686003)(66556008)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D3Wl61PwY/Ms+COdV8IBHgBLbnbIpxgGbsnJ/UcMO1uNqPETu8MnhuNQdWer?=
 =?us-ascii?Q?EkVB7S067qxM0KgiSQkOSQMT918zoxOqMX+xPQq0jycbVVKwwgduC5ClLXee?=
 =?us-ascii?Q?PogjNQA+3a0OnpIRiZNxa5tcfBfF/AEJSwjZf7zXQ1DLGMD2IerNGvjuti4y?=
 =?us-ascii?Q?o5sUbRAJxo4p1HsvMEyn3cahL3x9/gm3Qc2shn8AyXfGPcT068/SD+9/iTIg?=
 =?us-ascii?Q?HBS8WIqgYl1bxH6y0zzyYIGQRkLaD1NqGUxjl99Q+syMcbSdW0MgvugbV1N/?=
 =?us-ascii?Q?GvZDSl7nXBQ7UlJ35p6VOr/e5v4rbubst0VhDA4fLrUdd7EgacQW3M/y2gIm?=
 =?us-ascii?Q?HJ+9JvvljfqBA0RwwWN1XxdJ0iTwvaTmm9UDU93nlo7CAOJIq8iNloUfImDI?=
 =?us-ascii?Q?j/HZWnCO4PFSG1pngw2qj6lvnMawnBjONxrkaNWtP2+uXoSnzSgPOEKHIGeZ?=
 =?us-ascii?Q?7vxNRehIH2En9Go/Ol95Pz9tetCF2FIBUw/66qqTuKJdCrrtS4kfMLDSJQ9H?=
 =?us-ascii?Q?5ShGqTQexLaWk/k6PRvTghqNUUDM4OrMetfkTaDn3CI9VycB458aSqjSiYHK?=
 =?us-ascii?Q?yvytBFObZqhp3svzYmd3ZZoS3CQyOhVMJYjSKOgz4KRH82LPvucgIkS/XdR8?=
 =?us-ascii?Q?28srjHyz886F4SasrC7ku8d5SQU1aELNzta4zNd6foainBzINer5nukllzs6?=
 =?us-ascii?Q?ci1IUYdxJwO4hdBRUrZ1BEQ+5sdljaSOl0abY4soES9TJOKLcmdW99N7Zl4s?=
 =?us-ascii?Q?+z4KnkIiDAA3G/M9R4Vh03HGC8aAgXfI+JWaN/9wkEenzoezDE55P2x+fdgL?=
 =?us-ascii?Q?CLUhmQMp5BwNjIMRZBQ1OMNvesZRJKYMv4W+Z5sibZNTGnofnE6wXCBzeWo0?=
 =?us-ascii?Q?MgrIjEVK8sgAndOVJN+VGc4dQAaIarS6lmgZUsWXogvVEyaEyCov4UktNu8t?=
 =?us-ascii?Q?flTJ3QIapzNgOK7FPSEGphJXX/UKTSYTFQ+qPBb0pXuxj0gvhVeaXUNZcWHi?=
 =?us-ascii?Q?RqeXu+ggYBXl9I5yjGjwQUKNwv898eHslbivQH7zhYN4gG50yG6ihY8cKCBB?=
 =?us-ascii?Q?yDNIMpX4ZDYaPbo4VnlTNY41yhawwTo22sq22NGivuodhxnHUICw0n38X23v?=
 =?us-ascii?Q?iDfjUqPJH0FJqnMc3mSjr92u4Wa7mUGdXEpT3PSplzqVa1iv/+sLHZlJ1z9Q?=
 =?us-ascii?Q?RGbgUowxsKgXuZTfTydSsX16BnhaFBDQS01/pcBAUkz+2L9GCAJtz7dNqOM0?=
 =?us-ascii?Q?HXbVAZeps1ZoXHzG2ZevHUUIuiiMBQFYnhwB2FOD8Ws3MpigxBM62pnvuahf?=
 =?us-ascii?Q?YAqoOCkFMv11/omWXT1HVRKwUED3ue1zD7UGDY42WEoXuxSnVVar34gq2BsZ?=
 =?us-ascii?Q?zcy9c4jdtB7ksK91t1QpKrzYAj5q5qXBqaHwDU3SlkyCrsDuHAaWHl2S++31?=
 =?us-ascii?Q?dmvjbUg7bg8e7X0M0bhKnj2ByL7AuUtD+TamfV8Q+zqe2MmQuSvd1DRWwhyD?=
 =?us-ascii?Q?8YIMFvNAvG0tirXDFgPz0J3I20um71IbG6HPZvDP3/qNaeX6OwU2wcUUptcX?=
 =?us-ascii?Q?KbeH9Gafu2XRmfzJHMnai11vT8Md2yS8n2HafyVJj136cRSbptOVhMh4xCFZ?=
 =?us-ascii?Q?pMruOt6UEKqCVSGfXcr0dmcfRW+hWtsRMYD4uMkYr4Pnu6uQGoI3cxnV3liL?=
 =?us-ascii?Q?hzeMwg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f57d79-6f52-4c55-dc61-08d9d522db14
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 16:53:13.2848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8MGTk0SzbZLnJMpQsX3/TGnwuwivvuqooc/Hifu3uyHsw9ao1PUWJsedpoMCDmy04OEe9J82xsNR1Hljrm7S9nECSErlPRNomGyvd2MCi4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1599
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark and Lee,

On Tue, Jan 11, 2022 at 01:44:28PM +0000, Mark Brown wrote:
> On Tue, Jan 11, 2022 at 10:13:43AM +0000, Lee Jones wrote:
> 
> > Unless something has changed or my understanding is not correct,
> > regmap does not support over-lapping register ranges.
> 
> If there's no caches and we're always going direct to hardware it will
> work a lot of the time since the buses generally have concurrency
> protection at the lowest level, though if the drivers ever do any
> read/modify/write operations the underlying hardware bus isn't going to
> know about it so you could get data corruption if two drivers decide to
> try to operate on the same register.  If there's caches things will
> probably go badly since the cache will tend to amplify the
> read/modify/write issues.

Good point about caches. No, nothing in these drivers utilize caches
currently, but that doesn't mean it shouldn't... or won't. Any
concurrency in this specific case would be around the SPI bus.

I think the "overlapping regmaps" already exist in the current drivers... 
but actually I'm not so sure anymore.

Either way, this is helping nudge me in the right direction.

> 
> > However, even if that is required, I still think we can come up with
> > something cleaner than creating a whole API based around creating
> > and fetching different regmap configurations depending on how the
> > system was initialised.
> 
> Yeah, I'd expect the usual pattern is to have wrapper drivers that
> instantiate a regmap then have the bulk of the driver be a library that
> they call into should work.

Understood. And I think this can make sense and clean things up. The
"ocelot_core" mfd will register every regmap range, regardless of
whether any child actually uses them. Every child can then get regmaps
by name, via dev_get_regmap. That'll get rid of the back-and-forth
regmap hooks.

I think I know where to go from here. Thank you both! I'll send along
another RFC soon, once I can get this all cleaned up.


