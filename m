Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C1F681840
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 19:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbjA3SGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 13:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbjA3SGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 13:06:18 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2071.outbound.protection.outlook.com [40.107.7.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EC83B3DD;
        Mon, 30 Jan 2023 10:06:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6MUyhyAppzWQW5fOaoTgsz85vhlPXiitBozskS7XwUpoqI+ODP8d3tTDzBJHKpBvAnaMjI02kKC3h4GSY+8FWHZwlcY7iTnkQEBsqY14h2/eogaSCE6VOg4eY5cNrwFaLEGmphKT0S8LR6mr8h7TmBN0t3Ni0OFFoDoiSMHlnq5yPKEoKckkGr+x1qrF8/nH1TohJOGY7Rggi+FdO1ogfvJl8mMwt7kKxMGprdTZx4OUY9abz8tDwoFnJl0eB31wrU81wPAE1wQE1POsXmGOz0VQPPEzALqoLt3PAX/nV/Zq7czuxz0KMkuLE9jTKvSCCYHQ/ucar/stKeW/GpcOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4cTBJEo0OjgMKQJwnn3TzO48Pw56uEYV5S0D9ZAAyI=;
 b=UJ08TgSYfUsGjHcbiG7iKWxpV27LJ8j0DgWrLAmgmutThMEBgHvy9Kqt0wWMrSHjtDjhLwr3ZEwbR61IdVWCFd7YbMyuoJ+13QeEjzk9DbDXu4MMuy7VOOiNm+g2wpQcdPEQe9n2c9BCZPHmofQJNngG+poADRKdvo7P9HqBmd+lBuaecedH8UPTNcxP2uK450Je8yJn4ECYTL9e0CbqALlFRBdtI3i8GCpkyUV9EOfbyLoqfCnqc0czeBenxIEX0flXSBiQBpbdovYGN1d8ZlMIYQynnexT8kJaudiaHFUeovyQ3KQUD9lnUY9NKoP9uqEviGJ96s7MfLru55mWng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4cTBJEo0OjgMKQJwnn3TzO48Pw56uEYV5S0D9ZAAyI=;
 b=N47iM3LDktMN1jf0F0SjRNFag8keS7GFLRDNpSkak0aOUF8mZ+Y4n9ca7WxqFFkJgScBe4W3bQ7dxQ8y+7Z4v37OR3XeWnUUj4HsrzXGmtuhZtrykS7ifVBR8ePR2YCmFVM55aS7k8MdX/h2O7vzcIi4lIQ5o3rgpbkFT8JbZP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DB8PR04MB7129.eurprd04.prod.outlook.com (2603:10a6:10:127::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28; Mon, 30 Jan
 2023 18:06:12 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%6]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 18:06:12 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v2 0/3] Add support for NXP bluetooth chipsets
