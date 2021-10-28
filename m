Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3054343E2C4
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhJ1N7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbhJ1N7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:59:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC39C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 06:56:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id n36-20020a17090a5aa700b0019fa884ab85so7979592pji.5
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 06:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T5gtyFNSV98fxFw4D4Snvxpenx6sTbrIAms1H1Mh3YE=;
        b=C0QcO6bGmBP/2PaNBmYwBKlkBkc/BqBwgxjpYI1kgLo2ZpuJwhYYiFMVarRknQ8p3E
         9bn5hHriyhQG8SOwcMFjI0SxDhPaF/HhnGz3TkXHwTJ+Fk3w9FTFwwYD269ziBZwzidG
         T5DowlKJWWB2kL75Sli1un+wjrljdrTGxTWX0CsEs37j844ub3W0b0lwtJ1poZv/jXBK
         7BYNdbBdXGD1yfckupoV+7T51zXSTEchLJ8sWKhmpN2qa1Q8wt6JNi3W4LsB79ICnIK+
         OILTiLUqPJXEDdxbreTPAJiMahYZu3kVhpmWRS3DvGHudVpFQcqe1Ja6nCofy9aSn4mP
         U6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T5gtyFNSV98fxFw4D4Snvxpenx6sTbrIAms1H1Mh3YE=;
        b=KJXatEWIF+8rpTlGTQD7DQ+oD7/tu5elw4ITjoUNAsucdMsTSHGobHzFf0i4uyDe9g
         HC8wnvwWdppiE/IQ3aviBkR5wCxvu7OIT8z6W2fUEurywVcNsTzaLypSkm4zp7mwl/sf
         2GWWUgKtpn6bt3XGeMfv2yB19d6QE3HbQ32z5bPLjUkmk7ne05PhYyA/FtdgcwuCIkAx
         +xnnGTg0CHl5teHHGJ41f7cFHJ3kgrMsp5yhMP4+Q/t0FnXnBlbKuVZDg634ycoE74WB
         LiV/mBhm0XetdMdK5SVv7m40QSlqC7BBR8NvlB+bieIt5bMHzIx5fBg/pHiyHchsoo31
         I7pA==
X-Gm-Message-State: AOAM533hXfi/kxkey9FfpDx2o03rMmif4UBJhjn9F5Vt5Db8auIf91/T
        3Hbo93NtZkBPkRzIr0/dhUwPR6MUjWM=
X-Google-Smtp-Source: ABdhPJzaX+NccE5HBcoNYWmWrH3X4tv0dg5/k5W1P8caMIR0CWQK2A9WteqDlJ2jMTsZVR2AdU1yhg==
X-Received: by 2002:a17:90a:1190:: with SMTP id e16mr4683953pja.209.1635429410459;
        Thu, 28 Oct 2021 06:56:50 -0700 (PDT)
Received: from localhost.localdomain ([111.201.149.194])
        by smtp.gmail.com with ESMTPSA id a10sm2905134pgw.25.2021.10.28.06.56.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Oct 2021 06:56:49 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: sched: check tc_skip_classify as far as possible
Date:   Thu, 28 Oct 2021 21:56:44 +0800
Message-Id: <20211028135644.2258-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We look up and then check tc_skip_classify flag in net
sched layer, even though skb don't want to be classified.
That case may consume a lot of cpu cycles.

Install the rules as below:
$ for id in $(seq 1 100); do
$ 	tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
$ done

netperf:
$ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
$ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32

Without this patch:
10662.33 tps
108.95 Mbit/s

With this patch:
12434.48 tps
145.89 Mbit/s

For TCP_RR, there are 16.6% improvement, TCP_STREAM 33.9%.

Cc: Willem de Bruijn <willemb@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/dev.c      | 3 ++-
 net/sched/act_api.c | 3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index eb61a8821b3a..856ac1fb75b4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4155,7 +4155,8 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 #ifdef CONFIG_NET_CLS_ACT
 	skb->tc_at_ingress = 0;
 # ifdef CONFIG_NET_EGRESS
-	if (static_branch_unlikely(&egress_needed_key)) {
+	if (static_branch_unlikely(&egress_needed_key) &&
+	    !skb_skip_tc_classify(skb)) {
 		skb = sch_handle_egress(skb, &rc, dev);
 		if (!skb)
 			goto out;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 7dd3a2dc5fa4..bd66f27178be 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -722,9 +722,6 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 	int i;
 	int ret = TC_ACT_OK;
 
-	if (skb_skip_tc_classify(skb))
-		return TC_ACT_OK;
-
 restart_act_graph:
 	for (i = 0; i < nr_actions; i++) {
 		const struct tc_action *a = actions[i];
-- 
2.27.0

