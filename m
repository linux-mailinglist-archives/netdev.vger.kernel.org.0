Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F244E554216
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356759AbiFVFNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356622AbiFVFNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B110A34B80
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v191-20020a25c5c8000000b00663d6d41f5aso13753693ybe.12
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EvQ1EeBfzcaZ2NY/562e7h1W6s3GP0FJiq4bYltHlnA=;
        b=Qw2yU4sXT/dMWDllGXWWW4aEff3DuHl5z33dytP0ZXc+T+x/GEtu7jJ3N9P+jGx6Nn
         DGJY3YGdNI24M4qC7g9oTFj7U0OupGrqs79w35bmc/pv+zAy80vcoV9URU07W2CRygD0
         qIxEjFzUNw2s73SasD1a8ncVGw67QwJHTnAKCgu2ZVVsWO3aGANVC+x5ZQ9xe+OYseMX
         0pX7Yfhj+IeDraTI9iUvQ92+jbSqNMg2es2PTPkpqEOVg2ZhBSPsxW8bIiA1kXwrRjNY
         M7QCGawSsf1lyjYa0hiG5v5bygTQn00xNP7FyPreeAM/n8za9tri5hUUhJGfNfuF7sQW
         cEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EvQ1EeBfzcaZ2NY/562e7h1W6s3GP0FJiq4bYltHlnA=;
        b=u5nZCuA+mENhBuuaQxdmswSan9gQPQnsJKi7xBjBzABQRoyTTR8kSYwxxOverqmezb
         oOp488YFpA9HxvTZ0n3buwRsm+CaXmJ7RbkgoMW9jJ++XklYs37aPu9cKKEu2e8tvQUW
         9NgK68Ou0/4kPPnwOMTvpN2Lxz8f3zJz0wJW09ozYWqSeXD6VY3qr3PTTynKuYHOgXSy
         14Hh27kl08HqA6+Q0K2fjTdfEQ/IIqBoxy1T31LKIxePmpd3bNrjzZfsYMNQVq4NGwSf
         0NgFt4NOebecez2AXMQMhCrmYDjS56p2PQ8jXE8swvy7N7lMXBtwFBkW4VmJvq531sIm
         9Gnw==
X-Gm-Message-State: AJIora/cXGQJd19JL0N5lKx7k/YOdhuFoii8eD0A7kDQ2yOWr8ARIwN+
        +MOatX+siZ5MxZMpox5NkRjBikx2lK3SzA==
X-Google-Smtp-Source: AGRyM1vdIm5oHQd9A/2fCJdGCj1W9VA5d5iSHOF4hMAk2MNiAp/2Z4E797MdBGoD8umDstWVqHtWley9Ceqp4w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:3a1:b0:317:7c2d:a81a with SMTP
 id bh33-20020a05690c03a100b003177c2da81amr2179165ywb.380.1655874789563; Tue,
 21 Jun 2022 22:13:09 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:41 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-6-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 05/19] ipmr: do not acquire mrt_lock in __pim_rcv()
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

