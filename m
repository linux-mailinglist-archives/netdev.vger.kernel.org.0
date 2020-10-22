Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD4F2967C3
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 01:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373648AbgJVXz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 19:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373643AbgJVXzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 19:55:55 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD52DC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 16:55:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id e15so2328175pfh.6
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 16:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PU0QvKFwpPHkSe6vqPWqTywAUkijdCLP+2dreqDqs7I=;
        b=VzAkIRWFJhiuXsi66Lz9462BIIhLi4g8xEt7Z4jAy9nKmfKLOAYmw7DkhXemqP6To6
         Yib02SoJhJf3Ng6nwT+3HCQE+VYsc9Scb8OMpzVGnu9nX0Ajennc936OBtfczoBIgbG2
         dA66G1XjH5E0Av0wIo4tEfWMtleA1GCqFEWVWzLJE2ca2lEzM8y47yxit1RSK6SECuPr
         DmEWnDHmOvN7cNHVIkW14itDoHbFCUvyWTQUubLaPhfCbwUpuJlctfi5rRzKj1n1Cz9B
         mBJ4fq9DY/s5SLmo9XqvacCiwX7sRheVYNqQX0c+NDogMHHsZN+8qbpBRj+HmWgBg0jZ
         wqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PU0QvKFwpPHkSe6vqPWqTywAUkijdCLP+2dreqDqs7I=;
        b=gGjFqGyFypoHRDl8lddE5Wv+Z0H3W/jjX6cJoP3Y6OfnNgGRHa3gWb8biKeeuf4j5t
         BTzEYDnDlQac0Ph0zuBXoLHOjzzrzk80PpTEI46oV0dtYtjoXp3tTfd7jNcEyrhCbxcE
         3NA4lkkSJidwV/pedtouUNnKI7oo1Wb1fJqDXsiklYzkhr0oF7C4Eq6HEEKkGVF4k3fl
         CipzgfH8WhLkorQ3FpQODY2pnv+MZM6EQO2NE/B/NO4nb4HrZPvHuJsx7RdO1EwXZ3KO
         EBVvKn1HAEaqSU5i2KpSIUkRWH4hd89DKzKyvh4YKPPKXS54ofhHeuOxdK17V3vtpiSg
         1/+A==
X-Gm-Message-State: AOAM531T5l2kzTA/Vu5RQTTWPwyJhb+Ybc1gag9oswWJvW1qQbXLSh/U
        B10xJgrHftyD1Ct4X8swv9EzJSRC2ax0QA==
X-Google-Smtp-Source: ABdhPJzo7bFesnpTh8p3ikvbFlytkOJg+i4bi3YkgntXC4xzkb9ilTNeG/KIAkw3Dc7iQI4l7UFKrA==
X-Received: by 2002:a63:4e5e:: with SMTP id o30mr4455708pgl.251.1603410954900;
        Thu, 22 Oct 2020 16:55:54 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id v3sm3167244pfu.165.2020.10.22.16.55.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2020 16:55:54 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 3/3] ionic: fix mem leak in rx_empty
Date:   Thu, 22 Oct 2020 16:55:31 -0700
Message-Id: <20201022235531.65956-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201022235531.65956-1-snelson@pensando.io>
References: <20201022235531.65956-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sentinel descriptor entry was getting missed in the
traverse of the ring from head to tail, so change to a
loop of 0 to the end.

Fixes: f1d2e894f1b7 ("ionic: use index not pointer for queue tracking")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 24 +++++++++----------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 35acb4d66e31..b3d2250c77d0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -400,22 +400,20 @@ static void ionic_rx_fill_cb(void *arg)
 void ionic_rx_empty(struct ionic_queue *q)
 {
 	struct ionic_desc_info *desc_info;
-	struct ionic_rxq_desc *desc;
-	unsigned int i;
-	u16 idx;
-
-	idx = q->tail_idx;
-	while (idx != q->head_idx) {
-		desc_info = &q->info[idx];
-		desc = desc_info->desc;
-		desc->addr = 0;
-		desc->len = 0;
+	struct ionic_page_info *page_info;
+	unsigned int i, j;
 
-		for (i = 0; i < desc_info->npages; i++)
-			ionic_rx_page_free(q, &desc_info->pages[i]);
+	for (i = 0; i < q->num_descs; i++) {
+		desc_info = &q->info[i];
+		for (j = 0; j < IONIC_RX_MAX_SG_ELEMS + 1; j++) {
+			page_info = &desc_info->pages[j];
+			if (page_info->page)
+				ionic_rx_page_free(q, page_info);
+		}
 
+		desc_info->npages = 0;
+		desc_info->cb = NULL;
 		desc_info->cb_arg = NULL;
-		idx = (idx + 1) & (q->num_descs - 1);
 	}
 }
 
-- 
2.17.1

