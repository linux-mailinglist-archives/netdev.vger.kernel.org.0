Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2212513DD
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 10:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgHYILn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:11:43 -0400
Received: from mail-eopbgr30053.outbound.protection.outlook.com ([40.107.3.53]:26110
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725890AbgHYILm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:11:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BukBES5qAZ1/awhW+uVia1TOoeAgveFdmC2d3EJ6YciPE8JpMHLs7GL9lnsmV3WJeilJrGDVr+didwKjTEmmc6Ab1pjorY8OvXdQe9q7a/ez9nCI5khkYjjKDIeVkRu/exuaD8NuCi2284+m3KHhRDoq+wlVDvWm+1lpfdLfEH0IQQDEJM8TA4FpyU2GcEi1yksT1HggjVyd7xdeqEAT3bQ72xtHJ80Go0pUI04idRXx2pxMFL6YXcCNrINGtS57d5XF/RqmoOh0yV3ucKibnH557XjxK8cQlw93etCuTpN+GBc9O09UqtSZnVbo8HDrSbZyGXSQqsV+fFckOclEFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZGYyglz/61xuRQmhabtlmrPIKwtk6P4DOqoPBm5TrI=;
 b=KN+HjSbrS43fa7JqEm7MgTgLaLY7+XUShggnEXu60hHxjcAI5qjy3D9ibZLHimW1fzH2YPy3Vt2HMhGMD057C4hyhR+14d7pgW72k8WKefIabEtrCTqyR44186VWsPFosiGiHR7xY0uI7NemwrgeByg3oDjMpxWax3vEk6Ma50lSzU14oeQu1O3tcarlM4ICbprhgb4/tnB5HgpitI4+4FAE+p7fYuqJtRyL//Jwi2M7wKIlLj1XDfNF5TVXkXpKmfbrxZa/nYQ4BNGi6XDxgfQ2Jphea0U5c4I31FpJ0MMI5W/Da6loohprjMKtEWrNnNZbgWBfkMMuGAelngPFxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZGYyglz/61xuRQmhabtlmrPIKwtk6P4DOqoPBm5TrI=;
 b=Aynb8bynaiDN0YKnUyi9cNPBDGZSHPlZgdYsQ7SpxLwa0vy0rjC3hG6m0Lbq2hq5iNLVzRzlE50M+F8v5iykeS26dAcF4tjmdnhly+3mHoZ15SZzjFRjTGGDkgE/0mtdKcuehTO6mayqzlSlmkvncoAU/YaT3u4TKEezsDNELXk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB4325.eurprd05.prod.outlook.com (2603:10a6:209:4a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:11:37 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55ed:7763:fda0:1892]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55ed:7763:fda0:1892%7]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:11:37 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH ethtool v2] netlink: Print and return an error when features weren't changed
