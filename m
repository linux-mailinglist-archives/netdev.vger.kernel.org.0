Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D11655E70
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 23:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiLYWQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 17:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiLYWQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 17:16:37 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FEC1032;
        Sun, 25 Dec 2022 14:16:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpcqzWKE/p0fdpu6YE57Ebp0JdfqWv2eZ6rlDU6id0tzD9OwoxDaMN/TLY6EaTyBm3czmtJPeOUCdue6TDyJ1vOODY0oW3Om3pxX8wqeNX5q5LeO/wmJI0KR9e/Zvd7L++5v6F1HtcUMAq2Hjz32SE1kKbgj4ZkkLdxnwmTeeCb3r9UD+ogFFUj2jnB2hPvXDh8tghLLt0XM6Q1VOAl6CnnHQavbABuS+fwMoZmzDzSkNMlpyuxfkYAyH7U7XN87XlhO1rLo7AWDFFjA8gvnpQkNcB8LB2YZRpyEW+RImbBxHm9XJ4ihHWY5xG3AJL7HPNDbU2swl/YOTQ3d7RLBxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I6qZrCUtMlp4RVyWBVpu0QYiR/GytqxBiagtAPKtvUI=;
 b=Sv1ibX7EQHOF7EFNWgJKwfyTF6gwWVzTU5qfkcScvXSzJaAM/vlJyCP5fN3LZdyj1eUxEjpIHxjBAfiEUDQgY74jkLfcNCUIAWXBxaV6wBtoYsRttx6Wa7OiewXBrcme34bxEV2m2Hpq7v22JDKLZZYOE9ogNgUBaBvMgJUaaxVDl2W/eW0Kuzi6sY4KTkFZ64x2YuhoAZ1bVLkObbFY/KCpu8jdlVMCT6B2mf1OgRujtsqdUIqWF4+DhQ5rVDaiShVelIUW+k/eVISNb31BPUdxhfba5Yejjq03NeV43MIIDu++d9fM5oRLpi52dFTguzv6SxlI6sd+XZGOUg5ElQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6qZrCUtMlp4RVyWBVpu0QYiR/GytqxBiagtAPKtvUI=;
 b=sH6+o15XnjSv8zWsOIM+KlKSq8CkKgpb+bGpIGxfrmsJ89NjquL4UHKKUQmLE7nOWSaJfpoOVY+Vob6mEjqrT6qJbv8GoiuJ2MrwhcXmutK1I2kb5Al6FDt9FiD5LuhHVNk7aYDc/XQxduzGv3yQymCvOQe7Q/A9PMQ155tW8tQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8076.eurprd04.prod.outlook.com (2603:10a6:10:246::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Sun, 25 Dec
 2022 22:16:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::7c13:ef9:b52f:47d8]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::7c13:ef9:b52f:47d8%6]) with mapi id 15.20.5944.016; Sun, 25 Dec 2022
 22:16:32 +0000
Date:   Mon, 26 Dec 2022 00:16:28 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     stable-commits@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: Patch "net: dpaa2: publish MAC stringset to ethtool -S even if
 MAC is missing" has been added to the 5.15-stable tree
