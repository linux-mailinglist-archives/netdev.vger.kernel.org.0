Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE06D24CE58
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgHUG7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgHUG7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:59:47 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E06C061385;
        Thu, 20 Aug 2020 23:59:47 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k13so454391plk.13;
        Thu, 20 Aug 2020 23:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aP/3cBtNWjyOzOyBwL60+IEuGyns8LN4tPG62SGf08Q=;
        b=fA/8+r2A4PagOju6w4bkf1fqDc95Tqx/By1HZDvQRiWVha3nYujg3W721uFU1LS5vj
         RBm0mfW5urR5ZuPOxG/W5bsB+KYuyRIuyunFiIZNSaazo0WvREdTkR/PJoZ+GYK8DDb5
         4XDp+t0gkMVpTeSPZMuJaQO2Mn/VJPKbhXrwU9KmV/fqAYH2od3zksxWtRsWORANdn0i
         ZEksmDBykY08iybKBWhlHrdQ1NjJtiE9Y9nxm6CgX2C++c1Ov/bCvRDu9zbu4jE2eiQw
         JHMQ1OXw7GUiiN+mb2+cVp7svmu4gUqOgTPZEAeOHfU2qgr6cu4llBeEBLF751K7vYq5
         /gjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aP/3cBtNWjyOzOyBwL60+IEuGyns8LN4tPG62SGf08Q=;
        b=RPUeUPNXnxLA4GarghEl8c2EhC/piCuFSymIH3p6GrLocP1H4EbwRVSyWpM14s1J2Z
         JB5RDWCSK94DgriB2g6/bL0npBYtj7uA3ak/4ZoacJNR96ooSGwiuy1gS46prBoNxvae
         mv/12+PX4S2kWKAKUhYWApYttj6npssBGiG4Bj7PdddG7Gf9p4XihpC8wRH3knxTk08b
         whTyukKuDoQfCW5tE+AyzjcfTCpz2mCD8WjnvBIO5Qv8N+A4yULP/LsjWo3gfCk5fYf/
         kfCo6jDTRRe9OTk5L2/JDKekhu0HNwmM37QGyXdzj44vZENfahDXbeZcC0akQGN5cymf
         5XQQ==
X-Gm-Message-State: AOAM533HbEqCQ05l3INTS1UMetPg++v7VGOPaZSS/pDyFcHaMtAlEnK4
        3RLmgNvuU7FMe+/bE8SGkIbcR+UcCeRqDQ==
X-Google-Smtp-Source: ABdhPJzDoshdVjFPcHYnDn1OenUcJ0Oz6EktkQcR8y/j1kzDd0K/5hA/yaFYbwP1M/T8ovkJ6FjABg==
X-Received: by 2002:a17:902:e78d:: with SMTP id cp13mr1293811plb.105.1597993186157;
        Thu, 20 Aug 2020 23:59:46 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a4sm894244pju.49.2020.08.20.23.59.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Aug 2020 23:59:45 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCHv2 net] sctp: not disable bh in the whole sctp_get_port_local()
Date:   Fri, 21 Aug 2020 14:59:38 +0800
Message-Id: <08a14c2f087153c18c67965cc37ed2ac22da18ed.1597993178.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With disabling bh in the whole sctp_get_port_local(), when
snum == 0 and too many ports have been used, the do-while
loop will take the cpu for a long time and cause cpu stuck:

  [ ] watchdog: BUG: soft lockup - CPU#11 stuck for 22s!
  [ ] RIP: 0010:native_queued_spin_lock_slowpath+0x4de/0x940
  [ ] Call Trace:
  [ ]  _raw_spin_lock+0xc1/0xd0
  [ ]  sctp_get_port_local+0x527/0x650 [sctp]
  [ ]  sctp_do_bind+0x208/0x5e0 [sctp]
  [ ]  sctp_autobind+0x165/0x1e0 [sctp]
  [ ]  sctp_connect_new_asoc+0x355/0x480 [sctp]
  [ ]  __sctp_connect+0x360/0xb10 [sctp]

There's no need to disable bh in the whole function of
sctp_get_port_local. So fix this cpu stuck by removing
local_bh_disable() called at the beginning, and using
spin_lock_bh() instead.

The same thing was actually done for inet_csk_get_port() in
Commit ea8add2b1903 ("tcp/dccp: better use of ephemeral
ports in bind()").

Thanks to Marcelo for pointing the buggy code out.

v1->v2:
  - use cond_resched() to yield cpu to other tasks if needed,
    as Eric noticed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ec1fba1..836615f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8060,8 +8060,6 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 
 	pr_debug("%s: begins, snum:%d\n", __func__, snum);
 
-	local_bh_disable();
-
 	if (snum == 0) {
 		/* Search for an available port. */
 		int low, high, remaining, index;
@@ -8079,20 +8077,21 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 				continue;
 			index = sctp_phashfn(net, rover);
 			head = &sctp_port_hashtable[index];
-			spin_lock(&head->lock);
+			spin_lock_bh(&head->lock);
 			sctp_for_each_hentry(pp, &head->chain)
 				if ((pp->port == rover) &&
 				    net_eq(net, pp->net))
 					goto next;
 			break;
 		next:
-			spin_unlock(&head->lock);
+			spin_unlock_bh(&head->lock);
+			cond_resched();
 		} while (--remaining > 0);
 
 		/* Exhausted local port range during search? */
 		ret = 1;
 		if (remaining <= 0)
-			goto fail;
+			return ret;
 
 		/* OK, here is the one we will use.  HEAD (the port
 		 * hash table list entry) is non-NULL and we hold it's
@@ -8107,7 +8106,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		 * port iterator, pp being NULL.
 		 */
 		head = &sctp_port_hashtable[sctp_phashfn(net, snum)];
-		spin_lock(&head->lock);
+		spin_lock_bh(&head->lock);
 		sctp_for_each_hentry(pp, &head->chain) {
 			if ((pp->port == snum) && net_eq(pp->net, net))
 				goto pp_found;
@@ -8207,10 +8206,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 	ret = 0;
 
 fail_unlock:
-	spin_unlock(&head->lock);
-
-fail:
-	local_bh_enable();
+	spin_unlock_bh(&head->lock);
 	return ret;
 }
 
-- 
2.1.0

