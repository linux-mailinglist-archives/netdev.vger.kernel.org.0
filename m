Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5E7605011
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiJSTB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiJSTBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:01:24 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F86F19DD8B
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:01:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZR6D6aYb75WliCiv3VTVi3e8wbHNKHrzWCGL5J5f4zJOqG2fIWz5MJl2O1wiun3pzeoXsSssysfbigfxoGkPWXNrsH5XUcnZTXImDEfvWLnOGLcjRtitrIYCrjfbbjCfvJfOHdiTax1IMP5I0uz+JRJHqRHvnsulLTWXsBUSBJ3GlBWEfojKJfoCZQIOu5hsd/AsheG0laSGSwAVf1oqbIpGhtZJejLByzz6ABwlf5eCYH2OY85no9u5GMCvyOSavkW8+IzZUR23Aw318R2N94o3CZG8iMLlbObY1I217DX9+iqQy58WTmmZ0iDgx5b+D14vpk0VMt5PiiBch26sLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=es90vn2p13sZzygGmqWVOkwy+VwAbyjXEK0N0uiiin8=;
 b=PAwdYT0CyaJC5IFUhONEWx6obdVW+apFj684aZ47M5s/jS5rKXLw6SDNn1maer16vx6zDezJ4r5txgOwsLy5zkl15C6lp5K9+fsIb9IJrVu7baHNkzG1eXrL65sYfpdI4Df+cqPpXltINty2ix40IWyyussPnbfqNohzrfBdj/j1Kb90hft8LHozb/cMSp5JZgM0tTjYy/e2fyxADEiYntAVkhj+KEkvj909YBTrczWcavVYMYLV+1TMJatPzITLktO2wUPWxARuyzHmtB9kjdEvSUwJb/266zWvNevdIr42UX41ENzvKKp3z+P0Ps36ArbeZrAuhRUNDoLhSfmCZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=es90vn2p13sZzygGmqWVOkwy+VwAbyjXEK0N0uiiin8=;
 b=U+ZiR5qHi/FFyxmDhKx7gwLthc7ngIPzXa74SwQWpKxBJ6fBo5+53n4wYMmxUoSriS57x8Iv4YdM53mXe7k3f7zIMBdQzbHN81eQNLEWwtVeif20MqU0Hp2LJPxD/TIRJR7WCvDhwquu/WvE0zpQiW8vuIUWQFGWBzX5rUJWdaA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS7PR12MB6262.namprd12.prod.outlook.com (2603:10b6:8:96::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.32; Wed, 19 Oct 2022 19:01:21 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 19:01:21 +0000
Message-ID: <8f2e65d0-61b3-f6a9-084b-4c5c0ab1ccd1@amd.com>
Date:   Wed, 19 Oct 2022 14:01:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 net 3/5] amd-xgbe: enable PLL_CTL for fixed PHY modes
 only
Content-Language: en-US
To:     Raju Rangoju <Raju.Rangoju@amd.com>, davem@davemloft.net,
        kuba@kernel.org, Shyam-sundar.S-k@amd.com
Cc:     netdev@vger.kernel.org, rajesh1.kumar@amd.com
References: <20221019182021.2334783-1-Raju.Rangoju@amd.com>
 <20221019182021.2334783-4-Raju.Rangoju@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221019182021.2334783-4-Raju.Rangoju@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR1501CA0021.namprd15.prod.outlook.com
 (2603:10b6:207:17::34) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS7PR12MB6262:EE_
