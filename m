Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A476AC940
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjCFRHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCFRGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:06:50 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on0602.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::602])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385F9132;
        Mon,  6 Mar 2023 09:06:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEpn91VOolMrSXnYl3Sj9QE1awSI2CpF9K40vlufn/vjuRy59qf/X7VkdwYjzBuU6LE+r4VIY1WVZ8cRaYX5bQrKY22HU8d5IT8ANwV5CRlWEyUhsy04HtAgH8ZCAoRkOQtJopkAmAeopn+SQqyPh10BsR6IHr8SbYPhSh4gaoqPu1G3oTZQaXeoGLXJHnVdI3bZw5GhWT4B9VXmuxGsECrd1tq8hhC8yHSG6E8mctWVcnj3itoGHDbN/+6Bhny+GVNiE8TW6Awveb0DebwUu0OkLXdvuT0Uu5b9dAAcWtLAXLeTXnUaRenNpEDm6qSMtb3OWyexmQrBtoyegme8ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCoronL9UimY+ENdsvlEO1LNshpGhv1x5NtizCXhY+Y=;
 b=D35RJ9SCaztz+aKPl+5Emge/Y2GCFA5oCIbLB8CI3G6q2plgNRpS53J34jcYDyjK81/pGQNcUEYgo7QuY4rm9kCW+9I0KI7uCLz6qlWBZxg0UD70Q6DnToaUNky4E3fG4RybSaVBC91lsCESPP67jVoj2SFZtdMEY1r/q4O4dnf3oY9L3YPtTr8F0JoejRsNrHvGndYQfeQe9ubRAZPG+qmE6sH5q8T+wWJBl5TsJq0ARQpTGmsjumHMwe+7oDm4CKzsFu4G1VNeojeAxT5DSrjGV5U/fbB7eeOGNdKYvvaNNTf8J3SPYqfom5Sg8BIT9l6H6w1M4AItuAocYZwyKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCoronL9UimY+ENdsvlEO1LNshpGhv1x5NtizCXhY+Y=;
 b=OLRegU66smKCb/U/BMojrH/v9S/LDzBxfAXBw9MtZKE7OuMionVVC0afwge39F1Exmu3VI8rj0fBfr7Kn4LNo/x+h81A6n88kSboyAbCZWPQ3WLx2mi6j2rp7vyhQvMgNSKvPqcc9dGTvDqbp65Wb0x1Mty4ex97kG19unb6Bpw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM9PR04MB8556.eurprd04.prod.outlook.com (2603:10a6:20b:437::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 17:05:57 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:05:57 +0000
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
Subject: [PATCH v7 0/3] Add support for NXP bluetooth chipsets
Date:   Mon,  6 Mar 2023 22:35:22 +0530
Message-Id: <20230306170525.3732605-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:196::19) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|AM9PR04MB8556:EE_
X-MS-Office365-Filtering-Correlation-Id: c24691ff-a7f5-452e-09df-08db1e650d7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VevXcJdS0sKHTnSDAX0rFY6LevoJLkX3EjTA9fSfR15OeXnVZOM7HQin9XFiJeTnVhYE7IvJKq0gzmTYSxnoMOB5K0y/9X6EIWutyHUJjHzk8YHZyC0uvBOaIO0q+NSaR8kJZws2oz5yzRqJ7p1geonQBZCFvLLDwt2W4rppN2DVsF1y44Pxc4mbqLMS3EdF6pCif6dy6x+KA3qiRDdte5XXw75HFwfPyMvhdgna/9qYAKqZPA1Qk+3SKrVx9sjxvSSxILI4mbn4hFQw+0BmQghZFJn5478GVIW0gLCAQHBBRZj2lVKBb1ZR4Yq29HwiW2+ZVqmz4WrSHMM4N6Ho1w9CLtH1EGcehipPsM0hUXmnQ+0Xn/oAxa9khBpiuGRN9FRIOQOMu/4766bQ8fTluiwJaM0Pg/w+PRW8oWTqTOJkvcehrUrUXKemKJWWz0LcFl1hNEDITEi/gLT3QSnC+loAR/ktn4hq2M1wXsFCa734f8ktW+nibYcTGu/WZxXA+yG1TMHHOA+3gSitRkNeGZMtLhU8iWP/EUr69n5C1ckzqR/JJEoq5mIa9lkeTP+8st65IIEa6oYbLrX8HwM422+2Wqc63ZsNdvX1VF2Cj974P3dt98S3otfYbGR8NSeDNZP/2iZIt3eCyjXWHSQZmDD+KYd5IYDmHsy0zhfn5pWkSe+li/Z3EJX/o/Nqp3I+0ulk05lwBaWdxjBIKhyr97p202VPop8Jwo/wbd/kD6Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199018)(316002)(36756003)(83380400001)(86362001)(6486002)(186003)(2906002)(5660300002)(66476007)(66556008)(8936002)(66946007)(41300700001)(8676002)(4326008)(478600001)(6512007)(1076003)(6506007)(26005)(2616005)(7416002)(52116002)(6666004)(921005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oMca+5V1KygbRZ+MQljtNlGoNEE3HUjuHQrecCHL1lSbOhwwnZN9Kg8UlmQJ?=
 =?us-ascii?Q?+nyM+U8Tny91jIjojINDVm0uaJd/x0vS9HfGy2EqH57H366x5FmsQb4f5olV?=
 =?us-ascii?Q?htCV1uwICa6SjN1UTbULWUZX/3MRvlR1Iq0ldwDfDpK2Oi0wusMnw+2gZ6ZO?=
 =?us-ascii?Q?UOkF0Hu7YwXB5aURlcQWXx5TYK7duZ1R9FAG7qGCW1oC3IYONoC42Ae+HAS3?=
 =?us-ascii?Q?kjsi3rNhXyQZTCSaj4wBsfV1eR1zFEyTY529bfOvRMkK1Jznmsovkp1JN4t0?=
 =?us-ascii?Q?Q0NEP6kbUtdjI/v4eJB6u7far+9kJmNQtWLdUZ0pIZLPomOkS/UtnZjz94C7?=
 =?us-ascii?Q?EP7nG0k3ql4cahARs2dk3ydv5orUJuS4PudPEFfPf9SWcx5mBzR5RRu+hKej?=
 =?us-ascii?Q?bvnbJ/zGeWLpVHEbOoVi7Zqwory0om1aBIhVzsuqSL5Q5YMI4LeuUSiVxQw8?=
 =?us-ascii?Q?k8/nFI8W+HO5ADDG/N6sd0ZYuRPrKb5VEP4JvQNoPKg7vRAxi8U2dMySX0Tv?=
 =?us-ascii?Q?l5jG0h+Y1XIsR3kNcIeAoCm8rg/DwPiyBz9nCRwVzbAoz4ejnYr2UcH4UhFP?=
 =?us-ascii?Q?gMdcJcWUAEemCCs1FfpVDATPNpw0JtBA4mW72qWBxZu3XwsSDSS/mJRSSi3H?=
 =?us-ascii?Q?3PwoYiFuRzbMJraSJV+KvGteGbUR2kvPA//c9HzuTGj4s5yu5vZej7EHd7ta?=
 =?us-ascii?Q?x/KJ1kyzDwET+fqRcJvyQPdO/yYnqBmA52iZLl1/tvrfJNWonuscvWVbU50w?=
 =?us-ascii?Q?t/H1Swvyb9Lv2PL1LdBlY1EexL+9Ie8lq0Ss8hBP8WTCLNjX5nK9uJFWKdQu?=
 =?us-ascii?Q?bgdq69IUuhZTSyGYeu4m3AihariIDKumvidfCztLkoe2ce9MNv+YpSwsz+TQ?=
 =?us-ascii?Q?S7P+RCf1Md2Jq2qafAo6PrCLqxYUz7/pTjP1a8JFWxW+TXGXD/zzgtcHrukv?=
 =?us-ascii?Q?s0q01lGVohXhYu8w1RfUJxQvtaI7Fxly//k4Laxv5ops6J8FgQEgdySMgqfS?=
 =?us-ascii?Q?N5/lciG1Bb4iSVns+cR5z/PFZx74hroRVEa8E08s53P+hwkFq+SHM/tDlDaD?=
 =?us-ascii?Q?bzTR3eBjlpua1v4qkJ/nMswUUn3HVu9cTMAlT7g1wKE26E+jCuO+ccABJsnM?=
 =?us-ascii?Q?QrWHWaL0XVVmoiSJOpxZWjOww4NP90VlcpUL6jnQDs68K5LXzLPfWbP6cnhE?=
 =?us-ascii?Q?nFijeRlWQ6DgrfyjuWjnSXRrjnRtTytMylyINGy7h8slBeSAWRsYVQlmdN++?=
 =?us-ascii?Q?/qJNCrXjEl69W7SUKE0fY5t2pT5DlGvg+RvJ0WKMf72YZbH37mIq8nAVxugY?=
 =?us-ascii?Q?l5D6HFCd1jeyhIoIuUBnTkM+aAxR3K24XSsV2Ros/Ekq5EgboW17VOqjPBoC?=
 =?us-ascii?Q?E+g+h8oWHzQTjKZD0BrmL9h8Qd7Egi/Welor0R58dG+FQBky8R6s4C1bTFEX?=
 =?us-ascii?Q?uXZCSLTqTvh9k3yQCvX9btHo7AKZLaATyk0gvM7udWIyu0kSPXbjNzLrhtww?=
 =?us-ascii?Q?WOmKIqZAyP84n+m1975pZ7r5Gh0ogY/gdIlwPejjhY3ciVrJxVDYBYckakfy?=
 =?us-ascii?Q?ZuRq1EYJK2g0ScqRtmXiNuqNrDfJVYJT7SSYkM5FC73GfpNN4hqw3pZsGimd?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c24691ff-a7f5-452e-09df-08db1e650d7e
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:05:57.2295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kf2U6syVZlFeCDSRj2ZFOcRmajHggIfvEEokRRjRn5ToEZ2DfsCtAoxxIbyjyI3+eY/yvJkbVAC6coX3X9Tk2VhloTSVDEjxE9JVJ8h4yuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8556
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/bluetooth/btnxpuart.c                 | 1311 +++++++++++++++++
 drivers/tty/serdev/core.c                     |   11 +
 drivers/tty/serdev/serdev-ttyport.c           |   12 +
 include/linux/serdev.h                        |    6 +
 8 files changed, 1405 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c

-- 
2.34.1

