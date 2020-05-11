Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D4F1CD0E7
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 06:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgEKEp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 00:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725863AbgEKEpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 00:45:55 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44625C061A0E;
        Sun, 10 May 2020 21:45:55 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY0K9-005jHV-Kb; Mon, 11 May 2020 04:45:53 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/19] compat_ip{,v6}_setsockopt(): enumerate MCAST_... options explicitly
Date:   Mon, 11 May 2020 05:45:36 +0100
Message-Id: <20200511044553.1365660-2-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
References: <20200511044328.GP23230@ZenIV.linux.org.uk>
 <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

We want to check if optname is among the MCAST_... ones; do that as
an explicit switch.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/ipv4/ip_sockglue.c   | 10 +++++++++-
 net/ipv6/ipv6_sockglue.c | 10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index aa3fd61818c4..8f550cf4c1c0 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1272,9 +1272,17 @@ int compat_ip_setsockopt(struct sock *sk, int level, int optname,
 	if (level != SOL_IP)
 		return -ENOPROTOOPT;
 
-	if (optname >= MCAST_JOIN_GROUP && optname <= MCAST_MSFILTER)
+	switch (optname) {
+	case MCAST_JOIN_GROUP:
+	case MCAST_LEAVE_GROUP:
+	case MCAST_JOIN_SOURCE_GROUP:
+	case MCAST_LEAVE_SOURCE_GROUP:
+	case MCAST_BLOCK_SOURCE:
+	case MCAST_UNBLOCK_SOURCE:
+	case MCAST_MSFILTER:
 		return compat_mc_setsockopt(sk, level, optname, optval, optlen,
 			ip_setsockopt);
+	}
 
 	err = do_ip_setsockopt(sk, level, optname, optval, optlen);
 #ifdef CONFIG_NETFILTER
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 18d05403d3b5..1b4ad4f8dc42 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -973,9 +973,17 @@ int compat_ipv6_setsockopt(struct sock *sk, int level, int optname,
 	if (level != SOL_IPV6)
 		return -ENOPROTOOPT;
 
-	if (optname >= MCAST_JOIN_GROUP && optname <= MCAST_MSFILTER)
+	switch (optname) {
+	case MCAST_JOIN_GROUP:
+	case MCAST_LEAVE_GROUP:
+	case MCAST_JOIN_SOURCE_GROUP:
+	case MCAST_LEAVE_SOURCE_GROUP:
+	case MCAST_BLOCK_SOURCE:
+	case MCAST_UNBLOCK_SOURCE:
+	case MCAST_MSFILTER:
 		return compat_mc_setsockopt(sk, level, optname, optval, optlen,
 			ipv6_setsockopt);
+	}
 
 	err = do_ipv6_setsockopt(sk, level, optname, optval, optlen);
 #ifdef CONFIG_NETFILTER
-- 
2.11.0

