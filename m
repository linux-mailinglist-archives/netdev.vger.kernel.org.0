Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABA0645200
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 03:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiLGCY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 21:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLGCY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 21:24:56 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2127.outbound.protection.outlook.com [40.107.223.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E004F1BF;
        Tue,  6 Dec 2022 18:24:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlYQd4gqCmy/wla1g1obY0a7YZ+irINTVML2bEQP4jYXl42GLgPdbFK10JyEUp0b4cYqwAF/LNnDUIFOX0Eopab6yzWAyRQYvNDgMrH1S60tjGHb7uJHzLrtjMTgCyBZL6eApk8LP4hT1Qa/v4hM3RQRWF7PFkua3/kHcAkNmpGoqEs7TGyxR/4s5prBIKpoZm53Jr7f1LkHeRXTXisL3iVCXTD6Ny9pyj3Wbk+gZYdDwwpo/MG/l7GlUNawfysTz5vCf6bY/GYNmc0sx9PM8IBLYANvietNMTJg9fYpU32/4Ek4KGUf6sX+oEEfUCgL5W717JrhcobEfQH7KZLOOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5u5JhsRtxFrzO4qn48UQ8lYhWjM4P6zY9FwlAEtwHYw=;
 b=Eow8COvok0XlB3z6QsWtgP7t2vEKggq85GEMzJxgZvv5kCvWOIpjeGtq4fjc5gPSYtrkFl3+jzfLUjGAutPc1MB4pa0P17EI9AYZ6sRDAbeHuRaK59pNJP8XY5nI20+AhEbhkHygNKgxPm3xfuhSgotqJAvH/tTlVJiyYByzJ+PFjMAdl+ZPkhsmgkUo7VGWUz5TA5QVFEIwRUjCu6If000Oq06DMmxwK0Q+5Zfp3MiF8v11bKtGcL4XjDdiHuDR3p7mCQVIp4tYxE0wTnR7tKIFsyUNiSNxiU4AGjrOh8sP4oBvLoIVmfehhjXIuw5LxrvvoBwRsXewY4pqJvkNFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5u5JhsRtxFrzO4qn48UQ8lYhWjM4P6zY9FwlAEtwHYw=;
 b=utUUFTj8bRnov9L54x4Dw5XJxR3ijz4w+4CxLEZ1i0ZfSBcvtIkSnEskqc6Q+MPXYiwAqgz1n+awhYu2RqcEraACgOAvrS9+m68U5o2j59m4QSIgEbdQNej4FHt6AudVRXNnNtFxpjJni0rw4P0amcBoznnStVRuiUocCmf8pcg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ1PR10MB5930.namprd10.prod.outlook.com
 (2603:10b6:a03:48b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Wed, 7 Dec
 2022 02:24:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.013; Wed, 7 Dec 2022
 02:24:49 +0000
Date:   Tue, 6 Dec 2022 18:24:44 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 net-next 3/9] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <Y4/5bFMlpVLAQgEf@euler>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-4-colin.foster@in-advantage.com>
 <20221206151851.hnqqwf6zgaa2c7tb@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206151851.hnqqwf6zgaa2c7tb@skbuf>
X-ClientProxiedBy: SJ0PR03CA0129.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SJ1PR10MB5930:EE_
X-MS-Office365-Filtering-Correlation-Id: 49c4cf47-b48b-4c89-d530-08dad7fa36cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fa3x3T8/3+enqRjn0v5k3kJKS0GqshMLTNES0OUHPUrjG9TVMNKLbALz+eUdgQgV6UjCwxKKvcraNa7re4mWqz5RKmrsG6J9Q2Sagj060dOytRg5e8MWvRVtIBnQXHM8d4dkHXMyFNpFQUhQfBWqPAROrVUdtBrEjBy4FCQ7VDDSAjn4mPdU2JKbdpf9JD9zLWIwH8MdCAwsoqlbJjJpf15Z4Epnj+9OQNrLwGCbZf4wUeXMMHGjtDuC+d7lXd0TpB0BkIW4fbq/nPzX7kTHQf/AUHh743uFVsA7SL6zzBWUAieiBPVRmXPwOP26Fi/Z4xgSm9v1zCRxQj7cm759lHj1MWdmCBL6rFDXcrFj17cAAhO8tMCxdvoja0+L/egIURTtsgQh1bzbuoY8+4a9iwGfwp+C/eVNvU48WSaca3BeNHLHZ/kO7SqMhV8pKHriTZhpZJ44wASwTQ1eQ/zqEK5MMA6AcH2aL1aUFAOGCk7n6+VqzJrZpiwPYBAb7F4hy3xQRC3NdIQ8Fd+c2dojOkFyTLIRCdGNxdE7kSeQhIf4g+vGpho1fpJSdDGQsJijNdgHi19YrnXyHSlIZmaW2mqOdPlzzQrn9np3FUiEIeqsxgGOSaEvj3sTkp9t+eWWkChmCLMLIAf4Cy9U1XyQ5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(376002)(396003)(366004)(136003)(39840400004)(451199015)(66946007)(44832011)(66556008)(66476007)(7406005)(8676002)(7416002)(5660300002)(4326008)(2906002)(8936002)(316002)(41300700001)(54906003)(6916009)(6486002)(478600001)(6666004)(9686003)(6506007)(6512007)(26005)(186003)(33716001)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O6vRxF71sXtXFQCQMvm9hy/wIAv5Ce1QbDrbCTXuhTUEDSydGKazY+t+1V8B?=
 =?us-ascii?Q?HNafCPFGvxvAmsiH0jYWxvjxGQdnS2zM4pDEmlxN/X5+XeiPIlNb1I7PyhmQ?=
 =?us-ascii?Q?/XiCfQmO00OJrzKGdGuIzjRdGhpRXrrBmTZzXwPQvJgLkCZ7TTtZoeMWH9TP?=
 =?us-ascii?Q?rXl6IauVpu1xEBYGkWouDsIqgHhmxrbszYP56veD8rfX6wDzGnJ8t8LaD5EN?=
 =?us-ascii?Q?SXbphde+vDy7SHFwiaqdPAhlDU+cvmpo7EOCFSEXSaSMNEC/2eHH6YqMJRdG?=
 =?us-ascii?Q?vsgDn1m4qpT65w4vNMC8S+caPgOA75rWijWl9lKIUphc2H75NLuNT8MmV4Sx?=
 =?us-ascii?Q?pXSmnq1LsRxZu2EXlqZOvVI1ifZJc0m2GAoEDmvKZHw9aTcGmmIvHFAX/LS3?=
 =?us-ascii?Q?aeJyAcFy0LKyz/al7M6Wlq3QpbFrQKpIHO7clBpviKj9Eu7BhKRR7NfeSkaT?=
 =?us-ascii?Q?c20dHahJBW/z0C18M3UmfVBEUxdGMLkRD8B9RUaMF5DH1KvHBQ+jqx9T/I2W?=
 =?us-ascii?Q?Jbzk0DKwtUFVY+PHQ/w0yFmIDOB3eqPW6mKXypkM2m3S1HnIJknQVrHSWT+S?=
 =?us-ascii?Q?OumPvMe/T2p++xFQrMpsiyHi7ordyTGUjkIG1BvMkTcgmgY50on/dG8u34rH?=
 =?us-ascii?Q?RxcKHZkO6CeQSrcXoPfahz6B/QaGlexM/z4qOQd2GsWhffA0rV0gzKaMpdDW?=
 =?us-ascii?Q?KnKBehE7/nMa+XF1syI7/kfXpeFT2bpOu9R5rHV1yRc4qqAkdR35O8rclDnx?=
 =?us-ascii?Q?Qios19lhy4+/JC+gZ7fxWZlQhzspkvRFdVjBZVYP+09pYTL1/luJbmUABNhm?=
 =?us-ascii?Q?zMYclKSZnIaaMskqo8X0BTi5P55zkJwQ8ibNzi9h3WbhnYMzj7CpmIaj7HXr?=
 =?us-ascii?Q?e1e/CqGyuu0DrJxTrC9EmqzdFySWVaDG+LDNS+xW7vgXrjykVX0tqzs9Uc3c?=
 =?us-ascii?Q?hqRumoqE/18MffXYm1z31DVYSsJdTTzOTgVBSqRr3ptU9HFmno1EIdaLaEUp?=
 =?us-ascii?Q?h4AjxGyCSHFXo/9sp6iBS34gC8+t6e54fJi6oVYjlXdbRf1BmH/dHbbtmJQ1?=
 =?us-ascii?Q?3f7a6h47FOD56uUDCu9k5alT9ZVSO7hfjqlGvFI1YKrlJlHp2+7YUTKhjN4J?=
 =?us-ascii?Q?rPrS6t7UzgJNLou2NEEqXbj/fzT2Aro1CYj/IyUAAmnaaCrGbXuOvxRFMPk1?=
 =?us-ascii?Q?pm8suc/x+Bh3sLqwhB3l/fWNCi9YL9liOOl5JyBTmoNazQ4UpSVMHTdnHkcd?=
 =?us-ascii?Q?7FdVLz6YhDalvP8pQfodAiiVkpHAXd+SqQuYd6N+R5dNPvKQ3BBBCiS+9Ebi?=
 =?us-ascii?Q?nwoYBOzgbD+7EL8PIw38LO+M7+Cym3KfMbebl6MC2vM3eV1HipuiA24lLzsN?=
 =?us-ascii?Q?K5VwknzqbVTCpElylOeL2NrAtT31ZBXi+YlQ3a3duErPUULjqN5ki8a/4wbI?=
 =?us-ascii?Q?rFInOQYW4z7Ygt/k2NvOLpotxNykv1e7PKsSr3RaEuEP9pzJrLkkZ95b6l2g?=
 =?us-ascii?Q?zeINq8cJX96xrH3QNNqoh3qVP9t/MQ/KzH3a5NRWPiNaOtZ1HksScrS65V1k?=
 =?us-ascii?Q?qwTDaWMoWB+ReuJBgf3nt0UDP2cJsE/zAApjEnQc9KHzOnC7CSZ90JNwMqTr?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c4cf47-b48b-4c89-d530-08dad7fa36cd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 02:24:49.0413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9rY8vhgcA8DgHVmEEh19EQzN4Iz5RWvDUjaqXAN8J08aJafNhXmhwiJOK/ZjCid3h+V07itSxiZnSyIkyHevmauaaJcSV00wRE5xZu69zwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5930
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:18:51PM +0200, Vladimir Oltean wrote:
> On Fri, Dec 02, 2022 at 12:45:53PM -0800, Colin Foster wrote:
> > DSA switches can fall into one of two categories: switches where all ports
> > follow standard '(ethernet-)?port' properties, and switches that have
> > additional properties for the ports.
> > 
> > The scenario where DSA ports are all standardized can be handled by
> > swtiches with a reference to the new 'dsa.yaml#/$defs/ethernet-ports'.
> > 
> > The scenario where DSA ports require additional properties can reference
> > '$dsa.yaml#' directly. This will allow switches to reference these standard
> > defitions of the DSA switch, but add additional properties under the port
> > nodes.
> > ---
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > index b9d48e357e77..b9e366e46aed 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > @@ -19,9 +19,6 @@ description:
> >  select: false
> >  
> >  properties:
> > -  $nodename:
> > -    pattern: "^(ethernet-)?switch(@.*)?$"
> > -
> 
> Does this deletion belong to this patch or to "dt-bindings: net: add
> generic ethernet-switch"?

Good catch. I'll move it.

> 
> >    dsa,member:
> >      minItems: 2
> >      maxItems: 2
> > @@ -58,4 +55,26 @@ oneOf:
> >  
> >  additionalProperties: true
