Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6614226AF
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhJEMdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:33:03 -0400
Received: from mail-eopbgr110098.outbound.protection.outlook.com ([40.107.11.98]:6170
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234303AbhJEMdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:33:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEFb/JBs3qFKw0PVHiJEYWNcCvxvA0fCXUTivyIc/R5vtZ6XwYW1kfd+xzs2gjG3+2jn0ymGiUkOmEhI+rebUQS+nwZa3y1MaKgv7Sn0LXRifluBgGiW0RRWQ3Vhrw7beBgL0uMWV6+LvvRJhFgCo5CZVHaRpyRpp84QY5lq6Yw8yLpsMtncGmznE6scO7hNeMcCN4J47dFcrgrctAB+gGW/GssfoESiIKRPu+OJ4eug7IwN4q+wJ7ideqm6a483S2/Mh6iWqoU0YVLjGUFMVci6FSSSmpMZ5cuj0aHoBKwgRu96bsrTLKbQLWYr00DFognb0ygBksXdhAGmRUJtQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47QOp4OCwurkL1kJ4wbU8D/xrWkyWJVBeDH53wf9KdQ=;
 b=C1tR1Mi2lUWEy0egQ3e7QS3UkZAeWGuvLq4pcqPNwJd/2m0o6cP5Ot0Z98wFN5IIA8l2EFGx1efXtOfTpGtr2ucv2onHhMpsBUsV/oQHUO0Ml4HczqMHVAZ5O9PTcNf71eMJaYMk0SfghiuaaWUdsqsglrHTLqPHhkkZfLjNq4HnDxlU537wX5FH75TbCUuxa2i0VAMuY5B8aMH3mrG+tA6PfMx1Sk07PvBUTVX28KbW/HHXqGZbxHABheFBn0jVIxHPOsAvt+ekf+hqPkLygiU+s4/fgEg0/CsQOX+DpehAnrJszWrnyJ6B+UAy4QRF+anIA7jKvlqoIhKvP5hELw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47QOp4OCwurkL1kJ4wbU8D/xrWkyWJVBeDH53wf9KdQ=;
 b=c+ZMXffX0phTgQZqmAnYjyhdMU+2r7H6d2whaDEX0lxOtyrYtttcXKnBsxWjc1NTbV/YkLPKYrYmA19gxYL+jFLIxcd+SZMGCN/wZZ1iabSx4MKVs4OZq34Y/KWgTqGIYiWYP/7cXnZYznrrKQUDTi94FDhUASvWoV/WG0jGfns=
Authentication-Results: purelifi.com; dkim=none (message not signed)
 header.d=none;purelifi.com; dmarc=none action=none header.from=purelifi.com;
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 CWXP265MB1862.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:3a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.19; Tue, 5 Oct 2021 12:31:09 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::544a:ff7d:45fc:f79b]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::544a:ff7d:45fc:f79b%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 12:31:07 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org (open list:802.11 (including
        CFG80211/NL80211)), linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH] [v18 1/2] nl80211: Add LC placeholder band definition to enum nl80211_band
