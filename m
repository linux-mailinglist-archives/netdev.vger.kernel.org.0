Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEEA31A4A8
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBLSoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:44:44 -0500
Received: from mail-bn8nam11on2089.outbound.protection.outlook.com ([40.107.236.89]:47790
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229451AbhBLSon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:44:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6oo6aFgs5Nmd2grO4EpscEmcLk5vq7NO1TSe2FuGbo66xhimd9cm4gD2zjPrLdkcQC2iXFcDw7hr6BQTAL+Mz0+YPwyOheOp6Ea5aHTbBLW5PJ61qrYRSAPFFxkvXGJV7xID6ngVXPD6nem30qg1ABJYe5n8sf5UBgpgW5TamiJPAdrqNnFoGBHkxt+k4bNF/mqc4ybbF8fUsL5fw4yYX/TjZx6a3DO7CHpKsRPgpF8uZlyPEX+79tbtVBDwof8f8352PHX+vbnXrApg9ZLshegWYFC9eilEIJ9WZ093ER9CVRBD6mm2/7xruKsDAD3stMpbW45MeTMG5LOeeN60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eGSgA9n8lV6HsQhaXsYDZje8FvtDjXIab8Bv6DdCyU=;
 b=d69OAXdAQ8dLvdGtDIbmIBl+bMfYjBk6SYxexpTvmdvLI2mYrAfh2WklbU1dCuWS/uaouyLCieIAWZu2mkECQX4cvwCkLFMbK6s8gT6dxeCtX4UhHI/+4i/boCdylfjf1uPlZr2dpDQSI/f30QpEZ0fkEhdzWjr/s5FpFGcHn/xxZXCVbHV8ohhg9dt33CvkqOgZULzMCn5bZr2xS+k1j9dQaBOgemVpSx3EprfEn9AdEMqwbY5eSAGjBsyniWrzypQWO5TjH+9+VqOC7kYPKYzmc/GOBHEgZxgh3EoFfIMdeFACVpA4FV3NyPLmOeXu7xMQm0LsTZkyGCfhZ4tnng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eGSgA9n8lV6HsQhaXsYDZje8FvtDjXIab8Bv6DdCyU=;
 b=mGcTm6FElyvKeuHzNtLr5sTIZZFGK7PvWmmvObBFfe3+VtHO8du05KFGvIUtGN+wW7nOmdZixawfkQdZmLZfmyo2r/7ekjtjcnODkM9Z63eVB7nV055OGcH6kGpaaPWwkpu9RQyliXtFQg765N7jXiL35BU4/2oTmGzo1RRK9bI=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.29; Fri, 12 Feb 2021 18:43:49 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3846.034; Fri, 12 Feb 2021
 18:43:49 +0000
Subject: Re: [PATCH 1/4] amd-xgbe: Reset the PHY rx data path when mailbox
 command timeout
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com
References: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
 <20210212180010.221129-2-Shyam-sundar.S-k@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <c951cdd6-5627-5080-72eb-7f28438a6aac@amd.com>
Date:   Fri, 12 Feb 2021 12:43:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210212180010.221129-2-Shyam-sundar.S-k@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0701CA0036.namprd07.prod.outlook.com
 (2603:10b6:803:2d::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0701CA0036.namprd07.prod.outlook.com (2603:10b6:803:2d::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Fri, 12 Feb 2021 18:43:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fc775c10-9d87-4487-ec0e-08d8cf8622a8
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3370076BBAAD3D23BD9D9DEAEC8B9@DM6PR12MB3370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hgJhYi16wF6BgWi1Q9GvxwHehfb1Y9GETR3AU4QBKs1791WwG+JwdaZHTtFR/nNQRO0Fmp5IoYzQYuo77lyvIb7QwidsuvNA0zNRjOcvaHo54zmEJ0AOAN4zR5iiSOIbJx2ihCbUWotIP3ataQoDXAJDgSNZ1Q+LLGM9Ai9Ye1vy1XUeDjcuI1WlXONAJqJZb9FxAzFLZBAST5U3QNb9j8Dzm6rmhGWP7UOjg/D2BHLQb3hKnb4JpYnQxH3iuUWEgh3n7h1ZJnqAR3jEJX74HiAFoq+Pco3usuWcDKpzVTWpT1iSD8RgZgsJZpqE6J4Nr6LBxueftixSvBq5WNi93sLvUg1HuirCNxfhHiObhyc2RuoEEQz4KFY9P5jPG4WdKnhARzor28N/jwHniDYL2NKfyD9gj2UQlXpuJtqX0uM6g97vMfyHsk/E4iu/CxnjMPUvcxS/q0aVNmVvJWuOpOhYtbl0mSJga/P/cu3aYSPHtpd9JA5wnZmNtj+fRucZh8t7KBN5o1VRnKWNYt1iSvJO+gE2CfP38m5SlgWRZKOcNgfwkTT/gR+eCA6sNQcOXpQ7RBDKT0WJiZqfnsB2lmXg7pDEm28117B8B/qoUFs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(8936002)(8676002)(66946007)(5660300002)(36756003)(316002)(6506007)(956004)(52116002)(86362001)(31686004)(6486002)(31696002)(2906002)(2616005)(53546011)(4326008)(16526019)(110136005)(6512007)(186003)(66476007)(15650500001)(26005)(66556008)(83380400001)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VUxCTkFMTWMwaEFjbGtqclhjdjFELzZydnBCQVBlb3ZPQlVEUXNUWDdnbmhT?=
 =?utf-8?B?ekg5SUNYTmFDYis1YWFjTHU4YWhENzFHemI5V1E1VmtPazlWVFB5OVRucGtt?=
 =?utf-8?B?QkpGZ2hrL0lEYmpoRm42OFBYU2JndnNBQVgwUUo5c2hlZU9HUTNXaStlbkx5?=
 =?utf-8?B?QXZYb01UcFlrb1Vkd1JBaGtMdUZUclUrOEQ0ZEJUQkMyUnNnZzIwZmF6M011?=
 =?utf-8?B?aVFNRDJHazE5QUYvQTJ4TEpOL1VWZTgzTCtWMk12OG1XaFpZSXM4YXAzdHBP?=
 =?utf-8?B?cWErb3F1Z0tRMTRqdXJTMmZ4S1pTQndiVUJmTkxWTWYrMWc0ZVdrY1hLTHZh?=
 =?utf-8?B?TXVwanFKVnJXeENBRjdWTmtiNXh3MHJWVUhBQ3ZBTEFhR0RSTGxKUWpuU3pG?=
 =?utf-8?B?VkZkaDA5MmFCV3JDcWFhRHVJcVQxeUVvdzBwaEpsRkY0RnZ0bmRoRkVRYVlq?=
 =?utf-8?B?OWdWYmZiWC9DUXpQSnJVNWhXRHQ4UHU1QVRrQUprVW5Vd21BZTFiaXhuU2x5?=
 =?utf-8?B?V0JCYWxnWU05dzBiZk9CaWpaQXZBU1pVS01EM0FRRHRMWk55dndUU0llRGZO?=
 =?utf-8?B?TGViYmVqMzNEUURGbWxZUm03NGV2eE40dlV1bHdZRmJQUHp3RnhTb3JEU2h1?=
 =?utf-8?B?Z3FSRHBycHhuazYyWHoxQ0JHTnlwNVVxcGdScHlxdFJxNE9ZSHAxSWY5QUNO?=
 =?utf-8?B?L3krV2dDN2tCNDV6MVNEemkvYmJvTlkyZGxNZXZQajQ5S1JFY3RJODVqZ2dL?=
 =?utf-8?B?SjRVcG91R2ZRK2hST1pkc0pWN0h3ZGs1T1JrOTJVSXdteVZnVE0weHFQNHNn?=
 =?utf-8?B?VzM3c3gvdXJOK2lTcTZia1dTeENDVS96SzNxdUNwek5oZ1ZYMG4vTUhiZkcw?=
 =?utf-8?B?NTUzMGpZck54UkczVThLaWZtdjQzWUdlSCtUNmRYbGRnY0R3SGM0d1ZwQXR1?=
 =?utf-8?B?NDdZejVQVXFPSFozbXlmWUtkNXBIbEdjV2hESXMxQ1NhWUVQZ2VHUXMzU1dj?=
 =?utf-8?B?U2NEcDdIWUwzY09UbFZtMGVVVWdVVnJQQW1xRll2WXFDWGpDcmhrdExkSk9j?=
 =?utf-8?B?LzdoZTlsL1ZTYUsrc2hmak93c09pWTNibXZnSVYzc2phcHdWSEZHTlovczR2?=
 =?utf-8?B?VG1OTVF6YTdXRE4xbjRhQ3kwaDFERFd1L3BvaWNnaG5GaXE1SGxIdUZMN3Jh?=
 =?utf-8?B?QTA5QkR0TWZMRnRicHhDMW9ZTHV5VDRERVdaZW96OFpKNVBGaG11ZEZvZlVX?=
 =?utf-8?B?RWNCMVhCc3hkTE5DSW0vT0ZBNjBLYTQ2NEl3c2xKT2dXN1FiRG1uMU0vZWtU?=
 =?utf-8?B?WDR2cG0vOS9ZRjFXNkhwcDdQeDlPcGVBMlZZaHFGRE5DVlMyOHhleGFkNUZ5?=
 =?utf-8?B?K3lpdjlMWUdsRENmbFpnS05TdnNGbTZPVkdiSTZpNmNWalhQa3hvSlorRldN?=
 =?utf-8?B?TXlyMVVWWXpBS3NMR1cwYW5QdHJoWUphajNldmIyOHMvd2NEeUdNQVBzd2pz?=
 =?utf-8?B?WWtsNnZCUFI3TTIrS1NXWEZ6ZHJpOC9LVVNtRzlTZ2F5MnJlanhOUnJ0R0gv?=
 =?utf-8?B?c1UxVkZXNDlxN1hEamRFZGdNcEplWWd0M25XSzZEcWRLUkJGS01pWEorQ0wz?=
 =?utf-8?B?SVdlUEpCR0h5bjA1MUlwVEp5ZUdzQUxaQUcyVWxZSGc5ZEVQaC9GU25nVXR5?=
 =?utf-8?B?MDJxcDkrYWNwNmFCTllPc3AyMUlNY0x6V1FGblZLbGpsRlRxMStuQ0VPcGEv?=
 =?utf-8?Q?hd9faV52LsIfCtr+XT94y0v74t8Dp2xebEv3VV1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc775c10-9d87-4487-ec0e-08d8cf8622a8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 18:43:48.9307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hIWcmWCT5y9+NkXE9oyUiWYbrCGkeZgfAI6zQESK5QGJPffV+s6qjonoQc6ExN3mShzbudUZ4LNQzKl6m4bqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3370
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/21 12:00 PM, Shyam Sundar S K wrote:
> Sometimes mailbox commands timeout when the RX data path becomes
> unresponsive. This prevents the submission of new mailbox commands to DXIO.
> This patch identifies the timeout and resets the RX data path so that the
> next message can be submitted properly.
> 
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

I believe you need a Co-developed-by: before Sudheesh's Signed-off-by: 
if he was a co-developer.

> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-common.h | 13 +++++++++++
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 25 ++++++++++++++++++++-
>   2 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
> index b40d4377cc71..318817450fbd 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
> @@ -1279,10 +1279,18 @@
>   #define MDIO_PMA_10GBR_FECCTRL		0x00ab
>   #endif
>   
> +#ifndef MDIO_PMA_RX_CTRL1
> +#define MDIO_PMA_RX_CTRL1		0x8051
> +#endif
> +
>   #ifndef MDIO_PCS_DIG_CTRL
>   #define MDIO_PCS_DIG_CTRL		0x8000
>   #endif
>   
> +#ifndef MDIO_PCS_DIGITAL_STAT
> +#define MDIO_PCS_DIGITAL_STAT		0x8010
> +#endif
> +
>   #ifndef MDIO_AN_XNP
>   #define MDIO_AN_XNP			0x0016
>   #endif
> @@ -1358,6 +1366,7 @@
>   #define XGBE_KR_TRAINING_ENABLE		BIT(1)
>   
>   #define XGBE_PCS_CL37_BP		BIT(12)
> +#define XGBE_PCS_PSEQ_STATE_BIT		0x10

See comment below, this is a 3-bit field.

>   
>   #define XGBE_AN_CL37_INT_CMPLT		BIT(0)
>   #define XGBE_AN_CL37_INT_MASK		0x01
> @@ -1375,6 +1384,10 @@
>   #define XGBE_PMA_CDR_TRACK_EN_OFF	0x00
>   #define XGBE_PMA_CDR_TRACK_EN_ON	0x01
>   
> +#define XGBE_PMA_RX_RST_0_MASK		BIT(4)
> +#define XGBE_PMA_RX_RST_0_RESET_ON	0x10
> +#define XGBE_PMA_RX_RST_0_RESET_OFF	0x00
> +
>   /* Bit setting and getting macros
>    *  The get macro will extract the current bit field value from within
>    *  the variable
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 859ded0c06b0..489f1f86df99 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -1953,6 +1953,24 @@ static void xgbe_phy_set_redrv_mode(struct xgbe_prv_data *pdata)
>   	xgbe_phy_put_comm_ownership(pdata);
>   }
>   
> +static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
> +{
> +	int reg;
> +
> +	reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_PCS_DIGITAL_STAT);
> +	if (reg & XGBE_PCS_PSEQ_STATE_BIT) {

The PSEQ_STATE field is a 3 bit field and I believe you're looking for a 
POWER_GOOD state, so this should be:

	reg = XMDIO_READ_BITS(pdata, MDIO_MMD_PCS, MDIO_PCS_DIGITAL_STAT
			      XGBE_PCS_PSEQ_STATE_MASK);
	if (reg == XGBE_PCS_PSEQ_STATE_POWER_GOOD) {

where the constants define in xgbe-common.h should be:

#define XGBE_PCS_PSEQ_STATE_MASK	0x1c
#define XGBE_PCS_PSEQ_STATE_POWER_GOOD	0x10


> +		/* mailbox command timed out, reset Rx block */
> +		/* Assert reset bit for 8ns and wait for 40us */

Please combine this comment and be sure to capitalize appropriately.

> +		XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_CTRL1,
> +				 XGBE_PMA_RX_RST_0_MASK, XGBE_PMA_RX_RST_0_RESET_ON);
> +		ndelay(20);

This time doesn't match the comment of 8ns... which one is correct?

> +		XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_CTRL1,
> +				 XGBE_PMA_RX_RST_0_MASK, XGBE_PMA_RX_RST_0_RESET_OFF);
> +		usleep_range(40, 50);
> +		netif_err(pdata, link, pdata->netdev, "firmware mailbox reset performed\n");
> +	}
> +}
> +
>   static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>   					unsigned int cmd, unsigned int sub_cmd)
>   {
> @@ -1960,9 +1978,11 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>   	unsigned int wait;
>   
>   	/* Log if a previous command did not complete */
> -	if (XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS))
> +	if (XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS)) {
>   		netif_dbg(pdata, link, pdata->netdev,
>   			  "firmware mailbox not ready for command\n");
> +			xgbe_phy_rx_reset(pdata);

An extra tab here.

Thanks,
Tom

> +	}
>   
>   	/* Construct the command */
>   	XP_SET_BITS(s0, XP_DRIVER_SCRATCH_0, COMMAND, cmd);
> @@ -1984,6 +2004,9 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>   
>   	netif_dbg(pdata, link, pdata->netdev,
>   		  "firmware mailbox command did not complete\n");
> +
> +	/* Reset on error */
> +	xgbe_phy_rx_reset(pdata);
>   }
>   
>   static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
> 
