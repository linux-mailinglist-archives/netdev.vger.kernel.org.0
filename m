Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6184AF252
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbiBINGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiBINGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:06:21 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3517C05CB97;
        Wed,  9 Feb 2022 05:06:20 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id i17so4001712lfg.11;
        Wed, 09 Feb 2022 05:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=inCVYeDu1fAept4QEpKoCkDC4Yb03qxpv1FlXIUns7I=;
        b=M6fijd92xKG7v+VrkmSvHMaDtbq/nAz0qMuwwXeK3zx2d2oUzm88mnnwcn7kLCBmZ9
         ZS8tlRUaikG/pKqHaot+sA8vRCtwngbdlwqkfqEjGwau30qHA0DW2AUL4mh8hk0PP38J
         t67jVBU0dJ1T4IMpd7SNXWDoB7VX5qY3wl9lkJwHXjudfQzWWxxRN+x/1mYqt/Qm9GbS
         S24lporKHPffI8akVjpH/Jk4YUWJegACOLhwi+6x9IQloBf4w1ono9to+Zvt1GRfkM/A
         0w4fRqNBMzUV8cP8Owr7iKyovAx9+0PmIfPqyFNFf/pFEhRXGlVjoe3SDij4ikyzHnkT
         z68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=inCVYeDu1fAept4QEpKoCkDC4Yb03qxpv1FlXIUns7I=;
        b=QXT3JkDEhIlIePNdhpbx1nNa5DVpKsWTLpJzniBrXezegkrPoKwpUOUZ0/Hvm/M2ti
         nGFw94Dx2Js4NyGy5co/GaGSqGLMAL1bsBwbl2jvEbuBdxhIeG/j3EIEAxhzo7Tth3ND
         K7608a9ILpsX0nEBd8N1A7imQi4x+5sXOS7kqjtHgmTLrn4/nFb7VD7ak6BmpeO1Rvd3
         h4Ezy/+6S5CR0kCFI9C+aPAO1YGHsKyLqzQN7338tyrXOfXOnKrv6zTuIyiHBQ08clzh
         h+cmvA7OlSgLgxAEBfICJMjqTGngwYyroNsWMSZeSZMqffC74RSiMurBv3y+sFnHf6L7
         JbvA==
X-Gm-Message-State: AOAM532Y1YlQ8gkJSgTeY4opgdnz2hxD5/0e9Q+zMLf6Hx1+COHa9JNL
        ED/jptbIEJU4lG47taFzw8E=
X-Google-Smtp-Source: ABdhPJxArIjJy06rYv/F/8Maxi6QhxTI2ECVBt8J3IcsCVrOM+EO1KUfCDbLSNfVTmC5MwuPOKsgzw==
X-Received: by 2002:a05:6512:1597:: with SMTP id bp23mr1660573lfb.347.1644411979092;
        Wed, 09 Feb 2022 05:06:19 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k3sm2352608lfo.127.2022.02.09.05.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 05:06:18 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <schultz.hans+lkml@gmail.com>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/5] net: bridge: Refactor bridge port in locked mode to use jump labels
Date:   Wed,  9 Feb 2022 14:05:37 +0100
Message-Id: <20220209130538.533699-6-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Schultz <schultz.hans+lkml@gmail.com>

As the locked mode feature is in the hot path of the bridge modules
reception of packets, it needs to be refactored to use jump labels
for optimization.

Signed-off-by: Hans Schultz <schultz.hans+lkml@gmail.com>
Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 net/bridge/br_input.c   | 22 ++++++++++++++++++----
 net/bridge/br_netlink.c |  6 ++++++
 net/bridge/br_private.h |  2 ++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 469e3adbce07..6fc428d6bac5 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -23,6 +23,18 @@
 #include "br_private.h"
 #include "br_private_tunnel.h"
 
+static struct static_key_false br_input_locked_port_feature;
+
+void br_input_locked_port_add(void)
+{
+	static_branch_inc(&br_input_locked_port_feature);
+}
+
+void br_input_locked_port_remove(void)
+{
+	static_branch_dec(&br_input_locked_port_feature);
+}
+
 static int
 br_netif_receive_skb(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
@@ -91,10 +103,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 				&state, &vlan))
 		goto out;
 
-	if (p->flags & BR_PORT_LOCKED) {
-		fdb_entry = br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
-		if (!(fdb_entry && fdb_entry->dst == p))
-			goto drop;
+	if (static_branch_unlikely(&br_input_locked_port_feature)) {
+		if (p->flags & BR_PORT_LOCKED) {
+			fdb_entry = br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
+			if (!(fdb_entry && fdb_entry->dst == p))
+				goto drop;
+		}
 	}
 
 	nbp_switchdev_frame_mark(p, skb);
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 7d4432ca9a20..e3dbe9fed75c 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -860,6 +860,7 @@ static int br_set_port_state(struct net_bridge_port *p, u8 state)
 static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
 			     int attrtype, unsigned long mask)
 {
+	bool locked = p->flags & BR_PORT_LOCKED;
 	if (!tb[attrtype])
 		return;
 
@@ -867,6 +868,11 @@ static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
 		p->flags |= mask;
 	else
 		p->flags &= ~mask;
+
+	if ((p->flags & BR_PORT_LOCKED) && !locked)
+		br_input_locked_port_add();
+	if (!(p->flags & BR_PORT_LOCKED) && locked)
+		br_input_locked_port_remove();
 }
 
 /* Process bridge protocol info on port */
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2661dda1a92b..0ec3ef897978 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -832,6 +832,8 @@ void br_manage_promisc(struct net_bridge *br);
 int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
 
 /* br_input.c */
+void br_input_locked_port_add(void);
+void br_input_locked_port_remove(void);
 int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
 rx_handler_func_t *br_get_rx_handler(const struct net_device *dev);
 
-- 
2.30.2

