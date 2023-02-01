Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9827068674C
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjBANn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjBANnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:43:55 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20701.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::701])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CF64A1EE
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:43:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMlpII9+4FAWpLp61/JkVEQa3BWfOx2NBsQiIOoEjsDhzgQAPex6xlwz7gKiUK1B+Zxk/+A5BAxGLOFWPLaZWf2NDnN64Fj7lUjtfuPI2D81tcjRoXI2mLGpm8vjj6S0zt3NhOUNCgQUoq2JkH3LMhzashGIXhZeoB9XKLrEcGpxUl5SeHudELfH+bt7uKI+0rWHaPk0PFMObooWmK02P60ax87SACL2ixvcWtTX1OX9ImfYsqqhnKvwYDVW5tevVsFWlnLotZEp0/nebrujswoYpif0leaBXvYGZOq0NxLK0Znwc2Z5INyC44dKV0+f8AEhrvrqf8fHGhb9ku4O1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jlFsl9TtSQ/qh9xKc0mFt8Ev39Jzq/VBuAC7U+FCjMI=;
 b=N1Rq9ocenkGGaUrbXsTVda9DiZwqndIGrV0ykYFJV0hZs/3c0vzn9nStcsGx8JNX2ZBLHsEl5lmEiHftZtu03WyBRdaoSgs2IWD3Zfzq2RpPb65bQZ+8kaZB+oDFuQ8EkEYBHWzMReT3begtBqsn7aqzcWaZeTCy6Chuy/U6QxyqtubAT+8TmVUsMuNuybvzw59GvUawG9wKd2LgL4D5+go6vG3fu4iNx5v15+v1J3NhFz/9rYelaAT/p/284eVl5uDhjCl7KBQCo595niw1BkWHX077o3OecJoC09Gfwcd/QMyep3zN06zOElHvsBZNeIGMdr/8NExHr1FK46APTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlFsl9TtSQ/qh9xKc0mFt8Ev39Jzq/VBuAC7U+FCjMI=;
 b=jEF7sQUHrjkvJEWxTOXP6CnEVE8IQpTEPncXLZ+elROh7ATGoMvrKUoP3NG+Zt/N9r5oRbDeeXZBBn3I8c66/RJghAEBHK1wS3aWWl6UhawHXp95V5FL4lpbajzSZlDhcscMcwys4vqlRLI5rFl0G/Yq7DA29LC1B6Q359J3MME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5541.namprd13.prod.outlook.com (2603:10b6:510:142::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 13:43:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 13:43:51 +0000
Date:   Wed, 1 Feb 2023 14:43:44 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 04/15] net: enetc: ensure we always have a
 minimum number of TXQs for stack
