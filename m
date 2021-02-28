Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65113272EE
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 16:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhB1PUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 10:20:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22883 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230413AbhB1PTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 10:19:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614525508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FzPy8rjCfE+aeIPnfY5KvJTuaibGNzhMbRWIvII9Bk0=;
        b=Ey8OIwSYkNfuDzBr6MBf8C7YZmEJ10U43JGo/ePHxKXQDiwAbucPRO+/yrv3vNU47e+Y1k
        72Pz7XDuz+SNhTkeaLpfQS6pYRwoC1vvG25N7bLgKf5LXMJ+Jm80HNeU2PFAg5ZmxRbfKH
        gXjLHCINvF06bNJt5kineLgqnSGqbOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-mcjIwLwGNs6oWT9VocDrWQ-1; Sun, 28 Feb 2021 10:18:24 -0500
X-MC-Unique: mcjIwLwGNs6oWT9VocDrWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C8251005501;
        Sun, 28 Feb 2021 15:18:23 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-112-225.rdu2.redhat.com [10.10.112.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAF095C1D5;
        Sun, 28 Feb 2021 15:18:22 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wpan 02/17] net: ieee802154: fix memory leak when deliver monitor skbs
Date:   Sun, 28 Feb 2021 10:18:02 -0500
Message-Id: <20210228151817.95700-3-aahringo@redhat.com>
In-Reply-To: <20210228151817.95700-1-aahringo@redhat.com>
References: <20210228151817.95700-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a missing consume_skb() when deliver a skb to upper
monitor interfaces of a wpan phy.

Reported-by: syzbot+44b651863a17760a893b@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/mac802154/rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index b8ce84618a55..18abc1f49323 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -244,6 +244,8 @@ ieee802154_monitors_rx(struct ieee802154_local *local, struct sk_buff *skb)
 			sdata->dev->stats.rx_bytes += skb->len;
 		}
 	}
+
+	consume_skb(skb);
 }
 
 void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb)
-- 
2.26.2

