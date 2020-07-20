Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10F0227296
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 01:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgGTXAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 19:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgGTXAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 19:00:33 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B97C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 16:00:33 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n5so11028720pgf.7
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 16:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E3X5T7MV/sNafEfdlB7eZ+UajG8Py7wFAjMLpUqo8ao=;
        b=dm2SocycdI5q91q2gQCwuplbKs1iLqbiU1MCOZ7yTxQdkcSCVJSKY9WSs3SroM5ocN
         s2aJaXSyZ9GNQjYTfox7wSGEEO6KoyZg50rjlRf9SByE4r2+iKqSx0qRJtIinAubzTUB
         U/gnzJSHQWRdCIeYB+WQQ98xB0I5Rbv0kl/O5aCVrPS2nRaU/pCTHZk5va0NWQhp1CqJ
         bI1iVOU0lSCsYGUW4Wr3wzw1qxCk/ENlUdQlRhQmZlaUdY/8LBL8Q5bhfLSW8Q3doN8c
         BteoNj/x4xd1PF026/SFfBd37dcRtVjTZLfu+1uEpVlFxM0OummNx11ns5FmGUx5Cu7n
         fsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E3X5T7MV/sNafEfdlB7eZ+UajG8Py7wFAjMLpUqo8ao=;
        b=sOK0o56DxZzoimzDlDX0LYhyydl1m/nrQfdmHNgu1CLLBrLhhMa87/Yqzuh7ky9bdi
         fYkQ7vhxrx6eFz6CyJ3S9zobxVo65O9c2spkChbgSng3PnAYV9KfMP0JbkCIJQSaG30i
         VoHQnMLfeejnjqV4pndH8fBwh50mfh4BBkmZ5q3HsC6TlXnDAocoP7NVlmG2dbWpuj8G
         DU+z0tFTRU3Qzg+A3InUho+xC1oISbFUgW9+GchFPhWgSjdievDmxymR042mG2q/JsYL
         eyU8mKLvpNt9OvD7x7g9xKx8ZE/2Qj5CNO9+2QPGNMpKPEPpQFmUgOwLzE2HAivPVHv4
         /w4A==
X-Gm-Message-State: AOAM531BRFUAs78FzfAXyJJxFOabUMGBd+UorFg3uMxFBH5KDWACEZ6S
        8kZTPnFLa9I2YH3ReIdNlBDHABXlGZ0=
X-Google-Smtp-Source: ABdhPJypgnSfn3vK6j3YF26B/SAFDkiQFYUHyB64hrecXnjs6S7adqlbxKCewer1FfFi5BnzgNLlyA==
X-Received: by 2002:a62:2ad6:: with SMTP id q205mr21429984pfq.316.1595286031881;
        Mon, 20 Jul 2020 16:00:31 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n9sm606738pjo.53.2020.07.20.16.00.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 16:00:30 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 3/5] ionic: update filter id after replay
Date:   Mon, 20 Jul 2020 16:00:15 -0700
Message-Id: <20200720230017.20419-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200720230017.20419-1-snelson@pensando.io>
References: <20200720230017.20419-1-snelson@pensando.io>
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

