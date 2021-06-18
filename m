Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C926E3ACD3D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhFROPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:15:01 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58014 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFROPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:15:00 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7FEAC1FDAE;
        Fri, 18 Jun 2021 14:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624025570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YLYUcYH4EymR8fg+XBBx0/tAMx1/Y8L5K0AR9FA20o0=;
        b=qZGU20QjQgJ2NY+NfGve2ebX4xILPoUNiy003XC3uTMRMf7hSfVwiQUi0ZyZeFdwkXVqNL
        rSgvN1zwBWcvPq1UOV9FE//ftlDiKDPoVknovxp/946UzFns0yuATsSUxw3d4d+Gy/39M3
        XflziI8KVvBpNgHoveLiYIrIRnQEpD8=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 1D642118DD;
        Fri, 18 Jun 2021 14:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624025570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YLYUcYH4EymR8fg+XBBx0/tAMx1/Y8L5K0AR9FA20o0=;
        b=qZGU20QjQgJ2NY+NfGve2ebX4xILPoUNiy003XC3uTMRMf7hSfVwiQUi0ZyZeFdwkXVqNL
        rSgvN1zwBWcvPq1UOV9FE//ftlDiKDPoVknovxp/946UzFns0yuATsSUxw3d4d+Gy/39M3
        XflziI8KVvBpNgHoveLiYIrIRnQEpD8=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id S/ieBeKpzGBgSgAALh3uQQ
        (envelope-from <varad.gautam@suse.com>); Fri, 18 Jun 2021 14:12:50 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     Varad Gautam <varad.gautam@suse.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] xfrm: policy: Restructure RCU-read locking in xfrm_sk_policy_lookup
Date:   Fri, 18 Jun 2021 16:11:01 +0200
Message-Id: <20210618141101.18168-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit "xfrm: policy: Read seqcount outside of rcu-read side in
xfrm_policy_lookup_bytype" [Linked] resolved a locking bug in
xfrm_policy_lookup_bytype that causes an RCU reader-writer deadlock on
the mutex wrapped by xfrm_policy_hash_generation on PREEMPT_RT since
77cc278f7b20 ("xfrm: policy: Use sequence counters with associated
lock").

However, xfrm_sk_policy_lookup can still reach xfrm_policy_lookup_bytype
while holding rcu_read_lock(), as:
xfrm_sk_policy_lookup()
  rcu_read_lock()
  security_xfrm_policy_lookup()
    xfrm_policy_lookup()
      xfrm_policy_lookup_bytype()
        read_seqcount_begin()
          mutex_lock(&hash_resize_mutex)

This results in the same deadlock on hash_resize_mutex, where xfrm_hash_resize
is holding the mutex and sleeping inside synchronize_rcu, and
xfrm_policy_lookup_bytype blocks on the mutex inside the RCU read side
critical section.

To resolve this, shorten the RCU read side critical section within
xfrm_sk_policy_lookup by taking a reference on the associated xfrm_policy,
and avoid calling xfrm_policy_lookup_bytype with the rcu_read_lock() held.

Fixes: 77cc278f7b20 ("xfrm: policy: Use sequence counters with associated lock")
Link: https://lore.kernel.org/r/20210528160407.32127-1-varad.gautam@suse.com/
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Cc: stable@vger.kernel.org # v5.9
---
 net/xfrm/xfrm_policy.c | 65 +++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 0b7409f19ecb1..28e072007c72d 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2152,42 +2152,47 @@ static struct xfrm_policy *xfrm_sk_policy_lookup(const struct sock *sk, int dir,
 						 u16 family, u32 if_id)
 {
 	struct xfrm_policy *pol;
+	bool match;
+	int err = 0;
 
-	rcu_read_lock();
  again:
+	rcu_read_lock();
 	pol = rcu_dereference(sk->sk_policy[dir]);
-	if (pol != NULL) {
-		bool match;
-		int err = 0;
-
-		if (pol->family != family) {
-			pol = NULL;
-			goto out;
-		}
+	if (pol == NULL) {
+		rcu_read_unlock();
+		goto out;
+	}
 
-		match = xfrm_selector_match(&pol->selector, fl, family);
-		if (match) {
-			if ((sk->sk_mark & pol->mark.m) != pol->mark.v ||
-			    pol->if_id != if_id) {
-				pol = NULL;
-				goto out;
-			}
-			err = security_xfrm_policy_lookup(pol->security,
-						      fl->flowi_secid,
-						      dir);
-			if (!err) {
-				if (!xfrm_pol_hold_rcu(pol))
-					goto again;
-			} else if (err == -ESRCH) {
-				pol = NULL;
-			} else {
-				pol = ERR_PTR(err);
-			}
-		} else
-			pol = NULL;
+	/* Take a reference on this pol and call rcu_read_unlock(). */
+	if (!xfrm_pol_hold_rcu(pol)) {
+		rcu_read_unlock();
+		goto again;
 	}
-out:
 	rcu_read_unlock();
+
+	if (pol->family != family)
+		goto out_put;
+
+	match = xfrm_selector_match(&pol->selector, fl, family);
+	if (!match)
+		goto out_put;
+
+	if ((sk->sk_mark & pol->mark.m) != pol->mark.v ||
+	    pol->if_id != if_id)
+		goto out_put;
+
+	err = security_xfrm_policy_lookup(pol->security,
+					fl->flowi_secid,
+					dir);
+	if (!err) {
+		/* Safe to return, we have a ref on pol. */
+		goto out;
+	}
+
+ out_put:
+	xfrm_pol_put(pol);
+	pol = (err && err != -ESRCH) ? ERR_PTR(err) : NULL;
+ out:
 	return pol;
 }
 
-- 
2.30.2

