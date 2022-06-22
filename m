Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A34D554226
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357056AbiFVFNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356996AbiFVFNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169E536141
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j2-20020a2597c2000000b0064b3e54191aso13717231ybo.20
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pMVAfLUneu2rDqkIvgFtPAjyay5c/7uMbjWw3cM7zHg=;
        b=bAL5WrrniLAoDWqRLWvW2V3SQ1DaNL3X3bCamPOr+NT3ENQXxBnt2UTEgs/9oCFiJq
         RFEgbjEIHD/XQNTexRybNADQmtHPrsZhNgtvmCV0H+T4pBBIwO2Ri5S8fMpmt7Nytfmw
         cwVTXWB4vY5MxkFyNl5tNcu+/r6MbVjYkGjyyJHAOufbUL5Oh1nH21OE8jt1n/t06X5g
         isyc3f4Bif4Q/KTPZmVA2cePL5Ht3rkamo8KA37mFw+AMdjp7EhF9hwEePfKOkvjg7jI
         jhn8cjs2A5EangZHUy7yYIxclJxy4iuhOTNGda2+YsYSO7U/J4zmMHUFvzJq8YM+4LgL
         PWeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pMVAfLUneu2rDqkIvgFtPAjyay5c/7uMbjWw3cM7zHg=;
        b=csxk872ZZEtGwMolzJ3fnNEttSNi/BRW0w8JzN9SePEZvxCKWFnjS4v+lACLFocJq+
         yBQ/APqDntDwVDVRyqJ/K7w1Ki38wkYg9DIV1wn95u4Xq7q9Bvus7wzn82CySqOsFUTs
         GHsEaxYH/aPOxVm/5s92IGpDn3p0e4XEo9+PCtMvOvMIm4SJX6JjDeSLRgcq8UXfhwiY
         EyB2k1BDPn8U7Fc/6b/TK753cVuCnOvSgC8jVBWBalaLYmpuuXPDOJDXy+CS8PJbBgfq
         YCzmRBqdM5ejyEv2UENZgVs/AJ0jmFYEcmVdbu5F308DHC2L8GbbZ+P5CU0qWGZFVRKG
         4jMg==
X-Gm-Message-State: AJIora8WoapGgBnPpKZXegslNYkfJVFkYPzQSn+XuK3kUBDICfMYxgt1
        g2S3Oit3sinfjWo+rmCMJ0XOnNygAE7H+Q==
X-Google-Smtp-Source: AGRyM1tTMxCarc9JW6GMLXivU0LAvFvlhurgve9xJRsBKbAd/AqjbQ+AkNzN4e684LQkjZoVwps93VlO7CIhlA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:582:b0:317:72d3:cd12 with SMTP
 id bo2-20020a05690c058200b0031772d3cd12mr2091067ywb.299.1655874810250; Tue,
 21 Jun 2022 22:13:30 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:53 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-18-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 17/19] ipmr: conver /proc handlers to rcu_read_lock()
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

