Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E012E33C1
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 03:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgL1Cyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 21:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgL1Cyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 21:54:32 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09CEC061794;
        Sun, 27 Dec 2020 18:53:52 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id h186so5605741pfe.0;
        Sun, 27 Dec 2020 18:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y9GjcdWdDXwMVCPh4R/oYm+2IT0dwMb9tBB+uvycjjY=;
        b=l4he/Zrdd8dEAvIQeOJrYq5TwY3Ue9Ac0Jbj1lBgvPCYkCVWuqZjJwM2b3M1MN/Epb
         axdGL6/adhs4+V1u49MGNqkANkVhFjH0RfH3ypPBYG9EGx2Dromy3BXrMAj4uHDkvrcJ
         L8JGAFXogegZ2VjDQkpHsfKxrEVOsyxzrgx037xjqF6ntEYgWAtH/EqQ2iI0Pugthh+o
         zIdnjNNsNrUcXw/wrIPc8yJqGybwSK3eXFMNwEDrXu1ECil+2hpy9MnFEA8HOEiNJEf1
         3WXqSmDkRQHP9G7sj0246rHZAIUItkvd97keN7AstN4yJmhn2deIo/3CibVN7p/VXb9v
         uxxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y9GjcdWdDXwMVCPh4R/oYm+2IT0dwMb9tBB+uvycjjY=;
        b=saEHyxZF+iJw6xew5ESly4zuEHaN3HPL5GpQho0frjyhmMc3KTLOS+1xJgQj6N5YoW
         W9sOZCzTinkYudURvA2EzmkI5oYI0i9bEwJLHV8reDbNJzaqgdUPPx4VAXT0uB8Ot7cD
         hybojQQSAB5KasVcXs/m1Q1dp6xECH4cksWJ6ZJWSwVgl5YyI6u0uqr86PnGSoWpqms1
         zsv25CHR5H+RbAQD73iTsgDv20R7AFiFXHuY8kMeClIJe5QToQ4pRC/3/0ZdgdaYVhBP
         Tuc0LvAaUObYowO8ApuhZ1N3Uo/1MU0EyU2BD13W38eGqf3RWH6aLIlhlOGXYKghNWRV
         kahA==
X-Gm-Message-State: AOAM5318Dd0GqagY84YtkfWC9Eber6p4sPd9bWAusqHhLFubadF/pMc5
        y02yEgxSmVzyYdh4LQDvCUQ=
X-Google-Smtp-Source: ABdhPJzIdlsTokLU8dAzHzq5D8auP0RtqFTMMHRBSKvnByGmzfxb+8rnlAhix0kwm/4v3BrpqiPm6A==
X-Received: by 2002:a62:3503:0:b029:1aa:6f15:b9fe with SMTP id c3-20020a6235030000b02901aa6f15b9femr39125193pfa.65.1609124032133;
        Sun, 27 Dec 2020 18:53:52 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:feaa:4103:8c8c:bf1])
        by smtp.gmail.com with ESMTPSA id w1sm12425173pjt.23.2020.12.27.18.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 18:53:51 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net v2] net: hdlc_ppp: Fix issues when mod_timer is called while timer is running
Date:   Sun, 27 Dec 2020 18:53:39 -0800
Message-Id: <20201228025339.3210-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ppp_cp_event is called directly or indirectly by ppp_rx with "ppp->lock"
held. It may call mod_timer to add a new timer. However, at the same time
ppp_timer may be already running and waiting for "ppp->lock". In this
case, there's no need for ppp_timer to continue running and it can just
exit.

If we let ppp_timer continue running, it may call add_timer. This causes
kernel panic because add_timer can't be called with a timer pending.
This patch fixes this problem.

Fixes: e022c2f07ae5 ("WAN: new synchronous PPP implementation for generic HDLC.")
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_ppp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 64f855651336..261b53fc8e04 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -569,6 +569,13 @@ static void ppp_timer(struct timer_list *t)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ppp->lock, flags);
+	/* mod_timer could be called after we entered this function but
+	 * before we got the lock.
+	 */
+	if (timer_pending(&proto->timer)) {
+		spin_unlock_irqrestore(&ppp->lock, flags);
+		return;
+	}
 	switch (proto->state) {
 	case STOPPING:
 	case REQ_SENT:
-- 
2.27.0

