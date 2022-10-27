Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDC460EEA8
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbiJ0Dff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiJ0DfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:35:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2128.outbound.protection.outlook.com [40.107.220.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5263A17D;
        Wed, 26 Oct 2022 20:35:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEdAMOFGwFzlxrkHMpu/bYf6y4xdHuj6keXliS6Q9rFfgG6PrEFCGTW6WMPv/2eu7sU+GolmiWSGTCVGwb5SmgzhLZ0rZbbctx/qo1d9sF5FlgBzqxQ/AYH1q1WhtS8A273nb2MNVKpyFjUsrbTOTl1AkapbYhEJ0qGN8l0nmTwBpzpC5thZAJvi3jve1hKQiTGgC0r6ydUSPK1ppHSlORuf6d8kujJ1AK9RX8Mu080vgC5bF6gUd75Ma3m+oHXS1hr9BkFEU4HgqKN3P0TAB5BbL5Gz5kYib3cEyf8gL/a2H9lQJQSjBF/kgC6IXhQnR6Y92RgF2C++uwxF47kPwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GTds9C6e5cCENoJsHytULZHPx24ibEL/tkFzO+RPnQ=;
 b=h/Nl1m7eqtG6mZbC3IEp/9yLd3gAPIAqeP2DMn03sDlIxHK2TSR3OaqkxL9ILwVEyiYzjjTHOKZsm3CXWfBSfJqj6zUnilqyYjVe8mc7m08QL1i24FMDqAdcvnjE4YzNtGFXIVAa7ZzMEl4L6Cfqb/dvhs3DfbIXAUqIfuUrHUMYQ38h9vrL50LDOg3vVuG1m/P2iSD94A9vgIZx8eZcKWURZZCRQtvJEh/0VWVZdDiPCMDdRHcz0UxDPfqoIoBrEMQIfvoRSWyUGqxOpdaWVwLN7JO9HLvvIMarM+dudKwMTyKD/+ajZqrbqjnBhqcyUauq1hDFi/DS9gD9wh4QQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GTds9C6e5cCENoJsHytULZHPx24ibEL/tkFzO+RPnQ=;
 b=mCFkS4fQqx9zPcNh9ckH6K8NgeZDrgt1t991YpTvRxc9s0668j6oOYx/qJeV4Hi03PHLD+UzleeOlgSfmqpTNZXSxgaKIb6p+8lofTneK352o+OgaNvnoUE8jtbXZEYMNTHOuUyjSMfHmqtQP+5QqaG0nyC+/ZBKWMCAvrlIA2c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN0PR10MB5911.namprd10.prod.outlook.com
 (2603:10b6:208:3cd::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 03:35:17 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492%5]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 03:35:17 +0000
Date:   Wed, 26 Oct 2022 20:35:12 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh@kernel.org>, linux-mediatek@lists.infradead.org,
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
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v1 net-next 3/7] dt-bindings: net: dsa: qca8k: utilize
 shared dsa.yaml
Message-ID: <Y1n8cH0hkL4YjU1D@euler>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-4-colin.foster@in-advantage.com>
 <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-4-colin.foster@in-advantage.com>
 <20221025212114.GA3322299-robh@kernel.org>
 <20221025212114.GA3322299-robh@kernel.org>
 <20221027012553.zb3zjwmw3x6kw566@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027012553.zb3zjwmw3x6kw566@skbuf>
