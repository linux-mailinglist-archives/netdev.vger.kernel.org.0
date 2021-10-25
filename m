Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9416F43A5FA
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhJYViH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:38:07 -0400
Received: from mail-db8eur05on2047.outbound.protection.outlook.com ([40.107.20.47]:5857
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233805AbhJYViE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 17:38:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLZWn7BPdPlpEU2tnlmyzwnhQxjWKwzOov6Pp6VrnDViusC4VEZNBqTnjhAC/10e7eDQttjl/5NkTUrGtu4+mjjQa0lx3c4fZKCLgRdznkvAbCVycBn9pu6YN1k1shcFwgxeQO6ZU5zoWYigNHfBGiowlFWMair/lJyBTTfbpThkcpeC4IT6vYkAT9//r3R+LG6imqe0HkrIrpn99AWtO2CUCdi1s8RyyERnqx347SquVbWGKQDSes/JekukGG1Xyuu7sGSPTqekPy91VW5V0kpourTRx87TdvrxggsDZ9hyM3ZmV/Os1WrQ/4d+0HiHgELkpHBhiXqQQKqyFtp4CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtfeDsPRcxFbOgGrAMsdyy9uc3UY2Cr/d7Wjn3kb9HM=;
 b=n2bavLlJ4T2j5pI53QdKiI7iUSGwAWyJ2iA6G969n20RXGREEPT3N/oxWVkb8+mnuuNM5khL6dNBQ3pu08CvEg7HVAZJPpOVMT0+alITIaYNzTWB+mJyvMpYUTBFbLg6A1cBMLMGuGzXthx7Tq1sXSlw+AAboVuf3Abha8itwYXhV02W6upBrnP6dIdjFFu8jeC1tFzfLj3FFM8H3GleibJ9K4Cd0hVLmKX6f35Dqahs3GCA7XDYrqfJvJuyLxcUHcRyF5ZOtdeniNTrZ4AJRlsAp4r6mnZ+N7zqjNWCQb/LrwPFmRVE5fHiS96wR+jLFvvrmVUEI98ycilbZZ4Qfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtfeDsPRcxFbOgGrAMsdyy9uc3UY2Cr/d7Wjn3kb9HM=;
 b=odBWQXI/LIbxAtpy4lJtWDniQ5DxklQWdDGH/PMlFVrTm/jvxKrFPlWLiU3KEPU+j3q3JzWSS1rpWynPWwDZpSkg45DhgFAGWwIMlMjE0i0daca/sMvBxAK9CWCkZfDhNQZRgNmAt1engMa2e+9o0L4/xT7a47Cj7EW3sD1NuuI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB6762.eurprd03.prod.outlook.com (2603:10a6:10:20b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Mon, 25 Oct
 2021 21:35:39 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 21:35:38 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <YXcfRciQWl9t3E5Y@shell.armlinux.org.uk>
Message-ID: <5e946ab6-94fe-e760-c64b-5abaf8ac9068@seco.com>
Date:   Mon, 25 Oct 2021 17:35:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YXcfRciQWl9t3E5Y@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::30) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR07CA0020.namprd07.prod.outlook.com (2603:10b6:208:1a0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20 via Frontend Transport; Mon, 25 Oct 2021 21:35:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 495e0ee8-69b8-4c01-a688-08d997ff6330
X-MS-TrafficTypeDiagnostic: DBBPR03MB6762:
X-Microsoft-Antispam-PRVS: <DBBPR03MB676256E1675637F09DCF23C496839@DBBPR03MB6762.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0MUM/WJBI67aBgf5nQ2T2qlK7OeLX6MkThdRtPCyZ6p6s8XOwnhqt+U02mb5o7WI22FrAto2NwKidkl9y/DELLvpK32+xbcT5uqfyPger0zcJiMQP8GhHf2i0MK/Al+G1ikMPDJb9sSToo6Yd8bK9K406+OGLuy3b3rrsyScHcccOb6ol0+F4KEbxF88FfO1RqPwRVE0tqRefYPbb7ly0d7IT9Gm4/7+6uf39KJBdD2gVxmk5n0UPXaByNAIjjDEJg/KLz7d65NEG2XBuh23+AUrUt4bzAMnAaSvm7flJwBRsWzZgkUKDhwOhbQjBColnnlTpVoZwB79KrK0WragbYOmeP6sW6NHbt/+2Dt1poKY31/YV8gS26zo6aGvZnztmModM2BtmbuVr+urlDpHk3+MKQD61eDoGMiLYfW14zUY8q7tEPvqaAxqyxKkyJtLGIbZLefHDjX5mXxwgDLv5hoRwjtfCNScnb7zYE8nH0Sm9QHm/Le2JdQypAcrYMtsFVHmy6Gav6T5D4D2w1aex5HK8NXu44VQOYOTjnlE9IzSWhAzgjaBcScNMCBpUmvg+y6JBh+rj0FtSx7c02nuGLKprQP3/uCxAoHT8F4V2iSAYQz+aCqigyDu54qFbbPtcn0Ycp0vgZF5whZ7BUQ7Zb4gPpz7OGcjtW8yUFoPp06uZW+ox4tD5WJPPiOL9BNgwdKziXu1iJNVzVao8VUkhQSMgG6wZv476Wi7HZBZcIdlNkNzS+AYoi7kHKzdT2I0aq+Cahp9zf5ibfw/PUATLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(2906002)(6916009)(15650500001)(36756003)(508600001)(53546011)(6666004)(5660300002)(8936002)(38100700002)(8676002)(66946007)(316002)(186003)(66476007)(31696002)(26005)(44832011)(31686004)(4326008)(16576012)(38350700002)(52116002)(2616005)(54906003)(86362001)(66556008)(956004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3A4SlJQQVVIS0lveEJRVVZKc0t3dVNIb3lka2dva2JIM2x2ZUUxRndHYk5L?=
 =?utf-8?B?SVQyaWhYSW8xT1FGdU0xM252U0xnU2xKRzFrRURhTy9YY0E4Q2VtUmZHMFRB?=
 =?utf-8?B?aUwydGdJZEVNUkV5UW1OQkpCZm9vT2pnRUlGZTZQWHZ5Uko5NDJZQUlmT2dX?=
 =?utf-8?B?c1pFTHJSRDYyQStQclVOdFdoUUJCRFhFdkNzMmh3SW1jWXpFeElsU2ZFNnRL?=
 =?utf-8?B?YlBYeERHd29zLzRNNCtwdHJHSWZYck1YcWh2NzJNWCtKZW5vQjRVTHdZUFlp?=
 =?utf-8?B?VDhvNGgzZnl0b2ZPcVBONFZRaGtuaWRFLzBoQlNuaEhYY0ZVaW1RVXlJUVZ6?=
 =?utf-8?B?ZllTR3dqa29QTlZIUlNKSmVJakdtOE1uQlNCZ01ZNWhWOVZ3Tk5nWjRLcnJU?=
 =?utf-8?B?eDN4OFNsUWxQei83NHFUWTFDcUdac3ZGN3RyT29wMVQwUkk4SHdWRmh1V1Ex?=
 =?utf-8?B?dGNpK0FaT3FhSVRsZnR2djZvcTZtL0dkSFE4OThzdW1nU2JYZ01hajd5UHBP?=
 =?utf-8?B?MVp6bEVHa3Z2S3NMOGNMUVJsTUptNzU3SWhRSGFobk5aN0xoeTEyWVVITkY0?=
 =?utf-8?B?cWk3M2FMVE8xZ3NnMmx2WEEyZGlZZ0VWVFhvbWVqRFVMMG9MNVdhbEZXQWlE?=
 =?utf-8?B?ZklWdnd3bkpKODczSnpuLy9YOVluU2o1QmFxMEJid0NURDVpdW5YVXZDd0hI?=
 =?utf-8?B?d3N3OXcrTEJBUElwUzUxQURhWjA1YTcxSHdQRUZBSFhZOVc0NGZjdW85TUky?=
 =?utf-8?B?T3JiQzRVMFBtK2lXTk9uZFlMc3pmSmRnYm5QWHV6NmJSWFZDa2FTNW9oZGFK?=
 =?utf-8?B?WDNjY1NWVDdBSmN3ZE42R0dqbndEcVN1bkNuelJERDFwMkxJb0RVajEvVnRW?=
 =?utf-8?B?QmFHNFprS01UeTBic1lhK0treXE0b1ZXUGZ2ZmZnZEVEWCtyZWlZVDRITFpR?=
 =?utf-8?B?Wk5GUDZ5a1pPb3BScnNHcjdxQXAvUGZzSUcyNUl0ZzV2NjBxemVUazdTYmwz?=
 =?utf-8?B?Ti96bHhPbXFhWmhCbGNVUTNibGNEYUxaeGVLQ0dneXpOZHBIMU1lQS9WYUVv?=
 =?utf-8?B?Nk4wUlB5aVFxRFZzU2RPR01BcC9IaEpwcGNiMDlFYUY5aTNTMzgvOWM4NFZk?=
 =?utf-8?B?dzZLMW8xNlE2M2U0WDl3d0tqMC9Na1pvbElvcGtYY1lIYSt2Qmh1TWFVZ2FF?=
 =?utf-8?B?V2NLOER1ZjFBT1NmTmRKZi9UWEUzbWNmR2FlZFVlc1pFV0dxdDg4d1NBQzJq?=
 =?utf-8?B?VkU5Z0tlSlN4ZWFYSWJZQmRxVGtxSC9YNXFrZzJ1ZDRPbmhCa1VSbm8vcDRV?=
 =?utf-8?B?SDV5citaejdVU0hOMndMME9NeEkvb2V1LzBmbjRYNUxSdW1DV2VOOFQ0YkZC?=
 =?utf-8?B?RTRlYTFBN2x2dWxZbDFET0ZmME53Rm9ic1I0QXJRcUE0Z01DOXNWTkcxVkVn?=
 =?utf-8?B?WkZadG5nSitwWjMrRDBQcG04NDczVVIzckUxWHpQazNmL2JYUWlZNWZnMXBN?=
 =?utf-8?B?VmQ0L29pSDdiN1dyR3k2czVQcHVFNUljQ1ZORkZ6cTNPVWxiYWU1SG9zQ3Bu?=
 =?utf-8?B?V2lONGZJa3RESS9PdmgwRkx4WGtmUmhWSUhYci9JckNHY0JSVXd4NW9MTmhs?=
 =?utf-8?B?L0tYRDIrWExNMHdpTFdXYWNWbStSLysreEJ2dU5MMHE1NFUza3p3NUFaNWY4?=
 =?utf-8?B?eWl1Nm9qQzJyWU9ESWx6cWlGTmZZR3BDQ1dwWHdNRmhmNzQwVzM0Vy8rVGdo?=
 =?utf-8?B?QnkzaTNYVnExNjA0eTNtUmI2eHMyN1dtZEY5eU1DWlI1THNXTDlVSmNpajds?=
 =?utf-8?B?UU5WaG1DcWlBNjd5Yk53Wk9PZ3FLcWNwc1FPQjc3dHlFK2FkVDMrZS91S2Vs?=
 =?utf-8?B?RThmQjliZEtSRGkraDhEeU8yM2xZeFczMDZKVlZZcEk5QkhydDhoazUvYjV4?=
 =?utf-8?B?THlmbytGbERzVHFKZm0ybFhkMldtSlNTOGlkNFU0ZzA3TXNuRmFTU1BwSWFx?=
 =?utf-8?B?Um1Cekg4ekJvblY2andLWm1ybklSREUwdkdDOTN0dDJpL2V5TzMxOEdVNWE4?=
 =?utf-8?B?cElTWVUwTnQxU0ZqVDJsRWNFSFNXRVFIVmpJUU1lRFE5Q2hKdkNOR3NvUWpa?=
 =?utf-8?B?bzlQeVVmZWZBSnptUXFSLzZrZlZGRXZuQitxNDFPcW5RWnVoeUxiUnVPdnNr?=
 =?utf-8?Q?jBeANUPnMhx3LXH52v2XQPs=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 495e0ee8-69b8-4c01-a688-08d997ff6330
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 21:35:38.8222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1t69Z/BbptTxwHwpNgysUhsRG9JlaLk41OantpatvmMrYBjLJU+p837Frzs2XZItoJw1+6E0ExkFSLQin1exvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6762
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On 10/25/21 5:19 PM, Russell King (Oracle) wrote:
> On Mon, Oct 25, 2021 at 01:24:05PM -0400, Sean Anderson wrote:
>> There were several cases where validate() would return bogus supported
>> modes with unusual combinations of interfaces and capabilities. For
>> example, if state->interface was 10GBASER and the macb had HIGH_SPEED
>> and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
>> another case, SGMII could be enabled even if the mac was not a GEM
>> (despite this being checked for later on in mac_config()). These
>> inconsistencies make it difficult to refactor this function cleanly.
>>
>> This attempts to address these by reusing the same conditions used to
>> decide whether to return early when setting mode bits. The logic is
>> pretty messy, but this preserves the existing logic where possible.
>>
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>>
>> Changes in v4:
>> - Drop cleanup patch
>>
>> Changes in v3:
>> - Order bugfix patch first
>>
>> Changes in v2:
>> - New
>>
>>  drivers/net/ethernet/cadence/macb_main.c | 59 +++++++++++++++++-------
>>  1 file changed, 42 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>> index 309371abfe23..40bd5a069368 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -510,11 +510,16 @@ static void macb_validate(struct phylink_config *config,
>>  			  unsigned long *supported,
>>  			  struct phylink_link_state *state)
>>  {
>> +	bool have_1g = true, have_10g = true;
>>  	struct net_device *ndev = to_net_dev(config->dev);
>>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>
> I think DaveM would ask for this to be reverse-christmas-tree, so the
> new bool should be here.

Ah, I wasn't aware that there was another variable-ordering style in use for net.

>>  	struct macb *bp = netdev_priv(ndev);
>>
>> -	/* We only support MII, RMII, GMII, RGMII & SGMII. */
>> +	/* There are three major types of interfaces we support:
>> +	 * - (R)MII supporting 10/100 Mbit/s
>> +	 * - GMII, RGMII, and SGMII supporting 10/100/1000 Mbit/s
>> +	 * - 10GBASER supporting 10 Gbit/s only
>> +	 */
>>  	if (state->interface != PHY_INTERFACE_MODE_NA &&
>>  	    state->interface != PHY_INTERFACE_MODE_MII &&
>>  	    state->interface != PHY_INTERFACE_MODE_RMII &&
>> @@ -526,27 +531,48 @@ static void macb_validate(struct phylink_config *config,
>>  		return;
>>  	}
>>
>> -	if (!macb_is_gem(bp) &&
>> -	    (state->interface == PHY_INTERFACE_MODE_GMII ||
>> -	     phy_interface_mode_is_rgmii(state->interface))) {
>> -		linkmode_zero(supported);
>> -		return;
>> +	/* For 1G and up we must have both have a GEM and GIGABIT_MODE */
>> +	if (!macb_is_gem(bp) ||
>> +	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
>> +		if (state->interface == PHY_INTERFACE_MODE_GMII ||
>> +		    phy_interface_mode_is_rgmii(state->interface) ||
>> +		    state->interface == PHY_INTERFACE_MODE_SGMII ||
>> +		    state->interface == PHY_INTERFACE_MODE_10GBASER) {
>> +			linkmode_zero(supported);
>> +			return;
>> +		} else if (state->interface == PHY_INTERFACE_MODE_NA) {
>> +			have_1g = false;
>> +			have_10g = false;
>> +		}
>>  	}
>
> Would it make more sense to do:
>
> 	bool have_1g = false, have_10g = false;
>
> 	if (macb_is_gem(bp) &&
> 	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
> 		if (bp->caps & MACB_CAPS_PCS)
> 			have_1g = true;
> 		if (bp->caps & MACB_CAPS_HIGH_SPEED)
> 			have_10g = true;
> 	}
>
> 	switch (state->interface) {
> 	case PHY_INTERFACE_MODE_NA:
> 	case PHY_INTERFACE_MODE_MII:
> 	case PHY_INTERFACE_MODE_RMII:
> 		break;
>
> 	case PHY_INTERFACE_MODE_GMII:
> 	case PHY_INTERFACE_MODE_RGMII:
> 	case PHY_INTERFACE_MODE_RGMII_ID:
> 	case PHY_INTERFACE_MODE_RGMII_RXID:
> 	case PHY_INTERFACE_MODE_RGMII_TXID:
> 	case PHY_INTERFACE_MODE_SGMII:
> 		if (!have_1g) {
> 			linkmode_zero(supported);
> 			return;
> 		}
> 		break;
>
> 	case PHY_INTERFACE_MODE_10GBASER:
> 		if (!have_10g) {
> 			linkmode_zero(supported);
> 			return;
> 		}
> 		break;
>
> 	default:
> 		linkmode_zero(supported);
> 		return;
> 	}
>
> This uses positive logic to derive have_1g and have_10g, and then uses
> the switch statement to validate against those. Would the above result
> in more understandable code?

I experimented with something like the above, but I wasn't able to
express it cleanly. I think what you have would work nicely.

--Sean
