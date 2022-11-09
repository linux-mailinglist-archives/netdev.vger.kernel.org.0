Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B3D623682
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbiKIWZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiKIWZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:25:38 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2135.outbound.protection.outlook.com [40.107.22.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E85140C1;
        Wed,  9 Nov 2022 14:25:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwsQqm8+DbWFq/I47aDZy4Z1fZfG0e3FhB2aSdcKEuT8YZPg2ag9c/mW6bmrpBXvVi/CJBznfI0T8asHZlSxtzIVLNzkhfVBi0YFWIkvYnuo3guYZQvcaRWYBitxvHyM7Yqg01RJjjnR3eU8m6Qsz0kYdWrgMrgzfQ4652ZIFs9AEdVlZf7WVJW7D1mHRx3qIEFCvscpn5yCXyunVqjMdmgKm9Buu1z2GRH5FCfULvNKfQ+xXmkGfdqa2hlUj+f2ECuVOlvlT33VrVQ0TJu6ttXbOpZWAQ0QbZp5iDE+65/OIYvlH6B4/BT6UYGkBCRForeIiomfxKYWgZLvPTt5ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=on+3Lq8JAA1jiQkyNHR+jouBdQrWOoWAUjq6Tlc637Y=;
 b=hnx5mL6jdFJui6+sKaNnFo0WsQJbWc415rq1up9i0PWCgdF/scQUNChi4cdbv+FS5w2D+OqMaM/nTRZMw36813/5BD+yjXV2J+K9gQk4KJzmTflTvVSuiHorIEM+dUVl+92xV8l3Du5fgF64BIEWX533OOaA2ItHh8rDD0D0hF02C5HWIhDkXhyTCQPUUNn2PkfEF0H0vopWS1176qDDEa3Vq4O+x01qiMyaTkcFY4i2Wc94EOGoImgZivGAN/tkUFDY82Xz2+YjAjva0ZJd0eznMyMe04NfVjtzGgaaXhnpcjYMs2nVHeFA3OwYBWlzDjxM+YLL0UxY/xvoJmHUig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=on+3Lq8JAA1jiQkyNHR+jouBdQrWOoWAUjq6Tlc637Y=;
 b=Hmlqj3T4KkvrKIfHLerczUs85DEWrfZHcJUEq33Xcs/7BqWSLyy3DucX74lXlGSYgnaUKeO5Y6lUX+NCYXqdeWTJuFJGkYc9oVu/usnQd1aqJqS9RK1gKzKT2siZTP1qH9URStmpeZAOWIjyFgXorvcYBmJ7KqTeabbzm8LZV2k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DBAP190MB0950.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 22:25:34 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::4162:747a:1be7:da87]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::4162:747a:1be7:da87%4]) with mapi id 15.20.5791.022; Wed, 9 Nov 2022
 22:25:34 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, edumazet@google.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        maksym.glubokiy@plvision.eu, vadym.kochan@plvision.eu,
        tchornyi@marvell.com, mickeyr@marvell.com,
        oleksandr.mazur@plvision.eu