Date:   Mon, 30 Jan 2023 23:35:01 +0530
Message-Id: <20230130180504.2029440-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0008.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::19) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DB8PR04MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dfbe566-7bc2-4518-b469-08db02ecabe0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9unhWjM3NsXoZibV193tUxnAvTlELWJIVyX3mrpIaQ8Zp4ttRyYSVtitrk1/9LFBlxslpWZstmvE12Dl5Yl8rgknYymEYMp3g1pypxBgNirLPgQyif51pYIPlOHJFRkk6rc7RpGWNky6qBDm4U7MYX7iVGQuVlo6mm2zRYb3ZQN+w6bcL2gJZ64CBq58RX+wzaM9FpjGuUMZUfqFCGG2X1VRHRM4s2lAR7sCAhKv8QEgstJn+yu5E0g6puI76r5rswxhzqb2/xCvnpCbeQWvu2Amlh9D2cU4GuwGvmlDLMM9+oJZ6Lvwz7wwWamreLwCjFScP2kmWE/uLGwrMiOW0aH1BjL/C3UJDsIQPEyJydhN6JVqiU/4o25tUkxxjDYzv+JMQSN5gGfgww1zTuc2vg5Q9ljD3LJ78i6KASvbUpOYphVhSfH7P6SL5HPM50VCXlnApxMV7GL45zzL2sSNZ+0bmWDObyItUxXkEdc8rXVblaKxbXzZynNEJfaE70SkcMEMGatKeF2O98VQ9SBm+Sk62ZxBOhjjkS22xnprXGtEDn8KvOPbE7/GBRL89h/3nb0S0sZBdvK3X11K2erM+5mDZ23hK4xfc+7q0JzSv7AwA0QLaZUvTYGy+zMq+BaVD7khNncx56ZvGwmuRMqDXE4A0biPyzyD/2d0JO9lflspqovrcjqqaPvtUIwh8MX34kYSy02irSYr4ZaLKfbPhMDCWrpIueYeIy6JMzbhIf0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199018)(186003)(6512007)(86362001)(26005)(6506007)(1076003)(921005)(38350700002)(38100700002)(83380400001)(2616005)(36756003)(316002)(6486002)(6666004)(8936002)(52116002)(41300700001)(478600001)(7416002)(5660300002)(2906002)(66556008)(8676002)(4326008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5jP20E1GCs4nQQhhWBsyA7doPFMv/E1F0XrjQlZ6ubdyagmdC6VJmsDwdhrl?=
 =?us-ascii?Q?+j4b4n+dsySun5SaE5UcsEvUAbmwEAiUKkD9MzJWgBzisCrhoCETogeLgmuW?=
 =?us-ascii?Q?e4bHCljWHt8nEkTQMdPpCKEt04YY3CW/me8Mj44FAs26UFoWdN55fb98d/O3?=
 =?us-ascii?Q?MhRUCOVTuRzzmxIAyiNY2Ja1uVqI5C+gZErvvjGIR0qajTY1tjMGxzqDab+u?=
 =?us-ascii?Q?jdHV+PfIvr4SCsFv80OMX9ekcQpIM9oXbXDg4u4a0FxL5dePXu+R+yThj+xS?=
 =?us-ascii?Q?ndjfgxY6cNt8G7vrpblhwf3Z5wULa5nQa6+z4IO+pbsw/E1+oWwiuDK1QcCW?=
 =?us-ascii?Q?5vHV7jZo82XKvvbfaJd9kYPNuZ4qrsFkFvf5g7jUXTzHTOrPupt58eCOhUOE?=
 =?us-ascii?Q?CP4TA8l+iPo4yqjEU0pgQ4nkhdgrRwGYcwUqth46oaSWHyfNfDRs4uu7wFc1?=
 =?us-ascii?Q?6wjkAQTC6lVYMVAlhptTv17jCpO033NCpEdaHmdbLWU1fEIe6HZ3obqqd8jV?=
 =?us-ascii?Q?30Nm8XjTWxZBfpWBU/iZM7Wb0AcXTtZWi3V2HskF1T86mhAfk6+o5VRBBv17?=
 =?us-ascii?Q?2MC9j/HYHXTgNDW/gEeN6noTfnoW9QMzvnkeLCAMz2StvsF5ch27Ma4BgV/U?=
 =?us-ascii?Q?OtUppYe3NYHWjrjwtOo3GwFokhoLiXJMpV/ta6nuxZnHcfHuX+K+xthRaLTh?=
 =?us-ascii?Q?a0yzGLwizoIbA7guadmKoQUHJxMmVfhzvvnxqbAssLIfT2ORC7PwNjJAigtV?=
 =?us-ascii?Q?+bTHmJfhwCgTu4lqqv07/CbDlJudi+YEZDkFh7FnTDj8zh/p7bUqzVKSNYcN?=
 =?us-ascii?Q?DFiOeIQUJ1thM0Pos+426SQIpj75vv4RRrZOvVEEoSYJkh/8WCQdAshltcu7?=
 =?us-ascii?Q?teVWmHv1eg5J3OTk7JRzbUz08iD1L6JO9ANBOyTonZRCO4LDJk/ZMw9HK5cJ?=
 =?us-ascii?Q?EvnCsmxbgySlX3mGgQ+n7KsvZkqUZDi8It6PQwjj9UfyN+2NPq3N2Fyc6mBg?=
 =?us-ascii?Q?v0/tzS3BORLbBs3oEBVp6JO7wFkFZn28rkSWZ9OgQeV+w0ABKIVT8cKG2yTK?=
 =?us-ascii?Q?TY+77s3Moyo9pNiowZmOoRl6TdO/5MELc0n1sU0yi8zIoVYl+1CT6TqMTPMH?=
 =?us-ascii?Q?04bE7D3by1T9equuGw6gX39TVoXdt70wkRW9fmMOrP8/kysHJhB217hY1L5O?=
 =?us-ascii?Q?5b/ZBjjgHAE4KTUJyWOwoUOzykvsSMXEljNxv2MtRUpLpnCX+nWaBIsbpwVb?=
 =?us-ascii?Q?JT/3IOJj+7htwhYwmRCR7YxN86PLLNjTu8OC1N97I21TRP5SE01ZY0ButeCG?=
 =?us-ascii?Q?+mF8BcH+olcBmtNlM8JjQINmI9QsZxEHGv2Cvm3DEgCTLn+WG8BfbPUoW1TC?=
 =?us-ascii?Q?v8O1KFjqAnpWBengb+v7+zkMzbqiCsErt+FjokftIdRyyEbFCBKzDJvnTSAf?=
 =?us-ascii?Q?MhrjD6A/v6C1BcI3U1FW79/zOITHmA6eEj29rsXQ14u88VfgbqembKGr2iRG?=
 =?us-ascii?Q?eflwMRhh+lCGA5l86kKHNN0mIgQm8EYnzYpE/WsS5bH0c3yc/pcUk7444+4Q?=
 =?us-ascii?Q?rGlaGVzw50DavXiqLeGS4FAZoCvhjPObS6mF7VHOa5Kp5qVlLQ7Q+tAbIhC4?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dfbe566-7bc2-4518-b469-08db02ecabe0
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 18:06:12.3942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r1/H3Rhhqcfk7+rEeNu+4o/vDmEpsiaPDU13zV2vDZIxC2/+T6TuVgk++9ekYmqrlrJQHAXltdbZq/vkh23lz4bkKRt1l58dGvYWHazxcwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7129
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
The driver is based on H4 protocol, and uses serdev
APIs. It supports host to chip power save feature,
which is signalled by the host by asserting break
over UART TX lines, to put the chip into sleep state.

To support this feature, break_ctl has also been
added to serdev-tty along with a new serdev API
serdev_device_break_ctl().

This driver is capable of downloading firmware into
the chip over UART.

The document specifying device tree bindings for
this driver is also included in this patch series.

Neeraj Sanjay Kale (3):
  serdev: Add method to assert break
  dt-bindings: net: bluetooth: Add NXP bluetooth support
  Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets

 .../bindings/net/bluetooth/nxp-bluetooth.yaml |   42 +
 MAINTAINERS                                   |    7 +
 drivers/bluetooth/Kconfig                     |   11 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/btnxpuart.c                 | 1145 +++++++++++++++++
 drivers/bluetooth/btnxpuart.h                 |  227 ++++
 drivers/tty/serdev/core.c                     |   11 +
 drivers/tty/serdev/serdev-ttyport.c           |   12 +
 include/linux/serdev.h                        |    6 +
 9 files changed, 1462 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c
 create mode 100644 drivers/bluetooth/btnxpuart.h

-- 
2.34.1

