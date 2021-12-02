Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8347F465CAD
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355197AbhLBD0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355167AbhLBD0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:26:04 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DBEC061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:22:42 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id x131so26591651pfc.12
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kOrlKtG87qDx0MrTwJ8e9KliXZ82ErbO04FOjqifzxo=;
        b=HtLK0pNX4V8dxH3nmzKGzpqe7oPuBC8I+pi+LcTigo5RcTi22J4Y3ezkYvvjtM9Yb2
         d+rP4XOZLz1sOBi/j0bg418f9GslFYbnMsCNwFKDgB0Y27PkgBKgeT12PIqFEQFg9r8H
         /B1Gtm1jw8OLmqNsOF+FwcCAd3xcn6Mpuo4/Ll2zLKTe31GaldchKnqlXwyFhT98sg0i
         ilf2kqzF7JE1aRbCjIvmIk5ixELg3uFg1SUhEaJGKyBRb54Sq/K6jjlSGtJDn8Xo3W0o
         oPU84Y+yTRdkRtdgSUBQwyq9aIEp6fSE9LAKtLzGAUorkYnoaHvGhP/FVpgDE3MNmeuU
         NxGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kOrlKtG87qDx0MrTwJ8e9KliXZ82ErbO04FOjqifzxo=;
        b=tjZ2NmhhpE7Ukr+pd6sV76GreXGZMP0eArIoS8P1wzGlrB4Z50kX4Z85SBbH0Nz80x
         4pdYgZZiM7ZO0Q1Jh2PhKpwVfT1x2yWDZgBGu2vkPlOArc5pVZ9q40/nBEBsibAp8JXq
         HyGInlTjHNuiq7b7Wmb2hY/x8RFmHesTub9S8fMjMdWBa3LS2K7W8+whu6NEF4Qsezq4
         I74zVCGMVG8JPcO/CqcXNl/xNwyRsMjyUkCmG0RAnMWSp+gAHgC23hu2hZjxlnsFJDE7
         yiirDtfdLAt/CMgI+JsmVT4vJU5uoovzffasEPNHymeDQxk9HuL+f/7pKr2d0HkbA31d
         eRVQ==
X-Gm-Message-State: AOAM533I1xRRR6wCr8B5UElugZJpdiDmKf+wnW21dQQ2zEelrC8ux3Jb
        dk/b7oG2Wo3xUHrHgHYCj6I=
X-Google-Smtp-Source: ABdhPJxr9RyTR2Y0aW0PzuXY+pMcudj0Nqwv3TUuWTIop66z3/KY4w3VVe+5ED2CCtwE+QYg7B991Q==
X-Received: by 2002:a63:e50:: with SMTP id 16mr7718889pgo.619.1638415362175;
        Wed, 01 Dec 2021 19:22:42 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:22:41 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 10/19] ipv6: add net device refcount tracker to rt6_probe_deferred()
Date:   Wed,  1 Dec 2021 19:21:30 -0800
Message-Id: <20211202032139.3156411-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/route.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index ba4dc94d76d63c98ff49c41b712231f81eb8af40..8d834f901b483edf75c493620d38f979a4bcbf69 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -593,6 +593,7 @@ struct __rt6_probe_work {
 	struct work_struct work;
 	struct in6_addr target;
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 };
 
 static void rt6_probe_deferred(struct work_struct *w)
@@ -603,7 +604,7 @@ static void rt6_probe_deferred(struct work_struct *w)
 
 	addrconf_addr_solict_mult(&work->target, &mcaddr);
 	ndisc_send_ns(work->dev, &work->target, &mcaddr, NULL, 0);
-	dev_put(work->dev);
+	dev_put_track(work->dev, &work->dev_tracker);
 	kfree(work);
 }
 
@@ -657,7 +658,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 	} else {
 		INIT_WORK(&work->work, rt6_probe_deferred);
 		work->target = *nh_gw;
-		dev_hold(dev);
+		dev_hold_track(dev, &work->dev_tracker, GFP_KERNEL);
 		work->dev = dev;
 		schedule_work(&work->work);
 	}
-- 
2.34.0.rc2.393.gf8c9666880-goog

