Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79364690E93
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjBIQpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjBIQpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:45:49 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2136.outbound.protection.outlook.com [40.107.93.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB49656A4
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 08:45:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMX1ENjui9cAZnHAlsPnd3hLoDLRABZzacawEEM98Fh/5Rl/47SGE4OsEsR4SwShMJpX4CBa5wQCz/atnUJtmHPf9J5PhoQVWt0cjWSYYAL9ZRBO8DIY/EUC0l1E4kYuL1KIZin/hoAzK/edNoXzg486IdjwGfZrda+fsVAuDkhXO7nvQEm46E7zXyloe5+TnBnuZZy3yAFqrKGmhHcdxFyGnIMsjhXHxKORLzZUSeZgbi5MPfyjOHW6PDR6I9QEsFULA+tjDD29hVhXELtnFAMxiJ1Eoi9W8xeeyjjexPKc830YV90RDu3e1ze1MBTJ3Doyna6KyxVEK2kMmcuvDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rDgXV6McL/hTybAd2aTkJO+KEJm09v4lc56cFHXQkd0=;
 b=Pw7Erfa0D58/tLs0vKAbxGcndxehnZw/gUwLfkqOboL+8mJADTop42GjAlCgqa+saPMGVo9sUC6fBlNecIFWPfiWhbS3XiutTrvnVq1UXrdCs6SJxq8KqzjY+aDoxGImHMFa4mtPbnu165/ce1AS3/ne9qwrsOp+nNJB+e0W9MMf7yAuL4p74k/XKQjUOWZGJvX2EdW5mrgIKpX6NiSIjqMHfTJ8ZijCTGaVGGH8C6e0BhV1Dd5si4Azn6xzbezL/SJ553HMQqqfWVEsoey3ev38uzI7RbtNJdI4ddbKUxZ8oJb7NlcCb7hEWlBU3C+mRqYRD5NI54XNVne9RfUhOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDgXV6McL/hTybAd2aTkJO+KEJm09v4lc56cFHXQkd0=;
 b=awHfRnoI/giWZ9AX1dHjca2WGp2VHogMLprVh1XN9vJ2KI5zdwH5KuWMq2VwjUQscM3vkxyFtMsTSqjXLzauROZLkKrRdMsBPDj3COF82keL7S5xHMPtbLoEZaGLN/ju+yFDtlO1MhDKjkKx0ew+Oqj8KLYPHY0+uoRJTgzz30A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3988.namprd13.prod.outlook.com (2603:10b6:5:28e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 16:45:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 16:45:44 +0000
Date:   Thu, 9 Feb 2023 17:45:37 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
        kim.phillips@amd.com, moshe@nvidia.com
Subject: Re: [patch net-next 5/7] devlink: convert param list to xarray
Message-ID: <Y+UjMZre+qzqO4Th@corigine.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <20230209154308.2984602-6-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209154308.2984602-6-jiri@resnulli.us>
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3988:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c878adf-e492-4075-5d09-08db0abd1635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SZqpoh/MwvnQIyhS0qY26zKfm6v4PcZLZIkzaX3osmCOckgOk7QuRqnILI1m475KRSinz7612bC54atUfN3NMozDvpTCJZd5lhnQPUidTkQ/4P2M/1g0XzGcyuFxo/jNs8aYImQeXXCgnCVYDqm5RP+FcCUWQkYyuh0ZuxX4MO5QnFo/vOvjw6tlAAMjan7fcxQR6ZiOjSwOAoG4mimdOTnu5XPSbYygrd/IsP1jhPE/asVIDnhztLXMRUIEnDAbPateT0za8SqRdRzPGdlxfi/SdQJSislymi33OmqJg/QN45yLs4v3abI1t5aCFnggcSZpCeJKW3/Fk0w3OaHMmOl1BXUW/pdNK3xMnMu4elMV5i77F3vT9jpZwQPa18kqPE5p8Zq0Mhl+yfOA7As+vhIvfDPhrQhMqoBMAzUodqwy/UvTf9XHvNYJx2AumrWFL3Ka58xwpBo4M9bV7do8XjXopjAl+UaIFons3sJqmFcGObCRtgl4asPP3f2o2W98zmsCZvh/trEbxuXjsLv8+ASI0FQo+dlNBeGf8dxtets5g8WJMp8AGykJx+HqyIgp5jnT74jIpauqXz56VKN8bs//k9xg8XWNjtXr0r8ely56aSL3LEv5oUQYPRvl9H3ZavFwcXSIWWnX6dNjzqznVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(376002)(366004)(136003)(346002)(451199018)(6486002)(86362001)(478600001)(83380400001)(6666004)(4326008)(6916009)(66946007)(6512007)(2616005)(186003)(44832011)(6506007)(66556008)(36756003)(316002)(7416002)(41300700001)(66476007)(8676002)(2906002)(5660300002)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Non4N9ekluZ7W1+Er7n06awb+jBNmGMVusRD+WgCg7hLFrR28+Gwsj7KMUTd?=
 =?us-ascii?Q?qLPAjoUlWZXSVqs5vujBK6aSos8lpqqSM8wvguiT689eUtF1j3B3M7i01djv?=
 =?us-ascii?Q?0e/DfRMhp5W07U6cL/NKf6wRYdNpR+awoDJGS968hJ/EEtEIx2lXoplHs5ls?=
 =?us-ascii?Q?g0ZFtgedesGn+E8sluYgmYVNm+Kje9xKXw6WVyRNtI3/QLQIXuud2GCM21W8?=
 =?us-ascii?Q?TQKYXijb8u9DFmvLytLNY5vfyno9vlDVjgLYPyaT5VdPEuzyqhAFisGoMybc?=
 =?us-ascii?Q?1Vf7jL0rTlioRc/fcoqh9nrmqEfjnlu0EbnCVWu22RwaiwhAs6yKq9a2rFNH?=
 =?us-ascii?Q?v5GStFvG1MiBlqSKEkuEnH/VKNkyLAK6jokO4SeW0BOhY85GCFMv/mIDiqcG?=
 =?us-ascii?Q?IP3C4l4QaFejPx8ohiroaGvzhfLgAUibWwIWcIf7VcH4cmyC2G5S/FYPzW1V?=
 =?us-ascii?Q?aNQOVRbj7n9yrSRlwGCAvjgann5N0QL6XPNPLNRrwWsRxKq3TYeB5dgPvMkj?=
 =?us-ascii?Q?OmMzLg7jQqjd1OUoGH5sFV0ls8981aYbFwJuRAEpCwMaIOzOruE50Pz4bUsn?=
 =?us-ascii?Q?cZC5WaeboDF//q5oH177JtBSHinf3DTRRTKrd230MlWOFrje1GzmFPJ/Mswn?=
 =?us-ascii?Q?0DCQET+6p1ySSnrz6pdOU2UbJgxCLVpIWpwacoL2AorpJWbgG1UAG9ru/VI2?=
 =?us-ascii?Q?gELwVufoMPNM9w9OF1J/wBL8gAm1la7W1lk5aqztZ63dR3OKnWCyKYgELX/K?=
 =?us-ascii?Q?Axo4u5GgrlcvpCU/HoTg+prDuTt+lQlgDahty1M9hn/K2ORdYuquwNoiXys2?=
 =?us-ascii?Q?pMOBCn0TwA3WJp+nzrJAkap//uBS8sG8VHbdxvYAXHIXiYreGFZ5UHMF6HBN?=
 =?us-ascii?Q?VqZ6b+xWCYbP4LSbCuHZo+YkgpByOKjYAlkYPy6uHH3Y9PKTZYbi0+nfhK15?=
 =?us-ascii?Q?69F2BlcTDsw1DwaXUJSET8C9HBW4LnHDObEQwWEi2nOvO35HRU4+e7DHVhBK?=
 =?us-ascii?Q?NkFSMh++Neq0/mrLEuw/oiQj/KiBx85+FADK0BWbYVXLkggNTKn1GzpxKClt?=
 =?us-ascii?Q?V6tl+5w38RXtIHX8qMGjiOH4umlQU6UbYztU8wN7tYmAmkMxiVr/GAKwzJ80?=
 =?us-ascii?Q?JRhEfnKkUW4Ckc4/A3y/yETTeBjJbkrOJscuEusKCXBhD0anA/ohncbe5SYr?=
 =?us-ascii?Q?QBWn16f+oS86rL5HqqzyCWEBZsajlx32lGgXMqdr5SchiWUTg/rlMUpwQ0zB?=
 =?us-ascii?Q?dzECL0/eo2NOCnKM3MXTBFNZ0gll9Hu4wnni6jLvUYCchBP4pVGnL6QYZRHb?=
 =?us-ascii?Q?OO4ZMWex82uVPT1U/Eu5G8C1FdMatq2vdt51MOSRfbZnI72EBHc9ACY1ux5w?=
 =?us-ascii?Q?WcV8owUC6OHBC/2qnHK/ds3ycSlUph4fOa74tv7zXQl/A93xmKz5QBlBC4re?=
 =?us-ascii?Q?0Tmp53pi4n+ffDF8yxhKu24fd/+ouoP7U87GeQOfxssPeofvgxpNq1ia56aX?=
 =?us-ascii?Q?A2J5Pjk5cs/z76mbAxl/kq/y7StAR77zyAAQdwNf1LFqgp39z/fGtptq6caJ?=
 =?us-ascii?Q?zV/gvvNyN+qY+YxAFsrpq8Cc3vvSp83aXyvtz/F2G9PanBS/nbAfqElzcjZc?=
 =?us-ascii?Q?ibYjqH+gyh4jztZcuIlqy1CGFg9W4lIDkMMCmX92HAP0+KXrfje1OG+deK9x?=
 =?us-ascii?Q?z7JNOA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c878adf-e492-4075-5d09-08db0abd1635
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 16:45:44.3093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WLn7c49UWc5lgcNENbI6bT3RgNOcIJMwMzCfiTnABi+rcseXA2JMRA5MsKUoPc2ihF7d5U5RqreNg2gYkBsRwW8zzos+9av6yl0qWOSjDbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3988
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 04:43:06PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Loose the linked list for params and use xarray instead.

I gather this is related to:

[patch net-next 6/7] devlink: allow to call
        devl_param_driverinit_value_get() without holding instance lock

Perhaps it is worth mentioning that here.

> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Irregardless, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index bbace07ff063..805c2b7ff468 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -3954,26 +3954,22 @@ static int devlink_param_driver_verify(const struct devlink_param *param)

...

>  static struct devlink_param_item *
> -devlink_param_find_by_id(struct list_head *param_list, u32 param_id)
> +devlink_param_find_by_id(struct xarray *params, u32 param_id)
>  {
> -	struct devlink_param_item *param_item;
> -
> -	list_for_each_entry(param_item, param_list, list)
> -		if (param_item->param->id == param_id)
> -			return param_item;
> -	return NULL;
> +	return xa_load(params, param_id);
>  }

This change is particularly pleasing :)

...
