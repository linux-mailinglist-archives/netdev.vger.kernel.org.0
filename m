Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D0B322229
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 23:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhBVWbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 17:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhBVWa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 17:30:56 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14D6C06174A;
        Mon, 22 Feb 2021 14:30:16 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id j24so4583947pfi.2;
        Mon, 22 Feb 2021 14:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8rB7XHoP0ZeRGEybxMzkUNrsyW6ydwXiOdjNy5u1v+M=;
        b=UYD5t5x91J6fXBrK1eVlhxsn2RMfYrU3kYMa1pYPkjcuSiNEJEEEJs3MtZtJcigSe2
         RrVnZKkyLgKu3RLe3LNrSEHuJHo6ZzqzXvNCUihxhC3iY4sVe1511DEpFv6URzXsbGMj
         kAUsdogZl4rSA7Yad5egMNsHEN82jmYWLkUwIjuXGr+KPvLWN0xTh9Wn0K2+WeZxJ7N8
         hcArnpXk5m6RREKH5OeZG/6irMSl4WPC4CI62MjYtoFW4rG9YKDvCPhcIL3Ii95UE0tq
         zFFOWnI4Z1KgbUF6LWpjOKR3Il5ALPPekZWHNst49fRnZtiJBspoBheiCBTmoYTroYiq
         +crA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8rB7XHoP0ZeRGEybxMzkUNrsyW6ydwXiOdjNy5u1v+M=;
        b=sPAstYutDZDssz7Jkh+xxrCF7PRrIMRAu3vfsNSeECHVzyFbNazCHG8+2Qy5TbH4Gi
         n7oJmjDYytdmbO5Gozn8MqamWsTAga5lOX4gDkN1LYYCFQnRJ1SuUQT/gOyUMSAtSbJp
         KzedH8iGzdUYLOtdHMmFEAdawqB4X7P+u1zRVjlFVYYA5ZzFJwfFRQHU/iNYgPO3KOmJ
         yl/6buioFFrnFKKx8ZkKbsb/K66X2jvNIKhwN5HQnVKwemQSZQrLW3HArZaL2nTotiqg
         2HviFjHXNx+1TwNttfeOVI2OIDTnN7jkbhqgFI/Z5k9LrW8n6vbJkd3ikRlfatHbhaLF
         Dqqw==
X-Gm-Message-State: AOAM5335jVR4Dr8b1ZkwVYwxmfR4LEcdLsNpM5k/LvQ7vg9o1kEVXKnr
        GPxWeKlyY0Ez1m0Yjx5+75mZ+nRYM6I=
X-Google-Smtp-Source: ABdhPJyAPtIqUugSoJaZDIqpPQ7NVrf5B2jdzUPdejcZPbRGl3AM8n74+SQbbprebWD6t/bwHqz/Wg==
X-Received: by 2002:a63:d601:: with SMTP id q1mr21336880pgg.417.1614033015912;
        Mon, 22 Feb 2021 14:30:15 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gg5sm495385pjb.3.2021.02.22.14.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 14:30:15 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v2 1/2] net: dsa: bcm_sf2: Wire-up br_flags_pre, br_flags and set_mrouter
Date:   Mon, 22 Feb 2021 14:30:09 -0800
Message-Id: <20210222223010.2907234-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210222223010.2907234-1-f.fainelli@gmail.com>
References: <20210222223010.2907234-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because bcm_sf2 implements its own dsa_switch_ops we need to export the
b53_br_flags_pre(), b53_br_flags() and b53_set_mrouter so we can wire-up
them up like they used to be with the former b53_br_egress_floods().

Fixes: a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 19 +++++++++++--------
 drivers/net/dsa/b53/b53_priv.h   |  8 ++++++++
 drivers/net/dsa/bcm_sf2.c        |  3 +++
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ae86ded1e2a1..fceca3f5b6a5 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1953,19 +1953,20 @@ void b53_br_fast_age(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL(b53_br_fast_age);
 
-static int b53_br_flags_pre(struct dsa_switch *ds, int port,
-			    struct switchdev_brport_flags flags,
-			    struct netlink_ext_ack *extack)
+int b53_br_flags_pre(struct dsa_switch *ds, int port,
+		     struct switchdev_brport_flags flags,
+		     struct netlink_ext_ack *extack)
 {
 	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
 		return -EINVAL;
 
 	return 0;
 }
+EXPORT_SYMBOL(b53_br_flags_pre);
 
-static int b53_br_flags(struct dsa_switch *ds, int port,
-			struct switchdev_brport_flags flags,
-			struct netlink_ext_ack *extack)
+int b53_br_flags(struct dsa_switch *ds, int port,
+		 struct switchdev_brport_flags flags,
+		 struct netlink_ext_ack *extack)
 {
 	if (flags.mask & BR_FLOOD)
 		b53_port_set_ucast_flood(ds->priv, port,
@@ -1976,14 +1977,16 @@ static int b53_br_flags(struct dsa_switch *ds, int port,
 
 	return 0;
 }
+EXPORT_SYMBOL(b53_br_flags);
 
-static int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
-			   struct netlink_ext_ack *extack)
+int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
+		    struct netlink_ext_ack *extack)
 {
 	b53_port_set_mcast_flood(ds->priv, port, mrouter);
 
 	return 0;
 }
+EXPORT_SYMBOL(b53_set_mrouter);
 
 static bool b53_possible_cpu_port(struct dsa_switch *ds, int port)
 {
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index faf983fbca82..8419bb7f4505 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -326,6 +326,14 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *bridge);
 void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *bridge);
 void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
 void b53_br_fast_age(struct dsa_switch *ds, int port);
+int b53_br_flags_pre(struct dsa_switch *ds, int port,
+		     struct switchdev_brport_flags flags,
+		     struct netlink_ext_ack *extack);
+int b53_br_flags(struct dsa_switch *ds, int port,
+		 struct switchdev_brport_flags flags,
+		 struct netlink_ext_ack *extack);
+int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
+		    struct netlink_ext_ack *extack);
 int b53_setup_devlink_resources(struct dsa_switch *ds);
 void b53_port_event(struct dsa_switch *ds, int port);
 void b53_phylink_validate(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 1857aa9aa84a..3eaedbb12815 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1117,7 +1117,10 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.set_mac_eee		= b53_set_mac_eee,
 	.port_bridge_join	= b53_br_join,
 	.port_bridge_leave	= b53_br_leave,
+	.port_pre_bridge_flags	= b53_br_flags_pre,
+	.port_bridge_flags	= b53_br_flags,
 	.port_stp_state_set	= b53_br_set_stp_state,
+	.port_set_mrouter	= b53_set_mrouter,
 	.port_fast_age		= b53_br_fast_age,
 	.port_vlan_filtering	= b53_vlan_filtering,
 	.port_vlan_add		= b53_vlan_add,
-- 
2.25.1

