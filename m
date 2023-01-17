Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0447966E264
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjAQPhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbjAQPgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:36:50 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2130.outbound.protection.outlook.com [40.107.96.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC8E40BFE;
        Tue, 17 Jan 2023 07:36:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtnwuvZoRnj/IaDg+6SQM20fK3CeLLBu2N9d6e4tfzZArOal9ZQqRFNdh5b3Bu9JpGM3onUziPdXrfWNp+woQr/5DnKLeCTgrpwgAzaKGj1qJtHp/T8KBuKziLfevU5mFx+FvTc5qCPYm/K7u32LbNZ8pkV5Fv6tEZJ23DYH7zZTbpYlBhvFuXAnYDXkrGCSyhxTUSZPjR8UJEtCfLCcEZlvrIMF/9C8Fr71OAN4YK/CS5YSvphC6lkufZwAQ/v+SVgLVdmi0dmA6hlDtqn/R0Wctix16qTKJpwJddkYFuUTXtg0VG37hYqqNKJvrOPmeGCJIV6H1z58uxdRNTaK+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Op3p4IQpUMFfVdw3H5XUumbW7ejbNnyFGxscGUxLWuo=;
 b=YN6uYLiDknUPV2+h4ondvHqWF75qkB/q9dK+H30RHq9MaEliInfOveT1WTofVhWdXLJySxxSDfug1wqzz5CX/muJLv7YlvvLrzg7u5KOsDbln6XAQ/PQc6MsAnHbbU5lDkkrzfpoes1mqmTMx8xozwRPiR9yV+pcDCDuko34pNQ/MbNb3ehjDisRU2Q9HbMf9VmLAZOmx+f3Akegkv9781DQxA2OCFwhJUKKvPscdzmkwKlnIXKMhkdS/STJvX2i5dq5YBJngtppNw2g3Dc/B06egP+OQikucM8GcGUawD+cHAZE2hqVv7E8mzOkTU8QFM5CpB52SMk4h3YqxEku7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Op3p4IQpUMFfVdw3H5XUumbW7ejbNnyFGxscGUxLWuo=;
 b=gwOjvXmHp/CaXLaIv07Iv87rOVA1R1/JKEPr4ikWa6kYCc4En8CVSCDmnVPtZnh0iAV7zg8k6fxAABMp9XE8RldWhtX/JT5EGE7Mz1E5GK09WXbDAnefto9JhZVKItKVGs5+efmhFwqrGhLq7o0ylCsxGQJ4g8HN5ISkpBj6RpM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4936.namprd13.prod.outlook.com (2603:10b6:303:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 15:36:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 15:36:26 +0000
Date:   Tue, 17 Jan 2023 16:36:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Deming Wang <wangdeming@inspur.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, aelior@marvell.com, manishc@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qed: fix typo in comment
Message-ID: <Y8bAc8izdWt4dE1w@corigine.com>
References: <20230117100829.1785-1-wangdeming@inspur.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117100829.1785-1-wangdeming@inspur.com>
X-ClientProxiedBy: AM8P189CA0026.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: 809155bf-5fe7-4814-e9b0-08daf8a0982c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Etul3+9pTHRsipphIkLRs+ukC621Kh9SCzgKYzLaVw2nZyYR4KHbLhVYno9fk1CKJyp9lc6cd7LG9AFq7U6vkwbS/6Hq6fy7MRKwVFGYVrBYbejwJc1t3Nv9MVWMoQaTk3+1HbiTP5QhbNEgEKRRdTdOA0vh48CubuYZYt2yXpzOcCpqNCvq/JL/vRcKN42CFeHFx037lYc42INrGK+t1KBIEy3IdlZpgOjXHeO6EPXmzUDyZvp6mbAknlYyKlrXVDccNbWs6/HAoCoDdfLaBojCiyXn4JpUQ94wQtFWrpSthkrb2AFLSOHNFSN3L1zmgQ3ptKe6UWCTshJdFWloDBkIHJ4aFa3qrK0U85r8NORwGLWBk1Nu+tX5utu0nJFjfSxgQre+2CwYUCkVJB573S8KsQp+hJHPLX/ZiXiznwkOp6lVVGhJLPBQDkaDe0fq83ufWkRWyP5/7oBO7z00q2CNIN+YCzqNoG2adNnk1c2FYgzkyweE4RFqQ5nProLDP/dpSI3DdbnsNNs4b70tt/EWO4zFU6lSjB192tWwi+D2i5ZpybZoBXiBrkbHyo2VWIOiCVuw6wQODIRK7uwb1iWqb1aArpSADg4hfN3/2tNy3kMj/kRKoJ9Av01CSgb8bJS3ERGbOYPffAd3OWXAEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(366004)(396003)(39840400004)(451199015)(83380400001)(38100700002)(5660300002)(6916009)(86362001)(2906002)(4326008)(4744005)(8936002)(66556008)(66946007)(44832011)(8676002)(66476007)(478600001)(6506007)(186003)(2616005)(6512007)(6666004)(6486002)(316002)(41300700001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qc5doNvyKiluDBz7TiK4WSzzSUM9Opg9XtorOtp6nhL/Ya85BytW2RNo7/mb?=
 =?us-ascii?Q?CQ4/a935AnwsEZmUGGtrVYkB+ULa7XVaq9t9s+WphzjJMeTjJ5Y6MgskIzxU?=
 =?us-ascii?Q?i+Zs/GlOLICyvzV3zHje/cTiimRum1Tb0yFCp+hfMGrIxrf3oIwMq9rOMIxV?=
 =?us-ascii?Q?SdkkyYFI5VvtkareQAe3Zh2ChJ18msJ/Q2EEObeE9QgCOj8+E/29qatwnFK/?=
 =?us-ascii?Q?tiacMujsIZSp9smEPia9ZsA14qZhoK5QgTHbIaP4BaUzWGTGQzmZha14itBJ?=
 =?us-ascii?Q?eEoe3t/iFAkuvxCRvAwEn+jOxxCdeYqwa+SQ74Ft7PcMBwInshcTKUkLqEBx?=
 =?us-ascii?Q?4h/uiXQRodstkoS9i9CBFSasbwhqJ2mOHluu4OKWc0x0PtGWMFyRAEDeZBaW?=
 =?us-ascii?Q?6eAiiq8syRyNwgeZeHQAZ0uvW1/fp/7PS/NO/pQAtzXr87A36waL/5xjgaoO?=
 =?us-ascii?Q?lM3D+2sKwn5iCfqEdUaqCOLDjOdbbjgwJmc+R0jbcJ8bVrlx/7LoHnPAcPw+?=
 =?us-ascii?Q?BgiupjqOyJH7HDPKzKw2ggRx8pQjQuKYeANtecpmA+a14N9H6XOpyilvgR4n?=
 =?us-ascii?Q?7D62KvyA2QqBuozBIJ5PFjBja/ZuK+yv7CTbZmw2+rCsRgcvnUFuDO255dhP?=
 =?us-ascii?Q?5FtQ6UXupl77avDqhvouEZJRCY+vwOccB1dWTyz7w81msYUGUrjlbD/12RJT?=
 =?us-ascii?Q?ICejXYjxDGZJvJy90RPGKqbw4m8Dmj0bgGmycxaLi/8BjcE3STtE12C0ZG46?=
 =?us-ascii?Q?okA+OGXBV8i7TLhRcHy39rR5ffdiupF1BiroVrzrzPSnv1bekKIMoMosfUAb?=
 =?us-ascii?Q?mXJ8ZeCKGlO4zdKg1doeKe6rKiQQy/UzHvF5b+Q02MVJriFMED8cm6jNr9XY?=
 =?us-ascii?Q?kjPa7GgwxlytB+VGB2Q7vdDU6hvg1CBrooXk2ifYZ+8x2JiNyho3hcz1HS5v?=
 =?us-ascii?Q?Wdsco94OWs9i5umQWoYASStG964Jl6uBCJTfaina6Ea3dbme6D5n/8DqnL9r?=
 =?us-ascii?Q?+BRVU0cSA5OnicyYt2LSHWSgkndhDeafwSQHqwxXID18j51zd5tgR+i1ErOX?=
 =?us-ascii?Q?+0CVuv37HSD/n+YyZ20qJwMacq1gCO4ti/MAtmflrMAEVl7kZ1qlEL6EqWfl?=
 =?us-ascii?Q?kMHxPukNTJeIdOxWIWIv91XukqzfPgs1nzaHYmUzxLimEBjupSrG/cgkHtM3?=
 =?us-ascii?Q?75yl7ZS23qhG4yEql1780ZJmkvrh5EAJoN6QkPHPMOqVjnPzxBX6Pc8uu187?=
 =?us-ascii?Q?xiHQI4IXsbUNrMbIW33rspVSCZUbEMz3zoJAPF1DKHfd3SSCCfNyF3NThtEO?=
 =?us-ascii?Q?wQ6cBugP+kj8P8/pRo91RB5OJhN0yn82/kNtOezsy+fZSiWlQqcbvky5Zu8G?=
 =?us-ascii?Q?087CqCwlPIP090ilwujHE4p81pXf0K6k+nwc22Sj04fBTmJXk6yQjHVkP7kC?=
 =?us-ascii?Q?Qd11Z8maXQ8d992D7ylaqSpHsmgDwk1r9ZGMz5VEeE3rNKWHYmB6wlUcCVzv?=
 =?us-ascii?Q?Dbx9E5slZD/tECHfQKxBlGPDRu5JdcZdANuKeBoW+b3Mpnqz7MGwWyeMhNH3?=
 =?us-ascii?Q?FV6uInT7mN348JMx5/RS+VUBL3EBJB7MDEqANfWmUAtmUd2SXBCdYIiXk25Z?=
 =?us-ascii?Q?wLFuDPWxRVSZV4si2bx7Rlgpb3saID7QbTtgb796gI1uMmGbv7T19D2O57br?=
 =?us-ascii?Q?SqpxlQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 809155bf-5fe7-4814-e9b0-08daf8a0982c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:36:26.3223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tcS9S1gcjVTp044eDm38UAvp2sLyOxatYIvowEikvfcbRCeBEOtej60sdbq5zPF5lt6dcNanK36WOlFJTSSSoUGUl05te1A7SvQB4cRgOnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4936
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 05:08:29AM -0500, Deming Wang wrote:
> Replace "parital" with "partial".
> 
> Signed-off-by: Deming Wang <wangdeming@inspur.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_ll2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> index e5116a86cfbc..a6e5e6812897 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> @@ -212,7 +212,7 @@ static void qed_ll2b_complete_rx_packet(void *cxt,
>  	skb_put(skb, data->length.packet_length);
>  	skb_checksum_none_assert(skb);
>  
> -	/* Get parital ethernet information instead of eth_type_trans(),
> +	/* Get partial ethernet information instead of eth_type_trans(),

Perhaps also capitalise Ethernet as the line is being changed anyway.

>  	 * Since we don't have an associated net_device.
>  	 */
>  	skb_reset_mac_header(skb);
> -- 
> 2.27.0
> 
