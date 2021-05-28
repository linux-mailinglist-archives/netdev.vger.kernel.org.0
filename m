Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EC2394593
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 18:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbhE1QGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 12:06:01 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42868 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbhE1QGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 12:06:00 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0703D1FD2E;
        Fri, 28 May 2021 16:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622217863; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ryxgbzMlqoiV5wx2RetTsFDMMq3afsJoUJpplYegSOI=;
        b=QzVqmaTdvG8sY+sW6kDpyamAAxq9KXvIYsOztS8hos4Qa5PSJSrRBTwCEFcKkO2KPw9Gaf
        eyqfiuoQv4QTs6+fZ0AlhUxn2xf/EoUzI1CsBzbe56jAkx8exPt2FQq/a3PiA9iL9tR1O9
        j7ZhosNKBHIDDXmfmpy0kEgBOwjRfhQ=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 67DF0118DD;
        Fri, 28 May 2021 16:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622217861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ryxgbzMlqoiV5wx2RetTsFDMMq3afsJoUJpplYegSOI=;
        b=j7icTdjfsJkM58Fv9lglAUF+xTGHtZlo/a73j4E/I04DMiD8fFixjr17ikhPLaSjv/pdfj
        k8LoHW1jTShwk/7QhMfAlAqBJn/zq/uWc122JK38YbR5mcMKz9ruvd9EMIRzXa4ZAjp4li
        3uul8IAuNyvvfp/7EXe3A40UCCmTWA0=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 3sDlFoUUsWBTJwAALh3uQQ
        (envelope-from <varad.gautam@suse.com>); Fri, 28 May 2021 16:04:21 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     varad.gautam@suse.com,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v2] xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype
Date:   Fri, 28 May 2021 18:04:06 +0200
Message-Id: <20210528160407.32127-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210528120357.29542-1-varad.gautam@suse.com>
References: <20210528120357.29542-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: imap.suse.de;
        none
X-Spam-Level: *****
X-Spam-Score: 5.00
X-Spamd-Result: default: False [5.00 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         DKIM_SIGNED(0.00)[suse.com:s=susede1];
         RCPT_COUNT_TWELVE(0.00)[12];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2]
X-Spam-Flag: NO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
v2: Correct 'Fixes:' to the right commit.

 net/xfrm/xfrm_policy.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index ce500f847b99..e9d0df2a2ab1 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2092,12 +2092,15 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
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
@@ -2128,11 +2131,15 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
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
 
-- 
2.26.2

