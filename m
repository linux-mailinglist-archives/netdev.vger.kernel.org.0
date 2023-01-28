Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2D567F82D
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbjA1Nki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbjA1Nkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:40:36 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2091.outbound.protection.outlook.com [40.107.244.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44343B3D6;
        Sat, 28 Jan 2023 05:40:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCMyM0nxDLeKXkB95/Rlu6RTjLkJ+DO8SKgdwxffQ9ScbzxLs7YjttDwIBngyNHaxAEp39wBwY0hpong8Ca65l3iNMP8xsc/FpGZc7nb25f7Lf33KO42FFGBJ6CAMS9LbUbyXJ4qZCrrU66+Zml2B24Y5S3NtKqDavOxS9DlSK9GsUYfzOFet2WfbA1O1uK+s5mbpNJePOHkA4BW07QNFFtygpQ2vLtCfY29YKJohzCp7hcxBz0iPaYt26f/CjaJ3y8b88tQ5ft+mVwVoALQc/q1BQY+K8ubE0aS5e4s4CvLmQ3r6YEhHON41AzwEK6/znIa6vigTVp7urUP4LCz5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clom53zHJaWzawuaxbUsZ7HumAGG3hLDEH+x2vAhugM=;
 b=fbJTTljXG2tlLDs6DRXtkE3tzw6WuvILXm/0ODSVC/PUgnIA26i81PpgMxdJUWa8w2JJUkR+BFII0q0WzcEswcNKZj63FBI4GB5v1j1FdvqcKXtUQlkw0nuOc6h/G/He+o9NB0G1huMHeoHZyEbaHZi8yvICFepu4bk0QYEJr6qJtGfLiyaXV/6fJVct8MoMBiUEwICjTIxuUp9tXSUpOm5jAdodE3fW92EtLDYW7efXCNbcPQ7sKZRsiRPCLy/9UbgzLWmBIsCeaEoRBPhv37y+sqp2D0yy69xEgG2e4oC4Ae1/1mnTanlkteq+cJrvH3XZHLtgCXzRi6jkjipArQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clom53zHJaWzawuaxbUsZ7HumAGG3hLDEH+x2vAhugM=;
 b=m+/cQS/GzDGzB11riatAAKB8L1X0FPYcguxsaFV1vEPTvunWdDRCaq+z51qYK4U8A2O6l1busGYimwrKO0ZYCccbn7MUumKd142q4FZd19CWD8WEfvk6obTLl9GRNMs8/DErG4OJ5EVQb6GDgnBdG8q32CFojjIZtsGr7DXWa4w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4102.namprd13.prod.outlook.com (2603:10b6:208:262::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28; Sat, 28 Jan
 2023 13:40:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.028; Sat, 28 Jan 2023
 13:40:33 +0000
Date:   Sat, 28 Jan 2023 14:40:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: Avoid truncating allocation
Message-ID: <Y9UlyupsZIwjIULs@corigine.com>
References: <20230127223853.never.014-kees@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127223853.never.014-kees@kernel.org>
X-ClientProxiedBy: AS4P250CA0007.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4102:EE_
X-MS-Office365-Filtering-Correlation-Id: aa1805fb-b09d-45cd-131c-08db01353adf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3o0qX75J+5omPKdvxj8gUWAv4i34JUHGQKMcEz/6T7YBS9SdV1uTA8SYGybOnAuexlgeajOHhmoJAbgJTJ8HXVsziDFi9qom3w4h6WACKxpUEysTVmwmzulgxCOUxGGXR5OW2JnrKR2d3VPQMvfYf4e0IMxv0/Ou9upil/Nj/yI6L89RtOoQezZ//EroL4FiUEQO/x7kuRQoLo0TctWAaHIRGYhtqkskpxBwLxnl50bwjiEeCAOTf2CZOkf3tZNupBdwboq9vWB1vdreFiIgA9Lapf/KjcebaQouMAzn3xysZSHLJeKItsL9uDrgMpq4ACj0s3AKPk6iGVKizkEFYE6MRWRTVW+ZCjn2E1u/6U4J13ffiN1w/wRaT/uvRIsNlojUuyUmr0PUg5Mws923Rq0M5n+tu1eVXfr/bFvFBWUtMcKpPXO6eGXBwgqC6TKumWu7wUlk/I/2g1/nDmH0iUEf09TBhvKL6oKJw49v7Oq4V7OWijfmxGV+qRmfqqJ+JiO/677tpGUTW5so2HnjfdYhfraSCDeJQp8m05O/6mLn/CoD4DKkz5s2ACKyIFJxUThbucVprow4/6HwUOj4lqAUYHcE9BlEoLqiVcBA11vFgF9CLVsRpYdOCEhXEvy+0T6fPhuoGmcPUzpJP7oKqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(366004)(376002)(39830400003)(451199018)(66476007)(66556008)(6916009)(41300700001)(66946007)(4326008)(8676002)(8936002)(5660300002)(316002)(2906002)(4744005)(44832011)(36756003)(7416002)(54906003)(83380400001)(478600001)(86362001)(6666004)(6506007)(6512007)(6486002)(186003)(38100700002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y/2slhJr6UjdERHIVqUet6YHzWyqP147fIDhW+IN6g3lDN4z8sZW+/Bjk4fr?=
 =?us-ascii?Q?Wj/OdzF3h8OwbiFEEotjdV9ttOefc7UpEtrk7KBEQFBbBQd0AksnAGOHQfRk?=
 =?us-ascii?Q?TOaBnvD3sScbTmKxFXB7lEm4faM6+BrGaJWi+LGWuHyLPbOpRjYIjs3nV5/4?=
 =?us-ascii?Q?f9S/Xi9N2ND4biXEQIlk1hDqUYg2FFhzNJIp+zxq1lQgcOJMS0uPeQXA6NUq?=
 =?us-ascii?Q?6mnpNMt9FbF1n0VqzMTMvdvXBkj/jRd9jGvcUs6XpUuXUDwS6pkUWUIVIk6W?=
 =?us-ascii?Q?6Erwdu2jXQmfSDDqN+JqDvlmHEcF+8le7bE+5lWe4cgaPFG+oHwBhDCdIbvn?=
 =?us-ascii?Q?XSy20j8ywXI7iYqvEecP9JoyiQA/wkUI7dR+uZLE4trn9tZLovn0sHKiFuwB?=
 =?us-ascii?Q?s+cMnObAFdlr2kKGa5lHzA/S4rpxFjrzxTSx/SOpiE6atlpYBW00Q65HPcDv?=
 =?us-ascii?Q?Xws8Yr57C/Gyh4pUopOvWVKwfx9Bnf0DgPpN5b3sfH187NU99TMl8+cUSGkT?=
 =?us-ascii?Q?cnvaPAF5t8ZRcDyx3pFeQn4pU1lvaGZuA/m/lN2wMJIa8H17RY++cHTPnHHm?=
 =?us-ascii?Q?66b51Sjapq8UK8xbc6VjzkpjxYFwnFrDgIXzqeYfOucoqaLr84pMELqXM5Tc?=
 =?us-ascii?Q?8OCV7eiXF3MM9NOcEpG0JC6+uACVN7kewG6M8OGv0QYrpMkqjuGv6f4DPQWs?=
 =?us-ascii?Q?G7KL+TGa9ZzwJ5FtZBGqs9+u67kW1osvufhih7nvtXJYigtmkk3VHVV2viLg?=
 =?us-ascii?Q?9R+Nw7KdXkMyVVSm+jhsa8AnkRviIrwbRoKoeJB36WT1p1rT8wjC68uR5TAg?=
 =?us-ascii?Q?TfkNFSHw7wYFguTmSuskT8FmrTgrCEe2RSacUM+mVTRn1i55EVC9KIz6JwhR?=
 =?us-ascii?Q?hZXgM/jOvmxVSQUZHoz0N2c0pAfpVQhqqp8IO4MslL9yRp6ctxnULDpV+qA2?=
 =?us-ascii?Q?1R+H7WSYbaYiu+bXpeyWHjCKdinQ2z9FsDN+Yt5hCKfRqMYl41SsHf8grrLE?=
 =?us-ascii?Q?2FkEF30KT86YzXC5vLGLuD/DkdnJ9RgaTpr2wS5GyMeyBPvedemYVrdcHTHs?=
 =?us-ascii?Q?n3MVSy3aWwGv1L3zD1ImAIT6ehDBQHiGEwjd4rAYHOIkNWa9exg/N0aOSOcu?=
 =?us-ascii?Q?YRFhkFQSqGtoxDBMNkdMBFbqCpQLr5EA0IZJt+NXiJarkES6KS8DygQxyUX8?=
 =?us-ascii?Q?WfuU+YtsWVXVTsf5v2Mp3cQzFoB6hhqw9vDPiKL/yzx/ywpHHeRJ2Xdt/nk+?=
 =?us-ascii?Q?2F0t/UVrmouMRRavvy9n07kODPuhJLAccup3mXwHWvcZz7ZdLjna25BBHVWK?=
 =?us-ascii?Q?yKqMNWyF5/uZkydFrWUlDpq1thoQ1l8eLHLXEpwWXffDUHVB6P3fFdwdOC5r?=
 =?us-ascii?Q?kJJ8G2cfKlfCwjsC+MEY5NT6/7WyGMKBDJOsJ6JmVuItD5Ompgqmy8tCmq2B?=
 =?us-ascii?Q?RRrFUp645IpyTJyeTu3kFVtmsN8cvGZIh1SxKGSpaO1f3XDD48LKu3lIl3Ra?=
 =?us-ascii?Q?0YMj/68SaS4uzobGjAYBpOaYjBuYG69CzqDIi0k4QI/SpyE0+obiJf5eKV2t?=
 =?us-ascii?Q?b1p9wBl6T9unE6g9iwiLX4ZbLNwKtpNHmJVQEuF9Yp8MkkaxxBTKOIP+m4hw?=
 =?us-ascii?Q?J8iuO2FZqzIRHs2eWd1eqqAEPOOrHHXS/6i3rJcQifVlPQ4J1fwV84ps89kz?=
 =?us-ascii?Q?bWhW9w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1805fb-b09d-45cd-131c-08db01353adf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 13:40:33.7836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZGjZc6SQd1XAxlPiR0PllSUWju1MIEqXR3A8ytfZ9A8jBJbPwJbG0Eblvgz9Wsz66a3PFlHl2sr1dTrypI+R/5uA7sgUF1b8/yfpLkiwcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4102
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 02:38:54PM -0800, Kees Cook wrote:
> There doesn't appear to be a reason to truncate the allocation used for
> flow_info, so do a full allocation and remove the unused empty struct.
> GCC does not like having a reference to an object that has been
> partially allocated, as bounds checking may become impossible when
> such an object is passed to other code. Seen with GCC 13:
> 
> ../drivers/net/ethernet/mediatek/mtk_ppe.c: In function 'mtk_foe_entry_commit_subflow':
> ../drivers/net/ethernet/mediatek/mtk_ppe.c:623:18: warning: array subscript 'struct mtk_flow_entry[0]' is partly outside array bounds of 'unsigned char[48]' [-Warray-bounds=]
>   623 |         flow_info->l2_data.base_flow = entry;
>       |                  ^~
> 

...

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 3 +--
>  drivers/net/ethernet/mediatek/mtk_ppe.h | 1 -
>  2 files changed, 1 insertion(+), 3 deletions(-)

Reviewed-by: Simon Horman <simon.horman@corigine.com>

