Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2EA640E84
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbiLBTbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiLBTbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:31:38 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2105.outbound.protection.outlook.com [40.107.223.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D322EF37C9;
        Fri,  2 Dec 2022 11:31:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHAil+MvOUrpWpNp/PJES4EgboNXEurA/yzKKMld3IpsiqpNgXoObbZzn4yllzpZY6BjkHVD/i/XvBOFa2obuxQJPqHt1dJ743UG7hWpjSmMC87JUauj3N2WW9tk7XEC57syTgQyKyo9L6Vr02MptbEFo0J/lOB0d9xglXLUKuk9FTVMOUUzoTP+F9iN4zp/0wcsBHLxEU+30NHw44jqdAk0kZPTX78udzYSort8AtCbF4nvtB9TO+cNhznIaDmBIi47Qd53eFw8krzNAilqb1YdTW/+EtYkwuw4KEdnDrvUOv0wP9xyKWxZpKWzyURyBA+XjE2+iQfFfMtNS7JDoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgYJ9LUb6UH6aUEiPKQkgfKqjylK309mu1ea+X1OH7g=;
 b=B34ZJoXTTeMj0u/VPWDhNjWpegBqGRPJkhgriXpZRg/Sr/Z7es13prrq+0Abcm6Mguy1TCrbbIDMWVxMf44+o/CRhW7+2uTK8YbHVNjgPAmtOpg342dQhlArGls37R4w2+YVqSmavLChxZN/tJoZmrPVAxJ6kvkyYvxKWROyz4fjJxW8kVX7kKEcOdatcr1UlPV4nQK9BsK1ZZNXkva/dQqZ5ozzkUGV9KvMSOAnH0+BUgo8HX4iecdAWp3MwrYF53mIgPlE+2TsQPctB82CmEWKNxyu2+uw0M8mUbNYFhDREDcv8ANLA5tFLERepOLN/mZBb/V5WUKX9ZHMGHVSsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgYJ9LUb6UH6aUEiPKQkgfKqjylK309mu1ea+X1OH7g=;
 b=RUgF88UPUgyNPnXG7KP0SVN48YiKF/rUaZHhwIDKVbAz30xpuxXOYOKHdtcK5v1OU/TKmcJ3phzhRQbWfmO1kSFW9NxiL6KTfrblFTB/fDwXPjO9Nc2aJ1YRiFH8sdSj5h2R5UeMFkhQsjqd28Bm2FQvNRXmRq5BtJyL9lljMSc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ1PR10MB5905.namprd10.prod.outlook.com
 (2603:10b6:a03:48c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Fri, 2 Dec
 2022 19:31:34 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 19:31:33 +0000
Date:   Fri, 2 Dec 2022 11:31:28 -0800
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
Subject: Re: [PATCH v3 net-next 05/10] dt-bindings: net: dsa: qca8k: utilize
 shared dsa.yaml
Message-ID: <Y4pSkOFaGQKc7j/6@euler>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-6-colin.foster@in-advantage.com>
 <20221201224240.GA1565974-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201224240.GA1565974-robh@kernel.org>
X-ClientProxiedBy: BYAPR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:a03:100::34) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SJ1PR10MB5905:EE_
X-MS-Office365-Filtering-Correlation-Id: e5b40e68-b9fe-4bde-d812-08dad49bd1db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kagT2FcWxP2POLSUCqRQJQR8BpvvFY/1ILSGuNpBpV8/JYhbgDnJmyDQQrv4DbpIsnpaOEibBNtEomAMkDT97QKgcPWe+MbeYFoT1W9uvnDvzKRRS33Xg5FpMoS3bA/88KBytgvXFELq5VUZi/Y5gkXXWQQhL2U71D5ymARV4IkJsg8OjyXjL4GVWXzdGAV6b9eEOcDy4xd4v/hUvYiztGRDGureLrxkZ+RCpGu4hnR7YZzmRnISwhMsURh/BJYYDLngVLjNWvh2l5TOuxY1zoGsUyVPY/HJZMr7WKuolSTXQxAtqivHuP+7e5zx994UNbh10HAqHcpBkmrQJbalK2layimYiDdXBKJEKRYF3zo6Oi/vM4GNHedDdN0sUTgIUKe5hfM4ml+c9ELTJ+AhmynkB82NW4q2mzkpFQ6XWWQsxxXFLAf/xQ5jC7fHTFH+hQe2FS8cUseYIGb7eQd3GfSowTs+a+RCU7rgpSRRcMsCVS9gJs51WvDuCblQd5R6x6m0QsSIdcUO6bzY5M/3Zp84BYeESWAI73RzV9O/zPQXX8ucOULfGThy1VZlmkhiujuS4B3WXF6hSsekdV4yj1i3iuV650D2RAZGwMT2+xQHDpqglKyXkSDIf5eFY42ws0KLKs0lYyfZ72xAx9qdz2TYd02JswQmawxhUaZrtG5ngcWxZLN1Gc7jKTrEbgxC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(39840400004)(396003)(136003)(366004)(346002)(451199015)(83380400001)(38100700002)(6666004)(6506007)(6486002)(6512007)(54906003)(86362001)(9686003)(26005)(478600001)(186003)(66946007)(5660300002)(2906002)(8936002)(6916009)(66476007)(8676002)(7406005)(7416002)(33716001)(316002)(66556008)(44832011)(4326008)(41300700001)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Kd/z5rEr/ry1LVUu8IwMHuCR/kwx6pD2EOTkYXbzntU0tLkAkn4HUSpN0CT?=
 =?us-ascii?Q?O0xKv+KDLEy3ojeHsNF2t+/VpQ2a2213s0NtlDxShhrkmb7RCzb1htZR18hu?=
 =?us-ascii?Q?zB1ubZBrNyktUGRlQ9p1x2cWmMGAR6V2Ak6zHKpwYsmC7KMX5+xmrn6Wu9RB?=
 =?us-ascii?Q?9ybmxhp0vXCsT9jJbwEJgz71cuCu6iZlc1Dzweg5aZbrgUkovLg4YFoUettd?=
 =?us-ascii?Q?QStizf1bxTKD6k258QEL02KL4FxUsaBHEeKzWj8qEFzOzIYmY7AQAP4Zl3b9?=
 =?us-ascii?Q?H4lCDbm4K4x1qV7Jul28waljBrv0rm8rmIZByI0Dg9x9qQfyEd4aikC91NVs?=
 =?us-ascii?Q?AH8XL9XUNOOjOqAYqaQRE1/gD6sBl8FiPzohyPSr63HMcraiPHbRfNuBKHrU?=
 =?us-ascii?Q?KmTxpwaw8K64O3l8EcEyxjFeqW91aerpd+IAxe1H2BjWsDfFxRDxlbv96yCT?=
 =?us-ascii?Q?oqRF3g8EIrGI1pMU2Qo89WFWHpoBVlFzTbBArGd5a4QY4crUC2LHUqC03SRW?=
 =?us-ascii?Q?ZxMge4EdN+vcFl4iti+X8mZ1+dauYpifKeKc5xpujPxpZILZqDgk+NDJtHfC?=
 =?us-ascii?Q?VJdl7UPf4rLvTfCCgWEyF1lupVa2SzhpH+AtpCn6A6e7Nkl2DcT7vYAi8y/r?=
 =?us-ascii?Q?zNoZfVlrPj2Z/vtSviDUf6lzfuhmPl6AEwQJyv+zIP9ceLfjM76/16yyOJW7?=
 =?us-ascii?Q?jCaox1VTp70WC9oBCzg5Uxo0EDgONZwSwdyK7JiUdpUkgjXiOwV4qVkmPRyE?=
 =?us-ascii?Q?UJ4x3LCFhB0UrCNbUVMbDXffoY2o9XmX8Rhomhpz7i3hVJQ9UgP7u0WN1+M5?=
 =?us-ascii?Q?lDs2Aa/BsK5oloQWvYo9alkXwaf9PRdGUThQ9PycGOdgNEj34P5TSAdfsCre?=
 =?us-ascii?Q?HcFDals3N0Jlrh6nQ/QAmVLhaOXrWbZkVVa1mXCvb8ayFIp4HwzsKAJ/oOoZ?=
 =?us-ascii?Q?iE5LcNcq7QdIBcqGm4pAmpLe/ATcw75UxhfCEXVuDuv63umzC+Al65mrgCwA?=
 =?us-ascii?Q?WUibV4/+lN5qNqhZGfwpNKICy1SqF1UNXHsu9Tq6Gj5rVcSVRLUGErtb9aRn?=
 =?us-ascii?Q?Jx2QN5MXVHery18wijgKHtUIwpj4fJVawwyobCvqke23TVYvkMByW6HkfMAR?=
 =?us-ascii?Q?OSI8c3pVB+kciziQ/W1Z0MB0fn32kVUqZm3qJFFjFrtJSN3pkZbDbWL80z96?=
 =?us-ascii?Q?xUTvB2Fuudrc7/fvL8EBFBiAsQtj1F9r+GmRCU8oEpR/j0F7ZMggCaZjbN7N?=
 =?us-ascii?Q?sDNWsvY+E5INRgd9RnpxrapbP90VPzgUf8lkDsRbIfeGEVxR/cSnbIyqkNJv?=
 =?us-ascii?Q?aPYdipJTp9Cti2Ty9iOru8VxSXkasrbZlYCdtedL+g/BvR/c1ejxG9nM4WFA?=
 =?us-ascii?Q?ZF/k/N0Tt7pXrryY4aXkCs0oH06M88tU7J+0WUvGTFR/SDzSvzGxgIbVBrXc?=
 =?us-ascii?Q?chCscZ9rjD79FQae+bu5xB5W8hI3BoKVVZTDeS4AFQxEQHZScCwIT6EKPkD5?=
 =?us-ascii?Q?DdNXQWra08Xm9r/ioKHfbdAO/XAZFlBz71LOqGUhUYJa838xzklRvcfnJS/P?=
 =?us-ascii?Q?sK0jUBd2dxfplkGMr50YjSpmhFDwRaO/OLnmYaW14CgDs3f4atFoVnAH9jvw?=
 =?us-ascii?Q?+Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b40e68-b9fe-4bde-d812-08dad49bd1db
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 19:31:33.4711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: no/h5nyDE2pT5c5Xp3ccX1WkGNtTwiRQnEslSDwnAUp68/HKXZ+FbV1kerWDXz7SliX2F9RcOla0892cqVhQB5hzEomheMRxLufw+CD3C28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5905
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Thu, Dec 01, 2022 at 04:42:40PM -0600, Rob Herring wrote:
> On Sun, Nov 27, 2022 at 02:47:29PM -0800, Colin Foster wrote:
> > The dsa.yaml binding contains duplicated bindings for address and size
> > cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> > this information, remove the reference to dsa-port.yaml and include the
> > full reference to dsa.yaml.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> > 
> > v2 -> v3
> >   * Remove #address-cells and #size-cells from v2. The examples were
> >     incorrect and fixed elsewhere.
> >   * Remove erroneous unevaluatedProperties: true under Ethernet Port.
> >   * Add back ref: dsa-port.yaml#.
> > 
> > v1 -> v2
> >   * Add #address-cells and #size-cells to the switch layer. They aren't
> >     part of dsa.yaml.
> >   * Add unevaluatedProperties: true to the ethernet-port layer so it can
> >     correctly read properties from dsa.yaml.
> > 
> > ---
> >  Documentation/devicetree/bindings/net/dsa/qca8k.yaml | 11 +++--------
> >  1 file changed, 3 insertions(+), 8 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > index 6fc9bc985726..93a9ddebcac8 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > @@ -66,20 +66,15 @@ properties:
> >                   With the legacy mapping the reg corresponding to the internal
> >                   mdio is the switch reg with an offset of -1.
> >  
> > +$ref: "dsa.yaml#"
> > +
> >  patternProperties:
> >    "^(ethernet-)?ports$":
> >      type: object
> > -    properties:
> > -      '#address-cells':
> > -        const: 1
> > -      '#size-cells':
> > -        const: 0
> > -
> >      patternProperties:
> >        "^(ethernet-)?port@[0-6]$":
> >          type: object
> >          description: Ethernet switch ports
> > -
> >          $ref: dsa-port.yaml#
> 
> So here you need 'unevaluatedProperties: false'.
> 
> unevaluatedProperties only applies to the properties defined in a single 
> node level, and child nodes properties from 2 schemas can't 'see' each 
> other. IOW, what dsa.yaml has in child nodes has no effect on this node. 

I'm buttoning up v4 right now and removing this line deletion.
unevaluatedProperties: false exists under the etherent-port node, just
at the end of the properties list.

Since the etherent-ports node in net/dsa/dsa.yaml has
unevaluatedProperties: false, I understand that isn't necessary here.

> 
> >  
> >          properties:
> > @@ -116,7 +111,7 @@ required:
> >    - compatible
> >    - reg
> >  
> > -additionalProperties: true
> > +unevaluatedProperties: false
> 
> So this has no effect on anything within "^(ethernet-)?port@[0-6]$" and 
> below.
> 
> Rob
