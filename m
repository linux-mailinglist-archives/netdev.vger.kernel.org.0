Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E5A256B80
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 06:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgH3EhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 00:37:23 -0400
Received: from mail-eopbgr60108.outbound.protection.outlook.com ([40.107.6.108]:38946
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgH3EhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 00:37:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVwWpeXKA5jqN2zQCm3PPtlB1pb3eT8703UkHWUZA9QPdH4GXtyiODJAEYsXtUls+RkvVaAvuIIPrce27FVYSQv/QMVrIo8ZXB5mMO2w6Gl1jjIKHJo+JdcoH/8zmevI1Hjvn+GUFB9hfXE8OEWoo95uf0b/jkAx9aM+u7KWrJKjrJllOdn7N6sh0HUcYVUJxw5jG5V2PHN6nWJ44qodng6f57autW9OBkLqQZClxcQjmC8B6r3nReAZ/WqS200zJAD585jtj86z8qdfY32ZmCvQC5JACVjrAhNtNTyW6OoT8/wWAaacKHn4xJgeJ8Z9ztxhE4pOZZJpiUzCFuFDnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxFzRarMKUcNE9eD1j0Q/IKWg+Q304LdcqennmZa6W4=;
 b=Vj0rHPE8prJic0v4T1IVM5CHLMLezZBotBF0EykmuweVfyt7wS2F+YMW1NR4YNoR85x/gtEWdDQfKEl8hRdShuUY8oRV2LaquAqN90JhGCQ23m6CvFu5r/P0wzjBzbYt7EuurUSzFZc2GVT2HX9JJhF6LhTurF7UVinGUdxuHA+jlAW9WgZLRvzQR9md5vxuZnMLsuqCrpVxneKOZM6+grR4A7Y+reemjpn4YhqkN1T8paTmGBUH7R5wBNyFqt3f7fGfUyzQZqEXBfhTETevQ1s0AWy4bcq2MN+ZLAy3dseLusIXoeCf7Q7Gj5dD8O+2C2Qa18TZaVgxSK8sDjrpGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxFzRarMKUcNE9eD1j0Q/IKWg+Q304LdcqennmZa6W4=;
 b=nJIGV7s81K9mtiuFP6giRyamhvqFXthAVfCo2agg+9KXAxl/oSZo+zku225n6ePSwtgpPDuzDgFvL7kbsoej/akKgDc4GAGVWRYxQzpms1Y6RqKbrSIalzUH1Hf00Av2R1xS9xx1IoaAoQmkdU38CJUd6HpwQh+LtTxsVqqyXNE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR05MB5105.eurprd05.prod.outlook.com (2603:10a6:208:f4::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Sun, 30 Aug
 2020 04:37:19 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3326.025; Sun, 30 Aug 2020
 04:37:19 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net] tipc: fix using smp_processor_id() in preemptible
Date:   Sun, 30 Aug 2020 02:37:55 +0700
Message-Id: <20200829193755.9429-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0086.apcprd02.prod.outlook.com
 (2603:1096:4:90::26) To AM8PR05MB7332.eurprd05.prod.outlook.com
 (2603:10a6:20b:1db::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR02CA0086.apcprd02.prod.outlook.com (2603:1096:4:90::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Sun, 30 Aug 2020 04:37:16 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8dabe048-8c02-4fce-f450-08d84c9e60c2
X-MS-TrafficTypeDiagnostic: AM0PR05MB5105:
X-Microsoft-Antispam-PRVS: <AM0PR05MB5105E6CCA3CD1A623A82EDE7E2500@AM0PR05MB5105.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4h7MXXx/w26aZKp22/pVqDyFU1FxZ/B9ULP2zSuRNRVkgcvTrVVi03s/XRPevh1wbd05lHyCtis8Q9597GO0BKmmOYS+zp5z0Aa32wQFmizzDxBvo+0Zv4xPshCUNHELj6bBLI0dWKR2+D62xk2e/053dNKc6qyVcDkjYgcmHZlNympCYtZwt6JWI/RooZA2TQwavS5EfxUGALpBpSv2EaXIFOJ+VagTCPIcPbNHZQ1aTcvL57Nk1mVCjvTu5s6A7dVLlqf4Nqi0Fj+4gbE7cUyehaezN95AQi0R0aU/+7vLZtixBuEpspWIVLDcslDPPQeV1/lQfSA1wCb3cyGNeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39830400003)(36756003)(86362001)(16526019)(2906002)(478600001)(26005)(186003)(6666004)(55016002)(316002)(66476007)(66556008)(66946007)(8936002)(8676002)(1076003)(956004)(2616005)(103116003)(5660300002)(52116002)(83380400001)(7696005)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: WeOIcKDmD6RgYyXCZtJDHdV123CUR+Xrgwm436lE0VHtdVbPHgo8gPwmwR16EPYOH+Lrv4uuzc67W5knI1YvdkZIoe7iIz7I2Qcz2/WHSjJT90EYv17jHhi2EqZtRjXUJkzgxSqJvgepPLZEU8PggXmueNAWX1wYFyhw9gaK1zTL6fk/6pWb0pw4wKBZBX8bLHJesWziUZmqHz2aTs8Vd+yP+8Jlrt3pNzqudEZi385PMwH0rCoLyRfbZ6ywP0jf9XhgSZKhQAReD0K8cuBTWEkxCvqo93BZI5nTbHNaveR39pszZ0dLtbVvCvgaVwa1be+LHr3AX3EAf5OfyLE0mT/7uPyURSQ/J0jpjTSOCR4mKI5CAFvFxpL3Z1tNTYOCbW6LXpVmO5ObJC5QDPW96vyWSrEG0y5SPwhXHitoAmiAPr9AxxHp/Q8KtcG9xQirLiuPmMSsMcpXyTT96bDuLGLX3spbf/AaH/LWb/2GVRBUBszI6vSDuKaT7Ncqvg4c4MhUWLCwUW6e/o4gG+K6jTV3wGScb0eriZx3mh9j2T2sfBxCGfpQEd9Q1ZQUzCWSEXE5/rjk+SvH4LEGVkc90IObZKJMsykXmrkIcILqnm+xDuZhDyEltIVKU1aGcubp08oFiuECTVdWGnep4Kyq9Q==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dabe048-8c02-4fce-f450-08d84c9e60c2
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2020 04:37:18.8566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QnvcH7C2jc0WR+skqm4qdPr9kYaoxeAtpNPj+F6umvh0h2WxJKKchMkm4GtfeAF9KGzj2a5vyR04N8hEtBBu0y5tdQj6QeaN77b5ZYwJI4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'this_cpu_ptr()' is used to obtain the AEAD key' TFM on the current
CPU for encryption, however the execution can be preemptible since it's
actually user-space context, so the 'using smp_processor_id() in
preemptible' has been observed.

We fix the issue by using the 'get/put_cpu_ptr()' API which consists of
a 'preempt_disable()' instead.

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/crypto.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index c38babaa4e57..7c523dc81575 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -326,7 +326,8 @@ static void tipc_aead_free(struct rcu_head *rp)
 	if (aead->cloned) {
 		tipc_aead_put(aead->cloned);
 	} else {
-		head = *this_cpu_ptr(aead->tfm_entry);
+		head = *get_cpu_ptr(aead->tfm_entry);
+		put_cpu_ptr(aead->tfm_entry);
 		list_for_each_entry_safe(tfm_entry, tmp, &head->list, list) {
 			crypto_free_aead(tfm_entry->tfm);
 			list_del(&tfm_entry->list);
@@ -399,10 +400,15 @@ static void tipc_aead_users_set(struct tipc_aead __rcu *aead, int val)
  */
 static struct crypto_aead *tipc_aead_tfm_next(struct tipc_aead *aead)
 {
-	struct tipc_tfm **tfm_entry = this_cpu_ptr(aead->tfm_entry);
+	struct tipc_tfm **tfm_entry;
+	struct crypto_aead *tfm;
 
+	tfm_entry = get_cpu_ptr(aead->tfm_entry);
 	*tfm_entry = list_next_entry(*tfm_entry, list);
-	return (*tfm_entry)->tfm;
+	tfm = (*tfm_entry)->tfm;
+	put_cpu_ptr(tfm_entry);
+
+	return tfm;
 }
 
 /**
-- 
2.26.2