X-MS-Office365-Filtering-Correlation-Id: e53df7d5-c11f-49d2-54ea-08dab2044f44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +BUYYyL6tx+9AQwnsQ0CvB/4hS/6NmgNpfM8KxgMa0eL/rUWzKv/zNNTR3AOWVtQHg6S9CG1xA0QaSy21DZY8zIs9jgRSn8CtcWKhzgdYut8jTjAOD6RrPIOulCZyuLwe/Dw5N3quJUsJ5Oq44E3mwQeRsgadS21ykeQSQU1syKRtvgMjo8pL+zliRljq0idvSMjkFsIckUoN95ZORJFmvkdscmj2Df02W1nw/4lo+AtsWB9TXMVcAYGpSVdj81snbzJaLF2RhqnGyroFYPorAeLV0HJYLmg2/orqsCcKKRQckpZWOyhffkU1S/uJMz9DKyZfm0O8DWsRJmVhfwB8IcaMjylDoGUspqvSoWUcovBVT2bUnNfmujtwj6QMH1/ejJBgl0HWnAbGjUCmbBGyPwB4LZvUFvUKFg+Kd9M4oo3EHOeSvLsWcHl7zJ6KpXiVC2U64COZ2mItiFixD92uCYfm+Q1e1uucnZnRRF8f3oDnfgDKmofjzBHYVI7iVzaLfQX8p4UD1Eea/iFb62xQP2vGoSHvHLQn+m8w5AF6cdzFV8onW0GzOih8gbb6LvdMGWj/B+M3hKiL4topn7dmuHKCjxtVLauxa+ONeEcBZTdW5X+jil8iB+HPz8HxVgAsNEqNMeQs72HdAH83RkJt7RSdyPcx0spzyxufwwNQkls0mlqcRMqL8UVZz5zzMC3Wx8YwH1MWeyisiiymWPPzoETqpCxZ4O8hNsgWjjUBnMaTBOv2sNurYs+4sVJkepvwVUHcmzbHAKVix27Jpb9hotyAYd0wpHahm3yahPhoW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199015)(36756003)(31686004)(31696002)(86362001)(38100700002)(2906002)(2616005)(5660300002)(186003)(6486002)(6636002)(83380400001)(26005)(6506007)(316002)(66476007)(478600001)(6512007)(53546011)(66556008)(66946007)(6666004)(8936002)(4326008)(41300700001)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b056TWlidjB2U3M5dThDNldDMkNpbFRtMFAybDhlUWk0WjhPWWVzdlpjNDlV?=
 =?utf-8?B?SjJBNDlKZ3kxcmw0RUwwMzVWOHJQUDVIbzJSVis5WGFyQlpTVCtSY21xS0lY?=
 =?utf-8?B?OEdTaitUVTZYSmpCbmUzT0FmSk8vMTFodDlUZ25kVzdXU2V6dUxTWmIzOFRu?=
 =?utf-8?B?aGRRRUEvNjNPaTZyaExFbFpLUmRtWVNUS2MvekhMdWJoZE9tMFk1L21lVWhr?=
 =?utf-8?B?enNMR01vNWdhSlVEV0lnYTQxSXZUMjM4emgrWDV3NDdKSzJ5d09JeGpETkVJ?=
 =?utf-8?B?bmM5QXpoK2xlYzRHRG0rdkpvVUxNNDdaQVN3b2J4YkJHNnlmekt1TnBrR0xO?=
 =?utf-8?B?aEUzUm1RV1JCRXF1eHllUGJiOS9Talg5L2dzSVVaZWF6bkVLbTlmc3JmVSt4?=
 =?utf-8?B?WEczUHV0ZnVnTisrZlozZGE1ZCtPRXU0NnI0bzU5NHR3RFN0eXl0KzBKTVJr?=
 =?utf-8?B?dHBDeitiV1pGVzBUQytaSllmOGhPYTJqbk1NSTNNdytRUkpzNm40UE4yQ0JL?=
 =?utf-8?B?N2puUElMbjdpb0xmS2ZXNFNVMjZVVldjVG1uUzlkSlJBdWNweGladlRjTWI4?=
 =?utf-8?B?Q1o4RHAzQWQ2ZjZlcytTdUV0QVgrTG9Db2NQTytlN0pmTStoemZjVEdxanl6?=
 =?utf-8?B?WGs2amdTT1VKSnA1K3c5c3U2aUJXQkhiVUVVc29kUW5ON0gwN05aVllud2U4?=
 =?utf-8?B?azA4NndSUFFNKzFmcGJQclFRVnpMdUdxYWFLbzA4YjFvREVKY0txb3VlbVVJ?=
 =?utf-8?B?ZjNuZ2lZS0xxWXl4cG5LcEZaekxRV1E0VDgvdm5vUU9QUHZjbkRhcGFmYkJT?=
 =?utf-8?B?TG95K09BMSttcW1uVWF5eXh6REloTkJlSCtJZEhrc1ArbTYxN0xra3R2djRZ?=
 =?utf-8?B?UnBkcDkySDBvQm8yb3VwWDltVE1SM05rTEtTV01pS3VmYk45TUdndXJ2cVJ2?=
 =?utf-8?B?R09wV09RUjJlVXk4anhCRWRMN1hOUHhROVFtQ3lwaU5wbWVqM000VE5MTng5?=
 =?utf-8?B?bmtXU1BhV1IrUDdLY3JWakRmaHRXdUQ2WXFxVjd3OG1KTlI3cGZmdVZJL25m?=
 =?utf-8?B?R3lLcnhYNGFyNVowWWJTYXdiQjgyN0pSLzJDQjgvdWVDNC9vYlNzcUtTRE9j?=
 =?utf-8?B?S2l0TDU1OWk0VnloMDFkeTJTRjZuS3luV0xmaVhjend2YVN1QnlDODZjMFdl?=
 =?utf-8?B?c0Y1Y2VwbFBpZWZQaDV6ckwreklmeDJzUFM0Lzlub2diRlRBUTNIYnphU0RU?=
 =?utf-8?B?RldIS2lDa25mWGZ1ZUw1M1lhaXhHRW9vMTJqbHJjR3RrR0ZZUEhPZEtEelNI?=
 =?utf-8?B?cFpqaWJYRCtSSi8yQlFvL3FxRmlNZlV2YWhKTW1saU5JMmtwVHlsRFZ6VDlh?=
 =?utf-8?B?TTlobkQ1ZS9GamtXckExMGw5VXh4VmRoRUkwZ0FJTUZCOHRtUUtteXdjWFJh?=
 =?utf-8?B?eUo0dGhaQ09jcTExSTIxYUUwSmlCbzFJTnBZVXl5TWEvY2pOYjA4ZzI4K2JB?=
 =?utf-8?B?UkRGaC9rVEpFUUM2N3lSZFJZSkxEMFlSdS9WdEJPRTFNSnNwNUREcFhHdmVW?=
 =?utf-8?B?d3dXYXhCYWV4VkdZZzA2a0d0bm5PdjZiaDJxY3QzZGMwUGcvV3NIWmZ4amcv?=
 =?utf-8?B?bGZtemRIalZWU1NjUnRybWY1VWtvZ29FMFp5TUcrQlFXN0hIVWFOQW4yR3lz?=
 =?utf-8?B?R2tvdmx0dW1hU2xNQnpwT1ZwMEFXbVlWeCtzQXJWdVlIcHJoemhZa3pIdCtT?=
 =?utf-8?B?UWlyTkU5azNmZlpGY1RHR3EzelJLMExOVndwYUxyREh4VUMxdUU0LzMxSXJM?=
 =?utf-8?B?ZkRSTEExN05MSWlKQWJsZFdrc2tzQ1VYcGEzeGZqYU5CQjBDbXVtL0xmM3Nu?=
 =?utf-8?B?Q2JpYSsxT2EzSkZGRVNndlFCSldLei9HWUhhRFVIL2pPaWN4cDFDbmkybW1N?=
 =?utf-8?B?ZXAydTRMakVWYjNtVmdSOTNkNVVYcHJ1S05rRXVZOUxKRE9uYkEwRmlqRFBz?=
 =?utf-8?B?QXhlaWpNeHJCc2xobGUraWF4UnY2OVNYWUlUM2lnWmNzbTFyamV6U25hdExs?=
 =?utf-8?B?RXdkMW1VdFRLb3htOXJNSzNxWkYxMjFlbDJtbEtVSmh2emJDcFd0dVNXR0Fy?=
 =?utf-8?Q?qbjpY/6HA1gKPNi//sLgiSmZB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e53df7d5-c11f-49d2-54ea-08dab2044f44
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 19:01:21.0056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jmu2TeUkzWgffPEzEK70dIFKiEqj72e/ua58e2c2iMlcQLFcrTIPYh3msLRMu9rTyJavY6303gWqsN24pnsmSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6262
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/22 13:20, Raju Rangoju wrote:
> PLL control setting(RRC) is needed only in fixed PHY configuration to
> fix the peer-peer issues. Without the PLL control setting, the link up
> takes longer time in a fixed phy configuration.
> 
> Driver implements SW RRC for Autoneg On configuration, hence PLL control
> setting (RRC) is not needed for AN On configuration, and can be skipped.
> 
> Also, PLL re-initialization is not needed for PHY Power Off and RRCM

