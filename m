Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004786F1AA2
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 16:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjD1Okv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 10:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjD1Oku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 10:40:50 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2108.outbound.protection.outlook.com [40.107.94.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602D82696;
        Fri, 28 Apr 2023 07:40:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMpy+rPJOmJZNc3ZAG5b6mNjUc/XRorrphzc1dGuYcp4t2ULzMUWm7ZYzSB+mgoxX7wAnk42CjWnEohojFnt82yzyrTbmiQb7syn4J0Ddhe2poqsbEQYC3xR6otsAbHeHoEjXnS3ykwHeBk3Q6CLqmu7Ak7p1txE9CG8jOli9fLUc2Q9McqU//WSIRmTDDWHhTmdCpXqP/2t/o9JKRw0uZw+E8uYcC8WMcwqyUGPANbsaE6w2epA97ZllOawR6huZXPTVWjR/yj0Lu0h+n18oSwaiH2t5Hn1n7YKjbeifrSCwLKXqSaL5xYcjf5UOr+2UHw3Vlq18JamiyZu5ij/pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTHqVbCBKL3Q5/5gHEkaESQglK4mwDpaukPLQuSgtKE=;
 b=YQoBJxmKC6IgV1bozbq6OQqoxRGVE/dQZbHDMq6hdRwxCq8FL0lkN0Kt6Gj/h3JRLld98vKDzvSFJzUVY4a2NDhvBjw91OuThPijCF1oC2QS62RTSF3cNzKyNRP29idva443+P/G4Xtx5LRW5Dkt8kt5A3sawLyswcl4XraeRObMcGeJ1gMeEwhNhmRYsPFcUi7L2EvXFlzzFmvtX7xhrJXKXSv7RYfEkr8ytSkSO4JwSqf2rx3uETI7FIXXY6R9bLd88JbmNXoU08rEfQcuKVreIevmiRjnVvAnJcwlh0q5uSituDawOEOk9xxBvgRhDQgTpNJvGtdxuUrydhX5mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTHqVbCBKL3Q5/5gHEkaESQglK4mwDpaukPLQuSgtKE=;
 b=DOaxPq1fpfya73wB6TYXs/tscnhMl40Y6lFXT0WoNtOKBACO+BcJt7kg02OpmF//fL1VhN7a4uahD4CC7S1Fo33WG9JI+5YZGOhUxJy0CYdMmsHckw0w9qSTQ9CFp/8WrpsRynHN5wdMsq5B3ZR6kYWaKHLYaiTgjxlyM6NPsak=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB5061.namprd13.prod.outlook.com (2603:10b6:303:db::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 14:40:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 14:40:45 +0000
Date:   Fri, 28 Apr 2023 16:40:38 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v5 2/9] net/smc: Decouple ism_dev from SMC-D
 DMB registration
Message-ID: <ZEva5rj3DWQEmix8@corigine.com>
References: <1682252271-2544-1-git-send-email-guwen@linux.alibaba.com>
 <1682252271-2544-3-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682252271-2544-3-git-send-email-guwen@linux.alibaba.com>
