Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A631A17A775
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgCEObG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:31:06 -0500
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:6148
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726142AbgCEObG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 09:31:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9ATG1OrgbomwpzGl2A0Kbg8VrqusslJc7CSytOcQXz99yScOf9kiLiKUfQMnL6BVgKp9xao9MyKyjK/D8jPhNXqzjUYsjtHsy8bWLu5jexRZQkp9L9d6DWEuF/bkqit/oLoI1AtkUFpe29YxRLUDQazb4NspO9JKd5w8wf0QUac0WoPTNdQmODiUQIKjUMc1/vPUtHmy9n1qqCMOoG813+kiBznbmeFUZY8CdcIpwGCduLZEE6bZOfNLnUbmSWe0XQkb/9lEiL1cM3TTXhEAjcdMEnDTz/PxHFj45bB0+cp9XJYhHoe6b3YRhDwICekiEbX5g161lQ6YaVq2s6JQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lkl/9EsA3+8t3MupyKwG6ePnk0tuPIgA0W8KnpS7Yc=;
 b=IZWYHx/FTcxz/J4auUrRG4d8EkRKwOS6cY2p/lyyilZALoFu29bCItIjEaskAntsBdetS9VQyEKyzIBT72OeutVhmmfupaGznZ6ELFSG8qEQOX0PiwAPVYzWtTA9tJ9vjI3N0PX7KgRsZh0Y0LGR4DuPMHnBaak5w00/mgoAemytAOlH6a0sG/CaGBx25Qx0HtJRq/EsV7/d3LWRlsbX+TKli0Zys5hA2NbGHJZWid1Gj9CGVitnbh/ULWu85j+VowJ1KT34m0NIBXgtVKFhR0hqPc4l8OwSI64rSc+NNjc0Wg/pkNl8KT1RCj7Pa8U9aZWIte1oPb1J47ZD4RRPTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lkl/9EsA3+8t3MupyKwG6ePnk0tuPIgA0W8KnpS7Yc=;
 b=TUVrNwdnkZx0tw6KSwBnIEMb1PW5nSGMcpBb2qcBpHGzrUiKhgx9CQB2fa4YHxK2KILaJ8BUNcHL0Qqvsqv1cd4JTcPeRLR15NBcRx3KJs9QPzEGVW2sAqL8JNgfq/tBJd21KWews/vXvTks/ZE2dOAHlGLn8M4//Q7kLAuFpPw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB3963.namprd12.prod.outlook.com (2603:10b6:5:1cd::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14; Thu, 5 Mar
 2020 14:30:27 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 14:30:27 +0000
Subject: Re: [PATCH net-next v3 02/12] xgbe: let core reject the unsupported
 coalescing parameters
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     andrew@lunn.ch, ecree@solarflare.com, mkubecek@suse.cz,
        benve@cisco.com, _govind@gmx.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org
References: <20200305051542.991898-1-kuba@kernel.org>
 <20200305051542.991898-3-kuba@kernel.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2ec3b324-bb64-50ed-8a3e-848d648fb35b@amd.com>
