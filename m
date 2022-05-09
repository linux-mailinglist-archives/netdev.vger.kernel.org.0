Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD205202EF
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239388AbiEIQxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbiEIQxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:53:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2091.outbound.protection.outlook.com [40.107.93.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A40923AF21;
        Mon,  9 May 2022 09:49:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EL4EqAajj8LxxPPvlY636h7McFilWgbXrG4Qyhasv863KyOAkHnQ8eTorDQKO0cFwJmDC0Y0rLG1D29LoIRBZR2W1xs9XBMhfAIMwWjgqSivKb2Vb82hs1ChdkXmcC0Ey7b4wp/j+BEeEaqRtm41INS2HjLcRk8hKpGNE1yCKvl5mIf0WkSqPQdj02BcIH+5D2rdUJNSkk9h8I7xTsU0egSgZi/YNAPAFc9rj3wPZ3sceccnJFgHWVJ0mvhQRpF5WNBNCxpueWv5qvCuP1IWWmotk9VoR3XrgrKSiKAJxmiJrUxEhIVkoI41IPGFlXzho3n1NA4Mi9sI3BxkMtao1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MyMcV8NGa/ciD5LbuVWeueij/ChyDx8RMw0vYn2+ve4=;
 b=RVkLw0PoxH5ghoyMvIF1g+4HTH7xvKD6ffClRDRtokLvdz/zFFCnQpHjFdBlNZ5cjF3DZRBUemvFUElbQj9p28wUQWh4fwK44qGAQM7v7biA7zeZjxW1j83Zwia1CtgH9mh+7O3BOqLZnhamX6PFoW06w1xDmMxZ+GzC+BJql565bbvf4yhS1HEJM1XLGeIx3tOdCYLtTWV6URmxnxz9ZnuoPhY6nrTWs463wyDssAiBzmz+de7eI0M3dOVTXAKehB+p9JgXihxzmqYJaTNxHEdH/2HZ/5FLfMiYZAr2EfkmX4ssWuHWY84csw0f+531eFkbAoil7/8IIwW8+yvL2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MyMcV8NGa/ciD5LbuVWeueij/ChyDx8RMw0vYn2+ve4=;
 b=Ml0V48ltDFdKgPn2um3grAO3fv7DLg48XNgP246Mxg+FUDftMubM4E7Jtr08QBeEMiYiCP0xTSXzulC+nDtuIApykfoew1STYpW6VaKlr1rNid/OjLKsg9VDNd/zfeXFQ4E11zx7OaystSC0zhr3chvMzvzTJX6DOgJAOC+8cTc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3387.namprd10.prod.outlook.com
 (2603:10b6:5:1aa::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 16:49:21 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Mon, 9 May 2022
 16:49:21 +0000
Date:   Mon, 9 May 2022 16:49:22 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
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
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <20220509234922.GC895@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
 <20220509105239.wriaryaclzsq5ia3@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509105239.wriaryaclzsq5ia3@skbuf>
X-ClientProxiedBy: BY5PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8262b62-b2b2-4a2a-938a-08da31dbdd57
X-MS-TrafficTypeDiagnostic: DM6PR10MB3387:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3387A13B2379D12500B98333A4C69@DM6PR10MB3387.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Os9i0qANsEezN1Xcmgs88C8kq+Rj1yU59/fDb4iZiNtM7pRS1uoPGvxQJo/BA8ZRct/g2DtMP9/bo7hhEReJ6luHmN/u2OraIyhvmVlGc54M0XdBKt8d0PYYDC1F3DWNlPmOtbvxJWJPHq1erc1Jz8s8P5c9OwxyHfBEV6rLZpF0p5TnZzTRlr3zEypTaZeLEDYAHWlVYIcxre4e9hHegxLi0AE88QglCUGTR/xnjTq56Bg+Hb9YeCcjAsH6VhNHJp5QwUw3iTXOJMy+lrx1O9GBK/7UMr+E6tceaiu2oa0oCVnpVL56j0HXmk83TBqZ8ft9DNuitYPePDKTOfxOEgRA5JWcni7FJkzPExrC0p8AFcQFAn4gmWAvGUcRi3A7ts/iVkzHK/h/N2TRL5zEg1PrfJ+3H9fyOjM5Onjf4NaECKWseOmNAvdbgQX225bjHDs8/dYFnH5dGSeAX1V8RH0R7RCFJ0PwZHbIMZDMlgD3x7wmFxbN0Zm8N0rjuiLVzDbqdOPimTYzfS8Y10gMF6tf9U2P4w6fpuscOD6Ts2iB0ehrtXqvdwHuGJzaUGU5hk2gA7nXAPAOcdmX6FyV09bgwtd6pw0AutQ1fC7G44rcJVXKQr7mQJCgdsKzsHNHAn/oY7r9iqotA1NVWh82peNyhD8ZpuGW77pOaLS9VNNAZw1HHQXHMSQWMAXjl0ewZzWQdWGaiBxKLex9nK9qBM7FBhR3p9H8uHPp9A3Amyv9RkyNx8c6Dw9P07PmQtEnBskbvN97Wl/DVoGNgGl/qR65CvIANfqz8CLm3V4fTX0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(39830400003)(136003)(366004)(396003)(376002)(8936002)(508600001)(9686003)(8676002)(66946007)(66476007)(52116002)(33656002)(66556008)(2906002)(83380400001)(54906003)(6916009)(6512007)(186003)(4326008)(6506007)(86362001)(316002)(1076003)(5660300002)(44832011)(966005)(7416002)(6486002)(26005)(30864003)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JmZ2fBO2YO7F1wfEqLRQ+k1M5ugBLfXyiIK1xCFVB0JeXW1LygHFMObIcfKD?=
 =?us-ascii?Q?h/E/SlrVfBcURg82C2X6dsXArm9oxrQFdxoLli4Z1WE0Gizfu8q3Kiht+0xe?=
 =?us-ascii?Q?1i5w+iAO1429Cgu0F9BN2TeNj47ShsF2/hB7LD7yIbnOuzEDV2cJ0Bunclhk?=
 =?us-ascii?Q?trJcOnzeS5I9ESZ9rNAkrwCGZ1BTMPZ5y1j5weJVIJeoFmPScBuP7rf0LRc2?=
 =?us-ascii?Q?Tl603ObJQXX+4IiQPZxt8Gc87IK15llQ5E/1WvsLagoQgklABz0Y4Bnfxc1J?=
 =?us-ascii?Q?Y1z5YOHClPUhUWoBngBm3LLBzzGgzhSe036gLKqGp4qCj31p4OKt9SbXtKvm?=
 =?us-ascii?Q?9QGz2UNepwFDjTRYOBgEy155h0ULtAXMXhrdn9AZM8EANptnPYi5rUCAlXzQ?=
 =?us-ascii?Q?0sZU9g1ZLcNuM1rvNhIs1DqnC3AEHgLjSBRydPwl/+/pRqWTSChx6s+FvQSo?=
 =?us-ascii?Q?YOCuS3U/jBuqUc64DR/VrkeFJ42PAg3OoMXmwjOHLwaov06QlkLJcB08D1j4?=
 =?us-ascii?Q?aJL0Dht3FUnFxHedVF9I5xFWoKMNaIvnf4oMKyfD9OgvtPnzEG7L9vsRJtaL?=
 =?us-ascii?Q?BEk1sIGXTX6i7EdIpHwgF3GYEO4qJDebQgXbQROtLyTG5ykaRvjPWwxW/Ye7?=
 =?us-ascii?Q?OGvQxgBfAuAZM+cVdbr+UmB9nPLRQutFmLfqIFej8Q2J435dedo2nL3/UyCB?=
 =?us-ascii?Q?uWfnjA3uT5f3saGILoiy3gKjkVIMfAzwZjlF1J5aNn6PyhEuIo2TRqB5t+gG?=
 =?us-ascii?Q?OiMclvNgERutkNCQx+tVCysgo0DMrXKUTbwhBFruoFbEMyLHOUvtnkLYA65q?=
 =?us-ascii?Q?AWC6HbHQ2U3deXCjGxZA/mv6UNZJOYF3tVKJNN8cgkAbe3a5h7+6KfzBZZv1?=
 =?us-ascii?Q?5d5WkR5aymNCkSu0J86CwwQ84y+FuIWmrAjCHvNQ1YKFQTw9IaxgYFrZlr/t?=
 =?us-ascii?Q?rHPmzHQUmFPJWK4MYXBFL3Of4OqUcy982G757yKV9W5a/+zoJRRFuoQar//x?=
 =?us-ascii?Q?tG4sp840/NSNX7CUhzUI4gWOkIWtGr/aPHEco4XutuW34ov5dUXrZYRZ+WXh?=
 =?us-ascii?Q?04IzOA21xf6nxI7GpRBlbHh9nUu0rZgxurR8mlgDjpf02PmrCCGnvPqKYzxq?=
 =?us-ascii?Q?IOqyeewEHL1xqHPkdA19kno5RryG6FEiW52qVhbxwvVa7T8kxdw1VzEkaCTI?=
 =?us-ascii?Q?cDpqzKZEZFJOU2OEWZ9mQHBAiM81ShD2aGoajFbs3VqPUk6Cob8xIotCE1V4?=
 =?us-ascii?Q?GrXHLdZXW3HUju7t+DvfVnAYE25hxtqQhwLbul6cs4eDnkkx6QK1nFCNpvcw?=
 =?us-ascii?Q?5qoJAEKJVterqbvzmenT59PMdb+NobscaUQSM2j8XM6j9aK36U571me6Jhyx?=
 =?us-ascii?Q?FNDVI7MP+94CGBe4W3LHjFHZYFQ0sUbEjsSxZHbuZKsViXJScM/Mxpw5uNTD?=
 =?us-ascii?Q?uru7WUVeUV+qCprlQC0DUBzMAtfXJYyWEE8Rl3t6zSgKfI5YeGDc6pSvYrkM?=
 =?us-ascii?Q?s7yAarBpGweP56OBQFqHEepBWF0+ycJRnW4NqMNCUCo1Z12atihDwRF/5qe5?=
 =?us-ascii?Q?Ahjm6NWAWXqBohOqEeq/LYgRcUypjFvjZxg9hTBufQD44Q3KlQLTXZyS4cQc?=
 =?us-ascii?Q?lxsN/+mUJN+4Bg5iDPhnVQeB6Urnq+E0hGQzPjRwgSZLa1luY4vo9ZO9Ly9v?=
 =?us-ascii?Q?pVUCASENPDdvBlank1x3zjxC+THeWzIjIp1nw0H6M6voxLo4KZVCvjT9X6ft?=
 =?us-ascii?Q?5oUmXusJEo9zp2p7XZkVqbbi0tijuaWvoaIxZkzP0qagW97qsHpv?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8262b62-b2b2-4a2a-938a-08da31dbdd57
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 16:49:21.0574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WtlbiT8+nBER5/16PRKHyAQojxmLQ3Sq+/8QCnlkyHjnTE8Ykr8DmGEqSAu17OCS1eoSaskvte2BX59xrrtBsLYs2Xe4qEBvnPIRqtJRYoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3387
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Mon, May 09, 2022 at 10:52:40AM +0000, Vladimir Oltean wrote:
> On Sun, May 08, 2022 at 11:53:05AM -0700, Colin Foster wrote:
> > The VSC7512 is a networking chip that contains several peripherals. Many of
> > these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> > but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> > controlled externally.
> > 
> > Utilize the existing drivers by referencing the chip as an MFD. Add support
> > for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/mfd/Kconfig       |  18 +++
> >  drivers/mfd/Makefile      |   2 +
> >  drivers/mfd/ocelot-core.c | 135 +++++++++++++++++
> >  drivers/mfd/ocelot-spi.c  | 311 ++++++++++++++++++++++++++++++++++++++
> >  drivers/mfd/ocelot.h      |  34 +++++
> >  include/soc/mscc/ocelot.h |   5 +
> >  6 files changed, 505 insertions(+)
> >  create mode 100644 drivers/mfd/ocelot-core.c
> >  create mode 100644 drivers/mfd/ocelot-spi.c
> >  create mode 100644 drivers/mfd/ocelot.h
> > 
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index 3b59456f5545..ff177173ca11 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -962,6 +962,24 @@ config MFD_MENF21BMC
> >  	  This driver can also be built as a module. If so the module
> >  	  will be called menf21bmc.
> >  
> > +config MFD_OCELOT
> > +	tristate "Microsemi Ocelot External Control Support"
> > +	depends on SPI_MASTER
> > +	select MFD_CORE
> > +	select REGMAP_SPI
> > +	help
> > +	  Ocelot is a family of networking chips that support multiple ethernet
> > +	  and fibre interfaces. In addition to networking, they contain several
> > +	  other functions, including pictrl, MDIO, and communication with
> > +	  external chips. While some chips have an internal processor capable of
> > +	  running an OS, others don't. All chips can be controlled externally
> > +	  through different interfaces, including SPI, I2C, and PCIe.
> > +
> > +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> > +	  VSC7513, VSC7514) controlled externally.
> > +
> > +	  If unsure, say N
> > +
> >  config EZX_PCAP
> >  	bool "Motorola EZXPCAP Support"
> >  	depends on SPI_MASTER
> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > index 858cacf659d6..bc517632ba5f 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -120,6 +120,8 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
> >  
> >  obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
> >  
> > +obj-$(CONFIG_MFD_OCELOT)	+= ocelot-core.o ocelot-spi.o
> > +
> >  obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
> >  obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
> >  
> > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > new file mode 100644
> > index 000000000000..117028f7d845
> > --- /dev/null
> > +++ b/drivers/mfd/ocelot-core.c
> > @@ -0,0 +1,135 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/*
> > + * Core driver for the Ocelot chip family.
> > + *
> > + * The VSC7511, 7512, 7513, and 7514 can be controlled internally via an
> > + * on-chip MIPS processor, or externally via SPI, I2C, PCIe. This core driver is
> > + * intended to be the bus-agnostic glue between, for example, the SPI bus and
> > + * the child devices.
> > + *
> > + * Copyright 2021, 2022 Innovative Advantage Inc.
> > + *
> > + * Author: Colin Foster <colin.foster@in-advantage.com>
> > + */
> > +
> > +#include <linux/mfd/core.h>
> > +#include <linux/module.h>
> > +#include <linux/regmap.h>
> > +#include <soc/mscc/ocelot.h>
> > +
> > +#include <asm/byteorder.h>
> > +
> > +#include "ocelot.h"
> > +
> > +#define GCB_SOFT_RST		0x0008
> > +
> > +#define SOFT_CHIP_RST		0x1
> > +
> > +#define VSC7512_MIIM0_RES_START	0x7107009c
> > +#define VSC7512_MIIM0_RES_SIZE	0x24
> > +
> > +#define VSC7512_MIIM1_RES_START	0x710700c0
> > +#define VSC7512_MIIM1_RES_SIZE	0x24
> > +
> > +#define VSC7512_PHY_RES_START	0x710700f0
> > +#define VSC7512_PHY_RES_SIZE	0x4
> > +
> > +#define VSC7512_GPIO_RES_START	0x71070034
> > +#define VSC7512_GPIO_RES_SIZE	0x6c
> > +
> > +#define VSC7512_SIO_RES_START	0x710700f8
> > +#define VSC7512_SIO_RES_SIZE	0x100
> > +
> > +int ocelot_chip_reset(struct device *dev)
> > +{
> > +	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
> > +	int ret;
> > +
> > +	/*
> > +	 * Reset the entire chip here to put it into a completely known state.
> > +	 * Other drivers may want to reset their own subsystems. The register
> > +	 * self-clears, so one write is all that is needed
> > +	 */
> > +	ret = regmap_write(ddata->gcb_regmap, GCB_SOFT_RST, SOFT_CHIP_RST);
> > +	if (ret)
> > +		return ret;
> > +
> > +	msleep(100);
> 
> Isn't this a bit too long?

A few orders of magnitude :-(  microseconds != milliseconds.

I'll change this.


Actually I'll need to do more digging. The manual talks about 100us, but
doesn't talk about SPI. My comments from previous submissions say it was
adopted from the PCIe reset procedure, which says "The endpoint is ready
approximately 50ms after release of the device's nRESET" so that might
have been my confusion. Thanks for pointing this out.

> 
> > +
> > +	return ret;
> 
> return 0
> 
> > +}
> > +EXPORT_SYMBOL(ocelot_chip_reset);
> > +
> > +struct regmap *ocelot_init_regmap_from_resource(struct device *child,
> > +						const struct resource *res)
> > +{
> > +	struct device *dev = child->parent;
> > +
> > +	return ocelot_spi_devm_init_regmap(dev, child, res);
> 
> So much for being bus-agnostic :-/
> Maybe get the struct ocelot_ddata and call ocelot_spi_devm_init_regmap()
> via a function pointer which is populated by ocelot-spi.c? If you do
> that don't forget to clean up drivers/mfd/ocelot.h of SPI specific stuff.

That was my initial design. "core" was calling into "spi" exclusively
via function pointers.

The request was "Please find a clearer way to do this without function
pointers"

https://lore.kernel.org/netdev/Ydwju35sN9QJqJ%2FP@google.com/

> 
> > +}
> > +EXPORT_SYMBOL(ocelot_init_regmap_from_resource);
> > +
> > +static const struct resource vsc7512_miim0_resources[] = {
> > +	DEFINE_RES_REG_NAMED(VSC7512_MIIM0_RES_START, VSC7512_MIIM0_RES_SIZE,
> > +			     "gcb_miim0"),
> > +	DEFINE_RES_REG_NAMED(VSC7512_PHY_RES_START, VSC7512_PHY_RES_SIZE,
> > +			     "gcb_phy"),
> > +};
> > +
> > +static const struct resource vsc7512_miim1_resources[] = {
> > +	DEFINE_RES_REG_NAMED(VSC7512_MIIM1_RES_START, VSC7512_MIIM1_RES_SIZE,
> > +			     "gcb_miim1"),
> > +};
> > +
> > +static const struct resource vsc7512_pinctrl_resources[] = {
> > +	DEFINE_RES_REG_NAMED(VSC7512_GPIO_RES_START, VSC7512_GPIO_RES_SIZE,
> > +			     "gcb_gpio"),
> > +};
> > +
> > +static const struct resource vsc7512_sgpio_resources[] = {
> > +	DEFINE_RES_REG_NAMED(VSC7512_SIO_RES_START, VSC7512_SIO_RES_SIZE,
> > +			     "gcb_sio"),
> > +};
> > +
> > +static const struct mfd_cell vsc7512_devs[] = {
> > +	{
> > +		.name = "ocelot-pinctrl",
> > +		.of_compatible = "mscc,ocelot-pinctrl",
> > +		.num_resources = ARRAY_SIZE(vsc7512_pinctrl_resources),
> > +		.resources = vsc7512_pinctrl_resources,
> > +	}, {
> > +		.name = "ocelot-sgpio",
> > +		.of_compatible = "mscc,ocelot-sgpio",
> > +		.num_resources = ARRAY_SIZE(vsc7512_sgpio_resources),
> > +		.resources = vsc7512_sgpio_resources,
> > +	}, {
> > +		.name = "ocelot-miim0",
> > +		.of_compatible = "mscc,ocelot-miim",
> > +		.num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
> > +		.resources = vsc7512_miim0_resources,
> > +	}, {
> > +		.name = "ocelot-miim1",
> > +		.of_compatible = "mscc,ocelot-miim",
> > +		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
> > +		.resources = vsc7512_miim1_resources,
> > +	},
> > +};
> > +
> > +int ocelot_core_init(struct device *dev)
> > +{
> > +	int ret;
> > +
> > +	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
> > +				   ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
> > +	if (ret) {
> > +		dev_err(dev, "Failed to add sub-devices: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ocelot_core_init);
> > +
> > +MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
> > +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> > new file mode 100644
> > index 000000000000..95754deb0b57
> > --- /dev/null
> > +++ b/drivers/mfd/ocelot-spi.c
> > @@ -0,0 +1,311 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/*
> > + * SPI core driver for the Ocelot chip family.
> > + *
> > + * This driver will handle everything necessary to allow for communication over
> > + * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
> > + * are to prepare the chip's SPI interface for a specific bus speed, and a host
> > + * processor's endianness. This will create and distribute regmaps for any
> > + * children.
> > + *
> > + * Copyright 2021 Innovative Advantage Inc.
> > + *
> > + * Author: Colin Foster <colin.foster@in-advantage.com>
> > + */
> > +
> > +#include <linux/iopoll.h>
> > +#include <linux/kconfig.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/regmap.h>
> > +#include <linux/spi/spi.h>
> > +
> > +#include <asm/byteorder.h>
> > +
> > +#include "ocelot.h"
> > +
> > +#define DEV_CPUORG_IF_CTRL	0x0000
> > +#define DEV_CPUORG_IF_CFGSTAT	0x0004
> > +
> > +#define CFGSTAT_IF_NUM_VCORE	(0 << 24)
> > +#define CFGSTAT_IF_NUM_VRAP	(1 << 24)
> > +#define CFGSTAT_IF_NUM_SI	(2 << 24)
> > +#define CFGSTAT_IF_NUM_MIIM	(3 << 24)
> > +
> > +#define VSC7512_CPUORG_RES_START	0x71000000
> > +#define VSC7512_CPUORG_RES_SIZE		0x2ff
> > +
> > +#define VSC7512_GCB_RES_START	0x71070000
> > +#define VSC7512_GCB_RES_SIZE	0x14
> > +
> > +static const struct resource vsc7512_dev_cpuorg_resource =
> > +	DEFINE_RES_REG_NAMED(VSC7512_CPUORG_RES_START, VSC7512_CPUORG_RES_SIZE,
> > +			     "devcpu_org");
> > +
> > +static const struct resource vsc7512_gcb_resource =
> > +	DEFINE_RES_REG_NAMED(VSC7512_GCB_RES_START, VSC7512_GCB_RES_SIZE,
> > +			     "devcpu_gcb_chip_regs");
> > +
> > +int ocelot_spi_initialize(struct device *dev)
> 
> Should be static and unexported.

Good catch. I changed this from v7 so it can now be static. Thanks!

Everything else in your review looks good too, so I won't address each
of them.

> 
> > +{
> > +	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
> > +	u32 val, check;
> > +	int err;
> > +
> > +	val = OCELOT_SPI_BYTE_ORDER;
> > +
> > +	/*
> > +	 * The SPI address must be big-endian, but we want the payload to match
> > +	 * our CPU. These are two bits (0 and 1) but they're repeated such that
> > +	 * the write from any configuration will be valid. The four
> > +	 * configurations are:
> > +	 *
> > +	 * 0b00: little-endian, MSB first
> > +	 * |            111111   | 22221111 | 33222222 |
> > +	 * | 76543210 | 54321098 | 32109876 | 10987654 |
> > +	 *
> > +	 * 0b01: big-endian, MSB first
> > +	 * | 33222222 | 22221111 | 111111   |          |
> > +	 * | 10987654 | 32109876 | 54321098 | 76543210 |
> > +	 *
> > +	 * 0b10: little-endian, LSB first
> > +	 * |              111111 | 11112222 | 22222233 |
> > +	 * | 01234567 | 89012345 | 67890123 | 45678901 |
> > +	 *
> > +	 * 0b11: big-endian, LSB first
> > +	 * | 22222233 | 11112222 |   111111 |          |
> > +	 * | 45678901 | 67890123 | 89012345 | 01234567 |
> > +	 */
> > +	err = regmap_write(ddata->cpuorg_regmap, DEV_CPUORG_IF_CTRL, val);
> > +	if (err)
> > +		return err;
> > +
> > +	/*
> > +	 * Apply the number of padding bytes between a read request and the data
> > +	 * payload. Some registers have access times of up to 1us, so if the
> > +	 * first payload bit is shifted out too quickly, the read will fail.
> > +	 */
> > +	val = ddata->spi_padding_bytes;
> > +	err = regmap_write(ddata->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, val);
> > +	if (err)
> > +		return err;
> > +
> > +	/*
> > +	 * After we write the interface configuration, read it back here. This
> > +	 * will verify several different things. The first is that the number of
> > +	 * padding bytes actually got written correctly. These are found in bits
> > +	 * 0:3.
> > +	 *
> > +	 * The second is that bit 16 is cleared. Bit 16 is IF_CFGSTAT:IF_STAT,
> > +	 * and will be set if the register access is too fast. This would be in
> > +	 * the condition that the number of padding bytes is insufficient for
> > +	 * the SPI bus frequency.
> > +	 *
> > +	 * The last check is for bits 31:24, which define the interface by which
> > +	 * the registers are being accessed. Since we're accessing them via the
> > +	 * serial interface, it must return IF_NUM_SI.
> > +	 */
> > +	check = val | CFGSTAT_IF_NUM_SI;
> > +
> > +	err = regmap_read(ddata->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, &val);
> > +	if (err)
> > +		return err;
> > +
> > +	if (check != val)
> > +		return -ENODEV;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ocelot_spi_initialize);
> > +
> > +static const struct regmap_config ocelot_spi_regmap_config = {
> > +	.reg_bits = 24,
> > +	.reg_stride = 4,
> > +	.reg_downshift = 2,
> > +	.val_bits = 32,
> > +
> > +	.write_flag_mask = 0x80,
> > +
> > +	.max_register = 0xffffffff,
> > +	.use_single_write = true,
> > +	.can_multi_write = false,
> > +
> > +	.reg_format_endian = REGMAP_ENDIAN_BIG,
> > +	.val_format_endian = REGMAP_ENDIAN_NATIVE,
> > +};
> > +
> > +static int ocelot_spi_regmap_bus_read(void *context,
> > +				      const void *reg, size_t reg_size,
> > +				      void *val, size_t val_size)
> > +{
> > +	static const u8 dummy_buf[16] = {0};
> > +	struct spi_transfer tx, padding, rx;
> > +	struct ocelot_ddata *ddata = context;
> > +	struct spi_device *spi = ddata->spi;
> > +	struct spi_message msg;
> > +
> > +	spi = ddata->spi;
> > +
> > +	spi_message_init(&msg);
> > +
> > +	memset(&tx, 0, sizeof(tx));
> > +
> > +	tx.tx_buf = reg;
> > +	tx.len = reg_size;
> > +
> > +	spi_message_add_tail(&tx, &msg);
> > +
> > +	if (ddata->spi_padding_bytes > 0) {
> > +		memset(&padding, 0, sizeof(padding));
> > +
> > +		padding.len = ddata->spi_padding_bytes;
> > +		padding.tx_buf = dummy_buf;
> > +		padding.dummy_data = 1;
> > +
> > +		spi_message_add_tail(&padding, &msg);
> > +	}
> > +
> > +	memset(&rx, 0, sizeof(rx));
> > +	rx.rx_buf = val;
> > +	rx.len = val_size;
> > +
> > +	spi_message_add_tail(&rx, &msg);
> > +
> > +	return spi_sync(spi, &msg);
> > +}
> > +
> > +static int ocelot_spi_regmap_bus_write(void *context, const void *data,
> > +				       size_t count)
> > +{
> > +	struct ocelot_ddata *ddata = context;
> > +	struct spi_device *spi = ddata->spi;
> > +
> > +	return spi_write(spi, data, count);
> > +}
> > +
> > +static const struct regmap_bus ocelot_spi_regmap_bus = {
> > +	.write = ocelot_spi_regmap_bus_write,
> > +	.read = ocelot_spi_regmap_bus_read,
> > +};
> > +
> > +struct regmap *
> > +ocelot_spi_devm_init_regmap(struct device *dev, struct device *child,
> > +			    const struct resource *res)
> > +{
> > +	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
> > +	struct regmap_config regmap_config;
> > +
> > +	memcpy(&regmap_config, &ocelot_spi_regmap_config,
> > +	       sizeof(ocelot_spi_regmap_config));
> > +
> > +	regmap_config.name = res->name;
> > +	regmap_config.max_register = res->end - res->start;
> > +	regmap_config.reg_base = res->start;
> > +
> > +	return devm_regmap_init(child, &ocelot_spi_regmap_bus, ddata,
> > +				&regmap_config);
> > +}
> > +
> > +static int ocelot_spi_probe(struct spi_device *spi)
> > +{
> > +	struct device *dev = &spi->dev;
> > +	struct ocelot_ddata *ddata;
> > +	int err;
> > +
> > +	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
> > +	if (!ddata)
> > +		return -ENOMEM;
> > +
> > +	ddata->dev = dev;
> > +	dev_set_drvdata(dev, ddata);
> > +
> > +	if (spi->max_speed_hz <= 500000) {
> > +		ddata->spi_padding_bytes = 0;
> > +	} else {
> > +		/*
> > +		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
> > +		 * Register access time is 1us, so we need to configure and send
> > +		 * out enough padding bytes between the read request and data
> > +		 * transmission that lasts at least 1 microsecond.
> > +		 */
> > +		ddata->spi_padding_bytes = 1 +
> > +			(spi->max_speed_hz / 1000000 + 2) / 8;
> > +	}
> > +
> > +	ddata->spi = spi;
> > +
> > +	spi->bits_per_word = 8;
> > +
> > +	err = spi_setup(spi);
> > +	if (err < 0) {
> > +		dev_err(&spi->dev, "Error %d initializing SPI\n", err);
> > +		return err;
> > +	}
> > +
> 
> Personally I'd prefer:
> 
> 	struct regmap *r;
> 
> 	r = ocelot_spi_devm_init_regmap(dev, dev,
> 					&vsc7512_dev_cpuorg_resource);
> 	if (IS_ERR(r))
> 		return ERR_PTR(r);
> 
> 	ddata->cpuorg_regmap = r;
> 
> and so on.
> 
> > +	ddata->cpuorg_regmap =
> > +		ocelot_spi_devm_init_regmap(dev, dev,
> > +					    &vsc7512_dev_cpuorg_resource);
> > +	if (IS_ERR(ddata->cpuorg_regmap))
> > +		return -ENOMEM;
> > +
> > +	ddata->gcb_regmap = ocelot_spi_devm_init_regmap(dev, dev,
> > +							&vsc7512_gcb_resource);
> > +	if (IS_ERR(ddata->gcb_regmap))
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * The chip must be set up for SPI before it gets initialized and reset.
> > +	 * This must be done before calling init, and after a chip reset is
> > +	 * performed.
> > +	 */
> > +	err = ocelot_spi_initialize(dev);
> > +	if (err) {
> > +		dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);
> 
> Maybe showing the symbolic value behind the error number would be
> helpful?
> 
> 		dev_err(dev, "Initializing SPI bus returned %pe\n", ERR_PTR(err));
> 
> Similar for other places where you print the error using %d, I won't
> repeat this comment.
> 
> > +		return err;
> > +	}
> > +
> > +	err = ocelot_chip_reset(dev);
> > +	if (err) {
> > +		dev_err(dev, "Failed to reset device: %d\n", err);
> > +		return err;
> > +	}
> > +
> > +	/*
> > +	 * A chip reset will clear the SPI configuration, so it needs to be done
> > +	 * again before we can access any registers
> > +	 */
> > +	err = ocelot_spi_initialize(dev);
> > +	if (err) {
> > +		dev_err(dev,
> > +			"Failed to initialize Ocelot SPI bus after reset: %d\n",
> > +			err);
> > +		return err;
> > +	}
> > +
> > +	err = ocelot_core_init(dev);
> > +	if (err < 0) {
> > +		dev_err(dev, "Error %d initializing Ocelot core\n", err);
> > +		return err;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +const struct of_device_id ocelot_spi_of_match[] = {
> 
> static
> 
> > +	{ .compatible = "mscc,vsc7512_mfd_spi" },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
> > +
> > +static struct spi_driver ocelot_spi_driver = {
> > +	.driver = {
> > +		.name = "ocelot_mfd_spi",
> > +		.of_match_table = of_match_ptr(ocelot_spi_of_match),
> > +	},
> > +	.probe = ocelot_spi_probe,
> > +};
> > +module_spi_driver(ocelot_spi_driver);
> > +
> > +MODULE_DESCRIPTION("SPI Controlled Ocelot Chip Driver");
> > +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> > +MODULE_LICENSE("Dual MIT/GPL");
> > diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
> > new file mode 100644
> > index 000000000000..b68e6343caca
> > --- /dev/null
> > +++ b/drivers/mfd/ocelot.h
> > @@ -0,0 +1,34 @@
> > +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> > +/*
> > + * Copyright 2021 Innovative Advantage Inc.
> > + */
> > +
> > +#include <linux/regmap.h>
> > +
> > +#include <asm/byteorder.h>
> > +
> > +struct ocelot_ddata {
> > +	struct device *dev;
> > +	struct regmap *gcb_regmap;
> > +	struct regmap *cpuorg_regmap;
> > +	int spi_padding_bytes;
> > +	struct spi_device *spi;
> > +};
> > +
> > +int ocelot_chip_reset(struct device *dev);
> > +int ocelot_core_init(struct device *dev);
> > +
> > +/* SPI-specific routines that won't be necessary for other interfaces */
> > +struct regmap *ocelot_spi_devm_init_regmap(struct device *dev,
> > +					   struct device *child,
> > +					   const struct resource *res);
> > +int ocelot_spi_initialize(struct device *dev);
> > +
> > +#define OCELOT_SPI_BYTE_ORDER_LE 0x00000000
> > +#define OCELOT_SPI_BYTE_ORDER_BE 0x81818181
> > +
> > +#ifdef __LITTLE_ENDIAN
> > +#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_LE
> > +#else
> > +#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_BE
> > +#endif
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 1897119ebb9a..f9124a66e386 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -1039,11 +1039,16 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
> >  }
> >  #endif
> >  
> > +#if IS_ENABLED(CONFIG_MFD_OCELOT)
> > +struct regmap *ocelot_init_regmap_from_resource(struct device *child,
> > +						const struct resource *res);
> > +#else
> >  static inline struct regmap *
> >  ocelot_init_regmap_from_resource(struct device *child,
> >  				 const struct resource *res)
> >  {
> >  	return ERR_PTR(-EOPNOTSUPP);
> >  }
> > +#endif
> >  
> >  #endif
> > -- 
> > 2.25.1
> >
