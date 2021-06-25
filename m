Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6349D3B49B9
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 22:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFYU0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 16:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhFYU0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 16:26:15 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989B8C061574;
        Fri, 25 Jun 2021 13:23:53 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id d2so14121118ljj.11;
        Fri, 25 Jun 2021 13:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CI9kYZ5ZpRaDM0UxDOABOKTjftV26nJRscJMXYprTWE=;
        b=K3Q30s+HDeC9XxbnuFtZPvl+etSlFEFPnM+uW0Oq6TYAH0c1woqkk5C4cr7Jo5BDQO
         N6lABcGq3KnptaeW/ec3cShkx2xMnvca+PPxqEtHDWP0YB73plLXOFo4OXtYsyTqA/WB
         dqNbCgDUNcm02kc7iwK8b4TcbRonSC26dDWkR/msBEMTOyhIqppKT3YYBxz3rOjAtRE4
         mobOHFWRbxWUWznlCGbUIpiMwAsMBCJToX6HnRBucrQRyKfUvk6sJVf5a+DugBfH3bU1
         meXGvPn/00IUTOTIVONqCJYLjr8HC20M+guhRDC/v5fkLhdGLUuV+C2kjZQ2rlq/HBF6
         zo7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CI9kYZ5ZpRaDM0UxDOABOKTjftV26nJRscJMXYprTWE=;
        b=mcWgxEdZP26DKXUztmiuJVLsxqnQeXs5Mlv4aGyRfXB3wSXW3QZnPPwgIgIdtSm/Li
         CQeyekbw3Q35sbw+DuIoxrxBpNh4xitoxjTSp8mxyvBqy/SepSO+suXjSnOCcUfDGIv9
         ZnpnDjhrjZW0PXIeoGdpAqEeqYDKOOuRg7JAcwrWrtSEdUNLJzv9ehGr2hltF+BgB+9C
         ZFjesM8knd/QgBYElHVtxIBLg1iOc6qFlnBBo3mZc2NayH3bzEJhLMVVrm5M1YqQd3iP
         UPTfJeLKx2WvXcoO8MgQLDzpd61xwiTf1RJfzYVvuuFFcdOYnvGbXnl7gDKgZlfXYPoS
         cAAg==
X-Gm-Message-State: AOAM531c/Ur8h+LZRDLc6m6jpKPtChDg/jtgrRqa6a1w6hFuwbMu0GX8
        FVVCFe7wZbhVmueQDdI1ssI=
X-Google-Smtp-Source: ABdhPJyhpuE6ABebmByQKV8lihGqXyNOafRyMacrajKeyJ1TbFs7HyihR5nWGsKWaGITqfks4eWPIA==
X-Received: by 2002:a2e:9f4c:: with SMTP id v12mr7233089ljk.179.1624652631812;
        Fri, 25 Jun 2021 13:23:51 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id v14sm599897lfi.83.2021.06.25.13.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 13:23:51 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com
Subject: [PATCH] net: sched: fix warning in tcindex_alloc_perfect_hash
Date:   Fri, 25 Jun 2021 23:23:48 +0300
Message-Id: <20210625202348.24560-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported warning in tcindex_alloc_perfect_hash. The problem
was in too big cp->hash, which triggers warning in kmalloc. Since
cp->hash comes from userspace, there is no need to warn if value
is not correct

Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
Reported-and-tested-by: syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/sched/cls_tcindex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index c4007b9cd16d..5b274534264c 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -304,7 +304,7 @@ static int tcindex_alloc_perfect_hash(struct net *net, struct tcindex_data *cp)
 	int i, err = 0;
 
 	cp->perfect = kcalloc(cp->hash, sizeof(struct tcindex_filter_result),
-			      GFP_KERNEL);
+			      GFP_KERNEL | __GFP_NOWARN);
 	if (!cp->perfect)
 		return -ENOMEM;
 
-- 
2.32.0

