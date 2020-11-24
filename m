Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDEF2C320D
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 21:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731722AbgKXUi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 15:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgKXUi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 15:38:28 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965F1C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 12:38:28 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id s21so143049pfu.13
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 12:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iRS1X6wZ1eCJrc5Bx6GVBYf7zuzVdAhi9gDCtNi3SiA=;
        b=uiJ6VMcKxdDZF9oRIGKffS/zhaqlB3ZuxHrxV6C//eAad7W/0gU1nDGDbI4mXVdz8P
         1AU1WRfwo+u4PqdBNKktIjuUjLml8TgYhxbtFYm5ayiGXLCcEvEPwhJ5XsEdsK76Wer1
         X+Njpak+/tQGO5SBQRgt+ITd1C5VB87kldhVU0ke3ZlF44fVk14yWDObOKpIzpMOnyW1
         PVl+sDtMailHgeF1Eddv7v7RX0kiwq4SSf+xhFftUfu0vCBigTQp2YApr/7PVkuq68zQ
         bbyYo5OBcb9YjP28+OqeFwNbwgOsMTA5jt8XRrhRXVM9AFHtFYNi7ANOumg00PDLc01v
         xX9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iRS1X6wZ1eCJrc5Bx6GVBYf7zuzVdAhi9gDCtNi3SiA=;
        b=rBMhMa7kSxDsMnl6Enor4YSiLrfz3YdkWECICLDLEo92R/P93XZYLTX1Rzp5AbVOlb
         Eo79Oygs3mBIDqcATG0O4J3w9oYn7YLZmWX7dfzsyXCcAOssWVfxXw0Z7Fr+7c6pkFE4
         +F97RMoAYQWGTFWqP68NIlHycWSTX1t+hGcUAfGqJaIUfEs0swUZMPTNnZdei2RaANzF
         ztBLbUaPn7F2nsKIeLbEQ9Widuv5DMPgCv3GKGesD0fNTGU8A485oBB8ffAD0Z65IMf9
         F3KqnzjnT0g7q1MU1eLY1SXfN9I/9j10Sjsmyl5b1tFXio/Ir+IcoZlOsoDK4xaasPok
         neLw==
X-Gm-Message-State: AOAM532Q8ZFz45qip4AHfj4P5QMhcEkoIvWDe5uDlB50HjJiri9h1lga
        ajb0fVlyuLu8GLAE/nXldLY=
X-Google-Smtp-Source: ABdhPJySn/Ks9UYWWXIipcyzIwYbnPaVIYgfTrjMBmIQUSZnNWONk/GgCbOaZXzEaX1J46+kp1Dhdg==
X-Received: by 2002:a65:6a50:: with SMTP id o16mr162442pgu.292.1606250308228;
        Tue, 24 Nov 2020 12:38:28 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id t6sm15495153pfb.45.2020.11.24.12.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 12:38:27 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] gro_cells: reduce number of synchronize_net() calls
Date:   Tue, 24 Nov 2020 12:38:22 -0800
Message-Id: <20201124203822.1360107-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

After cited commit, gro_cells_destroy() became damn slow
on hosts with a lot of cores.

This is because we have one additional synchronize_net() per cpu as
stated in the changelog.

gro_cells_init() is setting NAPI_STATE_NO_BUSY_POLL, and this was enough
to not have one synchronize_net() call per netif_napi_del()

We can factorize all the synchronize_net() to a single one,
right before freeing per-cpu memory.

Fixes: 5198d545dba8 ("net: remove napi_hash_del() from driver-facing API")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/gro_cells.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
index e095fb871d9120787bfdf62149f4d82e0e3b0a51..6eb2e5ec2c5068e1d798557e55d084b785187a9b 100644
--- a/net/core/gro_cells.c
+++ b/net/core/gro_cells.c
@@ -99,9 +99,14 @@ void gro_cells_destroy(struct gro_cells *gcells)
 		struct gro_cell *cell = per_cpu_ptr(gcells->cells, i);
 
 		napi_disable(&cell->napi);
-		netif_napi_del(&cell->napi);
+		__netif_napi_del(&cell->napi);
 		__skb_queue_purge(&cell->napi_skbs);
 	}
+	/* This barrier is needed because netpoll could access dev->napi_list
+	 * under rcu protection.
+	 */
+	synchronize_net();
+
 	free_percpu(gcells->cells);
 	gcells->cells = NULL;
 }
-- 
2.29.2.454.gaff20da3a2-goog

