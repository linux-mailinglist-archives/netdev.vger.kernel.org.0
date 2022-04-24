Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5019C50D0CE
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 11:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbiDXJb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 05:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbiDXJbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 05:31:55 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2112.outbound.protection.outlook.com [40.107.215.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA07E90;
        Sun, 24 Apr 2022 02:28:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFcqsEmRoxU6aGKv1AXhmMe0Qc1Rjr8/CWoRdg7JphGawKyVCRZyvglSbAZwYI0JY+7Q2zAjbgE65Pkw3Qq8CswE5O/HjcPmAv6dWtaNpBMxGLwMoyEWCjBBlTRTUL8SQQEDektFZtfPb+PBMCONWYqQi8nu58VMOQd5Upp0udpvCsaJvMza2zsJkmjKajlfp9hYMhYvnPj1PUrGBzOJTlJsOg01g7Vrj+yAztLljO28b+m07n4zuwutjJhf3ly4jf8yMDh5LodX6QcTBrezycyRs0xaEQD4Y0aFYPmsl+pr+izpfODxlceVAPa/1KBpP3hQFG2A4C0o1qlm4540Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWZkJsM+sp6Z6MjOgZAlYVYq2AIIkACsvgoulTNnFp4=;
 b=JVdswBeHdkDLi/8ncTjA/VWGx6ZfP2dHGhZ3osN7qMRwYOvuz2NRJ0F8hNjCTThZodPcsA2rUDBgCSHCE2c+xj7GeHo3ZH7QZznaM70+LosE6uTmkivfZ+NFSQmX/C4yNDsdU0xylH3ombTLUdjgDYywU1fOqFFBO6AObmNYGovVoUBREViapdBZfOTXE3wKIddMf2Yx0S6ksXLiVIcts1VCGbXca7gVIdksSfX+75oZezpya6Yv6o1XK3sLsdNomRC0LgFanxJbbpExi4teStTZVjNhUKc23WlxmGkL/p6okreUWSvpnYozdCb7Ahr1SzppiXnxkOKHzgzYhTUZlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWZkJsM+sp6Z6MjOgZAlYVYq2AIIkACsvgoulTNnFp4=;
 b=iQY983vN4WTx5Ry+cqNpUmPO3ZlImTuB032Op423VAQFtwJTLl00RKH1C4zHryvb+5ttqwZGhVw43GqGZUbhoEl4xGqLa0kMZUF6DYoSOvR4ZKM5XT1kQ4OHcA76bz6hoXqafej+jYMwabo+b0sPFDIN9KwQcD7lbXIpepsWa84=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 TYZPR06MB4607.apcprd06.prod.outlook.com (2603:1096:400:123::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Sun, 24 Apr 2022 09:28:52 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5186.019; Sun, 24 Apr 2022
 09:28:52 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] FDDI: defxx: simplify if-if to if-else
Date:   Sun, 24 Apr 2022 17:28:42 +0800
Message-Id: <20220424092842.101307-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0199.apcprd02.prod.outlook.com
 (2603:1096:201:20::11) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 628e11b6-b677-4a78-d304-08da25d4d88c
X-MS-TrafficTypeDiagnostic: TYZPR06MB4607:EE_
X-Microsoft-Antispam-PRVS: <TYZPR06MB4607A6E51101338830726231ABF99@TYZPR06MB4607.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RaTddzJApX6XtO2dRL5XMCcDDu8ti1+uvknso2eiVw4pOKKFmeQd/ng/pysvD0hYt6xR0kuP4dd5+qzPsZt+TH6EvwYc2wTd5GX2BSyZvOQ/sHAJlEXGwAMNNbW7ZagGCI/755X6MnOsan+Jj4wp6PWyO9xHMkCvqI4eg2E1e+yAi5T3j7+518U9b5b+pfJm6WSxXAgdRj9pgC/EHpXft88+6YNQQRuxrBPmBou5t9gFS7yTPP+hn4KdaBV6euHK0NsU2mPQRM+P8GY5d3HnGj9PahLaTrwxLinqVTj4O78Wxp8CMO0IUJlotgsD3p+/ykQiThGnffYZFQmVHXqUxiIEqJY1QeLI+N0W/WM3yK+O2rFV5KTlzLm9eYelofgjXVIWckQUHwshX8gChZDBRBnq+f4FgYq4baWuprxL6KaXGNc94PcxlIafR0UOADZuCeIESYo2fpmQ7GqFa5l9HtN7TYPK3kgfN+2ysJUkpb1t0fFdvtDucebPAm+SK5SvaQtiR2GUCtbbfI0Ln4YFJyxt8uFk7BoYcX3I8xPikcMHL4ZlUhDqCPmQbraeXB0L5sQCHe7LA7z4/cXjciU0F9EnFfBLeAIw8DLSbQ4WPqqJzKurhoU5ZJ8vlBuBySqDUsMvKEC7KEIfXToBkrWQ58wihyqvNb70TiAFSj7LBN8o0xj3Qvwjq7W+IHCg8CKiRsiQWlwW44ew86g8Gvl5pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(110136005)(86362001)(36756003)(1076003)(186003)(83380400001)(107886003)(4326008)(38100700002)(38350700002)(2616005)(66476007)(66946007)(66556008)(8676002)(6486002)(6512007)(4744005)(2906002)(26005)(6666004)(5660300002)(52116002)(508600001)(6506007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4xdgN6rot8H+XMVyx88My08DAeVR8UJli5UkQc8vzmW6Yna7lVaT4xijPwYo?=
 =?us-ascii?Q?6GtEBxi6YrWVEO/5zQ+viDb0oEbq4r6q///wFU7XhaLhnxMB7ECaAd9SH4iE?=
 =?us-ascii?Q?lzDGKpaSSm6/m2WSDd4QEne0QMvnu0V3lm67rvpoFWd75f7Ln91lNwTnxjGw?=
 =?us-ascii?Q?iVFmWJPBoc+F2RCikk81MsZTUMwP1Ffo6WDVhb4IuJc8huI132m25YbryjJg?=
 =?us-ascii?Q?f4n0N6TqfdUZ69YI1VSAEhRA6XwR15qmw3CkTg/sE3M5JfUiCEBCFZvjSF4z?=
 =?us-ascii?Q?9ZJm+Pi+r+u5BGmtHi1toe4kQ5vlkjzHYF6t05oGAoibGbDNuREmZZjDcf1D?=
 =?us-ascii?Q?0tCut+6jP3qKrC1gxNwYMGelrJxI0L4mckll2RztK/D1rWk1l5/41DpWr2gq?=
 =?us-ascii?Q?z3KcIvptaW/lKuWwlHyOYCIZNhLtsSNBjeAz04OOOQOh1BkghgHlSaj9Djy/?=
 =?us-ascii?Q?5lNifpuIE0gIpLy0ypkQS71qjwFZaNZeo3Sv9/tx1P4Dh2yaUUzusaVD5M5N?=
 =?us-ascii?Q?H0/Cz+A60mMlb5juJonk5xCIAqKFJqNsqJBkFpItK7UtFqDiDpeSDlG2XghZ?=
 =?us-ascii?Q?4bwwn/s04+iGPYw/hw8CjuCX/ECRNgf0uQ0qgcZmWCo74TcbQgZ8evXpY/7k?=
 =?us-ascii?Q?LwLS2gzw8yvrf7FJfs2tH1BtNUhSaljWBs6bSFc71lIFtNQNgecDxu4nPtGI?=
 =?us-ascii?Q?NrXL6A+ru5iaRzBs5dJibOlLc5iCS5+5DuMrw4g3Ky/H13oYiv9mTMPM55AE?=
 =?us-ascii?Q?lgWXgIKrjAKC2/7C4EC0NLDUDHAxBMAVGkxcCKKHezq08woukLTSHlFyhx7e?=
 =?us-ascii?Q?HpSnOlEiw/ueMJ7lKQAav7PbxMTqs/G1dq5TaigVo4ZBao63jggUMRbVjKkb?=
 =?us-ascii?Q?4sM2IwjlMyTD18NUd/QePAzVZunoapvFWC7wh0N2Qq94scbGKpq2k0m/1qGv?=
 =?us-ascii?Q?gt6Al8E/01K77eiym7M6WXSzoMPzP2qUBhgOQrsa7eC9r5aXvEHl7nhsk0cs?=
 =?us-ascii?Q?3L5xuH36XR+kRaV6mSsNXhE4emA0zld+ULhrKYzdv84kwmgBLy5/Zv7j6uvB?=
 =?us-ascii?Q?Z4FiCsdvcIyi63cDhU9dWEsueoknFwopdiVjTsXLRrDRnjSajMPK3Z+zznJA?=
 =?us-ascii?Q?kTqvZ2h7iktj0uCeT86ts9uyqK4t+x285xJl35Q8YkKN3KF9z0gobi+8bVpn?=
 =?us-ascii?Q?xBl5XGfU/usV8BWrb1Guzk+Isaa5V1tvtZo1BuvPNY0DoK3pVqxWpjXIYOX2?=
 =?us-ascii?Q?RtFgVLGxhe3UQvmVw69aj2Wm6iVs1IZ2mMTys+J3RIKIbBEoXY4UQPPPCX8p?=
 =?us-ascii?Q?iPIAFxdtavKaGgq7NWO80QXASR8IStw0RGtRnalvUbJueMZ02VLVkWC0bH2j?=
 =?us-ascii?Q?h3NcbuS0jXMwJia8jHlS7eQTJebStkHqSbsZCg+aYLL1+Xc/JeFUcPjcQ25Q?=
 =?us-ascii?Q?OMxcAw2whCEL5LHIEXWoca27DoZV+fIjcS444NKJt2recHe78QYP9iZghUT/?=
 =?us-ascii?Q?64ng67WNpDaf7qB26GozoEjyGme/2oMQnlRjD7V3DlQ9ByLMiH/l8jhMt5Lb?=
 =?us-ascii?Q?vbpXPjPJLU6a5jxRWvlLrtd0P3iVLbw0bg10lh/2UrXunUAZFr+qGOE2sF65?=
 =?us-ascii?Q?+UGllW/6El416+tYsTjz3HRzOM+v6mxn+BrmKrLaNtHaaYCv47V3f2dCOLOR?=
 =?us-ascii?Q?OH+dn457rvFXPoMfsBTrH/oQsvbNLcgzPNaPh/8dkQUV144BUC89ivueDHIr?=
 =?us-ascii?Q?qAD9nwK8mA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 628e11b6-b677-4a78-d304-08da25d4d88c
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 09:28:52.5092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bF+Cj0UKgTwpPOwwJjBlVj9bCYUFSFB8IbpHRf8N8lfXLneCjPB9lnlGtMTJPJ97lKXzSB5ICElzhsTd6FiCuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB4607
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use if and else instead of if(A) and if (!A).

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/fddi/defxx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
index b584ffe38ad6..3edb2e96f763 100644
--- a/drivers/net/fddi/defxx.c
+++ b/drivers/net/fddi/defxx.c
@@ -585,10 +585,10 @@ static int dfx_register(struct device *bdev)
 			bp->mmio = false;
 			dfx_get_bars(bp, bar_start, bar_len);
 		}
-	}
-	if (!dfx_use_mmio)
+	} else {
 		region = request_region(bar_start[0], bar_len[0],
 					bdev->driver->name);
+	}
 	if (!region) {
 		dfx_register_res_err(print_name, dfx_use_mmio,
 				     bar_start[0], bar_len[0]);
-- 
2.35.1

