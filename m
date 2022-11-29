Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CCD63B8F0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbiK2D7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbiK2D7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:59:05 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2095.outbound.protection.outlook.com [40.107.101.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF002BE36;
        Mon, 28 Nov 2022 19:59:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ke6730yFTB+LY/mRDkVCxS6PHN3dMey4NDRqWsIuyrK/PYv/Pb77/E17s0oFb5edQpGB3N1PUW3KY9byUTOrGkvFVwXy5c2UHz2cUxteumZdf7dWwxZE8ZYF0H+4TuPnuFw5VINtWCGTSuovoZ4dv3Iv6pF3E5PSRIPrRdIPQIjROP+Fv2C6S45m7bcD979zR1dIBtxqHsw4riFW71dVgAB0EMfxHrCrhurLIK3C5juYWMaYcu+p5MBSBWXYS7Xc2ezZGfGbccZbT4MCp/jh92BlBQ2FkWNm2Gz2zbsQZ+f83gluqX02Nh0x1tZ6OgMwq3jz5Y5Aqsz30c1EdE4sDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aruHhMppQa60kz095e3jTuWRJu8UywEQMtbuUmU6xDU=;
 b=J7KQi0ETSqwVXS93ZinIONHSbBiZzcC5sbu6K/DM8zWDzBLrqB3H12NQ0YaKtoKNYzzH+yHtIzpQjlMKzQknCVI+ya9Ayhy0uQLiMaiwyA2NrdJJhh4QegbuYT/PxHOpmbWQ4lSju0sRdOPZ1tEKkp7triPo7khVQi0Xw+xnKIrajCrJetJzySEM6M48ukFa552tVNuTBT/WfZz/H/bcKAffi9IyMxNKASYAfXywpYkXVjGY//r509Oav06GtJbeBzoX8ICQfedn4+q0wdNInZl3csqsCDkHGtt/cVvwJZz0piVacgwwXE/gskANYHj2gJHZcGhYGujiXbRxpDSIug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aruHhMppQa60kz095e3jTuWRJu8UywEQMtbuUmU6xDU=;
 b=kSVcdN5ipBDPeGLPzBhB5AoNhABZXa+7BRWxLZHcyhTrJ7fSSYHp5650pMuX6HwcBmCDOgHrNlI4rrv/Xwd7HEb47nvEZ7vg66MGpUzZ/E9MSUY4ESewSu1B9x5X7Hp/NJPXdkSyADArFsG1izajidPn25r0eT96weIl3OvpFjw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB4565.namprd10.prod.outlook.com
 (2603:10b6:510:31::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 03:59:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 03:59:01 +0000
Date:   Mon, 28 Nov 2022 19:58:56 -0800
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
Subject: Re: [PATCH v3 net-next 03/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <Y4WDgL8k9uDsVx4X@euler>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-4-colin.foster@in-advantage.com>
 <20221128232337.GA1513198-robh@kernel.org>
 <Y4XSPMMDgiFipdIW@COLIN-DESKTOP1.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4XSPMMDgiFipdIW@COLIN-DESKTOP1.localdomain>
X-ClientProxiedBy: SJ0PR13CA0086.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH0PR10MB4565:EE_
X-MS-Office365-Filtering-Correlation-Id: a278b17e-4647-468a-9d2d-08dad1be0c8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o106zyhasV35ufYAEShJKA77VDqgCF2+BLn6Z4vvRkYXiv8SBD0RQzaa5Ls8EaJZOwnDqHtHjWZvVBxtJ9OrtGydraEB6e89NdZKZDoWp2hAZDxfZ7znPBS9ZnNxj8fzAAXZyhIWWhFBAdOWASzVq/peUtu/wDFfeMrxQ7fqrUpMjWk6GGDn+TOxml5rpPgkS/es2geUhl5wH7BkhzLwl6ny/7bxcSog8QQWhklFzEGKM/z4lt/ZjQNF1nwMGlVXcQ6PguVenke28uoYXBIYfaK8c4C3QSfIouVZ5Y5kuDvNMbU/3lkH2lLSYaz8mlgW2KSr6W2bv7cdp9C3zu+seA07ry+qKUR6Dik8FlegZrOxIPIz2xDWW9KBYbsn3kkHt8MsoIMuMMDGrtNAZp00uHEKY8GOM1gzr/91ObzG4g4O5B1/izsR5nZv1kOSi1nQNZSOnPgoVj/FzYzxmOdM7HpKg6mzaZeiHIgx0kCH3nzKJ1F1cCxhTX7yejD8Maoc1Wa91twfcmmmnQo2WuP1FwrpLltcgGyULQ/G/cAdd6Z3T6hyYk1PLOPDn/F7hq8OsJ8dKVoXcuGUtNiRF1Pz6yXKqVrNH9YPmA5kH8R4OQ26bQWB0OcoKYVcn3AGhzytvnPS2562Foqny8WnZNELwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39830400003)(366004)(376002)(346002)(396003)(136003)(451199015)(86362001)(6666004)(478600001)(6486002)(7406005)(7416002)(2906002)(186003)(6512007)(9686003)(38100700002)(66946007)(6506007)(44832011)(41300700001)(316002)(33716001)(66556008)(26005)(4326008)(8676002)(8936002)(54906003)(5660300002)(6916009)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OXKNlaykjjV1wN3mUyWxm4EOBor4FSM55bTW3g+JQdAnSg+s4HBQ2NoaxdfM?=
 =?us-ascii?Q?Cd6kDbYvt8lDisl53dbX5Ps1ZQKC2vu4YK9bmbazNnoNb6fmSj8qRsV3QoYN?=
 =?us-ascii?Q?3qeyLN7qFmBrm9RIVek8Aqr/O5bttzc/J7UZG6QfM6FcxRDZa3MWyVGDp56p?=
 =?us-ascii?Q?1/BJrgL3tHjKHQ/85i1o8+SAVzqZpr9LiRSABsDg22FUF+84IrXzXrcCPE1M?=
 =?us-ascii?Q?R4M/pFscEOeeNZhbWsHfwFfItv0FDJLhAlj4fE0wH5S6jPJYAyBh3XoDyMoL?=
 =?us-ascii?Q?MiuPylHPYKGTEuvl42VOv3bseGL9Ih0QUWHNw5e6E5UkKeVGPm7dUPgcS8WV?=
 =?us-ascii?Q?K156cH/rLLc6OyRb9EgL17slwu/eMVCzn6CvlzobrYdQybaQmwNyc4oBq8Vp?=
 =?us-ascii?Q?VuK/JWu0Mb3+WPsph4iEZCkIVAvfAG5I43mMsfZ5tYIANEcMz89bpsniW77Z?=
 =?us-ascii?Q?EKbfk+c/uqyztLNKhBrh4+aqZ96OpDbJk0l7WWwRAxP54H2ct5u0xcDPiuXv?=
 =?us-ascii?Q?dTtuQ+DJarLmrwm/7JRY8nmbby1/1ZYmPVaQgMGCTl+bup2FDcIC1anLk+JU?=
 =?us-ascii?Q?osAkDK7GCtyMgI1YyGXYCZ6H2k1jAecj2ao3yzhcolWzGJQJcujWtxjW/dmQ?=
 =?us-ascii?Q?REpsnjYmcujagPFJ35cMx8jWxGbN516p0PC8AeBBe59+BXidZUmOwKRGp9ko?=
 =?us-ascii?Q?cTIL/hFEeIfUsyOmdFSA/6Xxl7/zj7PCX84eVaO5RhH8V/EgwKhFvuuTBgjh?=
 =?us-ascii?Q?yAcJV5qREjf0ZyG2b273RA+Z73LZ+U6brgecGH9kwhbji+pfuekte84//ugT?=
 =?us-ascii?Q?vphy+tD1VlHUrgo5UVmrqQrMVXcMjY0v1gIHAcHzTWgcOdPPLFLRU66l9NdM?=
 =?us-ascii?Q?alae7zlOTMQnB1oXlpwN4u7KIQz1GG0mcLxwGL6qZj9lpRU8nGV83Uxp8gxL?=
 =?us-ascii?Q?AMgfg1zP+p3hD37Rx9tPKBnyrRO3kBIgd6XGA/Sx6I99S33LxLhZ/QRfLPTv?=
 =?us-ascii?Q?GteMHI+lfHIQK9iYcF6RbvDgViy/FwQBf0OJHRwCUp8h7xveGYxne5oVxgQF?=
 =?us-ascii?Q?IjxhVIpYkBkLose9mtP72wDt4Xh8QismaXCbyKFOZ+Jm8PtCUuJildt7y2xv?=
 =?us-ascii?Q?7QiTOYsLnvrbwCxdqMk5alo+96/g2egSyodsj3PX6+jlRuMOC1woLjw/eC2w?=
 =?us-ascii?Q?eopFX1jR6ZyYH6bNXhVMAjJCeOTMkxzjM/f3x4XZJUu8ZK6+FeynLl8ImciU?=
 =?us-ascii?Q?0IUR5I/IyMHQN10uiE4yu/FCT1ba3LWbpEAzICQmPRZ2Jwptmc868y+ImeXT?=
 =?us-ascii?Q?sb9C/5oiYclZKhGRl2hvv3f4hXKDguyjcVpc8Kktnlbew82qj3SuDYp8XWOK?=
 =?us-ascii?Q?Wzh/vTTyFicX3euUCpOBM3r+bxjn/LZofN9vlYxP+lBf0k4EvpsceTEfEEm2?=
 =?us-ascii?Q?mXXeYqV7Aq3yenxTnhkIUllBqZgtCJmWmUidTFXqnlgm82h/l6dDyk9wYrBq?=
 =?us-ascii?Q?0JS/Cn6ulf1RkC1fOPrhWjDIYErcqKC76DXbg5f+EwO5Yo11KBvo6JWPZMzE?=
 =?us-ascii?Q?MhQEjPGgn+s7mkfJ/DPCpSBjCeC62stzVA35JkGnd4H9K9B3AB2WoIWE9iP4?=
 =?us-ascii?Q?G+EaRscee5y6C0qguiqEPq0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a278b17e-4647-468a-9d2d-08dad1be0c8c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 03:59:01.4317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qrr8YeSle6iW9skuIdyQMXq/tEVOq+aPvoONMaH6WASKUzefy5U4Iy0/4IzBczRwpfwGwUe7MMMM9i/lQIiTNAXkjT3wuQfx7E/vKi+Lfds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4565
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 01:34:52AM -0800, Colin Foster wrote:
> Hi Rob,
> 
> On Mon, Nov 28, 2022 at 05:23:37PM -0600, Rob Herring wrote:
> > On Sun, Nov 27, 2022 at 02:47:27PM -0800, Colin Foster wrote:
> > > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > index b9d48e357e77..bd1f0f7c14a8 100644
> > > --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > @@ -19,9 +19,6 @@ description:
> > >  select: false
> > >  
> > >  properties:
> > > -  $nodename:
> > > -    pattern: "^(ethernet-)?switch(@.*)?$"
> > > -
> > >    dsa,member:
> > >      minItems: 2
> > >      maxItems: 2
> > > @@ -58,4 +55,20 @@ oneOf:
> > >  
> > >  additionalProperties: true
> > >  
> > > +$defs:
> > > +  base:
> > > +    description: A DSA switch without any extra port properties
> > > +    $ref: '#/'
> > > +
> > > +    patternProperties:
> > > +      "^(ethernet-)?ports$":
> > 
> > This node at the top level needs 'additionalProperties: false' assuming 
> > we don't allow extra properties in 'ports' nodes. If we do, then we'll 
> > need to be able to reference the 'ports' schema to extend it like is 
> > done with dsa-ports.yaml.
> 
> I'll double check if there's anything that adds any properties. If there
> is, would that be a separate file pair: "dsa-ports.yaml" and
> "ethernet-switch-ports.yaml"? Or do you think that could be contained in
> the existing dsa.yaml, ethernet-switch.yaml?

I came up with this change. It also fixes my accidental 's' affix to
^(ethernet-)port@[0-9]+.

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 616753ba85a2..c1900363a6ab 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -41,12 +41,18 @@ $defs:
     patternProperties:
       "^(ethernet-)?ports$":
         type: object
+        additionalProperties: false
+
+        properties:
+          '#address-cells':
+            const: 1
+          '#size-cells':
+            const: 0

         patternProperties:
-          "^(ethernet-)?ports@[0-9]+$":
+          "^(ethernet-)?port@[0-9]+$":
             description: Ethernet switch ports
             $ref: dsa-port.yaml#
             unevaluatedProperties: false

-
 ...

