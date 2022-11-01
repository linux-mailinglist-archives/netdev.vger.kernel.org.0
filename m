Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4246143C4
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 04:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiKADsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 23:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiKADsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 23:48:02 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2101.outbound.protection.outlook.com [40.107.93.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6712117599;
        Mon, 31 Oct 2022 20:48:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YS1StcYLPnNgWF7PZw1rphWNZ9+6aMMiGk8J30yM6Ctk+014/KiBZMJbPMuROZB4DwFJgplavVf8H7laJEJat+Yhr9EB8kipc7fr6utEk3hHnYTk7XrNS8qzEvcFZvwzBTgH0DsX8dn8zLUqm/gmM1HnisernWf9KLshsgA+QrSOS227ov+Fi+w9RZLpiFFukqUlxeBJ4IB1FbgAeRBsBBCZIQ51sPgVMKi1kb5YrScQ/y6THqYl3+2ctpgi0u6o6e3VZtd6Z/Uoutto1Eq+N4JSr/1IYrMeGznXqDBmz8bEhYryknSoSdAqMJlSHJ355Z6ZHaUcDRIvgUxBmBWuUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGaqW5LiW4wBrceSqKiBy6n5WDYhxBsQwEnx3GYwn1k=;
 b=HhxJnV1b4Lxg+DpCU8MdXOH4zRI2HayN+C6cGrVRWtoBi+w6COe2djddjLglNgsUVan9c6NQdGazF0f2z2ip/CHF6Zg04QQMZLQhuB+0AJ/fZKSxO82Haz+kYY1v5pGBMhXqqk6TEKt37oZqsjLW+G909uDJDUDo7AOQ95QuQxoO/FD3FmgGgxls4Hn4iyysyTUs8nqcY9hKnkJAj+QnoVnztk1YxPHqkjkVDr/6an4m+cwbfuDrHVv7WCr56/cJCDV270Z+3tr8aoD8xomLrqkezZy951oILkW8XkEdZaYZ7jvbE2dWEGpuMzI2VqxXvToOCdDJSZ/Z+neRcjbRew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGaqW5LiW4wBrceSqKiBy6n5WDYhxBsQwEnx3GYwn1k=;
 b=y5cvpBSzb12Wr1KNGM9luS6wLoWFSMuRWVyVgleejiSLbGDHlIS+eH3fiPuuPaxnY0os24GrVh1yNZ1L2WkcCJMWrkQ7P5zomNfs3P25eJy/VfqEH5nkd8Qa/QytpO/tKZ7RZ+bJPs4dpea8MCdhZWrezOaJzFch4lS/qvHKgOM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Tue, 1 Nov
 2022 03:47:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36%4]) with mapi id 15.20.5769.016; Tue, 1 Nov 2022
 03:47:57 +0000
