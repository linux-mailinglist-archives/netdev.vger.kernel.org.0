Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD4F46CE23
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244451AbhLHHNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:13:23 -0500
Received: from mail-eopbgr1300128.outbound.protection.outlook.com ([40.107.130.128]:40112
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240004AbhLHHNX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 02:13:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiXHDQz0dVkKMWgl/MrIoB8rXM/uk1m7sfZTTTr3FlejUWVRyfpidy8fsfi47wyp7uTwW2jsz9/zeLlZN17F65Te68TyoB8HIYuhBSaabAZoKDCWuIHRUuu2bl+ytMOZ/xFVABK3jfmkGU7BCnfKRGcHFPTKZzbCw3YGQZA3iLyi18QX6Hu8BAGAfAsfmWOlPKe4iolHvBS/qrPEjykESgLkCn+2pKoKYscbFwCTBGO5jjdD7rIWnZYpQhKN0lFens2kN63YncmEp7OXXvd602URMlEcVwJ+iuCrUBgE0+h+p8FQjO/MtQXXsvfh1MOuUHIf09memmjJlpPYECJzGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yM8aTaG/kZO0zd+8PIKiXDhwRmNnbetivJxMtZ5Qeo0=;
 b=YxfOYv8xMx+H1TA1iOsKZo/7Pe4YzPJ4bjfmzvTBkDxGG4m+6C8GTWA1hcGuHAkRt4jQbs3hTyKgBRhStl/jGBHoWS5emNdsARaMW/ovW/ypLZy/yEzDiGvpau0n1cvZVfb7fDSxMM6RjGWHUWpyiGvjOjh3wGcHBdMPeqCUj2RLgZ2/rvw/oEvOFkHQDaUhEu1aqXjnVWVR56aJ7eCL3hSWN1IHshKfn6TzahLFjCn+G7ssXWOaz9BrGIjqCh1qkAUaV0bVYiK4yYgplkk9lTWnrynJ4fwzhKJXxx58jr7Qcn5madjIhgejnfJQjGFAZuHkyZmME+TM2jaA6fa4sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yM8aTaG/kZO0zd+8PIKiXDhwRmNnbetivJxMtZ5Qeo0=;
 b=amD3AFavFY0seC5UDY6zZLqxcV/y5nn93RqKri4Tg1Zujrgl820TlKmjpv072T18HAbX1jAIT4I51U+vtMHubBH8P616iIQDVwnutxAH4bg55x6TmjpucRsQiZNsGeK5iekzK9R16gtkHdsOvG5mrfcxVJnGAl7KsXhhfyvs+y0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK0PR06MB2882.apcprd06.prod.outlook.com (2603:1096:203:5c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Wed, 8 Dec
 2021 07:09:46 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::8986:b885:90d7:5e61]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::8986:b885:90d7:5e61%3]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 07:09:45 +0000
Message-ID: <a096fa59-4a32-237a-e06f-a86dfc74a310@vivo.com>
Date:   Wed, 8 Dec 2021 15:09:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] net: gro: use IS_ERR before PTR_ERR
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel <kernel@vivo.com>
References: <20211207073116.3856-1-guozhengkui@vivo.com>
 <AG2AqAARE0*4ic4l2539l4rv.9.1638888118554.Hmail.guozhengkui@vivo.com.@PDIwMjExMjA3MTQ0MTM3LjIyNDU0LTEtYWxleGFuZHIubG9iYWtpbkBpbnRlbC5jb20+>
From:   Guo Zhengkui <guozhengkui@vivo.com>
In-Reply-To: <AG2AqAARE0*4ic4l2539l4rv.9.1638888118554.Hmail.guozhengkui@vivo.com.@PDIwMjExMjA3MTQ0MTM3LjIyNDU0LTEtYWxleGFuZHIubG9iYWtpbkBpbnRlbC5jb20+>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0113.apcprd03.prod.outlook.com
 (2603:1096:4:91::17) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
