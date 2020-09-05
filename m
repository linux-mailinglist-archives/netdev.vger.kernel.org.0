Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D562325E58A
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 06:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgIEEpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 00:45:52 -0400
Received: from mail-eopbgr50105.outbound.protection.outlook.com ([40.107.5.105]:26678
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725554AbgIEEps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 00:45:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIPqv+DJ+OoPlQpqRY0vSIzJbwPfKrHgUzcxqDwcr7nhieOWPPzPtOiiN7PrY/fkb2C1Q1rg2RP3dGMbkPq4wjKdFdS/GCnN7d8VpVtY74Qcf0/cIJ5FvoHqPB2dcxPx2Ib40kHhv99O0m464QsHCaQSuh2nrSvxWVQF6glDo5FPR22ek3aKGpYeiKtT/ZwaPyKLh3JtcH8xg2BOOmw7FkkOVIwmVkA88Sq4Ppj5z5kGe+NtB1HkUzIZvwTOkcP1UjKN8cnobc8e7zq5hq3oX5rhY+gj1z0DL1nQttYK252U8oJjP0KCEDpIrHoS6wydRacmaVVovbC15HxcA+0TDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZC2m15ZarUbkqfZ8/P0v9gbpIIbWcQOs2KRrg/K4tk=;
 b=Orn0c3V5IBjnO2d5QVqc/EIM7/jD0JBWecfyQDHVZaYg1//5P6yb1b9t4o8dUbJAzsaVRQwhXsS5VVOTX3knR7UzNzBtQ06idq1QzHZ+EA+CVsNiz8HCddTwuqveSalsMrTbPQSoxCxUxIbNfjn83Y7XYvV+j/3vVkvSyHdRHsBxy5HhPNqSmMPjgxQS8WaDHMnA5IiIQNLLNu4sJr8O0TZoM+JHz1muqmJVgfk2CzquNV15BOuWbBPM7503m34S0M2JOY/bm9jUPkWfFb8gbXRrkf+UZXvm5pmzKZ/ioTIuPHSTEFqQ6EwI3CMmJaNwEg757knvoYksIBkcXCkOBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZC2m15ZarUbkqfZ8/P0v9gbpIIbWcQOs2KRrg/K4tk=;
 b=VcHlay89ub+R6SJlGnvJRq75gaG8/luvHgIroY6txTSEBF4AB2rZWerqZ9Q2w6d4cJHRTG4bAX/TPRpp2M2Zo7CQaTF/3p75vbL/C0x2O24OMqUV9BPpnqWCYh4zj3ggIkEqpLPq0qC49mB2u6pxpxtREDgO5BGp83FaNmvhhCk=
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none
 header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB4784.eurprd05.prod.outlook.com (2603:10a6:802:67::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Sat, 5 Sep
 2020 04:45:42 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::20b1:691e:b3c7:2f58]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::20b1:691e:b3c7:2f58%7]) with mapi id 15.20.3348.017; Sat, 5 Sep 2020
 04:45:42 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     jmaloy@redhat.com, maloy@donjonn.com,
        syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com
