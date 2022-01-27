Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8F049E4FC
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242654AbiA0OrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:47:12 -0500
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:9825
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242663AbiA0OrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 09:47:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2l+2KPKAwHGay8+VaGkxQqLih65HAzWHmDdScSMHlCrx2DlJ8WUZmE0dRmSQZin5ml4/D3mZEQhUcGjG3zG8UV8EEoSfkBY5qLkydcJz/KqWESunXRF2Z8k0GNakBZNjCN2YOeNRTJAbc72qwXx7WjMziK4IE1GfHo/LycDTiZH6RdP8EaAT/0RZF4JsMEBD0J6ctb0/vmUm9R7KRKGiGRm+UitM1T4Sodg0HjXG/DSgQdxIwUJpLoQF5QXGgjkQc8O98uR3GIRardBsPIDghDHtzJy85QCEoK0Yuzy1NAmivulp/iziXapk7wdQiFyNhht2LdWCs5fKYxMFbAUkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75x9etTnait8cZo7d+kAy2lWUsLlI98A8JWlNLDLlH0=;
 b=gs599b27aH4kY3vRuRWItG1L5XBf4biFVvA7TvNnO3CR+BrWPVPgEJfR/XtfLBeqwazb8wyNlJ7sAbC+ytMPlwmHlE0MrsSw9rspTn4nbzd6oS8KN+rM6lthvExB+Z3swqOQqs8mosJoqisW2gDXgR/NCQwEoLyXNjHHnSPkMwKkMrUl+qwVGgz2Z9p01FUQjCmhVO9h+XJ+uIv3Bz5jto1WpYkhzYJxIGA3RzzLhd2On0VUkqCLOf8378T3m9PsoDuo6lcb7OMXo2wpIuC07XRD7wVd1Pu0cHMBhlINGWJDQ9HId6suwpio4Zc0qZAuamUzJAeoMMYoIVDsChSHkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75x9etTnait8cZo7d+kAy2lWUsLlI98A8JWlNLDLlH0=;
 b=huX24SkHfJgUjN7gfr2jxUTqnX4wFsbV+tpyEAtvnWQYBXc+0N0AUmgcD3xWr6PENl2InTQnUV2njkvvXA9UADrbfCkipaBFMoECjzqgASEt9NEi40R/crq8SU5RYJCICxddq5MzViUsod7zUGHRErL9HcbsWuvB9dZTpIyDbpw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM5PR12MB1385.namprd12.prod.outlook.com (2603:10b6:3:6e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 14:47:09 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b%8]) with mapi id 15.20.4930.018; Thu, 27 Jan 2022
 14:47:09 +0000
