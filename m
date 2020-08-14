Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C29244A46
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgHNNRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:17:51 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:48226
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728253AbgHNNRr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 09:17:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibWPZtRNOKlO3+sgL2st7Xs+GCQaCG1+kMrRkCvpDot/CSdktjWpGgWWojWhpxc+VS4EXgbS+RJabDwQtYhFer+ElVNXoQ6+mC9oJt+8WfHNt/WNNcMrhers6F00qBAT9nt7WDiIQCHK+rhWlRQIUiSVYFUWr01oJJsQZKshyBOUZl+Br3CaUluorwuWsEz12ANyHLW36wGDu/LohBoOwmMqIMOGvZGsFgzJwzyckMa1PNiR5I1PVF9ATsmf4ndpVdZlWokB7R7NeClvZHevcYyA3vjCI38RLb9YJ6ctoDXOkVG6cGFZWcAvd9q9+VtZi4mvRH9aFSqfxxD44x6UwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWwNAHQTeZNwb9EvL1lF+heVnrt0+Rtyl9tSsUkRvqg=;
 b=MwtJHsJnJgBqQDZXJy8ymFxEQpfO7lFonilMYhTHKnstqrqXSXh0uEoMX6OycXBaJ2FxPWhX7rVhfKa+raJSGt4cXQTtHZjw1noefV9saRwJZ54bRN6cVsUzDR39V1Dqc3Cic1YfdUvZ+Kkc+7K7XBlTB78ZIInH5jt5CMRp4cNnM+1aG5mPLNBU+1aIl3gxlrwNGOnKUCmI8bue/KbnDYvFerch923M6eW2+Fmz5CgPdAF4t7x9Z+6VubeWoLzVgBv/rIDJqFjBSoFR6wIQgk2awBIilCgILhNgCshe0uLcC4lOn9lso6L98wRVtom2QnJYUnqkKB8jSjJGQ2vxsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWwNAHQTeZNwb9EvL1lF+heVnrt0+Rtyl9tSsUkRvqg=;
 b=Fd9R7D4Va5lpevMIRdD3HxgbG2H1X+3xq91GgGJfgElxmQgHErCfBSjn/+Iro9007h5PhKD6gVJ17xPx7Gg1sSuug1jLFg/c2+eUho4xzwURHCf56GEp6exIFT6tzL5Z/XP7GdATVwOjbFtlaQZwdC727eceXYuHSP+hBNBfXpE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR0502MB3605.eurprd05.prod.outlook.com (2603:10a6:209:7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 14 Aug
 2020 13:17:39 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3283.016; Fri, 14 Aug 2020
 13:17:39 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH ethtool 2/2] netlink: Print and return an error when features weren't changed
