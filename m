Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63ED66D7CA2
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbjDEMbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237988AbjDEMbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:31:41 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe12::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D1E4C31
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 05:31:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+oRonybbKdvYRabO5TwkPCHt9vDty8cup4u2IB1gSkujX4SJQUW045aisudGs7p0w9itEXdFkzqpSpl1VVTfr0NLO0zCDYFQbP/VKoBnoL5NhaU8TEpDbycnORryhFM8jiO1Cfk4pN/aCak9VU5a7QqXlc/uxeGtQtl+w7dmSKkaulGXi/peR06uev+G6Q2IdHAEfzwsc8Ezhu3SnDQJCIeiQizuyqxSJ4tBnpilZpsj2iY9z/+rMAuqbKhLVW47ZOfRY9ETlkKe9RbwM8X5wPUrm+VP3GWXmUNr9jmxD8rHK09gO7nowZa5MXuy7p0FahSW8SdpJB300JwJHzlKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwfArx8zfHf6QI91b5A4grs6b7FPrS6jMo91JiNCII8=;
 b=mj7Q/A9cuvdS0CadDJOv3vrjNCxu8oSUUHYcmxacuIXz2A2rOtiszhBO+BYNMbmCM8XSPYblp8saHcP8In9QRPwlNvWrbI79aEPY5iJZoKXtdymyDCbhMOwe7EONvmpAhJMtfHQ+9p5bZMWr3/UU6QrlQat+x95ImbyHCmGOYa6oP/n71mEfQ9ATW5goKxiYGW+WzRQh7V8DlLatyQRjyloTfndpP79X2ssBmBEFTJCq/S0IEKr/ooQJ2burOEhzfJ+1P3aKfSJFanAUWmXli2TJkswcUbc1BcoRUR43XFySttYw+zwEGbFhFzJMbHZoivJ648RDqcdhDywUiynDoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwfArx8zfHf6QI91b5A4grs6b7FPrS6jMo91JiNCII8=;
 b=CsUsqoyRl8ttMCoJ5l0gSdrabLCtd5UOHkGzTjWZ8WfgRJmwNYYVRBtT60En8NWS0EhPero4b/XNRsYeqstCpQ1oullv7aELrcCWntLeCZJer9xuff/qRSrr+wfuhwI4kpkhnqC3aIQhexruKua29m1TEi4Blnzlt3u93AjXRA4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8074.eurprd04.prod.outlook.com (2603:10a6:10:24a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 12:31:34 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 12:31:34 +0000
Date:   Wed, 5 Apr 2023 15:31:30 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 1/5] Add NDOs for hardware timestamp get/set
Message-ID: <20230405123130.5wjeiienp5m6odhr@skbuf>
References: <20230405063144.36231-1-glipus@gmail.com>
 <20230405063144.36231-1-glipus@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405063144.36231-1-glipus@gmail.com>
 <20230405063144.36231-1-glipus@gmail.com>