Date:   Tue,  5 Oct 2021 13:30:54 +0100
Message-Id: <20211005123055.13697-1-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200928102008.32568-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO3P265CA0007.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::12) To CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:bb::9)
MIME-Version: 1.0
Received: from localhost.localdomain (46.226.5.242) by LO3P265CA0007.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:bb::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Tue, 5 Oct 2021 12:31:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b74ae503-8c6c-4401-108b-08d987fc017e
X-MS-TrafficTypeDiagnostic: CWXP265MB1862:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CWXP265MB1862E240914CDC858D947425E0AF9@CWXP265MB1862.GBRP265.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MT61uEEZpCrw290KG/VR7JOtI/ENEfKw58rxiQwmt6EYyWK/WXrHqrpgSv7qOEwiRR4HMoL0f76KLn5IxIOvTldbd1aI4ZZ0bLUGA1o3Ol6nwB/kGRTHMfOm/TKAAfqJ4lFc04xNLsaF4xMhzl6xg+HFiKfBufB4wD7pnIcc4KBWKg6e7mX5bnf8anoy7cKo5gZXPYv6PdwVgxWZAr3xtG+EfJB+otuUk7vILZHYtW2Qc8uv78WC1iviHcaK5ZH9Bp7mcyXAmraj47W5FRgWaPm3e9EUdiJS6ynLPOULISnm6lIiF228GE/PSEytA930m0Zb1i75GKH4GMLtJWKhbppM9aR6ipVvMnFftTsvDW47VUD9efKJdrYo1D8iMtiooVe10YLI1TWOLYP7uaGsMRldQhCAd6I73L+tqxhjOax55i2yh6hwIiA15s7jl+ZWr1k7J7MVmWLgl3WDJ7ObyBCCw0tDOPjucqieTOfv0oBiE2PI0hg4/T4QkmH08aG/TANydY03WsT48+U+KzKBo/gQjlA9Kf+3kJ5LaKD1/wAwLHwsM734BBN8FGv75m6DHUSog1Qxf0KAxwKW5fmYcSN/Y6gD7DPEXXJo1gVDZ1jrOJTOc5zVOwazdp+xG+4tUCnO3Ylig9gBXUFN+eTNIwDtdB9fzWPDpUVcq+PB+KKjvOJys4S+1trWP3bJuawtUigAPhFn7Ef/yKDlj97wEbpCKqYYXpXnKbpdzQy0tnA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66476007)(66556008)(2906002)(6486002)(36756003)(316002)(8936002)(8676002)(4326008)(54906003)(5660300002)(66946007)(2616005)(6512007)(508600001)(1076003)(38100700002)(6506007)(86362001)(186003)(52116002)(83380400001)(38350700002)(956004)(26005)(109986005)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rgYWHwg8S8LXvvrZAdz+/viCkr7PtqAI3ncg1gA/QeBklCQYUowY7yiFCsEG?=
 =?us-ascii?Q?8POiAOvHgwZWHydEpIWtUGUY+uRhl90eBC8/2Yf2gOrtVvnlIPwAjXqX/yvS?=
 =?us-ascii?Q?E3WVpLqiV6Lnr6zJqcKOjPnzHepSbFdkRLWwkHcwiW5CwWh5FB4fjgT9EUK/?=
 =?us-ascii?Q?3i/3/jVIp4FxCiBVP8iOOEpOupTJrsizdTODG/n4Q+FYnzGvjz7559GuIDUp?=
 =?us-ascii?Q?NXbpk/KHopFvizxIpulCpZGioePm7IDQTj+GL1ObSsQ5mQYYPapoe56466MT?=
 =?us-ascii?Q?n+KGFkpY0ca6n26szyFIZhZLE6BTpxGA6lt6cXpx9xy9G5Vh53RcaRAUIJBM?=
 =?us-ascii?Q?28lgdbgNegLruuHLSxLIqQgzTPuwFbm4eO4bgnmslmM+DtHlO49BpK5tafdA?=
 =?us-ascii?Q?KpZyztTIrCMn6BFcRdVyxieFt7QpmiLRGXBkjWXTpp0YpT0kDAhFqa9tE0fU?=
 =?us-ascii?Q?ZsJplpQoMq2CP9ZVKXSA3Rw3jmU/9+RGJnHFD4XwIGvOEzvsqHPJ4g/JqDa7?=
 =?us-ascii?Q?wz2+awmf0W2pSPWw/XuAfLtH3H17N8ceE81sMZb8X/v8N0TTFhcY9LsTC4o7?=
 =?us-ascii?Q?haVY9K4dwClcJSEZMB2Khu84onsH7vDMJWXAa6lKr3EgANYih5M7fLcAxh64?=
 =?us-ascii?Q?fkHj+5g1+0JleI+/gbq5ds5rt8QwWoiYQddfrOIkHw3XCysW6dJxagk2w6XW?=
 =?us-ascii?Q?fcO/rO7ioeFdyAK1BZNqdG2+pJGguCSkAgj9lx2Nq0FtovLzVLXfp3Plf1z2?=
 =?us-ascii?Q?DVPstZGBR5+5JOyoxMkg71YJ3x3n9xCY8PMqH+xyXgu21neqX2tsGXt4Qvbx?=
 =?us-ascii?Q?1TylwuMAZw1RYY6GQAHyirnw+XMaanI5KRmx/uuAMbxTegOpA05ciUP2WkL8?=
 =?us-ascii?Q?3/SO/b77tfbU4+0R7WEYCynfhUDlS/6wxrGmcOEc4hEk1WJHLTgkb4FHfQpz?=
 =?us-ascii?Q?x0zW5/bdGExAUyX0TTDmVpxqvaOb2ggtN4bfZvjtTybR9aph76/Gn84L2K79?=
 =?us-ascii?Q?mDNz7KGcIOxacqX3uQ175PT+mQaEqZoyPR8SWvGtFtN7MG5nRwbMW0/moOF/?=
 =?us-ascii?Q?1gK9UPkPIpnuk16U2iXhEmIlYPTuiqIBkUtTbSUt3viuugyIjscTBCmgqfhw?=
 =?us-ascii?Q?f3jMkl9eUD0WDirTdCNRq+vpitNZ7iiyAygrVKvjpQw4e3UhmOx/Rs3DCr9F?=
 =?us-ascii?Q?g/J2YzK4C6HJGB5TJ9zt7xudl3JDPqItKjSiTueNFNzxuG8m9yvWXSI6ooI2?=
 =?us-ascii?Q?GuWjK4GraFhjJT2sJYgZVMUvwSXcRgawmWn1ciWkAk+6aDXQPuXXo1t6vQL4?=
 =?us-ascii?Q?xqvVG2te9H8sUQ5To7aKrdNu?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74ae503-8c6c-4401-108b-08d987fc017e
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 12:31:07.7547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fa3i10Z1jG7gTZv6zAVr31BVovHwJW5YFVmge3cg/q1XLXtaEVu53Efe2zB6Zmwsgjrcxm2MdlLrB1p+u+4GYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB1862
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define LC band which is a draft under IEEE 802.11 bb
Current NL80211_BAND_LC is a placeholder band
The band will be redefined as IEEE 802.11 bb progresses

Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
---
 include/uapi/linux/nl80211.h | 2 ++
 net/mac80211/mlme.c          | 1 +
 net/mac80211/sta_info.c      | 1 +
 net/mac80211/tx.c            | 3 ++-
 net/wireless/nl80211.c       | 1 +
 net/wireless/util.c          | 2 ++
 6 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c2efea98e060..cb06fb604a60 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4929,6 +4929,7 @@ enum nl80211_txrate_gi {
  * @NL80211_BAND_60GHZ: around 60 GHz band (58.32 - 69.12 GHz)
  * @NL80211_BAND_6GHZ: around 6 GHz band (5.9 - 7.2 GHz)
  * @NL80211_BAND_S1GHZ: around 900MHz, supported by S1G PHYs
+ * @NL80211_BAND_LC: light communication band (placeholder)
  * @NUM_NL80211_BANDS: number of bands, avoid using this in userspace
  *	since newer kernel versions may support more bands
  */
@@ -4938,6 +4939,7 @@ enum nl80211_band {
 	NL80211_BAND_60GHZ,
 	NL80211_BAND_6GHZ,
 	NL80211_BAND_S1GHZ,
+	NL80211_BAND_LC,
 
 	NUM_NL80211_BANDS,
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c0ea3b1aa9e1..c577d03ab128 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1490,6 +1490,7 @@ ieee80211_find_80211h_pwr_constr(struct ieee80211_sub_if_data *sdata,
 		fallthrough;
 	case NL80211_BAND_2GHZ:
 	case NL80211_BAND_60GHZ:
+	case NL80211_BAND_LC:
 		chan_increment = 1;
 		break;
 	case NL80211_BAND_5GHZ:
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 2b5acb37587f..36524101d11f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -444,6 +444,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 		switch (i) {
 		case NL80211_BAND_2GHZ:
+		case NL80211_BAND_LC:
 			/*
 			 * We use both here, even if we cannot really know for
 			 * sure the station will support both, but the only use
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2d1193ed3eb5..d311937f2add 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -146,7 +146,8 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 			rate = DIV_ROUND_UP(r->bitrate, 1 << shift);
 
 		switch (sband->band) {
-		case NL80211_BAND_2GHZ: {
+		case NL80211_BAND_2GHZ:
+		case NL80211_BAND_LC: {
 			u32 flag;
 			if (tx->sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
 				flag = IEEE80211_RATE_MANDATORY_G;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bf7cd4752547..cf1434049abb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -853,6 +853,7 @@ nl80211_match_band_rssi_policy[NUM_NL80211_BANDS] = {
 	[NL80211_BAND_5GHZ] = { .type = NLA_S32 },
 	[NL80211_BAND_6GHZ] = { .type = NLA_S32 },
 	[NL80211_BAND_60GHZ] = { .type = NLA_S32 },
+	[NL80211_BAND_LC]    = { .type = NLA_S32 },
 };
 
 static const struct nla_policy
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 18dba3d7c638..2991f711491a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -80,6 +80,7 @@ u32 ieee80211_channel_to_freq_khz(int chan, enum nl80211_band band)
 		return 0; /* not supported */
 	switch (band) {
 	case NL80211_BAND_2GHZ:
+	case NL80211_BAND_LC:
 		if (chan == 14)
 			return MHZ_TO_KHZ(2484);
 		else if (chan < 14)
@@ -209,6 +210,7 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband)
 		WARN_ON(want);
 		break;
 	case NL80211_BAND_2GHZ:
+	case NL80211_BAND_LC:
 		want = 7;
 		for (i = 0; i < sband->n_bitrates; i++) {
 			switch (sband->bitrates[i].bitrate) {
-- 
2.25.1

