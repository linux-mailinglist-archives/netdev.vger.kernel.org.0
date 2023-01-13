Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3396692C2
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 10:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241118AbjAMJR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 04:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239903AbjAMJQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 04:16:40 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2133.outbound.protection.outlook.com [40.107.94.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB0A65AD9;
        Fri, 13 Jan 2023 01:12:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRQj0ELyc+5Tw4kL60wolXVFwjJPpdpBcPicJeOuaR05oA4FulMrB75mzfXE1AfC34Ozmt614TpRd1FEM9W9UmYlTLpx26NxHriXml4jSIw99ux3RbRh443gjM7IptVktyA4cr7FIZMmIdNZlTfRi7Q5fCqTOzrLmo8beQAt/3b91GaSfgi0MaMDdDwh+BoXxWR6w8nCJVK5QESlFE0U/GBTD6bEJeSkUFHQZnJz+0Ci7NnArrzu7fl1k7cXZGVGM4TENONvKV2hbBeuLGfEcrYpo2Y49jakE7WmmW+TNe/vAwZuGdLfgfWyXztjhXgEYwjzVfHCBRc7I4mPaTG0IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N70ea3OtjW7dIQjLKKRH56INMLN48DFiC19PSEnyblA=;
 b=TaiGk9dSlAbFUsh9Sk6aCFkWGUidyFphEitTeyH7429cFZpoTjZcngMRfRIPjn8qOYBxwvgSZ/ZxAiKF9hDxlY4YF2K33sf5DQ/8dpHwlQYCC5HJCFfIS916dpQc39MA3SIpkBWc7KtIQJBDa+vGBupnAffeFvyiqlcwIyODkTxz4XBk8MiTF0dTuWUVodg5RLs3uyeyaNSuDfdwSvXRN2HKQ3Rhfur/LH0a8GjEnFtZI1F1ZFabZ/XRxDqiSS+sIA4LvSPEnbpNFRrShfsrl0UuorfdTJyOkfwnzHWmR0YwOIW4CSptemXR1+VKchL8u9bJ/0hMUglR0NUOBm/34A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N70ea3OtjW7dIQjLKKRH56INMLN48DFiC19PSEnyblA=;
 b=ce0b2TusWbg3g9Hm0XQNB0Rev37zDPXNG+2UpVnmEJUqeze2/ZsHhNhZxFuMls4Y6IPitnozPH1K/Bm0EW3fQrgQ8/GxbdIfkZW0xf+78bf+FLqROjq9N9q9c/8KtliWsniu7Wkm2iBxq+uQF/NAQ250cCsSkS92aQkplxbnVl0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4830.namprd13.prod.outlook.com (2603:10b6:806:1a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 09:12:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.5986.019; Fri, 13 Jan 2023
 09:12:45 +0000
Date:   Fri, 13 Jan 2023 10:12:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        marcelo.leitner@gmail.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next v1 1/7] net: flow_offload: provision conntrack
 info in ct_metadata
Message-ID: <Y8EghrLt1rtcYSv/@corigine.com>
References: <20230110133023.2366381-1-vladbu@nvidia.com>
 <20230110133023.2366381-2-vladbu@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110133023.2366381-2-vladbu@nvidia.com>
X-ClientProxiedBy: AM0PR04CA0099.eurprd04.prod.outlook.com
 (2603:10a6:208:be::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4830:EE_
X-MS-Office365-Filtering-Correlation-Id: 54e8320f-f5ca-457a-be55-08daf5465545
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xoazLA34nWcbbxV2Alb6RgmhEYUw0qLr9Mpu3c4rlBB7JGEiuxAs/IhkC/ruBUahs54ZNFTjqliJRMLjHgZP7afKaFv6kYlmyPSp9QfZwtWMoOc3ATObaG8zjQ0/9VAnvMCKe4Cf0f/hbm7A7iJu0UbFJFXWb5QfMYq++Xf2nj4gMZmBveC0DCv5Bw9dI+4yCevPYIl0qKB0I0MmCN6iz+HDcK+lqwpjutIxSKXIy7zy+uMsM8V4doOTJHuu/CRdaSUvS3k7DNFiAou0nTj0wVZFxC9/CjE7dE/WpUM6mn8xn1YduLHi3ny/vEpSx+o6VA16iyOZ5lxG7gPfkxcGggK+l4tQ8lOkf8+Q7Hgp4r4Zm3LlVDStmh9Lf5cJ1dXzyP9sWPBxS88TbGWKRdNNYwySWK3HwsUqVsvSvwBVaP16Gk3ZhUrnN4j7OyIWGKrgpYDOSAOdUaZoRoFFEzT4+Hm3dZ/wbofLTwIUVs7Q9Go8UnjSWt6abaHZYhvs2IkEAeCxCIc7N6x641Fc14LebbZHccpBFJuYZfackHXTXs5Xd7pp1YVLX4gzko/ZTT+Xa4re/Eamy3X4uBw6z6adp6WdGflqzazKI8itBL7412dZFnUjKShFGq37dM9MPb4bKAzgYB9wO/tJkFAa7OHyfl1bXLx65rAQF/5Yey2IoBqxbTcUqprBrh+/Q8p0qC8t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39830400003)(346002)(366004)(376002)(136003)(396003)(451199015)(107886003)(6666004)(186003)(66476007)(66556008)(8676002)(6506007)(6486002)(478600001)(6512007)(66946007)(83380400001)(6916009)(41300700001)(4326008)(5660300002)(8936002)(44832011)(7416002)(2906002)(38100700002)(36756003)(2616005)(316002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fFtd2XnWv8/Z1rC3fi8XGT0Ut59QdBl/ZWQYONIYWnQDneEAaXkxRlVOnxUx?=
 =?us-ascii?Q?gsnBByTfIgOz7kzY2+YO0XbLPJ9qYKFY/sgeiP+/8hpqEtmftL6KrXIHxns6?=
 =?us-ascii?Q?SITwP5XC1yK63AzktkVK3FjcjpT7TkdoRHWiNX5lepEIa63417KxEDnPTl8Q?=
 =?us-ascii?Q?aXmt4ac4WLKp2G7Km3FSD2C8wEOcBT/l+7Jy03bICsZY33fykZdfjDr+2Gvp?=
 =?us-ascii?Q?eM3UFvWPm3gfHExVMPu/zNP2CnwxVj0QUS9PJKcZGnr/qxvsajKk+86SUpZk?=
 =?us-ascii?Q?M1gNbZwMuHNxBIyquSUBQVeV7tfaSQc4sUSRE+JpqUet+jwZmoWL2mrntBFg?=
 =?us-ascii?Q?jstjPe26InxxBUiXu0PvkRAfJcYss2w1Vbv+tXIVtD62lSe4viF9tTIMddP/?=
 =?us-ascii?Q?fmFTomor9y7M2hPlUibU7iUOQHOcKQrFXqzSIlo916lejGRkVKer6f6+OcUE?=
 =?us-ascii?Q?dYuCKG93DgpzSgxNi3VNMSVFekUys1+MsL00fTKZd9wm4GqoAV8KPM6H+riq?=
 =?us-ascii?Q?jvhnaiyracJNRE5uvBJltnyf5sYWy38yIQ5nG3taIWtc5iRHlF/ys4jLumIo?=
 =?us-ascii?Q?0MY1ptR8Wm/UmfyFt4hPp0x47BXupgOd6OQ3MtVJgp6VCDXOtiDBIML/qj4i?=
 =?us-ascii?Q?8LGQISyBG1v75XdwX9iU9HoI3NgAM3FF+8Q3hoEXWw6SBSr5YzIzgAnWDnHA?=
 =?us-ascii?Q?sDZBPG3lWK6w9mHhBCcg9qB/dl/hriM6DjRR9Iu8KWxciaqFnEpOrqjKpGeq?=
 =?us-ascii?Q?KQ4xWqGhTGRVfuSRTngHyzS3hTpHzjtfYZYINfY1IoNy3gfxcpm44nkaZ92U?=
 =?us-ascii?Q?ddLb5t56Lvb1hSiEFMr0bxJbL86V8Qldau++sorG0wiDYS8dk1qNPf/TD9LO?=
 =?us-ascii?Q?w3Try6thsqq6cZgxI5V1zePvojpZucNSgtCREm58KFv6J5LuTZjVi26oP5KU?=
 =?us-ascii?Q?GEHFB61feUPQUygduIhyGHmHp/4SlsPEbvvMKR+OLK7xrV50QfvDF1k/ivhG?=
 =?us-ascii?Q?fMh4lAYX2fe3Uzr7GbTcn042WLT9AISdx/loEnyBW5vlJ43Ov5gQPYcezx/g?=
 =?us-ascii?Q?0gOH4V6g1lB3ts+Ff3in+oG8ZBLuo0HBY5iA0JmkqF1cO9O47yrKu/PE0Hxk?=
 =?us-ascii?Q?lqrMv+4CdRiuv1B9n7H/q4E22QwBtucFw5nS3LsQv0+z2/8qaDn3FIGziCwF?=
 =?us-ascii?Q?g1XrHihfEQtG+bZzyoy1rdJs+lkODQu9eYrFgcBsOkpKFP68+Y+h2TRovfXC?=
 =?us-ascii?Q?sKC5V1VHm2UokpkrcEFTuwtI8A6gjf6u/FKSjvMUogJ+sNqcCPgroyCaTYtb?=
 =?us-ascii?Q?J+1Dmgq1su9NBAb4s0S3mL44ork8ygZJO7IOGmcEbAs+k/ivWAXUwO3Lo/Hd?=
 =?us-ascii?Q?HOkvmaBztiGLfNCPtpoEapCJpF4IufIAcjbYUv5FmW1dzK9QLeCN67lIID/H?=
 =?us-ascii?Q?mdzWtygWd32kSKtXpVaFn7SyAV6UO7LWFx/26SPkyvOfCFK73L8OPsO1+H+s?=
 =?us-ascii?Q?Zz/mhwQFupq6IedYgEFjGR7CVv8sPE+rLDBzG0QG8ujgcM1/ufnRPe7Xs46E?=
 =?us-ascii?Q?LW6xWLPX+bfquMEG6AjAL/lvBRjY2h+eHLMop0F5whNN4j+nXuo3eUH3EqBj?=
 =?us-ascii?Q?32iPR52EUUwDZSqEiRbDtWxNr16aZoL9ZSrpKCEbFJ5NgBMDRiuP4ZAxYsmf?=
 =?us-ascii?Q?LPEkLw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e8320f-f5ca-457a-be55-08daf5465545
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 09:12:45.6152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhcdl/lBwApxOQfofmND2KSEehhdRklzVROPWOfMV7QD788KTY6KeBXq8OoIhLtmgzLRciCHj2Q0ZM5vTDbh5ILA7eHpdHJ7J1mOk0ivo3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4830
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Baowen Zheng, oss-drivers@corigine.com

On Tue, Jan 10, 2023 at 02:30:17PM +0100, Vlad Buslov wrote:
> In order to offload connections in other states besides "established" the
> driver offload callbacks need to have access to connection conntrack info.
> Extend flow offload intermediate representation data structure
> flow_action_entry->ct_metadata with new enum ip_conntrack_info field and
> fill it in tcf_ct_flow_table_add_action_meta() callback.
> 
> Reject offloading IP_CT_NEW connections for now by returning an error in
> relevant driver callbacks based on value of ctinfo. Support for offloading
> such connections will need to be added to the drivers afterwards.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> ---

...

> diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> index f693119541d5..2c550a1792b7 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> @@ -1964,6 +1964,23 @@ int nfp_fl_ct_stats(struct flow_cls_offload *flow,
>  	return 0;
>  }
>  
> +static bool
> +nfp_fl_ct_offload_supported(struct flow_cls_offload *flow)
> +{
> +	struct flow_rule *flow_rule = flow->rule;
> +	struct flow_action *flow_action =
> +		&flow_rule->action;
> +	struct flow_action_entry *act;
> +	int i;
> +
> +	flow_action_for_each(i, act, flow_action) {
> +		if (act->id == FLOW_ACTION_CT_METADATA)
> +			return act->ct_metadata.ctinfo != IP_CT_NEW;
> +	}
> +
> +	return false;
> +}
> +

Hi Vlad,

Some feedback from Baowen Zheng, who asked me to pass it on here:

  It is confusing that after FLOW_ACTION_CT_METADATA check, this functoin
  will return false, that is -EOPNOTSUPP.

  Since this function is only used to check nft table, It seems better to
  change its name to nfp_fl_ct_offload_nft_supported(). This would make things
  clearer and may avoid it being used in the wrong way.

...
