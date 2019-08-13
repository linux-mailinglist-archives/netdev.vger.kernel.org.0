Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173B48B1A0
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfHMHzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:55:50 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:35947 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727451AbfHMHzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:55:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D19E7307C;
        Tue, 13 Aug 2019 03:55:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 03:55:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=AAdK2fmmxdbjuC9+1u/FVvg+yXS9COLPpoMKYrpj5SA=; b=qhnUWSxp
        0/GRFhBmPWMyQVl/IQxwvsQ87I/NyTbq6ygsw5sTSPQhcId4ALJfc2+yJh9gss33
        TRmOKwsKPH5btePP6M9iYIin11HffiySR+bPQF4xlcGQj2xH98Qrum6XPMxLBRh4
        AEWkIwGOFVT3kwp5SDpZtiTj2x9Chk8moOemQy66BJQgPxDbJBLLWf7qSxyxyV4x
        M29Ff9eaorrs+zTifP3sixAZ0aMj5UsQjlK2dHIt3hW7aeMLmTreyUtxrIeCnCzh
        o939YN/9Ho9lcnlDT/h9PN+mejIU+1j5Ipqlp4FUXAHDNDUnYep1wO7V/DAyJOZr
        LLOL2ahNaFqAJA==
X-ME-Sender: <xms:A21SXWmyCw4KchRIKM3TG8rzPRqOnALn7xi_yoIhnmiY9C1HN6_I2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvhedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:A21SXcU5-0P7vKqpsv_4IsOIyW9HTiPIgsB-2Dr7Imn3uzgWeleY1w>
    <xmx:A21SXdCMcCj4uH8-xuS2fpLNvJmuPpatJPub0R11mS3WqeBTpWeWEw>
    <xmx:A21SXcboceX1d60g1-boz0pvVMHfpr1OTD1235Z9ezyniUVihaAHGw>
    <xmx:A21SXfGQF2kgY4WzoQcBbjktJeQAwRY9wkKZ9OJ8dNPkWdk8K1gFag>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00DD180063;
        Tue, 13 Aug 2019 03:55:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 01/14] drop_monitor: Move per-CPU data init/fini to separate functions
Date:   Tue, 13 Aug 2019 10:53:47 +0300
Message-Id: <20190813075400.11841-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813075400.11841-1-idosch@idosch.org>
References: <20190813075400.11841-1-idosch@idosch.org>
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

