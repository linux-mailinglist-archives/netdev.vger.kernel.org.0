Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59622EB4CA
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731414AbhAEVS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:18:28 -0500
Received: from mail.katalix.com ([3.9.82.81]:35392 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbhAEVS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 16:18:28 -0500
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 8CBC97D533;
        Tue,  5 Jan 2021 21:17:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1609881466; bh=L5DgvzoaChhKRPQ/BcHR0cjVGKcZ5Fa2JdUS6eRWkLE=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PATCH]=20pp
         p:=20fix=20refcount=20underflow=20on=20channel=20unbridge|Date:=20
         Tue,=20=205=20Jan=202021=2021:17:43=20+0000|Message-Id:=20<2021010
         5211743.8404-1-tparkin@katalix.com>;
        b=o3GiYoYCQqBWnpDp+tHapvEqfsMyRnk8FIw9jI6PqaCHyDl5hEOuhbByuzaNx86wa
         LolsbdLcHRZWEayle+OULk9py+7OpK1n/QAJS5Tq+Vt/QGV4lpyey80rSwM9nPGPwp
         BfqlH/gdIyCtumGsFj1IymcOk+ZgxeMKBRIRgwjY/p3UL7d68FUdctuuU9cfPO/eBA
         AeOBI5jOkiB8yWnr8Dx29Ef8ffOd0EMrvnGLS+M//Ilv2FFPTRhtuNJhZuAdKNDEnc
         7R21CvvsdNAUvBnIv1nwdlXUYLjOaqkrnH/JUWsNg53Snpmt9bQMV//h+cWqYGfZhl
         XXZw0H1rPb2zQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH] ppp: fix refcount underflow on channel unbridge
Date:   Tue,  5 Jan 2021 21:17:43 +0000
Message-Id: <20210105211743.8404-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting up a channel bridge, ppp_bridge_channels sets the
pch->bridge field before taking the associated reference on the bridge
file instance.

This opens up a refcount underflow bug if ppp_bridge_channels called
via. iotcl runs concurrently with ppp_unbridge_channels executing via.
file release.

The bug is triggered by ppp_bridge_channels taking the error path
through the 'err_unset' label.  In this scenario, pch->bridge is set,
but the reference on the bridged channel will not be taken because
the function errors out.  If ppp_unbridge_channels observes pch->bridge
before it is unset by the error path, it will erroneously drop the
reference on the bridged channel and cause a refcount underflow.

To avoid this, ensure that ppp_bridge_channels holds a reference on
each channel in advance of setting the bridge pointers.
---
v2:
 * rework ppp_bridge_channels code to avoid the race condition in
   preference to holding ppp_mutex while calling ppp_unbridge_channels
---
 drivers/net/ppp/ppp_generic.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 09c27f7773f9..d019fa40b494 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -617,12 +617,15 @@ static struct bpf_prog *compat_ppp_get_filter(struct sock_fprog32 __user *p)
  */
 static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
 {
+	bool drop_ref = false;
+
 	write_lock_bh(&pch->upl);
 	if (pch->ppp ||
 	    rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl))) {
 		write_unlock_bh(&pch->upl);
 		return -EALREADY;
 	}
+	refcount_inc(&pchb->file.refcnt);
 	rcu_assign_pointer(pch->bridge, pchb);
 	write_unlock_bh(&pch->upl);
 
@@ -632,19 +635,28 @@ static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
 		write_unlock_bh(&pchb->upl);
 		goto err_unset;
 	}
+	refcount_inc(&pch->file.refcnt);
 	rcu_assign_pointer(pchb->bridge, pch);
 	write_unlock_bh(&pchb->upl);
 
-	refcount_inc(&pch->file.refcnt);
-	refcount_inc(&pchb->file.refcnt);
-
 	return 0;
 
 err_unset:
 	write_lock_bh(&pch->upl);
-	RCU_INIT_POINTER(pch->bridge, NULL);
+	/* Re-check pch->bridge with upl held since a racing unbridge might already
+	 * have cleared it and dropped the reference on pch->bridge.
+	 */
+	if (rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl))) {
+		RCU_INIT_POINTER(pch->bridge, NULL);
+		drop_ref = true;
+	}
 	write_unlock_bh(&pch->upl);
 	synchronize_rcu();
+
+	if (drop_ref)
+		if (refcount_dec_and_test(&pchb->file.refcnt))
+			ppp_destroy_channel(pchb);
+
 	return -EALREADY;
 }
 
-- 
2.17.1

