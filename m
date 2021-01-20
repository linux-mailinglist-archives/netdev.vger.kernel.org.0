Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4152FD190
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 14:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731412AbhATMwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:52:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732974AbhATMZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:25:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611145442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yXebZo9951zeOl62OYM0phw2rXGWPMFf4+PcqFILogk=;
        b=JMfCAIn2gu0FgkXe2wNeFuqtxv+E1MH25QJAEfsYbZ+glPuWB9Cr7Sn0gQJXIElQtUwjrX
        Z75+4/kJqK06lyifmdOw/sNKoErAKvcywPJMj0OuLwIArRuHI8MOGO470dPTp01Xwz+8e5
        qty23KyWulX/eHNFigQxFUpZpx//lic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-qIR8SGDnNpuJ12TcIyCF5Q-1; Wed, 20 Jan 2021 07:23:57 -0500
X-MC-Unique: qIR8SGDnNpuJ12TcIyCF5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A267E8145E5;
        Wed, 20 Jan 2021 12:23:56 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.194.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8669360C69;
        Wed, 20 Jan 2021 12:23:55 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     saeed@kernel.org, Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net] team: postpone features update to avoid deadlock
Date:   Wed, 20 Jan 2021 13:23:54 +0100
Message-Id: <20210120122354.3687556-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Team driver protects port list traversal by its team->lock mutex
in functions like team_change_mtu(), team_set_rx_mode(),
team_vlan_rx_{add,del}_vid() etc.
These functions call appropriate callbacks of all enslaved
devices. Some drivers need to update their features under
certain conditions (e.g. TSO is broken for jumbo frames etc.) so
they call netdev_update_features(). This causes a deadlock because
netdev_update_features() calls netdevice notifiers and one of them
is team_device_event() that in case of NETDEV_FEAT_CHANGE tries lock
team->lock mutex again.

Example (r8169 case):
...
[ 6391.348202]  __mutex_lock.isra.6+0x2d0/0x4a0
[ 6391.358602]  team_device_event+0x9d/0x160 [team]
[ 6391.363756]  notifier_call_chain+0x47/0x70
[ 6391.368329]  netdev_update_features+0x56/0x60
[ 6391.373207]  rtl8169_change_mtu+0x14/0x50 [r8169]
[ 6391.378457]  dev_set_mtu_ext+0xe1/0x1d0
[ 6391.387022]  dev_set_mtu+0x52/0x90
[ 6391.390820]  team_change_mtu+0x64/0xf0 [team]
[ 6391.395683]  dev_set_mtu_ext+0xe1/0x1d0
[ 6391.399963]  do_setlink+0x231/0xf50
...

To fix the problem __team_compute_features() needs to be postponed
for these cases.

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/team/team.c | 36 +++++++++++++++++++++++++++++++++++-
 include/linux/if_team.h |  1 +
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index c19dac21c468..f66d38b0e70a 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -975,6 +975,10 @@ static void team_port_disable(struct team *team,
 	team_lower_state_changed(port);
 }
 
+/*******************
+ * Compute features
+ *******************/
+
 #define TEAM_VLAN_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG | \
 			    NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
 			    NETIF_F_HIGHDMA | NETIF_F_LRO)
@@ -1018,12 +1022,39 @@ static void __team_compute_features(struct team *team)
 		team->dev->priv_flags |= IFF_XMIT_DST_RELEASE;
 }
 
-static void team_compute_features(struct team *team)
+static void team_compute_features_work(struct work_struct *work)
 {
+	struct team *team;
+
+	team = container_of(work, struct team, compute_features_task);
 	mutex_lock(&team->lock);
 	__team_compute_features(team);
 	mutex_unlock(&team->lock);
+
+	rtnl_lock();
 	netdev_change_features(team->dev);
+	rtnl_unlock();
+}
+
+static void team_compute_features(struct team *team)
+{
+	if (mutex_trylock(&team->lock)) {
+		__team_compute_features(team);
+		mutex_unlock(&team->lock);
+		netdev_change_features(team->dev);
+	} else {
+		schedule_work(&team->compute_features_task);
+	}
+}
+
+static void team_compute_features_init(struct team *team)
+{
+	INIT_WORK(&team->compute_features_task, team_compute_features_work);
+}
+
+static void team_compute_features_fini(struct team *team)
+{
+	cancel_work_sync(&team->compute_features_task);
 }
 
 static int team_port_enter(struct team *team, struct team_port *port)
@@ -1639,6 +1670,7 @@ static int team_init(struct net_device *dev)
 
 	team_notify_peers_init(team);
 	team_mcast_rejoin_init(team);
+	team_compute_features_init(team);
 
 	err = team_options_register(team, team_options, ARRAY_SIZE(team_options));
 	if (err)
@@ -1652,6 +1684,7 @@ static int team_init(struct net_device *dev)
 	return 0;
 
 err_options_register:
+	team_compute_features_fini(team);
 	team_mcast_rejoin_fini(team);
 	team_notify_peers_fini(team);
 	team_queue_override_fini(team);
@@ -1673,6 +1706,7 @@ static void team_uninit(struct net_device *dev)
 
 	__team_change_mode(team, NULL); /* cleanup */
 	__team_options_unregister(team, team_options, ARRAY_SIZE(team_options));
+	team_compute_features_fini(team);
 	team_mcast_rejoin_fini(team);
 	team_notify_peers_fini(team);
 	team_queue_override_fini(team);
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index add607943c95..581d79552bbd 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -208,6 +208,7 @@ struct team {
 	bool queue_override_enabled;
 	struct list_head *qom_lists; /* array of queue override mapping lists */
 	bool port_mtu_change_allowed;
+	struct work_struct compute_features_task;
 	struct {
 		unsigned int count;
 		unsigned int interval; /* in ms */
-- 
2.26.2

