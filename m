Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04E56BE9A3
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 13:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjCQMuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 08:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjCQMuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 08:50:51 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2050.outbound.protection.outlook.com [40.107.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62751A9DC0;
        Fri, 17 Mar 2023 05:50:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9SECcMRevdtksTB9WIevQwdTxJKW9IWFAgJ5S8opdWioDyfvyt8MDp9hAYaKKyXDeN5FILx16tCSzMZX5jVsEbCfcso2TkT+mTbJq5zGw47J4nvY5vfmCgTn+U69/rvhYyGrvh0CKHtxifHGxS0r0SPStl2sUYSWbI2cjck0m6tyWVtL4l+ucoEWL15Gk4LK9ZQIJADg7krgOuiF5pE95dZNoMs61kVYMpYEd9U1p/DmOQTkv8tu8NWMrQeaAGIYchv/T4m6Yg51e7xhh2Rsu6t8eVaqB7vQv9iN1T3PfloOU2U9DWYisATRhrECd2IO1Pe7AiIW3Uleiym/xfq/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jaw/tGXHtWFKwbBbJ8zZvL3+weHDAUzGEM893hEDnM=;
 b=oFUfYBtzmPVlEn3ATy+QWJuQtVK5mDXbfRQskkE2W4ejtl3fg75e9Lx3xwQmeYCI2eb1+u/YFgzjI0oBXbMJL3W41Y01FP18msVP4om1LgsW84vgyYTp6o+k5jCxkkrUCHguzMrY5pMCtXRlNqQ/NNkEimRBM8lVPjzg4r7UkINi38aqwMg5YmpI620xlQ7r0YoPgDqlz/aH8fowtoC4I0wnzqrol6rX4y7O22mdkPjAbBENH2pqHZR3rq6SD4Oxa4OmIpRjLCFSRmf4rlu5TGS/NbBSs/rW1NHaYlZq1vFe9eVQCOK3BQMKegKh5Ze9M+i3FormUERmZ6bOrRFdRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jaw/tGXHtWFKwbBbJ8zZvL3+weHDAUzGEM893hEDnM=;
 b=berNbe4wrEHw3LNzWeoqZDR04WgWSc3hcem/NLqMRWPh8Fjyx9D3hFts1CE5yZyG3/dExkXqRQa+VGrLla5E4W56Ms6PwOfrw1KF2/G2rj6st2zvzYsWQyGrbfKhK/WvSYqZxGf+qCCyMWwh7WLgt8C+sgv5Uyy/kWAw0b7+/yM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by AM8PR04MB7252.eurprd04.prod.outlook.com (2603:10a6:20b:1da::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Fri, 17 Mar
 2023 12:50:27 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9%7]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 12:50:26 +0000
Date:   Fri, 17 Mar 2023 14:50:22 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Ben Hutchings <ben.hutchings@mind.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH net-next 2/4] net: dsa: microchip: partial
 conversion to regfields API for KSZ8795 (WIP)
Message-ID: <20230317125022.ujbnwf2k5uvhyx53@skbuf>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
 <20230316161250.3286055-3-vladimir.oltean@nxp.com>
 <20230317094629.nryf6qkuxp4nisul@skbuf>
 <20230317114646.GA15269@pengutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317114646.GA15269@pengutronix.de>