Date:   Fri, 14 Aug 2020 16:17:45 +0300
Message-Id: <20200814131745.32215-3-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200814131745.32215-1-maximmi@mellanox.com>
References: <20200814131745.32215-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0156.eurprd05.prod.outlook.com
 (2603:10a6:207:3::34) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM3PR05CA0156.eurprd05.prod.outlook.com (2603:10a6:207:3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Fri, 14 Aug 2020 13:17:38 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 89084255-624d-4925-0a89-08d840546aff
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3605:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0502MB3605C43FFD82A0D3B696DB6DD1400@AM6PR0502MB3605.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zowSy/dWv0XDr4xjP/k/wuvhtgIYL+GHePwbwRTFCGtuomMMOa3kwmHbttE3ZHdvvVlMrTxPPGed1RNBRBaQdfNA+KS0MXUyNhM73jpIJSuGmOHLOhccuDd4JgKw8mNGYHRo/guqnWlfHbnWgd4oztjpX5yma/3KX7Q4bTL4Pb+k9evbk0pZcLLo53PrVL9kicgsymVldzyX7u7W/9kxix7fMuNUrJrVqNLkVEf1e1/nIO4HRz0SZgWOZdM8fwv+nLyBPOuYaxFICPQWfdjLNiuh4QV8KEDRIsJCxbwN/LP/oQnSQ3CRxgLui6UcVktt4zU4bZ6xz3gKdYyF+yJ3Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(6512007)(16526019)(8936002)(186003)(6666004)(6506007)(36756003)(83380400001)(1076003)(26005)(107886003)(110136005)(66946007)(316002)(54906003)(66476007)(66556008)(8676002)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(52116002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1S9XzzGawcZoM5ylJeC9D/eehSCvni5+MwKdGJVNRVWYjhiuvokpzNLzhoGgSuHkG1R2pDWGbfZ5ID4WF1FFqF4xKJaB4ijNaDP+XIudEe8BeuxiXk/9wlUTLfLB/zJfkc8aSaZWyCQ/KJEa2MD9ZiaYSb/EX7X1VINhRQ1oqPyiImjDh6XAxpCAfFkMKAHWh3opae8nmqy6J/hBzmTZcJ7Fj2Y0BBbJ/58Jad9dZ1C/tPp7947H5lUSBBYdxMAZXwkM6fFrMF7qtOZn/Kfn1dZl5mRSNFcqpM4AS1LSvynHymlxB499QZNWqq84N+7U98fMs6WtuZ8h6ZPi8pXFReZridJRYGp2pCnaUaDn+adbKeXuxdJhps2PGJlxpxpWJLwlbkFg3RfyPEgMfL6t4q/VKpSNJfjtwAoNi+WMd9F3wwpLUXU//ItvzBZbGKfnOoxiTeO3n8U7rK1nwY8oJ3QjOIRuE/ZUEcMfCohSga2ex+YZG8E6We9hUusgi2cT9cf34tLEETOBwwOX4sOk7st51jgSrp1cOFk2+Y9cGWETycENPoz1BQE23oS02TKeyXvK3pvmETwji7JGIzI3U/o8Oo0CnL2nWB11KttU/cqY2gVatiaBuRl67K/D26JHjfZXoYJLETUwhlbS0Dm/lg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89084255-624d-4925-0a89-08d840546aff
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 13:17:39.1313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4YRXB2qvYmDOcI4rh/snYEXUdWNKlZHs+KDUuW5eVHg/ZIBgIdG3y/yPMHXJFNL0/TcAflYDU9uwpeGklH9Vig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3605
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The legacy ethtool prints an error message and returns 1 if no features
were changed as requested. Port this behavior to ethtool-netlink.
req_mask is compared to wanted_mask to detect if any feature was
changed. If these masks are equal, it means that the kernel hasn't
changed anything, and all bits got to wanted.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 netlink/features.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/netlink/features.c b/netlink/features.c
index 133529d..4f63fa2 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -378,7 +378,7 @@ err:
 	return ret;
 }
 
-static void show_feature_changes(struct nl_context *nlctx,
+static bool show_feature_changes(struct nl_context *nlctx,
 				 const struct nlattr *const *tb)
 {
 	struct sfeatures_context *sfctx = nlctx->cmd_private;
@@ -388,8 +388,8 @@ static void show_feature_changes(struct nl_context *nlctx,
 	const uint32_t *wanted_val;
 	const uint32_t *active_val;
 	unsigned int count, words;
+	bool any_changed, diff;
 	unsigned int i;
-	bool diff;
 	int ret;
 
 	feature_names = global_stringset(ETH_SS_FEATURES, nlctx->ethnl_socket);
@@ -411,12 +411,20 @@ static void show_feature_changes(struct nl_context *nlctx,
 	if (!wanted_val || !wanted_mask || !active_val || !active_mask)
 		goto err;
 
+	any_changed = false;
 	diff = false;
-	for (i = 0; i < words; i++)
+	for (i = 0; i < words; i++) {
+		if (wanted_mask[i] != sfctx->req_mask[i])
+			any_changed = true;
 		if (wanted_mask[i] || (active_mask[i] & ~sfctx->req_mask[i]))
 			diff = true;
+	}
+	if (!any_changed) {
+		fprintf(stderr, "Could not change any device features\n");
+		nlctx->exit_code = 1;
+	}
 	if (!diff)
-		return;
+		return any_changed;
 
 	/* result is not exactly as requested, show differences */
 	printf("Actual changes:\n");
@@ -442,9 +450,10 @@ static void show_feature_changes(struct nl_context *nlctx,
 		fputc('\n', stdout);
 	}
 
-	return;
+	return any_changed;
 err:
 	fprintf(stderr, "malformed diff info from kernel\n");
+	return false;
 }
 
 int sfeatures_reply_cb(const struct nlmsghdr *nlhdr, void *data)
@@ -471,8 +480,10 @@ int sfeatures_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		return MNL_CB_OK;
 	}
 
-	show_feature_changes(nlctx, tb);
-	return MNL_CB_OK;
+	if (show_feature_changes(nlctx, tb))
+		return MNL_CB_OK;
+	else
+		return MNL_CB_ERROR;
 }
 
 int nl_sfeatures(struct cmd_context *ctx)
-- 
2.21.0

