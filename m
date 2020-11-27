Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840262C690F
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 17:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbgK0QCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 11:02:11 -0500
Received: from mail-eopbgr20101.outbound.protection.outlook.com ([40.107.2.101]:24572
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728495AbgK0QCK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 11:02:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P43XvDmitOGFnWMOCqvNd4FQCdIA6Iqhm4zPKYb3PSjFU78anSUKat1X4Vyzq6xUamPJvYd0Lp3H3vpPeoZFqxNZogdNS8SDPjRxDzIYMW8UbEpVxE7BFs4ZDiAJHHFaDMFkWSNGQqmfJcuzbhp7RwvsHfL34Zi+i+MC9XGbR+W1lFX3JRsjGsj5FdtXxEtfTSk26A1mA2toa5mXavnADXGGI7TFphpKsc5rGXWB/6tcNnp0MLJRHZatt3PR0XOsz09/NadhV/zTUn1IBx0vCMn1N+liaoH34dpgAoNkQmYDHkj46NqEDyQWCUuk6rGa3H3IXIzCxCT8AMLE624Qmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bf+iIZ9NnvTZ4m1LAF013BvtYZwgbMCqxyLLXtYLxI4=;
 b=hJVP8WvoL3nIGEuUKVS4iSKzUyhRldixfukXB7yJE/s9OT8RnCsoxxJtkKy3HpPGCLfvPqWLgNxzvZioJ6frMW1rfhA+Q6OAYyu1egHSnNxFR6icDawkk4JYGkw69Jps7WD6ZKN4ymskla+by0CDcT5eID96DDoiKjO7iBzI+k7T+bNYxWJ3hpHPKNxVWoMxvUOe5DKwMZzNsPcJ50yZB4wT33/7A8XkpUhtTsH08wIGdJHY55Y/qLJuhFDCphShy5kmLkbDyugGuq/jP/DiJ2NYOAzTmn9N4U9hDFwHOdWkr4oBxEcOYVTLCh2oUJ3u7RexjpOXUBk7s46tzS4fug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bf+iIZ9NnvTZ4m1LAF013BvtYZwgbMCqxyLLXtYLxI4=;
 b=v6J0OCGBLxxlA9XXQFPEYRBi/ADh/bkzjtJ0QxuNkXZoD0gh6nK+Cr4dlcGwHmp29wUaL+GuYYgh1nEZj/+6CMhZWiGqS6Hl39JWLLRa2l7lITCJ2VMhxLJAxru/ZPyjtQq2W40upZRYEPVsi+0obHMqb3jpupElnBm+hXxhgrA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=victronenergy.com;
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com (2603:10a6:10:192::11)
 by DBBPR07MB7641.eurprd07.prod.outlook.com (2603:10a6:10:1f3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.6; Fri, 27 Nov
 2020 16:02:05 +0000
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c]) by DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c%3]) with mapi id 15.20.3632.009; Fri, 27 Nov 2020
 16:02:05 +0000
Subject: Re: [PATCH] can: don't count arbitration lose as an error
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
References: <20201127095941.21609-1-jhofstee@victronenergy.com>
 <434167b4-c2df-02bf-8a9c-2d4716c5435f@pengutronix.de>
 <f5f93e72-c55f-cfd3-a686-3454e42c4371@victronenergy.com>
Message-ID: <e5f3940f-99e2-95df-7985-0b6ace0b3faf@victronenergy.com>
Date:   Fri, 27 Nov 2020 17:02:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <f5f93e72-c55f-cfd3-a686-3454e42c4371@victronenergy.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2001:1c01:3bc5:4e00:e791:efe6:bf00:7133]
X-ClientProxiedBy: AM0PR01CA0161.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::30) To DBAPR07MB6967.eurprd07.prod.outlook.com
 (2603:10a6:10:192::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2001:1c01:3bc5:4e00:e791:efe6:bf00:7133] (2001:1c01:3bc5:4e00:e791:efe6:bf00:7133) by AM0PR01CA0161.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Fri, 27 Nov 2020 16:02:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ee56041-b918-432d-523d-08d892edc955
