Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7ADE42342F
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 01:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbhJEXNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 19:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbhJEXNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 19:13:04 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282D7C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 16:11:13 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id a73so817296pge.0
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 16:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=bt3xIfE4BZHPPo38q5CPuaaMeeXh4XDQ8Z9nvqb7yO4=;
        b=Q+grvMMbdIU6ZGkKf8ssZ/D1VECPybABFxf/ISjBpk09y931PbPI/ZXT0/JbFaNPuU
         IZfZd4yglO0bWzmx+P7ATbnSULEs4BDUVdMCr/+IyvqYbK2TzoiO9bo149e/WDh3r32i
         2emkqtblDuSDQIW/3EDin8ItaT+DyQ5qBASN6lt+3mpq5otzSoN7/46Kr/ZZmoJ6puwK
         fVY/EbQ9OBjvhhgWM6nH6PmGyjCt3F+640CIGhiMUMTOpdDtU+58zn92dl/TSCOdZg/8
         51+4dPmWVrtkAb8E/Qzc7c0l/6XSZsAAPh7ppC04j6dmvztreLq7Rsy6QVuqj59huggL
         behA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bt3xIfE4BZHPPo38q5CPuaaMeeXh4XDQ8Z9nvqb7yO4=;
        b=aK/cuuEqI6BQ0k5/SIzw2VDkc50AtOZD1jnA5GGlYPZbKikKDrmncjzqWtWBtUqWWl
         q38A2jSWeG1t+Ph4XiGgstCWGxbGEi9tE/DxmqKTRYBACBKWyoNfIQbpDEmqvR56lBKL
         FZLn7+JzHmWvpLDmY+rSHaGWmZfnXrKPWY8lEXkx5WpWMt9C/9KEmecoPlP0vOWuBeNI
         hmaLQSzTY6pfw0/0pzOhijiZR3I2tUMOZrtFdOlexM8x+GuCaKIDCcxqYTX7FuvdndnH
         7o6oW29HlCcEPfXFEAaZWvHfv9n29YKNkHkhPpQcLgj7nMcUEyqsvsK/gXZgDB6Jwpgs
         PENw==
X-Gm-Message-State: AOAM533v8qopRuDZgcKVtJNgpn6p31i5yF/V8AxCvaORSkavlKt5ivqJ
        uCpo2ZyLnKH/HK8KRUcrnSrggA==
X-Google-Smtp-Source: ABdhPJxO1aqSEZiZTMp6HxZgkTerz8eXFKwhhFzmM1zFUVhSJbbnn/7vy3lu3sK9+s8kbZeNq8m3yA==
X-Received: by 2002:a63:5947:: with SMTP id j7mr17937582pgm.193.1633475472713;
        Tue, 05 Oct 2021 16:11:12 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t13sm3040974pjg.25.2021.10.05.16.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 16:11:12 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: move filter sync_needed bit set
Date:   Tue,  5 Oct 2021 16:11:05 -0700
Message-Id: <20211005231105.29660-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the setting of the filter-sync-needed bit to the error
case in the filter add routine to be sure we're checking the
live filter status rather than a copy of the pre-sync status.

Fixes: 969f84394604 ("ionic: sync the filters in the work task")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c       | 4 +++-
 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c | 3 ---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 381966e8f557..ccf3ffcd3939 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1292,8 +1292,10 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	if (err && err != -EEXIST) {
 		/* set the state back to NEW so we can try again later */
 		f = ionic_rx_filter_by_addr(lif, addr);
-		if (f && f->state == IONIC_FILTER_STATE_SYNCED)
+		if (f && f->state == IONIC_FILTER_STATE_SYNCED) {
 			f->state = IONIC_FILTER_STATE_NEW;
+			set_bit(IONIC_LIF_F_FILTER_SYNC_NEEDED, lif->state);
+		}
 
 		spin_unlock_bh(&lif->rx_filters.lock);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 25ecfcfa1281..69728f9013cb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -349,9 +349,6 @@ void ionic_rx_filter_sync(struct ionic_lif *lif)
 	list_for_each_entry_safe(sync_item, spos, &sync_add_list, list) {
 		(void)ionic_lif_addr_add(lif, sync_item->f.cmd.mac.addr);
 
-		if (sync_item->f.state != IONIC_FILTER_STATE_SYNCED)
-			set_bit(IONIC_LIF_F_FILTER_SYNC_NEEDED, lif->state);
-
 		list_del(&sync_item->list);
 		devm_kfree(dev, sync_item);
 	}
-- 
2.17.1

