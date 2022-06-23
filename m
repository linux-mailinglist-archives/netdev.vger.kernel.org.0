Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668855571BC
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiFWEky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347325AbiFWEfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:35:15 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E263E30F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:13 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-317a4c8a662so104865007b3.6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EvQ1EeBfzcaZ2NY/562e7h1W6s3GP0FJiq4bYltHlnA=;
        b=CVm3/2R6G9U82RK/T7/94wY9Cu0iTcP6FW8aBJUtwg95d8aVCBWKyH1O8M1pvh1s5D
         bJJCsgZGscLpANNVi4GKPApocwJLyRw9AdUqVeY6e1lZg3bNBCfTyZJOTZFHD2Rtgc1Q
         OjOv33HEVKNtTeqTuAqFdj1fBlccDp051KvA67BwuUJ/RzE/KL0pyr/Ez5qUG2UukJMM
         rxofqiYfSYjgMYq9ciwxlyGjFqbdM3I3TOrpbLp8KhPALBGnGmNhl990KLQaMDfECD5n
         7EKcIPQ7CgXopGupnTVacKndEeSlTWyckPY49TGA8lMz8ykGlkPnSNnmIn1ESIgHvNAp
         NNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EvQ1EeBfzcaZ2NY/562e7h1W6s3GP0FJiq4bYltHlnA=;
        b=l2B1ioVzdGMwyo/pDGSpOoyo+3fllDv5iEIYEyyNHz6tOUdrXrQWFFOydwKjlY8TH2
         RppDTi8nDWBA93pPLdZOfsdu8rnJlmuj3YekqKRtrT4Oj5RJ3JrFG6/l3/kggO3JwR0G
         7vl//dHjEPHuMhtmEW+qG7aKe2wG/djiWNkctLBBFzgv40vmOAHNYbWCwxFtywZnAjPz
         MQ66b/bZKU8FSPih23+gPebXmA87FNgFXJ44gTvo2CVGiagmH13y4IiOy+6XUJT13AEU
         Vx/7xfnJ6zXAXnN4bfKnIoejh1qpE1kezcl0fx/lFTPD2ePX1vGBsvWok/SkvAVYGBA6
         ZuMA==
X-Gm-Message-State: AJIora81CHnWHLJKWWdg+fBcLjZxC1HGzCmMnruIRUtMzKjV+7vyMF3j
        kfT2stvtWDjKEGE+LLoPc8Q9vgE71R6SGA==
X-Google-Smtp-Source: AGRyM1t1arsiteTIqRl6h2O2AwwFU5w6iOSvOgBQ57CWxvDc8dMzpSFBctBR7DGsQHYDvYcI+1ugJ5rumCSLAA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:a1d7:0:b0:317:d4ce:3b42 with SMTP id
 y206-20020a81a1d7000000b00317d4ce3b42mr8595755ywg.317.1655958913181; Wed, 22
 Jun 2022 21:35:13 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:35 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-6-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 05/19] ipmr: do not acquire mrt_lock in __pim_rcv()
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

rcu_read_lock() protection is more than enough.

vif_dev_read() supports either mrt_lock or rcu_read_lock().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ipmr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 8fe7a688cf41deeb99c7ca554f1788a956d2fdb9..8a94f9a459cd077d74b5e38c3d2f248620d4ecfc 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -582,6 +582,7 @@ static int __pim_rcv(struct mr_table *mrt, struct sk_buff *skb,
 {
 	struct net_device *reg_dev = NULL;
 	struct iphdr *encap;
+	int vif_num;
 
 	encap = (struct iphdr *)(skb_transport_header(skb) + pimlen);
 	/* Check that:
@@ -594,11 +595,10 @@ static int __pim_rcv(struct mr_table *mrt, struct sk_buff *skb,
 	    ntohs(encap->tot_len) + pimlen > skb->len)
 		return 1;
 
-	read_lock(&mrt_lock);
-	if (mrt->mroute_reg_vif_num >= 0)
-		reg_dev = vif_dev_read(&mrt->vif_table[mrt->mroute_reg_vif_num]);
-	read_unlock(&mrt_lock);
-
+	/* Pairs with WRITE_ONCE() in vif_add()/vid_delete() */
+	vif_num = READ_ONCE(mrt->mroute_reg_vif_num);
+	if (vif_num >= 0)
+		reg_dev = vif_dev_read(&mrt->vif_table[vif_num]);
 	if (!reg_dev)
 		return 1;
 
-- 
2.37.0.rc0.104.g0611611a94-goog

