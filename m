Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D7D2AFCFA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgKLBcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:51 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:11489 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbgKLAxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 19:53:51 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fac879d0000>; Thu, 12 Nov 2020 08:53:49 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 00:53:49 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 12 Nov 2020 00:53:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkAoCNbSqDLhQkEuOPbmYBaUNLwcvzephLjuhrldiVNQQOQcQQH/HScKLC+KDdY+FQ1kLMUyK6hiuKlEvoSFYtXCaFn2cJbRcju8D3NB1ZLg26QXRuzlzkfTuwToP3NMhfhWtxFxVmwpiiV89FzGa2GvQGoT6CR6ISwa/IoDQOKrXfyyt7ajkdOLUz0vDJndkn7m8Wtnw5lsfrjpCa+HCcltvuZIlwKBImmbZrM1yaw0DRSZGtA72gA4kNaMCGowhyffwfc+4cA0ReVYWIZwHLnksmggIq/9l9C59yeh6mlGiiMtPiUAqcOU7J86FNg2uSXHLz9zhtqzC+vVjC7DhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqWCF11HoDfwjYzReCI4S5+qLSZQjkv07y4jOFP99+Y=;
 b=eTbzWCmD3ndSEziiF4nmT+hl0IDf4BVWwnuwvSdnsBOe9XUVLiAGv07tNS6Hhq05hpLEbIjdvo0ozf8P26La0DL7GPHOOVGamdUCFz9X67CP8iOUd6/vOqDx4mw+c/4xM2XLsLhVJaSa4qBms2+x2VG/g1uVC1J8xfy8X+VNIncZ8UrIatFXhg/r5Xh3Y2teQU5uYk8bC+dMpzlKreW4pw6A/FN868GJ9RUGMBHzccv+jSM4QO++VK+FFw24Jjr+hbZmUPnuqhWdNMQTma+goIteL+NqqBvcpKk9egZnV7U6HaVrDsi0PvEnP7FLwWQoT297RlnmK9CyBFTtFD3+Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: azazel.net; dkim=none (message not signed)
 header.d=none;azazel.net; dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3174.namprd12.prod.outlook.com (2603:10b6:a03:133::16)
 by BY5PR12MB4872.namprd12.prod.outlook.com (2603:10b6:a03:1c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Thu, 12 Nov
 2020 00:53:46 +0000
Received: from BYAPR12MB3174.namprd12.prod.outlook.com
 ([fe80::c40f:9c12:affa:8621]) by BYAPR12MB3174.namprd12.prod.outlook.com
 ([fe80::c40f:9c12:affa:8621%6]) with mapi id 15.20.3541.025; Thu, 12 Nov 2020
 00:53:46 +0000
Subject: Re: [PATCH net-next,v3 5/9] bridge: resolve forwarding path for
 bridge devices
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <jeremy@azazel.net>
References: <20201111193737.1793-1-pablo@netfilter.org>
 <20201111193737.1793-6-pablo@netfilter.org>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <4670e6a2-1a80-0edc-d464-52baf95cf78c@nvidia.com>
Date:   Thu, 12 Nov 2020 02:53:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <20201111193737.1793-6-pablo@netfilter.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0049.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::18) To BYAPR12MB3174.namprd12.prod.outlook.com
 (2603:10b6:a03:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.228] (213.179.129.39) by ZR0P278CA0049.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 00:53:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be68cdf4-a2a6-42fe-1bbe-08d886a56876
