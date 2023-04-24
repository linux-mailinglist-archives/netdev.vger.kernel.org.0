Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6078A6ECC84
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjDXND5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDXNDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:03:55 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2134.outbound.protection.outlook.com [40.107.237.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7F246AD;
        Mon, 24 Apr 2023 06:03:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWOXcFagrzQhLvemCS+epAvRnkNHY8tnyXdxRHoTjAtHVzm0CWCPD0V3+qr2ok9dVwGT/gx0qgc4aL3M1wulARjk1QAjlx4oispVpcbCV6l6aMjYyqqi+AhANmfCu33sKvMFfMsfeaGiuwxdZJMC2RJpzmk281zky3w7XE9oox0ap80AJyqRd+Upcova6U4l+nJakOZjEmpzHtNOqOkBOFVH5eXT1Xrd14jgCvANYHoXGG4bEiUPedQ7tY2w7zdBI+Ws8Gn+Oz0wPKZLMzxPGQey27gE8baD+LM59kevGvMUrOBE6rPkcnXSygNxThMCIEE0FwRXiALfocVdsdeD0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ziVu0W+g/gfvVAW/fTkfzrwaomzB0UFoof9GLsFO44U=;
 b=fvWp6dGEQxeC6iQuyRBUh+QIjP0bKOM99WKfww7dwDGIyNf/P1UUKqZSR0O98YQPMCgQy+9ykStJbOYWNeB9KJgHFakb8yaKBKbvOawwhfwUQ6zgLXwOAyI0EaNwXHGu84PK2biAMBE5Zu+/tI2D6w7IKdY1tYqcgsoElX47RAcYSSkNi2C+cxPltOnBL82EsLPQ/Mm62BroCe1PUC53cLk1ydg7M+vdw4nbZVN9k1NjM8ilTbZUhMzZeeRd9iaEKxSnzjX1Zo0vOaqU6UZecq6GFbndNOWLbDqJmNekYnedGtArIcfYAlTp1H5ez16kFy7wmQNx8Yst69picEbDcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ziVu0W+g/gfvVAW/fTkfzrwaomzB0UFoof9GLsFO44U=;
 b=JF33jXWqmeG3SU/n2FEEQ6Yztm4snlzRdA8Og8GF66Vum2Iktg6tB7EXJo6XVgs5ESorciuby1Yi+Zy0TWxvsevhqRdwrmkkcbElAKLV5fyxgbzf/Myt7444fkJsCb1U+3eufnF+ZF86rPlflZ9WfO5KcJ15Xj5HM0NE6+gT/1g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4975.namprd13.prod.outlook.com (2603:10b6:806:1a3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 13:03:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 13:03:47 +0000
Date:   Mon, 24 Apr 2023 15:03:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] can: bxcan: add support for single peripheral
 configuration
Message-ID: <ZEZ+LDyojohzAPil@corigine.com>
References: <20230423172528.1398158-1-dario.binacchi@amarulasolutions.com>
 <20230423172528.1398158-5-dario.binacchi@amarulasolutions.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423172528.1398158-5-dario.binacchi@amarulasolutions.com>
X-ClientProxiedBy: AS4P195CA0023.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4975:EE_
X-MS-Office365-Filtering-Correlation-Id: b95aa3ed-5df0-4fe2-6a2a-08db44c45712
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jHEEkw2AoNpu8Ch3TLSQHXcUX+xYknJ+Oh9Fp+Rmt21FRNZQgx17RxacZQ4SjM4wM1ASeQVgeTC036inEsN3mdR/M8Vpwvrgbsv2cvOh7Rhw+iKwcefzU0fU8J9xEdf4rb4opZaYfXILhQ6Cmigm9W8xfQvpWj64VgDtoowjJdeHBIOgafxpPVOA5SqoVqvlA/po2LTMVKfevgGR7GBMcptDAni3a9CPCXK9SEB1dumW1bibVdrsVAGoHseafr8E0LudDdxD4uICkW95FZqs0JxZ4DMOGlsm8l2PA7AKw57hWZh1OXPUvOIzkbgnzDQ+yvLO02Hxbkmn1kNUdk//f3pFsrH60Oq7Kn7k5/c9UOsq+7iz3R9mGe27jDqD5mrZDLFVKkG/N7H5IcTRLfpVOCm6yNUmYDF2NOP2bQUSP5u9BTpuz/BVr8PnMcdDWJb1s218jj9ggSAcpN/M1sMUw5gSDxtLSk/go7RbFTvC2MqRE6TC0uTya355tv6RbIRQe0HXJVQsJNGOD8fBW80RobYCPkIMcU0mFBgTE/hd1f0NnDk7da9ueckwV2dkktSiocg13D32Bo0lfWTB68Voi5lhHE4OaJzhlZCtBmxV1dhceoTe0LHgRLVPSFczo9Ry5c25UyCffA21wnHxQHJ+R3InoJVZ2Qf0tbZpAG2outE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39830400003)(136003)(396003)(451199021)(478600001)(54906003)(86362001)(36756003)(186003)(6486002)(6506007)(6512007)(558084003)(6666004)(4326008)(6916009)(66476007)(66556008)(316002)(44832011)(83380400001)(66946007)(2906002)(38100700002)(41300700001)(8676002)(8936002)(5660300002)(7416002)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dowNbmjH0F2UvBLnqpZatC85OaX/0IkprZLy0/xTMOsCFxDyGlET8VWg8iZ5?=
 =?us-ascii?Q?nWjSWIFfDZPx5gaDDkVXwOURnOfaKcGMXG7FlVkrDGY51Jsvn/gSxoJuU3Aq?=
 =?us-ascii?Q?5Pn+hddUCEP7SX1BvxK8RyA7GR6/oSK6WKshT1K+L6rEBb/NqbYiT4gzMVU2?=
 =?us-ascii?Q?+x6Hc0gFRzSSp/od5WwbhtgaGhpO5RIyOjCEMAXEFAoBOczqTP9TLQPKhT1t?=
 =?us-ascii?Q?i74NNFdyUs7pMFuNR6E9UuinD4OwJ5NuOiV9Znf80lGBU1Vfck9s6QAV7WbL?=
 =?us-ascii?Q?kUG75VEmPEw4zNqYQgqTgvOAMfpey4zULlcw6raBpq8Z70DBR5UGPIF5XDQd?=
 =?us-ascii?Q?1b5Wjl+iGQrsdcfSXz32aAlAsEZ3KBq3MxcskpV1bbcayrYi02U16xND1k95?=
 =?us-ascii?Q?LILr0g5MvEJnMovMQAuGv2P0iMyrgNd1VIeaE9McLAYgb3cCojGCsZWBMTPf?=
 =?us-ascii?Q?abHXIYk17APSIXBAPoSJwjLcyi2qw4U9ynQgcrWibvL3fZqyfkeDsJVqBeS+?=
 =?us-ascii?Q?aagpGb4bTpKNgH6r2N+XVNTES49qe410IoG9QyP6n1DizTXA7kCjNudZLn7s?=
 =?us-ascii?Q?rVMKvfIg+3oU92KeNgE5XDFFCvEZu2nXmOij9X/7pf0eG1mVZ5emj+iFi8UO?=
 =?us-ascii?Q?4LKTWlBXq4WZH48wv+NBVLmiJ2oFYNb7Ds9rqhxLetpW7zM2+NH6KKr1FFDa?=
 =?us-ascii?Q?kBWAsirqQtb1IDODOpbePTa38kde1TF8bZeHmdw8d/NygUZvF5aTm5zZATRx?=
 =?us-ascii?Q?plSiLz76wNUlWt3kEB2ixEsiJ4PLcfSg8shgL5tp/L5jgeh1S7dRT4cICnbb?=
 =?us-ascii?Q?a53gSfjV9y0JdSCpq8dwtfNEbl6+suF+3VZa21lf37vL6/K3ulMvw9hkSbaw?=
 =?us-ascii?Q?Dr92iDCvsyuHKUPlpP0Wg0xRTODI79182vnBZaoXQxH0ukKMwTmIjOdr8+oS?=
 =?us-ascii?Q?u0ytEwvtsoAmrFXfINJcAh06M32ICtHWSKZqphN/SUsNne/lVpNB8OmMJaYV?=
 =?us-ascii?Q?LkWdNGz3LiXBobeRTDM/kkAwhFiorn8fLS5SzD/Q1KZNHMmURmaq7ItgPmgI?=
 =?us-ascii?Q?oAKqhZnJXYPpsBES6A+Hy8Wd0pff++GzSVoXxVYu8iQyyJwR+mqehcJVjIL6?=
 =?us-ascii?Q?9BbDnvT9CLOWuqGmCOIk/WawBKitb1a7XhMWna3ndpS0vjZ0tUIiH4/llsC3?=
 =?us-ascii?Q?OEnJRGCUfYgPWYjj4fF78XKdbRrnCQvaKgZkxgK+XtSqsvm0rD9R9/baYawq?=
 =?us-ascii?Q?H/y0iQNzT6DuGNz5uAYoTet9R/8uEggatYdYz91sNCiT+V12YKy6ZClSXezy?=
 =?us-ascii?Q?Nn7giLl7hZM4Xlpt/6XborHnT1qKMZMMH8KCbXC/Fq+3sMg0QQacvVHYeTi3?=
 =?us-ascii?Q?qABohIemZGyF1SsNA64mwFFtIpGl+cSC/TKx2Z2SQWuN4Vc9DHPr0umo0mLX?=
 =?us-ascii?Q?s6SxEJFOzEaxWI/LT0VliPmCm8lb8xjyDScAowzfHb1ifp61AJnTwGuxIluV?=
 =?us-ascii?Q?rI1PyBKlxack2iH2SgDND+JYbL6+oeH7HSY258WAVRK0vpesO7moJdOR9FAd?=
 =?us-ascii?Q?hVjavqzRHg8BOP9d2c0dQoWKL8U983LwbXLFM/4kV90gac9evJF50ko6yUNv?=
 =?us-ascii?Q?XwKNhV5pk0QenlAzjHXwoSFhBiXkscOXRPLQWC1XSlRg91Ex9ryvcwTyYE+2?=
 =?us-ascii?Q?20WsKw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b95aa3ed-5df0-4fe2-6a2a-08db44c45712
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 13:03:47.0297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zvfhy0fXPovblryafedBr5C476x9Tvd7U5CrgPz2pAHrE/g3CsGhIHV1BDO4W6c0JXXGc3CeVZbWDzpuOuvHyyt70NXobyjtQ1AVTrDIoGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4975
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 07:25:28PM +0200, Dario Binacchi wrote:
> Add support for bxCAN controller in single peripheral configuration:
> - primary bxCAN
> - dedicated Memory Access Controller unit
> - 512-byte SRAM memory
> - 14 fiter banks

nit: s/fiter/filter/ ?
