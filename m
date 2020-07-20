Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6225C2261A2
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGTOKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:10:37 -0400
Received: from foss.arm.com ([217.140.110.172]:48976 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgGTOKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 10:10:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27B4CD6E;
        Mon, 20 Jul 2020 07:10:36 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.210.119])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 00C553F718;
        Mon, 20 Jul 2020 07:10:32 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, Song.Zhu@arm.com,
        Jianlin.Lv@arm.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next] bpf: Generate cookie for new non-initial net NS
Date:   Mon, 20 Jul 2020 22:09:19 +0800
Message-Id: <20200720140919.22342-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For non-initial network NS, the net cookie is generated when
bpf_get_netns_cookie_sock is called for the first time, but it is more
reasonable to complete the cookie generation work when creating a new
network NS, just like init_net.
net_gen_cookie() be moved into setup_net() that it can serve the initial
and non-initial network namespace.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 net/core/net_namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index dcd61aca343e..5937bd0df56d 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -336,6 +336,7 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 	idr_init(&net->netns_ids);
 	spin_lock_init(&net->nsid_lock);
 	mutex_init(&net->ipv4.ra_mutex);
+	net_gen_cookie(net);
 
 	list_for_each_entry(ops, &pernet_list, list) {
 		error = ops_init(ops, net);
@@ -1101,7 +1102,6 @@ static int __init net_ns_init(void)
 		panic("Could not allocate generic netns");
 
 	rcu_assign_pointer(init_net.gen, ng);
-	net_gen_cookie(&init_net);
 
 	down_write(&pernet_ops_rwsem);
 	if (setup_net(&init_net, &init_user_ns))
-- 
2.17.1