X-MS-TrafficTypeDiagnostic: BY5PR12MB4872:
X-Microsoft-Antispam-PRVS: <BY5PR12MB48726CE90F397772ADE77B02DFE70@BY5PR12MB4872.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7YPRxoKL8u3/9KkxZ3zpL3efDRgARBBWHBLkQDNdW1mqw79+vhG3itDyvQw7bc10NTdozl68Kh05OmlLAKhQB81jkoVomm2uB3vXQ7wwpyrhYL879UkSpVHr5Z7hDUcmdxSQEcDaL9/7ZXA83AtBpSsq5oj7K/8SKS+197x4lOxzy64Bph1ZzJA/rQfNbWxzsKwzC0QMcxfO9FruukML83oogz0Xe3/Nw+oB9umOJZrAvOwKP4yf9qQbYgpG5dOZ3HP/KMwKrQDuCGN0P9AgQ4n4p4/BwfWYkTJ0KZGu3vI8/jyjIHGpmQrfciucy4RD1YnIa0nDelFemF4bIfKIXg3epLnZ0Gsq34Irht8LqVpl1lO2RA4+pkMXp2quy5wA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3174.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(186003)(8676002)(2906002)(956004)(4326008)(31686004)(16576012)(86362001)(53546011)(16526019)(6666004)(8936002)(5660300002)(6486002)(26005)(316002)(478600001)(2616005)(31696002)(66946007)(66556008)(66476007)(83380400001)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: D9FVYzkWXPhv3a4QoWZLf8XwA8xMLglZQpODQa/Ib/YZzutEDfgLdPdF0IXwpWyT35Gq8xIgPq561t9sZJXv1qKw7i/Ap6XWXWMTqNQ8XN51bExkCL8lNt4ZH/kiXz/4m/M+USRSp9gNcmt3HwBFYxjfq3MnHeaOlbalNO/AEh/Cj+B+kghQCT4Q62rNX6l7cOew/4UI4Y/pXhHFJmy8jvyT5AMaPwLuzx415UPJJjYYdzpH5qWjl0BrmxfEuNa/Y2FG72BGYrAscpaKvRelooY5gaxs5d53Xhnp5r5dTuwQYaHW62442awlah45VwdcnPTthisowj37JIyPrV92euhHpEIQXN+p58udu98YUt9yCZz0h/N6D+b10ccCAACYhk7K4niqQs2mnVuCCHAPbxMuKJy90pSQVc6CQUP/N4OjFtjycy/bm+l39GF/+DOrLVwkGs2AeEYwBd5OG6a0cy/25+wjeF/lmRGCnvC+wpiZDiABeVYXtjSWsZPpy73B/mCtKGgebGGtq2MiESsOP9fn5RNvw3NEVvq2xa7AwNAr6YouNEiW+RdVHsJ5EpSAxkUCTdER1Lmfb7xaOnnO4Ut8YJuaXp4f7uv/Gkfjxoz27H6VU9hqB/knHo/ZzzA1DejxKQyQG3YYHRU7qJ/utg==
X-MS-Exchange-CrossTenant-Network-Message-Id: be68cdf4-a2a6-42fe-1bbe-08d886a56876
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3174.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 00:53:46.1896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvDa2djhnD7Sff10S3rbe2gXNW05RIxZUTqekklztyoObx4Z8Yn9Qqpm/3xi/suwT7hPL/BZRggFSWFOa6yL7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4872
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605142429; bh=jqWCF11HoDfwjYzReCI4S5+qLSZQjkv07y4jOFP99+Y=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=SKBKMR7igGifdwpG9WZjU3FJU+005Oq4mAzgg6nDEhmLD0ym9REV2XzVtgud2B3EA
         dYM6TElFYrFABsv2o41wW9f4hVHxQ+9TNTGTaWhxWg/did7g4J1b+qb+fkeqbCwovh
         5guA6mr3YU2qU99IYUuIqy7QN6ryFdmsbVgdLPtWT2sKyDlKLImQogU7UAhIvA5h+u
         rDB/vq7KDNtYJjMLCXG81B338luTVh6j1iQxCc2LxJsSIve5plga2vnaxRxHZaiCtf
         tfipEIkWMW/veqnH0gVW0cIqR+mKmAaku16dj3KBcE2+vxVH1z6Nd3x/bvGotdiWjz
         Prf12r3hiZIKA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2020 21:37, Pablo Neira Ayuso wrote:
> Add .ndo_fill_forward_path for bridge devices.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/linux/netdevice.h |  1 +
>  net/bridge/br_device.c    | 24 ++++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ca8525a1a797..d26de9a3d382 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -836,6 +836,7 @@ typedef u16 (*select_queue_fallback_t)(struct net_device *dev,
>  enum net_device_path_type {
>  	DEV_PATH_ETHERNET = 0,
>  	DEV_PATH_VLAN,
> +	DEV_PATH_BRIDGE,
>  };
>  
>  struct net_device_path {
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 387403931a63..4c3a5334abe0 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -391,6 +391,29 @@ static int br_del_slave(struct net_device *dev, struct net_device *slave_dev)
>  	return br_del_if(br, slave_dev);
>  }
>  
> +static int br_fill_forward_path(struct net_device_path_ctx *ctx,
> +				struct net_device_path *path)
> +{
> +	struct net_bridge_fdb_entry *f;
> +	struct net_bridge_port *dst;
> +	struct net_bridge *br;
> +
> +	if (netif_is_bridge_port(ctx->dev))
> +		return -1;
> +
> +	br = netdev_priv(ctx->dev);
> +	f = br_fdb_find_rcu(br, ctx->daddr, 0);
> +	if (!f || !f->dst)
> +		return -1;
> +
> +	dst = READ_ONCE(f->dst);

While this is ok, I meant that you have to test the ptr after. In theory between
the !f->dst test above and now it could've become null, so to make it future-proof
please test the null dst after deref, after the READ_ONCE(). I realize currently
there are still problems after the change but we'll fix them.

> +	path->type = DEV_PATH_BRIDGE;
> +	path->dev = dst->br->dev;
> +	ctx->dev = dst->dev;
> +
> +	return 0;
> +}
> +
>  static const struct ethtool_ops br_ethtool_ops = {
>  	.get_drvinfo		 = br_getinfo,
>  	.get_link		 = ethtool_op_get_link,
> @@ -425,6 +448,7 @@ static const struct net_device_ops br_netdev_ops = {
>  	.ndo_bridge_setlink	 = br_setlink,
>  	.ndo_bridge_dellink	 = br_dellink,
>  	.ndo_features_check	 = passthru_features_check,
> +	.ndo_fill_forward_path	 = br_fill_forward_path,
>  };
>  
>  static struct device_type br_type = {
> 