X-ClientProxiedBy: SJ0PR13CA0072.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::17) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|MN0PR10MB5911:EE_
X-MS-Office365-Filtering-Correlation-Id: d58ed33e-7714-49a9-3bfd-08dab7cc4381
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yfIFHeV49ERNPldbS5KW/hBHDur7jOpULDQYje8OXK1WEqz3OqN59CQIHsvZwvD3IcPGOrpBUGtxXjFkazfM23R7avbs3J06OCs3SoZalSLXI8JFKAnopzKvsLq2QBBz3ILtb8yAMY2f4wDCc4InuR7X6vURm3ISfuze1a4vEAoZWPORlEKiFV4PN6D9OfxYZWBW3U/bMCIYXJ2AN6BVCGaH86lEVaD5FkgnCO/44mR3/OmXSF4kyluOM59t47DW6FIefZUNw+nMlr8hSfLCjDUDrtwW5QKfyzFjONS/svSa4oSOZEQ5sIBtNMxk4IqbcAdCgFsftp80dNGca1wcOWtxvk0bGcEF0dXi1xSQ8+hrIqblq7ktdpk57FN7PTvFRNSogbzM8a0wS5xWnbwbjPqnWq6b2bxcUVrnMdBJaDqSmZYcLzOg4kUEXLprd9EwPGMto+cYxXXOV2D7pvMaxoAUbTh8FUNA7/HTSDq4aPqddhE1JrlM6/Vpi1LPHifGPbhkP2tbMaTYgxD4I0fqXnh/ifB4voNXsZrvCrl4QwB81twfDbIUTs1uSRMbaYaZw0Wkt2wqokcIDugUIXcHtX/OobIVVLoQd61NUzlHTIpR7lSWihfHCLICbI2lilVgI1OreeehTm1WSuQ/wIVyzyUWdI66NMJAc1baiW9AkXfiYIiQyScSOCAIUjzHopfZgNaHy59FUEW92L9+OfxGkxMt6e5Hv5kKIZwDsWaHlnwnzDzORr9chQ6Y+/aZ3MwuBg2PKKRFOTFpkm8raHPb5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(136003)(39840400004)(396003)(366004)(346002)(451199015)(6486002)(6506007)(4326008)(316002)(86362001)(66476007)(66946007)(66556008)(8676002)(478600001)(54906003)(6916009)(6666004)(8936002)(6512007)(7416002)(83380400001)(9686003)(38100700002)(5660300002)(26005)(41300700001)(2906002)(33716001)(44832011)(186003)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yuq+gMcw/03LIOBZutkCY2KJME2dsM0sJ5d2H0lIQTeTjA5cgk6DPdz5yUhC?=
 =?us-ascii?Q?6sWu/N3md0DQil50KYsT8AnJQgw0u/es3YymTB+qEb6EI3eblIu/w8ACC27L?=
 =?us-ascii?Q?CRRj1lgTsEoCDwzJ+KiTtwdKNgRbliBym0heWyfO8seZR2ZIQcun2grzfsua?=
 =?us-ascii?Q?yAr58RhbafhmYBrMOIoRF0puuNLwbnlpr3RY3+yYSFTgj+pV1IxlxUFn6Fil?=
 =?us-ascii?Q?KZAFxykqUKeqvHBopP2Y1y+TFtK0DlmqAPDgFN/C99hT6sGB50gwaBhwncsP?=
 =?us-ascii?Q?CchuJ/BWiaFXq27cDXj5/Jp+o8y3RIaOmPA94wHgYjC+Dq6FdyelgZ2lMKiK?=
 =?us-ascii?Q?ym/tM6ziah2Jj4vuXjsVPmNkiHB23ONlq9erjhHxeV9xr0SeSNT81i2QN6jk?=
 =?us-ascii?Q?1A+nHRsRIZZnLN/LT6P36L3OOzBxU5UEXeuv3vxfNDdTdFdCAvDWcUGU4JWq?=
 =?us-ascii?Q?bRzrqNFSjlTTBuM7Pa6UDZtFW/9CwAogsbeyknCBW3+lrCGbW/5yMmmVNGQj?=
 =?us-ascii?Q?oxIOoUaFMvI0mKK1/8+YneBkWv3Otw+306pUpcOKiOLLoa7yk80+A+sYZU7D?=
 =?us-ascii?Q?SjueydUdbg1ErAsgaKAN3DrLtGhawnXHXtT4T8TZ3pgVprKIqmE6rOGuA+tG?=
 =?us-ascii?Q?wWZ362cgfUel+Nb9mQM8f/6gCpiwMIIZb2APZzdVsRepcJBM5pAZbIySAEyb?=
 =?us-ascii?Q?0RBSksY0JM7lCSEWIjKWQ5ZRqMA7SdejAOs05U5sttVu0x37jUvcpFGvyGzA?=
 =?us-ascii?Q?399A6moRxCvyCNv0PRSrI3X+USSUFnBastkyg83MGhbp+H2voj9/Vipux+Pu?=
 =?us-ascii?Q?czDB2Se26E4DckWX0asJgz297q3Dr16qBpxVryxPOW3LcRwQ1JdPZ/ExpAGr?=
 =?us-ascii?Q?lUKWYdK37PJKjDEWW+R7QyO+j+I9Of8wVu8B/1P/REu1e/hQ9DDvMr2+5Ex1?=
 =?us-ascii?Q?zUxJqbdCVl+J2mB7RM/d0DF5eA8u5PC06aGFmGE50CHp6hWKxlmGW0JzJTbS?=
 =?us-ascii?Q?EE+r847LhFHS2tqyVUOLQTcFuX7RGozYJqeAdnJOsm3SEwLfZz7tqiCP1vU4?=
 =?us-ascii?Q?khCHePVpT3atrp6hQVxzW3ExcYkJhz6MuQdcseXNyxuWLFWs1Xzbp3r4PVuL?=
 =?us-ascii?Q?4Ogw7u04lq32LDEo179FYgBAfOWwcGwvpE6HTrI68VbX+zNzvMkSO0eigN1C?=
 =?us-ascii?Q?T+c1l8wAfkCcUAs1pFPqqouHbnrw0QpVKTCuIvoU0rxpyxZkHDxA9edFpeQw?=
 =?us-ascii?Q?u5WnMAabSgpYZFF52WcL2GTHzh+wMz1qrIgjsjGb8xKA5hhvDvNJtmGO6ute?=
 =?us-ascii?Q?jh/j/o3MHHlW0K6yinERW486oRLVmKn7xcCmlAj3M5MYUlRRkfGf3nwt1CSS?=
 =?us-ascii?Q?asL+pd4x8nKL27KX57uUH/9F0O3PhpvqBZnoeAisNo3Niy3M/RAoY9xn8CcX?=
 =?us-ascii?Q?H0m2twcnD9shrPhldzfvRBJMOnXXBCDLAvt5W/9/3EgTogg0w5im+gzhX2Fh?=
 =?us-ascii?Q?rJQpXO+gE/a0sWIMb4tGVHfwLazSAEMJ1ep/AYKePWIN1da0RouZA53ik9R5?=
 =?us-ascii?Q?NvEEmWj463sJzsxkZfmjkQ/q3Lt2WOBMMSCrUOCovfWIZkFUPrAMI1vAmyy2?=
 =?us-ascii?Q?LMPLiBohRgsPhknwuJjjFi0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d58ed33e-7714-49a9-3bfd-08dab7cc4381
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 03:35:17.0100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hziwh+I9yWwFiyWzFnJopqL8scflmmwGu73ETuJxz45bFVvIZ9oFWknLzBphCiz3p7KLTpjl+QpOS9FSIoOW3ZgSI81S/Gh90BPBEz3btW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5911
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob and Vladimir,

