Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8493F3A95C2
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhFPJRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:17:30 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:29309
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231354AbhFPJR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 05:17:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrmCLYzm61vNC35aoKX1CojSoA94v9g1acC+tLfdspu1Zfa5x+xQwoNw6u37e/5hPipPYTLRMQ+e2bb+q+oPYB2xejBRlrw6/ClHHYMN+ohchC4tBeC489a9He4hEYjX0EBAE0tuTTp16Wvo0E3NhfFTCpVUnV02ZsyxdbmWAHkBzYitlQ5hsQteipiJO4uT7xPeQ7BThXmUU78cv9c96epxGQGSZWcGOPbt00+TWLgr9N8A9/qJhNrYq/LDHuDWyzgj4iVOIF5XP9w4lb/eH9AKKnJe+X+StPvi7E3U78wybWA1lQFDER51Emv6oRgIG4dutrWcPzT5x1hYxVIgDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koSalmUIzp3Nuxo4ISW1iIawmNUN77GnyMkcrEMCmUM=;
 b=lkke+HVk3j1O6EgPqs8lmcRxFrZhiOA3wh/pyBiGI9Ue7KEO7J8WcSlpEUq0r8mpY7Ay6eedbFdE9YXSnBBoTqg3soUuwK96iCsipfu7C6W0vy4zSzFdcdUm/OsDAFSrs4h9tz+g7GP45Z3VuG3Ol8KHh/yiCVItGqzGucT+xPjrwgXCMiynfMQTq7MxNZ1JpU/dERG/xFoQj3TiFAZtPGBe7pfNsAy5uyKtJ/6Vmx6vgF0N/mPjBpQW+T1kJ7wyPPLFygPUu+/6SiNI/+jdQmfg+YlfS9kDflidgYjavxu3Oyz+87bV1BulGr3yFmhu8TofDF6h8M1PQEgjgVp2GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koSalmUIzp3Nuxo4ISW1iIawmNUN77GnyMkcrEMCmUM=;
 b=W6RyM5F04rjRYT7YFWDT8hiQMIbjmFGsf88EaQdGEQFMvkf5PXJcta01s4WkgH8dceELdLmerdE/Gm6h6x2GD5JXIdvcYPYmSazLQRY33ZtoPittlIMrdW1Nqc+HmgYwZv0Lg+YXcVSkxu2HPWHB6k6U1KXaTkfc6zXJqI3MvV4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VI1PR04MB4735.eurprd04.prod.outlook.com (2603:10a6:803:53::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 16 Jun
 2021 09:15:19 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::d48b:48ed:c060:78de]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::d48b:48ed:c060:78de%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 09:15:19 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com
