Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8593427CC4
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhJISrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhJISri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:47:38 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3E8C061765
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 11:45:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so618556pjq.0
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 11:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4lWBYcfjuL+whODjagk0vnAumNnMPDqSxv60oiFH3/c=;
        b=zur8F/001JVwDKGwEPJIDFp790m6UzN4h6lEpBbkPTzvhPPTuh2tpv9Ae0eYstEJYx
         zbXk0GRzIGMk58V7gupMcX9oCFMd32AjwCvDQRTxuuGh9bu+DHutEHLaFekcluzp6tsT
         ZdxlclRumxS7i+c9b3LFyYRCKBvOjUGi67OmF6VmHZk6q5jMjMyclULKbOZPv5RAp27l
         B1hqMXinOScXRdVwy6n67wqeSTgdx4ETw5fh27y0Mrei1cMlCT1L7PETkppQ4XO5SjGi
         is8be3iClaGMTcyJQtCf3NJtGxEpw60ttfsnFqnh7SF3x/9MimqRAn9vGK/sSUkoSvTf
         Ec/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4lWBYcfjuL+whODjagk0vnAumNnMPDqSxv60oiFH3/c=;
        b=daWjqHMmsAwPzKn/ZBlm8wllgCVwqWrJdlq9SckiTFAJHc5bfrAGc4iM0QfaRPuVeX
         4+Vh4+msrKjRJCByFRFA+ZhmgSND0RidwVN0SSReBMhFF/rIc3L4GTuBorIYLAMenTRo
         jyj7xQy330PNH2SMwAKGYd3oHVYR7NGc3rJ/Zu7P4j4xa9fezPMaNl13IYmumBx+5IEw
         MKnOMZGUqbBTfu2b+vmVJwCZP3AtSG0Pav9b5e4dbULFQC1TGayq4t3dtE94pU3zLL8Y
         9gMDjAunGR9I+1IqM9IxPPFo0xOGs8ds5vxE+MPhhEUr+8fNv4OGq+zA27NP47NImVMf
         NIkQ==
X-Gm-Message-State: AOAM531l5elyeaRzpLCH3zSTYecPU64HSGdYfwT1J+yoU6mp/pIdO83N
        xtk+m52IMN+xDZ+D/Bibvp7/0A==
X-Google-Smtp-Source: ABdhPJylXuFlM8x3f2SmjFsvmS4IXm1sk6q3SZy01VGfW4vAYKvaMpyJiNUElZUHl7iDnlFKamnlPg==
X-Received: by 2002:a17:90a:af92:: with SMTP id w18mr19427909pjq.98.1633805140215;
        Sat, 09 Oct 2021 11:45:40 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s30sm3368433pgo.39.2021.10.09.11.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:45:39 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 9/9] ionic: tame the filter no space message
Date:   Sat,  9 Oct 2021 11:45:23 -0700
Message-Id: <20211009184523.73154-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009184523.73154-1-snelson@pensando.io>
References: <20211009184523.73154-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Override the automatic AdminQ error message in order to
capture the potential No Space message when we hit the
max vlan limit, and add additional messaging to detail
what filter failed.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_rx_filter.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 366f15794866..f6e785f949f9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -357,7 +357,7 @@ static int ionic_lif_filter_add(struct ionic_lif *lif,
 	}
 
 	if (err != -ENOSPC)
-		err = ionic_adminq_post_wait(lif, &ctx);
+		err = ionic_adminq_post_wait_nomsg(lif, &ctx);
 
 	spin_lock_bh(&lif->rx_filters.lock);
 
@@ -382,6 +382,19 @@ static int ionic_lif_filter_add(struct ionic_lif *lif,
 			return 0;
 		}
 
+		ionic_adminq_netdev_err_print(lif, ctx.cmd.cmd.opcode,
+					      ctx.comp.comp.status, err);
+		switch (le16_to_cpu(ctx.cmd.rx_filter_add.match)) {
+		case IONIC_RX_FILTER_MATCH_VLAN:
+			netdev_info(lif->netdev, "rx_filter add failed: VLAN %d\n",
+				    ctx.cmd.rx_filter_add.vlan.vlan);
+			break;
+		case IONIC_RX_FILTER_MATCH_MAC:
+			netdev_info(lif->netdev, "rx_filter add failed: ADDR %pM\n",
+				    ctx.cmd.rx_filter_add.mac.addr);
+			break;
+		}
+
 		return err;
 	}
 
-- 
2.17.1

