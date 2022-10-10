Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F0B5FA392
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 20:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJJSrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 14:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJJSrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 14:47:18 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2123.outbound.protection.outlook.com [40.107.237.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2775675398;
        Mon, 10 Oct 2022 11:47:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMKPETHSkpIIDmxrcIlsldkrtUdzl6hmOBURSMfExGxt96CiutmD82NsL4w9TlOlU9W2/M4W7eQ/V8SlParXGNv2dmedRuK8ItqQMZNkLpZ5jwrlqeeHxw3vfv6OOWIRJq3SxiOyrHkBXa0uB8/W5QueL7t/Ci3+vJcXJ97yoWI5CESGWdt6fAqfg0knAfA+b+1fdgpAKzIv9s2mY8s5vKfbmAlSDrgmXi7tQTYFAehg86jSsoxI77nEoApO5QOYIHR1RluI59hDZRp8KVeG3a/KKfJXVAlARRAUPgYJR0U9LXSjfmL+OyqNzr2e5+XHoG8IB6TjdRQmVkWP8PRVxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AotKSGtqQIE+I7f+BTzqLI/CAueaEKC/ex8Fp0SqmY=;
 b=j9pfhIZeg9DUjpjANCd1x95ucsKsIWu21ZDcoM3iemYbWlmh7sKUCj+KH12y3uvPH8znTZp5jNwKn2ao81vpEHMAADOWUYCXYV3t2Vevq6e4v4+WdPU1lkbizpwf8hd7NObjRkWTzswaRY7y0V5xn7rJPK/D6mh+5mQjOOP0/t697UtqFmapOUUI4cB8k+nbmQmDOrORVzS1NUYmDHJJI7J9LAQ0Xii3Xe+tFzPdu4rh6x9jnEVkQNeC3PVd1x9Ofd0y8QufyOuwzT9BPJzuRyKAipWj035qXEU/jwxfG6zY1342dBuenT5G49ndkJkrQasHiXg+ebxky6s5rNWg5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AotKSGtqQIE+I7f+BTzqLI/CAueaEKC/ex8Fp0SqmY=;
 b=FhXeDySPWhG+vnm6Cc91f2cFWLKHsGSu3kPM+fy43ewq6a8aJ67spcf8evm7o1NYd1vk0WpvBIZF/kepupkopE7RM8nhXWc90JgAIPu3kmcd0fM3cTNn3EKSiUcqFOHN+/VUJScBIzze951QGMY8n59QL3W9tL+gU3Uj7/JkCBE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB5928.namprd10.prod.outlook.com
 (2603:10b6:8:84::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 18:47:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Mon, 10 Oct 2022
 18:47:13 +0000
Date:   Mon, 10 Oct 2022 11:47:09 -0700
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
Message-ID: <Y0RoraHpuPbN5O4C@COLIN-DESKTOP1.localdomain>
References: <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <YzzLCYHmTcrHbZcH@colin-ia-desktop>
 <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
 <Yz2mSOXf68S16Xg/@colin-ia-desktop>
 <28b4d9f9-f41a-deca-aa61-26fb65dcc873@linaro.org>
 <20221008000014.vs2m3vei5la2r2nd@skbuf>
 <c9ce1d83-d1ca-4640-bba2-724e18e6e56b@linaro.org>
 <20221010130707.6z63hsl43ipd5run@skbuf>
 <d27d7740-bf35-b8d4-d68c-bb133513fa19@linaro.org>
 <20221010174856.nd3n4soxk7zbmcm7@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010174856.nd3n4soxk7zbmcm7@skbuf>
X-ClientProxiedBy: SJ0PR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB5928:EE_
X-MS-Office365-Filtering-Correlation-Id: b7b4c9e5-ea64-4151-beef-08daaaefd89f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xGI/4a3ryS0GSRznp+fdIlMbvAAcwFNLfvMoAp6H6qOJLOaYAXiaIi4hXx7cP0AmCZWenB6MVHzr7Yh21l9fXr1xgmRTTschl8+psbT/c/jqC9WYnyqLj6WYVZQRn+T6bUGlRKi1kRhRHUKmGr6z+BhuPM9YXilAiq8luE60cVt/Gt31v/FVYKEEg8ABMwCfEisv53dcuFyWMSvKm+BQiRWOpwPq6PRTYioSV0NY2w+j+dtUlCeG5g/N4mivLmI/HgwKJGvjcbZC4c13GSjsJBtw7df5m/Rh6u+grgBpdMjrKF1TSasx187A67IqQM1+Fg80u1L++AsDAKZHYudO2rbAUri52hAX1PhzQeBW+/RupkP/gVWRU22zJ7uEOG1yxOSEKRiKypUFS71M2tPSS+I1Szth9hmuUKXsUQvteOl3B0TLl49o1MAr64Z+bTag+JpoaE04qUkOurCNHoV4/EYTMwZPSb0fJKXvaoQSLzlcfaZlxnrAxVWPo6RPdUAY6kqs4rwhzOWCEDu+um9q5ypnLyb3MXW3imOrsaZj0x6BmeLHwevLW0TrkKxjiVrbOs+Us2H7wmXnkhVTF2yPndEqwKtnrcanHTvoplkGr3sFhpcWp39zXNt0Xa0OVS5GOQfmx7TKbeAfoxmFn9c7C/nO7Gx9CGdlxDq4+bsjhGlCENg/GI0pVmSZ0aiI1zzfE5QWSc89h2rKPfJTBIZrcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(39840400004)(366004)(451199015)(6666004)(316002)(54906003)(9686003)(26005)(6486002)(6916009)(38100700002)(478600001)(86362001)(83380400001)(6506007)(6512007)(186003)(2906002)(41300700001)(7416002)(8676002)(5660300002)(66946007)(44832011)(66556008)(66476007)(4326008)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yNOv3ZLSigviHAEsD9cqz/eFyx/k/+aYUOguVq5FECB3cu+4uIUWrg9jqFqM?=
 =?us-ascii?Q?oNniTX1UC6KQNgVoxAxhneBNVS2P/UNzBflIkH4jb21fuyxTVnd8vtCgHYrx?=
 =?us-ascii?Q?Vf8pa73HnMftOfTYeNmvZGqZlDfr33n2PkatSCFvIMWJ3pEyqSyHfUF7lXmf?=
 =?us-ascii?Q?RidLf39/FXOYUggOwyOAxu+89oWatYOwFMt5l3WJzSb7WLGxJ2xRsKAl2+6U?=
 =?us-ascii?Q?NzfVAcZyQJqkNdqBXZnficKjrChidC0AahelYJqdDHFNQB1wgdJ3QjYzgxJV?=
 =?us-ascii?Q?saRMT2bXXM505JTkaWE2LG3OOZQjclXwXYiO3AcdFQxhNw61mt9xnkpkiQ/c?=
 =?us-ascii?Q?PlEzyh6DR4VX5LmO218hJhMAdyOutaRnYP4PEH1VCJRvn0fFibz9rXtloOJl?=
 =?us-ascii?Q?VfXJnss1blZdAOs/fZGJvBJNL6D/E8uqS25dLsZjQhxWI1QZ275iOEhrzbQ1?=
 =?us-ascii?Q?sbn/A2dsbYsV8il55tcnRy3wnFikPAF1cLtb64YedrpkeBa54USy/E8ebmZo?=
 =?us-ascii?Q?Rzt9A0vvIQVfmEQWcnUyxWKmIggwF/mCF/uNCOlnO5hnxH9MuWJX7DLnz7y5?=
 =?us-ascii?Q?Z0Nv4QNaJAY/LnA9/JOsRW+HhMsMG8xjWqK/EghEcM9vcOJEN0q2FtFPr8M4?=
 =?us-ascii?Q?sOk+jgn7fbdLN8imQNwUlAjEdUqZFYwJV25kYoU5WzjLav7DaH892xgX5+id?=
 =?us-ascii?Q?AfPsR1y3LlTHRdWylUETSb+HwhpQ1kqkn4BongflljdOA56wtk4UJeNKO/La?=
 =?us-ascii?Q?jZlED7k4hIyUOMkMNBWCcjzbl3mPFTJG7vGZ9h6CdRYYZc1hxaul+h9fapHm?=
 =?us-ascii?Q?rKdsactlyuLmaLNYuF+z2LFZT+yK6YPEXIzqu9adwvKs9pYYdifvlK7zqDes?=
 =?us-ascii?Q?1PdldYj8HkIfsnKzVyhpbvOl9qTejbvMky5kY93fuyC2zkRok8Uu/U36BcQ4?=
 =?us-ascii?Q?55Kx2hT32gHlyysaObKWHU+spmCdyQsIIpbhxwA7Dvl2+WsodgR5BjXr3f0/?=
 =?us-ascii?Q?TbuEec/c4yCJqD/hb8jqljI5f8qZuBs3rllceWN900lYmUnr8TwP6G0Q9XHx?=
 =?us-ascii?Q?17jZC1W6Kzpa0zVYt5XdD8lYNOonOiDjIRJukyusstaCQ9t/GrkDJj3Ul78D?=
 =?us-ascii?Q?iI36V2nswrovb1RZf8PlueTaMMGqY+o0MdaHb3+WTOFYY37wCiu68GlpbGCY?=
 =?us-ascii?Q?dUnrKGVPnyvXyEcNmpWO44gWP7+fItX5u2akqtUouqCRwNMdj512Z0/6n5AY?=
 =?us-ascii?Q?c+HolMI1e4GE+6fAs71nlQPz6GjVXShzT0oKFSzLhYcj8x+d0TA808OLd03d?=
 =?us-ascii?Q?53DxkneYky7kBSjhYEMPmYeFKHKApAjaYnpAf6aTpPg2QnTxBJKEsCD75cpY?=
 =?us-ascii?Q?NMF7BcVz52lcCMNCHBoyBTTScM9S8gA2KreBfwZEUpg0Hj6iiRDtWFc1TukG?=
 =?us-ascii?Q?gnoDSclaO/A9C5FjXcPPas4vwOCW9hzGNb+U1ugXTamg93tAQZ58bmwUji/Z?=
 =?us-ascii?Q?+UbnmAEJowP2VKVFY2SSOmZO0ArKdgLt/j/vRMFceUIana/WzK8j3ctFzTO+?=
 =?us-ascii?Q?ouIHEa1v9t7vbwFjTRIxsPRsvNGgJ5SngIYbf7konMia7L2vNV45R3NzzJnR?=
 =?us-ascii?Q?bg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b4c9e5-ea64-4151-beef-08daaaefd89f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 18:47:13.7568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Uph0AHxm4KuJlZRskP5hcS28o1nKfL0SPOOBDHqny6972eDRwZHZcwtgX33y9q5ECvpbMV5Iv/FF1xZxFYuWyT/MiAwapNpnTPu51TuXDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5928
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 08:48:56PM +0300, Vladimir Oltean wrote:
> On Mon, Oct 10, 2022 at 09:37:23AM -0400, Krzysztof Kozlowski wrote:
> > What stops you from doing that? What do you need from me?
> 
> To end the discussion on a constructive note, I think if I were Colin,
> I would do the following, in the following order, according to what was
> expressed as a constraint:
> 
> 1. Reword the "driver" word out of mscc,vsc7514-switch.yaml and express
>    the description in terms of what the switch can do, not what the
>    driver can do.
> 
> 2. Make qca8k.yaml have "$ref: dsa.yaml#". Remove "$ref: dsa-port.yaml#"
>    from the same schema.
> 
> 3. Remove "- $ref: dsa-port.yaml#" from mediatek,mt7530.yaml. It doesn't
>    seem to be needed, since dsa.yaml also has this. We need this because
>    we want to make sure no one except dsa.yaml references dsa-port.yaml.
> 
> 4. Move the DSA-unspecific portion from dsa.yaml into a new
>    ethernet-switch.yaml. What remains in dsa.yaml is "dsa,member".
>    The dsa.yaml schema will have "$ref: ethernet-switch.yaml#" for the
>    "(ethernet-)switch" node, plus its custom additions.
> 
> 5. Move the DSA-unspecific portion from dsa-port.yaml into a new
>    ethernet-switch-port.yaml. What remains in dsa-port.yaml is:
>    * ethernet phandle
>    * link phandle
>    * label property
>    * dsa-tag-protocol property
>    * the constraint that CPU and DSA ports must have phylink bindings
> 
> 6. The ethernet-switch.yaml will have "$ref: ethernet-switch-port.yaml#"
>    and "$ref: dsa-port.yaml". The dsa-port.yaml schema will *not* have
>    "$ref: ethernet-switch-port.yaml#", just its custom additions.
>    I'm not 100% on this, but I think there will be a problem if:
>    - dsa.yaml references ethernet-switch.yaml
>      - ethernet-switch.yaml references ethernet-switch-port.yaml
>    - dsa.yaml also references dsa-port.yaml
>      - dsa-port.yaml references ethernet-switch-port.yaml
>    because ethernet-switch-port.yaml will be referenced twice. Again,
>    not sure if this is a problem. If it isn't, things can be simpler,
>    just make dsa-port.yaml reference ethernet-switch-port.yaml, and skip
>    steps 2 and 3 since dsa-port.yaml containing just the DSA specifics
>    is no longer problematic.
> 
> 7. Make mscc,vsc7514-switch.yaml have "$ref: ethernet-switch.yaml#" for
>    the "mscc,vsc7514-switch.yaml" compatible string. This will eliminate
>    its own definitions for the generic properties: $nodename and
>    ethernet-ports (~45 lines of code if I'm not mistaken).
> 
> 8. Introduce the "mscc,vsc7512-switch" compatible string as part of
>    mscc,vsc7514-switch.yaml, but this will have "$ref: dsa.yaml#" (this
>    will have to be referenced by full path because they are in different
>    folders) instead of "ethernet-switch.yaml". Doing this will include
>    the common bindings for a switch, plus the DSA specifics.
> 
> 9. Optional: rework ti,cpsw-switch.yaml, microchip,lan966x-switch.yaml,
>    microchip,sparx5-switch.yaml to have "$ref: ethernet-switch.yaml#"
>    which should reduce some duplication in existing schemas.
> 
> 10. Question for future support of VSC7514 in DSA mode: how do we decide
>     whether to $ref: ethernet-switch.yaml or dsa.yaml? If the parent MFD
>     node has a compatible string similar to "mscc,vsc7512", then use DSA,
>     otherwise use generic ethernet-switch?
> 
> Colin, how does this sound?

Thank you for laying this path out for me. Hopefully when I go
heads-down to implement this there won't be any gotchas. It seems pretty
straightforward.

Maybe my only question would be where to send these patches. If these
can all go through net-next it seems like there'd be no issue when step
8 (add 7512 documentation) comes along with this current patch set.

Otherwise this sounds good. I'll switch to getting a patch set of steps
1-7 as you suggest.
