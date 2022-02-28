Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F0A4C61A0
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 04:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbiB1DO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 22:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbiB1DOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 22:14:55 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300121.outbound.protection.outlook.com [40.107.130.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED13646B3F;
        Sun, 27 Feb 2022 19:14:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuBG0uEblJBc++0ouWK8f8wSn7Fg7YfH1vgz/D8e9wfnAXeHIutm+UqNO+vz7Rund/7nWk4CAZWLSQJwFIhO1laCTEIqgio4zPM8ogk2S0yMn7nC4B7NwytTrrx+L3nUPbWcLx27EoIwgjZCuUIpd3vXMK8KZRA7F2TqLf+L1MRozqtiu8h1qkkkrKQXptzhCbMvlad3vQXEbWl2UQg/3BC8zQjsyr2JwcGF+jaoRZnHH1vspgLJsmMlJjheQhq0X23rVD8P5Cyib609nQs+jUUzyyPzif0VsgOZ6maSRdoRM8Ts4YVRnFwBBPydlsKgtQ5TYK7CbeEd84NJZtYpoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0DNclOOf8BoodO8eDyNRXKsEcYkfgq9VnKtS3KHcnc=;
 b=Jyy7xnxNZ1skNVy2geQgV+Gw9qBzgataAgK8ovytb2E+QqXtJpjI4TTkSCnwrbm4t9oy5y1JquZVwiI0v3XKf3bKZ8xq2bj9xKPWUeVBt3zTEBtZbSDmnXemVz03e68wY3blef03EQ2EcJvPCxcl82U/XSYIohHhur8XmJypeY7a2K77BQRbeFZFmBY3gYnDOezEo1aRojlRR785S0e1qa8uEu7SDNvx7966BxemE7S1WINLLWSlG5fmdS3N5VEpeuyHw+6oWhIQm0XbS0eULqYbUHc/EFG9IWICZ2MkNDvoc7asQ7sSyScvbZoykvih9iuIUVxNu+g+YwP/McNdIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0DNclOOf8BoodO8eDyNRXKsEcYkfgq9VnKtS3KHcnc=;
 b=FdwVzbT4Gz+u5cQcFiIGZkMCv2T998OsF/sSMaIbgrFIwukzj6wfX9VPiTBPBhWzi6n9aFxx3Hv0hjZqpdyc+ZBy6L5wkvWa+N4pkOkkzhiYdoquYLzQ6K/hPH/dYhNZlRyLadeSBnyicD0FPur3Rw0OH0qi7afPm2T47cx2rlE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by TYAPR06MB2191.apcprd06.prod.outlook.com (2603:1096:404:25::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Mon, 28 Feb
 2022 03:14:13 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 03:14:13 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: wireless: marvell: use time_is_before_jiffies() instead of open coding it
Date:   Sun, 27 Feb 2022 19:14:04 -0800
Message-Id: <1646018045-61229-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:3:18::29) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d24ab06-db93-42fe-0ab9-08d9fa686564
X-MS-TrafficTypeDiagnostic: TYAPR06MB2191:EE_
X-Microsoft-Antispam-PRVS: <TYAPR06MB219140525D63E49F5F45C071BD019@TYAPR06MB2191.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LTkiWx5LdYPWPMD4RiuNOl/zvJiKGCSlWbyCbv+GI4HV32rVIrBjuknT7IhOnhNiXaDaIW9TLUfkIwQtDCGackygJ5V7GQwXdKSsZzZU4OwTOmA70UYCbSbk1mlwqycUevjoBjmH5AJmLZb2x0/v2IdNh+rKGTbHgd3N6ihRpqQL+gJdYASFKZbjuPcUUy7Rh+wml3GR7G/O71PPwB9sVWizDIqL8sYyj7KCoxP/frjAuIx41T1V6LK9jtMN1VPaUZHOkqG6C1YsSShwosIJcR2R61imCffpNm50IvUQZbzeJDW5IqnKuYsiriZ1LrljWTA1ZCzimGNdh/Cibyx/bGQgq7sZd1Z05U28rPpw1URE1+0nDizEdtDugxTAuOxddonVfRt+tnCLi7A9i1F8qttN/9iNGpfo1S1eorfxnzvMoP7H+47hcOsuG7KScQcjDS59lKB+ivZxGPnPMZxCytVYe3Hyyyqcuj4/yN4GOyMhQyw6RZva4ZCtxRjpcF5HCpuuduBxCy2ifG5hbgvC5HB442akwxyPNo3TX0zKvk9HURzdoOSr3bCEBapbGf7yqfDGMIxvfQvqUy+2uEvXYPUWtzWQcaQ8ZlnTfzGS8h9EAzQLvkAi9R/xqdRWu++pWyJnfptPFY22jlzdJ4N0wNjMHyLUj5NZCOlLwYLwTDxQqUgYxgdnEopr0w9E0nBSPtmSLbzD4zw+3YEGvCoQ7GZStFCysDUUJ9HRdzNIR54=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(107886003)(6486002)(6512007)(8676002)(8936002)(4326008)(66556008)(921005)(66476007)(508600001)(6666004)(36756003)(83380400001)(110136005)(7416002)(2906002)(52116002)(316002)(26005)(2616005)(86362001)(186003)(5660300002)(6506007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n/JPeYcmEwtu7/U8yGBNhYawKxHJSXgKnftDlsiN8iotKA3tvW9+iaoU3X22?=
 =?us-ascii?Q?vsdYAdzhc4AV8NC2QrP7Aemfw87jopcMHxJ82sv1OT2AahPoRQtzwZoihSIU?=
 =?us-ascii?Q?N1i+oWybb7FkwlnlUw+T8/X6v+jq/NQVmVsV+jbYyQGo7uG1CkONP647J5VV?=
 =?us-ascii?Q?PCZQm6SsIbdtFw3m/jwJMD3RreE/7ZG6bnRye5Wj1zxVHQQGSlHKBZJC5qQA?=
 =?us-ascii?Q?EIp8CZZNzsj0pSDLla/q7CDNLPo5l2a0hneNVLrwMS3x+Au21xJrpQpfh5Nv?=
 =?us-ascii?Q?FccTsnyjlW+01sporPxJQztlBJ/jj/O7xABfuFX/N1UDcjih0FlnDvOIQwvC?=
 =?us-ascii?Q?AdK7WSA4wmgO+ky26k5SyjnG8+J13pPKcu+okhM1Fd2Xufg6f6BBZ3bFwZuQ?=
 =?us-ascii?Q?ns9pCZcJbR9eQ5kkA2TocWBDqlXmBrWSr34oHEm2IFyb9KTcWc0jn9sMpiT8?=
 =?us-ascii?Q?Snuu1yPodgaHDBPC/yYXq1cP4MvChjy+ala2AzdV9rNXQJa9jIGhkjqOHugp?=
 =?us-ascii?Q?bDSchhZ+da386OMkNxi8sFC5IuQu+U2RNgYd6lFDtDYS6IvnVYiKtft7nJIA?=
 =?us-ascii?Q?VeF/wZRfJwCms24gMEiPbLaZfK4hMp6KSBzV/Bs2+uY+WSUBYbW3XmK/4i23?=
 =?us-ascii?Q?KE4zZ9sncfaB7CUb35wwri8xaPtW0saXRXoSLwaGIEPpG3KchR08uAIMyOK5?=
 =?us-ascii?Q?1/7w3GfAxn4cGD1OJ8Gh2HuyHwRiFH50dpKrjmUrzfnwc9XZi1OvGdAxpUFK?=
 =?us-ascii?Q?4IVPMEnmJuHXlBbFJnowi5l6XDwlI9l7DG6vfBaQ390+KVJfGXarWADIgnLx?=
 =?us-ascii?Q?hPU48RKDyt4Tb1iVwqWJ1McL25yhZesxDd0Kh4X8X3gJ/XgwXgG5HzQpLi1Q?=
 =?us-ascii?Q?mfOlyaONvLAgNhqLkfAdl77yb45amxBvLFWorq9RD0X3KjJSLHKxrSYu60H3?=
 =?us-ascii?Q?XBGZpYF7WJspo8fSXyJsFygyZpW5YaZ2rXl6NvmEWQlV4hfuJtaCiAV1ImZF?=
 =?us-ascii?Q?ws6oJONttusuDoIPIEBl3yoZfW/+EMXvEMBWGj2iGtLJWQbg6v44CjLUCtvM?=
 =?us-ascii?Q?+gwJtgnZogwFHZr63LyOHtu8ObhO91tiOHLMpGW6j418oH/A9ekC3Pz+BzrM?=
 =?us-ascii?Q?w507d928uruQFGVYxJNQz9+L633xzopH3VPPfDd6425KT11LL2okUY49lMuj?=
 =?us-ascii?Q?wNzf2+BnnrJ/GYA8xSBb/yJIlvdyGAOD1Uhw5Rj4m2t5yqq3YEhgsgE3n8SJ?=
 =?us-ascii?Q?fPI2lmJC4uUUtiPGcSFGDNsUQCU/EMStOtwIWOInz+VJR7QphmjrUAJbUgXc?=
 =?us-ascii?Q?fS3zyCXgqySjewXp5ccDCSUN+oT2e3VIOWz7OUVu5vSGS27am9i80FvtaQ/s?=
 =?us-ascii?Q?yJSNJT4XRhJSbpIgxkaSbF1nt8aIOmNLOEH5Ie0aoXQKdU0WH494nAAo19wJ?=
 =?us-ascii?Q?UeOrkBWxzN2grnx0KDJ7KRC3gTT3SRk/e2Km77UGBUTQzhGEDPeOEg/OE5CS?=
 =?us-ascii?Q?/UYumcVCT0mT1bTI9g5e1HLi0z2qOSrntoAdJZQUfUpeaXBA6xHiJU1ylIi2?=
 =?us-ascii?Q?vyaHcwlyUQZllfaOGNQzq+fp4FIJhkKdZ/qG9RQkGBmwPirBQLICA6R1PUP+?=
 =?us-ascii?Q?jqgI//Q81fkbwukFJXaXgu4=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d24ab06-db93-42fe-0ab9-08d9fa686564
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 03:14:13.6264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4AbY00wYFlMJITiR4j1ABjMk2Ld++bzzGP+C7+TiLVKL57iWOnEH7YtXakHeN6EKg2BlKVV85BciZwFy9VX0wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR06MB2191
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

Use the helper function time_is_{before,after}_jiffies() to improve
code readability.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/wireless/marvell/mwifiex/tdls.c | 4 ++--
 drivers/net/wireless/marvell/mwl8k.c        | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index 97bb87c..aa77fc3
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -1436,8 +1436,8 @@ void mwifiex_check_auto_tdls(struct timer_list *t)
 
 	spin_lock_bh(&priv->auto_tdls_lock);
 	list_for_each_entry(tdls_peer, &priv->auto_tdls_list, list) {
-		if ((jiffies - tdls_peer->rssi_jiffies) >
-		    (MWIFIEX_AUTO_TDLS_IDLE_TIME * HZ)) {
+		if (time_is_before_jiffies(tdls_peer->rssi_jiffies +
+		    (MWIFIEX_AUTO_TDLS_IDLE_TIME * HZ))) {
 			tdls_peer->rssi = 0;
 			tdls_peer->do_discover = true;
 			priv->check_tdls_tx = true;
diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 864a2ba..9efe825
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -24,6 +24,7 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/workqueue.h>
+#include <linux/jiffies.h>
 
 #define MWL8K_DESC	"Marvell TOPDOG(R) 802.11 Wireless Network Driver"
 #define MWL8K_NAME	KBUILD_MODNAME
@@ -1880,7 +1881,7 @@ static inline void mwl8k_tx_count_packet(struct ieee80211_sta *sta, u8 tid)
 	 * packets ever exceeds the ampdu_min_traffic threshold, we will allow
 	 * an ampdu stream to be started.
 	 */
-	if (jiffies - tx_stats->start_time > HZ) {
+	if (time_is_before_jiffies(tx_stats->start_time + HZ)) {
 		tx_stats->pkts = 0;
 		tx_stats->start_time = 0;
 	} else
-- 
2.7.4

