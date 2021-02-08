Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4347B313074
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhBHLOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:14:47 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10706 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbhBHLM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:12:28 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60211c6e0000>; Mon, 08 Feb 2021 03:11:42 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 11:11:42 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 8 Feb 2021 11:11:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUu/yQ+mjAGPELst8EC0i+rvUQknowxxkeNEkQTofHGWP3UDbHt01ctfA/OhCxij5n+EnPSKq81ZjiN/oCQzNKym7g5Tt0/T2JAzH0/0IXiZ9wKrL2H0OvfrlwA6wut5v4JbzavoqcCKQF34oXnn8BJOIxAzrWcWhigkwIXTnNp3h4nlzlsGUWt2B+p7zziBeIITz2OO5u0ZMExCDFl/GzNb9EqaV8/wxWR74Mi0K730rTCbw2xyofdBTFoNSffRKC2Diw/FHDXXdldYXvakL46DGMsktZ8C3cpFe6k1Y52rCCHsG22sj9YiN2Xq7f7uCp/rXbREJ1xtVmQVafNvfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54eFnTmaGhhT3f7XgVqe3P7OVXl69xXA7g9t9Ic2PyI=;
 b=Q/5o3+4RLAKmOwgTvSdgqzryW5OuyKgOOhGA2bg4GaivMHeSqo9VGl/zJwyUWtQM1N8mKsd2f1HcyiYKQJwIrQXw/PQKrYucfKDU4+NriIIzLiiArzIFS54Pg/Fu50c9p2NnTyzCO5AWW9wh0HmXu5b3W5uQc7y6fS8dbBwZ8BhadEPKetkFRwn9f8gdNJ+TzTmddbTn3i2al24Jsvn5GZFVV+KjY+15RBjXv+ufpmvsRSWMfQAtEOS0GF0IVK1tudqlzkAbrWalmd9OIWN9iw+ebn34x31hHi88zkTSwjCaR7URiE4QMAqoDCl2CN5WFM1hQ7ESbGAaprXjwqU7SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3244.namprd12.prod.outlook.com (2603:10b6:5:18c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 11:11:41 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 11:11:40 +0000
Subject: Re: [PATCH net] net: bridge: use switchdev for port flags set through
 sysfs too
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>
References: <20210207194733.1811529-1-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <3d1758eb-1aa0-1272-4183-27b14524127f@nvidia.com>
Date:   Mon, 8 Feb 2021 13:11:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210207194733.1811529-1-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0023.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::10) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.121] (213.179.129.39) by ZR0P278CA0023.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Mon, 8 Feb 2021 11:11:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 091d9564-3e41-4605-496c-08d8cc224f55
X-MS-TrafficTypeDiagnostic: DM6PR12MB3244:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3244C924EC8410E0A968E872DF8F9@DM6PR12MB3244.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DcTqp3J4GBs8KDGeiMJrrPXVLA7h9k/QQ5LWrKL/r/1432Hb1Tu8BuUbA7nLSc9/pj6sxP+ZihrNXJ65A8rTxGBXuaMzV4xkhsowYXhANSSNn4ffvc15TfAPxbzAeyVLN9SYMFA+wSuhV7DLkFqjnt4mLdFCaxOM48YfANmzWpJ+1JYiZgVmdapT0Aod3Z+uxHQeo0tb1RpPkVtPZ/WKlKahcXiWV1W1uF+690Pkm2dZEyHtwI+LqyC9HFDIBkTuTSYtpMLlIuqQ+7uVudpltGIpDzBU993R5Y7eNqG/uIS4ErTFYWQcSzg8zl5rbOSBfd5YD2eAyjieur0XUiM0bRRuBoalYnqWE+brmOZBlHWQx2+skx+1ThLR0rY1QdyDgmJI15bEoWZ+B3Lg67mgU92F/aMMEXUZDl83w86c7nuc5ZgI/CEeXF1FGdXVs4psU/Hf9Jmnp0K8XqilZeWTCF7GGzzSc58bYFCDjQ1AepzluuKJ5oFdD1D+J+zIUtHrT+Rj7LjSV0M241wIUKPXK0mw3EdQhleFXnPN6maSiHQ49OhBiTCIX6dMsoKAxFLj3ZKYI3hSGjZ4cFnoRZhlCIx5hnEFXSRZ3IpuJzxiDGQfpOVvDWH9Z9yHgdRKFuYZMpOa0LaZF9+YdN3XopGMtFq43ZIv5g86Rw7MNCrfd/feeU2gdz9ZoTtD1/mMuF4I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(478600001)(956004)(966005)(2616005)(16526019)(4326008)(5660300002)(8936002)(31696002)(36756003)(6666004)(66946007)(8676002)(54906003)(110136005)(31686004)(2906002)(86362001)(66556008)(7416002)(66476007)(186003)(26005)(83380400001)(53546011)(316002)(16576012)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OGMyQXk1b1hvYWVENVNISThtVTMvT1JJaWp3RHhkK0Zab2s0QXJTZmxuVnJP?=
 =?utf-8?B?YjUyVCthZTg2cFdOdmlRbGdZZXA4SHJ3QXFiS0Y5K0NHWE9xY1J4ZjhPNVJu?=
 =?utf-8?B?aEtxZVNQZGpZMmZNZTVDUG44K3FzaUFRRmF1bCtnTm9YaXJuL3NEVldNTU16?=
 =?utf-8?B?TG1ObE9INXRUdytDUWp6MkVad0hwWlVVZWVpL0lTYlFMNUNqL3J5RGtMNUxL?=
 =?utf-8?B?UU9HWi9zby9PMGZNclFJcTZlZmFHR3pkTklFK3lRaFVHYzZnRnVYZXVCUVp4?=
 =?utf-8?B?YVZ2SlNSdER5Q05VcFRHMEZaZSt5VmFhcGc2aDd5eDBlaFlEVFpqelVKMWJz?=
 =?utf-8?B?ckoraFRESUlSRXArTkg0eFIwaldTcERTL2NmV0dCbDZVek1uaXlQZERVbkh3?=
 =?utf-8?B?OFNFbzlGSmZjT1lybXIvaE4zZEdxVWNKanA4a2t5U0JEb0o0TS9XRFRZWUZt?=
 =?utf-8?B?Q2NSSkF2TjRqRy9rNVpqMGVPeG94VDNxaHM0NlllbmdLbFdmSUhHcHhYRk1M?=
 =?utf-8?B?cjVrQWZPNXVPK3dtNFMrYWlDRlBiLzBubktDN1dHTlZDb1hQd0hRZXJ6S1dk?=
 =?utf-8?B?cXpIdlpFNlNSMXU0bTY5R0phQmcvN3hPUzkvaHVLbk04L09mVEduRHU2Q1pH?=
 =?utf-8?B?RHRzRElKSkNGMGhUUld6TTNram5HWUNKbm16V1Z3b0tzOU9nNUFIRVRpR21s?=
 =?utf-8?B?aUtWV29LQStjZnRBTUI3WFRUWWRxZFo3NXpaMVRvMHAwSUZVRGs2M003SWVT?=
 =?utf-8?B?QjJncWl1SUtLUW5JTnNIOHNyNGlJenExcEduNFdwV1Rpdit1NFZrUTBkb2Vx?=
 =?utf-8?B?Zy9UR1lVZzd3VU9XbXVsNk8yeXZMS2VvbWVXb3JGZDdseUtyYmZBNFkweHNZ?=
 =?utf-8?B?ZXQ5Qm9tRU4rWUI0S0NWZVhHTzN2THFzaVRDdXJLMnk4cjJhc0tBL0M1K1Ra?=
 =?utf-8?B?QnUzaXZvbHROcnRycjNZVVArRGZKaEsxZnJBa2dTRDcvZFdLRm81Qm9GYWtG?=
 =?utf-8?B?UzNjMVZ5eFF1cGlOOURPYWJoTlVIMnJYd2VXOGdmMHhhaW1QRXhVdThrUkR2?=
 =?utf-8?B?L0kzNDhUZWJEUFdjS1BHbnFYYjE4ZWVydC9qL01sRTBpQlVxbWdpSlVVQXNh?=
 =?utf-8?B?TWwxcTNsUXkyZ1dKR1hrLzVSU3dXNFVRN0pmT3MvbXhxZnhxeVR4VXpBbW0w?=
 =?utf-8?B?STNjUVJuZTI0M0Vuano0TkJhUFNrbGYyYzhRQWVFRFVjbndCSXRXaFlxN0kw?=
 =?utf-8?B?dTQ0WXBkdE1NY2tKZWlaVHR5U1o1MmxQRWZaK0tPTS9WK3lkTUpFNXJjbzA5?=
 =?utf-8?B?ak5HNnk3Y3dKY2t0V2lLVitJSzhmQ3NIY01qMkVMbnR3azd6RCs3ZEt4UnhT?=
 =?utf-8?B?QW4yTHF0TDJZZTlMK3Q2ME55Z0lYOTlBUjBSbHp0MW84dTFYSXZzYkFIUHdT?=
 =?utf-8?B?RVVIWlRvWE10dmZhR0ROc1JzekNnN0hST1daUThHbGtsaXV2bUxjRUxPaTVi?=
 =?utf-8?B?bWxOU09YVkxXVkZCSVhBTzVtQ1BNZHVOczNEMExHY2ZsV0ZHMWp0R0Z3eUZI?=
 =?utf-8?B?cHlmYzhHOTR3WEdxdy96WC9SSWJXMlZ0ZmZndGd2YWUrdzc2UHg2MjFOWmxU?=
 =?utf-8?B?SEZNSzY5Mm1sVGJqS292S3pJbG04Rk9iQVZFWHZZRGN5MzZPMVlqcHdOVUFw?=
 =?utf-8?B?TUZmdGV2bE95Z01IMUFqdmZQRlRiN2ZLcnBJeC8rdWhieFN5dnVzd0M1Z2hh?=
 =?utf-8?Q?PPwH2QgDiWcDy4Wk0HqR0IWtO7ke3STez1Y1IQ3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 091d9564-3e41-4605-496c-08d8cc224f55
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 11:11:40.6750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qh1ed/7gocYHaoGF1QSMTp+m/mDxIl/DfY7qP7WEFFvQ5tDK/wLPuATxiyjbDT343lEhIZ7V7hHSwbsDxpHz4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3244
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612782702; bh=54eFnTmaGhhT3f7XgVqe3P7OVXl69xXA7g9t9Ic2PyI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-Header:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=sIAMF3UbE+Ye18EOVZ4r/gWZCDu+GAzjoLu+m1VjvNdxPJx1eF3hlovaWXwuTzen8
         P1Uvwq4BpsyM6gsAG2+jKYcbrnB3EpXbzNZStXuMHr4BFq4Wp6XxBIFcyQ5KDuiALs
         a8mYfZKn3tABOVDg6m3wR9qOmRFK1o9CBl8UL0kdOXK2pIcze7CaDDMlixvGs+6ZrC
         Xku+sT02Du7T/G4rJgraXypJxQDkQmis1yEyXI2XXerGEHUdtm2UEs6EKrGKCEwpnF
         LnTfYHqsmciTfW4qsVE9USw9w86ooB/81ftBqxeoKdr5q18IIfUi/DTunXVpEgT7GT
         XhGD2IA/Pi7pw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2021 21:47, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Looking through patchwork I don't see that there was any consensus to