Subject: [PATCH 0/3] net: marvell: prestera: pci: add support for AC5X family devices
Date:   Thu, 10 Nov 2022 00:25:19 +0200
Message-Id: <20221109222522.14554-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::18) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1P190MB2019:EE_|DBAP190MB0950:EE_
X-MS-Office365-Filtering-Correlation-Id: 95c769ec-2e99-4422-04a1-08dac2a151ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vQMapXkS1m9CRxEWhYU74BlhAe+ZzyebaTV7vRCAMBiTntukmgFB/fai0dPTcX1UC2qQ6a3IXtkyqsfYWvM4tgH7XHKze8IQqqNWEF+X19DsjHppwIeiNdJGeIwENFfs/pmDeKv41YAI01sCEhr+U1IR3fX14kxDQ915KF7HP+a8+NnoF2eUZFZWGqUrhVwQfpISPm7zib5yfQSDokbRrRQkpqrywP3QqIZZpYveWqll6AkHxIkNXEvU4UpCP7T8HbQPEK9POZpR8awvFy2RwawR/HSyNhbNvBDJ105J2hVNHeGEEPeLMFGNyn+wrW6ahVF2aWw6+WyAjmQhHuaCdm90HiV3wkFXFxyXmUJbU8HznbLg1ln2tQvKnvJXF8SiAViy/8rWZw82EORZ01QMRoJ/OUFlrvWj9rWoPKyHMMm/9IWSVEOXt8rn/vgk0GSZVy805B028Rxk9kkEXCYqcRrmOd1WaUkkyrTMOEMCft+bJN8hTrTWCZjB/PjdFJSNXMQqLsGEkjJgl3b9O6Tx+ilbA+rw19Rx6BmWpkzlSrKOuG+PYF9NKTwHbMef0c2QLtGY9egovvXUbjotN4DFJyr+dKGRcFra7tYYpcZLnxOIpsKUqkfjU9PKDr5SN0wAQ+l0vfoztOA9bDJUoXWQddNq1VlJmsnB73EzOWjnA3g1cIw3Ca4rhuS2JdbqlrRmCPxgCtGQbyCWt4BCVFaOcWI1ep+IJQPcA/9ei3hi7IgH2GG7kSMmwOlCnMD6nOGtuCA9JOcs+3NflhuMByBev3Po6mYxdohqVmn8e121D63KtDT7zgKtZl4f+j3xCw9n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39830400003)(34036004)(346002)(376002)(136003)(366004)(451199015)(6486002)(966005)(508600001)(6916009)(41320700001)(6666004)(107886003)(316002)(8676002)(38350700002)(52116002)(66476007)(4326008)(66556008)(66946007)(26005)(38100700002)(6512007)(86362001)(6506007)(8936002)(36756003)(5660300002)(2616005)(186003)(1076003)(83380400001)(44832011)(4744005)(41300700001)(2906002)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SMoUojkLyz4pP8yU+bqCZfBmDW1RYhK8kbRVWlFAWS2VTlZqKtI8G87d9uhc?=
 =?us-ascii?Q?kD8bf8i5c/6j7mJ5hWue22Gu1082QvVlCL48pU177iVz2bR3zQpd8mt6R/Yc?=
 =?us-ascii?Q?QD509L8+BZqjbweQWPIlE/M7dJGjfdyNYkrBErZwzc/NzKHW8cv1gHPiYYck?=
 =?us-ascii?Q?HUF9DBaBwZ3JvZ17KwwhqSN7JmMEngdZtkAzcxitN8PLUnVL+BAimD7TMP9h?=
 =?us-ascii?Q?06ZSn6a5U396IiPKXoh2E5Fe0U4g44YY58ZDTH8G7obsgEohlu/52t91JMyb?=
 =?us-ascii?Q?gNtNt3YoIteJYsXVIV3kpF2ZV4WxumXbxxrx7oBl0ckvLWlz4/uzpQ79U+nu?=
 =?us-ascii?Q?H3BYLg5nM5oDe08D7DZ1yZTfh8767W1Oi+/V9f8x5/liqh1VSsrGGe0nqpa4?=
 =?us-ascii?Q?wK/FkQEFW8n1nI8h/WRPHqtSrZrmfrs+6AdWgT6GM3uLIxUrjssini1aKFKx?=
 =?us-ascii?Q?7DL45/aeiFDIP14AvkyhMwbixDsJJsiGHMmgcZGA4Mz+DzvYdD5yWiYC/fiw?=
 =?us-ascii?Q?hItZrjuY8hx7vZghb/AgRVdQrVOwTQdSMuuYCPK3hsmupDc/cDQOxxhixCdc?=
 =?us-ascii?Q?CRqT9sDZnmUtc7hhBD6utdeKCirqx2KFchhIOZ2bhqx4/+ARF3192tt3B2oT?=
 =?us-ascii?Q?TFf0yJujmKpdl3z4S7d2ABlb0BsP06hUwz4MXtiU/ZrADRVJYMOHNrz6NHHU?=
 =?us-ascii?Q?9R8AJQlxBOPmYqIz2aqTHXya6r8NZtUW1XphgbeBLv5fXuoFO9yrGhAMg2u4?=
 =?us-ascii?Q?EbR39FIC7z5XdJeaXMXXoGHZr7sQW+HPiIa2nOorBgOHCDg4uFME7DGd3xBZ?=
 =?us-ascii?Q?XCBmuaHbaB1IjA2PcIvjZYRm5y7wpARbu8/EB46EAGPkke15n8A19B1Ed/S7?=
 =?us-ascii?Q?H8nnra/IfyCUozIM/YgAa6RHM6+Bj0YNxXR9IwhhoEVOosHWy+z55RZk1pL2?=
 =?us-ascii?Q?EAOuW0oDSfnoOcPXNc2oWh64rh2UDy5dCd78IOnHBMSq6FR+7o5d/5vOwLl0?=
 =?us-ascii?Q?V15tigyqSOQL6ockPpwB8K+XkCV8kDwbCudH3y794PYJu0kvzMPSyGwonRaB?=
 =?us-ascii?Q?9h9WguupGgn9dMNEaYpGRUm+I8i9dfFBuZ8VwrVDBjLwJdvjYw/02oTveM1h?=
 =?us-ascii?Q?jLW4msqBkPCF4mYSgvRIz9JtRnBmVKvjn08MYgNCp5NeyLShp0Gnv2tPgWx4?=
 =?us-ascii?Q?FW66ZARiZGbsOU6q53FzEFIOQ7GqwkGcrXZUA483c5UA9QjmQxCvdg6tQSrB?=
 =?us-ascii?Q?OV2thXTHDt/F4MmRkl8roZiymXV8wEcsjWSQDtUtynxgh8daZf8Vib3Q+Tac?=
 =?us-ascii?Q?ofAYhc2G9c50RNxTMgLaX9B9mA+GXoaxWEgMsH0N0LJv2yMc9EovdXOphqPn?=
 =?us-ascii?Q?um6nMM6BOrGmh3dC227HrQ3zdKm2crRgxvzPDlAZlJ/NYE911stG0WQqCYvu?=
 =?us-ascii?Q?737JWIue5c3hEgHbh29IWoWjuOgqdGWtQ7iPKmW8MB4skXQw6oekzp2VmQD9?=
 =?us-ascii?Q?SQLnCwyZUDVhDKCf3vcSCy9OhIe9ugMvhi7uDwIJF44QkMt/g1IxnCBdjL+q?=
 =?us-ascii?Q?NXA4n7xJ7UGDBrLRGX0rS/YpMLtJalxZ15xM3cHdyqUhblDCBnrfuPeIN/ng?=
 =?us-ascii?Q?1w=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c769ec-2e99-4422-04a1-08dac2a151ab
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:25:34.4687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yRearpBuB83jhHzB+6zpo7BglGxnEHZAoh4GWtFcSAo4+qUGC9lMCstjbfkETliZT1KmPtZmw1c8dB+92ENImzRHmCU2GqtY2djbSHZofgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAP190MB0950
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces a support for AC5X family devices.
AC5X devices utilize arm64 CPUs, and thus require a new FW (arm64-one)
to be loaded. The new FW-image for AC5X devices has been introduces in
the linux-firmware repo under the following commit:

60310c2deb8c ("Merge branch 'prestera-v4.1' of
https://github.com/PLVision/linux-firmware")

Maksym Glubokiy (1):
  net: marvell: prestera: pci: add support for AC5X family devices

Oleksandr Mazur (2):
  net: marvell: prestera: pci: use device-id defines
  net: marvell: prestera: pci: bump supported FW min version

 .../ethernet/marvell/prestera/prestera_pci.c  | 119 +++++++++++++++---
 1 file changed, 105 insertions(+), 14 deletions(-)

-- 
2.17.1

