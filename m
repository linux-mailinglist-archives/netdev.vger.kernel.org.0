Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E5C5A87F8
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 23:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiHaVRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 17:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiHaVRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 17:17:04 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2117.outbound.protection.outlook.com [40.107.20.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BA1D21F7;
        Wed, 31 Aug 2022 14:17:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VegpFVN/BMDAbNZP2Kzg3LpDefh/Btzp2ADYSsYN5gcXSBSZih80F8+Qt6177ykLzPtVcnVfXZHDjYQuBTJBVez4ouPz4FjaR86rn0C0kbrm/vMEtVw/R6dbL9vO/xP1t9TXN7UXSQRDjb1E+Szx2DtG3oD0co45oLdUOkdVjyHr1drLLeJ79HAElTxqEgFVSe0RlYOQCmTdrDLCHV7JQnLkOd8527jwO/WP4naJYsbaXTRbD+f+Y9EhMXdZqoijjuetQavLWK2PCBBlykMOtanLdvc9CKR8fUNlDrXV4fPZ0RSr+gI6BPQc9Ua7NqoPofLjWVK9KaqJ3MGRvvp7vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rKsYHRNhH8ZjG9prD0jx73BlaPhssWAIDKmBR3v4yyA=;
 b=Vz7vit14ERwKDzZLjDgPBiN560FttTKr/MpyF8P501MgvglOWld6ddiXPYHg7atAwGTaGvKNHNn5txYMxD3cnqKtysAdoMsKYbIvFurdbJwlxmbOqQY36+cWZh0T+GRHolEuTXlgREGq7HZPeeKxyuU+fPgjMVEeu1d9yCg5OzgWSHSDBt5CXeBoERfZbdHNfa1mzys801NIR9y4bH1zEDjVacVL7XC46z5EurPqQlX1BN1opGiCJhvAv/M6j0dO7IwgNIsvU+/Wu/4oPKyt5uSCJ48/tSmqBbiLHp2AwCm2oq+Am1Fcduhadzc7InQ2Gwd0R4ZI/Oz3FKT+oae9Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKsYHRNhH8ZjG9prD0jx73BlaPhssWAIDKmBR3v4yyA=;
 b=G8ACd/QZz2+SB4qYc7R3SJVk5wV1QdbNq2kju1fv65Y8it0THaROL8SQyj9Zv0mt8DgEJm/u7m0b4fOznoqn01YH33O/vsI2fAChbNCPAzQlHaeRo+fdo5FEHMvnz0XHmn/4PdzGMpbcgiyvNHf1Z699kDL3QAVI4APr3WaOHmo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by DBAP190MB0855.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:1ae::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 21:17:00 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae%7]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 21:17:00 +0000
Date:   Thu, 1 Sep 2022 00:16:56 +0300
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: Re: [PATCH net-next v4 7/9] net: marvell: prestera: add stub handler
 neighbour events
Message-ID: <Yw/PyBkjqaTSaxzM@yorlov.ow.s>
References: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
 <20220825202415.16312-8-yevhen.orlov@plvision.eu>
 <20220830151100.10ea3800@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830151100.10ea3800@kernel.org>
X-ClientProxiedBy: AS8PR04CA0083.eurprd04.prod.outlook.com
 (2603:10a6:20b:313::28) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa867362-0bfb-4e92-7788-08da8b962476
