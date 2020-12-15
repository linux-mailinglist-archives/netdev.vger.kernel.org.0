Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0372DA9C8
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 10:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgLOJJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 04:09:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47035 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbgLOJJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 04:09:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608023295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4gYBOP33QdFdZSUoa2zTJZUlxRo9LWgtPUFhjV1xbUA=;
        b=PCt5+xYEkb2uIRFthcTZCvVIffFKLi4D379pXfUkLq8TIKdNUCQcMN0cJIAG1S7LsbVLrW
        ie7jzIE4enPTrowCslQI5SDuK1BYwmgzWXdUtp1uD/er/nf9UQ5c6GsuP4FAiMPT311VWU
        7cIE3CwN8NAp/OvhABUu3EN/Jyu8mhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-5-bvWVZbMfiPgAQhmRvYcQ-1; Tue, 15 Dec 2020 04:08:13 -0500
X-MC-Unique: 5-bvWVZbMfiPgAQhmRvYcQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F3A251083;
        Tue, 15 Dec 2020 09:08:12 +0000 (UTC)
Received: from ceranb.redhat.com (ovpn-116-72.ams2.redhat.com [10.36.116.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A22E13470;
        Tue, 15 Dec 2020 09:08:11 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>, LiLiang <liali@redhat.com>
Subject: [PATCH net] ethtool: fix error paths in ethnl_set_channels()
Date:   Tue, 15 Dec 2020 10:08:10 +0100
Message-Id: <20201215090810.801777-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two error paths in ethnl_set_channels() to avoid lock-up caused
but unreleased RTNL.

Fixes: e19c591eafad ("ethtool: set device channel counts with CHANNELS_SET request")
Cc: Michal Kubecek <mkubecek@suse.cz>
Reported-by: LiLiang <liali@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 net/ethtool/channels.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 5635604cb9ba..25a9e566ef5c 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -194,8 +194,9 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	if (netif_is_rxfh_configured(dev) &&
 	    !ethtool_get_max_rxfh_channel(dev, &max_rx_in_use) &&
 	    (channels.combined_count + channels.rx_count) <= max_rx_in_use) {
+		ret = -EINVAL;
 		GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing indirection table settings");
-		return -EINVAL;
+		goto out_ops;
 	}
 
 	/* Disabling channels, query zero-copy AF_XDP sockets */
@@ -203,8 +204,9 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 		       min(channels.rx_count, channels.tx_count);
 	for (i = from_channel; i < old_total; i++)
 		if (xsk_get_pool_from_qid(dev, i)) {
+			ret = -EINVAL;
 			GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing zerocopy AF_XDP sockets");
-			return -EINVAL;
+			goto out_ops;
 		}
 
 	ret = dev->ethtool_ops->set_channels(dev, &channels);
-- 
2.26.2

