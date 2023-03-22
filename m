Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5656C4CB1
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjCVOBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjCVOBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:01:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2127.outbound.protection.outlook.com [40.107.243.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC14710FB
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:01:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ohh3TVl0IwWVggH4XfxqUy2SNFAnFk8qlgH7LkatDfulHklsUPbqGz/lgs+QkY9vbhmbAblGt71SwepZGrbtf7/sIwi3c6yOfhP6NXiFtv0Sivl3wvBsOqhh0m6j3n2cxruEdSdlxNbpLkHriEAXkAp4ui1M5Ld11dycaWbHTbMGk1UIlEcoEeuR4l90yTp+2jt1Cimbkki2igaEZbUShxMfAfaHUEqqUn85lcLgoDupSAV8AaLugG4T6qsMayGy/hA0e9jnj1bpkJOkpq3F3A7d/R6fnLKuAN9vcV5h8J7jseMvQOMPA8FQexic8ov1+s4V0xMrBEMRguUPSHz3dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UXmOhDpElvRjCAZMly++67nIIL3J5KsG6fCr0LvmMwQ=;
 b=I9cJfmSVt9KX+i0qpX4CQq0vNzkmMaX3tvXeGwZcvfQlUh5r9aKxrGPasDNbMBDlgwcoYcGOxmu9An8s5V9nq3OXzfRHyM9dhb+kWFmIqKu1hfNV2EJbsrkc+8bFbiHdKn9qcNKc3P7zMaewm2PWyuo6H9gQ6E93WFb4jUyQgzHbxWXFtNdCIeIHk1Kc2xr8/KcnikcLx5C2kqTGSXYWt9FwadKewGxopNbbOQP2fjWu2Xzq3Q05lKTqQxxvAQnAKSU1EtZl7K0mF9kMFas+hm8Q2EVYsxk9TbDuv1jU6QjeyMIGLTKSfQD+/0D7BDG0ND1QelDXV2DIRaxrDAZXgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXmOhDpElvRjCAZMly++67nIIL3J5KsG6fCr0LvmMwQ=;
 b=EMgXqwZbe1Vgpxi9ertMAJklrbLK1vFSLQ32NTlsuodEAUcI7atcWUB1C5fS9iVVRsY7wEh3WLCe6Z/u0zQ8OguIK6zSkAGw0fZJmuGoNNWoWZCSRIDEE4qaiCPcEqAF7IlXqSQD5+Mja6YSqyUsWGq1zb/K7NDwaqYfjqovl1Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3988.namprd13.prod.outlook.com (2603:10b6:5:28e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 14:01:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 14:01:01 +0000
Date:   Wed, 22 Mar 2023 15:00:55 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: ethernet: mediatek: mtk_ppe: prefer
 newly added l2 flows over existing ones
Message-ID: <ZBsKF4r7bARMFNp0@corigine.com>
References: <20230321133609.49591-1-nbd@nbd.name>
 <20230321133609.49591-2-nbd@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321133609.49591-2-nbd@nbd.name>
X-ClientProxiedBy: AM0PR04CA0040.eurprd04.prod.outlook.com
 (2603:10a6:208:1::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3988:EE_
X-MS-Office365-Filtering-Correlation-Id: 156ccc25-3982-4c43-3b29-08db2adddeb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZPOcl0uMpbizGXoyGy/WrP+CbTZj6y+6feGoNtz+liRONYaPRXDKcOBOqCyFyZ5s2kxmWIoBZPBztsp9lWyOqn3W+eXYMcVsnNS9GeMxiDh+TpJ/49tjQT1tE1utrrS5RmlM7AvPG43JXgAFDHVICvChxWMB6/x/b2PZgm2Xs/m9fyKERdWnAe8s6xfB2oV7bplSlZPlS6amUEtNKD5qpYHXAYr8SCbGGBJrwDw3JweDg4MudYuhbtd4DbF9SRfZGAKWTh9PfTu9JSRo0f6awslEmP5gJloBl6NUaQ0EwxH8hTMyvkt9F+xXdk0iRPA/2r5SIckkzcNz9OthMoLzBg2tps+Ar6UcNJlfcsv9hQVPU3dYaprQiU6fi6iq0+NCdY53uISisg5zI46SvHbdmAAeFZTf0XXdkdECQI0CV1buIK42qSY3ViTpG5iBK/z3SE9s7r7Ja8l0/B0b2zuvA8kGfbmdSp21UmV1Pl+vobVnTvdN7jHuw/8O7VRvlCJa9FgweD4i+/40PyW0U7KxHdoZXa84uhouzBjzDcIbVAspVKSkaRyMX4nePvWx1O5tonY1MRaV9T7748JLYsWke9FwDXgghiE/gP5TwC5QVCQLi79LvzZ80EuEBCp0f1GGBbpW3ZX1zK3ahP+FFU+rfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39840400004)(346002)(376002)(366004)(451199018)(2616005)(6666004)(6512007)(6506007)(6486002)(316002)(6916009)(478600001)(8676002)(66476007)(66556008)(83380400001)(4326008)(66946007)(186003)(44832011)(2906002)(8936002)(5660300002)(41300700001)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fkzp+AlNG1Chv7UtpuzrFQvgn9e1E+Iy4sm8K9uJO3+fvJr/WyUPHvaCnBAQ?=
 =?us-ascii?Q?QJhP2LLbVh8kt1D7h4d1KNgOTAEUlSUssz4XQr7HCRqprdHjrTfIGuykF72g?=
 =?us-ascii?Q?oYH4Asz1jVhKS6sl4J2vqQ8+1Qrn6F5i+1eOJoPFov28V+V76RfIjVVaOcId?=
 =?us-ascii?Q?UAYqsYKGY2wiJCINwQM0o6nioS/CXsJzvL7ZoYxM3fVzILFEBI1EcKLb3vaH?=
 =?us-ascii?Q?u05YROXJ1FWs5YJbWK6btpG78AH7ctOLRKKw6gFB1X526BjtS85BUledeN+2?=
 =?us-ascii?Q?inEp2n02R1EspDtZ2JoXJSDxPimV+48eBfp436fJyKFHUk3CvN+NOC//mtZ1?=
 =?us-ascii?Q?w7Vgv6W12yWyGEEWdClmMSfqfA7n00EA2O24uTPmAQDzza/NSyAwO0tK3J8R?=
 =?us-ascii?Q?MBSl66kFpMm98Gv5fmtbQ4Iwx4HDVOu5pt+8qOlI6gjfcm+ng4CO9zCp/38y?=
 =?us-ascii?Q?Gzj1CgDGata84Qd7c735wCQvc2idLDiMRkV9f4uj+/Zo3crp04xgQOvZVzvc?=
 =?us-ascii?Q?/tRCH8QfZlgKOv7bvXfalVZmcWTL7YvA4LIRWgWpCOlSZYFOpnn64VFuLHpl?=
 =?us-ascii?Q?yWVWgq5CZRmOfbkeGQadeTjXq6Dy0IxqWlqFZxsJZe+Pc85h5W/yEgPmE0QG?=
 =?us-ascii?Q?gXwy4RVjPJVKiCFC+n942dpZxH18F19MUenv60325C/RhA78z4wdCBYOKMji?=
 =?us-ascii?Q?kcK39z6bKrbNB6NZ1RIMTziQv2KuYEmY9vd+3pw1f7F/5CbO/05FeP3DaQkB?=
 =?us-ascii?Q?P8oGlGAUJJG0moRoHjQPKVXdo8Im6XgH9cECzTXFmzwAgCCWnvEZGSBPnwjh?=
 =?us-ascii?Q?LvsL+rfzOP++ZgDpLmTtQTlUm7QmmNkwjzog5qNJP/MwQjw/t0C5+43doV31?=
 =?us-ascii?Q?S7RkBnmpLOX3MbYZ66YqRwkCijIRrveEb9uLyCdQsyL8C/2xfWI+GUz18qNi?=
 =?us-ascii?Q?zX8UV5KiLTUoCQDaH0AJrC8IfU/0mjiiTzps65Tg86azctL52rDkR1VriDWG?=
 =?us-ascii?Q?UXS8472LPhC+KVgdJFZSEgW9VkKFuaGiGH99hdyOYbvM7gZDTCw9lfF8Xlny?=
 =?us-ascii?Q?sUi2YVLOcxGXhJTq57oSuQV92LtIrt5lzYG3dqm4DiL1F8HHsZtbolAAXf4a?=
 =?us-ascii?Q?sKY3yx+caySuYvoqOpPGKWYYEtrd8kKwOQb83X/Rv1l7/ZkzJDPJQ+WcPLCa?=
 =?us-ascii?Q?huS+NKzoeNfEy6KggJnhZYC1UXSImr9xIbb04nzU9vKxBkq7KIs/Fh+UUQhU?=
 =?us-ascii?Q?ZINciYi2ooAnO838Hr/r3nEwoKgLHT1TnQ8cAf7gaGYjf96xY7Tb7SkFdEhY?=
 =?us-ascii?Q?uEU+EPHzTVT5XykwNTKgj5xqtgnK+IAQcxvKybB4ejHzvA0+n/hcdsG+rWVi?=
 =?us-ascii?Q?/pJ/l36zx9U70Q21Tlthnt3yMcmGQSuuPs5LEr1EORL8h6Ge8zlK9JWJpNPy?=
 =?us-ascii?Q?QNhTGvg1tRrRTML1Ju651C64/9e5HsNKqBiKJld5PflplrZonZnb1yMP/ywi?=
 =?us-ascii?Q?Aj5SJSC0PC1fLMUDCNCSuwfpC/qntNEW76YRQdLME4+nVWM0dGzQUi97Doex?=
 =?us-ascii?Q?Uo8tcJsuU/Mfe9PV+LtJectmVZCFlt/BmmVmmX0vWr4NPoZDCpNKrjjsR5hR?=
 =?us-ascii?Q?+Rn8Uxq8FfV4aGxT6Px9ejyx1SowN2WRlx00Q7qls/7T1rSc+0USPU0j7jzU?=
 =?us-ascii?Q?JLU1zA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 156ccc25-3982-4c43-3b29-08db2adddeb6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 14:01:01.8024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pD1IKGWpGzALoxp0I2cla6dvgIC7sx9XNRoZJgRsx+fCNvyZ/Ciq/vpksP52P8rZQJpPWFqTicDFTJI6xJNp6xcYRXCHlptkWjY57Zc5Nlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3988
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 02:36:09PM +0100, Felix Fietkau wrote:
> When a device is roaming between interfaces and a new flow entry is created,
> we should assume that its output device is more up to date than whatever
> entry existed already.

As per patch 1/2. checkpatch complains that the patch description
has lines more than 75 characters long.

That aside, this change looks good to me.
But I'm wondering if it is fixing a bug.
Or just improving something suboptimal (form a user experience POV).

> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
> index 6883eb34cd8b..5e150007bb7d 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
> @@ -580,10 +580,20 @@ void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
>  static int
>  mtk_foe_entry_commit_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
>  {
> +	struct mtk_flow_entry *prev;
> +
>  	entry->type = MTK_FLOW_TYPE_L2;
>  
> -	return rhashtable_insert_fast(&ppe->l2_flows, &entry->l2_node,
> -				      mtk_flow_l2_ht_params);
> +	prev = rhashtable_lookup_get_insert_fast(&ppe->l2_flows, &entry->l2_node,
> +						 mtk_flow_l2_ht_params);
> +	if (likely(!prev))
> +		return 0;
> +
> +	if (IS_ERR(prev))
> +		return PTR_ERR(prev);
> +
> +	return rhashtable_replace_fast(&ppe->l2_flows, &prev->l2_node,
> +				       &entry->l2_node, mtk_flow_l2_ht_params);
>  }
>  
>  int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
> -- 
> 2.39.0
> 