X-ClientProxiedBy: FR3P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB8074:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a8a8eb4-f04b-4b93-8f6f-08db35d1b10b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zWOzNnBMz5MUFp2bR8vcFEgD3rlgd1qSFSWQVhdLMtF1PUFlA+WrcUdSOM8buyHg3we80izXuqwamdx3r/Y6UxOjf/7gfz9bl9DC0QieW+7ZeAVeU+XPqY6Ex3Rrpsh210xoWlH3Sx7WUtGHZhSjLyDsg1f16RaZqM8kmxYSza99+Ce8wcHjvkKQbvSJuXzRrnw9DbXimd5Ghs0ikqXwMZtdfehDe9kH2yBUipPw4B8KpQODH6178spwQfS/5ezwkscx7z0Sa9OIsaZpJg+aTkZbkrpAOL/EfaOnQ4Pqze/GET+o04+o7tG4zDFY3sjIjp/6bP5vF9mQY6m9gj2Dy8481SSWTsDzN8W0IFH9isPUEP6QwA8QHvu34XzwLJvJ7qHVXuOSUuWAFHtLZmzGtMywg7lOM3cstsUf+JZDhYvL08AP3lSkOAgearKx93UheYaLavqCDFjrR82MLn6q8/M2H+KeA+JGbV9EOkG9pTYnCtReZv3Kt9ZVeZrpSWRXxxMXcBcJ0E+LNnuEw4JD0OglyUu2cDXGgvNxUkuTe5E3S4YrGquTzHewd6MTnB3J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199021)(1076003)(26005)(6506007)(9686003)(6512007)(66946007)(6486002)(83380400001)(6666004)(66556008)(38100700002)(41300700001)(186003)(316002)(66476007)(478600001)(44832011)(2906002)(33716001)(86362001)(6916009)(4326008)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aJfdWOu2ANo/XnOCoynep5lWwWm/k9y2aeJRAgd/emOS7vsJr31TqEgrg1T8?=
 =?us-ascii?Q?pvdQajya3zomEbKrsfezd0wwQsK6DjvHjT+HV52cmj5UNTmqgIM64b26iron?=
 =?us-ascii?Q?kWYcURTHE/+BK/h8jwnL4A+bsZfxKU2qZsMyNaDi7rYoq4HbQTzqZ6kAF/eE?=
 =?us-ascii?Q?2mk162hcJcspIpLwXoD08IF20R381jfronvqba/NBwB2OvPuBYY8ZqSLrpLX?=
 =?us-ascii?Q?gDOCu35zI7QX+78SqUXKbvJAaCvJa0LFjScMGPLA9sPClJ7huhLDBPhEqOeb?=
 =?us-ascii?Q?k3kFUWakSg9FFerqHyttEYGUZqEfXSNmWu0wzw5/mEmx6v7STDFGUSx4BsXG?=
 =?us-ascii?Q?kcMZm0+GgD7BlVSKLlON8XGyGFvrQdmbKJVe+zLsyvWOpQgi14QZYfIwDMWV?=
 =?us-ascii?Q?3S6oD8Yqmvrmrr4BNaWOjj1GDRtxT2ogcF5u3e3XzYC/1cLKhzbdJf7GfUBL?=
 =?us-ascii?Q?nf+8U7jiJ4eVoxMRuc2clOfz0Do2jtUXq9S1GsV7KewZ1iG+NTD6TuippNYx?=
 =?us-ascii?Q?kKM4SNGJNZu7wklbX2irStLMgK6AhTQeTkEWwTU3iEOpmEFdIMECQ5SwR/yR?=
 =?us-ascii?Q?R8PKY+QTyNKRSvSXBfDUMnymIyh8RgLLoVacKXC5ypHRqqvTDvekyQ9Wcise?=
 =?us-ascii?Q?CM2zKCKx9Bvb0D1498HugYcEzDqUqu79e/FTdo4VM6GWjtO+Z/W55hnY7k1x?=
 =?us-ascii?Q?sJGFbXd2QZ21ukxKIF3Czt8cK0PK4f2WsCTI7RlFGn9YFHWZqKlgpCVlpJes?=
 =?us-ascii?Q?J30lx4aHl9XsYxAU2K/86B9dhg+Wvmy5O9SYEQfPTogS++3GJU8JvJX27i+k?=
 =?us-ascii?Q?egKGYhU02qDQkvULUW2f3TjpkgIpDmPpmXcT2S9bUHekE6Ly7m3EqOqtrAAl?=
 =?us-ascii?Q?mOiCpN9IVZsgrka8ESRCVPqZdxWC9HXDDZPEvnRk2zQonGrUG26ylqkxbvw9?=
 =?us-ascii?Q?0Z6W3wldlXs1Lu7zyCdM8FL8cWU5HrqCzUYJZg87tMXP6DXr6De006hTVGb5?=
 =?us-ascii?Q?55yMxZaQio6FmQgT5nxojkY1KB5tSySn/U/VMC649Qg2JsqCKVaMusbCJkHN?=
 =?us-ascii?Q?f8H0qK+SKfag6YlwxnYYIPmX7lUsUm2hwXjYOcvd2Iy3MY+oBS5gzDFecxFf?=
 =?us-ascii?Q?n6HlIEQOf5HEWVZTi54Fw32ZbAOBT9Q/7eVKPHadh97CqMLcqc5pVVQjjrKn?=
 =?us-ascii?Q?LHjRaRidW7HtJ+7MKpOygZcuYvyHkAWHfMiGqEG6A9zooxjjyF0sbipwnmhE?=
 =?us-ascii?Q?dhZS3bqHqiZ16RdGWEWckaE243iE7h/Qru2PhWlmtgFxAVN5HGyHoFbgh5YN?=
 =?us-ascii?Q?NjBbxFivEF/ZpmqSm6LLZFu7pA4h8AL3QaqEcHnyzCF5ycEVwPUQmhuYM6Cx?=
 =?us-ascii?Q?84268+Bb3D13NoeoQ+AmmqA29+njATGGDwk1FzszxZfNJ6YCkDycQpXQWMOz?=
 =?us-ascii?Q?LTeRRkYUz0/vt83lscye9V39kX8jdyDuJ3OjhRzKl7egStIagLyKaG1a1oBB?=
 =?us-ascii?Q?Em9UqpUnPnyiAmxBgsNAF8HlMbp+kdKx6m6jr5omtPHGI03JLeCcv63y6ecm?=
 =?us-ascii?Q?ypCEvtMnW1O4i8jW/Y6llC1jU+EE4fWbGMeAkA9OvxL+jpht1ibx/EjdgjAj?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a8a8eb4-f04b-4b93-8f6f-08db35d1b10b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 12:31:33.9097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hL7axoDjigdv6GO2TYgtJkHDrfNC1MfIh6jNf+8HOIqcKtgvue5fXIW5XvI07gBLyeY6a2xuoiVdMdWB+Rr72w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8074
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 12:31:44AM -0600, Maxim Georgiev wrote:
> Current NIC driver API demands drivers supporting hardware timestamping
> to implement handling logic for SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
> Handling these IOCTLs requires dirivers to implement request parameter
> structure translation between user and kernel address spaces, handling
> possible translation failures, etc. This translation code is pretty much
> identical across most of the NIC drivers that support SIOCGHWTSTAMP/
> SIOCSHWTSTAMP.
> This patch extends NDO functiuon set with ndo_hwtstamp_get/set
> functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
> to ndo_hwtstamp_get/set function calls including parameter structure
> translation and translation error handling.
> 
> This patch is sent out as RFC.
> It still pending on basic testing.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> ---
> Changes in v3:
> - Moved individual driver conversions to separate patches
> 
> Changes in v2:
> - Introduced kernel_hwtstamp_config structure
> - Added netlink_ext_ack* and kernel_hwtstamp_config* as NDO hw timestamp
>   function parameters
> - Reodered function variable declarations in dev_hwtstamp()
> - Refactored error handling logic in dev_hwtstamp()
> - Split dev_hwtstamp() into GET and SET versions
> - Changed net_hwtstamp_validate() to accept struct hwtstamp_config *
>   as a parameter
> ---
>  include/linux/net_tstamp.h |  8 ++++++++
>  include/linux/netdevice.h  | 16 ++++++++++++++++
>  net/core/dev_ioctl.c       | 36 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/net_tstamp.h b/include/linux/net_tstamp.h
> index fd67f3cc0c4b..063260475e77 100644
> --- a/include/linux/net_tstamp.h
> +++ b/include/linux/net_tstamp.h
> @@ -30,4 +30,12 @@ static inline void hwtstamp_config_to_kernel(struct kernel_hwtstamp_config *kern
>  	kernel_cfg->rx_filter = cfg->rx_filter;
>  }
>  
> +static inline void hwtstamp_kernel_to_config(struct hwtstamp_config *cfg,
> +					     const struct kernel_hwtstamp_config *kernel_cfg)

