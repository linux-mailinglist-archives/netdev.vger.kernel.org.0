Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C659F5F6A30
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 17:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiJFPAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 11:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiJFPAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 11:00:35 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364E2A9270
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 08:00:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRSqimZpOG1MsoIixJGVUr/0O9Ha0iEMgTB5M5cTSTqm+Q3aA2F5eId2Cgp4LAqNqmeGEdC2zfxqnRz2zVg4GjDPMOg+rclBIV95wftmXhfyC2ziMuMN60YrbeftVf2xZUWr0QBSqEPSRUPEx/owmvTJhACq7We3V7+V5PttMVpmJxDk1MMaN6Zad4mG0uEOjpUHSOUVYraDM4x9G7kJkQMHi7xKMQO4X5S3mnVHqIxoQh51IK721ZARuB6pmSeQNDu8X3BNLXfUWCrWya+z7cqrTYVHbI5OQ8NrB4Y9ivZHO7dd40wQoxmj2tfFU78cz5Y4vRLRpNQWI0ZGDq2Wxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZQ3VUL/RccI55QJTALKQEcHRUG0OIVGoa/OGgto2mg=;
 b=K02BZJp9j3AQq8+pFGGJlU4gCiB9ejr3KQYSs31y35MiSRcOxZwY3PNVlo9si9Dln2d1Z8jQiwEuXbng8Cfq28yZWMOdYyxA8ERLcSEDpXVxK/9QzIA6pSTlNALz+tSeDS0RqCdgYK/btZMLR4ssLpM+q/4WkmvuueYlxHG8s3wlZDQP79z/Xv15zUgJ8QksD3OVlHP7ZpKbx/wSlY19pU9q8ctxKm77wIj/if1SFcNyI6eENPf5Vy+w6NOVSxf7E20SOzRUaCx8J/+ZczxeC1xJNEFyualdP9V4OPmS6cGhTIlJzxJCoUYFErjyefsUGV3cri7o/HfHxgSPvmJ6ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZQ3VUL/RccI55QJTALKQEcHRUG0OIVGoa/OGgto2mg=;
 b=eo0AipDkneuhy3M2qFuFpYZs4nPpcJHVKec/W9BF0wHv9rY8N5E9/HfAi0ZQ/T+TP3q6z2Pf4wskATBam+Bqf9VyN5IkkbL27WoOZkqCoqa/c+MdbbAKaZNYFy2HDqXihuPwO7FXxSD9fEcpN13zWi71sfx1oGSDex53vx/HnOs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB6422.namprd12.prod.outlook.com (2603:10b6:8:b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.31; Thu, 6 Oct
 2022 15:00:29 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396%4]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 15:00:29 +0000
Message-ID: <d377d924-d205-cd25-e3d0-7521ed8a3ca1@amd.com>
Date:   Thu, 6 Oct 2022 10:00:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net 3/3] amd-xgbe: fix the SFP compliance codes check for
 DAC cables
