Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894D96E0295
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 01:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjDLXdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 19:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDLXdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 19:33:12 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC9B3AA6;
        Wed, 12 Apr 2023 16:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681342388; x=1712878388;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T2lwxOWVe7EscoTytAwGmHqhYpT+mBmLuq6ZH8W/ovI=;
  b=IoEdspELOORArsRxiGhQ/UGCQAhVMf9p8ZykYnt4Wp3G0hRXq21hNdCG
   skLIDuWErDGeGIrdz2kc1FgPk+uS8EvXHlM2SPVPWmE6O34s7wvLTgeGW
   iyJ0xXLtmeTdceYLpRuIB/T5GTJeK+2zWEWrL2yi8ufxc7e0kYvrQNGhy
   71tldm+XlG2/hEEQiKi0hgDkmfQ608CGP6QP4hiPIU2Ct+kEeIdjuM77b
   rdo7JQoRdngT8x4Up3py+wJ3OWuRdAwbe+0MgCZ1/e8I77kCyKDmxK9j9
   kwKDNhjmhvtiSeEpjdOc7mXQSnsdkX/IeqdLNHrg7PI9McCJP4icLOiGA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="344046569"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="344046569"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 16:33:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="1018919645"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="1018919645"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 12 Apr 2023 16:33:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:33:03 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:33:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 16:33:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 16:33:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+fyVK9IMP8UJoBkScuxxJOdqUaE7TOL7s/1nEpYTdLpsrfDFlj/kzMrrzcdSEFUmXeo+IKfSq9IYMnZg6kM/ttenbKIRGpI4KeIpHZN35dayMpOrpk6LWkZCTPdaGAroc6PfD+8tap47DGBykrVQmRfMJyU2WJmMFvi9vHMDjWelIukzN/SgpV6LrjsNE6iYs1z6xdvCK0+B8NLcI4EFgH9mpCXYlESvemNHpqAQkPVSHfTe6g0GBVhD3bPaJHF1jpt6xMqqN/sGpy9Jy2GpEzfnwlncJZztFB4p1sKPfib0Wb+Tw6PTgwbLejFJkzo8KUXcxH3DNpEVTi75WiufA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMcuqRpGIrayXgWlYMIaB9alNhXGJgTPc5zEgIxDpwc=;
 b=DdXngKK3mNS0sepIlAzhTpdnkMs1xTsJqYBJ5+9prqJL/wErjU1i7AXqxVI9WKvs6NOq5AepVE2pSZ/JeL+z3K6nGuE0Tzh3XbIsG/BbStyXdOOdVI+fI0ZtcAgYvkCCkoWalDYqYh4E3Vnv3ie4XjrZFllsd9k+4DASry7rfTOvvYVL1dbnahvgvJiMR4fJUzsR5uNQzMDwkuPU4LgaxUX9dZrhY6r1oTAvsdJ+zVe9wJABda+Oa0kLgWOwQAp+MjjQk99KzXPOjAxupheiqR7ud/CYYfopjhAsoi0cQjp0Xe1y1Rl8V4kb+gkNdrZ1+ncbBJN1DUOi5n17hkx1nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ2PR11MB7670.namprd11.prod.outlook.com (2603:10b6:a03:4c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 23:33:01 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 23:33:00 +0000
Message-ID: <0166d13c-dc55-c376-28ca-dae0a872b518@intel.com>
Date:   Wed, 12 Apr 2023 16:33:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v2] net/mlx5: stop waiting for PCI link if reset
 is required
Content-Language: en-US
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Gerd Bayer <gbayer@linux.ibm.com>,
        Alexander Schmidt <alexs@linux.ibm.com>,
        Leon Romanovsky <leonro@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230411105103.2835394-1-schnelle@linux.ibm.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230411105103.2835394-1-schnelle@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2PR07CA0008.namprd07.prod.outlook.com
 (2603:10b6:a03:505::8) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ2PR11MB7670:EE_
