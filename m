Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCAD2CC109
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbgLBPiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:38:04 -0500
Received: from mail-vi1eur05on2130.outbound.protection.outlook.com ([40.107.21.130]:44000
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728509AbgLBPiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 10:38:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBQwNkK7gFNEFlk+Cr3atzfs3oF31jv9fZhbIYryXva/qvqztGS9wFbJkigr13kbnEmw1BAitb7MNHtabEWW3ro/SyytgxkNX2FLWpVDja90dNkmw1eTIp/siZa7srmmDofsmAKEjLft1scJ01tlApbNUBqpSMI6AZGVBe7Iijcv/ZHLGC17JypjJED98WFw4NVV1FeUz+paaNfspibLCKC+hUfatnKWlLDtcisiAwCIrFkg6UMbpCh07s/wYewaoGfO9w0XdhnhGZINUfTD5Ol4r1mdScA2nJM2URc7R3i1P7yhmJRcix90cUubSQIAABcsaNPDCyaLecrlxLTXFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNZqTFpl4//MVBOeeDtBI5/+MhBvyQXL0iPqKahm7w8=;
 b=j9dhX1pmXW3Ed89bnRYfFwh1w5NnUmtLZwLaAPdrLx+mlVkRSWRtewuhdjRnGAeOzZHYk0cWGcs0HBDY2jYxL2fgwTK7ei0KPKhYmthvveknhj21n6IwUMA5Qu7IEV/jNsVGLFGbz3WtmCPCU2B2FBhpX9+xb2QRyT2qoZkTteOXp+ORMLyN3rX//zaivBlzpX5G298PZPML890Uheli8zhuoyWUsgfbMMlBDPWL4EuiIsvd1ZNCWrDAtHdIq4A9WW9r/PsK49TE8e2TMnPUp/UqzevIqSvEr4zEySMXeOHyQnXEpExtRr1ZwSgX9luHOT2wo1Cm0jrjGfiVixQO1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNZqTFpl4//MVBOeeDtBI5/+MhBvyQXL0iPqKahm7w8=;
 b=jKwnwxLZo+MXGIQzFHpqCAG5R4HnW8qjxCnDq53F94ZsUAOHfUCPu1iP8PSgrUviutUKx+F+4Lu8Ggul1d4AV2REkDgFDvU/vQQTh/MhNotIfaSCGDhf77Xh/C85+HjjEeZBTwazf6tSUGl0o/kOjtRzl9M/rmwGANIFwy28l3Q=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=victronenergy.com;
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com (2603:10a6:10:192::11)
 by DB7PR07MB5032.eurprd07.prod.outlook.com (2603:10a6:10:55::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.9; Wed, 2 Dec
 2020 15:37:13 +0000
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c]) by DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c%3]) with mapi id 15.20.3632.009; Wed, 2 Dec 2020
 15:37:13 +0000
Subject: Re: [PATCH] can: don't count arbitration lose as an error
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:ARM/Allwinner sunXi SoC support" 
        <linux-arm-kernel@lists.infradead.org>
References: <20201127095941.21609-1-jhofstee@victronenergy.com>
 <434167b4-c2df-02bf-8a9c-2d4716c5435f@pengutronix.de>
 <f5f93e72-c55f-cfd3-a686-3454e42c4371@victronenergy.com>
 <0988dd09-70d9-3ee8-9945-10c4dea49407@hartkopp.net>
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
Message-ID: <405f9e1a-e653-e82d-6d45-a1e5298b5c82@victronenergy.com>
Date:   Wed, 2 Dec 2020 16:37:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <0988dd09-70d9-3ee8-9945-10c4dea49407@hartkopp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2001:1c01:3bc5:4e00:e791:efe6:bf00:7133]
X-ClientProxiedBy: AM9P192CA0007.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::12) To DBAPR07MB6967.eurprd07.prod.outlook.com
 (2603:10a6:10:192::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2001:1c01:3bc5:4e00:e791:efe6:bf00:7133] (2001:1c01:3bc5:4e00:e791:efe6:bf00:7133) by AM9P192CA0007.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 15:37:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6d0dea1-3a28-4252-54a3-08d896d823d2
