Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9E46B4FEC
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 19:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjCJSUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 13:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCJSUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 13:20:07 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2043.outbound.protection.outlook.com [40.107.241.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA17310284F;
        Fri, 10 Mar 2023 10:20:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6/kpIApRABpnu5L6mDF1YxCB+Yts6izOG6epOrgT49OMyivm1jYeQFIHEicT/G3fXdPo20soYIkWN9pHf01Sdo4BQxVCqAsuUehB5YEfrbYfVoI1HUKVy8oktSN0F5i+Umgqyc8qBiUNNZ/ideo44kDburO+590eBLnW7Q9Fhle3UViJMAJdVv4QdRINDZ31NTGWajKsKI54ba3xEY6CyTDIurX1RY/279AEmWt8GhIAS/mB+BbpiEN1kE07QqFzhcVjb1/EPssm945yHrkXjqtG52rOF9A4kS4lpLF1eU26MGiFlIhBF7dynEF6v7Ww7fk5+E9tYO43R1OdHf+Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sr6KC+yyaQtkygcR2njzgAGJY3nOTwLhdjUm2Cl0IKw=;
 b=K3V4CwMmf3DvA78jHKlr6ddj6rIRbrbvs05ypneDJ90IXm509oMnHyPnIpd35YqkuNL/bF2apHqjvUNYYzU9cSPnrWUA8NK2Csl+rGngbBQ782A9VJ1Z7kO3qINYEGxuFUcO8VXdYnj0oXT75TAQ5zDBzLoAXzwiFYmo4LNju9aG9OAcGJ81MZ9At1qa0KiNNud2agBIwi4BYC56D2fkffqW/2GNql+jvF0eaWQfHavlUsXBOnUQ2sjXTRBLlkx+difc6jCoZjYHsEtv34X6pRx71QUuvBBj8hgaGIO/d2Opgo8d+DbGbO5cubW4VXpw7i03jFeb7zaY6oZ/kDYftQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sr6KC+yyaQtkygcR2njzgAGJY3nOTwLhdjUm2Cl0IKw=;
 b=S/2raSl5WsNsnZ5+8CejLihcOwngG3LogcGuLWvW/GuuyuNK2kJqWoEl4lJ2AzRtKV0l0SlT/NqtSt6kizLqiAXnFHI0Yq0T6I7swO5Iql41nkgT9jlnWPTMyHA5vdTMDppDzeEoDMj9T4LX3PjcW8pobVE+V5X+oEtE7zR3v0k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DB9PR04MB9704.eurprd04.prod.outlook.com (2603:10a6:10:303::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Fri, 10 Mar
 2023 18:20:01 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 18:20:01 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v8 0/3] Add support for NXP bluetooth chipsets
Date:   Fri, 10 Mar 2023 23:49:18 +0530
Message-Id: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0195.apcprd04.prod.outlook.com
 (2603:1096:4:14::33) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DB9PR04MB9704:EE_
X-MS-Office365-Filtering-Correlation-Id: 504f06c0-740c-4cd0-6732-08db21940fef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uo+AFwO/zNXdcWRjuX+my7lPpZtUgPzibPSDhjniYTlgTGo+Uhy7CRbXRdq6zFRkoHj4AX6MMt3wga5Lmh+3ZGaX92gPL/7pWOhnjRXsXbFVm2Bsq0hNwXgdLmQAmAF4yJvY8hU37iMq2Ni5ZDjLl892PmfGEw9KSQA5Q6ns/jLln3e99H72nrBWY6z/x6hOsOQSCVkqqX62i/7EVAluT/JixrENeAmg3TBEpP0cWlbzL131JGmwUhjujgYKfF8IU4Ymur6r0k23xI6JBZubnBB62qGwtcJAXcG7XBxZGmekSTk8mfe3uGwd6CKICQi98gtD9h27TOq4c3Q4V0R9dqO7cCEk/FVeSADCwFVlUoXkq6os7fTBJ+IYeUiGqmkP0sXmWDEetluoGg8EEUFLDnhyw7+yg5JQSpsmTQMaZtanVoIOrmjcSLU0JzzJOfpBqMiNy/rHoMswRe/lMOoDVeOPReW3juIh/N2ZXXUfk/KwuBF4oy06sxUokidh4HNX1uh6J0QpntMG+l2k2vdtugIqMM96jxzz7PlVfaZonXuyYLWRewPFcSJ4NpXdkeClipWHzjzd2+9fOlxB5EYHTxIR/u98L8k7zZYjCxPTLKCckHX5l7S7wapiJWqB+TsG0cXdcsKCJRs3W1zRKjdA9yOWCIX53H/NqvHBZZmuXlX+/6z2aZxSsnmhlPdP70ZK/YdjIvg9t5Bj3WEKZUMhEdd8gbFHAWWQSDu4rNdayO8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199018)(66946007)(66476007)(66556008)(1076003)(6512007)(6506007)(316002)(38100700002)(26005)(8676002)(36756003)(7416002)(478600001)(6666004)(8936002)(2906002)(5660300002)(6486002)(921005)(52116002)(86362001)(83380400001)(4326008)(2616005)(38350700002)(41300700001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xl2+xHfJ+mpgccVizYuT8IMOvDv9px6c8g7Wd8mqJ5G1EG9ClgTku64encEG?=
 =?us-ascii?Q?M8akua5/cMIXd2ebC2WIOTQ675C4yR0PHSWJEAGDEZJQRDrK5pjYYx229ZgQ?=
 =?us-ascii?Q?cv8/8cSCcFOqDrV6Xe1lSCgvVZOclGYe6/p6Ru4nnJNz5BGHlh85BbYjnbEm?=
 =?us-ascii?Q?xlGvcSLTgdlOlINPUzEtjbnF+AZTian9v9Ilgx12Yew+xTt1xYFtlhrIU15J?=
 =?us-ascii?Q?QB29WhMbLOkB9q+jU5AsjEKoraYDBMsEpCFRAXXaRbCMZAUOd30y3IFCcc4x?=
 =?us-ascii?Q?f27javeidULQZhL9pCtd7h+dq9Pb4b5PmJ4FuKdKyHjRmGb5pAiRpX69oOXk?=
 =?us-ascii?Q?jmESCZBEik1NxX6+g6fXq4qWfKtGRD5r/6DMs07cCx0Gsh8+sO/u+3GebF3r?=
 =?us-ascii?Q?lxS23ID1gQDpext1Vp0FDkj4o4KaV/gxhIHpBrqSn3J9OrNeBv1UPMiSAl2F?=
 =?us-ascii?Q?5zI8mDWqkce+p8S8jQW7LEJ1OHTN/Q54gsFHkGyxCqIEG7xgDAshMXEjEPOE?=
 =?us-ascii?Q?LRDRnzqiMoTK4RV5nuMl+WcF2WCOoEBqE7LC3MKWqxgt4YHlY+mTN/hmct3+?=
 =?us-ascii?Q?ohYmRUA6SDtHgXM9d6/D3CLL0xStCMz7cCGIsbSTlNsmNM1iSr2CM3LeqAyE?=
 =?us-ascii?Q?SZCVuee8wbgwvaneTBIqtpLAK97+u72Ccvy1d/KQkIyz8vwkMUa8Tzg5YznD?=
 =?us-ascii?Q?JT+cgSzGozG3gjkvVthsAy9hdnu0MBlmaxc/ijew/zMdxkczrcXUUI1qQZJS?=
 =?us-ascii?Q?IUfI+zJ/kr/xSfdPLhxTXjYjnxRf3anHIwMgcCjHAZKrwkAhU2/+SVWW7I5j?=
 =?us-ascii?Q?lTOSjOKcaWgwh0QiH7LG69Y5gvJUb1w8bPNLp/meZuKta6ikJTsqqdH1SOMf?=
 =?us-ascii?Q?VFUdEpglGjWkaHTQ3AB/9SIp5sRmT4e+Dwt1Cb2JFDOc2/R4nBTw8r2D7GkF?=
 =?us-ascii?Q?TxNV7QqmEnkVsKri9V2U3VDOjbbtOiXgoXInmRzPm3aVnSJq+WCBqjqA1F68?=
 =?us-ascii?Q?xn8LcKW9WbmdH9g5Mi46wpkkYhvcvuIayzl0DYcrJ9zUcpfwWDl3BSX7uhHh?=
 =?us-ascii?Q?XVZUVmLtxnHoJlicyOi10HVK3HLiKkwsEaFF8GR/X83Ee5WgUFwO7VZkpwbx?=
 =?us-ascii?Q?t5yjM9UCbi2nkLJwyNTqTF+LljH7CcnJpSu+2/KWTGKq0sUHAwJBEliG4Dto?=
 =?us-ascii?Q?Km4IRoUpf+ejlpi4ZOgnNj4CI7tFgqU7kKWk+ufLvZxib4ENhpA3onnZ5D5B?=
 =?us-ascii?Q?3iyDgR59pRNApH8trwBk6HthVrdgVLhGNzFoOXw3VW9jSqLt5vBQ0enlqUJA?=
 =?us-ascii?Q?obODGTFNQ6XE7e2NUh8T/bHe9Kykg3w0PVfbjhMrY96wOE2/S1CGtqt+bNPf?=
 =?us-ascii?Q?pYtCqnqBH7QbJyKuYOfRYVtm92Opq9jgNz2t4PR/OeQBagCG6soqQYNWVbxP?=
 =?us-ascii?Q?7F+q65GQWFrw8myyeiB5Yu0wQgY3OD31WikMtadD4pQ/4OPAy61BCUsneV+4?=
 =?us-ascii?Q?XOM2YxCjhHnR6tAMOv1Obfjr6m9AHoxdcy+DGR+lK4ZLeecUKb3xKxKCxAfb?=
 =?us-ascii?Q?qJNITUuTuhnI/kZ4Miv2q04cfycO9dCkEMF7IY07rVu4IdREqBrzBw4VSLA0?=
 =?us-ascii?Q?ew=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 504f06c0-740c-4cd0-6732-08db21940fef
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 18:20:01.1624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q0C7AvIy81k8GbRGKuTjraJ3Q9m1jmy2OSgZiB4yayo7qeYOCnkdH9WbmsXkFMnwXqbmV3t/ODAEcjlwFWA48Yvdsg+tOKpSRzqb9kYO0W8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9704
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
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
 drivers/bluetooth/Kconfig                     |   11 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/btnxpuart.c                 | 1293 +++++++++++++++++
 drivers/tty/serdev/core.c                     |   11 +
 drivers/tty/serdev/serdev-ttyport.c           |   12 +
 include/linux/serdev.h                        |    6 +
 8 files changed, 1387 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c

-- 
2.34.1

