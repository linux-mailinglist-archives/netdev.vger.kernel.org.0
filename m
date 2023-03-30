Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD50C6D0B79
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjC3QjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjC3QjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:39:15 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2105.outbound.protection.outlook.com [40.107.244.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F841CA1D;
        Thu, 30 Mar 2023 09:39:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8m2ddpj3kYjqXOyJSXRwntVaowC6ts/n1kM6Uf+AT9wxWOYj51tAsdioxEbAkrkJGDmansQu1//s3KbH0O3webLiirIjt7Q+xxmluHKPjJQzVKiJrFstuaGy/gk19U1RR6e7dDMYd0ewNkNRQ0Du+AHWhqaNfLQvd46aBLVlaCpYFVIB+vHX5RT8Ib0DeP0zt9T+za5zdJoz745kZBKYmTfkOhi7atrgMEoKZGgGqH2tRX0iD6iTxqGAU6OZpEW5gMX1+yElU7HM0BWxu1rc4qtEWMFJK8fOLV0Z2FqgBioabtZjXDP0+oF2xOBFDndXt7M3eJvOOE4o9H0Qi4DnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFr2U+g46mQXGEZz606s03XuYBsX8BRPheyK4PHXVZE=;
 b=bH5LDj4eHermWLAy5A6oFhiCEoI3xRTGCJ7FJ6bVqu13gc9LApr6VwGCN40pK4NuHOe63WwW1la7biUrXOxzHJaVr+zNDip+JBnJXnxzbRWUGD13CfUUuOnkNikNIdqkfrzXwLK3bYO1BOqYZuDhZhsI55IziWxyu2KKNSowNNXqnhj2k/VyKo3D2FL63Rh6gZ5jqfA5TjZDXIYUbW6CltzmWEfgGAnbJYNuRIR1t0NFWCltumdmLuxD6psauO/k6Oz9lzUrXaygnKkj7gIdOCp1Cre7xBvRZyp1MCVlciYyM5Hr137fCX0NkW45XAuTZJ5Dl7GlTWC7fk1miq8StQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFr2U+g46mQXGEZz606s03XuYBsX8BRPheyK4PHXVZE=;
 b=DkQco0Ov3T7qxrvjVkgf6h6K1nWEli9UKunUe0kKz0qxivMbtiqYmWZRV9Oorf1Du5Rw5PdPB9ZYlG08AXMYVmpDaAtBmHwppGX9dzF5IWiYwt22X8hXpKX5A+w5+9p8LVZQj7RXKv0MPb8d435CjGBaOzIZMiUqQ9+rBV+Z9ZU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4660.namprd10.prod.outlook.com
 (2603:10b6:303:6d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 16:39:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::d966:4c70:65af:f8a0]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::d966:4c70:65af:f8a0%5]) with mapi id 15.20.6222.028; Thu, 30 Mar 2023
 16:39:12 +0000
Date:   Thu, 30 Mar 2023 09:39:07 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [RFC 2/7] regmap: check for alignment on translated register
 addresses
Message-ID: <ZCW7K/DWmGApVen9@colin-ia-desktop>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
 <20230324093644.464704-3-maxime.chevallier@bootlin.com>
 <ZB3xJ4/FTEwHyVyY@sirena.org.uk>
 <20230330114546.13472135@pc-7.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330114546.13472135@pc-7.home>
X-ClientProxiedBy: MW4PR04CA0142.namprd04.prod.outlook.com
 (2603:10b6:303:84::27) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CO1PR10MB4660:EE_
