Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B1550D0E7
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 11:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbiDXJtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 05:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238919AbiDXJtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 05:49:07 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2125.outbound.protection.outlook.com [40.107.215.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7888F2E0BC;
        Sun, 24 Apr 2022 02:46:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGp1QjyxhC92b7Kv2m57R+rkZM7BbMRjXkST6JXyfGJPXjJKhzr58ZLOwkQUvuNE51mMtWCUoQX+OvN7MRvxgJcYAp1jo3G3bBfYTAgZ1PFH3SIDVh8tytem6F9LHf7DIv0V7xdTlx33p/NEd/Wc+dzzOJrqZtmq0eh454MMg3TBYqyBh0yI3eJQyScBQj4QEE/DdBtSzvdiC5EGf7HyvHV9bNT+3RPGkzgVMKfLZ1D30ddaihMg8i6yeAk7mjUNPC68RLQcShca5KOz8ChGG6GKPxQGveQ4c26oczuKwN7gY61JkbPHUxNjPQfuESARl3PsmH/NHR++7o+ZXTs46A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZfmA3JEFbDzNGgheDkRLjW1VxCl9tQoj+Q6K8yi3ejk=;
 b=ib2pUbCX2Ef8ofgnM33yTAeR8cYwp7syce61trXEQnkG31CBLQuhc+1DO29u3bLS/k4faDcouGHhYaGSVCIFm5pYuVB5rPHkABvnpjFdZRD6lXVLvBXoLXEE58NhLr7ut8g/5PyVmu+/JSLrxHtd9+U+6ZIr9rj+9qnG7D3/FGSFbEVlmPnOONNVocU/nW8fsIyExZsTwaXkk+iUdkoujjrD/XodyFgWCAPf76kO53w11UuEbMWbzW6L8/wOIivKlBZXMoqK5Xvkqx4GHW1XbelwVGNHg2xf9jcjAq/lYKGRTks/qFqtWMeYXX7iksuWUxB48gR3ENArOXo8HxmbMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZfmA3JEFbDzNGgheDkRLjW1VxCl9tQoj+Q6K8yi3ejk=;
 b=S5iK4AYSz6t2iA6m0rI/gChYCGsU92Ef6cwvc+o1W5IAWK6EqU+m6JqV8wUnAx6DEQhuRufllhUYsoD7LKjXLgj+taZfiSZY3ez5kHdhcXxYFEEw68iZm0OMsgeuCRSd2GvVEZO9XoSH9Lrby5/LqGSsDr5302HDbRfc5WqVbzQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 TY2PR06MB2925.apcprd06.prod.outlook.com (2603:1096:404:53::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Sun, 24 Apr 2022 09:46:03 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5186.019; Sun, 24 Apr 2022
 09:46:03 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] wil6210: simplify if-if to if-else
Date:   Sun, 24 Apr 2022 17:45:50 +0800
Message-Id: <20220424094552.105466-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2P15301CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::12) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a904c91e-52ce-42e5-4c72-08da25d73ef9
X-MS-TrafficTypeDiagnostic: TY2PR06MB2925:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB292529E7254A21BA58DF792AABF99@TY2PR06MB2925.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d1JQwNT+X3Wq1fw3uNwwyhhUA/bsAQrDXnMUKHyyfzXtHkufyPDsBml9upn8PFiw5TG5d/2+U+0ZDq6y4933JtpJtAu48slAM6ORdlnMoj4oidzJInoYdmFzn4g89x43IQ0cEO1PSx6ovV9+6J1XeVaveeOk3Mo0X0cFSsxr44dGN5fNwRpxPrL3vpmZ65kaxeruubwCmRrR6TK4LPMXb72z8MNf5M+AsEwudgbzcRM687i8NF33+00khv2O/cKLLtwc1JgiXm+8HmXX8BYqAYXn2fB2OuLdWDnwtEdgdjwGJQD9nLtNrGTHCOhjrCSN33UTnLGaBDurwKUNUNKhdwZdMYGUAvLdO/1PRz06AO2Qvu94H5YgHHvwRgx8Hqb8RqD1P0k7O09YIQrXkhPO3/sg86Oc4okFeDqsvx3+MnCyhlaVdwE1tbYJuJADgds0BxGdwPyg/Ge5uzMjVtlzmgYpUx72YJlaAT2j6jtEx+V3h+HC+Zhh/rJuZUHHUIaR7+R3tO3Ch7QracOCxT98QoPwqt5iVNx+QwVcSCRNZWK8IWwMMe4gT0huaUpNCPM3LYhWlm4/kYj16y9TL7hVtcN+KwctaSvZ7kECp/Hh8QIhKXGGIrl0TtN3kJktt4gTCayDzd2do2NGM2frrWmmg+ACcKW9NMzJY4jvWjnOY7bvZhax5Fde7hvCxZ1AiuMf1znqCWot6OJaiVednRWtsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(8676002)(66946007)(508600001)(66476007)(6486002)(4744005)(4326008)(83380400001)(66556008)(8936002)(5660300002)(107886003)(2906002)(2616005)(38100700002)(1076003)(38350700002)(36756003)(52116002)(6666004)(6512007)(26005)(6506007)(110136005)(86362001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q2JBGfkrtILwuqJN6eYjtNfRynRM9fBHLwFZzfsS4dh0xTOkVuSb7UR9Q0G0?=
 =?us-ascii?Q?5AqFMyyDjQttzeX/nZdq/zg/w/Jhy00yTquTTnAGmgN6jPIXWVogfiNPQHL+?=
 =?us-ascii?Q?7NHxIDTfqDhN8KSO+tVFHJ19PE2VLJfku5O3Ye2yxRh7BS0DOFAGoTrZ2SHF?=
 =?us-ascii?Q?9FOfGcLWkG5nHrDQwQxq78PYFENGw/mR4UBGP8hHnGQg8GtY3GgIe1tbabSw?=
 =?us-ascii?Q?wlS0Me54IA2FjcwWRiRmOkINJgBSKA0mKT83WW2oioC/lzFfHeRU5tOrxaHK?=
 =?us-ascii?Q?usCbY4/cXiK5qMTpOquXJQeDYTsGRj4rDD9aECC/kWHOxTtPWRjA4Yh/YAtu?=
 =?us-ascii?Q?fieKyCL4rV0FZ7dCFfgy84/DR+4otbu7yii6EJeS18R2RzyJsWpqpHBbjcCH?=
 =?us-ascii?Q?p1K4XLdkPp8/TioiAljwbwhiN5/LvhgfmahP6rplS+UOKsWUeGKPpzMAFo6n?=
 =?us-ascii?Q?raQSIG7E6kcHhjksv4QN5pVsO+daHHQWFpc+4+WlxHfIMuXBuRFKaUFz7IwY?=
 =?us-ascii?Q?9l1qOynawLAKiowhVfP3gAx1TA2xxcbrqYykR1r2g7XFbuPzFum9c+b5Zn6O?=
 =?us-ascii?Q?YNl+GznqCWaL2TJbAJTvnjh8ILTIpTui2ZuLJc7whclE2w5c6zsYT6zBRRU+?=
 =?us-ascii?Q?57kogu8AGLTe8bqAwgkDFumVCAqd508DPwe+8K0jViisaXHpwhopB8xnIDkc?=
 =?us-ascii?Q?J3sI4eGt32v42e6ogwDldmGFGC62TU7FXBU4SU3nMMEZYrGKTXbGusypGMbS?=
 =?us-ascii?Q?/184fjxtZaDNvnLyMWjoCOyCh71HjBUKr+hNKKMPNFtIgYtroIiM7g91l4g+?=
 =?us-ascii?Q?/h0WhBcvYog4KEjej8raAE9eyH24ObeMAke2bhBYVxEBp8j5iALqBYF8iUwe?=
 =?us-ascii?Q?IMqx36DxSbpgu+2MXXqNjT/nSC5pnNKs0/R+EZtCRu8fyJY4st0Iv78GduLv?=
 =?us-ascii?Q?bNB5F+E0o8TzHLhlgSivnNF+uwYLd/k5M+/RKhl0nCipbFG+rWuYgJnyigCr?=
 =?us-ascii?Q?2z6jFQH0iozy1jX0oa/jeIhoXN/eQLfPIfvrvOAO3lqPe9XM7wIZU1Am+1Pk?=
 =?us-ascii?Q?wP9NDCK0m4kVfqR8w/m3hPXqvaokEsdhectrC4LIjJ6c/sRoRlPs+EcLV0+V?=
 =?us-ascii?Q?Iu+1wsFDYp88OxtDcowFaC8iG+va9jM7cqpnxYSkFB2a2jKjh54F9RrpW7ST?=
 =?us-ascii?Q?UyOhRxtJzGkTxsHfOCyO3pKZF8sT4uR75pPg024DREXmEAg6+pG6dIoYyKgp?=
 =?us-ascii?Q?51Ny8AXihr4c9cnz4vEQvsQK/kL3elNbQM5LjRrP5tZls+wgaU+LV6IetTL9?=
 =?us-ascii?Q?00Q+LMi4Z4o6FZVtyRYONBubyppvcJM18QMpX58wPBBieYqOBZxGv8lVQ431?=
 =?us-ascii?Q?yIGXOCC84lfoirGy+fN1AOImYAQZ5+J/gbiuRnveJrZBlRkWyBVjYuzzSBWm?=
 =?us-ascii?Q?0C5Hrq4Oc7bG1xwE7EMUMp6wVtub5YNliUCfMhNvtK2qXafNx1nsBm4nQUKR?=
 =?us-ascii?Q?/YAZJvKBBbQDf39nhcnAunVSnfHulwG8zJP7rai4iHHSr1pXVgE3hncStT0e?=
 =?us-ascii?Q?WLYzcaawC6k+3uqF0mOba5IPDgrfCAg07t3xOh+aXHuhx0d+AebpIX1hFEAN?=
 =?us-ascii?Q?KKV2qJhqmt8ir2jGRn+dwNLV06OYNxFMu3w7B/QaLAZZBVwMcQ56IBkPSqQc?=
 =?us-ascii?Q?1LpTipE/1vU/IMzjDmDnOpvUcazs5FczYqZ/CRV6gad2AKAg4dmMIx98YaVD?=
 =?us-ascii?Q?4BGtU3wOiA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a904c91e-52ce-42e5-4c72-08da25d73ef9
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 09:46:03.3255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvawlaOAtWCriKvBLZGA/VtC41FG6S0/TCCLTU7XvawOvaA1+pHEY1pk9clitLgiteZ4TRUEb9msyFKghSagjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2925
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
 drivers/net/wireless/ath/wil6210/cfg80211.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 764d1d14132b..8f2638f5b87b 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1653,10 +1653,9 @@ static int wil_cfg80211_add_key(struct wiphy *wiphy,
 				params->seq_len, params->seq);
 			return -EINVAL;
 		}
-	}
-
-	if (!IS_ERR(cs))
+	} else {
 		wil_del_rx_key(key_index, key_usage, cs);
+	}
 
 	if (params->seq && params->seq_len != IEEE80211_GCMP_PN_LEN) {
 		wil_err(wil,
-- 
2.35.1

