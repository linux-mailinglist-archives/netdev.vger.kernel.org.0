Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF54690794
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjBILkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjBILkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:40:01 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20713.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::713])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC77565664;
        Thu,  9 Feb 2023 03:28:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpZaoDb01qkPQQ25G5fVQuB8faZVaAFQA1NgctzYk54VdVn6E6peOMGIaYThfAovlKjbmtmwRwsvV5JerJlj+QTBnP2u5DZGSB32qWecXv4mO8T4Bg2CT/Hk8A0k4c6V82eEblJTh3AuIYsB1OdpY/+R9uAiunJIHXhcgSvyak9/NbsPFe0swBBu8Rpy2cq1gF9W6VCpB7073sN9F5ox3gYGvLObQXaS1c/C8sJ2CQh6+P4mhfr5Jh3L9kLIC6/yyeVQ9wC+6cK8/Z8Q6s2J+qshiRAi3tf0zTaiBYz/a6DHmzjOixZ5CwfLR4Rg7OB5q2g0cS/Wyxx+X9OB8wpzCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CINSu18pNdu0kEbm72k/dHab6f8A6bzJEqsKPhFDrM=;
 b=M/lGF9mJy7MX9eyVufLIeLKL4lHaxyejeOJas3eq2ySAH/UQHLN01j/afHvZq0ulnfqAT3+3XdhcjSQUJmFCBQW9OgaJfGmmIo/WZ6dVg81NCWGrxGbP1O2X1kpVMHH/MwwOl1zBT8kZBAf6PLTTTuwP6BqCH8MQAzG2vM4M10kUaWqoJ17vk7cd+z/gsbehJq9CGLLprot/58pgneaB39gFCxNnqOalvIQBvtGEUm41GTvQhtdhS/LSiQLALC6ZYl61bp4bfpnNMCcsNygxqnAnO127xzJhG2Jsu/+KOQNOThI70Cj3Iu3JZukUPhUIbD5ONpCIcpaninomoef1wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CINSu18pNdu0kEbm72k/dHab6f8A6bzJEqsKPhFDrM=;
 b=TCSvzrm4P9lHM3ZzjvAqlDD6BvPzKCL9MaBYhLC3B/ZHjxUpGr6MJyxywwuEqR+xbx28rSsl5GHDA7tNNRU4jNC1fSiVdO9PwGlPX4nR/d9gyuQ7YJrRGDSr+Ye3Yfr5Irx8SgL9m2IH3Y8dLi0J8o9kuREqv/rDRE6XS0rZvSY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4876.namprd13.prod.outlook.com (2603:10b6:510:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.18; Thu, 9 Feb
 2023 11:27:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 11:27:38 +0000
Date:   Thu, 9 Feb 2023 12:27:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next v2 3/4] s390/qeth: Convert sysfs sprintf to
 sysfs_emit
Message-ID: <Y+TYo2UXuVQuXGrY@corigine.com>
References: <20230209110424.1707501-1-wintera@linux.ibm.com>
 <20230209110424.1707501-4-wintera@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209110424.1707501-4-wintera@linux.ibm.com>
