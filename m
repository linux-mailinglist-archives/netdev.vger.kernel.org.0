Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE50F6329EC
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 17:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiKUQrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 11:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiKUQq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 11:46:56 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140085.outbound.protection.outlook.com [40.107.14.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073AA15734;
        Mon, 21 Nov 2022 08:46:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKFRNU1LBCaqHv1tKP5kEpxKEtgGEdGWpbXSqxlQFHtIh39n6NxHCT7laU2zd61A6b88EPd0mD/WTUXcAQhdWRSdOVg0U/oOxwdYp/05qfkmTri4jc2Ebei4hf2uRYAshajjsYgR0ibyaOf+lC3uFQELb3CXi2T8TsFMYdbvLi7JlYIminD3P3ErMb/i+isNdExVUbPAz+hYJDsZW+cvKluD0A40eyx4Kcq2tl5uthdjA8Rky02KN+6X96HrFPvvgc+detk+xIM3e6jWU42pblI6yANb5dMtgA7zWJxZ1oNwEMxQ2IGRMerzbm1ot7S25szCPU23yhZZl1zlP/Nn8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=drt2CZbHDv2IFie6pLz/rPjd4XNuu0hM3WjY7RoNinY=;
 b=XcrD37OiZaWnlXPMeoNdZIETqEGhgQwfPQghkM206ncQ1sK7CAav2LUIBQn8YLYxXLCcf029fpJzqjTY+USqAVXDYSj5U4JoqlsIOUT1BvoXAoS/C7Qwn6qLxWUZizi1nzNDKOLSG5BGMg4FJAnd6xCT2KpHdXBdJcwntLlj0Pl8DUt67iaadVBxmTS5pW14WxApLFb9xNlpwJ+c+dA+h/xkPww5yK2+MLwXzUliRhUh8gDRcPqhz5dRoDjAN+pIk2U7o+h+k1Gs7T+S94jl2NkJeW405TBak8qQxRd2Eqqc1MZ2ofPVGGtd0HOi8qZWwhnZzzHi+ZF9cUEU8RAi0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drt2CZbHDv2IFie6pLz/rPjd4XNuu0hM3WjY7RoNinY=;
 b=WGxjG3T9dn15GL/B1jhi61OzmSFZZWyWS2ctDTu4c199TMB45DKc0ffn2Tsbkx6eR6Nwz2/ZBXXVkIt49DCA3qT2LKVppykAg/5WWEjb9J+hPzAutjTrhtC7xJsKYmnuwwuo2TaTFsd9GD30e47laGaxFec2NEwltwHPsOBtPfc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7356.eurprd04.prod.outlook.com (2603:10a6:102:8d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 16:46:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 16:46:51 +0000
Date:   Mon, 21 Nov 2022 18:46:48 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 net-next 1/3] net: mscc: ocelot: remove redundant
 stats_layout pointers
Message-ID: <20221121164632.zfbqka5i3haelmou@skbuf>
References: <20221119231406.3167852-1-colin.foster@in-advantage.com>
 <20221119231406.3167852-1-colin.foster@in-advantage.com>
 <20221119231406.3167852-2-colin.foster@in-advantage.com>
 <20221119231406.3167852-2-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119231406.3167852-2-colin.foster@in-advantage.com>
 <20221119231406.3167852-2-colin.foster@in-advantage.com>
X-ClientProxiedBy: AM0PR03CA0103.eurprd03.prod.outlook.com
 (2603:10a6:208:69::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: eb499f6e-b4a3-4437-3ea8-08dacbdffd69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UfBDRdPyG1Wl3kXF97hRu/qvg2kL5pU3lg5GNlxQCO16x3RyIsiUE2qhqYdY8VpdSqxU0mNJsxlyNzWajVxGGlCCYZTjEjRbgTMqyNi3AYSWncGcc2BysA/wYqP0e/N0Gu0XRPi+8sqyxXIzWmclQRSyAa+Gdn+XvWpX/hmQMjnpTEC89JKBz3LS2nXVZyXEUkAqi2ALcSOayodsgG3t5ssfeKjwEXaWsxRc4Vdzt5PnwDLR9FwPix0PCTGAbvxHeVt7c0skC26xKlCXnJu2eEWJowqKW+SeAFjyFDCNjaSQbGd0Ifwr4rmSU7gWNOw9YLJGbYNKiF826DkMXuwCX8Nafh0d4KnX+Al5qOegzuTve3hjSm1rqZecxr9J9g8DWLcLcraB0q2P/+mnF7A/jRs3qxLHPTi7zSrKVw/lySh9tCwFjNoGv/f/cZ8PWI+ZkuXOhL0LZ1dvE+Px3qenuz/CYGvhOFVKqC2tnoGi8HXvjL5gdwDsxm8HwTulWz0fkNs2vSRo7wLutLao0KMsFKd3Vx/sLnlLqNZFI035vgQiFvdn8aygtGfE52Gx8UA9SsloKCDsG2fN72YiRjqcMbNnG3kguKdnXLcR8hblsvrLMOu6HzMQYbwbZMk5G6ge97ZE87mmnz5uoP/LOauwSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199015)(38100700002)(33716001)(26005)(86362001)(6506007)(478600001)(6486002)(7416002)(6666004)(5660300002)(8936002)(4326008)(66556008)(8676002)(66946007)(66476007)(41300700001)(316002)(186003)(1076003)(4744005)(2906002)(54906003)(44832011)(6512007)(6916009)(83380400001)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fBtNR1ARGhxglxuq+N2I7f1zYznvsVSnJXd5ho3SuqejwGLKoN3tjYM5TdTJ?=
 =?us-ascii?Q?L14/wkISRd2HXmodIGELQopiEGTLPrejDoL7esAHfGol176jjt8QfM7kstwJ?=
 =?us-ascii?Q?NvsPOi9IdAnd9oKmpd2iJbouaWOgmu1ehnTFM/Y9QgObTPK8fflORgHzsW3i?=
 =?us-ascii?Q?AABhrtQWvq84UK5M/hpSXvCsOvjVDlUB71WYHrFq+rQW2tla/Knfa/1X7GSm?=
 =?us-ascii?Q?cdlTE2xUxtyeDMvmz+DSBLmWs6Pu2vJXp6ZGaxIuMMITYwoV/Feq03Ym6RCb?=
 =?us-ascii?Q?hBCN+nHO06oJ6A5sdHSQA/b5Yzf/GS6xTiPOxJYj8JBnGR4BEu6rV81XAY2B?=
 =?us-ascii?Q?PErOmh32wTKiSdhEujSB1YrLlZ/pGe2E4UshXSeRKqUIvQHjXhYAFVp5mbfd?=
 =?us-ascii?Q?PlgF+7D94ltRw4pKNXy9SejDXD/7iQNlPI4RfVUk1Hxdy2udIJLmpoyAETou?=
 =?us-ascii?Q?nVx9MDfBfXjBFR+eV5MxN7G3PFwPm953ZY0je7dyJJp3NmlVQ+OcOdPr1pBf?=
 =?us-ascii?Q?9UYp0+5L9FkvdWnzFqaFm3CRnLYyicF6ZiWhvsiEzUQh5lE7K2yFfJjrdz6h?=
 =?us-ascii?Q?/I8nTuHNLvCk2tFIyyI49Zk4zEBwKfnGJW+ZR7g3J2Zoc5+CiU+m/4PwSN8V?=
 =?us-ascii?Q?fxalXpdK9s9O5vbpDKNBaQJ2OhDAnsT0FZmL+lBJ19XB4ZXVTAoj0Ja7hwXN?=
 =?us-ascii?Q?Y8UMIEZo6y7Jw1ncjxXdW+xYPlobi+a3MZrVnlPnThdF9pg+gItsakzmKR4X?=
 =?us-ascii?Q?DvZOhx7eMfPOVi0ynhBiyhYoEtCQVeBgGkbkzjrLROST+hiAAYcXpnfZ5wQf?=
 =?us-ascii?Q?upLbvK3RXJv4993Zp9eedPFVaVZWupjjphq1JoVe8of6A82zPQa5Si1WxirH?=
 =?us-ascii?Q?KZBSWJJWwi00ut72UsgDj1Dbpp+naOa3zwXwB5GiGmbCNW9BHVKZGJMmzR8+?=
 =?us-ascii?Q?9wa4ZYu7wYT5nT1mLYdRp3Zd8kNm0FWYUS6nVi3CX43FuJYiMraEZgqVixm9?=
 =?us-ascii?Q?tP+NYVH4oMa7EgDRuNfZVSEBIbpdOy/8Vqn/MVZdYVnj+C9Y144efOG0RcxQ?=
 =?us-ascii?Q?x5c7yg4ia6HJ16dll8UukVNsNTzU25W6a/gvhCuI+iou9Q1xVs6YjCVkVD/7?=
 =?us-ascii?Q?l9djW/e4xkubvsvu8WfdeKVje8jTWJPdPSHhvxRGawVGOyAofBM9yXZlo900?=
 =?us-ascii?Q?063oSuUq+4jZRRKmWDQHQrzUCNXkIf9mx7rhAIGNLt9nuQRNv4xbTDt6znt6?=
 =?us-ascii?Q?00XnUeTGU1s1FyBgJ/LdsEq0vmt5ArKrh3n4hzbCiRNzeNksgSMU1l2+G1Ph?=
 =?us-ascii?Q?iLl6EA86hoU5+KIKejLlSsl0q1Vwl4pL7oEKKOA3IBjBbRc5BmUurDFJMyn9?=
 =?us-ascii?Q?IOXYw7YZ0LaiG2SuGVnVwmjso7mR+W/hdKQdgfnDZLBT5g4uuNpRxRasJkUG?=
 =?us-ascii?Q?NP7NhLq0BILY5TLL1WpQngiGguj3Y1VFs1IoOh3GCjWt7zJC7Kcb/kV+N5bT?=
 =?us-ascii?Q?TnsHOSGCD1B7WKOSIXeLGLB6MhPwxaqtWvKkDK1189CQX7S8XAM+8ztmRkPA?=
 =?us-ascii?Q?wV12/opeeG4/wak9nR2QBA63EqpO1nTXDmDSD3XofYfVP0qPNvVExeUR4eBH?=
 =?us-ascii?Q?Ew=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb499f6e-b4a3-4437-3ea8-08dacbdffd69
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 16:46:51.7587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9vLTATdfuFYJYgkpFSGDi2MoljSP9L89NWqJvwCkT2N7Xrjl4PUgqV28CP+9MJ3SCzcCe3mkcSZ5fGIZMVdR5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7356
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 19, 2022 at 03:14:04PM -0800, Colin Foster wrote:
> Ever since commit 4d1d157fb6a4 ("net: mscc: ocelot: share the common stat
> definitions between all drivers") the stats_layout entry in ocelot and
> felix drivers have become redundant. Remove the unnecessary code.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v1->v2
>     * Fix unused variable build warning in v1

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
