Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3561DC3EF
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgEUAhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgEUAhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 20:37:23 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726ADC061A0F;
        Wed, 20 May 2020 17:37:23 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jbZD7-00CgdR-NS; Thu, 21 May 2020 00:37:21 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/19] compat_ip{,v6}_setsockopt(): enumerate MCAST_... options explicitly
Date:   Thu, 21 May 2020 01:37:04 +0100
Message-Id: <20200521003721.3023783-2-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
References: <20200521003657.GE23230@ZenIV.linux.org.uk>
 <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
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
index 8206047d70b6..3c2c6cd3933b 100644
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
index a0e50cc57e54..96e3f603c8d8 100644
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

