Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B102C6B79EC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCMOKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjCMOJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:09:59 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2084.outbound.protection.outlook.com [40.107.247.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F9B5D44E;
        Mon, 13 Mar 2023 07:09:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nq6dOPAqnccj6ek1VoBJxKtGdciVnHaCpwB7W9O+0UxtYa6uR36BBYo0gXGjez3QIJ7IFSHLjZzO6IV6ZaznkLvhvBti1KEADrnYOQKXI3ZfWJl8WuyLKm+3csYWrnQMJFRsBMLSPkLnU/dYZm/6hWlLIkhJb00uJ1K2I/f9AYS5OJuHNP44+kU4w7/qU8x2Q0dKs9rtVK20xq7oLdBGGFMF7ovcP3Skw4Tw5/k87Gy3I9z7Kml5iKIp4B0EJkohmOJFmJSxRNsSAr0FOK9yT93Hyr9ouSNWdUjQczRkfFgTLSpJlfyt7EKyUAwyqi1fxUdykAZNab8P5qucgj3NFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMROdIwdrwhNN+iwm41m9w8HKuedgaA1/YxzkYHFOtA=;
 b=LHNipx3rvyiGFBrJyBNL73XEl3RLPCKRcNAapVnzZ6NuYioVYhWCPkoWL4dalxnEeWdbhIaAiIqorLZYEvuXONGGrw3B46kSQ8YC25JaQECl6j/4vrFuFQBcCj/g4fc9X3eURQohfJ3wn1iCWtoSvN+pgW9aVP46uR1PV8+/NuVzqG+++CdgmQVGLf6WJJj896LMVzYZtERsyAFdiLRswSutn+Km39CmiQ6j+cVixA04E+XhGzXRU/S8475RkHX9UiSjtOQKWIJVRE/DtP159+ZEVVTpo094tg+hzs97GOOV0n2Eoumrfz3CeFEjO97C/ey/xpN6UBGFVBOUO0ymEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMROdIwdrwhNN+iwm41m9w8HKuedgaA1/YxzkYHFOtA=;
 b=M7QMtk0gCnlxKvJ3ubMt71+FyMAdd8MSWCDvz21ARiLKQunEcyUCyw/qojb305ZhNPvrcj0wADb9GiZ3zxGXqbD77iJiWjCyWstP+kXXt+mWxXfrOoRc095jmWLv3vV6cVOX4tlmzIEY7A+gKSLUAobTszeXnfgrxulaBYGOyz0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DBBPR04MB7594.eurprd04.prod.outlook.com (2603:10a6:10:203::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:09:55 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 14:09:55 +0000
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
Subject: [PATCH v9 0/3] Add support for NXP bluetooth chipsets
Date:   Mon, 13 Mar 2023 19:39:21 +0530
Message-Id: <20230313140924.3104691-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DBBPR04MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d8a43bb-da00-43a2-13f8-08db23cc9f33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r4moLk0jnvfDGfc6EwzfJtWUzXDOQ5euwCGptHdHGFWCPFvdBBSbLVFHS46qa8dTHcWuRMQh9GtWsu+jsGLMlmkxELq8+DyrKAubna/+9APiRM4KG4P2XUmrTMKd5xVFMv4U+JE0AhvbO2m+zTKiyYC2XxClecJRlPkvBDb37+jdgZx2FIXTpqTlF4W/vUu4nE1DSsvLALC56mL8nRDRQ6CkdU5Ct+3Umm39sHCShxGA8QKj7E4z3NGf0PlPtVsrC4nVmbNKWDulL+lHbsZ4qatRTFro1fKl7ZN6wiAj971owRiGtBy63wGbxHCli24F7GDu6TMsDZG4knYX6Mk0ybkmqBs4qBV+yAcVF5E4FjDuoOgOnzTvpV0Nm5s0p2QYVkDYZtd7iyhjznXqlg1G9E/tuQm/UYMwetPe0TJt2d3cjAD7WcgK7nIDX3LAvL4+PuzFBVteNb37XpVGTAAOS+WhqKzLPXxsOc74DNRnEtvoFyz3U80qLL5Z1xWwt/eDzim6AWGbj0B4qubf7OIY7248ngjWDDSgzxdNK7SvU+vu6TOm7V0LijiyJmiN0d5rvnKxb/S7fYL3SRzwDBoRnH/h7hihyHhwKbDGuIpQ9VXMvBQJubV5bno5rXNciOLaC1Vv7DeyHMtEbeemKx5AELvE53g7u0kgA+dtqGGouRgvMu2gOedJcT6upWEk60Exo1yBHw5wWUQxQuhBMBZECle81gv0+xvWF7SQmNFFY5c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199018)(36756003)(86362001)(38100700002)(921005)(38350700002)(52116002)(2906002)(7416002)(5660300002)(6486002)(8936002)(41300700001)(316002)(478600001)(4326008)(83380400001)(66556008)(8676002)(66946007)(66476007)(186003)(6506007)(1076003)(26005)(6666004)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i8sI+V1lnl6XtIJCS49fnYsbyq5Ywzd4En9Z+KeVJFxrcl7H9Huf4ha39NR6?=
 =?us-ascii?Q?50ZE86b3Z/1MXh1np1IEZ3bhk2ULLE6zv+bmz248I5TAP9cUzXEK5P6JJXcy?=
 =?us-ascii?Q?7LieD4GAHqMAHEMcZJCXuhP3rOWgbGp36LsjkbGftnemC15XdVbpJ4FZRC6w?=
 =?us-ascii?Q?bTIVJWd+mBGMgDJN0K/Y9QrGXakaUaesShs67mI22BqJn4zY4DrzofTANP71?=
 =?us-ascii?Q?i9iizRcC0mMXzhMPWTdZhyHn1lJOEjojFThWPpYpSjUnwZOQvAMUFMBDByWw?=
 =?us-ascii?Q?Y1uXt9QgHqzpWN7xI7W03igfkxwJt5taA4T6zTNv/qV6C5AEhrgxXiFfR4/N?=
 =?us-ascii?Q?s2zmJ3ijPIRiX8iv6flI1b0YOPHCGlysPVGaFqKOJ+uLhTDAzXoGdxlqii34?=
 =?us-ascii?Q?k4bJKSwo0SIcKtQ/a2Kt5jJH9f7S0lm9vWChgphDdDKQ+h130cxFJJLeEpK/?=
 =?us-ascii?Q?GUTvsadFbGbvN2dCXvltmFpn7WDt5inJV6jRqP3YtC9bFAuxJCdq5sLEnjT3?=
 =?us-ascii?Q?4mlAziGV+d6As533U8NnO5OZpRzNuuEspYOfkI5vfWhDssdA78h/jbRtLcZV?=
 =?us-ascii?Q?o1d94WmsKYMfryMH3AbtSPqd1t2Jt1NSPOc2SSbkfsWg7DMW8BdvGThC70n9?=
 =?us-ascii?Q?Oj3ZPXjlX1mq8n2BF3KAhWLZ53ZJTHnV5cBXdeHSejubq2qind77fblAKT6C?=
 =?us-ascii?Q?ZdHKccJVCHH08aGSHEbTaxdHrQ0cvbKh9gweCBZQ8Ey60FSgJXW58FmMc0Pg?=
 =?us-ascii?Q?86G6aL7wC70Jk81Xk4th2as8vemyWber1uf5ftWCZLlUyv2dOgo1YfQmPxtb?=
 =?us-ascii?Q?JDzxtzGVmumVr7i2lsQI3lkbu5K5RLXLSEDJWfflvpw6R2rChfaOqtQjqa1c?=
 =?us-ascii?Q?EfOsgqQzgKr732RbeT7Mquvvh7moFxHCXPJjhZ+U+HdlBdknxiybMwumP3n9?=
 =?us-ascii?Q?fihvgRxzByrPOVOGmd58vmDx9ouedp+2Kpl6trM/kHP2+jA/+3IqjmiwN7B7?=
 =?us-ascii?Q?YHDMwELhmTJ4tCgjtBomoasJp5ZhgdcLqV4Srpu7HnV1D4i5Zm05jj3iL2SO?=
 =?us-ascii?Q?fT/LYsWcGobU251OPPFTNzR9oiL4saLedCvG6ZCb3cD5qDk1EhVJPXKcDNq7?=
 =?us-ascii?Q?U51J3pIQhHCSYIEr3uFI0eQ3Y+Kd8ZKnY6WgYjnFLyaaIuEIKnL7iWZO0G/2?=
 =?us-ascii?Q?FI9zy/bckBH03BCvhpqa2dmRNahE50ekuSzzmXfG62qTIyMQ9SbxPaX9+yEp?=
 =?us-ascii?Q?/R4Z3Mn3AgHkn9Dx/NaR0NuY056uz7C430puNYRvx89/OM/4hVCAuE4J1lYK?=
 =?us-ascii?Q?8+NN4JgY7J2p5CNoReVQQstTSBsTV0xytzyK8ekDYOwFQFE4k39XEqM/6Jb5?=
 =?us-ascii?Q?mP05bCQ5NzDUgwIznsEi0++ThRt/HwQYLpLUp5Wwq1dJZ20lm+ueCIShdCge?=
 =?us-ascii?Q?q4CFVJczHtxIx/rurShOWXXthsaVKEEp2Fg3eaQqDQarwxJW61HR+GfBnWR5?=
 =?us-ascii?Q?wFv6JDgTFcef6XDZeIycoqp8Vn2EoDGnENuaGmoMkllrQBPKy4FmLpRqK1mA?=
 =?us-ascii?Q?eCRdS9OLjFtlGVO1yLPvfYKtzR1cGLw6Exkj7/GZdk1WUWnhQ9fcOWNPcG+k?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d8a43bb-da00-43a2-13f8-08db23cc9f33
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:09:55.6157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2jC9idUtqz8nmio2A2ISGUQHfYZ3D1XtmLDHwE2kJyXrZXw/E8Z7K7uV30vLMRL8CQS8vQHaHzH/AkJtGVvtBK5u5ufy43wMCdGPsRLqEWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7594
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

