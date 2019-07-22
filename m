Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45067708AF
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbfGVSdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:38 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41035 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729509AbfGVSdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:37 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 84709248E;
        Mon, 22 Jul 2019 14:33:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=FvaBCMAbBglkNs9Tp337J8b0kjbFrJoelHYPvKu6QpA=; b=eo5L/Ggx
        mh7csQ8xIyE+35pGaDuNpiy4kO1egvM33YWJlgtkT8Qp0K111kcA6XXbDAGILeYQ
        QZZRnlWAXytJSX9jJ7Eikh0uDt1x/qCqiNPzDq40tSfn62MylBcGs+OAyv7/dGhB
        PYsOgimgUZxLcoIuocqonCopmiJl7ymEtLTxkMeOEmBWs5C0dcridxAn9v3Ls823
        KX0QG4s/8dMhVprgWCzPvWBbScKK1Xf53MGteHIJhv1ivtccFFGgJL4vHO7paq9w
        yGZYgw0oAjT6IMDVAD4SpNsZzluUXq91jyHgqNVQstCySn9yzMTbgBGZypTsq4g/
        F7GL+Ud6AQz9FQ==
X-ME-Sender: <xms:gAE2XafvTAoFEc4eZGZwIMfaMbhBbFKjdVR_zeYqs_3dAMaafehf-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeh
X-ME-Proxy: <xmx:gAE2Xauzc6f46r_Y4tSv2WVZa9QO7sgZ2IY12ipkZrMfem8uvcJtsg>
    <xmx:gAE2XZgsPcQPoVkIC8qz0QqYGvodKRZUCGCxWC_AFWMd1cI8ia_T9w>
    <xmx:gAE2XavY5n2SF2vWf_rXZLZKmhAq_QS6fZVxhP-UL1P6QIuZRv7WJA>
    <xmx:gAE2XfZhXkyVy21QXODu6dpNtgVCQT-QZq5YIexkJdYYGxO_ZyEV6w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1227180060;
        Mon, 22 Jul 2019 14:33:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 07/12] drop_monitor: Split tracing enable / disable to different functions
Date:   Mon, 22 Jul 2019 21:31:29 +0300
Message-Id: <20190722183134.14516-8-idosch@idosch.org>
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
index 099000930736..e68dafaaebcd 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -255,11 +255,58 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
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
@@ -268,34 +315,10 @@ static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
 
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

