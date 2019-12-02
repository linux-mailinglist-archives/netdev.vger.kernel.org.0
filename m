Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF3710EE0B
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 18:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfLBRTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 12:19:04 -0500
Received: from mail-eopbgr730066.outbound.protection.outlook.com ([40.107.73.66]:15392
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727628AbfLBRTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 12:19:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgyEGhlKJfxwefvYNBgg0ds9E8g0YKNWQ6tQQfHuF5MtIbKuZsDbi61WzPDobP8V8PJyZ32r6tQfl6Sj6HcemO76GxPjTnvZ0s2kwy0wApQuEgJSgSMwFAwUyr+HRih1xq5BgiMOs4ZWkHYwmM87yb91h1fNYOUzsHNOvkdwC6OMNXbi59sza+HKcoVZOjQR5UAYBCj3fxAMKaAOw2Hkr9j+Y89Re5OWv4Mz7MqJ4V8TTWpHJLbN0U0GlZhPsJro8esjuqkcxDCGBwD1cEnjyVmiWEdV4Oy55VXZFbprXgpqRnBgICI4S+HOUqsjwffDJiXi1nfSaBSVr+LT1BYwSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PF3LuUIkaipRdzFBmSVIJ7VMv3LtTh4hhM5PYadGUMI=;
 b=B/AHnMZ/RBWJlxH46Ow90Ltul9iK1e4vGkXNKT9uboVAv+leivBeiGTAgeGJws3OqP62XyJqCm+kH6eVkQ9KRq6qaSW0m+o0Z9TEtTxJxWUfGG+DK0mpTzHz8DFa7lK7M8EqTFUVcUMwnrFu4efeAVdHFPvWSOJMSpaMx7Pz3pXCg8YZyHgBi+ZowNRYDz09pBC70JyI4roLV3YCV7I6HOXUCr1AvJIuDDDU2taKPoWSqbT4lAFP6NtUxlLd4Morbh1X2oUpybR8f1ce5kbE8Sd/ljTB7Ed7PIprMQnzfu/+dbaiLpDPVzZodQVpTWivWnjJniNVScWjHTGohOoZxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PF3LuUIkaipRdzFBmSVIJ7VMv3LtTh4hhM5PYadGUMI=;
 b=uc27ZvmYf288g9lMA0ZyMrznb4Wzpl3iy3ugS4DLc9vs3LuqkIRL8n1lVZEV+lwwyaPKGMAwHlaQmVyWjIufhIHbtB42js2IiKu0noguZkrGFHG0mJIWLBXRu+FzBg4P8R0WPQUSfN9wtoCnlXrIGTegjl+j+mvSS4ATw6ZplQQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3513.namprd12.prod.outlook.com (20.179.106.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Mon, 2 Dec 2019 17:19:01 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::dd0c:8e53:4913:8ef4]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::dd0c:8e53:4913:8ef4%5]) with mapi id 15.20.2495.014; Mon, 2 Dec 2019
 17:19:01 +0000
Subject: Re: [PATCH net 1/2] amd-xgbe: Use __napi_schedule() in BH context
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20191126222013.1904785-1-bigeasy@linutronix.de>
 <20191126222013.1904785-2-bigeasy@linutronix.de>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <9c632f8c-96a5-bb01-bac5-6aa0be58166a@amd.com>
Date:   Mon, 2 Dec 2019 11:19:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
In-Reply-To: <20191126222013.1904785-2-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:5:40::40) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f9e558d-1ded-423b-aa33-08d7774bb96a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3513:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3513868B38E0461F0B14D4BFEC430@DM6PR12MB3513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-Forefront-PRVS: 0239D46DB6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(189003)(199004)(6486002)(36756003)(66476007)(66946007)(66556008)(31696002)(66066001)(65956001)(31686004)(229853002)(4326008)(6246003)(6436002)(316002)(386003)(6506007)(53546011)(14454004)(76176011)(52116002)(6116002)(65806001)(478600001)(6512007)(305945005)(86362001)(26005)(186003)(99286004)(5660300002)(7736002)(50466002)(2486003)(3846002)(8676002)(23676004)(25786009)(8936002)(58126008)(81156014)(446003)(230700001)(2906002)(14444005)(47776003)(2616005)(11346002)(54906003)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3513;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8INySbmAry1W8qKes9NSiDKlZSJbR+xiA5HxcRIrjWWt06DkNhp5s5OhVBneK4IFeZGp6WanvkXVitJJYmF8o8IpKsxw3ZJKD6AWEbkR65Wdmw/3ti/dNiJJqHh2w9GGhdPpxoasMPaDRw3c04rPTgPuNkV1zCXbBlVXnojC6tmsXAVa+4uPnEi6VDwwCDa8QKX5wzG1EPM0Uxva38fWzHpvOqgjG5puBrfNXgZfxZRP0eBjvhOV116Z9dECcElSAM41qAt2WlYPfHwxrWV3f9CoEZSGAKRHVqR3E/ayStT/G6RxY6QQUUwnVrZQSCIIbpYcweHrU9l6CLz6Khl851124nW7skR9lHvhd30Hee9z5fuYcHYQxAwU9WmdUJoaIg7rUmLiFLHdlxnY27jhbngLokah/a6jkAOwQxlb7/SwB6UyEXg9CkMuiFI84fdV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f9e558d-1ded-423b-aa33-08d7774bb96a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2019 17:19:01.5271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LDd4L3ihdSXnBe5xB0ugYWZaYriY2NZcUdUH8lwrftibxZ8Uecr+tu+laMf/d+x1HWPPX2UpLuwjcDqnPpAlpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3513
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/19 4:20 PM, Sebastian Andrzej Siewior wrote:
> The driver uses __napi_schedule_irqoff() which is fine as long as it is
> invoked with disabled interrupts by everybody. Since the commit
> mentioned below the driver may invoke xgbe_isr_task() in tasklet/softirq
> context. This may lead to list corruption if another driver uses
> __napi_schedule_irqoff() in IRQ context.
> 
> Use __napi_schedule() which safe to use from IRQ and softirq context.
> 
> Fixes: 85b85c853401d ("amd-xgbe: Re-issue interrupt if interrupt status not cleared")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> index 98f8f20331544..3bd20f7651207 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> @@ -514,7 +514,7 @@ static void xgbe_isr_task(unsigned long data)
>  				xgbe_disable_rx_tx_ints(pdata);
>  
>  				/* Turn on polling */
> -				__napi_schedule_irqoff(&pdata->napi);
> +				__napi_schedule(&pdata->napi);
>  			}
>  		} else {
>  			/* Don't clear Rx/Tx status if doing per channel DMA
> 
