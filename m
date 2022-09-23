Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F425E81AD
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 20:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiIWSSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 14:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiIWSSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 14:18:43 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2094.outbound.protection.outlook.com [40.107.244.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993DF12647B;
        Fri, 23 Sep 2022 11:18:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQoOqVW5znYIk/r5rwwmky5Fw7Q27nWp3p8whWrfbjjR3+sb61WZpzIdUMF+BStzZKkbCrztD8Cg7ci6k282RE1NUyFCx+CZGrESo5MwSI+xKBuHGHXKRYgYLW8IbDW/gESIniboCQeC6vnq9+YA0wG+KaUtzS93v9AQ4Rnp899V/YJB2XM1B6ycXWcG2ErUEGSQQ29jaeetQnRQVOd2fDC426Nk/ZgSqqoxTah+xH+A8HWO3kn0yM2VrhpWNPzvxwLSFkFYBUtWUKBCir7sL0I1ay2gwuZE+Pd5aSShHS/R5yVr1SICCWd4boYAYrVtaHVcH+rxYp63j7+Ti5mk8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7iFdUe4iISXxd8qofDDPmPgwyAlVS3GkCkpwwydAX88=;
 b=V5qyIScMitzRpeQs5XO9Q5jpSjiB3WvwLePfjs7RjOnGan4kwHslbnrhXYSe619UtyZ4q3Yuhx51kpien1QLVi8FbUqECT1+eyj0XCeQd8b4IMSDKgZwKWz8S8AXEu/f9yA9f+J7gcEM+AfKmTrs8Aqw4flkEfymcw1l/dZPTSQgl1pJQmhlaPpLQukGegVtAIxJ2HDzdVb6w5xbs6oxEbmJcD1JmrfVyMwTacF2Sk70FWoLvnCRMvRTLHOrKXzzGdbD89lP6+E0/2RBMEpcQVgKpWnQOmwl0iniKyis7AYtf7y377aebD25TuJUrtukPCU4c6J3rmOWqZNj1rQe5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iFdUe4iISXxd8qofDDPmPgwyAlVS3GkCkpwwydAX88=;
 b=xrxrMLt7TFBw2Y+1QZ5+WC8FGlDQ4Be33h6zl3sEnvcHUkA68vmAN6fphX8E+gfbAqWhlvrzWz858VhiHNZplFTCfMhV8jVAZPCGHBAMschMHFBPXPXw2hz0xorcm72P75+aSa7gPdoKeD+d07Mr2LaxvPuqDQkDE7O1bY3ehJc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by IA1PR10MB5947.namprd10.prod.outlook.com (2603:10b6:208:3d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Fri, 23 Sep
 2022 18:18:38 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 18:18:38 +0000
Date:   Fri, 23 Sep 2022 11:18:33 -0700
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
Subject: Re: [PATCH v2 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <Yy34edNkKopsETcg@colin-ia-desktop>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
 <20220922040102.1554459-13-colin.foster@in-advantage.com>
 <35ba126d-be10-2566-63df-3c474cdc8887@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35ba126d-be10-2566-63df-3c474cdc8887@linaro.org>
X-ClientProxiedBy: MW3PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:303:2b::14) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|IA1PR10MB5947:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b4d2c16-e188-4d2c-3980-08da9d900915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JYOiOZ2129YpA+LIeqmxl7psm9et54jPTzNvmfYnp8ldlb2wxQo1mW59t/7mE9dIi2660Via0EFShNafXAJs8XsrUeVdFAux0EiWlVrJTkPWEz5eB1LG1TxEFNa53vkcdd/JGPslr33CrKxtBzUt0MP2U5ivU5AoVlFIagMu9A0s05w8gA2+ChU4SHX2pZPMq4/Q1UCUESN28UKINeKqUazWh0qzuhtLWCmILXeko1r6Me/7m4nijL7r+9uS15wlqOqMTnfC6pesG5TjYIkwWB7c2RacS54Ju/z+7NoI/DHwfLWaWcpBN5QUXmO0qqPjfjhV/k5Z+NIaVwjlA7ArjtOnUpVcxTVRre/N2YU+Y26dvqgtW649aGs8nXZLhvCodYOW8MU5ghRRVhXSsiEiuv12oXWPSTT0XhxCdRHd/HgWxJJJa56DqXgOwGmOB3W2YWVCOyX/qJSHpY0ox9wR3nOlYC6Is/Z7a9yZ4Q62Pv6wwwIhJDyAVzFRhrf0U+nIpmqr3XgpEbJuM+morwwxQ0u+Q7Iw/RiXswFsn2dchYBR0mc+1gm0sDbxPG+VoPHwX7YnfsIn8TTcAgk6RnrIKX6Uu3YV+6ubAzmjMZt/iLCUXl7pL25IA4d5ANRmx8R5VxIZokrOXNhhzwPtgXA/CePZX2CBZyLvzWi5LC6VOlXpwGrvrI1xM0Ne9WFoj6uEOohE0f7tdbxYNj6+73AE0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(366004)(396003)(376002)(39840400004)(136003)(451199015)(6666004)(8676002)(86362001)(33716001)(38100700002)(66556008)(9686003)(6506007)(4326008)(66946007)(6512007)(53546011)(26005)(66476007)(41300700001)(8936002)(44832011)(54906003)(5660300002)(6486002)(316002)(478600001)(6916009)(7416002)(2906002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xBI52VHh+IJl/WWv0F9wPYv1sLzdiQTJu4Bumi/k7+V/IyhpGRQpIheuxCjM?=
 =?us-ascii?Q?SSneObwamtyDkdBNiergKTMMpmOUc1YMQ/gwE9hf/wi51QCECOCoto5QIMma?=
 =?us-ascii?Q?5sHnoZiiv2/0ljDWCXqtN77QRk2R1jA+dzdNhCoYS2M7R3BPMSdQoIGd/Pjr?=
 =?us-ascii?Q?j623a+OpshA14JD8/65z+GEcLWlMhXmzBFJpC+boeNH8e9LDwkKeO6zZexwv?=
 =?us-ascii?Q?+rEd2RH0zvACUiJagO5j7XqYff5lJybnnRQiVH20D8FahysHwBxXqlDlM47k?=
 =?us-ascii?Q?bWDZJFKyTm5vfQZN5AVSTjdX4Igb6Gn/3Z6O2vlxcZdtNkVuMu2X1ZRypseF?=
 =?us-ascii?Q?lrDN1VGqtoQrLLFatjdpX/Zd2rVFaI4cME3X9UU0t9QDl0E7XfnHUZydTxqH?=
 =?us-ascii?Q?SOZHLsiIvJulsIRqYWcjc5LGj2z660AoRkEJRakdTgh74Hqk0Tq3fPMcMyBn?=
 =?us-ascii?Q?z0PwSI4HyX/Ua2DO77D5T8H+R1GKF93llt+lHPX+dtdBDUOqtMBY8gQp5WXg?=
 =?us-ascii?Q?/mWGaChHXQ6tttuXeWIy7R2slbR55LATYCt0ryQr8V8ttNLpTU/+BJDFrIDb?=
 =?us-ascii?Q?hN6XRKFFfYfodwtwvfp2z4cQCmWSIs4FHLCoJygaJs+LzTitOddL/N5AdkWH?=
 =?us-ascii?Q?IthkKdjnDMOWilEaiEVjB64tGmJy4MpB5weIO8oKDbxrS+NZq9GYBMcfW9YE?=
 =?us-ascii?Q?XcYXx1bHmqu5u/XLU+Gss+/MpWZobqx/1VDddlPpnuihfN02TSvrqdNac+Qm?=
 =?us-ascii?Q?kXt18lcHuqLu25PZfEa1u9ltXs/KPET7yBeYtT0sjIKbLyV3Ow+9dequXPIp?=
 =?us-ascii?Q?CFkX/jviQyn092x4/aFud21SI4mAJw8DsT1/FKiJleq7rIPPDAp7H+u3Izuf?=
 =?us-ascii?Q?x3Mayi0FOhci4TSr4L/1EHVhsAZlwA38D+W+bm9rHZVOtnj+QV013VbAmTM2?=
 =?us-ascii?Q?kwKuqmaoMXEOicxNH4hKQ8lDLj1eIVE3JmXd7BGeE2VgLsPHS/2rwsG/XQ4B?=
 =?us-ascii?Q?izB6EBj0E3ANiJx1uPxuNb8qDugjDOPfUCM7D7J7VR3tAW87fsKbX9c6PTnz?=
 =?us-ascii?Q?eVBy+vlDba+8n1Xu2XBF0aSLnexFYGzIYNcnhq7ONOSC/d5UzSbjwIJEdpOj?=
 =?us-ascii?Q?UBN3fvHJsrJl4kfG6GEDrJJKlX8tYvqR7Op6j8dVNd91y+yT1e6PKqsiatrS?=
 =?us-ascii?Q?o08onrv5VculBhufOT6/VpM4CPeQyKGmuxe8dpbnepLXpe21igylVlTR8Whm?=
 =?us-ascii?Q?5afPEfsJ7U2TPldNNJfHyrPjsFCDwpLd4zn8oRVnHs8jlnx1fj6YghU2BpI2?=
 =?us-ascii?Q?8pSWWU/voQqSJsRSNBMkJJX6elyGebipEkIYTxGV2izrEd5ET7wWJch3j7Gb?=
 =?us-ascii?Q?kavxqp3f7kDOpa1tzama4jcoGkJcYiNUFyHz6Lzz1ON5GCz3kET30skjT4Nz?=
 =?us-ascii?Q?Agjalv0gQyg/ZQ5aUYNLMHidgBbUFhuC0UUVsPw/bdhy3Td1TJpyI6KBGN5F?=
 =?us-ascii?Q?5IeIm7lra+S96iZnPkUkVccJU53SD0yzK/+cwAPAK3PcDOzXJyKGLJHFJhs0?=
 =?us-ascii?Q?2begwjkBm1tjipEztphp4es9yrJZwjg2loP7O1hexCF4dLxLX2glF1qde6h3?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4d2c16-e188-4d2c-3980-08da9d900915
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 18:18:38.1771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: izLtiWuiDf8xuaw4C4bpTMM4Zwao1JjvgyEA9GvjNCEI+32fEY5KVxmj6DlpsGIMLZsmnlv5xMje6zJMwirudNDieQ5y98dBUuwDZcQzSBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5947
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 08:08:53PM +0200, Krzysztof Kozlowski wrote:
> On 22/09/2022 06:01, Colin Foster wrote:
> > diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> > index 8d93ed9c172c..bed575236261 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> > @@ -54,9 +54,21 @@ description: |
> >        - phy-mode = "1000base-x": on ports 0, 1, 2, 3
> >        - phy-mode = "2500base-x": on ports 0, 1, 2, 3
> >  
> > +  VSC7412 (Ocelot-Ext):
> > +
> > +    The Ocelot family consists of four devices, the VSC7511, VSC7512, VSC7513,
> > +    and the VSC7514. The VSC7513 and VSC7514 both have an internal MIPS
> > +    processor that natively support Linux. Additionally, all four devices
> > +    support control over external interfaces, SPI and PCIe. The Ocelot-Ext
> > +    driver is for the external control portion.
> > +
> > +    The following PHY interface type are currently supported:
> > +      - phy-mode = "internal": on ports 0, 1, 2, 3
> 
> "Currently supported" by hardware or by some specific, chosen
> implementation? If the latter, drop it. If the former, maybe this should
> be constrained in allOf:if:then.

Hi Krzysztof,

Currently supported by the software. This patch set explicitly adds
support for the four internal ports. There'll be another patch set right
around the corner that'll add QSGMII to ports 4-7.

I see your point though. I'll drop "currently" and have it match the
wording of the other drivers.
