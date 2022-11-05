Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B342561DD27
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 19:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiKESRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 14:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiKESRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 14:17:37 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2098.outbound.protection.outlook.com [40.107.92.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ABCDF7E;
        Sat,  5 Nov 2022 11:17:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgBD7s+ZnaXvhNAlqc4mVGusLb/gMpASS3psjJP1pbupT6A7zZ59JTPiYR0j/wDR3/NBWYUV94iIIXEtUazWbFWktMITHnYKT7Cmg9AkszEwZWQNRWsa8W3IS4eBt6Q7QjtaQs20PSGGGlWQ9kgd92a7ZNQSpPBfBV0tfuuYrtMe3fFdKnwr9YUGTqUgEtxni3hjqQTaZ7AuJVTDe2bv5QnHSPcJX7/qwKyiFO/bobhdneNYbDHVbYnN/31CQfcp20+bTmzIIlSNQUcWhzUMj0syAJ0pjJ4w/2ouqf6O6LqlF0EUwFx/QjQBh6qPsXnNlziXpZ/U+bRvlNN+nyfJvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/ECord+SifV3PIetO4yQ5wLgG/AQqEiLIj3Vn+wRkY=;
 b=GWqk4LazEvhdGFDRy85NzMSzBokjvZXc7VfxiGIoaaypyfonwrvGqw+Z/wiqGJW0AOr4sMLmavoA10tkMz+S0G+9eAhV0zbhJSjhB2U27gRLdiWpCLPBXKwV1oJegVSdbkA3JtEro1TFtnJDRQLk15tA/LSQYgLMI+NJtQdUfNCbh/bCL+zKonjtqRPyS7gWCgfLwWfXltugeSEfRFEKHim0rpfiYW4tVEsgX1XcERXeNYMiB4pZ5QrrSKPZiB/xQlbWqIJfRxQQBkBzicPOlYroB2dWWB3Qj3V50BhR9k9s8TK9+xZIz660WbGc1FLUOfa2dt84/CpmJAxs2upjpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/ECord+SifV3PIetO4yQ5wLgG/AQqEiLIj3Vn+wRkY=;
 b=S5yp82Bw4WP0m9hJeHZJ7uqgLLmQRoZRfZVFOJiQ4Gx/LiNtilfEZ5Zry44TUC4FnBnPBjR4nhi+d3eQZ/kUsLDqRulvx0bRYLUh+uV461fVaR4douu4qPppQhjaA33gCULaba9TCKgstGDfO9pN6omBxbuMSFZ4K2xKP+MH2xA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4856.namprd10.prod.outlook.com
 (2603:10b6:408:12b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sat, 5 Nov
 2022 18:17:32 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4780:1359:e037:1626]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4780:1359:e037:1626%4]) with mapi id 15.20.5791.022; Sat, 5 Nov 2022
 18:17:32 +0000
Date:   Sat, 5 Nov 2022 11:17:28 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH v2 net-next 3/6] dt-bindings: net: dsa: mediatek,mt7530:
 remove unnecessary dsa-port reference
Message-ID: <Y2aouEapTNroLcVe@euler>
References: <20221104045204.746124-1-colin.foster@in-advantage.com>
 <20221104045204.746124-4-colin.foster@in-advantage.com>
 <20221104185343.GC2133300-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221104185343.GC2133300-robh@kernel.org>