Date:   Thu, 5 Mar 2020 08:30:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200305051542.991898-3-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR11CA0016.namprd11.prod.outlook.com
 (2603:10b6:5:190::29) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM6PR11CA0016.namprd11.prod.outlook.com (2603:10b6:5:190::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Thu, 5 Mar 2020 14:30:25 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7c262376-add8-47ae-119a-08d7c111bf6d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3963:
X-Microsoft-Antispam-PRVS: <DM6PR12MB39633FD1F956488798145DD4ECE20@DM6PR12MB3963.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:538;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(189003)(199004)(6486002)(8936002)(81156014)(478600001)(81166006)(5660300002)(7416002)(36756003)(8676002)(4326008)(2906002)(86362001)(31696002)(316002)(66556008)(66476007)(16576012)(53546011)(2616005)(186003)(66946007)(16526019)(26005)(31686004)(956004)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3963;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M76q/EiGOfYrG+H33F3euQaV6hgPwxP+1iezBShrimSsJ97A+HTELQwio2ftr9IvqF53Dgw5otiOmCxmJL6Tp85E0ePt73xvPin80clXXqvuA1JQCGiJUhB2rKeWiOj4k/8qUtctnjH6HF3VQ8YAK8RJdBQfAOfhcTcTAPZXRdqtTai/oYglP6f2mj07plQmYF89qO3nTqX9pYAFGi2RCopiPu6mL1XIyBMtEpTotzxytegPPem8QMNQJlmhUaFN3tpbvSCFHrraVvbW9X453NiUJbH+fGCq8v01zboxM0XlWF6RR/s4geo4a47H6eMZetZqzC9XXqRhajaXMAOgxP80Rn3+NsN2RX8LJnAS/XbpAmDXpQ2gBGj3Md954ZHdUOCKNGRjKxGkha9ivLjHF8UpTF6qDehxlCBrRULuRjDSxZUvB2AEeXzkCmdYivSG
X-MS-Exchange-AntiSpam-MessageData: HlJVVrOvgnD3jCBRgdCjwtM0GLiSA74Bv4euDzWPWyzZBSTstr3BLHMKH7yRagJQ6v1KWTuJuzj5gkR58qpTAgvekJGwWpq6RxlCiuV1hJXQHU3U8sTOnU82WkaxnIE2CbY2KnobYyRwpEwctELUYw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c262376-add8-47ae-119a-08d7c111bf6d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 14:30:27.0373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5VSWJmLzgjqDwlTp1AMPI7G5/5HhNAjA0HRDJgYId8frAmSoINDNGJRLIzOUkMQCx0E+3/WDsMA4lQrPWu42g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3963
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/20 11:15 PM, Jakub Kicinski wrote:
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
> 
> This driver correctly rejects all unsupported parameters.
> We are only losing the error print.
> 
> v3: adjust commit message for new error code and member name
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c | 26 ++------------------
>  1 file changed, 2 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> index b23c8ee24ee3..61f39a0e04f9 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> @@ -450,30 +450,6 @@ static int xgbe_set_coalesce(struct net_device *netdev,
>  	unsigned int rx_frames, rx_riwt, rx_usecs;
>  	unsigned int tx_frames;
>  
> -	/* Check for not supported parameters  */
> -	if ((ec->rx_coalesce_usecs_irq) ||
> -	    (ec->rx_max_coalesced_frames_irq) ||
> -	    (ec->tx_coalesce_usecs) ||
> -	    (ec->tx_coalesce_usecs_irq) ||
> -	    (ec->tx_max_coalesced_frames_irq) ||
> -	    (ec->stats_block_coalesce_usecs) ||
> -	    (ec->use_adaptive_rx_coalesce) ||
> -	    (ec->use_adaptive_tx_coalesce) ||
> -	    (ec->pkt_rate_low) ||
> -	    (ec->rx_coalesce_usecs_low) ||
> -	    (ec->rx_max_coalesced_frames_low) ||
> -	    (ec->tx_coalesce_usecs_low) ||
> -	    (ec->tx_max_coalesced_frames_low) ||
> -	    (ec->pkt_rate_high) ||
> -	    (ec->rx_coalesce_usecs_high) ||
> -	    (ec->rx_max_coalesced_frames_high) ||
> -	    (ec->tx_coalesce_usecs_high) ||
> -	    (ec->tx_max_coalesced_frames_high) ||
> -	    (ec->rate_sample_interval)) {
> -		netdev_err(netdev, "unsupported coalescing parameter\n");
> -		return -EOPNOTSUPP;
> -	}
> -
>  	rx_riwt = hw_if->usec_to_riwt(pdata, ec->rx_coalesce_usecs);
>  	rx_usecs = ec->rx_coalesce_usecs;
>  	rx_frames = ec->rx_max_coalesced_frames;
> @@ -837,6 +813,8 @@ static int xgbe_set_channels(struct net_device *netdev,
>  }
>  
>  static const struct ethtool_ops xgbe_ethtool_ops = {
> +	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
> +				     ETHTOOL_COALESCE_MAX_FRAMES,
>  	.get_drvinfo = xgbe_get_drvinfo,
>  	.get_msglevel = xgbe_get_msglevel,
>  	.set_msglevel = xgbe_set_msglevel,
> 
