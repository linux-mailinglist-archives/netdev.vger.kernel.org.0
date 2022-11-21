Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7FF632E58
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiKUVCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiKUVCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:02:14 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140047.outbound.protection.outlook.com [40.107.14.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F4CCEBAD;
        Mon, 21 Nov 2022 13:02:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUBgW5OlRoAL07GNAF0SKt7N229t78vBoogMhLRzQh24FAul2B3TImtgDE9S1VEaRaKtTAD4bMmd+zB5zCfTgTwpV7HlrH91wOe/US+iuR3eDyqiRK/i3vhTiIwPo8jI0TAOI3IQ7B7VCkucxYjR/E6bvXriDQnJtoknlyQYPMG0o7j0oLcuWFf1MS4loCNXohY7h6M+S3aywZPYBzZY/YmuQN37qfhYah2VON+EVujuAjacDGe15SStKpsA6R6z97aR1F4LXk5zHVyDu/LBovsdu9Ny+Hvgb0r203iYW1NcCrQMo0Cg+U38c7gdCbmCzP4CxZLI65sO7N+uxHJs4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqB+CtUZKuMFJotWHW3GyjH8b15Etc6Y+OFa0GMVVWQ=;
 b=lxtk3SrB4zm1tvngQ2kZ5/G9ba1FoRTAOlfaIDH2+IIX3/mEABV9wMwuuHQQI8J1kHOKQMm5XYypf3A+RV6ClYj6A7JRrXZARZX42qmaZ2m6KPDmxs4zjA7/9JNBsg8IDAJQGIdWwatJOtV0E9Wv3FtgATvfx7I6/fEpOLaVttxCtZbfZyPcagiFVZNHKn+s/aYZKXLfckpVaqiNaxtd1Q2c6lgqmCnrM1xXOTmMKiOc1XgBv8ggf0ur6DoJXdFowHYB1fAtzSi3Ijbv3zBWa0//Pe+qFVBn7dKwm74bjs8kuDsjDnL9rzy2BM7dGhm/+60c6siqoJhSQXPluSr6DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqB+CtUZKuMFJotWHW3GyjH8b15Etc6Y+OFa0GMVVWQ=;
 b=FKVdXQXtOTmybD0jL+/CvY53NgnIsgYh9tQlmvu0ib/KKb4XDkQTZQ4Yy/Tx7/u432w+tXHPygEnejJRRaJ7crPXsxg1wieAIK+ZEh3amM8FqwpzigtG+XUBae2W4UCQGZOP52bWBkOtLqmmeLqdSH+g1dvHiMFRdGR5ptKLcyE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8827.eurprd04.prod.outlook.com (2603:10a6:20b:40a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Mon, 21 Nov
 2022 21:02:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 21:02:11 +0000
Date:   Mon, 21 Nov 2022 23:02:07 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Alexander Lobakin <alobakin@pm.me>, linux-kbuild@vger.kernel.org,
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
Message-ID: <20221121210149.fbv3lgi4vxnqw336@skbuf>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <20221119225650.1044591-15-alobakin@pm.me>
 <20221121175504.qwuoyditr4xl6oew@skbuf>
 <Y3u/qwvLED4nE/jR@colin-ia-desktop>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3u/qwvLED4nE/jR@colin-ia-desktop>
X-ClientProxiedBy: AM3PR04CA0139.eurprd04.prod.outlook.com (2603:10a6:207::23)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8827:EE_
X-MS-Office365-Filtering-Correlation-Id: 61c35ff0-07ff-46bb-8ceb-08dacc03a879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lhpya3jKHrTopQUjYYoYUpXYOG5xkxxtFQhHZnvKUG8xHD6F4TVA3a+vEd6Ief5FUOi7oE1/1dFfsLh/rieexU796v6V3tPEJeif9PYgLsOBse5Th95weajvMGGdHfhDUk8D59t5K8eoCUbDVWIUiDk+ZOAUGweVOfbJrwLvDtam6VZg69oijwnA7VMtwBxf0WCUfbAv+IgO1QJfwNFddlUdkVIhkxo7aOS4GGfa2Wz6T+VOCuTxVdz/B555U/pkrRDsDHAf+UAxVbQZOO7y6F3Ve2KfWV1PZGJjXIfMpqS5bgH+iYOG51ZI2SAoL7UN9gW4MBrm1+17P4gf2cmzCF5s5b5NhRd2HrwDeboiVNMj0no56ARAGlxUGY8hg+ZLWD4zW2EVSeJfywXtQADMk39cQ7xePnhQG74d0rEUHnzWoyU+ELC2FP8Q3c+/UZiEW8gH326mAwYD5hLbSP9qgV/wnEvqF2qlJasTYxY7AufStQxYPra01+Jo8/P7qmoSRdaJEHloaQklOEoByG+EPIvMPQT45KMGD8HolKSsODlBOXGsDSYvd+o3hn/24dIslMBBk7dAKASF/8pvbmXzxw7p0jJBMrpF1zJhi03Pe+rRuDEiKkt0GTNP9Asj335RJ0qngvhARe9Kb/U7D24wuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(44832011)(4744005)(478600001)(5660300002)(7416002)(9686003)(6512007)(26005)(6506007)(4326008)(8676002)(54906003)(66476007)(316002)(66946007)(6916009)(66556008)(41300700001)(186003)(8936002)(1076003)(33716001)(38100700002)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iqatE8oX5Xx7WEAG/XEsz+zwm+euxX9Z8uotFwauEHS6kJ1jSAyqRPwwh6V6?=
 =?us-ascii?Q?BntlCSPd4i+prgANNiM1Lr2MG7ZNWzQfPQtiRH78nNhPkOsWZrh1QRi/vxsd?=
 =?us-ascii?Q?KJiiXz0ibcT4JtaQ2ikDSVs7ufSK4+ZiZpqJb7NBUYm834ylmtfWOrLIOeDk?=
 =?us-ascii?Q?pkjG78chJsVyZjvz0UhlsGn9f+iwCvYABx9L6wI342IN+qmCJDIW1sYmg9Bv?=
 =?us-ascii?Q?uxmR6g/Espqh07fWMrf4/hkpECzXwdO4JUZaBueQDQqVhn25En0vzPtUUnGN?=
 =?us-ascii?Q?4W/ERdl+ZUBUUyw39tYeFmvLJBjK61MuXwsV19MjTFpr/+i96m6XLtTic3vw?=
 =?us-ascii?Q?AOXPB70cCMgVJHAHhL7x4y3HBCS/HtMOCmam1ctJpY1kaEkZEEQka/M77ph5?=
 =?us-ascii?Q?rbSKu0kP+CoUOzgmOhPJLgHwg3toI+hNR3kQRazFK5LrqXZsbCXy2Q4tGVTX?=
 =?us-ascii?Q?gJv/NFoKLDlUMFqeV5eFOubqUm6v5Ie9Qz+SiMlskObyzxPtD1pflGF+zN9z?=
 =?us-ascii?Q?FDxsSjfioKWXgkBfAgz25S0wZsRKCzEXrUaNE/JhRP3UJtb10vcBqMMK1FE+?=
 =?us-ascii?Q?pd2Vn8pF2vgms3vb5jbMyOb5a4xwEXhYii4TyJQcC3BXe2jU+BRjaGJ/8P4Q?=
 =?us-ascii?Q?auIR3F6DNBL2gDTNFOr1ImZBWrd3SGfJThLUuoDkmCJB4SWPbVbgLde2YQDX?=
 =?us-ascii?Q?8fUI06Fk4fxDzT0VWxOviyEtPaXIDnOeLSNkJSyQSFG0YcXVUCfGfkOqbMnO?=
 =?us-ascii?Q?Rw4x47SmWH5T2fkxNBFCjKqNFahQNgwvlnjUMf4fpOsWUB4edppfpk300bZv?=
 =?us-ascii?Q?zRd7dMabsd/L2AKr6ybstwGEEX+BftstilQw+6nhrRktk4fA8Ca0gTlTs2fM?=
 =?us-ascii?Q?eTGrxTrFvCphEK93fXc8PxGQ7C5y7yjOePxyzLIspe6enw+9QFSHYjcDg7oD?=
 =?us-ascii?Q?W3b/9cZTmtxx3/+9l9lfYVSwPBfuX/xtQQYFR/1FmmlyEbrjhum6aZfsXJh8?=
 =?us-ascii?Q?5KAcM2k9WKhBy5sY3WZa3syrD6i1Ypvwq4Ksdoi2fW4NEdyqeIn6zGWLZj5Q?=
 =?us-ascii?Q?6ZTgfinFrB8mn+Cm8GDtiXAzX9GgjYrxE0uO85BOiQfJwyC4G3B0AlxVLtXD?=
 =?us-ascii?Q?MxwgGBA/W8RPcSHXsR9UWvjwyqfA3U0soj+UjHfqigd9yQytx3IV+Xy4MX9g?=
 =?us-ascii?Q?vY1TMogCcaO/syBzO40XXPz4vtjj/NjzLnFLEfrE0Dq6PKKFWyRvXgoWraKH?=
 =?us-ascii?Q?9Y5HnwiQRN361Vq7f0PWRkdj7yR+ynaUyMNtp/7/pROXBEFsmp/QozUHI4Bo?=
 =?us-ascii?Q?MIocbYjqQZh9Cq1cykYeBAGVelIwh2o01cLksqYVbR7WKd28u113gctpCqMt?=
 =?us-ascii?Q?yrU5ipWUxrgfVC6CK0ZcFr4jUPwaYuNw1L/rxei5k1b8Km4BY1EdtL1AGMVz?=
 =?us-ascii?Q?CJabyZjelkceoOpeH6NXoaU1KJJc12CiC58ofMhIxbO4aXFoqYGUI8q3i12L?=
 =?us-ascii?Q?QnDCwjtT90RcVv+bhRMkIjA7jR63mxk1fE2Z/iHNtUeApwlWK8ngwCnm7hfU?=
 =?us-ascii?Q?KW3wYHl2lulcJLD/skxxCUpqoHzsoAjFrlvWAR6H2mZUP90H0z7EKSHs0/+Q?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c35ff0-07ff-46bb-8ceb-08dacc03a879
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 21:02:11.1884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mss6eTbgsES3MdtEReA/pqjhQSrIX2Bk3yIpzXB1pdSLXmAHUHWZ8ulQqc1aknjo9W/eBcT7y+TJQqijJSGSww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8827
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 10:12:59AM -0800, Colin Foster wrote:
> Good catch on this patch. "mscc_ocelot_dsa_lib" makes sense. The only
> other option that might be considered would be along the lines of
> "felix_lib". While I know "Felix" is the chip, in the dsa directory it
> seems to represent the DSA lib in general.

"mscc_felix_lib" could work too. At least it's more consistent with
felix.c and the function names.
