Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033A844FEE6
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 07:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhKOHBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 02:01:41 -0500
Received: from mail-eopbgr1320095.outbound.protection.outlook.com ([40.107.132.95]:14112
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229648AbhKOHBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 02:01:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I57pJpZATR8JhS0xmJNPMqCuawfOilmO2b1yYAkboJ5kKu1Sg2g8nVouwS8ntCLHYBU4dxBGJdxcjLXLp/eXh3qlYNXjGQ0XdegZVnkvR0aXsY2xlgO9/xADljFNISbDGFwEx4evB4mv3un18b6Ubds0bZydS1ANMtlU6cJ5f2nZ+U3MPPQpD4RsH19Ya7L5xGqu022kpOWbAFtPX5UgHCdRGROVo0cMvrFCovhou78QiqSkURPe4lWm+zMw9MP8bC2GkO7q19JDQxGMgyLY2sBQEeNc4AJ9HgCIjjF+ZtPhPqARsAAZ6BUvviEnjRm2pJpG1Ae/ZlVYzAmsbetc3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pT6cMV4Uyi7hhIjl2AxnrMX9RBtqr5Qo1YVtPZX4eS4=;
 b=fqV8Uu/YMCTzB1RYrFmJXYjzB7gIU0dE/94EgBJfDCDQRhOqE/k9OgGzKhr8AyIPvV8RXOseUS9utF8k98MEzjNJeD0VtVZ7fbUfdsu1RzZphdQ9l3NbQgBEWU/Kppx/R6ZOwX74UisjbJEXI0qe1lwZ5H9WQ9tx2n3lx0NHgkDc0Nx6wMknVwGhe9iog5vlQhip7BAr8aM11HR+aNi3cFdWi5MRJTWs9nL3ecuTZt8gHterNnjK9+0zYdnRmk1tIwpsLXCGnpD7m8i4W+whZyGB9umy0rEBBbygHpi6EiLUkLi0uLAr4ZNplLk2tmqJ78ztijqgpUPy++Z42SAc7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pT6cMV4Uyi7hhIjl2AxnrMX9RBtqr5Qo1YVtPZX4eS4=;
 b=Ht5AL/4yybUsmTA/ZY6lrVVntQiIo1Do1xesAB5AooxZUBUyJRJPjY3CYDEi962f6GRb1TBSNkE1Z7oDsGTtbUtUJsJtqoQmSvN7CTgNLrox34p+v3RYOyUFOIRSGJ+0XHN7ickXpBtDPzZ/dWlomEPEuTv3LLGMrnA1IH7ABgg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by TYZPR06MB3951.apcprd06.prod.outlook.com (2603:1096:400:25::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.18; Mon, 15 Nov
 2021 06:58:40 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::5e:78e1:eba3:7d0e]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::5e:78e1:eba3:7d0e%8]) with mapi id 15.20.4669.016; Mon, 15 Nov 2021
 06:58:40 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yihao Han <hanyihao@vivo.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com
Subject: [PATCH] net: fddi: use swap() to make code cleaner
Date:   Sun, 14 Nov 2021 22:58:16 -0800
Message-Id: <20211115065826.5221-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0190.apcprd02.prod.outlook.com
 (2603:1096:201:21::26) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
