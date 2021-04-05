Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4BD353C78
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 10:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhDEIoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 04:44:11 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:17282
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231979AbhDEIoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 04:44:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqcyExt8xdiK80mQOc9AXt1eVkBILowIv/VSuOKrXVEHfQFZRsfAGcAKTYi/TPRAWMIf8Tx42GPFjvte2Ma8v9jQnH2kTCOrGimd0At4SRoBEahel5bt8t4+YE5XWTSdc6jELwzV+b+XFJpb8ls6OG1+usN5b5QqYu3XDV7T0kstCKbsU6Lqk/kAE8ivSPCN52OYQzL6uzm1chZwmrfyceq4EaRDUm6R6NJSZVUWeUc3qXvzQiTza5dogeaTqic9Ia+IarrNcHGJEXoL5iCmd/CLioDUE9fdKtN4BLrsMnt21FqYoiYgA5kfGMceiPop6zDh8hPo2ZfMZ5sfQ2HASg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75TMaXhMOEj8cffY7O9YPHQOMVGcRmbZcSmM/RrvjHQ=;
 b=dYoCS90B7FmSj+tS21aIICxfH39P20xmDhh/KQLLZr8kamJa46Nfv8CqoPfFyO8r5UOG4ymhLcaDWCfqGiYzHh0bqjp0yf/XEAFqSRiZ7bKipiq8Q98wENkMOH4GqxYfcDxG33Lt8+1QOBhRVkYzAKlDtKJDdNw/MKAd8C1JzUVEoK3wWG1NRlrfq8L8PRzgvegeZklaYdfDXFOXBH/xS+Zq4cCoKlFB2SEVQPxATRi/sBkj/eSVjQSDtKpRz7ygMeh9IRK1HzqyYZV4yErVJkqk4fv5IMHY3l+GNUlGjw0gcTp6AYxFVZBOqYDKb8H9mgsvMJyTBH9HfYmn3iSr9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=t2data.com; dmarc=pass action=none header.from=t2data.com;
 dkim=pass header.d=t2data.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=t2datacom.onmicrosoft.com; s=selector1-t2datacom-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75TMaXhMOEj8cffY7O9YPHQOMVGcRmbZcSmM/RrvjHQ=;
 b=hlB34FAUiPGKhQUes+QkmSjSYv6GZTJ9HmJ7umH1gw7Nq1+BGXQZszcjwVBXvOVqSZ0GArSBngekAfTH3CxpslpPjF8p9+NITTmsXaxvX20fjBaYnZRePMpkGqNvHc5MkhbIuyVCO3y7+DSWTPSBnsqWafnTA+iFlfb+rrsLo4w=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=t2data.com;
