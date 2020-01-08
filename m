Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5470013474A
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbgAHQLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:11:15 -0500
Received: from mail-vi1eur05on2105.outbound.protection.outlook.com ([40.107.21.105]:40289
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727668AbgAHQLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 11:11:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odRMS8Fa2jSnFpcehvyjAFpnmTZdOdYukuUmkIdT13la8Ia2BqG9/MT2xQk/8ISnzDoquRk2yfgX8Vtd1k6QQ6LraiFWjROEjRvIVOrB1+MyhHjWZUBh+llZV1iR6oJP1t4BSjh4on5SpMBtC9XyLzupDjXPrfy8DiU5gXiCZ4YaQSAZEr8nB8x7Gtig/2cfy7caZlBD1qBab1yLicH5KPfI0hJzUEKh91VXi4/WekxyKEKez67h09n9VdZG0p01Vc7ANLKPOUvEtvSnFsMAYjiLB5KfArA4OEPYlYWPgkrn4SkRAIOTEODNTwwU2G7UhtuOk4Foci1RYttBt8WJIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvOHxOTqy1Hi6qakSLyQqpXe/nPMBCh9fxZIFbD2Lrg=;
 b=gt//p+j2E9lNZEbY7JReYV7b8aVF4jyhmWvbPq+AElf6rKfuIgG6Yh0FXdVCm93ZqaCjHkizquqxoRFND0sSW26wSxKS/m0CgvfU/X7g5OfzKMk+doWwnGUzaxjHx76CTGMWV5lKWkD6XlEpg2YhnCdu7UvRpv09oUHvEFXd19VUZWe2prBEkliqqNXl2N0tJHqk1JDOT9gsUJxE0HUKcu/oW6AW+rDLnti6bP7PhpCbkzZlW0CmkH7DsuCSPMl1SCBkJEJmbFZP7yYng6AI2bIqsaV+vOYp3jfUFXKZ5IndGKUJ9BYNgW3tT/I5sWfG8t2FQk+h6n/WS//7mFmPQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvOHxOTqy1Hi6qakSLyQqpXe/nPMBCh9fxZIFbD2Lrg=;
 b=iWEsdkNjCRMR/Q4ewu0cNnSQANNixP7+2QY/AclEHtfXYtm7gC+g5Jer0hsyH6JwuCnTxSB7wmio+odYcEX++FjsPjLG3DOOPHpONV/v7+/CVj/PaMlWOQJxGW7EmpYPQp76ZqmqeGkdGVIHFZMs9+60740V2/iCLg660JF9PYw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB5454.eurprd07.prod.outlook.com (20.178.81.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.6; Wed, 8 Jan 2020 16:11:11 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e%2]) with mapi id 15.20.2644.006; Wed, 8 Jan 2020
 16:11:11 +0000
From:   Alexander X Sverdlin <alexander.sverdlin@nokia.com>
To:     devel@driverdev.osuosl.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] staging: octeon: Drop on uncorrectable alignment or FCS error
Date:   Wed,  8 Jan 2020 17:10:42 +0100
Message-Id: <20200108161042.253618-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.24.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1PR0402CA0017.eurprd04.prod.outlook.com
 (2603:10a6:3:d0::27) To VI1PR07MB5040.eurprd07.prod.outlook.com
 (2603:10a6:803:9c::20)
MIME-Version: 1.0
Received: from ulegcpsvdell.emea.nsn-net.net (131.228.32.181) by HE1PR0402CA0017.eurprd04.prod.outlook.com (2603:10a6:3:d0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Wed, 8 Jan 2020 16:11:10 +0000
X-Mailer: git-send-email 2.24.0
X-Originating-IP: [131.228.32.181]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6afef9c0-8621-4a44-22a9-08d794556089
X-MS-TrafficTypeDiagnostic: VI1PR07MB5454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR07MB5454BA4E0427D25F59FDEDB8883E0@VI1PR07MB5454.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 02760F0D1C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(39860400002)(136003)(396003)(199004)(189003)(81166006)(316002)(54906003)(8676002)(86362001)(81156014)(186003)(16526019)(2906002)(8936002)(6506007)(6916009)(52116002)(4326008)(6512007)(26005)(5660300002)(6486002)(66476007)(1076003)(36756003)(66556008)(6666004)(2616005)(478600001)(66946007)(956004);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB5454;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wjj6/Xcwzwy8RkO9IUhFnxWy2igiem8JdgUGNBokHgTC187GRhGJJbFoLbiH9nnZg42LAkwVjfgGKXeEXp6ZeqOLX26t9fiybncmVGPYtBfDKGXbPS2KRXDMkuWSDyoyEj/jgR1XfJhyGhe6+LBTDOIwKdMUq0VsGV002PLErEP2GIPDMOuvTzofNhUqM1H/cYata02N/Pjp3h1RzQMw7zJbo75iLNULa+rqDC4kpyN+eyeteDj4zVCf9tlDgJrZ/OfRoCfjSieXTap7z7yPNk9uVVgO94CfPOtjdPiUxh4xVHWf0uwHHuouzyjp+2nBGkSpVnZSMN3kbTXTlPihsvDGeEnTeYtmXq2Fat9YtXBTvv7+RrhFDMuY7JR1/C72gihVq3cEuyWgzrJH06nCO3yuep2qeQ5fV0ttJj7+6lJZom5PanTlI+PuSSu9bO3o
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afef9c0-8621-4a44-22a9-08d794556089
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2020 16:11:11.0514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TL6yenyC+qdzkPSwtOzgvckY5B4dIT2loOCgEY0o3espwQK8p1UoTVt1NlXNyBP8kzm5i3EYINA03m3ue5c7g2jljz6vQ46SnBhsujg6x6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB5454
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Currently in case of alignment or FCS error if the packet cannot be
corrected it's still not dropped. Report the error properly and drop the
packet while making the code around a little bit more readable.

Fixes: 80ff0fd3ab ("Staging: Add octeon-ethernet driver files.")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/staging/octeon/ethernet-rx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 2c16230..edee9b5 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -69,15 +69,17 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
 	else
 		port = work->word1.cn38xx.ipprt;
 
-	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64)) {
+	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64))
 		/*
 		 * Ignore length errors on min size packets. Some
 		 * equipment incorrectly pads packets to 64+4FCS
 		 * instead of 60+4FCS.  Note these packets still get
 		 * counted as frame errors.
 		 */
-	} else if (work->word2.snoip.err_code == 5 ||
-		   work->word2.snoip.err_code == 7) {
+		return 0;
+
+	if (work->word2.snoip.err_code == 5 ||
+	    work->word2.snoip.err_code == 7) {
 		/*
 		 * We received a packet with either an alignment error
 		 * or a FCS error. This may be signalling that we are
@@ -125,14 +127,12 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
 				return 1;
 			}
 		}
-	} else {
-		printk_ratelimited("Port %d receive error code %d, packet dropped\n",
-				   port, work->word2.snoip.err_code);
-		cvm_oct_free_work(work);
-		return 1;
 	}
 
-	return 0;
+	printk_ratelimited("Port %d receive error code %d, packet dropped\n",
+			   port, work->word2.snoip.err_code);
+	cvm_oct_free_work(work);
+	return 1;
 }
 
 static void copy_segments_to_skb(struct cvmx_wqe *work, struct sk_buff *skb)
-- 
2.4.6

