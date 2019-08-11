Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F45C89029
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfHKHgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:36:48 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:59711 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbfHKHgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:36:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 37E011502;
        Sun, 11 Aug 2019 03:36:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:36:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=q136pVH8+XgOuqwHoJUr4vw4Kbp4VC/NK4s6umcoxuI=; b=KtIXGAg/
        an3vGhbUdBP9/CaWwinYFsjtuf5T+PUdMSdwclSK/KoxbmatVhzYJmBYq5eMgRq/
        3hwGGpDf0g6wc6ZAtAXDy0AdXXmJPCECup8z2WUUy5OjHX/1GV/x5G/oIK8YiQAU
        UzotsUtNSI4t+ZcgLSa7nLIU3xndh2/A7wmBbr2sqdcSTpdubRa/S2sP/LE+U5Eg
        CYCHaSUGl+fc1uDMN4h3Eb2QaLv1gf8RjOntK5Ok7mj5n57/bhJkPzfhn513X+ad
        ZwkL9aN46AH2/xUGiULA2Sec5aZ1gzlBno9gg2UtaTm3EQxgfy2cm/27ClncCL79
        DeV2vf2oW8T1Jg==
X-ME-Sender: <xms:jcVPXQVvDFWPwQBmJVcWALMokYbB21xoCyK8TCH4SPPUNf5kp8Ia-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:jsVPXZKOpygY1bzDCl8F1lVRB4K1_jQM6TPlN5FfdAjsbLeTCLcynQ>
    <xmx:jsVPXZ1jtwOFMmy1IxdTJ2vO0yX8tHErh7Xp-g8Vm0kXxgSRCJhhTA>
    <xmx:jsVPXR_gPrYZyhSnQDnrYVyOmv5g-w6Cx-2ZmGB4A4WzeuDy07zWpA>
    <xmx:jsVPXXBjk1EZtZ34j_R9MfUU4TDcH8_Snsbop0RNlph7gz1rlp_Xdg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8EAB480059;
        Sun, 11 Aug 2019 03:36:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 01/10] drop_monitor: Split tracing enable / disable to different functions
Date:   Sun, 11 Aug 2019 10:35:46 +0300
Message-Id: <20190811073555.27068-2-idosch@idosch.org>
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

Subsequent patches will need to enable / disable tracing based on the
configured alerting mode.

Reduce the nesting level and prepare for the introduction of this
functionality by splitting the tracing enable / disable operations into
two different functions.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 79 ++++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 28 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 4deb86f990f1..8b9b0b899ebc 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -241,11 +241,58 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
 	rcu_read_unlock();
 }
 
+static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
+{
+	int rc;
+
+	if (!try_module_get(THIS_MODULE)) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to take reference on module");
+		return -ENODEV;
+	}
+
+	rc = register_trace_kfree_skb(trace_kfree_skb_hit, NULL);
+	if (rc) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to connect probe to kfree_skb() tracepoint");
+		goto err_module_put;
+	}
+
+	rc = register_trace_napi_poll(trace_napi_poll_hit, NULL);
+	if (rc) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to connect probe to napi_poll() tracepoint");
+		goto err_unregister_trace;
+	}
+
+	return 0;
+
+err_unregister_trace:
+	unregister_trace_kfree_skb(trace_kfree_skb_hit, NULL);
+err_module_put:
+	module_put(THIS_MODULE);
+	return rc;
+}
+
+static void net_dm_trace_off_set(void)
+{
+	struct dm_hw_stat_delta *new_stat, *temp;
+
+	unregister_trace_napi_poll(trace_napi_poll_hit, NULL);
+	unregister_trace_kfree_skb(trace_kfree_skb_hit, NULL);
+
+	tracepoint_synchronize_unregister();
+
+	list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
+		if (new_stat->dev == NULL) {
+			list_del_rcu(&new_stat->list);
+			kfree_rcu(new_stat, rcu);
+		}
+	}
+
+	module_put(THIS_MODULE);
+}
+
 static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
 {
 	int rc = 0;
-	struct dm_hw_stat_delta *new_stat = NULL;
-	struct dm_hw_stat_delta *temp;
 
 	if (state == trace_state) {
 		NL_SET_ERR_MSG_MOD(extack, "Trace state already set to requested state");
@@ -254,34 +301,10 @@ static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
 
 	switch (state) {
 	case TRACE_ON:
-		if (!try_module_get(THIS_MODULE)) {
-			NL_SET_ERR_MSG_MOD(extack, "Failed to take reference on module");
-			rc = -ENODEV;
-			break;
-		}
-
-		rc |= register_trace_kfree_skb(trace_kfree_skb_hit, NULL);
-		rc |= register_trace_napi_poll(trace_napi_poll_hit, NULL);
+		rc = net_dm_trace_on_set(extack);
 		break;
-
 	case TRACE_OFF:
-		rc |= unregister_trace_kfree_skb(trace_kfree_skb_hit, NULL);
-		rc |= unregister_trace_napi_poll(trace_napi_poll_hit, NULL);
-
-		tracepoint_synchronize_unregister();
-
-		/*
-		 * Clean the device list
-		 */
-		list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
-			if (new_stat->dev == NULL) {
-				list_del_rcu(&new_stat->list);
-				kfree_rcu(new_stat, rcu);
-			}
-		}
-
-		module_put(THIS_MODULE);
-
+		net_dm_trace_off_set();
 		break;
 	default:
 		rc = 1;
-- 
2.21.0

