Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A2C41C1E3
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245169AbhI2JrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:47:15 -0400
Received: from mail.katalix.com ([3.9.82.81]:53944 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245148AbhI2JrH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 05:47:07 -0400
Received: from jackdaw.fritz.box (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id C01388CC16;
        Wed, 29 Sep 2021 10:45:24 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1632908724; bh=xgnKTiKAHj2t8C7qArCdn1TWuNDj6IvusqcbCoGzhMc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[RFC=20PATCH=20net-next=202/3]=20net/l2
         tp:=20add=20flow-based=20session=20create=20API|Date:=20Wed,=2029=
         20Sep=202021=2010:45:13=20+0100|Message-Id:=20<20210929094514.1504
         8-3-tparkin@katalix.com>|In-Reply-To:=20<20210929094514.15048-1-tp
         arkin@katalix.com>|References:=20<20210929094514.15048-1-tparkin@k
         atalix.com>;
        b=3BncXojr3d99Z7AYr38bFf1QDAm1DVR+uZOo+py9MsgPmixyQXW2wNsJyuki0XeSy
         DT0dBVRB+dU6MCjTmliqSXxl9l0O4ZZ1smYV1R0I8pCIEf7vwfZearb4ziE+KwWyMC
         12CgOe/WMTqyDCjKKDSYuOun8UYdPS+RmJs1uexsbq3I+BeWnF4m/mCFSymLg41lWo
         W6AdJYOuctXdITUL8yYEKVM2v7zvIu3874YLFq+gE5/YirnogHr1TS8eUihbTrf0m7
         Cod8Dfmh4frZZ3XBhwb2MovV4tIScUUg6PnKf5XLa4q8UZOYhro3BP0t/ZosNdZyPP
         ltDLwzBfO+4mQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [RFC PATCH net-next 2/3] net/l2tp: add flow-based session create API
Date:   Wed, 29 Sep 2021 10:45:13 +0100
Message-Id: <20210929094514.15048-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210929094514.15048-1-tparkin@katalix.com>
References: <20210929094514.15048-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support multiple logical sessions over a single L2TP tunnel
virtual netdev, the L2TP session creation API needs to be extended.  The
new "flow-based" sessions will not create a virtual net device
per-session, but instead will use tc rules and tunnel metadata to direct
traffic:

        tc qdisc add dev l2tpt1 handle ffff: ingress
        tc filter add dev l2tpt1 parent ffff: flower enc_key_id 1 \
                action mirred egress redirect dev eth0

To allow this session type to co-exist with the existing pseudowire
types, define a new API for creating flow-based sessions which the
l2tp netlink code can call directly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
 net/l2tp/l2tp_core.h |  8 ++++++++
 2 files changed, 54 insertions(+)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 6a4d3d785c65..dd0b1d64fd14 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1661,6 +1661,52 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 }
 EXPORT_SYMBOL_GPL(l2tp_session_create);
 
+static void l2tp_flow_recv(struct l2tp_session *session, struct sk_buff *skb, int data_len)
+{
+	struct metadata_dst *mdst;
+	__be64 id;
+
+	if (!session->tunnel->dev)
+		goto drop;
+
+	id = key32_to_tunnel_id(htonl(session->session_id));
+
+	mdst = ip_tun_rx_dst(skb, TUNNEL_KEY, id, sizeof(*mdst));
+	if (!mdst)
+		goto drop;
+
+	skb->skb_iif = skb->dev->ifindex;
+	skb->dev = session->tunnel->dev;
+	skb_dst_set(skb, (struct dst_entry *)mdst);
+	skb_reset_mac_header(skb);
+	netif_receive_skb(skb);
+	return;
+
+drop:
+	kfree_skb(skb);
+}
+
+int l2tp_flow_session_create(struct l2tp_tunnel *tunnel,
+			     u32 session_id, u32 peer_session_id,
+			     struct l2tp_session_cfg *cfg)
+{
+	struct l2tp_session *session;
+	int ret;
+
+	session = l2tp_session_create(0, tunnel, session_id, peer_session_id, cfg);
+	if (IS_ERR(session)) {
+		ret = PTR_ERR(session);
+		goto out;
+	}
+
+	session->recv_skb = l2tp_flow_recv;
+
+	ret = l2tp_session_register(session, tunnel);
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(l2tp_flow_session_create);
+
 /*****************************************************************************
  * Tunnel virtual netdev
  *****************************************************************************/
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 4d2aeb852f38..1a0b9859a7e1 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -252,6 +252,14 @@ int l2tp_session_register(struct l2tp_session *session,
 			  struct l2tp_tunnel *tunnel);
 void l2tp_session_delete(struct l2tp_session *session);
 
+/* Flow-based session.
+ * Optimised datapath which doesn't require a netdev per session instance
+ * and which is managed from userspace using tc rules.
+ */
+int l2tp_flow_session_create(struct l2tp_tunnel *tunnel,
+			     u32 session_id, u32 peer_session_id,
+			     struct l2tp_session_cfg *cfg);
+
 /* Receive path helpers.  If data sequencing is enabled for the session these
  * functions handle queuing and reordering prior to passing packets to the
  * pseudowire code to be passed to userspace.
-- 
2.17.1

