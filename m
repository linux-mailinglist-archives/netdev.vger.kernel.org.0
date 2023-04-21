Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6356EAAC5
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 14:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjDUMrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 08:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjDUMrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 08:47:15 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2048.outbound.protection.outlook.com [40.107.8.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC2A1B1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 05:47:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgTjxsdfpwkK4J2InMJdjsjQgD32WfaPEyjNefefQIt67s/XL5DsfGwj557o0GsZyLwrl4NNXWBXu/qHrGWzClYHF0kHJ4IlwCIxpOM3QQ+XwPYMq6kuMm5U1c0ihWXQPuH59cowt5KEZjYA/Zu0wQWnQ3mPghTqxGXdUFkgZP3apgQeklyf32EMFWuYtcxlGzIYyUDdNfASGkIsT6YjAS2bobtIkuW59u1y8OmkOfwUmybXe7JHybQ2LT3TxTuAtLYLKLumTptbaa28950nStznVXDAgWfo2N5ygpDjL0ZJZ+DUVabDU8vMZuI8v9b2W3K8BFstUgUyEN25Fdh+fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGodqNdSOAKoJBQXlyLC+G9gbXx0XrWqtLOJnLTGwSQ=;
 b=TZGrSEH2qb2U/UssERSp3dc9UPGQxE6dSahTYrMaxQxp2XVZJWE+qMb0kpyaUUxMdAuUFeo74o694CI4XutR7EPMuDpTRyXqNqX+v2XJmRK+oCW5d+J/9kUgqnyE8Z/ZkAb4annjmBFp+CUVZ/yMLaa1/iaa5l8PQGbjCA0ZaWbYuiCCbvKmiRB2VgQxP1vrsHwcWhKMjAT1iQ3KsnMfdWvm2J5LcpgciKAJrA6WPkq6EiMq/xRgBI/kxnrq1DPJ7lsJDKMYA0XPHw4k9o5QkDqVmsztWL9a5Bxdvv1ZYo9Yz97iQZsAsZwIjf6KpOrxTLnYjquAfH7e9JlYg8XvIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGodqNdSOAKoJBQXlyLC+G9gbXx0XrWqtLOJnLTGwSQ=;
 b=quMER7tWebAziNp8BZLA3pJM/Hu9xh+f58gmg5Iz2acaqXUV1IqJddCOvM46zvziD1hBYHohIGXSMebJ867bZOJ6vGcFMErT2nHXUvDilcnP8OAiwdydYP48uiDks4aQgKeOgAQZnYB/s+1XHNCu+p3VCudNtFLLxnpgYgSUEE4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS4PR04MB9436.eurprd04.prod.outlook.com (2603:10a6:20b:4ec::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 12:47:12 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 12:47:11 +0000
Date:   Fri, 21 Apr 2023 15:47:08 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Steven Rostedt <rostedt@goodmis.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 0/2] DSA trace events
Message-ID: <20230421124708.tznoutsymiirqja2@skbuf>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
 <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
 <20230412095534.dh2iitmi3j5i74sv@skbuf>
 <20230421213850.5ca0b347e99831e534b79fe7@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421213850.5ca0b347e99831e534b79fe7@kernel.org>
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS4PR04MB9436:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e28dc17-d84d-447b-3dda-08db426686ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJMQ7P/rf3uxxIjZAbscgAyCwGK/GnxSF1DMKm6w4YpI/T/YVC0ElwftD0sJJj6HMVJVRqOM9IVREwMwlix5eY37e8T/f/qhRUOlRIahvCVd9fPUSd0SgblUpwYMtiqZ5eYNCGtl4KNJd5T9qRPRaVdSsOnlY5yiWCQrJrJTYeThD0F27vM7J8YD/f40TF2XILUcqOiMKhlzpOGSm+7aYWNK9tIYUa+tmEny4a7YCyF0JV5COcplnRUuhW2BnS+IgXcyYPhgNDdS33hgx/DBauNdCfwB4ibnnrW1tQR1d5VeHvIH8hIGbwtSuzIDa3UZskPvFSJQdTCJ0LZUIoD9pFbVWR3YroZO2ubqwwKERTuJyV0MF5xh/WJrcUTb2g5yRX7x4JaB9BKs8Sy4sOx4/N+6x0O0ZUVCy3oyIYlyjk5JrFMV1v2bcUL6lwLhs3c32S8x0BIxUrAkxZdbfcHoRjF2NgYNw0Z1FFuQYezEzOYTmcdWqzBkW8i5CElyYpAqFGqMsldmx74K3tTEe1DVNJCmCvDTV+gX/AXyxEmAxeiyVCJa6neuRR0vkhhipGFh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199021)(4326008)(5660300002)(44832011)(86362001)(33716001)(1076003)(26005)(6512007)(186003)(9686003)(6506007)(38100700002)(8936002)(8676002)(478600001)(6666004)(6486002)(54906003)(41300700001)(316002)(66556008)(66946007)(66476007)(6916009)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bz/Fso7ForT0Q48Ce+rXbXZH0ApxdFRKYzjtxleGpHB1B5gwdm9Ceosa3VDI?=
 =?us-ascii?Q?N716Ii3D1bZt0vS5N3pBVKVz6E3RKn1bk7Q2YBZnlbC7lgoNarmtMgjcxvY0?=
 =?us-ascii?Q?zLqX8TDtqGywhT+FK94Bw0VyWLxgXBQhW7v7Q6fiPhup6f8xJR4AAj/sYuri?=
 =?us-ascii?Q?++iWexGkZfH3NteCoLjNHI5Krb16uNfkcpBVyJd82apQFeG3RY2eZlGrF6Jh?=
 =?us-ascii?Q?m4WgsX2l2hqG69OVqYR6I2l5/NQhpSgCcYIL9WAhTPdlSYSCbWuOB3EWa6cN?=
 =?us-ascii?Q?G3AHDugY3IhXd9EJCUfC63/5lQjPADOt9vSp6FyIzydNdE+dTZrSqImv2Ay6?=
 =?us-ascii?Q?Ftmj0GCMjU3jYJOFctS8qK3ZNcWATVbbGZEJmKGwsYtOj/eagx9hr481L/rz?=
 =?us-ascii?Q?GXlDxf5cvHJdORIpt58D2pPg3Ndjzm5lG4vkjVYhovLZbZXoAEGrJyeqTIHD?=
 =?us-ascii?Q?vzDGqM5eNshfB54m7ZkkxtZiizyrK2VXThZqNyJGUdqm6tzcYMmCPPJ2gVoj?=
 =?us-ascii?Q?unE2EFHK/AE64CwFx6HRsJLMIYIZW67847PvKCwa5zaqh7VVFL0Rq3y4plJC?=
 =?us-ascii?Q?w1VsuNmoLqceKDMEaGSSZzwaEDFGqFhDKaxPjxLPgas6Wz3J3AFMf/3V8uJ0?=
 =?us-ascii?Q?MNoaME+bgTuRe9lHx0pPpIs+Doy8wDRXsgxA3KeQDlXP/6gSC1l8UiD67aSI?=
 =?us-ascii?Q?fNabJ7KMC9dq3IYCwMJ6O71URLIhLrQ8GC9iw4i7avcrJvCP4jS42N9l7OLC?=
 =?us-ascii?Q?8P94KAJtKA+0chJT6gpF6gfrplO0+ojzYRXcH7W+5b22iaPoSNcCTo5vj2G9?=
 =?us-ascii?Q?+UCvCZjyDNkKq7fwrnbsxQREyS4fASvO9HsS9Avm4jN7ud0xPygDLd58kVO5?=
 =?us-ascii?Q?WK7/XtdZjWWF4MWNtiRmLADU7rjwLpOP2iaDmkAno72/Z93nLA5HLB9Gaj/m?=
 =?us-ascii?Q?Yu+jQpylRNiXD7keFspVLDsug61B3sK0/ZvJcM6W7/cYGEk6HjoeqT23kVGq?=
 =?us-ascii?Q?cptR4OL4SIORPBcp3sSddLdMfZdlpLjuB8/RtrnvCq/Ui+RmN2ekzznGzVIL?=
 =?us-ascii?Q?MU5pQNvJ3YxyGRz9NO3C6Yw0REl495Rw7eJne8zb/ZaD+HGvCfzsvgubnv0X?=
 =?us-ascii?Q?lPJ8sLh4/cqsxUY0rtyZgcNefr3xE+UrQMVfMmxDUn6R6POSIkdl0u3jkike?=
 =?us-ascii?Q?VDzKKH4PDqDhDbzn5dv3FZ74X9DfE4X3Y0tNEYf8sSSbjRxyW5UD9MTSZhCU?=
 =?us-ascii?Q?PoNnoUIvgkWPGBsMAxVRTZo43Nwc1RGH/2DlelwRq5NW8IfZF8h6sTNOiMTa?=
 =?us-ascii?Q?HEeqLEzeNZWmWRO5OS4v1AhqtmnwYmPtt6mlZrl+QYro0Y8DYTTcFCcAFga8?=
 =?us-ascii?Q?d85eLajeLdgD+pei+TAf5lZY7/oiB9nGwohsbSF+geHz5Bnel0buZflcQm73?=
 =?us-ascii?Q?DPg8YR7cXo5CvWFgTAJbRToTAQc8rI0mmEvo+AIDgrY4UKuqUGH/sxPs7ahR?=
 =?us-ascii?Q?UMagA20PP1tBOIVf0CQPw75sHc9E1FZCOx9undZrEWvuah211genefwDO60t?=
 =?us-ascii?Q?GVl2vj7M5z2k2gekFSL14xV3rNd1+x8KkPbBohaBu1Sa98wXnn7xFNdH03oS?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e28dc17-d84d-447b-3dda-08db426686ab
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 12:47:11.8153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tIAe7CqtZSEhdqEeuNsDGqFJi0KGH32nJtzvAZhciB0kcq1XKRYyxpf375mUg03yshbPQqqeRJQAgrXmwATOtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 09:38:50PM +0900, Masami Hiramatsu wrote:
> If the subsystem maintainers are OK for including this, it is OK.
> But basically, since the event is exposed to userland and you may keep
> these events maintained, you should carefully add the events.
> If those are only for debugging (after debug, it will not be used
> frequently), can you consider to use kprobe events?
> 'perf probe' command will also help you to trace local variables and
> structure members as like gdb does.

Thanks for taking a look. I haven't looked at kprobe events. I also
wasn't planning on maintaining these assuming stable UABI terms, just
for debugging. What are some user space consumers that expect the UABI
to be stable, and what is it about the trace events that can/can't change?