Date:   Tue, 25 Aug 2020 11:11:38 +0300
Message-Id: <20200825081138.10855-1-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0126.eurprd04.prod.outlook.com
 (2603:10a6:208:55::31) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0126.eurprd04.prod.outlook.com (2603:10a6:208:55::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Tue, 25 Aug 2020 08:11:36 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f8bb384b-eb99-4aff-2e50-08d848ce7d13
X-MS-TrafficTypeDiagnostic: AM6PR05MB4325:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB43254414212AF55658A2F86ED1570@AM6PR05MB4325.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ESrB9vi2gdbYGNUHyvn2NePK1KTnQb/IeFxnpDK32cAbYMST1gr3iDeVr5r0YyBrEEc97A9gMkfGSMWcoZmTL71gx1SeaDNVx2h+xWCpxB37o/lAtyzFIU5XxnLFXPISk8eSpNODd2PWfTh4wrYftBuO7lAiJyPFqyVoHkrwITt6cr5167GVEgz1gZ9OYQ4CAhPisomRBr3orFE3RKUIl55HNhOGOEQSGx46oPTFEVGwfA8uhkAAufpo/tpk/gS0h/tS9GcaDENTmEFzXJ586EsvoqUssid3RYjkyjo+2XHXs3wybDakJ58YBSjONoZYOU3Ztk42pLiLjrtKNts6RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(66946007)(66476007)(66556008)(2906002)(956004)(26005)(186003)(508600001)(8936002)(2616005)(6512007)(16526019)(110136005)(316002)(54906003)(6486002)(1076003)(4326008)(5660300002)(36756003)(83380400001)(6506007)(86362001)(8676002)(52116002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kAy85TaZYCZ1pSRjUopiZQJ2naYn7hj+U1gE/Ue0UamLoPZ0bT0kIw11JMu9a1q+8t5O5vurtrFKB1em2Zbl6Qehz0dxYzucbqqZTUdA1sX6+rJEUP/hEjAzKTW8b+EjT7GsOzq+SVrsFf6ysZBg+YDQesnLUb7fKr5hGJeIJKdn2R15QoLvW1f/uBUjKDr0JkKu58ex/dY0CHosWbFKP0r7wD6x6KBRvKrhoG8JNl+JhXDs/Lr7zYOsX3x5phuOC8mZuiEniDC5aMxO5TtteQi6xvvDMRSVOXT4c0UvrInHh3+UiX37m9qwRo4cAJ8ZWT/N26PQ31giwxt//Np6mjnyznbk+Iajvvzw4RtVykcGhQFhQqzALoGfQFVAD1dRg5HvFJzxTa6ir0HggFAX+ebHEr+CQ2lwQ5sKHTam9OR2fXfMNwFtFSDIfSg02CzyzuTzo/ggRwvkfk0ms8nUvv/v6o9amlOMsVDvJzZkrHIsvrXHU50a2yGM3FUgq0o7ZAaPOrDaEViPBspgVwKyvfkAkc5K89ikKxup4AcORiPv4fRMhofRcXPHou2qYNBd0Qcyt3DVVIfy9g0bMBKo1Pw+VQ4u4x4j2BAjGLU7k3h4azEhKqZM9SJ8+WDxH3jEVgQIog2Rx/VBmw/4bPXjNw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8bb384b-eb99-4aff-2e50-08d848ce7d13
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:11:37.5584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ywm62MBxX86aMTzzZpwpjN7ARnLpX+GkqC3leUBB3CHMluUJgQG4cvPgzKZu0zv4Uefd02yubiR4Z9j6TtfkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4325
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
 netlink/features.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/netlink/features.c b/netlink/features.c
index 133529d..7622594 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -243,6 +243,7 @@ int nl_gfeatures(struct cmd_context *ctx)
 /* FEATURES_SET */
 
 struct sfeatures_context {
+	bool			nothing_changed;
 	uint32_t		req_mask[0];
 };
 
@@ -411,10 +412,14 @@ static void show_feature_changes(struct nl_context *nlctx,
 	if (!wanted_val || !wanted_mask || !active_val || !active_mask)
 		goto err;
 
+	sfctx->nothing_changed = true;
 	diff = false;
-	for (i = 0; i < words; i++)
+	for (i = 0; i < words; i++) {
+		if (wanted_mask[i] != sfctx->req_mask[i])
+			sfctx->nothing_changed = false;
 		if (wanted_mask[i] || (active_mask[i] & ~sfctx->req_mask[i]))
 			diff = true;
+	}
 	if (!diff)
 		return;
 
@@ -520,6 +525,10 @@ int nl_sfeatures(struct cmd_context *ctx)
 	if (ret < 0)
 		return 92;
 	ret = nlsock_process_reply(nlsk, sfeatures_reply_cb, nlctx);
+	if (sfctx->nothing_changed) {
+		fprintf(stderr, "Could not change any device features\n");
+		return nlctx->exit_code ?: 1;
+	}
 	if (ret == 0)
 		return 0;
 	return nlctx->exit_code ?: 92;
-- 
2.20.1