Received: from [172.22.218.99] (218.213.202.190) by SG2PR03CA0113.apcprd03.prod.outlook.com (2603:1096:4:91::17) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 07:09:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d91e801-1422-4814-1df9-08d9ba19b6ea
X-MS-TrafficTypeDiagnostic: HK0PR06MB2882:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB2882545DDD176F4857D61671C76F9@HK0PR06MB2882.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OiPugfE7aF3SFo8i7hZrokmW/HSI3K6dLZgQmq96k5U3V7sCC2PCCiP/IVB6ssrQqlxu6AQXrNwEWfw+KXi9SUQq4VQutl1sjIcIdO7Qj6LCGpkesRZS4ewHvoiScxVtjFJJs2UOClvRE/9c/24vrSmUmvMUydjwKAlpGsn18NtpVP2xrYT0N0c8HC1B7NaIqFfdq+IqVN+jIrEqLCoGjMNA2VVDyNJxeveSbcM3S4Gy11JW018/FDdGMlLNONkMuTA8pgxj7OUcjW1NFVAK3o3EfvKSRPgEFVBes8Gk3ZTvWDvlmDuJh4Rsqz/SRkA4DKH6RgP1l1iMpSBWD7tZvbEEDX39e9jQ0x01FkAzVycEjqsitSdY0bCM7XsM389xuH+BiyJORbhvqTvoRiPh5LlPiAnki7TOPmxfFxprlkkPGvza1OTl2H/cieP+8qCdYd07emEf+SRPR4mfs6rSegM/Pz0uY5d1eiCq1V85wGe95Vjh4rVWy3TiLElCcw76ldxrwhhYIvSLPLAs79xPCkvxNCEJJM1L1psjFFv4/+x8Z2AQv7J+3HXTOZXQk25rzhg7i/z0vFAImVwzQlrNv5nhC07wj4sw44dWmNg5kcmMj0h6hjPtosvGAkHinDQydWJNmJDQLmhYWw0Bkxr+DcEf4S3EdNUeIcCDGX8esByJK4JvREMtm/jzU6gtFeaBnozX+TaVzWJq6vRgjXGtgSk4tIyjwlS9wWrqjwGgMGqcxMFMWxTd/fnwAdj4I/pOJuM0uoZFrDeD4M+d8jABNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(53546011)(6486002)(8676002)(8936002)(36756003)(2906002)(16576012)(6916009)(54906003)(316002)(52116002)(86362001)(31686004)(26005)(107886003)(186003)(38100700002)(2616005)(38350700002)(956004)(66556008)(66476007)(66946007)(4326008)(5660300002)(83380400001)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UCswR1RDdk5ILy9OeXJ0UFZQOTFPeHBvY3Q4bEJLRDVaMVp0QUdHV0FOa25V?=
 =?utf-8?B?eFM3Ums4bDVjT25VZWMreG9GL0l4SUN6NFpDZGtqRGtJa09rakRuUXNuMWFn?=
 =?utf-8?B?Y1FvSzJJOG4xWHpNcWFGN3d2ZGFVZmFXcE1iL2ZWc1lsRzN1NVQxdWRLeXVH?=
 =?utf-8?B?bW5zL1U3TklTeWN3dG1xWDVnS1B4K0Uxdkd4S0Nsc3ppTTFDN3pxdEZzc1dm?=
 =?utf-8?B?Mk44MmhYa1hIcXlmbEhDd3h4cW16V0pURllZSzBtRSs2U0RKNXdTSUtPSGVr?=
 =?utf-8?B?UkR3czRxenBISjV6dlNqckNhMS9TaFNDODMyNGI3MFlDMkM3R0tOT1RrSDVn?=
 =?utf-8?B?SXZyLzZjWW5ndFF5c1k5cHhqSnVTSUlURGxwS1hwZWlzSFQvRUpoYi93Rm9r?=
 =?utf-8?B?VXB6dmwrTnRSb1luR2pNTVV2dFRsVlJlMGluanhYY1VjT3pXRXpueW1EcjFQ?=
 =?utf-8?B?NFR0ZlVSTWFpMHhidnk5a0hMVzY1WmhPSEdlaHFIL3pQYnF0cmFUTEZISHVn?=
 =?utf-8?B?TlJONGVFVU0xVnp6TE94OFNROTBTdDBrekhBTWl0aXlTaFhXVFYwZEtDT0pw?=
 =?utf-8?B?SDE4ZUhnOGhUcG9jR2Ntd1JoVG56eHZlNzAyUEtnSHlGMy9uSExpNnRGdFpN?=
 =?utf-8?B?ME90aStaUEZHZW1HM24vUFpCUTJUMHloUG9MeEpEU042RklmWGhrWUJHb3k5?=
 =?utf-8?B?MGxuVW0wRFVYbzlZZUZMZFZSQnpaQTVRYkZhMVMzaCtBak9rYXJtYUd6OGRG?=
 =?utf-8?B?UnVsU3lLT0VjSzVIZ2Y3RkZUVlJXR2pzQldTTElyT1hHcy9LcW1taDRSaVNu?=
 =?utf-8?B?aTg2cVFEVHdySmF2djZmR09SdTFndnVBb3FXV0x2V1FQd3poeDdJOUxFSTRB?=
 =?utf-8?B?SGgzZzZzdFFtby9vOTlBdnFsWTdvdGZpZE1zS2VXbW1IL1p0Rklsb0xjcVdk?=
 =?utf-8?B?UitjOFRTK2FBUnl0K2h0Qlp1RW5QMmJpNVVHMXRRM0hjL04vZXZuMmMxOTZE?=
 =?utf-8?B?UmdWeC9YSk5oOXZJMVZRcllhUUEvTmgwbEJpQzJIclRxVGlOSWRpTUZ6bHN2?=
 =?utf-8?B?bDhQbWNjVVkvYmlTS3lHbHRBZlVwTk5xeFVza1RGYlQ2WkZ1eGlESFQ1R0Vx?=
 =?utf-8?B?R3VkUi9CVnVmTzNYc2JWN1ROV3R0OXJ4MisyN2FrZkJOM0N6R1VJcmhnS0hO?=
 =?utf-8?B?akVLQ0Q3SGdQYkl4Z3VKWFFZUWpPeUVUbkRtY2dMMlQ0VTFWYlRRQ2JLV2ps?=
 =?utf-8?B?cWFXN05FYUhkQUc3MVZoeFRoQWx1bFNJc0c0MmdMNndEZU9oZTNzanJJMGVl?=
 =?utf-8?B?UG5UOU5qd0x2d29QUlVKWUtpb0lyYjVPdkpWMWM3YllMQTBCWDlzNGpFVjJq?=
 =?utf-8?B?d3hleWRpemtBcGZITmNmZk9jcHpBcStVZ09oaG1vM0pKWGRsSkNmNExvTE1M?=
 =?utf-8?B?ZWQvUnVmN2EzZXBadjhINHgxR1FaczVLa2FCUS9BZUJTcFMxQ01LN0IxVGty?=
 =?utf-8?B?V1V6dnFseG8ydXpZNnJKQmdVYllWV1FYUGU4Q2ZjSzVGN3p3SnVhTzNaQVZi?=
 =?utf-8?B?RU1WdGhKdUwxVHpTcTlna091R0huTnBscE9SbENNNzhUMTFvcE5iUTFFUndK?=
 =?utf-8?B?RmhSUjdHczNjcnFJV0gvVjZlbVlzZUVEKzhIUFlGV2w2TXdkclh3YWFpVUox?=
 =?utf-8?B?SDZ4WDFKYVFzcVhIV00ybEhRMVEzZXdxTmtweVZxeTZnT05mNjNVWEJOS1BB?=
 =?utf-8?B?NmI2S2NTM3d3d2htODdBa3laOXR2Zm01dDFWZW0wTUdpamtkUmRtVGQ5aGl1?=
 =?utf-8?B?NEl3c3ZDaFBIQ1NjYlcyZVJMbzFGSU10QXgwbVcwd2hWRStJQjMrK2wveFRK?=
 =?utf-8?B?bWRjak5INkt1WkJkWnJPekpDVkM1TzFhUis1eG5mZFh0WFg2TWFHV284Skds?=
 =?utf-8?B?UTJOaW5CcEhwbTFGRjQ4cS9IUlVEbnc2dUl1ZEJDYzdvYWVzYjhtZnNRYkJ4?=
 =?utf-8?B?amltd0g3OGR2bUlmM29GcFVhakFWbklDVXVKeTdYbEVleVZkTDMrWkQ5ejZ4?=
 =?utf-8?B?N3JVd05iNko2eGV4RmdOU1RjZHlDSGN2ZFpyeG5Dd2RtS2pMSWs4ZkU5NVFy?=
 =?utf-8?B?VUt0b0NUYzBwSElRUWNVMUM2QmJQWXYyajFpM1hJT1lOUGtQdXp4YmZ1TlRZ?=
 =?utf-8?Q?XX3eQX3xc3aMHzwbM7Vkm/M=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d91e801-1422-4814-1df9-08d9ba19b6ea
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 07:09:45.8037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dJ6It0hwmnZD/N8JvO2J/NZrEZGt6/xWMe9372Y9Kviswj2/w0PgkjBPZRB3IgcT2s3cKrbbfGskp2R9iy7VWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2882
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/12/7 22:41, Alexander Lobakin wrote:
> From: Guo Zhengkui <guozhengkui@vivo.com>
> Date: Tue,  7 Dec 2021 15:31:09 +0800
> 
> Hi, thanks for your patch.
> 
>> fix following cocci warning:
>> ./net/core/gro.c:493:5-12: ERROR: PTR_ERR applied after initialization to constant on line 441
>>
>> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
>> ---
>>   net/core/gro.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/core/gro.c b/net/core/gro.c
>> index 8ec8b44596da..ee08f7b23793 100644
>> --- a/net/core/gro.c
>> +++ b/net/core/gro.c
>> @@ -490,9 +490,11 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
>>   	if (&ptype->list == head)
>>   		goto normal;
>>   
>> -	if (PTR_ERR(pp) == -EINPROGRESS) {
>> -		ret = GRO_CONSUMED;
>> -		goto ok;
>> +	if (IS_ERR(pp)) {
>> +		if (PTR_ERR(pp) == -EINPROGRESS) {
>> +			ret = GRO_CONSUMED;
>> +			goto ok;
>> +		}
>>   	}
> 
> `if (PTR_ERR(ptr) == -ERRNO)` itself is correct without a check for
> IS_ERR(). The former basically is a more precise test comparing to
> the latter.

Yes, even without `IS_ERR`, it runs well.

At least, `IS_ERR` before `PTR_ERR` is a good habit. :)

Zhengkui

> Not sure if compilers can get it well, but in ideal case the first
> will be omitted from the object code at all, and so do we.
> 
> In case I'm wrong and this is a correct fix, it at least shouldn't
> increase the indentation by one, these two conditions can be placed
> into one `if` statement.
> 
> NAK.
> 
>>   
>>   	same_flow = NAPI_GRO_CB(skb)->same_flow;
>> -- 
>> 2.20.1
> 
> Al
> 
