Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40D019A593
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 08:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731818AbgDAGqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 02:46:38 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43771 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731741AbgDAGqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 02:46:38 -0400
Received: by mail-qk1-f194.google.com with SMTP id o10so25944166qki.10
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 23:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2LJMlsSPFxnJE2SRVuuPYtKuA6N/ud51WXVmvBBokqk=;
        b=PD1tvOI0hg2QJHbtrgLJuvSQZgdR4p6sTaal5urBp49UsrxQy1gKC0k8U67wuqYriJ
         gGn8PwmyZLOBcx1JpFh+4O0Pe2lkHaoUo0+AG9sa4tqXl2Go2W/U3kvK9v5YNhPtglsO
         9FFWmfa4XlPmIpVvHdlx1jwF5An5SnRnVnH9lODsgSf45OScdOOfIoACF+FZmW6L/MWF
         uIc6x4MHxyJf/LVf3DKXV414M0bXmDNe9h7XwfV4yGfoNI4gS0MJT6sSvvZ6h+WYWqQU
         /pH8Ajf8RB6CG8qlXU9ILNwKlqjJ5f+DdwQZlV55GnzHP4t8nC2qu7g6S5IfP2f6qpTL
         IhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2LJMlsSPFxnJE2SRVuuPYtKuA6N/ud51WXVmvBBokqk=;
        b=jWLPEIdtFIkYqqyYW10DMG0lvZzw3aF7zZFucWWKModDcWHO7s5BPEDMASSVmi2PQ9
         QBdaC9wq6YU7R0+7EMuAt+QVAqSiPIE00ur6F6vO4MP0orH8C1t/C9aSfYy0aUhOE1YX
         4fPc1qzA1HpHRbLeJK0kOxLGD//UJQkA5pfF1KwJEeRtSkFWaH7UMc2I0fRMKMUHDZxE
         bAinkP2v6GEbd3GkV1ka191Ai6qxchki3cBpNzsjJqovOdiTn/bBhaqmLo5PD1nsbUoW
         1+JYMY/ixjaDNhO/HdYPkr8Lyq7cNyOCnRfodxqIgOdHg8GizUu1/wUHqtRk8IQPaZco
         awQg==
X-Gm-Message-State: ANhLgQ0tF3L3NaiCeVg0so+bTBIjhQYqGs0DkG9y0ue7QgfPTWoiFmZf
        7/pkQrUM4OGKaIz9DuSRs2s3FQR1SDE=
X-Google-Smtp-Source: ADFU+vscmZ22MK/GpyuT5TToHbzrfelO7s3gDM1h+5xloV39n/CDG9mAlcrTFU6jqLx8u9IK9erhRg==
X-Received: by 2002:a37:664d:: with SMTP id a74mr8269708qkc.256.1585723596958;
        Tue, 31 Mar 2020 23:46:36 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g6sm853221qtd.85.2020.03.31.23.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 23:46:36 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net-next] neigh: support smaller retrans_time settting
Date:   Wed,  1 Apr 2020 14:46:20 +0800
Message-Id: <20200401064620.493-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200401020749.2608-1-liuhangbin@gmail.com>
References: <20200401020749.2608-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we limited the retrans_time to be greater than HZ/2. i.e.
setting retrans_time less than 500ms will not work. This makes the user
unable to achieve a more accurate control for bonding arp fast failover.

Update the sanity check to HZ/100, which is 10ms, to let users have more
ability on the retrans_time control.

v3: sync the behavior with IPv6 and update all the timer handler
v2: use HZ instead of hard code number

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/core/neighbour.c | 10 ++++++----
 net/ipv6/addrconf.c  |  7 ++++---
 net/ipv6/ndisc.c     |  4 ++--
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 5bf8d22a47ec..39d37d0ef575 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1065,11 +1065,12 @@ static void neigh_timer_handler(struct timer_list *t)
 			neigh->updated = jiffies;
 			atomic_set(&neigh->probes, 0);
 			notify = 1;
-			next = now + NEIGH_VAR(neigh->parms, RETRANS_TIME);
+			next = now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
+					 HZ/100);
 		}
 	} else {
 		/* NUD_PROBE|NUD_INCOMPLETE */
-		next = now + NEIGH_VAR(neigh->parms, RETRANS_TIME);
+		next = now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME), HZ/100);
 	}
 
 	if ((neigh->nud_state & (NUD_INCOMPLETE | NUD_PROBE)) &&
@@ -1125,7 +1126,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
 			neigh->nud_state     = NUD_INCOMPLETE;
 			neigh->updated = now;
 			next = now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
-					 HZ/2);
+					 HZ/100);
 			neigh_add_timer(neigh, next);
 			immediate_probe = true;
 		} else {
@@ -1427,7 +1428,8 @@ void __neigh_set_probe_once(struct neighbour *neigh)
 	neigh->nud_state = NUD_INCOMPLETE;
 	atomic_set(&neigh->probes, neigh_max_probes(neigh));
 	neigh_add_timer(neigh,
-			jiffies + NEIGH_VAR(neigh->parms, RETRANS_TIME));
+			jiffies + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
+				      HZ/100));
 }
 EXPORT_SYMBOL(__neigh_set_probe_once);
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index a11fd4d67832..89aa6da8661d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1357,7 +1357,7 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp,
 
 	regen_advance = idev->cnf.regen_max_retry *
 			idev->cnf.dad_transmits *
-			NEIGH_VAR(idev->nd_parms, RETRANS_TIME) / HZ;
+			max(NEIGH_VAR(idev->nd_parms, RETRANS_TIME), HZ/100) / HZ;
 
 	/* recalculate max_desync_factor each time and update
 	 * idev->desync_factor if it's larger
@@ -4117,7 +4117,8 @@ static void addrconf_dad_work(struct work_struct *w)
 
 	ifp->dad_probes--;
 	addrconf_mod_dad_work(ifp,
-			      NEIGH_VAR(ifp->idev->nd_parms, RETRANS_TIME));
+			      max(NEIGH_VAR(ifp->idev->nd_parms, RETRANS_TIME),
+				  HZ/100));
 	spin_unlock(&ifp->lock);
 	write_unlock_bh(&idev->lock);
 
@@ -4523,7 +4524,7 @@ static void addrconf_verify_rtnl(void)
 				   !(ifp->flags&IFA_F_TENTATIVE)) {
 				unsigned long regen_advance = ifp->idev->cnf.regen_max_retry *
 					ifp->idev->cnf.dad_transmits *
-					NEIGH_VAR(ifp->idev->nd_parms, RETRANS_TIME) / HZ;
+					max(NEIGH_VAR(ifp->idev->nd_parms, RETRANS_TIME), HZ/100) / HZ;
 
 				if (age >= ifp->prefered_lft - regen_advance) {
 					struct inet6_ifaddr *ifpub = ifp->ifpub;
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 6ffa153e5166..1ecd4e9b0bdf 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1359,8 +1359,8 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 
 		if (rtime && rtime/1000 < MAX_SCHEDULE_TIMEOUT/HZ) {
 			rtime = (rtime*HZ)/1000;
-			if (rtime < HZ/10)
-				rtime = HZ/10;
+			if (rtime < HZ/100)
+				rtime = HZ/100;
 			NEIGH_VAR_SET(in6_dev->nd_parms, RETRANS_TIME, rtime);
 			in6_dev->tstamp = jiffies;
 			send_ifinfo_notify = true;
-- 
2.19.2

