Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF8B42329F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 23:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhJEVGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 17:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbhJEVGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 17:06:12 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23320C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 14:04:22 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so2980088pjw.0
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 14:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F9pNhpViyWyRyJMOPeFgEcLGjmDG7MgoLRw9zus3txg=;
        b=fr45+6WZEZvuavdFcsy4kpT1Mh86pAhaJgdNtf2D2pS/aO9i/02Rcr5WjGMLYmfvw2
         RrXJwXm5b0Dz0rnEdgB5/+xsgMVH1GVVcVMJt30Y78st91pltKiwDuUmWYdlE2I/yofe
         SJcqK8GxCtSpS4oGrv4FwdF7SpXMu9OBxtJGloEgKFwui/ZQd9E1dkMRXIJOZOofBjhQ
         OSN1e1LthuzfSV2E+gt6VGFn1WLHRcWRVtA2HbAzZfCnJIJyDZSh6DJMtNCM594of5Ut
         Ouc7YkLnJI1+iMq2N523D2vX0yJD1897NVlwSFkeY+16UKPFA4iiMhi3qFwK2dmSR4Wi
         0W2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F9pNhpViyWyRyJMOPeFgEcLGjmDG7MgoLRw9zus3txg=;
        b=EUg4B0AsoT3Hgzaox885w7Gg9OZ6EZyYU1aoAgpC3B03b71Sqxywbh29s2NSdF5OD1
         4h8JpePVhZtYA+g3RSmVMV5Qg5KUSn3GbpaQDdNYr70s03nr9XcVa2nW/17Xf3Hl06e7
         XbfLlAAWVbH3IfHAbw2CvEs5L9M94NE9Le/zb2x2mzv4HBk6YqjfDScI9UrponVb2LOi
         XBVXEsTh3c3+Lbg5QAcB2AnEKTbweTQE0Fc+/VR6zXtgY+12cjXQEsmb1eMRnmVvwjX3
         OSFXVtLqsogZByvlhIjWVk3orlUTBXP+MFgdR1zxm9xIkP5BVNMO3FUKm2D+xNFu2hlB
         7scQ==
X-Gm-Message-State: AOAM530QTsSmEwPtDuRi5NFdAEtVU6SXAtIF+DhZKjdXWmbO0Cjl3AdR
        /jFOepigO84STZQ+6c+O+1KzDRm5OVU=
X-Google-Smtp-Source: ABdhPJycZnqLU63xi+MjY3yqj0LXCBb2Wf5wyIQQGCyJ0JoAHnxnRgO+81P5MbpfGvKHuQ1pvcsmDg==
X-Received: by 2002:a17:902:9b88:b0:13e:55b1:2939 with SMTP id y8-20020a1709029b8800b0013e55b12939mr7173095plp.80.1633467861727;
        Tue, 05 Oct 2021 14:04:21 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4c77:3139:c57:fc29])
        by smtp.gmail.com with ESMTPSA id mv9sm2917348pjb.10.2021.10.05.14.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 14:04:21 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: [PATCH net] rtnetlink: fix if_nlmsg_stats_size() under estimation
Date:   Tue,  5 Oct 2021 14:04:17 -0700
Message-Id: <20211005210417.2624297-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

rtnl_fill_statsinfo() is filling skb with one mandatory if_stats_msg structure.

nlmsg_put(skb, pid, seq, type, sizeof(struct if_stats_msg), flags);

But if_nlmsg_stats_size() never considered the needed storage.

This bug did not show up because alloc_skb(X) allocates skb with
extra tailroom, because of added alignments. This could very well
be changed in the future to have deterministic behavior.

Fixes: 10c9ead9f3c6 ("rtnetlink: add new RTM_GETSTATS message to dump link stats")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 972c8cb303a514758278307cd9fcb974e37f2b96..8ccce85562a1da2a5285aebd19a6a4cb7d6a163e 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5262,7 +5262,7 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 static size_t if_nlmsg_stats_size(const struct net_device *dev,
 				  u32 filter_mask)
 {
-	size_t size = 0;
+	size_t size = NLMSG_ALIGN(sizeof(struct if_stats_msg));
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_64, 0))
 		size += nla_total_size_64bit(sizeof(struct rtnl_link_stats64));
-- 
2.33.0.800.g4c38ced690-goog

