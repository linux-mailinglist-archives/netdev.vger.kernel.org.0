Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1964C675C8A
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 19:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjATSRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 13:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjATSQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 13:16:59 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F76EDBE4;
        Fri, 20 Jan 2023 10:16:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWetJa8P4NwsdwZVo+PLPuvPw4pzw8rAbQddbB2ldGGAlffF0E2isibqfu9aDrNo2inKOIg2HS1cU8p6QW8oslMquKK5hImC8B8r7++ydZAVCKu3BYzlAMAYNMK+f2f3PN/iz+hBC4pyUyh5TVkXtaMcuOMcWCXZ6BoAQZ8f1xJ1lUVLncauG0+DFjZNrS2g1eOiFhCb9vpTSmn3UMV53r4ZNniXEYUftk56aDpHrqf1WdcTKXPr0vXKPHcihHbpoS5MjroiqJIHHrXLDLxrm6Tt3467t33W6+3ldBArGtS6mOiaFayH2A37RD8CGgvQYPoC6wltI9/pC2QObsp+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yid/9EaBoJ5uQPI9yvs8y3YbMKrVIwUULDwGBoIEho8=;
 b=ny4kQVSbR/Jslhf/6gvnMinwLcQEsO9eUPn9LXArhePZTZLStJqvIIIx45FVATKtKQ4IvgSzAGTTkIvVYMnVkmKnSKQfOLLyXjaINIqBAg3B2uVzOd2PUJqDa4HIPa4EbwwsuCz1TI48NKVS/VPNRbSiMsBPgE/4ujKcSm+Gw6RKrgiHVZQAQX3+qdnOj520aIi9Dv15hIMKAEt50kwfx6OBXGoSG9gA8OPHPRpeA7PQmODRWjcO7Nx+TdJHM4ZeFLm/Ee9FEP08oRLM9EYBD7HIcDqzu/HxOtNm3iaATJUUDVq55C4tfNdhgYhUy8g1MtdpsET5r82lfbMxCFLyXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yid/9EaBoJ5uQPI9yvs8y3YbMKrVIwUULDwGBoIEho8=;
 b=KYVlXnvZFY19Eg8DiYPGhnPspn77Z/6BZ2n8Zg6H8ramWpxaaAijVorAfd9MmjQ6QOcX4PALKeDQJHL3rs5V9Ac+fBpI+oVJuWv5jb8oJXGw0hA/IvNphSONAl33ntg+pqRqg9zdm/bAPXqOeUmYJ/Np/77GvlrRXvElz+mvj1A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5258.namprd10.prod.outlook.com
 (2603:10b6:610:c9::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.8; Fri, 20 Jan
 2023 18:16:55 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Fri, 20 Jan 2023
 18:16:55 +0000
Date:   Fri, 20 Jan 2023 08:16:50 -1000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
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
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <Y8rakgms4sRk/g1c@MSI.localdomain>
References: <Yz2mSOXf68S16Xg/@colin-ia-desktop>
 <28b4d9f9-f41a-deca-aa61-26fb65dcc873@linaro.org>
 <20221008000014.vs2m3vei5la2r2nd@skbuf>
 <c9ce1d83-d1ca-4640-bba2-724e18e6e56b@linaro.org>
 <20221010130707.6z63hsl43ipd5run@skbuf>
 <d27d7740-bf35-b8d4-d68c-bb133513fa19@linaro.org>
 <20221010174856.nd3n4soxk7zbmcm7@skbuf>
 <Y8hylFFOw4n5RH83@MSI.localdomain>
 <Y8hylFFOw4n5RH83@MSI.localdomain>
 <20230119202113.lwya43hjvosjk77a@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119202113.lwya43hjvosjk77a@skbuf>
X-ClientProxiedBy: BYAPR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB5258:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6e6606-0baf-4880-a539-08dafb128297
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w2rSTksMQsuus88ehzd6twzRfw2NoEMpTMMtJn2h23g8RfqVrW4ExhKGN4FOTNuK1JEWf+lBQ/AitvF+uYUBU7+qWCI7y7jn8CieuauO2NPQX5BmXfA4uKfvF0Vo8SX9IgyfU/bcSSXeMMkW95skuO8aN6Ye86HdlA1pz0zknycQ2jn4TJ3Kg1v/fbeKD9rwEsb+HT23E0tlPXlFEi3PYNftqm9jFvU1XzmBlOrXcxFR0aU6/1zB7xapwGM+NQmH7rVUsJYjnU739iGO599yff1e+qYcKEjacAQJF01nfwscf6hZelgWCw8coI1ZMUiCbmDmKW8Rzsb8993wZvyil/6U8wfe9S7OvqhV3oDZ4SRa5DmqugTeNQjZ94CWyIjqJsbyCwxmQTLmwH0haJ7G00lRPXod4lXj4fxKkL977Dpo1F5oxzazvYRyDvdtcSwM+WlnNfik40NwIcGr3nawO+0ouakqqMUpLiCIBqnFtbakhHcxFLsHReKV0FoRhJtZKFW1ayOtQlyNRIMylVd4zA6mwKKsPWSTIVrvF7pZD0MaWosm8IkeppLsewS2dCH9EqtvojvJnsRUTdLjj2Ol9O/urCdTsWNFQlFsiwoHtldNM5o+mfvpWfrmLoECWtAtPunTLAKJDeT46w4nnn3quA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(346002)(366004)(376002)(396003)(136003)(451199015)(83380400001)(478600001)(6486002)(6512007)(38100700002)(86362001)(6506007)(7416002)(44832011)(41300700001)(2906002)(9686003)(186003)(6666004)(316002)(4326008)(8676002)(66476007)(66946007)(66556008)(6916009)(5660300002)(8936002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VU7rPsecIdWpQ2uvIOL3KKN1iM34GlTvz5lMfo5d1kuzjZjtQJTWWfYkd46g?=
 =?us-ascii?Q?dapbjKP/jRn+2uPrabe/zW6MI68uO8eMbcNDMinh7Igo6AIwCWmv1xqesfmN?=
 =?us-ascii?Q?ejxK5cUbeBD7+UBuB1W+mA/Tl0GpUIu8VQ5GrWi78wE8c65x4G5NxMx8/d5F?=
 =?us-ascii?Q?6jzQRW6ZalAF/u+IqhBXh7Dk50TETgXmpUlfLQ4YNABq3Rc3EYIrqjbe6Orn?=
 =?us-ascii?Q?TS9evpmViXPJ6dW+IZGzC7FiqV5GmBl9qxLRBj25TaQjxnvqLK+i3QyL3w/s?=
 =?us-ascii?Q?7Jf7Hg63iHVolzCakhfjzpO9+uaAVMj98q2TVHA3fiWBRiZ52LsX8aSJEoPd?=
 =?us-ascii?Q?hKQUQwTqmTWaN0RzctWnjZpYcD84hc5uCkipQtMqh/cMtD93PeUwE4dfFsjh?=
 =?us-ascii?Q?FLNgetLBkJbmHwcTD51kdJPQSE+irWZV6gnD6e8GVHm7gkdDLdCQ+GNuccR2?=
 =?us-ascii?Q?M0Mcxir1wfI4nKuX+U7T1tgmICzWC69J1i3RTk2FxpqVWfb6TMGzqV/29eWt?=
 =?us-ascii?Q?f9Q3d9NRPs2+/mPS+9Ixxcl4N+DyBEzIxQyfICwnv9NLakm71HoUsUmshp1U?=
 =?us-ascii?Q?ZVT0wg1blx1m6/lrX8wdZi2mVfwKKE5PR3Wl2ai1WHzCAlozckSXPnP2Rn5l?=
 =?us-ascii?Q?X3ssLXZejyM7tmqbrSuSdYOFYHtP5aLZJqBz7+WB0DmXOxoWn1QIdqOfsqFH?=
 =?us-ascii?Q?e4JHOV2ySUDzdSXc5IvLXyvsZVIM2MaCfVd3qyk6OU22LZJQ1GGTF1zwctJj?=
 =?us-ascii?Q?QWivIE43IwXmW4fFY0uvBlVrJG5WjQhCSaQXnVZ3XZVk3gaCBwDu4SpPEcy9?=
 =?us-ascii?Q?dmyBY7lYKfhhWS1K5XfYk5JujIrMPGX9cFjwaBp5lvhp6d9++AgI/+MYsKEd?=
 =?us-ascii?Q?ujY9vymE6aMb47qz134PhkPLYvU/VtkPgS3ILNFCNAdOHjVJYSk7S4KqSvoD?=
 =?us-ascii?Q?ou5NnmUWmcFCnS602h12dZldRaQ7Q3HPao7tiVXuc2vPXT6CuvWAZoCJe3rt?=
 =?us-ascii?Q?he55waHhPSpL6XnyQ99es/RqUxaOPg5MtJk+Jb2GGaMsKEcqA+MXEDA5sKPJ?=
 =?us-ascii?Q?21KK7/PUXvZZQxlO9xcSgg/60mVr+QlKhexj1xB1UGWFyP6ggWdWh/v3Aswv?=
 =?us-ascii?Q?zhi/z0ot9wM2K7hJNsz9apCv1T1GQXfSZ9tWES/D2yh09n34zMUKIkQT0smj?=
 =?us-ascii?Q?+aEcz97Qk6gRiU1HlClKurcDqThpEWpX4VmINnAeYUlJt5OLvT318Qa9lZP3?=
 =?us-ascii?Q?KJ7BFnQwiYOwwywqOZOBWHJ/AMB0HHr+Bg3vJnKrL67pfH2vrSio/Le6IP64?=
 =?us-ascii?Q?d7JGOwA95xECbhRN7UqrXisSHrRa0Y/h2STrpVJg2605BrEpskHzr/s5rdnz?=
 =?us-ascii?Q?9gtcXk6wTFJGiNwnJ/vGCH1rPrNr/RyLz9xQgpt/Ge8vtlO9IFsHKKnhAWZ4?=
 =?us-ascii?Q?Ssof5JTJWvmTm+HuYRz/IABTlyOB3YtD1EQiXEyZeqWe2RnKCV+EqBuDY7TT?=
 =?us-ascii?Q?0JNF5wrzcysLOdaidiq8XJbhwKerwJrJqWpIi9gEpQCbrEYssQBipVasLTps?=
 =?us-ascii?Q?S+8/KeCAJjtcNibUvGob7eoMz+caQjSr5wta9oCcoc8yxBNs654p7B2PoWjI?=
 =?us-ascii?Q?ODkEx6kskVIS1gCaPCtvdSXuSZ34JNbaSUWV/6Rm4NiMeoLbmQAMjkuDSPyj?=
 =?us-ascii?Q?/kf+DJp1bego9hGr1QxnurNaz4w=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6e6606-0baf-4880-a539-08dafb128297
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 18:16:54.9680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+O1r9eZGdPXvE19pn5nDaddX9q3Wgd+n1D8M2WaGO/A9xvCz4u3x4dnKgkKQIjfaiLbyTyTrPHtuI579aGMLJ5aLeIC1UUu7tph40fSvk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5258
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 10:21:13PM +0200, Vladimir Oltean wrote:
> Hi Colin,
> 
> On Wed, Jan 18, 2023 at 12:28:36PM -1000, Colin Foster wrote:
>  
> -  ethernet-ports:
> -    type: object
> -
> -    properties:
> -      '#address-cells':
> -        const: 1
> -      '#size-cells':
> -        const: 0
> -
> -    additionalProperties: false
> -
> -    patternProperties:
> -      "^port@[0-9a-f]+$":
> -
> -        $ref: ethernet-switch-port.yaml#
> -
> -        unevaluatedProperties: false
> -

I think removing this entire section was the one thing I didn't try. And
sure enough - it seems to work exactly as I'd hope! Thanks!

Next week I'll do some verification and will hopefully get the next
patch set sent out.

>  required:
>    - compatible
>    - reg
>    - reg-names
> -  - interrupts
> -  - interrupt-names
>    - ethernet-ports
>  
> -additionalProperties: false
> +unevaluatedProperties: false
>  
>  examples:
> +  # VSC7514 (Switchdev)
>    - |
>      switch@1010000 {
>        compatible = "mscc,vsc7514-switch";
> @@ -154,6 +175,7 @@ examples:
>            reg = <0>;
>            phy-handle = <&phy0>;
>            phy-mode = "internal";
> +          ethernet = <&mac_sw>; # fails validation as expected
>          };
>          port1: port@1 {
>            reg = <1>;
> @@ -162,5 +184,51 @@ examples:
>          };
>        };
>      };
> +  # VSC7512 (DSA)
> +  - |
> +    ethernet-switch@1{
> +      compatible = "mscc,vsc7512-switch";
> +      reg = <0x71010000 0x10000>,
> +            <0x71030000 0x10000>,
> +            <0x71080000 0x100>,
> +            <0x710e0000 0x10000>,
> +            <0x711e0000 0x100>,
> +            <0x711f0000 0x100>,
> +            <0x71200000 0x100>,
> +            <0x71210000 0x100>,
> +            <0x71220000 0x100>,
> +            <0x71230000 0x100>,
> +            <0x71240000 0x100>,
> +            <0x71250000 0x100>,
> +            <0x71260000 0x100>,
> +            <0x71270000 0x100>,
> +            <0x71280000 0x100>,
> +            <0x71800000 0x80000>,
> +            <0x71880000 0x10000>,
> +            <0x71040000 0x10000>,
> +            <0x71050000 0x10000>,
> +            <0x71060000 0x10000>;
> +            reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
> +            "port2", "port3", "port4", "port5", "port6",
> +            "port7", "port8", "port9", "port10", "qsys",
> +            "ana", "s0", "s1", "s2";
> +
> +            ethernet-ports {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +          port@0 {
> +            reg = <0>;
> +            ethernet = <&mac_sw>;
> +            phy-handle = <&phy0>;
> +            phy-mode = "internal";
> +          };
> +          port@1 {
> +            reg = <1>;
> +            phy-handle = <&phy1>;
> +            phy-mode = "internal";
> +          };
> +        };
> +      };
>  
>  ...
> 
> Of course this is a completely uneducated attempt on my part.
