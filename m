Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2586F507A08
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 21:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354346AbiDSTQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 15:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241145AbiDSTQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 15:16:11 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2139.outbound.protection.outlook.com [40.107.244.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF4E3EF0D;
        Tue, 19 Apr 2022 12:13:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xjr3aIsF8bJx8CHleyJ0GkA/bm9FMZceFyKmhZLzvsA4LEnzEeFFW1DvrDd84WOTfpzeaFz/c494Gjkzn+vcDsIuTq9q5f8BJOtYDgmzoqXqkU5/1xqaTcnzgY0BcHXK3GTbVgYGUut0BPeEcnIne29iPlX55Dsw+wer6FVDvO6lfRkAsVNXUIOYqFC+302a2cxtSVehozUYm73XrI5pWrLuHgCZ11aQVqUMeujs5z7aOO4dX3OpFxuRvKd70Oz74crrTgnmBaLESh9ge0pBi2YXzTn9IdmK78Yz2ER4WwhwZtIYjiGOM5FJry4Xuy9GbacbI/3pidJHHuQl3eCUSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=arj+0HeIT+5WvxCqG/lp6wj7qSjCoE7VFj69Nf/lo0c=;
 b=N3N7zUfc8EXmi+/Iby4Wvlfv8+I55t45aKaSCh8JsscgBeH16cHTcHcPVkalK4cwVTkEydZ+TVGoFzERhQnmd2wvO4CEoGuiWtdzs8VWYjUkVo6Jubw7QyVaXgGsP46KNOSLvIWPWqiBYY5yEfTN8zjfUjvDIeemMJ9U12qsWrnbhYEG0Ow3P0IEEvebmyfAIZpVBf2BAls+i5v19NyK6QMD8xvolNGw9mU6Q2NJv3JGk+SO0hMPf+4j7x/+TqR3QFl4zzZvYlF5mJAUw00fjXtJWoHQL2oTZFsin7waXvVliLyvIBpRnYEfWETF5v2hYgCDTso8PZTfLJRu8Wvp5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arj+0HeIT+5WvxCqG/lp6wj7qSjCoE7VFj69Nf/lo0c=;
 b=xQxqi6kQR0f7yCfG1/g2RWVC1s0qT73TgDVHpMiyzmYOIZYPxJdwt3BYuEQqy7pnPpDrWaPZkzdt/MDzyikM+iPX+kwvR1u9+g/H67uaIaMsfjl///EBrdDP2xs0GKukthxhRIFRXA0Q35QPn9qA0ClLnE+bZRFaewXvao1MUk8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BL3PR10MB5489.namprd10.prod.outlook.com
 (2603:10b6:208:33c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 19:13:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5164.026; Tue, 19 Apr 2022
 19:13:23 +0000
Date:   Tue, 19 Apr 2022 19:13:18 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        katie.morris@in-advantage.com
Subject: Re: [RFC v7 net-next 10/13] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <20220420021318.GA1220@COLIN-DESKTOP1.localdomain>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
 <20220307021208.2406741-11-colin.foster@in-advantage.com>
 <YlaKlhiQEWMxJxhU@google.com>
 <Yl57uP+rsl/bsI4i@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yl57uP+rsl/bsI4i@google.com>
X-ClientProxiedBy: MW4PR04CA0130.namprd04.prod.outlook.com
 (2603:10b6:303:84::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d01dd7d-471d-4561-3df3-08da2238ac70
X-MS-TrafficTypeDiagnostic: BL3PR10MB5489:EE_
X-Microsoft-Antispam-PRVS: <BL3PR10MB5489FB5E32F85ACF5E1B199CA4F29@BL3PR10MB5489.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gMge5GI8pNFjFoShODG5e3Ws3TKPNiCq+jgp8fWfDI139GZbUk5IYq7YGdD3d5g5ZEt3KHbruT/wfxy5Aw0pHviaD+ngdim7od+GKYpXnXA8zflApxR9O1zGGAw7b6S791RwSQGYSIMp/P4GfPGUU/BqqJ5MciVLqp29H8TbTe+a+PDvUQtcU4KF9FJ+VCz0dp6BTDFrVKa0Ug8JulxAMiiGdl6vRnADfO5rNquRbUj4NTArZ59jycT3vFEATtmy0ucSoEpOP+e0kLQhU8F75p5uZOgO4/kqb7/GZotm8W1XKtbBMxtl9DugKgWUcVGJEwIfSK10U+fAn5T9f/3Ch0rGwaCAq5x4ZrS8rk0/YPGE3lWVTGu+pChHshfTbBO0DxSduONb9sYwxzB3uNzpd7tKTC3uS7tjASCHmjN7zUuB9MUlw6WxXtnWx3VzZZpo1NIji5LEKWhvYlBIyBLgvqgGL5KFKdHWKvRaUCu3go5z0o60UmfCiq8uimbyV7dsqrOYx3gvv8/6WEYS4uhUR/2BdWNy8eEy+KqwNJOOrXg4fi5ebCBukfGcM8HuGK5EbeJgmaXqHTfX6xoD8d/N7f2ITHfGRZ8lV3t2CtOyZoYwTdG9HMzkNwGe9rGfl2dkk7OZDi/2YHl8frBK6P3dkxDNAfyCZ7w1O4QGrMJ0ARMXJ8nHNQ2vomBBcn8EAId/DX2mNjsAdBz+EGpTaXIozZyLBnK+jUuKo+xm3wD/abYCLOwqwGRRgQbQEp82DliAjdlxcOefj65QBoK+7EUqgSY8zUOvzydVUsNcW5yRt0A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39830400003)(346002)(376002)(136003)(366004)(83380400001)(107886003)(186003)(26005)(38350700002)(1076003)(30864003)(38100700002)(5660300002)(8936002)(7416002)(44832011)(508600001)(316002)(66946007)(6666004)(6512007)(2906002)(6506007)(52116002)(8676002)(4326008)(33656002)(66556008)(66476007)(6916009)(54906003)(966005)(6486002)(9686003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3l2dXkzeTd3WlN6NFV5eWlzZUU4NVFUK0ZHT0t5SmRuV2FFSkVHUm9OTkhr?=
 =?utf-8?B?Njk5WkYxQnhnMFNCZ05oYitWRmxjUnpaOWN5ZEtzWjZEYUs3cHQzQXlEa0Iz?=
 =?utf-8?B?R1Vla2JEaUlwV2szOW1jZnk4ZEJwUENwVzg3Wm1UUnZjc2lGL05DT3ZxYllM?=
 =?utf-8?B?eHhkN1JEaW4xVmJmNEpHVk1RN3c5elV5UmI2UERNeHhBM3dEaWIwcmRZSUxZ?=
 =?utf-8?B?MDBkay9HdnRaT0krSi9FNW9nNVNBOTdFU0FBTWozUTNFQmFRQ01HUTQ3Q2Ny?=
 =?utf-8?B?R2lOMlAxeU5UUUF1SXJPYXJIc0h3UDRQdWdKeE1sY0owTnMrYlVnM3lrTjg0?=
 =?utf-8?B?bmpJdm5XSVBnckxoL0tVSFNKTll0NTgweVU4QTlwTFp4Zkt3YzlPR1UzMEZ4?=
 =?utf-8?B?NHFhbTAyczRhbUtsUVNGNjNkZTA0N2d0bFpTUHBvMlBVV2c0ZXZ5aUgwaGRX?=
 =?utf-8?B?SmltUDdZL0M0UCtWS3dHeHpCbDZWRWYwR0hhYTBXZnlJbFAyVktmY3B3UmhW?=
 =?utf-8?B?ZUZLZ0ZMUjJxaXNRK2tBalpBQUUydmRCNjRQN0FHOHBkNlhzZmpScmVISm93?=
 =?utf-8?B?cmtOb1JQdTBEcktkWlhINnRPWHVFb1dUMXM5WEg1Nmhrd3NiVmRIVEhkSjdX?=
 =?utf-8?B?bnBSTGgvRUFiSU9yNHd1MlhFTWVIVXgxWFkrUUswbXl4V00xaW5LVi9GSTFl?=
 =?utf-8?B?Z0UxVXlVdlFWRGFEZkxNUytJcnJPVWNIRmM4ektPTDBvQk0wRHR0L3NCZURK?=
 =?utf-8?B?Tmp6N0huMkU2T2dNK3l3ODhiS2p2YnhtL01YcWNIYm8yekJ6dzJsZXNrTVlv?=
 =?utf-8?B?b2JOU2FVOTJuNHE0My9ON1F0c3ZMY0k2ZkdBOEQwVW5DMGhEZHJadDU3Nzkw?=
 =?utf-8?B?K0FLZ1AwZ2FlcTFNWE5rcjVRbXEzMllBUzczZFFONGd2TS96RnZwTWgydFJz?=
 =?utf-8?B?Q3U1KzVoWjBQQ3FMRUxVZUh4V3U4VS9XMXFscDgrTGVHTU9EMWczanRSR0JG?=
 =?utf-8?B?S3QrNFhrWXRxdUphUDI1b0pIUVc0ejhRclcwUWE1THRZSndQQTdYYWJTVzhK?=
 =?utf-8?B?Zk40NGozNVFLNXRWSys1Qi9WZ2dnVVprUG84RU9ibkFjN25HdE9IelpYNHhx?=
 =?utf-8?B?bXFhWTR5TVBtZUJoMFgvcU0rRmVHTmpzNklhQ05IMmsreE5JVmtXTW1ycGlK?=
 =?utf-8?B?MmpTUnBNL3hSa3dVVGtGaTQ3enMxdWNkaEpUa1dGUktHcWQ2UmQxcGpUUnFq?=
 =?utf-8?B?RXZtKzlDQ0x5YXFGdDVrOUxsOXp6QTBoNlVMY2F1WHVTZUk2a2ovN3dxbjdu?=
 =?utf-8?B?d0FuWVBDQkFua0hzZmFYdENDS1g5MnJyLzdIRGU4c0JwelVZNUw0U0c2cVgz?=
 =?utf-8?B?M1NGTFFKendYTnV1eE5qTDZ5VFoyRUNocm9BNmRJSi9Oa1NScFNialoxL1k4?=
 =?utf-8?B?VFJGKzNKNzdEc29IYnA3QjJFbDR1amRyV2ZvYUllU3hKZ1Nqd1JacGRBMnhE?=
 =?utf-8?B?ZVdDZG96R1NzRmNXWDBJeHZtNEZJZ3ZsVFhORHdBQ3ZRZE9TNzJ4Q2o0bUFK?=
 =?utf-8?B?Z1pid3gwOGNJb1pPNWg4QnpxbDFlNkRHcjVJWWVSZzJuR0JTbU9lWXRpYnBG?=
 =?utf-8?B?alcxY2JOb0puS1NDS3JCTkpVV0Z6WEcxZUVCNUYxbnBXVXhFUFRiM1AyclpU?=
 =?utf-8?B?N3ZteDIrZG5HVk95S2JwTm1pS1AwSlV4VU5YbjdqazEzZFZnbjNVb2lOVkxw?=
 =?utf-8?B?U09KS2xyTkExZUkyU25Cc2pNWVJvb2IvRWM0K09Gem1oUXAyK1ZjTlJyZnlO?=
 =?utf-8?B?ckFjYWVUdXRWMkJvUjRWNWVRK0FtTkpEcmFQcUFrZHNXOHRFSGV1Qk1INW91?=
 =?utf-8?B?SG9JNU9hVUF5UFJteWM4VnRaMzYrSkdUbFVRUjcvOE83ampZcmo3dzFNSURY?=
 =?utf-8?B?MjUxNzhBc3pIdTIvRmRPdTdEa2FPU1orNkN0LzZKQ0NndWJzT2dMd3BsVHh5?=
 =?utf-8?B?MnlOL0orMWNmVXdtV1JsbVk4RXpJTmtvc0M1K2FrbUhVYjN1TktpYnVURkRr?=
 =?utf-8?B?RHRQYlF2TzdObmJTM2RaWjAvbVQxMVhXckRzOGJyY1ZCVFErcnpQM1RaUms0?=
 =?utf-8?B?VWQzQnAxM2NkdFNQeUFadmltM3d0RzhvTWRMNGVIYlVyQTVKNWtxUm9CRnhi?=
 =?utf-8?B?M2ZZOExxa3IvS0VlaEluQlY1TlpXeit1YVJ3d3lZSEdRRVBkY1d5b3BvZ3Uz?=
 =?utf-8?B?T096SmY2c2tYYThiU3d3NjFZejBuMzdpSmJSclIrRkNGVUpMaHI4OS84YU1m?=
 =?utf-8?B?S0h5d0g1Ykh1cXhoNmdnbjA2ZjdPcFBlbDBJK1ZxUXhLbDFReXRQa2NPWWh0?=
 =?utf-8?Q?+4627X4owyOgNvbU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d01dd7d-471d-4561-3df3-08da2238ac70
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 19:13:23.6333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AvZeJeTVtGc6VbjPpxRdcvz22hqsBofcgP7EBrxMo8GJ+NiSd7D0y9aDo8Ap5c5vC2Cf22nt9MorpabZuNrhdSxZwyMyO3KM/1su1W6f8q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB5489
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,WEIRD_QUOTING
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the feedback Lee,

I'll do some final cleanup (hopefully this month...?) and prepare
another patch set.


Something I plan to do, lest anyone object, is send the next patch set
that explicitly states that ports 4-10 currently aren't supported, and 
inform a user as such. One main reason for this is that the additional
ports rely on the drivers/phy/mscc/phy-ocelot-serdes driver, which
utilizes syscon_node_to_regmap. The same issue comes up, where syscon of
course only supports mmio. I can foresee that being worthy of its own
rounds of reviews, and will change the .

But I'm quite new to this process - so if that isn't an acceptable path
forward I understand.


On Tue, Apr 19, 2022 at 10:07:04AM +0100, Lee Jones wrote:
> [Adding everyone/lists back on Cc]

Oops... I'm not sure how I did that. Thanks!

> 
> On Thu, 14 Apr 2022, Colin Foster wrote:
> 
> > Hi Lee,
> > 
> > Thanks for the feedback. I agree with (and have made) your suggestions.
> > Additional comments below.
> 
> I'm swamped right now, so I cannot do a full re-review, but please see
> in-line for a couple of (most likely flippant i.e. not fully
> thought out comments).
> 
> Please submit the changes you end up making off the back of this
> review and I'll conduct another on the next version you send.
> 
> > On Wed, Apr 13, 2022 at 09:32:22AM +0100, Lee Jones wrote:
> > > On Sun, 06 Mar 2022, Colin Foster wrote:
> > > 
> > [...]
> > > > +
> > > > +int ocelot_core_init(struct ocelot_core *core)
> > > > +{
> > > > +	struct device *dev = core->dev;
> > > > +	int ret;
> > > > +
> > > > +	dev_set_drvdata(dev, core);
> > > > +
> > > > +	core->gcb_regmap = ocelot_devm_regmap_init(core, dev,
> > > > +						   &vsc7512_gcb_resource);
> > > 
> > > This just ends up calling ocelot_spi_devm_get_regmap() right?
> > > 
> > > Why not call that from inside ocelot-spi.c where 'core' was allocated?
> > 
> > core->gcb_regmap doesn't handle anything more than chip reset. This will
> > have to happen regardless of the interface.
> > 
> > The "spi" part uses the core->cpuorg_regmap, which is needed for
> > configuring the SPI bus. In the case of I2C, this cpu_org regmap
> > (likely?) wouldn't be necessary, but the gcb_regmap absolutely would.
> > That's why gcb is allocated in core and cpuorg is allocated in SPI.
> > 
> > The previous RFC had cpuorg_regmap hidden inside a private struct to
> > emphasize this separation. As you pointed out, there was a lot of
> > bouncing between "core" structs and "spi" structs that got ugly.
> > 
> > (Looking at this more now... the value of cpuorg_regmap should have been
> > in the CONFIG_MFD_OCELOT_SPI ifdef, which might have made this
> > distinction more clear)
> 
> The TL;DR of my review point would be to make this as simple as
> possible.  If you can call a single function, instead of needlessly
> sending the thread of execution through three, please do.
> 
> > > > +	if (IS_ERR(core->gcb_regmap))
> > > > +		return -ENOMEM;
> > > > +
> > > > +	ret = ocelot_reset(core);
> > > > +	if (ret) {
> > > > +		dev_err(dev, "Failed to reset device: %d\n", ret);
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * A chip reset will clear the SPI configuration, so it needs to be done
> > > > +	 * again before we can access any registers
> > > > +	 */
> > > > +	ret = ocelot_spi_initialize(core);
> > > 
> > > Not a fan of calling back into the file which called us.
> > > 
> > > And what happens if SPI isn't controlling us?
> > > 
> > > Doesn't the documentation above say this device can also be
> > > communicated with via I2C and PCIe?
> > 
> > During the last RFC this was done through a callback. You had requested
> > I not use callbacks.
> > 
> > From that exchange:
> > """"
> > > > > +	ret = core->config->init_bus(core->config);
> > > >
> > > > You're not writing a bus.  I doubt you need ops call-backs.
> > >
> > > In the case of SPI, the chip needs to be configured both before and
> > > after reset. It sets up the bus for endianness, padding bytes, etc. This
> > > is currently achieved by running "ocelot_spi_init_bus" once during SPI
> > > probe, and once immediately after chip reset.
> > >
> > > For other control mediums I doubt this is necessary. Perhaps "init_bus"
> > > is a misnomer in this scenario...
> > 
> > Please find a clearer way to do this without function pointers.
> > """"
> 
> Yes, I remember.
> 
> This is an improvement on that, but it doesn't mean it's ideal.
> 
> > The idea is that we set up the SPI bus so we can read registers. The
> > protocol changes based on bus speed, so this is necessary.
> > 
> > This initial setup is done in ocelot-spi.c, before ocelot_core_init is
> > called.
> > 
> > We then reset the chip by writing some registers. This chip reset also
> > clears the SPI configuration, so we need to reconfigure the SPI bus
> > before we can read any additional registers.
> > 
> > Short of using function pointers, I imagine this will have to be
> > something akin to:
> > 
> > if (core->is_spi) {
> >     ocelot_spi_initalize();
> > }
> 
> What about if, instead of calling from SPI into Core, which calls back
> into SPI again, you do this from SPI instead:
> 
> [flippant - I haven't fully assessed the viability of this suggestion]
> 
> foo_type spi_probe(bar_type baz)
> {
>   setup_spi();
> 
>   core_init();
> 
>   more_spi_stuff();
> }
> 
> > I feel if the additional buses are added, they'll have to implement this
> > type of change. But as I don't (and don't plan to) have hardware to
> > build those interfaces out, right now ocelot_core assumes the bus is
> > SPI.
> 
> What are the chances of someone else coming along and implementing the
> other interfaces?  You might very well be over-complicating this
> implementation for support that may never be required.

I had one person email me about this already, though I understand they
went another direction.

But I could see this back-and-forth going away. I'll take another look
at it and try to clean it up a little more.

> 
> > > > +	if (ret) {
> > > > +		dev_err(dev, "Failed to initialize SPI interface: %d\n", ret);
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
> > > > +				   ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
> > > > +	if (ret) {
> > > > +		dev_err(dev, "Failed to add sub-devices: %d\n", ret);
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +EXPORT_SYMBOL(ocelot_core_init);
> > > > +
> > > > +MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
> > > > +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> > > > +MODULE_LICENSE("GPL v2");
> > > > diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> > > > new file mode 100644
> > > > index 000000000000..c788e239c9a7
> > > > --- /dev/null
> > > > +++ b/drivers/mfd/ocelot-spi.c
> > > > @@ -0,0 +1,313 @@
> > > > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > > > +/*
> > > > + * SPI core driver for the Ocelot chip family.
> > > > + *
> > > > + * This driver will handle everything necessary to allow for communication over
> > > > + * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
> > > > + * are to prepare the chip's SPI interface for a specific bus speed, and a host
> > > > + * processor's endianness. This will create and distribute regmaps for any MFD
> > > 
> > > As above, please drop references to MFD.
> > > 
> > > > + * children.
> > > > + *
> > > > + * Copyright 2021 Innovative Advantage Inc.
> > > > + *
> > > > + * Author: Colin Foster <colin.foster@in-advantage.com>
> > > > + */
> > > > +
> > > > +#include <linux/iopoll.h>
> > > > +#include <linux/kconfig.h>
> > > > +#include <linux/module.h>
> > > > +#include <linux/of.h>
> > > > +#include <linux/regmap.h>
> > > > +#include <linux/spi/spi.h>
> > > > +
> > > > +#include <asm/byteorder.h>
> > > > +
> > > > +#include "ocelot.h"
> > > > +
> > > > +#define DEV_CPUORG_IF_CTRL	0x0000
> > > > +#define DEV_CPUORG_IF_CFGSTAT	0x0004
> > > > +
> > > > +#define CFGSTAT_IF_NUM_VCORE	(0 << 24)
> > > > +#define CFGSTAT_IF_NUM_VRAP	(1 << 24)
> > > > +#define CFGSTAT_IF_NUM_SI	(2 << 24)
> > > > +#define CFGSTAT_IF_NUM_MIIM	(3 << 24)
> > > > +
> > > > +
> > > > +static const struct resource vsc7512_dev_cpuorg_resource = {
> > > > +	.start	= 0x71000000,
> > > > +	.end	= 0x710002ff,
> > > 
> > > No magic numbers.  Please define these addresses.
> > 
> > I missed these. Thanks.
> > 
> > > 
> > > > +	.name	= "devcpu_org",
> > > > +};
> > > > +
> > > > +#define VSC7512_BYTE_ORDER_LE 0x00000000
> > > > +#define VSC7512_BYTE_ORDER_BE 0x81818181
> > > > +#define VSC7512_BIT_ORDER_MSB 0x00000000
> > > > +#define VSC7512_BIT_ORDER_LSB 0x42424242
> > > > +
> > > > +int ocelot_spi_initialize(struct ocelot_core *core)
> > > > +{
> > > > +	u32 val, check;
> > > > +	int err;
> > > > +
> > > > +#ifdef __LITTLE_ENDIAN
> > > > +	val = VSC7512_BYTE_ORDER_LE;
> > > > +#else
> > > > +	val = VSC7512_BYTE_ORDER_BE;
> > > > +#endif
> > > 
> > > Not a fan of ifdefery in the middle of C files.
> > > 
> > > Please create a macro or define somewhere.
> > 
> > I'll clear this up in comments and move things around. This macro
> > specifically tends to lend itself to this type of ifdef dropping:
> > 
> > https://elixir.bootlin.com/linux/v5.18-rc2/C/ident/__LITTLE_ENDIAN
> 
> I see that the majority of implementations exist in header files as I
> would expect.  With respect to the others, past acceptance and what is
> acceptable in other subsystems has little bearing on what will be
> accepted here and now.
> 
> > The comment I'm adding is:
> >         /*
> >          * The SPI address must be big-endian, but we want the payload to match
> >          * our CPU. These are two bits (0 and 1) but they're repeated such that
> >          * the write from any configuration will be valid. The four
> >          * configurations are:
> >          *
> >          * 0b00: little-endian, MSB first
> >          * |            111111   | 22221111 | 33222222 |
> >          * | 76543210 | 54321098 | 32109876 | 10987654 |
> >          *
> >          * 0b01: big-endian, MSB first
> >          * | 33222222 | 22221111 | 111111   |          |
> >          * | 10987654 | 32109876 | 54321098 | 76543210 |
> >          *
> >          * 0b10: little-endian, LSB first
> >          * |              111111 | 11112222 | 22222233 |
> >          * | 01234567 | 89012345 | 67890123 | 45678901 |
> >          *
> >          * 0b11: big-endian, LSB first
> >          * | 22222233 | 11112222 |   111111 |          |
> >          * | 45678901 | 67890123 | 89012345 | 01234567 |
> >          */
> > 
> > With this info, would you recommend:
> > 1. A file-scope static const at the top of this file
> > 2. A macro assigned to one of those sequences
> > 3. A function to "detect" which architecture we're running
> 
> I do not have a strong opinion.
> 
> Just tuck the #iferry away somewhere in a header file.

Will do

> 
> > > > +	err = regmap_write(core->cpuorg_regmap, DEV_CPUORG_IF_CTRL, val);
> > > > +	if (err)
> > > > +		return err;
> > > 
> > > Comment.
> > > 
> > > > +	val = core->spi_padding_bytes;
> > > > +	err = regmap_write(core->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, val);
> > > > +	if (err)
> > > > +		return err;
> > > 
> > > Comment.
> > 
> > Adding:
> > 
> > /*
> >  * Apply the number of padding bytes between a read request and the data
> >  * payload. Some registers have access times of up to 1us, so if the
> >  * first payload bit is shifted out too quickly, the read will fail.
> >  */
> > 
> > > 
> > > > +	/*
> > > > +	 * After we write the interface configuration, read it back here. This
> > > > +	 * will verify several different things. The first is that the number of
> > > > +	 * padding bytes actually got written correctly. These are found in bits
> > > > +	 * 0:3.
> > > > +	 *
> > > > +	 * The second is that bit 16 is cleared. Bit 16 is IF_CFGSTAT:IF_STAT,
> > > > +	 * and will be set if the register access is too fast. This would be in
> > > > +	 * the condition that the number of padding bytes is insufficient for
> > > > +	 * the SPI bus frequency.
> > > > +	 *
> > > > +	 * The last check is for bits 31:24, which define the interface by which
> > > > +	 * the registers are being accessed. Since we're accessing them via the
> > > > +	 * serial interface, it must return IF_NUM_SI.
> > > > +	 */
> > > > +	check = val | CFGSTAT_IF_NUM_SI;
> > > > +
> > > > +	err = regmap_read(core->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, &val);
> > > > +	if (err)
> > > > +		return err;
> > > > +
> > > > +	if (check != val)
> > > > +		return -ENODEV;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +EXPORT_SYMBOL(ocelot_spi_initialize);
> > > > +
> > > > +/*
> > > > + * The SPI protocol for interfacing with the ocelot chips uses 24 bits, while
> > > > + * the register locations are defined as 32-bit. The least significant two bits
> > > > + * get shifted out, as register accesses must always be word-aligned, leaving
> > > > + * bits 21:0 as the 22-bit address. It must always be big-endian, whereas the
> > > > + * payload can be optimized for bit / byte order to match whatever architecture
> > > > + * the controlling CPU has.
> > > > + */
> > > > +static unsigned int ocelot_spi_translate_address(unsigned int reg)
> > > > +{
> > > > +	return cpu_to_be32((reg & 0xffffff) >> 2);
> > > > +}
> > > > +
> > > > +struct ocelot_spi_regmap_context {
> > > > +	u32 base;
> > > > +	struct ocelot_core *core;
> > > > +};
> > > > +
> > > > +static int ocelot_spi_reg_read(void *context, unsigned int reg,
> > > > +			       unsigned int *val)
> > > > +{
> > > > +	struct ocelot_spi_regmap_context *regmap_context = context;
> > > > +	struct ocelot_core *core = regmap_context->core;
> > > > +	struct spi_transfer tx, padding, rx;
> > > > +	struct spi_message msg;
> > > 
> > > How big are all of these?
> > > 
> > > We will receive warnings if they occupy too much stack space.
> > 
> > Looking at the structs they're on the order of 10s of bytes. Maybe 70
> > bytes per instance (back of napkin calculation)
> > 
> > But it seems very common to stack-allocate spi_transfers:
> > 
> > https://elixir.bootlin.com/linux/v5.18-rc2/source/drivers/spi/spi.c#L4097
> > https://elixir.bootlin.com/linux/v5.18-rc2/source/include/linux/spi/spi.h#L1244
> > 
> > Do you have a feel for at what point that becomes a concern?
> 
> That's fine.  I just want you to bear this in mind.
> 
> I wish to prevent adding yet more W=1 level warnings into the kernel.
> 
> > > > +	struct spi_device *spi;
> > > > +	unsigned int addr;
> > > > +	u8 *tx_buf;
> > > > +
> > > > +	spi = core->spi;
> > > > +
> > > > +	addr = ocelot_spi_translate_address(reg + regmap_context->base);
> > > > +	tx_buf = (u8 *)&addr;
> > > > +
> > > > +	spi_message_init(&msg);
> > > > +
> > > > +	memset(&tx, 0, sizeof(tx));
> > > > +
> > > > +	/* Ignore the first byte for the 24-bit address */
> > > > +	tx.tx_buf = &tx_buf[1];
> > > > +	tx.len = 3;
> > > > +
> > > > +	spi_message_add_tail(&tx, &msg);
> > > > +
> > > > +	if (core->spi_padding_bytes > 0) {
> > > > +		u8 dummy_buf[16] = {0};
> > > > +
> > > > +		memset(&padding, 0, sizeof(padding));
> > > > +
> > > > +		/* Just toggle the clock for padding bytes */
> > > > +		padding.len = core->spi_padding_bytes;
> > > > +		padding.tx_buf = dummy_buf;
> > > > +		padding.dummy_data = 1;
> > > > +
> > > > +		spi_message_add_tail(&padding, &msg);
> > > > +	}
> > > > +
> > > > +	memset(&rx, 0, sizeof(rx));
> > > > +	rx.rx_buf = val;
> > > > +	rx.len = 4;
> > > > +
> > > > +	spi_message_add_tail(&rx, &msg);
> > > > +
> > > > +	return spi_sync(spi, &msg);
> > > > +}
> > > > +
> > > > +static int ocelot_spi_reg_write(void *context, unsigned int reg,
> > > > +				unsigned int val)
> > > > +{
> > > > +	struct ocelot_spi_regmap_context *regmap_context = context;
> > > > +	struct ocelot_core *core = regmap_context->core;
> > > > +	struct spi_transfer tx[2] = {0};
> > > > +	struct spi_message msg;
> > > > +	struct spi_device *spi;
> > > > +	unsigned int addr;
> > > > +	u8 *tx_buf;
> > > > +
> > > > +	spi = core->spi;
> > > > +
> > > > +	addr = ocelot_spi_translate_address(reg + regmap_context->base);
> > > > +	tx_buf = (u8 *)&addr;
> > > > +
> > > > +	spi_message_init(&msg);
> > > > +
> > > > +	/* Ignore the first byte for the 24-bit address and set the write bit */
> > > > +	tx_buf[1] |= BIT(7);
> > > > +	tx[0].tx_buf = &tx_buf[1];
> > > > +	tx[0].len = 3;
> > > > +
> > > > +	spi_message_add_tail(&tx[0], &msg);
> > > > +
> > > > +	memset(&tx[1], 0, sizeof(struct spi_transfer));
> > > > +	tx[1].tx_buf = &val;
> > > > +	tx[1].len = 4;
> > > > +
> > > > +	spi_message_add_tail(&tx[1], &msg);
> > > > +
> > > > +	return spi_sync(spi, &msg);
> > > > +}
> > > > +
> > > > +static const struct regmap_config ocelot_spi_regmap_config = {
> > > > +	.reg_bits = 24,
> > > > +	.reg_stride = 4,
> > > > +	.val_bits = 32,
> > > > +
> > > > +	.reg_read = ocelot_spi_reg_read,
> > > > +	.reg_write = ocelot_spi_reg_write,
> > > > +
> > > > +	.max_register = 0xffffffff,
> > > > +	.use_single_write = true,
> > > > +	.use_single_read = true,
> > > > +	.can_multi_write = false,
> > > > +
> > > > +	.reg_format_endian = REGMAP_ENDIAN_BIG,
> > > > +	.val_format_endian = REGMAP_ENDIAN_NATIVE,
> > > > +};
> > > > +
> > > > +struct regmap *
> > > > +ocelot_spi_devm_get_regmap(struct ocelot_core *core, struct device *child,
> > > > +			   const struct resource *res)
> > > 
> > > This seems to always initialise a new Regmap.
> > > 
> > > To me 'get' implies that it could fetch an already existing one.
> > > 
> > > ... and *perhaps* init a new one if none exists..
> > 
> > That's exactly what my intention was when I started.
> > 
> > But it seems like *if* that is something that is required, it should be
> > done through a syscon / device tree implementation and not be snuck into
> > this regmap getter. I was trying to do too much.
> > 
> > I'm renaming to "init"
> > 
> > > 
> > > > +{
> > > > +	struct ocelot_spi_regmap_context *context;
> > > > +	struct regmap_config regmap_config;
> > > > +
> > > > +	context = devm_kzalloc(child, sizeof(*context), GFP_KERNEL);
> > > > +	if (IS_ERR(context))
> > > > +		return ERR_CAST(context);
> > > > +
> > > > +	context->base = res->start;
> > > > +	context->core = core;
> > > > +
> > > > +	memcpy(&regmap_config, &ocelot_spi_regmap_config,
> > > > +	       sizeof(ocelot_spi_regmap_config));
> > > > +
> > > > +	regmap_config.name = res->name;
> > > > +	regmap_config.max_register = res->end - res->start;
> > > > +
> > > > +	return devm_regmap_init(child, NULL, context, &regmap_config);
> > > > +}
> > > > +
> > > > +static int ocelot_spi_probe(struct spi_device *spi)
> > > > +{
> > > > +	struct device *dev = &spi->dev;
> > > > +	struct ocelot_core *core;
> > > 
> > > This would be more in keeping with current drivers if you dropped the
> > > '_core' part of the struct name and called the variable ddata.
> > 
> > There's already a "struct ocelot" defined in include/soc/mscc/ocelot.h.
> > I suppose it could be renamed to align with what it actually is: the
> > "switch" component of the ocelot chip.
> > 
> > Vladimir, Alexandre, Horaitu, others:
> > Any opinions about this becoming "struct ocelot" and the current struct
> > being "struct ocelot_switch"?
> > 
> > Or maybe a technical / philosophical question: is "ocelot" the switch
> > core that can be implemented in other hardware? Or is it the chip family
> > entirely, (pinctrl, sgpio, etc.) who's switch core was brought into
> > other products?
> > 
> > The existing struct change would hit about 30 files.
> > https://elixir.bootlin.com/linux/v5.18-rc2/C/ident/ocelot
> 
> That's not ideal.
> 
> Please consider using 'ocelot_ddata' for now and consider a larger
> overhaul at a later date, if it makes sense to do so.
> 
> [...]
> 
> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