Subject: [net-next] tipc: fix a deadlock when flushing scheduled work
Date:   Sat,  5 Sep 2020 11:45:18 +0700
Message-Id: <20200905044518.3282-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28)
 To VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (123.20.195.8) by SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Sat, 5 Sep 2020 04:45:40 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [123.20.195.8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3544cbc7-daec-46bb-bf52-08d851568b23
X-MS-TrafficTypeDiagnostic: VI1PR05MB4784:
X-Microsoft-Antispam-PRVS: <VI1PR05MB47841BB4FAE365C574E29626F12A0@VI1PR05MB4784.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K9qyx/c1LF9HzmsHHA633aoAdt5cFzKxo1wr6pv5wd5oixFyeiUjRG2ueJsSNU9Nq+AS+EKfPxl9dIBQC59KEvLNAvaE7I6CZuHzwul6QDxMU0UqeqWVO3CwPNAR12MzWTUvObfr1CXx55HdAhFXGWnKpbpQGiDnOjnQMo9bSTryhfowARQamZ0ix9C9KM/3qFHRNRqCu3+zHk/S3pdjhOkB2ayPZNEt3SbCANgdYGN07wNyvp36QUnUZLHdp2hdaMbj7sr7jY4+L0jKKK3WOmfvlrOixUdp6napPMiHKiUH1gSgNFsPzFrTg+27RiR9iSyuEQ04Cm8rn0u0pbNueg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(346002)(396003)(376002)(136003)(366004)(5660300002)(55016002)(2906002)(52116002)(86362001)(55236004)(956004)(66476007)(66556008)(4326008)(103116003)(2616005)(66946007)(83380400001)(1076003)(7696005)(186003)(478600001)(6666004)(36756003)(8936002)(8676002)(26005)(16526019)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 4VzbZL/22PkQQm6xARsAxcrKQe3pfj57++Gf1+X8SVB+RlFXNs+pSn8jiMTHZ0y4xVzazuVvvpEPIPbFQatvOtynuXiUIbVIC4gEBbVAhz5FP04xEOPESecmKt5RbPodhnQRaMBCU0bGDPa6i7pah4esq1x1wxQ0DPf13dVtBJfgkZxayl82P5h9giL25AXXeqaIkzlcVccx9FIoizclUdPn+0MqgBai1zWxyrX8LhxG6DTVJoA/ccYVt2NCLF4ZYPorueeNU2t1nHAvq6AKOEEaWCS9W4uiHh2wc0b627crxtrJT8ETC94Ysr5LHyWWN81PbTlri20mgt6I+cOgJzryHgLurkh/1XyXhE5tEjyNzj+eecuualIreFE3XOl9JPNGbpOIryT5MZvEUcGow1rAGWePhXjTIs3KLBY5SuF6XKsyV4QSvB2BD62dw5q80Wd55t7gOdyaXC89XuSjkpEF2RP5vKY8R8hH1OlF6LVROv0Wn99yZ6aI+R0LDqPFeoRsOF/cLBOvfDLgj9hcFndhBPKKOFnNcHUNiM9+nAVQBPOicknDUzrHxCtgeFVzMGhLuzo0aXXEB5UG98Q5i+LSbYL/ngAu14U8AV/DXuFx6r/FNxjSgbgHztwsTu/hqDSzXqGiMurrTOnHbgZepg==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 3544cbc7-daec-46bb-bf52-08d851568b23
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2020 04:45:41.9686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4hQ7mC/lvgR+kYuZKHGcpRnl9MjKYc6iXwODJoUHTDZZqbCVxHWqPJ3TLPbhXUP5xp3kC+dHTHhehoQfDBog7KuOBYo3LagjsnDXgg/17MQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4784
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the commit fdeba99b1e58
("tipc: fix use-after-free in tipc_bcast_get_mode"), we're trying
to make sure the tipc_net_finalize_work work item finished if it
enqueued. But calling flush_scheduled_work() is not just affecting
above work item but either any scheduled work. This has turned out
to be overkill and caused to deadlock as syzbot reported:

======================================================
WARNING: possible circular locking dependency detected
5.9.0-rc2-next-20200828-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:6/349 is trying to acquire lock:
ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: flush_workqueue+0xe1/0x13e0 kernel/workqueue.c:2777

but task is already holding lock:
ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:565

[...]
 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(pernet_ops_rwsem);
                               lock(&sb->s_type->i_mutex_key#13);
                               lock(pernet_ops_rwsem);
  lock((wq_completion)events);

 *** DEADLOCK ***
[...]

To fix the original issue, we replace above calling by introducing
a bit flag. When a namespace cleaned-up, bit flag is set to zero and:
- tipc_net_finalize functionial just does return immediately.
- tipc_net_finalize_work does not enqueue into the scheduled work queue.

Reported-by: syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com
Fixes: fdeba99b1e58 ("tipc: fix use-after-free in tipc_bcast_get_mode")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
---
 net/tipc/core.c |  8 ++++----
 net/tipc/core.h |  1 +
 net/tipc/net.c  | 10 +++++++++-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 37d8695548cf..5e7bb768f45c 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -60,6 +60,7 @@ static int __net_init tipc_init_net(struct net *net)
 	tn->trial_addr = 0;
 	tn->addr_trial_end = 0;
 	tn->capabilities = TIPC_NODE_CAPABILITIES;
+	test_and_set_bit_lock(0, &tn->net_exit_flag);
 	memset(tn->node_id, 0, sizeof(tn->node_id));
 	memset(tn->node_id_string, 0, sizeof(tn->node_id_string));
 	tn->mon_threshold = TIPC_DEF_MON_THRESHOLD;
@@ -110,10 +111,6 @@ static void __net_exit tipc_exit_net(struct net *net)
 	tipc_detach_loopback(net);
 	tipc_net_stop(net);
 
-	/* Make sure the tipc_net_finalize_work stopped
-	 * before releasing the resources.
-	 */
-	flush_scheduled_work();
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
 	tipc_sk_rht_destroy(net);
@@ -124,6 +121,9 @@ static void __net_exit tipc_exit_net(struct net *net)
 
 static void __net_exit tipc_pernet_pre_exit(struct net *net)
 {
+	struct tipc_net *tn = tipc_net(net);
+
+	clear_bit_unlock(0, &tn->net_exit_flag);
 	tipc_node_pre_cleanup_net(net);
 }
 
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 631d83c9705f..aa75882dd932 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -143,6 +143,7 @@ struct tipc_net {
 	/* TX crypto handler */
 	struct tipc_crypto *crypto_tx;
 #endif
+	unsigned long net_exit_flag;
 };
 
 static inline struct tipc_net *tipc_net(struct net *net)
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 85400e4242de..8ad5b9ad89c0 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -132,6 +132,9 @@ static void tipc_net_finalize(struct net *net, u32 addr)
 {
 	struct tipc_net *tn = tipc_net(net);
 
+	if (unlikely(!test_bit(0, &tn->net_exit_flag)))
+		return;
+
 	if (cmpxchg(&tn->node_addr, 0, addr))
 		return;
 	tipc_set_node_addr(net, addr);
@@ -153,8 +156,13 @@ static void tipc_net_finalize_work(struct work_struct *work)
 
 void tipc_sched_net_finalize(struct net *net, u32 addr)
 {
-	struct tipc_net_work *fwork = kzalloc(sizeof(*fwork), GFP_ATOMIC);
+	struct tipc_net *tn = tipc_net(net);
+	struct tipc_net_work *fwork;
+
+	if (unlikely(!test_bit(0, &tn->net_exit_flag)))
+		return;
 
+	fwork = kzalloc(sizeof(*fwork), GFP_ATOMIC);
 	if (!fwork)
 		return;
 	INIT_WORK(&fwork->work, tipc_net_finalize_work);
-- 
2.25.1

