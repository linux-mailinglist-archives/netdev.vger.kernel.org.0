Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0A16B99F8
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjCNPkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCNPkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:40:06 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20627.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::627])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC4E7DB0;
        Tue, 14 Mar 2023 08:39:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ME5F54JticLPEaoRW/Nk1DU21GXfB9FlcphNV1JNzI/bUABG/ZPjDQVCf4AJbVpH/lJw0oxurMYyzQToNUrUrly0beQos0A9c07nLjIhtYgmvrPXKEs/SqElwzCbcZyCHLi3K7HdQ648oeYQoGz9jpEZX7f64Ph1h0ey9/WHTokVurqx9x0MEuTT/pdraLawO8U9kbZDEX9qmvxHfboJw4W618+Df6SlG1M8xu5M+JmJafAy/q/XQ7sO0RgQ4JxEsFQ0gdd9rr/P+Rvll82sRjXDiLSXIP/rud45006AaH7fai6wObPkYhXZf6iafLgzQpEYj3mrgSzdphU9J5bi/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Siw6u2B2d42+jl1KBLjndlEMSdL+irvPO/6kjl/KDTw=;
 b=afQ/snHnyg1Qp05/3+J30wP4qhd2D8jSWbd+20gpToHQA2T273Ism6wbwrSEsn0S4Jk8TsFiXCCVxX0kWeYXXsrqV4iRhJNyux5+9zO7W4ONo25OVo/Zj9RIEbmGQIliIdzMAi7p5VGGUmUyh8eqj7UGlpUEY0WHsFsVkeDgD32otg4Nw89ehke5OXzdPjwP8aKMTPuj5+c/g/3yI3mN+Z/jHTvmOCEYAqbSr/cuy9xzg5XnHOHBRs2bbJSDxj31psRoPRJJuzzxvM13HbqudyKWbzQe8dc3jB/W05X8ODrYciPl0scUiToOdRu85VuL4dMljjgEZcfoPN8dTBFrVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Siw6u2B2d42+jl1KBLjndlEMSdL+irvPO/6kjl/KDTw=;
 b=LjOC5f9Ey8pGhCBmuAdvn2R3WVugYhMbLDQ5x9nfErPBfNvpm/1zDnV3hpGOB/z4f+tzm7IbC2/pz9ySD3Iknbt3ganYSEgmYXGSWDmjWzkbM0X6P6PA3dj3PJU+P7oXIVP0F9TUG7b3zzr8EPYzBLcRk0eU6LRj1M1171qMhLA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by PAXPR04MB8144.eurprd04.prod.outlook.com (2603:10a6:102:1cc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 15:32:45 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:32:45 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v11 0/4] Add support for NXP bluetooth chipsets
