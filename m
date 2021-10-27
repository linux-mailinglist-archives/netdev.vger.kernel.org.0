Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34BD43CB27
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242260AbhJ0NwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:52:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237546AbhJ0NwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 09:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635342575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZD6LAq6atB4BsCmnlxgTYHzC6191yWWoUcGigwC22tc=;
        b=KjzIx8za4yy9NDex919H9ZF2RIgWs6tQiRoBcNEWe2hTAKjvRw7GeNOT0hHgEIMlZE+N/e
        +KZ8Bv64RyvlKm8JN7/0VYa8z1uLtUihuLWAuXLsYwFlN7Co2AqEZuNs02jS4vBkDllPfq
        Uacxoy30jH89OvVuJL8DQzvRBGWq5+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-uY69igsLMRWxG2prJR3BXw-1; Wed, 27 Oct 2021 09:49:31 -0400
X-MC-Unique: uY69igsLMRWxG2prJR3BXw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FF8C19253C2;
        Wed, 27 Oct 2021 13:49:30 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.193.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B708260CA0;
        Wed, 27 Oct 2021 13:49:27 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        bridge@lists.linux-foundation.org (moderated list:ETHERNET BRIDGE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: bridge: fix uninitialized variables when BRIDGE_CFM is disabled
Date:   Wed, 27 Oct 2021 15:49:26 +0200
Message-Id: <20211027134926.1412459-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function br_get_link_af_size_filtered() calls br_cfm_{,peer}_mep_count()
but does not check their return value. When BRIDGE_CFM is not enabled
these functions return -EOPNOTSUPP but do not modify count parameter.
Calling function then works with uninitialized variables.

Fixes: b6d0425b816e ("bridge: cfm: Netlink Notifications.")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 net/bridge/br_netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 5c6c4305ed23..12d602495ea0 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -126,8 +126,10 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
 		return vinfo_sz;
 
 	/* CFM status info must be added */
-	br_cfm_mep_count(br, &num_cfm_mep_infos);
-	br_cfm_peer_mep_count(br, &num_cfm_peer_mep_infos);
+	if (br_cfm_mep_count(br, &num_cfm_mep_infos) < 0)
+		num_cfm_mep_infos = 0;
+	if (br_cfm_peer_mep_count(br, &num_cfm_peer_mep_infos) < 0)
+		num_cfm_peer_mep_infos = 0;
 
 	vinfo_sz += nla_total_size(0);	/* IFLA_BRIDGE_CFM */
 	/* For each status struct the MEP instance (u32) is added */
-- 
2.32.0

