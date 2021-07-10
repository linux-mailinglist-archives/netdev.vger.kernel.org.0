Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC363C2C00
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 02:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhGJAXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 20:23:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:60427 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231406AbhGJAXp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 20:23:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10040"; a="270913467"
X-IronPort-AV: E=Sophos;i="5.84,228,1620716400"; 
   d="scan'208";a="270913467"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 17:20:57 -0700
X-IronPort-AV: E=Sophos;i="5.84,228,1620716400"; 
   d="scan'208";a="462343531"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.240.68])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 17:20:57 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Jianguo Wu <wujianguo@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, pabeni@redhat.com,
        fw@strlen.de, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/6] mptcp: fix warning in __skb_flow_dissect() when do syn cookie for subflow join
Date:   Fri,  9 Jul 2021 17:20:46 -0700
Message-Id: <20210710002051.216010-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210710002051.216010-1-mathew.j.martineau@linux.intel.com>
References: <20210710002051.216010-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

I did stress test with wrk[1] and webfsd[2] with the assistance of
mptcp-tools[3]:

  Server side:
      ./use_mptcp.sh webfsd -4 -R /tmp/ -p 8099
  Client side:
      ./use_mptcp.sh wrk -c 200 -d 30 -t 4 http://192.168.174.129:8099/

and got the following warning message:

[   55.552626] TCP: request_sock_subflow: Possible SYN flooding on port 8099. Sending cookies.  Check SNMP counters.
[   55.553024] ------------[ cut here ]------------
[   55.553027] WARNING: CPU: 0 PID: 10 at net/core/flow_dissector.c:984 __skb_flow_dissect+0x280/0x1650
...
[   55.553117] CPU: 0 PID: 10 Comm: ksoftirqd/0 Not tainted 5.12.0+ #18
[   55.553121] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 02/27/2020
[   55.553124] RIP: 0010:__skb_flow_dissect+0x280/0x1650
...
[   55.553133] RSP: 0018:ffffb79580087770 EFLAGS: 00010246
[   55.553137] RAX: 0000000000000000 RBX: ffffffff8ddb58e0 RCX: ffffb79580087888
[   55.553139] RDX: ffffffff8ddb58e0 RSI: ffff8f7e4652b600 RDI: 0000000000000000
[   55.553141] RBP: ffffb79580087858 R08: 0000000000000000 R09: 0000000000000008
[   55.553143] R10: 000000008c622965 R11: 00000000d3313a5b R12: ffff8f7e4652b600
[   55.553146] R13: ffff8f7e465c9062 R14: 0000000000000000 R15: ffffb79580087888
[   55.553149] FS:  0000000000000000(0000) GS:ffff8f7f75e00000(0000) knlGS:0000000000000000
[   55.553152] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   55.553154] CR2: 00007f73d1d19000 CR3: 0000000135e10004 CR4: 00000000003706f0
[   55.553160] Call Trace:
[   55.553166]  ? __sha256_final+0x67/0xd0
[   55.553173]  ? sha256+0x7e/0xa0
[   55.553177]  __skb_get_hash+0x57/0x210
[   55.553182]  subflow_init_req_cookie_join_save+0xac/0xc0
[   55.553189]  subflow_check_req+0x474/0x550
[   55.553195]  ? ip_route_output_key_hash+0x67/0x90
[   55.553200]  ? xfrm_lookup_route+0x1d/0xa0
[   55.553207]  subflow_v4_route_req+0x8e/0xd0
[   55.553212]  tcp_conn_request+0x31e/0xab0
[   55.553218]  ? selinux_socket_sock_rcv_skb+0x116/0x210
[   55.553224]  ? tcp_rcv_state_process+0x179/0x6d0
[   55.553229]  tcp_rcv_state_process+0x179/0x6d0
[   55.553235]  tcp_v4_do_rcv+0xaf/0x220
[   55.553239]  tcp_v4_rcv+0xce4/0xd80
[   55.553243]  ? ip_route_input_rcu+0x246/0x260
[   55.553248]  ip_protocol_deliver_rcu+0x35/0x1b0
[   55.553253]  ip_local_deliver_finish+0x44/0x50
[   55.553258]  ip_local_deliver+0x6c/0x110
[   55.553262]  ? ip_rcv_finish_core.isra.19+0x5a/0x400
[   55.553267]  ip_rcv+0xd1/0xe0
...

After debugging, I found in __skb_flow_dissect(), skb->dev and skb->sk
are both NULL, then net is NULL, and trigger WARN_ON_ONCE(!net),
actually net is always NULL in this code path, as skb->dev is set to
NULL in tcp_v4_rcv(), and skb->sk is never set.

Code snippet in __skb_flow_dissect() that trigger warning:
  975         if (skb) {
  976                 if (!net) {
  977                         if (skb->dev)
  978                                 net = dev_net(skb->dev);
  979                         else if (skb->sk)
  980                                 net = sock_net(skb->sk);
  981                 }
  982         }
  983
  984         WARN_ON_ONCE(!net);

So, using seq and transport header derived hash.

[1] https://github.com/wg/wrk
[2] https://github.com/ourway/webfsd
[3] https://github.com/pabeni/mptcp-tools

Fixes: 9466a1ccebbe ("mptcp: enable JOIN requests even if cookies are in use")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/syncookies.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/syncookies.c b/net/mptcp/syncookies.c
index abe0fd099746..37127781aee9 100644
--- a/net/mptcp/syncookies.c
+++ b/net/mptcp/syncookies.c
@@ -37,7 +37,21 @@ static spinlock_t join_entry_locks[COOKIE_JOIN_SLOTS] __cacheline_aligned_in_smp
 
 static u32 mptcp_join_entry_hash(struct sk_buff *skb, struct net *net)
 {
-	u32 i = skb_get_hash(skb) ^ net_hash_mix(net);
+	static u32 mptcp_join_hash_secret __read_mostly;
+	struct tcphdr *th = tcp_hdr(skb);
+	u32 seq, i;
+
+	net_get_random_once(&mptcp_join_hash_secret,
+			    sizeof(mptcp_join_hash_secret));
+
+	if (th->syn)
+		seq = TCP_SKB_CB(skb)->seq;
+	else
+		seq = TCP_SKB_CB(skb)->seq - 1;
+
+	i = jhash_3words(seq, net_hash_mix(net),
+			 (__force __u32)th->source << 16 | (__force __u32)th->dest,
+			 mptcp_join_hash_secret);
 
 	return i % ARRAY_SIZE(join_entries);
 }
-- 
2.32.0

