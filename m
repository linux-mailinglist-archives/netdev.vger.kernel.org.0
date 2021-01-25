Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3150030229F
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 09:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbhAYH65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:58:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727196AbhAYH5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:57:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611561361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3j3bf+VPQJmQMXkKHVZ15wsQL7kypkLK8xrfgmNp9tY=;
        b=aYFx5RUKFUotW8FFtc5img2uVzyIo12dkUdw9UnDqOBuXnVRy8ut0BFRMWeNbnS3Ks7BI3
        NvcWk9eMcCUKHLwV2MIgNWIz4OseW2IH0PSkZ6KlqbUDhlQ98CRaBUDI1cwh9cFC5+UJqa
        3mqLv2zMuZIuuwPznSnh+qzD/uQltBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-BgfosqEZPNCs5xP1INxZZA-1; Mon, 25 Jan 2021 02:44:21 -0500
X-MC-Unique: BgfosqEZPNCs5xP1INxZZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C64AA801AC4;
        Mon, 25 Jan 2021 07:44:19 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.194.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88A5C60C62;
        Mon, 25 Jan 2021 07:44:17 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH net] team: protect features update by RCU to avoid deadlock
Date:   Mon, 25 Jan 2021 08:44:16 +0100
Message-Id: <20210125074416.4056484-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function __team_compute_features() is protected by team->lock
mutex when it is called from team_compute_features() used when
features of an underlying device is changed. This causes
a deadlock when NETDEV_FEAT_CHANGE notifier for underlying device
is fired due to change propagated from team driver (e.g. MTU
change). It's because callbacks like team_change_mtu() or
team_vlan_rx_{add,del}_vid() protect their port list traversal
by team->lock mutex.

Example (r8169 case where this driver disables TSO for certain MTU
values):
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

In fact team_compute_features() called from team_device_event()
does not need to be protected by team->lock mutex and rcu_read_lock()
is sufficient there for port list traversal.

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: David S. Miller <davem@davemloft.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Saeed Mahameed <saeed@kernel.org>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/team/team.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index c19dac21c468..dd7917cab2b1 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -992,7 +992,8 @@ static void __team_compute_features(struct team *team)
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
 
-	list_for_each_entry(port, &team->port_list, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(port, &team->port_list, list) {
 		vlan_features = netdev_increment_features(vlan_features,
 					port->dev->vlan_features,
 					TEAM_VLAN_FEATURES);
@@ -1006,6 +1007,7 @@ static void __team_compute_features(struct team *team)
 		if (port->dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = port->dev->hard_header_len;
 	}
+	rcu_read_unlock();
 
 	team->dev->vlan_features = vlan_features;
 	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
@@ -1020,9 +1022,7 @@ static void __team_compute_features(struct team *team)
 
 static void team_compute_features(struct team *team)
 {
-	mutex_lock(&team->lock);
 	__team_compute_features(team);
-	mutex_unlock(&team->lock);
 	netdev_change_features(team->dev);
 }
 
-- 
2.26.2

