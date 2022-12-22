Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CC66546FF
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 21:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiLVUIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 15:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiLVUIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 15:08:42 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2104.outbound.protection.outlook.com [40.107.101.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C991BEAD;
        Thu, 22 Dec 2022 12:08:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvkIz+SuSNT4HP1yLkjeSZQy2dZzdRibxaFCEfdJPXjJUzVVysj0k3oqJDsfcTXJERtjaVliChCd/rYb/FPS1OX0Hal5FUC1FWPUmiZgCCY5QupljUW7CwNzf0yK2nG3a/PtTkKJe8m2ot4TZYAXY21bNt0TIxzcwdV95c2FYZEfS1ym0uPN4g6if/IvlBFsP3i6NKXNUh1WGjXlBcfuJqvfThpanr4s1gyjepAg50VBpE1Of30J5kX1V/Vn9gASb+QFYhMuOjtn8qRe4pEssI9B2uvFPZlXYlUfkFG5D9unY/37wZiKYzRk5DNqB9c4/JN+HP/HKBxOpRPXQjtyGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdjdQ2WT3bKGjIUr6Hh8Pjm/FDYQSCxnROdRPygMgKA=;
 b=Fn5Dto7vMaKEkvqmFlUMAtEMqQqQsKR11twqpzsaZnTOPch/Vv7JOmUMWJiAothd0R9GTzlymtTonud/kIN3uPPXwrVKidG1NYWiuJ+VBnp4KvKaG7k/Y+Hor+2E4oX2o0EHstKwttgwAe4JNJM0Pe7NRGl3HCQbMRue9QFYe/Q3u7n2+ElKoO9KgxzsInEk6Z4Wqo8Y5NEGkf62X3bWlTk7MIYkK9VL2ycAJfksgMdLMKMqm/NYfv+2eb+660GpcOXqvJbVbrjzX9o0e0yRh1iMr3txRqQAngDR6Y59LyO/SCUoXj/D+FUBGQXl0GhL834GGHoudICliiy1xXaJrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdjdQ2WT3bKGjIUr6Hh8Pjm/FDYQSCxnROdRPygMgKA=;
 b=ROqtc9MAfR2ScnpHFy/adSYjTF+5+y5YS47AUxrNF8JpAbq/j4opUJlJE4dkq742jJ+xjv8b7KEC693Sov4W3wP7tPCs3uj/qSQYiywXM8RP+8/YWUUa0xJ8lTKjMs9CIBqlE5dEUNSmP0dDkCyj7SWDoekg1SuGHM3rQZcPLJk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY8PR10MB6610.namprd10.prod.outlook.com
 (2603:10b6:930:56::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 20:08:38 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 20:08:37 +0000
Date:   Thu, 22 Dec 2022 12:08:30 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v5 net-next 04/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <Y6S5Ple5SURq0QSU@colin-ia-desktop>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-5-colin.foster@in-advantage.com>
 <1df417b5-a924-33d4-a302-eb526f7124b4@arinc9.com>
 <Y5TJw+zcEDf2ItZ5@euler>
 <c1e40b58-4459-2929-64f3-3e20f36f6947@arinc9.com>
 <20221212165147.GA1092706-robh@kernel.org>
 <Y5d5F9IODF4xhcps@COLIN-DESKTOP1.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5d5F9IODF4xhcps@COLIN-DESKTOP1.localdomain>
X-ClientProxiedBy: BYAPR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::18) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CY8PR10MB6610:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d86bba6-8d35-43e3-e4ba-08dae4584faa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yF0t62AhfkdeBt5pWfL/U3q6MbRU8VaPyIKV3p8mBH65TLPIbMXrPgZUQQ/PbASCvRaf3U7+EvwRSEQwlR1m08g4uRtve3gpshFu/BC5dY+ZL9l94nPHnpTsfYk+ZflfA2cazk/HubIVHH1cjJBHFZpHKLWlSwrXcpy7kxt2L9w0psaTGgJ0OPqHHucOAhCROrpfxciVoepBYrrpdQK2pBgVytgFD7yS93imx12e4Oxh1Vvr2j9YPrz4kN7r1PkzQU+AQ44nhEzDVlRglG99AuMfGQg8WFAt+Bqq8IuGRtX+H7nZxeiW7Q9TSyv6FOSYQ6avoxVeerbWSut/Ycl+uMGvQi3+ku+Q9zExl4ZSHgIVOSB1Hfwu0uLbhkhJ0PtaHBTUoj4Qmo5qkZZ89X7vY8SiFdRbjZWtUArVmC1NWeBatHttDAyZS7soKL+pkdtsmS6VBWBdIrFUlxtvRzJrwrjoEtZCaIN8NdV78HtMWJWjW4ADbFGZ70aw4WSU2f00LK072zXnTwCCH3dpjCDozC35ay2Qpu6F5p5viBjYdsybMtr7h279IptAZU6A/3N4hY7/MN98RIaoIsX4cJopmjM4TNnMQBuYd6laytJ4c+IcxYX1jj7Saf4sHtJq2yd2nRcRfY8x8n635A9uuw+oNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(346002)(136003)(376002)(39830400003)(396003)(451199015)(44832011)(6916009)(38100700002)(54906003)(6486002)(478600001)(7416002)(7406005)(2906002)(316002)(5660300002)(8936002)(66556008)(86362001)(66476007)(66946007)(4326008)(8676002)(66574015)(83380400001)(26005)(186003)(33716001)(6512007)(6506007)(9686003)(53546011)(6666004)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHh5Vi9uczJCZS9tV1BadGprWkVFVVUxNzFJZ2tMRUkrb2VWTHA1cjNRUjhK?=
 =?utf-8?B?UEJiR3JHdHBJQWY1YTZOQnlrWit4VWFMKzFyNmZKZ3BSTDFaQzdVeEZXVGhI?=
 =?utf-8?B?dUY4THR5Y0hqMEdTdDZ2M3FCQU9SaEpOMGE3azlqWk5OZFV2Qmp2dTVtYjd5?=
 =?utf-8?B?RWg2aldhbU9PaTVsMEVPenYzWVFoVUxSdjE2aEQ5aDl5VXNOenFqL014aFYx?=
 =?utf-8?B?cFBZUE53Z3F2LzF0Y0V0SUZtbXdWUi9kd25neEFtbG5VcGltK2RMNHBSVzJx?=
 =?utf-8?B?TUlQN1EzQ1pBTlFCNVVQSGhobTB4bUFOWTlVN2NYTC9mQnhWNXQzaUVDWUNJ?=
 =?utf-8?B?ZER3ZkJYYkpaaUlLSGZuSmJ4WldCd0dta1VwYytnR1p4UjdGVGxHOVNINzVV?=
 =?utf-8?B?VHVyMXMwLzRiR0FWa1QvM1NOcUZhTG1NbDRSdk51bm54L3hMNjN0MUo3WDZG?=
 =?utf-8?B?MnpqVjhUeDgvc3RrMlNnazMyZ2d6enFWSXpicGlTZFZJamFJVUlCbVEvTmhh?=
 =?utf-8?B?TWVvM1QxU3lKZEVMbEVGU003akF0U3pDWENncVdRcVZTNmhyRVlVRkhLS1pZ?=
 =?utf-8?B?MGMvb01QdEpqcFBnRGszZ2tFbWVTMklTRW10RFNsZ0FEMFR1M211cXNDWWZh?=
 =?utf-8?B?eldDdHp2aTl5bTNhZ1AyVlpKbFJRRGhXVzFoSWxuUi9KTUJweEZJaHpGNTlJ?=
 =?utf-8?B?Q00vejZmeFJGQ1ZCdlNZc0hZSlJNM05yTS9PVkw3eVJJSFdqV1lSSE1zWmM2?=
 =?utf-8?B?L21jdEQ4N2I5ZVZ0anVVY252bmhOVysyUmRJRmYraEZHb01WTTd6dlBWemxY?=
 =?utf-8?B?dUl4Tnp6U0hZVzhvdjNqNHozK0VkOExmTUdkVSsrKy8wNVkxSUt6U2ZHTnk0?=
 =?utf-8?B?bVF4eThEeUsxY3ZPR0pYK2RJd0ZHTWdVYzl3QS9EdzZJMUl6Q1g2aHNPZ3pG?=
 =?utf-8?B?OEoxczB0RVgwYXdnMEpqTTVPR1VsSmJ0U3ZaMUVVNzNUVDFJMzRib1VSVXR3?=
 =?utf-8?B?OTVFeERDM0E2RHRrN3JCaHBhaWpNY3kzdDRoelhITzdZWGIzanhQR29vQlVl?=
 =?utf-8?B?SHkyaHV2d2ZCNy8wUW9RZXV5WDRZRlNYZzJyaGRkQnlMMzd2WXdGYWplUERj?=
 =?utf-8?B?T0VYa1Mycmtxdyt5UEd1ZHV4aXcvNFBES0xLWkk0azZsQXFRWFhkN2xQRmxX?=
 =?utf-8?B?blBORjNZVFlRMlZLV0RoZW05OC9oL01WNjc2VGN3NHUyZ0MzbTF4bWZ0U3I3?=
 =?utf-8?B?RVNYb1JjSUdIanRhRi9WNE56b3NkWFl5MUpBQytYRnJPV2xWcUFCbmlqL1JC?=
 =?utf-8?B?YzhLV0tRaWdvUHplYUwwcnhvKy9VTGQxOGtSZzU5ZlZacjV4TzRqM01LSTM0?=
 =?utf-8?B?eDRoKzh2RWcyMVBIYUpodHMyZjA5Q2FaUUdLWjRqc05sV3IyNzRZbnZXTzRW?=
 =?utf-8?B?Nk9NNW5zY1JUdklyQ2NoNFVyNXkwVUNIMFJTcDNQeHU5QmJpRlUyMzdqZG9n?=
 =?utf-8?B?QnF4dGNlZyt5YUZ1NVpLOHdkWC9NUHBNcG1SQVkyaGt1dFZJVXJzdWJYaTQz?=
 =?utf-8?B?SkZ0ZXpDYXhpVndLYmdVMTBsK2xLVUdjNGF5UGwxL1V5My90c0N3UUVpeDRH?=
 =?utf-8?B?WDlQb3YvSGtlSWN4ck45eGZGNzBvbmlpVEova2JtNUxUYzdrWFBTWnRXMHNp?=
 =?utf-8?B?WUFZek51YUVsT3BQWDl3dFFITGJyTHlGWCtXMTBuaW1UbVhwb01YMkVrMUMx?=
 =?utf-8?B?L3RYSGgwMXhwM1ZnWkIwcHBDYm9CVUxEVzY2cWZqOHljVndUc2YvbVNCS1pr?=
 =?utf-8?B?aUxNS0ZlZGVTcXlIZUV6ZlJmKzk2RHE4bitnWnA4TGoyUlMzTW5CYkxaSVR3?=
 =?utf-8?B?d0FtMklBYW1ZSVppY2EzWUFkOFNBM0FsZ2lkb1FQSyt5d202M3dhQzZxaXJI?=
 =?utf-8?B?Umd0VXJsV3BIajE3ZDNBalZVRlZDZitoNkY1aUJ6b0o4Rk9Ic3ZqaTdBVDhi?=
 =?utf-8?B?MHRnaTdQYnlJNkR6RnBzRVlFTU9yNldhMTZTblJsOW5hUmtpMXdDLzl3ck1l?=
 =?utf-8?B?aWFxZmozRVZhU1hja09meEdPbjFMWGFpazhZa1pXWS9HVjk2NGxwUkJrUDc3?=
 =?utf-8?B?TUNuZUxwZ2FUMU5tcGE2UWZiU1htUGg1NDUzQnlDdU1qc2dnaGVEQ3VLb2tN?=
 =?utf-8?Q?Rpq0riHBB9rxk4fJ8Xj/abQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d86bba6-8d35-43e3-e4ba-08dae4584faa
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 20:08:37.5107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ai9vfrbp6cSfJfw//lmqY9wHry4EwmB78YFFOmb9dfcU3Mi0NP91wogPcRv9Udh/JE17os98Dqv+fWxZkStnKI+ncmUp4WYeG/NAjWE1X4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6610
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 10:55:19AM -0800, Colin Foster wrote:
> Hi Rob, Arınç,
> 
> On Mon, Dec 12, 2022 at 10:51:47AM -0600, Rob Herring wrote:
> > On Mon, Dec 12, 2022 at 12:28:06PM +0300, Arınç ÜNAL wrote:
> > > On 10.12.2022 21:02, Colin Foster wrote:
> > > > Hi Arınç,
> > > > On Sat, Dec 10, 2022 at 07:24:42PM +0300, Arınç ÜNAL wrote:
> > > > > On 10.12.2022 06:30, Colin Foster wrote:
> > > > --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > > > +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yam
> > > > @@ -156,8 +156,7 @@ patternProperties:
> > > > 
> > > >       patternProperties:
> > > >         "^(ethernet-)?port@[0-9]+$":
> > > > -        type: object
> > > > -
> > > > +        $ref: dsa-port.yaml#
> > > >           properties:
> > > >             reg:
> > > >               description:
> > > > @@ -165,7 +164,6 @@ patternProperties:
> > > >                 for user ports.
> > > > 
> > > >           allOf:
> > > > -          - $ref: dsa-port.yaml#
> > > >             - if:
> > > >                 required: [ ethernet ]
> > > >               then:
> > > > 
> > > > 
> > > > 
> > > > This one has me [still] scratching my head...
> > > 
> > > Right there with you. In addition to this, having or deleting type object
> > > on/from "^(ethernet-)?ports$" and "^(ethernet-)?port@[0-9]+$" on dsa.yaml
> > > doesn't cause any warnings (checked with make dt_binding_check
> > > DT_SCHEMA_FILES=net/dsa) which makes me question why it's there in the first
> > > place.
> > 
> > 
> > That check probably doesn't consider an ref being under an 'allOf'. 
> > Perhaps what is missing in understanding is every schema at the 
> > top-level has an implicit 'type: object'. But nothing is ever implicit 
> > in json-schema which will silently ignore keywords which don't make 
> > sense for an instance type. Instead of a bunch of boilerplate, the 
> > processed schema has 'type' added in lots of cases such as this one.
> > 
> > Rob
> 
> What do you suggest on this set? I think this is the only outstanding
> issue, and Jakub brought up the possibility of applying end of today
> (maybe 5-6 hours from now in the US).
> 
> It seems like there's an issue with the dt_bindings_check that causes
> the "allOf: $ref" to throw a warning when it shouldn't. So removing the
> "type: object" was supposed to be correct, but throws warnings.
> 
> It seems like keeping this patch as-is and updating it when the check
> gets fixed might be an acceptable path, but I'd understand if you
> disagree and prefer a resubmission.

Heads up on my plan for this. I plan to re-submit this on Monday after
the merge window with the change where I move the $ref: dsa-port.yaml#
to outside the allOf: section, and remove the object type as the above
code suggests. Hopefully that's the right step to take.
