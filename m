Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A49F83299
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731401AbfHFNUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:20:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47475 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728582AbfHFNUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:20:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D473722023;
        Tue,  6 Aug 2019 09:20:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Aug 2019 09:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=9ouiRLPeAKBhyU0c9H65eKAhGvi+xiy8EZs7Okb7CJU=; b=ZFmMYETt
        eA57kLZrYytwbj0Z0+FUQTYSfa7L9esb0/gXCL0z7T2ZhNcyn+iyrMLVGCz1gpMw
        m0fWIsWGsbQofOgsAxH6UHVa46rX9kBgx6RoLgo6bwdZOmaUVAPP9F/3oN0hkApV
        fq/0/B/pVQg4RTWkuAjdnfPe+7wBCZexo0eyWvdtGaoTBcx3BrdroeP6Y11s3qYp
        CaKjGro2sVVoj87J11t+Eyp8cIZmSj7AX00+/nmqqMjWtzTB6TytyO2oefPa+QcI
        6NQj7yi2gpjB3+8pl6SGBXxUa0s0cn50fzphhvqrG37zoWROf+0FQjrQUYq8ekqB
        Mz68K6QubhomiQ==
X-ME-Sender: <xms:rX5JXVyuXBt4EQ7qtHO4JX71l51GDOfnWM700x115hAA6a0r8fS0vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddutddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:rX5JXYkpxsQhFwoyqgNB4za4bachMf8MsgKEul6_brZPikKWGaN0lQ>
    <xmx:rX5JXbKzjuCsocuQ2V5cjWADleKEER1hAzviELn5hAKwKeuXbAv2wA>
    <xmx:rX5JXasYhOTJvQJXydkQSA8gFh4eWeIyk5-B6HYHpX3Bybave699Bw>
    <xmx:rX5JXbx0zCtf1xBu7dL4kprSb3-p4gZXvQkyxfJ4nRLtm8v1q2eW9w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2636080065;
        Tue,  6 Aug 2019 09:20:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, toke@redhat.com,
        jiri@mellanox.com, dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/6] drop_monitor: Rename and document scope of mutex
Date:   Tue,  6 Aug 2019 16:19:52 +0300
Message-Id: <20190806131956.26168-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190806131956.26168-1-idosch@idosch.org>
References: <20190806131956.26168-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The 'trace_state_mutex' does not only protect the global 'trace_state'
variable, but also the global 'hw_stats_list'.

Subsequent patches are going add more operations from user space to
drop_monitor and these all need to be mutually exclusive.

Rename 'trace_state_mutex' to the more fitting 'net_dm_mutex' name and
document its scope.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index dcb4d2aeb2a8..000ec8b66d1e 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -43,7 +43,13 @@
  * netlink alerts
  */
 static int trace_state = TRACE_OFF;
-static DEFINE_MUTEX(trace_state_mutex);
+
+/* net_dm_mutex
+ *
+ * An overall lock guarding every operation coming from userspace.
+ * It also guards the global 'hw_stats_list' list.
+ */
+static DEFINE_MUTEX(net_dm_mutex);
 
 struct per_cpu_dm_data {
 	spinlock_t		lock;
@@ -241,7 +247,7 @@ static int set_all_monitor_traces(int state)
 	struct dm_hw_stat_delta *new_stat = NULL;
 	struct dm_hw_stat_delta *temp;
 
-	mutex_lock(&trace_state_mutex);
+	mutex_lock(&net_dm_mutex);
 
 	if (state == trace_state) {
 		rc = -EAGAIN;
@@ -289,7 +295,7 @@ static int set_all_monitor_traces(int state)
 		rc = -EINPROGRESS;
 
 out_unlock:
-	mutex_unlock(&trace_state_mutex);
+	mutex_unlock(&net_dm_mutex);
 
 	return rc;
 }
@@ -330,12 +336,12 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 
 		new_stat->dev = dev;
 		new_stat->last_rx = jiffies;
-		mutex_lock(&trace_state_mutex);
+		mutex_lock(&net_dm_mutex);
 		list_add_rcu(&new_stat->list, &hw_stats_list);
-		mutex_unlock(&trace_state_mutex);
+		mutex_unlock(&net_dm_mutex);
 		break;
 	case NETDEV_UNREGISTER:
-		mutex_lock(&trace_state_mutex);
+		mutex_lock(&net_dm_mutex);
 		list_for_each_entry_safe(new_stat, tmp, &hw_stats_list, list) {
 			if (new_stat->dev == dev) {
 				new_stat->dev = NULL;
@@ -346,7 +352,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 				}
 			}
 		}
-		mutex_unlock(&trace_state_mutex);
+		mutex_unlock(&net_dm_mutex);
 		break;
 	}
 out:
-- 
2.21.0

