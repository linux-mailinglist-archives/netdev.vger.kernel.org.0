Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469256B7A94
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjCMOlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjCMOlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:41:11 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFA548E35;
        Mon, 13 Mar 2023 07:41:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AM+GXO+n+h18sEnoNdLSDjfkWcpyxY0qFxuVBLyAqPyKR3bA3a8WxFjYz8IqdCkbXhT3q84rNgGjU/gnu/SJufH9JWgt7FW3zUuoLcKLJDTe5+eg3xkxcrvRSs+fcxUM+KqYYSgj9sVkX9k1CNekvTuU1KOxtYC6kn4qqGdqTncM73o76cFszywddz9ciYjqh5LjP5A218zVGy2w65m/obKSbtzYlLzFAW3Zv6lxRhBA+wdaN7N8Sy3m2z7YzRNErWfDf8IWfYqWeLK5JdO8ESFvi3r54u4AodnuJpZMQXFQI8JbZPmYE124zmZIoPZr1MGsJD4dcsWipsNLlzURPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMROdIwdrwhNN+iwm41m9w8HKuedgaA1/YxzkYHFOtA=;
 b=EZlyH2NFcaZZcpAdv0sjs47on6OpxQh/RiquTiMH4P9LbSY0tJlaoEX/okyTcVhUTZb/SNYHwklL2vWDpo0bcJUGRLO2HE/3jY9M35Dte5o+NBgpE0wzpsjt+6hjrvmVvm3DHBaeKUJ7GEomXo29awznBiN51IUPOOxbwZHQa64TiqCdY9XDnCnfI4QVmqAuoiTTlwB0EAjJfsVr8cfDMY6CZwt8AcRQ+05IHD9l1W3ukzfgVstgPeChog7wbQ5j/jC31GuNYMmr79SbPYVLRUFCNnqXLdHZMb1lGd74LpPj+TPV6UNEiIfltx6Wv5v/6Y8G57cw4HLvlMByhYI+Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMROdIwdrwhNN+iwm41m9w8HKuedgaA1/YxzkYHFOtA=;
 b=Z4LzziEXzjhKydPtZettzPAImcW6yxXJWDXD5yxMz1e9dedKOvVn2QlSrgB3OkUus0bUq19E5d2K7Rhav0lqtKLGe3pPYrxy9BgSg2/wXaoQYFZK6Fsn6ebxQahtGaXVB7DUgpnb9dAIRK8TnLx4hrTuXys4Q7sxJUw4wrqHdn0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DB9PR04MB8203.eurprd04.prod.outlook.com (2603:10a6:10:242::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:41:02 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 14:41:02 +0000
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
Subject: [PATCH v10 0/3] Add support for NXP bluetooth chipsets
Date:   Mon, 13 Mar 2023 20:10:25 +0530
Message-Id: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0115.apcprd02.prod.outlook.com
 (2603:1096:4:92::31) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DB9PR04MB8203:EE_
X-MS-Office365-Filtering-Correlation-Id: 574a1458-ddac-49ad-ba69-08db23d0f7c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x8zlDJNXVq4OdBZMfo7OOTNTdDmnDv2vAOylij+Q46pduorsyc/27GY6jkVfz46PLzHsLlgntMt7EedFGoyU7WKz2BAaEQdJdY1oi3kPMBX1eijgoJnlhE+ydMPJVxvvdx8JqSLPcE5DBD48B0FXdBihLugrdr9CMRzh2ZJXhY5L14+PaOI8jZNj5JMmJT3cpxm8bkPkWVnRsOIX9v7uhbnt7bvavCsijed2rnMMMca0I6iLHE9Rbndl/+gjU1+8JkTpcWIW3BhH/iyGUeiR4bFyIv8QY2kn5hYhwoLBvniantKIEMyWncVStRIYn+Oq2oYg8gSAqd/cBpKQJAJ92diRlZ9C6c4uQlJTryrZwj2mAO8yPo57o5mNCI1hv8E0NFxzVun7e7IVVsrD8NswQiTBsPklNH8ere47BqvVDdETSuDmiPOeqVRYiauEIkRyGgS2kALQCVTzfKHfk1MLMmxd99uUe7bEUhWb3snknPVesrc5OtCS3FzYmEhS9tBVG21y3pzdaMS8zTTnWoJvBB2hrsvynpMPSlypAhuWpfJpbzI4t8VaLV0GmQNBhoWpimiSF6sBitwypXFmj1U8cop/DvYdM7cUijZVJ+8+/MNwwK95oKfkmWXvNm8Mk4rC+enK32ewLFygZmOY23Ad1xUZoSAYIx9j+2UlMNXxyi9dJQUDos+vIiWsAVsmtZRBRSp5UEmMBQ4GvPceM0D8dIZ/ZxNCJd0jeRlXfQJtNCc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199018)(38100700002)(38350700002)(921005)(36756003)(86362001)(2906002)(8936002)(7416002)(5660300002)(66556008)(4326008)(41300700001)(66946007)(8676002)(66476007)(2616005)(83380400001)(186003)(26005)(316002)(6506007)(1076003)(6666004)(6512007)(52116002)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjJYalRJM0k1Rmc3d3hVOCtvR1pxclc0cHRmaHlmdDkwa0YzREdPVGJWL0dL?=
 =?utf-8?B?TzlXWDBvMmVBcDg1Uy9ra0QvLzJlVjhzQ005Y0F1VW95azVPOFB6a1RkVjdl?=
 =?utf-8?B?ZExaakN2azRKa2dMN29jOXlXWlVjMk9sejJLemUvaEdBd2pYc0tmSCtrWVlX?=
 =?utf-8?B?UEh2RnFRWWhWMm0rTGR1Z1ZzOFJkcVB5RWM1WkdhUlBtODA1ck13ZUJBUENp?=
 =?utf-8?B?Mkhoekt5akU5bEFVNGhUSVFZSmloMWZDZjFwZXBYQlhXUjNWVisvdUFnQllX?=
 =?utf-8?B?K05NUHZlN3FWa3RvSXZhQ3cxZEMwaTdaS0owcVpkKzgyclZhK1I0d0hHYXlD?=
 =?utf-8?B?NmtLd0dUYmJBUU16WmllQ3FRbk04TUxzMktmL1NUVXFHc2tSVjdHMnF5OVcz?=
 =?utf-8?B?a0JoeGt2Q3VOQitKZU9lM053RDhsdWxEQTlENFVHM1ArVkpEZ3k1cnhHaytQ?=
 =?utf-8?B?czNvamdBRit1Q2tVeXFTZ2U4S0wvQUpxaGdJYUhEWWY5enVicGNhd2twa1Ax?=
 =?utf-8?B?aXRvdHpaSzV3U0EwaTNZamEzemtmTTJYWm5oSnl6UUErbkd5dDRDSlpNOUE4?=
 =?utf-8?B?MS96TGdLOUp4a0VabHUzYlhjdTJtVjNCNEJ6MDUrTWlMaVVNRHZscjFaNllG?=
 =?utf-8?B?TE9TNzdaZ2J3QzA3U3FMS2pTSWRkZlpoMHJwYWNKNmhyNkJXZjlVMGx4cllj?=
 =?utf-8?B?RndFTjdRM2ZZWVVmYzRVN2tyVFhTKys4OFNoa05LMCtOZi85NmRKbzB1cGRk?=
 =?utf-8?B?NlhUcm1qS2U2TTRRdFdoTm9sQmx6NWJaaDd3bFhmYjViS2NMUmRJaWJGZWZB?=
 =?utf-8?B?blloSzBuNlc0Q1FoT1NaL29PTGN3NHpDQTdjVlQ3RDIyOHV4SVVORjUvTit2?=
 =?utf-8?B?MDUrUHVrUSt3cjE3RTl2ZzNvSzF1blJsMVg0NU5URFh5Nmx1anIzSVhyYmFw?=
 =?utf-8?B?ZFJSNUNQUXNOckFZQkoyQzZmd2ZSTnlncmxScWFrSVlFNS9OS2IyaU1kQ3h1?=
 =?utf-8?B?NndESXRQSUw2RmNNblZEbGlMUW9mZGM1K0VwOE80N2pYQnVnSUloN1ZmeEsw?=
 =?utf-8?B?ZlFZSnRJOU52Szc1bGR4TVhZdmI5eHpvSDhXYkMzZmQ1QUppcDZMVVRlaEMv?=
 =?utf-8?B?RGhxQnM5ZitEVERpS2ZEVzNwZjFqekdIQTJQUEFvVGZQZnN2T0tGdGxVYzh6?=
 =?utf-8?B?eW9IK1l0eVRCTjlxcXVZZHQ4ZUlFQVRYcWVPY1RCeXZoQkk0UDhmd2hTenBy?=
 =?utf-8?B?NnJzZktVQkxBdURtUGcyK1JnRG9ib1NlVk1IYkpJblJrTmhDZjdPSGl0MVZl?=
 =?utf-8?B?dmZQdE9EU3JmTk1OQUZsdURobmNUdjM1c01oU2UvU3JJLzFaczllMExkVDdJ?=
 =?utf-8?B?N0M4MHZHZ1hLWTQ4UmdQUS8yRFJvTmUrMDJrdStON0JOcDJPM1Vtak1VRk1U?=
 =?utf-8?B?YlBVM0FrdTNDZytmRVVRQ0VTLzk2Z0x0K0VIMUVKam81RFhxVS9Ddk0rVHMz?=
 =?utf-8?B?VUMrWnA5cEkzL1RXRVF3M1B5eHZFb0I2Sm5MeVMyM1FNTU1sT1ZhV3NaR1hp?=
 =?utf-8?B?RmluTmUybU1GNFppV2V2T0VlNlRWbVJKY294c2lZNlBQZGVmdEtCaWlVRmtG?=
 =?utf-8?B?VjZkbjFUWWNVRExNQ2QrdFNBLzZPMnZ0SDFJMExSY0tES1g1SjIrNGJaOVV1?=
 =?utf-8?B?T2dUV1cyRHdobmJVM08vRTZiYjF5RjNONEZCbXRibUhNSkVVM1NId0wzMkZs?=
 =?utf-8?B?NDduMEltZGtRcE1QYk1HK1A3NitiZE1jVDNxMDVNdUlDZ012Q2NSQlAwemR0?=
 =?utf-8?B?MmlnaDhmNWhGdTlMMy9GM09TU2Z3emxmV3FCRExBWU1YN3pmckU1eGtSbitx?=
 =?utf-8?B?UW5xMFlKTmpTRDJDV0dwd0dISlNjM2R0dXkxRnhaZndQVGhiYjBpbVZxRVZ6?=
 =?utf-8?B?eWZWQmFmSGNsSVB6VVpKNEhuV1ZIWE4ySU4yK3hwaGh0RWZDeWhOZG9sQXpa?=
 =?utf-8?B?cEd6Q2xRZDljd1pObVFXSVpqTGJZMnh5YW5MYWpqRUJieDBDeXVSYm1TczRV?=
 =?utf-8?B?NVZwOFcxeUY1SDNCVVBabStEV2hpSTJXaWdSOEY1UlA1ZGRaRmpzdzVIa2xz?=
 =?utf-8?B?V1pZWG1TVk9acnlUSENGaGdpc2pkNlhZOEZyZXVkb2xKQmk5dGhZd2VFVU04?=
 =?utf-8?B?WXc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 574a1458-ddac-49ad-ba69-08db23d0f7c9
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:41:02.2606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQz3C2gshDJw6O0aDszBS2SjjTul0/Ooa0MIKmEzMWJbB+YAGpkb3vAfKrVgO8wzgX321y3jzpYzKF0ZZDcuuLPX1i/3t177H7yrJnyLnRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Neeraj Sanjay Kale (3):
  serdev: Add method to assert break signal over tty UART port
  dt-bindings: net: bluetooth: Add NXP bluetooth support
  Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets

 .../net/bluetooth/nxp,88w8987-bt.yaml         |   46 +
 MAINTAINERS                                   |    7 +
 drivers/bluetooth/Kconfig                     |   12 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/btnxpuart.c                 | 1293 +++++++++++++++++
 drivers/tty/serdev/core.c                     |   17 +-
 drivers/tty/serdev/serdev-ttyport.c           |   16 +-
 include/linux/serdev.h                        |    6 +
 8 files changed, 1393 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c

-- 
2.34.1

