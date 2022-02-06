Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966C04AAFF9
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 15:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242798AbiBFOdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 09:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242616AbiBFOdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 09:33:53 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A92C06173B
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 06:33:52 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id y9so2802723pjf.1
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 06:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DP+t2wAz0BLh4JRimJqwNiYNMCt/l4Dx8nWRptSyZZw=;
        b=k+2LnW4buye6IvJDKBWHo27GTiinNfPZGJqVDqZnF+gdabACFAvCyajsVMd0uOYVuI
         JsgUjaD/KirwHDpVhqV02Enm3SETveuYmza0U07PIUlqfmv1HGoZwaKajoHeOisMuawZ
         HSK7V87hZvoll+jEB6KvZIgX5dV+qN+KEHTCn7Gl3ALj73rmuMvoHZO4JvQ+lmmW/nW3
         XaFthtvnQWg1LTVwY1BB4LfPibA57uMGN4J7CqVL+jN3P+x5BvAQX0vpRLx8cCPSaM9/
         Agd13jvzXwObKDcoxl75LMopkvH6OEFdPo7+6nuvjJYRm8VdwbCz0uXDIZZ4wYzaCWpy
         HJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DP+t2wAz0BLh4JRimJqwNiYNMCt/l4Dx8nWRptSyZZw=;
        b=RmfBZ7D2R9Gqb931RyNCqiyPLcbkQBEd/Ijqm1HXAO6hKPRns0oPOc8MCtTd6Ar6uY
         3SuTfTAmFMhZ068QrSkc8t1bOfvZIANsQhR5Ddlzk8LQ/qolUOzuEULOJS9lTepe2Ms8
         ASgsaJ4zA4fc3Uo5XGMSEQf4Ln9l4itG6o6UEUKgXb9TLFC3flJNGQZ4YbLMRDLeuiO0
         JyOIzRpCiW+9ZFPjL7KSp1RfOghBPAj0VYLNyi7hEfUJUV/n2w57xGG/qjZEUGXbUHZg
         t9GHpDClvxUKSu+af63Mj4bDK2+0tbuo/E56YJ+ny2WHs4aAxG0L5+9tYgP+6s/YNr9L
         eeCw==
X-Gm-Message-State: AOAM5308vxJdrredMOZkr5/erMp8KsCB3wLAN6oPbVESPitJSLShfV7G
        983NjYr7H+/HhKdds5gAPmg=
X-Google-Smtp-Source: ABdhPJzdZ6vKAEZyB7d1+SPlpWMbQn/EGJ4/p7iXz9XCI/ah81a6e+juU0cwKrOAWhCw9XItDzGwAQ==
X-Received: by 2002:a17:902:a9c5:: with SMTP id b5mr12410326plr.167.1644158032415;
        Sun, 06 Feb 2022 06:33:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8eb:b7ed:dbe7:a81f])
        by smtp.gmail.com with ESMTPSA id e19sm6016747pjr.50.2022.02.06.06.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 06:33:51 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] net/smc: use GFP_ATOMIC allocation in smc_pnet_add_eth()
Date:   Sun,  6 Feb 2022 06:33:48 -0800
Message-Id: <20220206143348.350693-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
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

From: Eric Dumazet <edumazet@google.com>

My last patch moved the netdev_tracker_alloc() call to a section
protected by a write_lock().

I should have replaced GFP_KERNEL with GFP_ATOMIC to avoid the infamous:

BUG: sleeping function called from invalid context at include/linux/sched/mm.h:256

Fixes: 28f922213886 ("net/smc: fix ref_tracker issue in smc_pnet_add()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/smc/smc_pnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index fb6331d97185a5db9b4539e7f081e9fa469bc44b..0599246c037690b4b01813956e4af74519277bea 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -382,7 +382,7 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 		if (ndev) {
 			new_pe->ndev = ndev;
 			netdev_tracker_alloc(ndev, &new_pe->dev_tracker,
-					     GFP_KERNEL);
+					     GFP_ATOMIC);
 		}
 		list_add_tail(&new_pe->list, &pnettable->pnetlist);
 		write_unlock(&pnettable->lock);
-- 
2.35.0.263.gb82422642f-goog

