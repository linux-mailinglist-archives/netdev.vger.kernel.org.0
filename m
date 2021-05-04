Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06DC372B69
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 15:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhEDNzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 09:55:00 -0400
Received: from mail-eopbgr70090.outbound.protection.outlook.com ([40.107.7.90]:8941
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231216AbhEDNy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 09:54:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZD3Ti22EGK3jpR8nFkk/XPROy6HtHRaZYRN9tPpn3vwcKACbeKBQMHtnMXJW//esA1X0bOlzQrlbGTIa7+pKZH9mDS1BlLvid54t/viGv9Z8pxRqMcGIpx3q4s1PvD/QeVJktdY/cHL19UdIfcLLqUdKJxd9KpQZwXStY48I/b4vgBOJJXuvGV4TjqxZFpcm3YzuI8soj7bbm6ygt7d4rP8/cUqhkkWVO6eDwQdz3CMVJ/rkA5KSl0f2nwxNsDvyGTTt5hj81VR+bApe+LXbubnxeB56/bv8ISIeYLdynMgxHKbLefxYO2eE/Ucibe63370hEQXZz8sptkWVBcBP7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ydj7RaCj08K9ZGUu0dRRejcz68JdBKzwu+z5xfgillw=;
 b=A25DOZ6GYpTcLeZEud4LG6TPCTqAvtaQAfYY/FkY2mXE+deUc2KTyelCqBHp9PKWym5lT7OTmufm/BgAiZHcJBvqdiBev67Rw5s6JTIMajp+iIbBrfXMC4jr7pri3rkYM7sq+EEcUe9xDZPBO6YxtgHMFhJDlEf43TPm/v+/gMX9YCAaifz67IGS4HJ6RmrQLEzYli02sWH5o/7xLQyV8l+VeTMGp6dXA9HrHMLH7RL12HX6lKjoeyC+l1fr/nLGeaTJ0sVIeISzumPY1kHdv9Cf8Ac9CthQS+o8v9Jet0O27S3NiKor/y10Jzz4Uwc2FwTNkWGS91OB9K/kVWMUDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ydj7RaCj08K9ZGUu0dRRejcz68JdBKzwu+z5xfgillw=;
 b=kdKz8IX6UOIJOc9oO5CQ68G+OPNTVi01yoVyRFXWm0EVoHmLGGpr/GPnp4f8DbTsO4h6gwD5AmM/12NjlqeEkZpJJR4HaGFiL36dVbNxwZNjyNhgetIpOPNwF6lah5OSBpCxed5sGmApoAPxgtzimwnQSGA0oVBSVYELx4/mytg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM8PR10MB3985.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Tue, 4 May
 2021 13:54:02 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 13:54:02 +0000
Subject: Re: Null pointer dereference in mcp251x driver when resuming from
 sleep
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?Q?Timo_Schl=c3=bc=c3=9fler?= <schluessler@krause.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tim Harvey <tharvey@gateworks.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <d031629f-4a28-70cd-4f27-e1866c7e1b3f@kontron.de>
 <YI/+OP4z787Tmd05@smile.fi.intel.com> <YI//GqCv0nkvtQ54@smile.fi.intel.com>
 <YJAAn+H9nQl425QN@smile.fi.intel.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <66f07d90-e459-325c-8d5d-9f255a0d8c8f@kontron.de>
Date:   Tue, 4 May 2021 15:54:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YJAAn+H9nQl425QN@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.244.177.213]
X-ClientProxiedBy: AM3PR05CA0139.eurprd05.prod.outlook.com
 (2603:10a6:207:3::17) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.27] (89.244.177.213) by AM3PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:207:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Tue, 4 May 2021 13:54:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e579b66-6c64-454d-2b8d-08d90f0412e6