Message-ID: <Y9pskMNnHKFAROIl@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-5-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P189CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5541:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d6bc8ac-bfcd-4799-818f-08db045a5a65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nj6Eqe1QSHHnR50DRRrG8YNh/AOxRGtslCkNojR2MT8nYV5S1A2wMsFb1Fjx7SkcGdyNev4+Un4LQtGe0B4lSZDVtqaUGWqv1PG3UWxmV/7lWQrIF2Gdck/OkFXAvPLHEmvroCk1EBst45lBMHzI/+3v0InNExbzRQJ7mHh/miUiNR0sSMnPdOALIBMHLn7InnqefTAu9p5rcgz0NUM6jswkFSiJWkp0jV9JVTG1QI84QCeWXAmWpd9jGAPV55mwNlQztD4jSv8bji0BAUrZM137310iUS548eUuGQpuSRsduEkCjlgaq30dazMQqLRzm/mGgyuhZ5FXujEGL+SndW18NX1OilRHXUk6vARAFRTz0nqdtCefgBxTSFvJejkvyYIqSb1L8X8aEbTfYDJ6BsoYTFDkMmAOYcexlgbAsTpJoeLlhkblO0pzMs+JAathejiyKMA/7yG2QjkIV/CD2M6MHjlh/Lhn/YQzRJ8la03LEmULiyfDdTakMLAhx6OwaLbJEhusc2v8c048q0Gv/L7QTu65yqa1lvhAMpciqZ9uq5GuMH81pL9G+bG9dAjNu1TIZBEvOI+J8C2dTqXa99Oe1FGg+dKXDYMFS8zT3XcIZQGq9s4F6EAdvMjT6ZHn1m55nlTSzVXYrZwFTsUJ6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(346002)(136003)(396003)(366004)(451199018)(66946007)(66556008)(83380400001)(66476007)(8676002)(316002)(2616005)(86362001)(38100700002)(54906003)(36756003)(6916009)(186003)(6512007)(6486002)(6666004)(478600001)(6506007)(5660300002)(8936002)(4326008)(44832011)(7416002)(41300700001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3oTgippfi81VtdQ3LX5gGpKHVzA2gfPb3e2GKdAxYOoJHbKpf5yWHl7DJkEW?=
 =?us-ascii?Q?T5fG43Xx9X5c+J2Fp47fAOIcQLI+7maa8w1e8u0JQ4z4YkTlA8eDvMfNqXrU?=
 =?us-ascii?Q?iDTGHgToxsndsK107xHBpB7HSV6StS99Y8R4rIJwwerIxQ3KO0DCSW6Kt5v5?=
 =?us-ascii?Q?T39KmXvOkizhl/sXc8kxnnsngRJAwJZy0DkU2ka9SQgY75LtJ73E6DG7TI9X?=
 =?us-ascii?Q?yFcw/dxOAoRIpLT0PLVJfomytSiT+xNYwjMM2pl7Sd8QlG+XlFHVKisWMn46?=
 =?us-ascii?Q?pawLfW2lV0o2OBnP+qav8EBBa/40S05qaeuI9wyStpY1WGmSXAapu4UnMutu?=
 =?us-ascii?Q?3BOcotb2503v97z/ya4zxaiGWSgOeY9+aSjNmS2ZTl2wGC2Rkz2NqCrRmZtP?=
 =?us-ascii?Q?w7Iy7TpabE5kP0zvFn769JlT9i/e/tkMVR10GoDXLM71pwXKXTWfhm4P2Tx5?=
 =?us-ascii?Q?Bz/6CXmYY9OMpO8T/9pazyKXMrOnpeWQHyjgw0excdene9foY21WiC0e30OH?=
 =?us-ascii?Q?zP4FF7Bm+FtoB1uELPgqtPgGm18ay3HZZLlerf9gHWDpXY0ZYz6DurUS3pSg?=
 =?us-ascii?Q?jz2oManxJVydlfT0rcNkYvgP7pOIz3y99RWvM9YAC1yELfkI0ybI7HY/CfP7?=
 =?us-ascii?Q?Fi0mtsXnJ2FhQFZV9eecnNMnHRZHUoS+3H4IcPV071An24PsWs3qdMbEgbNE?=
 =?us-ascii?Q?JP304SkaTFK6hZigQebwel9rl2OPWkrV5xqQEfgzcytvFNAKfrbyt6EbT2d1?=
 =?us-ascii?Q?4TF/xMKov4+7o4TDKTck4w6hC5IfYtvTyVX1sebYC5z6WbQLaLNlxz4RraUM?=
 =?us-ascii?Q?1D+CXoF6EWRVyqHGDioyLPEqNBaS2IYXW48XDSukCEI6BTc4otyXPWXtqpAp?=
 =?us-ascii?Q?FgzTySoj3+fcB8PBwClOyoH7UWBL9I4wZRU140iihairKQ/TL9xBwCCsFk03?=
 =?us-ascii?Q?rOrFKc5EACg/zYxlp2u3cvRas01EFq9rtBvoKQ1lxr9p7nHU9W1lPzPS9PRj?=
 =?us-ascii?Q?zpQm/PZaf3WErkZkO/Nhc2iaDOePWBx34bsiM5mo4EUWdGwFORBgaHPvftEz?=
 =?us-ascii?Q?6TfyRiXiM5oa3On7clGuMqOufw3bUTZJ/73nX7Lu40bC49wOaMQ52vcwLwcu?=
 =?us-ascii?Q?su8TQYKxVGQFX6l2SYnsRA66wOT4JfNXsqwidFa2z2ki2f1fQzieAkE38m/+?=
 =?us-ascii?Q?jGEif3qENMZldgp8PxVOQIEfyw5bmE6jjSISFsqmI90qHKMeDnKDLsoFCZuC?=
 =?us-ascii?Q?ki4O81O7/QHmtBuvC+dq9cBPafkrDEdXaXXelMQsqn4x5Ehr3euitbxF6I+L?=
 =?us-ascii?Q?iSDYfiBexI4t3fVDNGFqpJGyWwUmScmyLEfiMoOAAPWwlTa6lWVhlb8p6ShZ?=
 =?us-ascii?Q?HWPY2b0wacrPwoNUabvQJJ1NqXN4AvywYPPr0FoBHnNc8BEyGFKMDY9xr83o?=
 =?us-ascii?Q?UolFpUNaq2Av4T0hPwkUHeTAGVDtquZxG6h4y/4iMzLQ14fR1pLaKVRHivQL?=
 =?us-ascii?Q?B+37tu8Wm6Cp7F4SPm3zixk7dNLvOamV0/Q/+SVK9lVh9HR+fPEI1jHpw0uO?=
 =?us-ascii?Q?EHj999RVxlS1aLAFfj8tHtWpUNAFrukUsgbTRB43YOJsn79hvRVc19K/Ce4d?=
 =?us-ascii?Q?9MN1+M2rE9nPEjh6P53eRqkg/VZLcpiSraJ1jYWePC1YpD8CKX+vk67jT3oQ?=
 =?us-ascii?Q?V8ur8A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d6bc8ac-bfcd-4799-818f-08db045a5a65
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 13:43:51.6362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +b1rHlFF826uCH2RstxBxeuDzVTwBXorS6vRKHda3R2p75IF8XhyZyA7GZfQNb15rcQS3gTRIOlAz2qcQsfOkfNbtO00LUpRHx+Is1z3U78=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5541
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:34PM +0200, Vladimir Oltean wrote:
> Currently it can happen that an mqprio qdisc is installed with num_tc 8,
> and this will reserve 8 (out of 8) TXQs for the network stack. Then we
> can attach an XDP program, and this will crop 2 TXQs, leaving just 6 for
> mqprio. That's not what the user requested, and we should fail it.
> 
> On the other hand, if mqprio isn't requested, we still give the 8 TXQs
> to the network stack (with hashing among a single traffic class), but
> then, cropping 2 TXQs for XDP is fine, because the user didn't
> explicitly ask for any number of TXQs, so no expectations are violated.
> 
> Simply put, the logic that mqprio should impose a minimum number of TXQs
> for the network never existed. Let's say (more or less arbitrarily) that
> without mqprio, the driver expects a minimum number of TXQs equal to the
> number of CPUs (on NXP LS1028A, that is either 1, or 2). And with mqprio,
> mqprio gives the minimum required number of TXQs.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

The nit below notwithstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
> index 1fe8dfd6b6d4..e21d096c5a90 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.h
> @@ -369,6 +369,9 @@ struct enetc_ndev_priv {
>  
>  	struct psfp_cap psfp_cap;
>  
> +	/* Minimum number of TX queues required by the network stack */
> +	unsigned int min_num_stack_tx_queues;
> +

It is probably not important.
But I do notice there are several holes in struct enetc_ndev_priv
that would fit this field.

>  	struct phylink *phylink;
>  	int ic_mode;
>  	u32 tx_ictt;
> -- 
> 2.34.1
> 
