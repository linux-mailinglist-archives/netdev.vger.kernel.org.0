Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A4F3CC2CF
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 13:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhGQLck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 07:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhGQLck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 07:32:40 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894DEC06175F;
        Sat, 17 Jul 2021 04:29:43 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id go30so19385614ejc.8;
        Sat, 17 Jul 2021 04:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wMQzc9hsJBjF5+GiV3deRlNe0BUFyhoXni4Q39sORR0=;
        b=nVcQW8yZtK9YjZwCSga6v5Bl9AXracc8wNFeqh16bVoP2bH7S+lRI0rM3neRXqFiWe
         Av1b3slBHxFrJ5nShWl/+WErIEk0mWSYZ6fNX7MQhm2Tmqw16tKcVzP0vFbsVCwRk3tv
         uJyXm0C1VPMgF1HHIsb3glZau0xoZVKg94BghYgTre8EazPmvykfYZ2M6cCQK4sbss4s
         vkJA+M/6lIrA1P75sBPGf+iMJzfGyXAwLKJ7QsARHaSvRB4A2RQ8Bb0BlBwKCSVP9Uih
         ++vRT2YeKyoC59xGZEDcmo2Wg+oFzCsVI0R30yWDeHmmvPiF1nOSGjwIdfsN1P2ENs1f
         JSxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wMQzc9hsJBjF5+GiV3deRlNe0BUFyhoXni4Q39sORR0=;
        b=DgdUJ+dQjhJrYSfB/B4pRlER76r3pQ3BntqITeVYowe6GvqVs4ke72dFmrWftYcbxm
         A1XAb5En6Bx+BcwKFEN/b9TuKd2fTR7uaG3CpUKSCACH8rpOG4e09ZpfXUx1XZyx6JaC
         tbd8j9PQ+rPHQ4CBss2LE+qM4zgUirDHtUGt/Jqx0G935I7XdIX7uuFK9vpXFkGtPJco
         zkIBMRcqe0WaF6oybfLAAJ7x8zIIU5ZLLaMROiBX4MMOcbz1pQej9ZQ8nrAzDkiZTyBu
         yYCqtyIdo3D3b3R4iS3RVFaEbq3u8hWrx4PNslHaGN5GH8y1U47QVK7KIMALTD/DYpqg
         ftgg==
X-Gm-Message-State: AOAM532reMtoW+npY/IlNLtAX0QbOnkyKCERE4mx4M7XJS+vRGvxhS6J
        PG1D19qN+0lMsmnhiVmQIHAJTKIy5QdsBFWK
X-Google-Smtp-Source: ABdhPJynwZCuNTz1MOt+2HfnZf5Tn+qRujwbGWZkMySSKZi+WO82aUyw2Pd/gS6uipCLO/A9mtcpyQ==
X-Received: by 2002:a17:906:9719:: with SMTP id k25mr17288756ejx.460.1626521381978;
        Sat, 17 Jul 2021 04:29:41 -0700 (PDT)
Received: from localhost.localdomain ([37.155.10.130])
        by smtp.gmail.com with ESMTPSA id g3sm3782743ejp.2.2021.07.17.04.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 04:29:41 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com
Subject: [PATCH] net: sched: fix memory leak in tcindex_partial_destroy_work
Date:   Sat, 17 Jul 2021 14:29:33 +0300
Message-Id: <20210717112933.12670-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in tcindex_set_parms(). The problem was in
non-freed perfect hash in tcindex_partial_destroy_work().

In tcindex_set_parms() new tcindex_data is allocated and some fields from
old one are copied to new one, but not the perfect hash. Since
tcindex_partial_destroy_work() is the destroy function for old
tcindex_data, we need to free perfect hash to avoid memory leak.

Reported-and-tested-by: syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com
Fixes: 331b72922c5f ("net: sched: RCU cls_tcindex")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/sched/cls_tcindex.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index c4007b9cd16d..7ffc7be1e05d 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -278,6 +278,8 @@ static int tcindex_filter_result_init(struct tcindex_filter_result *r,
 			     TCA_TCINDEX_POLICE);
 }
 
+static void tcindex_free_perfect_hash(struct tcindex_data *cp);
+
 static void tcindex_partial_destroy_work(struct work_struct *work)
 {
 	struct tcindex_data *p = container_of(to_rcu_work(work),
@@ -285,7 +287,8 @@ static void tcindex_partial_destroy_work(struct work_struct *work)
 					      rwork);
 
 	rtnl_lock();
-	kfree(p->perfect);
+	if (p->perfect)
+		tcindex_free_perfect_hash(p);
 	kfree(p);
 	rtnl_unlock();
 }
-- 
2.32.0

