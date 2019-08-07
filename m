Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139BA84988
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 12:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbfHGKbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 06:31:47 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:39907 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726902AbfHGKbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 06:31:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D5099147B;
        Wed,  7 Aug 2019 06:31:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 07 Aug 2019 06:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=HrGyFzPmDrx1i8revLlLvQliuvEchyFbm/o2KeCOVgU=; b=gU7+lfF+
        dEJ3CX3MzX2qF+WLVzDp9D/e9Ynxk4oYGK2xj6RbfPeWrCf+IJUHg9ELFwsrd9ng
        nZHNz9OXcK9abi9CwclpBZ1l43LV1lGcmtRQNB2WSnhn8Bz7vgTu6r5Evs8BKt19
        i5L1MO9bMc5gPZg85kYofLqT2Uo5RGdnmtgR3bymb3TLj01WDQLj2WDJNLAVjClt
        7zYryHpy574jX79ubNVaGOA08QyoIpIXIMhtOHovqEo/so0idfQxSUgAY1uMjyq1
        Ps73MGm1wM0zKkCi1tnAb42We+T9Qujmg7TZ078zlHhHQWCti7Nr2xCkfRevw5zf
        35LPIijKYb1XEw==
X-ME-Sender: <xms:j6hKXV9O90x3Im49mVnrbbjmOxAIVkcHuJrN_bBoLgdylPRwd4oOTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudduvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:j6hKXby--sOCtoMii6U5E5k6iyDOk4FQsc37HZauYwq_f_pc7ij0PQ>
    <xmx:j6hKXdFl2wnERoIvU-zkTB6x2JSDDDrZKNO_xNEzC2jIuVCIAGgrcQ>
    <xmx:j6hKXUILOXBmZtc4gK70TxZeoZ8BrmMzCfJC7pedgNHkZp-ZL4H4bQ>
    <xmx:j6hKXSKtgzopW5FdmEu_nrTwjo-Q1rs8jLuCvcRrnK4pJFPpH18dZw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 48278380090;
        Wed,  7 Aug 2019 06:31:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/10] drop_monitor: Reset per-CPU data before starting to trace
Date:   Wed,  7 Aug 2019 13:30:52 +0300
Message-Id: <20190807103059.15270-4-idosch@idosch.org>
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

The function reset_per_cpu_data() allocates and prepares a new skb for
the summary netlink alert message ('NET_DM_CMD_ALERT'). The new skb is
stored in the per-CPU 'data' variable and the old is returned.

The function is invoked during module initialization and from the
workqueue, before an alert is sent. This means that it is possible to
receive an alert with stale data, if we stopped tracing when the
hysteresis timer ('data->send_timer') was pending.

Instead of invoking the function during module initialization, invoke it
just before we start tracing and ensure we get a fresh skb.

This also allows us to remove the calls to initialize the timer and the
work item from the module initialization path, since both could have
been triggered by the error paths of reset_per_cpu_data().

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index b266dc1660ed..1cf4988de591 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -252,9 +252,16 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
+		struct sk_buff *skb;
 
 		INIT_WORK(&data->dm_alert_work, send_dm_alert);
 		timer_setup(&data->send_timer, sched_send_work, 0);
+		/* Allocate a new per-CPU skb for the summary alert message and
+		 * free the old one which might contain stale data from
+		 * previous tracing.
+		 */
+		skb = reset_per_cpu_data(data);
+		consume_skb(skb);
 	}
 
 	rc = register_trace_kfree_skb(trace_kfree_skb_hit, NULL);
@@ -475,10 +482,7 @@ static int __init init_net_drop_monitor(void)
 
 	for_each_possible_cpu(cpu) {
 		data = &per_cpu(dm_cpu_data, cpu);
-		INIT_WORK(&data->dm_alert_work, send_dm_alert);
-		timer_setup(&data->send_timer, sched_send_work, 0);
 		spin_lock_init(&data->lock);
-		reset_per_cpu_data(data);
 	}
 
 	goto out;
-- 
2.21.0

