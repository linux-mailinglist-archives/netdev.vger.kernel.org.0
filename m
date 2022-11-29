Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83A563BA83
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiK2HV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiK2HV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:21:27 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2107.outbound.protection.outlook.com [40.107.93.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D1F3C6F2;
        Mon, 28 Nov 2022 23:21:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbHsZfiLnobaQswxmsAvTnAPYoGQmep/5vKRtW6g8unzIoH7XtPGrXlTcK1FS4cvbXoFi8/oJy5ijs7hlbsJVYwurvXmF3XavxowxLnXPH1Dq69hUaag3xLf3jP4JbDW/oF47e3uSguDIHduz5W+SWRBRc5MWLqNpEFj2vmg8G5sr/XD05aetUDksAvOcZrEJskD9OeNbfAQ/8XXpAIodYeEj/Y7UycFEqMvuFEqTtFPbc5X/wgCDQ4a55NCCU6AJOWz2ujGVGSeEZMqgFNz3BG2wxd+KEScJIg/YbYAYpIm3hKFYu+Q2MGC0kP3qTYbKkVLN+GJpfBErH8BORIUcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fF8BQnP1WeF6r3kjAg3XKY9XojoL0WzFC88dRZq3m2g=;
 b=fddoGZdZmqvU2yTgt1ZeP2Ll+lLfeX8tFF0LwC/hzafySeIa5ntC7Hf0XTgcRX3Bp6DfEDW1mArxu1b4RYCsWKKkRV8oNJsCRxyVjWvQTivYYp8q5PqLUyyOHunasbyG/hcgld40yB0kjcqkCEXkRaSmCpSjEB+2KIeaqQ+h/tws9+bQJW2PsBaxmu9S5fDLCC9FvJXlDT8mYrjtXh9y378Y3fVTKTWCt1Grc+zgKIa0HzbulNHii6tKEtHyArziEkzku2mxm7RZVu7j3U0CDjijaT3atHvOTFgQ0mFcH/EBCb3F/+WDM5S/pcrkn+LFthbg9Gq/HW022Xv8fnZF4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fF8BQnP1WeF6r3kjAg3XKY9XojoL0WzFC88dRZq3m2g=;
 b=iCVKX1/DHTFLYE0yGjYAd64Lpq41CGFw4gk2oKUKW5bIERyTs5pcnvKwqWglCzqVese4OpRbK5gGCLwFmLnPCnnDi9BxmCFCWrCWbzarIB7DbpY4vlfHe1u1gfxgYIvDrPuQTSx638nMSn5EAnH+B3mHZzcx/Bk2uj8hs7X5sO0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6440.namprd10.prod.outlook.com
 (2603:10b6:303:218::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 07:21:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 07:21:24 +0000
Date:   Mon, 28 Nov 2022 23:21:18 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-renesas-soc@vger.kernel.org,
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
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
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
Subject: Re: [PATCH v3 net-next 04/10] dt-bindings: net: dsa: allow
 additional ethernet-port properties
Message-ID: <Y4Wy7iSeGEtpQkgI@euler>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-5-colin.foster@in-advantage.com>
 <20221128232759.GB1513198-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128232759.GB1513198-robh@kernel.org>
X-ClientProxiedBy: BYAPR02CA0048.namprd02.prod.outlook.com
 (2603:10b6:a03:54::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|MW4PR10MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ef221a8-51d8-4eb7-f16c-08dad1da5203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V0c4kkLIjxNdA3O2O7B6GnVVZ+bRp81zB143s5A184GbpnOwMBiCIDJzveJuplWjpvPQhA+FsmDqsvIWnGjdSJ6BWjXaDt0xTnqb+DaV1SZkCWch+3V1Kiteo75T7S1Bb2EZkiTOZMcFEg8r/pzpAy76cJdgHLAD12qPr5YnOlsynKOH1NLfp2i+YccWI+8upYU4SwaEDkk+Z8ecrMSp5RTNygy5DCg4dZZ0RNFaTWoocz98h6XNQKRb3Xazec4qIkecQcpjKvkVE+GR1ym7DztnYe1rN2RVI4lSgv8jJWwuWIthPQhLuLCXiZ7BhGSlmjnbIzdw+tWEMxLjwbY4+AoFQXRIF6saSlt26OcnRwxQwJ7SqPuZzSXL01ugbdppySit8RAhKzp+DxNO5wIjaXmr7/3Xjm3vcRRfQPvnNDsiEJ9wmn6KzvTK9B418mNjW2DlgLC+eazFSZhpQUK7VVGkqBKGW2bNzKMXNQx5CkqFYROoak34wbFl50UGWNVtOAhHKXNxkAteEtxKN9e6kQi33lfKsLH/etxo7n1yqX0/ebntTbcCFknBrZLLYQ0460U0lPeY5Hg6Vh8wF/uXPvq9hNxyWXRWRQmNfhEa5wF5ZiQ6y07ecB+jbTA0uKKu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(346002)(39840400004)(136003)(376002)(451199015)(8936002)(5660300002)(54906003)(186003)(66556008)(8676002)(41300700001)(4326008)(66476007)(66946007)(6916009)(316002)(33716001)(9686003)(38100700002)(83380400001)(6486002)(6666004)(26005)(86362001)(6512007)(478600001)(6506007)(7406005)(7416002)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y3WN4220IdpzjPhbsuwizLjEJHavMKuWGyPuTXr60xOxukWImktwdcMQ9ckY?=
 =?us-ascii?Q?bD08JYleO13+upJBaEvC2MkGKHNZZKm2YCTxdFYZTTqxYU4Qy8220+6RRfu7?=
 =?us-ascii?Q?99n+84yXcJfbTU29AyZI9dLsJjUUnN0xYLb04gUU/w8PS0A01+/K7PROn3Bc?=
 =?us-ascii?Q?itcwtUjAsfPYoVVcJ5fyZzjKzFTYNzliFnwJkXVPmE83tgB3PFdI1OVKscTz?=
 =?us-ascii?Q?f+4pszt57jrxGKM6OrATq1Il9lRgry6aYQRkjIktc2UJbI7uhyFGvrJQGhoH?=
 =?us-ascii?Q?/PFtygLG1JuC2ne4SS0ykLZM2eiIYy7cZtoLisydGt/DNGCPkv3Zb/xu4fhV?=
 =?us-ascii?Q?eJrsvO1cqQIrkqqE4aKHr6MxCouG0rP4U95N4BEnXdOVylfZivF4Wa6KG/RQ?=
 =?us-ascii?Q?riVcGsfowIk+rtFxzO7kav0JRuRKarE00ae5kGWFyrv8afOFbqHlvjEmTSpc?=
 =?us-ascii?Q?lR6eTq4T6NGmF0t3oHvyQ0AVEpPnlpzD/H+G7APf8DLmHX+eMYbj0CN6ICAl?=
 =?us-ascii?Q?iY7ug4oaT+d4vJiO27NeyplkS0aRqeMvck/4tCRcMdJf52wXLmHR5LYilWi5?=
 =?us-ascii?Q?IIm4ER10VwGPUrmUhRyXGsECyI6QA5EaBq7xut+fCVFr6U3hZbjWf7WRGhfz?=
 =?us-ascii?Q?h2Dv2il7XNQG1R1dZCChCh7Yeou20qlZ/7ykO9p1HER7UwkKfk7OxZPAGXTz?=
 =?us-ascii?Q?E35HEy7o2JcqTF8qlf5JjxyjFTqlIusVMMZQobTuyfVJUjcrNhGZbN07PsIk?=
 =?us-ascii?Q?N7rT2nFbsajR4lvPteQzYKoHkiYoBLfhXRk/srW/5RLMHBwXCWNI4QvCIocF?=
 =?us-ascii?Q?sqkMC9Uqkgrh8lXjHSEFlLdpY53SP1Oz3hi9oEQnGtPa8ZiBJ4+wgqL9OiW3?=
 =?us-ascii?Q?WUmhjQfpbwxtM0miuDzB8X/HhOX+HdoWH7CGe6jfe3bkgGHpVWGZ0ZqHt5UR?=
 =?us-ascii?Q?7hncIuZkIXSsmHsCjOglz9sghb4oBpmNz55GAlJZ1HoPI2qwERWu6yP23QZW?=
 =?us-ascii?Q?sv7tnenXGdoxhum1OpLo3mcqMBXDxDSwLuRubn0ltCd0QWPVH2jNUdMc9O83?=
 =?us-ascii?Q?iwipaCUWFDyszp66OoFiAwnkAgaY4FkC2UczyElTWdHGbwLBYySzIdQ1Wc5m?=
 =?us-ascii?Q?W8HlJ4TMgpls6/eeCI0vEXLOWSXmU8MZW0QIO1j+/n46bi6tpvmabAuq7EWk?=
 =?us-ascii?Q?3iZHoILIvvxYYMhlOcxjZ8R25o3/tA/PJyZ4RD5RvE7/djr8FSAA9+uojooZ?=
 =?us-ascii?Q?HQhT41Z6klamqKlAfIy3QxqupeTP3vOwIcg2g8by1xUMnCQsaKkbxBDx3b2m?=
 =?us-ascii?Q?ZYXic/GpKNZHAvcJWQzM8ENGGFngWlcpxoWCKiGZp6PCRFhzPLvyAYUFRCic?=
 =?us-ascii?Q?/oJB/Bg0EIJkAyo4l/4w1T1ZL7PD94ymBwgn3kTG8xXp1eHaKihJjbywgoTj?=
 =?us-ascii?Q?wC63rmDOxhWOXCzrr3srX8+5ogFYX4iqkn3Rzrs5b/BBIQyXqHbMCoPZ6rg5?=
 =?us-ascii?Q?HN61MoEEDpS4640ZkGRjCzxZ6xSLJgXCA+17sO/qsChQ31OexVOpjdgFrKUz?=
 =?us-ascii?Q?6DVJxJPGRM/cV5+0MAbjM1tG6NhzIbF+wxVq1OshtMTEFRuhBTFNTbpntu1Y?=
 =?us-ascii?Q?u4VkW5oBWzyLyuQ1i0CSKqU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef221a8-51d8-4eb7-f16c-08dad1da5203
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 07:21:23.8693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dJ7B0ZdKB0IT90PBpJXo46LIEwHaumxcGkx7JOcffwIG26W0bGyJIU90sD2EoXR54n9kr8KI6Gw2roid2+Us8KPHWD+fmE+uMHFCqd3xtWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6440
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 05:27:59PM -0600, Rob Herring wrote:
> On Sun, Nov 27, 2022 at 02:47:28PM -0800, Colin Foster wrote:
> > Explicitly allow additional properties for both the ethernet-port and
> > ethernet-ports properties. This specifically will allow the qca8k.yaml
> > binding to use shared properties.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> > 
> > v2 -> v3
> >   * No change
> > 
> > v1 -> v2
> >   * New patch
> > 
> > ---
> >  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > index bd1f0f7c14a8..87475c2ab092 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > @@ -38,6 +38,8 @@ patternProperties:
> >        '#size-cells':
> >          const: 0
> >  
> > +    additionalProperties: true
> > +
> 
> Where then do we restrict adding properties to ethernet-ports nodes?
> 
> >      patternProperties:
> >        "^(ethernet-)?port@[0-9]+$":
> >          type: object
> > @@ -45,7 +47,7 @@ patternProperties:
> >  
> >          $ref: dsa-port.yaml#
> >  
> > -        unevaluatedProperties: false
> > +        unevaluatedProperties: true
> 
> Same question for ethernet-port nodes.

For ethernet-port nodes, the qca8k has unevaluatedProperties: false. But
the fact that you're asking this question means I probably misunderstood
something...

For the ethernet-ports node, I'm curious if my other follow-up answers
that question where I realized dsa.yaml should, under the base
definition, have additionalPrpoerties: false. But again, my guess is
that isn't the case.


> 
> >  
> >  oneOf:
> >    - required:
> > -- 
> > 2.25.1
> > 
> > 
