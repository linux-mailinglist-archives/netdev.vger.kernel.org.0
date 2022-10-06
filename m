Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9C65F6A06
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 16:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiJFOst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 10:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiJFOsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 10:48:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C25B40CF
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 07:47:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6VUyhoHPR5XAJX0aPLpJxlm9pIXOof5Cgk0/sh0x9TmudEwJJwGL5nrdQ+npDu8TOBj6oiJKsb3Zpu1hfCOiQxzShniBAzsAuNMfEDNWxuvQ6f8BDPiXhFtM+TxtBZopwMtOuUuO2a3ZiULd0VNz3+v74k0BIRJq88GrZQufl2rR4295djL0w7Zak6ppaceXxfM8DSR5K0MEZzhgzDuYiArJ9x5vBhL380TwPcHSXZhsu3AWuaPU64iC6Cwqw/06IPV8FL1/o9pX2pbEu8NAo83yymAB8U92E/KRLMSh6y1UjQxWkN9ZO52EGlKIWX8e8Wuvxzfkk9HBFaIBJbgiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RT65eTBV9MIZ2pnmDFCv9C3uRAG3FvqTCBxg8U4EFw=;
 b=Xvhy6/8HvF8ZOFcln2S0UiJJ4JSCrHlQCmopfnxAc9uCXOz8DKZquwLF46YsTOG1MQ4YUzcfsyOOcByuhmdPL/QF5gM0IkZAEFlam3A07SJIwizF+j2xe6vZ4VuH6lj/24mIcsU2Vr4+ihvPYkyEhd7Hm/NzmDOJbg/5Yasy7XP2l7x6VYss9CgVyqmQsPRnqiqz56yTQ3Ax5kkc3m2VcLOJVd30BcyliyuKOq/7Cs1BpdTJZh5T+4gcedpWdwpv2P3EWMCRIhpEJt5FuCgqlF78z3Ji2sWn3wSrxhgHnocv0IFjpG2Ep+jhoXriBaMCaGugLok+6USxa99onbvR8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RT65eTBV9MIZ2pnmDFCv9C3uRAG3FvqTCBxg8U4EFw=;
 b=cyF80kj03j5X1Wu/Wzh8YdYt9FTYxCLU1bYeIaet3nngfL/3tq3SUKO62Im5lXrMQ3hbeHPX1Z6aMMILzqpo/bTChCIOQn47/v2YVcWgb6IrHqG5hu1CPLkFnofKL0s6pKV0KHfX1BIF39GlFNMjH8ck7pOUbbIj30pR+VXqYhw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH0PR12MB5105.namprd12.prod.outlook.com (2603:10b6:610:bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 14:47:46 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396%4]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 14:47:46 +0000
Message-ID: <88a61eba-a779-96ae-8210-d31e73ed73a1@amd.com>
Date:   Thu, 6 Oct 2022 09:47:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net 2/3] amd-xgbe: enable PLL_CTL for fixed PHY modes only
Content-Language: en-US
To:     Raju Rangoju <Raju.Rangoju@amd.com>, Shyam-sundar.S-k@amd.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, rrangoju@amd.com
References: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
 <20221006135440.3680563-3-Raju.Rangoju@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221006135440.3680563-3-Raju.Rangoju@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P223CA0003.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::15) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH0PR12MB5105:EE_
