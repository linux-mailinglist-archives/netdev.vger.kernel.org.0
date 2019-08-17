Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1EB91086
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfHQNaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:30:18 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:60619 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbfHQNaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:30:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 07C241FAF;
        Sat, 17 Aug 2019 09:30:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=AAdK2fmmxdbjuC9+1u/FVvg+yXS9COLPpoMKYrpj5SA=; b=sjyWtfh7
        o4Gv9XgZZtKiZPHA/kjPbJ72s6bZH78Z/fFMinx51P8b9CF85NKe6YWw27ukrgOx
        h0ae/NRO6POJ4HH7AFtzhB0OOl0HGNWDNWoKJE3m6atQOL58Qxj6eJX4fIhCIM88
        Ax38vWezGOJWa+ZFB7I0V9EybLbH+RKu/MfITww9j8p2nTqdbx1ta36OUn8qmwyj
        a3L2nQ+0CIR8rA/lNA8FbLXkuema17X60iS8p8mk1f/fWJjmnKvyG2Lz9La/TFfq
        Zpo2ffIoQB0a2P2h1KVAYAwoeIZhREoqCucHX7adlh60b8zYPw423o/B+soFcPYo
        2fzGVx9DWWkuvA==
X-ME-Sender: <xms:aAFYXWuQdZBvJ32miUxKsEWCy_9GhqPoHCOhVmNb88YPfYjLNlefMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejjedrvddurddukedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:aAFYXbS8qrLuLTgv__jLENlMK8bLulZCwTV08fAy7xu4IMeQTS7XcQ>
    <xmx:aAFYXUWYXhNQt2L6qTemXn37xgsVIH8Ls1hDyGDpyLkFq2fO_D7O7Q>
    <xmx:aAFYXdwrudhoyP4yT-dI31y0MCWHUSMJfLMElAJP1qKCoNChAQhU9A>
    <xmx:aAFYXdlJdpJqA3CVqY9EMQU12vr7Z6T7XFtwXyYgltl9qXqVwU6OQA>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83D8080060;
        Sat, 17 Aug 2019 09:30:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 01/16] drop_monitor: Move per-CPU data init/fini to separate functions
Date:   Sat, 17 Aug 2019 16:28:10 +0300
Message-Id: <20190817132825.29790-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817132825.29790-1-idosch@idosch.org>
References: <20190817132825.29790-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently drop monitor only reports software drops to user space, but
subsequent patches are going to add support for hardware drops.

Like software drops, the per-CPU data of hardware drops needs to be
initialized and de-initialized upon module initialization and exit. To
avoid code duplication, break this code into separate functions, so that
these could be re-used for hardware drops.

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/drop_monitor.c | 53 ++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 39e094907391..349ab78b8c3e 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -934,9 +934,40 @@ static struct notifier_block dropmon_net_notifier = {
 	.notifier_call = dropmon_net_event
 };
 
-static int __init init_net_drop_monitor(void)
+static void __net_dm_cpu_data_init(struct per_cpu_dm_data *data)
+{
+	spin_lock_init(&data->lock);
+	skb_queue_head_init(&data->drop_queue);
+	u64_stats_init(&data->stats.syncp);
+}
+
+static void __net_dm_cpu_data_fini(struct per_cpu_dm_data *data)
+{
+	WARN_ON(!skb_queue_empty(&data->drop_queue));
+}
+
+static void net_dm_cpu_data_init(int cpu)
 {
 	struct per_cpu_dm_data *data;
+
+	data = &per_cpu(dm_cpu_data, cpu);
+	__net_dm_cpu_data_init(data);
+}
+
+static void net_dm_cpu_data_fini(int cpu)
+{
+	struct per_cpu_dm_data *data;
+
+	data = &per_cpu(dm_cpu_data, cpu);
+	/* At this point, we should have exclusive access
+	 * to this struct and can free the skb inside it.
+	 */
+	consume_skb(data->skb);
+	__net_dm_cpu_data_fini(data);
+}
+
+static int __init init_net_drop_monitor(void)
+{
 	int cpu, rc;
 
 	pr_info("Initializing network drop monitor service\n");
@@ -961,12 +992,8 @@ static int __init init_net_drop_monitor(void)
 
 	rc = 0;
 
-	for_each_possible_cpu(cpu) {
-		data = &per_cpu(dm_cpu_data, cpu);
-		spin_lock_init(&data->lock);
-		skb_queue_head_init(&data->drop_queue);
-		u64_stats_init(&data->stats.syncp);
-	}
+	for_each_possible_cpu(cpu)
+		net_dm_cpu_data_init(cpu);
 
 	goto out;
 
@@ -978,7 +1005,6 @@ static int __init init_net_drop_monitor(void)
 
 static void exit_net_drop_monitor(void)
 {
-	struct per_cpu_dm_data *data;
 	int cpu;
 
 	BUG_ON(unregister_netdevice_notifier(&dropmon_net_notifier));
@@ -988,15 +1014,8 @@ static void exit_net_drop_monitor(void)
 	 * we are guarnateed not to have any current users when we get here
 	 */
 
-	for_each_possible_cpu(cpu) {
-		data = &per_cpu(dm_cpu_data, cpu);
-		/*
-		 * At this point, we should have exclusive access
-		 * to this struct and can free the skb inside it
-		 */
-		kfree_skb(data->skb);
-		WARN_ON(!skb_queue_empty(&data->drop_queue));
-	}
+	for_each_possible_cpu(cpu)
+		net_dm_cpu_data_fini(cpu);
 
 	BUG_ON(genl_unregister_family(&net_drop_monitor_family));
 }
-- 
2.21.0

