Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A916755421E
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357034AbiFVFNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357039AbiFVFNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:35 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3BD36147
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:32 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2eb7d137101so136292017b3.12
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=e+ZYZ7kE/qwElnjvjgd5Ved7ybd2g9symWMcNhHL2Fs=;
        b=SAiZkXEHtKfmLwWnGLPkHsq0G1CGDclcpVWr7qag7B3kVud1TBi578Q6/Vaixwq/XN
         sBqtuMtabcsRN2w0lgELHfEOuK5LCo9hIMECc5a4KOBP0h3e9ZmQVNMi5KRMp4tCDOtV
         kXL+PgHSXv1NVVNjnjYIwAmrnFm2V1oBHQ2yo1HROGHD9KGQh6lqWHRFZvzUvXieel8K
         IWPYb/x5jgpsqTu3Gr88J/TX9tAnMIIWIBDwGi8O9EnFKVvmF+sz0OgmuiVKndrgg1oo
         WltTr39Wycjv+Uv8h4SYTTXUmBAHWHUDraQ4oObyFyCpyoyTMfmwpzIO1AJz9Ej4OcFh
         PWBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=e+ZYZ7kE/qwElnjvjgd5Ved7ybd2g9symWMcNhHL2Fs=;
        b=4HBoUrzRWV0KS4b3u8X/85MCcufWJ+SOFx61wy3U2zklq6jXe2XTPwQvrsVe7kHEJQ
         LUVIycEd7c+molC4Ulm1XXWJKhu5ShwheMvBmysCz/J7Jd0swjA8xqBODtsAMZAnwnoD
         nyILrNabZ3aFl3OHMA6DCv3dF9amptD9JHJEaID6tKGjqTiiYzGjmy5Y8xAmajMRAzY+
         456w1EKUYYu/CH4ikr/fFZ/Ywpq79m7nUnV4DPoW1ynUaxAT4ysinD6gk9PzB+GzVZuy
         YUWA/E4+qztDrkIb1O0wHz98c5VUxzkf29M5/aKroHIwu63sbIDAY/oGo/cV1tWz0KxD
         AMag==
X-Gm-Message-State: AJIora9aXexZzScbP+bLQT2fWIKBz9LcNoyNOC+A5B+Z1jwqtXjPXD0z
        tli3l3FifeSDd70vZgq+dhFHJYzscIbydA==
X-Google-Smtp-Source: AGRyM1uXD2Sz/Ql/FNpGd+2teGdMLIkHEBnSpeK3ygxYbvStySpRpPAinC4fzAkNqdneiNHsY2ZEH7sEhDKBtg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:cb90:0:b0:317:946c:30fe with SMTP id
 n138-20020a0dcb90000000b00317946c30femr2110852ywd.82.1655874812092; Tue, 21
 Jun 2022 22:13:32 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:54 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-19-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 18/19] ipmr: convert mrt_lock to a spinlock
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

