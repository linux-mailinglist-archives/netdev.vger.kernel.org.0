Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1587531A4E6
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhBLTCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:02:05 -0500
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:26972
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231131AbhBLTCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 14:02:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvUJdE1G2SXM9rsyqADYglu97Lkb2wVX6zZbLbLQewqx3XATuEyNLZrF4CBTJDH4AdpwASyIz4AlamG8McMqdKw87XfV2KdrOO9CqUrtdfOptalsVsX2Zp75e8uYK/e4dOaSohwBo4ToPehf0eVMg5YYSX1cArIBiw9LH8A0J8Dta/fzWLZK5bmmLbVr9k+kNzwpWkYmxzMNhLSdiQ2QTkYoEX/1FnlWdS9uHmbx+bD+3Z0dbNg5Lq/wFgx39jLLhOds9rPzqumdVn0TpV1SiIy+T/Qn+P3ho27kAYZKAM+uT6Kqb1eIiM+Rt4eHzw1Ef68+314sADox2UH4v7mTkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hW2RhKq7FJBUZ7pWLJkTh5xxw24ojr8fAszKqYO/+U=;
 b=f77AdynPfxkFgFX3X7CwK195ZgLZ9OiBdToYoFJlReRgGNrEMmST59yA8jz+8aQZk1wrNiu2IPDE3DvcXTxIFLLaDtaPLHsV5IKrV3Gi+35Ql6phs6xcU05KDeB5N2heCUegkWyQooqMqmASEY/JSx+Bqu2QX45uKAGEFOsrvkunoJBj+TbCGAv2P8lIKmFbOYynmkCO+JLeLE9Vvx0x9F67qq8KwDtr6RcbVtN6NyejeoTcQM9x2UGPSSRH4QbsZiKxUoKBxaQ9LHNZDMi01fwgKpSfJOuTSixD/sYFEVNC9e/+RyFix8haMwI+y8df0Q6LKs9rN7iFdtNRMsc+BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hW2RhKq7FJBUZ7pWLJkTh5xxw24ojr8fAszKqYO/+U=;
 b=4H1hjC14PQwop7/yJFTMxJigpnDl+JP3KHqB9AmdgyCqX4d35XAq7sVuCOMciXDa8jVtIpWf0b84KpmZkWozhMn821ZjIMago3bGzACY5KKhlP5+vzdupn7lOiE/dS/VD62vkpxxVotrPnqLa5/AB5fBKqLzVQ8Wkdkbdi83bkQ=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3273.namprd12.prod.outlook.com (2603:10b6:5:188::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.29; Fri, 12 Feb 2021 19:01:10 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3846.034; Fri, 12 Feb 2021
 19:01:10 +0000
Subject: Re: [PATCH 3/4] amd-xgbe: Reset link when the link never comes back
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com
References: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
 <20210212180010.221129-4-Shyam-sundar.S-k@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <9aef8251-0350-7321-f5ab-6158466ea809@amd.com>
Date:   Fri, 12 Feb 2021 13:01:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210212180010.221129-4-Shyam-sundar.S-k@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:806:130::9) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR13CA0004.namprd13.prod.outlook.com (2603:10b6:806:130::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.12 via Frontend Transport; Fri, 12 Feb 2021 19:01:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 33b50adf-c7d9-4dd2-db2f-08d8cf888f50
X-MS-TrafficTypeDiagnostic: DM6PR12MB3273:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB32735857D35618D3C9037C44EC8B9@DM6PR12MB3273.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0WQnnWrM/E0UO9IybFAVU7h+WQ6/nhsAwSm3Z+1QmblydFvVxVuxcy9nOVj4Dk1sTeVwoqfjv2KKI7KdseOZDd8a4n1Nf/vMw8Ie+t0wzDUm9Nlo+Dh3Nu/0Bz91URr0xGsYCqi1SgKTxXA6LqFhBw8ylEr25JUMVG3RuEFpg7bfK6xT/T6xiIVrZxK6ya65N4ga8GKhyHCfRZ+PbOPrBOv4ns3cICZWPAF7Ly7MVlImljPcOCYUjX8vKHQzxJk6yn2ilH/xkUmgGmbe4czJ3U0zzFQQKWysmKW4AGRtK9ICcZIkxWMj8OaNb6pERBoHpv+rMTdDXA/k2JziBJVIdUkNCbPY5jDCTmwehqeZQ5I0ersF7ZJra/UIE5C/wjU8ZpPpzsTAq13M2kXzDS9zmAqmb75VYFal8iObo1muoBlwTD7YVb2x4iDSDZH87yOXEyn9cxe+L/138Ubpch91MwRwh9/cfCz9TZt2DP2BwyKJQM+RW071wnPzpAvtxQMwkYLji1DKLWFoYtylkLvYfOH5+/KcbDpJaduBSeOorvTz2QFfhPsZqdqIug7yXmuRk+5RX7NDiY9cqW2TObZ7X8DRgXRAXeMqFAMl0XqjZ84=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(31696002)(53546011)(4326008)(6506007)(31686004)(6486002)(26005)(86362001)(16526019)(186003)(36756003)(8936002)(110136005)(66476007)(478600001)(83380400001)(66556008)(956004)(2616005)(6512007)(2906002)(5660300002)(8676002)(316002)(66946007)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bWFmN2FKUzdodEs5cUJwckhGQlVHdldaZEhET1VQQVFmSHRoNTgyRmhWWEtR?=
 =?utf-8?B?aDgraEpvTDlhdkluYVYvcGJMY3pKWTdNWVB6cTRINVhTbzN4OHZkaDNWUFhQ?=
 =?utf-8?B?QnI2RG9Jc3U0cjJHa2hiMlVmTWpVc0d4K1VFdGpXUllqSk82ejhjQTBCSnFL?=
 =?utf-8?B?VC9uWHk0U01FdDFIQlhYV005SUxQYkJCUElPS0l0NWUzZ3ptUW4zK08zVFVz?=
 =?utf-8?B?TkZKeTQvdkR2bW9RU0l5K0Q5U3VlaTl6QmpKcHdlK3JTcy9ydjRBVGYzdlVU?=
 =?utf-8?B?UDFtYzY1b1p5eXpCUTFzVmVIUjdyTWZLTTJzNkpUVnlVemR4NXI1VXAwUHpU?=
 =?utf-8?B?UkNzdUg0VTMzOUU1SFQvWCt3elpuYTNhTkhEV0ZMeFRZYnFndzJ5QzViaDN0?=
 =?utf-8?B?d1BGbVRwQmlvcXFLT0p5RkdGWXFIZndJZC9LSmt3QTZsOGlaVXBncmtuRVhv?=
 =?utf-8?B?Zko4UE9ldjYydFQzV3Vyb2J2K2dmdnBmWlNjZW0vNi96WnJGa2FlclR4Qzh0?=
 =?utf-8?B?akNxZURRNzdrY1VrZDVKUE83aEpaZnhQczNBM3pWV2lXbjVSM0NMcXlDR3RL?=
 =?utf-8?B?YTg2cE1VQWtNdnBvNWhlOWtHTFpBc2FzenZTY1NOTTNIUVhJdDVFTWcrWGJ2?=
 =?utf-8?B?aFY2djNwL01aQWJjSUFQdnkxQm84YThkeHBkSmM2Y1ozcnNWV3AxWVRVbklk?=
 =?utf-8?B?QlJ2ZVhQejJZdVZ6VHc3Yy9xais1RGJ1dVRLbVRxTEFtT1RlUWoyTHA0S1My?=
 =?utf-8?B?aExLK1NOb1pFTXlqMXB3Ym5ZNk5WNkN2NFloMVpHV2xINW1ydXJrbC9rMG9N?=
 =?utf-8?B?N2ZnWmw4M1JYSllBQ254cjlHQTFTYWFIOUwxVWRJMnFUY0xnYThMN3YrQzh0?=
 =?utf-8?B?TUxJOXJ4aTJEYlpkTUNVT2hKV3dyQlIvR3pnRElXMVQxMGhidFRRRzlFVFJi?=
 =?utf-8?B?Z0NJUnlGWkpKYXUvQkZBSXljay9rVy9FUDljQXhkeUpYbjFzSTZ5N3NtV01N?=
 =?utf-8?B?ajZvcC9NWncxdVdzMEg4VnZlQkV5ay9UWkJkUjZVczBObkpIMVFBYzNjVXhi?=
 =?utf-8?B?SThCNExKQ1JkSjBTL2daa1RaOFlMTzM2bjBIMSsvUjc5Q3BneEV4NTRrYklx?=
 =?utf-8?B?QkJsbTJLOTRkdTNuL3NENHpjY3EyeVFFb05CMmM0REphZkF4eForbE1oMEVR?=
 =?utf-8?B?akt1cXA1cWFwRU4xbVVhYzlwSFkvTlVqTEZoMkRBeWFtc2hIaUVCc25Ba0RX?=
 =?utf-8?B?QlNLcFpPMXNUMEJjbDhKdnYwRjU1NXRPVWh6eGdSYlU2cXhQM21OcGlWL1Bz?=
 =?utf-8?B?Y000bDBFdGp0RHRTUDNTb3kxaVdrd0s5VVROaGtpL0tmQldoR0x3dXIxclQ2?=
 =?utf-8?B?SFlaTzJiYkJlZks0aXVhSFRDQ2xDOUQyZnFFQzF0WXJiU2Jud09UL281WTFo?=
 =?utf-8?B?b21Nd1BvWVlWZGdHeFZMZEQ0b1hobjdBZ2ZLVThGT1cyR1hmZ1R3bnJYeFNG?=
 =?utf-8?B?ZmF2ei9LVC9Ha29Xd2pYVmVldTQrV1lXa1hYY3RLRmxwd3AveTEzay9qS2g0?=
 =?utf-8?B?dEN4QkxvUW82U3NpMFlQODU4NDUyYzEvRWNxVlNidHJXNE9ZalBRUTlYYTlv?=
 =?utf-8?B?bnh3a3ZZTkkyUHpMTjMvVHJDU29HQUR6Wk5IRmswb1I3dTMraC9qcFVuNEZk?=
 =?utf-8?B?SUtoYmF4bTV0cExrWWg2a0ZDTTVEcDZjMW1RcEhKSlBudENsQjYzYytja3JY?=
 =?utf-8?Q?IOraFD14NfiKfiLvrObF7dJgnOk/A4yFPSZ6sNz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b50adf-c7d9-4dd2-db2f-08d8cf888f50
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 19:01:10.1567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UIhKGBRW8yK/hBDELONFT5SIl53INqI5crmvuofbZuaiTIt5FbHuvd0c6pvS7d7hvA054OerHb2XJCkQ6hZLbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3273
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/21 12:00 PM, Shyam Sundar S K wrote:
> Normally, auto negotiation and reconnect should be automatically done by
> the hardware. But there seems to be an issue where auto negotiation has
> to be restarted manually. This happens because of link training and so
> even though still connected to the partner the link never "comes back".
> This would need a reset to recover.

This last sentence is strange. Are you meaning to say this needs to 
restart auto-negotiation?

Please mention this pertains only to a backplane connection mode.

> 
> Also, a change in xgbe-mdio is needed to get ethtool to recognize the
> link down and get the link change message.
> 
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Same comment about Co-developed-by: as previous patch.

With those addressed,

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-mdio.c   | 2 +-
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 8 ++++++++
>   2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> index 19ee4db0156d..4e97b4869522 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> @@ -1345,7 +1345,7 @@ static void xgbe_phy_status(struct xgbe_prv_data *pdata)
>   							     &an_restart);
>   	if (an_restart) {
>   		xgbe_phy_config_aneg(pdata);
> -		return;
> +		goto adjust_link;
>   	}
>   
>   	if (pdata->phy.link) {
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 489f1f86df99..1bb468ac9635 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -2607,6 +2607,14 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
>   	if (reg & MDIO_STAT1_LSTATUS)
>   		return 1;
>   
> +	if (pdata->phy.autoneg == AUTONEG_ENABLE &&
> +	    phy_data->port_mode == XGBE_PORT_MODE_BACKPLANE) {
> +		if (!test_bit(XGBE_LINK_INIT, &pdata->dev_state)) {
> +			netif_carrier_off(pdata->netdev);
> +			*an_restart = 1;
> +		}
> +	}
> +
>   	/* No link, attempt a receiver reset cycle */
>   	if (phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
>   		phy_data->rrc_count = 0;
> 
