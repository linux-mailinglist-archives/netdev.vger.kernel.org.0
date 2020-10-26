Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9716B298577
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 03:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421321AbgJZCAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 22:00:42 -0400
Received: from mail-eopbgr60138.outbound.protection.outlook.com ([40.107.6.138]:28806
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1421317AbgJZCAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 22:00:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdvbMGMLOjSWPzL9N9LkKsRX5pNsjRlBbcKW9BiUxfgqt5qz1NQLhGqPchMTJQT8UbD3v6PfXdWH6FukHJrHOdSdvogkv0YW821yM4IS1wacXO9YNtwnnPTHuRb7FmN/eZkcCOzAQmK0DkfpOU2sQOxPatk6RyiQcgMyUClyHq0WftzQX8QehgDnmyQqqhhgdzlS5QuQ2e2ZKD20AU+0G292UUHFGX4u/BKctCkJoQlnSgGwTC1mjLPGiHW3cMmKLNIIdovlBO1Yh+bQk8L76rD4/SVm/SXplykpzjxG5Xzu0Fbo509QSfVDFyJcor+UOfzOwGNV+wazo9vfFuzz+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muBMGO4jP4YF/NVXUrQBsLVooK/bGNA4AmirEWfMCTw=;
 b=oHJXOaPWP3I9Lq4Dz8tJ7Vnp6vS8q76syC8pS42Uc7I01CAsKYfspLaZj5RgSJP3gfCchRPJM97aO9d36WDeKKV6QvBo6ntS7xTP4JhraWFIyla14eRm+hnOvsCTt0rWVRARma3RvNxoLdYITe1rRqi/HzBJD2xpUBDKcyVxsjZIc0VrI0lPyN0re5HmuvRLVVpTThKUCyEAE8jExP5Dq29bmVayUXPaxc3JeuboZ88t2ktf1hRAtxTosP/u87BbQxUpe1wRmbvILEYnbYIsi9U0TcDyMQzVNfShMfw6aHmbvyzmBn02uo/UPXirdDhKoYlOt27aDvmPWvMm77lzxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muBMGO4jP4YF/NVXUrQBsLVooK/bGNA4AmirEWfMCTw=;
 b=qpywIKrlNeZhR1SEXV34u2zPb6BTpqvP8ZmDQV/F6qo2ZX9JfhAtPy5FSfSAFd+79x7sthbwbDNljwNMYGZzpq4racuozlnckOhfY2jLYck3N88y0Oycvii1Rua9p1lZsbjkXi76I/DvS/Kc+JciD/ECkDbeM0f/yBwQRXUSd/M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from DB7PR05MB4315.eurprd05.prod.outlook.com (2603:10a6:5:1f::18) by
 DBAPR05MB7000.eurprd05.prod.outlook.com (2603:10a6:10:182::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.23; Mon, 26 Oct 2020 02:00:38 +0000
Received: from DB7PR05MB4315.eurprd05.prod.outlook.com
 ([fe80::c04f:dae3:9fa4:ff56]) by DB7PR05MB4315.eurprd05.prod.outlook.com
 ([fe80::c04f:dae3:9fa4:ff56%4]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 02:00:38 +0000
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [tipc-discussion] [net v1 1/1] tipc: fix memory leak caused by tipc_buf_append()
Date:   Mon, 26 Oct 2020 09:00:24 +0700
Message-Id: <20201026020024.12607-1-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: SG2PR01CA0146.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::26) To DB7PR05MB4315.eurprd05.prod.outlook.com
 (2603:10a6:5:1f::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ubuntu.dekvn.internal (14.161.14.188) by SG2PR01CA0146.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 26 Oct 2020 02:00:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f49832b-697e-4c0b-a62d-08d87952ef28
X-MS-TrafficTypeDiagnostic: DBAPR05MB7000:
X-Microsoft-Antispam-PRVS: <DBAPR05MB70002FD1B5DAAF6193DC4A9A88190@DBAPR05MB7000.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+k2ccC8lvnBrxOEK69mZc0hu6lS8gv2lR9nfzr0EAKnrwEJqkqcxQ7wqlyljyED2hlxZEjgcA+wiP51UPZhtU6bVrdh2yYzyTTGcT1bMijVvvLiGW1ygwvc66HrpMdIRK++wru1uuExtYh19k12SnP7hzYpnLBUeCTDZAiTEVsQxPJlWpeN4GRm6H3/Hj+plCOyeos+QdxkKqT1sFb5VbFdkfZhd2VyYYEtHfMZ/70wbDCAGaih5nztrJexjr9MRrmTyeBx4lYdILR/mqYYobqzSdB1Wu9CWywxOcaDZYD/ibtaf8MFyKLyB8G5EzCq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4315.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39840400004)(366004)(136003)(346002)(396003)(2616005)(66946007)(52116002)(66476007)(83380400001)(2906002)(66556008)(6666004)(6486002)(8936002)(6506007)(16526019)(6512007)(36756003)(956004)(86362001)(103116003)(478600001)(8676002)(316002)(1076003)(5660300002)(26005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 0ctWRoeEf+Ygq7B3cAkQmadLtZPwooenNMMi6CgsV7YkYnw53h268BvTZL/jfLLN2jXjE3MQXrAphvcMu0tZv9kecHHx17i5oFUl2hUqY57mc+of0PtbzSokdxUNGPO8JgLakJZpHXnJmz9+gDMNhg0XhxWky0Zl1iop/s+f5MZ/Cl3kvrDpxrSHrKL/VzvW7X+VX+dnJW5S/yMCs88+8Uc4qTUwYqipcToQkssjNvGsBnO6B6WZWe1goB/BAQ4iOp6SD1XeF8563mJ4HYHhKI5JOOOThGfPyw/4DobsBMA1DAnGpsik+lgjPmrATJRvpmq1kqpsW/pYg2H23wgEv93xYTVNaMuYozsoZVX89dcFNG1NH/uV7nF/a2eqHRH2TFsFSFX/ivWvfbZCrg6POqQMbJLOU7vWlBP7yLp5Fp27HssPw2BqfNKB5RHrYEB/QEpkIrn9TDZkNAARlz/WvYjy4jcI1MVqIkQPNc64OsqpzI5v7w33luJkM+RwRwJHjzmytRr+pV+X8C4KNN1rHUPKjMQe5TGy7Mk9lzIIqIGgSPJyZ+s5uZtx7tT2jhhcxwlLcXtzxhTOBqmoXhd2FyRKP8cUBlVfIcHJ2Io4qNgcTu7Ldunp4moKyl8gJecQuoKi+NLH70E7u+Hn0Mx+9g==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f49832b-697e-4c0b-a62d-08d87952ef28
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4315.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 02:00:38.2221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lrK3ih05jPXPGNHeiYhDgjjQPEKJwSQIT1k2P663KwAtCVQ0+jG6pBGNnvJZ+PxZBGzcKq28W0KsvnKLfTGvnkQUndCdVCp75A5pszvl5gA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR05MB7000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ed42989eab57 ("fix the skb_unshare() in tipc_buf_append()")
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
to avoid use-after-free error reported by KASAN, kfree_skb(head) in
tipc_buf_reassemble() is called only if the pointer to the appending skb
is not NULL.

Fixes: ed42989eab57 ("fix the skb_unshare() in tipc_buf_append()")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Reported-by: Thang Hoang Ngo <thang.h.ngo@dektech.com.au>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
---
 net/tipc/msg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 2a78aa701572..46c36c5093de 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -150,8 +150,7 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
 	if (fragid == FIRST_FRAGMENT) {
 		if (unlikely(head))
 			goto err;
-		if (skb_cloned(frag))
-			frag = skb_copy(frag, GFP_ATOMIC);
+		frag = skb_unshare(frag, GFP_ATOMIC);
 		if (unlikely(!frag))
 			goto err;
 		head = *headbuf = frag;
@@ -797,7 +796,8 @@ bool tipc_msg_reassemble(struct sk_buff_head *list, struct sk_buff_head *rcvq)
 	return true;
 error:
 	pr_warn("Failed do clone local mcast rcv buffer\n");
-	kfree_skb(head);
+	if (head)
+		kfree_skb(head);
 	return false;
 }
 
-- 
2.17.1