X-MS-Office365-Filtering-Correlation-Id: 06f2536b-7d88-4455-6f8a-08db313d4a8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9G3Al2Z99HAPbF8r7CdKTOBVsbFbTfYgajM9h+3gIiYRlolp8oZNG9YaS7tI3Jtws+ZLTsqalHOL7/RdQu7/GjNU92O5oF+eHAUxUFPkO+8IJ4Bw1iUANb2RwMqj1uOISblQsg/y0WYA21rkJr0lD6dctF5QKo1htzd1rGLH3cuzOR+0xohk5hAJZjgizMmZGrKnY5WKlB71UtmDu15RkGYvHOKLWu2zO+yaZ884cprOsS5mBxPW0+tYRXmMwPXOUTiFgyw5SpVw6+DM4VSGUXCumx+J9ZuZwuzKCWl6g9yQs5dG3m2HTCzzS8KZqQE+wTDvgcKqu3nKDgsFHZX1e4vaE2FcjvrqdAuEpC7jNo4W/JeEaPER8GHXYR+E5T33j7h6TskISF6gpF0AHZwSdtvMwB602mKt13sWta14cgFxnMmJtWemJUOH03hOUxS2t457sankoTy5GlFZXG+xAPyn9kVDP6s9q96oNynKER9daYj0sdsi9PKumCmqXhG6Gjackhop2beYg9hYvyjzvptePfanlabWtpmyOwHaTfcoKO1UBOwF8f7lNabpa17e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(39830400003)(346002)(136003)(366004)(396003)(451199021)(83380400001)(6666004)(26005)(33716001)(316002)(54906003)(7416002)(66556008)(66946007)(66476007)(8676002)(38100700002)(41300700001)(86362001)(6916009)(6512007)(4326008)(478600001)(6506007)(9686003)(6486002)(44832011)(8936002)(2906002)(5660300002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kau+kPpbkCBKktZGleCBuAA9msEj0iMEYNYMh2ShduiQAYu4rf+kpsYXVryR?=
 =?us-ascii?Q?Uuo8Ved3ONFBVsv3K8dGc2t2orNggwIflAgDpbU0sYYPAGbFV1juqkukmKtM?=
 =?us-ascii?Q?JA4vkTOQ2n/41G0mtA5dJ5LF6NIhF2R/txhg2YdvFrBuB99i4ACZE/sAakGw?=
 =?us-ascii?Q?G6oqtig839FuyQIH11pIdWQAaYr2mfZy0qcEnrwEjQIiDNzj7ARTMY1EiPQQ?=
 =?us-ascii?Q?AAyJX5ApLqQFFW1FLyGgUKUPQr8/JsnfYoR5JhwgJmYUkGyFg+9OByU82Yvp?=
 =?us-ascii?Q?qHte8WtzGuhM6cKgdQQ/+hcFGCOXdmf5UyOrX6mU+ulubKR20LlHwoMEqHtQ?=
 =?us-ascii?Q?RROoMOstfCgHxByo5ig+aVYpFocDQY/nIx55Z/ZWUCeSEW7W+gV1oqzy+evn?=
 =?us-ascii?Q?0xRb0CDZbG4OBU56Apu99SJlp3gR8ENKhc+r+Rp7N6I+zffHM6TDJM1hJlMC?=
 =?us-ascii?Q?KnpO7fWX4kPenBCJeF1nzpf3QxrtK6K0x6mLMfWBc0Os4T8GtJwecKLFhjxb?=
 =?us-ascii?Q?pyQAdE27zG29tEy4OZwgYTsMF/rXtl+zkP07U3m61r9W6eJlHKrdRompio2J?=
 =?us-ascii?Q?1kN5UsqPvYeNxR6nkeVHP1hlGa70zIxt90c1UDnBtRDbGmQjYZzepAKKWcJa?=
 =?us-ascii?Q?lj4zy9iDk3wV7PrS0M4Zbgkr3NgBZHEmaACGNDqiOzdXmxVoIgjdnsvaAoGA?=
 =?us-ascii?Q?EG0pK/CBDRsVO0tUk7hI4ZTNA3HOh6ZcVs6BX9GrtN/N8LKlwkvKGO3aFIoL?=
 =?us-ascii?Q?Esv+gDfjdmIkTKGOP+kQZQIcvspWKwcIuNGlwp8OPJLJTA752wgccGqFRzmy?=
 =?us-ascii?Q?WtR+JWHTGo7ZyUytGpceSr7E6NdhMTMkQWmbHRiu0LPDBMgBT0Nc57Sbt1f7?=
 =?us-ascii?Q?I/GC4Pa8DK4b8CUfr4uhBbU9oaTF/KbNo/2EVH3g8/ZgOsezEbjMjQlJGhh2?=
 =?us-ascii?Q?MhpnE8tLZZnw6/SdpD5ylgRz2Lmz8xqmZNt+F3ONDSqw3vkluvw9ToiqcaJC?=
 =?us-ascii?Q?yg5UrrJA3q8P2d8atEnGCnYW4vUgbTnhSITUn9G1WlUI4vdZGnlq6XGKUSCL?=
 =?us-ascii?Q?ur3kiB9GFkbmrbKq1wl0LbPeQim7lBrMk9sMih6Xyp+5nAxFjDOdFzT7A1BZ?=
 =?us-ascii?Q?xDD5XGpJ6UUW7jEcY0TWvr88rHpLv90LjjeodmC23QdUL9SbO4IEnGvZ4c3J?=
 =?us-ascii?Q?qz9wlHHH5UbITJPzj+dbO5I7/Z4gZ7wBjyc+zYh8l9087eCV5Fmglgzgg8hV?=
 =?us-ascii?Q?HmRJOpu36j5gr0ALXUsfFMgcIizSQY+3G8CyeZqtuAcux4/75fhpFLwC1GiT?=
 =?us-ascii?Q?ANtcwh1DampmZ1RuOc4i5CasWPuNxAKJY8rNpUjl4IOjUP3qYzP0lwIzNw0O?=
 =?us-ascii?Q?OLdglDxezTHzkPwURvBQB7vvWsHbOn9UcctwrW7vtTG87uST1UI6kH7MkeoA?=
 =?us-ascii?Q?2lVH+Ygi3hskQJrkYZok1+GXan46xBuESMTmURSjDHrW6qrqrnDgl6+eNOFw?=
 =?us-ascii?Q?Evs123WD25we8PPx7DZl6V6xKfOF7I/mxboox08kgg5rzmWrPkHA8v9Fauif?=
 =?us-ascii?Q?DeqvE8M1t0TM8mVlmOl7k5R/mBj4L9tuUS0NAe3sJN8gt3B5DJAGMqKMQ019?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f2536b-7d88-4455-6f8a-08db313d4a8b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 16:39:11.9605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pxZnU8RSNCcYhyg9vYv0sNm5Mq81QQMCJYY57XKADymjM+GU/+zLiovJ8FQyFGimdnaSZG9LxVQHz8VVAiXSOx+boTIgdfBMgDRoA9fPFSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4660
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

On Thu, Mar 30, 2023 at 11:45:46AM +0200, Maxime Chevallier wrote:
> Hello Mark,
> 
> On Fri, 24 Mar 2023 18:51:19 +0000
> Mark Brown <broonie@kernel.org> wrote:
> 
> > On Fri, Mar 24, 2023 at 10:36:39AM +0100, Maxime Chevallier wrote:
> > > With regmap->reg_base and regmap->reg_downshift, the actual register
> > > address that is going to be used for the next operation might not
> > > be the same as the one we have as an input. Addresses can be offset
> > > with reg_base and shifted, which will affect alignment.
> > > 
> > > Check for alignment on the real register address.  
> > 
> > It is not at all clear to me that the combination of stride and
> > downshift particularly makes sense, and especially not that the
> > stride should be applied after downshifting rather than to what
> > the user is passing in.
> 
> I agree on the part where the ordering of "adding and offset, then
> down/upshifting" isn't natural. This is the order in which operations
> are done today, and from what I could gather, only the ocelot-spi MFD
> driver uses both of these operations.
> 
> It would indeed make sense to first shift the register to have the
> proper spacing between register addresses, then adding the offset.
> 
> So maybe we should address that in ocelot-spi in the next iteration,
> Colin, would you agree ?

I'm curious what you mean by "proper spacing". The proper spacing of the
VSC7512 (ocelot-spi) is 4, and that's what the reg_stride is. All
registers can be accessed in many ways, as I described.

Consider the case I brought up, where we're trying to access a register
at 0x71070004. If you're on the processor internal to ocelot, this would
be

uint32 val = *(uint32 *)0x71070004;

Accesses to 0x71070001, 0x71070002, and 0x71070003 are not possible.
(Well maybe they are _possible_ on some architectures... you get the
point though)


Translate this to accessing the same register via SPI, where everything
is shifted down two bits. We're still accessing 0x71070004, but the way
this gets sent on the bus is 0x71070004 >> 2 = 0x1c41c001.

This patch set would have allowed accesses to 0x71070001 in the
ocelot-spi scenario, but not in the MMIO scenario. That wouldn't be
desired.


The result of all this is a consistent driver interface. "Give me
register 0x4 from a base address of 0x71070000" works in both MMIO and
SPI. Everything in /sys/kernel/debug/regmap should be the same in both
scenarios as well. All of these scenarios were the motivation behind
reg_shift.


Colin Foster