X-ClientProxiedBy: MW4PR04CA0380.namprd04.prod.outlook.com
 (2603:10b6:303:81::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB4856:EE_
X-MS-Office365-Filtering-Correlation-Id: e71bcde8-fde6-4971-42b1-08dabf5a0138
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jocsqITJaSyhZz/9Sp2wLhJG4FP++guVYgpwtpJbq2FAIMWT3IruoiJs4ZU5L0qtl31qYiZ7NBoD1Uj83tWrc8peH5lLPF0BmxF3fy+mZiKjqPTpP83BuePEwprwQEFhcrSmdXnz7Z3tp24ytVCkhIq2sh6SpMrbyYzCc7uuo95zQ+roKsi7jsPwWKyKFtQcMIBF61tivkYhOivh4Xdnzr1J95x1n82t0SWFDinNPrSMFTEUER8iYtjrbii/HiyZSNfQswZ3uEVgqN0+oGWVJkmQpzYlHIKlQUEUrc7LzqEWkAw0//sO08OZwgow7zNimEenZFlCL5aeWoOs78arKNK8Mgi4+hidtlMHgrqtdFl1mN3OuAG9PKs5pfmepSB4KfhPbdw1rH/xjgfoHE3mRBAqpPagMWUn6/vP264Kh/d0bC2fMGKNzqeJ8/HF+oCoXNG8zFPNAE3E9QPH2HP46irAl4eNye/IVMN6zDBl7HwrIsRsRfl48lbV/xO6N92pU5mXG+VwU+y1KSHokCLg/txZhT8bLhKvvJkPYVn3MvStfC6ATDxfC6rbdvMH3HXZO5Cf3TjEK+iAQM+YiNznOXDjk/MRkV/GRAv00t4iW6BPmxMjjKKsHeuEJnEfn/quczs8isW35UcbP/7rxmOARMADXw91iVGTPPFdshpA1IICvumaXB8NzhJIq9O6I0rvX0GfmJTJ2X+14alRrP8boQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39830400003)(136003)(346002)(376002)(366004)(396003)(451199015)(478600001)(6486002)(44832011)(8936002)(7416002)(5660300002)(2906002)(316002)(6916009)(54906003)(41300700001)(4326008)(8676002)(66476007)(66556008)(66946007)(83380400001)(38100700002)(6506007)(6666004)(86362001)(186003)(9686003)(6512007)(26005)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzFnMWdLdjZTWjJvV1UwR2xXRzJLeS95aXArdCtkTTBDaEtXZDRFblRHN2hn?=
 =?utf-8?B?WTRkeXNHejdrWlhvQUN3ZndYQldpbFNxMEovMHJ3OUdyWjJrUGI3c3hyN2Jj?=
 =?utf-8?B?eWkrQm0xUXZvT28xeE5XUC96ZkNpck9SZ3pBY3NSOGkwRTYvMEoydUpPRFly?=
 =?utf-8?B?azZIMzVzVytNZ3VKVU5zU2pIbVVHZjB6b3FvVjJkQzA4UVV3cU1tK0Qwb2VU?=
 =?utf-8?B?RmdkejVSQjN2KzNKWnlGaElLd21QYUIzdWtwUWh1dDdvNkdIK2JiV3kzUUlt?=
 =?utf-8?B?dWNEWG5UNzVMMFl4RFRMalk5bE50dHYzQ1U1czFPTG1pTEhPVmhVc1Y3TFd6?=
 =?utf-8?B?UXJYMnpDUHdYNDM4RmM1cHRyS0tUb21JaGZHeEo0L2JpQzBSeklHRThJeG9H?=
 =?utf-8?B?eFM4UENGUWllT2ZFQk5la0F5TGlCMGNtcUNPbDlKT1dWS3paUWJ6L0QwTW1z?=
 =?utf-8?B?N1ZBNVdzMEJXVkhBSW5zSkNjby9NSEIyZkRIMnpyZnNSeHRKY1pDU2U4b0ZS?=
 =?utf-8?B?NEpyVDEwZEZtc2Zaay9MZnl2WHZFQU5MejA1N1NoejhRblFJVVE5b0FISW0y?=
 =?utf-8?B?UnJzOEZOMk9hTVN5WWVGSUo2WlBTVEhUc2RoUk1DWEkrRkF3K2VuZ1c4bGtY?=
 =?utf-8?B?UklrMFVzY1crSCtyUkF3YlI5dkVMZFZCZkRiQmcrbWU4UmhSM1p0bk5yaUIw?=
 =?utf-8?B?VzBhd0puamVDMkhZSXl4c0RoYUIzSUJBTUNGWDZpZjNHRjh6WXR5eStUaFZ2?=
 =?utf-8?B?bEI1c2FsVlNNb0lCMzltY3RnTFBUV085Uyt4NTV6RG5hU2Zma3FMQmVhSlpo?=
 =?utf-8?B?NEJ4bDV4QWR4bDBaYU02QVZMNnBqSFZyQVd2TzJOLzdxeUtsRmhyU091NEg0?=
 =?utf-8?B?Z2ZaRkFSek01VXBIbXN6ajViL05PUWROTUxuY2o2N2lEelRLRHRXT0Y4NXI3?=
 =?utf-8?B?UWJBSG93ZWczTUZYamxlZitjY2RTZHoyeEszaElWc2pPM3pLSFFLdUxUWjhK?=
 =?utf-8?B?WnhkZGlRY1VyZ2ZiMVlsR3hTWGwzWEZ4NXgwbU9Yek5GS2oyREhWeHZEejRR?=
 =?utf-8?B?MGlTRkw5Q0RQbmVUaDcrcC9QTm90NFovMHFOZWUxenFSQnMxT2ZucUhkaG9u?=
 =?utf-8?B?MEpCOWFoOXZYcUlXNVFWdkN5T0FmNzFRUGsxcXJ3SjRrbGxYSnVjMTNnSDFF?=
 =?utf-8?B?cjdkRkNVaG5oN1J6S2xzcld4am1qcW0zUFlpMUhhYnZobWRWLytVeFdRamFF?=
 =?utf-8?B?Wk5kRmE5bWUyLzYvcE9ialh6Wm1NUk5Sc29BUzB6QklUd2IzNlNKK0dvR0VT?=
 =?utf-8?B?dlpXajBDUjdUUFQrYVA0MDZvZjk1N2VYSFpBRlVOZURqQ01wYzNVY3FNZnY5?=
 =?utf-8?B?OENMZml4cXc0K3pPM1JwYVQ0N3A3RVE3d0M3dW1abDM0RUlzeEwrWG9GVTdh?=
 =?utf-8?B?TVFuSHhYcjVpVFh3MDBFcnBCR2pJRG8yNldaakJqeEFLc21UTHJxa3g3WlFF?=
 =?utf-8?B?UTk4bFVmZXVpdjcvVVdwZ2VwdElMdERuRXNuYUZHQ2xxaFNhZEkwNmwwSllj?=
 =?utf-8?B?Ymhma0pjenpOOXdKajAxUGVwSi9oay9TRGRDMmVPYjhLZVRwWWlLdXhCS3dY?=
 =?utf-8?B?L09jT1NXcHh1MWVWYUg3bHBDZkRjc3REa3R3Vm8vNjZKSXNBUlR0Ums1Y0pG?=
 =?utf-8?B?Sk1yVm5DbVppNVJZdUM4Mnd1TXVhY3Z4RE9lbmtrbDZLb3NRTkI1MzJwY2ZE?=
 =?utf-8?B?Vm9GMzU2T0l2dktleWZxYWdTeGs2ZDlDcVJDOFQ5KzN0Mjg2Z1FWZkdnRk1m?=
 =?utf-8?B?NU4rN1F5d2ZKb0pUMjdOWHpIQUg1M0VNemxqbS9sNXZBaHNqdVB3empBMVY1?=
 =?utf-8?B?dFdjb1NYS1BENk9ibTE4eDN5a1NrNkRKSjk4VUxtajVEV1BwRHVwa3NHMVBl?=
 =?utf-8?B?Vm1XOFM0M0lnREtaVFR1YkJ1cEcrWGVVcWQwaWYxWTVpaWp4RHRSVGEzenhE?=
 =?utf-8?B?T2N5S2lsR2dRVGlTcW5EVGkrMmJxTCs3bG9DYmNzRmwxV2ttVi9xcFJwU2pv?=
 =?utf-8?B?Vm9xQmtZZWJScFpLNm5zZDdEMzRsWmhyRDdlRXp5MVVnTjR0b0gwaFd6ZFEv?=
 =?utf-8?B?QVBMTUlVQkRtOS9QUnVhakN3a04yUHRGK3FUS3lKNXlhdnJneDhPNUZZVTJi?=
 =?utf-8?B?cFE9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e71bcde8-fde6-4971-42b1-08dabf5a0138
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2022 18:17:31.7584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/VcBpmXbdeXZJw+Q0ZxEUqCeQ7i/DzHUO0lLbTSGHIVRRvZX3xdQa4T4jZ2XT9G/+9dsm6LABvUMqjIePU0hGZGg97xP4q6FpKAc1AQbBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4856
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Fri, Nov 04, 2022 at 01:53:43PM -0500, Rob Herring wrote:
> On Thu, Nov 03, 2022 at 09:52:01PM -0700, Colin Foster wrote:
> > dsa.yaml contains a reference to dsa-port.yaml, so a duplicate reference to
> > the binding isn't necessary. Remove this unnecessary reference.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> > Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > ---
> > 
> > v1 -> v2
> >   * Add Reviewed-by
> > 
> > ---
> >  Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > index f2e9ff3f580b..81f291105660 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > @@ -159,8 +159,6 @@ patternProperties:
> >          type: object
> >          description: Ethernet switch ports
> >  
> > -        unevaluatedProperties: false
> > -
> 
> You just allowed this node to have any property.

I appreciate your time and help. Thank you. In this case, I think I need
"unevaluatedProperties: true" so that the ^(ethernet-)?port node can
get the properties it needs from nodes in dsa... ?

But then I'm not sure how this node worked in the first place. I might
have misunderstood, but I thought you suggested that if this node had
unevaluatedProperties: false, it wouldn't be able to look into dsa-port.

On the other hand, you did include a lot more information in your
response to 0/6 of this set, which I have yet to fully absorb.

> 
> >          properties:
> >            reg:
> >              description:
> > @@ -168,7 +166,6 @@ patternProperties:
> >                for user ports.
> >  
> >          allOf:
> > -          - $ref: dsa-port.yaml#
> >            - if:
> >                required: [ ethernet ]
> >              then:
> > -- 
> > 2.25.1
> > 
> > 