The reason why I suggested the name "hwtstamp_config_from_kernel()" was
to not break apart "hwtstamp" and "config", which together form the name
of one structure (hwtstamp_config).

> +{
> +	cfg->flags = kernel_cfg->flags;
> +	cfg->tx_type = kernel_cfg->tx_type;
> +	cfg->rx_filter = kernel_cfg->rx_filter;
> +}
> +
>  #endif /* _LINUX_NET_TIMESTAMPING_H_ */
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index a740be3bb911..8356002d0ac0 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -57,6 +57,7 @@
>  struct netpoll_info;
>  struct device;
>  struct ethtool_ops;
> +struct kernel_hwtstamp_config;
>  struct phy_device;
>  struct dsa_port;
>  struct ip_tunnel_parm;
> @@ -1412,6 +1413,15 @@ struct netdev_net_notifier {
>   *	Get hardware timestamp based on normal/adjustable time or free running
>   *	cycle counter. This function is required if physical clock supports a
>   *	free running cycle counter.
> + *	int (*ndo_hwtstamp_get)(struct net_device *dev,
> + *				struct kernel_hwtstamp_config *kernel_config,
> + *				struct netlink_ext_ack *extack);
> + *	Get hardware timestamping parameters currently configured for NIC
> + *	device.
> + *	int (*ndo_hwtstamp_set)(struct net_device *dev,
> + *				struct kernel_hwtstamp_config *kernel_config,
> + *				struct netlink_ext_ack *extack);
> + *	Set hardware timestamping parameters for NIC device.
>   */
>  struct net_device_ops {
>  	int			(*ndo_init)(struct net_device *dev);
> @@ -1646,6 +1656,12 @@ struct net_device_ops {
>  	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
>  						  const struct skb_shared_hwtstamps *hwtstamps,
>  						  bool cycles);
> +	int			(*ndo_hwtstamp_get)(struct net_device *dev,
> +						    struct kernel_hwtstamp_config *kernel_config,
> +						    struct netlink_ext_ack *extack);
> +	int			(*ndo_hwtstamp_set)(struct net_device *dev,
> +						    struct kernel_hwtstamp_config *kernel_config,
> +						    struct netlink_ext_ack *extack);
>  };
>  
>  struct xdp_metadata_ops {
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 6d772837eb3f..736f310a0661 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -254,11 +254,30 @@ static int dev_eth_ioctl(struct net_device *dev,
>  
>  static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
>  {
> -	return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct kernel_hwtstamp_config kernel_cfg;

Should we zero-initialize kernel_cfg (" = {}"), in case the driver does
not bother to populate, say, "flags"?

> +	struct hwtstamp_config config;
> +	int err;
> +
> +	if (!ops->ndo_hwtstamp_get)
> +		return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	err = ops->ndo_hwtstamp_get(dev, &kernel_cfg, NULL);
> +	if (err)
> +		return err;
> +
> +	hwtstamp_kernel_to_config(&config, &kernel_cfg);
> +	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> +		return -EFAULT;
> +	return 0;
>  }
>  
>  static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
>  {
> +	const struct net_device_ops *ops = dev->netdev_ops;
>  	struct netdev_notifier_hwtstamp_info info = {
>  		.info.dev = dev,
>  	};
> @@ -288,7 +307,20 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
>  		return err;
>  	}
>  
> -	return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
> +	if (!ops->ndo_hwtstamp_set)
> +		return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	err = ops->ndo_hwtstamp_set(dev, &kernel_cfg, NULL);
> +	if (err)
> +		return err;
> +
> +	hwtstamp_kernel_to_config(&cfg, &kernel_cfg);

Cosmetic blank line here

> +	if (copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)))
> +		return -EFAULT;

and here?

(and in equivalent positions in dev_get_hwtstamp())

> +	return 0;
>  }
>  
>  static int dev_siocbond(struct net_device *dev,
> -- 
> 2.39.2
>
