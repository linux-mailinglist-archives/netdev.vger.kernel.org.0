Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA0B6BD6E5
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCPRWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPRWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:22:48 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2083.outbound.protection.outlook.com [40.107.13.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD58EB78B4;
        Thu, 16 Mar 2023 10:22:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nghpRTnNa3iGkzXD6RfnBhiey1cYHpHUGERpMgY14OxGUcxVWi9oB4ncsUbJLKqzJUNvJYLhCSVhHe6ge73mCeDlVTA26esXz2FQ1ruRAD12hFjfP0HfdpSfGeGyGnjEFAFJpubwnc/KovHqjgBf489SoiMIzrln/g8JHk3Yo+Pgvtawf+DDDfBPSkYssUaOfjqduhPH7jheVNRjf+LGFmUnhz8NXJ6MzCwat8gaimlHMknhVtRSP6hpSrp0WxbIiXAvAOyuXfuLA4K/7SvnyY/mjrDOxE2PSw3YuCsfExAyIbcWnYP0k7+y44UJIEC049r8THsRaSdd5YHnf9xIjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBuEIgLY6/KqoX4NxB46slkiVwwTMHvRbcdcW8VLcqY=;
 b=OUrusUHD4U40/etXE1ybPl2Dc5vDCHy3izIBJK31Nuz0iYN4a+10/x2o/5BkrvtOKg6wxB3aUx5Z5xAE5YBvnf2Vxkfuct3nkMnQAx3o3NQEZwXkB+asvcqzcPWDxxnC6r2ox1Jpp8Ah0SAslMUVHyoqxsjVya+Do9X9Hg2YQcnldIz09LvHejSXjICuS8Hrqc3Unt9oPNrls5buKpvFiNrsp53DwwyfBy6GU8/GF5ow7ZcQ8F8fnic+Uc/uUnuRh1of+IoTA+O5UqTThfQia+4KNOewmqd7EV1Hiljzbc5xgBBOA3JVrawCMFABxB53s5DmPKOr1muYkO+yH51omg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBuEIgLY6/KqoX4NxB46slkiVwwTMHvRbcdcW8VLcqY=;
 b=YvPIBmEuMEqVPmBFaBRaiyxIVKmbbZB2lMfb/ae8FGhNmJ7e3k7U9Jx8LfcCdZLVYPhIRwN4n6vByf0tNqGuf3wGyZ74G5JZMgqfzyJDeo+PVqLxYXe+ZaqNNgJjyz370X1gpKqDuDdH3agLIvQfK5GFvxxacX84kJ7pRvkUH8U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
 by PA4PR04MB9293.eurprd04.prod.outlook.com (2603:10a6:102:2a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 17:22:43 +0000
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::d590:6d9a:9f14:95b9]) by DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::d590:6d9a:9f14:95b9%8]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 17:22:43 +0000
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
Subject: [PATCH v13 0/4] Add support for NXP bluetooth chipsets
Date:   Thu, 16 Mar 2023 22:52:10 +0530
Message-Id: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG3P274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::19)
 To DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8600:EE_|PA4PR04MB9293:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cde76ea-befe-407f-e627-08db26430d08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F1WpSVBA4euVRQcEt3iSyRreo/8sFYLKojMFFUOqU2X06x0BQM1NQ8eqhcuk8Q5GpjglWgyWturEMSli7JPoPU+XohDp9jpE3vSBgxxwi0J3DEaE+29uQ1zR1MngCSkJTJEoXewDXvh8HQ5xQhFVh+OsoG/8mi51mWm5GWlQSdcW2K9eTxzogxw1IuHcor0y7fgSZWJPtQ++3mZyuWX9UOIMDLuCljyFf8cSsBVLpHmIZeuWaTizLb9zt4gNNspsfCNmkTNDr4r7VyCoXQR0owCLY3+UnE9/OtfrZtRlXRNW5y45eyZALWYi9kWbHiDAmF7v1cA9fErOVIuObhio4VM84P1hYlSf6z5tIK+wUd+gszA3l2fnCjj8gn1C/zWJckG7GHYm9QGSG1jHWed0jQiEs3V1rtJykEfeSxUjztsakaNnEu0z3bCPMIqH1keLvpOLHVfRYwUVRh3kV6rCHeYy543Uzso6VxxiLd9GBkXDuQDAY6wDXdss2bLmUDscX5bAMK2t4CQhcwnmsYcXIPLz6272CGfVWAUcKw12Mjb7faf4YPR9xON6B+lmzFQbzVbgjtghkWytOdDh5Xacdu+GjYmCk+EUqHM/FaEBgwiodijI1jvZhnJ5NEMptR5y+ycFHSd1jrUy4+oHqdnldKnBVy1u/+fbCveECh58Z9FR8TcwP+yj7wEuiehFrxa+GmuFU40OAuCnbuFARl5/raormPIixV86aiUcV4CKyIs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(6486002)(52116002)(6512007)(6506007)(1076003)(478600001)(26005)(83380400001)(2616005)(6666004)(66476007)(66946007)(316002)(186003)(66556008)(2906002)(41300700001)(4326008)(8936002)(5660300002)(8676002)(7416002)(38350700002)(38100700002)(921005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjNBR0ZiSE0xdkRTY2ZWSFFETUcwVjZaYXJ5b25ocTZ6MEl5ejN0VXBmazVH?=
 =?utf-8?B?QXJnUDdic1lLUUJ2R1U2TzdvRnZ4cUthSGdrSnRMOG1ZTlV6QjNQbTdoWkU1?=
 =?utf-8?B?alcwK3k2OWhiVmdlWDZWMGZncG1IRmFRVm4rYWRPdXVyRUY4ZU0ycUJIUkY2?=
 =?utf-8?B?b3pwQlM4M3lWWkpNWWJnWkJmVDREZEpHTGNITTYyZDhFTlVmSUY3RFY1QVpm?=
 =?utf-8?B?L3R1UzFMNHBHVmVtK3cwMURSQ0VGZzNycHJHeU5GYi85VnhWMXJMYUxvU2J2?=
 =?utf-8?B?WCtkd1l5SUNTbkI3dncvYkF4bnFFVk5oZUpBWGpXTUFzejlsa2lIaW9CN3pw?=
 =?utf-8?B?S1A5eW40SldrOVprS2Erc1c3SVZwUXdTWEJ3a3czNmlLcTlwOWlST2VjVG5H?=
 =?utf-8?B?R1FSdVJ1cllHcmFoaTQyS1EwTXJPOStDcXp6SkVaTTZiaFhlcm9qR0hBQ2ZX?=
 =?utf-8?B?UUJlck94ZEVvazBZVER1YnlDWEt2ZnNJSzZsbzdXaFlMdm4wQVUrQXpMT0lK?=
 =?utf-8?B?QzdYdWUvQnpPeXIvN1FlSjhzRFpObDZBZkVaZHVicEg5RWtLcGcwUUdFNUd0?=
 =?utf-8?B?L3RDMDVRSHZHLzVYbTlBNmJ0d3pXdWpSNXhMMXNEbUplZ3NuYzRzR0IxOVpn?=
 =?utf-8?B?SisyOUc3RzJGWmNsZlkvaGlTTGU5czdVRFJGcGhzV1MyRGR1L2J5OEhlMW1u?=
 =?utf-8?B?VG5iSkF1aEl0bHBNckNxWlFxNk1CMUg0K29sZmpScFFjMkZJZGtQTDBzdzdt?=
 =?utf-8?B?TytpNmZzTExVQkRsRkVJaXVKbmo3dml5SkI5ck92amE4V2Q5ZVVqUFU3MmJP?=
 =?utf-8?B?K0xqNjFYOHJERDFlaEpodGpZUWk3NC96VUxWS0tRazVudTA0OUU2clBNZG9h?=
 =?utf-8?B?TDNvWjlYbGtwKzlMMmJKYTNTZjRkNWp1a2FEWDQ2SldIV0dHdUhIS21vWDhG?=
 =?utf-8?B?ck1rYi9VZk5hcFlDNlk3Y2NuaC9QeFFtWXgzSWJQQUlzOEJWaEVKUmtEbS9k?=
 =?utf-8?B?bDRCdHNUR3JFQkRCZUtCSGhpbmEvYkJDemVZTFM5MkI2T0ZUL3Vwa2taRDNp?=
 =?utf-8?B?TG45VWZ2cWIzSndleG5nelJMTFdRSVZvVkhlOEFDZmVBVEVldmFRelpaSWh4?=
 =?utf-8?B?WGYvKzhiNEZHMEtIOXVzQkZFVmpUZllzTTJxVDBOS2RGL2tNM1VYNDN5dnlX?=
 =?utf-8?B?a0dyUEZsVVphaVpuVExPQTVhSlZKUDBiQkNLZ3dSdCtlUVVqdjdheSs5eGZs?=
 =?utf-8?B?aENGQ3NDY3EyTkgrYVlCcE9jRmtsMitLZitXSmJIQVc5NmRhQk1jNVIveWRw?=
 =?utf-8?B?NEJJMnhtOTBhR0tHb3pIa1hXYmFXQk0wVWI3N1cyQitWcEZLdzZnNERIWHZ3?=
 =?utf-8?B?ZVR0UElBd2hPcy9nRC81K0k0aEduM2ptTktMQ3ByektzSjRCSTYxRGo0TEFL?=
 =?utf-8?B?S3ZTRTNwZm5MeWVwcVFIeEtxTHllM1dTOEpvT2ZpZDhzRzlPZU1lOEJxVkpu?=
 =?utf-8?B?U0ZZVjRTY1BXVDZWN0tST1ViTFE3amR5WFc5eWF2aFlwWGV5NTgxVHNxWk53?=
 =?utf-8?B?QmVZU2ROL3Y3Rm5JUHZyRUhjeFRrU1o5T0pQM2VrQ0NXZ2N6TmRDdkZnQW1V?=
 =?utf-8?B?K3VaZ0F3VTNYSWFlMEZOcjFIUEcxWGFEOHI0OGo0Y3pNYldwUWF3U1RuOXY1?=
 =?utf-8?B?RWVUV2txMUxXRTFEUDNCbVJ6OGMxOWwvbFJKa3pJcnluai9ZalZ6K2xCN2di?=
 =?utf-8?B?TXpBaU5GNWRkczl4MGphTnIvY3laVmxyYmJlcnJWYlJZOHNkNGg3dTZHbzJv?=
 =?utf-8?B?ZWtzTjNTbWk4YnBnaTVBRmFZU21INHlyeTRWZnc5Y2h1cVUwc2tmUkQ5cDh1?=
 =?utf-8?B?dTNVUkxGMlNQMkxabUJFQmEydHlaUmd4UU95VUNvZkdJSDNVSGF4b3NDeFdy?=
 =?utf-8?B?SFU4Mm5XTXV3QW5mNUJhUnJDN0VYSU9tK1R4dFF3TXRpVk96Q3ozTmlJQUxD?=
 =?utf-8?B?V1M2NktPaDJGTnZiNWRnWG81dXZJTjliSllUSXBWUlBBNlkxemU0Vi9BN3lz?=
 =?utf-8?B?elpwOXdEQXAyTFc3a3gvSS95WUlJNlN2cnM3RG93eUVuOWdXRFk2MkRZZ3hw?=
 =?utf-8?B?bjVOendQOHRlRVVKTHFWTjhtS0FYajJPeTlEQ1Rzam1GNTZIcmtuNVBaUWMv?=
 =?utf-8?B?Smc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cde76ea-befe-407f-e627-08db26430d08
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 17:22:43.0313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWBFNo3qe7+kuoQC2NeAnSwro9O5Y9CDVzJnMySEuVsQ72FoCAC7XIkTGdijRqT0lD33M47lhwk8WEfmiEzpCLFmRuoXwl1kjb7noTC/yW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9293
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

Neeraj Sanjay Kale (4):
  serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
  serdev: Add method to assert break signal over tty UART port
  dt-bindings: net: bluetooth: Add NXP bluetooth support
  Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets

 .../net/bluetooth/nxp,88w8987-bt.yaml         |   45 +
 MAINTAINERS                                   |    7 +
 drivers/bluetooth/Kconfig                     |   12 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/btnxpuart.c                 | 1297 +++++++++++++++++
 drivers/tty/serdev/core.c                     |   17 +-
 drivers/tty/serdev/serdev-ttyport.c           |   16 +-
 include/linux/serdev.h                        |   10 +-
 8 files changed, 1398 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c

-- 
2.34.1

