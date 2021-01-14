Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A5C2F6097
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 12:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbhANL4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 06:56:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37464 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726376AbhANL4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 06:56:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610625311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DlZ5F5E1ivwqXZEXGI43ZKr4tUgsk7s+d0KLqvxzOB4=;
        b=bEkNIqTkpg1xJb+Y8ExCMfHA3XqeoH9jCXdSbQQgeDh6gzTvBN9ol7pPwaOT15me6FS5fg
        bneUUdOJIqa7rxl+g6xAA9Izk87hb0EXUYVJZ/mQKMskgJ1O+yMXCIMZ4ZSJ15bYZH/Ate
        a6zDq5QMcV0D+GORbx5DE6JMe7SM+6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-tQeAeZtZN6mEoNlbbSHbhA-1; Thu, 14 Jan 2021 06:55:09 -0500
X-MC-Unique: tQeAeZtZN6mEoNlbbSHbhA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69AD3806675;
        Thu, 14 Jan 2021 11:55:08 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.195.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EC305D9E2;
        Thu, 14 Jan 2021 11:55:07 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net] team: fix deadlock during setting of MTU
Date:   Thu, 14 Jan 2021 12:55:06 +0100
Message-Id: <20210114115506.1713330-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Team driver protects port list traversal in team_change_mtu()
by its team->lock mutex. This causes a deadlock with certain
devices that calls netdev_update_features() during their
.ndo_change_mtu() callback. In this case netdev_update_features()
calls team's netdevice notifier team_device_event() that in case
of NETDEV_FEAT_CHANGE tries lock team->lock mutex again.

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

To fix the problem the port list traversal in team_change_mtu() can
be protected by RCU read lock. In case of failure the failing port
is marked and unwind code-path is done also under RCU read lock
protection (but not in reverse order).

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/team/team.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index c19dac21c468..69d4b28beb17 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1802,35 +1802,35 @@ static int team_set_mac_address(struct net_device *dev, void *p)
 static int team_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct team *team = netdev_priv(dev);
-	struct team_port *port;
+	struct team_port *port, *fail_port;
 	int err;
 
-	/*
-	 * Alhough this is reader, it's guarded by team lock. It's not possible
-	 * to traverse list in reverse under rcu_read_lock
-	 */
-	mutex_lock(&team->lock);
+	rcu_read_lock();
 	team->port_mtu_change_allowed = true;
-	list_for_each_entry(port, &team->port_list, list) {
+	list_for_each_entry_rcu(port, &team->port_list, list) {
 		err = dev_set_mtu(port->dev, new_mtu);
 		if (err) {
 			netdev_err(dev, "Device %s failed to change mtu",
 				   port->dev->name);
+			fail_port = port;
 			goto unwind;
 		}
 	}
 	team->port_mtu_change_allowed = false;
-	mutex_unlock(&team->lock);
+	rcu_read_unlock();
 
 	dev->mtu = new_mtu;
 
 	return 0;
 
 unwind:
-	list_for_each_entry_continue_reverse(port, &team->port_list, list)
+	list_for_each_entry_rcu(port, &team->port_list, list) {
+		if (port == fail_port)
+			break;
 		dev_set_mtu(port->dev, dev->mtu);
+	}
 	team->port_mtu_change_allowed = false;
-	mutex_unlock(&team->lock);
+	rcu_read_unlock();
 
 	return err;
 }
-- 
2.26.2

