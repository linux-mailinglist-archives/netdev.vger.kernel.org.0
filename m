Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E12691FA1
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjBJNPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjBJNPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:15:42 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2103.outbound.protection.outlook.com [40.107.223.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8303BDBD0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 05:15:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oA69HDZ2Y9eaJJ5oJBkL5f+2Kd29JPGWpknkOpkJJBh6T+ZKdiQr6pOLyUIwP6hW40uKoFl52e5iCLYO8wSrjL9PRAt2RidmyQrl3sCM3RGfuP6U47NKC8TSsL/+ERrBE2QZn25IwFA0Xks+6XB9jhhaoM6ZPqlVI9R5Tv+mTSmjRDl3KpJHG5y5UWCj5K96v04mI2Us1agGYuT+oivCgysgdUYGU4Wmyuk0MxHU55PhL7812q3wo8RZM9KTxYNULd1xqtutFy4ji/qhMdWXEHC1dGyaPWRwt5cHMC2TV/hyoC4Rp1rsH38Fqwa9bdupYgLnT3tCn47QPsp43pfCeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMKawqbyp+ai6P69McOjDoJrnRIR5hujIS3AVjPNrhE=;
 b=H1eRog2l01QXVL7M4m6HzW5Z2ntcn3BN+nqRUMU82JS8At3CH27lzxqfSkjc7Jh8YNWclKqjS0BvLhiU+0r5URdNc8u/P5Dy03PZot+jy4VscKZeHg7+Z6e4Ybya9y9TmNFXWGWq18RA1lmcssFWpzPhGLZa6k3aU3isqQ3yDx2hxdgH+Y337QaosSpdZ/fDJ+imPaaJpS+3IOxjb1ZveAl/aqYVHOEPXmlS4/DcOz6LZW1EZO6reOHyG5YW30opNNQDRMVuqAQwxxhQS9M9g5YNxJ1gikDMsdZEMvNLj7o2bRI51X47RDHLZi9GkeVsEBQROFnfrLDCK5fViX33Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMKawqbyp+ai6P69McOjDoJrnRIR5hujIS3AVjPNrhE=;
 b=fr4g3+7JtHBkq515s0ad1oZVDs4xm2pt3uqgLX5vb3UYpLv9xfTsIRnBNJdmYKJwtEiDO5YJmVyIJ49mCDmaIK8YusGIp7gxakPVlovVUkTBH7oNu8S7vK+m+WhCWYM3cQZJ7vdaTA9z0C45DOAd0SvbQLnhk3rwC18JTtSZeEU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5674.namprd13.prod.outlook.com (2603:10b6:a03:401::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 13:15:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 13:15:39 +0000
Date:   Fri, 10 Feb 2023 14:15:32 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com,
        moshe@nvidia.com
Subject: Re: [patch net-next] devlink: don't allow to change net namespace
 for FW_ACTIVATE reload action
Message-ID: <Y+ZDdAv/YXddqoTp@corigine.com>
References: <20230210115827.3099567-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210115827.3099567-1-jiri@resnulli.us>
X-ClientProxiedBy: AM8P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: b29e6744-6104-4081-f5d2-08db0b68e77b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HgG2UR1fqDkdziNdCxMo5juyWKSy4XHdhMEA/B28HO41iqOqeTubP0GGVMPi+yagO0/5QpXEHedu+QxDxxRwSpSm1b0/9+DIa5C7S570nrK0qqif4jxQNciwsMXZZZdSZ1MOxAR7yztz++M2qO4ZePKn7g6TPCPU66bp6EsELD4Am7hwkX21xL+rFKPuiXJRW66GAJFlAaZerzrJSA7zePe6fFwER+3DyJq4WOKeMVoUMjQwbGpoyo5cJ6Wolj0hm9QjBGYa6/NISp+6KjSxuL1uN7tlMtYYDJBZpGMGpitQZHWuxX7V8gT1Tal5EywKOkDU/7x67nJQGUMU7dtGCHs/6G3z1Qo2ZPDzx6DDZJLYO+QyH3oSGihMAB9+Jt595qj7olZxXc5Sspo8OgbNneMW7mKuZB1kJcLhh0zsxkyT/gQbYgrjKoZtG0F/QvPSP9vYDn7L8djK8TQAI1IxURVdfgZ5tQqG/5YYQo8HnSOfNrFIf6cO+snFgpQs+IWhGnEkEoMqMpI64G43pvSuXaZ80XRb488YmX7NKkL7Gvwojs+/mEKdnpwn+7ZGC7fNnvBG8f7qo7VLORUDObVdw1l3vuR0ffo2BWBXTAbvch8RJzf+Jd+h2LAuEHKnmkecPoTJrt6qiAUYHJfR66k2p2YWD3obNESg5il1YgKS/wqznmj7ZTSIbM5bwtDLi4UA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(366004)(346002)(136003)(376002)(396003)(451199018)(66476007)(83380400001)(6512007)(6486002)(36756003)(5660300002)(44832011)(2906002)(186003)(41300700001)(6506007)(8936002)(66556008)(6666004)(316002)(478600001)(86362001)(38100700002)(6916009)(2616005)(66946007)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9jzLZepvl2soqtSnnCzJ4YqFxGRPfUS1U+e7VPgnPnNiF7DseoQ8fL4W4vB0?=
 =?us-ascii?Q?WYTuOlNQpbRooi8EF9c+R/XrU/JPkkhDnj25KyyUJ/+0x/txbMIdS6DaLCow?=
 =?us-ascii?Q?Lw55SogReDh5hV+ESUpdwXIYSg+NAFjwFMfn74pKSQ8AdUAGel3jYc0Acxyc?=
 =?us-ascii?Q?h6rKbNvVmN3qyxSKntsVRpjvzn1t9QcifqW1ConZpjGpii+9vzl+uP1kyvxJ?=
 =?us-ascii?Q?KT1DQFE0CGWg/cV9jsfubejnhJewepMGx2q8yoEqblwY0X6m1j6ao1WyyQhB?=
 =?us-ascii?Q?79kQ6Eco0s3clgv9owv4vJGrdBw/GxyucY+H+vzSPYpp5pZGjbOgbFT/1mlR?=
 =?us-ascii?Q?NPeEu1XM/Nn21TEwBEcMHA8HLPLE9x2JFg27vdEVh79ciihjbhOrhjzVNZ54?=
 =?us-ascii?Q?iPTnjTDUw99VSGqdLjYMBp3VES53AD2pbs9affmuF9075tSzxEQtx+FXq71c?=
 =?us-ascii?Q?p44hkEC+R9yJjfNCl1eHiNrNxXxLlq6gzKS6KOPnOoSnsNQFqJ7pQRMO2daf?=
 =?us-ascii?Q?xRAKUZzV8EGhMWWzT9Yd86r1ELG72vxdqMVsWKHd7E8QSIUpIHIB6JU1zobQ?=
 =?us-ascii?Q?LFGlx0gzkO4HBj4si/txymtg6bvj1P0iDjI3aielcNbO4jKSBIdvQpWKNkS2?=
 =?us-ascii?Q?hX2yXFBaMIUEdCwEZSdpjWf+HBp5UxlyKS3uPYhyRIuw8cOsnmekd/MDpKnu?=
 =?us-ascii?Q?PAl04lhB4jiXAqdOWpTnlGspGmpml6kTd/HhjMOtWGVFnCvkQBmEypBQHzz5?=
 =?us-ascii?Q?NMRlG/mBv2QlhyHVl/2OcqTpHnZK/iBWbhcOx/XBkmHgssOMtEx8mazqnAb/?=
 =?us-ascii?Q?e6egIm9xRc/Iys6gZXxo88zUHSGvEKlbVfzrxKwrrQ9McSnqxt5eXnaVkZLM?=
 =?us-ascii?Q?ImsKAo8gBf5EEYkchfFQ4pcJZl7yiJhnzgXqrK3PWYqXdig0OOyGfyd5Y9Em?=
 =?us-ascii?Q?CQNx3PKpOAhy5UwpEvdDFmxj4EKzofCm4PjrTAS4tHX87DdP0WFt2WrTo4yN?=
 =?us-ascii?Q?NZ6+WJAR2z90Ro2TW4Lx3OXZ+yQrQxsXgEqbZ4T3IrE2Sulw26Y9aMeqwDMg?=
 =?us-ascii?Q?JFDVuSTSOF/ZRv8FbcjCRNGZ+2OaYqD5ZznMP8XfFg01M0lodwMHryCtJNhb?=
 =?us-ascii?Q?28uFDrJMzQXcIcEPVs/r9cKXwoM3ovlkXrxDI5XJ436vo/vCO7LerOCRvhVJ?=
 =?us-ascii?Q?TU/YZ30/KRt0TgVfF0g/X4xhpWbgwDC5DvBnw5iEdbwzA60tdCv+OVFzRbDN?=
 =?us-ascii?Q?83g7qAZRoS1kBbmRb2QvDXxp0Kq+sBns6au5ZaPd3nAf8J/geLrrST1l8kMu?=
 =?us-ascii?Q?fm0X3UEQXWfVmG7Z3VY0wf2YR2Mzz0CN2L4EZ+M/rvE9Ka3UrC4VINV88tNi?=
 =?us-ascii?Q?KgoY9+Xj0DEGhsd/bd5sWzDIY8AiJFge4KSLHU+2Y4hhp+l5ypa18IAqA4w1?=
 =?us-ascii?Q?kEFkzih6RhOXjBcH8in4awtljtNmNsdogPaHp3VWOrmJhHhwfolj/sjkuRrt?=
 =?us-ascii?Q?haPoVTl2fE7zFphnJTVAfDdeTseIyq/VExOzRg52fmXC/Q1sVJG4097GCpXz?=
 =?us-ascii?Q?JlSYuCyHATRstPbtPvl/NtwLALuBzAndB49BCMq+6/viH++PYDIQ/4/cKMLj?=
 =?us-ascii?Q?/VuTL9v/Dl81Jt2BmvGZzFrxwxTLH61upQQo84L4hYo8QKhimAd+xs68ilXR?=
 =?us-ascii?Q?NeMykw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b29e6744-6104-4081-f5d2-08db0b68e77b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:15:39.4034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VtjxE+We34ydrTaUjL/ANlKCCLyMIuHQPmetFVPe4tvZeFcxcBYRlP4lRCnF9yz+AUCtARCvyT2QJIghNQJm1A8Dq+n/SGd+tZlNSXQD8Gw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5674
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 12:58:27PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The change on network namespace only makes sense during re-init reload
> action. For FW activation it is not applicable. So check if user passed
> an ATTR indicating network namespace change request and forbid it.
> 
> Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
> Sending to net-next as this is not actually fixing any real bug,
> it just adds a forgotten check.
> ---
>  net/devlink/dev.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/devlink/dev.c b/net/devlink/dev.c
> index 78d824eda5ec..a6a2bcded723 100644
> --- a/net/devlink/dev.c
> +++ b/net/devlink/dev.c
> @@ -474,6 +474,11 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>  	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
>  	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
>  	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
> +		if (action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
> +			NL_SET_ERR_MSG_MOD(info->extack,
> +					   "Changing namespace is only supported for reinit action");
> +			return -EOPNOTSUPP;
> +		}

Is this also applicable in the case where the requested ns (dest_net)
is the same as the current ns, which I think means that the ns
is not changed?

>  		dest_net = devlink_netns_get(skb, info);
>  		if (IS_ERR(dest_net))
>  			return PTR_ERR(dest_net);
> -- 
> 2.39.0
> 
