Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7DE6D445E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjDCM1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjDCM1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:27:11 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2044.outbound.protection.outlook.com [40.107.104.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612FD11E8A
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:26:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRsrtLWSJnI9nBSb8DLyx9OmPqKy23uHpoacLUagprGODbbkwVn82aujeernUb2mIg/kXEk/LPtPOy6KtKfGV3PV1PEmtpVXkcTeXxpT35MC/X10FXVVhI5Bhfy5cWSEoIYJB40ChGTsdVn6jVEDXpHMN73fHE4L0x/I3dRqApEouK6WItk/SlnA89EL5UhQtgIHcVnV/OWwi03wbnlmRaAStG2qT+Z28djZUCNiHLhxedjOGK4jP0oPRQRf6BwkRpbEwlgqamcvba24g/ufxOwyxkxnFZ+tnYYnd2JRP4m3q6siVO3YWtxrDR2LtEM8tz88aRxZR0PjEWZgM57Anw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=za/KGjPfFQ49iYZZXnlo5JWrY14gcwni6v8/0xRd1rw=;
 b=FWszzI8LwI7CQt4yw8+gkYsvwLzkdwv2Yc05psBtk3hywYzo+aOICDSz82UJpBN1o7VVnnk/u/bUoB6Uk7MpqvF4nee4bPoq84LXHJET0cQ3slrrZwXgqFs+Az49ur8jjt+bxg/52ww8Q88JUKN19X0GiXnsAkF+KIqqyw2Ym97kzmkLcaRDzdLvpPN+4vpfCOcBJfBIx8ms8PjmMVjo7wbTWjpTCAgj5UkhiAdNw4NigDiKC1m8CRHkrxTocdFw8U7TcXwApHDjIFKLBzMBS+CwzavQ2Zl0tLuBlPV5bZUTdijwmA4Y7pxtAxRLiwEsB2KonTNPRDVmkHSXGovFHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=za/KGjPfFQ49iYZZXnlo5JWrY14gcwni6v8/0xRd1rw=;
 b=bFn8E4zsXhkqsBcH9lT4tArSDDNR63DTwODjDH8tpar2MzipgNtu0Wg3njAvlS1ekR7cpQtYCE9eR75ZJYdjVcnUjj1a3M2kVU/74D3xYxNW3x0Ry/qEx0/9+Gs2H0YoSFyFFWUAI1l8rN8JOw03L2NinuFGB6CgwEejBb9cUkg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB10035.eurprd04.prod.outlook.com (2603:10a6:10:4ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Mon, 3 Apr
 2023 12:26:26 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 12:26:26 +0000
Date:   Mon, 3 Apr 2023 15:26:22 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC v2] Add NDOs for hardware timestamp get/set
Message-ID: <20230403122622.ixpiy2o7irxb3xpp@skbuf>
References: <20230402142435.47105-1-glipus@gmail.com>
 <20230402142435.47105-1-glipus@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230402142435.47105-1-glipus@gmail.com>
 <20230402142435.47105-1-glipus@gmail.com>
X-ClientProxiedBy: FR0P281CA0155.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB10035:EE_
X-MS-Office365-Filtering-Correlation-Id: c9ca8a2b-1d7b-4a9c-c028-08db343ea4ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n2YBuLLjecuEIyt5UN+UKO7PqLE98CQOQwqw7bVrylX/D55dzmlbMqdSWbVp1E7HXMG8OXT/N73lMXCuTf14uRGl5NEh6yHvPQenAQTs96MexPfmOtmGA3oOH2A4dRDP7Eveuheb5qIgTVEsuWlW7wy6wxgMhlHWmm5IGmtJF9T94KiG1OoacnmJoDBO/58EEQ2QtCVjILlP6VcS4sgVFPCG4O3M1FMd0lkbS1fC5wdOlsNvVEXZF+kf0Su+Xz5L5eM5QwT+TSMPG9jesX2McNAAcaXaXBu8cqF2mW7ofkvyX64oM1sSVEPoGTtL6VtdOqusuJK+ieL6epx/yZoLZvskPto0CI/Pr6TxlZ2oNZYi6HdvtEe83UU+obraCD9OUWTwHzXF0Olg83ExgJrPAkcCXCZEhuOTpYbtJP+uZPjv7XHl3MsW9wmn8FReszURJzgjXnG0SZp8eLnyFpaSSoIT7e6IXaNXXVFTgx2Bw79a3VEPor1YCd++42sgWmHA8/W5f8IWWqJLXpXFD8SecCVib8jtrpl8UTF86HvYwOXfHY662t5wcp23oEI0LU28u9ydoJ3btO324sVv6PS+Am/sPQU3ylU+AAhd6Yq15/GD94QbWCkmUkbTQKg89HlA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199021)(6666004)(6486002)(2906002)(26005)(1076003)(186003)(44832011)(6512007)(6506007)(8676002)(8936002)(5660300002)(83380400001)(33716001)(9686003)(41300700001)(30864003)(38100700002)(86362001)(316002)(478600001)(6916009)(66556008)(4326008)(66476007)(66946007)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kiQ752sijUiXa7IBCvUFgkhvf0xa1C49wftgaSZovLt/gzB93tS/nM1dK+VS?=
 =?us-ascii?Q?8QDHhtB1nKxfrOC9Rlb33nd85IGjVJDJ8RpSX9QZw70AZ4+RxJFW7QeaoeRl?=
 =?us-ascii?Q?r4qAjbT/XUtl1SylJqQZ2xCWl73PqPzNTqNkf2Z9iDO6sBvvdxpweM70FEIM?=
 =?us-ascii?Q?XUki/glxx2g0ITAzaLrrRq/p9zpTu7dgRsyzw3CrEa9Frb0u3CmQ/rR3Bjmy?=
 =?us-ascii?Q?TznrtpN2i6A898FEIViJkCkXP4B0cyH0kks/xslIBR0XILmIZivOv5cIByUw?=
 =?us-ascii?Q?3Y2uOKbZQoU+EH1rn94OmOoUSPukbdwBwRdbXMVQ98w2roMHvtA6306mUTiV?=
 =?us-ascii?Q?8q6OYNXjuuOVUi5g5s1SNnPfnIxqrBHYzCSMIoMhzOGMl8f7mee4X4J69MAD?=
 =?us-ascii?Q?82sCZMZr8fEXadlUbkAX+uFVjgzzP6VPDnohOLauvj95kJhNdHyBfRXFBRtL?=
 =?us-ascii?Q?P9SuvTodc/OGl+whF0CQw1xU/EkAzEha1/sG2m8AcHcjplrdMcL84HCg2jZ9?=
 =?us-ascii?Q?44ggUFE90XoE39ZUR96kHUGKaTc5ftxBJZ/5Eqh9ekXbh/Fi4UdECbNOaZqq?=
 =?us-ascii?Q?Vk2QenDiwQ1aGSM30xoaGZ6WDpVauwTQdCI3psZAIAAlrc5iv0y31hZ6gtiz?=
 =?us-ascii?Q?V2ntjrOpA5LuJW6yZ9WFYXY5zCk6uENjWXP/S9dTckuZkJkM7XNXeG4PVt2q?=
 =?us-ascii?Q?VI6EtpvzdM6sgETE+HD1Zss864U731h7RcYmmAGgooXrOHyqtUTKEs4rFJNm?=
 =?us-ascii?Q?YuksCQIvi3ctu8iWnutkMeS6eMsb6V5eJwnH1KIRQDsF2fMBz38+Qo+unNmw?=
 =?us-ascii?Q?AOdfacKOtkXlu6Gql9LLYxcrFaBZttLJZKrkqyexPikKsbWXe6cvBtq6hu8F?=
 =?us-ascii?Q?AWg3tKll11CjoHu5L8x7IoC7xtPDAAEAzs76wxc95mF0ZABGCFRJRvMdqCBm?=
 =?us-ascii?Q?uwjUNwdozILOn0BeqpDOkDMk66Ujp+fISLORo1Coj4qNhHJ7mhiHIiqRgdaC?=
 =?us-ascii?Q?hkGd0I8Yqr6RhRzzH3KH26l4bhTvbJxilJVBMym/RUHAigN/cCtzic/6EEdX?=
 =?us-ascii?Q?l3o0SPCNSen/KFoP+YDnoW9c9Fc6JG6N0TxgnI9TDlqFU9LZ236Z+Tihmlq2?=
 =?us-ascii?Q?VTB/nn074EUYyONqrDB9mh7iTosRPfIDdcTOFJU+PxxjKcYAMq51k7t0irU+?=
 =?us-ascii?Q?ATMQnxuMqYAJIAB2J7KKZf4J+LCtY1MhPP2QCIdlBeHqUjUsemifpK8SW58u?=
 =?us-ascii?Q?acIkfEtinq5/yXWfEt2Nb6yz3Kvt6T1dn9058paoZpExa+HqGC/MMsS9OvsM?=
 =?us-ascii?Q?dNOFrfi25jn1wvGE3W7LANVsmTG2VwDyYOuH6tDyI6c5Bz7+1zU61UR1x01w?=
 =?us-ascii?Q?VDJoMTNzt9YV7Lc+loE7JP+oTOQpYiJI0RLFFQgn50IKRNTQ4xgXke7Yn+hJ?=
 =?us-ascii?Q?VyvRf441dDPoInBRC6zOt3HIrtpoOy6W23in26/gsPrVBh6CwApafU15rZ94?=
 =?us-ascii?Q?MaUpVMcimcU/JK5c9sLhL6QnQcDioAwAJlkJer+qRXnuK6Q6o6W9WaLZWQtC?=
 =?us-ascii?Q?aN4SiSP4SfWKNSqf31Y+PKyxbTjq+PN1th+01i7Fao0cdOBJV8tLi7826Nw1?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ca8a2b-1d7b-4a9c-c028-08db343ea4ef
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 12:26:26.4722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xD0RPegw42KnbWcLa1UsVaykz2fBdfnOoakhYzjn8eLW9+8MKMuxH7risi8Z2Gy27/XLQCfTEmTv0msTvwVedA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB10035
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 08:24:35AM -0600, Maxim Georgiev wrote:
> Current NIC driver API demands drivers supporting hardware timestamping
> to support SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs. Handling these IOCTLs
> requires dirivers to implement request parameter structure translation
> between user and kernel address spaces, handling possible
> translation failures, etc. This translation code is pretty much
> identical across most of the NIC drivers that support SIOCGHWTSTAMP/
> SIOCSHWTSTAMP.
> This patch extends NDO functiuon set with ndo_hwtstamp_get/set
> functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
> to ndo_hwtstamp_get/set function calls including parameter structure
> translation and translation error handling.
> 
> This patch is sent out as RFC.
> It still pending on basic testing.