s/RRCM/RRC/

> commands. Otherwise, they lead to mailbox errors. Added the changes
> accordingly.
> 
> Fixes: daf182d360e5 ("net: amd-xgbe: Toggle PLL settings during rate change")
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> ---
> Changes since v1:
> - used enums for all mailxbox command and subcommands, pre-patch to this
> contains the enum updates
> - updated the comment section to include RRC command
> - updated the commit message to use RRC instead of RRCM
> 
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 8cf5d81fca36..b9c65322248a 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -1979,6 +1979,10 @@ static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
>   
>   static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
>   {
> +	/* PLL_CTRL feature needs to be enabled for fixed PHY modes (Non-Autoneg) only */
> +	if (pdata->phy.autoneg != AUTONEG_DISABLE)
> +		return;
> +
>   	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
>   			 XGBE_PMA_PLL_CTRL_MASK,
>   			 enable ? XGBE_PMA_PLL_CTRL_ENABLE
> @@ -2029,8 +2033,10 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>   	xgbe_phy_rx_reset(pdata);
>   
>   reenable_pll:
> -	/* Enable PLL re-initialization */
> -	xgbe_phy_pll_ctrl(pdata, true);
> +	/* Enable PLL re-initialization, not needed for PHY Power Off and RRC cmds */
> +	if (cmd != XGBE_MAILBOX_CMD_POWER_OFF &&
> +	    cmd != XGBE_MAILBOX_CMD_RRCM)

XGBE_MAILBOX_CMD_RRCM isn't defined, so this patch won't build.

Thanks,
Tom

> +		xgbe_phy_pll_ctrl(pdata, true);
>   }
>   
>   static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