Received: from ubuntu.localdomain (218.213.202.189) by HK2PR02CA0190.apcprd02.prod.outlook.com (2603:1096:201:21::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 06:58:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31f76079-1556-46e5-6669-08d9a8055a6a
X-MS-TrafficTypeDiagnostic: TYZPR06MB3951:
X-Microsoft-Antispam-PRVS: <TYZPR06MB395133FA5DC735FD73C7C390A2989@TYZPR06MB3951.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mgf6u/y/b86Kbpe+2bP63341Enjaqq00EdrXPCqGF6qrebBUhFXzmTGbwPWvNXcaq+xrST44omLz6XU6h7AQcty9qYN2IRTznNkz522IuNf65pbkTvdLAQOInvHlYMeAGGiUYektZBHV3ZfQrpfkPZeXaPsUhIWIjxnQCOxioAyjXErpO0cfHg646c5iGQdctISb9fg/uJPhL64LDe6tvBIKCXStNVTMGEHKuHs0QBwcjh/DwYH9DKpvEssK8eKkdDNrnCw9qebJANTkxbPVdw0NUx9P7SqjnYytC2beVGS2E/QycoHYP/Jmse4PEgUO803HRUK3di+QqtUjyVUWJ8gd4/LO1dpStjOsZU1hMLf1ykmpH4ys7kE8E1Mdq7VDNyPmGphjGNJkhU55NWUGnePy6Tn42DpUziepqJcFzmhvy98DwW50eDg2BVyICcAO4n0FH5obLNiFsDjbR3YL3ykvwzHDeYsHbJNWH+eCt+UJQKu+DY5VToTH0gT3mHvaSKtpVjGc2gjVKO3Q4u2JyFUmN1JH6TwT3NboaTOh1MYSS4/DoWJFdyBmlmHrOsR924Z4E+vQ4XZ3lEQrLr5HHMWHgZulDTF683VL8Y8zx72viCUpuJcnPR2EUFzAPdEzTIcFMioBZOJW3NegpO6/an1NdmHqJKz0WXJBrEsD8xlSoKfuBzovfoapI26eV3454Tl1tVHlbo94qSC73Zji5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(8676002)(66476007)(66946007)(6512007)(66556008)(316002)(83380400001)(52116002)(6506007)(38350700002)(38100700002)(2906002)(1076003)(26005)(110136005)(186003)(107886003)(6486002)(5660300002)(2616005)(956004)(8936002)(6666004)(86362001)(36756003)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fw8/AewPLZ8J8rJKvCoJ75TqEhFAJ+XbAtZY/o1s7bqP3MQTjy65NCrDC0NE?=
 =?us-ascii?Q?xguQXOdA6mzSgnL6ZAKsrN3j/8s+3SG0tW7DL191cVacmrbJUcVYtLFBDDel?=
 =?us-ascii?Q?1V0xCpxRmUCkldMDaseyk/mRme/5sB7On1uLUt6C6FG26HpTtxWWEYCtO40/?=
 =?us-ascii?Q?bdBj/h1YRtbBZ/++es+9s+NIX2KM1vVN5bc47OswkOzHpHKGmRqBxGMkKioE?=
 =?us-ascii?Q?2PlBsVLDMfuMxuOQ1TXSMfAQ/6/KkfpCp8olRkXxvaoUDMdatd2fVeH1Xm6I?=
 =?us-ascii?Q?uIRgQpLNe9rwoBKJf0i4O2P3VvHD4IRNHPYpJZI+trB5o89gOlC2TqYHN/Xs?=
 =?us-ascii?Q?9ywmJ8BXCs9okgYr827T7AAxo8gfl6aW+zJ0ZM2PBwYJ3LwZOyPuNCGRe1tW?=
 =?us-ascii?Q?cVezHRVmU/lPkP5hbOx/RwwEtMdxJkRUdVpX69ONb9O1MMMUp36/L3E0UybD?=
 =?us-ascii?Q?yzpoL1NPbP0HvJUjKpVntMhwNKeO09TpUrEM9MMiOpsECT01SSeZnUgeVCt1?=
 =?us-ascii?Q?myPA3vdsRuAYCDpSetgWSLbwYlgKU/9x8TkOPHT3ngNbuRGKSGJlrau2j1p7?=
 =?us-ascii?Q?gyVu4KuYB0/92NyJ/ze+cFaySV6OV48r5nH1jXDChf0ThiNB4ns7fLHMjWyD?=
 =?us-ascii?Q?sM649H/nKtp10Rf1JVpnqXIOwloAbhodRwdXfDtE4EY9A4KMApNSqbzeszDR?=
 =?us-ascii?Q?W0VsVay3MQ7QaMg9R0IhJwnsLiJStZAoP/09rxh6VJUHBBKF6j3cd4wXONI/?=
 =?us-ascii?Q?1ryIt4RXlEBJvFZLV6AwEijHjbbEEwa0aLJaSVEP27OgFAyi3jczTxD0UEp2?=
 =?us-ascii?Q?ElHzAAzaPEApkOt8dUAXaUi2kZ5wMNdDcAhky3j2qEwUk9vPHd2W6NuFC5kU?=
 =?us-ascii?Q?fARABVOXRZ0RpH6d9nrad0ngFyNrBXGCmMJ8vfF5a5h7Cs4okfBuxUVJc/r8?=
 =?us-ascii?Q?zWLYjCiFm9a1njlKD8aoTMARmP5tlhAHN05e9NcYnkn5aD5Q42XUK5fIYcTA?=
 =?us-ascii?Q?u8Yktjc7PSC2EP5y892MxBWMwSQ+C/90PJCcoOHf5+iseYYmUGS8ojAj1dP7?=
 =?us-ascii?Q?4bfxJ5ygtGSs//gMAQMr9w575EjTfO0ahGeZt/+XLMN1npNh1oTI2lFwOf78?=
 =?us-ascii?Q?NwpJSU8CkKN8I9YTOsWznkv6pkWX3KEz6f+Hnt0L5Aep2LfT5OpyaCrLmTUX?=
 =?us-ascii?Q?JmDqf62gAuXrjds0vxEgNBOl51kk9CGIneYumTFbxWfAdVd5r0uAEpYdZ5rc?=
 =?us-ascii?Q?H0U6YNtrAI0nNUBHQgchfyNiBEJfKcIfsAEOaS63LdX94J8iqcMg08Jh3iCE?=
 =?us-ascii?Q?zh/Xhh3sX44aSh9IiOO+VhHaPfi7bPJEGzDJxmof/fT7HLI8kdKDhfM/2TPs?=
 =?us-ascii?Q?WW65zi3PGPsAkuNu9oTQNB1BW4AMsXhK9dEcH2JQwqhElatRVLrFp9VA2BX3?=
 =?us-ascii?Q?P2saQGs0rftkcuA9R6fZmPU38c0h/b6ENwh08WhqPEbxryEPlxAuElNDzGCa?=
 =?us-ascii?Q?N0oQjpopVY4P0v/PmPCeBOME9uvjEZOawLyjYvk+A8k5+prcYMhN4s0K7Nl1?=
 =?us-ascii?Q?osPVSJtu4abO10FVChagKWfs594bIdGRpmfYgqAQd2FX8VRA5DbQNVzxIMRR?=
 =?us-ascii?Q?C7HY1vDynL4jMjgRuBGQZqA=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f76079-1556-46e5-6669-08d9a8055a6a
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 06:58:40.2398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VVqLlg4+mUEB/pC4jskPlnVIomGd3jkhVphYcSU7ltZej4yZM1R1dpgb2yZ1L3r5wy85DtWoaicXPCeTUiqXcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB3951
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 drivers/net/fddi/skfp/smt.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/fddi/skfp/smt.c b/drivers/net/fddi/skfp/smt.c
index 6b68a53f1b38..72c31f0013ad 100644
--- a/drivers/net/fddi/skfp/smt.c
+++ b/drivers/net/fddi/skfp/smt.c
@@ -1846,10 +1846,10 @@ void smt_swap_para(struct smt_header *sm, int len, int direction)
 	}
 }
 
+
 static void smt_string_swap(char *data, const char *format, int len)
 {
 	const char	*open_paren = NULL ;
-	int	x ;
 
 	while (len > 0  && *format) {
 		switch (*format) {
@@ -1876,19 +1876,13 @@ static void smt_string_swap(char *data, const char *format, int len)
 			len-- ;
 			break ;
 		case 's' :
-			x = data[0] ;
-			data[0] = data[1] ;
-			data[1] = x ;
+			swap(data[0], data[1]) ;
 			data += 2 ;
 			len -= 2 ;
 			break ;
 		case 'l' :
-			x = data[0] ;
-			data[0] = data[3] ;
-			data[3] = x ;
-			x = data[1] ;
-			data[1] = data[2] ;
-			data[2] = x ;
+			swap(data[0], data[3]) ;
+			swap(data[1], data[2]) ;
 			data += 4 ;
 			len -= 4 ;
 			break ;
-- 
2.17.1

