Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27442C79C8
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 16:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgK2PxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 10:53:11 -0500
Received: from mail-eopbgr60137.outbound.protection.outlook.com ([40.107.6.137]:51870
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725468AbgK2PxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 10:53:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBv6UmbXMwZaHlJvgaqp0S/BhOsOlshxYxciLr4sWp3+7S0LHVk4PiXnHs0Q9Fxn8qD7KanQVZNflFMh37SK3WmBjvNU33WTgfNPJwTeLD1kr1zSKm1OJ4HcwURLTiQcZH25Mt5blmfHXXE7G/583MWSa/cuvmfWp7uNCS8dd9M9U0MkhjvuCki75LJ+y9K9UA/fTouIiVTA/kCJzlHPOt5CM7t6y7dVZfivg271OxIJ6HTYUpwQ71lIpWF7LdJpTt2NbyrwqoPWi72RdIg9KeSzSRAGHtHN0KqV9rBfQUdP6aCUazAWuEEMtU8+9+EDpcGs8x/uGBURTw7JLz5LFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiNrO1PtLQwVcgHlATVTMIZiLIgLFJcjT7nFiazhl+A=;
 b=W/bzfsv0eQPrkumVph1T+rQRODju/XKJDAgIeSWaPooV7hgMmgcZDy9mXJqmU8rQ9/UH9ResgCW89PS35DVAiZRZO84JolQpAhKYPaiqapKZiYzlOcw6nOApL8OoyJtC/AU1fHFW5GIF3r914oirjP3DFu0wZEeRGFvBBFFm8WnCwJz1AMIE1UXhi8wolzNpZNv14hQaPwEjwugWcvxiVzLs/GVem3un+EDvRwfAwxhvfyc1abF6HJ6hHauRMq1n+b1M90ezuM1WlBdkqlh84Mmrl5kZea6fLXIouqiRH8OkSCsv0CFSEqsyBd+Ex1nCcBZTVRsVn05FekjWlsq6PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiNrO1PtLQwVcgHlATVTMIZiLIgLFJcjT7nFiazhl+A=;
 b=bc6PHUlowyxY820f27L0Z5Im4VFwOcTCX2ekVmjPoktLO7VEZe1pnraIaDp6GhJOcF/116nc+5y731ioYSSpeE/PgEjUfHFeW9583MPgcg0Y/jFF5/7nNkQgn//thyFx0DXEZgg4fwnUd18fs+pQTu41vclDSef0zoAg4GEjGsw=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=victronenergy.com;
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com (2603:10a6:10:192::11)
 by DB8PR07MB6473.eurprd07.prod.outlook.com (2603:10a6:10:133::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.6; Sun, 29 Nov
 2020 15:52:19 +0000
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c]) by DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c%3]) with mapi id 15.20.3632.009; Sun, 29 Nov 2020
 15:52:19 +0000
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
 <042ad21c-e238-511b-1282-2ea226e572ff@hartkopp.net>
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
Message-ID: <4319bb31-972c-78e1-ec20-11fdfd04d6bd@victronenergy.com>
Date:   Sun, 29 Nov 2020 16:52:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <042ad21c-e238-511b-1282-2ea226e572ff@hartkopp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2001:1c01:3bc5:4e00:e791:efe6:bf00:7133]
X-ClientProxiedBy: AM4PR0302CA0020.eurprd03.prod.outlook.com
 (2603:10a6:205:2::33) To DBAPR07MB6967.eurprd07.prod.outlook.com
 (2603:10a6:10:192::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2001:1c01:3bc5:4e00:e791:efe6:bf00:7133] (2001:1c01:3bc5:4e00:e791:efe6:bf00:7133) by AM4PR0302CA0020.eurprd03.prod.outlook.com (2603:10a6:205:2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Sun, 29 Nov 2020 15:52:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26467f38-e6f5-4e3b-79ff-08d8947ec0e4
X-MS-TrafficTypeDiagnostic: DB8PR07MB6473:
X-Microsoft-Antispam-PRVS: <DB8PR07MB6473CBDA2A45C5DD92BDAC98C0F60@DB8PR07MB6473.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xEKnWSYd96vbTE8jwvI9e6BDC5MJEEIJide7W3epzqwGmtZdyUJRA1YHt/vhAPtV2lO93PuEvPJ8OuXlZtk8oA0oCrVWOt04WvvlJxNPbyNejLZI9pQ7wRGfWqji0VOV5xduDFShIKauM+oG/lKUg3wq0Kt8er6VcIC7Lab7+o9dHfLqXoD+DbBu5pVnWTM8VUYoY2yDUHt2c0uW8DX8FcWEVdt/dXIFJsfB6ePabcj4kjylpv/uGuT8ce3mKX4J7lUY4/M/TxXq3UOOzkbytdG5gLvVlRp4aqXLTVHW05BobNh0XNFpr+YDj6Wk9/+cqIqXnboaAuxjg2jjKkBavvLQ3WwdAlEk92Ak9AnB7SjECwCpT3/fv0deU3qWA7Y8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR07MB6967.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(396003)(346002)(376002)(136003)(366004)(52116002)(31696002)(4326008)(2906002)(5660300002)(53546011)(478600001)(316002)(83380400001)(186003)(66946007)(16526019)(54906003)(110136005)(66556008)(31686004)(66476007)(8676002)(8936002)(6486002)(2616005)(36756003)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NzNjVlBibUU5ZDI2NEV6bVk3OTVydFI1VXRlMXE3OHluNE5CWldwZVFBRldx?=
 =?utf-8?B?T2Jkb0lRK0hkOFJJWWRIeURUb3ZiREQ2bFczU1Z6Q2toanlOTXAxK2dUK3Fz?=
 =?utf-8?B?QlZNQVBQeVZIZnhBd05VNEtCQW9pZVc2eVVSTGYzanJ0N013YTBINERqL1Yy?=
 =?utf-8?B?UmVPbEpDa0FMYzVoUmYxSHlBT1drRWtteFJMcFFBbFpUOWJaakIzNEZwWWp5?=
 =?utf-8?B?VElPRFNJUHp2RXhJZVloQVF2SS9oQUdKbFluZExyVE0xVlBHbU5kdzUvejIr?=
 =?utf-8?B?dlVIKzdvalFjUTVyRkFqNzVMT2U2V25oY0s0MmxrT3d0cVB3NmE5YW13OHZn?=
 =?utf-8?B?aHQxYmpXenhKdHVaV2k2enRpampqRWtXOGJic3J4WEIrUlM1eHJQVTFGTDVO?=
 =?utf-8?B?U2J2ZTdMRkNEZC8rKzNRNjBYQk03TXV2VGx2WUZBaGlHWG15bHJkbldMVHZQ?=
 =?utf-8?B?OWEyVGZSVmdEWUQ2NnBRb09mb2RUUjM1LzNobFhlYUgrUFUzT0ZNSjlyRlln?=
 =?utf-8?B?TmM0SDNoZ2hnS1RlbWJ0Y2ZlY21tRkhCSitkS2JpK0pmZmw1dkxUMjAvQWpD?=
 =?utf-8?B?YmdFMzZnb0lnalBlTytsOCtHMHREY1gxQi9xS1d4dThMRmhNYW5rNWt1VHFI?=
 =?utf-8?B?RzRCWDVveVgwVThPdmlGWHM5aVMrd0dKblFSTXo4dWNhMFE4VHYrSEphbXhk?=
 =?utf-8?B?VzV6WkZYckxxRjRVcHVxSUhjdGM0cVo0eVBUODRZcld4YWdmRURGbFhXV05k?=
 =?utf-8?B?eFhIdVFqYU5mSUFDS2xYM0NDcEIvV0tWM1poMG8rR0I2Unp2SW9YaSs4YUhm?=
 =?utf-8?B?czBDYUdzaG1hY2ovbHpqUysyT2IrdER5d0wvVU1GamVlMUhOWkJTM2w2dzkx?=
 =?utf-8?B?TXZwWmM1cXQwZXVxMWNmQUZubjRKZDlMbHdmY0NzWEpzdlZzOXZIVGZLZmEv?=
 =?utf-8?B?VmQ2L2F4T1dNNFp6WnpGUXRVaUtpSnNYb0cwdlZuL1o3S1ltb2h2S01sSXZX?=
 =?utf-8?B?SEhpOVZJYWxvT1pQeklsMlB6UG9KeDNrMTFXSTBhKzNiM0Z6dW5GcVhZTFRv?=
 =?utf-8?B?VTlnaGJBM0lNb2kxM0MzSUV6UHd5Tms3cVJSNWJnNjd2dTVlWGpQMTFCd3Np?=
 =?utf-8?B?R3Q0Q3UrYVJmSVdmZW83bFd4MUZ6WnJPdkZKNE9CRDFnK2wwa1dIZW1mM08w?=
 =?utf-8?B?YWJiZGNjMU0xQnluclJhUG1ZSkZkL3BLRzZGREl1SVphSXEwSDlQT1IvS20v?=
 =?utf-8?B?UDFOZSszVlhUVTFsZzhHS3paMks3QzJFdUNHcS9xTlFRU1RiQzliSnhxRGVj?=
 =?utf-8?B?eU02RURKdEhtMm9Cek1Od2FicFJBK0NxMFE4dGVVRjNTRXUrRTFGL3lGZ3l1?=
 =?utf-8?B?ZkFxc1JlQ1A5bithVHMrclNmQk1mOElxYk50WnhRckg5VFBIZlFDWEJtS01O?=
 =?utf-8?Q?QsByZ0HJ?=
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-AuthSource: DBAPR07MB6967.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2020 15:52:19.4380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-Network-Message-Id: 26467f38-e6f5-4e3b-79ff-08d8947ec0e4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiowcSH0+28Gk2q9Bga8KFdMXVrYlzP5eUK32/wd3AoYY/rBdxy1KA2x+Uh+JQQ9Hd7E58oPitX6mjDLdkrCl1NsJXXMY+UETR3E9hg8qA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR07MB6473
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Oliver,

On 11/28/20 6:23 PM, Oliver Hartkopp wrote:
>
>
> On 27.11.20 12:09, Jeroen Hofstee wrote:
>> Hi,
>>
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
> I have a PCAN-ExpressCard 34 here, which should make it in a test 
> setup as it acts as a PCI attached SJA1000.
>
> Will take a look at that arbitration lost behaviour on Monday. A 
> really interesting detail!
>
>

Thanks, appreciated. I would be surprised if this path is not taken though.

With kind regards,

Jeroen


