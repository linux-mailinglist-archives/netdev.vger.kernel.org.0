Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B49645853
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLGK6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLGK6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:58:19 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2098.outbound.protection.outlook.com [40.107.94.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8774063C8;
        Wed,  7 Dec 2022 02:58:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNh0VYriwx7RYj/PZfXuBut/U+koEp4xio+XIWFhchC32N25wWfu4a5sAxFNMDsBArfvcdDtRukB8cyfwRp0ma3Pu1UgTCYiQvC4JQOzR6zgYL1vk+/wQJpTw8qrWf+uoXB4tSEG5hww4TZN5JUuHXRu4GYPtDw00WrbV1bLCaLKT64hokQr4nXFCcyComwKGoLNoU5uATKxoaaahl15dB7aARgWBODgA7act7XEli2EGXgDskEJZLV510jb/kDxR4fPJ0XJWMtHl/O8IggZ7CZdcntNmJ6XNaSEwM7FDrHBLwJg0INKuWEs7tGDIl0MdczpMNnM5GKSwlpBaytbjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Aampry3pGa9rTqn6qMTVIc66Gro31d+eGqt/6LkbsI=;
 b=Qfd4yi7Ib/Z9SEmLLvyZY3mwiNjX2fCx/BS+B1ZFgTSRcbbqmkYjtDl0dbMbza8Sl79eWB+b7z82UcswBLjcgE7OgNpbpD7tJK0JYjH4qVuTHcUYux5/cIBgpv+xkcAKu7dg8mDUTjK5kNdXKNbD6nX25Ri1CvAHCPdYWRxJmAUg7SINBv1En6rB6aSaUSUrq8HSUD+lQuUe5G3rzcVSapjCtw7DYUYku+lv7AQcEZcEL0mkeUxBeZD7cy4CrWLo7gi702VeTUs7pdwiCcSesPvStQMznMFv/bccm9YZisSRj6qDwtrlFHf3+SdLr7n0AsnAwWwiPQfZnnFwhl//mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Aampry3pGa9rTqn6qMTVIc66Gro31d+eGqt/6LkbsI=;
 b=aoQyqVkR4vupeo3HUAfJRcodNyOtXnEDlzRMTqPOi4wVW+kLZXQP8jDNAOrZgT9umOiv5LGlO3tDmJW1gDSfpGyr7Emp4b+4XnXwSz+18rrvwF8bZqUaXoutb/J9IUjyhgxRzYYZi7w8T3KaCAvIQrCbNw9cuboZDY/0I/DaA9A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5710.namprd13.prod.outlook.com (2603:10b6:806:1ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 10:58:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 10:58:15 +0000
Date:   Wed, 7 Dec 2022 11:58:10 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, oss-drivers@corigine.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] nfp: Fix spelling mistake "tha" -> "the"
Message-ID: <Y5BxwtW1hC78/VC8@corigine.com>
References: <20221207094312.2281493-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207094312.2281493-1-colin.i.king@gmail.com>
X-ClientProxiedBy: AS4P195CA0005.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5710:EE_
X-MS-Office365-Filtering-Correlation-Id: b10a6a34-32ee-4504-4d75-08dad841f10f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KCRV6pw9pGCSVxZntlZnRLem3SrT36sBUXHb5PPY5lfVYwCvkLq9T1C5CmQ/pUuQT4HZpCYlqJTUL3Ri4pyR0j4yaWEmmItgUpPR82ZQfkD0Z55H1IRSfuvPx3GRq8oACUa8lkwr4sBDEJVB7QAN/3UBl/N3CUh2Avuz83rCLPJHHuYfQe5/2vkEnO3kzrZvliGoRMUvrRzBXx4P9nzx2BS7ITUaY3b4vaK9E9ryaSH7sekotkioNdSZA/WbYrMRfHTNiRJP/WGzoli34dOQe4H3EnYr0+UGkE9MRbXfJgLwFaLonP+sSXoablPdWkIed/r/hBMANDBBOoiPOvVUYo2qk2naGHPRiGjT6ORTQV5Jpm+tw27HyYBgG1nY8neWSxW7zBcLvAgkuLglkH5OSZSVcW/aim9+NVlSnWqixLzThnF0T8GPBlOmKzYCxHkI4trh7zBdL1wQ7FRaPwEu5cSRJUbzTfD5viv650mb6fR+KcluiBd8yX1xBTVoHZuPcndqz3aZ8E+Y9oIhQbkLAsuZRbUWe7za9uQ2kN+z6VwUzRYFAhfoH4/Pp/EufQFRnflSfpE8qy+IXziiZSldn+XtfKLwE2aYtpQIafwnAOoNzVUcEFcD/JmtxZvdOUDNCvjTmOwZDQvHscuMbL39gJgp8AUfVS7zaJk49pf7KfpCcCTP4fXMXywWVica8K47
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(346002)(396003)(136003)(376002)(366004)(451199015)(558084003)(36756003)(38100700002)(2906002)(5660300002)(44832011)(8936002)(186003)(2616005)(86362001)(83380400001)(54906003)(6916009)(316002)(478600001)(66476007)(66556008)(66946007)(41300700001)(4326008)(6486002)(8676002)(6512007)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P43HvwUn/9FbpcWfvNnJKwK8h2Sv1oyais7YpMcXeGsUNakd0y+rJNzbq4qP?=
 =?us-ascii?Q?3XANbjNhYxw2s4mKowTIj22ylUguah9RFIK/34weS33L1Y/PEykCHpUNL7qy?=
 =?us-ascii?Q?EsI1cTqXFegYvLvtNTrMs7UIjahyMRSzHcz+tlQzWPOW+BOZio1dEfqRXpRG?=
 =?us-ascii?Q?UkQGzTawVT+ubSX/SGhAi/vXzdNnB3bP/4T0WdsqHhFI6tMZJNEEI+OMEJqA?=
 =?us-ascii?Q?meqSdXlhT4nxUlL4dqyM/1wRdIE3IDmhlT73g6JlLZRfIS43kChveipglJtz?=
 =?us-ascii?Q?miJ6tmSoUgu5GLajBoqOEvo0cVWXy1PWQWA1UF9zGjMqABxqusf0nyOm2vg4?=
 =?us-ascii?Q?vv27pPt2xe07PxYFsfO643D/Zg43wKIciBX649G3Dd+keIe4BoAdz0jvwula?=
 =?us-ascii?Q?nxugn7VSc0Bd16Hkg3ALLXj47BW/Jz9PM6XwTx0A7RALveKkZ8ypT0ec1lno?=
 =?us-ascii?Q?iaMM7wcKHIBftbtjPflmfRSpSPlFfvAZuLxVQCrEjkQm5jOtuk7i60OkH1UE?=
 =?us-ascii?Q?L0/rWCRlxD82RI/bD01Zhj/mhuH+kvAaogjO3itmdaT8vZSkJNZ9kYgWhohS?=
 =?us-ascii?Q?hW2h15e03TLlVbMF48OgvlR/h8BJ3sFB+GoU14OBhwGwRPzGpNRVWPT+gz5r?=
 =?us-ascii?Q?OstSlS37+X6xtpdci3Ut9BHh6qhRwgnVGNhQeMYaPXa8d+9phgbyySCxqJBG?=
 =?us-ascii?Q?BESufeV+kgFlU4AHYPKQJnT5IgBAGeDjOxS6q5gzs1nWUtHB+cOEw8Q7Xdin?=
 =?us-ascii?Q?f9cJspS94jrf6vY6muGIjAXhyGrbtsV/KsnADiI9nvvXN6Qh1LdTUW94EhCw?=
 =?us-ascii?Q?6c7GzG9H7Qxc7WR5n6TkXdev2FAl75lGraR0KK94q3bOv/uP8TvwMprP35cN?=
 =?us-ascii?Q?NZoJ6qCuQk58+Xm/E1rvSyMf8UUyF566k3MPK8TGED1TRqzmv22hiPfWq68d?=
 =?us-ascii?Q?tgrW9Ruv2DVKTbslM70Pk/Zt36t92awv3IFEnPwHpJQB50MlUxmB69RfNPqZ?=
 =?us-ascii?Q?2DoDBScJme8SY+OQfB44EZqnO4xYv+Qk9XjP8m70J2p9SJ9OwxSgaXCPyPtl?=
 =?us-ascii?Q?kqCTDlQm+cnrA7G38lajc1SksIiLkJ0cdCzU02ycvicHcVz3dC95+FXkRmS2?=
 =?us-ascii?Q?c5UEK1ccGu1IazkJOqgahV4eBeoprQWC1p04lM5ywGyq0ie0wO3yCQ2NvwwR?=
 =?us-ascii?Q?Ko3gfmoP8rbdUjfje98myw/9Xd2jTB8UD6B0fBSxbWWRMtT3ANLyf4nKOnFE?=
 =?us-ascii?Q?+nv4DWQ8DWykHbF5HlB7n7KXCp5lC9Li1uUahFAu9JguXj399kDKWgjf1KBs?=
 =?us-ascii?Q?ti57hv6edYfEOcqAxG1FKoeoa1nEi+OofRmYiZKzr9uTjWZw+i7+DZ5AYzY7?=
 =?us-ascii?Q?cop4RXu8uDXjZWEPQZ+ovKo00HP0yzTgBY6VdakYI0UVAQpFjgfUmJCjHoJ0?=
 =?us-ascii?Q?JzdgDxpygyIoxSeZU8cBvaHmnsUGa4R1kVNYEgUudCNfU+jIuO+6cgLlvf+h?=
 =?us-ascii?Q?vAJdAPVPA1zbsXOwXoH+/cpx5+3qyZvH8W6VHnW5/WztBmDKXFeknxecbT46?=
 =?us-ascii?Q?AHr/ywZsu106VALLnkLmPoullf+KV1xgWXieIy073Bz1KJAl3SR3fTfNR4OF?=
 =?us-ascii?Q?Rei2k3MSPYY2sljNCWvTHgu6iGzIOOTerpobk58PKVR4igqWVfpy0lhsiZed?=
 =?us-ascii?Q?AD4J7Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b10a6a34-32ee-4504-4d75-08dad841f10f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 10:58:15.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jxCh3dZz4Jzmqn+kegvUZHKRIJp7DZ4lmbs0Otu8W6ULpm8CnjUXdu6+jblwXP1KUUEoqefdaqn2ufwiHRHSnr5T+cAs/Aa5uaBZvugx+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5710
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 09:43:12AM +0000, Colin Ian King wrote:
> There is a spelling mistake in a nn_dp_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Hi Colin,

thanks for fixing this.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