X-MS-Office365-Filtering-Correlation-Id: b7d449d5-803f-4bf6-a87b-08daa7a9bb8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkpkwxD6/lsGE8Y+YOMvdfDh3YF2z++YTMZE/izuidXezh5GV9YcI/2mi5lY9KpHfnqcssPZXHGXLe67cQtaslmrMigyYSX8hsivDYTLE3vp9ANgSN4YCPRm1J+HSG8+T9iPWn49myMALZDRRK27Uv252lphDKOHgzBj7Lnl3NTKA9XDLQcPioiKKuKlY5HZLmHZQHUspmUjWraB7XCdpszeYZoi2s5QtyVsYnYR0DSjDErv22DVJXlBJznZRjVwHh5hR7zj3YVbPtuRE9CaqsB/civ2QVzFqK0PpuaQJoBE7K3zoDsEacRSKQBYojfxOjJO93HETZfwQa4jeZwvtEzQs12pgE8PGC00bQdIhmrfhmny1xbO7214jLzyXtRQhSMC6KIwWMb3wWEqbSw2j9vPFdmRvGfeXhcLUEDzvF3+3VHTozS+o/abrHni0JkjCA+mLlNsbyQt/doBbHeuhGT8AniCdHoOpv08+VegemMu9Wt3l1vyfy3XQzRzGbxsvtcUB/O9haHMsjKlPTxYHpTYWMNTzX9v/B1XbPQsfbCjitQLFd4Jq7M/dVRWdjL7YQpxlNNPP6OXcl7Xvinx3gOBIydQSb88qREH2vzNME8HanGe5GJWg6H8/4YgWXSZzfdbWSge3FAiJy3NHM30xNbHlJ8p66cTb7PEiO8yq0k5U8e1Oed+VOUjb97vbZNPEXUhxpep9YD/RgLO/0/c7sJHoCpgaDAdWZKVgi0F0t80URbrmazrrm/vKmDJ7l4dMNRR7/KesaU3L9xrQDa+tRHsVhWsJT+SS/088xOG6OE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199015)(86362001)(6486002)(31696002)(478600001)(316002)(6506007)(53546011)(8676002)(26005)(6512007)(66556008)(66476007)(66946007)(41300700001)(8936002)(31686004)(83380400001)(2906002)(4326008)(2616005)(5660300002)(36756003)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MU1oNzZ3QlFmV09MQm42R1NIN1M5aXYwRHQxWjYrdWhlTlRiUUNPWTVlZU14?=
 =?utf-8?B?Nk1VV0l0d0xqelRjRmNFcHplUDBiMEFETXgvV0VTLzR6QkZ2U1NPYXJRTWo5?=
 =?utf-8?B?Y2x5SEorNk54ZGpiQ2lwdFpVTlRyTzdXb2J0NW1GV0VLbnczcDcwV1FVZUdM?=
 =?utf-8?B?MFh4THQwT0cxVDVLZXVIRUovN0dYSkpuQWt3T1E4TjV4SGNrRDhtSytmVzZi?=
 =?utf-8?B?UEdUdkRTOWJKOEFUMldFaW5BWVBNVDBPdWxUN3J2eDk1ME4vZTVtSHZuSGQr?=
 =?utf-8?B?RU1ZcEQzbDdlbktVM216QVJ4OHFHT1BqdGYwZUpqNXFXbnBxMjlkNm0xeDVU?=
 =?utf-8?B?Nm1rYnNyTEZCbEplRDFtUjQ0MW9SbTJwYnRVSWdZVi80aHErTUFQNTgrMGMy?=
 =?utf-8?B?TUNXQk5QM1VDKzlZbzVpUy93RVBuMXEzMzB2eldkb2ZmUFJBQ3JueTRQZCtl?=
 =?utf-8?B?M1ZWcG9DS0prYVFnZjVOUUx1MnNTb3V1RmR6NlVRVU1BNFNEL0ZoU3VMNWhL?=
 =?utf-8?B?bnpjOEp2ZkpDSlVaRlh2clVRakx6ZXprS09MazlpMmhDc2NmN3U3OC9tL3g4?=
 =?utf-8?B?djVqR3ozdkVLdHlTcE80ZHhmanAwNjI5VVVVTEdTcms3NC9PSzV1ZlpiUjhz?=
 =?utf-8?B?dDZNdFBSeE5NczdJUnlJbFd5N3BmWlZ1aGxOaGt2T1IzM1VCa1poRi85Rkx3?=
 =?utf-8?B?YWhMYnhrbExIVU9xdXRyQU9HazN2UUIzT21FMU40dVRhbHBaOWZnc1FWVFlF?=
 =?utf-8?B?UUxhTENRallwMUJjdHNaYWZCMVpWRlVzaHN1ZXZaWXRqN09maGpwZ0hFUlBh?=
 =?utf-8?B?SFhlaGE1cFVWMmhRVUNUZU1QOXdlaTdMN0w3VlFQNEVvZjBCZVY0YUUzTE81?=
 =?utf-8?B?eTF6REdsS2cyRHJZUmVrbGpCWm51RXoxMUMwWU5tVG1pUTFFK0Z0QmdtaXA4?=
 =?utf-8?B?VUpBQ1FmUCs0dGF3OXEraFhqTnBtYnhPdTg1U0RRK1RveDJrSW1qQlM2QXZt?=
 =?utf-8?B?cmlPZEhqaXVUSnZmRzREMTFhUWRsb0x5UlRXUlozRVBiWklMSFV4ejJ5UGFh?=
 =?utf-8?B?YThNME1NOTE1b3hpdlNtVVJBNHZ1R2RBUDhVakpVbzlKSnZ4bHF4QTdjUkN1?=
 =?utf-8?B?TFpZT3hNYlRXeGI2ZWg4SFN5NExRa2ZMdUh1WitvS2hmWTJSdDl6Rm14cWFB?=
 =?utf-8?B?YUZOTGh4MS9BWFFwcTRXdUNFK0QwQVZDRHVKMmc4Y1lsaFFvTitQRithSUZx?=
 =?utf-8?B?cmk0cS9zWHM1MDB0L3poNTNoYVdYY0krNDlVUGlpaVRmako2aytlREkwQ25S?=
 =?utf-8?B?MnFVVzJ1VWxWYjJLL3lQRU53SmZ0RC90SEFodnVVbU9WOENFUndENExwckFo?=
 =?utf-8?B?YnFpbGIvK0EvVDBMRk5Yajg4UXdxQTNFSkJ6RGJsZk90cm56S2FtUC81QnM5?=
 =?utf-8?B?VDBCcmtGT1lNeEo5eDB2a1pEcmZraU9nelpBTk9YSFUwdDJ1RGhFaDNaTDdu?=
 =?utf-8?B?bkNqRnZCVWZJSko4T1NkSnJaWXgzUnRmWklDYkM2Z0dxU0JPRjRaSUZFbDlx?=
 =?utf-8?B?c1M1RDJKdFM5WTNOQmR2Q0JyUkw4T2orZVA4VUoyR0lYZWhoM3I5SldhNHR3?=
 =?utf-8?B?N0dUUnRWbm95eGlSWVlXUVRsOWpvL1hxSzhZUHJHRUpta1ZEUDhNbDJGb1I5?=
 =?utf-8?B?K0VUNGdUVHBXSEVycElxWVNGclI0Vk9zZUZyQUFiaUJqNlBzQlhlOW5NTWh2?=
 =?utf-8?B?QlVUNUxhT0J5ZXNSUFZ0M29hazh1eTBZdy9veDlJcFFZV1ozY21kanJPczNU?=
 =?utf-8?B?Si9WUmNYRytlUmVIL1gwb1dLWUE5UmU0ZDVBKzU4Y3ppNTdJaU9lbjF1eEd3?=
 =?utf-8?B?dElCK1gxMHVyQ3RmYTJSWUR4NnVadk1SZ1c3SWJLZjlFQ1NkNGlGZkQ5OHli?=
 =?utf-8?B?bUVsZXRWaFZwVjEwM3p6WFdKSmlTMm5RbVZ2QjV3TEFzdXk0SDI2dVFLSS9m?=
 =?utf-8?B?b0pwbVpqeThpZFo1ZElVRmQwOTJCM1BrYXBVaU05SFd4RW1DT094S2xNRjJp?=
 =?utf-8?B?VDhSWHcvL0FNUnVQM0l2aXQ2TkI1bnBuZ1VMc3Vtci8rV240Q1dPb2FrWDZr?=
 =?utf-8?Q?90ai6iT609xrGlyKgdn4sS2q+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7d449d5-803f-4bf6-a87b-08daa7a9bb8e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 14:47:46.5440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzXOaxfeUmptrtfKkzt1yOeP3PzuFk/mJegnXqgWi1raKYCazzGzmJ76o2kX7/0B6MEuaYFZZaCWNgx1PROCsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5105
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
> PLL control setting(HW RRCM) is needed only in fixed PHY configuration
> to fix the peer-peer issues. Without the PLL control setting, the link
> up takes longer time in a fixed phy configuration.
> 
> Driver implements SW RRCM for Autoneg On configuration, hence PLL
> control setting (HW RRCM) is not needed for AN On configuration, and
> can be skipped.
> 
> Also, PLL re-initialization is not needed for PHY Power Off and RRCM
> commands. Otherwise, they lead to mailbox errors. Added the changes
> accordingly.
> 
> Fixes: daf182d360e5 ("net: amd-xgbe: Toggle PLL settings during rate change")
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 21 +++++++++++++--------
>   drivers/net/ethernet/amd/xgbe/xgbe.h        | 10 ++++++++++
>   2 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 19b943eba560..23fbd89a29df 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -1979,13 +1979,16 @@ static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
>   
>   static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
>   {
> -	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
> -			 XGBE_PMA_PLL_CTRL_MASK,
> -			 enable ? XGBE_PMA_PLL_CTRL_ENABLE
> -				: XGBE_PMA_PLL_CTRL_DISABLE);
> +	/* PLL_CTRL feature needs to be enabled for fixed PHY modes (Non-Autoneg) only */
> +	if (pdata->phy.autoneg == AUTONEG_DISABLE) {
> +		XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
> +				 XGBE_PMA_PLL_CTRL_MASK,
> +				 enable ? XGBE_PMA_PLL_CTRL_ENABLE
> +					: XGBE_PMA_PLL_CTRL_DISABLE);
>   
> -	/* Wait for command to complete */
> -	usleep_range(100, 200);
> +		/* Wait for command to complete */
> +		usleep_range(100, 200);
> +	}