X-MS-TrafficTypeDiagnostic: DB7PR07MB5032:
X-Microsoft-Antispam-PRVS: <DB7PR07MB503250EF0C8F3A90DE8B7E89C0F30@DB7PR07MB5032.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cTV0KeB8bKwUg77k+9n8ecZ3PkOYdeaJq7282MbIaj00gsAphLipbWAqWP7w8rL8rvXwPT2Eqi3i83cJ3dYcddFzUkv4IRBsDUw9bCtWoBANyGvpdERq5XVFrJz1AbDk9NlSOnY+AY/F6oJCZDeM8w0vWTMDIIMsoqt9XKfnvU/+69VfnrbCBDY2teBPAzAv2wwj+5HMM8UdDvcuuCFA8HF9adBKAQZ9Sx+DzURVBiJ2PwMRhDZuddQFq8K5fjZQxBJtVCInyPZQnAUsi+D9SjUMNNafWcA20C05phQKiFRSoFXCmSTQfDq1eZ9flKbnmPVmG4WzY3Xq3wsFWKBcJA6lbsy0UtBZ9ZDCucAdRptwL9RRg4oY02VyYxgGc+LQEn1EtAasF/6kt7IcV0w8aPr9SA0S4QSBQibSrjDCwXM513CLyS5aBii3w15xreHp+theZOlrQu/u6AtjbRAiDzjzn98xS+F76hX1oYb44wK063la61W23ciWIa5FboI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR07MB6967.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(366004)(136003)(376002)(396003)(110136005)(66556008)(86362001)(316002)(2906002)(6486002)(83380400001)(966005)(4326008)(54906003)(52116002)(36756003)(478600001)(8936002)(8676002)(31696002)(31686004)(5660300002)(53546011)(66946007)(186003)(66476007)(16526019)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MnlFdWY5U1hSaG5TdzlYYitLUGlKdm5mY3B2UnNUdEdreW84T2lqQm1lS25Z?=
 =?utf-8?B?QlZXSWJRZWxTRGM3TlhmZ3JtTzNlT1VKa1Rzc3hKakRYaGJOUDR2SVpPbUhz?=
 =?utf-8?B?amRvK2VORVNENy9RZmNPQ1p4TS9RMi9ZMW5RZWNCcUQ4dVZERjByMWNqTmdw?=
 =?utf-8?B?MFVIUEZyZkpUd2RnMXNLaS8xYzRuWExpdVRvVkRzSkhYNUR4bm0xUTVZRG9j?=
 =?utf-8?B?cEZFd09FaEdQZnByRE9idDhiK3kwRDZWL2JtZkJGTkNOeGdlc2lkSUpjL1Vv?=
 =?utf-8?B?cSt3LzBtS1duNTRlWmpyRTlsWUVFZzZtRlAwYU9oK3lrWUxpRmFkd1o0Ukpv?=
 =?utf-8?B?V0cwb1YvOXc2K1Z2dDFRYXJCVUllVkdjWmZPS1YxaHovM2xrK3NrUUZJYXVo?=
 =?utf-8?B?N0tmb2s4Ri95WTBCWVlUN3p2aEtROHV3cTdXdm96cm8rVTN0bDRQY2w1d2lZ?=
 =?utf-8?B?VDJ5OGxrWjlQQmpyZDVNM1dRMHAyMzA4Q3BDcTJpNTJYV2g4MEoxYXhnMVBS?=
 =?utf-8?B?QnJNTFdpWkUza3hZTFBHTW1ObDVta2EvZER1Z0ZsYW0xSXdSQi8yM09KQlZW?=
 =?utf-8?B?Y0xId2lkNWo1NStsOWhaT0xXcG50M1kvcmsvc28xU2JmTUJ5OC9kS0pPNUZq?=
 =?utf-8?B?bHdaSHRGS0RpU3UwbnZSMjVQekVUNmp0US9zSlF3bytJdmNHV2xMaFlhaEVt?=
 =?utf-8?B?d1RhQllLLzh0bSt1Wi9oTzM2MFZWaUM0aVZlN3RySDFkcFNoQU5JeUxLSmJK?=
 =?utf-8?B?MWk4TjRZbEJlMWppendtU1RkT3QvaVYrZTJIUTJRTkZCSGJ4MFQwQmh1WlQ4?=
 =?utf-8?B?bnFjcFI3WTlUZGJ6OUwzZ2tTVE9sc0Z0NVhNSHdrMzlTNHN5aFhoRUtQUW9C?=
 =?utf-8?B?Y0k5Rnl6bGxyNklBTUhGUnRyTFZoeVE2RUNrWDRhR3hDeTZlNHVlY1RrUGUv?=
 =?utf-8?B?WUg3SW9aYndLeDFKOFBBTzdUbDFJWXdaTTdjcU1xWjNNeG1iZndqVmdoTUEr?=
 =?utf-8?B?TXhEcXVON3BodnNtQ2hkeU9MbWNsbTVMVWgweDBwTy9aNWNxQWtBalU0cVhS?=
 =?utf-8?B?TmJZQUkzWStKd05MTHR6SThQVStZRVErdEJEWUQ4VytXZ1dIZ2wyYUJiRDZm?=
 =?utf-8?B?MFQwV3E0eUFMZkJhNUR3bzhlZ3o0cUVMU045VzRYZ3pRQVNvQjdEcFBwLzFZ?=
 =?utf-8?B?NE1XRWhNSzlDUnN2K01CTDFINmR0bnhFbzEwZzFraGh2ZXh2aWhRajR5Rnd4?=
 =?utf-8?B?MktBYlRnK2V1VGlBM1B6dWhXSWZxR0h0bS82Q3lWb2JrQUVsUHQrQUN5cldy?=
 =?utf-8?B?c3FMdUxoTDExOXpEVml5a0svZHNTclo3Z0JVY1dUQm13U05XekEyYzM2WTUv?=
 =?utf-8?B?S2ljZGtpOGlKL3Y5bVk0TzhzZUJQaHFidFpOQVFORGhQTC9rRnhuME9GZ011?=
 =?utf-8?Q?H+jTgv8s?=
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-AuthSource: DBAPR07MB6967.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 15:37:12.9729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-Network-Message-Id: a6d0dea1-3a28-4252-54a3-08d896d823d2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P9/7H11BQXBIlaNhM9kXfaEfdrGsegR+rWkZry93VTxeqm2J1SOnlsaZMP7sXAWnYY1NZAb8UQQB29Ek1TKVkkVh3+fnjwHVEkWtuWurvGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR07MB5032
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Oliver,

