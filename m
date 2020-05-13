Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66941D12BF
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 14:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731980AbgEMMdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 08:33:43 -0400
Received: from mail-eopbgr80117.outbound.protection.outlook.com ([40.107.8.117]:4078
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731734AbgEMMdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 08:33:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdLyWGMkq6EXzVZaaIcWqUekFVI2lBBpdPNaiGtN/yxza60I0fuSEELWv03JtNVmW8aUu0CiCcm5NYZW0GaGRlsoEB3NpngyRWOWcMcqzq4+eeJS/hLU/UEvoEkAh/9Dw9y0yl5zOImxhUlnMCTxptgbnel9sX/c/WTfKw3eZyZOVtiL/vlA2Q2rVJ++SGDQNshE7Ch0IqF2y5xed8UuTz1c5BCpApJo3Jg5lIpKh+ZhXwBm7Qzp+hoy1htuZVNFjHKjmIPm+QLG7Rlu5ScfKjv0qMtcZ07IygSwYj/DV0mXY3g8Iwexli7LgQHgBiinGlUowb9D24ozKFsMyvC2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnOZ5Q94ZoxKaQ14p3kohNJuQJj5DqmuEfjDUK1wTMA=;
 b=kjoee+cvHFpwwowp5WHXC15uk1xRFkSIRdgg2R+tuMZ1AKU4mUeSWAsxHJTzYIKm4sZA5xamgl80E5M+Z5qpr2CQMhD+R+7SB8qotz2KjkPCpbFJdlji5tD4OwRsXXpplhYCDT8pBWFGYLr2/pyAfviMdk/AE/1P+UThtQHGd8xjLsGci9suGVxXuM5lemCa0bir1hCFsZBhPsSpRSTsDyrUv6/Rzw1wKH6LGfbJZWcGTdKruUbvJm58QGHZ86SBpzTzAE4fsG9xGq43Skl5uXXuLGuhi8++CL1MpP9ZdfBMvSoEaZWNqcskVYsAsv5Axo659z+5B2nCORJqAd4Sng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnOZ5Q94ZoxKaQ14p3kohNJuQJj5DqmuEfjDUK1wTMA=;
 b=HN16+RshoeZRaKx49wvBjB5cKp5xVt3NrSr0NCuZGJQVN8z8zcr6no3PDrTt4WGy9Vf2vORYDNiHj0qXVnuZl4syI2g0KRjMnULXbqBUVzhTuRzvuDcWnRPRB5SPTgrXNPwVx2oJ35abDITpalr7EA66D0x7s9dGZ5KXQG6GB0A=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6SPR01MB0038.eurprd05.prod.outlook.com (2603:10a6:20b:3b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 13 May
 2020 12:33:35 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3000.016; Wed, 13 May 2020
 12:33:35 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net 3/3] tipc: fix failed service subscription deletion
Date:   Wed, 13 May 2020 19:33:18 +0700
Message-Id: <20200513123318.1435-4-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200513123318.1435-1-tuong.t.lien@dektech.com.au>
References: <20200513123318.1435-1-tuong.t.lien@dektech.com.au>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0203.apcprd02.prod.outlook.com
 (2603:1096:201:20::15) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HK2PR02CA0203.apcprd02.prod.outlook.com (2603:1096:201:20::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 12:33:32 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82c061d5-ad73-4b06-d491-08d7f739da67
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0038:
X-Microsoft-Antispam-PRVS: <AM6SPR01MB0038B059FDBB24AEC470A32CE2BF0@AM6SPR01MB0038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w2ItD4k3fN7B0fb50+NJ/i7zC9xI/oFvbzM7N5Y/KGElrnMliT+egHLRRTRVbnZHlN86HqXbbr86uza7vhvOrJU0sBcgOstqN35LMMIva2kMFVEu+b28LB4nAKyTcoALiqKMNrBJwIIp9nqXabehy+X5JiRvo6R1PclI467z7h+Vc1BbAJKAShBYpLtB/VVtZ0riJGLRvUPVHG3BoMx7QofetyIiKdlfM/r3MdDwhIPrJuK0Q3T7ATcSGzbUDeG9DKaZzf72+jBI54gJICN9NamCvInbci16IaoE3lCJuLm0mwXzVF7Euga5VbdmW2QeTmcKmTHuuLaPCqg7fCMH8bksg7hK9XkPGNTSTdiR7I62dpPFqJ0fkrM1WAeaJQnAYPX287AsIvxaYh/rU//Nz2BjttLXfh7PaWbp7WfGww4Q2MJUcX4eNOKAw3lnaXaDjAhKTin6/NL4OJdtNixiS555X/Ll2AqaWnMmmjhfXA3badWycaUFRmRhQcEZMgh5zQVsrj13Ki5GiVjEHRnrUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39830400003)(396003)(136003)(366004)(346002)(33430700001)(7696005)(478600001)(2616005)(52116002)(186003)(16526019)(66476007)(956004)(26005)(316002)(6666004)(36756003)(55016002)(86362001)(5660300002)(66556008)(103116003)(33440700001)(1076003)(8936002)(2906002)(4326008)(8676002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vrH7yePF+uT+4zKUPA5QuKidNYwtROTRO04EqfQilXzeVf3RlTZSqnqo2+YWUfGHAlgnj9GimAZaDqXPBmpusfex4dkAP8rXPtKd/Td2q7yNRie3SDPzWa/EQ6zNs5MkmE+NxHHaWOwO9WYAlPmY2QCWDVZ80cWDUMAHhAKLPhB5/JueKuz9TdMtu7W73l/p+mFHWdOLBI8J/GT9kvMwM6igvFjpt17WvzNAA35+gwGIS17Z0KODLOQTJSc6mYN31KzUQjf0QmRZRV9ZAHQSmUqwky0yX+RR2xO26rF9wvNgk7PQqO5/Vt/MI7AGc24ndIdMZ7KZ/LUJguyuUcGZSzuuUjpU/HRyquyEUUHnH9x74HQZvsP06L2UtyIpVsI7Bd14xdEfP7kc6n6EwDl9Sc9nKz+l9N4xvG9osyz0s2vJKoohFdipmNw40pAqvwtjDB+3F0YSHIAWpMMMQcRAbaFhYqzhb4y0NBbINsj/5ko=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c061d5-ad73-4b06-d491-08d7f739da67
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 12:33:35.0366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aETGLiA0D0bU/pyjVmExnUwTJshNUbECJv2oyYr4bOapP+wxM6fBvBRBz3a1Tqe4xEHPO+1zoZX9D9sBSEgGLSIM8dusy59FT71HR+QZF64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a service subscription is expired or canceled by user, it needs to
be deleted from the subscription list, so that new subscriptions can be
registered (max = 65535 per net). However, there are two issues in code
that can cause such an unused subscription to persist:

1) The 'tipc_conn_delete_sub()' has a loop on the subscription list but
it makes a break shortly when the 1st subscription differs from the one
specified, so the subscription will not be deleted.

2) In case a subscription is canceled, the code to remove the
'TIPC_SUB_CANCEL' flag from the subscription filter does not work if it
is a local subscription (i.e. the little endian isn't involved). So, it
will be no matches when looking for the subscription to delete later.

The subscription(s) will be removed eventually when the user terminates
its topology connection but that could be a long time later. Meanwhile,
the number of available subscriptions may be exhausted.

This commit fixes the two issues above, so as needed a subscription can
be deleted correctly.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/subscr.h | 10 ++++++++++
 net/tipc/topsrv.c |  9 +++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/tipc/subscr.h b/net/tipc/subscr.h
index aa015c233898..6ebbec1bedd1 100644
--- a/net/tipc/subscr.h
+++ b/net/tipc/subscr.h
@@ -96,6 +96,16 @@ void tipc_sub_get(struct tipc_subscription *subscription);
 		(swap_ ? swab32(val__) : val__);			\
 	})
 
