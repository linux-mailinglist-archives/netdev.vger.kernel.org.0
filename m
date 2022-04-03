Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B695B4F09A6
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358541AbiDCNK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358637AbiDCNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:29 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4752140E7
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:28 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l62-20020a1c2541000000b0038e4570af2fso4081661wml.5
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B1wqCJjycXccmpr0OYQdIB9liIfmIlJGjy/dtfC04bA=;
        b=F8D9fPrvJHsv70/isrhgUpVhKDrU2CZ1ttwfMfHxf1QPlvisbBcLgSAI/GrBp/+ZmD
         SjJqT3ZTAoALzh0/4lfmBwHohnDoeFOKZZhYbQ1/mBIBWN3brlYGZEVj54PpwsjA1Phu
         ym/FRdSHFSayM3txPHWCNZVLiwrx0lCbiQMWiYtfWt/w3GuQezWhW0htfG6K+WboyNLt
         TbEZGsX7vD4uidYDh69kkN9OGIkXp8hYVf8oLEpkMpIe0g/gNIojlqpmZPc3WLbehWv9
         qKdW5tGldJwvCLpAzPccqgIDxvKt/wXf6SHTkFF8d15CseeU6PejaA0CPuev3Md7ebiN
         X3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B1wqCJjycXccmpr0OYQdIB9liIfmIlJGjy/dtfC04bA=;
        b=Q67862myUWbsgIGdR8SKZUtr5/nYpEnu0AsLxnPykNFqQlprm6tL3Sd6oVwA1uFuAN
         7FRbMj+6g4dSKFKay8P0i5a67wfUl6FuNx+byo2PqRM8au9D2AtDwQK+vjM2h6cS1Dig
         tWDigNOWxswG3uoQsHuXcJ1EFgMxzoPO06OYy3yr+fztghPnmy6o0caHUb65rB7qr/bK
         n1jhZ/GSytkShNe/inCTe7OESpEGeZ8EZjPrBkYuaZ77GVJRL2ln/SX/eYru9ABiRrZC
         mrrHdCQ084au7nUfmV8jxPSxVTcqENgtwdG40rWAja8/Id1GY5P2AmrMbzOVsTEqallc
         MZHg==
X-Gm-Message-State: AOAM533VImurV+K8CvIh7o/PFiCmkqXnpgOu9sfCl7vn91gbYB4jzCXj
        4wQLvZ/QA/QIoLp8WEwhivpvSZEd3J4=
X-Google-Smtp-Source: ABdhPJxQtlvBKOj2wHtVmrJURAHX/271L5lridHtzhlh+bleyHmqf5qQ1jWgFI6RCh6qMWwYZghI2Q==
X-Received: by 2002:a05:600c:35cc:b0:38c:73e8:7dd5 with SMTP id r12-20020a05600c35cc00b0038c73e87dd5mr15702465wmq.196.1648991307256;
        Sun, 03 Apr 2022 06:08:27 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 14/27] ipv6: refactor ip6_finish_output2()
Date:   Sun,  3 Apr 2022 14:06:26 +0100
Message-Id: <53e9e0d4c60a54b0c1070619e7104dbe32b5f937.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Throw neigh checks in ip6_finish_output2() under a single slow path if,
so we don't have the overhead in the hot path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 39f3e4bee9e6..4319364a4a8c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -119,19 +119,21 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	rcu_read_lock_bh();
 	nexthop = rt6_nexthop((struct rt6_info *)dst, daddr);
 	neigh = __ipv6_neigh_lookup_noref(dev, nexthop);
-	if (unlikely(!neigh))
-		neigh = __neigh_create(&nd_tbl, nexthop, dev, false);
-	if (!IS_ERR(neigh)) {
-		sock_confirm_neigh(skb, neigh);
-		ret = neigh_output(neigh, skb, false);
-		rcu_read_unlock_bh();
-		return ret;
+
+	if (unlikely(IS_ERR_OR_NULL(neigh))) {
+		if (unlikely(!neigh))
+			neigh = __neigh_create(&nd_tbl, nexthop, dev, false);
+		if (IS_ERR(neigh)) {
+			rcu_read_unlock_bh();
+			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
+			kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_CREATEFAIL);
+			return -EINVAL;
+		}
 	}
+	sock_confirm_neigh(skb, neigh);
+	ret = neigh_output(neigh, skb, false);
 	rcu_read_unlock_bh();
-
-	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
-	kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_CREATEFAIL);
-	return -EINVAL;
+	return ret;
 }
 
 static int
-- 
2.35.1

