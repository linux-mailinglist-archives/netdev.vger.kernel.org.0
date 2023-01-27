Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9C167E6F7
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjA0NoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjA0Nn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:43:59 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2086.outbound.protection.outlook.com [40.107.104.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00B23F297;
        Fri, 27 Jan 2023 05:43:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DqtG9Dw4MwNwo4H5oGo2up9j7lCwawSIOKhaNWYRYfftyO6BcrDT5yW/u4P1kKmmHbgdtLGNwA5oH3uR8Plzy1upgNk2pk1BGg8v5UXjzaqN4KVyQN3tmGVT3DqP4KLFgqW6+cu9lCs6rDcEROu+5dhhQE0W5VXkqiV80cXxB1FzXcvsynBn/GwtlwZo21cef1Nq6+5UMVfP80ZgVSb9cyQIn6cbVO1toFvd16Q3EHW4mIDZkY97Iu0adr8JOCDBA/jgl95Jhjk267F7l/wN7BILomUClNdgJ1MHL4GXvo7EAqdMoUKbNbb8jHDprRK2ruFcAywfbKOm4GaU8Vnx7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUYtnvURHjAxle0XKTRxHpGj4DthXZ8tztJrF4PoOPE=;
 b=OJfCiBpl+Pz/pHVZ+GA9yjqZr7BuBf5V6G2btQ/HqZgMHxPRKsE+WVYi3aH+LVI9c/NJA15E+oGWci7ndps6c//nF3BO38xfakoOjkCd0T31lG3iKpvFs6TucstqBNDBmeTw1pGgJIOwk+8c8aW5XIqod58svdWClxkG+1tU97zRvFS9PzujfCC3/h5wGvXeWbX4goZGX7GJLGSsDeWAEd7/owu/u9WLR1jc76uors63W8tsJ8SQfFESlJi/uUH5bS3OLWOu+ooSiGqDy64TrPnm4U6ovI0Yrtq+MnGktIFQ2DJar1FPDb9dH9ZDhrp52Kl6/x785pWH0b/ggZC7Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUYtnvURHjAxle0XKTRxHpGj4DthXZ8tztJrF4PoOPE=;
 b=Qzu2ah6zX+9R2Pi8CB3Ueq9pEEKL23RBzubC6KyBHHnIv7sR/AMpSwUjn83d5Ir+5FczBOjFIUaLMiIqWAgBZofeiZJvZmwzaXKSLJspwS3yII1WXno6CueGFrOYqbpeYOWJPlV9nx+GS6QNwgO5p8fOPmxzB5D9uDxyqRrP+Oc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8210.eurprd04.prod.outlook.com (2603:10a6:20b:3e7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 13:43:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 13:43:55 +0000
Date:   Fri, 27 Jan 2023 15:43:51 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: pcs: pcs-lynx: remove
 lynx_get_mdio_device() and refactor cleanup
Message-ID: <20230127134351.xlz4wqrubfnvmecd@skbuf>
References: <20230127134031.156143-1-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127134031.156143-1-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: BEXP281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::18)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8210:EE_
X-MS-Office365-Filtering-Correlation-Id: a05466c5-e813-48d1-1a5a-08db006c88a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ej23YWYxW2o+5mX1KKuIXAfrBhQLj6vroTTxpTyEwFVApoZYb6NS57fwQc+7DiMQZttdF6yfoMhVUGlajTba+rCL+q2Xy0c39wgn5fs04cgWb88uFzqyVkzfA2jI9L+kawWNT20qgaBzvqQcyyw7OewHY9kcWlSE+CiNpIk88yzL6t1TBaHrePMSGuAAGnWyxYcPb6EMtEF7e3y1PKlQBK2iuTXiCqsUlbC6RcqUIN8JFXzS2jdU2WQEKf50oXgDhQg6d19zhNdJASJiAwHpHZ6+XfjMtBlC0FkOxYjyAxHhwTtAobWxnmHAsAUwlwA40zhdB8WeGhliTCBNBNPiikC/7IDGr3RGSvmL91PmvJcRTKHpKns/egfFsj9zh0NdDy6UWQcRA0KPYVxV/5HDGYF/VRdTKdUaztr29xqMnBF1RRhONDrdw2FnUPjUeIAGH77jPxs44yaFyVXnV0k0u00cI7/w0PDctJaehtFKtjSqk5YuLLIs47PzwCxZAX/lss8ZoSYBn/XU7FIwM0Irko8U3+ygDNhbVWtDOWosJ592xyMeOzBR9OYwXDmFPJjwBzHN4+5IhJ8HUXmrdQBH4BGyrH5IGIvWLG3bZWTXdwmqKZNZ9ChTjiriIKZ7TldtIlKMjGj196NGS5e6VxsV1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199018)(83380400001)(2906002)(186003)(9686003)(26005)(6512007)(6506007)(1076003)(33716001)(6666004)(4744005)(5660300002)(54906003)(316002)(7416002)(4326008)(86362001)(66476007)(6916009)(38100700002)(8936002)(66556008)(41300700001)(8676002)(478600001)(44832011)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ABu9gHQ1T5qq/WMHfCXPxXdscOr5koYuh7GC5QTVsqJdmv1MMMOO/th8NAVQ?=
 =?us-ascii?Q?EnTAThtZklEmRkxJFsvSeN/eWN4MmANiWJKi/mMncDKTUbM5egRqk1Gjb7zK?=
 =?us-ascii?Q?YHOmoCgsxtLhrOCoJEaQFE3aZXt+y+elEkquX/JSXG63QpOZpneIA0itmpTh?=
 =?us-ascii?Q?WURbaOYKniH2DE2yrJ2AOuSZSwfSWZGdeFc0ttFLtnbFc5oEVngNi+pfZlnj?=
 =?us-ascii?Q?k0r34bnApSlLsGs3O/yfpNU4wc2bozWXIAKmvCf0lCAk3duM4tqlVLtyuWET?=
 =?us-ascii?Q?p7wYxbenu7nyZci7mTkJCTZy+0h/j1rnMfXK1OSdDwDxEGRSR8oCvba9N7Vi?=
 =?us-ascii?Q?mSBSdTtrdUz90lF/lkTynaiLdXrws0I2SnYfoiMrxG2bQF5yOiFNm8HmZHqe?=
 =?us-ascii?Q?UlZ+A1HQ2ys3ZAqtCOKFp6y4TFUdTeVNKoTzkKwWUfC9Of8XS1novdSbDTGa?=
 =?us-ascii?Q?kIJUqaqTKIEBZhTWRQuEnGEEXS3wM283eeBvRxPO1ckK8lxTF5ij0KezlpCV?=
 =?us-ascii?Q?316lV5J29kgQoJ5PmUHIZCcTbLmoLRvpm+fPW5U21HEtKq9ULcxMLdtf4qdf?=
 =?us-ascii?Q?hebyE7KeG2vEcp08WMsp9gjJcudKXxRFBwAuAAPY1QA6n86SSejNPmi2EdxI?=
 =?us-ascii?Q?jL1zhvgCyelrALFstVTJf6qJ2W9WDpKeHACmvyOZINq+NudKpEy1lw+domWf?=
 =?us-ascii?Q?XI1rsFIa657XepR+fK7syhM8NPFW1Mt4s0/yh4xNdcGELiCFZegy2Nu9I8lI?=
 =?us-ascii?Q?xW/TbHQrKqpG4DhCWC7lYhbZznmBZGhXEJS+aQVEESVt3/NNvPOzsiS2qxgE?=
 =?us-ascii?Q?1r19rFISWAHeedLa8wbeyvA2u8zihyPBAsCj93xtyZplD35ixx0mMrGB21xB?=
 =?us-ascii?Q?7mpH6wdYsy8fJbB5ifGZofhHnrUGaTyC5Ifa6sEZKExsZB9bo/qudaTcvCUM?=
 =?us-ascii?Q?Oza2ExA829pDKyQiZfOLUaFb9gPFTi458rEoUZfOudIOXuVC2arloeHeqAEb?=
 =?us-ascii?Q?vwa3V4kLipc/vjXTEBkiI4to05ss8X+wVuvh3waqhC6yQczOkq9CsAQdC5p1?=
 =?us-ascii?Q?5IA048XLQXF1s3oBmTtCZSgRVMb28NMkBI/7mAeP1wLx1f9RmsKdxJmC7ISY?=
 =?us-ascii?Q?2uroKhpY6W1fJp9JxmdJDsswImrXAcfukROptrf0mCVDK2tCyNGE5OyXHNN0?=
 =?us-ascii?Q?up8/ttr51FwXeVn/MDMQLPJsuAwCgbbdlB4oOZz99jZebHdFTYJQN0n/vTig?=
 =?us-ascii?Q?lKbsocp3rYrg+jxC9MS2N+WSVNBXmZwARkZ5bQr9UbNkTUZ8ifvma/k8idJn?=
 =?us-ascii?Q?BuNPDCwMWklCmP+lnNRUkReDuO7QxiKb2tyLdCuHwPxPSTeBV0hWO5eoU6rx?=
 =?us-ascii?Q?W9sl6q7HkzlzORqbyTZ65M+rE2uII4J2gk1sJXjixqEwVmS77rJm2wnqbXX0?=
 =?us-ascii?Q?p6x9evLTllxwkKegvNqgKs5OBRoiVo/rc+xdm05fvdmWYWF84LoIB7Wp2Xwt?=
 =?us-ascii?Q?Mkvrk3bzUxkadcDfzjPlSTU9IudO13wYk45fUj7xdddPal6OQsvdSL7hAuM2?=
 =?us-ascii?Q?oR8XuWl+IoMI5/jcg26g/+/hVupIK3Tl1RzlwXXnePth26caIPpVrK0/t4mx?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a05466c5-e813-48d1-1a5a-08db006c88a4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 13:43:55.5105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i59cIxTtufJIRKNhHaEf4ioj1dnam/wVKt7JbOIjAvd6ZRpKK65DewkSR8GQTaV8GJNp9+O04OuKxR4p1DrReA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8210
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 02:40:30PM +0100, Maxime Chevallier wrote:
> One of the main difference is that the TSE pcs is memory-mapped, and
> the merge into pcs-lynx would first require a conversion of pcs-lynx
> to regmap.

I suppose sooner or later you'll want to convert stuff like
phylink_mii_c22_pcs_get_state() to regmap too?

Can't you create an MDIO bus for the TSE PCS which translates MDIO
reads/writes to MMIO accesses?