Message-ID: <20221225221628.kxllljzeh3h4zwyh@skbuf>
References: <20221225151438.695754-1-sashal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221225151438.695754-1-sashal@kernel.org>
X-ClientProxiedBy: FRYP281CA0011.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::21)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8076:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d8233b3-6db6-4805-5790-08dae6c5ad4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ys4tnYkZaei2SdaNLRQBDJzgo6il44WYAIHnC6nxCiDfZNo0xFI0E1W9GeW5J/4ozSG5BhnTE6BeP3hofeZjy9RIWuXzd4wQz4Ie5G+RJvm0T64UYJSKZoxxZllbaaw0wpg+whbYcBGeQlEydJ/0X7P0XR7u2s6UBCptmqi3QSQt8dvqavyOXSCmsXDKHaza+IJtq8QDc+J6WmdaD4XFACJahxvayRo3tlaWa7H1f8QUfPk4JoOzi21dsCB7z51kukSuAc+ekUnCZmsIZAWlI2eHfD7ZosdwfkTxrX2PXpg889ZYgXsNRgHaeiucoHL7U29zNdhimZEm2lTfun8cvVvXWKbCQ7PTd8oNtxjYsmmfB8KxbfprKtwwvxtXTBIHzKEHm6cZgDKcy1AXaeFOypzaZGrmNMgpLEUs3jhwSTqAXba39z9QVCBBuT+1UF2cC/29IcRwkhhesTOZUklIGpOcm1vSgX9SCH3TJnQSj14TVufocng1NZG2cDGu8hp5FFFXT13+I5iZmdM88UtiE3sb/2RfQa0xPq7H6gPC/WDR6zYFtDjLw1K2jDCR3g4KVI79chr74m5BZECQFhMivNg/JgSIJ9QaflvO0AJW1R5SacGl6KK8UDcWlz9yaz9WYBVtf+q898xCa8CXyklO/XIEpTUP8jH262NcOFITXaGqPoXLSK9iVQEcCtkVGUfvSRGyCAG82k3Z25gZZbiBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199015)(2906002)(54906003)(4744005)(6666004)(316002)(44832011)(478600001)(6486002)(1076003)(966005)(186003)(38100700002)(6512007)(9686003)(6506007)(26005)(33716001)(86362001)(8676002)(4326008)(66946007)(41300700001)(66556008)(66476007)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NckK8Maj9MqpV5IYr1YvXUy49dWt6/bxD2nSBTS7TBdPwhEjy4YnUSghVrft?=
 =?us-ascii?Q?2Z4+DkQflMo8msWWQI2edx+FdTeo2stcBnhrGiiz8wnANvzWtzyF0f3Aj50/?=
 =?us-ascii?Q?NhwoX4vBBY938sbV8O4OdYnQPjSrHixgh1JGvYtb6/0M6vXQF0P9/zgO2OZ2?=
 =?us-ascii?Q?itLtcENsZs2Je0ya3iGJlX1Yr7/+E1R3vPDkegGPoL2LNE9PXZ8H5iumV/qj?=
 =?us-ascii?Q?2f0ieiGTLChhcyeRWtw+D/LH9Pmyyw9Geeu1NzrA2FBbmv1a3UVREXwLL+NI?=
 =?us-ascii?Q?v4UZKNXzszNhfyp5jB9CM36Flw9zbfscmrPMufmFRiE0RpUMZmDkgFcK3lUf?=
 =?us-ascii?Q?xH6JtZGeSEh/43mU/4q5S8OmdnKJZsZwxwyYpYMM3AE3n9Ub5UMLfja/pWTP?=
 =?us-ascii?Q?QOLBxAUhcWkVkQ+hjDFz/PQGjK+MiGjZIUmRW5Xc7zbvJpf60jED8JYHvQm/?=
 =?us-ascii?Q?WtveT160uQbE0QBxQmxF/e4OaDS9oJmDk9cfP3aXW9iuXsqRFuCovlKvKuZN?=
 =?us-ascii?Q?jprMUILAc1d8k3dc5MB6YmeIWhbrkbcMlfWbiC+28CuaSixT1ejkQkw1na6g?=
 =?us-ascii?Q?Xt16eqxvelzPUNrr08qKITpF2FllONAfIOyWKa6YakUnWtqvVBfGQQIeiO9e?=
 =?us-ascii?Q?xgNHY4cK5WhkfgJkon+91YYQwlBok8Ott1nujjzimmbC+yzJHhuRTzuBiW99?=
 =?us-ascii?Q?WajwettDhCFjwq3EgFgmF3wyG2vGume5jfv3HaCad82P1e4qSQBTcC+l8gas?=
 =?us-ascii?Q?CdnKSzW8LHCVk1Fjbur0Rgz/pGiN+hiqU9ksmJmSPj2ltDDfJFkxSDSPkrGu?=
 =?us-ascii?Q?UrUwGQ4BLCPicdMQtUJNoSGPbzEUo9u+xkBDmVOHmw396uwvmbepzIcYYZJ9?=
 =?us-ascii?Q?+31P2l6zeKdpYMg99LhkoHt6DUVVMmtrraBg1ICPWLIgeJh+o0+4c9fENPvg?=
 =?us-ascii?Q?Zf8YLSJ2RgwL3Toxz12PQijW1PwiVszVOsZdbudZdvNp+HAG1X1j1uXA6vL+?=
 =?us-ascii?Q?O9naaLQMG69Cf2dGqPPoiw8F8atzKTXolkqFfYXsbZn3PpUc8LUBKs1nUUNa?=
 =?us-ascii?Q?DTnXruK1Y90ScM3X08wmD8zFj5YYNeLojjoa4pnsZXSbGt2aZm5HpnmJzI8j?=
 =?us-ascii?Q?An3uUjyvbGzBRcoYFL7v1QKAD25RaQD/LaHaCqTE1VqveXwYc50CvQIcgSjM?=
 =?us-ascii?Q?tN7rcl1lZwU6RMUa/zW7eX6g+3OSGYcOe3OCwkmlxIH5G29hVmV20Cc/12+5?=
 =?us-ascii?Q?otw/zwPuWsdWwiyfToBXrgVE5DvCveXbfIAG1NGi/6NpIWVBjre4j51UcLlQ?=
 =?us-ascii?Q?2Ko4GfTp1HLXoaYJaoRVEQ1YUyNWM41aMS+Wc93vxpd0hxxQ3PBa9LlE/yjK?=
 =?us-ascii?Q?TK9Tnd1s2t3TSIyNrNvw6ZoRacmK5BmVL+FPlfmyOhWEWx4hGiA1U2Zq6+Y9?=
 =?us-ascii?Q?PtsBSQJTiS8vg/MkBbLcIWD9OR3qhus31hJ3EghrhASSS3SPs6e+qbOq+Gz5?=
 =?us-ascii?Q?ty+nPwsjzlScU/WEXp8zSOuJ6GYRJJz/Yy00OeleLHjxiKhfQ1LeydoxRAnA?=
 =?us-ascii?Q?B1AyjegF3LiyC/n1qvv5dQlzCQ4If+pno3B1MM8GCxS8Qgr8olxx853RGwJ0?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d8233b3-6db6-4805-5790-08dae6c5ad4d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2022 22:16:32.0881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNanUKkpYT5p6QrDZIiwRSz6+mpgHvJg4ZvQthg0PCPQEOcdnDF7H1VrABQddyZ4DCyn6C0zjy3Wve6TMFfdFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8076
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Sun, Dec 25, 2022 at 10:14:37AM -0500, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     net: dpaa2: publish MAC stringset to ethtool -S even if MAC is missing
> 
> to the 5.15-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      net-dpaa2-publish-mac-stringset-to-ethtool-s-even-if.patch
> and it can be found in the queue-5.15 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Didn't we just discuss that this patch should be dropped from the stable
queues for 5.15, 6.0 and 6.1, and didn't you just say that you'll drop it?
https://lore.kernel.org/netdev/Y6ZH4YCuBSiPDMNd@sashalap/
