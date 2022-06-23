Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2CC5571C3
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiFWElP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347436AbiFWEgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:36:12 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0175530F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:36:12 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31814f7654dso55513497b3.15
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pMVAfLUneu2rDqkIvgFtPAjyay5c/7uMbjWw3cM7zHg=;
        b=pMd86Be5TmWcdvffOplX7AkPp7j+d3STtyxbVjr3qZv5JcfsM87d8ZS/+IC3NkWFfW
         yysBNOpReCBUHmodZF7OZTGiEhLzBKHCRO7WCl6Qe/Sqa7NUQUTcbQnzr4RwNqZFlP4q
         6y6AeaZnCfvm4BVy7YRWz/gxcsbUkekIJntad5cu32aC0E759GYjvK35Pst5LAg5QcMX
         zcbAYvUjJ8l3IripzPwc8Qh9nes+3mHPE7JtnH9SKEDteYlXg5Cp6Iadj6I6vfRi60/e
         FL4e7ogFYlPsuinjXq/aiCJHKIUVveabNLiF0VhL1SNhfq5rUzuX2rnirbTWGUJAp/Pz
         1VWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pMVAfLUneu2rDqkIvgFtPAjyay5c/7uMbjWw3cM7zHg=;
        b=rFEtwO1rXlhV8K16u8zlPElUV1S0Q2DFXGumxBCki82BzZsp0zIF6d6f2g39L0Paca
         9Dj8mcc+5NTWlPkm8CvsvUvJYSWRyHduZGhEMOOJYX43UOqG4C6Pnqcpdg0+ldzqW+TS
         eUNdyAnW2YgmbxHsnGCDXBb0qpSYSDQRX254DovYxZl0+OOsMf+/ji8DgNfVRyOxEmOy
         Ytbyzl2wjiaZQ9wIne7hJmxymvnQ6tjmL0ttd3Wou0TxL/3JreqABMsC+eIZP9SuMtnW
         iEUsbC+4kGUxuLq59Qfqm6YduAZVj8CBG/BNYzMrbpvljBBD7DKSQUYDyJATbUQlxurV
         8ewA==
X-Gm-Message-State: AJIora+dbBD1nDSP8DPlPave9km1Y4JS4RCN1/mfUwBiTQLziZc3iftE
        fDOVCJPq7jPZArAJkjHYJbSFxvLhwSd4qQ==
X-Google-Smtp-Source: AGRyM1so+89CtzrzvXQYOfRQviGyVnY5Ljko+lZt7fqyToC9zTZUVnSVmV8/fLLMUrDqPlqFpp2NVAlR40ZqvA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:9891:0:b0:317:a4a7:fdb0 with SMTP id
 p139-20020a819891000000b00317a4a7fdb0mr8185784ywg.313.1655958971335; Wed, 22
 Jun 2022 21:36:11 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:47 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-18-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 17/19] ipmr: convert /proc handlers to rcu_read_lock()
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

We can use standard rcu_read_lock(), to get rid
of last read_lock(&mrt_lock) call points.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ipmr.c  | 8 ++++----
 net/ipv6/ip6mr.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 38963b8de7af65cabd09894a816d342cd3cee5df..2e39f73fe81a2392e07af83fd933033964e3a730 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2895,7 +2895,7 @@ static int ipmr_rtm_dumplink(struct sk_buff *skb, struct netlink_callback *cb)
  */
 
 static void *ipmr_vif_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(mrt_lock)
+	__acquires(RCU)
 {
 	struct mr_vif_iter *iter = seq->private;
 	struct net *net = seq_file_net(seq);
@@ -2907,14 +2907,14 @@ static void *ipmr_vif_seq_start(struct seq_file *seq, loff_t *pos)
 
 	iter->mrt = mrt;
 
-	read_lock(&mrt_lock);
+	rcu_read_lock();
 	return mr_vif_seq_start(seq, pos);
 }
 
 static void ipmr_vif_seq_stop(struct seq_file *seq, void *v)
-	__releases(mrt_lock)
+	__releases(RCU)
 {
-	read_unlock(&mrt_lock);
+	rcu_read_unlock();
 }
 
 static int ipmr_vif_seq_show(struct seq_file *seq, void *v)
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index f0a9bceb8e3c05ab45e95e8983e505edc005917e..7381cfdac3e376c97917465918a464bd61643f2a 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -404,7 +404,7 @@ static void ip6mr_free_table(struct mr_table *mrt)
  */
 
 static void *ip6mr_vif_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(mrt_lock)
+	__acquires(RCU)
 {
 	struct mr_vif_iter *iter = seq->private;
 	struct net *net = seq_file_net(seq);
@@ -416,14 +416,14 @@ static void *ip6mr_vif_seq_start(struct seq_file *seq, loff_t *pos)
 
 	iter->mrt = mrt;
 
-	read_lock(&mrt_lock);
+	rcu_read_lock();
 	return mr_vif_seq_start(seq, pos);
 }
 
 static void ip6mr_vif_seq_stop(struct seq_file *seq, void *v)
-	__releases(mrt_lock)
+	__releases(RCU)
 {
-	read_unlock(&mrt_lock);
+	rcu_read_unlock();
 }
 
 static int ip6mr_vif_seq_show(struct seq_file *seq, void *v)
-- 
2.37.0.rc0.104.g0611611a94-goog