Content-Language: en-US
To:     Raju Rangoju <Raju.Rangoju@amd.com>, Shyam-sundar.S-k@amd.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, rrangoju@amd.com
References: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
 <20221006135440.3680563-4-Raju.Rangoju@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221006135440.3680563-4-Raju.Rangoju@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR13CA0032.namprd13.prod.outlook.com
 (2603:10b6:208:160::45) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM4PR12MB6422:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c70cd12-6bf1-49dc-e7e4-08daa7ab8271
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKfQllITz7ORV8UWJSjicXciG9YHKA9DIp1kJhLJ/N43SKxKvWCt5nJOA1Tq6Ga3DJZqcxqkjJtORs9vqdCEtm1Fm1CGCI8PYqMtf339qlLFPd+u/Bb9u7UsunIgnRCxIRfWj36u9c9H68WWzEAV0FpzU1w3178pm6M7rCWBCL1pcyExoo+X2J2G3TSAriETXDKbPh4JYY3+581swfP8XIQ06VdTkx+lt+3RlDUo0y7rDVoVNpFlwZ2O9i7qIR2k3oBnPuNBpRjUyW0T74oAl88a8Rx0wKX/f9ChdwkBzAbk9geoCy0eeMG+tHU7JoNBC3bearnZXY+R73a41mX6afRSpYXAlAqTk94rkw0UenGGtOROt/fs7LtpGWBtBB620gWBfAjAgGGvMJvCVfRmOzzVMLmbiLDZCk2PuSYUsThnAF77HN07SsaeHFyi/coDx8NJQszQC/rLnnoTCZVdNvPtF3yNfSEXM3EUrUOLTxT2wy5Si5/dv32KOzgKCvBtF+z/O4fV/x00hbwmIiYfCZ1goP/AJ48fJKoyWHTkUfMFrb7G4BIc03tuFEz5iwLxAV90BbcNTmmB8w3Y/S0aFVBN+OzAM3LBOJYx2tC3a5SOiS1xEthUW+ZX8SgBHzSucmoqS3gAjVRkv7AUa3wZhuIqACJPZ5xf8JcWjaucGFpQqOwCuYkckzs2cYxgHnnpP0L3RhzRWl+/ly1DNXgT35NoHMxwD3qucGxKaVtHjhULWkRSn3kOJEiTX2UNbScHBqSUxQgtB5B/TYwxtcDTwp3aMTjKDZnYyun6KHcJk5s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199015)(31686004)(478600001)(6486002)(53546011)(6506007)(38100700002)(83380400001)(5660300002)(86362001)(36756003)(8936002)(31696002)(26005)(6512007)(186003)(2906002)(2616005)(41300700001)(66476007)(8676002)(66556008)(66946007)(4326008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHNaS3VJbGd5VXBZM1JGMUllUXZMYzFhWHNTdXpVTWJueUVhRzNZUlNlTTBR?=
 =?utf-8?B?aXVLMzNLTDJGNEM3N0JxNEU3NVhScHlNeWdWdTZ0WWpOaFJkUzN2b3kxNVhP?=
 =?utf-8?B?bXJNWGpEbG9sa25xZDhzcnJId0dtdzVhZExLdkJ0S2N3SXhiSWxCcTlJNjZC?=
 =?utf-8?B?VW80N2NOcVJlR3loNzROSm1WNnV4Yy93U2JzQnRjVnlnVzU2ZlcweElQT0lM?=
 =?utf-8?B?ZXVsSThMUHVnTDNQUll5aEhiTzhVdThob1c3UUQrUWdQbEplTkpHeE9RbCs0?=
 =?utf-8?B?Vm5BaG9CRlRSSHliWW1adE1xWkE1N2E4YkNFczBxYldsZUxUVGc0dkd5YUZx?=
 =?utf-8?B?b0ROMDJGSDg1ODlXTXdmNUNRWVl3dzNpOWZDakhCNGlkbXVza25hSGRRSUZW?=
 =?utf-8?B?L29Tang0aTFXcWU5WFBEbzJPNmtacHUwMmgyWjd5ZGt5Z2oyUmNhS25uRmNu?=
 =?utf-8?B?VjlKclhuYU16K1djdkRMZDZVK3UySnZEYmRyanM5dkV4R0poM0NMenhlQnhH?=
 =?utf-8?B?c0tFcG1ZWFFub2FJSGhvVTdZaWN1ckZtUW85VUxUcHRYZ0p6bDN5eVY4ODNJ?=
 =?utf-8?B?K3NuTTYxSGUrbGdjdjlhd1oraU5lY24rODFOMlV4cDVxNlV6WGZrSkxJK0R2?=
 =?utf-8?B?KzRBeTBEcm1HYlNDMTY5TmU0TXVBb0FuVzBMMXIrYXpGOFd6WHVsMEJ5ZjhF?=
 =?utf-8?B?dXg2QlQ1R3lRNXhCVHJ1dWZRcTExZDBiaFBNN3ErS05NQ0p2SDFjNDd4ampz?=
 =?utf-8?B?Tzl1cHoyR2hRM1ltWCtsbTMrTTlZeGpYdVRJY0FYUHpLRGpsRjBUVytSRlhq?=
 =?utf-8?B?a28zWVU0K1MwS0ZUOWVxOGpyWjlNNWZRYy8ybTNCSk1OS1E5WEdvNmVRdGRJ?=
 =?utf-8?B?bXFTdkN4OStKeDNPdVovN016U3hVTzdQbDdHMnh0OVRsTERZNXY1R2F4WGM4?=
 =?utf-8?B?NmpoWmNHQWRSbG5DNG5aSzZBYjVITTd2UklLRmc1bEMzOEFPYlRYQlB4K0Fn?=
 =?utf-8?B?UHFpNW5kTW8zcU83Qmd1cmhqYVFNZlRjOHpSQkRRS0ZIMFBEVkdPK1crd3NY?=
 =?utf-8?B?TldyK2o4RHJzTklpT3BhQ0NyL3NzOW1JZ3AwMEhRekdlNXR2NVVzY00rZXZz?=
 =?utf-8?B?eXRiKy9aZThPSlYzaWZnYlB3bEFodE9GaFc4Ukc5T3V1d3pnNVRRUS81Wm5u?=
 =?utf-8?B?MjhFd2gxNXc3allVWStFblMxUDNPTVl0bkh2QVpRQ2xOOWF2cHRHMUFjTGx2?=
 =?utf-8?B?cmdxbXVhaVo1S2lONkxWRWJvRjRiM2FhUVFsbk85Qm5HYjZlTTUyRDQvOVlr?=
 =?utf-8?B?aHNTTmVDNGtYbUwva2VBMVhJc21qSnU5U1lzOHRhUlJ2L2VCcjVJT0VYUm9R?=
 =?utf-8?B?QmEwdUp6UGphejNYRHdWTXRmUTNjaWY2Q0t6Qlh3amtTV01aTHNTVk43cjAw?=
 =?utf-8?B?UklPZzJkZXBwekhGRUZyb24xSzZ6NUd1U1ROT2gwR29LcE4zRmhJZ2dKNjdI?=
 =?utf-8?B?cktiTldTMDduNWhYRDBJemg3aHNBb2h6TnkzVFAzWmRNNzVQRHZyT24rMjFz?=
 =?utf-8?B?ZkQzVnR6KzM4RzVuZ0pRVVp6bjNwUm9VZlJHV0FuUGJjby9SLzRXNURDN0Z3?=
 =?utf-8?B?bWcrdWpqRHVQN054UnFRNHpIVERuNFh0MExrTVVURjBQclVCL0FDR2s3TEdp?=
 =?utf-8?B?LzlLd2VaSTZ1SHA2NWp4RXV1UkJSSEdmVXNENGgxYVY0TlJPdU5RNzRNN2Jh?=
 =?utf-8?B?R2F0ci95Y2Z2eG5vTUg0Uzhyb2xiL0NmdVNTckRqZmQ3dVp5cUVJMW54MW9B?=
 =?utf-8?B?cU5pdGwwWk9idXArYUd1aUl5TElEcUVOQTBOTmZWTHVYblZnZG1jL0F1UnR1?=
 =?utf-8?B?Z3pJOUduWmNOb1VlWFJucGFMT3NBVUpLZHl4TUZ0VE5vU0dLSkdVc0txbTJy?=
 =?utf-8?B?bHdCUUNnQ0lweE5ZY1NWdm54QVl1Y3FwbGswWjlFM25TUGJOTGRYSFNKRnkz?=
 =?utf-8?B?K0p5VEdHbTVFNHBVc3J2OG9ESkhxakkrR2tNeGdUQzVxL2t2SERPdFlJN1ZL?=
 =?utf-8?B?a3dTSUtSc1g2VXVsOEptN0xSalVma2lJNDRMNDB5NXQrS0RucEluRWNaWVhX?=
 =?utf-8?Q?XLrNQq8w4HNWsi2CXTTO9sFEk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c70cd12-6bf1-49dc-e7e4-08daa7ab8271
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 15:00:29.7189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: widuxgiZxt3cK1P06D667eg9WElv4+B9fD4FSSYa6I83UUdLx0o1zZ6C7GzMGSindkcVVJCdjGGdy4B9n6cz4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6422
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/22 08:54, Raju Rangoju wrote:
> The current XGBE code assumes that offset 3 and 6 of EEPROM SFP DAC
> (passive) cables are NULL. It also assumes the offset 12 is in the
> range 0x64 to 0x68. However, some of the cables (the 5 meter and 7 meter
> molex passive cables have non-zero data at offset 3 and 6, also a value
> 0x78 at offset 12. So, fix the sfp compliance codes check to ignore
> those offsets. Also extend the macro XGBE_SFP_BASE_BR_10GBE range to 0x78.

So are these cables going against the specification? Should they be quirks 
instead of changing the way code is currently operating? How many 
different cables have you found that do this?

Why would a passive cable be setting any bit other than passive in byte 3? 
Why would byte 6 also have a non-zero value?

As for the range, 0x78 puts the cable at 12gbps which kind of seems 
outside the normal range of what a 10gbps cable should be reporting.

I guess I'm not opposed to the ordering of the SFP checks (moving the 
passive check up as the first check), but the reasons seem odd, hence my 
question of whether this should be a quirk.

Thanks,
Tom

> 
> Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 23fbd89a29df..0387e691be68 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -238,7 +238,7 @@ enum xgbe_sfp_speed {
>   #define XGBE_SFP_BASE_BR_1GBE_MIN		0x0a
>   #define XGBE_SFP_BASE_BR_1GBE_MAX		0x0d
>   #define XGBE_SFP_BASE_BR_10GBE_MIN		0x64
> -#define XGBE_SFP_BASE_BR_10GBE_MAX		0x68
> +#define XGBE_SFP_BASE_BR_10GBE_MAX		0x78
>   
>   #define XGBE_SFP_BASE_CU_CABLE_LEN		18
>   
> @@ -1151,7 +1151,10 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
>   	}
>   
>   	/* Determine the type of SFP */
> -	if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
> +	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
> +	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
> +		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
> +	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
>   		phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
>   	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_LR)
>   		phy_data->sfp_base = XGBE_SFP_BASE_10000_LR;
> @@ -1167,9 +1170,6 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
>   		phy_data->sfp_base = XGBE_SFP_BASE_1000_CX;
>   	else if (sfp_base[XGBE_SFP_BASE_1GBE_CC] & XGBE_SFP_BASE_1GBE_CC_T)
>   		phy_data->sfp_base = XGBE_SFP_BASE_1000_T;
> -	else if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE) &&
> -		 xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
> -		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
>   
>   	switch (phy_data->sfp_base) {
>   	case XGBE_SFP_BASE_1000_T:
