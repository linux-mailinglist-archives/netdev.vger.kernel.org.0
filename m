Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350B1373608
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 10:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhEEIHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 04:07:35 -0400
Received: from mail-eopbgr20133.outbound.protection.outlook.com ([40.107.2.133]:30619
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231829AbhEEIHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 04:07:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TG2qD9XVp3PDaLBYNbdLqX3KYSV/riutaH0UXDrQXH0QQ//QT+xpAMEw1UINsqlXVcj7Xb/7z2wviDPw5SOG4NRsFjYPkk4jYxYYrEUD952SqeICZUI/+y0k2p7M+wOMBzSjZ9qE1cPm8NfUQdv3boBCzRLfQZ02I1IffBTVyTAkZTzdzy7pw5+370GHr8GPNmI4xmub8j6zM7bL0KgdDFqd/GBZZ0KhpSzusVmFo3URXJrMcD3esWajFeMYSqmO9rvOHk7LfrRjMoUe6J4/QC1PMsp0ORfyrd4Iy2XPjKpM97FIgFnD/3UzuPIWzzRR9htEIaCQNRzypq9fQj8HsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PI/UpSOrXbkY3oiFUh544jygI4fK47wyICP2r/0oiOY=;
 b=LuzFALXx35fKc8u/ZtvYsJcqTf7LVeAR9g/2v6Dg/d9bgtXOegkVEuL7bfrOQnEBD7hNz/qgsgLqgSLl5Iz2uqV0v+3MoO1QJVuqWO7DJTloCQjbPRQbht4WdvdvELTN1W1DATHei/j+0LlotLZtJrzNEILSA4u4M4XVAsBIvU/3Np0o418L1nJZWtYGKwvNiduMVfd4TxXqWutN/mt/q7in/XdRFFT9Ns/AX/YDpemXQtZe0yQKN4bbvCCPFx/mJfkLtCoDLrdeARD3C0xf92zPAXJApdt8pnYmwb6gLtyDvzsP4QBsEISIWu99CJVcqHnWgjp2mAFM/tPKuOw2DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PI/UpSOrXbkY3oiFUh544jygI4fK47wyICP2r/0oiOY=;
 b=NnDkxhajNBKyMr80FsiW5e7us1lz7kxX/EMz5zzNZ8JslsKl61knQUZcNw8Hjk7FhDexhQld+EmpOTfAMapdIpd+bt5OGEq0AC0MOBPjc4lw+J+ZRDOkG0n2qCMzt2lOc4zY5PqxCjWwRVyUQkzyVmoWb/CDUy360sF/TFToayA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2354.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:da::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Wed, 5 May
 2021 08:06:33 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4108.024; Wed, 5 May 2021
 08:06:33 +0000
Subject: Re: [PATCH v2] can: mcp251x: Fix resume from sleep before interface
 was brought up
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        =?UTF-8?Q?Timo_Schl=c3=bc=c3=9fler?= <schluessler@krause.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tim Harvey <tharvey@gateworks.com>, stable@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <17d5d714-b468-482f-f37a-482e3d6df84e@kontron.de>
 <20210505075127.yrx474t5dkpxxdmt@pengutronix.de>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <96710db4-f330-eb3a-71fa-570dd651aee4@kontron.de>
Date:   Wed, 5 May 2021 10:06:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210505075127.yrx474t5dkpxxdmt@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.142.67.208]
X-ClientProxiedBy: AM0PR02CA0164.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::31) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.17] (46.142.67.208) by AM0PR02CA0164.eurprd02.prod.outlook.com (2603:10a6:20b:28d::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 08:06:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7039707c-8642-411b-6a54-08d90f9cb255
X-MS-TrafficTypeDiagnostic: AM0PR10MB2354:
X-Microsoft-Antispam-PRVS: <AM0PR10MB2354E83AA7F6A2387A5684FBE9599@AM0PR10MB2354.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vqYjdvP/zkaSTCSU/xdsyCvHNl3K+X6dTs+ilih3tvWZ6qOTDdX3ID/OesduSXqBrjkmKJkOwqEbU28PsTREwj+EOPFUw9dSOvjGlTfxFeDh2EPlXKZwAYnoJXuzSRwLno8x4pGdEvg+HMKX22e1Fztki9xY0fvukjolZsvMmg65NFigjpb8OPGXffADS5HMm9W4aapjqBuDs5ArO2Il6+yKLaBbsKIxytNISfyA5uMr86q+tXmiSP9hj6KCCqx75XJ0IfXSIQ5Pg5iihJ+i6dKqBXyhIBB6FtedCjvj4TrYHjdesB/x9Uh7Crnlc1gctzph+cVFrMQPA+bFIC3cd6C9LRGzVG2zlwhhYjIENwd+pu35j+yUF/hyFi4JpDP1QkjvUsT/IGjODbo25gk8YrrUtCwscnOGFRRd33OiI40PwXXw2n5KWJYJcDSvm1zBvcnBDyS5zHVJe7X7/AJhUvZHlZ3hQb23+GyGEIi2zjVQVyzjSkveZ7VbPmz+nfQ86TZNR/Ya5XVmr7x6U56LxNtSpf9gg4TbLsUQIhAwTdzJr+7EGWctEUpDg2dSCl0YFo8vMCoi8w+eLMVWulQP3Qoa+wtIVkRo4KKdqBM3iNm02dHD+tLwdcRGHYErsK6YP8benrSXmbLTtIN3wteUKv/fIEcewK03wQ1BdUaNvG8tcsstKjQPU9jSPtzxfdED
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(376002)(136003)(39850400004)(2616005)(44832011)(7416002)(86362001)(66946007)(6486002)(36756003)(31696002)(4326008)(8676002)(66476007)(66556008)(956004)(5660300002)(2906002)(6916009)(478600001)(316002)(31686004)(16576012)(16526019)(83380400001)(186003)(38100700002)(53546011)(8936002)(26005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QzNRVmdaMTkydWc1c3U2WWYweEVFR3NpYTBTM3Mzb3ErMFpmeFZpbkNsaGhx?=
 =?utf-8?B?R2tEN1NhRjVBamJIWjFXRXIvRlVHWERwZXFVNCs5S3BuTkRSUmd4eUZKSXZB?=
 =?utf-8?B?eGxLSDlJL2xRU3E3TFI4amxLQTJ2MkYxQVJHTDBuSTFoczRtRXVwZXp1RjR4?=
 =?utf-8?B?WVg5QzBnMmpOeEhwV2NmTTR3UmtNaFJQUExWZC9NeVhWYzJHek9YQ1BFQ0cw?=
 =?utf-8?B?VnN0MVNDdE01dG9leE9RdmpUclRBYnBkT1JqcHRyVjI5bmh1YVNUSmRxWVZi?=
 =?utf-8?B?OTdNZmxpcFNGZ2pmTmcxQlpqaTdQZm5SU0lPaWFYblVMUTRWVWNUT2VtZkVt?=
 =?utf-8?B?YnhuMkRRaUlTNDNVOGt3WDlYdGtpcHNVSzhzKzBPRXp0emtCTUZ5dFdDR2NL?=
 =?utf-8?B?RnVBdzdSTnVtaEtlZldybE5WMkRzc1Y4ZnErd2MvRVkxak9NU1U2d3Qwbnho?=
 =?utf-8?B?TVdRU2hZOHpHSjJZa2JkYThDUkRZWVdmeWlleGMvb2xaWFlub3dmaVNaSVRZ?=
 =?utf-8?B?bXFGT1BvSVFSTFEwbk9KZWN3SUZhN05sdnI4L053YjZSMHpyUEpZVXNGRWdG?=
 =?utf-8?B?R3lGcFFCdTh3dnhqeHo2c2JyTXl1a3lEYmlybEROallwL3d1dDRZaWhsUFE1?=
 =?utf-8?B?SkxmLzBOU3lRVWxpeTdOTm5ic1N5RGtiTkZiQXdSa284cGZkUnZHRXFsajY3?=
 =?utf-8?B?MDI0VU9oWFJOMVVRM0wvRlFjdnozUW51aTlLODJMZVdmVElHUEJDWjdPUStw?=
 =?utf-8?B?VFFLcE5Kbi94cHM5bElpTE5QdDBDUHFtdzZ5eUxGb3pldU4rYjFSOHowWVQ5?=
 =?utf-8?B?OHd6L0RNYkhUZ1YzcHUrTkNlK1Q4aEsweUpnWlBYRG1uaGQ2OHpJUWIwUVBx?=
 =?utf-8?B?ZVlLOTVtMnpQWWJTMnd0UUxBVzg0cG0vczhmcXZUeGFNRGNCZUwrb1E4c1Ey?=
 =?utf-8?B?YS9NS2lWRkxZUExCRlVKV2oyOEM0WHNFWE5TWjh2eEdOQXlTWEE0amNieUVr?=
 =?utf-8?B?a0NJeG1QTDk1cEkzdmhGSW9NUkVtOElMSzErY1ovSnRiRStXLzFwTG56WWJ4?=
 =?utf-8?B?eTRoaDdVUFVSTU1hejJORnlFeGdIYWF0Tm9zbGtwVk9RYVdsc2pNbkZKRFZG?=
 =?utf-8?B?c0dFdncxVWJWeW1zUTdKaGdYUmFrNHJBMGlmVmtXbnFDUHRkcWdQclhCbnR1?=
 =?utf-8?B?OHFaaG5VMEp2Y0pHcnFobmYzdFNoU2ovVXVGQWZxOXdWb0h3TkxyTXBLZkc3?=
 =?utf-8?B?Y01ZNy8rajFidkoybitCTjk5MzFyTFFJZUxvS2hWVUdZZ3hyOU9mSnpoWXFL?=
 =?utf-8?B?TUNobm15NnczWkRrMkNYaWhFb0xRUFllSkJ6V2kreU00eUVFQ1doQWx1Yjd5?=
 =?utf-8?B?ZmhNYWQrdnRuWE9aOURpOFpROFd3QVFaZFllTnNuRHVreFhzeHBlWkxkbVZL?=
 =?utf-8?B?aXhpeGpHY0JmelNwNE1nM1hTbkxTZmdOSEJwektaMG1PQTJhNWJVeXR6V1k4?=
 =?utf-8?B?ZWtwUTRaWUJHdy85TVBjYlA5Nm53MkkvQnZWK0RBdTZxNE1kaWp6cEV0UHA3?=
 =?utf-8?B?d2MvTXFxeS9zdHdnYUNxVjgwMUhyNTNUZFpMcW43dFVDQkMxUU95OFcvaFJB?=
 =?utf-8?B?aTZTOHVrTUJNcXF0RUI1ZkRPdTg4UGxsVkRKeGtEK0hpUUlnMHhma3E2K0Mz?=
 =?utf-8?B?TUZ0NlQ3YkZIT2ZxSGtobUFWaVlUMWxKcG5Bejl6S3NjTThCVktoajNPR3RS?=
 =?utf-8?Q?oPeiEBuoCNSARQY/8heIGZWJxrycmEEGiWR8n9z?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 7039707c-8642-411b-6a54-08d90f9cb255
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 08:06:33.2262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5rva6/cz4Vrw89xf0O9jouVZfaeYtlMn3FaAWphfc/1VPiMgAO1rKDLfD5vDH/rMPDdMR74bZIIDq9U95YPIqT7Bx8Gj4J/rg1B3p6YYNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2354
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.05.21 09:51, Marc Kleine-Budde wrote:
> On 05.05.2021 09:14:15, Frieder Schrempf wrote:
>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>
>> Since 8ce8c0abcba3 the driver queues work via priv->restart_work when
>> resuming after suspend, even when the interface was not previously
>> enabled. This causes a null dereference error as the workqueue is
>> only allocated and initialized in mcp251x_open().
>>
>> To fix this we move the workqueue init to mcp251x_can_probe() as
>> there is no reason to do it later and repeat it whenever
>> mcp251x_open() is called.
>>
>> Fixes: 8ce8c0abcba3 ("can: mcp251x: only reset hardware as required")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
>> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> ---
>> Changes in v2:
>>   * Remove the out_clean label in mcp251x_open()
>>   * Add Andy's R-b tag
>>   * Add 'From' tag
>>
>> Hi Marc, I'm sending a v2 mainly because I noticed that v1 is missing
>> the 'From' tag and as my company's mailserver always sends my name
>> reversed this causes incorrect author information in git. So if possible
>> you could fix this up. If this is too much work, just leave it as is.
>> Thanks!
> 
> Done.

Thanks!

> 
> I've also squashed this fixup:

Oh dear, I really should have looked at this more closely.
Thanks a lot and sorry for the mess!

> 
> | --- a/drivers/net/can/spi/mcp251x.c
> | +++ b/drivers/net/can/spi/mcp251x.c
> | @@ -1224,13 +1224,13 @@ static int mcp251x_open(struct net_device *net)
> |  
> |         ret = mcp251x_hw_wake(spi);
> |         if (ret)
> | -               goto out_free_wq;
> | +               goto out_free_irq;
> |         ret = mcp251x_setup(net, spi);
> |         if (ret)
> | -               goto out_free_wq;
> | +               goto out_free_irq;
> |         ret = mcp251x_set_normal_mode(spi);
> |         if (ret)
> | -               goto out_free_wq;
> | +               goto out_free_irq;
> |  
> |         can_led_event(net, CAN_LED_EVENT_OPEN);
> |  
> | @@ -1239,8 +1239,7 @@ static int mcp251x_open(struct net_device *net)
> |  
> |         return 0;
> |  
> | -out_free_wq:
> | -       destroy_workqueue(priv->wq);
> | +out_free_irq:
> |         free_irq(spi->irq, priv);
> |         mcp251x_hw_sleep(spi);
> |  out_close:
> 
> Marc
> 
