Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB5A248E31
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgHRSw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHRSw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 14:52:57 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E160CC061389;
        Tue, 18 Aug 2020 11:52:56 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s14so3670992plp.4;
        Tue, 18 Aug 2020 11:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ytj+BpqeiCrlRi7pvlYx49LlX+2X2MCiIXaiNwEamZU=;
        b=ljAN3lAlDQmWRLF/4kSakgZyYJqVjxliynG2w9uxzkZoHlpmCn/LRCXPYkuP6ix001
         b4bfZdnL5idVfDF6BwQJlHs/CCqo1jPxDFX32xqMRR5Wee5DKc9OXbXY6TxOFEHNbhsG
         q5PrNLeAyfkhUrThitvq+yh+0HP8zQJEdox4vvFKRBAxbW+JiekwNXZ08L8MvIp0iMUi
         vvb8QzolBefq6C5G3rXen+6iBPcdMw+yARKM5ELB/i4j0TL+DD9NFn09NJdk9/VGL1YT
         H1hZrpwX18v278lMfJVvp5Aui9+hCczxa69Bfchu8yHlX6DiYTK23XlfiPqeZ0puiXg8
         3ZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ytj+BpqeiCrlRi7pvlYx49LlX+2X2MCiIXaiNwEamZU=;
        b=glqTEAn34T2Xhy+uqKFjD5oczhy7PVWSf/hcmX4cMDXthamq7vaLNtST1Wy/15anEJ
         MV0rwtcyBg1Eufq19u3IEz8LetSVIvk+hNBBeE0E4zTDQlAEzwo0Or7SKg7HgIS9CgMb
         jEDUu03ETw+Z6w22XwyErt6ER+0KpY2C5o2AXwATd43gkzjzbtV8fxglrM8eC0MV1wAI
         dvzmQv7beSggDckftlvavQPuoQjYnGv9tJPuzIPGEQPds2h7sCJVsZ+QaexNeOiN7cVQ
         DmhYowrEXQhO8oVoFCgjRDBhxHavsYzqgaVmKWmEISJUXM3nmoMoi+kLBtHM6y2JJSw9
         QVZQ==
X-Gm-Message-State: AOAM530Za9HN3cHzjAOuBUL18CxFiYP6fKYfBVl9FzeDbY04iO3J9v8M
        kq7G6HsiLfCxJcTSjoRNT0qjHzc1mw3DRA==
X-Google-Smtp-Source: ABdhPJzvh5vMEZUjEmQMj7IkexRr7QUmC8ecHyrzolXuv+AcJAzPPWTgacFUZ6kqI6LMaABbYD9Pmw==
X-Received: by 2002:a17:902:b616:: with SMTP id b22mr15843878pls.246.1597776776405;
        Tue, 18 Aug 2020 11:52:56 -0700 (PDT)
Received: from localhost.localdomain ([49.207.62.177])
        by smtp.gmail.com with ESMTPSA id r15sm26774398pfq.189.2020.08.18.11.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 11:52:55 -0700 (PDT)
From:   Sumera Priyadarsini <sylphrenadin@gmail.com>
To:     davem@davemloft.net
Cc:     claudiu.manoil@nxp.com, kuba@kernel.org, Julia.Lawall@lip6.fr,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sumera Priyadarsini <sylphrenadin@gmail.com>
Subject: [PATCH] net: gianfar: Add of_node_put() before goto statement
Date:   Wed, 19 Aug 2020 00:22:41 +0530
Message-Id: <20200818185241.22277-1-sylphrenadin@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every iteration of for_each_available_child_of_node() decrements
reference count of the previous node, however when control
is transferred from the middle of the loop, as in the case of
a return or break or goto, there is no decrement thus ultimately
resulting in a memory leak.

Fix a potential memory leak in gianfar.c by inserting of_node_put()
before the goto statement.

Issue found with Coccinelle.

Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index b513b8c5c3b5..41dd3d0f3452 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -750,8 +750,10 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 				continue;
 
 			err = gfar_parse_group(child, priv, model);
-			if (err)
+			if (err) {
+				of_node_put(child);
 				goto err_grp_init;
+			}
 		}
 	} else { /* SQ_SG_MODE */
 		err = gfar_parse_group(np, priv, model);
-- 
2.17.1

