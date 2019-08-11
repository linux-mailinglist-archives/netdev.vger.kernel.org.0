Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75FC18902A
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHKHgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:36:50 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:51173 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbfHKHgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:36:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B070A1948;
        Sun, 11 Aug 2019 03:36:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:36:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=F0tiDwq8dGNSUs6mPVjCxbdJiIKtH2wYuxibCknzJBo=; b=ItXANwIV
        qJXMYXsrP8Wx/AaZhllXdNFMCX/96SZUb3bu7q3Jotmbod0qH1dzlfvpQ0Ty5uNN
        gHdjXmQd3ja+35JT4Uf3njzgoNatqs63V3aKXKC/korLw2DUqyL+Oe+ai1I+iQUC
        kOgAfR0ishR3PHPofGciJAUFq+Aa25lyWXVImRLdhs1C7t/fbv/0CB2864jgvFYy
        Et1GhYXw6qprhsv+ty5MquL6JDVvaaFRM8Iaq3FRda+GIDHfBxYfijK0Hk4vXuay
        V3ei0Idb1yEQ9ngQy06CAHWRM673HdAacGHMeHlvoRWlY+ROdJgC6bJ9Op8gALfW
        55kZTv/+TpbMkA==
X-ME-Sender: <xms:kMVPXVJQWQGtMhWzEGJEMZqPqG3ZGPnZOCHNX98nG0oFFBYMwPByEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:kMVPXaXoeUisU7DGTktGo9_x-ecKd4fPExgbk8c84l1wgmFymZGshA>
    <xmx:kMVPXX0ttu728Yqju8tB4ogxI7nKEVnBsxdAVa1pa7KpxZgtRsn8Kw>
    <xmx:kMVPXXT_zuIXyHlkuh09I7hYJIG746RzG1KsZUiTTx32kWrbUeCUIA>
    <xmx:kMVPXYTek0Zt_NupH1CpFNAU-u96aIBjP7dauRrW5PyRescZbdWQOg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 12A4A80063;
        Sun, 11 Aug 2019 03:36:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 02/10] drop_monitor: Initialize timer and work item upon tracing enable
Date:   Sun, 11 Aug 2019 10:35:47 +0300
Message-Id: <20190811073555.27068-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190811073555.27068-1-idosch@idosch.org>
References: <20190811073555.27068-1-idosch@idosch.org>
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