X-ClientProxiedBy: AS4P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB5061:EE_
X-MS-Office365-Filtering-Correlation-Id: e6619a79-1472-4360-62f7-08db47f68c62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ffH8/ZSyV5kCSbYm5sEsCBzWH0mZ12a9Qa8qeU7U28A9CIh2zb+zK30gSXoCdZEacvCXrlYHNEkZFLZoq1OzGVtfMqzOLDTcC2NShmvZe5lkZ3otCSbcyX3k+uzHOj7KiSambj0gwqQv9qBcOkGX1zhx1TasKOXnFjDsOmVS085rMZAqbLl4DEX/11WHGOGV02nNvMCxFmX+ADFzzMzXcWZmNEGYyrFrcXMuRqMh+/3Dt6IksQ72KHPLRBBzLTAHm1maxX6WOp68Fdg6arJVQA9LOm972hyW37p9QDymbjEbxrme3b/dNJXM7kZnfsLTjLs1LWEE2IZgXuCx1fEmWwkvXUIQVWYxeb2io9bv/WK5aHkS2/oIvnsFPSNrXN3POyR+Iz9kdlBa9HY9zvvF6Dk9//b4e3p6lR2sTLDh2HdcWId27Ove5Bd2mwAtfW39PXGR7cP8N4qOZj4FMsG3mm/H/vtK6nBwyajDKu83qBz7WIDaLE4hsoAdn49oE+I3ulESANMPlHIxIiEiWKq4bQA2ax3jFTs4fDYYFncri42NP5k0YEoo0VU8c4up5Yt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(366004)(39840400004)(451199021)(86362001)(36756003)(2906002)(6486002)(186003)(2616005)(83380400001)(6512007)(44832011)(4326008)(6916009)(66476007)(66556008)(478600001)(6666004)(66946007)(6506007)(41300700001)(38100700002)(316002)(8676002)(5660300002)(8936002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gvJnJBO/fxZuty+w1CEZay49R7PWYANJ+BGAk3UlxVeyRZy9udJUIojORFPx?=
 =?us-ascii?Q?jNrFdfUVK3zfWYSHpKONhUCQvZ7H/4ZESzDz1R1/+nIJJX8WgX9SnsT+FWDS?=
 =?us-ascii?Q?U0DuMxtB2fopIB3gIljMen5NK9vOLv2gqlN0NTDXFaeLm0Fx5oLJCx5vykdv?=
 =?us-ascii?Q?OwDZsjOig8Bv7vkrOPNmin9g53UOuIz0E3ORJ2XEms6bx5GJeHycs8YTmwyH?=
 =?us-ascii?Q?+LDDzvrUU7emeS7O/XwRokSUDgL3vGveZYN4OlSd00Wqt2Cq2w6d6xkEb30E?=
 =?us-ascii?Q?JcifI1Tcq5WMygHzNjofeNyfmXixEB0dzTH2WzT0FiRSCBtODj/KAKwnTbE9?=
 =?us-ascii?Q?/Janyu2OIXm++yeFMPYWo2+v7wxa3azl/91yPpS2g6tKVrHmgAmjM1cdRAbT?=
 =?us-ascii?Q?mRpkh9suJHSHx+PwGwJ6FT8f9UT9YQ2x4FSBLFK54LtD1a3fBqVA+i93zAUm?=
 =?us-ascii?Q?rUiiJv1yy2Byl41+uV9zmSXgfIQv/jK07eAFlNOD3SqXyOkLhEGL9iMGjdQn?=
 =?us-ascii?Q?S9GiT3xYdQU/c4nbAGRFSMstYnEjxaSQbLgtDsAoE5p7B1lUTwvBcebAx2e/?=
 =?us-ascii?Q?ajdDLW/BjtwY8auFb9oIF96BmXCDIIv8iJYvJn3dw96XhqYw8vKdy2aQDQpW?=
 =?us-ascii?Q?EIHZ6qawF+1YI9tjI8FJNaWv3TqGuICpGbFqv+Lcrh4oKWDPOAv5ghDfhBpi?=
 =?us-ascii?Q?WN/SY8mPJxlLviMYnGXVbSYmJSfPsZQyBFeqO7gG4+AMQJv5Jft2nodmivu1?=
 =?us-ascii?Q?jcvwiSVwXDdqKwxLDJ6cpyse2yZDUzL09NTCeL7W580R8yUJwVQBsIVqZLg2?=
 =?us-ascii?Q?6CbuZ7JUEUAnkzRPL9GbINwEJu00h5pW8zyqtRjxOqVu1Nl68eGuF47g15a+?=
 =?us-ascii?Q?ZZZxbyMjJ4UCTiAPourqiUJ9DKI3016UCQ/A7qmhtNTKBsK2wfgggsBnFfLS?=
 =?us-ascii?Q?FfJpZ4b8A6D5p/B++S0v5xsFc901DmXp/XrgCeMohdPAO6w8piDPYbadEdZr?=
 =?us-ascii?Q?0L+EQNDNP1YlPHJw/R5rHGoFfL9eoy+KquDc5Er70srITswGf9RwYTEM2X5g?=
 =?us-ascii?Q?SLVMkRs7Tf9KioBhUPDJQLAD1rqh5qFSHzR5YgxVhU/sxpEZLLgbc7SSshpb?=
 =?us-ascii?Q?qCS2YQHZ0fVICqaVWxTy0FKeCj32LFs4R/MaKm3OVSB4VZMec6Heinr4T73M?=
 =?us-ascii?Q?jeUx8KCBYRuBfXhqEGD2l/Yfc/zDPKNo4LJu3PBg7ha5Ha5ntDYhuAZmvwZg?=
 =?us-ascii?Q?mk+TJjfdMvgX8Ui9uEKtzVGqeieTMT2StLpVnRHLK3QkMhWnwhZZM2yXxEgN?=
 =?us-ascii?Q?p6qj4MR3NjgjAW0rJWUZk/UoJ3rA4A/O/YP69G3U3wfHFg4VGguQbRnKPgrS?=
 =?us-ascii?Q?Z19gx6COw4Wx1dpI9JCuK63L4DwAh2R8f6LsyaNXn2VWFWxNKCn/a6zUjLkC?=
 =?us-ascii?Q?ClqMp3cCmcvRmMop/nBhOSzckTn2edBguf2Csi+Huu8mAqj/vqWRPeFSQ89N?=
 =?us-ascii?Q?rCpzLHKLMb9WU72dhm+yAtqV+hMjmkyp9P+ubDMXXcu+g3kH1AhrKr5QXD6B?=
 =?us-ascii?Q?VgbQTzj9c7C6RbBf+2uMrKm4KWpq2mWjIZ+RS7y1C1xI3pAMnosjmYjjb3Eu?=
 =?us-ascii?Q?uuhSoDUyhcbcz/q2Q58gW2J8sflA3+49tjVLoryE/e6MolQj/pMzSsoQJp0Y?=
 =?us-ascii?Q?3WC75A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6619a79-1472-4360-62f7-08db47f68c62
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 14:40:44.9696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: taybg2DLUxM5EwOuZEbdRmScNnFhr9KpuXr0ZZWvJLDQ+WObryaKqc2x8dRfOBhdp3j/YAZIL3TStaR171qdkOIL4l1SiAkOcPLCdikwD+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB5061
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 08:17:44PM +0800, Wen Gu wrote:
> This patch tries to decouple ISM device from SMC-D DMB registration,
> So that the register_dmb option is not restricted to be used by ISM
> device.
> 
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> ---
>  drivers/s390/net/ism_drv.c | 5 +++--
>  include/net/smc.h          | 4 ++--
>  net/smc/smc_ism.c          | 7 ++-----
>  3 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
> index 8acb9eb..5eeb54d 100644
> --- a/drivers/s390/net/ism_drv.c
> +++ b/drivers/s390/net/ism_drv.c
> @@ -796,9 +796,10 @@ static int smcd_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid,
>  }
>  
>  static int smcd_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb,
> -			     struct ism_client *client)
> +			     void *client_priv)
>  {
> -	return ism_register_dmb(smcd->priv, (struct ism_dmb *)dmb, client);
> +	return ism_register_dmb(smcd->priv, (struct ism_dmb *)dmb,
> +				(struct ism_client *)client_priv);

Hi Wen Gu,

a minor nit from my side: there is no need to cast a void pointer to
another type.

>  }
>  
>  static int smcd_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)

...
