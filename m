Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8977224AF6D
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgHTGst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHTGss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 02:48:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA41C061757;
        Wed, 19 Aug 2020 23:48:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id e4so559323pjd.0;
        Wed, 19 Aug 2020 23:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jm+uUDSmmx9X1srdhmuJqsAe+TT5/kJh3UlKWgVNgVw=;
        b=HJn1uRjpGV0DhRy/Wceim0P9RIA4TesPYKX6RA6GTr6TtUBSWMRf4zuFwWLwn4anFf
         g9AD4wbX4fYOXAb3y2KF6oB7gugTUi+UlY7zopLQXY1dz/aFPMNfyK/E6Zwf+MFCS58w
         YHbXDecPPVi2AaBxe7aXEqvtxJVOpmp2VBuzclRYOG0NWrFIughBcKTyxfoL/G4NdYqX
         H7WFKCisPljyaBVYQWZIpvlCSl0W5P6xSQuonxwmk2TZruEcvmLDTR6rGLiPFDk4CU5p
         m7EffC8PtZoo7JCpm8Cju9Tu3j90FYuXziBsjJ0CVGshCcGQLpyPN4sPsyW/uM5lWfmP
         e2YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jm+uUDSmmx9X1srdhmuJqsAe+TT5/kJh3UlKWgVNgVw=;
        b=RM3E3IwqgftloBqIkgQ6VGzQF71enYXkeQH1k9Cm2DfpX063ibtc3A5STCK3kJv04t
         uMQPXPhL9UVQiuh5pwB7YcQENr1pEVlDH8JwdlE74LNFWuWniS8fcbgk2Bm6j8Oeb8i5
         hfFsoMTkfPiRtbAMVm12sNmmNb1GUhJA3Xnw9Ew00x5Ims93zTk7cX6IzwfooTyhEOcY
         JnWFVcLpeBCFwYMUgUjVPpEoCmiHrd66k0UMxNqNkiBGRBYBBFFoV81Dx7nFqnGbevdS
         ZaIvUjaII/LVObW3re8DsrJ0g09eQ9NpxxMpc5BQ3/3YdCCJbMPq2QOsdAB0Pv4dlqdG
         Y1Ew==
X-Gm-Message-State: AOAM530bHFfEKmpLXhqbENMGbOzOjOVga8ATbebIUH6W5fSANT36TjO0
        U9VwRBdaKlEQg5EpRONdne7CwA+Oatdtkg==
X-Google-Smtp-Source: ABdhPJzyUsvupUEj90FwoqrcE1uxgomLzTTgJXrbMSN+Xm5wJgBh/5q7BepmiBAbbTKf5E/Sana1/Q==
X-Received: by 2002:a17:90b:4b89:: with SMTP id lr9mr437065pjb.190.1597906127508;
        Wed, 19 Aug 2020 23:48:47 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w7sm1454778pfi.164.2020.08.19.23.48.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Aug 2020 23:48:46 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: not disable bh in the whole sctp_get_port_local()
Date:   Thu, 20 Aug 2020 14:48:39 +0800
Message-Id: <b3da88b999373d2518ac52a9e1d0fcb935109ea8.1597906119.git.lucien.xin@gmail.com>
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

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ec1fba1..f0f9956 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8060,8 +8060,6 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 
 	pr_debug("%s: begins, snum:%d\n", __func__, snum);
 
-	local_bh_disable();
-
 	if (snum == 0) {
 		/* Search for an available port. */
 		int low, high, remaining, index;
@@ -8079,20 +8077,20 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
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
 		} while (--remaining > 0);
 
 		/* Exhausted local port range during search? */
 		ret = 1;
 		if (remaining <= 0)
-			goto fail;
+			return ret;
 
 		/* OK, here is the one we will use.  HEAD (the port
 		 * hash table list entry) is non-NULL and we hold it's
@@ -8107,7 +8105,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		 * port iterator, pp being NULL.
 		 */
 		head = &sctp_port_hashtable[sctp_phashfn(net, snum)];
-		spin_lock(&head->lock);
+		spin_lock_bh(&head->lock);
 		sctp_for_each_hentry(pp, &head->chain) {
 			if ((pp->port == snum) && net_eq(pp->net, net))
 				goto pp_found;
@@ -8207,10 +8205,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
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

