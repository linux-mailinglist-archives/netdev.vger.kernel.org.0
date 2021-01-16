Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1E72F8A6C
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbhAPB0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbhAPB0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:26:31 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02D0C0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:50 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id b26so15901824lff.9
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=VnbZUGhcOcO+Dyfe5nmSkUdTecUEO+CYWc9F7HJm+xQ=;
        b=u/xiGqHASyNi6U+TBBRafbPtnLFhXjnF0x+VbB3jgdto3KayHnuBpzeNesKRLdObqy
         v78R/tEYUViGBV2XFwgKkt5U3/33httFfl9+HO/3q32A+qLLcjwU89rciQ31FkQ/LZ3R
         SY7svvUc5AY2UeV5DO/0wYxogEFB8oOh6B1qbnJbSgKjDt/FDVeJQA3NM+9YEEzrTirv
         lV2vB4PO+LE5/Q2LXQwPtf50xp4Ow2HFuSzE6YiSsotK0kASCBYJSId9voVeUMqlEK7W
         zxt764aFW5bfqie8YGt1TNhrbX1YoJwCOhS0bIhmTl57j/fajEKv+tz522YCF3Hmr80f
         XR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=VnbZUGhcOcO+Dyfe5nmSkUdTecUEO+CYWc9F7HJm+xQ=;
        b=oOEEedlBC6d4t5OHg7E1INB5hC3RPnKVB9gRNbwm4ZOAqakw1te1OZiQaEVIa6wrUc
         6rqu2kAgTd+yxBm7dQ0ckodb8riL8Sadr97uPfm1DTIKthfKoxbUVD1qmZl5TfJ9qwsl
         yVvPF5UCis2SvoE4I05DuCLqYgjJUjE8BKQ5T/Ygm67Qc3lx1Mj/Sy0+x6FYRD9dJy5j
         zHQWoQyxTLmH2aXyiZ6CGSI9lnanx62h2zQwEltwZuWwtJVqWYAJmdBu1qeUSGJDAWer
         6ye9mxFR+hb0SZkkhn1rCevFSHkG8vzV4XAEZSaJRccBPihE3LJN3ZMb2G2yk8eRZvaw
         BupA==
X-Gm-Message-State: AOAM530Bx5r5oPD/UoqzNaQh11t3vrMKoQoQ8XNVuB0EhRsOy6fGWtaY
        v60TiKrMBkFaKQQ/rx4rRnYyMQ==
X-Google-Smtp-Source: ABdhPJw05sk3dyqgdQE5pDNJcrQThTU1InkB3d1RJhppXUi8Qng5snESj4eiJeexejwPtZZutIeYUQ==
X-Received: by 2002:a19:430f:: with SMTP id q15mr6699770lfa.6.1610760349226;
        Fri, 15 Jan 2021 17:25:49 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 198sm1085686lfn.51.2021.01.15.17.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:25:48 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org
Subject: [RFC net-next 1/7] net: bridge: switchdev: Refactor br_switchdev_fdb_notify
Date:   Sat, 16 Jan 2021 02:25:09 +0100
Message-Id: <20210116012515.3152-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210116012515.3152-1-tobias@waldekranz.com>
References: <20210116012515.3152-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having to add more and more arguments to
br_switchdev_fdb_call_notifiers, get rid of it and build the info
struct directly in br_switchdev_fdb_notify.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/bridge/br_switchdev.c | 41 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index a9c23ef83443..ff470add8e52 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -102,46 +102,27 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	return 0;
 }
 
-static void
-br_switchdev_fdb_call_notifiers(bool adding, const unsigned char *mac,
-				u16 vid, struct net_device *dev,
-				bool added_by_user, bool offloaded)
-{
-	struct switchdev_notifier_fdb_info info;
-	unsigned long notifier_type;
-
-	info.addr = mac;
-	info.vid = vid;
-	info.added_by_user = added_by_user;
-	info.offloaded = offloaded;
-	notifier_type = adding ? SWITCHDEV_FDB_ADD_TO_DEVICE : SWITCHDEV_FDB_DEL_TO_DEVICE;
-	call_switchdev_notifiers(notifier_type, dev, &info.info, NULL);
-}
-
 void
 br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 {
+	struct switchdev_notifier_fdb_info info = {
+		.addr = fdb->key.addr.addr,
+		.vid = fdb->key.vlan_id,
+		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
+		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
+	};
+
 	if (!fdb->dst)
 		return;
 
 	switch (type) {
 	case RTM_DELNEIGH:
-		br_switchdev_fdb_call_notifiers(false, fdb->key.addr.addr,
-						fdb->key.vlan_id,
-						fdb->dst->dev,
-						test_bit(BR_FDB_ADDED_BY_USER,
-							 &fdb->flags),
-						test_bit(BR_FDB_OFFLOADED,
-							 &fdb->flags));
+		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
+					 fdb->dst->dev, &info.info, NULL);
 		break;
 	case RTM_NEWNEIGH:
-		br_switchdev_fdb_call_notifiers(true, fdb->key.addr.addr,
-						fdb->key.vlan_id,
-						fdb->dst->dev,
-						test_bit(BR_FDB_ADDED_BY_USER,
-							 &fdb->flags),
-						test_bit(BR_FDB_OFFLOADED,
-							 &fdb->flags));
+		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
+					 fdb->dst->dev, &info.info, NULL);
 		break;
 	}
 }
-- 
2.17.1