X-MS-TrafficTypeDiagnostic: DBAP190MB0855:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euR3wSdz5aNib6Lf4fXr1DVqbtoa+EJFje0vy86khEkCfx13fPTGFbWJEULsLK1c3+pG2WN/GV72QUJpxFVbQ4EmO8k+KDcaQ+3oM0NEYn/2lX6XutnzYUidkCX7lGpVPtHJ9COiSJEzOr2uQzdirKcOxKAJXGdJQWtHHdKmLRq/6QMIIdFAtlOO+X8FbekrWNqkh+l4CL1umZs0CYS/ZExamwGKkxXES7zWgQpWEpj27xIJhgNwmuyvl5hmUgbIp29sW+Ea7sXrMjOmbOni8BmA6r2qzDQnGbpjg/i3QyvQ0OR1KfCMCgAntITNqKL3Pw6NajCDYLjhV7tV2Mod9uvIU6Y/X8v3DaAekgBPYnL/0AbJGQYGbAR80CgdnTImupGHoEa5TBZgDCKgjE2bhRKkfbmubYDbBev1BClqgc96P6A75irDQDCraon0T6Xig6eWoEzEFuLoUIEWd2eTu/VmKvxQ94D8+gOXNwX97oh98wNmp4rieHTeSUqSoCAlH54Nmq5vloP35wzvIFN5kHy53zDlkHvXsMzYhsciWeVa0dRMG9nwoSz91K2U7KBp3MhcnNrxoqkuOjSmGLn5T56E6QLOhA6oD0XuSFh5wy3swKMGNebiiCakYhQZhvqypas0tGV9lWMcJuigR2jVtbgE4GOaz6p4GrMz3vvsa34f/EWgp4bYKvtIKa4n9NWWtUfyVsGqcrteTf+8ZSrAzjPYlmDDSz9HdPgbKCS2WrUAsYOtCat8JIL4Od1bXMEO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(34036004)(39830400003)(396003)(376002)(366004)(136003)(346002)(4744005)(83380400001)(2906002)(186003)(7416002)(9686003)(66946007)(41320700001)(5660300002)(44832011)(66574015)(52116002)(26005)(6512007)(8936002)(316002)(6666004)(6506007)(107886003)(66556008)(4326008)(8676002)(66476007)(38350700002)(38100700002)(6916009)(508600001)(41300700001)(54906003)(86362001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SNkFDX9rj22QAjz0NrIiFj0sflemiv5uhSZBLVJBHk6I5BbGFj7SvxRzXc8U?=
 =?us-ascii?Q?Ii1spEWhdZqg9MDFLgRBSlG+zFPeq3hUVJxU3HXZXEd4IhpWwhTOz/mOY9w9?=
 =?us-ascii?Q?zdjlUfoecExzFKtYMv+cZKOONEe48uZ7wzrwhMD6wpR3cOrJ36y2ibYnulv9?=
 =?us-ascii?Q?AvTkvIyni2kN6CJe/BtslR1COF7ZJf81ZHqHF80kxTxruQwei+FlJglUtO/+?=
 =?us-ascii?Q?13bhLcCngJQ/wDhO3zauNrf3+q98EcZB4tKfkdWZkSEEwRjbPVGMSXZB4+1h?=
 =?us-ascii?Q?EafQObuXEPSsEo1+NRrvpYUuLKFcyAw8eX1YCIJg4uLlszVL0l/VFfx2iqEa?=
 =?us-ascii?Q?l/Cq4MhbrFSD+bR/CmdjXsrOz97oMcDky6g2DN/wEF5jVAQs53azunGxjIVs?=
 =?us-ascii?Q?6VHlh1OH76SyKj5nq3H53Sahe1NvOSjizyDk62Cm5h0h+z1NVvfSIAgnGjYc?=
 =?us-ascii?Q?oNa7RusjW52YudX1hvnOEiMdefJW8diOfvq4xXOtLc0XiryvBKxsAGjkGOXG?=
 =?us-ascii?Q?m6DSWI7LmX6iR6d1VTDiwcHaFtTpxxzWZ9AZmdjPClo+VWfH1m1PmbLuPp5F?=
 =?us-ascii?Q?HvbOBm5h4yiRBb9CLb/qfcY7QejDJbTz5vEfHt//Ns+RvZfU3UH04cDW4evx?=
 =?us-ascii?Q?D1oLwrZ+/foNBtyHJX58n56MBoA2Eh4paNcl8gjXn0LT/xFvPmpYkkwwWbPH?=
 =?us-ascii?Q?IRv8uLKcSs5gI5EFtUF4l8F+5nJypZ231hUCOH7o/n0hKzXWIdkhsYQ6gima?=
 =?us-ascii?Q?8svZ2zTe5x0HB3/mbeTqbnqJ7JLZsd2Forr3DptKaXWg/IvXduIm44jsdApt?=
 =?us-ascii?Q?yKloAOtPmmtEqu2Cwip0PGaN3V7+1hO2qOFS5430qUWbp4tmMjAmukTujcBo?=
 =?us-ascii?Q?jMeKS3zwa+G8OfbMKt5qJ6Dt5Csa9+M3lQ2rEQNtfkPUneogKNAHH7HgM824?=
 =?us-ascii?Q?9VWNkaRQP0VoknGIa0hVenDKifGOMkmCEveldDRgCJ/BdZYP4wyLQZCW649m?=
 =?us-ascii?Q?tn+YfaUK3V+20QfgrruW4ysyWkWxqvqtHQhmczyiUz15H6zV8sMKbz9ig095?=
 =?us-ascii?Q?KPzcikbDJpUeQrxa2H7EVixLbfXi97UrGwRJhmGabxhvltKrBGq4nP7lqrdM?=
 =?us-ascii?Q?YItD9M0zyyqH6qosDMgbKfSHngH1O6colDGTjouNqzp8RbfV288jsKvufu1B?=
 =?us-ascii?Q?Sjeiwjh2DBiP1Z8Z5tBQk8ZpsBQHGbdtl7aJHxAZU1dzXytmUeoS98Nr59Bg?=
 =?us-ascii?Q?KV/dJEpNz1M52UFIzGWD0ZdETdzW6y+fIu7mUT6H/ju5ao6knG4gJeWm4S/n?=
 =?us-ascii?Q?C+AvhSoSa8KnY/wXjK9h7IshrB3Gwos7ROMKzVM3uHOIMUKDOkrolV93pjCK?=
 =?us-ascii?Q?L2hoDYnZwc3tlPchWyWR78R025CPl1MMM4D7kOa/hmJzSn2Peu7xQ0Lo3Pts?=
 =?us-ascii?Q?Wn5FX7Msy71XkbUREUAVlQhmXFAyRxMpinZQ5FYqz2Cd6iqd8TP6upHg77KE?=
 =?us-ascii?Q?akNbIq9Xzr5Eyh7tFTP/mf/oxOLWNJSIxLIMu00U9MLdaBLW4yMY2BJJvgo9?=
 =?us-ascii?Q?s/XXA5X/tPIYfsEPMaaAIu3GRUZyc8c108s2GcWsQKNzhkJbp42wnFqdoRAi?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: aa867362-0bfb-4e92-7788-08da8b962476
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 21:17:00.0538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vTT8mQbuMJRvcuxAPGGIppNRQwxyMnMV107q5EgOo7N0K8T8EsUkg78flILadm56n1iexDRgHzCtA7MBwu+8QDp/gHyy/sFCIqWyHzDxLEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAP190MB0855
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will recheck harder and update.
Thank you for review.

On Tue, Aug 30, 2022 at 03:11:00PM -0700, Jakub Kicinski wrote:
> On Thu, 25 Aug 2022 23:24:13 +0300 Yevhen Orlov wrote:
> > Actual handler will be added in next patches
> 
> Please make sure each point in the patch set builds cleanly.
> Here we have a warning which disappears with the next patch:
> 
> drivers/net/ethernet/marvell/prestera/prestera_router.c:624:26: warning: unused variable 'sw' [-Wunused-variable]
>         struct prestera_switch *sw = net_work->sw;
>                                 ^
