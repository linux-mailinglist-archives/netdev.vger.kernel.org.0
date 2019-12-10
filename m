Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 515D3117E2F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 04:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLJDbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 22:31:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbfLJDbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 22:31:47 -0500
Received: from paulmck-ThinkPad-P72.home (199-192-87-166.static.wiline.com [199.192.87.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55F1F206E0;
        Tue, 10 Dec 2019 03:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575948707;
        bh=SK9zlfAidZcR8wXbm7RRCApD4saMH6Z/ATfM1G4weYc=;
        h=Date:From:To:Cc:Subject:Reply-To:From;
        b=hnvSDakzl3sAYuFKLcZYxQ5gFZ8psJrwDkQRCnYagO0lE5sRsEHBM5uHJX5jJmCRT
         0TP2kLSLQ90MwYTSbkXGTe0yCJwzJxR17ni4La1H6iYlWhcP1MlE9AzvSpnNf+Q0SY
         heSXFwYKGnguP5X8kUYcMo1Km3fWi1+CSIWzoj2E=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 7B0433522768; Mon,  9 Dec 2019 19:31:46 -0800 (PST)
Date:   Mon, 9 Dec 2019 19:31:46 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        torvalds@linux-foundation.org, mingo@kernel.org, kernel-team@fb.com
Subject: [PATCH net/tipc] Replace rcu_swap_protected() with
 rcu_replace_pointer()
Message-ID: <20191210033146.GA32522@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit replaces the use of rcu_swap_protected() with the more
intuitively appealing rcu_replace_pointer() as a step towards removing
rcu_swap_protected().

Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Jon Maloy <jon.maloy@ericsson.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>
Cc: <tipc-discussion@lists.sourceforge.net>

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 990a872..64cf831 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -258,7 +258,7 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 	rcu_dereference_protected((rcu_ptr), lockdep_is_held(lock))
 
 #define tipc_aead_rcu_swap(rcu_ptr, ptr, lock)				\
-	rcu_swap_protected((rcu_ptr), (ptr), lockdep_is_held(lock))
+	rcu_replace_pointer((rcu_ptr), (ptr), lockdep_is_held(lock))
 
 #define tipc_aead_rcu_replace(rcu_ptr, ptr, lock)			\
 do {									\
@@ -1189,7 +1189,7 @@ static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending)
 
 	/* Move passive key if any */
 	if (key.passive) {
-		tipc_aead_rcu_swap(rx->aead[key.passive], tmp2, &rx->lock);
+		tmp2 = rcu_replace_pointer(rx->aead[key.passive], tmp2, &rx->lock);
 		x = (key.passive - key.pending + new_pending) % KEY_MAX;
 		new_passive = (x <= 0) ? x + KEY_MAX : x;
 	}
