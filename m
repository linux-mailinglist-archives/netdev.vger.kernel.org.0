Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352A65B217E
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 17:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbiIHPE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 11:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiIHPE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 11:04:28 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2129.outbound.protection.outlook.com [40.107.94.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E972F6;
        Thu,  8 Sep 2022 08:04:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lj8+n/RMFi+/vH0vifTOIYhEz764nAIgWFLHZr47EozememKcL36sHOX7OYmox9euAEAAnF3nSVUEXy8XCB1lEqPl7GIwUOkHwR0YbIwqveOpD/p2HJPY6dxC11lhRh08oNc8YhegnMAHtoOeAeg+vuxHHsiYt7GtwX1JYL4UwFOeP7h+PiyXjRFvR2RA3B9krzhq+ceMGgzEMxqMJnGGx114HS0JWSC4b+AqUxQ5oA6OmdLVoRAsis4tRDjohfg2JF94aGCWkB0G9SqAcE9IgCvuhnsCV+0ITpVoQ5v06kzQDkZkWZG2ZDjF/1zynKo4W7CZGTKbrgG9ZDJ8xGsQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItOH2Lz1bJTErRwdLkVe3O/p5AKP5HRD4vzYsMDL7J8=;
 b=QT3hJHWxsxu6QG2CFG7H1jkVYC0qmMwWrZzmU2gc+8VSt4ROtD4wUlqlmh2Jw6cv/XilG8UNkEblJENKLlYt2PSQ/AvRiDwwmILHNAnlR5xKGEXagJLFoOxfopcWXoHs/UzES7yhl6g76Vc17vEKmTu4eb/QvTDLZRZpup9WmR1wDAJs/SxpZZvWkc7cr8nJcav/TpYwXvzxgq/DIMZmAh3At8p5nXXZE4c9k1NCqsNsg27l6vUlWfiW6qn17QUoZyeAR/lfVzNlvrJfNNiiR06eDDQwp5TSX4X0YvKg6eD14D1wUAaPS1VnCRKnhf37wrDrzmyPNCbBJl8NRUW1/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItOH2Lz1bJTErRwdLkVe3O/p5AKP5HRD4vzYsMDL7J8=;
 b=IGcBX2aczbytWzK8XuVWVywwJAgqfD2AkFZN+2mvrryVCjgs+gw3BGkhdZeb5gzKjjkLMRt86Zwjdw9wRUmvTOW4CWYj4vEakhL/DMQJKrN0qzKB8O31bJPMD9mNxXJJios3UV1itICHIP4AhfGp0OfO6CDQ/iAV9WudzEcXwLo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5114.namprd10.prod.outlook.com
 (2603:10b6:610:dd::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Thu, 8 Sep
 2022 15:04:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Thu, 8 Sep 2022
 15:04:20 +0000
Date:   Thu, 8 Sep 2022 08:04:13 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Lee Jones <lee@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RESEND PATCH v16 mfd 1/8] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <YxoEbfq6YKx/4Vko@colin-ia-desktop>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
 <20220905162132.2943088-2-colin.foster@in-advantage.com>
 <Yxm4oMq8dpsFg61b@google.com>
 <20220908142256.7aad25k553sqfgbm@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908142256.7aad25k553sqfgbm@skbuf>
X-ClientProxiedBy: BYAPR06CA0069.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::46) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40459e03-0976-4a2a-81b6-08da91ab6831
X-MS-TrafficTypeDiagnostic: CH0PR10MB5114:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OW+RTij8GHaFU20YKsaa4b4D4UvMPcty+Cgif8y8wPYlBHazntyLhACPLztaAkf5C177O0PFTKUtKEro+/F81Id+GmDhyejODL55sx9uQR6PiRkp4N9rmnQifgOz8jkoJJ3pBR5FoNsk8eDrc1B2YC73jUr1iDRweiCJeV9nB/cQoQAlQyf78X2pbd2HpS381la+1+QcLP/GEA7BBWYBq4/8t21fEy65vNjP6ACQf6kFy3UKC4f0kke3ilRrl2xl81QgcN5IYwI/O+KIAuA2GZ7y9KhDYkAmI8IzGhQyyTDlhT+AaRld6SZZosbN/7E8yzabeuA/SRnHsVQw80hCvjpjeTsnpMS86b554z20j60PkgZe3SvMp/l7MIH++5WmC8i+WWo4Iq8sfnAM2p6mkEhVmY/Gt/4phOZmpIpgyTFMcUYLrx8JjcS5+ZTHXF4YTKd7qsQToPV3FDT0LtC1lTN7I/f+ekDfObBhRyVxJGAFAE72MN6G0RPMQJhwlv3jGCpJMgLD6fVMCQNOqVqVGXIAKc0eA+EXHGKNf45zlarYncIIHT/IT1y0yFsa7rG9hNRbvDYCjgaKwOb+z9acpR6WEbEGczzNEVLLSNywAM1DdhdV7JfwKM0A5rb77ylJp+bqXP6b7o2GIW/JmjG+kTuSSi0hnkoBBEnUbEeJTQdMUcOIvpZe4X3eb/d5NHzqjC1J8wYNNiYmTmTdgcQPEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(396003)(346002)(39840400004)(136003)(366004)(38100700002)(8676002)(4326008)(66476007)(66556008)(66946007)(86362001)(186003)(83380400001)(6512007)(26005)(107886003)(6666004)(6506007)(6486002)(41300700001)(478600001)(9686003)(6916009)(316002)(54906003)(33716001)(2906002)(44832011)(7416002)(8936002)(5660300002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w5Ygj1KAwvwSh5STiUWhpnPVFHVaLViRH+FDy40h3TU9HDnJ91ix/uhN+nOs?=
 =?us-ascii?Q?yP2NKc6jA5D7wAs71Sztq9lLxb8mH9R5N7SKFCyRFbGxtp4Q9VODbskE99nn?=
 =?us-ascii?Q?tTY/8iFqQfiQ1VFS+WaAW0D47XA+qz1XZZe7S5kV+gG4wic25em6SzrCLAAa?=
 =?us-ascii?Q?txkU9XIh98eeRA4sxmyjpkGXmdOLpBDNNdIMQ2sWBvjrkDggDDIfjv1cumBL?=
 =?us-ascii?Q?kcPrLJ1qtwtlhgJAnpvCk5WrxrlRmGOnZuOqgJi4TDIU4aPq32HiZ6zlcDKW?=
 =?us-ascii?Q?uJHqBgg8r1MYChXVA81pku2ZRi/D6aYAv5Mjm8avQ6RfVrmNGQah3XA8rK0L?=
 =?us-ascii?Q?LqqBU81mgzCOIiyLEUaRXw7jZYS6STbV4tVi5/dGBM/OYnYKQsarOdupFIgL?=
 =?us-ascii?Q?dV0D7hWj50GvsYKLd3f1pm66V6YsMxJZd5YfNgqfjo0axurEEntjkctB2bSe?=
 =?us-ascii?Q?Y2PhXUZ8T7sooUVzhnm3Z0yvd0llrznpg6tQD7ydRNx+sdvqtJ466DZ/ZiWQ?=
 =?us-ascii?Q?CdNSMvvlbFRDpDCPe++Mpiaw1sKGMW6rqmgcIWNZGUGw+ape4QmCiGMRVxPY?=
 =?us-ascii?Q?0K1c0YsFotfxaZW8buYYscJ23jvHERY+P39yEuldElwHow6W8C5qKiRTjm2j?=
 =?us-ascii?Q?n1O5qZXKclDblJpsFBoGfmGnPJiTEzqWNvw/hAE1vWTIkcAHyrkQdkdh+sD3?=
 =?us-ascii?Q?vTv1hz/FiNjB4sdaNlc1jrs1/lVIyvU5rMYrvEVZCowV6Y3xSnTtQRZM2Fij?=
 =?us-ascii?Q?mmAMOMm3XURPmUWmmH1FPOWbPm+F7J3uDf7k1ejcwYi/1koMRdw1nKdF7kQe?=
 =?us-ascii?Q?RjF9M1k1X7elx2pKn0xVrp2OCve5cFZ8mx+VP6LwsAoZMBa4RHKIfa1wVvH1?=
 =?us-ascii?Q?tFPvXp0UwqNKGs5H2dVUbk10N0i61NgToTSSKATiPZS2cU5iYA7YZ42zLmMY?=
 =?us-ascii?Q?1z2T1d3Z1NWGlPXPSOZB5NXUZXEldMMcs8YwWYHmO28lcNkdtaOS7iKUTo8s?=
 =?us-ascii?Q?pD7mbL+JfaXm5x5ZtztgT0YJP1IW8OZLqViFIg+XB+t+ufD3k2fulYYsJ1W5?=
 =?us-ascii?Q?a5GJhUp8BnOas1rfpKz1HbgSV1THIXo/LD4Rge22qtsolH5ylBiq2NRfF2Gt?=
 =?us-ascii?Q?xQe5kV8cxao47qtS2J24+qOF8f2+ykPwKDm0izMxvif9Ym8kevnPHP2oe6f4?=
 =?us-ascii?Q?J7B4nVBA1baB/br8kNF+jXS1IruS32Q6oBWwjow4EjJYO5pNO/uYZa7/7dxT?=
 =?us-ascii?Q?DG5c0Z2Rbjp2/S5oPQAAOaGflPE6puxFhKmj4rbuTbKv8SgsGdv6KW/+/nTz?=
 =?us-ascii?Q?vbljENut2d1JgxOwie9yBSSgfDPhrJBoXDXBaohALXim143iGXIsWYi0QpOH?=
 =?us-ascii?Q?htfBLqZeDHsoQfsVmuOK1FCBURszqi+0YkrYXDeJHP3SQ/c6K/6qPKYb2QpF?=
 =?us-ascii?Q?Vx7MpoEJaPNtYnZlEoS/wyivtNhnk7usJsHFHAYGKOo8QPtd7i437l+VKS8x?=
 =?us-ascii?Q?Xrr1kJhnKH3rPV7A7NIVG65VnNzauDZ8AGsO5hgMYqHzTRjRjRNyA9BrLt8C?=
 =?us-ascii?Q?vMWVtSGgjYtiw8OasnL6lkp66hFtuhXJ/g/EmFDNZmnB5vV+bh94K5+Ncgbb?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40459e03-0976-4a2a-81b6-08da91ab6831
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 15:04:20.2356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4F9isRFW37vcwmPG+SdZwEU2vswaHjrGHuNyyPHdhAFI7meei+CzKrEitCxj8iyjjqaN0J59srRcSCfUgfRg5nNgs7wmN+WeTwXHT+d6Bw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5114
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 02:22:56PM +0000, Vladimir Oltean wrote:
> On Thu, Sep 08, 2022 at 10:40:48AM +0100, Lee Jones wrote:
> > Applied, thanks.
> 
> Hurray!
> 
> Colin, what plans do you have for the rest of VSC7512 upstreaming?
> Do you need Lee to provide a stable branch for networking to pull, so
> you can continue development in this kernel release cycle, or do you
> expect that there won't be dependencies and you can therefore just test
> on linux-next?

Yay!

My plan was to start sending RFCs on the internal copper phys and get
some feedback there. I assume there'll be a couple rounds and I don't
expect to hit this next release (if I'm being honest).

So I'll turn this question around to the net people: would a round or
two of RFCs that don't cleanly apply to net-next be acceptable? Then I
could submit a patch right after the next merge window? I've been
dragging these patches around for quite some time, I can do it for
another month :-)
