Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCA22DA81
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfE2KZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:25:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40604 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfE2KZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:25:45 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <stefan.bader@canonical.com>)
        id 1hVvmB-0003im-KS; Wed, 29 May 2019 10:25:43 +0000
From:   Stefan Bader <stefan.bader@canonical.com>
To:     stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Andy Whitcroft <andy.whitcroft@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 1/4] ipv4: ipv6: netfilter: Adjust the frag mem limit when truesize changes
Date:   Wed, 29 May 2019 12:25:39 +0200
Message-Id: <20190529102542.17742-2-stefan.bader@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529102542.17742-1-stefan.bader@canonical.com>
References: <20190529102542.17742-1-stefan.bader@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Wiesner <jwiesner@suse.com>

The *_frag_reasm() functions are susceptible to miscalculating the byte
count of packet fragments in case the truesize of a head buffer changes.
The truesize member may be changed by the call to skb_unclone(), leaving
the fragment memory limit counter unbalanced even if all fragments are
processed. This miscalculation goes unnoticed as long as the network
namespace which holds the counter is not destroyed.

Should an attempt be made to destroy a network namespace that holds an
unbalanced fragment memory limit counter the cleanup of the namespace
never finishes. The thread handling the cleanup gets stuck in
inet_frags_exit_net() waiting for the percpu counter to reach zero. The
thread is usually in running state with a stacktrace similar to:

 PID: 1073   TASK: ffff880626711440  CPU: 1   COMMAND: "kworker/u48:4"
  #5 [ffff880621563d48] _raw_spin_lock at ffffffff815f5480
  #6 [ffff880621563d48] inet_evict_bucket at ffffffff8158020b
  #7 [ffff880621563d80] inet_frags_exit_net at ffffffff8158051c
  #8 [ffff880621563db0] ops_exit_list at ffffffff814f5856
  #9 [ffff880621563dd8] cleanup_net at ffffffff814f67c0
 #10 [ffff880621563e38] process_one_work at ffffffff81096f14

It is not possible to create new network namespaces, and processes
that call unshare() end up being stuck in uninterruptible sleep state
waiting to acquire the net_mutex.

The bug was observed in the IPv6 netfilter code by Per Sundstrom.
I thank him for his analysis of the problem. The parts of this patch
that apply to IPv4 and IPv6 fragment reassembly are preemptive measures.

Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
Reported-by: Per Sundstrom <per.sundstrom@redqube.se>
Acked-by: Peter Oskolkov <posk@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

(backported from commit ebaf39e6032faf77218220707fc3fa22487784e0)
[smb: context adjustments in net/ipv6/netfilter/nf_conntrack_reasm.c]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 net/ipv4/ip_fragment.c                  | 7 +++++++
 net/ipv6/netfilter/nf_conntrack_reasm.c | 8 +++++++-
 net/ipv6/reassembly.c                   | 8 +++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 2c75330b1c71..5387e6ab78d7 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -519,6 +519,7 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 	struct rb_node *rbn;
 	int len;
 	int ihlen;
+	int delta;
 	int err;
 	u8 ecn;
 
@@ -560,10 +561,16 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 	if (len > 65535)
 		goto out_oversize;
 
+	delta = - head->truesize;
+
 	/* Head of list must not be cloned. */
 	if (skb_unclone(head, GFP_ATOMIC))
 		goto out_nomem;
 
+	delta += head->truesize;
+	if (delta)
+		add_frag_mem_limit(qp->q.net, delta);
+
 	/* If the first fragment is fragmented itself, we split
 	 * it to two chunks: the first with data and paged part
 	 * and the second, holding only fragments. */
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 664c84e47bab..e5d06ceb2c0c 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -353,7 +353,7 @@ static struct sk_buff *
 nf_ct_frag6_reasm(struct frag_queue *fq, struct net_device *dev)
 {
 	struct sk_buff *fp, *op, *head = fq->q.fragments;
-	int    payload_len;
+	int    payload_len, delta;
 	u8 ecn;
 
 	inet_frag_kill(&fq->q);
@@ -374,12 +374,18 @@ nf_ct_frag6_reasm(struct frag_queue *fq, struct net_device *dev)
 		goto out_oversize;
 	}
 
+	delta = - head->truesize;
+
 	/* Head of list must not be cloned. */
 	if (skb_unclone(head, GFP_ATOMIC)) {
 		pr_debug("skb is cloned but can't expand head");
 		goto out_oom;
 	}
 
+	delta += head->truesize;
+	if (delta)
+		add_frag_mem_limit(fq->q.net, delta);
+
 	/* If the first fragment is fragmented itself, we split
 	 * it to two chunks: the first with data and paged part
 	 * and the second, holding only fragments. */
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index ec917f58d105..020cf70273c9 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -343,7 +343,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *prev,
 {
 	struct net *net = container_of(fq->q.net, struct net, ipv6.frags);
 	struct sk_buff *fp, *head = fq->q.fragments;
-	int    payload_len;
+	int    payload_len, delta;
 	unsigned int nhoff;
 	int sum_truesize;
 	u8 ecn;
@@ -384,10 +384,16 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *prev,
 	if (payload_len > IPV6_MAXPLEN)
 		goto out_oversize;
 
+	delta = - head->truesize;
+
 	/* Head of list must not be cloned. */
 	if (skb_unclone(head, GFP_ATOMIC))
 		goto out_oom;
 
+	delta += head->truesize;
+	if (delta)
+		add_frag_mem_limit(fq->q.net, delta);
+
 	/* If the first fragment is fragmented itself, we split
 	 * it to two chunks: the first with data and paged part
 	 * and the second, holding only fragments. */
-- 
2.17.1