> use switchdev notifiers only in case of netlink provided port flags but
> not sysfs (as a sort of deprecation, punishment or anything like that),
> so we should probably keep the user interface consistent in terms of
> functionality.
> 
> http://patchwork.ozlabs.org/project/netdev/patch/20170605092043.3523-3-jiri@resnulli.us/
> http://patchwork.ozlabs.org/project/netdev/patch/20170608064428.4785-3-jiri@resnulli.us/
> 
> Fixes: 3922285d96e7 ("net: bridge: Add support for offloading port attributes")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_sysfs_if.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
> index 96ff63cde1be..5aea9427ffe1 100644
> --- a/net/bridge/br_sysfs_if.c
> +++ b/net/bridge/br_sysfs_if.c
> @@ -59,9 +59,8 @@ static BRPORT_ATTR(_name, 0644,					\
>  static int store_flag(struct net_bridge_port *p, unsigned long v,
>  		      unsigned long mask)
>  {
> -	unsigned long flags;
> -
> -	flags = p->flags;
> +	unsigned long flags = p->flags;
> +	int err;
>  
>  	if (v)
>  		flags |= mask;
> @@ -69,6 +68,10 @@ static int store_flag(struct net_bridge_port *p, unsigned long v,
>  		flags &= ~mask;
>  
>  	if (flags != p->flags) {
> +		err = br_switchdev_set_port_flag(p, flags, mask);
> +		if (err)
> +			return err;
> +
>  		p->flags = flags;
>  		br_port_flags_change(p, mask);
>  	}
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
