Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF96B708AA
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbfGVSd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:26 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:37697 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728765AbfGVSdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 72A69220E;
        Mon, 22 Jul 2019 14:33:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=9ouiRLPeAKBhyU0c9H65eKAhGvi+xiy8EZs7Okb7CJU=; b=KBeSg4c0
        TYYUjh03CwyMkqsnrX8ThU8XtwVtGzyJRSRneQRfaAWIREKOBmyjNbphD+tHjmu0
        REIs9qfbUkl4hIaQS++TUPQ9NEDkfj/8jKHorxMRX8YgQUiGN7fJp9i+zzo4Gi4P
        8aMLsvtCa30VJuu+sTaJKlm7i3ScKe+gM0SCCX2IxBM5NOIyh3ohxz0y4B27KzRM
        6vS+iYBayilFyiDC6GpbTY5XC08BFCrz/C5Bc+XKUG0KWTqmX2/m9EbP4BvKazYE
        0BQHWFNFeRbc4Vuw8187aJtToR75M9AEZSOuuDPNMyrpN6Lqj71STShPQXIbLkdk
        8r102t2RIxSSqQ==
X-ME-Sender: <xms:dAE2XQE_d_GS_jClEXfAcr6lNj_uN6uhsooANZFjZocyV2TWhUe3rA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:dAE2Xf6mc3UwvcqMZNNohupzM7Ik-kGLdV6VqXDtKoNbrINBm3c_Tg>
    <xmx:dAE2XW7jcRDhqvh01XQJq07uoy33JNr5m_QW0RLemGY8n9BTMCGLyg>
    <xmx:dAE2XauUnQJ5IkkssC1birgRUMciIdo1pMI-mMpLBAoQfCy_s1S_ow>
    <xmx:dAE2XfTHGwxjsl8kLGWQ5SvokOl3HSqeib89YZglBT8C7gyf52P7XQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2FC580060;
        Mon, 22 Jul 2019 14:33:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 02/12] drop_monitor: Rename and document scope of mutex
Date:   Mon, 22 Jul 2019 21:31:24 +0300
Message-Id: <20190722183134.14516-3-idosch@idosch.org>
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

