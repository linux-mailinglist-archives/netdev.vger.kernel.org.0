Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6B72287BB
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbgGURqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgGURqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:46:32 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8418BC0619DB
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j19so12257228pgm.11
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E3X5T7MV/sNafEfdlB7eZ+UajG8Py7wFAjMLpUqo8ao=;
        b=ExO/cjnUSlaz1VCqWhiBV08Oo8JBevub7lljYnZTisB+iti0R71GeBjaqtpdeXEO5u
         02mEnHkCokAIC3Zn/F5AJVrv87z9fB1MTs8nRzFElLfmeMUE5To9JLZOf3SCR60u+MgQ
         1i/EjNIuhNKgVfP+F4lMhxbnfmnBr6kray/gY7EdUnJhExQPV6MkENndu7015qDKATvn
         4cLdoLTW1fkcRfcuDDzwAxb0FstcfQnzQJmW9JSywQgBus178vFBKdPRlOb5b8IbtGpJ
         1VVe//a9B6h/CgGXdY/pNJgZEVDJVy2vSCs3DNGhR82SyX4kjdLd6YfZB8R57tud5HOh
         /zwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E3X5T7MV/sNafEfdlB7eZ+UajG8Py7wFAjMLpUqo8ao=;
        b=ghY4Ya9m0CoWHwenA4zCBr3vBUeFL6CfX7So5Wj0/efpdBNsH0yvz3hXLsJFSjXAo4
         P2k/Hym/gzQzcL10x1W71mRlD6Hq9U+DjvLlbLb0bqAUa6IE5uinfFMDiUrjDrhK9dmq
         4MN/WZtM3rlIyIXX++GpcNChX5RLHkCxROlbtR7cW+433cqryG/gldiu3DlIjPS2o1jD
         5ZWoKcEjwUFrpjLVJnmdeTBBjpl5Mzhv2W4tSwRsa+vGU9SfaizYCIbpzF0do6PrAp9A
         0deRUbws8u/ngnIlby8UH+qNU2da5vwRRkjL1iZgZdwhhzVQsr0D5Q9Cp2PUsNrJskpZ
         /hbA==
X-Gm-Message-State: AOAM532kAy8xSV/FKyKuUkTr6pfWkikgpD5otviAW+uhv6ZIVSPhwqSt
        g8QNqOsJwm/iMyiZlcdk0iGUv9xVvqw=
X-Google-Smtp-Source: ABdhPJyv11UwnW1DKas7/AE+5Q/PIPkh5r4DbouuWxMvUL0o5T4zRFzjuiXwo8zW3svR8k17gpNt7Q==
X-Received: by 2002:aa7:8391:: with SMTP id u17mr26671338pfm.156.1595353591745;
        Tue, 21 Jul 2020 10:46:31 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c14sm4598712pgb.1.2020.07.21.10.46.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:46:30 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net 4/6] ionic: update filter id after replay
Date:   Tue, 21 Jul 2020 10:46:17 -0700
Message-Id: <20200721174619.39860-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721174619.39860-1-snelson@pensando.io>
References: <20200721174619.39860-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we replay the rx filters after a fw-upgrade we get new
filter_id values from the FW, which we need to save and update
in our local filter list.  This allows us to delete the filters
with the correct filter_id when we're done.

Fixes: 7e4d47596b68 ("ionic: replay filters after fw upgrade")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index fb9d828812bd..cd0076fc3044 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -21,13 +21,16 @@ void ionic_rx_filter_free(struct ionic_lif *lif, struct ionic_rx_filter *f)
 void ionic_rx_filter_replay(struct ionic_lif *lif)
 {
 	struct ionic_rx_filter_add_cmd *ac;
+	struct hlist_head new_id_list;
 	struct ionic_admin_ctx ctx;
 	struct ionic_rx_filter *f;
 	struct hlist_head *head;
 	struct hlist_node *tmp;
+	unsigned int key;
 	unsigned int i;
 	int err;
 
+	INIT_HLIST_HEAD(&new_id_list);
 	ac = &ctx.cmd.rx_filter_add;
 
 	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
@@ -58,9 +61,30 @@ void ionic_rx_filter_replay(struct ionic_lif *lif)
 						    ac->mac.addr);
 					break;
 				}
+				spin_lock_bh(&lif->rx_filters.lock);
+				ionic_rx_filter_free(lif, f);
+				spin_unlock_bh(&lif->rx_filters.lock);
+
+				continue;
 			}
+
+			/* remove from old id list, save new id in tmp list */
+			spin_lock_bh(&lif->rx_filters.lock);
+			hlist_del(&f->by_id);
+			spin_unlock_bh(&lif->rx_filters.lock);
+			f->filter_id = le32_to_cpu(ctx.comp.rx_filter_add.filter_id);
+			hlist_add_head(&f->by_id, &new_id_list);
 		}
 	}
+
+	/* rebuild the by_id hash lists with the new filter ids */
+	spin_lock_bh(&lif->rx_filters.lock);
+	hlist_for_each_entry_safe(f, tmp, &new_id_list, by_id) {
+		key = f->filter_id & IONIC_RX_FILTER_HLISTS_MASK;
+		head = &lif->rx_filters.by_id[key];
+		hlist_add_head(&f->by_id, head);
+	}
+	spin_unlock_bh(&lif->rx_filters.lock);
 }
 
 int ionic_rx_filters_init(struct ionic_lif *lif)
-- 
2.17.1