Message-ID: <3a2e877f-250a-4f58-fee0-a125741ec3ef@amd.com>
Date:   Thu, 27 Jan 2022 08:47:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] net: amd-xgbe: Fix skb data length underflow
Content-Language: en-US
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raju.Rangoju@amd.com
References: <20220127092003.2812745-1-Shyam-sundar.S-k@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20220127092003.2812745-1-Shyam-sundar.S-k@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:805:de::26) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07592964-43fb-4c69-c31e-08d9e1a3e56d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1385:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB13857EECC4F3E4C1C6B60502EC219@DM5PR12MB1385.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kBLzt7NFqvoYGzwAIiWkK7JD5JD+Tl6VxkYK9lJSW+kRE9wZChoLzZhVhWSM1IRmoF3rZQ+y/i52BRWJMRKCiaN2wLUcpwmYZSQjJGYdcEQeIzDzFOl35Ma/735z9dtc4ftLLZQVc8m9wf0k1OSZB67ddOmW+dC9/b/RjR2XXVN0WNjAC5lnt3ivvcmNltiPi/2M9o7ed7RvXkyYOasYkt+fDWZN7/ct6WJsWnD7TyqpanuCIBEcEXvdNrc8O8/BbvNRogGY+HvhgC4+IJcYJ8oT5aF/9WF+ECwT/jn5DyvmrLBzxYlAplQKQZq1EExsa/Y1c+k8IYE9h6tf76paxKC1mC1PfgDAF1bjvGh3LNB15GxVZ4pSD0mqNtW1TNMt8+8vOpvYe1crn67esVaHmNI2IrZPoHfYKHtZW1p5OPhjdLU4f1dORUhabqJkuoaYtxfvvhk1H2BzaCWD5WqbTkAwWAP5VvoL5pcKCFCA0YCH3aOjkoPyx3ypRMn5qigzZBDUFnFiSLJnxD/sdpm1czpdAWzS+wIbChtHx84vCfhmHPzNSIDzc4PY9ZJW+Dyt3ovi1zA+qy7EttH4r34MK1q0z56grSYtI9PTImfA2M1vKcSmKE9Qgnb2aSjR60aQxzbljTp12XCNzhNS0ebe2IwETO0yAEchXs75BMYmHumYoxO196y7C550KH/h5OJhNKrfMobE6EqoMmesb52bx2PU2i3l5zpPsDys2VD5q2MRd7rZxlLJOaPr8ATtSPvn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(66946007)(8676002)(508600001)(53546011)(2906002)(6506007)(316002)(4326008)(86362001)(6486002)(66476007)(31696002)(26005)(38100700002)(6512007)(5660300002)(8936002)(110136005)(66556008)(83380400001)(186003)(31686004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U04xb3ZuYkZBQ3luU3BXNFY3czNvTGdoNDg3a0JzQ0VFNkczanplNUhiSFhD?=
 =?utf-8?B?UmR2L2I1NnkwNzFCNXJUemZqV2ZTd0tZaElEbE9wQXAvV2tLQ1QySjFPSzA0?=
 =?utf-8?B?cUl0d3Nsb2NvRmtGZDIwZVowMWVrZFNhSWR4WXJNV0N4bVNhRENPMjR1Snpj?=
 =?utf-8?B?YlBLRkorNFhLczAzTE5uUmdyYUt6bzZHN0ZzMXk0MERRdTFjRW1CSTZ3MWxO?=
 =?utf-8?B?SEE0SThoS3Z6M1ZyKzBqZzZBeitaZFRZV050aGNreTBZa2xDd2RmMlFweElG?=
 =?utf-8?B?RWpoQXo4NEIrTm9tS0VhVmJxbENTQ2QzclNSZFdzS2NMRWxlK2czSkxOaWox?=
 =?utf-8?B?dWJCb3hiNFFpeXVXeHJWY0lUN0tmcE5SZUtWWWZBS1hZYVUvcUVZMlF2S012?=
 =?utf-8?B?dUlLMXZXODFKenZJWm1rMFBJL3RQSGp4YzNpTnRHbTVWRy9iV0YrbE5sSS9M?=
 =?utf-8?B?eVBhVnNQeWlHQ29BbzRIdDBwU3N2bDBOTGdhVnRqTmIrclhzd2NSVzF0cVdR?=
 =?utf-8?B?Z2RZbE9oSysvdVo4TjdwNXZUOWVoYzNiY05RRXVXYmovYTRRWU9BOFkwRE9J?=
 =?utf-8?B?M1RkZnRJeDFiMlVrSkxTVmRXVEN6Mk44NXF3b2ZYVitQeUJ2YVpCMlhORlhF?=
 =?utf-8?B?bXhucVh2WkVmUUlHWlpMd0F6Z3JFK1ExNU5sWUc5dmkxRXZpZFh0U3ZPSDAz?=
 =?utf-8?B?T01VRHBuMU9IYjBpSmJYaUdXOCtwNVNBTnA3ZTNSMGVBcDRFL05PdEFCOVJs?=
 =?utf-8?B?RFJrN0NxUXdoTllCUzNJUkYycVZLdmk0OWlXNG1DbERxQi9QZHBoVXpmcHJQ?=
 =?utf-8?B?RkFMMjhxMVRPam5ObC9ocVg0YjdIblhnc2xWUXZKSitEdEtYbWlObHQyYXUv?=
 =?utf-8?B?L3dXODlLOWdPYlZ3TDNkK2tuOG5RUGkrVHhkRmFKVUVWRXBCQXNrUHBGYUtr?=
 =?utf-8?B?ZkJ2elZvK2QzblV2bUtFU3l5anMvY052aDNiOG1jQmhiSUhuODhaL0JMT2x5?=
 =?utf-8?B?TDU0cEhMR2JXWExiTmJuTXRaM0xuYUhUa2F3SGJNY1JYWVhSa1ZSUXlnQWo3?=
 =?utf-8?B?Y1VRMnlWTWQxNUt0ZVh1eHZpWEk4THpaYnRSZHVrZ2hrL3NXVE90cyt2dG1M?=
 =?utf-8?B?eTl2TE94dlM1UXZyMEt2YVRXSVRaVk1RQzM2MjByd0JwaDc5MmNWMnVLcmhL?=
 =?utf-8?B?b2djNUhiWG10NGxTUmgxZWFIbDF4bHVJcWhkTHMyR0FoS1pkaWUyZEZSSFFD?=
 =?utf-8?B?bTM1bWdMTEJJK2YvWGhkN2t3YjAzays2azRrQW5tL2lGcUE4TmM1OGpWVHla?=
 =?utf-8?B?b1gzMVl3TndrWWtQTEtzYVg4M0RLcmNCM1NaV0V6UldCcFRWVmpPc015ZGdN?=
 =?utf-8?B?L2UzelFDOEFWK0s3U0FBZHhGOS80WWxZWDJ0NHpyVWU1dktuWVpIK3pEaHc2?=
 =?utf-8?B?NmVZSGZlNGs3M0t0SENFTGdZZjcxVk41K2NWZXMrbTkxdnA5b1lvUnozSVg2?=
 =?utf-8?B?SGJaaHd4OWFJaXpZeE9FSHZjUWJMc1FJUXp1by9VeFN2TjdqdjRlU2dMeFE3?=
 =?utf-8?B?Ym1YODdMN3lqbCszK3NZNzk5dnhONk10bXE4L080Mk10VXA5Ym11V2Y5Qmpq?=
 =?utf-8?B?dDkrT1FDMmc3OTJJUzFBa2xZWFFOWTFYNEd5RHErOUNGSUhNaXExenpXWFJX?=
 =?utf-8?B?bEhLWWZiSU1MVmhZSXBVUVUveWt3Wi9GdHYxaG5QT3JnVDFONnVGRysrQkZW?=
 =?utf-8?B?bjJkVEIxRzZrK1VHMHhFdWJJNWU2TFpCbnNIbFJJSU1ZTEZONzc4cGtmVkVN?=
 =?utf-8?B?emtpOXF5TzJGV2dzcUJXTGJSRGJ3eTJNU2NkSERrOGNWd3RVdDNoQ3RWeE1w?=
 =?utf-8?B?ZDJlRlJQL1VZeGh0WXBudEQvRGF3NWhvcklUS2ZqYS9jM0dJaGpIOWp6QzVI?=
 =?utf-8?B?SW5MRU4rVzZwdURsdENXby9IU0xMQ2dFcHZtOUZ2S0lvQ1RMUmJhT0NmcnE4?=
 =?utf-8?B?NFprdHNmQUk0dGpGdHdSZVJ3RnlpOGZwa281bUVQUHg1T3FPa1BXQXBaWW5o?=
 =?utf-8?B?SlBqM1JXVEtlZGQyV0kvRzJyajluMmtoY1NPTnVpRUppSkxRaW9pWmRveEE5?=
 =?utf-8?B?am1ydldjNGtmSW84aldFVHA4b1JTd3htVkgzTlh0MkZRMmdsMDAvTjJENlhX?=
 =?utf-8?Q?JO+76MAjMHej6hUsjQG0gxs=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07592964-43fb-4c69-c31e-08d9e1a3e56d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 14:47:09.7230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mADLbQZwasYS+6eoWqWJpEQTRwgLmhCB5NDoL3PCsrl74lyi8bz8/KvKK6xvvsTUUEQVYZJ3GI5+SP04LGtbmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1385
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 03:20, Shyam Sundar S K wrote:
> There will be BUG_ON() triggered in include/linux/skbuff.h leading to
> intermittent kernel panic, when the skb length underflow is detected.
> 
> Fix this by dropping the packet if such length underflows are seen
> because of inconsistencies in the hardware descriptors.
> 
> Fixes: 622c36f143fc ("amd-xgbe: Fix jumbo MTU processing on newer hardware")
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> index 492ac383f16d..ec3b287e3a71 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> @@ -2550,6 +2550,14 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
>   			buf2_len = xgbe_rx_buf2_len(rdata, packet, len);
>   			len += buf2_len;
>   
> +			if (buf2_len > rdata->rx.buf.dma_len) {
> +				/* Hardware inconsistency within the descriptors
> +				 * that has resulted in a length underflow.
> +				 */
> +				error = 1;
> +				goto skip_data;
> +			}
> +
>   			if (!skb) {
>   				skb = xgbe_create_skb(pdata, napi, rdata,
>   						      buf1_len);
> @@ -2579,8 +2587,10 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
>   		if (!last || context_next)
>   			goto read_again;
>   
> -		if (!skb)
> +		if (!skb || error) {
> +			dev_kfree_skb(skb);
>   			goto next_packet;
> +		}
>   
>   		/* Be sure we don't exceed the configured MTU */
>   		max_len = netdev->mtu + ETH_HLEN;
