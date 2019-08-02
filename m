Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 455D57EF83
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404378AbfHBIl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:41:27 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33883 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729530AbfHBIl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:41:26 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so33401776plt.1;
        Fri, 02 Aug 2019 01:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fzCpgzD4dyLvmdopNA+j9jMP2LfwLF+bdTI1nF6yVOw=;
        b=V14q/d8I3TPGZMoTaaEXCEKKmI627nOnmGyvAn2RnzNQb94QR4+F6LL6UlHd1T7AfK
         hYP9RJ14NyVHBoo2Qjd7kdm3POSQApuGwCHTEA7vrqj1yufI4wkIYsW7GABg0S6LkmC5
         2HtnD8wfrvcSpbetdxerHjlFpjcEdY/dVb7MwnBV3PXSBoadrNvMZp8ywmYKwZ7jPPqC
         3/k7iwmfyoTnTlWwRtLpc9zg6Sm2vGwwUUb65EqwnY83GUy8udYRrdyD1PJiuYkmBS0S
         VwvkGywNNddFvAvhW7V1c72b+D+u70tkqwG0+eO1WWzZFHmhptQuLixxze4IVk0jev2q
         18MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fzCpgzD4dyLvmdopNA+j9jMP2LfwLF+bdTI1nF6yVOw=;
        b=o2bxu4kURRyvWfvL+C+8ylUXYfzG47gDn+TWoQpaGYn4epgbG/C1d7LkZuvshD4lFa
         k4SApb3U6Ih0XkL01zL9DPQUYUirX+zspxE++8uu6uttSMrE9A2R1deCGOXs5sb+Ue3L
         KoxsMukujypEZw4lu6jr68PDtglj8maZb7/S1LLhU6dzzxJ8RFaEJUvbuObOzDBE571J
         VZ0KtUlOuFt8yLOI/Jg/6LFg4IXJFN8oM2dUjp38k66mVLH0JE5Ba2cV2wniQfe7aXMM
         TxUCXZODt+QH/A3bdAu34L6HRwodEwoziaHlE/VsKbLhQzhWoSLLQt8vu3X1kaBz9Bfi
         BDTQ==
X-Gm-Message-State: APjAAAWVzeA5ozKMQR2IIfzEPJQlfszyAC4PEStC6Lknthfedx0D+Vqo
        490nnl3ORqQFiH2mPDilWG8=
X-Google-Smtp-Source: APXvYqxiac8S9hm7uBe6UD//6v0/LJFZ6uLrD07uXH5Fi8olwTPsgcIyf0MQGU/zD9f2vzVV1P/MQg==
X-Received: by 2002:a17:902:e20c:: with SMTP id ce12mr3848617plb.130.1564735286238;
        Fri, 02 Aug 2019 01:41:26 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id o12sm5894498pjr.22.2019.08.02.01.41.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 01:41:25 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2 2/2] cxgb4: smt: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 16:41:21 +0800
Message-Id: <20190802084121.13059-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Convert refcount from 0-base to 1-base.

 drivers/net/ethernet/chelsio/cxgb4/smt.c | 14 +++++++-------
 drivers/net/ethernet/chelsio/cxgb4/smt.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.c b/drivers/net/ethernet/chelsio/cxgb4/smt.c
index eaf1fb74689c..343887fa52aa 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.c
@@ -57,7 +57,7 @@ struct smt_data *t4_init_smt(void)
 		s->smtab[i].state = SMT_STATE_UNUSED;
 		memset(&s->smtab[i].src_mac, 0, ETH_ALEN);
 		spin_lock_init(&s->smtab[i].lock);
-		atomic_set(&s->smtab[i].refcnt, 0);
+		refcount_set(&s->smtab[i].refcnt, 1);
 	}
 	return s;
 }
@@ -68,7 +68,7 @@ static struct smt_entry *find_or_alloc_smte(struct smt_data *s, u8 *smac)
 	struct smt_entry *e, *end;
 
 	for (e = &s->smtab[0], end = &s->smtab[s->smt_size]; e != end; ++e) {
-		if (atomic_read(&e->refcnt) == 0) {
+		if (refcount_read(&e->refcnt) == 1) {
 			if (!first_free)
 				first_free = e;
 		} else {
@@ -98,7 +98,7 @@ static struct smt_entry *find_or_alloc_smte(struct smt_data *s, u8 *smac)
 static void t4_smte_free(struct smt_entry *e)
 {
 	spin_lock_bh(&e->lock);
-	if (atomic_read(&e->refcnt) == 0) {  /* hasn't been recycled */
+	if (refcount_read(&e->refcnt) == 1) {  /* hasn't been recycled */
 		e->state = SMT_STATE_UNUSED;
 	}
 	spin_unlock_bh(&e->lock);
@@ -111,7 +111,7 @@ static void t4_smte_free(struct smt_entry *e)
  */
 void cxgb4_smt_release(struct smt_entry *e)
 {
-	if (atomic_dec_and_test(&e->refcnt))
+	if (refcount_dec_and_test(&e->refcnt))
 		t4_smte_free(e);
 }
 EXPORT_SYMBOL(cxgb4_smt_release);
@@ -215,14 +215,14 @@ static struct smt_entry *t4_smt_alloc_switching(struct adapter *adap, u16 pfvf,
 	e = find_or_alloc_smte(s, smac);
 	if (e) {
 		spin_lock(&e->lock);
-		if (!atomic_read(&e->refcnt)) {
-			atomic_set(&e->refcnt, 1);
+		if (refcount_read(&e->refcnt) == 1) {
+			refcount_set(&e->refcnt, 2);
 			e->state = SMT_STATE_SWITCHING;
 			e->pfvf = pfvf;
 			memcpy(e->src_mac, smac, ETH_ALEN);
 			write_smt_entry(adap, e);
 		} else {
-			atomic_inc(&e->refcnt);
+			refcount_inc(&e->refcnt);
 		}
 		spin_unlock(&e->lock);
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.h b/drivers/net/ethernet/chelsio/cxgb4/smt.h
index d6c2cc271398..4774606a0101 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.h
@@ -59,7 +59,7 @@ struct smt_entry {
 	u16 idx;
 	u16 pfvf;
 	u8 src_mac[ETH_ALEN];
-	atomic_t refcnt;
+	refcount_t refcnt;
 	spinlock_t lock;	/* protect smt entry add,removal */
 };
 
-- 
2.20.1

