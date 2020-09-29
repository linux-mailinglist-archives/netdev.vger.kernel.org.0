Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F11927CC66
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732743AbgI2MgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729532AbgI2Mfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 08:35:46 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 118F9C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 05:35:46 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 24F5C86C83;
        Tue, 29 Sep 2020 13:35:44 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601382944; bh=soGIhdGRsvcoY5CEjyzWEm1prQSDuMRBpoHC/klPfoc=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=201/1]=20l2tp:=20repo
         rt=20rx=20cookie=20discards=20in=20netlink=20get|Date:=20Tue,=2029
         =20Sep=202020=2013:35:41=20+0100|Message-Id:=20<20200929123541.317
         80-1-tparkin@katalix.com>;
        b=YHgRSbvLOCOqexjfiJ4mF8i+g0YU3uB8/ATV0fqgBDIRP3k09Mj+M26USJK8TMckE
         XHc0ugjVTrmQCDZgaYQL+GyFTRUVitd3B7qGqyLhW44G1Zc1xn90jOID5i5asXdfPW
         ptFjF5uVx10jjvC8mwEJd9frzBT66cGl4eJjkk1Q0DnUoozKddPqCjHNkno8qO2pEr
         byv9IJH2O/7yVAFjBKciQbEuxJv4OgIhXRecnTXq4bRiqkmIQ6LXRyW4ctbpUC2wk6
         i5a2iTfBFMf5NoQCL4py6ekBWedLtvF1NSgQFjT3kqf3Pl5jQ/KtJdNp39X8fUFRRo
         rEuSPc5Myq4dg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 1/1] l2tp: report rx cookie discards in netlink get
Date:   Tue, 29 Sep 2020 13:35:41 +0100
Message-Id: <20200929123541.31780-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an L2TPv3 session receives a data frame with an incorrect cookie
l2tp_core logs a warning message and bumps a stats counter to reflect
the fact that the packet has been dropped.

However, the stats counter in question is missing from the l2tp_netlink
get message for tunnel and session instances.

Include the statistic in the netlink get response.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 include/uapi/linux/l2tp.h | 1 +
 net/l2tp/l2tp_netlink.c   | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/l2tp.h b/include/uapi/linux/l2tp.h
index 88a0d32b8c07..30c80d5ba4bf 100644
--- a/include/uapi/linux/l2tp.h
+++ b/include/uapi/linux/l2tp.h
@@ -144,6 +144,7 @@ enum {
 	L2TP_ATTR_RX_OOS_PACKETS,	/* u64 */
 	L2TP_ATTR_RX_ERRORS,		/* u64 */
 	L2TP_ATTR_STATS_PAD,
+	L2TP_ATTR_RX_COOKIE_DISCARDS,	/* u64 */
 	__L2TP_ATTR_STATS_MAX,
 };
 
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 83c015f7f20d..5ca5056e9636 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -420,6 +420,9 @@ static int l2tp_nl_tunnel_send(struct sk_buff *skb, u32 portid, u32 seq, int fla
 	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_SEQ_DISCARDS,
 			      atomic_long_read(&tunnel->stats.rx_seq_discards),
 			      L2TP_ATTR_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_COOKIE_DISCARDS,
+			      atomic_long_read(&tunnel->stats.rx_cookie_discards),
+			      L2TP_ATTR_STATS_PAD) ||
 	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_OOS_PACKETS,
 			      atomic_long_read(&tunnel->stats.rx_oos_packets),
 			      L2TP_ATTR_STATS_PAD) ||
@@ -760,6 +763,9 @@ static int l2tp_nl_session_send(struct sk_buff *skb, u32 portid, u32 seq, int fl
 	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_SEQ_DISCARDS,
 			      atomic_long_read(&session->stats.rx_seq_discards),
 			      L2TP_ATTR_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_COOKIE_DISCARDS,
+			      atomic_long_read(&session->stats.rx_cookie_discards),
+			      L2TP_ATTR_STATS_PAD) ||
 	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_OOS_PACKETS,
 			      atomic_long_read(&session->stats.rx_oos_packets),
 			      L2TP_ATTR_STATS_PAD) ||
-- 
2.17.1

