Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115455F57BB
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 17:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiJEPoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 11:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJEPoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 11:44:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2119.outbound.protection.outlook.com [40.107.223.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FE52C671;
        Wed,  5 Oct 2022 08:44:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hf1PUYd1MfSt0+WYgUvijocNhU9N+e5/fYWaUZa/4ykq20Ly/o0EoKwFZ/mGGas6MiQlOaS/YANJ3zz6ACoATJf/tJ9FimWdiFAp+P9PSw4x2U/He+PgbsmJqpfU0AM+CJDFU2US6pghzA4Zi39wcVKfbUp+WlrbKfzIcUVqx1qqK1Ytzosup26BiYilJNP3Y7HmeogpYikXKjjn97MNzkQkYbS0g2YxWLM8i1u9jtuzGo+Yuhuz1ctJ1FvFesWEvcM9f6h//DoZVincp+WucovS2tKW5J5gH47UbVzGu9I4FkPf+bXBRKH3grdbTtVX5TeH7wJhUTOJEfi5TmdEgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4GwRQ8ETyiVCFacxIlG/n+pxE/51LtmPOHfLUjdKMg=;
 b=H4Fg3L83uvk1rLJqkbvXRZkVA32vPefbmMl6+IBiBBwZwrdBdZep+OK2URoNYCX5OdDdEtsQwjRb8+VRuQ7LWDec2A2utHtbYN9LXU0sk0O1aNhxBpP3VF9U5twkMMO9+vMoPGgBIQ54JJB0Qy1EvOXTFU+75jKjkWkqxnjPt21TvSHUoaEejlLHpBmUYW4vLBpEcVwn55XLsWJtgXVP+dB1WM2hDHzLC62yI8rkowZcMTWg99Lh9n+B0nI6S5fP/9qNc2ugEVcRFzr7b6Wrh2Mjk1JBDJz1lnOY3IBWNik6lRJTAv7qJRG9MEHF6fbpINqWEBf5dtYl2Z3PRNLGrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4GwRQ8ETyiVCFacxIlG/n+pxE/51LtmPOHfLUjdKMg=;
 b=JS3f1gDs79dZG8A+LDDMliwRseLDEtSzD8mDazLQiFX7nn/rxQDdeszzfMKCyPQhou2ZQ64PPUTLoquVxopslzspmZwcQXFsP50hSaXJnEgb2CPJgcRXl+0BwDhtAo101XdiAl/4S1Ddx9GWgoyEY6zhpYfoUvU5XkC3IhMcl3M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5173.namprd10.prod.outlook.com
 (2603:10b6:408:127::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 15:44:14 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Wed, 5 Oct 2022
 15:44:14 +0000
Date:   Wed, 5 Oct 2022 08:44:08 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <Yz2mSOXf68S16Xg/@colin-ia-desktop>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <YzzLCYHmTcrHbZcH@colin-ia-desktop>
 <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
X-ClientProxiedBy: BYAPR07CA0047.namprd07.prod.outlook.com
 (2603:10b6:a03:60::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB5173:EE_
X-MS-Office365-Filtering-Correlation-Id: f1eadd62-5053-4055-6725-08daa6e873f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HMySK3iYLvLICY8CaBYW8h4YBboneS97FaYMEZ6HUoP4Rnae+glg/dsCUoLfPDQvEKdRh1WXN+DdmCU8fk5hQpxb8nRxZe+5ftHoi+lXVeX/rOVBClAU/KYWtlQgFWkDzRDQD/2aK+fv16icp02VKohVoG1fClRVI/PHMvJrUWVCWUHVdvgwoBkZfRkRYDAuTc7juScPYpHoKyLJk8dY5DRiPq0NM5mZBbSlYjlxjRWryOHtVD9Gf0dlNptFRIkMbqjHakzYko67ms95fK6ymV/uuGqesqn2Ck57bx30yqHbe8mNLT5/X7Ky7aOfi1alJB/dBHlHSlcaK+s8ob2y4zYZw/rR+uiLNBvX/S9lLYPK975z0+zHbnuHyvwnO7NKZOYvsSUwA0OhWt4b4EPDbNUqIaNTzLy8LIJksjyqsDGEjTA4Wt7henyOkX1NlIq1cfuCYBcEpVSjRCb9gXYk/qIs8Mxtv0B0WlYlofXxw2GGby5XTW2gd986COOei8FJAub45MJDLk07uZpLjDaMkDK3R2g6PgF1+ce0A+8p/q4yk3tcGqASxmEtQTcn2RdJ1tCytd2993S1H2o55mMg1a0pKkXIAXkqa97hpAfP4xtKKZIPy54TPkiwd+HA07MO3fFQFQD52EYqrdtfYinNS7Hc82d2vXptGHCOzWTTWSWL2ru5oqu33UKZXAy+U22+nkz0xrlFk6pSG5KkSutrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(376002)(366004)(39830400003)(396003)(451199015)(86362001)(38100700002)(2906002)(33716001)(83380400001)(186003)(6506007)(9686003)(6512007)(53546011)(6666004)(6486002)(478600001)(26005)(54906003)(6916009)(316002)(66476007)(66946007)(66556008)(8676002)(4326008)(41300700001)(8936002)(5660300002)(44832011)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ARTYC+waE/tMJbHaZgv5lC4Vv8si4n8wbdI7Vhwdt1Waxk35rfZXNmtSVsHe?=
 =?us-ascii?Q?Qiz8GoUZ7Vd+uqZonWdDsqlTwzAGH0v6IRpo+Rm5Lkf5xobqYb/605vnDBcf?=
 =?us-ascii?Q?r64jnLP0lLtxiIAKU04uIJdRNS4G/zf+dIu5a3rL5sUu4B0JowhKRlCPC4UU?=
 =?us-ascii?Q?G2H81TpebddthPKKZCBO6BNnuRN2zjQDX8KSR603utLLL8xNV/2tUNKYHhqU?=
 =?us-ascii?Q?Wn0nryhY22NegWiv39O55mVm5LmwHsajth8AHAsYfrt5Gf4keeH8OEgaof9O?=
 =?us-ascii?Q?BResv2w+TETjVOk53yISoonvjjLTmE0tNJzN85NNpmbcM7rivYB42XUmRwjn?=
 =?us-ascii?Q?ws6jAGNsxsJqhqER11roP7c//OQLoHGX+oNNEmbzzjaLw1rstBjOJHZ5Ipqd?=
 =?us-ascii?Q?WdUB1Wx29GsOy2r7nc4X6QSbHeMq3DSWAI+j2BGnEKVcEtQFO/q5TyE2AjxK?=
 =?us-ascii?Q?n6DGRgQ8xYgtiIwGXk6M3C7n8BFNDrkuQwCBd3wakPi1kKg6lSiD6GiGVzVd?=
 =?us-ascii?Q?FuBQ7NdAuhPjnBu4MukymoVj9KGyIf9Rzv5IkiPwkgxr3fmrg/XMo8iLBFwa?=
 =?us-ascii?Q?0+BZfdYUSmf1YJ+dvMUCHTRKEzoTfcRajLBDRuMXothKIcnat3nadnAwE4+K?=
 =?us-ascii?Q?024kAH4ykZ+yWiNQm1100enR/wloWT+NivoC5ZB9K1/Qpr1wltnrv7QBd7OO?=
 =?us-ascii?Q?ESSGtgrqQKyLB6KRwSgGin6SKe0KUW8p/YPQMKABXVbNNorqxwrlgngCoBzV?=
 =?us-ascii?Q?EJD0tsX/sjW3GnW2N5GGcOteieOuqDBDPxYXa8rd6CuAzUPPx90QViVnod13?=
 =?us-ascii?Q?b1ii8df0THL/q4/Dq4mdUp6PPF8UJiHe9sRm/SYRaZzyT3Hk4J+zRvFIU+Ze?=
 =?us-ascii?Q?xTqGg6Fk6B6t3/OcfCA/TPLSZO5st+nGsxx0xIJD3PoIynNtBVB8KAqtsSA2?=
 =?us-ascii?Q?oEIrE9peweeTgY9JdXdi6MdkbGzLrggr6WuoQ1y/2aDM5qy1cRxhhHRUVvOd?=
 =?us-ascii?Q?mMfklR+t/Z0yVirvhCdYVel09PzYvJacJg05AhWjIA66jQXdUgU8M7eCQNdo?=
 =?us-ascii?Q?TGYgutFyRCVaxaORrYFb4R+fGhBxEmH5yN/S4v+Va9ASp5Z2WGaVsh6dL2Bv?=
 =?us-ascii?Q?AFEwdqHwt4hnwztyS0W//H45AnsG/MM2h4CLprc/LJATqBQ1Hxr58NE53n0x?=
 =?us-ascii?Q?DH+5gXaEAVDCC4eXmNvtp6xus9muZJzHg8iPLwMcsImuzo/SbXOPuPF4NSs2?=
 =?us-ascii?Q?tMKIX853Mbhd1raAOlx024VVr6asv3NknuhEYMJKUJ0FHnQuUTI8iUmqaG91?=
 =?us-ascii?Q?JlFtqdmOp/suFT90t0BaPnzd/khVcA55OP2g4Na7Cz4BneKXYRfUYitbSOLp?=
 =?us-ascii?Q?0zvlCJw+7WyJJoAyv/29680h7Axs5BboOJLrdVii4AfDX9izgkezflDbTBnP?=
 =?us-ascii?Q?m650hKIYyBQ2V0EdxNVYftFJLG6DSuFZV0QjPtE9qAB47h4jiD35Ug1QZWl5?=
 =?us-ascii?Q?/By22C59DrXDzuWCzBIZuzyumFjYnkAe16BIiy1jPAz2+A2ftjEqVIZ6A1pJ?=
 =?us-ascii?Q?SZHUGExOLgkiScBgW8mSvOoRMgOkajlifxx6MKUcIsFFiXhYmnUcNC98nIKG?=
 =?us-ascii?Q?Gg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1eadd62-5053-4055-6725-08daa6e873f1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 15:44:14.1201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IO5slTHsoTTrI6PWRYWCAWEaeFioIOBz0gcFzl1IZktBy+mfsru++k116Lm/scFLDTFsBLHk2kP6J071g7cYsabgtQ2rXQjaFZJs2act2QA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5173
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 10:03:04AM +0200, Krzysztof Kozlowski wrote:
> On 05/10/2022 02:08, Colin Foster wrote:
> > Hi Krzysztof,
> > 
> > On Tue, Oct 04, 2022 at 01:19:33PM +0200, Krzysztof Kozlowski wrote:
> >> On 26/09/2022 02:29, Colin Foster wrote:
> >>> The ocelot-ext driver is another sub-device of the Ocelot / Felix driver
> >>> system, which currently supports the four internal copper phys.
> >>>
> >>> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ...
> >>> +  # Ocelot-ext VSC7512
> >>> +  - |
> >>> +    spi {
> >>> +        soc@0 {
> >>
> >> soc in spi is a bit confusing.
> >>
> >> Does it even pass the tests? You have unit address but no reg.
> > 
> > I omitted those from the documentation. Rob's bot is usually quick to
> > alert me when I forgot to run dt_binding_check and something fails
> > though. I'll double check, but I thought everything passed.
> > 
> >>
> >>> +            compatible = "mscc,vsc7512";
> >>
> >>
> >>> +            #address-cells = <1>;
> >>> +            #size-cells = <1>;
> >>> +
> >>> +            ethernet-switch@0 {
> >>> +                compatible = "mscc,vsc7512-switch";
> >>> +                reg = <0 0>;
> >>
> >> 0 is the address on which soc bus?
> > 
> > This one Vladimir brought up as well. The MIPS cousin of this chip
> > is the VSC7514. They have exactly (or almost exactly) the same hardware,
> > except the 7514 has an internal MIPS while the 7512 has an 8051.
> > 
> > Both chips can be controlled externally via SPI or PCIe. This is adding
> > control for the chip via SPI.
> > 
> > For the 7514, you can see there's an array of 20 register ranges that
> > all get mmap'd to 20 different regmaps.
> > 
> > (Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml)
> > 
> >     switch@1010000 {
> >       compatible = "mscc,vsc7514-switch";
> >       reg = <0x1010000 0x10000>,
> >             <0x1030000 0x10000>,
> >             <0x1080000 0x100>,
> >             <0x10e0000 0x10000>,
> >             <0x11e0000 0x100>,
> >             <0x11f0000 0x100>,
> >             <0x1200000 0x100>,
> >             <0x1210000 0x100>,
> >             <0x1220000 0x100>,
> >             <0x1230000 0x100>,
> >             <0x1240000 0x100>,
> >             <0x1250000 0x100>,
> >             <0x1260000 0x100>,
> >             <0x1270000 0x100>,
> >             <0x1280000 0x100>,
> >             <0x1800000 0x80000>,
> >             <0x1880000 0x10000>,
> >             <0x1040000 0x10000>,
> >             <0x1050000 0x10000>,
> >             <0x1060000 0x10000>,
> >             <0x1a0 0x1c4>;
> >       reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
> >             "port2", "port3", "port4", "port5", "port6",
> >             "port7", "port8", "port9", "port10", "qsys",
> >             "ana", "s0", "s1", "s2", "fdma";
> > 
> > 
> > The suggestion was to keep the device trees of the 7512 and 7514 as
> > similar as possible, so this will essentially become:
> >     switch@71010000 {
> >       compatible = "mscc,vsc7512-switch";
> >       reg = <0x71010000 0x10000>,
> >             <0x71030000 0x10000>,
> >       ...
> 
> I don't understand how your answer relates to "reg=<0 0>;". How is it
> going to become 0x71010000 if there is no other reg/ranges set in parent
> nodes. The node has only one IO address, but you say the switch has 20
> addresses...
> 
> Are we talking about same hardware?

Yes. The switch driver for both the VSC7512 and VSC7514 use up to ~20 regmaps
depending on what capabilities it is to have. In the 7514 they are all
memory-mapped from the device tree. While the 7512 does need these
regmaps, they are managed by the MFD, not the device tree. So there
isn't a _need_ for them to be here, since at the end of the day they're
ignored.

The "reg=<0 0>;" was my attempt to indicate that they are ignored, but I
understand that isn't desired. So moving forward I'll add all the
regmaps back into the device tree.

> 
> Best regards,
> Krzysztof
> 
