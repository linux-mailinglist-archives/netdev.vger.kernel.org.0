Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878B8351AD9
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbhDASDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:03:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236446AbhDAR6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:58:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gOPtje+FyDAgtorSzzokEKCOA5PME5R2rkhYp/Wn4fU=;
        b=PeNg3F4gBr983T7qUmh7RE61XPSvQAphX+YaAOFXzco2jT4q0IIDNyb0cv/JLNHaGu26HJ
        MaSm/2ca1NidTSG/VNFBgaHK4GE2zTPa6uHcg8TvLqt+S4WXKWHioghwZVpnwLA3XsdEI7
        EAHuRRZ5PciyDH75+C65j1L6w2S/pTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-HbE_SiGZPQ-ANp_LaR5DsA-1; Thu, 01 Apr 2021 12:58:10 -0400
X-MC-Unique: HbE_SiGZPQ-ANp_LaR5DsA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB49C6D242;
        Thu,  1 Apr 2021 16:58:09 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-240.ams2.redhat.com [10.36.114.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7316919C46;
        Thu,  1 Apr 2021 16:58:08 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/2] mptcp: forbit mcast-related sockopt on MPTCP sockets
Date:   Thu,  1 Apr 2021 18:57:44 +0200
Message-Id: <b7d0edf1f94da07d39e9319cdd78a7863473eacf.1617295578.git.pabeni@redhat.com>
In-Reply-To: <cover.1617295578.git.pabeni@redhat.com>
References: <cover.1617295578.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unrolling mcast state at msk dismantel time is bug prone, as
syzkaller reported:

======================================================
WARNING: possible circular locking dependency detected
5.11.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor905/8822 is trying to acquire lock:
ffffffff8d678fe8 (rtnl_mutex){+.+.}-{3:3}, at: ipv6_sock_mc_close+0xd7/0x110 net/ipv6/mcast.c:323

but task is already holding lock:
ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1600 [inline]
ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp6_release+0x57/0x130 net/mptcp/protocol.c:3507

which lock already depends on the new lock.

Instead we can simply forbit any mcast-related setsockopt

Fixes: 717e79c867ca5 ("mptcp: Add setsockopt()/getsockopt() socket operations")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 45 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1590b9d4cde2..e06cea0a3c54 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2878,6 +2878,48 @@ static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
 	return ret;
 }
 
+static bool mptcp_unsupported(int level, int optname)
+{
+	if (level == SOL_IP) {
+		switch (optname) {
+		case IP_ADD_MEMBERSHIP:
+		case IP_ADD_SOURCE_MEMBERSHIP:
+		case IP_DROP_MEMBERSHIP:
+		case IP_DROP_SOURCE_MEMBERSHIP:
+		case IP_BLOCK_SOURCE:
+		case IP_UNBLOCK_SOURCE:
+		case MCAST_JOIN_GROUP:
+		case MCAST_LEAVE_GROUP:
+		case MCAST_JOIN_SOURCE_GROUP:
+		case MCAST_LEAVE_SOURCE_GROUP:
+		case MCAST_BLOCK_SOURCE:
+		case MCAST_UNBLOCK_SOURCE:
+		case MCAST_MSFILTER:
+			return true;
+		}
+		return false;
+	}
+	if (level == SOL_IPV6) {
+		switch (optname) {
+		case IPV6_ADDRFORM:
+		case IPV6_ADD_MEMBERSHIP:
+		case IPV6_DROP_MEMBERSHIP:
+		case IPV6_JOIN_ANYCAST:
+		case IPV6_LEAVE_ANYCAST:
+		case MCAST_JOIN_GROUP:
+		case MCAST_LEAVE_GROUP:
+		case MCAST_JOIN_SOURCE_GROUP:
+		case MCAST_LEAVE_SOURCE_GROUP:
+		case MCAST_BLOCK_SOURCE:
+		case MCAST_UNBLOCK_SOURCE:
+		case MCAST_MSFILTER:
+			return true;
+		}
+		return false;
+	}
+	return false;
+}
+
 static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 			    sockptr_t optval, unsigned int optlen)
 {
@@ -2886,6 +2928,9 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 
 	pr_debug("msk=%p", msk);
 
+	if (mptcp_unsupported(level, optname))
+		return -ENOPROTOOPT;
+
 	if (level == SOL_SOCKET)
 		return mptcp_setsockopt_sol_socket(msk, optname, optval, optlen);
 
-- 
2.26.2