Date:   Tue, 14 Mar 2023 21:02:09 +0530
Message-Id: <20230314153213.170045-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0212.apcprd04.prod.outlook.com
 (2603:1096:4:187::8) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|PAXPR04MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: cfdfac8f-5ff1-4509-4775-08db24a15bbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NCM/f4zM0nPok+og0+2ASntdlBxdRjofb2BimGhzdW7cBg/alApK5BLP/Ae41UG9Ua2odDW4ukk63kRZiAHnOjnNaPQ1mSFhdQNQVxTedmOeaEf8VhZLkWBqvvgo5xgme+DBcGce7WB/OWToNec00U84TGYkgY4jhOskPh+0cAMbKR4jDmkNpagw1qbYGdmZHJeTMw2I8I3BdKGv/lrMG/Dt+RD2nB+5hyYy/qn2MCxkeSrK3vkHq/8XUiJdc1l3NbuXAoz0n89l/yjPWP9874HNa3y9hMAwsH55Ct4gzLu9nDQbRgl4YOsTG0mV1Gb+nqN9gLTbfUxczALLvBCSDNzI8iZjVh7K819/3JJs6TkkpP/W7YR0qi33N/YGz7IldMOX723f6HYXIVWrP8Tmyn8lJoJmq44oObi5TYT5CYQlCwm3iOKfRI39prqP4REEAYwz2EkZsmCJLTDyjxY0kuqCiaoqFuYyy5iJWrCPWI0HxVJS2rfxCoFk6KHUbCtlqTluplIOnhE6CUrnrUX9rEnKiFL3mx16RUG4cA3WdIKljl1BBtkyy0w7osoYdzP+/GPKBPV5ldsM9wA4pyWly6BqJ6FFyozFDKlwEeF2QRhotB59XjSICFKvvGFFhVHoWlf1y/ZS4kyR6aKqfT4dw49XgQHXrrEyuXPndi1wK/Q5aVCgeShfdmzHvgZzA8yPhQuTcUX2Sflt5yWwfvTWsO18moITdQ86IluhAyiHXlo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199018)(8936002)(36756003)(478600001)(66476007)(316002)(66946007)(66556008)(8676002)(2906002)(4326008)(41300700001)(5660300002)(7416002)(921005)(86362001)(52116002)(6486002)(26005)(6512007)(1076003)(6506007)(6666004)(186003)(2616005)(38100700002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGFUWTZBUnlBU08vWGEwY3dtcXhWU0dOOHo0eEFucHAzb3NoS1hCSlBZZ0d5?=
 =?utf-8?B?UXNxUnh0bzRMMzhPV0FEQm5JME1KdzRjeXdoTm9VS01QMEZSWnQ4eDkrd2Mr?=
 =?utf-8?B?RzJITWtWYUdyb0xHNG45UHlCV1R4eVBVSWh5VHZHVXhyaGRVZk45YUZjRkpQ?=
 =?utf-8?B?dUs4NEpzQzFlbnFVd2g0YnQxcUVYOFB0RlM5bTZkbGpaaWZtaGpkNlV1ejBa?=
 =?utf-8?B?SVZ0OURKSktVVUZ6QmlCdzhQczU3ZW9DSS9KSEN1V2dqQ1BUZ0dPV3ZsNk1Q?=
 =?utf-8?B?QjFUbDNLd1hYcU9leDFiN0JrZmkvSU1jWDlUY0gxYk1YR0t0MERva3ZEZkFt?=
 =?utf-8?B?UFZzb09nL0ZoTWhyYjArcXQvSnB6QVc2QVplTkNmWU93THhnazFYRFZrRElz?=
 =?utf-8?B?NmtGZTg0WndaSXErQ2laUVp4WXhURGFJOGxOaHY2U040Q0VYOTY0TTVKUFNX?=
 =?utf-8?B?Zml4TVJRa0VlTXY4TFNUMWowVkFrS1N4SWVwTlM2REUwQitHUG8xQk1zV2FY?=
 =?utf-8?B?V3VxZmhsVmRUMmJqa3RpcjJtVzBFemhGRHZyUVZzQm5VWGN5VnhOZTcxRFNR?=
 =?utf-8?B?bmlCeUJ5dlRiRElzcHVEcndYRWlmbjRURWViNzdSSGJZelN2bWZ5dTdRV3E1?=
 =?utf-8?B?MEdEcXo5dmI1WXRsRkxpNkI1VTJSSGE3T1B0dGc3dzJ6TTVCQmdyeTA5dGY2?=
 =?utf-8?B?TU5oUVZBQnVTeWtJbDFWMk4rU2lmRlpyWVRkOSthMGpkNG5XckpWR3RjTTQ1?=
 =?utf-8?B?QzNVM0d2cnJvS20xRUlYWFUzK2tiWVhrb3o5bzhQMmlPV3RxRkFxbUkvbldl?=
 =?utf-8?B?Q21jaDVacTBiNXBDZS9NWHdCRlVyMlkvVmlybWUvMWlubjZNU1F2MjlqMXhI?=
 =?utf-8?B?VEN5TU9LVzRqWEkyZzF4bGpjbkZnNEJCWlJtR3VJOWo5VjRoWVRZRUV4SEVN?=
 =?utf-8?B?QStDdzVsc2RUcVpRUjhzRUZFZnM0aXdtRzdxWVhrN2dZVkJGUVoyVHFoY2hB?=
 =?utf-8?B?TmluLzVqYmhVTEwzeVVqZEljbEZQbHZkL3BSaXlEV2c2Rjl0emYrV3NQaHI2?=
 =?utf-8?B?RDFrdE1ZSHJaaEVmVGxTY29mNHM0cjVBcHZSQ3BHd3hlbkNPQnBxQ2tXQmkw?=
 =?utf-8?B?RVVES3dOS0VIaVZLK0N6OTVlM2VOZlRORWliZHlRVG9DZENDMUJsWlkyODRJ?=
 =?utf-8?B?dVJoUkJVMVJXQ2tmNUU5UTl4anI3cktwcWR0eEorSU0zc2k4dmlDa21QemF0?=
 =?utf-8?B?bkQyMnBVdXVPTm1sRWRwL2p4S1lRU3BuZ2Y2clRwVnhleTl6aDVyV3VrRXFV?=
 =?utf-8?B?Q213RmtrRTlrVmpUdlRqSGdOL3JoTUNueXRJWVdpbXl5SUZVRkVYVEJGU2Vq?=
 =?utf-8?B?RkdteVRKelVudWQwUEFPUzVTSHJzbDlGaWJEZkFFelpINklTMlVGcWVtWjhm?=
 =?utf-8?B?RXd1S3VLYURLbDlOOGlsTm1rclpnOGdVSldBZWRPMTR1Y3Y4alpjMkZVdkIy?=
 =?utf-8?B?enlabnhmM1luWkU2UGhXTkJOckd6c1RQNHdOOWpUMUl5ZVo4QldrMDVZRGpX?=
 =?utf-8?B?UWhCYkdET1F5Nkk1TTFXaXFBbXltdkxtV1lBRXJJSkNWUmQ2LytRUzVVb1Ru?=
 =?utf-8?B?cDdNS0dKSklZYlhJblNMOXd0dlI2SVg0UFpXU3l5bk1DbWNGZXREOGozcktx?=
 =?utf-8?B?ekZBWWhwYWt1Mnh0c1QzU0hjaTNLMUwwSkhLWml6N3F2YjdLMGVHaXpqRjFS?=
 =?utf-8?B?WFY4TksxWHNta1ZmNFpwY1FYQmxDQWdIZ0R6eFdHdE9BbFVPTEQ3OEJkMVhE?=
 =?utf-8?B?Yko0b01vRkRDSnBUNXFOOCtuWEFzRzMyN1QrMHptbGFYVWE4djF0M1FNVUM1?=
 =?utf-8?B?U1VmRTExbEs1RXp3TUI4TFJlZlo2OG9ROW41ejJWQ1pkaEhQZzJ6MEx4ZWFr?=
 =?utf-8?B?TkhsYkNVUk5DaXN1dmZrWUcyS2NFZEVGWGdMVGg2RWxxNTBxR0JkQ256UjJX?=
 =?utf-8?B?ZDNQL0R5djdocUgvRVRYcERoMkN6TkNnaDRhNnBtem4wWTROUlRHWS9RZVlC?=
 =?utf-8?B?WU5qTzJYSnFZZXFpSFVPcWEwcmV4MllIbVZKcktoVG5QbGJPeEFGSGtoSHpu?=
 =?utf-8?B?alpOcjdjL3BoVWtIR2h1YzBaQURzb3VPbzhsSFNJdklZNFE3RGxFSWl5Tm5v?=
 =?utf-8?B?dkE9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfdfac8f-5ff1-4509-4775-08db24a15bbc
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:32:45.2644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gmaaEKfWn1s/cYdpESjN0IcY2y5P/+aVgEvIpKQtu+/vmvQeK7zpqbtTJK1qgbJ9jXRsNTcnPtKNMDICJzC6rJtiyD/XtM3MxzRofPBo+ho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8144
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a driver for NXP bluetooth chipsets.

The driver is based on H4 protocol, and uses serdev APIs. It supports host
to chip power save feature, which is signalled by the host by asserting
break over UART TX lines, to put the chip into sleep state.

To support this feature, break_ctl has also been added to serdev-tty along
with a new serdev API serdev_device_break_ctl().

This driver is capable of downloading firmware into the chip over UART.

The document specifying device tree bindings for this driver is also
included in this patch series.

Neeraj Sanjay Kale (4):
  serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
  serdev: Add method to assert break signal over tty UART port
  dt-bindings: net: bluetooth: Add NXP bluetooth support
  Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets

 .../net/bluetooth/nxp,88w8987-bt.yaml         |   45 +
 MAINTAINERS                                   |    7 +
 drivers/bluetooth/Kconfig                     |   12 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/btnxpuart.c                 | 1285 +++++++++++++++++
 drivers/tty/serdev/core.c                     |   17 +-
 drivers/tty/serdev/serdev-ttyport.c           |   16 +-
 include/linux/serdev.h                        |   10 +-
 8 files changed, 1386 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c

-- 
2.34.1

