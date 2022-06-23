Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1635571C2
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiFWEk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347343AbiFWEfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:35:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4418130F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j11-20020a05690212cb00b006454988d225so16187510ybu.10
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ieF6vXeFFn+xrybKfdCGWxcLeig/WsIdEGabofxCaJA=;
        b=oFoYWCtvGpRg+mwf0B8RRXKlhqG/sKQjd5ie2f65uO2As4YaUBvqIUw9F0eZLeUaci
         qKDZPw8vtWG9DcnG/B2RpnUVIFgWUQho1EkKkjATYA10gwTMxCyuJADyole//g4xl/CB
         nYfrZy/3zoBXMnzNvkMFkAwZex+dvI6p9FP7SzgG0wJOWhieY8m9WD1SpjPBF7fCOK9W
         EuE/UoKCDutUj5xR3GAeikxXGLcxOX2zvCQCaFaOY00ZK/f+0ZkpGINSrIxHjZto+YIQ
         w7xU+XHHRQVv7VJuo3tPU78DL0cUc91yXqNpjKg4StEzitw/D+lkf5jiUEX1u2r9OPCp
         BzcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ieF6vXeFFn+xrybKfdCGWxcLeig/WsIdEGabofxCaJA=;
        b=J/ZPi5PObRN3W/szzAJS22UaNsFQbC/ac9S+oSIxBTTU9znoCzRoyyP1f3rPPQr727
         dTKGuuZ9oe9DKmFNV3kmgvAswEtGf935acDGmhF3dJrr17uCLJc+se/KajYxmJzrDXd6
         MXb1qdNjZv9p2g4rG5tAuYJT28gfCQ8vXotzbyO1OsiW5UX6V4jzOZNkQU4DakrLcHBO
         THpmKvmOKAEKN7Ut90MrfgGDrL15s7qEQDseJ2ao77q0i3QJAjjwe//ckPEXOPvZRmx/
         c2MGnlmuylMIQVOQLRRiew5er4NDqDaZ7eGnB68P9XVzJKG3S2YcsTfi+YxQM4nhiPNU
         XTSQ==
X-Gm-Message-State: AJIora8V0QOsJSLk5TOIZ4j8kuG9Mg6USVY/9RdECVs0tkzxnx1+WMbK
        rHfe/PzWOogRGnmya8kNEG7zWnbGxNueKg==
X-Google-Smtp-Source: AGRyM1ulYxRDkGPoMzkIy82DcFIyWODOLtOeQoeP6wW+GPOPtWtbrD0MbZppVCGSdUtbeafx8hI24QX2sg07HA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:2fc3:0:b0:314:2bfd:ab9c with SMTP id
 v186-20020a812fc3000000b003142bfdab9cmr8675206ywv.22.1655958921557; Wed, 22
 Jun 2022 21:35:21 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:37 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-8-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 07/19] ipmr: do not acquire mrt_lock before
 calling ipmr_cache_unresolved()
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

rcu_read_lock() protection is good enough.

ipmr_cache_unresolved() uses a dedicated spinlock (mfc_unres_lock)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ipmr.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index bc8b7504fde6ec3aadd6c0962f23e59c0aac702a..6ea54bc3d9b6555aaa9974d81ba4acd47481724f 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -680,7 +680,7 @@ static int vif_delete(struct mr_table *mrt, int vifi, int notify,
 			if (VIF_EXISTS(mrt, tmp))
 				break;
 		}
-		mrt->maxvif = tmp+1;
+		WRITE_ONCE(mrt->maxvif, tmp + 1);
 	}
 
 	write_unlock_bh(&mrt_lock);
@@ -905,7 +905,7 @@ static int vif_add(struct net *net, struct mr_table *mrt,
 		WRITE_ONCE(mrt->mroute_reg_vif_num, vifi);
 	}
 	if (vifi+1 > mrt->maxvif)
-		mrt->maxvif = vifi+1;
+		WRITE_ONCE(mrt->maxvif, vifi + 1);
 	write_unlock_bh(&mrt_lock);
 	call_ipmr_vif_entry_notifiers(net, FIB_EVENT_VIF_ADD, v, dev,
 				      vifi, mrt->id);
@@ -1923,11 +1923,12 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 	kfree_skb(skb);
 }
 
-static int ipmr_find_vif(struct mr_table *mrt, struct net_device *dev)
+/* Called with mrt_lock or rcu_read_lock() */
+static int ipmr_find_vif(const struct mr_table *mrt, struct net_device *dev)
 {
 	int ct;
-
-	for (ct = mrt->maxvif-1; ct >= 0; ct--) {
+	/* Pairs with WRITE_ONCE() in vif_delete()/vif_add() */
+	for (ct = READ_ONCE(mrt->maxvif) - 1; ct >= 0; ct--) {
 		if (rcu_access_pointer(mrt->vif_table[ct].dev) == dev)
 			break;
 	}
@@ -2161,15 +2162,9 @@ int ip_mr_input(struct sk_buff *skb)
 			skb = skb2;
 		}
 
-		read_lock(&mrt_lock);
 		vif = ipmr_find_vif(mrt, dev);
-		if (vif >= 0) {
-			int err2 = ipmr_cache_unresolved(mrt, vif, skb, dev);
-			read_unlock(&mrt_lock);
-
-			return err2;
-		}
-		read_unlock(&mrt_lock);
+		if (vif >= 0)
+			return ipmr_cache_unresolved(mrt, vif, skb, dev);
 		kfree_skb(skb);
 		return -ENODEV;
 	}
@@ -2273,18 +2268,15 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 		int vif = -1;
 
 		dev = skb->dev;
-		read_lock(&mrt_lock);
 		if (dev)
 			vif = ipmr_find_vif(mrt, dev);
 		if (vif < 0) {
-			read_unlock(&mrt_lock);
 			rcu_read_unlock();
 			return -ENODEV;
 		}
 
 		skb2 = skb_realloc_headroom(skb, sizeof(struct iphdr));
 		if (!skb2) {
-			read_unlock(&mrt_lock);
 			rcu_read_unlock();
 			return -ENOMEM;
 		}
@@ -2298,7 +2290,6 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 		iph->daddr = daddr;
 		iph->version = 0;
 		err = ipmr_cache_unresolved(mrt, vif, skb2, dev);
-		read_unlock(&mrt_lock);
 		rcu_read_unlock();
 		return err;
 	}
-- 
2.37.0.rc0.104.g0611611a94-goog