X-ClientProxiedBy: VI1P193CA0007.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::17) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|AM8PR04MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: 42a2fe6d-d56e-49f6-2eee-08db26e62e72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fTM7d/3b++LQ6RA5mcDDokzRUZ0iD3W+aGvhn6pgwlrUR7+p9a7Jdn/h9ndOJPlWUBzZNEu9kFAHBJ9VM/xCguU295mcU6RF/X1ka081yNJSeY9WuzV8cPARCOFprIb/eIdIm9INUYUF7+vHT5VXCniFXvVQkq5+dwFn7GSmY6RKhw06oapCW1iIDjmb8U5KE0Y68n9xjwKMRGKlNPkmm8gAE93V679/riFqdj2qKd13K4kOjvH4DC9iK+hbsgYehrOTnnvZ0Vx3Tf+Y2B5ZJOmuLqp9E1pD1Rjssp35yzyFAAQ86xySjQ5T2fYnAj4BmRlY96pCgkC4D+5OZn91Brg0v1pn7lO/mIihO7alqorXCC2YhEFnBUMTXUEBULAE1cINdxpVtZvjvoGwIUyWkAOx326cqic5QhHcGptRJvP+ZAibcv7gZImY/PQojAwu3YFT5HgPKDu/pXXdGWE2+sSZZ+GtKW0re5ZsQLhXZGdekIWugLI0A128a787u7NeKHt6U6jKxmY0wtpj1gNRpYu0VT3gxfJXzArF7eGPKrg6LLPwBfroD26CQaH+uBOyTldfJbsO7/xnKGDt5xzYOr4oeI6fF+DBPw38yKDQY1sX4RAn3AmKds5bCLaogKfK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(396003)(366004)(136003)(39860400002)(376002)(346002)(451199018)(186003)(6486002)(966005)(83380400001)(6666004)(478600001)(316002)(66556008)(66476007)(66946007)(8676002)(6512007)(6506007)(1076003)(26005)(9686003)(54906003)(6916009)(4326008)(41300700001)(8936002)(44832011)(7416002)(5660300002)(38100700002)(2906002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c/z6bEf7rBEsh/rWkL92QhN+N/F+hzn4KwY0O6h+85mzunjPmUt0UcvrXq4Q?=
 =?us-ascii?Q?9Fiuyv4LL/QCP1AIsn/2ObiWi0AKpV5lFb1ha5RHvW/3Gg6Y+OuFEPBtTP3l?=
 =?us-ascii?Q?W4gMz94rQVXKZmOaHYAZrcipmcIpqgtYjunc+Dc0P9TyDNZAeR7gsY60XIIU?=
 =?us-ascii?Q?Eczx6h7BStOHrKVDjadr+Oede+8aJrNHJN7R7d9/772IRM1UGKfFidibpjZ+?=
 =?us-ascii?Q?H0RJVJzoCIRxCMyBhRx85ql3j/3+vGJ5YmECDuQLGn7DE3FNFBLHc9veJ/7T?=
 =?us-ascii?Q?Hbmc+npOgkpSDBDk1cjofUCRkzRSPwDSkiqc9BmdiRL8uhKvGzKubsp0Sthn?=
 =?us-ascii?Q?BzrBdh8nlOvb5RSIB95cTqaq0ax/7vz23u7aeYSXY8m5tqsMzM1enzDXidg1?=
 =?us-ascii?Q?eBo+7SrlUU7wc15BgmwnhR/url5OsiUOpuxP+jxoTXz1q86L7knfbM66bYUl?=
 =?us-ascii?Q?mD/ugVu/fHgoL08flIWJY1xte2kctYLjTFb3e6bFfkB6K3+uA/tAjEo9ydFQ?=
 =?us-ascii?Q?npyaOsDYsTlD4TqHVnbxNqKqC+Oq72svosX4uNpOvNEfuePba+E+4NxL/ex5?=
 =?us-ascii?Q?g79QeZ8+wu9K22MMPNq7mpymbYP4i5Sh2HF/dV3eqGHVmnF7S446GvXywvIc?=
 =?us-ascii?Q?sWjL4Ms5httmJu555FLo0e4Pk/jCGwAeaxOCfCw7OyJc0z4Lfl515LRTUy6Y?=
 =?us-ascii?Q?CzqBLTfYQuAcXuOpL5Ccg3NQLuk/5fkiDTmRJrzJ2Unkv9dhKHFoGe3mySjm?=
 =?us-ascii?Q?tHCcTiKyKArW0pPGFIBvNVNSl+RTPX3o2kUHzghIrJg6ou8+GPENB/lLDKLG?=
 =?us-ascii?Q?MRWN90bcofYkDa9W1lyTVo/MahgA3mRHLNEB9eD6/zbCVFrEMFDJEjEO/aw/?=
 =?us-ascii?Q?LDs1q4Pb6HXiVAEnHAvN9KXyYFY9XVgm0waBcMcW644PYDvJ139y5KyoGeaf?=
 =?us-ascii?Q?a124YFITs4gvBJKYSqFxzsSakhtMs/+cdhs+e22waK2LWc9Etan2UvjRe83X?=
 =?us-ascii?Q?WgZXWlEfSvx2lvtMXILFGfm/NcQ0MLO2xHFD++asQYhYInYGEd7RJsoeyV+p?=
 =?us-ascii?Q?E4P+rSxMggr+ILHiiYpyE31H9qrYZYqhUoO5RkZB6a8R8SeD6cG6u/oNNH20?=
 =?us-ascii?Q?gDyKgGufzJAf8vfyYRvj6bYQ880gh1pQmrGnGHssepQexJsMRxd3uxuvhUus?=
 =?us-ascii?Q?EXeSONYJcF8PSabKZ/SfPzR5155SLMAmLUisaM+P4XXyoDWPkGcHlCGiG6hK?=
 =?us-ascii?Q?rSDYlWmw+gw6JhUiLb1UyLDTRsdPLpSqOO5zwPQvQMAaFROkKKAZ52afnERd?=
 =?us-ascii?Q?lyVVeOansbrQlIL1wjY90ieWhF+ewS1vAzg5O4LLfrxADvVFvu12d+IcHkHU?=
 =?us-ascii?Q?JLo6x9lqLbS3IT3cY55bYlB0CBZWUfyH2u4PGzYozLVGvJyUf3eyLRJF6FD/?=
 =?us-ascii?Q?JEG9/J4H5ConOKVjOIbynVf826VbFiC7LKNew9yqoNv6lUdR3UtxI5RlSLLu?=
 =?us-ascii?Q?mvMqdO0EkKcJgV1lXpUhQXecaONqZsIIECpaHcZrzDJw5W/SVoVEbieFVp1u?=
 =?us-ascii?Q?riK86Kh5KoYlauVSViANtFLEPSJgeJY50KB6N08wVIi8omH3e6PVGuysxHrV?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a2fe6d-d56e-49f6-2eee-08db26e62e72
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 12:50:26.8188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bPh9/mXDFzz0HAQ0ATrY9HuFcL6PSrX9ZyCYxQEZwewQ/yyq5WNdDuqQQBay1mLeC6MxLCpwNiGuzuOMt+sQHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7252
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 12:46:46PM +0100, Oleksij Rempel wrote:
> There reason is that ksz8795_regfields[] is assigned only to KSZ8795.
> KSZ8794, KSZ8765 and KSZ8830 (KSZ8863/KSZ8873) do not have needed regfields.
> 
> Please note, ksz8795_regfields[] is not compatible with KSZ8830 (KSZ8863/KSZ8873)
> series.

Right... well, it's kind of in the title and in the commit description:

| !! WARNING !! I only attempted to add a ksz_reg_fields structure for
| KSZ8795. The other switch families will currently crash!

If the only device you can test on is KSZ8873, that isn't going to help
me very much at the moment, because it doesn't have an xMII port, but
rather, either MII or RMII depending on part number. AFAIU, ksz_is_ksz88x3()
returns true for your device, and this means that neither phylink_mac_link_up()
nor phylink_mac_config() do nothing for your device. Also, above all,
ksz8863_regs[] does not have either P_XMII_CTRL_0 nor P_XMII_CTRL_1
defined, which are some of the registers I had converted to reg_fields,
in order to see whether it's possible to access a global register via a
port regfield call.

I'm going to let this patch set simmer for a few more days. If no one
volunteers to test on a KSZ8795, IMO the exercise is slightly pointless,
as that's where the problems were, and more and more blind reasoning
about what could be a problem isn't going to get us very far. I'd rather
not spend more time on this problem at this stage. I've copied some more
people who contributed patches to this switch family in the past few
years, in the hope that maybe someone can help.

For context, the cover letter is here:
https://patchwork.kernel.org/project/netdevbpf/cover/20230316161250.3286055-1-vladimir.oltean@nxp.com/
