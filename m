Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B8439F8D4
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 16:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhFHOUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 10:20:33 -0400
Received: from mail-vi1eur05on2102.outbound.protection.outlook.com ([40.107.21.102]:40160
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233116AbhFHOUc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 10:20:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+2r9z8ydQBj0GoB9k3QPynnVSB8JV2quQTBZ0BZNr5GHHgXSSMZtJibPTo3jMXqKcnRPL98ZhuN8jOCcf7FqQxhofpV6UgbgyYHcLlwn+pRKQzNkG5tU4ehYlDN4+TnFyOBQ2/IavXXE5tzAOzyAnyBxXbAZhSiDY9hMFaUydYTboNa+sgN+7gzG7IsDgdIeiPnQYjeTC2uUT6yipTxDxKEnQwnjUUjX+qAcYep9e7+Tt+twEvzSRG/HCKmJ+YicpzIbRVTMI2a9pHPFLG05zAuA/1nWn0HjCDyWK8gfapqV90mico0TpV8qMZyKCsi6wO9eOASvV8eaibezOIhEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7r0wGshcLQeP6W5n6q84DsDPZjbl62vr6uNGFd3RXMo=;
 b=Axbz7u5s6XKwfgeGhy/BUb1kblMP0eXIE/LqQdOtudvq4lfknourwcmEesVwZYNK+qdxQ8+0KhGgNujgP6ZfOtAg0cl+lR22X25cD2qvxhcnfsAAVReUSB/GLiIt289CWyTG+8zezo2H0CfYzFjYJj9oGjcOT4fAxw6nsWvBYNaKP97e8JVwqGHYppigYLdPpV78K3BXTNlAlRKlx3RkCPrtq6vNErQ2TyZJmmUi4lc/3mMnSU2ZJEh2T5phupSHmmcGjLhB6qLvhPOEPFRH1wMU+Y840VEEp1PEL159VqwqE5g/nd+Psf22tHoBZX01YprwiM+DZbdj0AGyV1wkww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7r0wGshcLQeP6W5n6q84DsDPZjbl62vr6uNGFd3RXMo=;
 b=ik5zr3D43SPclNqMsWhcd5thbbLJ8jCRUg5vkwaOdVoTAcuEXcLjWxGGJdkzpwSiUdYTH7e2dwugg0OjZlrta3Qj45kgUKPu6A/iCiloyg5shrqxyjnm+FtO+vXdlScziT5NI7J0P8WFxmWSVzs8pt1pyyjOs8XIUt2oKejzfsk=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM9PR10MB4069.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 14:18:37 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::1133:8761:6cc9:9703]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::1133:8761:6cc9:9703%5]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 14:18:37 +0000
Subject: Re: [PATCH V1 net-next 0/2] net: fec: fix TX bandwidth fluctuations
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
 <DB8PR04MB679585D9D94C0D5D90003ED2E6239@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YK+nRkzOhQHn9LDO@lunn.ch>
 <DB8PR04MB679556065CABCB72C79815D7E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <a3ccbaab-3290-43a8-b105-7f61da2a2f3c@kontron.de>
