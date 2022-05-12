Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48755250CD
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 17:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355685AbiELPEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 11:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352384AbiELPEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 11:04:05 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2113.outbound.protection.outlook.com [40.107.100.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C506A6CF4F;
        Thu, 12 May 2022 08:04:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFJuWkVbfEof+mW1cieCtjjRQQfzqt2CczYIgcFNur6GpBH4sf2UENLullqOzy/cI+iV+1VscQe4cVaaAKukG/XK7Bgt2tzSMh16wDu9fSfxm9ea5hW/f57qUJ/3rDzCYJuVikGGyKx56c7QIQxJSIy04rXu2PPjGnPs8o5lKUtZdjBRh7ylDIitynaOvU6LlHrmyvNWIXxMB/LYpZfuT7bxklmlnSgHpOW2PynEza/rczMRCtnsWklidlB+I98+ejUGcxf8bduEaHV6k7keBh3k0OQWHn5qY3kv06saPixGROBf4yagFUphS9aray6n4fwCFy7VR0VLq2uBc3iMGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1WDct291odsCam711rT1o87dyc/eJ0XUMPbR9eBcbE=;
 b=Gcbt6+OEQ3heCTLhQpOA9OCVu4Hl3nV7VqoQd/sH8Bh2NlSjAiJpCzq/ZoxYe5ANtH5WHl6NtjEK+WAWT9eUkqOL9jtzJuWr7RuBMxMTB3XY3BfwEL61y8fG9qi2vdGnroyYsHMf97ubH9z9D6wEK44WeG6tlwSe+msvNoXbzLSFTLJCirkCivjHmVzFlEvEZrX6ejjv3jshZ6Nv1DUOO+x2lL6GwdwmM8YnuQbU/Jvvc3MskmYd0ksYwo7L4FJq2TsVCzLPEga9DcRNTXruDvxI9A+RybZbHFXovcW2S3FLW0/XJDlWRMXGPiRGavOCehQb5DxuBZ6PRSOxYdJ0Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1WDct291odsCam711rT1o87dyc/eJ0XUMPbR9eBcbE=;
 b=XHzyqnkbkS31dOCyW3zRSoZRG68oI26MHZBhwpD2QQDSCblowcYhrlOZ+/GDzNDG4qOHVfIes6r4r6UU99ExovoEHJMffmAptk2/dqtkpZCHEMLceVEF+A4/zKEs2wtZ0b3NWGW64NskrAx7mna0Tqj7t8dkSGq9si/uI/Xl268=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB4939.namprd10.prod.outlook.com
 (2603:10b6:610:c0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Thu, 12 May
 2022 15:04:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.024; Thu, 12 May 2022
 15:04:00 +0000
Date:   Thu, 12 May 2022 08:03:56 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <20220512150356.GB1395@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
 <20220509105239.wriaryaclzsq5ia3@skbuf>
 <20220509234922.GC895@COLIN-DESKTOP1.localdomain>
 <20220509172028.qcxzexnabovrdatq@skbuf>
 <YnqFijExn8Nn+xhs@google.com>
 <20220510161319.GA872@COLIN-DESKTOP1.localdomain>
 <YnzYM1kOJ9hcaaQ6@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YnzYM1kOJ9hcaaQ6@google.com>
X-ClientProxiedBy: MW4PR04CA0168.namprd04.prod.outlook.com
 (2603:10b6:303:85::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1f1c20e-0d3f-4fe8-89be-08da3428a532
X-MS-TrafficTypeDiagnostic: CH0PR10MB4939:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB4939F919BD7C2B81161F2CA3A4CB9@CH0PR10MB4939.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PuFps+Ic2WoGnWvoS+a+D5bkMgNcTlJIx4uuLjKZ4i5trv8GHxqU+KdL0q40DBHIbLmFzjxCsfYYk7HH5GureE0A7SSCX1NZwZQ3MpRLlo9Pfr9msK9npxOwpQGZhetbLiN6Ht0oVij2OIJz1MTAeLITOb9z/RyJioni832IrmzZqJOSI4nfxxeL/9qveL3/y6mFCCnWiL7owyG7LswQOh1rPfTynlSxIRdOM49KddmCnOIdz2VX897O/HS/P1A33OA25NyoyDtZs82JXGeFv5inYnhw2601fOHluClFjWzzMcwevhmwF00NfnbrqFqiKixoyRYtudeqRdLVZvn4p6ckXr69Sq3eFgdhWdoEPxbEacKV0yjbSy0iOdYNKdq24s7CBxfNNw+5HfMKPNIY+gyt2lKruuqTkfzxX0ZVfMj+l/dwrhDVoQcAvOTgFa0oKga77iPZSBh8R6+i71+XOPUiqP/vCY/zgzRI2GK8GsOBTIzV0ChEglejOHGkluvIxPtylgHhkheTrYcr3zxSipoz4PX02YQ+hqeZ2JEBnBzQVkVvxVNpVlRIwD3MnhHf08w+Eo13fqKegmFmIbH7YhC2ENJrF5bqaq1xyQ3lNSVZTbDXKmLy3z53Ov6IvtjgWeaG/CBvGd9+XotlWYsb2LEX4lshGZ4eP/f653wIvfrS1wxXOvhUFY8KHsvGPLuUWxlKJHhNHlbVqcXtFH57wW4Ui5BMMPeMwnEsIxizZxIicyceCLse93mFUvIBiHNJSGF6xVZjlz9c5k4PmlDWorRHv2nKOKpou+E59YxGt34=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(366004)(39830400003)(346002)(396003)(6486002)(508600001)(316002)(6512007)(26005)(966005)(9686003)(1076003)(6666004)(6506007)(186003)(86362001)(52116002)(2906002)(5660300002)(7416002)(44832011)(83380400001)(4326008)(66946007)(66476007)(54906003)(8676002)(66556008)(6916009)(38100700002)(38350700002)(8936002)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWZNdXg4UDNWeXkxUWRLRDI1aTBZWlhFRmZrSE12QXN5MVFRd1VNTnNyS3Rm?=
 =?utf-8?B?TGR6VTE1NllGNHJHalRwT2theUVJdHJDdHo0bFB5TmlxZEp1S0xKckFFUlIz?=
 =?utf-8?B?bWp0SEV4N3JFaWhKcmtKc1g0RU9JbGIyZ3ZzUDA1aE1UK2RjTFJSRlpWY01J?=
 =?utf-8?B?akhhWWJQN1BQbyttTWVJL1grSnRCV2lMQldHNGFMbG5mQ0FVcS91cmpoUUxq?=
 =?utf-8?B?RVY4Q0NoUkNYYkFKY0dLVy9MRU01cEdybFZUUGlQMjB1R3FpN2d6c3NXQ0ZI?=
 =?utf-8?B?bzhJbXFKcThaamZiTFNUSmVhYVBJNWdtZ2VUcXZiSmI2dzRmOFdHMWl1WkdO?=
 =?utf-8?B?RTJhdjdtZVpyZlZqUzdIamUrbDY2bU55VXV5RkZZYzBWWjB3UEsrRjcxNXlk?=
 =?utf-8?B?dGhKdUNHbTFWZEdHUkRoUTNnNzR1Wlh6NmRXTWdsbXlzZzRuK3F0d3JZNXlX?=
 =?utf-8?B?dCtEQXBabjJ2QVB4K0x0RS9NNTF5TkpXaTNjNzl5WTNEditYOEpWU1Z5azhZ?=
 =?utf-8?B?SFpiZGg2UkcxRlFuUGhhSnM0c0x1Q3gvUUFWa3JqZ3puZlYrQWEvMTBHVGp1?=
 =?utf-8?B?dTlhUzRQSW1mYjB2U1M0RkMvZFZHMjFrMnExQk94OWh3Y3R4eVFMaDhhTWlR?=
 =?utf-8?B?YWFtaGM2ZUFiTzljaWZmTk5kUjAwT0pQd3R1RXdIYmNzMG5peSs0amNxUjVE?=
 =?utf-8?B?MUoxNklRYk1IT2k4bEhyTEdrRDB0VENJQUVodzVuL2NuN3cxd2ZscWlWd3Rp?=
 =?utf-8?B?OWxGQmcrb3QvVnJYcE95UU81NkdTYVhiVEpoeWE3V0UvNStnZTZyYVJZY2Rh?=
 =?utf-8?B?OXM5SnplZUIwY3daaWswY2p6cnJyN3hCaUV1UFVWUkphcTJFZkJCSVhNU2Zr?=
 =?utf-8?B?eDRJbXk5cGxmQSs2bHlTVTgyRFNZUGowc3g3UTU5MHZQSkhHakE0OE9oYW9T?=
 =?utf-8?B?T1ZpZkRSeVVENC9BaFM4V0N5Q2txNWVvS3dyLzIrMHVzcGdXN0lsNWV1aCtz?=
 =?utf-8?B?RTl6SC8yNjkyaHc4aDRBbmIyRmMwViswRkVhTlc5SC8vWmFXbnRmV3R1enhK?=
 =?utf-8?B?STQ5N0xQTjArazJxdUx4ZHpOU2FPRnBPajI1R3AybHoxK1ZGc2pBK3ovSDNw?=
 =?utf-8?B?UEkrTysrOG9pKzUxLyswMVFSRDVzSzRPclUyWDc2ODE0WldaUGU3ajlFcnJs?=
 =?utf-8?B?VCsrQmF0ak52SU9YVC9UUlBhWWlWVFlENnU0SHhvbEFZU0pNOHhMZE9PWEha?=
 =?utf-8?B?YkRibXErMkpFTWpxUDAwTGtoUThrenlsQUFYVlJMMHN0THJrM0NyTW9sK2xv?=
 =?utf-8?B?YjNLMEt5bVNsbTM3Rm5UbjFUT0w3Z3laeEhBaWE2RlNoS3I4bHEwckE2R2lI?=
 =?utf-8?B?S3FhdzFXZVBra1EwSUVHZVA0Ty9LSzZHZExFMnhwZGxqYURvZEhXUzQvL3BY?=
 =?utf-8?B?Z29TRlhLenF4NytnNS9tOS9EZFg0Q0dUQzllcFRqZ290MnRodDQ1SHVGUlIw?=
 =?utf-8?B?QWJrOUtLK3dVNEpzNk1PN2U3U1lCc01rYzhrbmdvemZ3OXpXSzVwTmxzK1li?=
 =?utf-8?B?dGNCb3ZySUNtNmtGdFhjNWY1cU5nTXJWVENxZGhwYWlvWkxYQzdzZjJCS0hI?=
 =?utf-8?B?eXh4ZzFzNlB4K1U4NEo5cFF2ZzJBZHJTWXRNMVNqV002eDRoKzcwcUpabVd4?=
 =?utf-8?B?bnFzTEc4OXZXQnlwUTJ0cyswK01xTHEyVS80TlJFUHo0VXVRWTRMRXRQRkd5?=
 =?utf-8?B?eUovcmJWbldBZURPQmxNZjFDZEFHV3RxMHE2VFdIUTAweXRrNTlMWXVGMVJ1?=
 =?utf-8?B?U1M3cGUwSjFwYklQblF2MEdCbGtacGZJZjRKTkpiRTJZV2lJaGE4K01UOGVn?=
 =?utf-8?B?ZGF1bUNOdG9SWWo5bnRRQjVhRnVWaGxIS25zcDJMb0tST0gxdi8xSm10V0kv?=
 =?utf-8?B?MGlrWHlqMXRxWWN2c0V0OGFzdHNYOGY3Y3BIR3ZqdTVPMU40dDMyZm9VUFcy?=
 =?utf-8?B?cTFmVCtwZ2prVzg5VStvM2FmYlBDTXVkTjFGbE1qa21pcHBsVEdGODdMY3N4?=
 =?utf-8?B?RHdSOS90dHBNdWZReWpSM1dxWlBFN0R0L3Nkc1l3d1A0ZExFRllFRWpkNHZE?=
 =?utf-8?B?VFZPZWM4aDRud0N1bDhTVDQ5bW9acTkxYWlrTzhUV3I0OFRJRVNvU3o3N1VK?=
 =?utf-8?B?em03bTJpdzAyWXRVeUlSY2NTOUdEZC9ybzZDUHhJQVFnM2tKaGVEVjdvV2xC?=
 =?utf-8?B?dTlHZ3VjaS9uSHRTQjRWNFFtb2FybUdaWjU0UjQ2VXI5YzZtK0tvTWZHMzZo?=
 =?utf-8?B?OWk1d1RLSjJ1WU5QQUszY0tRWjBDK1VBOGE0VW5vc1FreHZhTlEyMSt3eDM4?=
 =?utf-8?Q?4wCl1UGmTI/6amMU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f1c20e-0d3f-4fe8-89be-08da3428a532
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 15:04:00.5297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMKxELXvYUXF55ojtP0Z0Nih8InPVbmh6o+IuneRf2b9HP7yulxV3fDH5Y5kD21oOxHmYWrlH95i79Mf8ofyDIN5x+MR2X981LpZQdjS0ZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4939
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 10:49:39AM +0100, Lee Jones wrote:
> On Tue, 10 May 2022, Colin Foster wrote:
> 
> > On Tue, May 10, 2022 at 04:32:26PM +0100, Lee Jones wrote:
> > > On Mon, 09 May 2022, Vladimir Oltean wrote:
> > > 
> > > > On Mon, May 09, 2022 at 04:49:22PM -0700, Colin Foster wrote:
> > > > > > > +struct regmap *ocelot_init_regmap_from_resource(struct device *child,
> > > > > > > +						const struct resource *res)
> > > > > > > +{
> > > > > > > +	struct device *dev = child->parent;
> > > > > > > +
> > > > > > > +	return ocelot_spi_devm_init_regmap(dev, child, res);
> > > > > > 
> > > > > > So much for being bus-agnostic :-/
> > > > > > Maybe get the struct ocelot_ddata and call ocelot_spi_devm_init_regmap()
> > > > > > via a function pointer which is populated by ocelot-spi.c? If you do
> > > > > > that don't forget to clean up drivers/mfd/ocelot.h of SPI specific stuff.
> > > > > 
> > > > > That was my initial design. "core" was calling into "spi" exclusively
> > > > > via function pointers.
> > > > > 
> > > > > The request was "Please find a clearer way to do this without function
> > > > > pointers"
> > > > > 
> > > > > https://lore.kernel.org/netdev/Ydwju35sN9QJqJ%2FP@google.com/
> > > > 
> > > > Yeah, I'm not sure what Lee was looking for, either. In any case I agree
> > > > with the comment that you aren't configuring a bus. In this context it
> > > > seems more appropriate to call this function pointer "init_regmap", with
> > > > different implementations per transport.
> > > 
> > > FWIW, I'm still against using function pointers for this.
> > > 
> > > What about making ocelot_init_regmap_from_resource() an inline
> > > function and pushing it into one of the header files?
> > > 
> > > [As an aside, you don't need to pass both dev (parent) and child]
> > 
> > I see your point. This wasn't always the case, since ocelot-core prior
> > to v8 would call ocelot_spi_devm_init_regmap. Since this was changed,
> > the "dev, dev" part can all be handled internally. That's nice.
> > 
> > > 
> > > In there you could simply do:
> > > 
> > > inline struct regmap *ocelot_init_regmap_from_resource(struct device *dev,
> > > 						       const struct resource *res)
> > > {
> > > 	if (dev_get_drvdata(dev->parent)->spi)
> > > 		return ocelot_spi_devm_init_regmap(dev, res);
> > > 
> > > 	return NULL;
> > > }
> > 
> > If I do this, won't I have to declare ocelot_spi_devm_init_regmap in a
> > larger scope (include/soc/mscc/ocelot.h)? I like the idea of keeping it
> > more hidden inside drivers/mfd/ocelot.h, assuming I can't keep it
> > enclosed in drivers/mfd/ocelot-spi.c entirely.
> 
> Yes, it will have the same scope as ocelot_init_regmap_from_resource().
> 
> Have you considered include/linux/mfd?

I hadn't, but that seems to make sense here. I'll try to get all the
suggestions implemented in the next few days and send something back
out.

Thanks for the feedback!

> 
> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
