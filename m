Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF2011B878
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 17:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbfLKQVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 11:21:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43399 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728912AbfLKQVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 11:21:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576081271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=2CgaiZGVWW/n9d9DIQJ26nfHPuXR8n4Y20ID89ySQq0=;
        b=eXw45Q77y+oesXgUi7dzT6Lk0VpOThaWDBZ8WmkxIDa1TnxnU6J5ohSd26bj0IEplp1BIp
        JrgXy6OGAgruiylfEuYnP4+prdyL9ZHKO8ApYwYPyDFAQJi4NhtGNORmlXrIf9BSphl1j5
        MRnQaE2GAdKB4Rk0p+zGlQt1VzCxNXE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-e2xumNFrN_iFh8dCXO33nQ-1; Wed, 11 Dec 2019 11:21:10 -0500
X-MC-Unique: e2xumNFrN_iFh8dCXO33nQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74CC78DCCFD
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 16:21:09 +0000 (UTC)
Received: from ocho.redhat.com (ovpn-117-26.ams2.redhat.com [10.36.117.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9F5919C69;
        Wed, 11 Dec 2019 16:21:08 +0000 (UTC)
From:   Patrick Talbert <ptalbert@redhat.com>
To:     netdev@vger.kernel.org
Cc:     ptalbert@redhat.com
Subject: [PATCH net-next] net: Use rx_nohandler for unhandled packets
Date:   Wed, 11 Dec 2019 17:21:07 +0100
Message-Id: <20191211162107.4326-1-ptalbert@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since caf586e5f23c ("net: add a core netdev->rx_dropped counter") incoming
packets which do not have a handler cause a counter named rx_dropped to be
incremented. This can lead to confusion as some see a non-zero "drop"
counter as cause for concern.

To avoid any confusion, instead use the existing rx_nohandler counter. Its
name more closely aligns with the activity being tracked here.

Signed-off-by: Patrick Talbert <ptalbert@redhat.com>
---
 include/linux/netdevice.h |  5 +++--
 net/core/dev.c            | 15 +++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9ef20389622d..3d194cea9859 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1618,8 +1618,9 @@ enum netdev_priv_flags {
  *			do not use this in drivers
  *	@tx_dropped:	Dropped packets by core network,
  *			do not use this in drivers
- *	@rx_nohandler:	nohandler dropped packets by core network on
- *			inactive devices, do not use this in drivers
+ *	@rx_nohandler:	Dropped packets by core network when they were not handled
+ *			by any protocol/socket or the device was inactive,
+ *			do not use this in drivers.
  *	@carrier_up_count:	Number of times the carrier has been up
  *	@carrier_down_count:	Number of times the carrier has been down
  *
diff --git a/net/core/dev.c b/net/core/dev.c
index 2c277b8aba38..11e500f8ffa3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5123,20 +5123,19 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 			goto drop;
 		*ppt_prev = pt_prev;
 	} else {
-drop:
-		if (!deliver_exact)
-			atomic_long_inc(&skb->dev->rx_dropped);
-		else
-			atomic_long_inc(&skb->dev->rx_nohandler);
+		/* We have not delivered the skb anywhere */
+		atomic_long_inc(&skb->dev->rx_nohandler);
 		kfree_skb(skb);
-		/* Jamal, now you will not able to escape explaining
-		 * me how you were going to use this. :-)
-		 */
 		ret = NET_RX_DROP;
 	}
 
 out:
 	return ret;
+drop:
+	atomic_long_inc(&skb->dev->rx_dropped);
+	kfree_skb(skb);
+	ret = NET_RX_DROP;
+	goto out;
 }
 
 static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
-- 
2.18.1