Date:   Tue, 8 Jun 2021 16:18:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <DB8PR04MB679556065CABCB72C79815D7E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [89.244.177.254]
X-ClientProxiedBy: AM0PR02CA0141.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::8) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.32] (89.244.177.254) by AM0PR02CA0141.eurprd02.prod.outlook.com (2603:10a6:20b:28d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23 via Frontend Transport; Tue, 8 Jun 2021 14:18:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fba79626-61bf-45d6-38a3-08d92a884e9f
X-MS-TrafficTypeDiagnostic: AM9PR10MB4069:
X-Microsoft-Antispam-PRVS: <AM9PR10MB406954EF7C3B14E1C87B6189E9379@AM9PR10MB4069.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QP0C6OJDaH97205TMwxav2/3bkdTG6GwiwGRlt+SdgnuQ7puHaQtrBbu2RItyvvJXqOFzWQenAtz6wWnW7B37OxplsUDsuyoxxvB+1WsKxCA6mlwfJEpGlgpmfik9pFBhFLyPG7IooI+zhQjjO7xW7IHHfnUCJus5OJBoOtuv5oRz+/CYKlmAi/xCnjjnlWCcJogaXKKop7eG0JcYkdH5XO+73GVS35CrXakvrPs6pkAaDsdCfeutiQls9AYIZrq4POIMdX6TvTgi3hKnkh0QxuOGHd92xREQOfhKerFo87kGIqxRexgH4czUH5qIPaDDfnu1dFHqp0+nl8BKA3Xl6ku0fXHwx0tMjoAtczOAkSF4c4MHfqfprJdkjimyhYiCUg80ldmLuDAAgEcdssiUOzzZhqXjisCaEZtY8p998GnQ/wCjadrLs0P+AQHFjFjVIJps55cxt/Oq4mu2hTTUBfiZYVF6B2t3imZ90IpCTJAtV8UMyNLEKzqdc2yfFdNJsFkpwz7f7+SDFB1Us0MYH5guDnLNIU3mZ/sOjrRWCLYQCaE+7+Sr0OV43WWToNZEab8BbpIAA5znmgRg8E+ekr+Bsbgdhu1Tcn9SuYjAU7F2A97iWcJKD9jrLeI/oG+jXEPcrtLldqNm/+iJo5D0/xyNu8tnfYzfEnuHkkaZnEx6NgVzVFb75jSz5d5BMU6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(366004)(376002)(136003)(396003)(956004)(2616005)(31696002)(86362001)(44832011)(186003)(4326008)(8936002)(16576012)(38100700002)(16526019)(316002)(8676002)(6486002)(478600001)(31686004)(2906002)(36756003)(53546011)(5660300002)(83380400001)(66556008)(110136005)(54906003)(26005)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?gb2312?B?TG1EK3owMVAvZWN6bWtKczQ3Qmg3alRBQWt0Qll6U0hoTWd6TjZxcHpmT01i?=
 =?gb2312?B?czZNMzJMTG5RSEJTL3QrVmhJMGtXWU1BYjdCYTVQc04xN2Y4ZjVUVmptcXFo?=
 =?gb2312?B?cXhTSDR0RDRRTzZyU2s4dUQ1c1o5Y2xsY1ZmSVNSYWVocnlJR2RaOFBVV1dm?=
 =?gb2312?B?WFI4NVhhK2QreDhnbEUwSWlRRXF5aXlYUTFyZnRnazg3TERNZFFrekpyZmhW?=
 =?gb2312?B?MHR2eGIxT1hNb0M3eFY1OW1QRmN3ajNVdGJ5T2dCOWFxWjJjTjhveFJ5QUxF?=
 =?gb2312?B?bEVRaG5Ecy9TdHRYUCtvaklodWlWSC9PZE9BaDVjNVhEMHJ3L1MvbXdYSHls?=
 =?gb2312?B?aUdlMU9CZjFlSC9KWGgxaEh1SjlmWFZ1N2s1UTZSbnVWemI1a2QreHgyTU91?=
 =?gb2312?B?Ymgwam5iOHlkdTR6dXlnZmZBSDdYNHhqQk1XbjZlNzl1cUMvVHd2bUdqdk9H?=
 =?gb2312?B?V1QxUVQ0WXQ5RzBncGoxT3Z6empScFdnM0lFbzZ0U1RQNm81ZWdVTjRTbGZ3?=
 =?gb2312?B?dnBFV2lWTUZhU3dhaldMdzlCTTNPRk9YRUNUNWlTQUJ5Rk1kYjd0ZjI0ZzBr?=
 =?gb2312?B?bXhBSGs2Zko2Z2M1OXJuTEN2OWpWampHK1JIVjhkTW1BQUt0RnBUQzd5MVBl?=
 =?gb2312?B?MVk4WmJoSXlqQ3VmUDkzdU5tN01wdFowYVhwWmdHY0w5TW52OXRxR25LaHN0?=
 =?gb2312?B?UDhsQ3k0MWRyR2hpM2lPYjQ0SFNSZmZOK2YwZ2IybzVNeW9VaDQzSVdpcUhX?=
 =?gb2312?B?VGtXVEtRaFNEdGt4Wm1Sd3NLaVYrS1ZVTnZGeFcrNXl2dWl0RFFHaXpnMXpP?=
 =?gb2312?B?MUI5V0VrNzNZYStOV2FLaEkreXJ3VFpzSEJ6bXNpUnlnT3dnNnNJZUZETlBk?=
 =?gb2312?B?Nzc3Wmt5QXROQ3paNFhBQmh0RGR6eFljcXVndy8weFhSdXpnU2lNVk1mQkNs?=
 =?gb2312?B?em82U1BQQWNML2hwN0hQU0lIY2E5alV4bXMyRjNYN09Ob2I4MWFlVUZTQldN?=
 =?gb2312?B?c3NyYjI0Yi9ob1JsbHhkdkpad05JSzBoQ0ZwZ2NGMnFIVVlUdG85ZHczSklX?=
 =?gb2312?B?Z0M4SldSandBWU9ZbExwS0JTeDluRzdkdkxwTGxzbkxoOWo1azhQU1YvTGJZ?=
 =?gb2312?B?Y01WL1FRRTl2dUsvWGU3anY1MUk5ZG9SeEtNemlqejZhWUx3ekZ4cGdUb0s5?=
 =?gb2312?B?UG1MclMwUytxZWs3K0wyQzRheFgyWnI5Vlcvd0NmSFVXZFEyc1BwZ3NWS29m?=
 =?gb2312?B?UEF4eERPcjZaSUhLRExmRXdxeHJkWjcvZWU5V0s5bm40eDVkV2w0dkRzQzU5?=
 =?gb2312?B?NXVaSSs5em1OZ2pUeThhakRTclozM0JtTjZYVHQvclJFTmpuTVJveE12cERx?=
 =?gb2312?B?QnpxaWxtdnNjUFRFOTlFTm8wVUdxQkdseXgyWmFGblRqTUxrcTFyM0t0eDhn?=
 =?gb2312?B?NmpBeDYrcFJja243N2MyMU5FREhFWjVYaWFneCt5SmtsMGpKU3ZoS1FkMVNI?=
 =?gb2312?B?M0p3aVF3dURtN0dFenhSSzRQdG5xT0lZUlBtUmgxN1JnTzIrMUs0a3l5Z2V0?=
 =?gb2312?B?NlRENWdFa09MSnZrcndEVzVTSEtKdUd2Mzd4MG9SeTNEZTEvL29RbGVycC84?=
 =?gb2312?B?SXdYcGJnZDU2YmU5WWRSNEtoeG9Ia05aKy9oMnNTTFM0ZUZQSm9rVUFJcnQ5?=
 =?gb2312?B?M2ptN2tuazZtUzNkYUtjQk9xdWtNSFZtRVJHUVFKeituWEdjVjgyRVZlWFNU?=
 =?gb2312?Q?97cRxbCW2Uk8/l2VkRsqybuK/wGKNMhKa7b9KVD?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: fba79626-61bf-45d6-38a3-08d92a884e9f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 14:18:37.3461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EO2v2Hl/MXntuf6qv9/Hh2c3TIxYvWBpkiQ9pPQH62mOy24Ej4nMyc2KVL4ipxNbXdMtg246KJ4i1m65gM5yyC5aby44uyAhITBDvw5EFnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim, hi Andrew,

On 08.06.21 05:23, Joakim Zhang wrote:
> 
> Hi Frieder,
> 
>> -----Original Message-----
>> From: Andrew Lunn <andrew@lunn.ch>
>> Sent: 2021Äê5ÔÂ27ÈÕ 22:06
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Cc: davem@davemloft.net; kuba@kernel.org; frieder.schrempf@kontron.de;
>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; dl-linux-imx
>> <linux-imx@nxp.com>
>> Subject: Re: [PATCH V1 net-next 0/2] net: fec: fix TX bandwidth fluctuations
>>
>> On Thu, May 27, 2021 at 12:10:47PM +0000, Joakim Zhang wrote:
>>>
>>> Hi Frieder,
>>>
>>> As we talked before, could you please help test the patches when you are
>> free? Thanks.
>>
>> Hi Frieder
>>
>> If you can, could you also test it with traffic with a mixture of VLAN priorities.
>> You might want to force the link to 10Full, so you can overload it. Then see
>> what traffic actually makes it through.
> 
> Did your mailbox get bombed, let you miss this mail, hope you can see this reply.
> 
> Could you please give some feedback if it is possible? Thanks :-)

Thanks for the patches! As far as the bandwidth drops are concerned, this solves the problem. According to my simple iperf tests the untagged TX traffic now always goes to queue 0 and therefore doesn't see any random bandwidth limitations anymore. 

Regarding Andrew's request for testing this with some tagged traffic mix, my problem is that though I have used VLANs before and know how to set them up, I've never done anything with QoS, so I don't really now how to set the priorities (looks like I need to set up internal priorities and egress mapping somehow!?). If you have any pointers for this it would be appreciated. I probably could do some quick verification tests, but I don't have the time to really dive into the topic.

Best regards
Frieder
