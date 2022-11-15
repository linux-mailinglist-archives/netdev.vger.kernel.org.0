Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6613562A35E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 21:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238462AbiKOUuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 15:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238306AbiKOUuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 15:50:10 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60075.outbound.protection.outlook.com [40.107.6.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2504C2D1DB;
        Tue, 15 Nov 2022 12:50:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWJ0IvRDtLbHVukaF0k/o0F0NzKAX1aVUw8XeUkthVihUIVDlxwvC0upNS10qdi9TLqRTqh3Sb3KpKIVF7sKRXbWT8EpE4Hh5awNogtmjglardEJbsw9v3mUKI/AjgtjUn6A2WjmncSsY7095eVS+r0ufVYC5ZZ5jT3dSNkaingwp8xEcbkxtDPyCyGbKQiSmTFyzr2zAaRzDCAjrIc/F++3YL7Obqb8OZ1BV5KJzWaAXQ3C9sUkDipmjSdYAFSE9p5c6tSHFJIO4FGZrK69hG/ku98p93w3S56+kBWkzUGEiMwy7EX18QYQy+lUltORnsljogxWhaSZmAMuDJ+inQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/bgvgUHpnHVYwxcYIoGZlKG83XXI2aZHk0axyOY23N8=;
 b=bX1UIUYPx0osUKVWoMEOJmp2YVqaZ/whZsWwwuWbIhvQho+GxkfK/JH9AmouNx2ebw3CuDioVxZDfU9lxS1nACeopK0WLcPjT+AE3TdQpPwDwVCG+T5QYi1MKNwlxEny2JsGV/7YYQfjWXjBcCVVaCd3wx5ntcHJsOjxKDhPQQaxj71w0cAGbnRmWXmBJV9cg7AonX2PcrlvKZzPd41i8H9gKbe8LisXJ2UsjF1iv6+jU8egBfla4YHcIQj6ptWlAVXuB8UO2yv1Y33sL0t3s0RCHMJn23MR3RjSGPgayiV1MvidnkDTSUzML4DQuEKXF9qpt4g0JHJ1hTt4BX3vAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bgvgUHpnHVYwxcYIoGZlKG83XXI2aZHk0axyOY23N8=;
 b=kd4jS/TvuOEPTSdcjtWCcQS2xGrTCn4szzfBZiuo7aMrmmQrzirDU9Wyx3bicBwhuyJj6fxTwxiK8uyznV7A7z/srPgeEffJatUD5EcTju3T4pNuu/R6eYFW0DS6nVNdTgr4qGbeZaPBJOJeSTgS7/aIpiNapg7Wg4kWoJVeih0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DB8PR04MB7129.eurprd04.prod.outlook.com (2603:10a6:10:127::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 20:50:05 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 20:50:05 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v5 0/3] net: fec: add xdp and page pool statistics
Date:   Tue, 15 Nov 2022 14:49:48 -0600
Message-Id: <20221115204951.370217-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0210.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::35) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DB8PR04MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: 66acdb00-6632-4cdb-d649-08dac74af934
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G3jx33ioH1bYBzecEMQgdIguy0McAier46vppxU0jDtcdbSXMQgENwFf0/CXdMu7En4zBw7/XaufmUg1TzNe38090hl9Dn94wH3OSNeqxLgAJxvoWQDgR2GTFtum1jTdQke+ILcdqfUB7HE2EHGSg17DsetVVMzDQrwN38IPkkQJ7wN976Gbjkrsjo78ZjzoyQEkgXlXFMrvYAupW1I9sIDDkcxZ5hNCxEsziSCI3ToOrdvR24ef6Oz4SXnCguzXL3c01QpqZSD+nbumwd9YWD7cb20VzkTA7XYv+Xkr8omc+F9Hv2xEVQ/dHFuvwksaIn4HfIK7PO8HOjF/ADMRotiSeSV0AZti08z/FG594pUyvpS4Nu4RnINY0ATFAXkMrBnsTVjs9RRr1QKJrLRdxaLEVk8YsFRkxfwp+v0Okx4JlTH1+Wa7p/et02RWOf+2ZTeeVl4T6wz/lYDeckZEXGAgJS0em9Q8Lxvv83oidRRYIQVzvAgkHYatx+zuFEl198UKy6meyoTKOL02UxOHLFOW3iyetG36YCLcRZs6WREsNn70oJ9+CcAOhSZo3WF40VTkhiwc1Y3fdSMHGOTP9L0YxlEYQIMlWJWvUOsIP9rTeDQ6yStLmXhRVqoiLXvHjy6NjqMoU0SdHKIpX+3abQHQKn0XPF3+VR1VQMgo3pfPsUAjSacuI9BgOBGbNavB7ViRKQhzh7ThoAttDH58h0KgItMoAW52Bb0p8tXNvP4oiYu9TcILU2Vy9U2cLfALVKnSHvcdWd71Lmd/EZTF6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199015)(66556008)(5660300002)(2616005)(66946007)(66476007)(6486002)(478600001)(86362001)(44832011)(7416002)(186003)(4744005)(110136005)(2906002)(36756003)(8936002)(1076003)(6512007)(6506007)(6666004)(54906003)(316002)(38100700002)(83380400001)(41300700001)(52116002)(55236004)(8676002)(4326008)(38350700002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LO/kYWjBISMMo8vTiMEQWtfVWFbA38/6DZ/CUJlyB+hCFquEPJVKsKJCWUrC?=
 =?us-ascii?Q?DLFKUGilTIjYIfzt4XmLSVEJF5zc/iAhuy5OIIr5AVcRXkJIJRI4jLVbSopC?=
 =?us-ascii?Q?FtRTF7jGJFbvCc6hZlVOZWi+d9cyGT3g+cF2daKiQVIEFLj8TYBmgsALTVkP?=
 =?us-ascii?Q?ccP1K4fRXGXCaiZFO7C2wKHmIBp0FzMKArJiuOCE6AewogylPWVL+DBCBF1w?=
 =?us-ascii?Q?KWRL9qx+1YvvH8ubJp9QCHxlWaBQSxQgYtQFhJQ8ysg9HC4sSTZOd8zuL/E3?=
 =?us-ascii?Q?G5gJZaDZWmecd+m9JDGZSyAOUja7AB+b2naABdKjvPNSrppKFvUyRRxVpxvo?=
 =?us-ascii?Q?9PPSqfx1vjUPZnp5igzVSBlu2dKoA5aMTDINZhNlJbS/PB+unWl5hRlvIhJn?=
 =?us-ascii?Q?bz3pjynCEhq3oTLfB1IAbA/QmU/RSGJAT+KViqksGzTDG8yLtj1WYHiVVyCs?=
 =?us-ascii?Q?ivQJ5Nxsr7pyuPK87QtXSaZT1CtJsZaDRN3TOaGgo22betALOOKwpvScSbyi?=
 =?us-ascii?Q?zDYlw3qLacK0opvxT0QEyroAgpJPls7uzkwYAY//VOuMH/vb7YsvBVkk8j+g?=
 =?us-ascii?Q?NHe8aPYXVBd0DWlj0ZR3irpJeitTFT1G/2AoAsWMjtV0B/NgywHWACgBpRaZ?=
 =?us-ascii?Q?jopIf26133C1yUWKYwZgyD6nY7FB/whtuuhh2Ay7NDKq9tj1KOKAapYgzo9r?=
 =?us-ascii?Q?WuPZYVr9fE9OTRcs/QWKXhNv48+fb3yahhnKN0GHWkHjFEi3rjpnRV4xygD2?=
 =?us-ascii?Q?39fTadBj8pak/VoOnFpBdl8aUcakaeQNVg7oQfDziVViBG2YSw2q9y948Pg5?=
 =?us-ascii?Q?QeCoZtFu3yqrLuvs52wohnCSjBNMzcZoxVbSPz4bQAa9RUHZU3P7yceB1iGx?=
 =?us-ascii?Q?GO+J8BUYzhF1IXUDU6Ce9k3y0tv0FzH086N9IbFYm7DJdPETGD+0kH1WAzXb?=
 =?us-ascii?Q?VBX4W0xkec/7WWk/GPXdGiA+Vk8ly+6vMW3EPIT1VsHQ2f0IANMdtO7ULYPf?=
 =?us-ascii?Q?r62KVyCjWg8LZ271tZrpZhZmZOO7gQvllVa6Av885VGm8LUId42sviV7sNXu?=
 =?us-ascii?Q?BnG94iSR9NKZMQc0C7TG3frizv+gETDspKIijSX+polRH8QPNYj8213GSkA6?=
 =?us-ascii?Q?fiSBCT6ma2vtqR6aMHNpQBKOMbKL1IbSMHoGaj9AYy0fPzne1/MDjiw//4BA?=
 =?us-ascii?Q?+VZuq3OLxJSj38YX8jMwndxqHrMRQLmv0RKNZ6EzJ34SykZTXoJKY7DmtNS3?=
 =?us-ascii?Q?SDDU/ge2XzTqrGnN/FA7wCiSU/SMteK9nib0q9uLoHWlEhzUMAdSBNtcc44i?=
 =?us-ascii?Q?D9Kzwk6QbmdnyaKeQ0rNUo9GF2795aoFb99Pmg4oWbh1XVpbN3Lt4glH14cs?=
 =?us-ascii?Q?AnCNR0dFjW5Sg5CNiWo96bnNaU0oT5zDnmuuE0aOAma/qWJsmHKlKzNs9rHZ?=
 =?us-ascii?Q?eE6njsSkr5CFCb6K31CssGMMapbcGP+232TO+uuYl+PFyT2LvgKo3N92LpOr?=
 =?us-ascii?Q?aAzk5Q3L3cH77vl/ubDEYisK6ZOeOrACrZJha7swRpPIdUIsGNGLnepjcqDB?=
 =?us-ascii?Q?KmnzzjhNWqurkpyzkMVG4pq+kBdvFya9h3eD0aqM?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66acdb00-6632-4cdb-d649-08dac74af934
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 20:50:04.9937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M9GOPovUvrMVzzzmJPA6S9IqgodhYCchxOHnjfLQ7ifK9ZdMEuZa1UDaUXq255fFGJhBHIcdqp4QdvtwsAJNcA==
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

Changes in V5:
 - split the patch into two: one for xdp statistics and one for page
   pool
 - fix the bug to zero xdp_stats array
 - use empty 'page_pool_stats' when CONFIG_PAGE_POOL_STATS is disabled.

Changes in V4:
 - Using u64 to record the XDP statistics
 - Changing strncpy to strscpy
 - Remove the "PAGE_POOL_STATS" select per Alexander's feedback
 - Export the page_pool_stats definition in the page_pool.h

 Changes in v3:
 - change memcpy to strncpy to fix the warning reported by Paolo Abeni
 - fix the compile errors on powerpc

 Changes in v2:
 - clean up and restructure the codes per Andrew Lunn's review comments
 - clear the statistics when the adaptor is down

Shenwei Wang (3):
  net: page_pool: export page_pool_stats definition
  net: fec: add xdp statistics
  net: fec: add page pool statistics

 drivers/net/ethernet/freescale/fec.h      | 15 ++++
 drivers/net/ethernet/freescale/fec_main.c | 96 +++++++++++++++++++++--
 include/net/page_pool.h                   |  2 +
 3 files changed, 107 insertions(+), 6 deletions(-)

--
2.34.1