X-ClientProxiedBy: AM0PR01CA0076.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4876:EE_
X-MS-Office365-Filtering-Correlation-Id: b130e80a-cb29-4790-f8c3-08db0a90a5fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NAVnUqRuzbpjuKpALJhIupUTjLWjFpK3NjcGzRGSCIswnLntnQVdyL2FlXp5k9NMn8++toLnzYp7jb9yVmDQF2olfNm3geDt7nHCGECmpmmIg4LphzRf8auv5rsOs1DxyPwrA3g26eKARfKypWR3S4zTz+GtMuQZqlzyEYuQA6hiSgP2CgV6BkihXTnNlE0o/B7cIVlSogIEEGFspXCul5zDK7SfuU0MYxDYy0N2TSsuOFkf43edyJTAnLnnElMDcE1tpbiQgsvZxqaNSyQNHxYXVGGBhfGFn5HT7rCybAHsYEdHlpWVD7bmyJN+cdvskDrJa8ZTQb+I5DG8SX3I6X7wVl7AdGAJkYAgUuC0kNvtMaaVv0lJ7QQf1xJmOrbqBjvACMnRAT6rygzYtrfboVFto+imYsAEjE61Cnb8ycm6nJjwhW8lqODkp8HFpE+4XOT3ziYbmmhHhhCZsuuKudP1+AriMOlHwR6BDpt4mkolSaflExQMtEIWnoIl+utE4dJxgCa/bLep9PnciZlIqbMmg6yJV5kWW7m9MvpGWXlKjMHFlFQA3ghvGKHW7ZSJWDQDUnkp6jwVPsUbuJsQ/gJQl/H9kAhe9yKNZwAdwdCgdgNk4+lPp4P9vcM434Gl6VuH5G6E700cQw/wHZvVUE1TxGgz6yRaMa6FCp/+/vqN48tYnVlGb9DHjfxLpEPJYP/qeagL/vqF8fxmoRiYtzQ6GdfVUoeONZjQeELqiq0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(366004)(346002)(376002)(396003)(451199018)(8936002)(41300700001)(2616005)(186003)(6512007)(8676002)(83380400001)(54906003)(2906002)(4326008)(66946007)(6916009)(66476007)(66556008)(44832011)(5660300002)(38100700002)(316002)(86362001)(6486002)(478600001)(6666004)(6506007)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q28EDzlnCLK1VpxYywBzS2PU66lftWqZim6n0pMAIetwxVC9sJbu7QCLbftq?=
 =?us-ascii?Q?HKKCCISiuHgKmvvENRcDNbr2wtbMWUUhIMCMMQ/grFljDZIKy9TcKHXMMRLT?=
 =?us-ascii?Q?gbW0mCFDuqEG+RUGrJ+1kAbAn1PMWr6XVZ9cKYVqLpDhzs1PwJnpQRD1F6Ey?=
 =?us-ascii?Q?Fr8YOzCwAPT+0+eb4h1Up+hYRqs0fwlVS7aEU6BjiBX761ZynhUKJ6pxchUy?=
 =?us-ascii?Q?q2rvn5lApmOzoLuY+a0RtzGsM2vumz3P9PGAC4gBNAAn8b7iuV7gVeZV2QJ2?=
 =?us-ascii?Q?cDig4DxYY13cTMiiAQPxBvR8xnV2+dLSEzXpZvutn3MuE0gEWUV0ljzcW8JP?=
 =?us-ascii?Q?sdfWWf0/eDVUx7xeMfFPNSJ+6y6JHHqs7xRGa/sX81GTkeLsqkf3tujwmbB9?=
 =?us-ascii?Q?s/NN2uBiG3J+NuazSZHdHKD5gAMSaedGYqFelDZMyNopM/7QfmGMASxHoOt5?=
 =?us-ascii?Q?y9nGbcvHSYH5TfbKdvq4T7rj3Gc4+Rk5s6mKxts1K5aSHW70H0ClndG6M4WP?=
 =?us-ascii?Q?URu1dmphh5LLPWWJ5s89/FF1Rl1tX7WOGPIHHJcssZTv/hBrArk9mvJs/ao5?=
 =?us-ascii?Q?q3q034Z0tRnK/V3+YkdoCRDwT1yXSGZhR5i+q7lUmWO/zT/zDiwiCpQTHMJW?=
 =?us-ascii?Q?aH3x8xQ9e84vdLpEVUaWHJWRsh5sDF3jQSVos5anzDV/wPb2JKWvLchr9yH2?=
 =?us-ascii?Q?jevmXSItZmnlzThe2tfvsd1tLfDaLWXul0ErTyfnPEJvxcSvsxy7fioBZI8P?=
 =?us-ascii?Q?SWPLNoYO6SX+W38US2Xac3TsF6UeeSuE10Jw8czXYUcC0JDvdXFozHXX2wjv?=
 =?us-ascii?Q?7ZhDzVJXqpGREnIVIHxwL5gPPk4I9+98voabtN6r5exnc4wM/EhgVLxSVka8?=
 =?us-ascii?Q?FDjuav7xXqXCdxMXcsQu1Tf2VC6WaRTTylf/PX5djB94qwml6h75NXj9Ppn3?=
 =?us-ascii?Q?5twPWBGKst6inh6/8FJf5k+b42qAylXXe1yxHDZaZGsDrKzaOpfhM2jczT8M?=
 =?us-ascii?Q?OtTmmwG41olIHug9yIvpgwPV/PG4r4d/Xc1SELzsj+l/I4P28zu76QIp9pUq?=
 =?us-ascii?Q?6duYjSNayprB7nreP7qo6zTRQ+1bwTeDBODTce6/eeMZJ5VXcJ9K58MV9nXG?=
 =?us-ascii?Q?dX/9Vb+3iZ2WPN2nRgogCmFapVHhNVyUfFUM7CEAGmrpyInQJMdkZkljSPx3?=
 =?us-ascii?Q?Rbj/3dBjP+Cwr5ai0mJ4g5xfl+HqHJjArg1tjGaKRpx3StI4d1auGV52/0Yl?=
 =?us-ascii?Q?0XCQNcoY1PGOow71mk7aIhYwnQToUdmXAAEosvUKj8voO8d4bGMFErWRkv8x?=
 =?us-ascii?Q?GI/u07n47EIVxEH3KRkfmt7xnDnfcM/+hNBw3A7RV91jDxOHC1L7cLS/85RV?=
 =?us-ascii?Q?7LCjUJ8M6WxyV5yWW2tH/PgCpHfAa0IlQPefNG2gaOumfKRW7HtryosDnW9z?=
 =?us-ascii?Q?8htQ1G8ZoQjx8koIpBFrpFgssZvYORkC2ZXSI9K8ChgJQ7YGMbPPJ5iQnsl3?=
 =?us-ascii?Q?DWqmppo156X0lZL55M8IQOPPeU6ukx+0rW3u8rrxfko1LV/HQSjmLLZZwMGo?=
 =?us-ascii?Q?xz+15mrqEx514bzXhKj1MQ0O5T8m66zYdg9NnO26xP32KzvB2ohrQJ2oP5aT?=
 =?us-ascii?Q?cbehpXPZA3A/MZGoN6I/8hjx5rrOtfNYR/B0LdpJvGQuHnefFpjjBknKXgjA?=
 =?us-ascii?Q?7X8FsA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b130e80a-cb29-4790-f8c3-08db0a90a5fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 11:27:38.0719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: umWf2GhFz7iKuP3RWYDm3VybCJU4siKqytG9RZWHUJCqpw5XN2YVC8GTiPmPE/f5sl9L7nr2OBrWnJHaYlq7ZBO8wbNwSxd2utzOmV9pE6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4876
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 12:04:23PM +0100, Alexandra Winter wrote:
> From: Thorsten Winkler <twinkler@linux.ibm.com>
> 
> Following the advice of the Documentation/filesystems/sysfs.rst.
> All sysfs related show()-functions should only use sysfs_emit() or
> sysfs_emit_at() when formatting the value to be returned to user space.
> 
> Reported-by: Jules Irenge <jbi.octave@gmail.com>
> Reported-by: Joe Perches <joe@perches.com>
> Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
> Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>

