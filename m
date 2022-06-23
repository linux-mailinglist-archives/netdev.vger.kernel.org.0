Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAFF5571A3
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiFWElZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347442AbiFWEgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:36:15 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E21C30F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:36:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2dc7bdd666fso160682707b3.7
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=e+ZYZ7kE/qwElnjvjgd5Ved7ybd2g9symWMcNhHL2Fs=;
        b=T9LHPc7ATfTlMXS52Bz3DwE8sYmoQ7FMmqx0RLiV4j1NKy/NRhwU+/Kc+eAShzgKWX
         EEFam0IyxUgv1h0glqBj4ViFTGQaEt5oH8uw8Is05qq5A/cmXKK1sYAIT8b5miTIqOxt
         pAzCPUAk50r0T3aNw/DNz7Bk+sZvDn4HEX60lcuXKvbVxOOEtRfjm6ZEn4BpkO7myzEi
         nC8dYAEKcWqAt2g8YckzMq05EIESUSI7VYQMMRmdXDgeQxzTMppNJU4qXZzu2TwM2G3U
         8lyNEQEXGM15hwiLwgHN/qj/IT4McVDHbbrhNCu63JZBokg68+EEnmvvieXsKsO+QC72
         RwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=e+ZYZ7kE/qwElnjvjgd5Ved7ybd2g9symWMcNhHL2Fs=;
        b=idrGLZQLK5q+DFBpF/XpyAuRgonLtMFLitAfqpwUOhpEFraF+YGCEYvBOTzUTYwJ6D
         RHaBTexxNr3CpXJ4VOmk8fLjpgyh2rI3Ge1uyG9/CqBSRBlnsL7NGawJlPKgD6p7Gp/b
         DWPqjBYjCbxyIqyB1v6EHQvx0iWKxKHZQJRgs3rbgx+LyC4DppXYwLz6ULKFH5Rntye1
         PkRFIY4L8etCCjg9BbMy/JIp0bKyBYXNr/uN4ajcpnUViufY/Wn+N2dyC87LC11WazMi
         fPds6Zh+oMU/wYE0gKQvyFuVoon617Mzn3a3/QtSLwc9d6dgVx8ZvGp+9qBlDhdOzJ99
         xN+g==
X-Gm-Message-State: AJIora/dSMxU1G7FbusXhYS2+dth0z2dVfLffJPPrh3guZn/sgTu7Usn
        vHDc22AqIx1RB+Ro8JIvT62FE+Bz3OlX/A==
X-Google-Smtp-Source: AGRyM1tjFnDF5Q91lXODf/pFhllq9hr7e4ZL3LLtHhaKEgJ2ddrSFUGi1CkSIMgaTRoKFoB5HZHz9wqEWFjxRA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:140a:b0:663:896e:4a86 with SMTP
 id z10-20020a056902140a00b00663896e4a86mr7797722ybu.574.1655958973933; Wed,
 22 Jun 2022 21:36:13 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:48 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-19-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 18/19] ipmr: convert mrt_lock to a spinlock
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mrt_lock is only held in write mode, from process context only.

We can switch to a mere spinlock, and avoid blocking BH.

Also, vif_dev_read() is always called under standard rcu_read_lock().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ipmr.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2e39f73fe81a2392e07af83fd933033964e3a730..f095b6c8100bd24262c949390b68865b8b3987c3 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -77,12 +77,11 @@ struct ipmr_result {
  * Note that the changes are semaphored via rtnl_lock.
  */
 
-static DEFINE_RWLOCK(mrt_lock);
+static DEFINE_SPINLOCK(mrt_lock);
 
 static struct net_device *vif_dev_read(const struct vif_device *vif)
 {
-	return rcu_dereference_check(vif->dev,
-				     lockdep_is_held(&mrt_lock));
+	return rcu_dereference(vif->dev);
 }
 
 /* Multicast router control variables */
@@ -664,7 +663,7 @@ static int vif_delete(struct mr_table *mrt, int vifi, int notify,
 	if (!dev)
 		return -EADDRNOTAVAIL;
 
-	write_lock_bh(&mrt_lock);
+	spin_lock(&mrt_lock);
 	call_ipmr_vif_entry_notifiers(net, FIB_EVENT_VIF_DEL, v, dev,
 				      vifi, mrt->id);
 	RCU_INIT_POINTER(v->dev, NULL);
@@ -683,7 +682,7 @@ static int vif_delete(struct mr_table *mrt, int vifi, int notify,
 		WRITE_ONCE(mrt->maxvif, tmp + 1);
 	}
 
-	write_unlock_bh(&mrt_lock);
+	spin_unlock(&mrt_lock);
 
 	dev_set_allmulti(dev, -1);
 
@@ -785,7 +784,7 @@ static void ipmr_expire_process(struct timer_list *t)
 	spin_unlock(&mfc_unres_lock);
 }
 
-/* Fill oifs list. It is called under write locked mrt_lock. */
+/* Fill oifs list. It is called under locked mrt_lock. */
 static void ipmr_update_thresholds(struct mr_table *mrt, struct mr_mfc *cache,
 				   unsigned char *ttls)
 {
@@ -897,7 +896,7 @@ static int vif_add(struct net *net, struct mr_table *mrt,
 	v->remote = vifc->vifc_rmt_addr.s_addr;
 
 	/* And finish update writing critical data */
-	write_lock_bh(&mrt_lock);
+	spin_lock(&mrt_lock);
 	rcu_assign_pointer(v->dev, dev);
 	netdev_tracker_alloc(dev, &v->dev_tracker, GFP_ATOMIC);
 	if (v->flags & VIFF_REGISTER) {
@@ -906,7 +905,7 @@ static int vif_add(struct net *net, struct mr_table *mrt,
 	}
 	if (vifi+1 > mrt->maxvif)
 		WRITE_ONCE(mrt->maxvif, vifi + 1);
-	write_unlock_bh(&mrt_lock);
+	spin_unlock(&mrt_lock);
 	call_ipmr_vif_entry_notifiers(net, FIB_EVENT_VIF_ADD, v, dev,
 				      vifi, mrt->id);
 	return 0;
@@ -1211,12 +1210,12 @@ static int ipmr_mfc_add(struct net *net, struct mr_table *mrt,
 				   mfc->mfcc_mcastgrp.s_addr, parent);
 	rcu_read_unlock();
 	if (c) {
-		write_lock_bh(&mrt_lock);
+		spin_lock(&mrt_lock);
 		c->_c.mfc_parent = mfc->mfcc_parent;
 		ipmr_update_thresholds(mrt, &c->_c, mfc->mfcc_ttls);
 		if (!mrtsock)
 			c->_c.mfc_flags |= MFC_STATIC;
-		write_unlock_bh(&mrt_lock);
+		spin_unlock(&mrt_lock);
 		call_ipmr_mfc_entry_notifiers(net, FIB_EVENT_ENTRY_REPLACE, c,
 					      mrt->id);
 		mroute_netlink_event(mrt, c, RTM_NEWROUTE);
-- 
2.37.0.rc0.104.g0611611a94-goog