X-MS-Office365-Filtering-Correlation-Id: 47b6dd38-b263-490b-ac79-08db3bae40cb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cAXd2cp4pOR/rc27uWD6fdKEZCaSuCr0K0icDIOSXSYX/HWzi0utHbz5RF5G4BOivJB76lki22twM3OfnLDHPaIw2w+gQ6P39BgZnsm9wvWxMca76kBQQRKQtNMAbL8V98R3gJKtGOc0ud74S3/RlejvIzcSZ6xlJeJAVkOH4TY3HpLOIfrrB0cxRSFlKtsDjJi0kVUcdoDdmP4JGbx1ohR69UOBAzPtmXGG2UZlI92IX+mbxqzYmlOg05ABjq1Bc5uTqgJo9UlavNOTOnsaY7Jxcdyti9LA6LYm3wAPo8iF7cti7EDNzqq9pzZkkTL+SOQ/sUOxb3u4nKw81ZWiUOUzyxTxxKeQk5mieOtZ7sVFbdiKKZgW8U0rLdiqGOao0VB8sa+GhXJrli6fVmi+Jt8t4DuGKEuWJcq/oINEJPzt6vBV87EQ6Kwwob9CUQugvMYE5ZF87LkNvbqG98Jml44fUrjsO6WLTgB+uJjLITvZApRgLp92336fJd4bSgsOykdP3fq6wDPm7q0ItNl7if/XB2qCy1h+8embTmwmC2XsfCSTSa8TPRqk+rByG+O/GcHAKSojhMnBPidTaJAN0BbTN8ie/1MVjwSKpPztjk7F+TNWuct9Tli+Tpbe1yE8ozOhaEunz2zJ6T7EQ8U2IA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199021)(31686004)(316002)(4326008)(6486002)(66556008)(66946007)(66476007)(966005)(8676002)(478600001)(41300700001)(83380400001)(110136005)(54906003)(36756003)(31696002)(86362001)(2616005)(6506007)(26005)(6512007)(53546011)(8936002)(5660300002)(82960400001)(2906002)(186003)(38100700002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVN5NHMrNkYzZFRTaHdoeHRFdVlJLzh1ZTUwM1lCbHJjL0I3TkRuT0phWVpx?=
 =?utf-8?B?cDJQT1paU2dFeG1FWWs5VS9kMnh3Y1RiaFN0cnVwOUZsem5IME5HcTdFbDNV?=
 =?utf-8?B?Mlc0YzNPN0p2dHZkZG9Qb0FaRlFZaFdJdFo0NHR1Z0dIdkU5U3ZBQzhEVnR5?=
 =?utf-8?B?cnBpZW4wUXFZamVUL2UvSXZVc2VId3ozNnpXZmVTWnczdkFyTUdwRW04U0Vm?=
 =?utf-8?B?cDJGaStuK3NMdkxDd3UrdWJubG5wVUE0dS8vdTQvZWFlelRVSDlZdlprRkls?=
 =?utf-8?B?bjNIZ3RpVzRTalUzamdkN2JCdm80UXBVRm5jalFDY1VIZStLY29icktKdW82?=
 =?utf-8?B?d0oxN3FoZFFCell5UmxJc04rNXQ2VjBGRFRXTHQ3dTd0NGYwK3pnTzNsalRz?=
 =?utf-8?B?cE5Ua1FvY1ZyYmxVNzFicHo4WEFzSjdXOEx5bW1IazdYSElWVnQrUFkwcDZW?=
 =?utf-8?B?TGZIcVZMYzVZZk5KNnBIS2gwWURBaTZrOTEyK1dWVzlMQzRYN3FrV3o1SkJS?=
 =?utf-8?B?L1hGdzNJbDJPcGxHT3N2WUlSREVDUDNmY3MyeUxNMERnUzJnU2RwdjhpYTI2?=
 =?utf-8?B?Z2dhZVl3VTg4bVY1ZTVibHNlSnJoT21WVzNEblh6cjFkRmZjSXhheWcvMnFx?=
 =?utf-8?B?bFovdXhmMVNjNUx4WnVJZ0hkYStZV1RoU1dzYmNQa3k5NityczBKMDBER1Fa?=
 =?utf-8?B?NVc5L0g4aFpid1pqZGVEYWkyR1FTWXJuZnhWb1JDRzY0NUExN3ZWRmUzb1pP?=
 =?utf-8?B?QmNzeFNZZFE1dTZQSnR0bzJHc0lvSDdld0RuYWVNZjNMeHlUTUNWYSs3bjFT?=
 =?utf-8?B?dTNCK01DemdjTGVhUjJjWHZTRlVmZzhtWVFoS1lVcHlEOHZ4dW5zUk9DcGVr?=
 =?utf-8?B?dnFZVjVvVExHYktQdEkyTThhdVlSRFp1clN6RUY3QUdmc3NUUHJNNnF1Wloy?=
 =?utf-8?B?M0tENXZXV29HOGEvQjRkdDB5MElYVkpXSXlQeXAxbWtxbld4azVqNGNsQU9x?=
 =?utf-8?B?em83SUNYR0Jya0tlL2ZSYnF4NzFqenM5dEJwdndQaG0wdFkyMnUxTVJZZ05k?=
 =?utf-8?B?ZmpkRHlxRGNOU3AyenU1ajE4YWU1cWtEaGZ2NXNCU1hRQ3F6WS9FazdVMVVG?=
 =?utf-8?B?YTRtTk8ySUh4K2dpYnc5NE9kWFVKYk9RWWlSUFBLejd6MHY1cXBESlcrNGxP?=
 =?utf-8?B?anJ1a1U4aldoemtHRTg2SnZGTlR5ZTViQmxsN24wbUxneTJWcVVOc0JFQUZ5?=
 =?utf-8?B?NDhEQkpWSDlDVkZMRVp2SlErRVVqU01LU2VlTm43ZEJaMzNubGs0VnVmTFd0?=
 =?utf-8?B?RFF5Z0lWNTA0ZlRZdjkzWmN5bkJIRXowY0dDYUxodldlWnpIQWM4UlRRc0FV?=
 =?utf-8?B?ejN1aEpDOFREUkZiekQxdzl0T09GRE80VE1nc3I4RlpoQjNiT0JWQzl1bXlD?=
 =?utf-8?B?b1BvN2lrb0VKbTR5aVZSVWpzdkErVjBqNHVSMHI5SmRIcEM4TGRNcXhRQVZ0?=
 =?utf-8?B?MjdaMmtkMmp5NFhwRlUzVU9OaVlJN3hETncyM2tXZHZEVGxhYmxseEZkQUdB?=
 =?utf-8?B?SkVJRmtMK2J4VlA3OVZTMnI5RVFKTE1RU2hleHE0MXl6ZlFZSXJZbTlOMUZM?=
 =?utf-8?B?d3BvQ1lSdk1zQ2NnMlowQWJaVFZYZlVqSkhSd3A3V3lHU0FxSTNsaXB4S2RX?=
 =?utf-8?B?Uk1aUzk0ajc0TnBSTENubkh0ZURKNjVHanArWmp0M3RWNzNEVTNyZjlDMnM1?=
 =?utf-8?B?eU5WOE9HL3ZRenZoeVU1NnYrY3VtWDlLam9LRVZ2VlZJMVpzOWMzeTJNUUtM?=
 =?utf-8?B?czRjcjN4dy9mazkxcXJ0b0hHcWdyNU5NVFNDd243NEtnWTY3M3B6ZkxMemxM?=
 =?utf-8?B?WnBsWHVnclZleUFxem5tbkZDZ3hRdExpUHAxVjlvM0RadmIvc1RWOXY2QW90?=
 =?utf-8?B?dTZEbkY1SmJxeGtiakI5OXlCbTBWcUg5ZU01cHluejg1eTUrcHFBOE9CbnNm?=
 =?utf-8?B?T0JZLytCMklZaVlQSHVwMHlmMFpwZVNMM1J1QVBYU3p5OGZzZUIzZWNNSzVI?=
 =?utf-8?B?OTBPZHphNGpEeE1GMjZQaDYxQnBMZEtHcEcwS0FtNlo5TVF6RjF4d0I5NS9M?=
 =?utf-8?B?d29uMFFqRmdzWW5JU1NKZ2hrN0JaZFRhMkVlLzZoWnVDSm41NzU2UnIrWEpv?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b6dd38-b263-490b-ac79-08db3bae40cb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 23:33:00.2629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xgqky70DVfCDdrclfX6T6kzWvFIpDu3FMVTQsSX6TlMQJSpDscP5JAyT42buaGgt2I56rruZ4Ulv6RR67mYrf64hvw5ioAu7rvbtYDgj9Rw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7670
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2023 3:51 AM, Niklas Schnelle wrote:
> After an error on the PCI link, the driver does not need to wait
> for the link to become functional again as a reset is required. Stop
> the wait loop in this case to accelerate the recovery flow.
> 

Ok, so if the PCI link is completely offline (pci_channel_offline) then
we just bail out immediately and fail to recover, reporting to the user
as-such. Then a system administrator can setup in and perform the
appropriate reset? Rather than not reporting until the timeout
completes. Essentially, we know that this will never recover at this
point so stop wasting time.

Makes sense.

> Co-developed-by: Alexander Schmidt <alexs@linux.ibm.com>
> Signed-off-by: Alexander Schmidt <alexs@linux.ibm.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Link: https://lore.kernel.org/r/20230403075657.168294-1-schnelle@linux.ibm.com
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> index f9438d4e43ca..81ca44e0705a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> @@ -325,6 +325,8 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
>  	while (sensor_pci_not_working(dev)) {
>  		if (time_after(jiffies, end))
>  			return -ETIMEDOUT;
> +		if (pci_channel_offline(dev->pdev))
> +			return -EIO;
>  		msleep(100);
>  	}
>  	return 0;
> @@ -332,10 +334,16 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
>  
>  static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
>  {
> +	int rc;
> +
>  	mlx5_core_warn(dev, "handling bad device here\n");
>  	mlx5_handle_bad_state(dev);
> -	if (mlx5_health_wait_pci_up(dev)) {
> -		mlx5_core_err(dev, "health recovery flow aborted, PCI reads still not working\n");
> +	rc = mlx5_health_wait_pci_up(dev);
> +	if (rc) {
> +		if (rc == -ETIMEDOUT)
> +			mlx5_core_err(dev, "health recovery flow aborted, PCI reads still not working\n");
> +		else
> +			mlx5_core_err(dev, "health recovery flow aborted, PCI channel offline\n");
>  		return -EIO;
>  	}
>  	mlx5_core_err(dev, "starting health recovery flow\n");
> 
> base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