...

> diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
> index 6143dd485810..f3986c6e21b9 100644
> --- a/drivers/s390/net/qeth_l3_sys.c
> +++ b/drivers/s390/net/qeth_l3_sys.c

...

> @@ -367,35 +367,21 @@ static ssize_t qeth_l3_dev_ipato_add_show(char *buf, struct qeth_card *card,
>  			enum qeth_prot_versions proto)
>  {
>  	struct qeth_ipato_entry *ipatoe;
> -	int str_len = 0;
> +	char addr_str[INET6_ADDRSTRLEN];
> +	int offset = 0;
>  
>  	mutex_lock(&card->ip_lock);
>  	list_for_each_entry(ipatoe, &card->ipato.entries, entry) {
> -		char addr_str[INET6_ADDRSTRLEN];
> -		int entry_len;
> -
>  		if (ipatoe->proto != proto)
>  			continue;
>  
> -		entry_len = qeth_l3_ipaddr_to_string(proto, ipatoe->addr,
> -						     addr_str);
> -		if (entry_len < 0)
> -			continue;

Here the return code of qeth_l3_ipaddr_to_string() is checked for an error.

> -
> -		/* Append /%mask to the entry: */
> -		entry_len += 1 + ((proto == QETH_PROT_IPV4) ? 2 : 3);
> -		/* Enough room to format %entry\n into null terminated page? */
> -		if (entry_len + 1 > PAGE_SIZE - str_len - 1)
> -			break;
> -
> -		entry_len = scnprintf(buf, PAGE_SIZE - str_len,
> -				      "%s/%i\n", addr_str, ipatoe->mask_bits);
> -		str_len += entry_len;
> -		buf += entry_len;
> +		qeth_l3_ipaddr_to_string(proto, ipatoe->addr, addr_str);

But here it is not. Is that ok?

Likewise in qeth_l3_dev_ip_add_show().

> +		offset += sysfs_emit_at(buf, offset, "%s/%i\n",
> +					addr_str, ipatoe->mask_bits);
>  	}
>  	mutex_unlock(&card->ip_lock);
>  
> -	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
> +	return offset ? offset : sysfs_emit(buf, "\n");
>  }
>  
>  static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
> @@ -501,7 +487,7 @@ static ssize_t qeth_l3_dev_ipato_invert6_show(struct device *dev,
>  {
>  	struct qeth_card *card = dev_get_drvdata(dev);
>  
> -	return sprintf(buf, "%u\n", card->ipato.invert6 ? 1 : 0);
> +	return sysfs_emit(buf, "%u\n", card->ipato.invert6 ? 1 : 0);
>  }
>  
>  static ssize_t qeth_l3_dev_ipato_invert6_store(struct device *dev,
> @@ -586,35 +572,22 @@ static ssize_t qeth_l3_dev_ip_add_show(struct device *dev, char *buf,
>  				       enum qeth_ip_types type)
>  {
>  	struct qeth_card *card = dev_get_drvdata(dev);
> +	char addr_str[INET6_ADDRSTRLEN];
>  	struct qeth_ipaddr *ipaddr;
> -	int str_len = 0;
> +	int offset = 0;
>  	int i;
>  
>  	mutex_lock(&card->ip_lock);
>  	hash_for_each(card->ip_htable, i, ipaddr, hnode) {
> -		char addr_str[INET6_ADDRSTRLEN];
> -		int entry_len;
> -
>  		if (ipaddr->proto != proto || ipaddr->type != type)
>  			continue;
>  
> -		entry_len = qeth_l3_ipaddr_to_string(proto, (u8 *)&ipaddr->u,
> -						     addr_str);
> -		if (entry_len < 0)
> -			continue;
> -
> -		/* Enough room to format %addr\n into null terminated page? */
> -		if (entry_len + 1 > PAGE_SIZE - str_len - 1)
> -			break;
> -
> -		entry_len = scnprintf(buf, PAGE_SIZE - str_len, "%s\n",
> -				      addr_str);
> -		str_len += entry_len;
> -		buf += entry_len;
> +		qeth_l3_ipaddr_to_string(proto, (u8 *)&ipaddr->u, addr_str);
> +		offset += sysfs_emit_at(buf, offset, "%s\n", addr_str);
>  	}
>  	mutex_unlock(&card->ip_lock);
>  
> -	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
> +	return offset ? offset : sysfs_emit(buf, "\n");
>  }
>  
>  static ssize_t qeth_l3_dev_vipa_add4_show(struct device *dev,
> -- 
> 2.37.2
> 
