Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E51F6D87A8
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjDEUFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbjDEUF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:05:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2108.outbound.protection.outlook.com [40.107.223.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201DC4C2D
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 13:05:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xh2zDDLuDwtGzw1y+FVeyIlhGtvT5537t+YaTo9v2nI1FNCQY/9+Onlpj3IKoY3oueu6lGNktYbi3HELPLLxbjJwLmsjisK/F2HejeBDCxQvn5naJBc9jZI8PBLGkaLLcemruRHCQvx6PCVJM+IhFF21Zv8C9y9PqWfiTmbis26EFAyqYE0Cem1clMtvKSk/77iuSN1RDZTbK6dMhz2pMW6KOtyMMGqhGonsz9HFIvPfDMJBlZWvinjvccAKbXaAEmFE55OnjZukKBfQ4gEgX0YbMO1P4Stnve/dv5Wk0Nr/qYQYdl8atWjIr0QtSucB/vMdpvXMVWiRVhSzrq7tPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNteb759DJ7ylmcn40JNuYYqoqEiRK3dbPT43z7N5kM=;
 b=UB9HwMuUHW1Z0RRCbgpd5697XIFpCPRKKSAjXNBJqmP5b22FfcrwX0v2orAbebSv0iEOiMwU+rEnZMkqAgbNB1kGR9PTasC1mAMfR0onuoBzvbkv4KDE8ToqmFpfvy4Porm5TiimCIKgN8VPhHhtnI2hL3uB+He9QZ5LZXek0xV3xLVb5LwY1zELZ2X681Wtx7rxpA29M6aN+cMlTeCOX//MWlJ9UVyvAXhpY9oj2Ar+sc1VqDEPadwBK2WO9BtPAovnRH37ul1LRj60Re8AsKXxYov6Nw5U4uQCQqb1NF/iCiEnAk7XyO6TDNok9Q6X6alNqLZXfF2AnqfeEjAYAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNteb759DJ7ylmcn40JNuYYqoqEiRK3dbPT43z7N5kM=;
 b=TBi0pdpE5W9nTy/g6Ho/HIrCDfbMOXSGVwW4h7caHc5XF2cOt2etsmvaeLP2x9T3PbiFlANKaHx/LLm2hoy1Cix2H42nsy8w1cdMD+Hx60+0IEFEZhlvNVKqzsd+uf8fPZv5qjiEF/ingcCVmSKgVAszeK84hiorQCMTphotlDA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6168.namprd13.prod.outlook.com (2603:10b6:a03:4fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Wed, 5 Apr
 2023 20:05:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 20:05:22 +0000
Date:   Wed, 5 Apr 2023 22:05:15 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: replace
 NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Message-ID: <ZC3Ue5i/zjZkvMGy@corigine.com>
References: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: f6b46a6c-03c5-4ef8-cad6-08db361115ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0VuvPYxxUJ6Z7gBLbGhI6N9cZ/N0mLW5qo7Qry2R5h4/1QPCpTlcozz4Db6bT7rrBKLSzkP1/+g1YDL4Z/uoCb8Z7/P0tD4Y9uEeVETAdsUGGHg5+AmPP7UgiWBtylS1hnwclM9Pe0lHf2fqPRTvoTu9Vp6ny0mCVk+a8FqXaxKVzkRudMvGd+qS4e4qIxlErU6vpCmo93kbZsd6UoAoDh/sbpRLoof/H4Xe2UC7K6OQmVf2Tl+DYOPObYcmRLW4/IJlyKG7VfPG9A/lxOAs5gYDfk8e1VSuOC4THVmbOGamgMf1TbAQ0bpaku7KHWYPa0X0GjTyyFRIYkfA6adM0F8DyK8wwezZTvPpfJhnEw1JuUNxxuQu4ojK4N2+JYbb58E6LJX/5gJ0pOqHRBk9ShYZHB8ws9xTZkZUlW6TrmNQkLtmfvPilQOpQkXRnMeK4b8QcdvD1kUvOKf9kPng+cuJtWhYt3+KBvyhPe/icJEMwgiLwx+mZLOZXPnVDOyYrDMhJ1dnuawsdBr+aH+xcVSogxCn/s1xNmZzv/A4BrFxZePZMFIoGZEAmIZsK3OgNHcl5/xgHu6tSp3U04u/5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(346002)(39840400004)(376002)(451199021)(4326008)(6916009)(6506007)(41300700001)(316002)(38100700002)(86362001)(966005)(83380400001)(8676002)(6512007)(186003)(5660300002)(8936002)(2616005)(478600001)(54906003)(66946007)(44832011)(66556008)(66476007)(2906002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4LgugRfUZKewqpjfD9Jgbx9W7lcK/CTaV75ux6A7tFJoBNvKLBx2vmQYDY4H?=
 =?us-ascii?Q?TlD1hPYEqRm4qWa8amOU59QG7NvGDWT3uJt3nwho+prz82ZZfLY0AxS8wwWm?=
 =?us-ascii?Q?JWIWR+ljANL8UGt3mEp8xx5fuUH4I2EwxsgQSQ2aEL2mX2xNPTBUTWyIvHHK?=
 =?us-ascii?Q?HBiIv7UTcrmoJGeyUhNRYVjx+sQzFsyfWIROhUBAefkZWi9V46UQpKhmyOVo?=
 =?us-ascii?Q?HYYhyY6WW0lfGv4Z8C5sTD80ftkqAaRU/N21+XL8VRPl9EErrOpCsJktZdUW?=
 =?us-ascii?Q?VYGservug/VqR0/scm0gGJttV6N9ux8V0w2NBMxCCDp72mm1vEn3RxY8NJ7j?=
 =?us-ascii?Q?4h2AaqihXPTV+e/gXnW+WB5PG5K6znTwESl/9WKYnZcZHxIFH0l3/guIG2A1?=
 =?us-ascii?Q?FIKGq8uzPZ2IH/+CBTypAVZX+BEU+NCjBKxOoB565+ObeMenN48/y5HKCdx1?=
 =?us-ascii?Q?OjaN7+tojj1PiqBElb+cE9nR5XTECfiSyr8f6cGZ7IqhBr1AEmX7st6Piwae?=
 =?us-ascii?Q?VfRv9xHh/eTL4HWG9wfaLmFmVB2RHfrp3AGQbnXnCQNwrrdpbh2tAKVbGAqn?=
 =?us-ascii?Q?ErjBiz8LTcDFqyfH0S+gJgAQTairz/POUvllGQCNCADej2KWi3HUdEeDbNUx?=
 =?us-ascii?Q?2lIxk2vtkY5slYVdnt2wdV13mhEuHvb8NwOLnnno63lFu8XfmLxxx3I3SMJc?=
 =?us-ascii?Q?WJ9Bjm8ItOoCbeZEfMseBy7AbGbczbRatGK3mvXtJ5opw1qkyTi3vk+/dsnP?=
 =?us-ascii?Q?i6jhmuCbQP0b+6xDmIjGmYo3Cg3jSkxxvZwM++S5jttVH/tN1EMptktkXFrT?=
 =?us-ascii?Q?ClpNTaZy/QHIpy+x3IT/wBaoubkoB59do3xJauSPxueh37Tb1BraxV48Sowq?=
 =?us-ascii?Q?Dl87nL7ZYdgazbR/o1/M+DN4Yubvz+R6daZiWWr/wgs/dcgpCyjPQC2RA5H2?=
 =?us-ascii?Q?cw9wym7de2VnMcZ2F+6TucVBx7jNwYh1yoW9Yt9CHtKSSPttl5Ht8xEyrhN+?=
 =?us-ascii?Q?LRgG37rwiUDdtR+i2uqtgncP09yLiBBz7rQTZfVu1Pw2Pnt7Euak8CISCkpF?=
 =?us-ascii?Q?XMzgn8SaQPcuU8MnmluMmJWzjXu7+Ebn+Egm4xEsAX7FY3FxRJrT5s3aSdJs?=
 =?us-ascii?Q?KFCCD0beZDg9AVhOFfYldrfIM2Xs32hj3e2XBwToLnzMZqvwrcW2mzAjpPeV?=
 =?us-ascii?Q?k42e9vtqcKWPSeBpzYKPwJgosfbCBfYTBuEbtUx3+pbOytmL5Wy+MwRVBrAZ?=
 =?us-ascii?Q?bwhAHDgydIl9MUnY43rodM4AvYc9Q8pnTx1oxNMBciJyR040rTHDZaIqVect?=
 =?us-ascii?Q?iz5sc2ScUCEhj/tllOw4YOvrW3OYv5VXu7Bt6wDzg32J5ZsTBmYfSLClwaQu?=
 =?us-ascii?Q?R9RV1uUvx3NWegWHrJs0NnQfGFykxAUpnuqUcdQr01iXhdkNqkTEB2thCuui?=
 =?us-ascii?Q?r5aj3Es6ywCj4SS+FlCGfE6uX5KWQx6ucMrmEvNGC8j4L9g1x52UUiccQM/2?=
 =?us-ascii?Q?ny28WyrgyPof3rIJHY7DqoaUu0qorDhj2Nkwg6haYQpKZSFQRMqi0iZgdREy?=
 =?us-ascii?Q?bmmTFc2apajUI3Zu9n2Aq9iaTx5BtPUOlP9o0kEnICXwwzafwwnUZNZBtwhQ?=
 =?us-ascii?Q?E3gu/hKJSoKBrTT2JWNLtW0w85o5mSXbXGSrt/LLK6vC84yPx+7UJbkiKqv8?=
 =?us-ascii?Q?3bDcWQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b46a6c-03c5-4ef8-cad6-08db361115ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 20:05:21.8841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2oLMGwLmfK0T/V7yTaqONezv0m44jDsymBhWxouCuBSs07ZMDdJTsIf62Lalu+Yf1pw/U9zuLE/LAJy+bWATVlvnFjb0zJr4PJp+3KNnrOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6168
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 07:51:15PM +0300, Vladimir Oltean wrote:
> There was a sort of rush surrounding commit 88c0a6b503b7 ("net: create a
> netdev notifier for DSA to reject PTP on DSA master"), due to a desire
> to convert DSA's attempt to deny TX timestamping on a DSA master to
> something that doesn't block the kernel-wide API conversion from
> ndo_eth_ioctl() to ndo_hwtstamp_set().
> 
> What was required was a mechanism that did not depend on ndo_eth_ioctl(),
> and what was provided was a mechanism that did not depend on
> ndo_eth_ioctl(), while at the same time introducing something that
> wasn't absolutely necessary - a new netdev notifier.
> 
> There have been objections from Jakub Kicinski that using notifiers in
> general when they are not absolutely necessary creates complications to
> the control flow and difficulties to maintainers who look at the code.
> So there is a desire to not use notifiers.
> 
> Take the model of udp_tunnel_nic_ops and introduce a stub mechanism,
> through which net/core/dev_ioctl.c can call into DSA even when
> CONFIG_NET_DSA=m.
> 
> Compared to the code that existed prior to the notifier conversion, aka
> what was added in commits:
> - 4cfab3566710 ("net: dsa: Add wrappers for overloaded ndo_ops")
> - 3369afba1e46 ("net: Call into DSA netdevice_ops wrappers")
> 
> this is different because we are not overloading any struct
> net_device_ops of the DSA master anymore, but rather, we are exposing a
> rather specific functionality which is orthogonal to which API is used
> to enable it - ndo_eth_ioctl() or ndo_hwtstamp_set().
> 
> Also, what is similar is that both approaches use function pointers to
> get from built-in code to DSA.
> 
> Since the new functionality does not overload the NDO of any DSA master,
> there is no point in replicating the function pointers towards
> __dsa_master_hwtstamp_validate() once for every CPU port (dev->dsa_ptr).
> But rather, it is fine to introduce a singleton struct dsa_stubs,
> built-in to the kernel, which contains a single function pointer to
> __dsa_master_hwtstamp_validate().
> 
> I find this approach rather preferable to what we had originally,
> because dev->dsa_ptr->netdev_ops->ndo_do_ioctl() used to require going
> through struct dsa_port (dev->dsa_ptr), and so, this was incompatible
> with any attempts to add any data encapsulation and hide DSA data
> structures from the outside world.
> 
> Link: https://lore.kernel.org/netdev/20230403083019.120b72fd@kernel.org/
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

...

> diff --git a/include/net/dsa_stubs.h b/include/net/dsa_stubs.h
> new file mode 100644
> index 000000000000..27a1ad85c038
> --- /dev/null
> +++ b/include/net/dsa_stubs.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * include/net/dsa_stubs.h - Stubs for the Distributed Switch Architecture framework
> + */
> +
> +#include <linux/mutex.h>
> +#include <linux/netdevice.h>
> +#include <linux/net_tstamp.h>
> +#include <net/dsa.h>
> +
> +#if IS_ENABLED(CONFIG_NET_DSA)
> +
> +extern const struct dsa_stubs *dsa_stubs;
> +extern struct mutex dsa_stubs_lock;
> +
> +struct dsa_stubs {
> +	int (*master_hwtstamp_validate)(struct net_device *dev,
> +					const struct kernel_hwtstamp_config *config,
> +					struct netlink_ext_ack *extack);
> +};
> +
> +static inline int dsa_master_hwtstamp_validate(struct net_device *dev,
> +					       const struct kernel_hwtstamp_config *config,
> +					       struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	if (!netdev_uses_dsa(dev))
> +		return 0;
> +
> +	mutex_lock(&dsa_stubs_lock);
> +
> +	if (dsa_stubs)
> +		err = dsa_stubs->master_hwtstamp_validate(dev, config, extack);
> +
> +	mutex_unlock(&dsa_stubs_lock);

nit: clang-16 tells me that err is uninitialised here if dsa_stubs is false.

> +
> +	return err;
> +}
> +
> +#else

...

> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 8abc1658ac47..36bb7533ddd6 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -3419,16 +3419,6 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
>  
>  		return NOTIFY_OK;
>  	}
> -	case NETDEV_PRE_CHANGE_HWTSTAMP: {
> -		struct netdev_notifier_hwtstamp_info *info = ptr;
> -		int err;
> -
> -		if (!netdev_uses_dsa(dev))
> -			return NOTIFY_DONE;
> -
> -		err = dsa_master_pre_change_hwtstamp(dev, info->config, extack);

nit: clang-16 tell me that extack is now unused in this function.

> -		return notifier_from_errno(err);
> -	}
>  	default:
>  		break;
>  	}