On 12/2/20 3:35 PM, Oliver Hartkopp wrote:
>
>
> On 27.11.20 12:09, Jeroen Hofstee wrote:
>> On 11/27/20 11:30 AM, Marc Kleine-Budde wrote:
>>> On 11/27/20 10:59 AM, Jeroen Hofstee wrote:
>>>> Losing arbitration is normal in a CAN-bus network, it means that a
>>>> higher priority frame is being send and the pending message will be
>>>> retried later. Hence most driver only increment arbitration_lost, but
>>>> the sja1000 and sun4i driver also incremeant tx_error, causing errors
>>>> to be reported on a normal functioning CAN-bus. So stop counting them
>>>> as errors.
>>> Sounds plausible.
>>>
>>>> For completeness, the Kvaser USB hybra also increments the tx_error
>>>> on arbitration lose, but it does so in single shot. Since in that
>>>> case the message is not retried, that behaviour is kept.
>>> You mean only in one shot mode?
>>
>> Yes, well at least the function is called 
>> kvaser_usb_hydra_one_shot_fail.
>>
>>
>>>   What about one shot mode on the sja1000 cores?
>>
>>
>> That is a good question. I guess it will be counted as error by:
>>
>>          if (isrc & IRQ_TI) {
>>              /* transmission buffer released */
>>              if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
>>                  !(status & SR_TCS)) {
>>                  stats->tx_errors++;
>
> I can confirm with CAN_CTRLMODE_ONE_SHOT active and the patch ("can: 
> sja1000: sja1000_err(): don't count arbitration lose as an error")
>
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git/commit/?h=testing&id=bd0ccb92efb09c7da5b55162b283b42a93539ed7 
>
>
> I now get ONE(!) increment for tx_errors and ONE increment in the 
> arbitration-lost counter.
>
> Before the above patch I had TWO tx_errors for each arbitration lost case.


Good, thanks for checking!

>
>>                  can_free_echo_skb(dev, 0);
>>              } else {
>>                  /* transmission complete */
>>                  stats->tx_bytes +=
>>                      priv->read_reg(priv, SJA1000_FI) & 0xf;
>>                  stats->tx_packets++;
>>                  can_get_echo_skb(dev, 0);
>>              }
>>              netif_wake_queue(dev);
>>              can_led_event(dev, CAN_LED_EVENT_TX);
>>          }
>>
>>  From the datasheet, Transmit Interrupt:
>>
>> "set; this bit is set whenever the transmit bufferstatus
>> changes from ‘0-to-1’ (released) and the TIE bit is set
>> within the interrupt enable register".
>>
>> I cannot test it though, since I don't have a sja1000.
>
> Do we agree that in one-shot mode both the tx_errors and the 
> arbitration_lost counters are increased in the arbitration-lost case?
>
> At least this would fit to the Kvaser USB behaviour.


I have no opinion about that. I just kept existing behavior.


>
> And btw. I wondered if we should remove the check for 
> CAN_CTRLMODE_ONE_SHOT here, as we ALWAYS should count a tx_error and 
> drop the echo_skb when we have a TX-interrupt and TX-complete flag is 
> zero.
>
> So replace:
>
> if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
>                   !(status & SR_TCS)) {
>
> with:
>
> if (!(status & SR_TCS)) {
>
> Any suggestions?
>

In theory, yes. But I can't think of a reason you would end
up there without CAN_CTRLMODE_ONE_SHOT being set.
Aborting the current transmission in non single shot mode
will get you there and incorrectly report the message as
transmitted, but that is not implemented afaik.

Regards,

Jeroen


