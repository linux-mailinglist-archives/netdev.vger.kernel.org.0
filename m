Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089365BB9CA
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 19:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiIQRvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 13:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiIQRvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 13:51:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2136.outbound.protection.outlook.com [40.107.244.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC54F27DD1;
        Sat, 17 Sep 2022 10:51:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUIK38raTscqdcw1s6/jwbpTv7Edx78PYGBTPAhAnRBYqYSu/b6Y3qzeNvwoeix6cUs9vVVYnQHzBY0o+EoYG+UrYiXsPhQBzsPXd+9LEXy+sx3/3zUNO8v8DNEyB3dZACNouM++7+PxeSdlXpTsHif89md1h8S5HzXxvsgHnOX9ipGELNSIkidsqtUStGPR0hvUdZhYdEDEPMEJlxzaH4IZIKEfb3Gl9+tbGlsCgr8UXUEVbt/EFgS9Hnuef454QRXvHZPgbDnnxIgwnBvWcs8SudWWzbgmfZFz0uvlfM8M5D2TpRt2OAJyYzDRCA0bmymgxescOf/x/Kz1BgsD/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IxMptbxw7ypSwkOXdKI7a5ieNBR4CA6p6PVuseP0z+8=;
 b=FYMtIF71AI3bRLgrXUkSceWlfCAJaWu+HBesPYFL+1890exbHAvfkgAtWER0uO4ZFX5exvvbE4vtDEgG+mTPkkPJbofOEUMbQxHdut6kQC6oTX7KK+2MJ9U1fArGT56NrlN8i1u/RfCVDg6fH6fbLDdUdtw/k6xQeapsMvJ39njN6NvSsMexedhdFWBk8HsPA5pzcilu+peZYZO18dMCoXvlJlQJpc1TYN727W/SwV1c3vhtFz4kBLW/kuKDoNeeELck8Dx/7AuwQTbtUYHI9PHyzbHcjMjMc/7JydlpvXz8LLkLYCQ4o6vuJ1NQIzPmVTIDY6CVLpyR7zhb957P7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxMptbxw7ypSwkOXdKI7a5ieNBR4CA6p6PVuseP0z+8=;
 b=KlwTNV6vICmMmSr49TVoR+dex5z8x/Xzrx2MfaPj7+rPfuMfHX06nkt2IqqCrl8rYiofDFaBNPAEK/fT7nLoWSdGntZkb2JSVSAcKijF/jO5/28SIVOcI3voSkSgYiAHRFZC7oo0zNfcWsCFDmrAlRQUQ9tC7YFLmjhUh72hzRk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4523.namprd10.prod.outlook.com
 (2603:10b6:806:113::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Sat, 17 Sep
 2022 17:51:41 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5632.018; Sat, 17 Sep 2022
 17:51:40 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 0/2] clean up ocelot_reset() routine
Date:   Sat, 17 Sep 2022 10:51:25 -0700
Message-Id: <20220917175127.161504-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0148.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4523:EE_
X-MS-Office365-Filtering-Correlation-Id: 3096e73f-818d-4f90-7ff1-08da98d54689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mhFSQvzR+EvAP0fHKw4xiHG2XHZ+m9PTZrmpnA/sjbOqgJj31CTdK7bSovobAEnMqMjoSjz5UfR9Jtcdmicqu35dBv/mcgBRwM1IM+mbo9kaHjDCh7la0q/bZtyQkuLikXEtwit4egY9IltVsHdJIlFcRv1yOZiKHxLkKjX1d7qIPieQdduq7YV3+hs15lzyznpmSvuR/0SfIB6E30TR+ghMfU8bymtDB4lqzPRNnCkHwyGC8owXYk/7clAjM0yhKFlzRTz9bgKWCOOltGh7r8knURrSxEtQEhFK0T/iqVCzpFErQ0GWahQxJ6XNmQ0OmDzDhCYkDxJdA35LGRiIG82M7bXLSOriT2hLDZLylEd68wgtC6koFt0yzQR6kb4Mac1KOzgbnSMmDdZDYEbMK+wP5BhgEUUkjZVlESlfbQSmojZs4DoKUWW9fp25eNRo75B5+niTJcq0+88MSYO07Vw7QZRHF9X0oY550Uapo7yhpRQjoeQPqIDRPZkNDDtaux1894c43PgFrI5RfLv9KT+XCJo1WD8dATvquIoj1r408zUUjOIrxaTETpPvu9ZqsfR49wLz7CNu/3p/WqZe0aHAlm2Vru3ATVnHI7Wbdh/dG8fQf3BN88Me1BDT2yqSOwxP2CxCdT4FIbi9T69k2b0A7VKqApzAY1SPzFWbRuCX9TtAfwauEhuupM6G/eX79KBnEkLwQGl3TDHxvRSDUA0Is0gTaItlcagbfdKEh90+nG2CqNERpwjWoC3guYc/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39830400003)(366004)(376002)(346002)(396003)(451199015)(36756003)(5660300002)(8936002)(2616005)(7416002)(4744005)(38350700002)(66556008)(66946007)(38100700002)(8676002)(66476007)(86362001)(44832011)(2906002)(4326008)(54906003)(478600001)(6486002)(83380400001)(1076003)(186003)(52116002)(316002)(6506007)(41300700001)(6666004)(26005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tk51zOjptWZbaICvY3UElGxFQQaThnNz1GTwwgrIxm1+kzKzFfkSNO5EtpJ2?=
 =?us-ascii?Q?0Evdob24yfDkuobvoRlwo3ka0L815pRf61Az1lXNmVj58y8iWprxp0CYBZ6+?=
 =?us-ascii?Q?37IBgQ/rVIVTtLxghjDHr60q4OsCIVItETyZeXfoH7uVA2w0F1JZjCU9roWu?=
 =?us-ascii?Q?aNN0Xvb3q+jXRsC5weB7eZAppwijTI4o/cZkuhPLb6uzu1pBJ9KoLSqTRohz?=
 =?us-ascii?Q?Xm/6EaFfuLsKLMck4TaWAIlM0w7+gzTY/AkbcPN0Nb2SIoX6275LItMuLGMF?=
 =?us-ascii?Q?YPzyxpQ2dUocVsWfSycM8hbCE63l/iIPjcXUX7sbqmpZ7T1ZhLBxqZ8fmbPH?=
 =?us-ascii?Q?RpphigOS/JsCmPHxqGHNhDTdsDHuwCesgXNHzPmqaEnC7USSyXjo9vOtqkBR?=
 =?us-ascii?Q?V+RWVRRgUMnkt399Pv28E3MsZqCUUdf4cNgs5xgN7i3elC2kfZGrCdSs/W2C?=
 =?us-ascii?Q?3Ar4Zy5S9418KlmqdmrGJLDKPpiZqWxkeuvXJhL647PBEgIShod4lupDPPCN?=
 =?us-ascii?Q?BMhPOMEWVdK2GduvGEZNAJMgdq3lHlpvIPpnXN1vJ0E7HGbbn9slj+EFNM8e?=
 =?us-ascii?Q?flahPnDXyVN2AHXvvgtLDV4s+haholi2oxa1QfQRnwsgdWA2WMQYoYWO9VIf?=
 =?us-ascii?Q?jdinaqYCogydvFC/0CbBzoC9MUii2CZi7WjeiMs12rwbDCDTncFvXPQpO4zq?=
 =?us-ascii?Q?/xviWupXcVcl+tQrLIzUCnUuC8eElgWnHbYXnr1X+gfHgH0b7MuWeHgkyCSy?=
 =?us-ascii?Q?Djx9N8mDvVi4aSNb8SWKIwzuK0/8QVC8MIAdgbRxPS6dCj3JifDtP/ciYvni?=
 =?us-ascii?Q?+pvW+qMhjpTGPpc+2GN2I1Q3c0fPGBaXC+mkgWFco+PGwnqzOWn9A5HYTe6D?=
 =?us-ascii?Q?ylY9u6k9EhMjwytNCPpqlM7JeBguHFJB39kTGLQQvZf2We2UK+xihwEI+pBz?=
 =?us-ascii?Q?e9bCQ4gvRS87lABYfa12tn9v8VExbsiGdIcOFu/gVCmpVDc3WlVoNjtt/+Hp?=
 =?us-ascii?Q?nvnZRW9u27DsyORkcfJk5Pq/u1M3FvnBBqWvAoCB9AYLwurew2The5l+OrkY?=
 =?us-ascii?Q?3YwCeHIzQS+4nZ6wS9U0knDHzpFyiJJixQ/zZgTaHFsu5jiqBUY/JGpZOm3c?=
 =?us-ascii?Q?KtvtPqseOJ8zvZz0ELlLqTHt6V/ttfmjrEGsKZhv+OOo+1/KPRzV1yyu0ZVw?=
 =?us-ascii?Q?UXgyfumWeANEtFtOUuYskNVcXUv3/rGjAmZgRadHLxRIf8lrIVjDxTkLWeDR?=
 =?us-ascii?Q?MRDP9hZd4OtX0kpNhYTbL4EkV1znPjzqiu6ZP+8imZlo0P417b+cbwJ74n6U?=
 =?us-ascii?Q?LIJligBOvoMQdzeNSm6aA7tOy+7/uqqzA8y3l9PYoK+Ha5U6Wf1TozR65ja4?=
 =?us-ascii?Q?VecFBigGtwUDasQfvgLaixEv2yFXPpEzt2ZktsvY0UKrTa5n7+Yo8N9W5Fma?=
 =?us-ascii?Q?vlWgyWB3yUzmw4XZpZJqe/mtICvn2w9SLKj3zaVasP2u/nKSw9QAPrFkQ6s3?=
 =?us-ascii?Q?kS6xudR40P4ReFC9WJic/rrIJQOjR2ynsCzXf5iIXy1zMAKoyl92TNVF5vKb?=
 =?us-ascii?Q?y//ivHZe+mFCH15kdsiUWGTKo/BpWE7zq6rafq2zQPOE9Nj15DcjpC4aSnSr?=
 =?us-ascii?Q?5g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3096e73f-818d-4f90-7ff1-08da98d54689
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2022 17:51:40.7718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e7Bok1SXokYu/+IF2RqGPm6dyPLRKAVKFugXEXHyCdvxIGM0Ms6e/F/rRkCNsXg5fDJmqu+OuF6JL8DzHbml2mEDruI2tjpKsg/Pv9PRapg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4523
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_reset() will soon be exported to a common library to be used by
the ocelot_ext system. This will make error values from regmap calls
possible, so they must be checked. Additionally, readx_poll_timeout()
can be substituted for the custom loop, as a simple cleanup.

I don't have hardware to verify this set directly, but there shouldn't
be any functional changes.

v2:
    Fix 64-bit compiler warning (1/2) (kernel test robot)
    Remove unnecessary variable assignment (2/2)
    Add Reviewed tag (1/2)

Colin Foster (2):
  net: mscc: ocelot: utilize readx_poll_timeout() for chip reset
  net: mscc: ocelot: check return values of writes during reset

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 46 ++++++++++++++++------
 1 file changed, 33 insertions(+), 13 deletions(-)

-- 
2.25.1

