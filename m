Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DB95F149D
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 23:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiI3VQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 17:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiI3VQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 17:16:10 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7BF123D94;
        Fri, 30 Sep 2022 14:16:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frBHyQhUunptTMsO8vhZR1zj6XoWyhoVW5UuM5bw8RS4RmhETANypEgsbrOICiDHDvDfzuXl9/ITgoEWFfS0VC7FGE5Amoy0FGWmcW2pGDx2HNpVqwvbQaxJCX1Yu6u/NXaVNKQ+LSuOohAFCMrivDh4ejiQcid33EYKcr78u9FLScqDhOiBzBeZnGCNIQqHTinRC20ZzYTz+dx57XsxT1QOyiT04s0Un6D7QFmkTJtVqo3uOzEBRqGMktDEaiS8rA5uoanXrqOmmLt0ui3xlZrcphSDsqHmBtbzclx8BMECB4xs4fLifBQwHFdZTo1FhXU2CtA/tTRoEAEnJ8QkdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ooX2+bsohXpsXExyyiUEHzk3PCk7/LmtVcQIrg68isU=;
 b=J2gV3sDVYnVYLSc70QThhxsPkIWfAPckPsB2kelVhHSHAh/XcYCvjwtRbLGgd28QTtXbAqjJSBKPfKtFdh8RkhCwMHLgA9QhZx4V5xczjz405ZjEwdZlZE94xU04TM6xClfa/gFef0r5j1JWV900Dem6yYHLml4ehoMi3ipt2b+8DosmkyKF3+EIDAMG80j1iON+ySiKxWvxcjuEXxn4na0p+PJrAmFPeIXLdTcCeVC4flG23O2x2hkmQH9dAhUYhTliQNOOXD0TO5lfubBSINfKR5WIvFSrLCERzzA/G+pklo1Q0Y4TTAnVkhT2zSU6EIDSUeWoLOSWw0Z6fDQehg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooX2+bsohXpsXExyyiUEHzk3PCk7/LmtVcQIrg68isU=;
 b=MiwJxipkscHQm6xInRphaozZCviHoev6WuZcNXI9KXifz9HMP2gytQaQsIXNVohsPkMgbBpm72R1R277mfsNR8H2iLSX5vFxqR/uMfW+xtTo6k8kA5I7lW+Hbf7xKUkqRIVDHv2Y7syfZYsJriZjHz2lCxganYai5ElRf4X3xP4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB5071.namprd10.prod.outlook.com
 (2603:10b6:5:3a1::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 21:16:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.017; Fri, 30 Sep 2022
 21:16:01 +0000
Date:   Fri, 30 Sep 2022 14:15:58 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <Yzdcjh4OTI90wWyt@euler>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
X-ClientProxiedBy: MW4P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB5071:EE_
X-MS-Office365-Filtering-Correlation-Id: 8da1db46-a3ef-4f3e-34d2-08daa328f97b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qJZars1XaVn4Vhwl6RhmqXzQ2ovV3qMSzgtO0VaipvbVMr2esVk/oPNilR6l6hNZTeMsZs7sf0hJJonG6Mxu7P+0UqyihB45vIC+mvtWfBY6mFw11zYrPxZpXOUMZbBB+mzqTeLJdDydQI8/NQs7AnLI99JFTvAOprm1vqW3ntokpBetiE8HBXAJuVHxzpLr4QCp9Be91vCVy6MHWyWrCuCbQBgnH2OkwN8l1KdN+kYBwQbDyqGd3xnRiA4P2f9kS0c3zcnS56BYnh0UYHSKbfV1207Krdw7SMCjg9tb9NPuimHPr0FXtJowmf5Diwqbtf1TpjmTz2SLZAzVExNZxmcwvGy2vnEmrsniDDmlzNVU5GhqswTCfcleHv391opbiJromzhG8AQyxXZaGLuiou8dqCPS44ahp5zJRrzVGYb5ieUvD7WILc2lNYlmM1iBFIoNqaCXdjbh1n/VfWQWeNMFKq7xxmu46r0Kd0XXMo2clAVpjnRpZiT3GkanKSj2Zy2LVQOXxyAlel3oa64mrLVL9PIl91XODWUiGYEL4S7/A10XhblIji3Fl3Kp2EKnWSdnz1+zLnPvY7+j9WMhO1PDq6IReuBJ1PSIkiqejVFL2fXFYW5mg1dpwKxZI/phbKerGTBl24xOV3E4ogA7giTWKhQxLD2D2ZV/063Xhl6Y3hYKtSKbQrIOdpnjVh74/Ec78GbQI4/JmQHijr0uDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(346002)(376002)(39830400003)(136003)(451199015)(2906002)(83380400001)(44832011)(5660300002)(8936002)(41300700001)(7416002)(186003)(8676002)(6916009)(316002)(66476007)(66946007)(4326008)(9686003)(86362001)(38100700002)(33716001)(66556008)(6512007)(6486002)(6506007)(6666004)(54906003)(478600001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qBFU/MsZ0KeclBBws5scLFW5IQ4b/4qduCz9pMxxAnmWE48zSM6cCh2b/qnA?=
 =?us-ascii?Q?WyOreaKIFsgxJcFIyiZdRwrxfouRbXk/Fm8WPkIo6u4hXon3b5ubTZm4e5Su?=
 =?us-ascii?Q?2ojSz2vR+uIwQ5EK3nu0BuYClGcbYrCGjztZ+OkVAH+1jBmKBqMZyVCG7EfN?=
 =?us-ascii?Q?FTyUq/g7qA3qfdCHeLE2W+un66UFaG749sFsld/KokC0Bi98TOncVgOL2kLr?=
 =?us-ascii?Q?N1T8K5awxCyDUDNLoCQv/dHnzSNd9wkWEvkpGbkK3Rjm1nLv//Er2XtzTWmL?=
 =?us-ascii?Q?3ZGNBe3PR14d01ltMyUEEAhSyYxceQiH0ISla/ELDFXbtrz6bjy5gbP4y0pZ?=
 =?us-ascii?Q?pqgDrCKHf85wqBC2/Rg72vqDjO5bUFqgjExpiRg1M+DYfwPrPbydEJONXOdP?=
 =?us-ascii?Q?LyX/cJ5X0mikKx93yBbPEFxq/6ve54UqavmPN/2DsAIDgSiu+QhawFX/+I12?=
 =?us-ascii?Q?ZgRhAHVSGiEyKwdk5CRHJHYgDUb4kkfWwlBVObsfg4cQbQd8ESTiWqsPhzKs?=
 =?us-ascii?Q?6PJ7SXfUrl1rzfkT1bugz186uh3q62RF3v+n+V0dUc9ko8qZyKnccuntAwEf?=
 =?us-ascii?Q?TWo7cj7FyPp1sRKF1/DKqTs3L1+zQBRxgiQLMnXCz2YuUXkaI8mMQaKggRzN?=
 =?us-ascii?Q?OFg57L1oAo6tJCtns49qnemOKDXsGNcXlKdFbsCD7XKU+Ru5OWmH3/JERgx7?=
 =?us-ascii?Q?wpOcCxj3UMRSAX1xezEao+N81YOhWxTlof54RRkk00N+VHitF7R4vp3dZ4l1?=
 =?us-ascii?Q?rv8ZxcDi3HB/+Rq6qFXtrDxV1a7Vr+5ieWBbnW5DyuIaaVcQZ5mHJjvmw4zd?=
 =?us-ascii?Q?tb//CXUXD8mtsom7N7Lml7rpNfhKoYBv/78moXnGWEA6zJHQF0m6ZgiVBj0Q?=
 =?us-ascii?Q?3ptrmrsxTK7qJT0OXwrSnjHvn5f+aHFdHD1eE8vYipirzg8NWtsQ/HPdXmyz?=
 =?us-ascii?Q?4Kr/2WdBaGd9AbkpbfRBKLayzBMLO3FHZLefdAcP602oGp+mdOtuNRTe6qgm?=
 =?us-ascii?Q?jqfppa1c1yBos3yUt5P3ty1pBYKc9OyIS09ELKkGmBQu0OLvDdQRxE4AkcUC?=
 =?us-ascii?Q?hK3wVVFAp5LjW06nxbZgK0qSD+bmH5MAJIHagx/YrNhnZN2oWHw82MqvIyFv?=
 =?us-ascii?Q?2NBKqS/rkB2ly1Ey6aztzcjsBMedav79EunNUW+pHkz4ctDlwdwaspMASIXA?=
 =?us-ascii?Q?rIQpm8MDpzFbBx7cEXP90GWP4Cq+aN5hc1/XA/y38XJyaQG03s5FCrNuKnlI?=
 =?us-ascii?Q?Y6oRXWqAOK53W5aD1Qle1pQbg1YsCZUsjRDgEWh7Cb7iyq+8m9g7QBUurx/v?=
 =?us-ascii?Q?8hoo7fsL0NHzKJ/Eizt9FORqxK2TErW4bp4yoBjuI14PmsF0yAMUKzp1/OaL?=
 =?us-ascii?Q?5sGM4/esiHmHpDyxb3f0+sE/tNLksRqc5JTBaaR1BuEgxLqlrc+NIEYPi9Yv?=
 =?us-ascii?Q?+1lj7eXwPgAXPLJ/vP0hukVlblatc1YT9UDfRCzwrySHPJvQn4ScPXRZkyGa?=
 =?us-ascii?Q?74AwWGLHVCjN7zDIKVGJKmegx5I9HvpE7GQEKiqBTWVvkwNcPgn8FhslNjN6?=
 =?us-ascii?Q?PvbO0kkKuZ/hC/oLpyg6HvxPnS3PXp5wYsBsiRJdm8RGItxrUARfMlnRmyoK?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da1db46-a3ef-4f3e-34d2-08daa328f97b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 21:16:00.8779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xWd8mnICxSuMS/wvyaYkgx0YdKjlTrGmVVPE8jLjzy4kpKGe7WFw8Gz5NhKbvT5bSfqrr/Vn6kOwElgupi84k2+tm4cqPKlpD7OorLzNHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5071
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 11:26:00PM +0300, Vladimir Oltean wrote:
> On Sun, Sep 25, 2022 at 05:29:26PM -0700, Colin Foster wrote:
> > ---
> > +      - phy-mode = "internal": on ports 0, 1, 2, 3
> 
> More PHY interface types are supported. Please document them all.
> It doesn't matter what the driver supports. Drivers and device tree
> blobs should be able to have different lifetimes. A driver which doesn't
> support the SERDES ports should work with a device tree that defines
> them, and a driver that supports the SERDES ports should work with a
> device tree that doesn't.

This will change my patch a little bit then. I didn't undersand this
requirement.

My current device tree has all 8 ethernet ports populated. ocelot_ext
believes "all these port modes are accepted" by way of a fully-populated
vsc7512_port_modes[] array.

As a result, when I'm testing, swp4 through swp7 all enumerate as
devices, though they don't actually function. It isn't until serdes /
phylink / pcs / pll5 come along that they become functional ports.

I doubt this is desired. Though if I'm using the a new macro
OCELOT_PORT_MODE_NONE, felix.c stops after felix_validate_phy_mode.

I think the only thing I can do is to allow felix to ignore invalid phy
modes on some ports (which might be desired) and continue on with the
most it can do. That seems like a potential improvement to the felix
driver...

The other option is to allow the ports to enumerate, but leave them
non-functional. This is how my system currently acts, but as I said, I
bet it would be confusing to any user.

Thoughts?