Date:   Mon, 31 Oct 2022 20:47:43 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        linux-mediatek@lists.infradead.org,
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
Message-ID: <Y2CW3/V4/iiMh+Sq@COLIN-DESKTOP1.localdomain>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-4-colin.foster@in-advantage.com>
 <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-4-colin.foster@in-advantage.com>
 <20221025212114.GA3322299-robh@kernel.org>
 <20221025212114.GA3322299-robh@kernel.org>
 <20221027012553.zb3zjwmw3x6kw566@skbuf>
 <20221031154409.GA2861119-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031154409.GA2861119-robh@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0214.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4553:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d8d954-b698-4e12-ffd7-08dabbbbdd5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XY40nut9fhqgP7WkvuJh5/Cd/NgET5adxxPkXr3l/ZoCd9v8Kqq5cej4EKrxUEMUMhlftyHZqQWQwysV1VfW11t2uYyZS/sxucDuajBzyzuRLD1tkJ5dZ57rF5ug0j4+fV4hQQ+cHJPFUTImbj41N5IM1rOcBcfsNx3G+Sn8ZO31DY7opMStQv9GlK/6QsVCax+YTDnl9nthSv5Q9juAe/zpHwBlhuMj7QSQ6op7HTovzeCvbiyzzgB+bV00Siv08jlLg2bSTQtvP3C+UB7NFPzZ8F3ghhBaK0oRaaCd2jbKg/F5P1QCHw9XCnrJq04KdQctoEmkf6vsao9Mp4+yR9zNk3oBKXlqMpejEGOXunomePdWTA527AhORZvUDTcLed4HWF4WT5Ud3mE5MILGGmRBq/xsTd8SmHGCWghLJIC8uByQ0y87JSdyClof0ZlBWckYUPHQm1U8JtuTxTW8IVqIlQiA6A1kcPsTsLkps4oi8tRNaFNBJk3e7ZBm3nvw9/94VZYEI3OhwU/pJEtuif92Esh6XyEz0Mioy80IG5obyHJNQxxfx28vRHMGURpyMXdCkCPl/C7zt+kksnSqkz1I9mA6UX07AirR810udI8VyjpHLzColWYK+FGzVF/a+ubGvdh3M44g3icgV4JDFb8XT0YF9vrDbFt/zH0I683viec6ATF/khx/9kYPi0R+8mNlDm6wNYdIAex9MvpRrxD5fQaNQStwt11VXzXXjLUn2Xd0yNmrfBnNYk0Eho4T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(39830400003)(136003)(346002)(451199015)(86362001)(38100700002)(6506007)(83380400001)(6486002)(2906002)(44832011)(9686003)(186003)(26005)(478600001)(6666004)(6512007)(41300700001)(6916009)(316002)(54906003)(66556008)(66946007)(5660300002)(8676002)(66476007)(4326008)(7416002)(8936002)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QEuWOprBnd+JllM+q+JdH3teRPRWQlcv2rZ9HKry6acnbL0+ZaCE+R3u/X29?=
 =?us-ascii?Q?7v+cjJyvYG8W3cK/NzmJZpVzU5BYeh+xPu+v0AE++G0tK/93xcuES+1grGVB?=
 =?us-ascii?Q?I7RgMzqrz84Yf7FV6Ds0sWiFIu7tdklvv4mCVx3rOgNMXRsqRPIj1mvHxNuD?=
 =?us-ascii?Q?tmUnjo6iKrrgs1stRbWRaNJ6ZZojSZgzOKq5GBXP6aMsbjzzfeOh3RccomIU?=
 =?us-ascii?Q?2jYBd6k/ykdrRiZfBn95A8gotohs6myeV68Qgb6+7Ok2xwP7/V01q4e2VhPA?=
 =?us-ascii?Q?B8x6fBfssttcyPGPRQpvKhfk3A0yeu+8sobNzgA+dtJFJdnJQhCJWgGXAK2x?=
 =?us-ascii?Q?BtFTwSNipDj8qtTJo4NDnCrvXve6NHAf9q6AlWiD0+hPiQzcaQ2HD/5CEWRw?=
 =?us-ascii?Q?Q4rCKkI9PJG8zARAF8ulCXgD5Os81+PTyt/qGYSA7gEbph4E3tpag30u5BDD?=
 =?us-ascii?Q?1LJRkSmjDDT8AkAkVKS2bsieMCaxk+S+TYt7DuHPq5TPvZRIEa1UfHg1OpYF?=
 =?us-ascii?Q?oV40GYiziKTCFwL5KlKPut7dXQ/dtHTys39G4MndYYH3fDjFM+U8cISKfhQx?=
 =?us-ascii?Q?s8bPH6/AllPSNml7n2oNijRA6Jga6p2ejB3SP18XbvRTBqGdgcV5sj2mmH7M?=
 =?us-ascii?Q?jnSd13a9VrRhRtu4j5W1VcCgVyrxWWBRmV7XQxuU4Z9ymq06zM0vOwgg+APQ?=
 =?us-ascii?Q?iomPEebND7TCpBpYZKbloO4+PYwN4Sco9AeBlL5xZkwKh424LcGOD86Xh0v/?=
 =?us-ascii?Q?7pOjJ499SfEYCugFWdVPD+ZYVFoYj6FQFP7IH0EzlR7MkDvxaifnlCIXUkFX?=
 =?us-ascii?Q?YADmXPD3gALdMi/3srJle1HUUo7PGsSU6qalfnrUXnl2XYqpywyPB94kQIfA?=
 =?us-ascii?Q?gS5w8AqgAE07x8GaRejfWp134O+6JjWENyxVFTXxhwwpV2CdD2DcdnSR7d+V?=
 =?us-ascii?Q?CqSP8zQ+WPfCqSdXZVdEZgqibiNbIlqw/4ZU+wCLHraT9uSz4dRb21A4lIJB?=
 =?us-ascii?Q?YAXdHYdZV0MuZLVXJjDOeRizlT9bmIkUTDBInp/kLYeTesT8IV+klnzAr3P0?=
 =?us-ascii?Q?XhrKqc2nom7OADFB4Ty5eflhBZZMnVzXITfRlNZHyywUy6B9lrFYX3kYO7Pv?=
 =?us-ascii?Q?4WDwIvrlZcfRxLsNUkGG0iLzJ7CF1kk8iHc9P/RTiuXJ9ymOJ52TBZNiWSE+?=
 =?us-ascii?Q?sDzbNS92bSq4Ro+pX5wF2LsMG5jCTJqnnRna4FpcULUz2Jlo2CuoNRSLWL4z?=
 =?us-ascii?Q?d9hQJd1DSG4l4V3g89RtM2UGfZhydz4NJ70tVxZh7F5EmvOMrM7rgiTIoVGd?=
 =?us-ascii?Q?zRI3tBc4V04S6W0i7XDDZZPYh8b8mi6VRMsYxz4mRJNZz5lh1vkU+XBTJ6Jt?=
 =?us-ascii?Q?5J9ITCrwQ/NdT9I7POl9Bc8lOp8Rxi0Hngm9/8wn+w0WBviA56S+TOPlbyp/?=
 =?us-ascii?Q?SEiGdCi2TOrFq0NHMqH+8dv703NHDFcEb4XMBU9P+UiZz02xBZ7zrwLEf0HJ?=
 =?us-ascii?Q?AVnyVatLzD10qHrWnp9xW3Gs1vJ5p45gNUaa4ZCdHy8lf47f7j9igltUsVrJ?=
 =?us-ascii?Q?1m67KtQyfK3DZkmT+bIAY2Kvusio+tCmwZWKOkZY33nL0w5c0o75pmu+YbYi?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d8d954-b698-4e12-ffd7-08dabbbbdd5d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 03:47:57.6518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ohmtbcg5euk0WCPNO3B1Rup7sFfYti1QttIfUxdWlWCfGA++7T9Jldbq+fM2GwsuMt7o/Q7lbYMlSA6lipaE3osWFrKfpATaNhz9sm8tqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 10:44:09AM -0500, Rob Herring wrote:
> On Thu, Oct 27, 2022 at 04:25:53AM +0300, Vladimir Oltean wrote:
> > Hi Rob,
> > 
> > On Tue, Oct 25, 2022 at 04:21:14PM -0500, Rob Herring wrote:
> > > On Mon, Oct 24, 2022 at 10:03:51PM -0700, Colin Foster wrote:
> > > > The dsa.yaml binding contains duplicated bindings for address and size
> > > > cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> > > > this information, remove the reference to dsa-port.yaml and include the
> > > > full reference to dsa.yaml.
> > > 
> > > I don't think this works without further restructuring. Essentially, 
> > > 'unevaluatedProperties' on works on a single level. So every level has 
> > > to define all properties at that level either directly in 
> > > properties/patternProperties or within a $ref.
> > > 
> > > See how graph.yaml is structured and referenced for an example how this 
> > > has to work.
> > > 
> > > > @@ -104,8 +98,6 @@ patternProperties:
> > > >                SGMII on the QCA8337, it is advised to set this unless a communication
> > > >                issue is observed.
> > > >  
> > > > -        unevaluatedProperties: false
> > > > -
> > > 
> > > Dropping this means any undefined properties in port nodes won't be an 
> > > error. Once I fix all the issues related to these missing, there will be 
> > > a meta-schema checking for this (this could be one I fixed already).
> > 
> > I may be misreading, but here, "unevaluatedProperties: false" from dsa.yaml
> > (under patternProperties: "^(ethernet-)?port@[0-9]+$":) is on the same
> > level as the "unevaluatedProperties: false" that Colin is deleting.
> > 
> > In fact, I believe that it is precisely due to the "unevaluatedProperties: false"
> > from dsa.yaml that this is causing a failure now:
> > 
> > net/dsa/qca8k.example.dtb: switch@10: ports:port@6: Unevaluated properties are not allowed ('qca,sgmii-rxclk-falling-edge' was unexpected)
> > 
> > Could you please explain why is the 'qca,sgmii-rxclk-falling-edge'
> > property not evaluated from the perspective of dsa.yaml in the example?
> > It's a head scratcher to me.
> 
> A schema with unevaluatedProperties can "see" into a $ref, but the 
> ref'ed schema having unevaluatedProperties can't see back to the 
> referring schema for properties defined there.
> 
> So if a schema is referenced by other schemas which can define their own 
> additional properties, that schema cannot have 'unevaluatedProperties: 
> false'. If both schemas have 'unevaluatedProperties: false', then it's 
> just redundant. We may end up doing that just because it's not obvious 
> when we have both or not, and no unevaluatedProperties/ 
> additionalProperties at all is a bigger issue. I'm working on a 
> meta-schema to check this.

Thanks for this information. So if I'm understanding correctly:

 - All DSA chips I'm modifying should reference dsa.yaml, as they
   currently are.
 - As such, these all should have unevaluatedProperties: true, so they
   can see into dsa.yaml.
 - dsa.yaml, and any schema that gets $ref:'d, can not have
   unevaluatedProperties: false, unless the desire is to forbid any
   other properties to be added.

I'll get another patch set out this week with all these changes, and
tested against the latest dt_bindings_check.

> 
> 
> > May it have something to do with the fact that Colin's addition:
> > 
> > $ref: "dsa.yaml#"
> > 
> > is not expressed as:
> > 
> > allOf:
> >   - $ref: "dsa.yaml#"
> > 
> > ?
> 
> No. Either way behaves the same. We generally only use 'allOf' when 
> there might be more than 1 entry. That is mostly just at the top-level.
> 
> Rob