+/* tipc_sub_write - write val_ to field_ of struct sub_ in user endian format
+ */
+#define tipc_sub_write(sub_, field_, val_)				\
+	({								\
+		struct tipc_subscr *sub__ = sub_;			\
+		u32 val__ = val_;					\
+		int swap_ = !((sub__)->filter & TIPC_FILTER_MASK);	\
+		(sub__)->field_ = swap_ ? swab32(val__) : val__;	\
+	})
+
 /* tipc_evt_write - write val_ to field_ of struct evt_ in user endian format
  */
 #define tipc_evt_write(evt_, field_, val_)				\
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 931c426673c0..446af7bbd13e 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -237,8 +237,8 @@ static void tipc_conn_delete_sub(struct tipc_conn *con, struct tipc_subscr *s)
 		if (!s || !memcmp(s, &sub->evt.s, sizeof(*s))) {
 			tipc_sub_unsubscribe(sub);
 			atomic_dec(&tn->subscription_count);
-		} else if (s) {
-			break;
+			if (s)
+				break;
 		}
 	}
 	spin_unlock_bh(&con->sub_lock);
@@ -362,9 +362,10 @@ static int tipc_conn_rcv_sub(struct tipc_topsrv *srv,
 {
 	struct tipc_net *tn = tipc_net(srv->net);
 	struct tipc_subscription *sub;
+	u32 s_filter = tipc_sub_read(s, filter);
 
-	if (tipc_sub_read(s, filter) & TIPC_SUB_CANCEL) {
-		s->filter &= __constant_ntohl(~TIPC_SUB_CANCEL);
+	if (s_filter & TIPC_SUB_CANCEL) {
+		tipc_sub_write(s, filter, s_filter & ~TIPC_SUB_CANCEL);
 		tipc_conn_delete_sub(con, s);
 		return 0;
 	}
-- 
2.13.7

