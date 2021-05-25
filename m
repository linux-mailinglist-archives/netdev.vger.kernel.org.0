Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42E3390B45
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 23:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbhEYVZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 17:25:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:19651 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232942AbhEYVYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 17:24:53 -0400
IronPort-SDR: rkn1WbfTOJpU1qtNB2DpNiLGt0+T+JwIO1FL2THONNIDLxOF66jIsX7vT51BvRV4p6gukvdZru
 P99BQ822eH1Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9995"; a="263511360"
X-IronPort-AV: E=Sophos;i="5.82,329,1613462400"; 
   d="scan'208";a="263511360"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 14:23:20 -0700
IronPort-SDR: AkRQgx3l6XxrMfPZk6lqkVICyf7KBM/zkkTtmFsiAML5rFkEiYkTSElc4O91GAsJlRQEKG7Edm
 iBxTWTtK1h9Q==
X-IronPort-AV: E=Sophos;i="5.82,329,1613462400"; 
   d="scan'208";a="546924975"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.216.142])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 14:23:19 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 4/4] mptcp: validate 'id' when stopping the ADD_ADDR retransmit timer
Date:   Tue, 25 May 2021 14:23:13 -0700
Message-Id: <20210525212313.148142-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210525212313.148142-1-mathew.j.martineau@linux.intel.com>
References: <20210525212313.148142-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

when Linux receives an echo-ed ADD_ADDR, it checks the IP address against
the list of "announced" addresses. In case of a positive match, the timer
that handles retransmissions is stopped regardless of the 'Address Id' in
the received packet: this behaviour does not comply with RFC8684 3.4.1.

Fix it by validating the 'Address Id' in received echo-ed ADD_ADDRs.
Tested using packetdrill, with the following captured output:

 unpatched kernel:

 Out <...> Flags [.], ack 1, win 256, options [mptcp add-addr v1 id 1 198.51.100.2 hmac 0xfd2e62517888fe29,mptcp dss ack 3007449509], length 0
 In  <...> Flags [.], ack 1, win 257, options [mptcp add-addr v1-echo id 1 1.2.3.4,mptcp dss ack 3013740213], length 0
 Out <...> Flags [.], ack 1, win 256, options [mptcp add-addr v1 id 1 198.51.100.2 hmac 0xfd2e62517888fe29,mptcp dss ack 3007449509], length 0
 In  <...> Flags [.], ack 1, win 257, options [mptcp add-addr v1-echo id 90 198.51.100.2,mptcp dss ack 3013740213], length 0
        ^^^ retransmission is stopped here, but 'Address Id' is 90

 patched kernel:

 Out <...> Flags [.], ack 1, win 256, options [mptcp add-addr v1 id 1 198.51.100.2 hmac 0x1cf372d59e05f4b8,mptcp dss ack 3007449509], length 0
 In  <...> Flags [.], ack 1, win 257, options [mptcp add-addr v1-echo id 1 1.2.3.4,mptcp dss ack 1672384568], length 0
 Out <...> Flags [.], ack 1, win 256, options [mptcp add-addr v1 id 1 198.51.100.2 hmac 0x1cf372d59e05f4b8,mptcp dss ack 3007449509], length 0
 In  <...> Flags [.], ack 1, win 257, options [mptcp add-addr v1-echo id 90 198.51.100.2,mptcp dss ack 1672384568], length 0
 Out <...> Flags [.], ack 1, win 256, options [mptcp add-addr v1 id 1 198.51.100.2 hmac 0x1cf372d59e05f4b8,mptcp dss ack 3007449509], length 0
 In  <...> Flags [.], ack 1, win 257, options [mptcp add-addr v1-echo id 1 198.51.100.2,mptcp dss ack 1672384568], length 0
        ^^^ retransmission is stopped here, only when both 'Address Id' and 'IP Address' match

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c    | 2 +-
 net/mptcp/pm_netlink.c | 8 ++++----
 net/mptcp/protocol.h   | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 71c535f4e1ef..6b825fb3fa83 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1023,7 +1023,7 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ADDADDR);
 		} else {
 			mptcp_pm_add_addr_echoed(msk, &mp_opt.addr);
-			mptcp_pm_del_add_timer(msk, &mp_opt.addr);
+			mptcp_pm_del_add_timer(msk, &mp_opt.addr, true);
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ECHOADD);
 		}
 
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 6ba040897738..2469e06a3a9d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -346,18 +346,18 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 
 struct mptcp_pm_add_entry *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
-		       struct mptcp_addr_info *addr)
+		       struct mptcp_addr_info *addr, bool check_id)
 {
 	struct mptcp_pm_add_entry *entry;
 	struct sock *sk = (struct sock *)msk;
 
 	spin_lock_bh(&msk->pm.lock);
 	entry = mptcp_lookup_anno_list_by_saddr(msk, addr);
-	if (entry)
+	if (entry && (!check_id || entry->addr.id == addr->id))
 		entry->retrans_times = ADD_ADDR_RETRANS_MAX;
 	spin_unlock_bh(&msk->pm.lock);
 
-	if (entry)
+	if (entry && (!check_id || entry->addr.id == addr->id))
 		sk_stop_timer_sync(sk, &entry->add_timer);
 
 	return entry;
@@ -1064,7 +1064,7 @@ static bool remove_anno_list_by_saddr(struct mptcp_sock *msk,
 {
 	struct mptcp_pm_add_entry *entry;
 
-	entry = mptcp_pm_del_add_timer(msk, addr);
+	entry = mptcp_pm_del_add_timer(msk, addr, false);
 	if (entry) {
 		list_del(&entry->list);
 		kfree(entry);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 165c8b40b384..0c6f99c67345 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -672,7 +672,7 @@ void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
 bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk);
 struct mptcp_pm_add_entry *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
-		       struct mptcp_addr_info *addr);
+		       struct mptcp_addr_info *addr, bool check_id);
 struct mptcp_pm_add_entry *
 mptcp_lookup_anno_list_by_saddr(struct mptcp_sock *msk,
 				struct mptcp_addr_info *addr);
-- 
2.31.1

