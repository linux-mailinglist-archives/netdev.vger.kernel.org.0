Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D782C354280
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 15:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbhDENxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 09:53:22 -0400
Received: from mail-eopbgr20076.outbound.protection.outlook.com ([40.107.2.76]:63209
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237460AbhDENxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 09:53:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDgQOHa2haq7TnoYCh3EY3QbnYZ/+QHXsamQXiKaNEymN7dSN2dcNZspDp7fyCqNXAgi9ZJ58QHE0+W3IITFnv6EJWmZaXfeWsHDRcrOZsaAKXH4SGvYpLJ8RfuxO83Dz66j9UDiXvMxtqSEECsHwZwz9eix/5O9SmT5js2qhwBD3g3Sz5/4veEFvQ6qb/ci407fTuuZianqqngjN64za8YsMMA0VuORzQJcW9l1D5kCGBDXrxxSNBB3So/bk/Fxnro5BMEKEsoKA1DxxpVk+G2TAghjMsdbQnN3D6fkFkfxPBrt2Zc5FGkaOhr9CEs8tuIRkwiA+0sZRYVAs2tBaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=escwcWEpi5D4xYk+79ucuk+RALohbc03RhEjfY8wv2M=;
 b=BfoEHsio1tlLjSljFGIFyw7zY0RFfBBKR+ArhYH9+8Xjcl+Sgdf0uiUm+RZcJ7ehtTrtnlGnG1dkX2bxjSUJxMZ1zj0wTcauLZoANdd69gahy2vyWhisWUBYJTPR9a/oTqZL853qhhS0YZwY2pLWCVqkig2spqLjphHEBzWcJhSOpd5dE09zl+L1qMfvTJ2tQacdGakaNttMZs1JmcgGhjsxWk4Fan8LpvrHwxOz1zty8dcz11Uq7uIm3cVICGOrrK0RAUFB8+ia92BggTpq6sKR0Uk8PHF56I8E34R0lCq3yOlJJXqprtTykPoNMFxth+iJjWE401RHx4Pa/a3wBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=t2data.com; dmarc=pass action=none header.from=t2data.com;
 dkim=pass header.d=t2data.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=t2datacom.onmicrosoft.com; s=selector1-t2datacom-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=escwcWEpi5D4xYk+79ucuk+RALohbc03RhEjfY8wv2M=;
 b=RFeFBOnxA1VChew/+VWwF1OW5FhY8I+h1Vb1vdiSShazWcCcVwKH/9CQjXNpupFXGeNSWYAifGgZuuJr7og8Sl0au8k2o9scKRE8K02JziHpkufOVaINxm6aJg2scLAzV6CSiHHzO9msZF951EcdYjEqkaf5PeqhTi8XUIljTM0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=t2data.com;
Received: from HE1PR0602MB2858.eurprd06.prod.outlook.com (2603:10a6:3:da::10)
 by HE1PR0601MB2587.eurprd06.prod.outlook.com (2603:10a6:3:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Mon, 5 Apr
 2021 13:53:11 +0000
Received: from HE1PR0602MB2858.eurprd06.prod.outlook.com
 ([fe80::409f:a235:de54:364e]) by HE1PR0602MB2858.eurprd06.prod.outlook.com
 ([fe80::409f:a235:de54:364e%8]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 13:53:11 +0000
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
 <ff5719b4-acd7-cd27-2f07-d8150e2690c8@t2data.com>
 <010f896e-befb-4238-5219-01969f3581e3@gmail.com>
From:   Christian Melki <christian.melki@t2data.com>
Message-ID: <1ded1438-b3cf-19d2-c3f4-1c1da3505295@t2data.com>
Date:   Mon, 5 Apr 2021 15:53:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <010f896e-befb-4238-5219-01969f3581e3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.234.39.46]
X-ClientProxiedBy: HE1PR08CA0076.eurprd08.prod.outlook.com
 (2603:10a6:7:2a::47) To HE1PR0602MB2858.eurprd06.prod.outlook.com
 (2603:10a6:3:da::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.7.217] (81.234.39.46) by HE1PR08CA0076.eurprd08.prod.outlook.com (2603:10a6:7:2a::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Mon, 5 Apr 2021 13:53:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d0161e7-3c35-493c-4399-08d8f83a2657
X-MS-TrafficTypeDiagnostic: HE1PR0601MB2587:
X-Microsoft-Antispam-PRVS: <HE1PR0601MB2587ED769250C91FF2A3C657DA779@HE1PR0601MB2587.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YWysbDapb7JPIbiYyGCx8vdewDwBV4BZ9zHUMW36YTi4QXh1MIYFLE6ELvk+dLe7KKYUnqgaMYf9LfWpRrsLpPChdFE8ry/3N/MhwQtJJmLSRXQVunkuRAHeP+RwkhusyiA6+QGsJehZSj4yRqEIMkWQOP1uOXTkCwtRTUP410jUWC+38PNMjxN4mhy4n2rIdpot9ZrTblLgDjHhryzfcwgi5E2IPGWZ5lsKdy41Tj3oA1gwUxnCvBzZO8rFbtpYGyGDeUbZUTNvbyqZLCy72o5/J5qB6v5t8v0z5tILac35tbMZVuYkl1YbdoctqIHLiFIpPahWe5I6VBgi0xwzymvbKxBNfyMAoQhe3K08AcoZqtaRMQjRmt00rd6Z9pXx4TEBTDiLL03PTyI3pygJMrGxpGWs5Qk8RBOgHcvk7W5S9pAQHX1yyajfWAk4wqDrLSZ5JpjIPRmgNonDwDy7PzDywVPY4Hc+t2L3uezY98/CG+qKXaX/9RYqCxOe2f1xz2yIxvPVd2o4BfCBnbtF45kDUFq+7sDVIJBvl/PSBjxxDN034mk4g8ZEOuoSULp5N+ZHMpKBzIEtr3hAA3QRwLETK10MsYMLl1Hhw1OkGOLpacW925Lsnl/O7PdfHijEbpxfZOXbopYRlurLX8L1CzUYZnGQkAurVPiPsp3HthfcMBakxKQRTxI3E9TpT4jqwZs5Hp0UJ3qCalSq1j5DdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB2858.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(366004)(376002)(42606007)(346002)(396003)(86362001)(31696002)(5660300002)(8676002)(53546011)(66556008)(2906002)(44832011)(8936002)(83380400001)(36756003)(66946007)(956004)(4326008)(31686004)(2616005)(316002)(16576012)(16526019)(186003)(38100700001)(6486002)(478600001)(26005)(66476007)(52116002)(110136005)(3450700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Yk5Fak1oc2M2d2NGMHFwZFFxM01UblpCUjVLODRTMzZNL3p1ZDcrRlF3OXdF?=
 =?utf-8?B?bEMzTDNMYS9MYkQrdmZhYjNVa0toSER2dVR2UHZlOXBIbGNmakxKYlJYSHpE?=
 =?utf-8?B?dnJFZ3lCWEZlV0NWS0h1b0kvRWFTQ3U0Wit0N3pBcnFmU1FUajQxV0dqUHlN?=
 =?utf-8?B?MTJwbExpOTlnYS9heEVVQjdmcVlWRFk3MVR6UVVwa2Z4Q1ZTeEhid3NzbnFI?=
 =?utf-8?B?MVVKWUtIbGFnN0R6d01Ha2dFWjFEL2FzM3VneDF3Q2dZTXVTeERkYmlJeDkx?=
 =?utf-8?B?SVF0SmY4REhnalBVRHJBa2Y2aFlyT2g0eHR0RnpYYlFwY1M1MjlhaU8yT240?=
 =?utf-8?B?R3QxTitHSmtDOXBkemRNdnRhaGVOTVN4VjI2VUxFbFhhcGx0RW9EcUNvb3ZC?=
 =?utf-8?B?SHNLNVNQaTFqQ3h2cHRZN2Q1bTREMWhDNDZiMkJIbG9JQWNSZGpBVDVKeVRU?=
 =?utf-8?B?THN1RjU1aGQ4OFVzVjFlYWFVK0VuakxEUnU2YWpyTnVlMnRXRzRsV2pEWHZ0?=
 =?utf-8?B?bEhaVVZtcFRuWlNIMW56ZjEwUno0WkE0Tks2RFFONzhaU25OYVJKWXptTmpr?=
 =?utf-8?B?N2tYa2JGTzFJbCsvS0VlcW05Mkg3cTRhZDdkaFRKSDBIRFFHcy9LSG90Z3hC?=
 =?utf-8?B?MW40VkFTYzM3QmhuZjh0SjJVMFFTQmJYWVFMWTdXZ0R6SHBUTGc1WlhOS29O?=
 =?utf-8?B?TjQrVDVsUStIKzdLcXIyZFJBUWV3dDk5V29CVHhpSC9uVFQ2clFRdmpVeDdm?=
 =?utf-8?B?cVFqaENUMFpFbnM3cG9PVTlodisvc2wzeCszaXN4Z2JvKyt2WTAvQitkSmU2?=
 =?utf-8?B?ZjZXSDhCNXZaeHBOaGtGc0xObC85S0lFMzFBWGhPVktLTkFtVmd1bDZOK2oz?=
 =?utf-8?B?TlhYTXVDbjVvTW1RaUpzTWNocGhmOWdNYyt1bnhySERiRU1tbUJaSHB2UWxU?=
 =?utf-8?B?RktWYmxQNlhacDJSdzB3ZXpIem1UeDh3RFlobTVsN2UwSHZMOUZKb0VrT29r?=
 =?utf-8?B?dGs5QlZPOWFUOW5ESUpleVJLbUhvTnNXQ3l2dGpHSnpsTTR3LzVVRG40VHZJ?=
 =?utf-8?B?c04vWWFxM0RSbXZXSzJJYUlZMmZnNERRdllDd0VXam9QcHREN3Fmak9vSmxG?=
 =?utf-8?B?cXpPZTFpTjgvM040WkpEWjd3VFluVDh5RE9Ob2I5SDBBSkl5c0VwMTBGVTN0?=
 =?utf-8?B?YkRQUjhKbWVWRGJnVWdmZzZTU0dWdG1JY3BoNFRrOWRaSDc2ZHIzYTNMdGR4?=
 =?utf-8?B?clNqYzVTeCtLVEtZbGNMUnBkamRQUFNDRWl2NUZrN1NVaTlCdE1EL3Bnbm1E?=
 =?utf-8?B?dXJkdjFNSFExeXpwY3picFZKcmxLT0IwOVZtTnpNc3FnVy85Qnh3ZUdFVURr?=
 =?utf-8?B?L1hQYUo0LzFyRnh6ZGdoazU2OHhkQ2UwUGUvQzFGcTN1TUhTUWxLZkpOV0ZP?=
 =?utf-8?B?b3h0RDdtczFjTEdaRkZSMXRzamk4RDY5RGREd05aNThGYTkwWVptUUNHa1Vo?=
 =?utf-8?B?d3IzMmJwZnhsUzBRTzJ2ajhhUjBTNFJ4SlAzY29yS2ZpTm1URU9HN3M0Qk8y?=
 =?utf-8?B?RDBBOVRpdXJhWWZ1WDZWS1RpcG5lQzR2TkN1aUJnZmppU2NkcEZ3cFpHYlVN?=
 =?utf-8?B?Nmt2OWhqcFlsTzV5WlpjR2loQVROYmxCVlN0dUdaU3NvVnhoV3ZxRFVTTGF4?=
 =?utf-8?B?VE5GUDMzOWp3alRzdW03cTlUMXR4WHlFd2MzbWR5NmNyUVU5WnRjbVRaSTFF?=
 =?utf-8?Q?3QqBua1VPz2caEB7bAobdVoHk3TKp0aRzlEzEPl?=
X-OriginatorOrg: t2data.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0161e7-3c35-493c-4399-08d8f83a2657
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB2858.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 13:53:10.9809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 27928da5-aacd-4ba1-9566-c748a6863e6c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ef5KPop+uStEAxWcpSAFjWpjgJ+ZqXI19ghyoIWpwv9S3qIfoVFEmLj1NA/2fbQcV3YECLrQlq3mjGSwTyDnUY/+7hnvDjTAlxrYwqyTTM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0601MB2587
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/21 2:09 PM, Heiner Kallweit wrote:
> On 05.04.2021 10:43, Christian Melki wrote:
>> On 4/5/21 12:48 AM, Heiner Kallweit wrote:
>>> On 04.04.2021 16:09, Heiner Kallweit wrote:
>>>> On 04.04.2021 12:07, Joakim Zhang wrote:
>>>>> commit 4c0d2e96ba055 ("net: phy: consider that suspend2ram may cut
>>>>> off PHY power") invokes phy_init_hw() when MDIO bus resume, it will
>>>>> soft reset PHY if PHY driver implements soft_reset callback.
>>>>> commit 764d31cacfe4 ("net: phy: micrel: set soft_reset callback to
>>>>> genphy_soft_reset for KSZ8081") adds soft_reset for KSZ8081. After these
>>>>> two patches, I found i.MX6UL 14x14 EVK which connected to KSZ8081RNB doesn't
>>>>> work any more when system resume back, MAC driver is fec_main.c.
>>>>>
>>>>> It's obvious that initializing PHY hardware when MDIO bus resume back
>>>>> would introduce some regression when PHY implements soft_reset. When I
>>>>
>>>> Why is this obvious? Please elaborate on why a soft reset should break
>>>> something.
>>>>
>>>>> am debugging, I found PHY works fine if MAC doesn't support suspend/resume
>>>>> or phy_stop()/phy_start() doesn't been called during suspend/resume. This
>>>>> let me realize, PHY state machine phy_state_machine() could do something
>>>>> breaks the PHY.
>>>>>
>>>>> As we known, MAC resume first and then MDIO bus resume when system
>>>>> resume back from suspend. When MAC resume, usually it will invoke
>>>>> phy_start() where to change PHY state to PHY_UP, then trigger the stat> machine to run now. In phy_state_machine(), it will start/config
>>>>> auto-nego, then change PHY state to PHY_NOLINK, what to next is
>>>>> periodically check PHY link status. When MDIO bus resume, it will
>>>>> initialize PHY hardware, including soft_reset, what would soft_reset
>>>>> affect seems various from different PHYs. For KSZ8081RNB, when it in
>>>>> PHY_NOLINK state and then perform a soft reset, it will never complete
>>>>> auto-nego.
>>>>
>>>> Why? That would need to be checked in detail. Maybe chip errata
>>>> documentation provides a hint.
>>>>
>>>
>>> The KSZ8081 spec says the following about bit BMCR_PDOWN:
>>>
>>> If software reset (Register 0.15) is
>>> used to exit power-down mode
>>> (Register 0.11 = 1), two software
>>> reset writes (Register 0.15 = 1) are
>>> required. The first write clears
>>> power-down mode; the second
>>> write resets the chip and re-latches
>>> the pin strapping pin values.
>>>
>>> Maybe this causes the issue you see and genphy_soft_reset() isn't
>>> appropriate for this PHY. Please re-test with the KSZ8081 soft reset
>>> following the spec comment.
>>>
>>
>> Interesting. Never expected that behavior.
>> Thanks for catching it. Skimmed through the datasheets/erratas.
>> This is what I found (micrel.c):
>>
>> 10/100:
>> 8001 - Unaffected?
>> 8021/8031 - Double reset after PDOWN.
>> 8041 - Errata. PDOWN broken. Recommended do not use. Unclear if reset
>> solves the issue since errata says no error after reset but is also
>> claiming that only toggling PDOWN (may) or power will help.
>> 8051 - Double reset after PDOWN.
>> 8061 - Double reset after PDOWN.
>> 8081 - Double reset after PDOWN.
>> 8091 - Double reset after PDOWN.
>>
>> 10/100/1000:
>> Nothing in gigabit afaics.
>>
>> Switches:
>> 8862 - Not affected?
>> 8863 - Errata. PDOWN broken. Reset will not help. Workaround exists.
>> 8864 - Not affected?
>> 8873 - Errata. PDOWN broken. Reset will not help. Workaround exists.
>> 9477 - Errata. PDOWN broken. Will randomly cause link failure on
>> adjacent links. Do not use.
>>
>> This certainly explains a lot.
>>
>>>>>
>>>>> This patch changes PHY state to PHY_UP when MDIO bus resume back, it
>>>>> should be reasonable after PHY hardware re-initialized. Also give state
>>>>> machine a chance to start/config auto-nego again.
>>>>>
>>>>
>>>> If the MAC driver calls phy_stop() on suspend, then phydev->suspended
>>>> is true and mdio_bus_phy_may_suspend() returns false. As a consequence
>>>> phydev->suspended_by_mdio_bus is false and mdio_bus_phy_resume()
>>>> skips the PHY hw initialization.
>>>> Please also note that mdio_bus_phy_suspend() calls phy_stop_machine()
>>>> that sets the state to PHY_UP.
>>>>
>>>
>>> Forgot that MDIO bus suspend is done before MAC driver suspend.
>>> Therefore disregard this part for now.
>>>
>>>> Having said that the current argumentation isn't convincing. I'm not
>>>> aware of such issues on other systems, therefore it's likely that
>>>> something is system-dependent.
>>>>
>>>> Please check the exact call sequence on your system, maybe it
>>>> provides a hint.
>>>>
>>>>> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
>>>>> ---
>>>>>  drivers/net/phy/phy_device.c | 7 +++++++
>>>>>  1 file changed, 7 insertions(+)
>>>>>
>>>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>>>> index cc38e326405a..312a6f662481 100644
>>>>> --- a/drivers/net/phy/phy_device.c
>>>>> +++ b/drivers/net/phy/phy_device.c
>>>>> @@ -306,6 +306,13 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
>>>>>  	ret = phy_resume(phydev);
>>>>>  	if (ret < 0)
>>>>>  		return ret;
>>>>> +
>>>>> +	/* PHY state could be changed to PHY_NOLINK from MAC controller resume
>>>>> +	 * rounte with phy_start(), here change to PHY_UP after re-initializing
>>>>> +	 * PHY hardware, let PHY state machine to start/config auto-nego again.
>>>>> +	 */
>>>>> +	phydev->state = PHY_UP;
>>>>> +
>>>>>  no_resume:
>>>>>  	if (phydev->attached_dev && phydev->adjust_link)
>>>>>  		phy_start_machine(phydev);
>>>>>
>>>>
>>>
>>
> 
> This is a quick draft of the modified soft reset for KSZ8081.
> Some tests would be appreciated.
> 
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index a14a00328..4902235a8 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1091,6 +1091,42 @@ static void kszphy_get_stats(struct phy_device *phydev,
>  		data[i] = kszphy_get_stat(phydev, i);
>  }
>  
> +int ksz8081_soft_reset(struct phy_device *phydev)
> +{
> +	int bmcr, ret, val;
> +
> +	phy_lock_mdio_bus(phydev);
> +
> +	bmcr = __phy_read(phydev, MII_BMCR);
> +	if (bmcr < 0)
> +		return bmcr;
> +
> +	bmcr |= BMCR_RESET;
> +
> +	if (bmcr & BMCR_PDOWN)
> +		__phy_write(phydev, MII_BMCR, bmcr);
> +
> +	if (phydev->autoneg == AUTONEG_ENABLE)
> +		bmcr |= BMCR_ANRESTART;
> +
> +	__phy_write(phydev, MII_BMCR, bmcr & ~BMCR_ISOLATE);
> +

Wouldn't this re-set BMCR_PDOWN?
Since this is probably required by a few other micrel phys,
maybe a kszphy_type flag and continue with genphy_soft_reset?

> +	phy_unlock_mdio_bus(phydev);
> +
> +	phydev->suspended = 0;
> +
> +	ret = phy_read_poll_timeout(phydev, MII_BMCR, val, !(val & BMCR_RESET),
> +				    50000, 600000, true);
> +	if (ret)
> +		return ret;
> +
> +	/* BMCR may be reset to defaults */
> +	if (phydev->autoneg == AUTONEG_DISABLE)
> +		ret = genphy_setup_forced(phydev);
> +
> +	return ret;
> +}
> +
>  static int kszphy_suspend(struct phy_device *phydev)
>  {
>  	/* Disable PHY Interrupts */
> @@ -1303,7 +1339,7 @@ static struct phy_driver ksphy_driver[] = {
>  	.driver_data	= &ksz8081_type,
>  	.probe		= kszphy_probe,
>  	.config_init	= ksz8081_config_init,
> -	.soft_reset	= genphy_soft_reset,
> +	.soft_reset	= ksz8081_soft_reset,
>  	.config_intr	= kszphy_config_intr,
>  	.handle_interrupt = kszphy_handle_interrupt,
>  	.get_sset_count = kszphy_get_sset_count,
> 

