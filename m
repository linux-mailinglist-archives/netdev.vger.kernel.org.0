Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DE14577D6
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 21:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhKSUpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:45:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:43531 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233284AbhKSUow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:44:52 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10173"; a="231971904"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="231971904"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 12:41:46 -0800
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="506889214"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.14.166])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 12:41:44 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Poorva Sonparote <psonparo@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/4] ipv4: Exposing __ip_sock_set_tos() in ip.h
Date:   Fri, 19 Nov 2021 12:41:34 -0800
Message-Id: <20211119204137.415733-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119204137.415733-1-mathew.j.martineau@linux.intel.com>
References: <20211119204137.415733-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Poorva Sonparote <psonparo@redhat.com>

Making the static function __ip_sock_set_tos() from net/ipv4/ip_sockglue.c
accessible by declaring it in include/net/ip.h
The reason for doing this is to use this function to set IP_TOS value in
mptcp_setsockopt() without the lock.

Signed-off-by: Poorva Sonparote <psonparo@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/ip.h       | 1 +
 net/ipv4/ip_sockglue.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 7d1088888c10..81e23a102a0d 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -783,5 +783,6 @@ int ip_sock_set_mtu_discover(struct sock *sk, int val);
 void ip_sock_set_pktinfo(struct sock *sk);
 void ip_sock_set_recverr(struct sock *sk);
 void ip_sock_set_tos(struct sock *sk, int val);
+void  __ip_sock_set_tos(struct sock *sk, int val);
 
 #endif	/* _IP_H */
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 38d29b175ca6..445a9ecaefa1 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -576,7 +576,7 @@ int ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 	return err;
 }
 
-static void __ip_sock_set_tos(struct sock *sk, int val)
+void __ip_sock_set_tos(struct sock *sk, int val)
 {
 	if (sk->sk_type == SOCK_STREAM) {
 		val &= ~INET_ECN_MASK;
-- 
2.34.0

