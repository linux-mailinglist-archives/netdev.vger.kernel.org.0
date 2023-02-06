Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728A168C264
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjBFQCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjBFQCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:02:40 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2095.outbound.protection.outlook.com [40.107.92.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A319CC2C;
        Mon,  6 Feb 2023 08:02:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0lnpJ/VnuD84XOQfa+mghEnmDwG3nr9Mtoo2YZuL46PL00Wr3MnGSbOpiaVW3/htcETWx43FZvw7o2x5pHR304Rtw9vvXKhKws5Oj0FAXI21JSWcbYrm8sEV3bEud2E86daColNxSWtblAefPfx3eDs04W4y7yuCG1PP51nXN6BThlS0g7mTyFY/LUj+h9MHdkBGYTVTIKFD7Yt2GcYdiL25q7B/bHJCaeb4+hgIFtgngPkvOZLItLJhbKBu1xC+f96qaw7A3RvbNCktD0apL9vpj+vgsRhsMeJRZMIZzBd55VSjubAQUPxgKWkAL3CQjjTnlW9roGGmuEiC7W2LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElbqQq3AfMbIofWiTsbPWBjKCmxBgVLCoQHIVzFfxX4=;
 b=C1rlvlr0MxlWVnfeL7TY/2oycQt+uCLXT8Tr/0yXiJDOE9SfNbIvoYnEvY+mbZOJA363XlJoBGcgxOPtpTs5F1m071742JKC9e+Mfn1AIxhW91SsNtdWtVYYvSwEiS+YZMICDabEmru41xF4+KSxfVLv0foXu3xa50ey2Sbd3zACc1DRkCa2Oqzz4piKgltWV5MbMixnjxFoNp/RSRyXaiFxT24xW13JOleeoMx/odPTi1PH9wz3sS3ll33uJZoOCQ38KJxuy4Mc4R4UBNqeVKl48SnbaewNqi8hTol4Y7O/ZxzCtAFl9mr+UN6BnVRy1ZA+2gZIFx6dWVIo7ybrvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElbqQq3AfMbIofWiTsbPWBjKCmxBgVLCoQHIVzFfxX4=;
 b=q85Ir+LI4oAXYozXuoIHCLwOQJcXN+UQ+CzjP6NZA4JwW4jtqeM071+DdtJWM4Cm2Nm5iy/d0OJAUVO5/wmR0lyiVmrVbVeYd1cVU5UVQuYbFJ45c0bHUytQmbqidWIco8hKAMYoCsBlR9cNO0Vj1ky/NaBDyMQmOV+p6ui0C2Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5668.namprd13.prod.outlook.com (2603:10b6:510:113::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 16:02:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 16:02:36 +0000
Date:   Mon, 6 Feb 2023 17:02:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: implementation of
 dynamic ATU entries
Message-ID: <Y+EkiAyexZrPoCpP@corigine.com>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-6-netdev@kapio-technology.com>
 <Y9lkXlyXg1d1D0j3@corigine.com>
 <9b12275969a204739ccfab972d90f20f@kapio-technology.com>
 <Y9zDxlwSn1EfCTba@corigine.com>
 <20230203204422.4wrhyathxfhj6hdt@skbuf>
 <Y94TebdRQRHMMj/c@corigine.com>
 <4abbe32d007240b9c3aea9c8ca936fa3@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4abbe32d007240b9c3aea9c8ca936fa3@kapio-technology.com>
X-ClientProxiedBy: AS4P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5668:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e9b3a42-5728-4a9f-81ac-08db085b8fd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UbNIGPC40yaAs0aW5MSN2UM3rNmYlfZNYUGIrxf1EbVeVQJjhnUGfcPQGBP6dSAuUHTWR3FrUopHN1rSUNtWC1MQEPie9LHsGP/ZoNnZmzxb+uBAnmyn9JlelJPxuTaM//upXgnI2/JCMgQ0gtwKWF0IbOLwsaKDYP2vnoMwohL/Md+u916m3/RbQ+NEA1UiLhG3QTNEgUJNjKPxb0enmB4PEcWCBFsXY++dXYGVN01/W5jSK3+n19uWoyqoou00lMkMjVaznLgfcE/gDE3tC2XJJLsX4M23hvQgEHP6MBZjIQFs7kWk/FkaByHISi8yjDwPmjLaIXL6yU3Sth9UKJPBerwUdNPz+/VXUnajltjkYinodxTwrJc8HhTOfDX+tqul467GMWCPrkSZejdvrc0y8hrYpTTKoAr2q82nJ5vCeYP++WwvOWZ6+MfEG3ySHqfMvzwBV6XKI89tN8p4VjjCkPuUIqNy7TYQF4us8QjKs6elIK8D3q5gfMF9QVAuJihpG5MHHF8DTkL9t5bjxHxi44rmfpUJ5X3KMkXJc5xv7n0R/bBfLkaRsDdTwcfS1YSTOmkN/k2diuVeHMzL/FmyH2pz3pcYDYdmvH1V3fqHpWZHcbobImHWoGvUV2qux7ODvCqj+7Of0CFt1exJRD8yAiYK1FQnI6Ng8eGoPPk4UJ3qqRxdh5Xt+Ve0i8QVhoJczDgSqRs8TgDd+3x6e9B2VrxSOGbCCS/BHkdkdzDlmV/2Z/Ne5Cw3rVfHb+em
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(376002)(366004)(346002)(136003)(451199018)(83380400001)(8676002)(4326008)(66556008)(86362001)(36756003)(2906002)(6916009)(66476007)(66946007)(44832011)(54906003)(316002)(186003)(6512007)(6506007)(2616005)(6666004)(478600001)(53546011)(41300700001)(7406005)(7416002)(38100700002)(5660300002)(8936002)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uohi0R2nn4MGiB8KYcLVCOx15HxbrenCrQanlov0M/N1cX8v5IMIsW63JeJs?=
 =?us-ascii?Q?1oAhDqp4UPyyIRzLzvlsomuACGAeEeYXhJT6ytE8wEXGa5II9styV2Tj+fG6?=
 =?us-ascii?Q?4kFCqkgbsZIa4pBeCrBwJymq1NX6Tsi+8Xo1fK9tfkOhhmL5YNXGCH/1qRgQ?=
 =?us-ascii?Q?ODSl9L096Vk/Px5H4roZ/0Hg3QETejROFa95UPtjdAOCLskdvFBvzZeDGDvs?=
 =?us-ascii?Q?DAhHarVPFWDSBlpoxUQwAO51g/oqw73cF+MuUfKXzuKki/Kq2VncIVrVRH4Q?=
 =?us-ascii?Q?Qq3Jd1NePoCPG8oR4eXF+0ms6ZeDXyvUQis+dETW+qFdEKplzvcen26QwDmK?=
 =?us-ascii?Q?JAkyJUKwxCXZsCotozGIQ/A3R6hDBI0zqwp1Am/wbye+urvEiDgYHSgtW4fO?=
 =?us-ascii?Q?aW4rLBSWOrli3+WCg3sazI7/ahHqw+zdUaYil6wqfAxCjK+UrcPfT7FHW5Nb?=
 =?us-ascii?Q?X/WZzxjfKTMYXPQcbtFTP8BPmqKc4raKbKI4ZNoMrRL/qUojFzpeW4EFG0Ra?=
 =?us-ascii?Q?rng6lQhUDvvdVURw5TYl1tj/xqoZnv52CtMAQpmtw35cduAJTmeSwogRlVDu?=
 =?us-ascii?Q?IloWJcezW6vYod2CTqWaziCA3NseSAwc9/5n48GFbaqHpodht/k411q2Y58M?=
 =?us-ascii?Q?QloX9KwW+5XMKgwT9qOSAjIRFWNtR2349CdC1UaDrO5Aiqa4Hb5WvgOLWPkh?=
 =?us-ascii?Q?AZVnfvQbqlJnFJL8Ky2gH7fYRyY+gzloucY7RbahqNskVyNwjJZWZylXSUhm?=
 =?us-ascii?Q?WU1syFGkjaVRxdRlkteAMIT59LpqKZOPG0sFJIW0yrIWEQjfEuoPq+4kAFPT?=
 =?us-ascii?Q?GFLN8UF1v9gD6X5l0DCKFq7T3b6Al+OqYYDKvozBPV7LC/t07asTHYcYMlxP?=
 =?us-ascii?Q?nMt/eqmW1WQFOSxiG4V0y/TThNaV+hYcjpjX2LTUDOaKwbiHIbvDYGiMQz5X?=
 =?us-ascii?Q?IjJrzJD+NxnGUMQ8DWxnCGsrEuS/sSJCgvTBXCm4AHITINlVCMZ3YEHdSkej?=
 =?us-ascii?Q?rZqu779fuRbHxcBqf2j4ASxU5i5mqs5QrYESesPKNk1y7y/RdG/xr6KIBirR?=
 =?us-ascii?Q?DZwrIBlSsvEbzGmghiwsdHy9EpFForBJ1XcM4edNHRSqrG+Tb+mpxJWcGSo+?=
 =?us-ascii?Q?8lrC+Hhn3Tg5Z+9KufbjfJkIvhDHhNaqmZRgXN1+mahfqKixLTVju6cgr2F7?=
 =?us-ascii?Q?AbSRlTYWK3EKZRU08Bl7u/eAYupYFSsJThRI/GC2ciGO73oC11P52BQ8kCfO?=
 =?us-ascii?Q?nU8k3NOATMbHAiBTEYGBidd0liJ9wMwaXNeIz5wOmB5R/PZ3xXQbsvHVZAmi?=
 =?us-ascii?Q?3bxGDILPMdHLQOAKczuyvAjujbB0VG20eQbjXmaavcLFs+a7vIOBllotw5WS?=
 =?us-ascii?Q?tvWOG7HntczabODbPKyXmBVOpI//7OFHC1i4O25Q2zD02/e8u2uRHDpwXaoh?=
 =?us-ascii?Q?BW+FbKT+pK4ETKgKKgKPbRig/YlErZ+uKEDlaVaY/BCBJStUZtKAduSv41Si?=
 =?us-ascii?Q?mRtacpOpd8SIzgCWze67BFgsaayf7ul8RrDWRn4hyQCIS+PmwLW7c/2AEYkm?=
 =?us-ascii?Q?YAlpNzM7PYfvBl8CzMYQBneLoqLzRg14ZzbjJsnSdgn0KYvq7E2chH7JeqQm?=
 =?us-ascii?Q?DF2aRZuNB7Wl5+zsQ8kTjAhHjm/V9zhk75Xez3c3lEoQqN2vOSvuUjSaNNkZ?=
 =?us-ascii?Q?hOKcaA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9b3a42-5728-4a9f-81ac-08db085b8fd6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 16:02:36.0689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lQkLqqKGvJq2rlx33P83+HIXKrhRqfbgo3S4MzvXmdTWCz1LnNBe6CptuJ6CppV4ZrzNKz9feE1JnftOHW7CdRUk4GuQMPGkyCf3fxCMG5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5668
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 04, 2023 at 09:48:24AM +0100, netdev@kapio-technology.com wrote:
> On 2023-02-04 09:12, Simon Horman wrote:
> > On Fri, Feb 03, 2023 at 10:44:22PM +0200, Vladimir Oltean wrote:
> > > On Fri, Feb 03, 2023 at 09:20:22AM +0100, Simon Horman wrote:
> > > > > else if (someflag)
> > > > >         dosomething();
> > > > >
> > > > > For now only one flag will actually be set and they are mutually exclusive,
> > > > > as they will not make sense together with the potential flags I know, but
> > > > > that can change at some time of course.
> > > >
> > > > Yes, I see that is workable. I do feel that checking for other flags would
> > > > be a bit more robust. But as you say, there are none. So whichever
> > > > approach you prefer is fine by me.
> > > 
> > > The model we have for unsupported bits in the
> > > SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS
> > > and SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS handlers is essentially this:
> > > 
> > > 	if (flags & ~(supported_flag_mask))
> > > 		return -EOPNOTSUPP;
> > > 
> > > 	if (flags & supported_flag_1)
> > > 		...
> > > 
> > > 	if (flags & supported_flag_2)
> > > 		...
> > > 
> > > I suppose applying this model here would address Simon's
> > > extensibility concern.
> > 
> > Yes, that is the model I had in mind.
> 
> The only thing is that we actually need to return both 0 and -EOPNOTSUPP for
> unsupported flags. The dynamic flag requires 0 when not supported (and
> supported) AFAICS.
> Setting a mask as 'supported' for a feature that is not really supported
> defeats the notion of 'supported' IMHO.

Just to clarify my suggestion one last time, it would be along the lines
of the following (completely untested!). I feel that it robustly covers
all cases for fdb_flags. And as a bonus doesn't need to be modified
if other (unsupported) flags are added in future.

	if (fdb_flags & ~(DSA_FDB_FLAG_DYNAMIC))
		return -EOPNOTSUPP;

	is_dynamic = !!(fdb_flags & DSA_FDB_FLAG_DYNAMIC)
	if (is_dynamic)
		state = MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_7_NEWEST;


And perhaps for other drivers:

	if (fdb_flags & ~(DSA_FDB_FLAG_DYNAMIC))
		return -EOPNOTSUPP;
	if (fdb_flags)
		return 0;

Perhaps a helper would be warranted for the above.

But in writing this I think that, perhaps drivers could return -EOPNOTSUPP
for the DSA_FDB_FLAG_DYNAMIC case and the caller can handle, rather tha
propagate, -EOPNOTSUPP.

Returning -EOPNOTSUPP is the normal way to drivers to respond to requests
for unsupported hardware offloads. Sticking to that may be clearner
in the long run. That said, I do agree your current patch is correct
given the flag that is defined (by your patchset).