On Thu, Oct 27, 2022 at 04:25:53AM +0300, Vladimir Oltean wrote:
> Hi Rob,
> 
> On Tue, Oct 25, 2022 at 04:21:14PM -0500, Rob Herring wrote:
> > On Mon, Oct 24, 2022 at 10:03:51PM -0700, Colin Foster wrote:
> > > The dsa.yaml binding contains duplicated bindings for address and size
> > > cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> > > this information, remove the reference to dsa-port.yaml and include the
> > > full reference to dsa.yaml.
> > 
> > I don't think this works without further restructuring. Essentially, 
> > 'unevaluatedProperties' on works on a single level. So every level has 
> > to define all properties at that level either directly in 
> > properties/patternProperties or within a $ref.
> > 
> > See how graph.yaml is structured and referenced for an example how this 
> > has to work.
> > 
> > > @@ -104,8 +98,6 @@ patternProperties:
> > >                SGMII on the QCA8337, it is advised to set this unless a communication
> > >                issue is observed.
> > >  
> > > -        unevaluatedProperties: false
> > > -
> > 
> > Dropping this means any undefined properties in port nodes won't be an 
> > error. Once I fix all the issues related to these missing, there will be 
> > a meta-schema checking for this (this could be one I fixed already).
> 
> I may be misreading, but here, "unevaluatedProperties: false" from dsa.yaml
> (under patternProperties: "^(ethernet-)?port@[0-9]+$":) is on the same
> level as the "unevaluatedProperties: false" that Colin is deleting.
> 
> In fact, I believe that it is precisely due to the "unevaluatedProperties: false"
> from dsa.yaml that this is causing a failure now:
> 
> net/dsa/qca8k.example.dtb: switch@10: ports:port@6: Unevaluated properties are not allowed ('qca,sgmii-rxclk-falling-edge' was unexpected)
> 
> Could you please explain why is the 'qca,sgmii-rxclk-falling-edge'
> property not evaluated from the perspective of dsa.yaml in the example?
> It's a head scratcher to me.
> 
> May it have something to do with the fact that Colin's addition:
> 
> $ref: "dsa.yaml#"
> 
> is not expressed as:
> 
> allOf:
>   - $ref: "dsa.yaml#"
> 
> ?

Looking into documentation (I promise I did some reading / research to
try to get a stronger understanding of the documentation yaml) I came
across the history of ethernet-controller.yaml which suggests to me that
the pattern:

allOf:
  - $ref: 

is frowned upon
commit 3d21a4609335: ("dt-bindings: Remove cases of 'allOf' containing a
'$ref'")

I do have a knack for misinterpreting data, but I read that as:
allOf:
  - $ref:
shouldn't be used unless there's more than one list entry.


All that aside, I did upgrade from 2022.5 to 2022.9 just now and do see
these dtschema errors now. I'll be sure to use this before resubmitting.


> 
> If yes, can you explain exactly what is the difference with respect to
> unevaluatedProperties?
> 
> > >  oneOf:
> > >    - required:
> > >        - ports
> > > @@ -116,7 +108,7 @@ required:
> > >    - compatible
> > >    - reg
> > >  
> > > -additionalProperties: true
> > 
> > This should certainly be changed though. We should only have 'true' for 
> > incomplete collections of properties. IOW, for common bindings.

That makes a lot of sense - and helps me understand why I had so much
trouble understanding why it originally was "additionalProperties: true"


I'll obviously take another look at this. The nxp,sja1105.yaml seemed to
be most akin to what the qca8k.yaml needed to be - that is "take
dsa.yaml and add a couple extra properties to the ports nodes". But
there's always subleties.


> > 
> > > +unevaluatedProperties: false
