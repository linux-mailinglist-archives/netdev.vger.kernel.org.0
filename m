Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 420F17A81E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 14:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfG3MVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 08:21:15 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53359 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfG3MVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 08:21:15 -0400
Received: by mail-wm1-f66.google.com with SMTP id x15so56971422wmj.3
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 05:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TlNchQ/vtVIj+X/dPogW/VhRCNvW7uKobaOaSR9wIVw=;
        b=XztUXeM97JDaihnB0HagW5xvRBMhRYAr79vQdfBG04yIqoZYcKub3kXOUsu9ULFsjm
         BIzlEU01i72gcZwbffxBob+Ml856DF5tWt2iinloyTic4HrdjAPmJmjuHsJ1aFytONGB
         EsMVjzQJwTbx1vE/QlYDqe3xTgtpoPu9BXczg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TlNchQ/vtVIj+X/dPogW/VhRCNvW7uKobaOaSR9wIVw=;
        b=rz14bgcHEXmo1U7X0+G8Hd7kR8N3++vaSyoJrBSR01VCtYcHoxgrBuNtzWtamRbJrD
         51V0yp0BfJWrC/oag3hW23adSOGkBteHxnNfI/KicbiAwKxwRsi4XKceG48ABXTOn7tH
         z7VAztJusvXYPwWn+xOw8I2CHhe6TpIVF+/Tcuf4ne1V51M1JBtCGcHe6oghYPcbZzKT
         +uUNsmis5DARarOZqLIQ9xy5UxsTHkVG0NrRECP3taAS8tJPdJfs+JYPZpagqOjn9pX8
         dCoL7JVEEjcfPb8bwR83/uG0hAXmsffLiUjmAUKNAMexIGL4vETH4hlhb0HzM17kBEN6
         kzkQ==
X-Gm-Message-State: APjAAAVvn+FPS/5TKWwNnBi4J7D/2UxxOWyHeDHyB8XSJGOKpW/MIU0t
        rWMTCJ++32LBOZj2FbgZj38UkmrAA6s=
X-Google-Smtp-Source: APXvYqz/bHR9d2rrOZ/49Uk9ujDRweI5mm2fYTQ2y7HdZbDIekx0jz1Rut9ZywlIODtRP0IhMrEqog==
X-Received: by 2002:a1c:a848:: with SMTP id r69mr102326719wme.12.1564489272624;
        Tue, 30 Jul 2019 05:21:12 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id l25sm49316717wme.13.2019.07.30.05.21.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 05:21:11 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next] net: bridge: mcast: add delete due to fast-leave mdb flag
Date:   Tue, 30 Jul 2019 15:20:41 +0300
Message-Id: <20190730122041.14647-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In user-space there's no way to distinguish why an mdb entry was deleted
and that is a problem for daemons which would like to keep the mdb in
sync with remote ends (e.g. mlag) but would also like to converge faster.
In almost all cases we'd like to age-out the remote entry for performance
and convergence reasons except when fast-leave is enabled. In that case we
want explicit immediate remote delete, thus add mdb flag which is set only
when the entry is being deleted due to fast-leave.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/if_bridge.h | 1 +
 net/bridge/br_mdb.c            | 2 ++
 net/bridge/br_multicast.c      | 2 +-
 net/bridge/br_private.h        | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 773e476a8e54..1b3c2b643a02 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -237,6 +237,7 @@ struct br_mdb_entry {
 #define MDB_PERMANENT 1
 	__u8 state;
 #define MDB_FLAGS_OFFLOAD	(1 << 0)
+#define MDB_FLAGS_FAST_LEAVE	(1 << 1)
 	__u8 flags;
 	__u16 vid;
 	struct {
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index bf6acd34234d..428af1abf8cc 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -60,6 +60,8 @@ static void __mdb_entry_fill_flags(struct br_mdb_entry *e, unsigned char flags)
 	e->flags = 0;
 	if (flags & MDB_PG_FLAGS_OFFLOAD)
 		e->flags |= MDB_FLAGS_OFFLOAD;
+	if (flags & MDB_PG_FLAGS_FAST_LEAVE)
+		e->flags |= MDB_FLAGS_FAST_LEAVE;
 }
 
 static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3d8deac2353d..3d4b2817687f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1393,7 +1393,7 @@ br_multicast_leave_group(struct net_bridge *br,
 			del_timer(&p->timer);
 			kfree_rcu(p, rcu);
 			br_mdb_notify(br->dev, port, group, RTM_DELMDB,
-				      p->flags);
+				      p->flags | MDB_PG_FLAGS_FAST_LEAVE);
 
 			if (!mp->ports && !mp->host_joined &&
 			    netif_running(br->dev))
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e8cf03b43b7d..c4fd307fbfdc 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -199,6 +199,7 @@ struct net_bridge_fdb_entry {
 
 #define MDB_PG_FLAGS_PERMANENT	BIT(0)
 #define MDB_PG_FLAGS_OFFLOAD	BIT(1)
+#define MDB_PG_FLAGS_FAST_LEAVE	BIT(2)
 
 struct net_bridge_port_group {
 	struct net_bridge_port		*port;
-- 
2.21.0

