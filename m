Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB99E4B129C
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244089AbiBJQX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:23:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbiBJQXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:23:55 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E77B8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:23:56 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso4867964pjj.1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TZLDQqvtrtjYDQxcfx0030/+RgQSopx3mnKMqKHFXNA=;
        b=ogjIC8DLW7xqWKGhyu71oMycX4n5d/CHGr20gf5i+hOaN1coafpFd1N+KBdURiicVG
         LrWSrRjEMmAID8hHymxSTtZ8p+DCNm7LrJPvpjBkcyDFlOxL4QESUCdPO5IMIuegLwfX
         rOqWjLiNySX7ETlHrE9HR9oFzMgdxd8AT8K5p+3YIfimCIbytfwaH+EUKfzSmLS0G3sl
         I8S8I48dDyyjMERUsCyZgWL9diZeWn49r+z58doINphuANTV80O0FYywTzLw0Z9qLDMi
         i3Hek1HcetRnbDuqhVT95lRzzzbf3EpDP43lcwh+u8miVLWI4orkVYpQwFSPJlDRpS/c
         hpTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TZLDQqvtrtjYDQxcfx0030/+RgQSopx3mnKMqKHFXNA=;
        b=DPNXBoQwxg4lgOnBVJE7u0iysUlZ4XqP8gWcSrTtVWeDbXBk5RbEqptasmQSF/egI9
         eZpoSgIH7AjncYyKRJq9+TIIz8en7+RmQKHzn6ad9OMSnH9jXWc8TiyqE6EUJ30ZDFqR
         ZUAUD0ETMRz3Obemx9DMbewxwyIyHGrIfCS9MVG3gioAns6PDubEZlygvbVF4wLjzVqx
         MfbaM3A9L2HG8iGVTIzQMRYTXitp6/P3EXICLNXDABxzQjVCOhCIXwSHGLO2cN0/Fcxz
         Fhoo/1IyVU5r1aAE9DLqTp1b8NHR90s/igfb/mcLwCihTNi4SrwEUnFebgpk1SUVoKoz
         AYcQ==
X-Gm-Message-State: AOAM5338wU5r84d2QDUZWckcjHDPVtF1oLFDKBVYj38SNAQ/kouz8sU1
        8Cb7yDf6JCo/aVmbDie9tYM=
X-Google-Smtp-Source: ABdhPJweD7QmUeamDBn1zkUM2jAxHaJkkw5lrMmujpmBCehgcxh15AIHp6uqITASj3rRl+3/lsoanA==
X-Received: by 2002:a17:902:ac88:: with SMTP id h8mr8065512plr.128.1644510236066;
        Thu, 10 Feb 2022 08:23:56 -0800 (PST)
Received: from localhost.localdomain ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id 19sm2831767pjb.42.2022.02.10.08.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:23:55 -0800 (PST)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Cc:     ennoerlangen@gmail.com, george.mccollister@gmail.com,
        olteanv@gmail.com, marco.wenzel@a-eberle.de,
        syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
Subject: [PATCH v2 net-next] net: hsr: fix suspicious usage in hsr_node_get_first()
Date:   Thu, 10 Feb 2022 16:23:46 +0000
Message-Id: <20220210162346.6676-1-claudiajkang@gmail.com>
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
v2:
 - rebase current net-next tree

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

