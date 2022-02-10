Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2954B120E
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243750AbiBJPtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:49:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbiBJPtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:49:19 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F92BAE
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:49:21 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u12so2139906plf.13
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vN/MgKDwQzyisPjcjMkOSdCn/0rDGPWunTFqpoTJf8c=;
        b=dnDgPN/bU68Db4q6zsPC43Id0FCTiAzcA4vNe3gP+Hg2C4vyY8VdXlcx+rrVQE9Jo3
         ESc86ER2KyjyTLhsylnmFK1byCBlR5sauhaAXIN0l46An2rGidISSb9KI4ZijWVa6Tjj
         r3DTCauh8jq45PqaB+INkCKpfAK0xACEqh1Y+fmH3ULz1Dxfq2WyBi3BE6kaZ9IUOYcj
         8N2De/4DpH9RTVwpCTBAok5vEPC9iyL7jTqb8tc1MJ7nVgnigPeAZTlKUuGwKMXQerKI
         xhsnwT/RGd37TIJ7YOsamuAVsSAsR2MUm5FqD8BvvH4UoiBQBE0t83cymwsQOfNpKS+s
         +UQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vN/MgKDwQzyisPjcjMkOSdCn/0rDGPWunTFqpoTJf8c=;
        b=UxlQXm/azPDoq9QoiddUXqDRJsT7ZSxSFz3ON2lUH3umkzu29o7qU9SDCPYX1PdLDY
         3ygBfZ/f+UNeH6WUeSVelvcMr8G8sobn2NKTHMoaF8d0niMMI1Y1a+pfDjw8mDyOehOV
         JvGzBbVgSia6Vgb4RhI3qMZVMFFYcq8OfBtDwdWn2o/DzQBiBDTwakNvrgLAK4bKw724
         RrSxGnUSbNGtlIygcopruuKA18fthczlJP0QLn/g2IdJCBTAUhKb1bAxUYbjvX5O8nkY
         FwBYHzkCQ3go64Lb3HhC0EmMxNPtni/joq0Fsvod0o8YypLe1OW8lbA6Q0ZcXC/s6pYU
         rj0A==
X-Gm-Message-State: AOAM530v2IW/ItFsJDYygnYXxjS1tuZ13bPYZ/Pc2T4PnyiWJoJJzmoJ
        EgrxDK5g7tfiSGmuxxoEkeqGwkanZVyoU1T1OWY=
X-Google-Smtp-Source: ABdhPJxGx6O/r/rKaain4O2u/fKe1bV5J8b4t4ri//vVl33Pmh5a63gLIRLtw/R6vgmz8GQjNbb4dQ==
X-Received: by 2002:a17:90a:f0d4:: with SMTP id fa20mr3441027pjb.1.1644508160438;
        Thu, 10 Feb 2022 07:49:20 -0800 (PST)
Received: from localhost.localdomain ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id l14sm3000060pjf.1.2022.02.10.07.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:49:20 -0800 (PST)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Cc:     ennoerlangen@gmail.com, george.mccollister@gmail.com,
        olteanv@gmail.com, marco.wenzel@a-eberle.de,
        xiong.zhenwu@zte.com.cn,
        syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
Subject: [PATCH net] net: hsr: fix suspicious usage in hsr_node_get_first
Date:   Thu, 10 Feb 2022 15:49:12 +0000
Message-Id: <20220210154912.5803-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Currently, to dereference hlist_node which is result of hlist_first_rcu(),
rcu_dereference() is used. But, suspicious RCU warnings occur because
the caller doesn't acquire RCU. So it was solved by adding rcu_read_lock().

The kernel test robot reports:
    [   53.750001][ T3597] =============================
    [   53.754849][ T3597] WARNING: suspicious RCU usage
    [   53.759833][ T3597] 5.17.0-rc2-syzkaller-00903-g45230829827b #0 Not tainted
    [   53.766947][ T3597] -----------------------------
    [   53.771840][ T3597] net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!
    [   53.780129][ T3597] other info that might help us debug this:
    [   53.790594][ T3597] rcu_scheduler_active = 2, debug_locks = 1
    [   53.798896][ T3597] 2 locks held by syz-executor.0/3597:

Fixes: 4acc45db7115 ("net: hsr: use hlist_head instead of list_head for mac addresses")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 net/hsr/hsr_framereg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index b3c6ffa1894d..92abdf855327 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -31,7 +31,10 @@ struct hsr_node *hsr_node_get_first(struct hlist_head *head)
 {
 	struct hlist_node *first;
 
+	rcu_read_lock();
 	first = rcu_dereference(hlist_first_rcu(head));
+	rcu_read_unlock();
+
 	if (first)
 		return hlist_entry(first, struct hsr_node, mac_list);
 
-- 
2.25.1

