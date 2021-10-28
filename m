Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C85C43E59C
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhJ1QBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:01:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230230AbhJ1QBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635436729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/ZAZTdtyaSOOs5rc8T6wOKjWpg0v6cCvD+QvTGbgJzM=;
        b=fncM32Xq+ocAweOHBHZHf8SdQGz5pNTtkeYgl0mmhcPqGLv3bz6/zYvf4TGEhwSGDJiKeO
        v0BXIF0VwfoyqF+6/tF4Wxez0VThy67CrMYlZ7sj4ldwBNPcPIm0NsvE08X7ml74IIHb8q
        /nhu29dfTJmN8TQgBnyuqvFBo7lpA7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-7JO76a4UO0ma4pJGbmmnkg-1; Thu, 28 Oct 2021 11:58:44 -0400
X-MC-Unique: 7JO76a4UO0ma4pJGbmmnkg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C2E19126B;
        Thu, 28 Oct 2021 15:58:42 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.193.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE9805DF56;
        Thu, 28 Oct 2021 15:58:36 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        bridge@lists.linux-foundation.org (moderated list:ETHERNET BRIDGE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v2] net: bridge: fix uninitialized variables when BRIDGE_CFM is disabled
Date:   Thu, 28 Oct 2021 17:58:35 +0200
Message-Id: <20211028155835.2134753-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function br_get_link_af_size_filtered() calls br_cfm_{,peer}_mep_count()
that return a count. When BRIDGE_CFM is not enabled these functions
simply return -EOPNOTSUPP but do not modify count parameter and
calling function then works with uninitialized variables.
Modify these inline functions to return zero in count parameter.

Fixes: b6d0425b816e ("bridge: cfm: Netlink Notifications.")
Cc: Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 net/bridge/br_private.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 37ca76406f1e..fd5e7e74573c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1911,11 +1911,13 @@ static inline int br_cfm_status_fill_info(struct sk_buff *skb,
 
 static inline int br_cfm_mep_count(struct net_bridge *br, u32 *count)
 {
+	*count = 0;
 	return -EOPNOTSUPP;
 }
 
 static inline int br_cfm_peer_mep_count(struct net_bridge *br, u32 *count)
 {
+	*count = 0;
 	return -EOPNOTSUPP;
 }
 #endif
-- 
2.32.0