Who should do that testing? Do you have any NIC with the hardware
timestamping capability?

> Implementing ndo_hwtstamp_get/set in netdevsim driver should allow
> manual testing of the request translation logic. Also is there a way
> to automate this testing?

Automatic testing would require manual testing as a first step, to iron
out the procedure, right?

The netdevsim driver should be testable by anyone using 'echo "0 1" >
/sys/bus/netdevsim/new_device', and then 'hwstamp_ctl -i eni0np1 -t 1'
(or 'testptp', or 'ptp4l', or whatever). Have you tried doing at least
that, did it work?

> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> ---
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
>  drivers/net/ethernet/intel/e1000e/netdev.c | 39 ++++++-----
>  drivers/net/netdevsim/netdev.c             | 26 +++++++
>  drivers/net/netdevsim/netdevsim.h          |  1 +
>  include/linux/netdevice.h                  | 21 ++++++
>  include/uapi/linux/net_tstamp.h            | 15 ++++
>  net/core/dev_ioctl.c                       | 81 ++++++++++++++++++----
>  6 files changed, 149 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 6f5c16aebcbf..5b98f7257c77 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6161,7 +6161,9 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
>  /**
>   * e1000e_hwtstamp_set - control hardware time stamping
>   * @netdev: network interface device structure
> - * @ifr: interface request
> + * @config: hwtstamp_config structure containing request parameters
> + * @kernel_config: kernel version of config parameter structure.
> + * @extack: netlink request parameters.
>   *
>   * Outgoing time stamping can be enabled and disabled. Play nice and
>   * disable it when requested, although it shouldn't cause any overhead
> @@ -6174,20 +6176,19 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
>   * specified. Matching the kind of event packet is not supported, with the
>   * exception of "all V2 events regardless of level 2 or 4".
>   **/
> -static int e1000e_hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
> +static int e1000e_hwtstamp_set(struct net_device *netdev,
> +			       struct hwtstamp_config *config,
> +			       struct kernel_hwtstamp_config *kernel_config,
> +			       struct netlink_ext_ack *extack)
>  {
>  	struct e1000_adapter *adapter = netdev_priv(netdev);
> -	struct hwtstamp_config config;
>  	int ret_val;
>  
> -	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> -		return -EFAULT;
> -
> -	ret_val = e1000e_config_hwtstamp(adapter, &config);
> +	ret_val = e1000e_config_hwtstamp(adapter, config);
>  	if (ret_val)
>  		return ret_val;
>  
> -	switch (config.rx_filter) {
> +	switch (config->rx_filter) {
>  	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
>  	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
>  	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> @@ -6199,22 +6200,24 @@ static int e1000e_hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
>  		 * by hardware so notify the caller the requested packets plus
>  		 * some others are time stamped.
>  		 */
> -		config.rx_filter = HWTSTAMP_FILTER_SOME;
> +		config->rx_filter = HWTSTAMP_FILTER_SOME;
>  		break;
>  	default:
>  		break;
>  	}
> -
> -	return copy_to_user(ifr->ifr_data, &config,
> -			    sizeof(config)) ? -EFAULT : 0;
> +	return ret_val;
>  }
>  
> -static int e1000e_hwtstamp_get(struct net_device *netdev, struct ifreq *ifr)
> +static int e1000e_hwtstamp_get(struct net_device *netdev,
> +			       struct hwtstamp_config *config,
> +			       struct kernel_hwtstamp_config *kernel_config,
> +			       struct netlink_ext_ack *extack)
>  {
>  	struct e1000_adapter *adapter = netdev_priv(netdev);
>  
> -	return copy_to_user(ifr->ifr_data, &adapter->hwtstamp_config,
> -			    sizeof(adapter->hwtstamp_config)) ? -EFAULT : 0;
> +	memcpy(config, &adapter->hwtstamp_config,
> +	       sizeof(adapter->hwtstamp_config));
> +	return 0;
>  }
>  
>  static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
> @@ -6224,10 +6227,6 @@ static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
>  	case SIOCGMIIREG:
>  	case SIOCSMIIREG:
>  		return e1000_mii_ioctl(netdev, ifr, cmd);
> -	case SIOCSHWTSTAMP:
> -		return e1000e_hwtstamp_set(netdev, ifr);
> -	case SIOCGHWTSTAMP:
> -		return e1000e_hwtstamp_get(netdev, ifr);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -7365,6 +7364,8 @@ static const struct net_device_ops e1000e_netdev_ops = {
>  	.ndo_set_features = e1000_set_features,
>  	.ndo_fix_features = e1000_fix_features,
>  	.ndo_features_check	= passthru_features_check,
> +	.ndo_hwtstamp_get	= e1000e_hwtstamp_get,
> +	.ndo_hwtstamp_set	= e1000e_hwtstamp_set,
>  };

The conversion per se looks almost in line with what I was expecting to
see, except for the comments. I guess you can convert a single driver
first (e1000 seems fine), to get the API merged, then more people could
work in parallel?

Or do you want netdevsim to cover hardware timestamping from the
beginning too, Jakub?

>  
>  /**
> diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
> index 35fa1ca98671..502715c6e9e1 100644
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -238,6 +238,30 @@ nsim_set_features(struct net_device *dev, netdev_features_t features)
>  	return 0;
>  }
>  
> +static int
> +nsim_hwtstamp_get(struct net_device *dev,
> +		  struct hwtstamp_config *config,
> +		  struct kernel_hwtstamp_config *kernel_config,
> +		  struct netlink_ext_ack *extack)
> +{
> +	struct netdevsim *ns = netdev_priv(dev);
> +
> +	memcpy(config, &ns->hw_tstamp_config, sizeof(ns->hw_tstamp_config));
> +	return 0;
> +}
> +
> +static int
> +nsim_hwtstamp_ges(struct net_device *dev,
> +		  struct hwtstamp_config *config,
> +		  struct kernel_hwtstamp_config *kernel_config,
> +		  struct netlink_ext_ack *extack)
> +{
> +	struct netdevsim *ns = netdev_priv(dev);
> +
> +	memcpy(&ns->hw_tstamp_config, config, sizeof(ns->hw_tstamp_config));
> +	return 0;
> +}

Please keep conversion patches separate from patches which add new
functionality.

Also, does the netdevsim portion even do something useful? Wouldn't
you need to implement ethtool_ops :: get_ts_info() in order for user
space to know that there is a PHC, and that the device supports hardware
timestamping?

> +
>  static const struct net_device_ops nsim_netdev_ops = {
>  	.ndo_start_xmit		= nsim_start_xmit,
>  	.ndo_set_rx_mode	= nsim_set_rx_mode,
> @@ -256,6 +280,8 @@ static const struct net_device_ops nsim_netdev_ops = {
>  	.ndo_setup_tc		= nsim_setup_tc,
>  	.ndo_set_features	= nsim_set_features,
>  	.ndo_bpf		= nsim_bpf,
> +	.ndo_hwtstamp_get	= nsim_hwtstamp_get,
> +	.ndo_hwtstamp_set	= nsim_hwtstamp_get,
>  };
>  
>  static const struct net_device_ops nsim_vf_netdev_ops = {
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> index 7d8ed8d8df5c..c6efd2383552 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -102,6 +102,7 @@ struct netdevsim {
>  	} udp_ports;
>  
>  	struct nsim_ethtool ethtool;
> +	struct hwtstamp_config hw_tstamp_config;
>  };
>  
>  struct netdevsim *
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index c8c634091a65..078c9284930a 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -57,6 +57,8 @@
>  struct netpoll_info;
>  struct device;
>  struct ethtool_ops;
> +struct hwtstamp_config;
> +struct kernel_hwtstamp_config;
>  struct phy_device;
>  struct dsa_port;
>  struct ip_tunnel_parm;
> @@ -1411,6 +1413,17 @@ struct netdev_net_notifier {
>   *	Get hardware timestamp based on normal/adjustable time or free running
>   *	cycle counter. This function is required if physical clock supports a
>   *	free running cycle counter.
> + *	int (*ndo_hwtstamp_get)(struct net_device *dev,
> + *				struct hwtstamp_config *config,
> + *				struct kernel_hwtstamp_config *kernel_config,
> + *				struct netlink_ext_ack *extack);
> + *	Get hardware timestamping parameters currently configured  for NIC
> + *	device.
> + *	int (*ndo_hwtstamp_set)(struct net_device *dev,
> + *				struct hwtstamp_config *config,
> + *				struct kernel_hwtstamp_config *kernel_config,
> + *				struct netlink_ext_ack *extack);
> + *	Set hardware timestamping parameters for NIC device.

I would expect that in the next version, you only pass struct
kernel_hwtstamp_config * to these and not struct hwtstamp_config *,
since the former was merged in a form that contains all that struct
hwtstamp_config does, right?

>   */
>  struct net_device_ops {
>  	int			(*ndo_init)(struct net_device *dev);
> @@ -1645,6 +1658,14 @@ struct net_device_ops {
>  	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
>  						  const struct skb_shared_hwtstamps *hwtstamps,
>  						  bool cycles);
> +	int			(*ndo_hwtstamp_get)(struct net_device *dev,
> +						    struct hwtstamp_config *config,
> +						    struct kernel_hwtstamp_config *kernel_config,
> +						    struct netlink_ext_ack *extack);
> +	int			(*ndo_hwtstamp_set)(struct net_device *dev,
> +						    struct hwtstamp_config *config,
> +						    struct kernel_hwtstamp_config *kernel_config,
> +						    struct netlink_ext_ack *extack);
>  };
>  
>  struct xdp_metadata_ops {
> diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
> index a2c66b3d7f0f..547f73beb479 100644
> --- a/include/uapi/linux/net_tstamp.h
> +++ b/include/uapi/linux/net_tstamp.h
> @@ -79,6 +79,21 @@ struct hwtstamp_config {
>  	int rx_filter;
>  };
>  
> +/**
> + * struct kernel_hwtstamp_config - %SIOCGHWTSTAMP and %SIOCSHWTSTAMP parameter
> + *
> + * @dummy:	a placeholder field added to work around empty struct language
> + *		restriction
> + *
> + * This structure passed as a parameter to NDO methods called in
> + * response to SIOCGHWTSTAMP and SIOCSHWTSTAMP IOCTLs.
> + * The structure is effectively empty for now. Before adding new fields
> + * to the structure "dummy" placeholder field should be removed.
> + */
> +struct kernel_hwtstamp_config {
> +	u8 dummy;
> +};

In include/uapi? No-no. That's exported to user space, which contradicts
the whole point of having a structure visible just to the kernel.

See net-next commit c4bffeaa8d50 ("net: add struct kernel_hwtstamp_config
and make net_hwtstamp_validate() use it") by the way.

> +
>  /* possible values for hwtstamp_config->flags */
>  enum hwtstamp_flags {
>  	/*
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 846669426236..c145afb3f77e 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -183,22 +183,18 @@ static int dev_ifsioc_locked(struct net *net, struct ifreq *ifr, unsigned int cm
>  	return err;
>  }
>  
> -static int net_hwtstamp_validate(struct ifreq *ifr)
> +static int net_hwtstamp_validate(struct hwtstamp_config *cfg)
>  {
> -	struct hwtstamp_config cfg;
>  	enum hwtstamp_tx_types tx_type;
>  	enum hwtstamp_rx_filters rx_filter;
>  	int tx_type_valid = 0;
>  	int rx_filter_valid = 0;
>  
> -	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> -		return -EFAULT;
> -
> -	if (cfg.flags & ~HWTSTAMP_FLAG_MASK)
> +	if (cfg->flags & ~HWTSTAMP_FLAG_MASK)
>  		return -EINVAL;
>  
> -	tx_type = cfg.tx_type;
> -	rx_filter = cfg.rx_filter;
> +	tx_type = cfg->tx_type;
> +	rx_filter = cfg->rx_filter;
>  
>  	switch (tx_type) {
>  	case HWTSTAMP_TX_OFF:
> @@ -277,6 +273,63 @@ static int dev_siocbond(struct net_device *dev,
>  	return -EOPNOTSUPP;
>  }
>  
> +static int dev_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct hwtstamp_config config;
> +	int err;
> +
> +	err = dsa_ndo_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
> +	if (err == 0 || err != -EOPNOTSUPP)
> +		return err;
> +
> +	if (!ops->ndo_hwtstamp_get)
> +		return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	err = ops->ndo_hwtstamp_get(dev, &config, NULL, NULL);
> +	if (err)
> +		return err;
> +
> +	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int dev_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct hwtstamp_config config;
> +	int err;
> +
> +	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> +		return -EFAULT;
> +
> +	err = net_hwtstamp_validate(&config);
> +	if (err)
> +		return err;
> +
> +	err = dsa_ndo_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
> +	if (err == 0 || err != -EOPNOTSUPP)
> +		return err;
> +
> +	if (!ops->ndo_hwtstamp_set)
> +		return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	err = ops->ndo_hwtstamp_set(dev, &config, NULL, NULL);
> +	if (err)
> +		return err;

Here, when you rebase over commit 4ee58e1e5680 ("net: promote
SIOCSHWTSTAMP and SIOCGHWTSTAMP ioctls to dedicated handlers"),
I expect that you will add another helper function to include/linux/net_tstamp.h
called hwtstamp_config_from_kernel(), which translates back from the
struct kernel_hwtstamp_config into something on which copy_from_user()
can be called, correct?

> +
> +	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
>  static int dev_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
>  			      void __user *data, unsigned int cmd)
>  {
> @@ -391,11 +444,11 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
>  		rtnl_lock();
>  		return err;
>  
> +	case SIOCGHWTSTAMP:
> +		return dev_hwtstamp_get(dev, ifr);
> +
>  	case SIOCSHWTSTAMP:
> -		err = net_hwtstamp_validate(ifr);
> -		if (err)
> -			return err;
> -		fallthrough;
> +		return dev_hwtstamp_set(dev, ifr);
>  
>  	/*
>  	 *	Unknown or private ioctl
> @@ -407,9 +460,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
>  
>  		if (cmd == SIOCGMIIPHY ||
>  		    cmd == SIOCGMIIREG ||
> -		    cmd == SIOCSMIIREG ||
> -		    cmd == SIOCSHWTSTAMP ||
> -		    cmd == SIOCGHWTSTAMP) {
> +		    cmd == SIOCSMIIREG) {
>  			err = dev_eth_ioctl(dev, ifr, cmd);
>  		} else if (cmd == SIOCBONDENSLAVE ||
>  		    cmd == SIOCBONDRELEASE ||
> -- 
> 2.39.2
>