X-MS-TrafficTypeDiagnostic: AM8PR10MB3985:
X-Microsoft-Antispam-PRVS: <AM8PR10MB39852A951D0A5DCD05B39E2AE95A9@AM8PR10MB3985.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bIx5HpcfXPVrO1y0Y17YmhmRsr1CQCniXI+HRdkALaSQ4S5d0dqUM2BTcvLpep5bxZ5Z8LdIUK6w34QppztmQB0mgTjh1O6yANIjWP9/y3h42OGYIbHlf2Rhtp0GOCJiF8IeceGdy0/Y/daBGGRAUV2Y+5DLq8hfiF3gVAeycjmsce8PqxLfE7+R91/Lw6Srnv5+uHx1tMHvv06dcv6CxDYtxm4Unci5PlXWVJ4Tjritem7C1hum0hQ9QxlTuFvakg2ZdnSErrACbUWbdb5nnNE+XMw+qdL5KRQ7Q8ZdMfP9hDGbyIfz+WBkA/uF7cQQf7KoTEbLQxiAv6t+hOiC3sjBc7ThmwzsAep923RlUsRX10W5EeXdbJiAbkWVyN/PtjvN5tYXZoeRV8yGUTmcl0aItuiaiZHZxolIftWbefNrlThJRKkFBPLiJDjjmrD69zWERs7scJXSPEqoG+exnyQqRZwsiLwq6k4Pgwzr6KuRoq/QGs62Q0dKgNOEDFrP9fNODL+iDmAV81wyjDM1lpPYGtAEvVzBwhnC+vz4mJyu6fdC3t913k+T6JqZMJGQwI3Hghp1pFtX5koo0tKdo06ljAsfWTtB6bHB0xW3WREBYDOucE2MnwZGRzimQs4ToffYBF8/qyRlfrUMXfSQgqjQl9A8sdgjhEMM8VUGqKNquU3Q9HchNTxyGgcfrp4I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(66556008)(66476007)(8676002)(66946007)(31686004)(6486002)(53546011)(83380400001)(44832011)(2616005)(110136005)(16526019)(4326008)(16576012)(7416002)(478600001)(2906002)(956004)(54906003)(26005)(36756003)(186003)(38100700002)(316002)(5660300002)(31696002)(8936002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RlRHMVpteGtzKzZDZFdBMzlDWE1YSFd5aFc3MDMyUDRIaHdRUHdiUmN3cjk5?=
 =?utf-8?B?YThMNGZIUit4SVFGbllvd2hiZGdpM1duMTFOQ3lRbkVGek9jTlRJVzhpN2Nz?=
 =?utf-8?B?WjFJdDJoVkVKRHR0dFBEWnVBUStKeHh0aVV3UXErdndtS01EQnlWS2VlK0Fs?=
 =?utf-8?B?TjErOFRLZ2JTR3FWaDhWUjRydjc1L1oxTkUzQlZ4NzNkbFlzbWpIeUorbHRC?=
 =?utf-8?B?WG1qQnR4a29OS0JRVmR4b3I5dlVKMEtvU1p1bHNxMTZ3eFAzRnNBbk5RNzRW?=
 =?utf-8?B?MVZRZzdoeU9oTDdoNlBKcU81R3FSLzFrSWJGajBDc1R0LzFQUFc1bWZsYUhF?=
 =?utf-8?B?WkltbnpGbTZNSnpXN1BNUWJKb21Rd3NiWnhVRlVHeVBuR21BSHorRXNjMWZL?=
 =?utf-8?B?MnpHWEJPOGo5WWlTUTRWVkxHcmJUVmE3OXArempZa0IxdTFnVVhQTGhrMlRS?=
 =?utf-8?B?Q0NoZzBraDRDUzh5NnQwMnB5dkpoQi9GVlhncENVeTJZRUJHVVRGWkkrMDBn?=
 =?utf-8?B?RmN0QmVseENaMFR2d1ZSNVBHVnUzSmltNzl3RFZ3K0V1djhuNlFsWXE4dGxJ?=
 =?utf-8?B?R21jdU04Z05lbGMyWVBFSmE0MUpIYmpFUTM1VG9SdElvT3MvejZHdDc1b0tV?=
 =?utf-8?B?Z2o4MnIrV0RoQXdmQU9PRHY5dFRtakxqUSsrMkpvN1BFN0M5dE9vVDFsSEN2?=
 =?utf-8?B?RFBoQVduRW5UakR3ZUJQWmk4cFZRUW9OZFpEMjJJTmVza3JSb2xrQWkwcVpV?=
 =?utf-8?B?SnBQNnFVamEyQUkyRTJRZG1CL1hhdUJKbDhhTFh0VFp2RkFUMnBVTExHWXRk?=
 =?utf-8?B?cUQxMlFzQWNETk5GVnp5SXV2SlEwbFlER3hKc3BIOFpaZ2t5Z0tud2QxMUM5?=
 =?utf-8?B?VFl5UlcwYkpwdnY1cGQ5VkxvWGtUVk5NUDBEVTc0cVBoWlIwbGgzajd4Tk95?=
 =?utf-8?B?LzdENDJpMVBoeTRKK05COVlNNXZ5cEtRcVd3MnRGcGtBekg4bit6WUxXbFZv?=
 =?utf-8?B?MDRqWENQd0N4VlZ0ZitQUUgwM091UXlzdHNEZlFBMjdGVTIxb1NjK09BUVNT?=
 =?utf-8?B?OG5MZjNhTVhibGNmenhmNDYrWkJmdHRhM3F5UkhtVWl3ZjlJR24vVEltTVpp?=
 =?utf-8?B?b3R3dWhFZERKd284SHFKQmNsVjdDNnVkaUxHQXlJYzd0VkY1N0loblFFczgz?=
 =?utf-8?B?TjBlcmsrTWJSNC9ac0tERFhjQ1o5T0RnWWdxcFpsVEFpQ3RWR0c5QmdZRjJa?=
 =?utf-8?B?R29aK3JqM3V6ekI1VjhCZ2ZnODkxa0VVQmpkZEZicEx6Qi9tdGdNcGVYNVd6?=
 =?utf-8?B?a2szem1UTEhoSjNWRHlQbmVqT21abERWTDdOTktMaWpCQzZSeitLK1FXUTBU?=
 =?utf-8?B?c0VOZTZRa0ZYK2M1THplbG9WbUNTSUErSVN4aEoyUk1rSWY3WGNxMm1zNE5O?=
 =?utf-8?B?VmtYMDM5UzBZb3NyMHZzWEc3NGlIQmFQb1RSSThuSW5qYmI5RnBOUVZPRDVY?=
 =?utf-8?B?QzZubmtmMytiNUpJM2w0SmRhRXEvYmJCaXhOSzdOVjlMRXJWei9DWi95VVZW?=
 =?utf-8?B?YVdwSU1XY3JybXdLSFByZWxtbVIzb1dseUVmZXJEOWc2WWFRMitrc0EyNkda?=
 =?utf-8?B?Q1BSQ2hiV09EWDlocXY2ZHA0YW5XQ2c2ZC9RYnlvM1J4UEtpZVgwa1pKaXRw?=
 =?utf-8?B?dTZacldwa3BMSndpdHJpZG5EYnNhd2FPWW5Zc3RNS0F5V3dOQXVPNEtaZXV3?=
 =?utf-8?Q?pkHFcu9m2wBuHQYl5bNrKTBk8d6G/z9E1ILHiF9?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e579b66-6c64-454d-2b8d-08d90f0412e6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 13:54:02.4104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/CICNW6oUdwE4F9sXIkqXXCe3isgWDr5V/opdpVubW0wxriFmKAvzjDY6Cm7P7U0/GD4xAZlGBwJFXvxYfAc8bhhIyBft9+cUacqWb/Rhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB3985
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.05.21 15:54, Andy Shevchenko wrote:
> On Mon, May 03, 2021 at 04:48:10PM +0300, Andy Shevchenko wrote:
>> On Mon, May 03, 2021 at 04:44:24PM +0300, Andy Shevchenko wrote:
>>> On Mon, May 03, 2021 at 03:11:40PM +0200, Frieder Schrempf wrote:
>>>> Hi,
>>>>
>>>> with kernel 5.10.x and 5.12.x I'm getting a null pointer dereference
>>>> exception from the mcp251x driver when I resume from sleep (see trace
>>>> below).
>>>>
>>>> As far as I can tell this was working fine with 5.4. As I currently don't
>>>> have the time to do further debugging/bisecting, for now I want to at least
>>>> report this here.
>>>>
>>>> Maybe there is someone around who could already give a wild guess for what
>>>> might cause this just by looking at the trace/code!?
>>>
>>> Does revert of c7299fea6769 ("spi: Fix spi device unregister flow") help?
>>
>> Other than that, bisecting will take not more than 3-4 iterations only:
>> % git log --oneline v5.4..v5.10.34 -- drivers/net/can/spi/mcp251x.c
>> 3292c4fc9ce2 can: mcp251x: fix support for half duplex SPI host controllers
>> e0e25001d088 can: mcp251x: add support for half duplex controllers
>> 74fa565b63dc can: mcp251x: Use readx_poll_timeout() helper
>> 2d52dabbef60 can: mcp251x: add GPIO support
>> cfc24a0aa7a1 can: mcp251x: sort include files alphabetically
>> df561f6688fe treewide: Use fallthrough pseudo-keyword
> 
>> 8ce8c0abcba3 can: mcp251x: only reset hardware as required
> 
> And only smoking gun by analyzing the code is the above. So, for the first I
> would simply check before that commit and immediately after (15-30 minutes of
> work). (I would do it myself if I had a hardware at hand...)

Thanks for pointing that out. Indeed when I revert this commit it works 
fine again.

When I look at the change I see that queue_work(priv->wq, 
&priv->restart_work) is called in two cases, when the interface is 
brought up after resume and now also when the device is only powered up 
after resume but the interface stays down.

The latter is a problem if the device was never brought up before, as 
the workqueue is only allocated and initialized in mcp251x_open().

To me it looks like a proper fix would be to just move the workqueue 
init to the probe function to make sure it is available when resuming 
even if the interface was never up before.

I will try this and send a patch if it looks good.
