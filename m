Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117CC694905
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 15:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjBMOzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 09:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjBMOzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 09:55:15 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2062.outbound.protection.outlook.com [40.107.6.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32660B756;
        Mon, 13 Feb 2023 06:55:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKuiCRP3SMfI7PrVxXksz6R6yX2hhUNP9H1pRXMNd3OrBBIF4CzL57n/XskDwDUM/k7FAbZOLygBxo3LshgbnipNjU64PuCIzvgfp4S4M750ful4K1DaEgws2qcBr407k2t+52mbtl9nfFAyKkvX3klj4oKYbXwuLizj55Gl3phioObroNW6RDxB10sbYdC+x5UJQKR4SjMSDKuJrbJ9S2QZz2RC5yUu1F2nYXVpNrxLef/GgYzjyCz5ZZ975oF7CPaXnz1r7Sz0E7MXCzxcg9hFbZAx63f70fBWvkHXWggSHMABTpERmgnZHCuowhWDfR9/BJMVAJCzsvGXRup2pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFfOY0znxpgP//5eX7kbtTfwa7otG1K1fnvii7amyW8=;
 b=hgF+r1mIo+Cx1662Ya8/l+rmheRTDvJRk7QbJirX2j2i08JV8i3OsK4gx1o5jJzkjMwG4eWGjh+/5DZEKxlHSmurIp2nkKARUfytq0yfFbAEtcgCqHyNdtZEU6cYUNmEe1Qhlc3zOe4PJYxJblcLUS+Jdnj6etnDCZC6NbnStfDKfcHEct4PtOf4vu1mFFY2puF1oDB8Iey3zAC2e022PPLT3r4mFjLDF9/XcizeUBudt0vGpDqRyAFnSasl96FUA+R0p5el7WRPjtSnDM77Ob99k84rEgNtCFSP/ZqeEbo4q1BW50pj2aQZtwr8G2RuPXkxGk9BOMg3hspgIkcLrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFfOY0znxpgP//5eX7kbtTfwa7otG1K1fnvii7amyW8=;
 b=f90Dn6hlildjsMQK5OHK38T6rGcGjC/6Byx8aMeFYNAbGv+uWCYrjHBhSP6HOlt+jlYSIi++5UHPPZphwc6vjKM36i26KiBZN21gW6XwhX2tG6jfoEyT2euOpW6ZyImTnUrtYqxz8LO+X7XS21Bkrb72mQDAMuFIqbd/6eF2AkI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM9PR04MB7523.eurprd04.prod.outlook.com (2603:10a6:20b:2d6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 14:55:10 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 14:55:09 +0000
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
Subject: [PATCH v3 0/3] Add support for NXP bluetooth chipsets
Date:   Mon, 13 Feb 2023 20:24:29 +0530
Message-Id: <20230213145432.1192911-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0156.eurprd05.prod.outlook.com
 (2603:10a6:207:3::34) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|AM9PR04MB7523:EE_
X-MS-Office365-Filtering-Correlation-Id: 343dc611-c994-42b6-b3f6-08db0dd24d64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L10Wzj0hihB3y/zEml1QpK070QPEHJL4uFcNLMDVl+VXYI0QnYIc6wEBPhAijUmHrQwwU+zevZL9ni93yocMmJuYRVOQwuM7yFQ/E8hz920cDhDZCRcbmTZiSNcFUtPKDc7Lm5W0bYyGYF4cOnCFg9sl+n2ZWnRmiMj9+kPNH37RrS3P+1rNjMEA4Jf/nBUUuDUqE/u1ct64lg1oOv1lEM8NYQY88fq1r/0mME80PP0Rr0vW2qdwCnST2ZGnHofwKtTpmaKSd5fTEPH9G4k0zwBFa5HkktqMS1Tyx2jpauAfdHKF777MqODEDwZ7/HsJQdjYeJ6jjkPZ7WuI+2TEQ/ZLIkTtC/w9XvoXLl7+fQ3mp9uHtpZDjhSZbNO1uVulNqLG5xGJ3QbzPEdDA1yckb+ZEIZoLUYluetYOUZksAZqdSsd/GfwxE1uI1FUEaekjdG0PhoHVKhyrrgOB9lR2vDlwUz+iGpowSc9URJ+4ZAvRhSnBvw8Chb88+0usz90BFwhsGUUeNTNtxsQrTS0ehYsDvRWzla5kVDt9A+jIrlVRWwKR03nuReT74gYhF8RgA3o4SPXN1jqYh1PbhEzayyYEntJCo2GtdwtvPSO8r8KA99w0OhS5JUHaHZnqyNgkuxNEQin5hUFD1FcRREYMnirQwDuXEM5Qwk5O8imrOhe+W/IMOI90kieFeLWg7X9LPbW1b5SZR5plRvU4dblQQFHL/GnzhrUW5/zN9UW4DQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199018)(478600001)(2616005)(6666004)(6486002)(52116002)(1076003)(6506007)(186003)(316002)(6512007)(26005)(66556008)(66946007)(83380400001)(66476007)(4326008)(8676002)(41300700001)(7416002)(5660300002)(921005)(8936002)(36756003)(2906002)(38350700002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iit2TQi2KSiRMdP4KxDfi2K1zo0Pg2dOkH01CmpKhKsPfOg8oozKMSdiZld/?=
 =?us-ascii?Q?5l44T1k7jj85e0lD0nklVXNP0KDG6xWrQFh4boJIYIa6Ag2ORuJmq8d7Dzug?=
 =?us-ascii?Q?JRTbhbF4yZGzBAQTMvd8xte9ErYvf89qD0UYms6FLnxgooRPExfcU+CPyoc4?=
 =?us-ascii?Q?HWnv/fVD/iN3WqpyTRQ97N+128ldj20zpYeSC0o3SGUsUbck1heRowzH+qK6?=
 =?us-ascii?Q?SJlWS7F+OTPEXiJulPfxZoKjTFmLI8yy9iTzqrYpQnqzIWrjTOr7feZUITsC?=
 =?us-ascii?Q?144oQKlmNj+8HjUk1X8CGmWPlU2y5keq5Ra+XC6tsNXDnESN8CyB7Mrn03Km?=
 =?us-ascii?Q?MpVSMl8X30POl0MUDn0Mhp7yhrl9/sKHqta1qkr0Pbq2SD8J6fgMoGrnRi40?=
 =?us-ascii?Q?mCe1NDRBMsh5rPKfPLo55/EebC2uodz7XYIiwszflTjkg4M3SncAhzC2yQ0E?=
 =?us-ascii?Q?vmCfj7Ui39U8GL4zRI40+ASMuFUNCTsnpg/rHH2xwF3PGlnmuYZc6FBcQfei?=
 =?us-ascii?Q?bNXoptrI+EiP59UCMq1ouzD+L3sx3YP5V5vd55BeSOD7F9Thh/AnfOV9//2E?=
 =?us-ascii?Q?kAdnIWMBADpjzOt7l80MWhMopJHdAcpt7cXTKpLiWRa8tAv1T6843UmRUqk1?=
 =?us-ascii?Q?SnlMg5J1br/bJ3iYPNmwIdKRX+6/CbONSbNOTVx0afPKotswz9Hig4DMUu3s?=
 =?us-ascii?Q?q7dWxWW5zOKIlTmZIJyn8sTgaQhnAp9ZAgNjvgOYH5ZH6wujfEihQ6UnrZEa?=
 =?us-ascii?Q?IFZ1zYb35Ks6zaPJbExXkNKepGpfJ143idM4nGfgAOPoQIbGKl+J3eHYo3v9?=
 =?us-ascii?Q?tXlJ4HoekGCOWU8HpCU4YEG0wt2N+EJHbGJu3ARTztzWAUuy0qhJyPRWukwh?=
 =?us-ascii?Q?P0ZMsoxpTDUrhrh9CXxRAmrxvJmEy/aYdq18M96rOoTThgaov1Y03VGQbVAR?=
 =?us-ascii?Q?C1Tk0ly8WJv0Tec5dsAwPBKa+z/rwrIQUELcHorrVdnAd09m0y86wM65OHJ6?=
 =?us-ascii?Q?eA+v1xVy2El8ttLlut+lhVR6S4pAVjpcXp2LU/3PPVeFxgl6qvL8kXS/Fb4c?=
 =?us-ascii?Q?hWRU9LPjgHa3zYvbuhnTw1vjknSYbUdOxK+y+2DfrsSteycHuAB5AEVt18+d?=
 =?us-ascii?Q?0OrKXEHq0UAEtYSvwvI4v7UvYjkticQXbI79HMR9V2GD0Y3GeNA6CwMJPsAc?=
 =?us-ascii?Q?aA5T6nGvy1p3wJl5ooO36IWUZE9g1xM5cfWpiVmNH1DaEjccODzzHbxDD9xS?=
 =?us-ascii?Q?JQYqGNM7SFcAHUReX84gaRpXx7ceDnIilPrPzwaCIzXAk0DqvlIv/jhWKImY?=
 =?us-ascii?Q?c17A7/V5Kx3PUkQ80AYLDLIqwXqlSvR0f3Jq18aiPUHX22lpFmD2yzVmfZH2?=
 =?us-ascii?Q?dXwFTpbHkEc1fnHWrjn5tVHTsCJUH1Nk8bSXmTOd5P5bao1OLSYD0VRF3XX6?=
 =?us-ascii?Q?SzvDF9WAyO5wrfd7bjSbjajXi8GPBPeZranGXRLFrhu2rVTrje16su1F6Wpw?=
 =?us-ascii?Q?WRCbF7/VYqmBgjycZz7cVogus2xcBkGSD27tpjCaJ+UY5L6uIPSTDvaWcQrf?=
 =?us-ascii?Q?l7vfghcTvD3t7qJTjHtReQ20YA/7d4KFVgUN8Tbnf0uKOXiTYqs0r8Oy7PS3?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 343dc611-c994-42b6-b3f6-08db0dd24d64
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 14:55:09.8295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5wyv2JzmSe7Hk8NMDp606geVbjjnEQfQpDbTrrOrVC3uu7NzNtOmgb/an5MRbU/bbDq9QLuVmJLpdF5Szs25t5t3kUBf6JERHt/03lREuqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7523
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a driver for NXP bluetooth chipsets.

The driver is based on H4 protocol, and uses serdev APIs. It supports
host to chip power save feature, which is signalled by the host by
asserting break over UART TX lines, to put the chip into sleep state.

To support this feature, break_ctl has also been added to serdev-tty
along with a new serdev API serdev_device_break_ctl().

This driver is capable of downloading firmware into the chip over UART.

The document specifying device tree bindings for this driver is also
included in this patch series.

Neeraj Sanjay Kale (3):
  serdev: Add method to assert break signal over tty UART port
  dt-bindings: net: bluetooth: Add NXP bluetooth support
  Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets

 .../bindings/net/bluetooth/nxp,w8xxx-bt.yaml  |   44 +
 MAINTAINERS                                   |    7 +
 drivers/bluetooth/Kconfig                     |   11 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/btnxpuart.c                 | 1370 +++++++++++++++++
 drivers/tty/serdev/core.c                     |   11 +
 drivers/tty/serdev/serdev-ttyport.c           |   12 +
 include/linux/serdev.h                        |    6 +
 8 files changed, 1462 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,w8xxx-bt.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c

-- 
2.34.1

