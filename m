Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5CF2310C2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731977AbgG1RUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:20:48 -0400
Received: from mail.katalix.com ([3.9.82.81]:43944 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731957AbgG1RUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 13:20:45 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 368AD7D370;
        Tue, 28 Jul 2020 18:20:44 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595956844; bh=XNqaJbPHHMnXglAIB/Wcv0YAaifck1sk8jH8nXjG9LI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=204/6]=20l2tp:=20remove=20build_
         header=20callback=20in=20struct=20l2tp_session|Date:=20Tue,=2028=2
         0Jul=202020=2018:20:31=20+0100|Message-Id:=20<20200728172033.19532
         -5-tparkin@katalix.com>|In-Reply-To:=20<20200728172033.19532-1-tpa
         rkin@katalix.com>|References:=20<20200728172033.19532-1-tparkin@ka
         talix.com>;
        b=legghd6lVRQZGr/FazsY7WovX9ohJfVMVMDdnt2kIx3MOlmWAidVbf+goOqaLx9a+
         xF9k/MO6iA4m/zpoY8zbw7OTR44Fn5HwsIvb5HpXi3ePmeWGqWHQK9HoHDOXdO7DrT
         UUyoI/T4wlv39j8Y8keOEbeoi2RkUsdIsY73RCrh+n/HL9Np/XjJHOX5GayZRu6UL8
         H6XIKkpkGBrka0qYvpEAXwuO12+SMzUxs0diSbJEoLcqMb58RLsBTiBOWl/0X/6irG
         kVosypdp5YettmJ+CO03DRpIvkpwj+RKhF2dDVzU6zAex5YiwLBZFICu6MF1EBkSD6
         YTJMWnguW8W2A==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 4/6] l2tp: remove build_header callback in struct l2tp_session
Date:   Tue, 28 Jul 2020 18:20:31 +0100
Message-Id: <20200728172033.19532-5-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728172033.19532-1-tparkin@katalix.com>
References: <20200728172033.19532-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The structure of an L2TP data packet header varies depending on the
version of the L2TP protocol being used.

struct l2tp_session used to have a build_header callback to abstract
this difference away.  It's clearer to simply choose the correct
function to use when building the data packet (and we save on the
function pointer in the session structure).

This approach does mean dereferencing the parent tunnel structure in
order to determine the tunnel version, but we're doing that in the
transmit path in any case.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 10 ++++------
 net/l2tp/l2tp_core.h |  1 -
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 690dcbc30472..3992af139479 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1116,7 +1116,10 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
 	}
 
 	/* Setup L2TP header */
-	session->build_header(session, __skb_push(skb, hdr_len));
+	if (tunnel->version == L2TP_HDR_VER_2)
+		l2tp_build_l2tpv2_header(session, __skb_push(skb, hdr_len));
+	else
+		l2tp_build_l2tpv3_header(session, __skb_push(skb, hdr_len));
 
 	/* Reset skb netfilter state */
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
@@ -1700,11 +1703,6 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 			memcpy(&session->peer_cookie[0], &cfg->peer_cookie[0], cfg->peer_cookie_len);
 		}
 
-		if (tunnel->version == L2TP_HDR_VER_2)
-			session->build_header = l2tp_build_l2tpv2_header;
-		else
-			session->build_header = l2tp_build_l2tpv3_header;
-
 		l2tp_session_set_header_len(session, tunnel->version);
 
 		refcount_set(&session->ref_count, 1);
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 0c32981f0cd3..3dfd3ddd28fd 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -101,7 +101,6 @@ struct l2tp_session {
 	struct l2tp_stats	stats;
 	struct hlist_node	global_hlist;	/* global hash list node */
 
-	int (*build_header)(struct l2tp_session *session, void *buf);
 	void (*recv_skb)(struct l2tp_session *session, struct sk_buff *skb, int data_len);
 	void (*session_close)(struct l2tp_session *session);
 	void (*show)(struct seq_file *m, void *priv);
-- 
2.17.1