X-MS-TrafficTypeDiagnostic: DBBPR07MB7641:
X-Microsoft-Antispam-PRVS: <DBBPR07MB7641BC880747824986EF69B1C0F80@DBBPR07MB7641.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FRJxKKvWo0i6JQ/TYBS2Oc/on+OO2w7nXpPez4efDjiXpk0LQIK6micT/kZDrHrTg7qQwSeRZhvVTAsnx7LrgI4p8VsTkwHRuUJe0YZuQ86uV2J3UK8PJR1c4k/GkESnT9bm81YX/yAh0HTKge5NKHb1ZrjSfjo6e6romanbYg7wyAHv87WnCU8tvda2TvhwE+F6HdKDNratJwWL6gr0ms+ySM10ih7rhCB4wJjZxsO7pkZQvWl1OT0ApNtCe+BQXwPHsvDTFZ1L1xWLuyfb9liZyeL/0LSfwA31BOdN0YOHkuy2PG/dXq2K/lTsRCDGKdzChkXPdiWpgw+JwV8Svbi6qNv/cd9BkbrlybSA93CPIjQq516wrWmoqpFn5DYr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR07MB6967.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39850400004)(52116002)(186003)(16526019)(316002)(2616005)(478600001)(54906003)(83380400001)(6486002)(31696002)(31686004)(8676002)(4744005)(5660300002)(86362001)(66946007)(66556008)(66476007)(4326008)(2906002)(36756003)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aE9NNE81WXNtQWRiam42U0pFTWtoK3dzeGlEU0doZ29Jc1pKYXAzWlovNXo0?=
 =?utf-8?B?NHZKRmF5eDI1eXA0Z0JmaGRPVFdiSmdtRFhaYk1zbGxYZG10VkRxS1hxUHIr?=
 =?utf-8?B?dXd6OVp5anh3ZStVRS9hMTVoRG5TYWM3YS9xR3pscG5lb0pqQ0pla1FCNEhn?=
 =?utf-8?B?VDUwZjhJUWpQS1BNa3BtcmdDbnBBUGdWM1ZxWUVacUNzcjloZWwvd2ppbVpu?=
 =?utf-8?B?L3ZBRU5MSEtHMFF6Z0FDeDhpWU9JS2VVeS9sV0JTZTZOay9oMFBkVzZkS284?=
 =?utf-8?B?VGtBZXdPQ2QreWw1OEpGQzBoREFMUFpSNE9xdlRkcGluQ1NlODhqU3ZESWFi?=
 =?utf-8?B?V3laVCtpZ0RpN01xeU9vTmtTb2pYbWIxdTVOWWdiVHczRkg2cDhqMkVMUUhK?=
 =?utf-8?B?OUx1TUU3YXdvQXg5bkxsZWNQNkVYUkcza0tTZThRWlJ0eFk5NnVRcm9mb1NZ?=
 =?utf-8?B?a1pGYTJuRXJobjJ4dkxXajFhWWI4VDRUcHpja2JwY0F1cGZNQzhYUEJndysv?=
 =?utf-8?B?bnI5SDJjM1RsU3pjWFdFV2xkeXMrTmVKNFZTQUpYdmdIajdMSXA1R0hacXVH?=
 =?utf-8?B?eERFMGpUYlpmWXc5Tk5KNWhqTXFsZ1pWT1lyelZxaVNJNkprQlFsVzFNVDNj?=
 =?utf-8?B?amJ2dE0xanBmT0Q1Qk5CTk03SjJFTlVrQWJiSkJWb05hdXIzYmFicWdFWmpT?=
 =?utf-8?B?YjhaUy9XTnVOVjg0ZnFwYURRMlpjMjVvRk5IWUhFaExybFJMd2k1eDk4T0NW?=
 =?utf-8?B?Z0ZHNGVWbFFndjUyRXBBWGpnVXNOVEpsaDhiQkc3aXVvQWttc3hrRzMvcW9I?=
 =?utf-8?B?RjZXalBnWTZjaWh3ZXJXTlFkazB6M2c3WXhMY2ptS2ZOUmJQcjNLaGJzcnRy?=
 =?utf-8?B?bytIWHFodm1MOG5vQU0zZk5wQ1VsazNRN1VDZ1VCVjcvaTN3ZG5QY3JxVXp3?=
 =?utf-8?B?TVlYWmdYZllIMGNRa0RwNm56UHc0MDQ5V3NlNFNLZWI2aUlUZVRITEhwMElY?=
 =?utf-8?B?Rnc0NlB4dnJJMGd5UUZ4SG1BbGIxY0xNNHh0YXdhUldRaDBiSDJCNyswMHYv?=
 =?utf-8?B?QzhVRTlFZ1owSFh0UFFaT1E5TlNUQUVyOVh4ZkJiblBRc01WekhuNG9jZVJw?=
 =?utf-8?B?Y0VpMHhCYWlzK3Zmd1VQRUtNV0grZUVmNVpSWE41NUErWWRjVWVCLzZsbVV4?=
 =?utf-8?B?NFJBQ00wa0t6T3pITjJRelZ1N2VUem81Wko2WU1ycGpwK0VFQzUrM2NRT3lG?=
 =?utf-8?B?aGZVWWVFMUtDS1FrbTloaXlhVmRFZk82bVZXOUI4V1hocW92c3R5KzQ4ejNQ?=
 =?utf-8?B?dEp0MVFTTnJuYlBOS2llYTVwbVQ0N1BadzdpelNDbnhjUENHTEg1YkJuNStr?=
 =?utf-8?B?S01OUXJJaWpFcGkraHA2d2ROZHUwcVhJV3VGd0Y5ekFOWXB0OFFhdHJpWjJX?=
 =?utf-8?Q?dJGQGd53?=
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-AuthSource: DBAPR07MB6967.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 16:02:05.4128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee56041-b918-432d-523d-08d892edc955
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ne77kdxHK0BYdcowlcUDGNLnoVwK5BHmFmTyL4fZ6PGFbOxsESr89G0eUovBtt2tsn5v3qtKuyoOGLw1yc2ufi679RqSgIst5wnPnJ+E1/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR07MB7641
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

[...]

>
>
>>   What about one shot mode on the sja1000 cores?
>
>
> That is a good question. I guess it will be counted as error by:
>
>         if (isrc & IRQ_TI) {
>             /* transmission buffer released */
>             if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
>                 !(status & SR_TCS)) {
>                 stats->tx_errors++;
>                 can_free_echo_skb(dev, 0);
>             } else {
>                 /* transmission complete */
>                 stats->tx_bytes +=
>                     priv->read_reg(priv, SJA1000_FI) & 0xf;
>                 stats->tx_packets++;
>                 can_get_echo_skb(dev, 0);
>             }
>             netif_wake_queue(dev);
>             can_led_event(dev, CAN_LED_EVENT_TX);
>         }
>
>

I just realized this is likely the case. If it wasn't called,
can_free_echo_skb won't be called, causing a memory
leak. I guess someone would have noticed that.

Regards,

Jeroen


