Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0938902C
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfHKHgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:36:54 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41923 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbfHKHgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:36:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 377E71974;
        Sun, 11 Aug 2019 03:36:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=HrGyFzPmDrx1i8revLlLvQliuvEchyFbm/o2KeCOVgU=; b=ePF4HP06
        3tcdPAwf3tBSsI7UjqCn5ovre5YsyqixDK2mfdSGWb1KhIOo/z6SpUCccTXBo1Li
        XP8/qLMCN1Im1xi+2h4ju1Nh8WL4Md6Q0scHjf0ghAgeocEEnEne9wJyU4PQ7gL3
        cKSEB8jvHc2DF4j50dZkORroq/4iDBOfnkZAvI29kNYMFC4Ex2PAQrjd5vAY2T1g
        e8whZUG/AjbwaYTSe88ke03+WU4KYtPNgp4sO3ZNffzgCr3orM9wUdriTGZp6zpY
        bObFMI2W58FS3cEZU1PzATt0DHcW5E2EQGS1IDh4joZx+WlUI6cTHWWEDBYLUvpS
        o44b/+1YVMu0/w==
X-ME-Sender: <xms:ksVPXfsoVSNrmFUgLhkJy81w_VE918qa_ecIY0W3jI-w4V5J0GWwOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:k8VPXUmXbbltNyoLJv2STGtZwFcPWv2lI_4FwV3_GgumAgdlYSr1eA>
    <xmx:k8VPXfy-JXiKT_odk48DuiTL-vDNmQqCBDFZqGzEIp-snLuu9dW4og>
    <xmx:k8VPXYxV2mwKN-CiMeI4BoHj4l1WB4NXcXuSOYzySmdKCGWN8sQPzw>
    <xmx:k8VPXWHa5rY68_OvM-hw2W-aC9Z3lU0KqwOnYP_QgXXjYOyjiBN73w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 910DF80061;
        Sun, 11 Aug 2019 03:36:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 03/10] drop_monitor: Reset per-CPU data before starting to trace
Date:   Sun, 11 Aug 2019 10:35:48 +0300
Message-Id: <20190811073555.27068-4-idosch@idosch.org>
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

