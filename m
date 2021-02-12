Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238A731A4FD
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhBLTGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:06:33 -0500
Received: from mail-mw2nam10on2060.outbound.protection.outlook.com ([40.107.94.60]:20833
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231466AbhBLTGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 14:06:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTtsLcveNFHbeQgo/zmGvTu0JbkTM6nOv4se71h8faT158IFdKDiG31YFAxUTF9lKAyWHeFynrLSDs4iWxBf9me5ycTmVy2HECLk2qpfy8wrZ81bEC7CHM9TJ4vfDS7pYGmRr+0HQ4DRIG7yP8ZjbsNtwtoIMT7gujv6DuuzIdygwlut2uknTiLumJEOzzBlQfxLPk3DzhRJWQZJiq2L3LCMBYALu7o5+ZLmrIBv7gCl0iPBY14u+5ZwLKtIhA0v+YUXtMQtkgdFiWHOnKexOuET2VU4GRGEF7geJPBR/5fPgZhDh2O9S0Y3pozTCiY7Ziz+TTFwkcJbSjk61Mp6LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m54LKJKPtzK8Po0e0d35E7sZbkHY/ovtI6Tjg9N2ktI=;
 b=C7u+7f0bwsbX++0Pzvah1FVT8YaH2x6tcMyF5D5l6Sbw3VBmQQmDP2zVscrJVfRjZjTfVW0Fn7AkZ7ca7t+OFs7+IsrVY3xjILdrYrEIP5M2d3zg4EE4/pQXJuNaJ0Wxm4zaT2liWjF8qpTEYynkZN1RPS6+qzgiXdxA3EKM8QrnktoOcT1eIwrdZ5Oon637kLWMBVnrvfJ7in7BKp2GSMw3sMhDbBbsZjL6PoLCXZK+McNHzuo9oBrw559YObOMxGT0yeKmNpbGLXzxVm2zrCo7ok/qcqttFnVk+FdHIFwQ9tbF8CZeypgTVV22vo+NzLn0tLmJtUV7z9LvVh5tmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m54LKJKPtzK8Po0e0d35E7sZbkHY/ovtI6Tjg9N2ktI=;
 b=U1FHNJeRvL8HM3OM1i8zgWvpFpC8bXFLXQQC3pRE2nPocm+W1YnwsbbQbwlDai0/ZxidUBRebKcps4/078fjxfxhgEPyNhLs9oRyxIwk9jxVTsqTma8CVt2OWI985TALhbI55f3o7UAHETQrxqqnRrjTr3FsSQb61wQKlWUpe/U=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3689.namprd12.prod.outlook.com (2603:10b6:5:1c7::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.27; Fri, 12 Feb 2021 19:05:29 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3846.034; Fri, 12 Feb 2021
 19:05:29 +0000
Subject: Re: [PATCH 4/4] amd-xgbe: Fix network fluctuations when using 1G
 BELFUSE SFP
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com
References: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
 <20210212180010.221129-5-Shyam-sundar.S-k@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <ead767df-ca25-34f6-2518-febc27a642c1@amd.com>
Date:   Fri, 12 Feb 2021 13:05:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210212180010.221129-5-Shyam-sundar.S-k@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:806:20::17) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR03CA0012.namprd03.prod.outlook.com (2603:10b6:806:20::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 19:05:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 748fbe1b-6ecd-49fe-2bc2-08d8cf8929b1
X-MS-TrafficTypeDiagnostic: DM6PR12MB3689:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3689DCB69113F9057C69084BEC8B9@DM6PR12MB3689.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kpph2dQgA8jB2N/Q0xkRAeNfWRNdIpYQYFLr4KaKkX5RyBWPez61P0iMZsZGDLwSrayGjtYLPhMz47+LYlloopbwKRbvt4/djqet6HAn8cbec8RaHerPuzmL/tTNoQ2shIFKsiWrIctqOaeDGt6nLWZ/q1VMtkZZ5vW7st/CR+Nx1HoGZTGlX49McrL0Idz2IAA0Bu6fn/E4LK0rx+T0XeZZGDoJEZFpgicy19i1d+2vFwKyBzSRDWcNzMIuRnHkfkvph6mpxcQ6qivC5vt44rdeqT/Nv2NWAL4tEUU3pLty7/ahgrjUxRBEQDfXsphXqmz0Rfuuy812+xUJejSXUr6PD6cwovrJYheFcu6A9yto/GCy2N2cshdl4zu7hlafGQBuy6CihaO6P2p3cPAwSO05+RhwB3vutYeFKI9IxuInoReicRYiA0HQ/uTQL6BCQ76wzT+cr5w6s1X5kE7Im4ewsDZNcnZ7OHaHF5yxasp+dd5TQKkmdt6RCNAyFG5sRz2VvlzN51T6/+ePYJ/9fnTUwJ4S76LAaNLou/l4q5tj6GfDvMbKoyjOwJ03Iu98QiGgECGu/PexUEQ+0fF+N5l5Pf2cF9Om9ol816poDOE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(86362001)(52116002)(8676002)(110136005)(956004)(6512007)(2906002)(2616005)(16526019)(31686004)(66946007)(66556008)(36756003)(478600001)(6486002)(5660300002)(4326008)(26005)(6506007)(31696002)(8936002)(66476007)(316002)(53546011)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NXM4WHAvT1dFV3dwMlh5YkFZS2JhZ3FpbUUzSkU1Zit1SDJnY00rbUsrRTYz?=
 =?utf-8?B?WWExNUQxaDA5dCt5OUpQRU8rMGd0SUp0akprV0tPbGU5bEtBRWF5bXUxM0RU?=
 =?utf-8?B?ZTgxMWI5WWtXdnBqMWdOYTVJbUJzRkd0YU5PK3ZheDNlM0s4WTlYL1NwZ2JS?=
 =?utf-8?B?YVBsNHFSM1RlUUt4aXdFZkhsNmhJUDdWVkNrQjdnSVZRSlVNYUY3M2F5M2Vn?=
 =?utf-8?B?MWZVNHREZ2EzZ281N1g3WkJ6SnU1SnRRdDNHdFFMQ0ZVcTJGcWdlWFA4dWdC?=
 =?utf-8?B?bGZLTGN4OTFRdHlxSlhxekRxeU5ia0RFUFplQlFHcHVxTWZ3TVNqQUpjaWhJ?=
 =?utf-8?B?MklvR09rTVcwcHVzQTJlaGs5ZjNVaUwxeUJCcS81dEg1ejZwTk1kM3ZSZXdM?=
 =?utf-8?B?Nno2aHV5blN6U3BGa0ZwUEp0MitwWlRrd1FkbGVCZFlUQ0J6REZQanQ0Zld2?=
 =?utf-8?B?WVZBejhmZEhTTmwxVWduOEloR0xvcXNDRWk1VnNQYVRla295cmtrWDJtaGtI?=
 =?utf-8?B?N1dxTk55TW1LaFJGTEQ5ZjNYVGNYTjdkOU1xQ2pTTU5CUW9Pb2srQmdSWHda?=
 =?utf-8?B?T29tSm1mMUZxeERKTnZaaFlGWU5uQ0NKMi9qTWNSVnZuUitkcjk0SEU3SnhV?=
 =?utf-8?B?bnB0K2psNEVMcXJHbHdYTTdKdFQ5VVZkdDBTRll3cks2WUNMcldXWUc0WDZn?=
 =?utf-8?B?M0w2cEFBaTRzS0VvZ3lCdnd1Rm5KcUxESHBKL051TW93VzhWcE1KMkF5aElS?=
 =?utf-8?B?aE11ZG9RTVlaWU4zb1ZPU21JTzNKQmxYNTBMbVpvTXp1Qm9tUWt4OEVWRlZl?=
 =?utf-8?B?V1BIOEhtTkplRk5mQXhmSG16M3J5dW5KOCtsL2JYVXNZTm41WmYrSTRGQ0pB?=
 =?utf-8?B?UmwrcXZWU2hxektvU2k0ZmJubEtuT003dVpOOGNLQlpYZHB0SWg5cE1vNzJk?=
 =?utf-8?B?L1Q4d2g4WG9HcERURE81QjhCdVNFY1VkTEpZeVQzS1NhSXlqZ0p2KzFsUytO?=
 =?utf-8?B?VlByMHJkZXBFUUV1SGxlUSsySGJIMkdEMkcvSEFFWGdRWlduY1dxN2FMcVlF?=
 =?utf-8?B?R1N0OU9YMVlnbk41ZmZBNFpzMXlPZHlYc0pLUkR0MlE2L3lrOTNLckJOZ240?=
 =?utf-8?B?VzVoWWxNZmhidldZeFFtU0lqTDhFTTFZbEpCUzAwdWxhSUxBL3RXbjQ1MFd4?=
 =?utf-8?B?NFN0R0gwam1Ia0dhYkszNHZIbVpkSlFPYkxzdXNvVnZXSjVoazE2TEtIL05k?=
 =?utf-8?B?YVhNMGJvcktaSFR5cHNmc3hCQUJTOXpiUUVLcU1pTDhrRG9OMDNuTzdDMGp5?=
 =?utf-8?B?YVhHMU5LQ0tWTGp0cktBL0FkUTE5ZlBBSmVpTzNQZHpPdlNNNjdNWUpKMUFH?=
 =?utf-8?B?NTBBdWgwQXJISzk5dHNwRjRIaHhHVHV6R0NIUkUvOWozeTI1RmU4cnRIZjhr?=
 =?utf-8?B?ZVM0eThKR21lRHQvemVVU04wMHBaSEF2M3UwdkFyaUtoVTRVWHl2b0wySDVC?=
 =?utf-8?B?YTl1K3pHMmIvYXdKeXhIUms4NnZOY2FrdmJ4Nk1uRGFQWXJZRHJnb0JEM2Fz?=
 =?utf-8?B?Y1hPV3V6L2QzUXlnLzFjWGVNRzhkVjljZjlVSG9Id05zamI5RE40eWNZb3FS?=
 =?utf-8?B?eTN1TWgvZW1Sckdjb2ZJMzdJYjZ6aEhhWCtmbEM4K3FlN0g2Vm5FUktZWHp0?=
 =?utf-8?B?ajV6bWQzN0NXRVowcmI0QkFhR0krSVBha0xvOVRpY2NGb3I0eUtQajdsLzU5?=
 =?utf-8?Q?P+glpeQVyzSOQ0tPM1MlCJ8/mXWR87RGPHRDpT0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 748fbe1b-6ecd-49fe-2bc2-08d8cf8929b1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 19:05:29.1960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DOm/HQXVa3kkdvGoKSHv5EL8II0W2SYgg46SEVrDpoSyA4/igfQ2SF31JG4TZt0q2Am/OH92ITX9wuaQ0QWdXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3689
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/21 12:00 PM, Shyam Sundar S K wrote:
> Frequent link up/down events can happen when a Bel Fuse SFP part is
> connected to the amd-xgbe device. Try to avoid the frequent link
> issues by resetting the PHY as documented in Bel Fuse SFP datasheets.
> 
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Same comment about Co-developed-by: tag as previous patch.

With that addressed,

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 1bb468ac9635..e328fd9bd294 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -922,6 +922,12 @@ static bool xgbe_phy_belfuse_phy_quirks(struct xgbe_prv_data *pdata)
>   	if ((phy_id & 0xfffffff0) != 0x03625d10)
>   		return false;
>   
> +	/* Reset PHY - wait for self-clearing reset bit to clear */
> +	reg = phy_read(phy_data->phydev, 0x00);
> +	phy_write(phy_data->phydev, 0x00, reg | 0x8000);
> +	read_poll_timeout(phy_read, reg, !(reg & 0x8000) || reg < 0,
> +			  10000, 50000, true, phy_data->phydev, 0x0);
> +
>   	/* Disable RGMII mode */
>   	phy_write(phy_data->phydev, 0x18, 0x7007);
>   	reg = phy_read(phy_data->phydev, 0x18);
> 
