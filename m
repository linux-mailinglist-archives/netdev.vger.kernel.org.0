Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD7842ABAF
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhJLSP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:15:27 -0400
Received: from mail-sn1anam02on2069.outbound.protection.outlook.com ([40.107.96.69]:5710
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232809AbhJLSP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:15:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPqFZB6x1sUOL6mkEXT3GfLuIxiGr5iGKXUdg5aaN1jl26gsx39x5FvTtyeRCw+GO9KAeFd9ugCDpo3VU1YyuullKHQdNx1ile+Gw704NjoB3dIR3YWGrizDIV2YpjFHKJIwZid9yDxlNcmf9hD/FKt/c1uK7evHffq99P6qsuklqN4zO99Xo4YOa8ujdSy0wHxoWOswq3KxxD9tTuHnMZCuK3s3MbaMGxgXFKxVW3lnqW3no8IFcapR42a78WiwfVGGDNEGQ1LfHG0RasfheKHDAtHTauLKOg3zsbO6hQcRpz/30TenEuiWF1K9m9+S1UTvXUpfiPqAzr5Kvht/6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kokyyv1+NlFulxYXpEi1ZClIPjLf3jex7angIbKZyMU=;
 b=Wjg0g9Ka0hQPPXb6ONZqkaY4OmuT5XUC5ZdHWE9PtAqhJ1uMXfKwX0eKULkhoEjFHfIIFzw+DvNPHTZTwFX6BWrSqsdD6PGU3/cHyiWnFa17nj0422oprR2uIAStCS7Hx8uGs8DCaMmP/WevReUG7VJQutrQZ/xBBW44+3P6DGEJZN9SmQCiBMhd0n7JDF7+jq36nsLkJifoa/UDwP676+F20q4t1flq0b1TSKxTpxyygY0FjU9P8CUR3AHeJOgK4NbLYOj90X/Z95IigIKc4enQIR5EGcMDPIIsKW0wLsvn60z6aYunfWP0p2xKlgXuGnh0Ysc4r+Z+DKFhmF6Syg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kokyyv1+NlFulxYXpEi1ZClIPjLf3jex7angIbKZyMU=;
 b=UMD2/sR1SHA9jgv+K2BpRSLz1mx+MWG/aHrhAFtWTFpKQ9+O7Dng7IejCCdw0jwpWagyWjguFPeZ6FB2ZreHWJfqEOmzT9LJAl/7emJhYuofsqg5/vsryAIGOhhF6t0W0X3u58EiaaeJHEtTRHEl6HxZdmhSqpYB/aqMb0k9TJc=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5167.namprd12.prod.outlook.com (2603:10b6:5:396::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Tue, 12 Oct
 2021 18:13:23 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 18:13:23 +0000
Subject: Re: [PATCH v2 1/2] net: amd-xgbe: Toggle PLL settings during rate
 change
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raju.Rangoju@amd.com,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
References: <20211012180415.3454346-1-Shyam-sundar.S-k@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <62eca0fd-3aa0-395e-5309-f33dc3e0c55a@amd.com>
Date:   Tue, 12 Oct 2021 13:13:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211012180415.3454346-1-Shyam-sundar.S-k@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0095.namprd05.prod.outlook.com
 (2603:10b6:803:22::33) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by SN4PR0501CA0095.namprd05.prod.outlook.com (2603:10b6:803:22::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Tue, 12 Oct 2021 18:13:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 107842b8-e8cc-4e88-3170-08d98dabfa79
X-MS-TrafficTypeDiagnostic: DM4PR12MB5167:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB51672152E19D1991FABB7E92ECB69@DM4PR12MB5167.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lbKlF0C5T/YB2xwBcAS5/3LmZ83mNXK8fBzhtkKMrO7qXKGmGjTXlrTSYISAVSnFV0eT6jUcV/Kr2nXzReIzAg5w7a7OEOFaAbSH3864xhVvMT6TBBN4u6oxdQJTkbk/qFD6iGTbOgywcZqqqAbvVMJLwFniy+QKfmal92dQ90ytvnEvJa4+UK1EMWT7LvUFsrisHEGLBrG2MVGpJ3ZmNK21OsriWMGnmB1wgEfk1cFMUDLwEQKXCMeytx3Iqx9zwyQiZDUYX5DQoUVkVTdt99IJI2p1swr6bDV5GNf0itl6GohnnGxqxIfiqewvmLzX1ocKmmGcw4cXvs6AOpN3KeIaFs75qBg3Fd7mTZ1CzJyjcbEYauBPAZXNI42ZoY/ZVZVGLVDGTF54LFDp4S4xBILw3AbNH7iB61yN13To7g+PYiDjLmtRJQjqOvxFAkNsNJxVubCSE17plSj25vL9NqU+NYKN3NX1QU9o+PAz32xukGnS85rdn4ggioMvHm2tKAehodfOjMyRnNq6Lzsa0x38KmJhYpEP9kyqCoPCe6wZMQqajmrn99MPABL/cU/AplRrA+2+7wDPiN+jIIFYriVGomb9miA8CWtq8WXzfKeIvy2lFB2m4NAE+lYwapsslV1RxrL9bqxL+nweKgZLacc8wOVz7bGVPI3YE2n/spGt/KGcHdGDrCnl5z5xR4wZstrh8ZlrqQpRNrLajEJl3IlPy0sQ9OgxoxNsiyJtMheD/glNOfPvbw1kHIomtH6M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(36756003)(31686004)(2906002)(26005)(508600001)(110136005)(5660300002)(53546011)(6486002)(66476007)(16576012)(186003)(8676002)(83380400001)(956004)(66556008)(2616005)(4326008)(8936002)(66946007)(31696002)(86362001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vy9ZUEhaYnJJTTl2aUphUi83bTVDNXp3MGtUa1J6UG1ZNG1aNjQ1azBXUHlz?=
 =?utf-8?B?YTZYNm0rUkMrRGkxVkZKdnBVOEZleitEd3ovdjhrOVFqSlhaOVh2Z1YzWDVF?=
 =?utf-8?B?VkUyRnNKeU5Lb3RQS1JINHlhRjdSUWRQNURUS3FabnQxdSt2bWdnRkhZamJl?=
 =?utf-8?B?YWswK21nb0hqbFZ5VEk3dk9GZ280a2ZsT2VzNkNWOUwvLzc2bTFhcVZ2N2FN?=
 =?utf-8?B?STdnR3ozT080NnF4ZllvWk1VS21FUGhPbFA5a1hyTWwyMTFSbWovVzRuTGFk?=
 =?utf-8?B?c1NrQlZUcGVGd0tFek8yZ3pudk0xVS8wa2RQQkc2TEhqVHRYL0JhaUhVdjVY?=
 =?utf-8?B?RUtTMUo1MWMvbTdVRVJKZ1p4WHMwaEFOSWdWN0NQODZKQmRJWUFtMHU2YzA1?=
 =?utf-8?B?bzdZSmg1SCtXQXh5bFlhb0o4Sjc2TkZwNW1KTmkwc1MyZDFMbU9TWlUvOVg1?=
 =?utf-8?B?aUFsZ28ySEl0THF2NEdrbkcwdnZqaXozbnFERU9pTm5vL3lWYjBabjl2aE50?=
 =?utf-8?B?U3FrdWJLS0xDMnNFbXlaelMwTHFOMmFheGVNbjdjK1p1WTc0ODExWHFVQ3VZ?=
 =?utf-8?B?VGwwYzVKUHQwVW45NzVSeTJDRUdMamFZejNkUm5Ec0xETGJKUDcvNVg4ODJs?=
 =?utf-8?B?dTdxZUtYbjFhZDBLeXlxU1RuSzRrNG5IYmNpNlMxWUJ0SnRuN0JqVXJNTUIw?=
 =?utf-8?B?bFpzYXBJNnd5alZyR2hJNzlWYzhxMGhGd1lUNXRhQTUxN2hRMERGVmJmTlNB?=
 =?utf-8?B?b25Ea3FwbHlIdHNQR0lJZlpOREJ4YnlERTBRRnVVQjBwOUl3ekVFQjloS1RN?=
 =?utf-8?B?b2VLVExOajU4ZUw0dDBJOWNqcGdBd3dFWFB1YmJhOG4rRnFvMGdOdmVwcmRs?=
 =?utf-8?B?enJJZ1htUHZUaVpncXI4Uy9tbzRtUFJHbHUxU0NQVW13N281WDhranBmbzI1?=
 =?utf-8?B?WWYwUmNoaXlPcnVYZkFGczZ0OE44aUJDVnU1b096Y1FZc0pkbUtVVzB1cUhz?=
 =?utf-8?B?WUZmdVRpOVViN2Zocjl4SmF5aGp4Vk84K1lqMDZxVFBka3pJdk9mUG8xZ3hV?=
 =?utf-8?B?SWNhZFR5a3dJdmVrcTAzczd1ZkFjamcrVHpRQ3VleHBkY0dmQlJUcGxIUXUv?=
 =?utf-8?B?elpwekVUeDhhVXY5WTJPa2pQQ3NManplVktvTkpsckRLTHU0a1lla3BRbW1E?=
 =?utf-8?B?V0c3Z1VrcXlUcTBSWUpuRFlsQjV1Z2lnY2s0VmVITHdvcmFFeGRqdnVsVGJE?=
 =?utf-8?B?K2ZGcGQ4VE9jVHVhQ0hKQ3ZlNFhmQm9XbDljalBUdUY0VUhwWCs1dE95UDJN?=
 =?utf-8?B?R2Z4anQ2V1M1MmxlMDlGK0dxMitSVlhHT3dmZE1GVWFuSzhwdXlWR2xESCtJ?=
 =?utf-8?B?VHQ5ZUVuaWphSEJHRnJmaTFZaWZmYWUwZ0d6UzBUOUtOSGZMTlRDNUtZRURP?=
 =?utf-8?B?YVpIY2o4TDJXTVZnaGZVNXJpTlBFN3Zrb1kzY1FmTnI0SE10NTlFM0YwQjFC?=
 =?utf-8?B?Rkh2bDVkK1kzQWk4N2l5QVNBTkEvSkp0RVVpRE9FNU44czF5L0taY2hlNkdY?=
 =?utf-8?B?TnhkNXJHN3ZJeSthQVBWOTg1L0t1K3l6azdkaWVaNkhocVp3d2JPSU9keldD?=
 =?utf-8?B?cXRSaEZ2ODQ4dnFkRXdhdHg1MFg1NG9VT0szNW10aWJpWWpjMU5TT2hGUkd6?=
 =?utf-8?B?NnJCeXZHZEExWFZQVmsxbXdBNFhoWmxHOVBERjZaSDNocC9oZEZPcW1TMFNR?=
 =?utf-8?Q?JEkr5tNc5ZvKdmtPQTx+3cbbI3X38HrR3VPqvH1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107842b8-e8cc-4e88-3170-08d98dabfa79
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 18:13:23.4480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m4MER9wbzerv/jYggaRdUWiQXgJf4yNGliqZu3Om8t2pgbADHoXIRpPKkMJ0Cxiiu2Anc0Mcd0NdtKk7SQkqIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5167
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 1:04 PM, Shyam Sundar S K wrote:
> For each rate change command submission, the FW has to do phy
> power off sequence internally. For this to happen correctly, the
> PLL re-initialization control setting has to be turned off before
> sending mailbox commands and re-enabled once the command submission
> is complete.
> 
> Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

With the minor change below...

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v2: add a missing Co-developed-by tag
> 
>   drivers/net/ethernet/amd/xgbe/xgbe-common.h |  8 ++++++++
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 20 +++++++++++++++++++-
>   2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
> index b2cd3bdba9f8..3ac396cf94e0 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
> @@ -1331,6 +1331,10 @@
>   #define MDIO_VEND2_PMA_CDR_CONTROL	0x8056
>   #endif
>   
> +#ifndef MDIO_VEND2_PMA_MISC_CTRL0
> +#define MDIO_VEND2_PMA_MISC_CTRL0	0x8090
> +#endif
> +
>   #ifndef MDIO_CTRL1_SPEED1G
>   #define MDIO_CTRL1_SPEED1G		(MDIO_CTRL1_SPEED10G & ~BMCR_SPEED100)
>   #endif
> @@ -1389,6 +1393,10 @@
>   #define XGBE_PMA_RX_RST_0_RESET_ON	0x10
>   #define XGBE_PMA_RX_RST_0_RESET_OFF	0x00
>   
> +#define XGBE_PMA_PLL_CTRL_MASK		BIT(15)
> +#define XGBE_PMA_PLL_CTRL_SET		BIT(15)
> +#define XGBE_PMA_PLL_CTRL_CLEAR		0x0000
> +
>   /* Bit setting and getting macros
>    *  The get macro will extract the current bit field value from within
>    *  the variable
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 18e48b3bc402..4465af9b72cf 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -1977,12 +1977,26 @@ static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
>   	}
>   }
>   
> +static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
> +{
> +	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
> +			 XGBE_PMA_PLL_CTRL_MASK,
> +			 enable ? XGBE_PMA_PLL_CTRL_SET
> +			 : XGBE_PMA_PLL_CTRL_CLEAR);

Please line the ":" up with the "?" above it.

Thanks,
Tom

> +
> +	/* Wait for command to complete */
> +	usleep_range(100, 200);
> +}
> +
>   static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>   					unsigned int cmd, unsigned int sub_cmd)
>   {
>   	unsigned int s0 = 0;
>   	unsigned int wait;
>   
> +	/* Clear the PLL so that it helps in power down sequence */
> +	xgbe_phy_pll_ctrl(pdata, false);
> +
>   	/* Log if a previous command did not complete */
>   	if (XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS)) {
>   		netif_dbg(pdata, link, pdata->netdev,
> @@ -2003,7 +2017,7 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>   	wait = XGBE_RATECHANGE_COUNT;
>   	while (wait--) {
>   		if (!XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS))
> -			return;
> +			goto reenable_pll;
>   
>   		usleep_range(1000, 2000);
>   	}
> @@ -2013,6 +2027,10 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>   
>   	/* Reset on error */
>   	xgbe_phy_rx_reset(pdata);
> +
> +reenable_pll:
> +	/* Re-enable the PLL control */
> +	xgbe_phy_pll_ctrl(pdata, true);
>   }
>   
>   static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
> 
