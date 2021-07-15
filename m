Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B25A3CA940
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 21:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242815AbhGOTFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 15:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242671AbhGOTFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09E37613DA;
        Thu, 15 Jul 2021 19:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375703;
        bh=m/i/HMsx2BkqaC2YrJ2TGwZdRfxs3GJ877IyQhux/hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOG/UaacGfxoB54pfizGU17OnrFL8Li69ndjpOoPctSMuiAwZ0RqaV5JwM98eF8r3
         +7aHojQY3E2L/nsb4L4fGduDOvjdwxDsWXLqymbBBrXPCEYTQeR4wURQLz0oB95fZj
         Aa2DhQcBpM7fMJxufi6bptrXYiudJuRjz8NdrUkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Varad Gautam <varad.gautam@suse.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH 5.12 198/242] xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype
Date:   Thu, 15 Jul 2021 20:39:20 +0200
Message-Id: <20210715182628.078846156@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Varad Gautam <varad.gautam@suse.com>

commit d7b0408934c749f546b01f2b33d07421a49b6f3e upstream.

xfrm_policy_lookup_bytype loops on seqcount mutex xfrm_policy_hash_generation
within an RCU read side critical section. Although ill advised, this is fine if
the loop is bounded.

xfrm_policy_hash_generation wraps mutex hash_resize_mutex, which is used to
serialize writers (xfrm_hash_resize, xfrm_hash_rebuild). This is fine too.

On PREEMPT_RT=y, the read_seqcount_begin call within xfrm_policy_lookup_bytype
emits a mutex lock/unlock for hash_resize_mutex. Mutex locking is fine, since
RCU read side critical sections are allowed to sleep with PREEMPT_RT.

xfrm_hash_resize can, however, block on synchronize_rcu while holding
hash_resize_mutex.

This leads to the following situation on PREEMPT_RT, where the writer is
blocked on RCU grace period expiry, while the reader is blocked on a lock held
by the writer:

Thead 1 (xfrm_hash_resize)	Thread 2 (xfrm_policy_lookup_bytype)

				rcu_read_lock();
mutex_lock(&hash_resize_mutex);
				read_seqcount_begin(&xfrm_policy_hash_generation);
				mutex_lock(&hash_resize_mutex); // block
xfrm_bydst_resize();
synchronize_rcu(); // block
		<RCU stalls in xfrm_policy_lookup_bytype>

Move the read_seqcount_begin call outside of the RCU read side critical section,
and do an rcu_read_unlock/retry if we got stale data within the critical section.

On non-PREEMPT_RT, this shortens the time spent within RCU read side critical
section in case the seqcount needs a retry, and avoids unbounded looping.

Fixes: 77cc278f7b20 ("xfrm: policy: Use sequence counters with associated lock")
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org # v4.9
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: "Ahmed S. Darwish" <a.darwish@linutronix.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_policy.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2092,12 +2092,15 @@ static struct xfrm_policy *xfrm_policy_l
 	if (unlikely(!daddr || !saddr))
 		return NULL;
 
-	rcu_read_lock();
  retry:
-	do {
-		sequence = read_seqcount_begin(&xfrm_policy_hash_generation);
-		chain = policy_hash_direct(net, daddr, saddr, family, dir);
-	} while (read_seqcount_retry(&xfrm_policy_hash_generation, sequence));
+	sequence = read_seqcount_begin(&xfrm_policy_hash_generation);
+	rcu_read_lock();
+
+	chain = policy_hash_direct(net, daddr, saddr, family, dir);
+	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence)) {
+		rcu_read_unlock();
+		goto retry;
+	}
 
 	ret = NULL;
 	hlist_for_each_entry_rcu(pol, chain, bydst) {
@@ -2128,11 +2131,15 @@ static struct xfrm_policy *xfrm_policy_l
 	}
 
 skip_inexact:
-	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence))
+	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence)) {
+		rcu_read_unlock();
 		goto retry;
+	}
 
-	if (ret && !xfrm_pol_hold_rcu(ret))
+	if (ret && !xfrm_pol_hold_rcu(ret)) {
+		rcu_read_unlock();
 		goto retry;
+	}
 fail:
 	rcu_read_unlock();
 


