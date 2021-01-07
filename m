Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7322ED673
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 19:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbhAGSOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 13:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbhAGSOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 13:14:03 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBB12C0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 10:13:22 -0800 (PST)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 7FDE97D55C;
        Thu,  7 Jan 2021 18:13:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1610043201; bh=qHSpP77ivYRppJQ1QcmD9+jcu+Wq/FHiproLOhDTVMA=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PATCH=20net
         =20v3]=20ppp:=20fix=20refcount=20underflow=20on=20channel=20unbrid
         ge|Date:=20Thu,=20=207=20Jan=202021=2018:13:15=20+0000|Message-Id:
         =20<20210107181315.3128-1-tparkin@katalix.com>;
        b=bbsziuZ+PiY4PR68nkdv0DTuFGxVBpR82yE7d+DSWEi/f55+EHQLEtiC5lwPaaJfi
         mfqS6qtc0D1q5id3PmxD8n5Tk6vg3YYvkjWke+fFJOzRIFaAp3lE/sbLfdhFVs/hQz
         41ZABAJr5hUMU2iQ+Qt4Oi8tXLxCjpTqOH8XtWH04vYxXgZdTFJo004e6tahYMpcq1
         5WDkifAseOrCLar3UQdJRKmuPFUdHLpnCGpbqNQ71l9zjYJKl8oeVLQqrQSkS+lykS
         hnz9WyC97xw/s5uorqEksVmupLDPYeTScHQEFMXISpuNRSvUHyLpOHitGMwPoLYfjh
         X6q4frAUOtNVA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net v3] ppp: fix refcount underflow on channel unbridge
Date:   Thu,  7 Jan 2021 18:13:15 +0000
Message-Id: <20210107181315.3128-1-tparkin@katalix.com>
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

Signed-off-by: Tom Parkin <tparkin@katalix.com>
Fixes: 4cf476ced45d ("ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls")
---
v3:
 * remove bool tracking variable in ppp_bridge_channels and re-read
   pch->bridge instead
 * add missing tags
v2:
 * rework ppp_bridge_channels code to avoid the race condition in
   preference to holding ppp_mutex while calling ppp_unbridge_channels
---
 drivers/net/ppp/ppp_generic.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 09c27f7773f9..d445ecb1d0c7 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -623,6 +623,7 @@ static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
 		write_unlock_bh(&pch->upl);
 		return -EALREADY;
 	}
+	refcount_inc(&pchb->file.refcnt);
 	rcu_assign_pointer(pch->bridge, pchb);
 	write_unlock_bh(&pch->upl);
 
@@ -632,19 +633,24 @@ static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
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
+	/* Re-read pch->bridge with upl held in case it was modified concurrently */
+	pchb = rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl));
 	RCU_INIT_POINTER(pch->bridge, NULL);
 	write_unlock_bh(&pch->upl);
 	synchronize_rcu();
+
+	if (pchb)
+		if (refcount_dec_and_test(&pchb->file.refcnt))
+			ppp_destroy_channel(pchb);
+
 	return -EALREADY;
 }
 
-- 
2.17.1

