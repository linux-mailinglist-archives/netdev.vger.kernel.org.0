Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2016384986
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 12:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfHGKbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 06:31:43 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:59973 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726902AbfHGKbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 06:31:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6260F1400;
        Wed,  7 Aug 2019 06:31:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 07 Aug 2019 06:31:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=F0tiDwq8dGNSUs6mPVjCxbdJiIKtH2wYuxibCknzJBo=; b=cP9KuZ8/
        nl6wX8XwHYfMD00A4yM9/vwj6+VtN/plWsHVNzLjCxEgs5rKnC0+JZMqy8W91Ev9
        y/1UcoNffvZSfzp6vUEXtdD4wNXWwX3YSqcmrXc2Pb92VdAOiq9fwFpapP8/UNQn
        qJvzWcnWBNjZTYLtfJGUYCW8xIhufarTT+MbbXxYr1bsZ5Ete17Y1vbz2ZxYSt8y
        UbvTgdWOoEYKM0/T0FxcYJEIA4jQSUHBx4B2F9SLvj+fkVSg5k6lv8/O3hSrpkbi
        i+ZJCUlmLsx1J3B4I/61kf7I6PmCDqQ82dGiNiXLQB5PrCWX1S0V1EhgvZMvSgJT
        /XI/juw8Ob2J/g==
X-ME-Sender: <xms:jahKXSb-O3RKRSrw2fg7WqdDaEBb0YgcW8bC-Css-nu3HY1vMoa2og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudduvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:jahKXaRNOqVVXmx0tE0QZgtu3nFiQJ-XGkGHhWnHtT7XSIZ-67nTlQ>
    <xmx:jahKXah38N6ZJUAhanrDN7X_5VSZHuxGDsCZ4OwXfMyJKDVNaCjhuw>
    <xmx:jahKXWuyZgPLkUmuS6GA7u1Z4V1VGJkNAM-tmcdOm_MERfLdxPRoJw>
    <xmx:jahKXVIcw5XouSeeiFSdVDby7qNPynKYU-xUuSDhnQCTwWs9Fy_4dQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C1ED138008E;
        Wed,  7 Aug 2019 06:31:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/10] drop_monitor: Initialize timer and work item upon tracing enable
Date:   Wed,  7 Aug 2019 13:30:51 +0300
Message-Id: <20190807103059.15270-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190807103059.15270-1-idosch@idosch.org>
References: <20190807103059.15270-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The timer and work item are currently initialized once during module
init, but subsequent patches will need to associate different functions
with the work item, based on the configured alert mode.

Allow subsequent patches to make that change by initializing and
de-initializing these objects during tracing enable and disable.

This also guarantees that once the request to disable tracing returns,
no more netlink notifications will be generated.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 8b9b0b899ebc..b266dc1660ed 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -243,13 +243,20 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
 
 static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 {
-	int rc;
+	int cpu, rc;
 
 	if (!try_module_get(THIS_MODULE)) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to take reference on module");
 		return -ENODEV;
 	}
 
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
+
+		INIT_WORK(&data->dm_alert_work, send_dm_alert);
+		timer_setup(&data->send_timer, sched_send_work, 0);
+	}
+
 	rc = register_trace_kfree_skb(trace_kfree_skb_hit, NULL);
 	if (rc) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to connect probe to kfree_skb() tracepoint");
@@ -274,12 +281,23 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 static void net_dm_trace_off_set(void)
 {
 	struct dm_hw_stat_delta *new_stat, *temp;
+	int cpu;
 
 	unregister_trace_napi_poll(trace_napi_poll_hit, NULL);
 	unregister_trace_kfree_skb(trace_kfree_skb_hit, NULL);
 
 	tracepoint_synchronize_unregister();
 
+	/* Make sure we do not send notifications to user space after request
+	 * to stop tracing returns.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
+
+		del_timer_sync(&data->send_timer);
+		cancel_work_sync(&data->dm_alert_work);
+	}
+
 	list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
 		if (new_stat->dev == NULL) {
 			list_del_rcu(&new_stat->list);
@@ -481,14 +499,10 @@ static void exit_net_drop_monitor(void)
 	/*
 	 * Because of the module_get/put we do in the trace state change path
 	 * we are guarnateed not to have any current users when we get here
-	 * all we need to do is make sure that we don't have any running timers
-	 * or pending schedule calls
 	 */
 
 	for_each_possible_cpu(cpu) {
 		data = &per_cpu(dm_cpu_data, cpu);
-		del_timer_sync(&data->send_timer);
-		cancel_work_sync(&data->dm_alert_work);
 		/*
 		 * At this point, we should have exclusive access
 		 * to this struct and can free the skb inside it
-- 
2.21.0

