Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3274536FF
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhKPQNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbhKPQM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 11:12:29 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FB5C061766
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:09:30 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so3322241pjb.1
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=cYi+0J3O/mkcKeZzLi5DGW4y3mf5Tpi9h27G7Z0Z+s0=;
        b=aIidVUoF96NPZLmoQ6GuA1JwSGjzrRa447n5m3oBiGEl/5MtqExZl6sG/0gyAGxVu1
         jUXzMJnTdUp/uzVoqwSU5sTdJOzux+fpKQCmBs+hLFncuRTDYvGPTGUKemskhSjzN8DX
         OKmlxS35D4uXHjiek8eZAIY7t7Bh4BG1V6wHOHWP2q0kgcXFz0TB5PE6aXGuGS85qbKX
         DSPLAERJXY3FRrEWhfrsKcpcaGfS3Z7U82bvq8Er2v71JJFwf25Q/7tu/4t3sasjz1qf
         Zkbzxocv1JgfY4oOL/negnXJd3p0Q1AKg8dghOuoW1QyFqLcwKTcj2aLG/5zPdl74czh
         H1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cYi+0J3O/mkcKeZzLi5DGW4y3mf5Tpi9h27G7Z0Z+s0=;
        b=6By9lJoVHpah1fjv7f74RIpNSQnw+yjIIyNpxarBOsak82ipLpPoLYjfHC6ey6rFS5
         myCzLSCWUqeMxV43s6KEBN274i3++OQyReWB5VvKhMR1IXCPnK2wHfPk4RuA7JCxpG1A
         N8Z19oHgmZ8Ew8+fFM+OLhUW4yWuWsI3Ym4R4G9ZzmMlFyeFLU0Ebl+ZghxtN7LJNV73
         r+IBPSmeRE/J29ICnoPwU7ZzPxnhUEybMjowSFfv5TFdmIOTMK7MKq5K9FmyQGUyTL4f
         FJgTMm6b2rgNXzbw+Jo3zJF/kxiaRByaL3S/Ix8GTK6+sH+fHM+cLthNuUYeVMgttmJd
         6Wtg==
X-Gm-Message-State: AOAM532tjX+0ZwXswtECQqOTDoSUNHyfqwW1ecczfamcgnt/Zg6NnX0s
        yQ4N1Z+YZnwfBhExpZqPjYA=
X-Google-Smtp-Source: ABdhPJzi12ni2CNOHgq1sd7HhrfW3FxAavqT/ltT82MqOaNhsFXrl2QHHORo/BB2DyFpwB0h/Jl43Q==
X-Received: by 2002:a17:90a:7004:: with SMTP id f4mr341317pjk.156.1637078970357;
        Tue, 16 Nov 2021 08:09:30 -0800 (PST)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id lt5sm2727526pjb.43.2021.11.16.08.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:09:29 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] amt: cancel delayed_work synchronously in amt_fini()
Date:   Tue, 16 Nov 2021 16:09:23 +0000
Message-Id: <20211116160923.25258-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the amt module is being removed, it calls cancel_delayed_work()
to cancel pending delayed_work. But this function doesn't wait for
canceling delayed_work.
So, workers can be still doing after module delete.

In order to avoid this, cancel_delayed_work_sync() should be used instead.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Fixes: bc54e49c140b ("amt: add multicast(IGMP) report message handler")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 47a04c330885..b732ee9a50ef 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3286,7 +3286,7 @@ static void __exit amt_fini(void)
 {
 	rtnl_link_unregister(&amt_link_ops);
 	unregister_netdevice_notifier(&amt_notifier_block);
-	cancel_delayed_work(&source_gc_wq);
+	cancel_delayed_work_sync(&source_gc_wq);
 	__amt_source_gc_work();
 	destroy_workqueue(amt_wq);
 }
-- 
2.17.1

