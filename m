Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4B1636CFD
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 23:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiKWWSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 17:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKWWSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 17:18:11 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2122.outbound.protection.outlook.com [40.107.93.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13EC222;
        Wed, 23 Nov 2022 14:18:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSaA0kfek8ohqUh1D8RQ6pWXyYmvI3fhupL5pi7SSIyXIfwilhEGQUWr8s/KsOd740sFhjZKnKmgIr2vdkeL5usx+nRRXlBp3al/XJ3PzzQjj73XOmeA4h2xvTEVR3Vs3R33Kg40RBxqvyE8yPRJylparXvMHmgW8cxQ6FNo5p2sQzGDcIgVv4X3cOmVDKPJvrPfECIJtpYq0ADFNT8or84xnJHLv61E0b6cnhhTjX0XvccZenGQhdh5XpKlP8O8kiGmW3rhCYbk+P7L0MoQ+PVP25OdX02rGFvqa3coyzaYFayc8xte4f1MLYKerACyzdzj2GBojJVp+9Lrh2qfaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbIcZJ3Ua7hq/jhL+nlv3Yw5XDonQETGQT0lpSbysxw=;
 b=QGIxyesJXlbmstjGz1dRioZk8X6Jokgyp16KWtN7u1XU6zaLoHgtYEYlnjOer2BG3g8TlL6RpBgbEZCuDCJKqqeCGDQOYZ38zY7v3cdd8cWvHzrqpyXJWJEfmlZnNAv7SeRr7+sk0OGg/2rFirnfzpicOAWHEE8gtYYHJ7J7ae+X9O3ArjFVgSICyf9J1kJrpmUUZM/5ZUkEAa08Xy19rVHHqpHXN0b/FimFoZoiyDgXdEpS/MXl1AKbe2+zJ5fHw0PXzjiFzjHvYCUwRdF62wMh7MYIrWuZg5OWZTDXf5yMsgVbSEV8sXan1RIopzt8fPYABB0d6o9pAa8Jv2R37Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbIcZJ3Ua7hq/jhL+nlv3Yw5XDonQETGQT0lpSbysxw=;
 b=0DK/XLHA0ibyyWZ5aNGMDt+rXgzZvn5N7Fw9QSadzseJBPRPz8Dm8GvHXL3Bwzumqap65ofXccyFQ7KKktRQC2lrGHfzqYlsp4rvQlfOE/7oM92KwBLrKA++wmDcL+HuyeDIEIpd7SC1kPcsEhDRW0m7D0m8QKuai/LGBfB72+A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4460.namprd10.prod.outlook.com
 (2603:10b6:806:118::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Wed, 23 Nov
 2022 22:18:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 22:18:06 +0000
Date:   Wed, 23 Nov 2022 14:18:02 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Alexander Lobakin <alobakin@mailbox.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexander Lobakin <alobakin@pm.me>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] dsa: ocelot: fix mixed module-builtin object
Message-ID: <Y36cGl7wLM3aGeI2@colin-ia-desktop>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <20221119225650.1044591-15-alobakin@pm.me>
 <20221121175504.qwuoyditr4xl6oew@skbuf>
 <Y3u/qwvLED4nE/jR@colin-ia-desktop>
 <20221123214746.62207-1-alobakin@mailbox.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123214746.62207-1-alobakin@mailbox.org>
X-ClientProxiedBy: MW4PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:303:6b::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4460:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a3d854a-4af6-4348-d5f9-08dacda09858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dgVW807a2YR04E77kdFKlbzV5WhjCMm29Kp2Z0sZchJ6Kt1nMFNaaGfZkOm6Nq0uBSZN1J0+olRfQjUy4fKeAwT84ZWrU0BSbTYKXB0cyhzLrjWeyk9yKW0NsbG2wK8MfU42lyIAbHvV+VSLUuErzvAE2KhcMCP57Wtl5daq5OtQ9xQtu3P/iBzbEj5QEmOAXNkiowK5WmQ/IaE8v9ES4bhRI02SoV7u5CW3yekga94x5XySO59BLCqlgN+mgnXJf4UEQ9oR92hcg1Hbh7OYAyA/6qwN4+gl44KbkybmrpOnwX2vuam53Q9F4sNKu7SOHAD5jRYHWacpzO+J/W1Y3KXlFoYx+YGRIfhlqHmCzek3/YDxo0vmWV6bWvFTr+SzbzUU4EUQqKtXvgrGrjR5evXhH19ZiHnzv+UdI5sTKlxVQWGZJvTgzIztRLO3tanBv9VDxnM1DgeldjSjQEn0+bMxjLi0bl0GoRczJoEcoCMgiCWGOEzMhT151tB4WkX1YCzJ6FLqoivXWZWmLDYFmsDtZ/ma2LphODovZ6P7hNkvkqgPoWuXi5de+AtYElIBjIrj8zXlDg05v7IVloPfoUXYJpDXdE353x/EnIiiQhrlFrA2bquss16xdJy4DmtmKB9tkAV4xQcg9QO1HwiMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(39830400003)(136003)(346002)(376002)(451199015)(26005)(2906002)(33716001)(6506007)(6666004)(9686003)(6512007)(5660300002)(6486002)(83380400001)(38100700002)(4326008)(66556008)(66476007)(66946007)(8676002)(478600001)(186003)(44832011)(7416002)(8936002)(6916009)(316002)(54906003)(86362001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dXqu7CyJkTvLXXpUMsf5JXCfzAz0ixir0a3z0ZdLEcKltg5//mD4MjgqPS5+?=
 =?us-ascii?Q?nMYC3SfnrALlGrEh7YwTgxVg3M5MZnOX8ee5TTt2YJspqvt4CTxweEDlXdl4?=
 =?us-ascii?Q?7kkJWiQWPRTvgkaKDEMLXvHQm8XsDBJhOFqCZzpUqa6oMFqn+siFzRznTIyi?=
 =?us-ascii?Q?f0BfvztDZR7s6a5s+fv8VnvltcZCGvgukF3k1F3i2/DlErJ99N0kVjm3eCeM?=
 =?us-ascii?Q?ZgNbI6bbBzBFj85rP4C43nLt7VKRSsHH4T+JDmYKRMUqA6kzLceP70TQeo/Q?=
 =?us-ascii?Q?qE/0hA0kFuM+VtGqtmB1Xv4cJhsFM86z7MWUS7qNCsw4LYM8nTAioFmEs0EA?=
 =?us-ascii?Q?w51oyBTtRXGF/XxpGwxOVfSkJDWo3c6TmqYgNhmP4NdPomNBHE1m69Tun+GP?=
 =?us-ascii?Q?Bm528FenJRRfEZJUi265RBRnqZfuP4GOdZe51G0Q0i/a9GRpMcQFx3LZ0YLk?=
 =?us-ascii?Q?eXBUJzaokERD+s2SvZ/0fJXNQ+H7bPs0P92cKVHTuNLHexjSk+T+4xnK9QdP?=
 =?us-ascii?Q?Gb4sk4BDaeYX7L9cgscAsxjPG89fJSl++jxt2lv/iJJCU8CoBoYzTcuJaPbB?=
 =?us-ascii?Q?IdFrqNTWAkk+lVwBzTUduCUAYlZeR4AdA7MTEAzPouzEJKfI/GgxOubTiCde?=
 =?us-ascii?Q?ou7ppgg7V3IZ4xWTwtZO/kWgLHLdJ20tZf5QRtDAz9ug5N8Oyji2ZbFmPy9O?=
 =?us-ascii?Q?ZvlLVYSWKGGw0uTfZkeaRcq2xnpusMDmE3C05btvVAcPKzlI6K5L3JZLrgGd?=
 =?us-ascii?Q?bcTaMHAE8/a4fLZzUFOAqB4OMuAZHzqCF2WxQXbtl9nwoFSDRY3R7iCGVy1N?=
 =?us-ascii?Q?ALFCy999otcx1BSiKWRX68QOupIGar6xFQPDCv+Y89XcRu52d9nPZXQGQAOC?=
 =?us-ascii?Q?AjXKSYOV8PF1H25sISE/BWS1a5RMqjCgOJsWiofR2G2Hy3yET3NkqgrIb7gz?=
 =?us-ascii?Q?OWo07+BxluY1hNXz5dyx6n1+gxZtJI2Xpodbk5OhGPsAyGNFNDCECifVlIXd?=
 =?us-ascii?Q?LE3ri5xblb9LpUWk6itY1KT07rtoaIJJDGg9cgWx4d/dfBT3GaLlBGk4Zf9Z?=
 =?us-ascii?Q?6ZR34LcJ5TCw0GCukL6PvT0KcrjAbnTiesL3GFxxKaR8Pv8GGO51xzHrA28a?=
 =?us-ascii?Q?1OTPnBSVDZxc7UUhbXBxqu5Ts9nQcVD0g1fxQ+bV8sJMdNxbthHKxhJIa5M6?=
 =?us-ascii?Q?cNbfDXURJ2QpUXsVoBBcgCdGsc5zH4+I5eBevYGg9s8QIx+UPoRsHvcHICT7?=
 =?us-ascii?Q?dALc1mevEvXrsXoDjd8MLKe6P5WgetBrkXphZQso8y1XAKNi6kMoSgUqbzJ5?=
 =?us-ascii?Q?x/x7nBW3p6rfkB/hvu3C5zWpoK0FBqCG8I2Pwh6a5qQl7/V4AYF9mlRP19wT?=
 =?us-ascii?Q?SuCvNOSBKZf+liPSHNP4aycjPLRenRkITEzc5ys0Y7ZQNb+EuUm/Ez8rXG5E?=
 =?us-ascii?Q?eAMeMKeCgCIhyrzo2vdxqeK4Z1o913qx2asFNLDijjDW5QH7SsRRE/biHIqJ?=
 =?us-ascii?Q?GCb7i9hhgH2vyPp0110T7HdpMF5sH3FkxwUhtmRg47kMnKt9rJmxuPnwDL4d?=
 =?us-ascii?Q?S0Sqd8HepUWbvXH0tiuCnpZ+59erc1O0vPqnt7Mnhd/nyk5fVYuzZKpl+7aa?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3d854a-4af6-4348-d5f9-08dacda09858
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 22:18:06.2485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNq/3unm0uFnR35okoh2tLf1r20zBnItVrKrRDzlzLE6JrJ/mqoJ35it7uIWFZltj5k1gqU07AQSfxsS7ug1DDVD2l7Wcu40Zpb7hTI2ENc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4460
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 10:47:46PM +0100, Alexander Lobakin wrote:
> From: Colin Foster <colin.foster@in-advantage.com>,
> Date: Mon, 21 Nov 2022 10:12:59 -0800
> > On Mon, Nov 21, 2022 at 07:55:04PM +0200, Vladimir Oltean wrote:
> > > On Sat, Nov 19, 2022 at 11:09:28PM +0000, Alexander Lobakin wrote:
> > > 
> > > Adding Colin for a second opinion on the naming. I'm sure things could
> > > have been done better in the first place, just not sure how.
> > 
> > Good catch on this patch. "mscc_ocelot_dsa_lib" makes sense. The only
> > other option that might be considered would be along the lines of
> > "felix_lib". While I know "Felix" is the chip, in the dsa directory it
> > seems to represent the DSA lib in general.
> 
> The thing confused me is that one chip is named Felix and the other
> one is Seville, but the shared code is named felix as well. So at
> first I thought maybe Felix is a family of chips and Seville is a
> chip from that family, dunno :D
> 

Not important, but in case anyone is curious:

Ocelot is a family of switches. Linux support exists for the internal
MIPS on some of those devices. My understanding is the switching
hardware is licensed out to other chips that can be controlled
externally (e.g. PCIe). Felix was the first chip to do so with full
Linux support. When Seville came along, it utilized a lot of common
code from Felix. Thus, Felix is a "chip" as well as a "library" -
specifically the DSA implementation of Ocelot. At least in my mind.

(Note: I haven't verified this timeline back to the early days of
Felix... I'm mostly speculating)

> > 
> > Either one seems fine for me. And thanks for the heads up, as I'll need
> > to make the same changes for ocelot_ext when it is ready.
> 
> Something interesting is coming, nice <.<

Interesting to a very select group of people :-) The Ocelot chips can be
controlled externally. 6.1 has basic support for these chips -
essentially an expensive GPIO expander. Adding support for half of the
ports is phase 2, and I need to sit down for another day or two to finish
things up before that can happen. Hopefully very soon, as my calendar is
finally freeing up... Still going for 6.2!

> 
> (re "pls prefix with "net: dsa: ..."" -- roger that)
> 
> Thanks,
> Olek
