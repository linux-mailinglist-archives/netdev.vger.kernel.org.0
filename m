Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8882A29A342
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 04:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504916AbgJ0DYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 23:24:20 -0400
Received: from mail-db8eur05on2115.outbound.protection.outlook.com ([40.107.20.115]:18017
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504911AbgJ0DYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 23:24:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZEwR8Al4YFc67R9ZWzaHA7GgCqRN1eUbC5UuFsjhYHCIAlYNoTTq2wBr7xAqjiAnEJhUiE4PdNQnShMKLHWm4HdxNzNSuRhmUrHukkL9mRHKf39hdgK2ruvwtG25Ub5jcn1zmBOIiWeXhcqa/c/mVBBhXZMrYcid1EzmodQ8SwJPPDJiHgHuhdAiMDkrJH/FEAp5TVQJbdy/znWdXIlFmCx35Eqvw3BAMbBz2UZH61ZBJeo/SGnwKuPXkmyFmfihBHf5Uu+8GqXbbs54m7Hq7+a/wGZvJUAhSXtnoX9qD/ZrAZsCGAva28TgOx8a/Fl/B1b971hKcwgdySU+LI/vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vssvi8ADMNJ18QT3eqq6qgJyVB9+wzrx7Fkj5OKq90=;
 b=HbnbzrfvFXHjLqh+/JqrFq3ZVfC+PxwHOCYqgugG4Jl/33ai8BID1qMAoVCFCjHSxLD/X2BE5gqvFufckuICG/ZA2+cWgmqw5MixVfwbyLulu+p4hwAQjdf9osiR+Cq/ZiDfCUDX6lv1B40JJLDw3zFiJ+0dMzuwV/m8dnavYPCqj6YgiATyiWx7fOgTs8ELVtbWxN54XB+5XIcEqUquDdV7ugLsKFduiIz9VLne5DsQ17POHbN7l4whMjhk6Ykjsmlgh2M9n/nlLLrVg2KBmvcnL+0W/z9rU7qzVKM0ERcKJ1j2tcg3KD0qS1z6dd326l4ftmEFfhV4P9CJtWcrOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vssvi8ADMNJ18QT3eqq6qgJyVB9+wzrx7Fkj5OKq90=;
 b=Xe3ZYoKn3iTg4VqjQWJ6Nnih2v39ExqLaJVjBNYaMYae3MHod/SawZUUIzFfOFxhpF5qPXXPuUzN+6828wBVTwmh4jqeoitmbtWqR5FWAogkYV2QX81phKLKnRmwecg3BO0UN2gUmTlxF3pFM4X/UqMpZiLoWutcnHAB2Tnp28s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from DB7PR05MB4315.eurprd05.prod.outlook.com (2603:10a6:5:1f::18) by
 DB7PR05MB5307.eurprd05.prod.outlook.com (2603:10a6:10:68::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.28; Tue, 27 Oct 2020 03:24:16 +0000
Received: from DB7PR05MB4315.eurprd05.prod.outlook.com
 ([fe80::c04f:dae3:9fa4:ff56]) by DB7PR05MB4315.eurprd05.prod.outlook.com
 ([fe80::c04f:dae3:9fa4:ff56%4]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 03:24:16 +0000
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [tipc-discussion] [net v3 1/1] tipc: fix memory leak caused by tipc_buf_append()
Date:   Tue, 27 Oct 2020 10:24:03 +0700
Message-Id: <20201027032403.1823-1-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [113.20.114.51]
X-ClientProxiedBy: SGAP274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::13)
 To DB7PR05MB4315.eurprd05.prod.outlook.com (2603:10a6:5:1f::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ubuntu.dekvn.internal (113.20.114.51) by SGAP274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 27 Oct 2020 03:24:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5a392c3-ca84-42de-e09e-08d87a27c877
X-MS-TrafficTypeDiagnostic: DB7PR05MB5307:
X-Microsoft-Antispam-PRVS: <DB7PR05MB5307970B9B88627206F0482E88160@DB7PR05MB5307.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EXonxtHekx1ngX2T9dtzqFoFrmDPDNqzo/ciwKgKE9C6wfoGRG80PUKhJ1kPIrxCk/Ny6zl70H/Q1tORmq0HvBhV1pu18GWeY69ejMvlwyj6xIAaIX7tN7IqmElLLmCEb7r0MGh5u5c9Bxh+csmctLXqISQNOtzSMKgAXBTFcHpHM4P6cj/2CRAj+D2r+94/vCesqNpob+B0T4m9h8B1tw//W4i6/X25klU+GjHy+zSgcY6WvEzu0e+LKs1kxVhlpd2PdiLaG7HDzKiScFo9mkTz8HcLq1rP+b9KkSeOGyk3ssYENelOjJvbnQTg002A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4315.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(39840400004)(136003)(6486002)(103116003)(186003)(26005)(956004)(16526019)(66556008)(66946007)(478600001)(2616005)(6666004)(52116002)(316002)(6506007)(6512007)(2906002)(8676002)(66476007)(83380400001)(36756003)(86362001)(1076003)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: hlGjgxonAA4J4ddvPZA40Trrjhutq+VXKSUpiDWT1qFnZm9wHaDj12l7BLGsvW8nZmOTsKCv9kTKKPMmeadzjspWft/BFzZBJWBn4/nZnszzGj0739nt2/2GlyDjfyR8bGEPrkVMMxC2gmuJUhtl/2CZB0QH+oGYJudyZEda3owtq7vsOSngwDGFZP6jve9u44PKOGPCpGDSfsRshzGS9jzHiviakopsA6tM2hwtvlFXs7INp54UdhJlHkfOKVhzsIkUnZiVF7k9qRO8LO1DiEJ6j39+8Ck8R6xpTJwHU/5f9E73K42EGn6TXKKBzgkiyoH6ou2vxrBNKCVUaKHwJswe8eIZq53h8b1SzsILyg0MYxR6A2/B9o1fY8EH4XEozcTvT4+0CurDP4smqBFRZskf+HstQ5nzx2zED4BKzn/jlWK6dug5xfhuWrLn5YRN5zInSQMtqr7cNRrkoDuAAZYIJdkSmxdLtprsgDZSOVAjKgMjcAw+O8xIjAaZew1rcAQV15K9FVf3/Z93mGNPSXziFQijRQoOB55U0BPlEU/IxNIZuWhmeu8AlT40q7R6hhfByT4SqsM4hYfm8Wvpc3DlPpZlL5fSHLrE+gLb3M6q30CSwElIuX8Tlzf5bLDbzYJvHDHXJ56Z1o+AfiW4Vw==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a392c3-ca84-42de-e09e-08d87a27c877
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4315.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2020 03:24:16.1776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +8C287T2yJ9fj00BDidQjCvbUAqQF7v7IUB5wPUAKppFzpgTpmxpRxmwV2tepVaTCN2URx+wqB3pohJAilU2O4quCbPY17+M5un6eMHwERo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5307
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ed42989eab57 ("tipc: fix the skb_unshare() in tipc_buf_append()")
replaced skb_unshare() with skb_copy() to not reduce the data reference
counter of the original skb intentionally. This is not the correct
way to handle the cloned skb because it causes memory leak in 2
following cases:
 1/ Sending multicast messages via broadcast link
  The original skb list is cloned to the local skb list for local
  destination. After that, the data reference counter of each skb
  in the original list has the value of 2. This causes each skb not
  to be freed after receiving ACK:
  tipc_link_advance_transmq()
  {
   ...
   /* release skb */
   __skb_unlink(skb, &l->transmq);
   kfree_skb(skb); <-- memory exists after being freed
  }

 2/ Sending multicast messages via replicast link
  Similar to the above case, each skb cannot be freed after purging
  the skb list:
  tipc_mcast_xmit()
  {
   ...
   __skb_queue_purge(pkts); <-- memory exists after being freed
  }

This commit fixes this issue by using skb_unshare() instead. Besides,
to avoid use-after-free error reported by KASAN, the pointer to the
fragment is set to NULL before calling skb_unshare() to make sure that
the original skb is not freed after freeing the fragment 2 times in
case skb_unshare() returns NULL.

Fixes: ed42989eab57 ("tipc: fix the skb_unshare() in tipc_buf_append()")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Reported-by: Thang Hoang Ngo <thang.h.ngo@dektech.com.au>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
---
 net/tipc/msg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 2a78aa701572..32c79c59052b 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -150,12 +150,11 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
 	if (fragid == FIRST_FRAGMENT) {
 		if (unlikely(head))
 			goto err;
-		if (skb_cloned(frag))
-			frag = skb_copy(frag, GFP_ATOMIC);
+		*buf = NULL;
+		frag = skb_unshare(frag, GFP_ATOMIC);
 		if (unlikely(!frag))
 			goto err;
 		head = *headbuf = frag;
-		*buf = NULL;
 		TIPC_SKB_CB(head)->tail = NULL;
 		if (skb_is_nonlinear(head)) {
 			skb_walk_frags(head, tail) {
-- 
2.17.1