Rather than indent all this, just add an if that returns at the beginning
of the function, e.g.:

	/* PLL_CTRL feature needs to be enabled for fixed PHY modes (Non-Autoneg) only */
	if (pdata->phy.autoneg != AUTONEG_DISABLE)
		return;

Now a general question... is this going to force Autoneg ON to end up
always going through the RRC path now where it may not have before? In
other words, there's now an auto-negotiation delay?

>   }
>   
>   static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
> @@ -2029,8 +2032,10 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>   	xgbe_phy_rx_reset(pdata);
>   
>   reenable_pll:
> -	/* Enable PLL re-initialization */
> -	xgbe_phy_pll_ctrl(pdata, true);
> +	/* Enable PLL re-initialization, not needed for PHY Power Off cmd */

Comment should also include the RRC command...

> +	if (cmd != XGBE_MAILBOX_CMD_POWER_OFF &&
> +	    cmd != XGBE_MAILBOX_CMD_RRCM)
> +		xgbe_phy_pll_ctrl(pdata, true);
>   }
>   
>   static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
> index 49d23abce73d..c7865681790c 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe.h
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
> @@ -611,6 +611,16 @@ enum xgbe_mdio_mode {
>   	XGBE_MDIO_MODE_CL45,
>   };
>   
> +enum XGBE_MAILBOX_CMD {
> +	XGBE_MAILBOX_CMD_POWER_OFF	= 0,
> +	XGBE_MAILBOX_CMD_SET_1G		= 1,
> +	XGBE_MAILBOX_CMD_SET_2_5G	= 2,
> +	XGBE_MAILBOX_CMD_SET_10G_SFI	= 3,
> +	XGBE_MAILBOX_CMD_SET_10G_KR	= 4,
> +	XGBE_MAILBOX_CMD_RRCM		= 5,
> +	XGBE_MAILBOX_CMD_UNKNOWN	= 6
> +};

If you're going to add an enum for the commands, then you should apply
them everywhere. Creating this enum and updating all the command locations
should be a pre-patch to this patch.

Thanks,
Tom

> +
>   struct xgbe_phy {
>   	struct ethtool_link_ksettings lks;
>   