Received: from HE1PR0602MB2858.eurprd06.prod.outlook.com (2603:10a6:3:da::10)
 by HE1PR0601MB2331.eurprd06.prod.outlook.com (2603:10a6:3:94::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 5 Apr
 2021 08:44:01 +0000
Received: from HE1PR0602MB2858.eurprd06.prod.outlook.com
 ([fe80::409f:a235:de54:364e]) by HE1PR0602MB2858.eurprd06.prod.outlook.com
 ([fe80::409f:a235:de54:364e%8]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 08:44:01 +0000
Reply-To: christian.melki@t2data.com
Subject: Re: [PATCH] net: phy: fix PHY possibly unwork after MDIO bus resume
 back
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
References: <20210404100701.6366-1-qiangqing.zhang@nxp.com>
 <97e486f8-372a-896f-6549-67b8fb34e623@gmail.com>
 <ed600136-2222-a261-bf08-522cc20fc141@gmail.com>
From:   Christian Melki <christian.melki@t2data.com>
Message-ID: <ff5719b4-acd7-cd27-2f07-d8150e2690c8@t2data.com>
Date:   Mon, 5 Apr 2021 10:43:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <ed600136-2222-a261-bf08-522cc20fc141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.234.39.46]
X-ClientProxiedBy: HE1P191CA0006.EURP191.PROD.OUTLOOK.COM (2603:10a6:3:cf::16)
 To HE1PR0602MB2858.eurprd06.prod.outlook.com (2603:10a6:3:da::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.7.217] (81.234.39.46) by HE1P191CA0006.EURP191.PROD.OUTLOOK.COM (2603:10a6:3:cf::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Mon, 5 Apr 2021 08:44:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c18581b2-1c4c-4621-97e8-08d8f80ef5b0
X-MS-TrafficTypeDiagnostic: HE1PR0601MB2331:
X-Microsoft-Antispam-PRVS: <HE1PR0601MB23310604CB6A28A724AFFAC4DA779@HE1PR0601MB2331.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fDWI+NcthByp8f9yabrFoW5EJfKfjEpd4A3feEn4Jg7fRStqd3sLk7ehU6L7wJQFsdIsuiu5iOAPjrhjQ6cGOHR4ah75UyKY/Lq97bhzOP7bBGoUbA7df7qrOk9dk59j/NFkR5599H4emGifn+vgEL5AnRdzflBKbfLRqEl8c1V5ZHTlx0x2N8/WXpexnR8qW60FPV91sTCATdRM1iAknWGWrfdEn5T/T/bdr9TT3zaqJHwAomumDPurvCPmqgOpAL/9xQOcnP6UKqODAPI1C/soaMt9pRWKCXY2LeR5GdHILNgLLZIkm5IipiBMJm1hVMeAagZcMn6epQoh0w6WHhoKNB3rH+rXFvtwk2kB20R+33IvojlyvxkfBkY0psxLJgJAAHEd0g2xaS/c70RiuhX2ZbjNdQWupVBvsdHSJ0O0KvJKAV8/izIhlq6zfahYno1QY9WSvnPV4QCRoiTb9OwYNtTb+8TOaD/lqMgEEAfw5jVNLRDhYobSf51zdaHZupbghz8VorNOuvclH2H2emtQjw3V1P2vhRMtUzV8qO4ry6iSJ6cYckTFX/GJXoaCYJEoOmjnXm+vqNYUT1ZCAtcz+siCN4dywJM/7hHNX5Wn8HBDissz0hNtSerMGMZKNIyi2F5sJL2J1fnxrXOroxNPYM8wswJHP/OOvk0M5w/K8JwBQEcd23kqfhjCcq97UmQajoDxFd3LER7AvSwYWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB2858.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(42606007)(376002)(136003)(39830400003)(36756003)(52116002)(16576012)(66556008)(66476007)(86362001)(83380400001)(2616005)(2906002)(31696002)(26005)(316002)(38100700001)(16526019)(186003)(53546011)(44832011)(478600001)(8936002)(3450700001)(956004)(110136005)(31686004)(4326008)(66946007)(6486002)(5660300002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dHk2aFdvS21WK09TdXBoZFZ3MUVhMzRTN2hWWUhIeUhzLzJwSllDd3dkSWY3?=
 =?utf-8?B?aWVlbVdHTnZpcXEyQ05CbWZFNUltWGFadTJOVUthSXBySDEzZ0laVncvcnNu?=
 =?utf-8?B?UElwSTVoSXRRMi9mZHdqMG9kLzM3M2JEeTJsdW9VVlVXOUdFNlorVnJRbUNH?=
 =?utf-8?B?ejBEQ2tlT3V2MjlweHltR3RDN1dzeEhKT0U4MUZnWW9NeDU3T09EenVQblM1?=
 =?utf-8?B?WjgzS05jaTU0dENFQ0RucTYxNzFiM2tTTlQ2NGNETUJnOVFkbzJHY2xnT0hw?=
 =?utf-8?B?bEd5WUk5SVVZL2NTMTgvSG1TZlJPQzdGUFFkc0hrckZIdzF4WnJCZ05LTCtN?=
 =?utf-8?B?M25pdFE5dTJOcExjVlN5RmFiWGRBOHZscFRDMVpZU2thbXpPc2c1SlJBbFRi?=
 =?utf-8?B?cnY5OU1nS1BnUG4zOXR2M2E5Y1FGNXlVUzBNTkJHbkxucm0rOVYwUU5EbnZr?=
 =?utf-8?B?ZDVkdWloenFnNkUrVmlqTW9OUHNDMVZyYTBLQWJ3TTdONzdJWkNqNThwd0lw?=
 =?utf-8?B?YmQ5UWN6bktlbk5ZbURxdEtrUVI5dlBuSUJCYngxSERFWFBlZE5haTNIS1NJ?=
 =?utf-8?B?dVZVeUxDRnFmbzE2YUxmRDczZkhsYysvVTI2bGR4Q25aRnV1eGo4bzlSWWky?=
 =?utf-8?B?Y0M4WWlFTjlpSHVqMVJrb05lRUFjdzV3ZlBOM05maUgwbVlJRWVjMjZGMFps?=
 =?utf-8?B?MjlvZzRzcFNiYXFKTDdaQXYwWFA5bWZtVkhrWDFBOGhrUVFNZDlpVndXMzFy?=
 =?utf-8?B?NUFiL1p3cHVSWmFoTkUybkZJNWhZSFhCVGE4SjZUOGx1eXlzNkRxMVJVZnBx?=
 =?utf-8?B?U3d4SDdYZlg4YXFUMHVaMmJmREhWQm1pRWVxaW1qemdBaldDVnpoV3lNWDBF?=
 =?utf-8?B?VENjcG11VnlERmx0ZFZFNUhSd1dDOXZ3bzVZdUNscHErejZYVDY1TTVnSHNo?=
 =?utf-8?B?TDZCb205RVpqWVpLV1JGVldlYVpiZVRUY0htc2orRHEvaUdXVTMxT2xsLzFX?=
 =?utf-8?B?clZoZ2l4ZGEvd2RSU2M4SjZLMlZacVZMV25QMmUvNDJtYWM1N2hzSUxIRytF?=
 =?utf-8?B?ZjFwSnFWbThLcmhUUzJlV3BkWFlSVGMyYVF3ZEgyWjJJV0RoSUJsd2k3bXEx?=
 =?utf-8?B?OEhsSG1tbE51QjFaRTFveE03bjVzMUZUTHpUWDNZd2krS3hYL20zeWhMNjMv?=
 =?utf-8?B?dm9TVE9RZTZhZXhCaE5FN0twMElmam9rOUgzRHRDb0tLV2hVNEJ5VTlNQ21F?=
 =?utf-8?B?YitxaWJGcFcyR0lDU0JscmVJMVRuSUxtRFBnYWxsTUgzMVU5UmpwcWowbzJ6?=
 =?utf-8?B?ZThJYklzTDZoYmcyU1FGbCtNRHJ6RnpwUnpLRlg0NVhjMmZlelR4K3VtUUc0?=
 =?utf-8?B?YnpNVE5KSTVCMGZ6N1JjN01ZcXpQREt1ZU51dGtVZUFEVUMvMmVHakRDNklK?=
 =?utf-8?B?eng0NTl5Nmh4cms5ZlBFdjN0ZFIxdUVvSkZheWduS1FUWUlYWmh0Y0x1eHRW?=
 =?utf-8?B?M2dzUkJaSE5LQ3dOa0JqVTMzQ2RIVGsvVlE5aFZzV28vWTYybVNkVWgwVUYx?=
 =?utf-8?B?OU1YWkx1QUJCRmo2TEUxQkQ1YUZBMlpYblpQd3ZGczg0aWl2Y01GKzl0Ullr?=
 =?utf-8?B?cHJrMGplcVZSR0ZLL2Z3VTB6RVhGTUY3VkdyOUtta3JtSHpRQkNVTGlmMFJx?=
 =?utf-8?B?UVBJRmp4SVJ6ZzlESkhYRXpRVWRVbHROaXNKQTlINm5JbkZ2U2xBdjhuKzVK?=
 =?utf-8?Q?VlxUyJjLJ6/+jUicGfWCYAsp65oBnPQVYD5LCW8?=
X-OriginatorOrg: t2data.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c18581b2-1c4c-4621-97e8-08d8f80ef5b0
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB2858.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 08:44:01.0141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 27928da5-aacd-4ba1-9566-c748a6863e6c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEZet+DGz2e3P1TNiB8gxdTx+MoEnIYL8Wr3/OqsL196AxoxYMQVFnM4HvbPWQdVxYBRZKbtQoIE9PF6tbMpHazxP27Nt7+8Z+IbEb4aoBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0601MB2331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/21 12:48 AM, Heiner Kallweit wrote:
> On 04.04.2021 16:09, Heiner Kallweit wrote:
>> On 04.04.2021 12:07, Joakim Zhang wrote:
>>> commit 4c0d2e96ba055 ("net: phy: consider that suspend2ram may cut
>>> off PHY power") invokes phy_init_hw() when MDIO bus resume, it will
>>> soft reset PHY if PHY driver implements soft_reset callback.
>>> commit 764d31cacfe4 ("net: phy: micrel: set soft_reset callback to
>>> genphy_soft_reset for KSZ8081") adds soft_reset for KSZ8081. After these
>>> two patches, I found i.MX6UL 14x14 EVK which connected to KSZ8081RNB doesn't
>>> work any more when system resume back, MAC driver is fec_main.c.
>>>
>>> It's obvious that initializing PHY hardware when MDIO bus resume back
>>> would introduce some regression when PHY implements soft_reset. When I
>>
>> Why is this obvious? Please elaborate on why a soft reset should break
>> something.
>>
>>> am debugging, I found PHY works fine if MAC doesn't support suspend/resume
>>> or phy_stop()/phy_start() doesn't been called during suspend/resume. This
>>> let me realize, PHY state machine phy_state_machine() could do something
>>> breaks the PHY.
>>>
>>> As we known, MAC resume first and then MDIO bus resume when system
>>> resume back from suspend. When MAC resume, usually it will invoke
>>> phy_start() where to change PHY state to PHY_UP, then trigger the stat> machine to run now. In phy_state_machine(), it will start/config
>>> auto-nego, then change PHY state to PHY_NOLINK, what to next is
>>> periodically check PHY link status. When MDIO bus resume, it will
>>> initialize PHY hardware, including soft_reset, what would soft_reset
>>> affect seems various from different PHYs. For KSZ8081RNB, when it in
>>> PHY_NOLINK state and then perform a soft reset, it will never complete
>>> auto-nego.
>>
>> Why? That would need to be checked in detail. Maybe chip errata
>> documentation provides a hint.
>>
> 
> The KSZ8081 spec says the following about bit BMCR_PDOWN:
> 
> If software reset (Register 0.15) is
> used to exit power-down mode
> (Register 0.11 = 1), two software
> reset writes (Register 0.15 = 1) are
> required. The first write clears
> power-down mode; the second
> write resets the chip and re-latches
> the pin strapping pin values.
> 
> Maybe this causes the issue you see and genphy_soft_reset() isn't
> appropriate for this PHY. Please re-test with the KSZ8081 soft reset
> following the spec comment.
> 

Interesting. Never expected that behavior.
Thanks for catching it. Skimmed through the datasheets/erratas.
This is what I found (micrel.c):

10/100:
8001 - Unaffected?
8021/8031 - Double reset after PDOWN.
8041 - Errata. PDOWN broken. Recommended do not use. Unclear if reset
solves the issue since errata says no error after reset but is also
claiming that only toggling PDOWN (may) or power will help.
8051 - Double reset after PDOWN.
8061 - Double reset after PDOWN.
8081 - Double reset after PDOWN.
8091 - Double reset after PDOWN.

10/100/1000:
Nothing in gigabit afaics.

Switches:
8862 - Not affected?
8863 - Errata. PDOWN broken. Reset will not help. Workaround exists.
8864 - Not affected?
8873 - Errata. PDOWN broken. Reset will not help. Workaround exists.
9477 - Errata. PDOWN broken. Will randomly cause link failure on
adjacent links. Do not use.

This certainly explains a lot.

>>>
>>> This patch changes PHY state to PHY_UP when MDIO bus resume back, it
>>> should be reasonable after PHY hardware re-initialized. Also give state
>>> machine a chance to start/config auto-nego again.
>>>
>>
>> If the MAC driver calls phy_stop() on suspend, then phydev->suspended
>> is true and mdio_bus_phy_may_suspend() returns false. As a consequence
>> phydev->suspended_by_mdio_bus is false and mdio_bus_phy_resume()
>> skips the PHY hw initialization.
>> Please also note that mdio_bus_phy_suspend() calls phy_stop_machine()
>> that sets the state to PHY_UP.
>>
> 
> Forgot that MDIO bus suspend is done before MAC driver suspend.
> Therefore disregard this part for now.
> 
>> Having said that the current argumentation isn't convincing. I'm not
>> aware of such issues on other systems, therefore it's likely that
>> something is system-dependent.
>>
>> Please check the exact call sequence on your system, maybe it
>> provides a hint.
>>
>>> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
>>> ---
>>>  drivers/net/phy/phy_device.c | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>> index cc38e326405a..312a6f662481 100644
>>> --- a/drivers/net/phy/phy_device.c
>>> +++ b/drivers/net/phy/phy_device.c
>>> @@ -306,6 +306,13 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
>>>  	ret = phy_resume(phydev);
>>>  	if (ret < 0)
>>>  		return ret;
>>> +
>>> +	/* PHY state could be changed to PHY_NOLINK from MAC controller resume
>>> +	 * rounte with phy_start(), here change to PHY_UP after re-initializing
>>> +	 * PHY hardware, let PHY state machine to start/config auto-nego again.
>>> +	 */
>>> +	phydev->state = PHY_UP;
>>> +
>>>  no_resume:
>>>  	if (phydev->attached_dev && phydev->adjust_link)
>>>  		phy_start_machine(phydev);
>>>
>>
> 

