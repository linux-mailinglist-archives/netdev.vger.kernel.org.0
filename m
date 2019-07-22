Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8995708B0
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbfGVSdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:40 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:34473 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729509AbfGVSdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id E6E9C254B;
        Mon, 22 Jul 2019 14:33:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=E2VAHk7OBYcJH2gbHOVRqKCNQ6XBd2EKhgt1oQ28U6U=; b=rhFAct9e
        NZk3OTXtpSD0S01lbSuZUnO2ROnMwQIU1KuKNLXdQYQBi0gDhHhvNPKCtJqSq51a
        okSQFcSqdnpIe+UajQ4g8X5S5ZHwCcu+87SdHAq1EhMWBhMGlLQRMq5yHzTX1bTP
        62ILdTmy2sbFVRFc1GHXoeZHYYHjweu98dlNZ5R2Y6EHR/yrnPy/PQOWKpiUIlR+
        9LLKdru3o18zuxXYOJ6a1fKaydoTHdro6WQV0SKLV1IxNbaTDh41FBCmm3brS8kp
        8LviejtbghgqEOtU+xBH3c1GVdMd3oE0eRfbQ1W1NVJ5n60p86BB9bY/8ltF3Mlu
        8CLJEA0ihV6p4g==
X-ME-Sender: <xms:ggE2XeVvoQz4mn_P73dvkSVycTa9nO9p5WVOhGot8PA7AbKtOLv7Ow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeh
X-ME-Proxy: <xmx:ggE2XbVmKKun04SKJbwzyaAQOHn78RTzewodK3IuqgmJVgHLrsW8JQ>
    <xmx:ggE2XSBqxyMrMaeHUbRvNhc1nzjAV-lOBVz1F7C_d9GoKIiycs1A4A>
    <xmx:ggE2Xeh2LfpkZJ1zAP7o_eA7Qf6eM2AT5v_KTAiP0AhdJ0-FOcSEJA>
    <xmx:ggE2XfUBOI6M0J2uSdCLn3lmHnPhNvTVHiGuLUGDcu_v82c1zrFfmQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 755ED8005C;
        Mon, 22 Jul 2019 14:33:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 08/12] drop_monitor: Initialize timer and work item upon tracing enable
Date:   Mon, 22 Jul 2019 21:31:30 +0300
Message-Id: <20190722183134.14516-9-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190722183134.14516-1-idosch@idosch.org>
References: <20190722183134.14516-1-idosch@idosch.org>
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
index e68dafaaebcd..2f56a61c43c6 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -257,13 +257,20 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
 
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
@@ -288,12 +295,23 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
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

