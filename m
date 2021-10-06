Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD05423501
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 02:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbhJFAc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 20:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbhJFAc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 20:32:27 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD980C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 17:30:36 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so948651pjb.5
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 17:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ycW8AYFOytCSYeFeetiJ3I9rQl7R4jGO7P0glOYSzpg=;
        b=qGFRxObhLzC/dQUfvx/FZPJQLLOGW3O2VrCEOg8WJlPm3wLINNHtKkDBTJjSpO5r9Q
         xaWLA3ScPMnCfqwSy1LbavvQdtuV15PnRbcGXDsY1MhYaV+xoefflCHROWeivqyXmFO4
         wFKZcCS0VMYLpXK+yewc7tn94PtgfigSkRlBBJwvB/NEs6tUeKAblCaJG84KACIrqRaW
         VuxWUD/2FfzqirvjxYGbtH4acxlLgzECUs7rhbNTnqsWfrnpgy7JCsTdbLGrCUWfbyDd
         O+XDam4VpTDJwLymQ6Imm0O/aNfVHDMgf+TTANdcodF1YazWWmBtSPDZ1oK+zylWEb0C
         4jTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ycW8AYFOytCSYeFeetiJ3I9rQl7R4jGO7P0glOYSzpg=;
        b=FCtDEjzqMwEHVXSfvuShFu9is8CKOWWpsc/89Ib2mol57m3A+5qIdabuIEFdxQ8W3W
         9v/B5MGVe4OlursQt+V/lGauxThNnXSeHDdVZmNelYq9/H3rU27R+CRz4d3eQ2krKNy0
         GD+2sOnf+jaa4UIV/vdZs6w5PlV4ExJOmrLTqZMO3XZ5KjaAjP8xsTbPbUn5WZFHf0UV
         uZgMN6xj7FeCaNDhqnMiZY5k9GoKCrdBLbsIMD2EM5lzVN5+WBJ+8t3/zSKNd/2sn2XT
         FCd+w3yhgR9FmnzrLoB3y/jZjuvUHDNlIVWjCSD7+j70GHqRAOSZx3FdjSwFnVZKt+7O
         XJSA==
X-Gm-Message-State: AOAM530jvOYEPpb6VNrZbkYUcwomzophNlCHsL8UJOrT/vFpMRKJ7D83
        3taqvkuDwnVv3+tFqtkczXY=
X-Google-Smtp-Source: ABdhPJwkfD9Kv/ZmQAPc89NY50UfnkBUzdat74LGEzu1zJu/Mjdc8ntOWtSkGiUSry7VbAG2KilmNw==
X-Received: by 2002:a17:90b:4a05:: with SMTP id kk5mr7331254pjb.25.1633480236212;
        Tue, 05 Oct 2021 17:30:36 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4c77:3139:c57:fc29])
        by smtp.gmail.com with ESMTPSA id a13sm18774164pfn.24.2021.10.05.17.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 17:30:35 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Tao Liu <xliutaox@google.com>
Subject: [PATCH net] gve: fix gve_get_stats()
Date:   Tue,  5 Oct 2021 17:30:30 -0700
Message-Id: <20211006003030.3194995-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

gve_get_stats() can report wrong numbers if/when u64_stats_fetch_retry()
returns true.

What is needed here is to sample values in temporary variables,
and only use them after each loop is ended.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Catherine Sullivan <csully@google.com>
Cc: Sagi Shahar <sagis@google.com>
Cc: Jon Olson <jonolson@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Luigi Rizzo <lrizzo@google.com>
Cc: Jeroen de Borst <jeroendb@google.com>
Cc: Tao Liu <xliutaox@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 099a2bc5ae6704553516561106a0bb6822fdb8e4..99837c9d2cba698ada900229330cb10bc1606a6b 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -41,6 +41,7 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 {
 	struct gve_priv *priv = netdev_priv(dev);
 	unsigned int start;
+	u64 packets, bytes;
 	int ring;
 
 	if (priv->rx) {
@@ -48,10 +49,12 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 			do {
 				start =
 				  u64_stats_fetch_begin(&priv->rx[ring].statss);
-				s->rx_packets += priv->rx[ring].rpackets;
-				s->rx_bytes += priv->rx[ring].rbytes;
+				packets = priv->rx[ring].rpackets;
+				bytes = priv->rx[ring].rbytes;
 			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
 						       start));
+			s->rx_packets += packets;
+			s->rx_bytes += bytes;
 		}
 	}
 	if (priv->tx) {
@@ -59,10 +62,12 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 			do {
 				start =
 				  u64_stats_fetch_begin(&priv->tx[ring].statss);
-				s->tx_packets += priv->tx[ring].pkt_done;
-				s->tx_bytes += priv->tx[ring].bytes_done;
+				packets = priv->tx[ring].pkt_done;
+				bytes = priv->tx[ring].bytes_done;
 			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
 						       start));
+			s->tx_packets += packets;
+			s->tx_bytes += bytes;
 		}
 	}
 }
-- 
2.33.0.800.g4c38ced690-goog

