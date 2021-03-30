Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9263434E9CC
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhC3OCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbhC3OC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:02:29 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A71C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:02:28 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g20so8440831wmk.3
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=lqRJMoKmqYUamKc0KxaI/u8DpFqhLO6WWMh5+NalI3E=;
        b=SSC/ytgRNImyCIyE9eJ/Mlju3Gtby94/WSm79nO3KRMxEznC7glseibWM0qZ8RfqwS
         PCd6ndNra8GOGDwDXYqBm+xKFDpgoNUwcOcH7XAvgJhBQw1wvuAUipIBsiZ5tSqUK1MX
         O3SV6WCmPHNslH89WS8UfXEfabKX1B8dD+X2bX3nx5JtWAIOavjg6/4g09RdCs/1DN5p
         6ga0XjxzGTudgIHyY0rya03A7TljqV94c4MZcbKMs739DB+pDL2a4RXK7aOlfiHQB1pY
         WFOv2ZPZ3bdLFqXO8DLlO4ekx0ZznJMdPOrYEXklkCHH9yFHJSLzzC4FWVGtUBSHxHtl
         E4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lqRJMoKmqYUamKc0KxaI/u8DpFqhLO6WWMh5+NalI3E=;
        b=VeSlyecZkNPPH8QdRaiZ/oDzqxHyskKGI8Bj+cHUJRUhlXq4LQspeBDKJz1014u0lh
         gjHaT4jlY7Vv1fJ85FY+4ezOh8k554UMPtRIhBCdf/0DvLOAK+gt3VxX72nm9Xsad96x
         uEImXSmj3gSMhPIB19VE4eEpN9qHMpt8rw9BIn0OBAmRmabIi1op7fNBpUIfoJyofM/4
         j91ku1JgVI1bP2MU8vxjCOvil2QaMi046r45HFAr5zjSuVKjnorwzN1h0t8BhQUcDBOu
         CabqZhkIbPukgE+BKTwOMoL5ahsfDVeZpXpYzYfEJXSjZa+KbNLEl8zhrbWuKCgsApvA
         ABIw==
X-Gm-Message-State: AOAM530do0rWdqX7gmwxfJaDXQQCEAJwaygenn95G/SdDXvQBQkwN3HW
        YlDGRZsd4xetUzqz2GOXYG126Q==
X-Google-Smtp-Source: ABdhPJzzsh6dSM2rK68bNdPJFqMA5xnkr5PKi4qC91aiHgQRRLixaliRIR9uCUyAmd9gb3dcH+yYhw==
X-Received: by 2002:a7b:ce16:: with SMTP id m22mr4394920wmc.65.1617112947633;
        Tue, 30 Mar 2021 07:02:27 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:f64e:6bc4:f9f4:9202])
        by smtp.gmail.com with ESMTPSA id a15sm24891782wrr.53.2021.03.30.07.02.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Mar 2021 07:02:27 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     manivannan.sadhasivam@linaro.org
Cc:     netdev@vger.kernel.org, bjorn.andersson@linaro.org,
        kuba@kernel.org, davem@davemloft.net,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] net: qrtr: Fix memory leak on qrtr_tx_wait failure
Date:   Tue, 30 Mar 2021 16:11:08 +0200
Message-Id: <1617113468-19222-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qrtr_tx_wait does not check for radix_tree_insert failure, causing
the 'flow' object to be unreferenced after qrtr_tx_wait return. Fix
that by releasing flow on radix_tree_insert failure.

Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow control")
Reported-by: syzbot+739016799a89c530b32a@syzkaller.appspotmail.com
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 net/qrtr/qrtr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index f4ab3ca6..a01b50c7 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -271,7 +271,10 @@ static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
 		flow = kzalloc(sizeof(*flow), GFP_KERNEL);
 		if (flow) {
 			init_waitqueue_head(&flow->resume_tx);
-			radix_tree_insert(&node->qrtr_tx_flow, key, flow);
+			if (radix_tree_insert(&node->qrtr_tx_flow, key, flow)) {
+				kfree(flow);
+				flow = NULL;
+			}
 		}
 	}
 	mutex_unlock(&node->qrtr_tx_lock);
-- 
2.7.4