Subject: [PATCH net 0/2] net: fixes for fec ptp
Date:   Wed, 16 Jun 2021 17:14:24 +0800
Message-Id: <20210616091426.13694-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0081.apcprd02.prod.outlook.com
 (2603:1096:4:90::21) To VI1PR04MB6800.eurprd04.prod.outlook.com
 (2603:10a6:803:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0081.apcprd02.prod.outlook.com (2603:1096:4:90::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 09:15:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72880660-4b70-4a43-c771-08d930a7431d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4735D1D4D47BACD173F5F893E60F9@VI1PR04MB4735.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D1gl64jg+5iXu51gKN2iby2UU025sVwy7tWpdPfAvWVaHCN+5DzqZMVd5qHw/5ypptQVzUzgj7eryWiaHghaaj9fmUI/MB/2zzWVYTpr8R0Wwtq6vFc2Qf0wy4rFyVFGYiK2rb8ACK/G+jhcqV8crDK1Uxz9VF6VLCDEWduVD1eVrhyOSWlQwagZwoW2s+Ll57FF7NZKOtkIYijSGlccxfWtMi2reZiuZ36jOQJicZH2X7IovpJ2VToThTCTihqInI5mUvH6btkPSY7kNMZ/ANNb18AjiGvpnL/BGwz9FvuyABuTdMMego3cZlbc36yJDg/nG7eCMsNI42Ha20edIUh+hAr1yWOuCEVbTSt/FxH/8kSNbXyOTA+Go5AIFUhmYeYLuYt41k9X9kmuyR4B9zyU1klX39zbc3f16nu7ZCNk89PGZ8C0ANuwXniQHUWBDo4zdlnTcGvqZb+ZIaLHK+pN59R6vPWIudKj+zvHWP1hPEO0EnY6hE2ATPWTYrjhqGRTZ+9izvPHlw/eX4BmrWhD7GDGs3mQeGMKy7LwHEQFHXkVN0hdojFp2wFVe8q0DEpeAJpICtGHh88TNMgnTbVOSfuM6622Sbea7wFM13OeQYkVxQFtY9WJtMsmnKsc7UvvDJxvqlcz/ET5BXGw2MQytgDjLu2tUf6Ho/A2q5pvJlpDbroHIaBXDtSOvQzY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(2906002)(36756003)(1076003)(186003)(38100700002)(26005)(83380400001)(16526019)(6666004)(6512007)(8936002)(38350700002)(6506007)(66476007)(956004)(6486002)(86362001)(2616005)(558084003)(5660300002)(8676002)(4326008)(316002)(7416002)(66946007)(478600001)(66556008)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MMubpv7wjfIBRQq680itk25AzGPYCU7LVzoHls98/v/N9Dq5DFSg6Y9KfYRO?=
 =?us-ascii?Q?6HWiV7ddgF9L43a+bPYeMHXug91BarAX60Ia6t93URXcKdnL6GDHaNLJLwn3?=
 =?us-ascii?Q?8GKLkeQmMBbzzal+YuJyBPvh5QHIOdAtUv2nU55xV1EK0imLwBNk5q2QqsXf?=
 =?us-ascii?Q?PQl7hJh01X001uD9aTMqih53ztXopqY/VRziQWqIs9mUzF4uR5HBEmazG5HS?=
 =?us-ascii?Q?IUyGvwjLo5+ODNGkswPPZTInBr51DkqlQ52473mz+Mx1TOD26Kz8XZrJ0Oax?=
 =?us-ascii?Q?rV1n2IsVHaiHoLNTQqkS1XZn2QiHZY1a90C+ylOTT6AMgDTiHQXcYQWAiJGz?=
 =?us-ascii?Q?RtRpTXToBzSn6wG/db80eniLhrSMJjiwSvECMPqpWVOw6Ru+3dbGgv8rtL5a?=
 =?us-ascii?Q?hsx/6dt/S7O/LGymuxVdmW2pvVNm7fnzIbOMlV2KLWhoeN4K/fjIFd2ewCHX?=
 =?us-ascii?Q?WqtTUmLhkImrC5+S+e1jHEwpWCZIn0oV91ghQi8QMtroJsCTPaEYlDcV17F7?=
 =?us-ascii?Q?GzvTG1aCKS5MsBDf+CNxTc7wbFibUZ6BTy4p34pxnDgoHEzPA5N9gFoByP5V?=
 =?us-ascii?Q?g8Ki4i1WJ/bw2CeQP7eFrHluBsP5Fk+Ymzjlp5n8n+tqjVsxKH2fmEI2Nxru?=
 =?us-ascii?Q?1ck494tmWHExzcAOAKLLWbaWdxUURXFLzK4G0gCID1G4Va1gqNLFJaZ7QL/u?=
 =?us-ascii?Q?XGYHVBtM4Ze6qw2o2H3mhFbRvMOTnbKMh5qoPpHNHXNdWqih88vDVhZEssBy?=
 =?us-ascii?Q?FCqDRBYkbdgdZEo8JCEosfOSL1Quhd4RJSobiAB7F1wJkNWJuRgmJXOmuA0V?=
 =?us-ascii?Q?M8M47qHD9Mz4e53WUEAoE1NZNpp5aIVz4iq+tnYBU9+pnMnqy1nEcvPk3s1x?=
 =?us-ascii?Q?KTYISHSKgG1xytBRQTBD8VxKs6owNT2nzvN2xV6jr9e17+jIKmWdjEEL+kQC?=
 =?us-ascii?Q?A73qjRWHcKG+3lnWEMiSJ7ZZ4Qu4/dRN2mxjiowGfAETSc8EzMm5GJuV1jNP?=
 =?us-ascii?Q?+Is+yjp2VGv0+SJEpo+83NT23egE5DLBacv3TwfbbwIGEipQRBQ/qRBAiZ1u?=
 =?us-ascii?Q?YiGLhbsotSYfJxOPzbhGttMOuIusYV3entwc3pZaA0x013Qd/eEeCCjtjkLM?=
 =?us-ascii?Q?6xmFgFl85TavGaM6+Cffdog3RG0/ddJvTDQxeJEtuYci+N80ozQ2N9tT3LBc?=
 =?us-ascii?Q?YXB3uDw4ueXqdz66ntCTjCBbRN5lP9/bQx2W+THI9BKCMTrvr6O1N8uZmSYn?=
 =?us-ascii?Q?I0+A0Tq3Fh8RiHlYP+SfHh3NQNUAhiDwFwpq55q6dtsYW9Xe6H7cfv5zTPe0?=
 =?us-ascii?Q?cRG4zr1B804f816PlnS6MVff?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72880660-4b70-4a43-c771-08d930a7431d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 09:15:19.6409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ao3uytf1s615Jg6nJeQ5owwVH9BZqVuhQKfPik2juAv/RCuC0D/yghL5c47q6G66kBd7MFwu5+N1SUXXSo6Okg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4735
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small fixes for fec ptp.

Fugang Duan (1):
  net: fec_ptp: add clock rate zero check

Joakim Zhang (1):
  net: fec_ptp: fix issue caused by refactor the fec_devtype

 drivers/net/ethernet/freescale/fec_ptp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

-- 
2.17.1

