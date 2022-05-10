Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6295203A7
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239664AbiEIReq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239666AbiEIReo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:34:44 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2117.outbound.protection.outlook.com [40.107.243.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB70A1F3EAB;
        Mon,  9 May 2022 10:30:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCNOcpWt6ZXZob5kY2uIWG6YTcX3m5z1p5/aroRHnCnejMKqW7koJHjmQS2KqNtFE5iO0rBqzYPtT83mEMx8sw7u2Qrq+67xwS+1s/4e1W2/6FXwnZIQLjdFLgUmA0tvaWnH3Pcp1A2JF4vkL13GQHDQmKMvq2kv0n7ri1OMVjHIHLRP0o/wSa4SOZRsAtpRGCS1ZmIajmQlsajP7QKB/Q62/rZ04cKFExTTuKlQx4td4L6gtsZwYWq22BeCZ20Jh+1hIYSA6LE11RN1u50vrU76voIu5jnnHY5f7s/aa/Yd+hS7ACa3WYOExurIKqnTzv6NV91/f9+di32ijnbzXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPD8izv3EO1/LK8wD2RegzYnqW6d2UJQ+C3jagzpG98=;
 b=f7GLNp+sSEmCNv4kNEU83CW0JtHD6W5KlhXP0HNsGx6AaszS2t+LxNxQhBTHD/gI7ZOZBUuXJWldnK5g45pDZl7CvsRTZD5sc/Vhr2IrbgY+hYQMCIbXIpBUVfDsmnVnRWK1Qj2wgIeGz/R4Fk14xhUeFlFRkUM2etZCCQr+xoTYpKvfYpv8DlpHAKQLHdINe/a5csKoAm+aTANeZEwzYQAAqtK3dGdpPwLJKox3J8JGJ8ZzcYs6Kw4pfX8n8wkoXnMuPqltzi53hKWAHM/Fgx5ZyvDqAOdsUzKgxcgHo/jr4k7My8PBRE5tweIXE1+fJ3wzLTmXFBicHkkPFvUo8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPD8izv3EO1/LK8wD2RegzYnqW6d2UJQ+C3jagzpG98=;
 b=u8O50NCZXz9lqxG5I/x0605GY7gm0OR3436AsrOpoxiPzc3de5vtGJBmKOgUla5lQbQyZkzNkg738wvjSqMKTLAUjkQINlBDcBCDBlx+8P1DgpiV/AiMpJTyf2N+MIHs/JoyIXKTD7sNNjqZOd/tG+l/m8VKHMGdQsyjg1lIyfI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB3637.namprd10.prod.outlook.com
 (2603:10b6:a03:126::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Mon, 9 May
 2022 17:30:38 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Mon, 9 May 2022
 17:30:38 +0000
Date:   Mon, 9 May 2022 17:30:40 -0700
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
Message-ID: <20220510003040.GG895@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
 <20220509105239.wriaryaclzsq5ia3@skbuf>
 <20220509234922.GC895@COLIN-DESKTOP1.localdomain>
 <20220509172028.qcxzexnabovrdatq@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509172028.qcxzexnabovrdatq@skbuf>
X-ClientProxiedBy: SJ0PR03CA0253.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::18) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f73d906c-d54e-449f-e1aa-08da31e1a1cd
X-MS-TrafficTypeDiagnostic: BYAPR10MB3637:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3637FDFFB6636D509B0DD66CA4C69@BYAPR10MB3637.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4zgc5WmdPc8YKYFrm9o9cWjrrKw1jMF0Wi2nQeBhux48RiSom4fIDptxgsgC4aNEwQ58L21YvOq2jsyVkEFOU5+iyGX0T/xYbFblPd7/2Lzbz94V21HEPci0xZ58EBgzV/MzSptsGC56oYKIZ0FY5WQliBhaGqXMCfumGqId8oYNfPEqypphb4oykRc30joGOcEyhVqLhjMU4lpkHuuvV6YsEshQ8ZffVQGxUAmWPzCvXMlOKFqGHp859mrKERtACE6sWYEMIneX363UX+uHCdVHqrYcuN+Mlu1uPI44nTebYef9jy6dkMD084VLjc6Wb3WFqmB91Kgsdqlv2ujT7BC1zCzZJQkFNqro4KQrrszpFj6PAJ8bAWBP8tLGUN3a6j+1sH4CIbODoro7aDYb64hBL1qAWGNsKOCu3kXKzbKEM//DBOJgBo59XppIxuivqI7txyaB8oUM0pIzeDGhi16Q0uqdxnKyIV/P7bomsZ2yKHV0OsQFoKl+qhGiC+mae8qCjYfvgqvEMW7CaKUhS/xAqkZMUIxi/VXxHm4PHNIuhyawJjxmLbn2IlpD8kxJL7gDpqUlIJGyr+JpM4yPAVXBbL/srATcbUPk8XovsSaP39qW87fKaCt4phqvx05O31QLX4dXUa07a5SB43KdytQ5bhVLKgTRTrSygHARSbxKGy9jbWYSgFfwyeDffYGMu97hWC32+bv1MAp3MNfJ5qZ4HaZ+VkSYykrQF4DCIE2i+yAXA/R9f4G0YjcDfZkhm7LlcceNVHAN3pIjcRb1p40nvpocjNpM3oUMcCe7A38=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(376002)(136003)(346002)(39840400004)(54906003)(86362001)(8936002)(66946007)(66556008)(6916009)(8676002)(4326008)(316002)(66476007)(1076003)(6666004)(38100700002)(6486002)(6512007)(9686003)(6506007)(52116002)(26005)(508600001)(2906002)(38350700002)(33656002)(966005)(83380400001)(5660300002)(7416002)(44832011)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?spVdHy7JPRachQWfkxRcnnz+DJipGNgCQPWheWRTG0EXJ4BrcAw001UwwVu4?=
 =?us-ascii?Q?RbhHw0BQ15HJF/3xN5yaGWolkgHepzjgLe1WEBTSRqZMBe5jYEfX+FXw4jg4?=
 =?us-ascii?Q?iOOnxfct6ZC7zKHMnLY+118LRZ+IXc01oiQi9L4tKrUdyvvRq/pI8Ei+1ZyL?=
 =?us-ascii?Q?RrxUE6zCoSGuo9E4fm+DFdYGMALLqUriYYEVLKhpkYeJLClpVVta3JhKm/37?=
 =?us-ascii?Q?qZoLi39oCOuS3wqaxiZG0JKtLjRF14JVyRJ+9Iz6XbrKHzburE6234qwh8qw?=
 =?us-ascii?Q?aG50H2BRGdSoDPIPMEBLckV1t/eBPjvjpr3/CURfEb7MQdpdxW3TwYluCbzz?=
 =?us-ascii?Q?IgzVXfNz8tqJicG9T1ot85GkO8bN/hu0VEDdE2DhqNFhzQdAVAT0h3A4wRes?=
 =?us-ascii?Q?Zgm+sPuQTpZJgnGqrZhMQaNy2LLS4sw7tFTphmrLCqSdqfzv6oJbvY04YO7e?=
 =?us-ascii?Q?hRnks62k8VOeWLZH76pyR+iaTNP1Se1vEctHgdUetama/faWA9ka5JovOfEI?=
 =?us-ascii?Q?DPIjNdzExyrfF6jILIJ8YM+kayyR48Yu0mabdUXuYIV84FEBv6ZR6wz8YjES?=
 =?us-ascii?Q?WvfX1fhYR58QBpMUvSqhz16+WlWLXXgTL6pdeZ5MbeoMs+L73Ale/PcDHO0k?=
 =?us-ascii?Q?LB94ZfDGtneIexv7tn1EhQp2xxo8IeLKbK/01hro2ZIAMue6+in9RZaXnxYq?=
 =?us-ascii?Q?9TpEO8KgWDKl9XcAWdfbTdZhZxMGcAKkr2FXdBFg6zZ+m9adCCRa7keHDwsn?=
 =?us-ascii?Q?KBx84BvTfqDiAzSPbwcPevPuDCmSxRlOA8um2eVsdSFAOfa08oooVRwxRIyX?=
 =?us-ascii?Q?7v5gIE19sxL4ZYfxAKyk3I9W8O0mU+O1nT7wjSbOQB9TsKlhBPplsU50lKmG?=
 =?us-ascii?Q?0m/LXoCpojDVwbjaDgee74e5hq/fNGUJJYmw++uhJoBYsxnLhm86JzmaBeun?=
 =?us-ascii?Q?FvENIAPoWnOXGz8iaqYgwUN624wC3hkZd+C1/vLGZrQLyh3FeBoZgilTReCY?=
 =?us-ascii?Q?aTWuSxprl1WNvIPXl31GkrgdCiGEsnjpIT+ZXNU3OxAyiZXoYp46RBMQ9rrs?=
 =?us-ascii?Q?k6qd8l5VbNK5reO2YK2ygad56z4MaHeMoPom1swNmY4Mfw/p2tPbmeT29O5H?=
 =?us-ascii?Q?+xihd6LiKQJzK7Jvo65vTcosGDAuW9y8EiyJlW2X1pKHwrXYYlOsq3Tpu6cw?=
 =?us-ascii?Q?lByRiKPXVf4W/IfmP3n6mm9vO493M9DAP79789ZMK+lbgD1Mxi7HS92C8axo?=
 =?us-ascii?Q?4hfaWAWDJOoYPvWw2FSMNdgoTLPTuLG6p88Ib2JD7Ess6NjEege6xhqC230t?=
 =?us-ascii?Q?UtTN7weLdcL34h9IF+Y78W55Y1wG9Mrg7c086ytau8qxUBIC3IHsG5WPRAHS?=
 =?us-ascii?Q?2skXBDD+ZprKxZmZovasACJ9+bOX7fZDL/ewcxdVvsiFNfdJxpk9QnUNEpl7?=
 =?us-ascii?Q?F1SoaaQLy93YeKoW6g7ykKJp210Xr5toNQ720iUpI8WprSmYbuV0dQx232dJ?=
 =?us-ascii?Q?txVXeKyhfy+toHrc6lXuFy2nKA53G4g4rYxR6x+eKVH6XYR1ohYC9pVpiUn2?=
 =?us-ascii?Q?z8J19znmvn+9sPTV5rP26+4YQgEssMwTcoARnR9p+LDgZGMWzhwPEg/DdwNX?=
 =?us-ascii?Q?bPdg0XIOzGKBek06mvPCDdGLPHKBJARjyd2erKyFvIVUwqv+KK2AZ1z2mDKA?=
 =?us-ascii?Q?R8/zT8eh2cEE7E7eVfWDuO94FOMYQne716hJNVVEGbYp4vvU/rg6IqwqRakQ?=
 =?us-ascii?Q?p63pnCDxdSkJDZmK8h2lEuAQwrPDD8BNE9wwjuu3azTb4ByPWjnf?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f73d906c-d54e-449f-e1aa-08da31e1a1cd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 17:30:38.0404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nlu77pvdCtBvAVQitHCYQDdVbDgzgsmHDhqG/bNVUBOdonwlR+xo/4TVlIWgeA7sn8vQCgrGUyuLGdExI8MXdUrANgLBoiGZ7ZCLGNk41Rw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3637
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 05:20:29PM +0000, Vladimir Oltean wrote:
> On Mon, May 09, 2022 at 04:49:22PM -0700, Colin Foster wrote:
> > > > +struct regmap *ocelot_init_regmap_from_resource(struct device *child,
> > > > +						const struct resource *res)
> > > > +{
> > > > +	struct device *dev = child->parent;
> > > > +
> > > > +	return ocelot_spi_devm_init_regmap(dev, child, res);
> > > 
> > > So much for being bus-agnostic :-/
> > > Maybe get the struct ocelot_ddata and call ocelot_spi_devm_init_regmap()
> > > via a function pointer which is populated by ocelot-spi.c? If you do
> > > that don't forget to clean up drivers/mfd/ocelot.h of SPI specific stuff.
> > 
> > That was my initial design. "core" was calling into "spi" exclusively
> > via function pointers.
> > 
> > The request was "Please find a clearer way to do this without function
> > pointers"
> > 
> > https://lore.kernel.org/netdev/Ydwju35sN9QJqJ%2FP@google.com/
> 
> Yeah, I'm not sure what Lee was looking for, either. In any case I agree
> with the comment that you aren't configuring a bus. In this context it
> seems more appropriate to call this function pointer "init_regmap", with
> different implementations per transport.
> 
> Or alternatively you could leave the "core"/"spi" pseudo-separation up
> to the next person who needs to add support for some other register I/O
> method.

That's true. If it comes down to it I can do that. Though I really do
like having the SPI-specific stuff clearly separated, I can bring them
together if it speeds things up. I'll wait for feedback.
